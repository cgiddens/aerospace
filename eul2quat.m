function quat = eul2quat(r1,r2,r3,seq)

if seq == '123'
    q1 = -sin(r1/2)*sin(r2/2)*sin(r3/2) + cos(r1/2)*cos(r2/2)*cos(r3/2);
    q2 = sin(r1/2)*cos(r2/2)*cos(r3/2) + sin(r2/2)*sin(r3/2)*cos(r1/2);
    q3 = -sin(r1/2)*sin(r3/2)*cos(r2/2) + sin(r2/2)*cos(r1/2)*cos(r3/2);
    q4 = sin(r1/2)*sin(r2/2)*cos(r3/2) + sin(r3/2)*cos(r1/2)*cos(r2/2);

elseif seq == '132'
    q1 = sin(r1/2)*sin(r2/2)*sin(r3/2) + cos(r1/2)*cos(r2/2)*cos(r3/2);
    q2 = sin(r1/2)*cos(r2/2)*cos(r3/2) - sin(r2/2)*sin(r3/2)*cos(r1/2);
    q3 = -sin(r1/2)*sin(r2/2)*cos(r3/2) + sin(r3/2)*cos(r1/2)*cos(r2/2);
    q4 = sin(r1/2)*sin(r3/2)*cos(r2/2) + sin(r2/2)*cos(r1/2)*cos(r3/2);

elseif seq == '121'
    q1 = cos(r2/2)*cos((r1 + r3)/2);
    q2 = cos(r2/2)*sin((r1 + r3)/2);
    q3 = sin(r2/2)*cos((r1 - r3)/2);
    q4 = sin(r2/2)*sin((r1 - r3)/2);

elseif seq == '131'
    q1 = cos(r2/2)*cos((r1 + r3)/2);
    q2 = cos(r2/2)*sin((r1 + r3)/2);
    q3 = -sin(r2/2)*sin((r1 - r3)/2);
    q4 = sin(r2/2)*cos((r1 - r3)/2);

elseif seq == '213'
    q1 = sin(r1/2)*sin(r2/2)*sin(r3/2) + cos(r1/2)*cos(r2/2)*cos(r3/2);
    q2 = sin(r1/2)*sin(r3/2)*cos(r2/2) + sin(r2/2)*cos(r1/2)*cos(r3/2);
    q3 = sin(r1/2)*cos(r2/2)*cos(r3/2) - sin(r2/2)*sin(r3/2)*cos(r1/2);
    q4 = -sin(r1/2)*sin(r2/2)*cos(r3/2) + sin(r3/2)*cos(r1/2)*cos(r2/2);

elseif seq == '231'
    q1 = -sin(r1/2)*sin(r2/2)*sin(r3/2) + cos(r1/2)*cos(r2/2)*cos(r3/2);
    q2 = sin(r1/2)*sin(r2/2)*cos(r3/2) + sin(r3/2)*cos(r1/2)*cos(r2/2);
    q3 = sin(r1/2)*cos(r2/2)*cos(r3/2) + sin(r2/2)*sin(r3/2)*cos(r1/2);
    q4 = -sin(r1/2)*sin(r3/2)*cos(r2/2) + sin(r2/2)*cos(r1/2)*cos(r3/2);

elseif seq == '212'
    q1 = cos(r2/2)*cos((r1 + r3)/2);
    q2 = sin(r2/2)*cos((r1 - r3)/2);
    q3 = cos(r2/2)*sin((r1 + r3)/2);
    q4 = -sin(r2/2)*sin((r1 - r3)/2);

elseif seq == '232'
    q1 = cos(r2/2)*cos((r1 + r3)/2);
    q2 = sin(r2/2)*sin((r1 + r3)/2);
    q3 = cos(r2/2)*sin((r1 + r3)/2);
    q4 = sin(r2/2)*cos((r1 - r3)/2);

elseif seq == '312'
    q1 = -sin(r1/2)*sin(r2/2)*sin(r3/2) + cos(r1/2)*cos(r2/2)*cos(r3/2);
    q2 = -sin(r1/2)*sin(r3/2)*cos(r2/2) + sin(r2/2)*cos(r1/2)*cos(r3/2);
    q3 = sin(r1/2)*sin(r2/2)*cos(r3/2) + sin(r3/2)*cos(r1/2)*cos(r2/2);
    q4 = sin(r1/2)*cos(r2/2)*cos(r3/2) + sin(r2/2)*sin(r3/2)*cos(r1/2);

elseif seq == '321'
    q1 = sin(r1/2)*sin(r2/2)*sin(r3/2) + cos(r1/2)*cos(r2/2)*cos(r3/2);
    q2 = -sin(r1/2)*sin(r2/2)*cos(r3/2) + sin(r3/2)*cos(r1/2)*cos(r2/2);
    q3 = sin(r1/2)*sin(r3/2)*cos(r2/2) + sin(r2/2)*cos(r1/2)*cos(r3/2);
    q4 = sin(r1/2)*cos(r2/2)*cos(r3/2) - sin(r2/2)*sin(r3/2)*cos(r1/2);

elseif seq == '313'
    q1 = cos(r2/2)*cos((r1 + r3)/2);
    q2 = sin(r2/2)*cos((r1 - r3)/2);
    q3 = sin(r2/2)*sin((r1 - r3)/2);
    q4 = cos(r2/2)*sin((r1 + r3)/2);

elseif seq == '323'
    q1 = cos(r2/2)*cos((r1 + r3)/2);
    q2 = -sin(r2/2)*sin((r1 - r3)/2);
    q3 = sin(r2/2)*cos((r1 - r3)/2);
    q4 = -cos(r2/2)*sin((r1 + r3)/2);
else
    fprintf('\nPlease enter a valid Euler rotation sequence. %s is not a valid sequence.\n\n', seq);
    clear quat;
    return
end

quat = [q1;q2;q3;q4];

end