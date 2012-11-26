% This function computes the Levenshtein distance between 2 input strings
% The code is based on the pseudocode: 
%    http://en.wikipedia.org/wiki/Levenshtein_distance

function LDist = LevenshteinDistance(s1, s2)

% d is a table with m+1 rows and n+1 columns
m = length(s1);
n = length(s2);
d = zeros(m+1,n+1);
 
d(1:m+1,1) = [0:m]';
d(1,1:n+1) = [0:n];
 
for i=2:m+1
  for j=2:n+1
    
    if s1(i-1) == s2(j-1), cost = 0; 
    else cost = 1;
    end
    
    d(i,j) = min([d(i-1,j) + 1; ...       % deletion
		  d(i,j-1) + 1; ...       % insertion
		  d(i-1,j-1) + cost]);    % substitution
  end
end

LDist = d(m+1,n+1);

return
