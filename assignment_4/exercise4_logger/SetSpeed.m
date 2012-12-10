function [] = SetSpeed(dPhi)
% 
% Input: vector of left/right wheels speeds in rad/s

    global m1;
    global m2;
    
    global robotOptions;
    
    % how fast do we want to move there?
    p1 = fix(robotOptions.rad_per_s_to_power*dPhi(1));
    if abs(p1) > robotOptions.maxPower
        disp('Warning: speed command for motor 1 too large, reducing value to maxPower ...');
        p1 = sign(p1)*robotOptions.maxPower;
    end
    m1.Power = p1;
    
    p2 = fix(robotOptions.rad_per_s_to_power*dPhi(2));
    if abs(p2) > robotOptions.maxPower
        disp('Warning: speed command for motor 1 too large, reducing value to maxPower ...');
        p2 = sign(p2)*robotOptions.maxPower;
    end
    m2.Power = p2;
    
    % move
    m1.SendToNXT();
    m2.SendToNXT();
%     NXTwriteData(hSerial, dPhi(1), dPhi(2), 0);
end