function  do_odo_map(h,  odometry, z, PARAMS)
pnum = size(z,2);

figure(h(1))
% subplot(1,2,1)
title('Odometry Map');
xlabel('[m]');
ylabel('[m]');

hold on
odometry.xv(1)
odometry.xv(2)

plot(odometry.xv(1,:), odometry.xv(2,:),'b.', 'MarkerSize', 8)

if(~isempty(z))
    [x_pts, y_pts] = pol2cart(z(2,:), z(1,:));
    Pts = [x_pts; y_pts];
    
    theta = odometry.xv(3);
    
    R = [cos(theta) -sin(theta);sin(theta) cos(theta)] ;

    Pts_wrt = R * Pts + repmat([odometry.xv(1); odometry.xv(2)], 1, pnum) + repmat([PARAMS.CAMERA_POS_DX; PARAMS.CAMERA_POS_DY], 1, pnum);
    
    plot(Pts_wrt (1,:), Pts_wrt (2,:),'k.');
end
grid on

% pause