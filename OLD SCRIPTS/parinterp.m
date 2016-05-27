function parinterp = parinterp(a,b,c)
    e = 1;
    i = 1;
    while e > .0001
        fa = -1.5 * (a^6) - (2 * (a^4)) + (12*a);
        fb = -1.5 * (b^6) - (2 * (b^4)) + (12*b);
        fc = -1.5 * (c^6) - (2 * (c^4)) + (12*c);
        xmax = b + .5 * ((fa - fb)*((c - b)^2) - (fc - fb)*((b - a)^2))/((fa - fb)*(c - b) + (fc - fb)*(b - a));
        if xmax < fb
            c = b;
            xtemp = c;
            b = xmax;
        elseif xmax > b
            a = b;
            xtemp = a;
            b = xmax;
        end
        e = abs(xtemp - xmax);
        i = i + 1;
    end
    fxmax = -1.5 * (xmax^6) - (2 * (xmax^4)) + (12*xmax);
    fprintf('Iterations: %g \nxmax: %g \nf(xmax): %g\n', i, xmax, fxmax);
end