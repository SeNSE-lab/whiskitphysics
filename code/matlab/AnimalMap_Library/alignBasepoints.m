function [basePointMatAligned,alignmentParameters]=alignBasepoints(basePointMat,basePointNames, PLOTTING)
%The purpose of this function is to put the basepoints into a standard
%position and orientation.
%   Inputs:
%       basePointMat:
%           Nx3 Matrix containing the basepoints that you wish to put into
%           standard position and orientation
%
%       basePointNames:
%           Nx6 Matrix of basepoint names.  The proper format for the names
%           is [Side, Row Letter, 2 Digit Column Number BP]. For example if
%           you want to describe whisker B3 from the left array, its name
%           would be LA03BP.
%
%       PLOTTING:
%           Toggles plotting.
%
%   Outputs:
%       basePointMatAligned:
%           An Nx3 matrix of basepoints that is in standard position and
%           orientation.
%
%       alignmentParameters:
%           The rotation and translations that put the basepoints into
%           standard position and orientation outputted as struct.
%           Fields:
%               offset: the x,y,z translation values
%
%               globalTheta: Theta Euler rotation to get the animal generally
%               pointing the right direction.
%
%               globalPhi:Phi Euler rotation to get the animal generally
%               pointing the right direction.
%
%               globalPsi:Psi Euler rotation to get the animal generally
%               pointing the right direction.
%
%               theta: Theta Euler rotation to get the animal properly aligned
%
%               phi: Phi Euler rotation to get the animal properly aligned
%
%               psi: Psi Euler rotation to get the animal properly aligned

DBG_PLOTTING=0;

% Split the base points into left and right arrays
[~,~,rightList,leftList]=splitBasePointsLR(basePointMat, basePointNames);

% Find the matching base points between the arrays
matchList=matchBasePointsLR(leftList,rightList);

% Convert the list to 1D so that it can be used with the unsplit matricies
matchList1D=[matchList(:,1);matchList(:,2)+length(leftList)];

% Index the rows and columns for later use
[rowList, colList,rowIdx,colIdx]=getRowColInfo(basePointNames);

% Find the mean position of the matching basepoints and center everything
% around that point.
offset = mean(basePointMat(matchList1D,:));

for j = 1:3
    basePointMat(:,j)=basePointMat(:,j)-offset(j);
end

matchRowList=rowList(matchList1D);

%Find the mean positions of the top and bottom rows
topRow=mean(basePointMat(rowIdx{1,min(matchRowList)},:));
bottomRow=mean(basePointMat(rowIdx{1,size(rowIdx,2)},:));

%If your top row is higher than your bottom row then flip everything
%upside-down
if topRow(3)<bottomRow(3)
    globalPsi=180;
    basePointMat = EulerRotateWhisker(0,0,globalPsi,basePointMat);
else
    globalPsi=0;
end

%Debug plotting if you need it
if DBG_PLOTTING==1
    figure; plot3d(basePointMat,'.k');
    grid on; axis equal;
end

%Split the left and right arrays into their own matricies
rightArray=mean(basePointMat(matchList(:,1),:));
leftArray=mean(basePointMat(matchList(:,2)+length(leftList),:));

%If the left array is further along x than the right array, rotate it by
%180 degrees
if leftArray(1)>rightArray(1)
    globalTheta=180;
    basePointMat = EulerRotateWhisker(globalTheta,0,0,basePointMat);
else
    globalTheta=0;
end

globalPhi = 0;

%Debug plotting if you need it.
if DBG_PLOTTING==1
    figure; plot3d(basePointMat,'.k');
    grid on; axis equal;
end
%

%---------------------------------------
%Whisker row planes
%---------------------------------------
%% Rotate about theta to get the head to point along the positive Y-axis

% what venkatesh did previously was to only consider a rotation from 1 to
% 30 degrees (NOT +/- 180)

%find the mean x and y coordinates
x = mean(basePointMat(matchList(:,1),1));
y = mean(basePointMat(matchList(:,1),2));

%find the angle between the mean coordinate and the y axis
theta = atan2(y,x)*(180/pi);
theta=theta+180;

%rotate the array around the z axis to align it to the y axis
basePointMatTheta = EulerRotateWhisker(theta,0,0,basePointMat);

%Debug plotting if you need it
if DBG_PLOTTING==1
    figure;
    plot3d(basePointMatTheta,'.k');
    grid on; axis equal;
end
%% Rotate about phi to get the right and left arrays along the x-axis
x = mean(basePointMatTheta(matchList(:,1),1));
% y = mean(basePointMatTheta(matchList(:,1),2));
z = mean(basePointMatTheta(matchList(:,1),3));

%find the angle between the mean coordinate and the x axis
phi = atan2(z,x)*(180/pi);
phi=-(phi+180);

%rotate around the y axis to align it to the x axis
basePointMatThetaPhi = EulerRotateWhisker(0,phi,0,basePointMatTheta);

%Debug plotting if you need it
if DBG_PLOTTING==1
    figure;
    plot3d(basePointMatThetaPhi,'.k');
    grid on; axis equal;
end

%% find the whisker planes for x-y alignment.

%Only one row in FRH, number of whisker rows embedded in code all over
%change to a input variable that user can manually change when
%prompted?
% x = basePointMatThetaPhi(matchList1D ,1);
% y = basePointMatThetaPhi(matchList1D ,2);
% z = basePointMatThetaPhi(matchList1D ,3);

x = basePointMatThetaPhi(: ,1);
y = basePointMatThetaPhi(: ,2);
z = basePointMatThetaPhi(: ,3);

%Fit whisker row planes 
rows=min(rowList):max(rowList);
allPlaneErr = cell(0);
% err=zeros(size(rows));
% n=zeros(3,length(rows));
planeCount=1;
% pt=zeros(3,length(rows));
for r=rows
    if size(x(rowList==r),1)>3
        hold on;
        [alignmentParameters.planeErr(planeCount), alignmentParameters.allPlaneErr{planeCount},n(:,planeCount),~] = fit_3D_data(x(rowList==r),y(rowList==r),z(rowList==r),'plane','on','off','r');
        
%         if sum(sign(n(:,planeCount))) > 0
        if sign(n(3,planeCount))<0
            n(:,planeCount) = -n(:,planeCount);
        end
        plot3([mean(x(rowList==r)),mean(x(rowList==r))+n(1,planeCount)],[mean(y(rowList==r)),mean(y(rowList==r))+n(2,planeCount)],[mean(z(rowList==r)),mean(z(rowList==r))+n(3,planeCount)],'k');
        planeCount=planeCount+1;
        
    end
end

%Find the average normal vector of all of the row planes
avgnormal = mean(n,2)';

%Find the angle between the normal vector and the x-y plane
psi = atan2(avgnormal(3),avgnormal(2))*(180/pi);


%Make sure the angle is defined correctly
% normal in first quadrant
if (psi >= 0 && psi <= 90)
    psi = 90 - psi;
    % normal in second quadrant
elseif psi > 90
    psi = -(psi - 90);
    % normal in third quadrant
elseif psi < -90
    psi = abs(psi) - 90;
    % normal in fourth quadrant
elseif (psi < 0 && psi >= -90)
    psi = -(90 - abs(psi));
end

psi = -psi;

%Rotate the whisker around the x axis to align the row planes to the x-y
%plane
basePointMatAligned = EulerRotateWhisker(0,0,psi,basePointMatThetaPhi);
avgnormal = EulerRotateWhisker(0,0,psi,avgnormal);

%debug plotting if you need it
if DBG_PLOTTING==1
    figure;
    plot3d(basePointMatAligned,'.k');
    grid on; axis equal
    hold on; plot3d([0,0,0;avgnormal*10],'r');
end

%clean up variables for output
alignmentParameters.offset=offset;
alignmentParameters.globalTheta=globalTheta;
alignmentParameters.globalPhi=globalPhi;
alignmentParameters.globalPsi=globalPsi;
alignmentParameters.theta=theta;
alignmentParameters.phi=phi;
alignmentParameters.psi=psi;


%% Plot the aligned array
if PLOTTING==1
    figure;
    plot3d(basePointMatAligned,'r.');
    view(90,180);
    grid on;
    axis image;
end

end