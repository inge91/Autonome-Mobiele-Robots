%**************************************************************************
%**************************************************************************
%InitCamera
%This script initialise the camera settings.
%First checks the connected video device and set the image format (in this
%example we set a VGA resolution (640x480 pixels).
%
%   Author Xavier Perrin - xavier.perrin@mavt.ethz.ch
%   based on the work of Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - Mai, 4, 2007
%**************************************************************************
%**************************************************************************

%--------------------------------------------------------------------------
%CHECK THE CONNECTED VIDEO DEVICE
%--------------------------------------------------------------------------
%Ask for the installed video library
imaqreset
imaqhwinfo
videoinfo = imaqhwinfo('winvideo')
AdaptorName = videoinfo.AdaptorName;
DeviceID = videoinfo.DeviceInfo.DeviceID;% recover the address of the video device

%List the supported formats
videoinfo.DeviceInfo.SupportedFormats;
format = 'RGB32_640x480';

%--------------------------------------------------------------------------
%CREATE A VIDEO INPUT OBJECT
%--------------------------------------------------------------------------
global vid
global center Rmax Rmin

vid = videoinput( AdaptorName, DeviceID, format );

stop(vid);
% Configure the object for manual trigger mode.
triggerconfig(vid, 'manual');

% Now that the device is configured for manual triggering, call START.
% This will cause the device to send data back to MATLAB, but will not log
% frames to memory at this point.
start(vid)

%% This lunches the camera calibration
cal = 1;
while(cal == 1)     %% It will keep calibrating until you are satisfied
    [response, center, Rmax, Rmin] = calibrate_camera(vid);
    if response == 'y'
        cal = 0;
    end
end