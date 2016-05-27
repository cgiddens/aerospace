function rot = R1d(angle)

x = angle;

rot = [1,0,0;0,cosd(x),sind(x);0,-sind(x),cosd(x)];

end