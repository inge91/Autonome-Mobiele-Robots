% this function computes the pattern string based on the extracted blobs 
% The input segments are in a sequence. 
function  S = ComputePatStringBlobs(cl_angles,cl_type)

configfile_lines;  
histo = 2 * ones(1, 360/SEGRES);
h_len = length(histo);
NBlobs = length(cl_angles);

% convert angles in degree
deg_angles = rad2deg(cl_angles);

for i=1:NBlobs,

    if(deg_angles(i) < 0)
        deg_angles(i) = deg_angles(i) + 360;
    end

%     deg_angles(i)
    idx = fix(deg_angles(i)/SEGRES);

    %     histo(idx + 1) = 3;	           % if you just want to represent color blobs
    histo(idx + 1) = 2 + cl_type(i) ;   % if you want to represent each color separately
end

% figure(55)
% plot(1:h_len, histo, 'r-'); 
% pause

% init
S = [];
for i=1:h_len

%     append blob pattern
%     S = [S, histo(i)];
      S = [S, repmat(histo(i), 1, 5)];
end
