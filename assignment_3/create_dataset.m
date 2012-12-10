% camera calibration should only be done once
function dist = create_dataset(N)

global center Rmax Rmin vid

snapshot = imread(vid);

count = 1;
%angsteps = [0.05, 0.5, 1, 1.5, 2, 5, 10];
angsteps = 360/N;
for i = 1:length(angsteps)
    % angstep should be experimented with
    [undistortedimg, theta] = imunwrap(snapshot, center, angsteps(i) ,Rmax, Rmin);

% Show the undistorted image
    %figure;
    %imagesc(undistortedimg);
    %colormap(gray)

    
    %BWthresholds = [75, 80, 85, 90, 95 100];
    BWthresholds = 100;
    for j = 1:length(BWthresholds)
        % Set black and white threshold
        BWimg = img2bw(undistortedimg, BWthresholds(j));
        %imagesc(BWimg)
        rho = getpixeldistance(BWimg, Rmin);

    %im = imread('omni_snapshot.jpg');
    %figure;
    figure(3);
    imagesc(snapshot);
    hold on;
    drawlaserbeam(center, theta, rho);

        
        %alphas =[80, 95, 100, 120, 130, 150];
        alphas = 107;
        for k = 1:length(alphas)
            height = 0.07;
            dist = undistort_dist_points(theta, rho, alphas(k), height);
            figure;
            axislimit = 1;
            'draw beam'
            draw_undistorted_beam(dist, theta, axislimit, angsteps(i), BWthresholds(j), alphas(k), count);
            %count = count + 1
        end
    end
    
end




