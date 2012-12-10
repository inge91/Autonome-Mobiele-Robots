function [] = StopRobotCommunication()
    SetSpeed([0,0]);
    COM_CloseNXT all;
end