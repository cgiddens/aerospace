function fpi2 = fpi2(x)
    re = 1;
    i = 1;
    fprintf('Iteration\t\txi\t\t\t\txi+1\t\t\t\tre\n');
    while re >= .001
        x1 = exp(-x);
        re = abs((x1 - x) / x1);
        fprintf('%3d\t\t\t%g\t\t\t%g\t\t\t%g\n',i,x,x1,re);
        x = x1;
        i = i + 1;
    end