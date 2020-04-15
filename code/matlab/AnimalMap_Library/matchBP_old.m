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
% 2018/02/05

% clear
% load('RAT_aligned.mat');
% BP = RAT(3).BP;
% varargin{1} = 1;

l = find(BP.RawNames(:,1)=='L',1,'last');
r = size(BP.RawNames,1) - l;
% Prepare stack
LNstack = java.util.Stack();
LPstack = java.util.Stack();
for i = l:-1:1
    LNstack.push(BP.RawNames(i,2:end)); % A01, A02, A03
    LPstack.push(BP.RawPoints{i,1});
end 

% Compare
n = 1;
for i = l+(1:r)
    if LNstack.empty()
        i = i - 1;
        break;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif contains(LNstack.peek(),'Z')
        LNstack.pop();
        LPstack.pop();
    elseif contains(BP.RawNames(i,:),'Z')
        continue;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif (strcmp(BP.RawNames(i,2:end), LNstack.peek()))
        LP{n,1} = reshape(LPstack.pop(),1,3);
        RP{n,1} = BP.RawPoints{i,1};
        LN(n,:) = ['L',LNstack.pop()];
        RN(n,:) = BP.RawNames(i,:);
        n = n + 1;
    elseif (cstrcmp(BP.RawNames(i,2:end), LNstack.peek()) == 1)
        if (~isempty(varargin))
            disp(['(',num2str(varargin{1}),') No right BP: R',LNstack.peek()])
        end
        if (~strcmp(BP.RawNames(i,2:end), LNstack.peek()))
            LPstack.pop();
            LNstack.pop();
            continue;
        end
        LP{n,1} = reshape(LPstack.pop(),1,3);
        RP{n,1} = BP.RawPoints{i,1};
        LN(n,:) = ['L',LNstack.pop()];
        RN(n,:) = BP.RawNames(i,:);
        n = n + 1;
        
    elseif (cstrcmp(BP.RawNames(i,2:end), LNstack.peek()) == -1)
        if (~isempty(varargin))
            disp(['(',num2str(varargin{1}),') No left BP: L',BP.RawNames(i,2:end)])
        end
    end
end


if i < (l+r)
    for j = (i+1):(l+r)
        disp(['(',num2str(varargin{1}),') No left BP: L',BP.RawNames(i,2:end)])
    end
end
   
while (~LNstack.empty())
    disp(['(',num2str(varargin{1}),') No right BP: R',LNstack.pop()])
end



BPPoints = [LP;RP];
BPNames = [LN;RN];

end

