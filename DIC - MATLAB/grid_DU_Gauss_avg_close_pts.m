function [N_pts_Gauss_avg,gridx_DU_Gauss_avg,gridy_DU_Gauss_avg] = ...
    grid_DU_Gauss_avg_close_pts(N_Elem,N_Node_Elem,...
    N_Elem_Order,Elem_Node,gridx,gridy)


%% Calculate the grid points at the averaged Gauss quadrature points:

%Points in the master element where groups of Gauss points will be averaged
if N_Elem_Order == 1 %Linear element
    r_avg = [0,0];
elseif N_Elem_Order == 2 %Quadratic element
    r_avg = [-0.5, -0.5; -0.5, 0.5; 0.5, 0.5; 0.5, -0.5];
elseif N_Elem_Order == 3 %Cubic element
    r_avg = [-2/3, -2/3; -2/3, 0; -2/3, 2/3; 0, 2/3; 2/3, 2/3; 2/3, 0; 2/3, -2/3; 0, -2/3; 0, 0];
end

%Number of averaged Gauss points:
N_GQ = N_Elem_Order^2;

%Get the x- and y-grid values for all the element nodes, for all the
%elements
X_EN = gridx(Elem_Node); %N_Node_Elem x N_Elem
Y_EN = gridy(Elem_Node);

%Combine the x- and y-node grids into one grid
%          Elem1      Elem2    ...
% Node1 | x1   y1 |  x1   y1 |
% Node2 | x2   y2 |  x2   y2 |
%  .  
%  . 

XY_EN = zeros(N_Node_Elem,N_Elem*2);
XY_EN(:,1:2:end) = X_EN;
XY_EN(:,2:2:end) = Y_EN;

%Get the shape functions at the averaged Gauss points:
Nhat = zeros(N_GQ,N_Node_Elem);
for i = 1:N_GQ
    r = [r_avg(i,1),r_avg(i,2)]; % coordinates of the i'th Gauss Quad point, in master element coordinates
    [Nhat_i,~,~] = Shape_Funct_LH(N_Elem_Order,r); %Shape functions and derivatives of i'th point
    Nhat(i,:) = Nhat_i';
end

XY_GQ = Nhat*XY_EN; %N_GQ x N_Elem*2
X_GQ = reshape(XY_GQ(:,1:2:end),[],1);
Y_GQ = reshape(XY_GQ(:,2:2:end),[],1);


%% Get grid data points into final form for averaged Gauss points

%Vectorize the matrices
gridx_DU_Gauss_avg = reshape(X_GQ,[],1);
gridy_DU_Gauss_avg = reshape(Y_GQ,[],1);

%Eliminate duplicate points:
grid_DU_Gauss_avg = [gridx_DU_Gauss_avg,gridy_DU_Gauss_avg]; %Combine x and y grid data into one matrix
grid_DU_Gauss_avg_big = grid_DU_Gauss_avg*1000; %Multiply the grid data by 1000
grid_DU_Gauss_avg_floor = round(grid_DU_Gauss_avg_big); %Round to the nearest integer; this step removes any small difference between points that should be the same
grid_DU_Gauss_avg_unique = unique(grid_DU_Gauss_avg_floor,'rows'); %Eliminate duplicate points
grid_DU_Gauss_avg = grid_DU_Gauss_avg_unique/1000; %Divide by 1000 to recover original data

gridx_DU_Gauss_avg = grid_DU_Gauss_avg(:,1);
gridy_DU_Gauss_avg = grid_DU_Gauss_avg(:,2);

N_pts_Gauss_avg = length(gridx_DU_Gauss_avg);




