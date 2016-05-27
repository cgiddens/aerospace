%This function setups up the full grid information for the correlation process

function [gridx,gridy,grid_setup] = grid_setup_fun(grid_setup,gridx,gridy,...
    full_grid_selection,full_grid_message,reduction_full)

 %The user doesn't want to define a new full grid AND there is already a
 %grid in the working folder
if strcmp(full_grid_selection,'No') && ~isempty(grid_setup)
   
    %Do nothing
   
   
%The user wishes to define a new full grid OR there is no grid in the
%working directory
elseif strcmp(full_grid_selection,'Yes') || isempty(grid_setup)
    
    if full_grid_message == 1 %Message box only if the user defined a reduced grid
        msgboxwicon = msgbox('Define grid for full image size.');
        waitfor(msgboxwicon)
    end

    [gridx,gridy,grid_setup] = grid_generator_GUI_compatible_3(reduction_full);

end