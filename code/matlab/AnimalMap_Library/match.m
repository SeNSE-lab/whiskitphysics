function [BP,WH,ID] = match(BP,WH,varargin)
%MATCH The purpose of this function is to match the basepoints and the
% whisker.
%
%   [BP,WH,ID] = MATCH(BP,WH,i) matches ith rat's basepoints with whisker.
%
%   Rem: matching rule:
%       If the basepoint is missing, take the whisker's first row as the
%       basepoint. If the whisker is missing, disregard and move on.
%
% By Yifu
% 2017/11/28

% Initialize Pointer
error('Use matchBPWH instead.')
p1 = 1; p2 = 1; n = 1;
while(p1 <= size(BP.RawNames,1) || p2 <= size(WH.RawNames,1))
    % matched
    if isequal(BP.RawNames(p1,1:6),WH.RawNames(p2,1:6))
        BP.Names(n,:) = BP.RawNames(p1,:);
        WH.Names(n,:) = WH.RawNames(p2,:);
        BP.Points{n,:} = BP.RawPoints{p1,:};
        WH.Points{n,:} = WH.RawPoints{p2,:};
        ID.Col(n,:) = WH.Names(n,3:4);
        ID.Row(n,:) = WH.Names(n,2);
        ID.Side(n,:) = isequal(WH.Names(n,1),'R');
        p1 = p1 + 1;
        p2 = p2 + 1;
        n = n + 1;
    % BP info missing: take whisker(1,:) instead
    elseif isequal(BP.RawNames(p1,1:6),WH.RawNames(p2+1,1:6))
        BP.Names(n,:) = [WH.RawNames(p2,:),'BP'];
        WH.Names(n,:) = WH.RawNames(p2,:);
        BP.Points{n,:} = WH.RawPoints{p2,:}(1,:);
        WH.Points{n,:} = WH.RawPoints{p2,:};
        ID.Col(n,:) = WH.Names(n,3:4);
        ID.Row(n,:) = WH.Names(n,2);
        ID.Side(n,:) = isequal(WH.Names(n,1),'R');
        p2 = p2 + 1;
        n = n + 1;
    % WH info missing: disregard and move on
    elseif isequal(BP.RawNames(p1+1,1:6),WH.RawNames(p2,1:6))
        if ~isempty(varargin)
            disp(['Rat ',num2str(varargin{1}),' doesn''t have whisker: ',...
                BP.RawNames(p1,1:4)]);
        end
        p1 = p1 + 1;
    end
end
ID.Num = size(WH.Points,1);
BP.Num = size(WH.Points,1);
WH.Num = size(WH.Points,1);
    
end

