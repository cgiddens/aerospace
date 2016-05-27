function eul = quat2eul(q)
    
    %NOTE: THIS ONLY WORKS FOR 3-2-1 ROTATIONS

    q0 = q(1);
    q1 = q(2);
    q2 = q(3);
    q3 = q(4);
    
    eul(1,1) = atan2((q2*q3 + q0*q1), .5 - (q1^2 + q2^2));
    eul(2,1) = asin(-2*(q1*q3 - q0*q2));
    eul(3,1) = atan2((q1*q2 + q0*q3), .5 - (q2^2 + q3^2));
    
end