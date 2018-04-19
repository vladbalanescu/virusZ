zloc=(30-1)*rand(2,2)+1

% disp(zloc(1, 2))

minX = 15;
maxX = 25;
minY = 15;
maxY = 25;


nearZombies = nan(0,2);
count=1;

for i = 1:length(zloc)
    x = zloc(i, 1);
    y = zloc(i, 2);
    if (((x >= minX) && (x <= maxX)) && ((y >= minY) && (y <= maxY)))
        disp('adding to near zombies')
        nearZombies(count, 1) = x;
        nearZombies(count, 2) = y;
        count = count + 1;
    end
end


% 
disp('near zombies')
disp(nearZombies)
% nearZombies = nearZombies + [1, 2]
% 
% disp(nearZombies)
