%Given the displacement gradients at each quadrature point of each element,
%this function averages them at Gauss points closest together
% The output is a vector of the form:

% DU_avg:
% grid_DU 1     ux_avg
%               vx_avg
%               uy_avg
%               vy_avg
% grid_DU 2     ux_avg
%               vx_avg
%               uy_avg
%               vy_avg
%   .
%   .
%   .

% D2U_avg:
% grid_DU 1     ux2_avg
%               uxy_avg
%               uy2_avg
%               vx2_avg
%               vxy_avg
%               vy2_avg
% grid_DU 2     ux2_avg
%               uxy_avg
%               uy2_avg
%               vx2_avg
%               vxy_avg
%               vy2_avg
%   .
%   .
%   .

function [DU_avg,D2U_avg] = strain_avg_Gauss_close_pts_center(...
    N_Cluster,DU,D2U,ind_center)

% Separate the derivatives into the individual components
ux_Gauss = reshape(DU(1:4:end,:),[],1);
vx_Gauss = reshape(DU(2:4:end,:),[],1);
uy_Gauss = reshape(DU(3:4:end,:),[],1);
vy_Gauss = reshape(DU(4:4:end,:),[],1);

ux2_Gauss = reshape(D2U(1:6:end,:),[],1);
uxy_Gauss = reshape(D2U(2:6:end,:),[],1);
uy2_Gauss = reshape(D2U(3:6:end,:),[],1);
vx2_Gauss = reshape(D2U(4:6:end,:),[],1);
vxy_Gauss = reshape(D2U(5:6:end,:),[],1);
vy2_Gauss = reshape(D2U(6:6:end,:),[],1);


%Sum the strains at the average Gauss points
ux_avg = sum(ux_Gauss(ind_center),2)/N_Cluster;
vx_avg = sum(vx_Gauss(ind_center),2)/N_Cluster;
uy_avg = sum(uy_Gauss(ind_center),2)/N_Cluster;
vy_avg = sum(vy_Gauss(ind_center),2)/N_Cluster;

ux2_avg = sum(ux2_Gauss(ind_center),2)/N_Cluster;
uxy_avg = sum(uxy_Gauss(ind_center),2)/N_Cluster;
uy2_avg = sum(uy2_Gauss(ind_center),2)/N_Cluster;
vx2_avg = sum(vx2_Gauss(ind_center),2)/N_Cluster;
vxy_avg = sum(vxy_Gauss(ind_center),2)/N_Cluster;
vy2_avg = sum(vy2_Gauss(ind_center),2)/N_Cluster;

    
%Get DU_avg into final form
DU_avg = reshape([ux_avg,vx_avg,uy_avg,vy_avg]',[],1);
D2U_avg = reshape([ux2_avg,uxy_avg,uy2_avg,vx2_avg,vxy_avg,vy2_avg]',[],1);



