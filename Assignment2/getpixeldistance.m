%GETPIXELDISTANCE
% Get distances in pixels between the image center and the wall. Note that
% the radial distortion has not been compensated yet.
function dist = getpixeldistance( BWradialimage , min_dist )

for i = 1 : size( BWradialimage , 1 );
    l = BWradialimage( i,: );
    ind = find( l==0 );
    if isempty( ind )
        dist(i) = inf;
    else
        tmp = ind(find(ind>=min_dist)); 
        if isempty( tmp )
            dist(i) = 0;
        else
            if tmp(1) == min_dist
                dist(i) = 0;
            else
                dist(i) = tmp(1);
            end
        end 
    end
end