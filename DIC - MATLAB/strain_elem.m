%This function calculates the displacement gradients at the quadrature points of the element.  
% Note that the strains will be most accurate when computed at the
% quadrature points of the element, opposed to the nodes of the element.

% The output, DU, has the following form, where GQ = Gauss-Legendre
% Quadrature point:

%Linear element:
%           GQ1 (Center of element)
% Elem 1    du/dx
%           du/dy
%           dv/dx
%           dv/dy
% Elem 2    du/dx
%           du/dy
%           dv/dx
%           dv/dy
%   .
%   .
%   .

%Quadratic element:
%           GQ1     GQ2     GQ3     GQ4
% Elem 1    du/dx   du/dx   du/dx   du/dx
%           dv/dx   dv/dx   dv/dx   dv/dx
%           du/dy   du/dy   du/dy   du/dy
%           dv/dy   dv/dy   dv/dy   dv/dy
% Elem 2    du/dx   du/dx   du/dx   du/dx
%           dv/dx   dv/dx   dv/dx   dv/dx
%           du/dy   du/dy   du/dy   du/dy
%           dv/dy   dv/dy   dv/dy   dv/dy
%   .
%   .
%   .

%Cubic element:  similar to above, but with 9 GQ points


%The second output, D2U has the following form:

%Cubic element:
%          GQ1        GQ2         ...
% Elem 1   D2u/Dx2    D2u/Dx2    
%          D2u/DxDy   D2u/DxDy
%          D2u/Dy2    D2u/Dy2
%          D2v/Dx2    D2v/Dx2
%          D2v/DxDy   D2v/DxDy
%          D2v/Dy2    D2v/Dy2
% Elem 2   D2u/Dx2    D2u/Dx2    
%          D2u/DxDy   D2u/DxDy
%          D2u/Dy2    D2u/Dy2
%          D2v/Dx2    D2v/Dx2
%          D2v/DxDy   D2v/DxDy
%          D2v/Dy2    D2v/Dy2
%   .
%   .
%   .


function [DU,D2U] = strain_elem(N_Dim,N_Elem,N_Node_Elem,N_Elem_Order,Elem_Node,Bhat,B2hat,U)

N_GQ = N_Elem_Order^2; %Number of quad points in master element

dispx = U(:,1);
dispy = U(:,2);

%Get the u- and v-displacement values for all the element nodes, for all the
%elements
U_EN = dispx(Elem_Node); %N_Node_Elem x N_Elem
V_EN = dispy(Elem_Node);

%Combine the u- and v-displacements at element nodes into one grid
%          Elem1      Elem2    ...
% Node1 | u1   v1 |  u1   v1 |
% Node2 | u2   v2 |  u2   v2 |
%  .  
%  . 

UV_EN = zeros(N_Node_Elem,N_Elem*2);
UV_EN(:,1:2:end) = U_EN;
UV_EN(:,2:2:end) = V_EN;

% Recall form of Bhat':
%         Node1    Node2   ...
% GQ1  | DN1/Dx | DN2/Dx |
%      | DN1/Dy | DN2/Dy |
%       ----- -----
% GQ2  | DN1/Dx | DN2/Dx |
%      | DN1/Dy | DN2/Dy |
%       ----- -----
%  .
%  .

%Calculate the displacement gradients
DU_mat = Bhat'*UV_EN; % 2*N_GQ x 2*N_Elem 

%       Elem1   Elem2   ...
% GQ1 | ux vx | ux vx |
%     | uy vy | uy vy |
%      ------- -------
% GQ2 | ux vx | ux vx |
%     | uy vy | uy vy |
%      ------- -------
%  .
%  .

% Recall form of B2hat':
%          Node1       Node2     ...
% GQ1  | D2N1/Dx2  | D2N2/Dx2  |
%      | D2N1/DxDy | D2N2/DxDy |
%      | D2N1/Dy2  | D2N2/Dy2  |
%       ----------   ---------
% GQ2  | D2N1/Dx2  | D2N2/Dx2  |
%      | D2N1/DxDy | D2N2/DxDy |
%      | D2N1/Dy2  | D2N2/Dy2  |
%       ----------   ---------
%  .
%  .

D2U_mat = B2hat'*UV_EN; %3*N_GQ x 2*N_Elem

%             Elem1                Elem2          ...
%     | D2u/Dx2   D2v/Dx2  | D2u/Dx2   D2v/Dx2  | 
% GQ1 | D2u/DxDy  D2v/DxDy | D2u/DxDy  D2v/DxDy |
%     | D2u/Dy2   D2v/Dy2  | D2u/Dy2   D2v/Dy2  |
%      -------------------- --------------------
%     | D2u/Dx2   D2v/Dx2  | D2u/Dx2   D2v/Dx2  | 
% GQ2 | D2u/DxDy  D2v/DxDy | D2u/DxDy  D2v/DxDy |
%     | D2u/Dy2   D2v/Dy2  | D2u/Dy2   D2v/Dy2  |
%      -------------------- --------------------
%  .
%  .

%Rearrange format of DU_mat
DU = zeros(N_Elem*N_Dim^2,N_GQ);
m = 1;
for i = 1:N_GQ
    DU(1:4:end,i) = DU_mat(m,1:2:end);   %ux
    DU(2:4:end,i) = DU_mat(m,2:2:end);   %vx
    DU(3:4:end,i) = DU_mat(m+1,1:2:end); %uy
    DU(4:4:end,i) = DU_mat(m+1,2:2:end); %vy  
    m = m+2;
end

%Rearrange format of D2U_mat
if N_Dim == 1
    a = 1;
elseif N_Dim == 2
    a = 6;
elseif N_Dim == 3;
    a = 18;
end
D2U = zeros(N_Elem*a,N_GQ);
m = 1;
for i = 1:N_GQ
    D2U(1:6:end,i) = D2U_mat(m,1:2:end);   %D2u/Dx2
    D2U(2:6:end,i) = D2U_mat(m+1,1:2:end); %D2u/DxDy
    D2U(3:6:end,i) = D2U_mat(m+2,1:2:end); %D2u/Dy2
    D2U(4:6:end,i) = D2U_mat(m,2:2:end);   %Dv2/Dx2
    D2U(5:6:end,i) = D2U_mat(m+1,2:2:end); %Dv2/DxDy
    D2U(6:6:end,i) = D2U_mat(m+2,2:2:end); %Dv2/Dy2
    m = m+3;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For reference, the original nested for-loop chunk of code is below.  The
% above code, along with the end of the "FEM_strains_GUI_compatible" code
% replaces the below code.  Matrix multiplication above is MUCH faster than
% the for-loops below.

%
% Elem_Node = Elem_Node';
% 
% %Calculate du/dx, du/dy, dv/dx, dv/dy at each Gauss Quadrature point of each element
% DUS = zeros(N_Dim^2*N_Elem,N_Elem_Order^2); %Initialize empty vector for DU, the displacement gradients at each quadrature point of each element
% 
% m = 1; %Initialize the counter m
% for Elem = 1:N_Elem %Loop over the elements
%     
%     %Get the physical coordinates and displacements of the four nodes in
%     %element "Elem"
%     XY_El = zeros(N_Node_Elem,N_Dim); %Initialize empty vector for XY_El
%     U_El = zeros(N_Node_Elem,N_Dim); %Initialize empty vector for U_El
%     for i = 1:N_Node_Elem %Loop over the number of nodes in element "Elem"
%         
%         Node = Elem_Node(Elem,i); %Get the node number for the i'th node of the the "Elem"th element
%         XY_El(i,:) = Coords(Node,:); %Get the physical coordinates for the node "Node"
%         U_El(i,:) = U(Node,:); %Get the physical displacements for the node "Node"
%         
%     end
%     
%     %Calculate the displacement gradients at the four nodes of the "Elem"th
%     %element
%     N_Quad_Order = N_Elem_Order; %Set the quadrature order to the element order
%     
%     k = 1; %Initialize counter for the number of Gauss Quad points / the column of DU_El
%     
%     DU_El = zeros(N_Dim^2,N_Elem_Order^2); %Initialize an empty vector for DU_El
%     
%     for x_alpha = 1:N_Quad_Order %Loop through the number of quadrature points in the x-direction associated with quadrature order N_Quad_Order
%         for y_alpha = 1:N_Quad_Order %Loop through the number of quadrature points in the y-direction associated with quadrature order N_Quad_Order
%             
%            [r_x_alpha,w_x_alpha] = Gauss_Quad_OLD(N_Quad_Order,x_alpha); %Compute the "alpha"th quadrature point and corresponding weight in the x-direction
%            [r_y_alpha,w_y_alpha] = Gauss_Quad_OLD(N_Quad_Order,y_alpha); %Compute the "alpha"th quadrature piont and corresponding weight in the y-direction
%            r = [r_x_alpha,r_y_alpha]; %Combine the x- and y-components of the quadrature point into one vector
%         
%            [Nhat,DNhatS] = Shape_Funct_LH(N_Elem_Order,r); %Compute the shape functions at parent element node r
%            xy = Nhat' * XY_El; %Compute the physical coordinates at the parent element node r
%            JS = DNhatS' * XY_El; %Compute the Jacobian of the coordinate transformation
%            JinvS = JS^(-1); %Compute the inverse of the Jacobian
%            BhatS = DNhatS * JinvS; %Compute Bhat
% 
%            DU_r = BhatS' * U_El; %Compute the displacement gradients at parent element node r
%            DU_r_vec = vectorize(DU_r); %Transform the 2x2 matrix of displacement gradients into a vector [du/dx; du/dy; dv/dx; dv/dy]
% 
%            DU_El(:,k) = DU_r_vec; %Store the displacement gradients of parent element node r into the matrix of displacement gradients for element "Elem"
% 
%            
%            k = k + 1;
%         end
%     end
%     
%     %Store the displacement gradients for the "Elem"th element into the
%     %matrix of all displacement gradients DU
%     first = m; %starting row in DU for the "Elem"th element
%     last = m + N_Dim^2 - 1; %last row in DU for hte "Elem"th element
%     DUS(first:last,:) = DU_El; %Store element displacement gradients into big matrix
%     m = m + N_Dim^2; %Increment counter m
%     
% 
%     
% end
% 





