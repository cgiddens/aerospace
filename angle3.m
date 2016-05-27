% CALCULATE THE ANGLE BETWEEN TWO 3D VECTORS
%----------------------------------------------
% Aerospace Engineering, UT Austin 2016
% Author: Calvin Giddens
%----------------------------------------------
% Variables:
%   A, B:       3D vectors
%
% Output:
%   angle:      Angle between A & B (radians)
%----------------------------------------------

function angle = angle3(A,B)

    angle = atan2(norm(cross(A,B)),dot(A,B));

end