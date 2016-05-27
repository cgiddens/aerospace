function wdot_w_thetadot = wdot_thetadot(t,w_theta)

    lambda = 14.25;
    mu = 0.1875;
    
    wdot1 = lambda * w_theta(2) + mu;
    wdot2 = -lambda * w_theta(1);
    wdot3 = 15;
    w_thetadot1 = (w_theta(1) * cos(w_theta(6)) - w_theta(2) * sin(w_theta(6))) / cos(w_theta(5));
    w_thetadot2 = w_theta(1) * sin(w_theta(6)) + w_theta(2) * cos(w_theta(6));
    w_thetadot3 = (-w_theta(1) * cos(w_theta(6)) + w_theta(2) * sin(w_theta(6))) * tan(w_theta(5)) + wdot3;
    
    wdot_w_thetadot = [wdot1 wdot2 wdot3 w_thetadot1 w_thetadot2 w_thetadot3]';
end