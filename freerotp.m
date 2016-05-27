% SIMULATING FREE ROTATION ABOUT PRINCIPAL AXES
%----------------------------------------------
% Attitude Dynamics HW 10, Problem 1
% Aerospace Engineering, UT Austin 2016
% Author: Calvin Giddens
%----------------------------------------------
% Variables:
%   I1, I2, I3:     MOI around X, Y, & Z axes
%   w1i, w2i, w3i:  Initial angular velocities
%   tmax:           Duration of rotation
%
% NOTE: Time step is in 1 second increments.
%----------------------------------------------

function [] = freerotp(I1,I2,I3,w1i,w2i,w3i,tmax)

%Initiate matrices
t = [1:tmax];

%M1 = zeros(1,length(t));
%M2 = zeros(1,length(t));
%M3 = zeros(1,length(t));

w1 = zeros(1,length(t));
w2 = zeros(1,length(t));
w3 = zeros(1,length(t));

a = zeros(3,length(t));
%a1 = zeros(1,length(t));
%a2 = zeros(1,length(t));
%a3 = zeros(1,length(t));

H = zeros(3,length(t));
T = zeros(1,length(t));
I = [I1 0 0; 0 I2 0; 0 0 I3];

%Set initial values
w1(1) = w1i;
w2(1) = w2i;
w3(1) = w3i;

H(:,1) = I * [w1(1); w2(1); w3(1)];
T(1) = (1/2) * [w1(1); w2(1); w3(1)]' * I * [w1(1); w2(1); w3(1)];

for n = 2:tmax
    
    %NOT USED: Calculate moments about principal axes
%    M1(n) = (I1 * a1(n-1)) + (I3 - I2) * w2(n-1) * w3(n-1);
%    M2(n) = (I2 * a2(n-1)) + (I1 - I3) * w3(n-1) * w1(n-1);
%    M3(n) = (I3 * a3(n-1)) + (I2 - I1) * w1(n-1) * w2(n-1);
    
    %Calculate resultant angular acceleration
    w = [w1(n-1); w2(n-1); w3(n-1)];
    a(:,n-1) = inv(I) * cross(I*w,w);

    %NOT USED: Find acceleration due to moments
%    a1(n) = M1(n) / I1;
%    a2(n) = M2(n) / I2;
%    a3(n) = M3(n) / I3;

    %NOT USED: Calculate angular acceleration using Euler's equations
%    a1(n-1) = (-(I3 - I2) * w2(n-1) * w3(n-1)) / I1;
%    a2(n-1) = (-(I1 - I3) * w3(n-1) * w1(n-1)) / I2;
%    a3(n-1) = (-(I2 - I1) * w1(n-1) * w2(n-1)) / I3;

    %Account for resultant angular velocity
    w1(n) = w1(n-1) + a(1,n-1);
    w2(n) = w2(n-1) + a(2,n-1);
    w3(n) = w3(n-1) + a(3,n-1);
    
    %Calculate angular momentum
    w = [w1(n); w2(n); w3(n)];
    H(:,n) = I * w;
    
    %Calculate angular kinetic energy
    T(n) = (1/2) * w' * I * w;
end

%Plot results
close all
figure
subplot(3,1,1)
plot(t,w1)
hold on
plot(t,w2)
plot(t,w3)
legend('x','y','z')
xlabel('time (s)')
ylabel('angular velocity (m/s)')
title('Free Rotation About Principal Axes')
subplot(3,1,2)
plot(t,H)
xlabel('time (s)')
ylabel('angular momentum (kg*m^2/s)')
legend('x','y','z')
subplot(3,1,3)
plot(t,T)
xlabel('time (s)')
ylabel('rotational kinetic energy (J)')

end