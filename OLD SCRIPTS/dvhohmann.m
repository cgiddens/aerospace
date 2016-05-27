function dvhohmann = dvhohmann(ri,rfmin,rfmax,step)
    u = 398600.4419;
    vcs1 = sqrt(u / ri);
    fprintf('Orbital Ratio\t\tDelta-V (km/s)\n');
    figure
    hold on
    for r = rfmin:step:rfmax
        a = (ri + r) / 2;
        et = -u / (ri + r);
        v1 = sqrt(2 * ((u / ri) + et));
        dv1 = v1 - vcs1;
        vcs2 = sqrt(u / r);
        v2 = sqrt((((v1^2) / 2) - (u / ri) + (u / r)) * 2);
        dv2 = vcs2 - v2;
        dv = dv1 + dv2;
        ratio = r / ri;
        fprintf('%.4f\t\t\t\t%.5f\n',ratio,dv);
        plot(ratio,dv,'*r');
    end
    title('DVHohmann vs. R');
    xlabel('R');
    ylabel('Delta-V (km/s)');
end