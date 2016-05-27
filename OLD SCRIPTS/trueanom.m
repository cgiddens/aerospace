function truanom = trueanom()
theta = 0;
a = input('Apogee: \n');
e = input('Eccentricity: \n');
dt = .01;
i = 1;
p = a + (1 - (e^2));
    while theta <= 7
        r = p / (1 + e * cos(theta));
        R(i) = r;
        theta = theta + dt;
        i = i + 1;
    end
theta = 0:.01:7;
plot(theta, R);
xlabel('True Anomaly (rad)');
ylabel('R (km)');
legend('a = 7000, e = 0', 'a = 7000, e = .5', 'a = 12000, e = .1', 'a = 1700, e = .9');
hold on
end