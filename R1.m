function rot = R1(angle)

x = angle;

rot = [1,0,0;0,cos(x),sin(x);0,-sin(x),cos(x)];

end