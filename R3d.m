function rot = R3d(angle)

x = angle;

rot = [cosd(x),sind(x),0;-sind(x),cosd(x),0;0,0,1];

end