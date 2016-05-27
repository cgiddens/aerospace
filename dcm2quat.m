function quat = dcm2quat(C)

    B0 = .5*sqrt(C(1,1) + C(2,2) + C(3,3) + 1);
    B1 = (C(2,3) - C(3,2)) / (4*B0);
    B2 = (C(3,1) - C(1,3)) / (4*B0);
    B3 = (C(1,2) - C(2,1)) / (4*B0);

    quat = [B0;B1;B2;B3];

end