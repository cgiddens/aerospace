%This function uses the smoothing algorithm that the user decides to smooth
%the displacement data

function [dispx_smooth,dispy_smooth,smooth_setup] = smooth_disp(...
    smooth_setup,grid_param,corr_setup,...
    dispx,dispy,dispx_smooth_prev,dispy_smooth_prev,loop_type,N_threads)

%Get the smoothing algorithm from the smooth setup structure
smoothing_algorithm = smooth_setup.smoothing_algorithm;

if strcmp(smoothing_algorithm,'no smoothing'); %No smoothing is requested
    %Revised 140607:
    %If not smoothing, set smoothed displacements to empty
    dispx_smooth = [];
    dispy_smooth = [];
    
    %Original code:
%     if isempty(dispx_smooth_prev) %No previous smoothing
%         %Set the raw data as the smoothed data
%         dispx_smooth = dispx;
%         dispy_smooth = dispy;
%     else %dispx_smooth_prev is NOT empty-->Previous smoothing
%         %Set the previously smoothed data as the current smoothed data
%         dispx_smooth = dispx_smooth_prev;
%         dispy_smooth = dispy_smooth_prev;
%     end
       
elseif strcmp(smoothing_algorithm,'moving average') %Use my code for moving average
    
    %If the user has a new enough version of Matlab (i.e. 2014b), use
    %the version of smooth_moving_average that uses "scatteredInterpolant".
    % Otherwise, use the old version of padding the displacements and
    % smoothing the data.
    
    if exist('scatteredInterpolant')
        [dispx_smooth,dispy_smooth,smooth_setup] = smooth_moving_average_V2(smooth_setup,...
            grid_param,corr_setup,dispx,dispy,loop_type,N_threads);
    else
        warningstring = {'An older version of Matlab, which does not support the function "scatteredInterpolant" was detected.','',...
            'Therefore, an older version of smoothing the displacements, which is known to induce inaccuracies near the borders of the ROI when large displacements are present, is being used.','',...
            'For the most up-to-date smoothing algorithm, please use Matlab R2014b.'};
        dlgname = 'Old Version of Matlab';
        h = warndlg(warningstring,dlgname);
        waitfor(h)
        
        [dispx_smooth,dispy_smooth,smooth_setup] = smooth_moving_average_V1(...
            smooth_setup,grid_param,corr_setup,dispx,dispy,loop_type,N_threads);
        
    end
end