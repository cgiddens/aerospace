function newrap = newrap(x0)
    re = 1;
    xi = x0;
    header = ['   iteration', '    xi    ', '    re    '];
    n = 1;
    result = [1,x0,0];
    r = 2;
    L = 5;
    V = 8;
    while (abs(re)) > .08
        fx = ((((r^2) * acos((r - xi) / r) - (r - xi) * sqrt(2*r*xi - xi^2)) * L) - V);
        dfx = ((r^2 * -xi * (-1 / sqrt(1 - ((2 - xi) / 2)^2)) - ((r - xi) * (2*r*xi - xi^2)^(-1/2) * (2*r - 2*xi) - (-1) * sqrt(2*r*xi - xi^2)) * L) - V);
        x2 = xi - (fx / dfx);
        fx2 = ((((r^2) * acos((r - x2) / r) - (r - x2) * sqrt(2*r*x2 - x2^2)) * L) - V);
        re = abs((xi - x2) / xi);
        n = n + 1;
        result(n,1) = n;
        result(n,2) = x2;
        result(n,3) = re;
        xi = x2;
    end
    disp(header);
    disp(result);
end