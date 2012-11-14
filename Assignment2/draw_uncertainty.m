function draw_uncertainty( dist, theta, sigma_dist, varargin );

% draw_uncertainty( dist, theta, sigma_dist, {N} )
%
% Draw the N sigma bounds of the distance errors on the ground floor.
%
% 2007.4.30 stefan.gaechter@mavt.ethz.ch

%--------------------------------------------------------------------------

N = 1;
if nargin == 4,
  N = varargin{1};
end; %of if

%--------------------------------------------------------------------------

dist_ub = dist + N*sigma_dist;
dist_lb = dist - N*sigma_dist;

[x_ub, y_ub] = pol2cart( theta, dist_ub );
[x_lb, y_lb] = pol2cart( theta, dist_lb );

K = length( dist );
hold( 'on' );
for k = 1:K,
  d = dist(k);
  if ~(isnan(d) | isinf(d) | (d == 0)),
    line_hdl = line( [y_lb(k), y_ub(k)], [-x_lb(k), -x_ub(k)] );
    set( line_hdl, 'Color', 'red' );
  end; %of if
end; %of for
hold( 'off' );

%--------------------------------------------------------------------------
