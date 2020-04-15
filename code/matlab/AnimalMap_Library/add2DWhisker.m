function s = add2DWhisker(whiskername, s, pts)
%add2DWhisker the purpose of this function is to add a 2D whisker to an
%already rearranged data structure. If the whisker idendtity exists, then
%the 2D information is directly added to the structure. If not, then a new
%whisker identity is added to the structure, with all other information
%NaN.
%
%   This function fits all 2D whiskers using the model: y = Ax*3+Bx*2. It
%   also outputs the p-value for a quadratic curve.
%
%   s = add2DWhisker(whiskername, s, pts)
%
%   Example Input:
%   s = add2DWhisker('1LA01', s, points)
%
% By Yifu
% 2019/07/09

if length(whiskername)~=5
    error('Whisker name is not in the correct format: e.g. 1LA03.')
end

if issorted(size(pts),'ascend')
    pts = pts';
end



%% Actual fit
if ~isempty(pts)
    g = fittype(@(a,b,x) a*x.^3+b*x.^2, 'coefficients', {'a','b'});
    f = fit(pts(:,1), pts(:,2), g, 'StartPoint', [0.01 0.01]);
    fitWhisker = [pts(:,1),f.a*pts(:,1).^3+f.b*pts(:,1).^2];
    [fitWhiskerx, fitWhiskery] = equidist(fitWhisker(:,1),fitWhisker(:,2), 100);
end


%% insert
[flag, index] = searchWhisker(whiskername, s);
if ~isempty(pts)
    s.WHPoints2Dfit{index,1} = [fitWhiskerx; fitWhiskery];
    s.WHPoints2D{index,1} = pts;
    s.A2D(index,1) = f.a;
    s.B2D(index,1) = f.b;
    s.S2D(index,1) = whiskerLength(pts);
    K = whiskerCurvature2D(f.a, f.b, whiskerLength(pts));
    s.K2D(index,1) = K;
else
    s.WHPoints2Dfit{index,1} = nan;
    s.WHPoints2D{index,1} = nan;
    s.A2D(index,1) = nan;
    s.B2D(index,1) = nan;
    s.S2D(index,1) = nan;
    s.K2D(index,1) = nan;
end

if ~flag
    warning(['Not having ',whiskername,' in 3D data'])
    s.A3D = insertArray(s.A3D, index, nan);
    s.B3D = insertArray(s.B3D, index, nan);
    s.AnimalNum = insertArray(s.AnimalNum, index, str2double(whiskername(1)));
    s.Axis = insertArray(s.Axis, index, [nan, nan, nan]);
    s.BPPhi = insertArray(s.BPPhi, index, nan);
    s.BPPoints = insertArray(s.BPPoints, index, [nan, nan, nan]);
    s.BPR = insertArray(s.BPR, index, nan);
    s.BPTheta = insertArray(s.BPTheta, index, nan);
    s.Col = insertArray(s.Col, index, str2double(whiskername(4:5)));
    s.Error = insertArray(s.Error, index, nan);
    s.EulerPhi = insertArray(s.EulerPhi, index, nan);
    s.EulerTheta = insertArray(s.EulerTheta, index, nan);
    s.EulerZeta = insertArray(s.EulerZeta, index, nan);
    s.Names = insertArray(s.Names, index, whiskername);
    s.ProjPhi = insertArray(s.ProjPhi, index, nan);
    s.ProjPsi = insertArray(s.ProjPsi, index, nan);
    s.ProjTheta = insertArray(s.ProjTheta, index, nan);
    s.Row = insertArray(s.Row, index, double(whiskername(3))-64);
    s.S3D = insertArray(s.S3D, index, nan);
    s.Side = insertArray(s.Side, index, strcmp(whiskername(2),'R'));
    s.WHPoints = insertArray(s.WHPoints, index, nan);
    s.WHPointsFit = insertArray(s.WHPointsFit, index, nan);
    s.WHPointsSmooth = insertArray(s.WHPointsSmooth, index, nan);
    s.quality = insertArray(s.quality, index, false);
end


    function arr = insertArray(arr, idx, ele)
        arr = [arr(1:idx-1,:); ele; arr(idx:end,:)];
    end



end