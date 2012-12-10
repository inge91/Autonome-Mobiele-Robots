function [z,z_nf] = extract_beacon(dist_pt, angle_pt)

% configuration file
configfile

corners = [];
corners_nf= [];

len_buff = size(dist_pt,2);

[x,y] = pol2cart(angle_pt, dist_pt);


XY = [x;y];
[NLines, r, alpha, segend, seglen] = recsplit(XY);

% disp(sprintf('Number of extracted lines: %d\n', NLines));

for i=1:NLines
    corners_nf = [corners_nf, [segend(i,1) segend(i,3) ; [segend(i,2) segend(i,4)] ]];
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% select just nearby corners
 
for i=1:NLines-1
	if(r(i) > 0.01 && r(i + 1) > 0.01 )
        
        sq_dist = (segend(i,3) - segend(i + 1,1))^2 + (segend(i,4) - segend(i + 1,2))^2;
 
        if (sq_dist < LINKMIN_SQ)
            corners = [corners, [segend(i,3) ; segend(i,4)] ]; 
        end
    end     
end
sq_dist = (segend(NLines,3) - segend(1, 1))^2 + (segend(NLines,4) - segend(1, 2))^2;

if (sq_dist < LINKMIN_SQ)
    corners = [corners, [segend(NLines,3) ; segend(NLines,4)] ];
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

 

% in polar coordinates
if (isempty(corners) ~= 1)
    [th, r] = cart2pol(corners(1,:), corners(2,:));

    % output
    z = [r; th];

    % in polar coordinates
    [th_nf, r_nf] = cart2pol(corners_nf(1,:), corners_nf(2,:));
    
    % output
    z_nf = [r_nf; th_nf];
else
    % output
    z_nf = [];
    z = [];    
end



