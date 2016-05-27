function [xyinput,corr_coeff] = cpcorr_mod(varargin)
%CPCORR Tune control point locations using cross-correlation. 
%   INPUT_POINTS = CPCORR(INPUT_POINTS_IN,BASE_POINTS_IN,INPUT,BASE) uses
%   normalized cross-correlation to adjust each pair of control points
%   specified in INPUT_POINTS_IN and BASE_POINTS_IN.
%
%   INPUT_POINTS_IN must be an M-by-2 double matrix containing the
%   coordinates of control points in the input image.  BASE_POINTS_IN is
%   an M-by-2 double matrix containing the coordinates of control points
%   in the base image.
%
%   CPCORR returns the adjusted control points in INPUT_POINTS, a double
%   matrix the same size as INPUT_POINTS_IN.  If CPCORR cannot correlate a
%   pairs of control points, INPUT_POINTS will contain the same coordinates
%   as INPUT_POINTS_IN for that pair.
%
%   CPCORR will only move the position of a control point by up to 4
%   pixels.  Adjusted coordinates are accurate up to one tenth of a
%   pixel.  CPCORR is designed to get subpixel accuracy from the image
%   content and coarse control point selection.
%   NOTE:  EJ modification:  CPCORR_MOD will adjust the control point by
%   more than 4 pixels, depending on the subset size!!
%
%   Note that the INPUT and BASE images must have the same scale for
%   CPCORR to be effective.
%
%   CPCORR cannot adjust a point if any of the following occur:
%     - points are too near the edge of either image
%     - regions of images around points contain Inf or NaN
%     - region around a point in input image has zero standard deviation
%     - regions of images around points are poorly correlated
%
%   Class Support
%   -------------
%   The images can be numeric and must contain finite values. The input
%   control point pairs are double.
%
%   Example
%   --------
%   This example uses CPCORR to fine-tune control points selected in an
%   image.  Note the difference in the values of the INPUT_POINTS matrix
%   and the INPUT_POINTS_ADJ matrix.
%
%       input = imread('onion.png');
%       base = imread('peppers.png');
%       input_points = [127 93; 74 59];
%       base_points = [323 195; 269 161];
%       input_points_adj = cpcorr(input_points,base_points,...
%                                 input(:,:,1),base(:,:,1))
%
%   See also CP2TFORM, CPSELECT, NORMXCORR2, IMTRANSFORM.

%   Copyright 1993-2011 The MathWorks, Inc.
%   $Revision: 1.16.4.10 $  $Date: 2011/08/09 17:49:27 $

%   Input-output specs
%   ------------------
%   INPUT_POINTS_IN: M-by-2 double matrix 
%              INPUT_POINTS_IN(:)>=0.5
%              INPUT_POINTS_IN(:,1)<=size(INPUT,2)+0.5
%              INPUT_POINTS_IN(:,2)<=size(INPUT,1)+0.5
%
%   BASE_POINTS_IN: M-by-2 double matrix 
%              BASE_POINTS_IN(:)>=0.5
%              BASE_POINTS_IN(:,1)<=size(BASE,2)+0.5
%              BASE_POINTS_IN(:,2)<=size(BASE,1)+0.5
%
%   INPUT:   2-D, real, full matrix
%            logical, uint8, uint16, or double
%            must be finite (no NaNs, no Infs inside regions being correlated)
%
%   BASE:    2-D, real, full matrix
%            logical, uint8, uint16, or double
%            must be finite (no NaNs, no Infs inside regions being correlated)


[xyinput_in,xybase_in,input,base,subset,search_zone,thresh] = ParseInputs(varargin{:});

CORRSIZE = subset/2;
ncp = size(xyinput_in,1);

% get all rectangle coordinates
rects_input = calc_rects(xyinput_in,ones(ncp,1)*CORRSIZE,input);
rects_base = calc_rects(xybase_in,search_zone*CORRSIZE,base);

xyinput = xyinput_in; % initialize adjusted control points matrix
corr_coeff = zeros(size(xyinput,1),1);

for icp = 1:ncp
    
    %Check to see if the current point is a NaN pt
    if isnan(xybase_in(icp,1)) || isnan(xyinput_in(icp,1))
        xyinput(icp,:) = NaN;
        continue
    end
    
    if isequal(rects_input(icp,3:4),[0 0]) || ...
       isequal(rects_base(icp,3:4),[0 0]) 
        % near edge, unable to adjust
        xyinput(icp,:) = NaN;
        continue
    end
    
    %EJ:  New check:  Moved this check from the ParseInputs function
    if xyinput_in(icp,1)<0.5 || xyinput_in(icp,2)<0.5 || ...
       xyinput_in(icp,1)>size(input,2)+0.5 || xyinput_in(icp,2)>size(input,1)+0.5
        %Control point is outside of the image
        xyinput(icp,:) = NaN;
        continue    
    end
    
    if xybase_in(icp,1)<0.5 || xybase_in(icp,2)<0.5 || ...
       xybase_in(icp,1)>size(input,2)+0.5 || xybase_in(icp,2)>size(input,1)+0.5
        %Control point is outside of the image
        xyinput(icp,:) = NaN;
        continue    
    end

    sub_input = imcrop(input,rects_input(icp,:));
    sub_base = imcrop(base,rects_base(icp,:));    

    inputsize = size(sub_input);

    % make sure finite
    if any(~isfinite(sub_input(:))) || any(~isfinite(sub_base(:)))
        % NaN or Inf, unable to adjust
        xyinput(icp,:) = NaN;
        continue
    end

    % check that template rectangle sub_input has nonzero std
    if std(sub_input(:))==0
        % zero standard deviation of template image, unable to adjust
        xyinput(icp,:) = NaN;
        continue
    end

    norm_cross_corr = normxcorr2(sub_input,sub_base);    

    % get subpixel resolution from cross correlation
    subpixel = true;
    [xpeak, ypeak, amplitude] = findpeak(norm_cross_corr,subpixel);

    %save the correlation coefficient:
    corr_coeff(icp) = amplitude; %EJ modification 140610
    
    % eliminate any poor correlations
%     THRESHOLD = 0.5; %original
    THRESHOLD = thresh; %EJ modification 140610

    if (amplitude < THRESHOLD) 
        % low correlation, unable to adjust
        xyinput(icp,:) = NaN;
        continue
    end
    
    % offset found by cross correlation
%     corr_offset = [ (xpeak-inputsize(2)-CORRSIZE)
%     (ypeak-inputsize(1)-CORRSIZE) ]; %Original code
    zero_disp = ceil(size(norm_cross_corr)/2); %location in the normcrosscorr that corresponds to zero displacement
    corr_offset = [xpeak,ypeak] - zero_disp;
    

    % eliminate any big changes in control points
%     ind = find(abs(corr_offset) > (CORRSIZE-1), 1); %Original code
    max_disp = search_zone(icp)*CORRSIZE - CORRSIZE - 1; %EJ: use when undeformed subset size is different from 2X deformed subset size
    ind = find(abs(corr_offset) > max_disp, 1);
    if ~isempty(ind)
        % peak of norxcorr2 not well constrained, unable to adjust
        xyinput(icp,:) = NaN;
        corr_coeff(icp) = -1;
        continue
    end

    input_fractional_offset = xyinput(icp,:) - round(xyinput(icp,:)*1000)/1000;
    base_fractional_offset = xybase_in(icp,:) - round(xybase_in(icp,:)*1000)/1000;    
    
    % adjust control point
    xyinput(icp,:) = xyinput(icp,:) - input_fractional_offset - corr_offset + base_fractional_offset;


end


%-------------------------------
%
function rect = calc_rects(xy,halfwidth,img)

% Calculate rectangles so imcrop will return image with xy coordinate inside center pixel

default_width = 2*halfwidth;
default_height = default_width;

% xy specifies center of rectangle, need upper left
% upperleft = round(xy) - halfwidth; %Original line of code
upperleft = round(xy) - [halfwidth,halfwidth]; %EJ modification

% need to modify for pixels near edge of images
upper = upperleft(:,2);
left = upperleft(:,1);
lower = upper + default_height;
right = left + default_width;
% width = default_width * ones(size(upper)); %Original line of code
% height = default_height * ones(size(upper)); %Original line of code
width = default_width; %EJ modification
height = default_height; %EJ modification

% check edges for coordinates outside image
[upper,height] = adjust_lo_edge(upper,1,height);
[~,height] = adjust_hi_edge(lower,size(img,1),height);
[left,width] = adjust_lo_edge(left,1,width);
[~,width] = adjust_hi_edge(right,size(img,2),width);

% set width and height to zero when less than default size
iw = find(width<default_width);
ih = find(height<default_height);
idx = unique([iw; ih]);
width(idx) = 0;
height(idx) = 0;

rect = [left upper width height];

%-------------------------------
%
function [coordinates, breadth] = adjust_lo_edge(coordinates,edge,breadth)

indx = find( coordinates<edge );
if ~isempty(indx)
    breadth(indx) = breadth(indx) - abs(coordinates(indx)-edge);
    coordinates(indx) = edge;
end

%-------------------------------
%
function [coordinates, breadth] = adjust_hi_edge(coordinates,edge,breadth)

indx = find( coordinates>edge );
if ~isempty(indx)
    breadth(indx) = breadth(indx) - abs(coordinates(indx)-edge);
    coordinates(indx) = edge;
end

%-------------------------------
%
function [xyinput_in,xybase_in,input,base,subset,search_zone,thresh] = ParseInputs(varargin)

% narginchk(4,5);

xyinput_in = varargin{1};
xybase_in = varargin{2};
if size(xyinput_in,2) ~= 2 || size(xybase_in,2) ~= 2
    error(message('images:cpcorr:cpMatrixMustBeMby2'))
end

if size(xyinput_in,1) ~= size(xybase_in,1)
    error(message('images:cpcorr:needSameNumOfControlPoints'))
end

input = varargin{3};
base = varargin{4};
if ndims(input) ~= 2 || ndims(base) ~= 2
    error(message('images:cpcorr:intensityImagesReq'))
end

input = double(input);
base = double(base);

%Original Check:
% if any(xyinput_in(:)<0.5) || any(xyinput_in(:,1)>size(input,2)+0.5) || ...
%    any(xyinput_in(:,2)>size(input,1)+0.5) || ...
%    any(xybase_in(:)<0.5) || any(xybase_in(:,1)>size(base,2)+0.5) || ...
%    any(xybase_in(:,2)>size(base,1)+0.5)
%     error(message('images:cpcorr:cpPointsMustBeInPixCoord'))
% end

%EJ New Check:
%Eliminate the check on the base and input points; instead, move this check to
%within the loop over the control points.  If a base or input point is out of the
%image, make that point not correlate.  (Note that originally, I only moved
%the check on the input points into the loop; this works if you are using
%image 1 as the reference image, and so the xybase_in are the grid points.
%But if you use the preceding image as the reference image, then the
%xybase_in points are the valid_points from the previous correlation, and
%so they have the possibility to be out of the image


subset = varargin{5};
search_zone = varargin{6};
thresh = varargin{7};

