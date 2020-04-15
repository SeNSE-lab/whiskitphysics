function [R, P] = svd_fit(points, names)

% names = AlignBPNames;
% pts = cell2mat(AlignBPPoints);

pts = cell2mat(points);
P = mean(pts);
pts = pts - P;
%% similar axis
[C,~,ic] = unique(names(:,2));
xsim = pts(find(names(:,1)=='R',1,'first'),:) - pts(find(names(:,1)=='L',1,'first'),:);
zsim = pts(find(ic==1,1,'first'),:) - pts(find(ic==max(ic),1,'first'),:);
ysim = cross(zsim,xsim);

%% get V

V = zeros(3,3,length(C));
for row = 1:length(C)
    if sum(ic==row)<10, V(:,:,row) = nan; continue; end
    [~,~,V(:,:,row)] = svd(pts(ic==row,:)-mean(pts(ic==row,:)));
    if dot(V(:,1,row),xsim)<0, V(:,1,row)=-V(:,1,row); end
    if dot(V(:,2,row),ysim)<0, V(:,2,row)=-V(:,2,row); end
    if dot(V(:,3,row),zsim)<0, V(:,3,row)=-V(:,3,row); end
end
%% get R
R = normc(nanmean(V,3));
a = 1;
% hold on
% % plot3d(pts,'ko');
% quiver3(0,0,0,R(1,1),R(2,1),R(3,1),5,'r-');
% quiver3(0,0,0,R(1,2),R(2,2),R(3,2),5,'g-');
% quiver3(0,0,0,R(1,3),R(2,3),R(3,3),5,'b-');
% plot3d(pts*R,'ro')
% xlabel('x')
% ylabel('y')
% axis equal

end

