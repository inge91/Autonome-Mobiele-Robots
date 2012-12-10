function rad = deg2rad(alpha)
%----------------------------
% DEG2RAD conversion: alpha deg., min., sec.  ->  radians
%
d = length(alpha);
if d > 4
   disp(alpha), error('invalid input list in function deg2rad')
end
alpha = [alpha(:); zeros(4-d,1)];
alpha(3) = alpha(3) + alpha(4)/100;
rad = pi/180*((alpha(3)/60 + alpha(2))/60 + alpha(1));

