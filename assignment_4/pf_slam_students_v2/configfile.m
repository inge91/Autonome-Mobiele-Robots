%%% Configuration file
%%% Permits various adjustments to parameters of the FastSLAM algorithm.
%%% See fastslam_sim.m for more information

% switches
SWITCH_CONTROL_NOISE= 0;
SWITCH_SENSOR_NOISE = 1;
SWITCH_INFLATE_NOISE= 0;
SWITCH_PREDICT_NOISE = 0;   % sample noise from predict (usually 1 for fastslam1.0 and 0 for fastslam2.0)
SWITCH_SAMPLE_PROPOSAL = 1; % sample from proposal (no effect on fastslam1.0 and usually 1 for fastslam2.0)
SWITCH_HEADING_KNOWN= 0;
SWITCH_RESAMPLE= 1; 
SWITCH_PROFILE= 1;
SWITCH_SEED_RANDOM= 0; % if not 0, seed the randn() with its value at beginning of simulation (for repeatability)


% Parameters for line extraction

RMIN = 0.01;              % in [m]
RMAX = 1.0;              % in [m]
INLIERTHRESHOLD = 0.01;  % in [m]
MINSEGPOINTS = 2;        % Minimum number of points for a segment
MINSEGLENGTH = 0.01;      % Minimum actual length for a segment [m]
MINCLUPOINTS = 3;        % Minimum number of points for a cluster
RHOPEAKLEVEL = 0.12;     % Normalized peak level of rhodiff, used for clustering

LINKMIN        = 0.1;
LINKMIN_SQ     = LINKMIN*LINKMIN;     % min dist to link edges for detecting a corner