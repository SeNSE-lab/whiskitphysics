
function [rightPad,leftPad,rightList,leftList,rightIndx,leftIndx]=splitBasePointsLR(basePointMat, basePointNames)
% This function slits the base point matrix into left and right arrays.  It
% also splits up the base point names.
% Inputs:
%   basePointMat--->Any nxm base point matrix that you want to split by left
%       and right arrays
%
%   basePointNames--->An nx5 matrix of chars of in the order SIDE ROW
%       COLUMN...ANYTHING ELSE  For example 'RA1BP'
%
% Outputs:
%   rightPad/leftPad--->The split base point matrix
%
%   rightList/leftList--->The split base point names matrix. This only
%       outputs the row and column. For example 'A1'


    leftList=[];
    rightList=[];
    leftIndx=[];
    rightIndx=[];
    leftPad=[];
    rightPad=[];


if iscell(basePointMat)
    countL=1;
    countR=1;

    for i=1:size(basePointNames,1)
        if strcmp(basePointNames(i,1),'L')
            
            leftList=[leftList;basePointNames(i,1:6)];
            leftPad{countL,1}=basePointMat{i,:};
            leftIndx=[leftIndx,i];
            countL=countL+1;
        elseif strcmp(basePointNames(i,1),'R')
            rightList=[rightList; basePointNames(i,1:6)];
            rightPad{countR,1}=basePointMat{i,:};
            rightIndx=[rightIndx,i];
            countR=countR+1;
        end
    end
else

    for i=1:size(basePointNames,1)
        if strcmp(basePointNames(i,1),'L')
            leftList=[leftList;basePointNames(i,1:6)];
            leftPad=[leftPad; basePointMat(i,:)];
            leftIndx=[leftIndx,i];
        elseif strcmp(basePointNames(i,1),'R')
            rightList=[rightList; basePointNames(i,1:6)];
            rightPad=[rightPad; basePointMat(i,:)];
            rightIndx=[rightIndx,i];
        end
    end
end


end