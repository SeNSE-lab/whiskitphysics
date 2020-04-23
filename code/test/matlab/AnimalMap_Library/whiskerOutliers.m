function [goodPoints, badPoints] = whiskerOutliers(rawWH, varargin)
%whiskerOutliers This function aims to find outliers in the raw whisker
% data, returns both good points and bad points on this whisker.
%
%   [goodPoints, badPoints] = whiskerOutliers(whisker)
%   [goodPoints, badPoints] = whiskerOutliers(whisker, sigma) takes a raw
%   3-by-N whisker, and significant level (default: 1.75(*sigma)), returns the
%   good points and bad points on the whisker. The distribution model for 
%   the distance between the points and the whisker is 'Half-Normal 
%   Distribution'.
%   
% Yifu
% 2017/12/14
    if size(rawWH,2)<10
        goodPoints = rawWH;
        badPoints = [];
    else
        if isempty(varargin)
            threshold = 1.75;
        else
            threshold = varargin{1};
        end
        dist = sqrt(sum(rawWH.^2,1));
        [~, idx] = sort(dist);
        rawWH = rawWH(:,idx);
        try
            [x,y,z] = equidistlen3d(rawWH(1,:),rawWH(2,:),rawWH(3,:),0.5);
        catch
            warning('Reduce sampling rate.');
            rawWH = rawWH(:,1:2:end);
            [x,y,z] = equidistlen3d(rawWH(1,:),rawWH(2,:),rawWH(3,:),0.5);
        end
        whisker(1,:) = x'; whisker(2,:) = y'; whisker(3,:) = z';
        smoothWH(1,:) = smooth(whisker(1,:),10);
        smoothWH(2,:) = smooth(whisker(2,:),10);
        smoothWH(3,:) = smooth(whisker(3,:),10);
        dist = zeros(size(rawWH,2),1);
        for n = 2:size(rawWH,2)-1
            dist(n) = min(min((smoothWH-rawWH(:,n))./normr((smoothWH-rawWH(:,n))')'));
        end
        distribution = fitdist(dist,'HalfNormal');
        FLAG = find(sign(distribution.mu + threshold*distribution.sigma - dist)+1);
        goodPoints = rawWH(:,FLAG);
        badPoints = rawWH(:,~FLAG);
    end
end

