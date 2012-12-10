function test_accuracy

load('LabeledLineSignatures.mat');
sz = size(PatStrings);

% loop through each pattern string and check if the right location gets
% predicted
good = 0;
total = 0;

for i = 1:sz(1)
    for j = 1:sz(2)
        estimated = CheckPattern(PatStrings{i, j});
        actual = PlaceID(i, j);
        fprintf('Estimated: %d, actual: %d\n', estimated, actual);
        if (estimated == actual)
            good = good + 1;
        end

        total = total + 1;
    end
end

fprintf('Success rate: %f\n', good/total);
