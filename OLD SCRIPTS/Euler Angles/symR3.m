function rot = symR3(angle)

x = sym(angle);

rot = [cos(x),-sin(x),0;sin(x),cos(x),0;0,0,1];

end