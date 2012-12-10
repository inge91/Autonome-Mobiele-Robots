% % --------------------------------------------------------------------------
% % Uncomment this portion in if you're not using the GUI
% 
% % SET COM PORT
% COMPORT = '\\.\\COM6'; % virtual COM port number
% 
% %% SET INITIAL ROBOT POSITION.
% startPose = [ 0, 0, pi/2 ]; % sets the robot start pose
% 
% %% SET FINAL ROBOT POSITION.
% goalPose = [ 0.5, 0.5, 0.0, 0.1, 25.0 ]; % sets the robot goal pose
% THRESHOLD = 0.25; % threshold distance to goal
% 
% %% SET CONTROL PARAMETERS.
% global Krho;
% global Kalpha;
% global Kbeta;
% Krho = 0.15;
% Kalpha = 0.5;
% Kbeta = -0.2;
% 
% %% SET ROBOT CONSTANTS.
% robotConst(1) = 0.02700; % wheel radius
% robotConst(2) = 0.142/2; % 1/2 wheelbase
% 
% %% Run or Simulate
% SIMULATE = 1;

%--------------------------------------------------------------------------

%% ROBOT PARAMTER SETUP
global robotOptions;
% robotOptions = struct('maxPower','port1','port2','ActionAtTachoLimit','SpeedRegulation');

robotOptions.maxPower = 60; % maximum power in percent to send, needs to be an integer in the range [-100,100]
robotOptions.port1 = MOTOR_A;
robotOptions.port2 = MOTOR_C;
robotOptions.ActionAtTachoLimit= 'Brake';
robotOptions.SpeedRegulation = 1;

% took the conversion factor from
% http://www.philohome.com/nxtmotor/nxtmotor.htm (blue line)
% assuming a linear relationship
robotOptions.rad_per_s_to_power = 1/1.6*60/(2*pi);


OUTBOUNDS = 5; % if the robot is OUTBOUNDS (m) distance away from the goal, then the controller has probably exploded
SAMPLES = 50; % max number of samples to take



%% ROBOT COMMUNICATION SETUP.
if(SIMULATE)
    SAMPLINGTIME = 0.15; % Sampling time in seconds.
else
    InitRobotCommunication(); % initializes BT communication
end

%% INITIALIZE CONTROLLER.
pose = startPose; % current position
PhiPrime = [0 0]; % speed of each wheel [rad/s]
S = [0 0]; % accumulated encoder values [m]
dS = [0 0]; % encoder value since last time step [m]
rho = OUTBOUNDS; % distance from the goal

%% INITIALIZE SOME VARIABLES.
trajectory = ones(SAMPLES, 3).*nan;
data = ones(SAMPLES, 10).*nan;
ultrasoundArray1 = ones(SAMPLES, 3).*nan;
ultrasoundArray2 = ones(SAMPLES, 3).*nan;
irArray1 = ones(SAMPLES, 3).*nan;
irArray2 = ones(SAMPLES, 3).*nan;