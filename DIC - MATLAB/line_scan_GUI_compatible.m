%This function takes either the displacement data (dispx and dispy) OR the
%strain data (DU) and find the data points along the center lines of the
%images.

function line_scan_GUI_compatible(figpos,N_images,skip,param_line_scan)

%Get the line scan parameters:
grid_plot_scan = param_line_scan.grid_plot_scan;
data_scan = param_line_scan.data_scan;
x_label = param_line_scan.x_label;
y_label = param_line_scan.y_label;
plot_title_data = param_line_scan.plot_title_data;
plot_title_location = param_line_scan.plot_title_location;
plot_title_dir = param_line_scan.plot_title_dir;
plot_title_ROI_boundary = param_line_scan.plot_title_ROI_boundary;


%% Plot the requested data:

%Determine the scale to use for the plot:
a = min(min(data_scan));
b = max(max(data_scan));
range = [a,b];

%Define the style
style = '-*';
gray_interval = 1/N_images*skip;

%Create the figure
m = figure('units','pixels','OuterPosition',figpos);
N = 0;
linecolor = [0 0 0];
for i = 1:skip:N_images
    figure(m)
    plot(grid_plot_scan,data_scan(:,i),style,'color',linecolor)
    title({[plot_title_data,' along the ',plot_title_dir,' line ',...
        plot_title_location,' from ',plot_title_ROI_boundary,' of ROI '];...
        sprintf(' (Current image #: %1g)',i)},'fontsize',10,'fontweight','bold')
    xlabel(x_label,'fontsize',10,'fontweight','bold')
    ylabel(y_label,'fontsize',10,'fontweight','bold')
    set(gca,'fontsize',10)
    ylim(range)
    hold on
    try
        waitforbuttonpress
    catch
        return
    end
    N = N + gray_interval;
    linecolor = N*[1 1 1];
end
