function [p_axis,phi] = dcm2principal(C)

    [eig_vec, eig_val] = eig(C);
    
    for i = 1:3
        quit = 0;
        if quit == 0 && abs((real(eig_val(1,i)) + real(eig_val(2,i)) + real(eig_val(3,i))) - 1) <= .001
            quit = 1;
            column = i;
            break;
        end
        if quit == 1
            break;
        end
    end
    
    p_axis = eig_vec(:,column);
    phi = acos(.5 * (C(1,1) + C(2,2) + C(3,3) - 1));

end