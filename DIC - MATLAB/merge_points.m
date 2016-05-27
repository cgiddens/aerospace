function [gridx_patch_new,gridy_patch_new] = merge_points(gridx_patch,gridy_patch,Ny,Nx,x_matrix)


for i = 1:2
    
    if i==1
        grid_patch = gridx_patch;
    else
        grid_patch = gridy_patch;
    end
    
    %Fill in NaN values from deleted points and reshape grid into matrices
    ind_NUM = find(~isnan(x_matrix)); %Values that are NOT NaN
    ind_NaN = find(isnan(x_matrix)); %Values that ARE NaN
    
    grid1_NaN = zeros(Ny*Nx,1)*NaN;
    grid2_NaN = zeros(Ny*Nx,1)*NaN;
    grid3_NaN = zeros(Ny*Nx,1)*NaN;
    grid4_NaN = zeros(Ny*Nx,1)*NaN;
    
    grid1_NaN(ind_NUM) = grid_patch(1,:);
    grid2_NaN(ind_NUM) = grid_patch(2,:);
    grid3_NaN(ind_NUM) = grid_patch(3,:);
    grid4_NaN(ind_NUM) = grid_patch(4,:);

    
    %Reshape the patch coordinates
    grid1 = reshape(grid1_NaN,Ny,Nx);
    grid2 = reshape(grid2_NaN,Ny,Nx);
    grid3 = reshape(grid3_NaN,Ny,Nx);
    grid4 = reshape(grid4_NaN,Ny,Nx);

    %Pad the matrices with one row and column of NaN values:
    grid1_padded = [NaN(1,Nx);grid1;NaN(1,Nx)];
    grid1_padded = [NaN(Ny+2,1),grid1_padded,NaN(Ny+2,1)];

    grid2_padded = [NaN(1,Nx);grid2;NaN(1,Nx)];
    grid2_padded = [NaN(Ny+2,1),grid2_padded,NaN(Ny+2,1)];

    grid3_padded = [NaN(1,Nx);grid3;NaN(1,Nx)];
    grid3_padded = [NaN(Ny+2,1),grid3_padded,NaN(Ny+2,1)];

    grid4_padded = [NaN(1,Nx);grid4;NaN(1,Nx)];
    grid4_padded = [NaN(Ny+2,1),grid4_padded,NaN(Ny+2,1)];

    %Get average for point 1:
    grid1_shifted = grid1_padded(2:end-1,2:end-1);
    grid2_shifted = grid2_padded(1:end-2,2:end-1);
    grid3_shifted = grid3_padded(1:end-2,1:end-2);
    grid4_shifted = grid4_padded(2:end-1,1:end-2);

    grid_all1(:,:,1) = grid1_shifted;
    grid_all1(:,:,2) = grid2_shifted;
    grid_all1(:,:,3) = grid3_shifted;
    grid_all1(:,:,4) = grid4_shifted;

    grid_mean1 = nanmean(grid_all1,3);

    %Get average for point 2:
    grid1_shifted = grid1_padded(3:end,2:end-1);
    grid2_shifted = grid2_padded(2:end-1,2:end-1);
    grid3_shifted = grid3_padded(2:end-1,1:end-2);
    grid4_shifted = grid4_padded(3:end,1:end-2);

    grid_all2(:,:,1) = grid1_shifted;
    grid_all2(:,:,2) = grid2_shifted;
    grid_all2(:,:,3) = grid3_shifted;
    grid_all2(:,:,4) = grid4_shifted;

    grid_mean2 = nanmean(grid_all2,3);

    %Get average for point 3:
    grid1_shifted = grid1_padded(3:end,3:end);
    grid2_shifted = grid2_padded(2:end-1,3:end);
    grid3_shifted = grid3_padded(2:end-1,2:end-1);
    grid4_shifted = grid4_padded(3:end,2:end-1);

    grid_all3(:,:,1) = grid1_shifted;
    grid_all3(:,:,2) = grid2_shifted;
    grid_all3(:,:,3) = grid3_shifted;
    grid_all3(:,:,4) = grid4_shifted;

    grid_mean3 = nanmean(grid_all3,3);

    %Get average for point 4:
    grid1_shifted = grid1_padded(2:end-1,3:end);
    grid2_shifted = grid2_padded(1:end-2,3:end);
    grid3_shifted = grid3_padded(1:end-2,2:end-1);
    grid4_shifted = grid4_padded(2:end-1,2:end-1);

    grid_all4(:,:,1) = grid1_shifted;
    grid_all4(:,:,2) = grid2_shifted;
    grid_all4(:,:,3) = grid3_shifted;
    grid_all4(:,:,4) = grid4_shifted;

    grid_mean4 = nanmean(grid_all4,3);

    %Reshape and put back into original format
    grid_mean1_reshaped = reshape(grid_mean1,1,[]);
    grid_mean2_reshaped = reshape(grid_mean2,1,[]);
    grid_mean3_reshaped = reshape(grid_mean3,1,[]);
    grid_mean4_reshaped = reshape(grid_mean4,1,[]);
    
    %Remove values that are NaN:
    grid_mean1_reshaped(ind_NaN) = [];
    grid_mean2_reshaped(ind_NaN) = [];
    grid_mean3_reshaped(ind_NaN) = [];
    grid_mean4_reshaped(ind_NaN) = [];

    if i==1
        gridx_patch_new = [grid_mean1_reshaped; grid_mean2_reshaped; grid_mean3_reshaped; grid_mean4_reshaped];
    elseif i==2
        gridy_patch_new = [grid_mean1_reshaped; grid_mean2_reshaped; grid_mean3_reshaped; grid_mean4_reshaped];
    end
    
    
end



% %Reshape the patch vertices into a column vector
% gridx_col = reshape(gridx_patch,[],1);
% gridy_col = reshape(gridy_patch,[],1);
% 
% %Take only the first row of patch points (one corner of the square)
% gridx_one_corner = gridx_patch(1,:);
% gridy_one_corner = gridy_patch(1,:);
% 
% %Initialize the gridx_new and gridy_new  to start the same as the
% %original patch coordinates 
% gridx_new = gridx_col;
% gridy_new = gridy_col;
% 
% N_pts = length(gridx_one_corner);
% 
% %Set the threshold for "close" as step size/1.5 
% %Using "step" alone would cause the corners of the SAME square to merge!
% 
% thresh = step/1.5;
% 
% % for i = 1:N_pts
% %     
% %     ptx = gridx_one_corner(i);
% %     pty = gridy_one_corner(i);
% %     
% %     diffx = abs(gridx_col - ptx);
% %     diffy = abs(gridy_col - pty);
% %     
% %     diffxy = diffx+diffy;
% %     ind = find(diffxy<2*thresh);
% %     
% %     meanx = mean(gridx_col(ind));
% %     meany = mean(gridy_col(ind));
% %     
% %     gridx_new(ind) = meanx;
% %     gridy_new(ind) = meany;
% %     
% %     
% % end
% 
% 
% gridx_patch_new = reshape(gridx_new,4,[]);
% gridy_patch_new = reshape(gridy_new,4,[]);