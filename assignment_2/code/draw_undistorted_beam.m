%DRAW_UNDISTORTED_BEAM Draw the undistorted beam
%   DRAW_UNDISTORTED_BEAM( rho, theta )
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007
function draw_undisdtorted_beam( rho, theta , axislimit, angstep, bw, alpha,count)

[x,y] = pol2cart( theta , rho );
plot( 0,0,'ro');
hold on;
plot( y, -x, '.' ); axis([-axislimit axislimit -axislimit axislimit]); axis square; grid on;
plot( y(1), -x(1), 'ro' );
plot( y(4), -x(4), 'bo' );
%set(gcf, 'Visible', 'off')
str1(1) = {'angstep:'};
str1(2) = {angstep};
str1(3) = {'bw:'};
str1(4) = {bw};
str1(5) = {'alpha'};
str1(6) = {alpha};
text(0.72,0.7,str1)
countstr = num2str(count)
