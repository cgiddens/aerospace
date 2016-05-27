function eul = hw5p3(q)

    for i = 1:size(q,2)
        q0 = q(1,i);
        q1 = q(2,i);
        q2 = q(3,i);
        q3 = q(4,i);
    
        eul(1,i) = atan2((q2*q3 + q0*q1), .5 - (q1^2 + q2^2));
        eul(2,i) = asin(-2*(q1*q3 - q0*q2));
        eul(3,i) = atan2((q1*q2 + q0*q3), .5 - (q2^2 + q3^2));
    end
end
        