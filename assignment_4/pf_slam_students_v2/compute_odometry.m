function odometry = do_odo_mapplot(odometry, dn_rn, dth_rn)

odometry.xv = [odometry.xv(1) + dn_rn*cos(dth_rn + odometry.xv(3,:)); 
               odometry.xv(2) + dn_rn*sin(dth_rn + odometry.xv(3,:));
              pi_to_pi(pi_to_pi(dth_rn) + odometry.xv(3,:))];
 
% odometry.xv