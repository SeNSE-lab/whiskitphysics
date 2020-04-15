function matchList=matchBasePoints(leftList,rightList)
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

matchList=[];
for i=1:size(leftList,1)
    for j=1:size(rightList,1)
        if strcmp(leftList(i,1:4),rightList(j,1:4))
            matchList=[matchList; [i,j]];
        end
    end
end


end