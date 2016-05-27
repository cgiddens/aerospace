function [DU_avg_i,D2U_avg_i] = calc_strains_loop(i,dispx,dispy,N_Dim,N_Elem,...
    N_Node_Elem,N_Elem_Order,Elem_Node,Bhat,B2hat,N_Cluster,ind_center)

%Get the the displacements for the i'th image
U_i = [dispx(:,i),dispy(:,i)]; 


%Calculate the displacement gradients at each quadrature point of each
% element for image i
[DU_i,D2U_i] = strain_elem(N_Dim,N_Elem,N_Node_Elem,N_Elem_Order,Elem_Node,Bhat,B2hat,U_i); 


%Average the displacement gradients over the element
[DU_avg_i,D2U_avg_i] = strain_avg_Gauss_close_pts_center(...
        N_Cluster,DU_i,D2U_i,ind_center);