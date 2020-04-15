function matchList=matchBasePointsLR(leftList,rightList)
% This function looks at the left and right name list and finds the base
% points that exist in both arrays.
% 
% Inputs:
%   leftList/rightList--->The nx2 char matrix of whisker names for the 
%       left/right whisker arrays.  For example 'A1'. Usually comes from
%       the output of splitBasePointsLR
%
% Outputs:
%   matchList--->mx2 matrix of indicies of the basepoints that match
%       between the left and right arrays.  The first column is the left 
%       array the second column is the right array.

leftList=leftList(:,2:4);
rightList=rightList(:,2:4);
matchList=[];
for i=1:length(leftList)
    for j=1:length(rightList)
        if strcmp(leftList(i,:),rightList(j,:))
            matchList=[matchList; [i,j]];
        end
    end
end


end