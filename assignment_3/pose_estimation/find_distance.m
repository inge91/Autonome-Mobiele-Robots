function distance = find_distance(s1, s2)

% Check which string is longer and rotate that one(should be same length)
if length(s2) >= s1
    temp = s1;
    s1 = s2;
    s2 = temp;
end

% Keep track of the distances and the string that belongs to it
distances = [];
strings = [];

for i = 1:length(s1)
    distances = [distances;  LevenshteinDistance(s1, s2)];
    strings = [strings ; s1];
    % Rotate the string by one character
    s1 = [s1(2:length(s1)) s1(1)];
end

% Return the smallest element and the string that belongs to it
index = find(distances == min(distances));
index = index(1);

string1 = strings(index, :);
string2 = s2;
distance = distances(index);



