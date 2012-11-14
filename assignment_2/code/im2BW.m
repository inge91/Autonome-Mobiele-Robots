%Convert the image into a Black & White image
%Th is the threshold
function OUTim = img2bw( INim , Th )

    if length(size( INim )) == 3
        im = INim(:,:,2); %                 if it is a color image, just use the GREEN component
    else
        im = INim;
    end
    OUTim ( find(im<=Th) ) = 0; 
    OUTim ( find(im>Th) ) = 1;
    
    