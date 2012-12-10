function data = GetRobotData()

    global m1;
    global m2;

    data = zeros(1,2);
    deg2rad = pi/180;

    data_struct = m1.ReadFromNXT();
    data(1) = data_struct.Position * deg2rad;
    data_struct = m2.ReadFromNXT();     
    data(2) = data_struct.Position * deg2rad;

end
