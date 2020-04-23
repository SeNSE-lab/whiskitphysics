function res = isnanCell(C)
%isnanCell find the nans in a cell array

res = cell2mat(cellfun(@(x) any(isnan(x)), C, 'UniformOutput', false));
end