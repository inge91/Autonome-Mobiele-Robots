%LASERSCAN_TEST
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007

stop(vid);
% Configure the object for manual trigger mode.
triggerconfig(vid, 'manual');

% Now that the device is configured for manual triggering, call START.
% This will cause the device to send data back to MATLAB, but will not log
% frames to memory at this point.
start(vid)

% -------------------------------------------------------------------------
% MOST IMPORTANT PARAMETERS
% -------------------------------------------------------------------------
% Rmax = 160;%        Max detectable distance, set to 160 pixels in VGA images.
%                     Rmax was already loaded when calling "calibrate_camera.m"
% Rmin = 77;%         Min detectable distance in pixels in VGA image
%                     Rmin was already loaded when calling "calibrate_camera.m"
alpha = 112;%         Radial distortion coefficient
height = 0.17;%       camera height in meters
BWthreshold = 180;%   Threshold for segment the image into Black & white colors
angstep = 1;%         Angular step of the beam in degrees
axislimit = 0.8;%     Axis limit

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------
while 1
    tic;%                               Start counting elapsed time
    
    snapshot = getsnapshot(vid);%       Acquire image
    
    snapshot = imflipud( snapshot );%   Flip the image Up-Down
         
    [undistortedimg, theta] = imunwrap( snapshot , center, angstep, Rmax, Rmin);% Transform omnidirectional image into a rectangular image

    BWimg = img2bw( undistortedimg , BWthreshold );% Binarize rectangular image into Blak&White

    rho = getpixeldistance( BWimg , Rmin );%     Get radial distance (this distance is still affected by radial distortion)
    
%    figure(1); imagesc(snapshot); hold on; drawlaserbeam( center, theta, rho );        
    
    dist = undistort_dist_points( theta , rho , alpha , height );
    
    dist = [dist((181):end) dist(1:(180))];

    figure(2); draw_undisdtorted_beam( dist , theta , axislimit ); drawnow;

%    c = img2bw( grayimg , BWthreshold ); figure(3); imagesc(c); colormap(gray); drawnow;

% Compute the time per frame and effective frame rate.
elapsedTime = toc;
effectiveFrameRate = 1/elapsedTime
end