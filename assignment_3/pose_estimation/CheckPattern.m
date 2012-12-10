function location = CheckPattern(pat)

% load the cell array containing the labeled data
load('LabeledLineSignatures.mat');
sz = size(PatStrings);

prob_match = [];

% make a list of the distance of each labeled fingerprint to the given pattern
for i = 1:sz(1)
    for j = 1:sz(2)
        dist = find_distance(pat, PatStrings{i, j});
        len = length(PatStrings{i, j});
        prob = ((len - dist) / len) * 100;
        prob_match = [prob_match, prob];
    end
end

% loop through each location, and get the average error
locations = unique(PlaceID);
averages = [];

for l = locations
    loc_indices = find( PlaceID == l );
    averages = [ averages, mean( prob_match(loc_indices) ) ];
end

% return the most likely location
location_index = find( averages == max(averages) );
location = locations(location_index);
