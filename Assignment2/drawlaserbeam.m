%DRAWLASERBEAM Overlay a laser beam on a given image
%   DRAWLASERBEAM(CENTER,THETA,DIST)
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - June, 12, 2008
function drawlaserbeam( center, theta, rho )

xc = center(2);% x-coordinate of the center
yc = center(1);% y-coordinate of the center

x_dist = rho.*cos(theta) + xc;
y_dist = rho.*sin(theta) + yc;

plot ( y_dist , x_dist , 'r.' );
hold off;