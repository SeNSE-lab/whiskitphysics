function A = findAngle(V)   
%findAngle return the angle between the vector and xy plane.
%
%   A = findAngle(V) returns the angle between the 3xN vector V and the
%   horizontal x-y plane.
%
% By Yifu
% 2018/02/06


if size(V,1) ~= 3, error('The input is not vector!'); end
N = size(V,2);
A = zeros(1,N);
for i = 1:N
    V1 = V(:,i);
    if all(V1 == [0;0;0])
        A(i) = 0;
    else
        V2 = V1 - [0;0;V1(3)];
        A(i) = acos((V1'*V2)/norm(V1)/norm(V2));
    end
end




end

