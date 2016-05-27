function [grid_setup,reduction,corr_setup,FEM_setup,gridx,gridy,...
    dispx_smooth,dispy_smooth,dispx_raw,dispy_raw,corr_coeff_full,scale,...
    small_strain,large_strain,gridx_DU,gridy_DU,...
    grid_setup_reduced,gridx_reduced,gridy_reduced,...
    corr_setup_reduced,dispx_reduced,dispy_reduced,corr_coeff_reduced,...
    gridx_def,gridy_def,gridx_DU_def,gridy_DU_def] = load_computed_data


try %Try loading the smoothed data and strains
    load('grid_scale_data');    %gridx_scale, gridy_scale
    gridx = gridx_scale;
    gridy = gridy_scale;
    
    load FEM_setup;
    load('disp_smooth_data');   %dispx_smooth, dispy_smooth
    scale = FEM_setup.scale;
    
    load('DU_data');            %DU_FEM, D2U_FEM, gridx_DU, gridy_DU, large strain, small strain
    
catch %If there's no smoothed data:
    load('grid_data');          %gridx, gridy
    
    FEM_setup.N_Node_DU = [];
    scale = 1;
    
    dispx_smooth = [];
    dispy_smooth = [];
    small_strain = [];
    large_strain = [];
    gridx_DU = [];
    gridy_DU = [];
end

%Load raw data, also
load('disp_raw_data');      %dispx_raw,dispy_raw
load('valid_data');         %validx, validy, corr_coeff_full

%For compatibility with version 1, check to see if corr_coeff_full exists;
%if not, make a blank variable
if ~exist('corr_coeff_full','var')
    corr_coeff_full = [];
end

%Load the reduced data also
load('grid_reduced_data');  %gridx_reduced, gridy_reduced
load('disp_reduced_data');  %dispx_reduced,dispy_reduced, corr_coeff_reduced

%For compatibility with version 1, check to see if corr_coeff_reduced exists;
%if not, make a blank variable
if ~exist('corr_coeff_reduced','var')
    corr_coeff_reduced = [];
end

load grid_setup;
load grid_setup_reduced
try
    reduction = grid_setup_reduced.reduction;
catch
    reduction = [];
    corr_coeff_reduced = [];
end
load corr_setup;
load corr_setup_reduced;


try
    load grid_deformed_data
catch
    gridx_def = [];
    gridy_def = [];
    gridx_DU_def = [];
    gridy_DU_def = [];
end