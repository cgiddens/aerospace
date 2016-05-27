% This function creates a matrix that has a "box" structure

% Example 1:  [matrix] = box(3, 3, 3, 5, 5)
% values = [0.9987, 0.5000, 0.0013];
% matrix = ...
% 0.0013  0.0013  0.0013  0.0013  0.0013
% 0.0013  0.5000  0.5000  0.5000  0.0013
% 0.0013  0.5000  0.9987  0.5000  0.0013
% 0.0013  0.5000  0.5000  0.5000  0.0013
% 0.0013  0.0013  0.0013  0.0013  0.0013

% Example 2:  [matrix] = box(3, 1, 3, 5, 3)
% values = [0.9987, 0.5000, 0.0013];
% matrix = ...
% 0.0013  0.0013  0.0013
% 0.5000  0.5000  0.0013
% 0.9987  0.5000  0.0013
% 0.5000  0.5000  0.0013
% 0.0013  0.0013  0.0013

function [matrix_normalized] = normal_distribution(center_row,center_col,N,matrix_template)

%Get the size of the matrix:
[N_row,N_col] = size(matrix_template);

%Create the values that you will use to fill in the matrix, according to a
%normal distribution
values = normcdf(linspace(3,-3,N)); 

%Create a starting matrix of the correct size, with values of the "center"
%point
matrix = ones(N_row,N_col)*values(1);

% Fill in the matrix with the normally distributed values:
for i = 2:N
    top = center_row - (i - 1);
    bot = center_row + (i - 1);
    left = center_col - (i - 1);
    right = center_col + (i - 1);

    if top > 0
        matrix(top,:) = values(i);
    end
    
    if bot < N_row + 1
        matrix(bot,:) = values(i);
    end
    
    if left > 0
        matrix(:,left) = values(i);
    end
    
    if right < N_col + 1
        matrix(:,right) = values(i);
    end
    
end

%Replace the weight values with "0" where the matrix_template contains NaN:
indices = isnan(matrix_template);
matrix(indices) = 0;

%Normalize the weight values so they sum to 1
matrix_total = sum(sum(matrix));
matrix_normalized = matrix/matrix_total;