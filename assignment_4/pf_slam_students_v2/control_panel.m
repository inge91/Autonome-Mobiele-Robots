clear all
close all

% -------------------------------
%   PARAMETERS
% -------------------------------

% % odo noises
sigmaX = 0.003; % m
sigmaTH = deg2rad(0.02); % rad
PARAMS.Q= [sigmaX^2 0; 0 sigmaTH^2];

% % observation noises
sigmaR= 0.01; % m
sigmaB= deg2rad(0.01); % rad
PARAMS.R= [sigmaR^2 0; 0 sigmaB^2];

% NUM PARTICLES
PARAMS.NPARTICLES= 200; 

% laser filtering
PARAMS.FEAT_MIN_RANGE = 0.05;
PARAMS.FEAT_MAX_RANGE = 0.4;

% corner extraction
PARAMS.FEAT_MIN_ANGLE = deg2rad(150);
PARAMS.FEAT_MIN_PT_CHK = 4;
PARAMS.FEAT_MAX_DIST = 90;

% NN association threshold
PARAMS.NN_MAX_DIST = 18;

% Odometry filter
PARAMS.TOL_JMP = 0.02;

% Camera relative position respect to the wheels
PARAMS.CAMERA_POS_DX = 0.065;
PARAMS.CAMERA_POS_DY = 0.0;

% % resampling
EFECTIVE_PERCENTAGE= 0.75; % minimum number of effective particles before resampling

% -------------------------------
%   DATASET LOAD
% -------------------------------

log = ReadLogFile('log.txt');

% -------------------------------
%   PARTICLE FILTER SLAM
% -------------------------------

fastslam1_sim(log, PARAMS);