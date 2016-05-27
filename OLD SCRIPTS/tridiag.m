function tridiag = tridiag(a,b)
    a = [a,b];
    for i = 2:1:(size(a,1))
        a(i,:) = a(i,:) - a(i-1,:)*(a(i,i-1)/a(i-1,i-1));
    end
    for i = (size(a,1)-1):-1:1
        a(i,:) = a(i,:) - a(i+1,:)*(a(i,i+1)/a(i+1,i+1));
    end
    x = zeros(size(b,1),1);
    for i = size(b,1):-1:1
        x(i) = a(i,end)/a(i,i);
    end
    disp(x);
end