clear all
close all

% -------------------------------
%   PARAMETERS
% -------------------------------

sigmaXs       =   [0.003   0.05   1      0.003   0.003   0.003  0.003  0.003 0.003   0.003 0.003];
sigmaTHs      =   [0.02    0.02   0.02   0.1     0.5     0.02   0.02   0.02  0.02    0.02  0.02];
sigmaRs       =   [0.01    0.01   0.01   0.01    0.01    0.1    0.5    0.01  0.01    0.01  0.01];
sigmaBs       =   [0.01    0.01   0.01   0.01    0.01    0.01   0.01   0.1   0.5     0.01  0.01];
particleNs   =   [200     200    200    200     200     200    200    200   200     10    1000];

filenames     =   {'default.png' 'sigmaX_0.05.png' 'sigmaX_1.png' ...
                   'sigmaTH_0.1.png' 'sigmaTH_0.5.png'            ...
                   'sigmaRs_0.1.png' 'sigmaRs_0.5.png'            ...
                   'sigmaBs_0.1.png' 'sigmaBs_0.5'                ...
                   'particles_10.png' 'particles_1000.png'};


% make sure the script doesn't fail near the end because of slordigheid
assert( length(sigmaXs) == length(filenames) );


% loop through each test scenario and save the result
for i = 1:length(sigmaXs)
    close all

    % % odo noises
    sigmaX = sigmaXs(i); % m
    sigmaTH = deg2rad( sigmaTHs(i) ); % rad
    PARAMS.Q= [sigmaX^2 0; 0 sigmaTH^2];

    % % observation noises
    sigmaR= sigmaRs(i); % m
    sigmaB= deg2rad( sigmaBs(i) ); % rad
    PARAMS.R= [sigmaR^2 0; 0 sigmaB^2];

    % NUM PARTICLES
    PARAMS.NPARTICLES= particleNs(i); 

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

    % save the image
    print('-dpng', filenames{i})

    close all
end
