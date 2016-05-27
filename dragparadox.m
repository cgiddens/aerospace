function [] = dragparadox(v_ini,r_ini,Cd,A1,A2,m,w,rho,tlength,tstep)

    %NOTE: FOR INITIALLY IDENTICAL CIRCULAR ORBITS ONLY
    %THE ONLY DIFFERENCE BETWEEN THE TWO SATELLITES IS SURFACE AREA

    u = 3.986004415*10^14;
    
    v1 = v_ini;
    v2 = v_ini;
    r1 = r_ini;
    r2 = r_ini;
    a1 = r_ini;
    a2 = r_ini;
    
    da1_tot = 0;
    da2_tot = 0;
    tvec1 = zeros(1,tlength / tstep);
    tvec2 = tvec1;
    t = tstep:tstep:tlength;
    
    for i = 1:(tlength/tstep - 1)
        
        vr1 = v1 - (w * r1);
        vr2 = v2 - (w * r2);
        fd1 = (Cd * A1 / m) * .5 * rho * vr1^2;
        fd2 = (Cd * A2 / m) * .5 * rho * vr2^2;
        da1 = -2 * (vr1 * a1^2 / u) * fd1;
        da2 = -2 * (vr2 * a2^2 / u) * fd2;
        
        da1_tot = da1_tot + da1;
        da2_tot = da2_tot + da2;
        
        tvec1(i) = da1_tot;
        tvec2(i) = da2_tot;
        
        v1 = vr1;
        r1 = r1 - da1;
        v2 = vr2;
        r2 = r2 - da2;
        
    end
    
    da_tot = da2_tot - da1_tot;
    fprintf('\nTotal separation: %f m\n', da_tot);
    
    close all
    figure
    subplot(2,1,1)
    plot(t,tvec1,'r')
    title('Drag Paradox - Single Day')
    hold on
    plot(t,tvec2,'g')
    legend('da (Satellite 1)','da (Satellite 2')
    subplot(2,1,2)
    plot(t,tvec2 - tvec1,'b')
    xlabel('Time (s)')
    ylabel('Separation (m)')
    legend('Separation')
    
end