% % % % % % % % % % % % % % % % % % % % % % 
% Test corner script
% Luciano Spinello 2007
% % % % % % % % % % % % % % % % % % % % % % 
close all;
clear all;
figure(4);

% read the logfile 
% **CHANGE LOG FILENAME HERE**
log = ReadLogFile('log2.txt');
logmatrix = log;

% matrix size
m_size = size(logmatrix, 1);
c_size = size(logmatrix, 2);

% params for laser range
PARAMS.FEAT_MIN_RANGE = 0.05;
PARAMS.FEAT_MAX_RANGE = 0.4;

% params for corner extraction

% angle thres
PARAMS.FEAT_MIN_ANGLE = deg2rad(150);
% angle rob. check
PARAMS.FEAT_MIN_PT_CHK = 4;
% unused
PARAMS.FEAT_MAX_DIST = 90;

for logrow=1:m_size,

    if(logmatrix(logrow,2) == 1)
              
        % transf. respect to bearing  angle
        % prune invalid distance points
        [rho, theta] = prepare_laser(logmatrix(logrow,3:end), PARAMS);
 
        % corner extraction
        [z, z_nf] = extract_beacon4(rho, theta);

        if(isempty(z) == 0),
            % polar->cartesian
            [xs, ys] = pol2cart(theta, rho);
            [x, y] = pol2cart(z(2,:), z(1,:));
            [x_nf, y_nf] = pol2cart(z_nf(2,:), z_nf(1,:));            
            
            % Plot extracted segments
            figure(2), clf,           plot(xs,ys, 'y.'),hold on,grid on, axis([-0.5 0.5 -0.5 0.5]), grid on; hold on;
            color = 0;

            sz = size(z_nf,2);
            
            for i=1:2:sz,
                if color   == 0, c = 'r'; elseif color   == 1, c = 'b'; else c = 'g'; end
                line([x_nf(i) x_nf(i + 1)], [y_nf( i) y_nf(i + 1)], 'color', c, 'linewidth', 2);
                color   = mod(color  +1, 3);
            end
                
            % Plot
            plot(x, y, 'm*')
 
        end
   
        grid on
        disp 'Press ENTER to extract corner from the following laser set'
        pause
        hold off

    end

end
