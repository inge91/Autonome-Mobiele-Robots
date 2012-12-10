%UNDISTORT_DIST_POINTS Remove radial distortion of distance points
%It uses the camera model and reproject the points onto the ground floor
%using the scale factor "scale"
function new_dist = undistort_dist_points( theta, rho, alpha, scale )

new_dist = scale * tan( rho ./ alpha );