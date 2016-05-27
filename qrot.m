function qvq = qrot(q,v)

    qi = [q(1); -q(2); -q(3); -q(4)];
    v = vertcat(0,v);
    %qvec = q(2:4);
    %qivec = -q(2:4)';
    %vvec = v(2:4);
    %qv(1) = q(1)*v(1) - dot(qvec,vvec);
    %qv(2:4) = q(1)*vvec + v(1)*qvec + cross(qvec,vvec);
    %qvq(1) = qv(1)*qi(1) - dot(qv(2:4),qivec);
    %qvq(2:4) = qv(1)*qivec + qi(1)*qv(2:4) + cross(qv(2:4),qivec);
    
    qv = [  q(1)*v(1) - q(2)*v(2) - q(3)*v(3) - q(4)*v(4); 
            q(1)*v(2) + q(2)*v(1) + q(3)*v(4) - q(4)*v(3);
            q(1)*v(3) - q(2)*v(4) + q(3)*v(1) + q(4)*v(2);
            q(1)*v(4) + q(2)*v(3) - q(3)*v(2) + q(4)*v(1);
         ];
    qvq =[  qv(1)*qi(1) - qv(2)*qi(2) - qv(3)*qi(3) - qv(4)*qi(4); 
            qv(1)*qi(2) + qv(2)*qi(1) + qv(3)*qi(4) - qv(4)*qi(3);
            qv(1)*qi(3) - qv(2)*qi(4) + qv(3)*qi(1) + qv(4)*qi(2);
            qv(1)*qi(4) + qv(2)*qi(3) - qv(3)*qi(2) + qv(4)*qi(1);
         ];
    
    qvq = [qvq(2); qvq(3); qvq(4)];

end