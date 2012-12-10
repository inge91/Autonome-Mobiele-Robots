function InitRobotCommunication()

    
    global m1;
    global m2;
    global robotOptions;
    
    %% close and reopen connection
    COM_CloseNXT('all');
    hSerial = COM_OpenNXT();
    COM_SetDefaultNXT(hSerial);
    
    %% Create motor objects
    % we use holdbrake, make sense for robotic arms
    % SpeedRegulation: whether there is an underlying velocity controller
    m1 = NXTMotor(robotOptions.port1, 'Power', 0, 'ActionAtTachoLimit', robotOptions.ActionAtTachoLimit, 'SpeedRegulation', robotOptions.SpeedRegulation);
    m2 = NXTMotor(robotOptions.port2, 'Power', 0, 'ActionAtTachoLimit', robotOptions.ActionAtTachoLimit, 'SpeedRegulation', robotOptions.SpeedRegulation);

    %% Prepare motors
    m1.Stop('off');
    m1.ResetPosition();
    m2.Stop('off');
    m2.ResetPosition();
    
    m1.SendToNXT();
    m2.SendToNXT();
    
    pause(0.5); % get ready...
end