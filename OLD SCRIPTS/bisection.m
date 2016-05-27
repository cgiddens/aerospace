function bisection = bisection(x,y,a1,b1)
        x1 = find(x == a1);
        xu = find(x == b1);
        mid = (x1 + xu)/2;
        resultheader = ['     Iter   ', '    x1    ', '    xu    ', '    xr    ', '    ea'];
        result = [1, x(x1), x(xu), x(mid), x(mid)];
        if (abs(y(mid)) <= .001)
            root = mid;
            return;
        else
            i = 0;           
            while (abs(y(mid)) >= .001)
                i = i + 1;
                mid = floor((x1 + xu)/2);
                if(y(x1)*y(mid) > 0)
                    x1 = mid;
                else
                    xu = mid;
                end
   x             result(i+1,1) = i+1;
                result(i+1,2) = x(x1);
                result(i+1,3) = x(xu);
                result(i+1,4) = x(mid);
                result(i+1,5) = x(mid);

            end
            root = mid;
        end
        for n = 1:i
            result(n+1,5) = abs(result(n+1,5) - x(mid)) / x(mid);
        end
    disp(resultheader);
    disp(result);
end
