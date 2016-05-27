function rot = symR1(angle)

x = sym(angle);

rot = [1,0,0;0,cos(x),-sin(x);0,sin(x),cos(x)];

end