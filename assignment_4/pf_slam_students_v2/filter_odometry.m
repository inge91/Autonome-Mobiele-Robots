function valid = filter_odometry(Dr, Dth, TOL_JMP)



Dx = Dr*cos(Dth);
Dy = Dr*sin(Dth);


if(sqrt(Dx^2 + Dy^2) < TOL_JMP)
    valid = 1;
else
    valid = 0;
end