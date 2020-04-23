function [rawBasePointsOut,meanBasePointsOut,basepointNamesOut,whiskersAligned,AlignmentParams]=alignScans(basepoints,basepointNames,whiskers,whiskerNames)
% The purpose of this function is to align all of the different 3d laser
% scans/microscribe traces that were taken of the animal.  It works by
% minimizing the distance between matching basepoints in each scan.
%
%   Inputs:
%           basePoints{U,1}(V,3):
%               basePoints is a cell filled with the 3D basepoint locations
%               for each whisker.  U is the number of basepoints that you
%               have.  V is the number of points in the pointcloud defining
%               the basepoint.
%
%           whiskerPoints{W,1}(X,3):
%               whiskerPoints is a cell filled with the 3D whisker shape
%               for each whisker.  W is the number of whiskers that you
%               have.  X is the number of points in the pointcloud defining
%               the whisker.
%
%           basePointNames(U,8):
%               basePointNames is a matrix filled with the names of the
%               basepoints.  The length and order of this matrix should
%               match the basePoints cell.  The proper naming scheme for
%               this matrix is: side, row letter, 2 digit column number,
%               2 digit scan number, 'BP'.  For example, the second scan of
%               basepoint C3 from the left array should be named 'LC0302BP'.
%               Columns are counted from caudal to rostral starting at 1.
%               For the rat this means that greek column is 1.
%
%           whiskerNames(W,6):
%               whiskerNames is a matrix filled with the names of the
%               3D whiskers.  The length and order of this matrix should
%               match the whiskerPoints cell.  The proper naming scheme for
%               this matrix is: side, row letter, 2 digit column number,
%               2 digit scan number.  For example, the first scan of
%               whisker D5 from the left array should be named 'LD0501'.
%               Columns are counted from caudal to rostral starting at 1.
%               For the rat this means that greek column is 1.
%
%
%   Outputs:
%           rawBasePointsOut:
%               The aligned basepoints, pointclouds averaged to a single point.
%           meanBasePointsOut:
%               The aligned basepoint point averaged over all scans.
%           basepointNamesOut:
%               basepointNames reorganized by scan.
%           whiskersAligned:
%               Aligned full whisker scans
%           AlignmentParams:
%               The alignment parameters used to align the scans.
%% Preprocessing the input data

%Initialize variables
Plotting=0;
scanNums=str2num(basepointNames(:,5:6));
basepointsByScan=cell(max(scanNums),1);
scanIndx=cell(max(scanNums),1);
basepointNamesByScan=cell(max(scanNums),1);
basepointsMean=zeros(size(basepoints,1),3);

%Turn the basepoint point clouds into a single mean point
for i=1:size(basepoints,1)
    basepointsMean(i,:)=mean(basepoints{i,1},1);
end

%Organize the unaligned basepoints into a cell and plot them to take a
%look.  Also setup a cell that make index by scan number easier. The
%reference scan is the scan that all of the other point clouds will be
%aligned with.  We will use the scan that has the greatest number of
%basepoints.
rawBasePointsOut=zeros(size(basepointsMean));
refScanSize=0;
if Plotting
    clr='rgbcmgky';
    figure;
end
for i=1:max(scanNums)
    basepointsByScan{i,1}=basepointsMean(scanNums==i,:);
    basepointNamesByScan{i,1}=basepointNames(scanNums==i,:);
    scanIndx{i,1}=scanNums==i;
    dum=size(basepointsByScan{i,1},1);
    if dum>refScanSize
        refScanNum=i;
        refScanSize=dum;
    end
    if Plotting
        plot3d(basepointsByScan{i,1},[clr(i) '.']);
        hold on;
    end
end

if Plotting
    title('Basepoint Scans Unaligned');
    grid on;
    axis equal;
end
%% Align the scans

% We want to align every scan eAlignmentParamscept for the reference scan.
dum=1:max(scanNums);
indx=dum(dum~=refScanNum);

global basepointsMove basepointsRef
whiskersAligned=whiskers;
AlignmentParams=zeros(max(scanNums),6);

%Itereate through every scan eAlignmentParamscept for the reference scan
for i=indx
    
    %Find the matching basepoints between the current scan and the
    %reference scan.
    matchIndAlignmentParams=matchBasePoints(basepointNamesByScan{i,1},basepointNamesByScan{refScanNum,1});
    basepointsMove=basepointsByScan{i,1}(matchIndAlignmentParams(:,1),:);
    basepointsRef=basepointsByScan{refScanNum,1}(matchIndAlignmentParams(:,2),:);
    
    %Run an optimization to actually align the two scans (see optimization
    %function @LOCAL_alignScans below).
    AlignmentParams(i,:)=fminsearch(@LOCAL_alignScans, [0,0,0,0,0,0],optimset('Algorithm','active-set','MaxIter',20000,'MaxFunEvals',20000,'TolX',1e-20,'TolFun',1e-20,'display','off'));%,'PlotFcns', @optimplotfval
    
    %Apply what the optimization has found to the basepoints
    
    %Translate
    basepoints2=basepointsByScan{i,1}+repmat(AlignmentParams(i,1:3),size(basepointsByScan{i,1},1),1);
    %Rotate
    basepointsAligned{i,1}=EulerRotateWhisker(AlignmentParams(i,4),AlignmentParams(i,5),AlignmentParams(i,6),basepoints2);
    
    %Prepare for output
    rawBasePointsOut(scanIndx{i,1},:)=basepointsAligned{i,1};
    
    %Now apply the alignment to the whisker scans
    for j=1:size(whiskers,1)
        if str2double(whiskerNames(j,6))==i
            %Translate
            whiskersAligned{j,1}= whiskers{j,1}+repmat(AlignmentParams(i,1:3),size(whiskers{j,1},1),1);
            %Rotate
            whiskersAligned{j,1}=EulerRotateWhisker(AlignmentParams(i,4),AlignmentParams(i,5),AlignmentParams(i,6),whiskersAligned{j,1});
        end
    end
end

%Add the reference scan to the output variables
basepointsAligned{refScanNum,1}=basepointsByScan{refScanNum,1};
rawBasePointsOut(scanIndx{refScanNum,1},:)=basepointsAligned{refScanNum,1};

%% Plotting results and cleanup
if Plotting
%     plot the alignment to take a look at how it did.
    figure;
    clr=['rbkcmg'];
    
    for i=1:max(scanNums)
        plot3d(basepointsAligned{i,1},['.' clr(i)]);
        hold on;
    end
  
    title('Basepoint Scans Aligned To Each Other')
    grid on;
    axis equal;
end

%Calculate the mean basepoints, eAlignmentParamscluding the top and bottom 2.5% of the
%values.  This helps to compensate for outliers.
side='LR';
rows='ABCDEFGHIJKLMNOPQRSTUVQXYZ';
cols=num2str((1:99)','%02d');
count2=1;
for m=1:2
    for i=1:size(rows,2)
        for j=1:size(cols,1)
            count=0;
            dum=[];
            for k=1:max(scanNums)
                for n=1:size(basepointNamesByScan{k,1},1)
                    if strcmp(basepointNamesByScan{k,1}(n,1:4),[side(m),rows(i),cols(j,:)])
                        dum=[dum; basepointsAligned{k,1}(n,:)];
                        count=count+1;
                    end
                end
            end
            if count>0;
%                 meanBasePointsOut(count2,1)=trimmean(dum(:,1),5);
%                 meanBasePointsOut(count2,2)=trimmean(dum(:,2),5);
%                 meanBasePointsOut(count2,3)=trimmean(dum(:,3),5);
                center=mean(dum,1);
                dist=distancePoints3d(dum,repmat(center,size(dum,1),1));
                [~,includedIndx]=excludeOutliers(dist,2,'fromMean');
                meanBasePointsOut(count2,:)=mean(dum(includedIndx,:),1);
                basepointNamesOut(count2,:)=[side(m),rows(i),cols(j,:) 'BP'];
                count2=count2+1;
            end
        end
    end
end

% rawBasePointsOut=basepointsAligned;
end

function e=LOCAL_alignScans(AlignmentParams)
%Translate the wisker, then rotate the whisker, then calculate the total
%distance between the reference basepoint and the moving basepoint.

global basepointsMove basepointsRef

basepointsMoveTrans=basepointsMove+repmat(AlignmentParams(1:3),size(basepointsMove,1),1);
basepointsMoveTransRot=EulerRotateWhisker(AlignmentParams(4),AlignmentParams(5),AlignmentParams(6),basepointsMoveTrans);


e=sum(sqrt(sum((basepointsMoveTransRot-basepointsRef).^2,2)));

end