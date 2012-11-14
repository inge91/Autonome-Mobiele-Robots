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
%LOAD PRE RECORDED SEQUENCES
%--------------------------------------------------------------------------
load OmnicamCapture

figure();
movie(F_1);

figure();
movie(F_2);
