function [Y, r] = normr(M)
%NORMR normalizes the rows of M to a length of 1. Also return the ratio.

Y = zeros(size(M));
r = zeros(size(M,1),1);
for i = 1:size(M,1)
    if norm(M(i,:)) == 0
        r(i) = 0;
        Y(i,:) = zeros(1,size(M,2));
    else
        r(i) = norm(M(i,:));
        Y(i,:) = M(i,:)/r(i);
    end
end

end

