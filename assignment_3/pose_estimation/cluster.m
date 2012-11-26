function [NClusters, ClusterIdx] = cluster(XY)
  
configfile_lines;
    
% Compute the rho's
N = size(XY, 2);
rho = sqrt(XY(1,:).^2 + XY(2,:).^2);
    
% Determine the possible splitting positions
drho = [0 (rho(2:end) - rho(1:end-1))]; 
splitpos = false(1,N);
splitpos(find(rho >= RMAX)) = true;
splitpos(find(abs(drho ./ rho) >= RHOPEAKLEVEL)) = true;

% forming clusters
ClusterID = zeros(1,N);
ClusterID(1) = 1;
NClusters = 1;
ClusterSize = zeros(1,N);
ClusterSize(1) = 1;
ClusterIdx = [1 1];
for i=2:N
  if (~splitpos(i))                % in the same previous cluster
    ClusterID(i) = ClusterID(i-1);
    ClusterSize(ClusterID(i)) = ClusterSize(ClusterID(i)) + 1;
    ClusterIdx(NClusters, 2) = ClusterIdx(NClusters, 2) + 1;
    
  else
    NClusters = NClusters + 1;
    ClusterID(i) = NClusters;
    ClusterSize(NClusters) = 1;
    ClusterIdx(NClusters, 1) = i;
    ClusterIdx(NClusters, 2) = i;
  end
end


% removing small clusters
for i=1:NClusters,
  if ClusterSize(i) < MINCLUPOINTS
    ClusterID(find(ClusterID == i)) = -2;
    ClusterSize(i) = 0;
  end
end


% Construct output
NClu = NClusters;
NClusters = 0;
for i=1:NClu
  if ClusterSize(i) > 0
    NClusters = NClusters + 1;
    ClusterIdx(NClusters, 1:2) = ClusterIdx(i, 1:2);
  end
end

return;


