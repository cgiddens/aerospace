% This function removes grid points that are too close to the edge of the
% image, based on the maximum search-zone and subset size

function [N_pts_new,gridx,gridy,grid_setup,initialx,initialy,...
    search_zone] = delete_grid_boundaries(gridx,gridy,grid_setup,...
    subset,initialx,initialy,search_zone,filenamelist,reduction)

%Get the image size
[N_pi_y,N_pi_x] = size(imresize(imread(filenamelist(1,:)),1/reduction));


%Get search_zone info (legacy from when you could adjust the search zone)
max_search_zone = max(max(search_zone));

%The minimum border region w/ no grid points
min_border = subset/2*max_search_zone + 1;

min_top = min_border;
min_lft = min_border;
min_bot = N_pi_y - min_border;
min_rgt = N_pi_x - min_border;

%Find indices of gridx and gridy that are outside of the allowable region:
ind_lft = find(gridx<min_lft);
ind_rgt = find(gridx>min_rgt);
ind_top = find(gridy<min_top);
ind_bot = find(gridy>min_bot);

ind_outside = unique(sort([ind_lft;ind_rgt;ind_top;ind_bot]));

%Remove points that are outside of the allowable region:
gridx(ind_outside) = [];
gridy(ind_outside) = [];
search_zone(ind_outside,:) = [];
initialx(ind_outside,:) = [];
initialy(ind_outside,:) = [];


% Also, change x_matrix and y_matrix:
%Get the grid matrices from grid_param
x_matrix = grid_setup.x_matrix;
y_matrix = grid_setup.y_matrix;
Nx = grid_setup.Nx;
Ny = grid_setup.Ny;

%Find indices of rows and columns that are inside the border and must be
%removed
[dummy,ind_lft] = find(x_matrix<min_lft);
[dummy,ind_rgt] = find(x_matrix>min_rgt);
[ind_top,dummy] = find(y_matrix<min_top);
[ind_bot,dummy] = find(y_matrix>min_bot);

ind_lft = max(ind_lft);
ind_rgt = min(ind_rgt);
ind_top = max(ind_top);
ind_bot = min(ind_bot);


%Check to see if there are any points in the boundary; if there aren't,
%then adjust the ind_XXX so that the matrix_inside = matrix
if isempty(ind_lft)
    ind_lft = 0;
end
if isempty(ind_rgt)
    ind_rgt = Nx + 1;
end
if isempty(ind_top)
    ind_top = 0;
end
if isempty(ind_bot)
    ind_bot = Ny + 1;
end

%Remove the grid points that are in the border
x_matrix_inside = x_matrix(ind_top+1:ind_bot-1,ind_lft+1:ind_rgt-1);
y_matrix_inside = y_matrix(ind_top+1:ind_bot-1,ind_lft+1:ind_rgt-1);


%Store the modified grid parameters in grid_param
[Ny_new,Nx_new] = size(x_matrix_inside);
N_pts_new = length(gridx);

grid_setup.x_matrix = x_matrix_inside;
grid_setup.y_matrix = y_matrix_inside;
grid_setup.Nx = Nx_new;
grid_setup.Ny = Ny_new;
grid_setup.N_pts = N_pts_new;


