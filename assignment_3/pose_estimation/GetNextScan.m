% This function reads a scan from the camera and returns the scan points
% in cartesian coordinate.
function  XY = GetNextScan
  
  configfile_lines;
  path(path, './scans/');
  
  % this can be done once at the beginning
  %  InitCamera;

  % Get the laser points in polar coordinate.
  scans = GetLaserScans(NSCANPOINTS);

  % Convert points to cartesian coordinate
  XY = zeros(NSCANPOINTS,2);
  theta = [0:(2*pi)/NSCANPOINTS:2*pi]';
  theta = theta(1:end-1)-(pi/2);
  
  [XY(:,1), XY(:,2)] = pol2cart(theta, scans');
  
return

