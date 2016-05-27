function rf = ecef2eci(r,GMST)

    i = 1;
    rf = zeros(3,1);
    while i <= size(r,2)
        rf(:,i) = R1(-GMST(i)) * r(:,i);
        i = i + 1;
    end
    
end