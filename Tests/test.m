clc
clear

base = {'Sheffield', '1563'};
places = [  {'Leed', '1416', '46'};
            {'Chesterfield', '1581', '17'}
         ];


% General vars setup    
PD1 = str2double(base(2));
nr_zombies = 6;
nr_iterations = 20;
avg_results = zeros(size(places, 1), 2, 'double');

% Number of times each simulation is done before averaging
reps = 5

for i=1:size(places, 1)
    results = zeros(reps, 2, 'double');
    size = str2double(places(i,3));
    PD2 = str2double(places(i,2));

    for j=1:reps
        [speed, time] = virusZ(size, PD1, PD2, nr_zombies, 'PD1',nr_iterations, true, true);
        results(j, :) = [str2double(speed) str2double(time)];
    end

    avg_results(i,:) = mean(results,1)
end
