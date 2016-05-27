function fpi = fpi(m,v,t,c0)
    g = 9.81;
    i = 1;
    ve = 1;
    resultheader = ['      Iter   ', '   xr    ', '    ea    '];
    result = zeros(1,3);
    while ve >= .001
        c1 = ((sqrt(g * m) / v) * tanh(sqrt((g * c0) / m) * t))^2;
        c0 = c1;
        v2 = sqrt((g * m) / c0) * tanh(sqrt((g * c0) / m) * t);
        ve = abs(v2 - v) / v;
        result(i,1) = i;
        result(i,2) = c0;
        result(i,3) = ve;
        i = i+1;
    end
    disp(resultheader);
    disp(result);
end