function dv_hohmann_bielliptic = dv_hohmann_bielliptic(r0,rfmin,rfmax,step)
    u = 398600.4419;
    vcs1 = sqrt(u / r0);
    fprintf('Orbital Ratio\t\tHohmann dV (km/s)\tBi-elliptic dV (km/s)\n');
    figure
    hold on
    for r = rfmin:step:rfmax
        et = -u / (r0 + r);
        v1 = sqrt(2 * ((u / r0) + et));
        dv1 = v1 - vcs1;
        vcs2 = sqrt(u / r);
        v2 = sqrt((((v1^2) / 2) - (u / r0) + (u / r)) * 2);
        dv2 = vcs2 - v2;
        dv = dv1 + dv2;
        ratio = r / r0;
        plot(ratio,dv,'*r');
        ri = 4 * r;
        a1 = (r0 + ri) / 2;
        a2 = (r + ri) / 2;
        dvb1 = sqrt((2*u/r0)-(u/a1)) - sqrt(u/r0);
        dvb2 = sqrt((2*u/ri)-(u/a2)) - sqrt((2*u/ri)-(u/a1));
        dvb3 = sqrt((2*u/r)-(u/a2)) - sqrt(u/r);
        dvb = dvb1 + dvb2 + dvb3;
        fprintf('%6f\t\t\t\t%.5f\t\t\t\t%.5f\n',ratio,dv,dvb);
        plot(ratio,dvb,'*b');
        if dv < dvb
            optimal = ratio;
        end
    end
    title('Delta-V: Hohmann Transfer vs. Bi-elliptic Transfer');
    xlabel('Orbital Ratio (rf/ri)');
    ylabel('Delta-V (km/s)');
    fprintf('Optimal ratio for bi-elliptic transfer: %.4f\n', optimal);
end