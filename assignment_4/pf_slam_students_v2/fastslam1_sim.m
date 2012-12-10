function data = fastslam1_sim(logmatrix, PARAMS)
% OUTPUTS:
%   data - set of particles representing final state
%
% Tim Bailey and Juan Nieto 2004.

% % % % % % % % % % % % % % % % 
% Luciano Spinello 2007 - 2008
% - Per particle data associtation unknown (NN)
% - Corner extractor from line segments
% 
% Autonomous Systems Lab
% Institute of Robotics and Intelligent Systems
% ETH Zürich

format compact

% some spec. conf. params
configfile;
NEFFECTIVE = 0.75*PARAMS.NPARTICLES; % minimum number of effective particles before resampling

%  setup for figures
h= setup_animations();

% initialisations
particles= initialise_particles(PARAMS.NPARTICLES);
odometry = initialise_particles(1);

% covar. matrices for odo and range sensor
Qe= PARAMS.Q; Re= PARAMS.R;

% size of the logfile
m_size = size(logmatrix, 1);
c_size = size(logmatrix, 2);

% start time of the algorithm
t0 = 0;

% Main loop
for logrow=1:m_size,
    rho = [];
    theta = [];
    
    % timing
    t1 = logmatrix(logrow,1);
    dt = t1 - t0;
    t0 = t1;

    % check if the input is the odometry
    if(logmatrix(logrow,2) == 0)
 
        % Coarse filter wheel encoder values 
        if(filter_odometry(logmatrix(logrow,3) , logmatrix(logrow,4), PARAMS.TOL_JMP))
 
            % Odometry predict step for each particle
            for i=1:PARAMS.NPARTICLES
                particles(i) = predict_odo (particles(i), logmatrix(logrow,3), logmatrix(logrow,4), Qe);
            end
            
        end
    end


    % Observation step and update of the particle set

    % check if the input is a sensor measurement
    if(logmatrix(logrow,2) == 1)

        % transf. respect to bearing  angle
        % prune invalid distance points
        [rho, theta] = prepare_laser(logmatrix(logrow,3:end), PARAMS);

        % corner extraction from laser data
        [z, z_nf] = extract_beacon4(rho, theta);

        % if features are found
        if(~isempty(z))
            msg = sprintf('Observed %d features',size(z,2));
            msg
            do_feature_plot(h, z, z_nf, [rho; theta]);
            
            % Perform update
            for i=1:PARAMS.NPARTICLES
                % per particle data association 
                [zf, idf, zn, particles(i).da_table] = data_associate_unknown(particles(i), z, particles(i).da_table, PARAMS);

                if ~isempty(zf) % re-observation of map features
                    w = compute_weight(particles(i), zf, idf, PARAMS.R); % w = p(z_k | x_k)
                    particles(i).w= particles(i).w * w;
                    particles(i)= feature_update(particles(i), zf, idf, PARAMS.R);
                end

                if ~isempty(zn) % observe new features, increase the map with new features
                    particles(i)= add_feature(particles(i), zn, PARAMS);
                end
                particles(i).da_table = particles(i).xf;
            end

            % resample step of the particle filter
            particles= resample_particles(particles, NEFFECTIVE, 1);

            % plot map relative to the best particle
            do_map(h, particles, [rho; theta], PARAMS);
        end
 
    end

    % plot particle set
    do_plot(h, particles);
    
  
end

data= particles;


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


function h= setup_animations()
% h(1) = figure(1);
% hold on, axis equal

h(2) = figure(2);
hold on, axis equal


% % % % % % % % % % % % % 

function do_feature_plot(h, z, z_nf, pts)

figure(h(2))
subplot(1,2,2)

[x, y] = pol2cart(z(2,:), z(1,:));
[xs, ys] = pol2cart(pts(2,:), pts(1,:));
[x_nf, y_nf] = pol2cart(z_nf(2,:), z_nf(1,:));

% Plot extracted segments
axis([-0.5 0.5 -0.5 0.5]), ;
color = 0;

plot([0], [0], 'og'), hold on;
plot(xs, ys, 'k.'), grid on;;

sz = size(z_nf,2);

% for i=1:2:sz,
%     if color   == 0, c = 'r'; elseif color   == 1, c = 'b'; else c = 'g'; end
%     line([x_nf(i) x_nf(i + 1)], [y_nf( i) y_nf(i + 1)], 'color', c, 'linewidth', 2);
%     color   = mod(color  +1, 3);
% end

% Plot
plot(x, y, 'm*', 'MarkerSize', 10);
title('Sensor view and feature detection');
xlabel('[m]');
ylabel('[m]');
hold off

 


% % % % % % % % % % % % % 

function do_plot(h, particles)
figure(h(2))
subplot(1,2,1)
title('Particle filter SLAM');
xlabel('[m]');
ylabel('[m]');

xvp = [particles.xv];
w = [particles.w];

ii = find(w== max(w));

% take the first
ii = 1;

xvmax= xvp(:,ii);

% plot(xvmax(1,:), xvmax(2,:),'r.', 'MarkerSize', 10)
plot(xvp(1,:), xvp(2,:),'r.', 'MarkerSize', 4)

xfp = [particles(ii).xf];

% if(~isempty(xfp))
%     plot(xfp(1,:), xfp(2,:), 'm+');
% end
grid on

drawnow

% % % % % % % % % % % % % 
function p= make_laser_lines (rb,xv)
if isempty(rb), p=[]; return, end
len= size(rb,2);
lnes(1,:)= zeros(1,len)+ xv(1);
lnes(2,:)= zeros(1,len)+ xv(2);
lnes(3:4,:)= transformtoglobal([rb(1,:).*cos(rb(2,:)); rb(1,:).*sin(rb(2,:))], xv);
p= line_plot_conversion (lnes);

function p= initialise_particles(np)
for i=1:np
    p(i).w= 1/np;
    p(i).xv= [0;0;0];
    p(i).xf= [];
    p(i).Pf= [];
    p(i).da_table = [];
end

function p= make_covariance_ellipses(particle)
% part of plotting routines
p= [];
lenf= size(particle.xf,2);

if lenf > 0
    N= 10;
    inc= 2*pi/N;
    phi= 0:inc:2*pi;
    circ= 2*[cos(phi); sin(phi)];

    xf= particle.xf;
    Pf= particle.Pf;
    p= zeros (2, lenf*(N+2));

    ctr= 1;
    for i=1:lenf
        ii= ctr:(ctr+N+1);
        p(:,ii)= make_ellipse(xf(:,i), Pf(:,:,i), circ);
        ctr= ctr+N+2;
    end
end

function p= make_ellipse(x,P,circ)
% make a single 2-D ellipse
r= sqrtm_2by2(P);
a= r*circ;
p(2,:)= [a(2,:)+x(2) NaN];
p(1,:)= [a(1,:)+x(1) NaN];
