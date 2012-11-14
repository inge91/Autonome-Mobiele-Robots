%GET_CIRCLE Etract a circle from the image
%
%   [center, radius]=GET_CIRCLE(I) Fits the maximux radius circle visible on the image and returns 
%   the center coordinates and external radius
%   I is the input image, which can be both color or grayscale image.
%   center = coordinates of the circle center, center=[col;row]
%   radius = radius of the extracted circle
%
%   Author Davide Scaramuzza EPFL davsca@tiscalli.it, March, 10, 2006


function [center, radius]=get_circle(I)

imagesc(I);
title('Click on the expected image center');
initial_center=ginput(1)';        
title('Now click on the image external point');

outerPoint=ginput(1)';

title('Fitting circle...');

Rmin=0.8*norm(outerPoint-initial_center);
Rmax=1.2*norm(outerPoint-initial_center);

if length(size(I))==2%isgray(I)
    img=I;
else
    img=rgb2gray(I);
end
edge_img=edge(img,'sobel'); 
edge_img=remove_int_ext_bord(edge_img,initial_center,Rmin,Rmax);
[center,radius]=extractCircle(edge_img,initial_center,outerPoint);
draw2DCircle(center,radius,'r');
title('Circle fitted');



function img_out=remove_int_ext_bord(I,center,Rmin,Rmax)

%center is a one-column vector where c(2) is line and c(1) is column number
[lines,cols]=size(I);

x=[1:lines]';
x=x*ones(1,cols);
y=[1:cols];
y=ones(lines,1)*y;
x=x-center(2);
y=y-center(1);
rho=sqrt(x.^2+y.^2);
z=zeros(size(I));
z(find(rho<Rmax & rho>Rmin))=1;
img_out=z.*I;

function [C_final,r_final]=extractCircle(I, center, outerPoint)

[lines,cols]=size(I);

if (nargin<3)
   if (nargin==1)
       fprintf(1,'Click on the image center\n');
       center=ginput(1)';
   end
    fprintf(1,'Click on the image external point\n');
    outerPoint=ginput(1)';
end



radius_threshold=0.10;

if nargout==0
  fprintf(1,'Lauching test mode...\n'); 
  test=1;
else
  test=0;
end

edgeI=I;

if(test)
  figure(5);
  imshow(edgeI);

  figure(6);
  imshow(uint8(I));
  hold on;

  plot(center(1),center(2),'mo');
end
%figure(2); imshow(edgeI);

X=[];
Y=[];

fprintf(1,'Rejecting inner points... ');

est_radius=norm(center-outerPoint);

for i=1:lines
  for j=1:cols
    if edgeI(i,j)~=0
      distToCenter = norm([j;i]-center);
      
      if(abs(distToCenter-est_radius)>radius_threshold*est_radius)
	edgeI(i,j)=0;
      else
	%Remove points between the point and the center
	l_dist=1;
	
	while(l_dist>0.9)
	  G=l_dist*[j;i]+(1-l_dist)*center;
	  gx=round(G(1));
	  gy=round(G(2));
	
	  if((edgeI(gy,gx)==1)&gx~=j&gy~=i)
	    edgeI(gy,gx)=0;
	  end
	  l_dist=l_dist-0.2/distToCenter;
	end
      end
    end
  end
end

if(test)
  figure(7)
  imshow(edgeI);
end

if(test)
  figure(8)
  imshow(edgeI);
end

%return
for i=1:lines
  for j=1:cols
    if edgeI(i,j)~=0
      X=[X,j];
      Y=[Y,i];
    end
  end
end

fprintf(1,'done.\n');

C=[];
r=[];

fprintf(1,'Doing a simplified RANSAC to obtain circle parameters... ');

% Sort of ransac, except than
% instead of creating all the model
% the median is used on the parameters
for i=1:1000
  [C_c,r_c]=randCircleProps(X,Y);
  C=[C,C_c];
  r=[r;r_c];
end

C_final=median(C,2);
r_final=median(r);

fprintf(1,'done.\n');

if(test)
  figure(6);
  draw2DCircle(C_final,r_final,'r-');
  plot(C_final(1),C_final(2),'yx');
end

function [C,r]=randCircleProps(X,Y)
[lines,nbPoints]=size(X);

T=randTriplet(nbPoints);
[C,r]=circleProps([X(T(1)),Y(T(1));...
		   X(T(2)),Y(T(2));...
		   X(T(3)),Y(T(3))]);

function T=randTriplet(nbPoints)
T=round(rand(3,1)*nbPoints);
if T(1)==0
  T(1)=1;
end
if T(2)==0
  T(2)=1;
end
if T(3)==0
  T(3)=1;
end


function L=makeLine(A)
L=[A(1)^2+A(2)^2, -2*A(1), -2*A(2), 1];

%
% P in the form Nx2
%
function [C,r]=circleProps(P)
[nbPoints,cols]=size(P);

M=[P(:,1).^2+P(:,2).^2,-2*P(:,1),-2*P(:,2),ones(nbPoints,1)];

[U,S,V]=svd(M);
nullV=V(:,4);
nullV=nullV/nullV(1);
C=[nullV(2);nullV(3)];
r=sqrt(nullV(2)^2+nullV(3)^2-nullV(4));


function draw2DCircle(center,radius,color)

t = linspace(0,pi*2);
x = radius * cos(t);
y = radius * sin(t);
nx = x + center(1); 
ny = y + center(2);
hold on
plot(nx,ny,color,'linewidth',2);
plot(center(1),center(2),'ro');
hold off;