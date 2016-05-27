function bungee = bungee(m,v,t,c0)
g = 9.81;
i = 1;
ve = 1;
resultheader = ['      Iter   ', '   xr    ', '    ea    '];
result = zeros(1,3);
while ve >= .001
    v2 = sqrt((g * m) / c0) * tanh(sqrt((g * c0) / m) * t);
    dv2 = ((1 / sqrt((g * m) / c0)) * (-1 * g * m / (c0^2)) * tanh(sqrt((g * c0) / m) * t)) + (sqrt((g * m) / c0) * ((1 - (tan(sqrt((g * c0) / m) * t)^2)) * (1 / sqrt(16 * g * c0 / m)) * (16 * g / m)));
    c1 = c0 + ((v - v2) / dv2);
    ve = v2 / v;
    c0 = c1;
    ve = abs(v - v2) / v;
    result(i,1) = i;
    result(i,2) = v2;
    result(i,3) = ve;
    i = i + 1;
end
disp(resultheader);
disp(result);
end