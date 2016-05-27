function orbit_propagate = orbit_propagate(a,e,i,O,w,theta1,theta2,step)
    step = (step / 360) * 2 * pi;
    theta1 = (theta1 / 360) * 2 * pi;
    theta2 = (theta2 / 360) * 2 * pi;
    R = [(cosd(O)*cosd(w) - sind(O)*sind(w)*cosd(i)), (-1*cosd(O)*sind(w) - sind(O)*cosd(w)*cosd(i)), (sind(O)*sind(i)); 
        (sind(O)*cosd(w) + cosd(O)*sind(w)*cosd(i)), (-1*sind(O)*sind(w) + cosd(O)*cosd(w)*cosd(i)), (-1*cosd(O)*sind(i));
        (sind(w)*sind(i)), (cosd(w)*sind(i)), cosd(i)];
    n = 1;
    for t = theta1:step:theta2
        u = 398600;
        p = a*(1 - e^2);
        rmag = p / (1 + e*cos(t));
        r = [rmag*cos(t); rmag*sin(t); 0];
        dr = sqrt(u/p) * e * sin(t);
        rdtheta = sqrt(u/p) * (1 + e * cos(t));
        v = [(sqrt(u/p) * -1 * sin(t)); (sqrt(u/p) * (e + cos(t))); 0];   
        rperi(:,n) = r;
        vperi(:,n) = v;
        n = n + 1;
    end
        rgeo = R * rperi;
        vgeo = R * vperi;
        
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