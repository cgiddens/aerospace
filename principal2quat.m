function quat = principal2quat(axis,phi)

    axis_u = axis./norm(axis);
    B0 = cos(phi/2);
    B1 = axis_u(1)*sin(phi/2);
    B2 = axis_u(2)*sin(phi/2);
    B3 = axis_u(3)*sin(phi/2);

    quat = [B0;B1;B2;B3];

end