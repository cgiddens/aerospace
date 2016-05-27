%This function plots the averaged DIC data

function data_avg_GUI_compatible(figpos,param_disp_avg)

%Get the average parameters
data_avg = param_disp_avg.data_avg;
data_std = param_disp_avg.data_std;
data_min = param_disp_avg.data_min;
data_max = param_disp_avg.data_max;
x = param_disp_avg.x;
plot_title = param_disp_avg.plot_title;
y_label = param_disp_avg.y_label;
x_label = param_disp_avg.x_label;

%% Plot the requested data:

%Create the figure
m = figure('units','pixels','OuterPosition',figpos);
plot(x,data_avg,'*-')
hold on
plot(x,data_min,'k-.')
plot(x,data_max,'k-.')
title(plot_title,'fontsize',10,'fontweight','bold')
ylabel(y_label,'fontsize',10,'fontweight','bold')
xlabel(x_label,'fontsize',10,'fontweight','bold')
set(gca,'fontsize',10)
legend('Average data','Min','Max')

