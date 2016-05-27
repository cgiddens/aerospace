% Inputs:
% u = gravitational parameter of planet
% a = semi-major axis of planet
%
% Output:
% SOI = radius of planet's sphere of influence

function [soi] = SOI(u,a)

us = 132172000000;

soi = (2^(-1/5)) * ((u/us)^(2/5)) * a;

fprintf('SOI = %f km\n', soi); 

end