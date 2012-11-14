%IMG2GRAY convert a color image into gray-scale
%   GRAYIMG = IMG2GRAY(COLORIMG)
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007
function grayimg = img2gray( colorimg )
if length(size(colorimg))==3
    grayimg = colorimg(:,:,2);
else
    grayimg = colorimg;
end