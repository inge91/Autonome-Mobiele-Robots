log1 



% % odo noises
sigmaX = 0.01; % m
sigmaTH = deg2rad(3); % rad
PARAMS.Q= [sigmaX^2 0; 0 sigmaTH^2];

% % observation noises
sigmaR= 0.01; % m
sigmaB= deg2rad(1); % rad
PARAMS.R= [sigmaR^2 0; 0 sigmaB^2];

% NUM PARTICLES
PARAMS.NPARTICLES= 10000; 

% laser filtering
PARAMS.FEAT_MIN_RANGE = 0.05;
PARAMS.FEAT_MAX_RANGE = 0.4;

% corner extraction
PARAMS.FEAT_MIN_ANGLE = deg2rad(150);
PARAMS.FEAT_MIN_PT_CHK = 4;
PARAMS.FEAT_MAX_DIST = 90;

% NN association threshold
PARAMS.NN_MAX_DIST = 0.1;

% Odometry filter
PARAMS.TOL_JMP = 0.02;

% Camera relative position respect to the wheels
PARAMS.CAMERA_POS_DX = 0.11;
PARAMS.CAMERA_POS_DY = 0.0;






%%%%%%%%%%%

% % odo noises
sigmaX = 0.01; % m
sigmaTH = deg2rad(4); % rad
PARAMS.Q= [sigmaX^2 0; 0 sigmaTH^2];

% % observation noises
sigmaR= 0.01; % m
sigmaB= deg2rad(1); % rad
PARAMS.R= [sigmaR^2 0; 0 sigmaB^2];

% NUM PARTICLES
PARAMS.NPARTICLES= 1000; 

% laser filtering
PARAMS.FEAT_MIN_RANGE = 0.05;
PARAMS.FEAT_MAX_RANGE = 0.4;

% corner extraction
PARAMS.FEAT_MIN_ANGLE = deg2rad(150);
PARAMS.FEAT_MIN_PT_CHK = 4;
PARAMS.FEAT_MAX_DIST = 90;

% NN association threshold
PARAMS.NN_MAX_DIST = 0.08;

% Odometry filter
PARAMS.TOL_JMP = 0.02;

% Camera relative position respect to the wheels
PARAMS.CAMERA_POS_DX = 0.11;
PARAMS.CAMERA_POS_DY = 0.0;
