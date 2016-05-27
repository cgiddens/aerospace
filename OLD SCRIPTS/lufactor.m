function lufactor = lufactor(a,b)
    U = a;
    L = eye(size(a,1),size(a,2));
    for n = 1:1:size(U,2)
        for i = n:1:(size(U,1)-1)
            if U(i+1,n) ~= 0 && U(i,n) ~= 0
                elementary(i,1) = -(U(i+1,n)/U(i,n));
                elementary(i,2) = i+1;
                elementary(i,3) = n;
                U(i+1,:) = U(i+1,:) - U(i,:)*(U(i+1,n)/U(i,n));
            end
        end
    end
    for i = 1:1:(size(elementary,1))
        L(elementary(i,2),elementary(i,3)) = elementary(i,1);
    end
    c = L\b;
    x = U\c;
    disp(L);
    disp(U);
    return