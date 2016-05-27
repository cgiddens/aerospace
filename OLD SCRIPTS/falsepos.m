function falseposition = falsepos(x,y,x1,xu)
endpoint1 = y(find(x == x1));
endpoint2 = y(find(x == xu));
deltax = xu - x1;
deltay = endpoint2 - endpoint1;
rootloc = endpoint1 / (deltay / deltax);
root = x1 + rootloc;
disp(root);
