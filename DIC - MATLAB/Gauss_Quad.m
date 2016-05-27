%Function "Gauss_Quad" returns the quadrature points for an element of quadrature order N_Quad_Order 

%This function is good only for N_Quad_Order <= 5!!!

 
function[varargout] = Gauss_Quad(varargin)

%Check to see if you want ALL the gauss points, or just one of them
[N_Quad_Order,alpha] = ParseInputs(varargin{:});

%Note:  all values for r_alpha and w_alpha are taken from class notes

if N_Quad_Order == 1 
    r = 0;
%     w = 2;
    
elseif N_Quad_Order == 2
    r = [-1/sqrt(3),1/sqrt(3)];
%     w = [1,1];
    
elseif N_Quad_Order == 3
    r = [-sqrt(3/5),0,sqrt(3/5)];
%     w = [5/9,8/9,5/9];
    
elseif N_Quad_Order == 4
    r = [-sqrt(1/35*(15 + 2*sqrt(30))),-sqrt(1/35*(15 - 2*sqrt(30))),sqrt(1/35*(15 - 2*sqrt(30))),sqrt(1/35*(15 + 2*sqrt(30)))];
%     w = [49/(6*(18+sqrt(30))),49/(6*(18-sqrt(30))),49/(6*(18-sqrt(30))),49/(6*(18+sqrt(30)))];
    
elseif N_Quad_Order == 5
    r = [-1/3*sqrt(1/7*(35 + 2*sqrt(70))),-1/3*sqrt(1/7*(35 - 2*sqrt(70))),0,1/3*sqrt(1/7*(35 - 2*sqrt(70))),1/3*sqrt(1/7*(35 + 2*sqrt(70)))];
%     w = [5103/(50*(322 + 13*sqrt(70))),5103/(50*(322 - 13*sqrt(70))),128/225,5103/(50*(322 - 13*sqrt(70))),5103/(50*(322 + 13*sqrt(70)))];
    
end

if ~isempty(alpha) %You want only the alpha'd Gauss point
    r_alpha = r(alpha);
    varargout{1} = r_alpha;
else %You want all the Gauss points
    GQx = reshape(repmat(r,N_Quad_Order,1),[],1);
    GQy = reshape(repmat(r',1,N_Quad_Order),[],1);
    varargout{1} = GQx;
    varargout{2} = GQy;
end

function [N_Quad_Order,alpha] = ParseInputs(varargin)

N_Quad_Order = varargin{1};
if nargin == 2
    alpha = varargin{2};
else 
    alpha = [];
end
