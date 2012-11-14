%IMG2BW    Convert the image into a Black & White image
%   OUTim = img2bw( INim , BWthreshold )Convert the image into a Black & White image
%   BWthreshold is the threshold
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007
function OUTim = img2bw( INim , BWthreshold )
    im = img2gray( INim );
    OUTim = INim;
    OUTim ( find(im<=BWthreshold) ) = 0; 
    OUTim ( find(im>BWthreshold) ) = 1;
    
    