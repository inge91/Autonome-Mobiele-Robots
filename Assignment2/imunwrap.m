%IMUNWRAP Unwrap an omnidirectional image
%   [undistortedI,theta] = IMUNWRAP(I, center, theta_step, Rmax, Rmin)
%   I = input gray-scale image
%   center = coordinates of the circle center, center=[col;row]
%   theta_step = angular step
%   Rmax = Maximum external radius
%   Rmin = Minimum external radius
%   undistortedI = resultant undistorted image
%   theta = array of theta values
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007

function [Iunwraped, theta] = imunwrap(I, center, theta_step, Rmax, Rmin)

I = img2gray( I );

Rmax = round( Rmax );
Rmin = round( Rmin );

I = double(I);

xc = center(2);
yc = center(1);

rad_step = deg2rad( theta_step );
theta = [0:rad_step:2*pi-rad_step];

rows = length( theta );
cols = Rmax-Rmin+1;
Iunwraped = zeros( rows, cols );

[RHO,THETA] = meshgrid(Rmin:Rmax, theta);
X = RHO.*cos(THETA) + xc;
Y = RHO.*sin(THETA) + yc;

U=floor(Y);
V=floor(X);
IND=(U-1)*size(I,1)+V;

IND(find(~(U>=1 & U<=size(I,2) & V>=1 & V<=size(I,1)) )) = 0;
nonZeroIND = find(IND);

Iunwraped( nonZeroIND ) = I( IND( nonZeroIND ) );

oness = 255*ones( rows, Rmin-1 );
Iunwraped = [255*oness, Iunwraped];

Iunwraped=uint8(Iunwraped);
