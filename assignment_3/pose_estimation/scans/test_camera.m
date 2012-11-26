%**************************************************************************
%**************************************************************************
%TEST_CAMERA
%This script helps testing if the camera works propoerly.
%First checks the connected video device and set the image format (in this
%example we set a VGA resolution (640x480 pixels).
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007
%**************************************************************************
%**************************************************************************

%--------------------------------------------------------------------------
%CHECK THE CONNECTED VIDEO DEVICE
%--------------------------------------------------------------------------
%Ask for the installed video library
imaqhwinfo
videoinfo = imaqhwinfo('winvideo')
AdaptorName = videoinfo.AdaptorName;
DeviceID = videoinfo.DeviceInfo.DeviceID;% recover the address of the video device

%List the supported formats
videoinfo.DeviceInfo.SupportedFormats'
format = 'RGB32_640x480';

%--------------------------------------------------------------------------
%CREATE A VIDEO INPUT OBJECT
%--------------------------------------------------------------------------
vid = videoinput( AdaptorName, DeviceID, format );
preview(vid);% run the preview of the camera

%--------------------------------------------------------------------------
%ACCESSING VIDEO PROPERTIES
%--------------------------------------------------------------------------
%To access a complete list of an object's properties and their current
%values, use the GET function with the object.
%--------------------------------------------------------------------------

% List the video input object's properties and their current values.
get(vid)
% Access the currently selected video source object
src = getselectedsource(vid);
% List the video source object's properties and their current values.
get(src)

%--------------------------------------------------------------------------
%CONFIGURING VIDEO PROPERTIES
%--------------------------------------------------------------------------
%Enumerated properties have a defined set of possible values. To list the 
%enumerated values of a property, use the SET function with the object and 
%property name. The property's default value is listed in braces. 

%List the video input object's configurable properties.
set(vid)
%List the video source object's configurable properties.
set(src)
%When an image acquisition object is no longer needed, remove it from
%memory and clear the MATLAB workspace of the associated variable.
%delete(vid);
%clear vid;