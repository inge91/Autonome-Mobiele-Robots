function [rho , theta] = prepare_laser(laser_buff, PARAMS)



% size definitions
c_size = size(laser_buff, 2);

las_res = 2*pi / (c_size); % avoid timestamp and data nature
las_th_st = -pi;
las_th_span = 2*pi;


% trasforms laser coordinates n the right reference frame

theta = las_th_st:las_res:las_th_st+las_th_span - deg2rad(1);

% prune invalid distance points
valid = (laser_buff > PARAMS.FEAT_MIN_RANGE) & (laser_buff < PARAMS.FEAT_MAX_RANGE);

% % rad2deg(las_res)
% % size(theta)
% % size(laser_buff)

rho = laser_buff(valid);
theta = theta(valid);


th_valid1 = (theta > -pi/2) & (theta < pi/2);


theta = theta(th_valid1);
rho = rho(th_valid1);

% % % 
% % % % size definitions
% % % c_size = size(laser_buff, 2);
% % % 
% % % las_res = 2*pi / (c_size); % avoid timestamp and data nature
% % % las_th_st = 0;
% % % las_th_span = 2*pi;
% % % 
% % % 
% % % % trasforms laser coordinates n the right reference frame
% % % 
% % % theta = las_th_st:las_res:las_th_st+las_th_span - deg2rad(1);
% % % 
% % % % prune invalid distance points
% % % valid = (laser_buff > PARAMS.FEAT_MIN_RANGE) & (laser_buff < PARAMS.FEAT_MAX_RANGE);
% % % 
% % % % % rad2deg(las_res)
% % % % % size(theta)
% % % % % size(laser_buff)
% % % 
% % % rho = laser_buff(valid);
% % % theta = theta(valid);
% % % 
% % % 
% % % th_valid_a = (theta > 0) & (theta < pi/2);
% % % th_valid_b = (theta > 3*pi/2);
% % % 
% % % theta = [theta(th_valid_a) theta(th_valid_b)];
% % % rho = [rho(th_valid_a) rho(th_valid_b)];