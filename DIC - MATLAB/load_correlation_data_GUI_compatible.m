function [grid_setup,corr_setup,gridx_scale,gridy_scale,dispx_scale,dispy_scale,...
    dispx_smooth,dispy_smooth] = load_correlation_data_GUI_compatible(scale)

%Load the parameters from the grid setup
load grid_setup

%Load the parameters form the correlation set-up
load corr_setup;

%Load the data from the correlations and scale the data

load grid_data.mat
gridx_scale = gridx*scale;
gridy_scale = gridy*scale;

load disp_raw_data.mat
dispx_scale = dispx_raw*scale;
dispy_scale = dispy_raw*scale;

%Try loading previously smoothed displacements
try 
    load disp_smooth_data
catch
    dispx_smooth = [];
    dispy_smooth = [];
end
