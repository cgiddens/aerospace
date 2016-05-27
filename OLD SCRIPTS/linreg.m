function [a1 a0] = linreg(x,y)
    if length(x) ~= length(y)
        disp('x and y must be of the same length!');
        return
    end
    n = length(x);
    a1arg1 = 0;
    a1arg2 = 0;
    a1arg3 = 0;
    a1arg4 = 0;
    xhat = 0;
    yhat = 0;
    for i = 1:n
        a1arg1 = a1arg1 + (x(i)*y(i));
        a1arg2 = a1arg2 + x(i);
        a1arg3 = a1arg3 + y(i);
        a1arg4 = a1arg4 + (x(i)^2);
        xhat = xhat + (x(i) / n);
        yhat = yhat + (y(i) / n);
    end
    a1 = (n*a1arg1 - a1arg2*a1arg3) / (n*a1arg4 - (a1arg2^2));
    a0 = yhat - a1 * xhat;
    %disp(a1);
    %disp(a0);
end