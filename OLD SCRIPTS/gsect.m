function gsect = gsect(x,y,x1,x2)
    e = floor((x2 - x1) / 2);
    mid = e;
    i = 1;
    while e >= .0001
        t = mid - e;
        y1 = -1.5 * (t^6) - (2 * (t^4)) + (12*t);
        t = mid + e;
        y2 = -1.5 * (t^6) - (2 * (t^4)) + (12*t);
        if y1 > y2
            e = e / 2;
            mid = mid - e;
            ymax = y1;
        end
        if y2 > y1
            e = e / 2;
            mid = mid + e;
            ymax = y2;
        end
        i = i + 1;
    end
    fprintf('Iterations: %g \nxmax: %g \nf(xmax): %g\n', i, mid, ymax);
end