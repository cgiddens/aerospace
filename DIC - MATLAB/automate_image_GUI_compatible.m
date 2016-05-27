%This code shifts the control points specified by gridx and gridy by
%computing the normalized cross-correlation coefficient.

function [validx,validy,corr_coeff]=automate_image_GUI_compatible(filenamelist,...
    reduction,gridx,gridy,ref_image,subset,search_zone,N_images_correlated,...
    N_pts,initialx,initialy,N_threads,loop_type,thresh)

%Transform the subset value from ODD (which is the size the subset really
%will be) to EVEN (which is what's needed to feed into the "imcrop" in
%order to get an ODD sized subset
subset = subset-1;

%Initialize variables:
validx = zeros(N_pts,N_images_correlated);
validy = zeros(N_pts,N_images_correlated);
validx(:,1) = gridx;
validy(:,1) = gridy;
corr_coeff = zeros(N_pts,N_images_correlated);


% Initialize the JAVA progress bar
try % Initialization
    percent = 1;
    do_debug = 1;
    ppm = ParforProgressStarter2('Correlate Images Progress Bar', ...
        N_images_correlated, percent, do_debug);
catch me % make sure "ParforProgressStarter2" didn't get moved to a different directory
    if strcmp(me.message, 'Undefined function or method ''ParforProgressStarter2'' for input arguments of type ''char''.')
        error('ParforProgressStarter2 not in path.');
    else
        % this should NEVER EVER happen.
        msg{1} = 'Unknown error while initializing "ParforProgressStarter2":';
        msg{2} = me.message;
        print_error_red(msg);
        % backup solution so that we can still continue.
        ppm.increment = nan(1, N_images_correlated);
    end
end


% Choose serial or parallel loop and run through the loop over the images
if strcmp(loop_type,'serial') == 1 %Use serial loops
[validx, validy,corr_coeff] = serial(filenamelist,reduction,gridx,gridy,...
    validx,validy,corr_coeff,ref_image,subset,search_zone,N_images_correlated,N_pts,...
    initialx,initialy,ppm,thresh);

elseif strcmp(loop_type,'parallel') == 1 %Use parallel loops
[validx,validy,corr_coeff] = parallel(filenamelist,reduction,gridx,gridy,...
    validx,validy,corr_coeff,subset,search_zone,N_images_correlated,N_pts,N_threads,...
    initialx,initialy,ppm,thresh);

end

%Close the wait bar
try % use try / catch here, since delete(struct) will raise an error.
    delete(ppm);
catch me %#ok<NASGU>
end


end


%% This function uses a serial for loop to run through the images
function [validx,validy,corr_coeff] = serial(filenamelist,reduction,gridx,gridy,...
    validx,validy,corr_coeff,ref_image,subset,search_zone,N_images_correlated,N_pts,...
    initialx,initialy,ppm,thresh)
    

for i=1:N_images_correlated %Loop over all the images in the set

    
    %% Read in the reference image
    if ref_image == 1 %Reference image = first image

        base_points = zeros(N_pts,2);
        base_points(:,1) = gridx;
        base_points(:,2) = gridy;

        if reduction ~= 1
            base = imresize(imread(filenamelist(1,:)),1/reduction);
        else
            base = imread(filenamelist(1,:));
        end


    elseif ref_image == 2 %Reference image = preceeding image

        if i == 1 %Self correlation of the first image with itself
            if reduction ~= 1
                base = imresize(imread(filenamelist(1,:)),1/reduction);
            else
                base = imread(filenamelist(1,:));
            end

            base_points = zeros(N_pts,2);
            base_points(:,1) = gridx;
            base_points(:,2) = gridy;

        else %Correlation of further images
            if reduction ~= 1
                base = imresize(imread(filenamelist(i-1,:)),1/reduction);
            else
                base = imread(filenamelist(i-1,:));
            end

            %Set the base points as the correlated points from the previous
            %correlation
            base_points = zeros(N_pts,2);
            base_points(:,1) = validx(:,i-1);
            base_points(:,2) = validy(:,i-1);
            
        end

    end


    %% Run through the part of the loop common to both serial and parallel loops

    [validx_i,validy_i,corr_coeff_i] = cpcorr_loop(filenamelist, reduction,... 
        subset,search_zone,base_points,base,N_pts,initialx,initialy,i,thresh);

    %Store the validx_i and validy_i into the appropriate column of validx and
    %validy
    validx(:,i) = validx_i;
    validy(:,i) = validy_i;
    
    %Store the correlation coefficients:
    corr_coeff(:,i) = corr_coeff_i;

    %Mark that an image has been correlated
    ppm.increment(i);
    
end  
 
end


%% This function uses parallel for loop (parfor) to run through the images
function [validx,validy,corr_coeff] = parallel(filenamelist,reduction,gridx,gridy,...
    validx,validy,corr_coeff,subset,search_zone,N_images_correlated,N_pts,N_threads,...
    initialx,initialy,ppm,thresh)

%% Reference image is always the first image of the set
base_points = zeros(N_pts,2);
base_points(:,1) = gridx;
base_points(:,2) = gridy;

if reduction ~= 1
    base = imresize(imread(filenamelist(1,:)),1/reduction);
else
    base = imread(filenamelist(1,:));
end


parfor (i=1:N_images_correlated,N_threads) %Loop over all the images in the set
    
    %% Run through the part of the loop common to both serial and parallel loops
    [validx_i,validy_i,corr_coeff_i] = cpcorr_loop(filenamelist, reduction,... 
        subset,search_zone,base_points,base,N_pts,initialx,initialy,i,thresh);

    %Store the validx_i and validy_i into the appropriate column of validx and
    %validy
    validx(:,i) = validx_i;
    validy(:,i) = validy_i;
    
    %Store the correlation coefficients:
    corr_coeff(:,i) = corr_coeff_i;

    %Mark that an image has been correlated
    ppm.increment(i);

end



end


%% This function is common to both types of for-loops
function [validx_i,validy_i,corr_coeff_i] = cpcorr_loop(filenamelist, reduction,... 
    subset,search_zone,base_points,base,N_pts,initialx,initialy,i,thresh)

%Read in the image to be correlated
if reduction ~= 1
    input = imresize(imread(filenamelist(i,:)),1/reduction);

else %reduction == 1
    input = imread(filenamelist(i,:));

end

%Adjust the input points by the average reduced displacements
input_points = zeros(N_pts,2);
input_points(:,1) = base_points(:,1) + initialx(:,i);
input_points(:,2) = base_points(:,2) + initialy(:,i);

%Correlate the i'th image with the base image using cpcorr
[shifted_points,corr_coeff_i] = cpcorr_mod(input_points, base_points, ...
    input, base, subset,search_zone(:,i),thresh);

%Store results in the validx and validy matrices
validx_i = shifted_points(:,1);
validy_i = shifted_points(:,2);

end
