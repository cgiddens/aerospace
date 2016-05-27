function [dispx,dispy] = calc_disp(grid_param,corr_setup,gridx,gridy,validx,validy)

%Find the reference image:
%ref_image = 1 --> first image
%ref_image = 2 --> previous image
ref_image = corr_setup.ref_image;
N_pts = grid_param.N_pts;
N_images = corr_setup.N_images_correlated;

if ref_image == 1 %Reference image = first image

    %Calculate displacements
    gridx_full = repmat(gridx,1,N_images);
    gridy_full = repmat(gridy,1,N_images);
    
    dispx = validx - gridx_full;
    dispy = validy - gridy_full; 
    
    
elseif ref_image == 2 %Reference image = previous image
    
    %Initialize empty vectors for the incremental displacement
    dispx_succ = zeros(size(validx));
    dispy_succ = zeros(size(validy));
    
    %Self-correlation of the first image
    dispx_succ(:,1) = validx(:,1) - gridx(:,1);
    dispy_succ(:,1) = validy(:,1) - gridy(:,1);
    
    %Calculate the displacements between each image
    for i = 2:N_images
        dispx_succ(:,i) = (validx(:,i) - validx(:,i-1));
        dispy_succ(:,i) = (validy(:,i) - validy(:,i-1));
    end
    
    %Calculate the total displacement from the reference image
    dispx = zeros(size(validx));
    dispy = zeros(size(validy));
    for i = 2:N_images
        sumx = zeros(N_pts,1);
        sumy = zeros(N_pts,1);
        for j = 1:i
            sumx = sumx + dispx_succ(:,j);
            sumy = sumy + dispy_succ(:,j);
        end
        
        dispx(:,i) = sumx;
        dispy(:,i) = sumy;
    end
    
    
end





