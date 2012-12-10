function  [zf,idf,zn,da_table]= data_associate_unknown(particle, z, da_table, PARAMS)
zf= []; zn= [];
idf= []; idn= [];

% obs in coord pol, feat in cc

% NN data asso.
% da_table empty
% add feat and feat num
% compare

% idz now contains the num of beacons 
len_beac = size(z,2);

% da_table is
% xf; yf 

if(isempty(da_table) == 0) 
	len_table = size(da_table,2);
else
	len_table = -1;
end

% feature in wrf

for i=1:len_beac,
    r= z(1,i);
    b= z(2,i);

    s = sin(particle.xv(3) + b);
    c = cos(particle.xv(3) + b);

    obs_z(:,i) = [particle.xv(1) + r*c; 
                  particle.xv(2) + r*s];
end

% obs_z
% find associations (zf) and new features (zn)
count_asso = 0;
for i=1:len_beac,
    norm_vec = [];
    
    if(len_table ~= -1)
        norm_vec = [];
        for j=1:len_table,
            % Ecuclidean distance
            eu_distance = [(obs_z(1,i) - da_table(1,j)); (obs_z(2,i) - da_table(2,j))];

            % Mahalanobis distance            
            curnorm = sqrt( eu_distance' * inv(particle.Pf(:,:,j)) * eu_distance);
            % store distance
            norm_vec(end + 1) = curnorm;
        end
        [val_min, val_idx] = min(norm_vec);

        if(val_min < PARAMS.NN_MAX_DIST)
            idx_c = find(idf == val_idx);

            if(isempty(idx_c))
                idf= [idf val_idx];
                zf= [zf [z(1,i); pi_to_pi(z(2,i))]];
            end
            count_asso = count_asso + 1;
        else
            zn= [zn [z(1,i); pi_to_pi(z(2,i))]];
            da_table(:,end+1) = obs_z(:,i);
        end
    else
        % 1st feature
        da_table = obs_z;
        
        zn= [zn [z(1,i); pi_to_pi(z(2,i))]];
%         disp '1st'
    end
    
end

% if(count_asso ~= 0)
%    count_asso 
% end