%Function "Shape_Funct" computes the shape function vectors Nhat and DNhat
%for a given element (linear, quadratic, cubic) at a given point r_alpha.  

% Shape_Funct_LH provides the shape functions for a left-handed coordinate
% system, such as is used in images!

% Shape functions based on ME 471 notes

function[Nhat,DNhat, D2Nhat] = Shape_Funct_LH(N_Elem_Order,r_alpha)

ksi = r_alpha(1);
eta = r_alpha(2);

if N_Elem_Order == 1 %4-node bi-linear element
    
    % 2-node, linear shape functions in 1D
    N1ksi = 1/2*(1 - ksi);          % ksi = -1
    N2ksi = 1/2*(ksi + 1);          % ksi = 1
    
    N1eta = 1/2*(1 - eta);          % eta = -1
    N2eta = 1/2*(eta + 1);          % eta = 1

    %4-node, bi-linear shape functions in 2D
    N1 = N1ksi*N1eta;               % ksi = -1; eta = -1
    N2 = N1ksi*N2eta;               % ksi = -1; eta = 1
    N3 = N2ksi*N2eta;               % ksi = 1; eta = 1
    N4 = N2ksi*N1eta;               % ksi = 1; eta = -1
    
    % Complete shape function
    Nhat = [N1; N2; N3; N4];
    
    
    %Derivatives of 2-node, linear shape functions in 1D
    DN1ksi = -1/2;
    DN2ksi = 1/2;
    
    DN1eta = -1/2;
    DN2eta = 1/2;
    
    %2nd derivatives of 2-node, linear shape functions in 1D
    D2N1ksi = 0;
    D2N2ksi = 0;
    
    D2N1eta = 0;
    D2N2eta = 0;
    
    %Derivatives of 4-node, bi-linear shape functions in 2D
    DN11 = DN1ksi*N1eta;            % DN1 / dksi
    DN12 = N1ksi*DN1eta;            % DN1 / deta
    
    DN21 = DN1ksi*N2eta;            % DN2 / dksi
    DN22 = N1ksi*DN2eta;            % DN2 / deta
    
    DN31 = DN2ksi*N2eta;            % DN3 / dksi
    DN32 = N2ksi*DN2eta;            % DN3 / deta
    
    DN41 = DN2ksi*N1eta;            % DN4 / dksi
    DN42 = N2ksi*DN1eta;            % DN4 / deta
    
    %Complete shape function derivatives
    DNhat = [DN11 DN12; DN21 DN22; DN31 DN32; DN41 DN42];
    
    %2nd derivatives of 9-node, quadratic shape functions in 2D
    D2N1_11 = D2N1ksi * N1eta; %
    D2N1_12 = DN1ksi * DN1eta; %
    D2N1_22 = N1ksi * D2N1eta; %
    
    D2N2_11 = D2N1ksi * N2eta; %
    D2N2_12 = DN1ksi * DN2eta; %
    D2N2_22 = N1ksi * D2N2eta; %
    
    D2N3_11 = D2N2ksi * N2eta; %
    D2N3_12 = DN2ksi * DN2eta; %
    D2N3_22 = N2ksi * D2N2eta; %
    
    D2N4_11 = D2N2ksi * N1eta; %
    D2N4_12 = DN2ksi * DN1eta; %
    D2N4_22 = N2ksi * D2N1eta; %
   
    
    %Complete the 2nd derivatives:
    D2Nhat = [D2N1_11, D2N1_12, D2N1_22; ...
              D2N2_11, D2N2_12, D2N2_22; ...
              D2N3_11, D2N3_12, D2N3_22; ...
              D2N4_11, D2N4_12, D2N4_22];
    
    
elseif N_Elem_Order == 2 %9-node bi-quadratic element
    
    %3-node, quadratic shape functions in 1D
    N1ksi = 1/2*(ksi - 1) * ksi;     % ksi = -1
    N2ksi = -(ksi - 1)*(ksi + 1);    % ksi = 0
    N3ksi = 1/2*ksi*(ksi + 1);       % ksi = 1

    N1eta = 1/2*(eta - 1) * eta;     % eta = -1
    N2eta = -(eta - 1)*(eta + 1);    % eta = 0
    N3eta = 1/2*eta*(eta + 1);       % eta = 1
    
    %9-node, bi-quadratic shape functions in 2D
    %Corner nodes
    N1 = N1ksi*N1eta;                % ksi = -1; eta = -1
    N2 = N1ksi*N3eta;                % ksi = -1; eta = 1
    N3 = N3ksi*N3eta;                % ksi = 1;  eta = 1
    N4 = N3ksi*N1eta;                % ksi = 1;  eta = -1
     
    %Mid-side nodes
    N5 = N1ksi*N2eta;                % ksi = -1; eta = 0
    N6 = N2ksi*N3eta;                % ksi = 0;  eta = 1
    N7 = N3ksi*N2eta;                % ksi = 1;  eta = 0
    N8 = N2ksi*N1eta;                % ksi = 0;  eta = -1
    
    %Middle node
    N9 = N2ksi*N2eta;                % ksi = 0; eta = 0
    
    % Complete shape function
    Nhat = [N1; N2; N3; N4; N5; N6; N7; N8; N9];
    
    
    %Derivatives of 3-node, quadratic shape functions in 1D
    DN1ksi = 1/2*((ksi - 1) + ksi);
    DN2ksi = -((ksi + 1) + (ksi - 1));
    DN3ksi = 1/2*((ksi + 1) + ksi);
    
    DN1eta = 1/2*((eta - 1) + eta);
    DN2eta = -((eta + 1) + (eta - 1));
    DN3eta = 1/2*((eta + 1) + eta);
    
    %2nd derivatives of 3-node, quadratic shape functions in 1D
    D2N1ksi = 1;
    D2N2ksi = -2;
    D2N3ksi = 1;
    
    D2N1eta = 1;
    D2N2eta = -2;
    D2N3eta = 1;
    
    %Derivatives of 9-node, bi-quadratic shape functions in 2D
    DN11 = DN1ksi * N1eta;           % dN1/dksi
    DN12 = N1ksi * DN1eta;           % dN1/deta
    
    DN21 = DN1ksi * N3eta;
    DN22 = N1ksi * DN3eta;
    
    DN31 = DN3ksi * N3eta;
    DN32 = N3ksi * DN3eta;
    
    DN41 = DN3ksi * N1eta;
    DN42 = N3ksi * DN1eta;
    
    DN51 = DN1ksi * N2eta;
    DN52 = N1ksi * DN2eta;
    
    DN61 = DN2ksi * N3eta;
    DN62 = N2ksi * DN3eta;
    
    DN71 = DN3ksi * N2eta;
    DN72 = N3ksi * DN2eta;
    
    DN81 = DN2ksi * N1eta;
    DN82 = N2ksi * DN1eta;
    
    DN91 = DN2ksi * N2eta;
    DN92 = N2ksi * DN2eta;
    
    DNhat = [DN11, DN12; DN21, DN22; DN31, DN32; DN41, DN42; DN51, DN52; ...
        DN61, DN62; DN71, DN72; DN81, DN82; DN91, DN92];
    
  
    %2nd derivatives of 9-node, quadratic shape functions in 2D
    D2N1_11 = D2N1ksi * N1eta; %
    D2N1_12 = DN1ksi * DN1eta; %
    D2N1_22 = N1ksi * D2N1eta; %
    
    D2N2_11 = D2N1ksi * N3eta; %
    D2N2_12 = DN1ksi * DN3eta; %
    D2N2_22 = N1ksi * D2N3eta; %
    
    D2N3_11 = D2N3ksi * N3eta; %
    D2N3_12 = DN3ksi * DN3eta; %
    D2N3_22 = N3ksi * D2N3eta; %
    
    D2N4_11 = D2N3ksi * N1eta; %
    D2N4_12 = DN3ksi * DN1eta; %
    D2N4_22 = N3ksi * D2N1eta; %
    
    D2N5_11 = D2N1ksi * N2eta; 
    D2N5_12 = DN1ksi * DN2eta; 
    D2N5_22 = N1ksi * D2N2eta; 

    D2N6_11 = D2N2ksi * N3eta; 
    D2N6_12 = DN2ksi * DN3eta; 
    D2N6_22 = N2ksi * D2N3eta; 
    
    D2N7_11 = D2N3ksi * N2eta; 
    D2N7_12 = DN3ksi * DN2eta; 
    D2N7_22 = N3ksi * D2N2eta; 
    
    D2N8_11 = D2N2ksi * N1eta; 
    D2N8_12 = DN2ksi * DN1eta; 
    D2N8_22 = N2ksi * D2N1eta; 
    
    D2N9_11 = D2N2ksi * N2eta; 
    D2N9_12 = DN2ksi * DN2eta; 
    D2N9_22 = N2ksi * D2N2eta; 
    
    %Complete the 2nd derivatives:
    D2Nhat = [D2N1_11, D2N1_12, D2N1_22; ...
              D2N2_11, D2N2_12, D2N2_22; ...
              D2N3_11, D2N3_12, D2N3_22; ...
              D2N4_11, D2N4_12, D2N4_22; ...
              D2N5_11, D2N5_12, D2N5_22; ...
              D2N6_11, D2N6_12, D2N6_22; ...
              D2N7_11, D2N7_12, D2N7_22; ...
              D2N8_11, D2N8_12, D2N8_22; ...
              D2N9_11, D2N9_12, D2N9_22];
    
elseif N_Elem_Order == 3 % 16-node, cubic element
    
    %4-node, cubic shape functions in 1D
    N1ksi = 9/16*(1 - ksi)*(ksi^2 - 1/9);   %ksi = -1
    N2ksi = 27/16*(ksi^2 - 1)*(ksi - 1/3);  %ksi = -1/3
    N3ksi = 27/16*(1 - ksi^2)*(ksi + 1/3);  %ksi = 1/3
    N4ksi = 9/16*(ksi + 1)*(ksi^2 - 1/9);   %ksi = 1
    
    N1eta = 9/16*(1 - eta)*(eta^2 - 1/9);   %eta = -1
    N2eta = 27/16*(eta^2 - 1)*(eta - 1/3);  %eta = -1/3
    N3eta = 27/16*(1 - eta^2)*(eta + 1/3);  %eta = 1/3
    N4eta = 9/16*(eta + 1)*(eta^2 - 1/9);   %eta = 1
    
    %1st derivatives of 4-node, cubic shape functions in 1D
    DN1ksi = -9/16*(ksi^2 - 1/9) + 9/8*(1 - ksi)*ksi;
    DN2ksi = 27/8*ksi*(ksi - 1/3) + 27/16*(ksi^2 - 1);
    DN3ksi = -27/8*ksi*(ksi + 1/3) + 27/16*(1 - ksi^2);
    DN4ksi = 9/16*(ksi^2 - 1/9) + 9/8*ksi*(ksi + 1);
    
    DN1eta = -9/16*(eta^2 - 1/9) + 9/8*(1 - eta)*eta;
    DN2eta = 27/8*eta*(eta - 1/3) + 27/16*(eta^2 - 1);
    DN3eta = -27/8*eta*(eta + 1/3) + 27/16*(1 - eta^2);
    DN4eta = 9/16*(eta^2 - 1/9) + 9/8*eta*(eta + 1);
    
    %2nd derivatives of 4-node, cubic shape functions in 1D
    D2N1ksi = -27/8*ksi + 9/8;
    D2N2ksi = 81/8*ksi - 9/8;
    D2N3ksi = -81/8*ksi - 9/8;
    D2N4ksi = 27/8*ksi + 9/8;
    
    D2N1eta = -27/8*eta + 9/8;
    D2N2eta = 81/8*eta - 9/8;
    D2N3eta = -81/8*eta - 9/8;
    D2N4eta = 27/8*eta + 9/8;
    
    
    %16-node, cubic shape functions in 2D
    %Corner nodes
    N1 = N1ksi*N1eta;   %ksi = -1; eta = -1
    N2 = N1ksi*N4eta;   %ksi = -1; eta = 1
    N3 = N4ksi*N4eta;   %ksi = 1; eta = 1
    N4 = N4ksi*N1eta;   %ksi = 1; eta = -1
    
    %Middle nodes on the side
    N5 = N1ksi*N2eta;   %ksi = -1; eta = -1/3
    N6 = N1ksi*N3eta;   %ksi = -1; eta = 1/3
    N7 = N2ksi*N4eta;   %ksi = -1/3; eta = 1
    N8 = N3ksi*N4eta;   %ksi = 1/3; eta = 1
    N9 = N4ksi*N3eta;   %ksi = 1; eta = 1/3
    N10 = N4ksi*N2eta;  %ksi = 1; eta = -1/3
    N11 = N3ksi*N1eta;  %ksi = 1/3; eta = -1
    N12 = N2ksi*N1eta;  %ksi = -1/3; eta = -1
    
    %Four middle nodes
    N13 = N2ksi*N2eta;  %ksi = -1/3; eta = -1/3
    N14 = N2ksi*N3eta;  %ksi = -1/3; eta = 1/3
    N15 = N3ksi*N3eta;  %ksi = 1/3; eta = 1/3
    N16 = N3ksi*N2eta;  %ksi = 1/3; eta = -1/3
    
    %Complete the shape function
    Nhat = [N1; N2; N3; N4; N5; N6; N7; N8; N9; N10; N11; N12; N13; N14; N15; N16];
        

    %1st derivatives of 16-node, cubic shape functions in 2D
    DN11 = DN1ksi*N1eta;    % dN1/dksi
    DN12 = N1ksi*DN1eta;    % dN1/deta 
    
    DN21 = DN1ksi*N4eta;
    DN22 = N1ksi*DN4eta;
    
    DN31 = DN4ksi*N4eta;
    DN32 = N4ksi*DN4eta;
    
    DN41 = DN4ksi*N1eta;
    DN42 = N4ksi*DN1eta;
    
    DN51 = DN1ksi*N2eta;
    DN52 = N1ksi*DN2eta;
    
    DN61 = DN1ksi*N3eta;
    DN62 = N1ksi*DN3eta;
    
    DN71 = DN2ksi*N4eta;
    DN72 = N2ksi*DN4eta;
    
    DN81 = DN3ksi*N4eta;
    DN82 = N3ksi*DN4eta;
    
    DN91 = DN4ksi*N3eta;
    DN92 = N4ksi*DN3eta;
    
    DN101 = DN4ksi*N2eta;
    DN102 = N4ksi*DN2eta;
    
    DN111 = DN3ksi*N1eta;
    DN112 = N3ksi*DN1eta;
    
    DN121 = DN2ksi*N1eta;
    DN122 = N2ksi*DN1eta;
    
    DN131 = DN2ksi*N2eta;
    DN132 = N2ksi*DN2eta;
    
    DN141 = DN2ksi*N3eta;
    DN142 = N2ksi*DN3eta;
    
    DN151 = DN3ksi*N3eta;
    DN152 = N3ksi*DN3eta;
    
    DN161 = DN3ksi*N2eta;
    DN162 = N3ksi*DN2eta;
    
    %Complete the 1st derivatives:
    DNhat = [DN11, DN12; ...
             DN21, DN22; ...
             DN31, DN32; ...
             DN41, DN42; ...
             DN51, DN52; ...
             DN61, DN62; ...
             DN71, DN72; ...
             DN81, DN82; ...
             DN91, DN92; ...
             DN101, DN102; ...
             DN111, DN112; ...
             DN121, DN122; ...
             DN131, DN132; ...
             DN141, DN142; ...
             DN151, DN152; ...
             DN161, DN162];
    
    
    %2nd derivatives of 16-node, cubic shape functions in 2D
    %Corner nodes
    D2N1_11 = D2N1ksi * N1eta; %D2N1/Dksi2
    D2N1_12 = DN1ksi * DN1eta; %D2N1/DksiDeta
    D2N1_22 = N1ksi * D2N1eta; %D2N1/Deta2
    
    D2N2_11 = D2N1ksi * N4eta; %D2N2/Dksi2
    D2N2_12 = DN1ksi * DN4eta; %D2N2/DksiDeta
    D2N2_22 = N1ksi * D2N4eta; %D2N2/Deta2
    
    D2N3_11 = D2N4ksi * N4eta; %D2N3/Dksi2
    D2N3_12 = DN4ksi * DN4eta; %D2N3/DksiDeta
    D2N3_22 = N4ksi * D2N4eta; %D2N3/Deta2
    
    D2N4_11 = D2N4ksi * N1eta; %D2N4/Dksi2
    D2N4_12 = DN4ksi * DN1eta; %D2N4/DksiDeta
    D2N4_22 = N4ksi * D2N1eta; %D2N4/Deta2
    
    %Middle nodes on the side
    D2N5_11 = D2N1ksi * N2eta; 
    D2N5_12 = DN1ksi * DN2eta; 
    D2N5_22 = N1ksi * D2N2eta; 

    D2N6_11 = D2N1ksi * N3eta; 
    D2N6_12 = DN1ksi * DN3eta; 
    D2N6_22 = N1ksi * D2N3eta; 
    
    D2N7_11 = D2N2ksi * N4eta; 
    D2N7_12 = DN2ksi * DN4eta; 
    D2N7_22 = N2ksi * D2N4eta; 
    
    D2N8_11 = D2N3ksi * N4eta; 
    D2N8_12 = DN3ksi * DN4eta; 
    D2N8_22 = N3ksi * D2N4eta; 
    
    D2N9_11 = D2N4ksi * N3eta; 
    D2N9_12 = DN4ksi * DN3eta; 
    D2N9_22 = N4ksi * D2N3eta; 
    
    D2N10_11 = D2N4ksi * N2eta; 
    D2N10_12 = DN4ksi * DN2eta; 
    D2N10_22 = N4ksi * D2N2eta; 
    
    D2N11_11 = D2N3ksi * N1eta; 
    D2N11_12 = DN3ksi * DN1eta; 
    D2N11_22 = N3ksi * D2N1eta; 
    
    D2N12_11 = D2N2ksi * N1eta; 
    D2N12_12 = DN2ksi * DN1eta; 
    D2N12_22 = N2ksi * D2N1eta; 
      
    %Four middle nodes
    D2N13_11 = D2N2ksi * N2eta; 
    D2N13_12 = DN2ksi * DN2eta; 
    D2N13_22 = N2ksi * D2N2eta; 
    
    D2N14_11 = D2N2ksi * N3eta; 
    D2N14_12 = DN2ksi * DN3eta; 
    D2N14_22 = N2ksi * D2N3eta; 
    
    D2N15_11 = D2N3ksi * N3eta; 
    D2N15_12 = DN3ksi * DN3eta; 
    D2N15_22 = N3ksi * D2N3eta; 
    
    D2N16_11 = D2N3ksi * N2eta; 
    D2N16_12 = DN3ksi * DN2eta; 
    D2N16_22 = N3ksi * D2N2eta; 
    
    %Complete the 2nd derivatives:
    D2Nhat = [D2N1_11, D2N1_12, D2N1_22; ...
              D2N2_11, D2N2_12, D2N2_22; ...
              D2N3_11, D2N3_12, D2N3_22; ...
              D2N4_11, D2N4_12, D2N4_22; ...
              D2N5_11, D2N5_12, D2N5_22; ...
              D2N6_11, D2N6_12, D2N6_22; ...
              D2N7_11, D2N7_12, D2N7_22; ...
              D2N8_11, D2N8_12, D2N8_22; ...
              D2N9_11, D2N9_12, D2N9_22; ...
              D2N10_11, D2N10_12, D2N10_22; ...
              D2N11_11, D2N11_12, D2N11_22; ...
              D2N12_11, D2N12_12, D2N12_22; ...
              D2N13_11, D2N13_12, D2N13_22; ...
              D2N14_11, D2N14_12, D2N14_22; ...
              D2N15_11, D2N15_12, D2N15_22; ...
              D2N16_11, D2N16_12, D2N16_22];
    
end


    



