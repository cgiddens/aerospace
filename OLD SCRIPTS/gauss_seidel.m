function x = gauss_seidel(A,x,B,it)
    C = A;
    for i = 1:size(A,1);
        C(i,i) = 0;
    end
    for j = 1:size(A,1)
        C(j,1:size(A,2)) = C(j,1:size(A,2)) / A(j,j);
    end
    for j = 1:size(A,2)
        D(j) = B(j) / A(j,j);
    end
    D = D';
    iter = 1;
    xprev = x;
    if nargin < 4 || isempty(it)
        while norm(x - xprev,1) > .000001
            xprev = x;
                x = D - C * xprev;
            iter = iter + 1;
        end
    else while iter < it
            xprev = x;
                x = D - C * xprev;
            iter = iter + 1;
        end
    end
    %disp(x);
    %disp(iter);
end