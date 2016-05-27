function linregproof = linregproof(n,y)
    yhat = 0;
    arg = 0;
    for i = 1:n
        yhat = yhat + (y(i)/n);
    end
    for i = 1:n
        arg = arg + (y(i) - yhat)^2;
    end
    err = sqrt(arg / (n - 1));
    yhat2 = 0;
    arg2 = 0;
    arg3 = 0;
    for i = 1:n
        arg2 = arg2 + (y(i)^2);
        arg3 = arg3 + y(i);
    end
    err2 = sqrt((arg2 - ((arg3^2)/n))/(n - 1));
    disp(err);
    disp(err2);
end