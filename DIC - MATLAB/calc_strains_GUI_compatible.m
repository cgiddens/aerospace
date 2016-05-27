%This function calculates the strains based on the displacement derivatives

%This code assumes 2D data

function [small_strain,large_strain] = calc_strains_GUI_compatible(...
    DU,D2U)

%Get individual derivative components:
ux = DU(1:4:end,:); %dU/dx
vx = DU(2:4:end,:); %dV/dx
uy = DU(3:4:end,:); %dU/dY
vy = DU(4:4:end,:); %dV/dY

ux2 = D2U(1:6:end,:); %d2U/dx2
uxy = D2U(2:6:end,:); %d2U/dxdy
uy2 = D2U(3:6:end,:); %d2U/dy2
vx2 = D2U(4:6:end,:); %d2V/dx2
vxy = D2U(5:6:end,:); %d2V/dxdy
vy2 = D2U(6:6:end,:); %d2V/dy2

%Small strains (in %):
exx = ux*100;
exy = 1/2*(uy+vx)*100;
eyy = vy*100;
eeqv = sqrt(exx.^2 + eyy.^2 - exx.*eyy + 3*exy.^2);

small_strain.exx = exx;
small_strain.exy = exy;
small_strain.eyy = eyy;
small_strain.eeqv = eeqv;

%Large strains (in %):
Exx = (ux + 1/2*(ux.^2 + vx.^2))*100;
Exy = 1/2*(uy + vx + ux.*uy + vx.*vy)*100;
Eyy = (vy + 1/2*(vx.^2 + vy.^2))*100;
Eeqv = sqrt(Exx.^2 + Eyy.^2 - Exx.*Eyy + 3*Exy.^2);
% Eeqv = sqrt(Exx.^2 + Eyy.^2 + 2*Exy.^2);

large_strain.Exx = Exx;
large_strain.Exy = Exy;
large_strain.Eyy = Eyy;
large_strain.Eeqv = Eeqv;
