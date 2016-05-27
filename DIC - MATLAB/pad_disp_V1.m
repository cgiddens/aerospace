%This function pads the disp matrices around the border, to reduce edge
%effects during the smoothing process.  It mirrors edge data over both the
%x-axis and the y-axis


function [dispx_padded,dispy_padded,N_row,N_col] = pad_disp_V1(N_row,N_col,...
    dispx_matrix,dispy_matrix,kernel_size,N_images_correlated)


%Pad disp matrices with double-reflection
dispx_padded = padarray(dispx_matrix,[kernel_size,kernel_size],NaN);
dispy_padded = padarray(dispy_matrix,[kernel_size,kernel_size],NaN);

[N_row_padded,N_col_padded,dummy] = size(dispx_padded);

for i = 1:kernel_size 
    
    %Pad the top rows
    row_i = dispx_matrix(i+1,:,:); %Row that will be reflected
    diff_values = row_i - dispx_matrix(1,:,:); %Difference in values between the row to be reflected and the top row
    mirror_values = dispx_matrix(1,:,:) - diff_values; %New values, reflected
    dispx_padded(kernel_size - i + 1,kernel_size + 1:end - kernel_size,:) = mirror_values; %Assign pad-values to the appropriate row in the padded array
    
    row_i = dispy_matrix(i+1,:,:);
    diff_values = row_i - dispy_matrix(1,:,:);
    mirror_values = dispy_matrix(1,:,:) - diff_values;
    dispy_padded(kernel_size - i + 1,kernel_size + 1:end - kernel_size,:) = mirror_values;
    
    %Pad the left columns
    col_i = dispx_matrix(:,i+1,:); %Col that will be reflected
    diff_values = col_i - dispx_matrix(:,1,:); %Difference in values between the col to be reflected and the left-most column
    mirror_values = dispx_matrix(:,1,:) - diff_values; %New values, reflected
    dispx_padded(kernel_size + 1:end - kernel_size,kernel_size - i + 1,:) = mirror_values; %Assign pad-values ot the appropriate column in the padded array
    
    col_i = dispy_matrix(:,i+1,:); %Col that will be reflected
    diff_values = col_i - dispy_matrix(:,1,:); %Difference in values between the col to be reflected and the left-most column
    mirror_values = dispy_matrix(:,1,:) - diff_values; %New values, reflected
    dispy_padded(kernel_size + 1:end - kernel_size,kernel_size - i + 1,:) = mirror_values; %Assign pad-values ot the appropriate column in the padded array
    
    %Pad the bottom rows
    row_i = dispx_matrix(end - kernel_size - 1 + i,:,:);
    diff_values = row_i - dispx_matrix(end,:,:);
    mirror_values = dispx_matrix(end,:,:) - diff_values;
    dispx_padded(N_row_padded - i + 1,kernel_size + 1:end - kernel_size,:) = mirror_values;
    
    row_i = dispy_matrix(end - kernel_size - 1 + i,:,:);
    diff_values = row_i - dispy_matrix(end,:,:);
    mirror_values = dispy_matrix(end,:,:) - diff_values;
    dispy_padded(N_row_padded - i + 1,kernel_size + 1:end - kernel_size,:) = mirror_values;
    
    %Pad the right columns
    col_i = dispx_matrix(:,end-kernel_size - 1 + i,:);
    diff_values = col_i - dispx_matrix(:,end,:);
    mirror_values = dispx_matrix(:,end,:) - diff_values;
    dispx_padded(kernel_size + 1:end - kernel_size,N_col_padded - i + 1,:) = mirror_values;
    
    col_i = dispy_matrix(:,end-kernel_size - 1 + i,:);
    diff_values = col_i - dispy_matrix(:,end,:);
    mirror_values = dispy_matrix(:,end,:) - diff_values;
    dispy_padded(kernel_size + 1:end - kernel_size,N_col_padded - i + 1,:) = mirror_values;
    
end


%Pad the corners by averaging the padding from both the rows and the
%columns
TL_row_x = zeros(kernel_size,kernel_size,N_images_correlated);
BL_row_x = zeros(kernel_size,kernel_size,N_images_correlated);
BR_row_x = zeros(kernel_size,kernel_size,N_images_correlated);
TR_row_x = zeros(kernel_size,kernel_size,N_images_correlated);
TL_col_x = zeros(kernel_size,kernel_size,N_images_correlated);
BL_col_x = zeros(kernel_size,kernel_size,N_images_correlated);
BR_col_x = zeros(kernel_size,kernel_size,N_images_correlated);
TR_col_x = zeros(kernel_size,kernel_size,N_images_correlated);

TL_row_y = zeros(kernel_size,kernel_size,N_images_correlated);
BL_row_y = zeros(kernel_size,kernel_size,N_images_correlated);
BR_row_y = zeros(kernel_size,kernel_size,N_images_correlated);
TR_row_y = zeros(kernel_size,kernel_size,N_images_correlated);
TL_col_y = zeros(kernel_size,kernel_size,N_images_correlated);
BL_col_y = zeros(kernel_size,kernel_size,N_images_correlated);
BR_col_y = zeros(kernel_size,kernel_size,N_images_correlated);
TR_col_y = zeros(kernel_size,kernel_size,N_images_correlated);

for i = 1:kernel_size
    
    %% Dispx:
    
    %Pad the top-left corner
    row_i = dispx_padded(kernel_size + i + 1,1:kernel_size,:); %Corner row that will be reflected
    diff_values = row_i - dispx_padded(kernel_size + 1,1:kernel_size,:); %Difference in values between the row to be reflected and the (original) top row
    mirror_values_row = dispx_padded(kernel_size + 1,1:kernel_size,:) - diff_values; %New values, reflected
    TL_row_x(kernel_size - i + 1,:,:) = mirror_values_row;
    
    col_i = dispx_padded(1:kernel_size,kernel_size + i + 1,:); %Corner col that will be reflected
    diff_values = col_i - dispx_padded(1:kernel_size,kernel_size + 1,:);
    mirror_values_col = dispx_padded(1:kernel_size,kernel_size + 1,:) - diff_values;
    TL_col_x(:,kernel_size - i + 1,:) = mirror_values_col;
    
    %Pad the bottom-left corner
    row_i = dispx_padded(end - kernel_size - i,1:kernel_size,:); %Corner row that will be reflected
    diff_values = row_i - dispx_padded(end - kernel_size,1:kernel_size,:); %Difference in values between the row to be reflected and the (original) bottom row
    mirror_values_row = dispx_padded(end - kernel_size,1:kernel_size,:) - diff_values; %New values, reflected
    BL_row_x(i,:,:) = mirror_values_row;
    
    col_i = dispx_padded(end - kernel_size + 1:end,kernel_size + 1 + i,:); %Corner col that will be reflected
    diff_values = col_i - dispx_padded(end - kernel_size + 1:end,kernel_size + 1,:);
    mirror_values_col = dispx_padded(end - kernel_size + 1:end,kernel_size + 1,:) - diff_values;
    BL_col_x(:,kernel_size - i + 1,:) = mirror_values_col;
    
    %Pad the bottom-right corner
    row_i = dispx_padded(end - kernel_size - i,end - kernel_size + 1:end,:); %Corner row that will be reflected
    diff_values = row_i - dispx_padded(end - kernel_size,end - kernel_size + 1:end,:); %Difference in values between the row to be reflected and the (original) bottom row
    mirror_values_row = dispx_padded(end - kernel_size,end - kernel_size + 1:end,:) - diff_values; %New values, reflected
    BR_row_x(i,:,:) = mirror_values_row;
    
    col_i = dispx_padded(end -kernel_size + 1:end,end - kernel_size - i,:); %Corner col that will be reflected
    diff_values = col_i - dispx_padded(end - kernel_size + 1:end,end - kernel_size,:);
    mirror_values_col = dispx_padded(end - kernel_size + 1:end,end - kernel_size,:) - diff_values;
    BR_col_x(:,i,:) = mirror_values_col;
    
    %Pad the top-right corner
    row_i = dispx_padded(kernel_size + i + 1,end - kernel_size + 1:end,:); %Corner row that will be reflected
    diff_values = row_i - dispx_padded(kernel_size + 1,end - kernel_size + 1:end,:); 
    mirror_values_row = dispx_padded(kernel_size + 1,end - kernel_size + 1:end,:) - diff_values; %New values, reflected
    TR_row_x(kernel_size - i + 1,:,:) = mirror_values_row;
    
    col_i = dispx_padded(1:kernel_size,end - kernel_size - i,:); %Corner col that will be reflected
    diff_values = col_i - dispx_padded(1:kernel_size,end - kernel_size,:);
    mirror_values_col = dispx_padded(1:kernel_size,end - kernel_size,:) - diff_values;
    TR_col_x(:,i,:) = mirror_values_col;
    
    %% Dispy:
    
    %Pad the top-left corner
    row_i = dispy_padded(kernel_size + i + 1,1:kernel_size,:); %Corner row that will be reflected
    diff_values = row_i - dispy_padded(kernel_size + 1,1:kernel_size,:); %Difference in values between the row to be reflected and the (original) top row
    mirror_values_row = dispy_padded(kernel_size + 1,1:kernel_size,:) - diff_values; %New values, reflected
    TL_row_y(kernel_size - i + 1,:,:) = mirror_values_row;
    
    col_i = dispy_padded(1:kernel_size,kernel_size + i + 1,:); %Corner col that will be reflected
    diff_values = col_i - dispy_padded(1:kernel_size,kernel_size + 1,:);
    mirror_values_col = dispy_padded(1:kernel_size,kernel_size + 1,:) - diff_values;
    TL_col_y(:,kernel_size - i + 1,:) = mirror_values_col;
    
    %Pad the bottom-left corner
    row_i = dispy_padded(end - kernel_size - i,1:kernel_size,:); %Corner row that will be reflected
    diff_values = row_i - dispy_padded(end - kernel_size,1:kernel_size,:); %Difference in values between the row to be reflected and the (original) bottom row
    mirror_values_row = dispy_padded(end - kernel_size,1:kernel_size,:) - diff_values; %New values, reflected
    BL_row_y(i,:,:) = mirror_values_row;
    
    col_i = dispy_padded(end - kernel_size + 1:end,kernel_size + 1 + i,:); %Corner col that will be reflected
    diff_values = col_i - dispy_padded(end - kernel_size + 1:end,kernel_size + 1,:);
    mirror_values_col = dispy_padded(end - kernel_size + 1:end,kernel_size + 1,:) - diff_values;
    BL_col_y(:,kernel_size - i + 1,:) = mirror_values_col;
    
    %Pad the bottom-right corner
    row_i = dispy_padded(end - kernel_size - i,end - kernel_size + 1:end,:); %Corner row that will be reflected
    diff_values = row_i - dispy_padded(end - kernel_size,end - kernel_size + 1:end,:); %Difference in values between the row to be reflected and the (original) bottom row
    mirror_values_row = dispy_padded(end - kernel_size,end - kernel_size + 1:end,:) - diff_values; %New values, reflected
    BR_row_y(i,:,:) = mirror_values_row;
    
    col_i = dispy_padded(end -kernel_size + 1:end,end - kernel_size - i,:); %Corner col that will be reflected
    diff_values = col_i - dispy_padded(end - kernel_size + 1:end,end - kernel_size,:);
    mirror_values_col = dispy_padded(end - kernel_size + 1:end,end - kernel_size,:) - diff_values;
    BR_col_y(:,i,:) = mirror_values_col;
    
    %Pad the top-right corner
    row_i = dispy_padded(kernel_size + i + 1,end - kernel_size + 1:end,:); %Corner row that will be reflected
    diff_values = row_i - dispy_padded(kernel_size + 1,end - kernel_size + 1:end,:); 
    mirror_values_row = dispy_padded(kernel_size + 1,end - kernel_size + 1:end,:) - diff_values; %New values, reflected
    TR_row_y(kernel_size - i + 1,:,:) = mirror_values_row;
    
    col_i = dispy_padded(1:kernel_size,end - kernel_size - i,:); %Corner col that will be reflected
    diff_values = col_i - dispy_padded(1:kernel_size,end - kernel_size,:);
    mirror_values_col = dispy_padded(1:kernel_size,end - kernel_size,:) - diff_values;
    TR_col_y(:,i,:) = mirror_values_col;
    
end
    
%Average the row and col pad values
TL_x = (TL_row_x + TL_col_x)/2;
BL_x = (BL_row_x + BL_col_x)/2;
BR_x = (BR_row_x + BR_col_x)/2;
TR_x = (TR_row_x + TR_col_x)/2;

TL_y = (TL_row_y + TL_col_y)/2;
BL_y = (BL_row_y + BL_col_y)/2;
BR_y = (BR_row_y + BR_col_y)/2;
TR_y = (TR_row_y + TR_col_y)/2;


%Assign pad-values to the appropriate row in the padded array
dispx_padded(1:kernel_size,1:kernel_size,:) = TL_x; 
dispx_padded(end - kernel_size + 1:end,1:kernel_size,:) = BL_x;
dispx_padded(end - kernel_size + 1:end,end - kernel_size + 1:end,:) = BR_x;
dispx_padded(1:kernel_size,end - kernel_size + 1:end,:) = TR_x;

dispy_padded(1:kernel_size,1:kernel_size,:) = TL_y; 
dispy_padded(end - kernel_size + 1:end,1:kernel_size,:) = BL_y;
dispy_padded(end - kernel_size + 1:end,end - kernel_size + 1:end,:) = BR_y;
dispy_padded(1:kernel_size,end - kernel_size + 1:end,:) = TR_y;
