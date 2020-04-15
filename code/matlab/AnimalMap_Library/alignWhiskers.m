function whiskersAligned=alignWhiskers(whiskers,alignmentParams)
% This function takes the alignment parameters that were created by the
% function "alignBasepoints" and applies them to the other point
% clouds.
%
%   Inputs:
%       whiskers:
%           An Nx1 cell containing Mx3 matricies describing whisker point
%           clouds or you may also input a Nx3 matrix to align a single
%           point cloud or a bunch of single point locations (i.e. a bunch
%           of basepoints).
%
%       alignmentParams:
%           The alignment parameters that are outputted by the
%           alignBasepoints function
%
%   Outputs:
%       whiskersAligned:
%           Either the cell or matrix that was inputted, rotated and 
%           translated by the alignment parameters.

for i=1:size(whiskers,1)
    if iscell(whiskers)
        whiskers{i,1}=whiskers{i,1}-repmat(alignmentParams.offset,...
            size(whiskers{i,1},1),1);
        
        whiskers{i,1}=EulerRotateWhisker(alignmentParams.globalTheta,...
            alignmentParams.globalPhi,alignmentParams.globalPsi,whiskers{i,1});
        
        whiskers{i,1}=EulerRotateWhisker(alignmentParams.theta,0,0,whiskers{i,1});
        whiskers{i,1}=EulerRotateWhisker(0,alignmentParams.phi,0,whiskers{i,1});
        whiskers{i,1}=EulerRotateWhisker(0,0,alignmentParams.psi,whiskers{i,1});
    else
            whiskers(i,:)=whiskers(i,:)-repmat(alignmentParams.offset,...
            size(whiskers(i,:),1),1);
        
        whiskers(i,:)=EulerRotateWhisker(alignmentParams.globalTheta,...
            alignmentParams.globalPhi,alignmentParams.globalPsi,whiskers(i,:));
        
        whiskers(i,:)=EulerRotateWhisker(alignmentParams.theta,0,0,whiskers(i,:));
        whiskers(i,:)=EulerRotateWhisker(0,alignmentParams.phi,0,whiskers(i,:));
        whiskers(i,:)=EulerRotateWhisker(0,0,alignmentParams.psi,whiskers(i,:));
    end
    
end

whiskersAligned=whiskers;

end