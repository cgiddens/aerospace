function gs_trajectory = gs_trajectory()
    theta0 = 50;
    y0 = 1;
    v0 = 25;
    xl = 0;
    xu = 60;
    a = xl;
    b = xu;
    phi = 0.618;
    x2 = xl + phi*(xu - xl);
    x1 = x2 + phi*(xl - xu);
    i = 1;
    check1 = tand(theta0)*x1 - (9.81/(2*(v0^2)*(cosd(theta0)^2))*x1) + y0;
    check2 = tand(theta0)*x2 - (9.81/(2*(v0^2)*(cosd(theta0)^2))*x2) + y0;
    fprintf('Iteration\ty1\t\t\t\ty2\n');
    while (abs(xu - xl) / (b-a)) >= .01
        if check1 > check2
            xu = x2;
            x2 = x1;
            check2 = check1;
            x1 = phi*xl + (1-phi)*xu;
            check1 = tand(theta0)*x1 - (9.81/(2*(v0^2)*(cosd(theta0)^2))*x1) + y0;
            fprintf('%g\t\t\t%g\t\t\t%g\n', i, check1, check2);
            i = i + 1;
        else
            xl = x1;
            x1 = x2;
            check1 = check2;
            x2 = (1-phi)*xl + phi*xu;
            check2 = tand(theta0)*x2 - (9.81/(2*(v0^2)*(cosd(theta0)^2))*x2) + y0;
            fprintf('%g\t\t\t%g\t\t\t%g\n', i, check1, check2);
            i = i + 1;
        end;
    end
end