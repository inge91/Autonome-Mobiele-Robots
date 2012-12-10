function SaveEncoderData(fid, time_stamp, dx, dtheta, N)
fprintf(fid, '%f 0 %f %f ', time_stamp, dx, dtheta);
for i=1:N-2
    fprintf(fid, '-1 ');
end
fprintf(fid, '\n');
