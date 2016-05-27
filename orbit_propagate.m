function [r_ecef v_ecef t_] = orbit_propagate_perturb(a,e,i,O,dO,w,dw,theta1,theta2,step,dM)

    %EVERYTHING IN DEGREES
    
    u = 3.986004415*10^14;
    E0 = acosd((e + cosd(theta1))/(1 + (e*cosd(theta1))));
    n_ = sqrt(u / a^3);
    
    rgeo = zeros(3,theta2/step + 1);
    vgeo = zeros(3,theta2/step + 1);
    t = theta1;
    n = 1;
%    for t = theta1:step:theta2
    while t < theta2
        
        R = [(cosd(O + ((n - 1)*dO))*cosd(w + ((n - 1)*dw)) - sind(O + ((n - 1)*dO))*sind(w + ((n - 1)*dw))*cosd(i)), (-1*cosd(O + ((n - 1)*dO))*sind(w + ((n - 1)*dw)) - sind(O + ((n - 1)*dO))*cosd(w + ((n - 1)*dw))*cosd(i)), (sind(O + ((n - 1)*dO))*sind(i)); 
        (sind(O + ((n - 1)*dO))*cosd(w + ((n - 1)*dw)) + cosd(O + ((n - 1)*dO))*sind(w + ((n - 1)*dw))*cosd(i)), (-1*sind(O + ((n - 1)*dO))*sind(w + ((n - 1)*dw)) + cosd(O + ((n - 1)*dO))*cosd(w + ((n - 1)*dw))*cosd(i)), (-1*cosd(O + ((n - 1)*dO))*sind(i));
        (sind(w + ((n - 1)*dw))*sind(i)), (cosd(w + ((n - 1)*dw))*sind(i)), cosd(i)];
        
        k = floor(t / 360);
        p = a*(1 - e^2);
        rmag = p / (1 + e*cosd(t));
        r = [rmag*cosd(t); rmag*sind(t); 0];
        dr = sqrt(u/p) * e * sind(t);
        rdtheta = sqrt(u/p) * (1 + e * cosd(t));
        v = [(sqrt(u/p) * -1 * sind(t)); (sqrt(u/p) * (e + cosd(t))); 0];
        E = acosd((e + cosd(t))/(1 + (e*cosd(t))));
        t_(n) = sqrt((a^3)/(3.986004415*10^14)) * ((2*k*pi) + (E - (e*sind(E))) - (E0 - (e*sind(E0))));
        rperi(:,n) = r;
        vperi(:,n) = v;
        n = n + 1;
        t = t + step;
        
        rgeo(1,n) = R * rperi(1,n);
        vgeo(1,n) = R * vperi(1,n);
        rgeo(2,n) = R * rperi(2,n);
        vgeo(2,n) = R * vperi(2,n);
        rgeo(3,n) = R * rperi(3,n);
        vgeo(3,n) = R * vperi(3,n);
        
    end
        
        
        r_ecef = rgeo / 1000;
        v_ecef = vgeo;
        
        figure
        plot3(rgeo(1,:), rgeo(2,:), rgeo(3,:), '-*b');
        hold on
        plot3(0,0,0,'Og');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title('Position Vector');
        
        figure
        plot3(vgeo(1,:), vgeo(2,:), vgeo(3,:), '-*r');
        hold on
        plot3(0,0,0,'Og');
        title('Velocity Vector');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
end