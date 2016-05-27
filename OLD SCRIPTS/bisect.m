function bisect = bisect(xorig,yorig,x1orig,xuorig,iterations)
x1 = find(xorig == x1orig);
xu = find(xorig == xuorig);
x = xorig(x1:xu);
y = yorig(x1:xu);
x1 = 1;
xu = length(x);
i = 1;
itemp = i;
mid = floor(xu/2);
midlength = mid;
sect = 2;
result = zeros(iterations,5);
resultheader = ['     Iter   ', '    x1    ', '    xu    ', '    xr    ', '    ea'];
result = [1, x(x1), x(xu), x(mid), x(mid)];
for n = 1:iterations
    while i < mid
        if (y(i)*y(i+1) < 0)
            sect = 1;
        end
        if y(i+midlength)*y(i+midlength+1) < 0
            sect = 2;
        end
        i = i + 1;
    end
    if sect == 1
        xu = mid;
        mid = floor((xu - x1) / 2);
        midlength = mid - x1;
        i = itemp;
    end
    if sect == 2
        x1 = mid;
        mid = mid + floor((xu - mid) / 2);
        i = x1;
        itemp = i;
        midlength = mid - x1;
    end
    result(n,1) = n;
    result(n,2) = x(x1);
    result(n,3) = x(xu);
    result(n,4) = x(mid);
    result(n,5) = x(mid);
end
for n = 1:iterations
    result(n,5) = abs(result(n,5) - x(mid)) / x(mid);
end
disp(resultheader);
disp(result);
end