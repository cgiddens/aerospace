function result = tdgen(n,upper,main,lower)
    result = zeros(n,n);
    for i = 1:n
        result(i,i) = main;
    end
    for i = 2:n
        result(i,i-1) = lower;
        result(i-1,i) = upper;
    end
    return