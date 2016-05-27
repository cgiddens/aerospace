function rot = R2(angle)

x = angle;

rot = [cos(x),0,-sin(x);0,1,0;sin(x),0,cos(x)];

end