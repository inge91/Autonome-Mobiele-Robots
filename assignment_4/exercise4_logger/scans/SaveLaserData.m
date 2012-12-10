function SaveLaserData(fid, time_stamp, laser_scans)
nb_scans = size(laser_scans,2);
fprintf(fid, '%f 1 ', time_stamp);
for i=1:nb_scans
    fprintf(fid, '%f ', laser_scans(i));
end
fprintf(fid, '\n');