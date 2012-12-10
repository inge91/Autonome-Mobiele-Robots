function [dEncoder, encoder] = GetEncoder(robotData, encoder)
    dEncoder = robotData - encoder; % calculate change in encoder value from previous time step
    encoder = encoder + dEncoder; % accumulate total encoder value
end