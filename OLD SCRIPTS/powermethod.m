function powermethod = powermethod(A,x0,tol)
    err = 1;
    nval = 20;
    x = x0;
    while err > tol
        x1 = A * x;
        err = abs(norm(x) - nval);
        nval = norm(x);
        x = x1 / nval;
    end
    err2 = 1;
    nval2 = 20;
    x2 = x0;
    A2 = inv(A);
    while err2 > tol
        x3 = A2 * x2;
        err2 = abs(norm(x2) - nval2);
        nval2 = norm(x2);
        x2 - x3 / nval2;
    end
    x2 = 1 / x2;
    x = x';
    fprintf('Lambda\t\t\t\t\t\tEigenvector\n------\t\t\t\t\t\t-----------\n');
    fprintf('%8f\t\t\t[%1.6f\t%1.6f\t%1.6f]\n',nval,x(1,:));
    fprintf('%8f\t\t\t[%f\t%1.6f\t%1.6f]\n',nval2,x2(1,:));
end