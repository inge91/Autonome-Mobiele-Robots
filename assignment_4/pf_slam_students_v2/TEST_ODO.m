close all;

log = ReadLogFile('log.txt');
logmatrix = log;
m_size = size(logmatrix, 1);
c_size = size(logmatrix, 2);

las_res = 2*pi / (c_size - 2); % avoid timestamp and data nature
las_th_st = 0;
las_th_span = 2*pi;

x = 0;
y = 0;

TOL_JMP = 10.15
dth_t = 0;
for logrow=1:m_size,

    if(logmatrix(logrow,2) == 0)
        Dm = logmatrix(logrow,3);
        Dth = logmatrix(logrow,4);

%         plot([0,dx*cos(dtheta)], [0,dx*sin(dtheta)]), axis([-0.2 0.2 -0.2 0.2]); 
        
        if(filter_odometry(Dm , Dth, TOL_JMP))
        dth_t = mod(Dth + dth_t,2*pi);        
        dx_r = Dm*cos(dth_t); 
        dy_r = Dm*sin(dth_t);
        
            x = x + dx_r; 
            y = y + dy_r;
        
        
%             plot(logrow, Dx, 'b.', 'MarkerSize', 18),hold on;
%             plot(logrow, Dy, 'r.', 'MarkerSize',18),hold on;
            plot(x, y, 'm.', 'MarkerSize',14),hold on;
%             pause
            axis equal
        end
%         logrow
%         pause
    end


end




% % % % % % % % % % % % % % % % 


