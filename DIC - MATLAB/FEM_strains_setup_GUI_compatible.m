%This function uses the grid information from the DIC correlation and
%generates a mesh to be used for FEM strain calculations

%The DIC grid must be flat at the top (i.e. all nodes must have the same
%y-value) for this code to work.  The bottom of the grid, however, can be
%stair-stepped.

% Note that the origin in images is the top-left corner, with the positive
% x-axis to the right and the positive y-axis going DOWN.  This is a
% left-handed system.  DO NOT USE this code with a normal coordinate
% system!

%Nodes are numbered starting at the top left of the mesh and then go down
%first and to the right second.  Elements are numbered in the same fashion.

%Linear elements:
% 01 **** 04 **** 08 **** 13 **** 18
% **  01  **  03  **  06  **  10  **
% 02 **** 05 **** 09 **** 14 **** 19
% **  02  **  04  **  07  **  11  **
% 03 **** 06 **** 10 **** 15 **** 20
%         **  05  **  08  **  12  **
%         07 **** 11 **** 16 **** 21
%                 **  09  **  13  **
%                 12 **** 17 **** 22


%In a given element, the node ordering is as follows:

%Linear element
%    1 *** 4
%    *     *
%    2 *** 3

%Quadratic element
%    1 *** 8 *** 4
%    *     *     *
%    5     9     7
%    *     *     *
%    2 *** 6 *** 3

%Cubic element
%    01 ** 12 ** 11 ** 04
%    **    **    **    **
%    05    13    16    10
%    **    **    **    **
%    06    14    15    09
%    **    **    **    **
%    02 ** 07 ** 08 ** 03

function [N_Dim,N_Elem,N_Node_Elem,N_Elem_Order,Elem_Node,Coords,X_GQ,Y_GQ,Bhat_elem,B2hat] = ...
    FEM_strains_setup_GUI_compatible(N_Elem_Order,gridx,gridy,grid_param)

%Set / get basic parameters:
N_Dim = 2; %Dimensionality of problem (i.e. 1D, 2D, or 3D)

Coords = [gridx, gridy]; %Physical x,y coordinates of each node

x_matrix = grid_param.x_matrix; %x-grid coordinates in a matrix form, with NaN where points don't exist
y_matrix = grid_param.y_matrix; %y-grid coordinates in a matrix form, with NaN where points don't exist
Nx = grid_param.Nx;
Ny = grid_param.Ny;

N_Node_Elem = (N_Elem_Order + 1)^2;

%Number the nodes
Nodes = zeros(Ny,Nx);
count = 1;
for j = 1:Nx %Loop over the columns
    for i = 1:Ny %Loop over the rows
        point = x_matrix(i,j);
        if isnan(point) == 0 % The current point is not NaN
            Nodes(i,j) = count;
            count = count + 1;
        end
    end
end


%Define the elements:
N_Elem = 0;
for i = 1:Nx - N_Elem_Order %Loop over the columns
    for j = 1:Ny - N_Elem_Order %Loop over the rows
        
        %Define the boundaries of the potential element
        top = j;
        bottom = j + N_Elem_Order;
        left = i;
        right = i + N_Elem_Order;
        
        %Check to see if there are any "NaN" points in the grid
        element = Nodes(top:bottom,left:right);
        index = find(element == 0);
        if isempty(index) == 1 %There are no NaN points in the grid
            N_Elem = N_Elem + 1;
            
            if N_Elem_Order == 1 %Linear elements
                Elem_Node(N_Elem,1) = element(1,1);
                Elem_Node(N_Elem,2) = element(2,1);
                Elem_Node(N_Elem,3) = element(2,2);
                Elem_Node(N_Elem,4) = element(1,2);
                
            elseif N_Elem_Order == 2 %Quadratic elements
                Elem_Node(N_Elem,1) = element(1,1);
                Elem_Node(N_Elem,2) = element(3,1);
                Elem_Node(N_Elem,3) = element(3,3);
                Elem_Node(N_Elem,4) = element(1,3);
                Elem_Node(N_Elem,5) = element(2,1);
                Elem_Node(N_Elem,6) = element(3,2);
                Elem_Node(N_Elem,7) = element(2,3);
                Elem_Node(N_Elem,8) = element(1,2);
                Elem_Node(N_Elem,9) = element(2,2);
                
            elseif N_Elem_Order == 3 %Cubic elements
                Elem_Node(N_Elem,1) = element(1,1);
                Elem_Node(N_Elem,2) = element(4,1);
                Elem_Node(N_Elem,3) = element(4,4);
                Elem_Node(N_Elem,4) = element(1,4);
                Elem_Node(N_Elem,5) = element(2,1);
                Elem_Node(N_Elem,6) = element(3,1);
                Elem_Node(N_Elem,7) = element(4,2);
                Elem_Node(N_Elem,8) = element(4,3);
                Elem_Node(N_Elem,9) = element(3,4);
                Elem_Node(N_Elem,10) = element(2,4);
                Elem_Node(N_Elem,11) = element(1,3);
                Elem_Node(N_Elem,12) = element(1,2);
                Elem_Node(N_Elem,13) = element(2,2);
                Elem_Node(N_Elem,14) = element(3,2);
                Elem_Node(N_Elem,15) = element(3,3);
                Elem_Node(N_Elem,16) = element(2,3);
                
            end
            
        end
               
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the parts of calculating the strain that are dependent only on the
% grid, which is constant, and are independent of the displacements,
% which change with each image

Elem_Node = Elem_Node'; %N_Node_Elem x N_Elem

%Get the x- and y-grid values for all the element nodes, for all the
%elements
X_EN = gridx(Elem_Node); %N_Node_Elem x N_Elem
Y_EN = gridy(Elem_Node);

%Combine the x- and y-node grids into one grid
%          Elem1      Elem2    ...
% Node1 | x1   y1 |  x1   y1 |
% Node2 | x2   y2 |  x2   y2 |
%  .  
%  . 

XY_EN = zeros(N_Node_Elem,N_Elem*2);
XY_EN(:,1:2:end) = X_EN;
XY_EN(:,2:2:end) = Y_EN;

% Get the coordinates of all the Gauss Quad points in the master element
[GQx,GQy] = Gauss_Quad(N_Elem_Order); %N_GQ x 1
N_GQ = N_Elem_Order^2; %Number of Gauss Quad points in the master element

% Get the derivatives of the left-handed shape functions for all of the
% Gauss Quad points

%DNhat':
%        Node1      Node2     ...
% GQ1 | DN1/Dksi | DN1/Dksi |
%     | DN1/Deta | DN1/Deta |
%      ---------- ----------
% GQ2 | DN1/Dksi | DN1/Dksi |
%     | DN1/Deta | DN1/Deta |
%      ---------- ----------
% .
% .
% .

%D2Nhat':
%          Node1          Node2         ...
% GQ1 | D2N1/Dksi2    | D2N2/Dksi2    |
%     | D2N1/DksiDeta | D2N2/DksiDeta | 
%     | D2N1/Deta2    | D2N2/Deta2    |
%      --------------- ---------------
% GQ2 | D2N1/Dksi2    | D2N2/Dksi2    |
%     | D2N1/DksiDeta | D2N2/DksiDeta | 
%     | D2N1/Deta2    | D2N2/Deta2    |
%      --------------- ---------------
% .
% .
% .

Nhat = zeros(N_GQ,N_Node_Elem);
DNhat = zeros(N_GQ*2,N_Node_Elem);
D2Nhat = zeros(N_GQ*3,N_Node_Elem);
k = 1;
m = 1;
for i = 1:N_GQ
    r = [GQx(i),GQy(i)]; % coordinates of the i'th Gauss Quad point, in master element coordinates
    [Nhat_i,DNhat_i,D2Nhat_i] = Shape_Funct_LH(N_Elem_Order,r); %Shape functions and derivatives of i'th point
    Nhat(i,:) = Nhat_i';
    DNhat(k:k+1,:) = DNhat_i'; % Place i'th shape function derivatives into matrix shape function derivatives for all the Gauss quad points
    D2Nhat(m:m+2,:) = D2Nhat_i';
    k = k+2;
    m = m+3;
end

%Compute the XY values for all the Gauss Quad points
% XY_GQ:
%      Elem1  Elem2 ...
% GQ1  x  y   x  y   
% GQ2  x  y   x  y
% .
% .
% .
XY_GQ = Nhat*XY_EN; %N_GQ x N_Elem*2
X_GQ = reshape(XY_GQ(:,1:2:end)',[],1);
Y_GQ = reshape(XY_GQ(:,2:2:end)',[],1);

%Compute the Jacobian for all of the Gauss Quad points, for all of the
%elements

%       Elem1   Elem2   ...
% GQ1 | A   B | A   B | 
%     | C   D | C   D |
%      ------- -------
% GQ2 | A   B | A   B | 
%     | C   D | C   D |
%      ------- -------
%  .
%  .
J = DNhat*XY_EN; % N_GQ*2 x N_Elem*2

%Compute the inverse of each sub-matrix of J

%           Elem1         Elem2     ...
% GQ1 |  1    D  -B |  1    D  -B | 
%     | detJ -C   A | detJ -C   A |
%      ------------- -------------
% GQ2 |  1    D  -B |  1    D  -B | 
%     | detJ -C   A | detJ -C   A |
%      ------------- -------------
%  .
%  .

Jinv = zeros(N_GQ*2,N_Elem*2);
k = 1;
m = 1;
for j = 1:N_Elem %Loop over the columns
    for i = 1:N_GQ %Loop over the rows
        
        J_ij = J(k:k+1,m:m+1); %Get the sub-matrix J
        J_ij_inv = J_ij^(-1); %Compute the inverse of the submatrix
        Jinv(k:k+1,m:m+1) = J_ij_inv; %Place the sub-inverse back into the main inverse matrix
        
        k = k+2;       
    end
    
    k = 1;
    m = m+2;
    
end

% Reshape the Jinv and the DNhat matrices so that the quad points are in
% the 3rd dimension.  Note that to use reshape properly, the matrices are
% transposd first, hence the capital "T" in the new name.

% JinvT3(:,:,i), where i = Gauss Quad point
%                      
% Elem1 |  1    D  -B |
%       | detJ -C   A |
%        ------------- 
% Elem2 |  1    D  -B | 
%       | detJ -C   A |
%        ------------- 
%  .
%  .

% DNhatT3(:,:,i), where i = Gauss Quad point

% Node1 | ksi  eta |
%        ----------
% Node2 | ksi  eta |
%        ----------
%   .
%   .

JinvT3 = reshape(Jinv',N_Elem*2,2,N_GQ); 
DNhatT3 = reshape(DNhat',N_Node_Elem,2,N_GQ); 

% Compute the matrix Bhat, for all Gauss quad points
Bhat = zeros(N_Node_Elem, N_Elem*2, N_GQ);
%          Elem1     Elem2    ...
% Node1 | ksi eta | ksi eta |
%        --------- ---------
% Node2 | ksi eta | ksi eta |
%        --------- ---------
%   .
%   .
for i = 1:N_GQ %Loop over Gauss quad points
    DNhatT3_i = DNhatT3(:,:,i); %Get the DNhat' for the i'th point of all elements; note that it remains transposed
    Jinv3_i = JinvT3(:,:,i)'; %Get the Jinv for the i'th quad point for all elements; note that it is transposed back to original orientation
    Bhat_i = DNhatT3_i*Jinv3_i; %Bhat will be used w/ displacements to get displacement gradients later   
    Bhat(:,:,i) = Bhat_i; %Save Bhat for the i'th quad point of all elements into main matrix w/ all quad points for all elements
end

%If the grid of control points was not evenly spaced, then Bhat would
%change for each element.  Hence, the form of Bhat above is the more
%general form, that allows for uneven spacing of the grid.  However, in
%this DIC code, the grid is evenly spaced, and therefore Bhat is the
%same for each element.  Knowing this, reduce Bhat to cover only one
%element, and stack the GQ points back in the 2nd dimension.

% Bhat_elem:
%                GQ1              GQ2        ...
% Node1  | DN1/Dx  DN1/Dy | DN1/Dx  DN1/Dy |
%         ---------------   --------------
% Node2  | DN2/Dx  DN2/Dy | DN2/Dx  DN2/Dy |
%         ---------------   --------------
%  .
%  .

Bhat_elem3 = Bhat(:,1:2,:); %Bhat for one element (same for all elements for even grid)
Bhat_elem = reshape(Bhat_elem3,N_Node_Elem,2*N_GQ); % Stack GQ points back to 2nd dimension

% This next section also assumes an even grid spacing in order to calculate
% the second partial derivatives.  To be generic, we'd need the equivalent
% of the Jacobian, J, and it's inverse, but I'm not sure how to do that.
% Instead, I take advantage of the even grid spacing, and define Dksi/Dx
% and Deta/Dy through the step size:

step = grid_param.step;

DksiDx = 2/3*(1/step);
DetaDy = 2/3*(1/step);

%The equivalent of the Jacobian for the second derivatives; this is the
%same for every GQ point, of every element, for an evenly-spaced grid.
%Note that this is not really a Jacobian for 2nd derivatives; I've just
%structured it to follow a similar set of operations as the 1st
%derivatives.
J2inv = [DksiDx^2, DksiDx*DetaDy, DetaDy^2];
J2inv_mat = repmat(J2inv,N_Node_Elem,N_GQ);

%Get the derivatives in the true coordinates (instead of master element
%coordinates)
B2hat = D2Nhat'.*J2inv_mat;


% B2hat:
%                       GQ1                             GQ2        ...
% Node1  | D2N1/Dx2  D2N1/DxDy  D2N1/Dy2 | D2N1/Dx2  D2N1/DxDy  D2N1/Dy2 |
%         ------------------------------   -----------------------------
% Node2  | D2N2/Dx2  D2N2/DxDy  D2N2/Dy2 | D2N2/Dx2  D2N2/DxDy  D2N2/Dy2 |
%         ------------------------------   -----------------------------
%  .
%  .

