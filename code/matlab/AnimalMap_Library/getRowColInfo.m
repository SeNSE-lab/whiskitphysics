function [rowList, colList ,rowIdx,colIdx]=getRowColInfo(basePointNames)
% This function indexes the rows and columns so that they can easily be
% used.
%
% Inputs:
%   basePointNames--->An nx5 matrix of chars of in the order SIDE ROW
%       COLUMN...ANYTHING ELSE  For example 'RA1BP'
%
% Outputs:
%   rowList/colList--->An nx5 matrix of numeric row and column names.  
%       In the case of row 'A'=1; 'B'=2;...etc.
%
%   rowIdx--->A 1x7 cell where each cell column is a whisker row and the
%       content of that position are the indicies of each whisker in that
%       particular whisker row. For example rowIdx{1,2}(1,:) would give you
%       the index of every whisker in the second row.  There are 7 columns
%       in the cell because there are a total of 7 whisker rows
%
%   colIdx--->A 1x9 cell.  The same explaination as above but for whisker
%       column.  There are 9 columns in the cell because there are 9
%       whisker columns.
%
%


rowList=zeros(size(basePointNames,1),1);
colList=zeros(size(basePointNames,1),1);

for i=1:size(basePointNames,1)
    rowList(i,1)=letter2num(basePointNames(i,2));
    colList(i,1)=str2double(basePointNames(i,3:4));
end

maxrow=max(rowList);
maxcol=max(colList);

colIdx=cell(1,maxcol);
for i=1:maxcol
    count=1;
    for j=1:size(colList,1)
        if colList(j)==i
            colIdx{1,i}(count)=j;
            count=count+1;
        end
    end
end

rowIdx=cell(1,maxrow);
for i=1:maxrow
    count=1;
    for j=1:size(rowList,1)
        if rowList(j)==i
            rowIdx{1,i}(count)=j;
            count=count+1;
        end
    end
end

end