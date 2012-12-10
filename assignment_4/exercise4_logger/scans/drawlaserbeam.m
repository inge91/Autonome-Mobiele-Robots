%DRAWLASERBEAM Overlay a laser beam on a given image
%   DRAWLASERBEAM(CENTER,THETA,DIST)
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007
function drawlaserbeam( center, theta, rho )

xc = center(2);% x-coordinate of the center
yc = center(1);% y-coordinate of the center

x_dist = rho.*cos(theta) + xc;
y_dist = rho.*sin(theta) + yc;

count = 1;
for i = theta
    plot ( y_dist(count) , x_dist(count) , 'r.' );
    hold on;     
%    line( [ yc, y_dist(count) ],[ xc, x_dist(count) ] );
    count = count +1;
end
hold off;