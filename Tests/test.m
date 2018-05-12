clc
clear

% {'Leed', '1416', '46'};
% {'Chesterfield', '1581', '17'};

base = {'Sheffield', '1563'};
places = [  {'Leed', '1416', '46'};
            {'Chesterfield', '1581', '17'};
            {'Blackpool','3994','114'};
            {'Manchester','4680','52'};
            {'Liverpool','4332','101'};
            {'York','766','69'};
            {'Boston','185','106'};
            {'Stoke-on-Trent','2709','63'};
            {'Birmingham','4199','103'};
            {'Peterborough','573','122'}
];


% General vars setup    
PD1 = str2double(base(2));
nr_zombies = 3;
nr_iterations = 1000;
reps = 10; % Number of times each simulation is done before averaging

avg_results1 = zeros(size(places, 1), 2, 'double');
avg_results2 = zeros(size(places, 1), 2, 'double');



for i=1:size(places, 1)
    results1 = zeros(reps, 2, 'double');
    results2 = zeros(reps, 2, 'double');
    size = str2double(places(i,3));
    PD2 = str2double(places(i,2));

    for j=1:reps
        [speed, time] = virusZ(size, PD1, PD2, nr_zombies, 'PD1',nr_iterations, true, true);
        results1(j, :) = [str2double(speed) str2double(time)]
    end

    for j=1:reps
        [speed, time] = virusZ(size, PD1, PD2, nr_zombies, 'PD2',nr_iterations, true, true);
        results2(j, :) = [str2double(speed) str2double(time)]
    end

    avg_results1(i,:) = mean(results1,1);
    avg_results2(i,:) = mean(results2,1);
end

disp('pd1 - pd2')
disp(avg_results1)
disp('pd2 - pd1')
disp(avg_results2)