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