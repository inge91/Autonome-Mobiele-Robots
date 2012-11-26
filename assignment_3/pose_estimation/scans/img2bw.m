%IMG2BW    Convert the image into a Black & White image
%   OUTim = img2bw( INim , BWthreshold )Convert the image into a Black & White image
%   BWthreshold is the threshold
%
%   Author Davide Scaramuzza - davide.scaramuzza@ieee.org
%   ETH Zurich - April, 25, 2007


% function OUTim = img2bw( INim , BWthreshold )
    % im = img2gray( INim );
    % OUTim = INim;
    % OUTim ( find(im<=BWthreshold) ) = 0; 
    % OUTim ( find(im>BWthreshold) ) = 1;

function OUTim = img2bw( INim , Th )
    if length(size( INim )) == 3
        im = INim(:,:,2);                               % if it is a color image, just use the GREEN component
    else
        im = INim;
    end
    OUTim = im;
    OUTim ( find(im<=Th) ) = 1;
    OUTim ( find(im>Th) ) = 0;    
    