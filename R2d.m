function rot = R2d(angle)

x = angle;

rot = [cosd(x),0,-sind(x);0,1,0;sind(x),0,cosd(x)];

end