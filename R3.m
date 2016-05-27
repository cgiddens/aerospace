function rot = R3(angle)

x = angle;

rot = [cos(x),sin(x),0;-sin(x),cos(x),0;0,0,1];

end