function [BP,WH,ID] = matchBPWH(BP,WH,varargin)
%matchBPWH The purpose of this function is to match the basepoints and the
% whisker.
%
%   [BP,WH,ID] = matchBPWH(BP,WH,i) matches ith rat's basepoints with whisker.
%
%   Rem: matching rule:
%       If the basepoint is missing, take the whisker's first row as the
%       basepoint. If the whisker is missing, disregard and move on.
%
% By Yifu
% 2018/02/01

% clear
% load('RAT_aligned.mat');
% BP = RAT(2).BP;
% WH = RAT(2).WH;
% BP = rmfield(BP,'Names');
% BP = rmfield(BP,'Points');
% WH = rmfield(WH,'Names');
% WH = rmfield(WH,'Points');

%%
nameStack = java.util.Stack();
pointStack = java.util.Stack();
% Push all whisker points into stack
for i = WH.RawNum:-1:1
    nameStack.push(WH.RawNames(i,:));
    pointStack.push(WH.RawPoints{i,1});
end
n = 1;
for i = 1:BP.RawNum
    if nameStack.empty()||pointStack.empty(), break;
        % R WH run out
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif xor(contains(nameStack.peek(),'Z'),contains(BP.RawNames(i,:),'Z'))
        error('check why');
    elseif contains(nameStack.peek(),'Z') && contains(BP.RawNames(i,:),'Z')
        WH.Names(n,:) = nameStack.pop();
        WH.Points{n,:} = pointStack.pop();
        BP.Names(n,:) = BP.RawNames(i,:);
        BP.Points{n,:} = BP.RawPoints{i,:};
        ID.Col(n,:) = nan;
        ID.Row(n,:) = nan;
        ID.Side(n,:) = isequal(WH.Names(n,1),'R');
        n = n + 1;
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    elseif all(BP.RawNames(i,1:end-2) == nameStack.peek())
        % Match
        WH.Names(n,:) = nameStack.pop();
        WH.Points{n,:} = pointStack.pop();
        BP.Names(n,:) = BP.RawNames(i,:);
        BP.Points{n,:} = BP.RawPoints{i,:};
        ID.Col(n,:) = WH.Names(n,3:4);
        ID.Row(n,:) = WH.Names(n,2);
        ID.Side(n,:) = isequal(WH.Names(n,1),'R');
        n = n + 1;
    elseif any(BP.RawNames(i,1:end-2) < nameStack.peek())
        % either extra BP, or L WH run out
        if (~isempty(varargin))
            disp(['(',num2str(varargin{1}),') Delete: ',BP.RawNames(i,:),'. (No WH)'])
        end
    elseif any(BP.RawNames(i,1:end-2) > nameStack.peek())
        % extra WH
        while(~all(BP.RawNames(i,1:end-2) == nameStack.peek()))
            WH.Names(n,:) = nameStack.pop();
            WH.Points{n,:} = pointStack.pop();
            BP.Names(n,:) = [WH.Names(n,:),'BP'];
            BP.Points{n,:} = WH.Points{n,:}(1,:);
            ID.Col(n,:) = WH.Names(n,3:4);
            ID.Row(n,:) = WH.Names(n,2);
            ID.Side(n,:) = isequal(WH.Names(n,1),'R');
            n = n + 1;
            if (~isempty(varargin))
                disp(['(',num2str(varargin{1}),') Add: ',BP.RawNames(i,:),'. (No BP)'])
            end
        end
        WH.Names(n,:) = nameStack.pop();
        WH.Points{n,:} = pointStack.pop();
        BP.Names(n,:) = BP.RawNames(i,:);
        BP.Points{n,:} = BP.RawPoints{i,:};
        ID.Col(n,:) = WH.Names(n,3:4);
        ID.Row(n,:) = WH.Names(n,2);
        ID.Side(n,:) = isequal(WH.Names(n,1),'R');
        n = n + 1;
    end
end
while (~nameStack.empty())
    % Extra WH at the end
    WH.Names(n,:) = nameStack.pop();
    WH.Points{n,:} = pointStack.pop();
    BP.Names(n,:) = BP.RawNames(i,:);
    BP.Points{n,:} = BP.RawPoints{i,:};
    ID.Col(n,:) = WH.Names(n,3:4);
    ID.Row(n,:) = WH.Names(n,2);
    ID.Side(n,:) = isequal(WH.Names(n,1),'R');
    n = n + 1;
end
ID.Num = n - 1;

for i = 1:size(WH.Points,1)
    if size(WH.Points{i},2) ~= 3, WH.Points{i} = WH.Points{i}'; end
end


end



