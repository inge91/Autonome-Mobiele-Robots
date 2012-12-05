%IMFLIPUD   Flip the image Up-Down
%   OUT_IMAGE = IMFLIPUD(INPIT_IMAGE)

function out = imflipud( im )
if length(size(im))==3
    out(:,:,1) = flipud( im(:,:,1) );
    out(:,:,2) = flipud( im(:,:,2) );
    out(:,:,3) = flipud( im(:,:,3) );    
else
    out = flipud( im );
end