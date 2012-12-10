function  do_map(h,  particles, z, PARAMS)
pnum = size(z,2);

figure(h(2))
subplot(1,2,1)
hold on

xvp = [particles.xv];
w = [particles.w]; 

ii= find(w== max(w)); 

% take just the 1st
ii = ii(1);
% xfp = [particles(ii).xf] + repmat([PARAMS.CAMERA_POS_DX;
% PARAMS.CAMERA_POS_DY], 1, size(particles(ii).xf,2));

% if(~isempty(xfp))
%     plot(xfp(1,:), xfp(2,:), 'm+');
% end
%     
xvm= xvp(:,ii);
% plot(xvm(1,:), xvm(2,:),'r.', 'MarkerSize', 10)
plot(xvp(1,:), xvp(2,:),'r.', 'MarkerSize', 4)

lastbp = xvm;

if(~isempty(z))
    [x_pts, y_pts] = pol2cart(z(2,:), z(1,:));
    Pts = [x_pts; y_pts];
    
    theta = xvm(3);
    
    R = [cos(theta) -sin(theta);sin(theta) cos(theta)] ;

    Pts_wrt = R * Pts + repmat([xvm(1); xvm(2)], 1, pnum) + repmat([PARAMS.CAMERA_POS_DX; PARAMS.CAMERA_POS_DY], 1, pnum);
    
    plot(Pts_wrt (1,:), Pts_wrt (2,:),'k.');
end
grid on

% pause