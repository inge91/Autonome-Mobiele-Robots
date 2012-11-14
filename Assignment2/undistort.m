function Nimg = undistort( img , center, alpha )
% Parameters of the new image
fc = 7;
Nwidth = 320;
Nheight = 240;
Nxc = Nheight/2;
Nyc = Nwidth/2;
Nz  = -Nwidth/fc;

if length(size(img)) == 3;
    Nimg = zeros(Nheight, Nwidth, 3);
else
    Nimg = zeros(Nheight, Nwidth);
end

for i = 1:Nheight
    for j = 1:Nwidth
        Nx = i-Nxc;
        Ny = j-Nyc;
        if (Nx==0 & Ny==0)
            continue;
        end
        rho = sqrt(Nx^2 + Ny^2);
        theta = atan(abs(rho/Nz));
        r = alpha*theta;
        
        x = round( Nx*r/rho + center(2) );
        y = round( Ny*r/rho + center(1) );
        if x <= 0 | y <= 0 | x > size(img,1) | y > size(img,2)
            Nimg(i,j,:) = 0;
        else
            Nimg(i,j,:) = img(x,y,:);
        end
    end
%   (i*Nwidth+j)/(Nwidth*Nheight)*100
end

Nimg = uint8(Nimg);
figure; imagesc(Nimg); axis equal;
title( ['alpha = ',num2str(alpha)]);
