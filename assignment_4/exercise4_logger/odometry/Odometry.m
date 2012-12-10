function [dx, dtheta] = Odometry(dS, halfwheelbase)

    dSr = dS(1);                    % change in the encoder value for the right wheel since the last time step [rad]
    dSl = dS(2);                    % change in the encoder value for the left wheel since the last time step [rad]
    
    % Delta x, delta theta in the robot-centered frame
    dx = ((dSl + dSr) / 2);
    
    % dy = 0  (!!)

    dtheta = (dSr - dSl) / (2*halfwheelbase);  % current orientation
    dtheta = Set2range(dtheta);
end