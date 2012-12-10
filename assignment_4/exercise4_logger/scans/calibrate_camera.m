function [response, center, Rmax, Rmin] = calibrate_camera(vid)

%global vid
%global center Rmax Rmin

disp('starting acquisition. Please wait...');
for i=1:1
    tmpsnapshot = getsnapshot(vid);
end

% Flip the image Up-Down
snapshot = imflipud( tmpsnapshot );

% Max detectable distance (set to 160 pixel by default in VGA image).
% Rmax is automatically scaled according to the image size
Rmax = round( 160/480*size(snapshot,1) )
% Min detectable distance (set to 77 pixel by default in VGA image).
% Rmax is automatically scaled according to the image size
Rmin = round( 77/480*size(snapshot,1) )

% This functrion allows you to calibrate the camera (extract the center of
% the image). Follow the directions on-line
figure(1); [center, radius] = get_circle(snapshot);
center
% Draw the max and min radius
draw2DCircle(center,Rmin,'m');
draw2DCircle(center,Rmax,'m');


% This function convert the omnidirectional picture into a rectangular
% image. Use this tool to see if the calibration was accurately done (for
% example the smaller circle of the camera objective should transform into
% a horizontal line. Check this. Is the line is not perfectly horizontal,
% you may have to repeat the calibration. The calibration is very important
% to have an accurate detection of the distance.
ud = unwrap_allimage(snapshot, center, Rmax, 1, 0); figure(2); imagesc(ud);
% Draw radius
hold on; line ( [0, size(ud,2) ], [ round(radius), round(radius) ] , 'Color', 'r', 'LineWidth', 2);
% Draw Rmin
hold on; line ( [0, size(ud,2) ], [ round(Rmin), round(Rmin) ] , 'Color', 'm', 'LineWidth', 2);
hold off;



response = input('Are you satisfied with the calibration? (y/n)', 's');

close(1)
close(2)