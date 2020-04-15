function [BPPoints,BPNames] = matchBP(BP,varargin)
%matchBP The purpose of this function is to match left and right
%basepoints, so there won't be any offset in the origin.
%
%   [BPPoints,BPNames] = matchBP(BP,i) given i-th rat's BP
%   information, return matched BP points and BP names.
%
%   These points and names are only used for re-orientation, so they should
%   be a match using RawNames and RawPoints.
%
% By Yifu
% 2018/08/27


l = find(BP.RawNames(:,1)=='L',1,'last');
r = size(BP.RawNames,1) - l;
% Prepare stack
LNstack = java.util.Stack();
LPstack = java.util.Stack();
RNstack = java.util.Stack();
RPstack = java.util.Stack();
for i = l:-1:1
    LNstack.push(BP.RawNames(i,2:end)); % A01, A02, A03
    LPstack.push(BP.RawPoints{i,1});
end 
for i = (l+r):-1:(l+1)
    RNstack.push(BP.RawNames(i,2:end)); % A01, A02, A03
    RPstack.push(BP.RawPoints{i,1});
end 

% Compare
n = 1;
while (~LNstack.empty() && ~RNstack.empty())
    if contains(RNstack.peek(), 'Z') || contains(LNstack.peek(), 'Z')
        break;
    elseif strcmp(RNstack.peek(), LNstack.peek())
        LP{n,1} = reshape(LPstack.pop(),1,3);
        RP{n,1} = reshape(RPstack.pop(),1,3);
        LN(n,:) = ['L',LNstack.pop()];
        RN(n,:) = ['R',RNstack.pop()];
        n = n + 1;
    elseif (cstrcmp(RNstack.peek(), LNstack.peek()) == 1)
        if (~isempty(varargin))
            disp(['(',num2str(varargin{1}),') No right BP: R',LNstack.peek()])
        end
        LPstack.pop();
        LNstack.pop();

    elseif (cstrcmp(RNstack.peek(), LNstack.peek()) == -1)
        if (~isempty(varargin))
            disp(['(',num2str(varargin{1}),') No left BP: L',RNstack.peek()])
        end
        RPstack.pop();
        RNstack.pop();
    end
end


while (~RNstack.empty())
    if ~contains(RNstack.peek(),'Z')
        disp(['(',num2str(varargin{1}),') No left BP: L',RNstack.pop()])
    else
        break;
    end
end
   
while (~LNstack.empty())
    if ~contains(LNstack.peek(),'Z')
        disp(['(',num2str(varargin{1}),') No right BP: R',LNstack.pop()])
    else
        break;
    end
end

BPPoints = [LP;RP];
BPNames = [LN;RN];

end

