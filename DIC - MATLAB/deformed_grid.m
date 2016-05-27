%This function computes the deformed grid for each image based on the
%original grid and the displacements

function [gridx_def,gridy_def,gridx_DU_def,gridy_DU_def] = deformed_grid(def_grid,...
    gridx_scale,gridy_scale,gridx_DU,gridy_DU,dispx_smooth,dispy_smooth)

N_images = size(dispx_smooth,2);

    if def_grid == 1 %Compute the deformed grid:
    %Compute the deformed grid locations:
    gridx_def = repmat(gridx_scale,1,N_images) + dispx_smooth;
    gridy_def = repmat(gridy_scale,1,N_images) + dispy_smooth;

    %Approximate the displacements of the strain grid using interpolation:
    if isempty(gridx_DU) %No displacement gradients have been calculated yet
        gridx_DU_def = [];
        gridy_DU_def = [];

    else %Displacement gradients have been calculated, and the deformed grid should be, too
        dispx_DU = zeros(size(gridx_DU,1),N_images);
        dispy_DU = zeros(size(gridy_DU,1),N_images);

        for i = 1:N_images
            dispx_DU(:,i) = griddata(gridx_scale,gridy_scale,dispx_smooth(:,i),gridx_DU,gridy_DU);
            dispy_DU(:,i) = griddata(gridx_scale,gridy_scale,dispy_smooth(:,i),gridx_DU,gridy_DU);
        end

        gridx_DU_def = repmat(gridx_DU,1,N_images) + dispx_DU;
        gridy_DU_def = repmat(gridy_DU,1,N_images) + dispy_DU;

    end

else %Do not compute the deformed grid:
    gridx_def = [];
    gridy_def = [];
    gridx_DU_def = [];
    gridy_DU_def = [];
end
