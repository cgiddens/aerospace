% CALCULATE DIRECTION COSINE MATRIX FROM
% PRINCIPAL AXIS OF ROTATION & ROTATION ANGLE
%----------------------------------------------
% Aerospace Engineering, UT Austin 2016
% Author: Calvin Giddens
%----------------------------------------------
% Variables:
%   axis:       Axis of rotation (3x1)
%   phi:        Angle of rotation (radians)
%
% Output:
%   C:          Direction Cosine Matrix
%----------------------------------------------

function C = rotprincipal(axis,phi)

    axis_u = axis./norm(axis);
    e1 = axis_u(1);
    e2 = axis_u(2);
    e3 = axis_u(3);
    sigma = (1 - cos(phi));
    C11 = ((e1^2)*sigma + cos(phi));
    C12 = e1*e2*sigma + e3*sin(phi);
    C13 = e1*e3*sigma - e2*sin(phi);
    C21 = e2*e1*sigma - e3*sin(phi);
    C22 = (e2^2)*sigma + cos(phi);
    C23 = e2*e3*sigma + e1*sin(phi);
    C31 = e3*e1*sigma + e2*sin(phi);
    C32 = e3*e2*sigma - e1*sin(phi);
    C33 = (e3^2)*sigma + cos(phi);
    C = [C11,C12,C13;C21,C22,C33;C31,C32,C33];

end