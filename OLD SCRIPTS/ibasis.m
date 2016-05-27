function ibasis = ibasis(n)
    for m = 1:n
        result(m) = cos(2*pi*m/n) + i*sin(2*pi*m/n);
    end
    disp(result);
end