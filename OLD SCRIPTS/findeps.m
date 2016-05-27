function findepsilon = findeps()
ep = 1;
while ((1 + ep) > 1)
    ep = ep/2;
end
    ep = ep*2;
    disp(ep);
end