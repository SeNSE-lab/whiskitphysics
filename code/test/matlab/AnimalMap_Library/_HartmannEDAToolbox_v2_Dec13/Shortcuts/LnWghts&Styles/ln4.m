% Hartmann EDA Toolbox v2, Dec 2013
% function [void]=ln4(n)
% Sets the line width of object "n" to 4.
% Default (no input) is current object (n=1)

function [void]=ln4(n)

if nargin==0
    n=1;
end;
if length(n) > 1
    % user input the handle directly, instead of the number of the handle
    for i = 1:length(n)
        set(n(i),'LineWidth',4);
    end;
elseif length(n)==1
    if rem(n,1) == 0  % user input the number of the handle
        h=get(gca,'Children');  h=h(n);
    elseif rem(n,1) ~=0  % user input the handle
        h=n;
    end;
    set(h,'LineWidth',4);
end;
