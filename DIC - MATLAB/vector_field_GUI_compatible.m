function vector_field_GUI_compatible(figpos,quiver_param,N_images,skip,...
    dispx,dispy,scale,reduction)

qscale = quiver_param.qscale;
gridx = quiver_param.gridx*reduction;
gridy = quiver_param.gridy*reduction;
qskip = quiver_param.qskip;

m = figure('units','pixels','OuterPosition',figpos,'windowstyle','normal');
xmin = min(min(gridx)) - 0.1*max(max(gridx));
xmax = max(max(gridx)) + 0.1*max(max(gridx));
ymin = min(min(gridy)) - 0.1*max(max(gridy));
ymax = max(max(gridy)) + 0.1*max(max(gridy));

if scale == 1
    unit = '(pixels)';
else
    unit = '({\mu}m)';
end

for i = 1:skip:N_images
    figure(m)
    h = quiver(gridx(1:qskip:end,i),gridy(1:qskip:end,i),...
        dispx(1:qskip:end,i),dispy(1:qskip:end,i),0);
    hU = get(h,'UData');
    hV = get(h,'VData');
    set(h,'UData',qscale*hU,'VData',qscale*hV)
    axis ij
    axis([xmin xmax ymin ymax])
    axis equal
    title(['Vectorfield of displacements',sprintf(' (Current image #: %1g)',i)],...
        'fontsize',10,'fontweight','bold')
    xlabel(['X ',unit],'fontsize',10,'fontweight','bold')
    ylabel(['Y ',unit],'fontsize',10,'fontweight','bold')
    set(gca,'fontsize',10)
    try
        waitforbuttonpress
    catch
        return
    end
end
    
% set(gcf,'windowstyle','normal')