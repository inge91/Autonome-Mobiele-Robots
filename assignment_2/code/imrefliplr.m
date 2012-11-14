function out = imrefliplr( im )
if length(size(im))==3
    out(:,:,1) = fliplr( im(:,:,1) );
    out(:,:,2) = fliplr( im(:,:,2) );
    out(:,:,3) = fliplr( im(:,:,3) );    
else
    out = fliplr( im );
end