function qout = multq(q1,q2)
    %q1vec = q1(2:4);
    %q2vec = q2(2:4);
    %qout(1) = q1(1)*q2(1) - dot(q1vec,q2vec);
    %qout(2:4,1) = q1(1)*q2vec + q2(1)*q1vec + cross(q1vec,q2vec);
    
    qout = [  q1(1)*q2(1) - q1(2)*q2(2) - q1(3)*q2(3) - q1(4)*q2(4); 
            q1(1)*q2(2) + q1(2)*q2(1) + q1(3)*q2(4) - q1(4)*q2(3);
            q1(1)*q2(3) - q1(2)*q2(4) + q1(3)*q2(1) + q1(4)*q2(2);
            q1(1)*q2(4) + q1(2)*q2(3) - q1(3)*q2(2) + q1(4)*q2(1);
           ];
    
end