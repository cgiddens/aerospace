function [x1] = jacobi(a,x0,b,it)
    xact = a\b;
    n = size(a,1);
    for j = 1:n
        x1(j) = ((b(j) - a(j,[1:j-1,j+1:n]) * x0([1:j-1,j+1:n])) / a(j,j));
    end
    x2 = x1';
    iter = 1;
    if nargin < 4 || isempty(it)
        while norm(x2 - x0, 1) > .000001
            for j = 1:n
                x3(j) = ((b(j) - a(j,[1:j-1,j+1:n]) * x2([1:j-1,j+1:n])) / a(j,j));
            end
            x0 = x2;
            x2 = x3';
            iter = iter + 1;
        end
    else while iter < it
            for j = 1:n
                x3(j) = ((b(j) - a(j,[1:j-1,j+1:n]) * x2([1:j-1,j+1:n])) / a(j,j));
            end
            x0 = x2;
            x2 = x3';
            iter = iter + 1;
        end
    end
    x1 = x2;
    %
    %disp(x1);
    %disp(iter);
end