function particle = predict_odo(particle, dr, dth, Q)
% Q  cov matrix, noise odometry
% dr and dth is retrieved from the encoders (that is delta_r and delta_theta) in dt
% time.

Dmv = multivariate_gauss([dr; dth], Q, 1);
dr_n = Dmv(1); 
dth_n = Dmv(2);


% predict state
xv= particle.xv;

% xv contains the *LAST* position of the considered particle in world coordinate frame, such as:
% xv(1) = last x;
% xv(2) = last y;
% xv(3) = last theta;

% In order to obtain the prediction step for the current particle 'particle'
% consider then the measurements of the odometry of the robot that are:
% dr_n  = noise added measurement of dr using  cov. matrix Q
% dth_n = noise added measurement of d_th using  cov. matrix Q

% Hint:
% x_new = x_old + dn_rn*cos(dth_rn + theta_old)


x_new = particle.xv(1) + dr_n * cos(dth_n + xv(3));
y_new = particle.xv(2) + dr_n * sin(dth_n + xv(3));
th_new = particle.xv(3) + dth;

particle.xv= [x_new; 
              y_new;
              pi_to_pi(th_new)];

% pi_to_pi is a *safe* function that converts angles from [0,2*pi] into the
% standard convention {[0,pi], (-pi, 0]}
