function dist = CalibrateScans()

global vid
global center Rmax Rmin
clc;

N = 722;

alpha = 107;%         Radial distortion coefficient
height = 0.1261;%     camera height in meters

BWthreshold = 180; %   Threshold for segment the image into Black & white colors
angstep = 360/N;%         Angular step of the beam in degrees
axislimit = 0.8;%     Axis limit

path(path, './scans/');
configfile_blobs;

while true 
    snapshot = getsnapshot(vid);%       Acquire image

    snapshot = imflipud( snapshot );%   Flip the image Up-Down

    [undistortedimg, theta] = imunwrap( snapshot , center, angstep, Rmax, Rmin);% Transform omnidirectional image into a rectangular image

    BWimg = img2bw( undistortedimg , BWthreshold ); % Binarize rectangular image into Blak&White

    rho = getpixeldistance( BWimg , Rmin );%     Get radial distance (this distance is still affected by radial distortion)

    figure(1); imagesc(snapshot); hold on; axis equal; drawlaserbeam( center, theta, rho ); %pause;

    dist = undistort_dist_points( theta , rho , alpha , height );
    XY = zeros(2,722);
    [XY(1,:), XY(2,:)] = pol2cart(theta, dist);
    figure(2); clf; hold on; axis equal;axis([-0.5 0.5 -0.5 0.5]); plot(XY(1,:), XY(2,:), 'y.-');
    [NLines, line_r, line_alpha, segend, seglen] = recsplit(XY);
    color = 0;
    for i=1:NLines
        if color == 0, c = 'r'; elseif color == 1, c = 'b'; else c = 'g'; end
        line([segend(i,1) segend(i,3)], [segend(i,2) segend(i,4)], ...
            'color', c, 'linewidth', 3);
        color = mod(color+1, 3);
    end
  
    %----------------------------------------------------------------------
    
    img_center = center';
	radius = Rmax;
	radius_inner = Rmin;

	%% color segment
	[cl_angles, cl_center, cl_type] = color_segment(color_s, snapshot, sat, lum, max_pxarea, min_pxarea, img_center, radius, radius_inner , stdthreshold);
	[ cl_center , cl_type ]

	rad2deg(cl_angles)
	figure(12); imshow(snapshot); hold on;  axis equal; 
	plot([img_center(1, 1), img_center(1,1) + 100],[img_center(1,2), img_center(1,2)], 'y-');
	plot([img_center(1, 1), img_center(1,1)],[img_center(1,2), img_center(1,2) + 100], 'y-');
 
	if(isempty(cl_center) ~= 1)
		plot(cl_center(:, 2),  cl_center(:, 1), 'mx', 'MarkerSize', 5);
	end

end