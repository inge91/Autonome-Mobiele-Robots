% adapted from luciano's test function

load 'LineSignatures.mat';

sz = size(PatStrings, 2);     
confusion = zeros(sz, sz);

for i = 1:sz
	tLD = [];
	for j = 1:sz
	%    confusion(i,j) = LevenshteinDistance(PatStrings{i}, PatStrings{j});

	% rotate string and take minimum distance (max alignment)
	t1 = PatStrings{j};	
	for k = 1 : length(t1)
		t2 = t1(1);
		t1 = t1(2:end);
		t1 = [t1,t2];
		tLD(k) = LevenshteinDistance(PatStrings{i}, t1);
	end
	
	confusion(i,j) = min(tLD);
	
	end
end

% display results
PlaceID
confusion

% plot confusion matrix
colormap('gray')
imagesc(confusion);