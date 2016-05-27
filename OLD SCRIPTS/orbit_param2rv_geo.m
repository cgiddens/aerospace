function orbit_param2rv_geo = orbit_param2rv_geo(a,e,i,O,w,theta)
    u = 398600;
    p = a*(1 - e^2);
    rmag = p / (1 + e*cosd(theta));
    r = [rmag*cosd(theta); rmag*sind(theta); 0];
    dr = sqrt(u/p) * e * sind(theta);
    rdtheta = sqrt(u/p) * (1 + e * cosd(theta));
    v = [(sqrt(u/p) * -1 * sind(theta)); (sqrt(u/p) * (e + cosd(theta))); 0];
    R = [(cosd(O)*cosd(w) - sind(O)*sind(w)*cosd(i)), (-1*cosd(O)*sind(w) - sind(O)*cosd(w)*cosd(i)), (sind(O)*sind(i)); 
        (sind(O)*cosd(w) + cosd(O)*sind(w)*cosd(i)), (-1*sind(O)*sind(w) + cosd(O)*cosd(w)*cosd(i)), (-1*cosd(O)*sind(i));
        (sind(w)*sind(i)), (cosd(w)*sind(i)), cosd(i)];     
    rgeo = R * r;
    vgeo = R * v;
    disp(rgeo);
    disp(vgeo);
end

