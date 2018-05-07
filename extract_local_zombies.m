function [loc_zombies,xmin,ymin]=extract_local_zombies(cpos,spd, agent);

%Extracts list of zombie coordinates that are nearby

global ENV_DATA

%ENV_DATA is a data structure containing information about the model
   %environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution
   %    of food

x=cpos(1);
y=cpos(2);
nearZombies = nan(0,2);
count=1;
% disp(ENV_DATA.bm_size)
% disp(spd)


% If it would be possible to move out of the map (positive) - set the maximum movement
% range to be the map size, otherwise, can move freely
if x>ENV_DATA.bm_size-spd
    xmax=ENV_DATA.bm_size;
else
    xmax=x+spd;
end

% If x could move negatively out of the map, set the minimum to be the map
% limit. - otherwise move freely.
if x<spd+1
    xmin=1;
else
    xmin=x-spd;
end

% Repeat for y direction
if y>ENV_DATA.bm_size-spd
    ymax=ENV_DATA.bm_size;
else
    ymax=y+spd;
end
if y<spd+1
    ymin=1;
else
    ymin=y-spd;
end

% xmin and xmax represten the range of search in the x direction (and is
% adjusted for the map edges).
% same for y

% TODO: search this x and y range for zombies.
for (n=1:length(ENV_DATA.zombies_locs(:, 1)))
   x = ENV_DATA.zombies_locs(n, 1);
   y = ENV_DATA.zombies_locs(n, 2);
   
   if (((x >= xmin) && (x <= xmax)) && ((y >= ymin) && (y <= ymax)))
        nearZombies(count, 1) = x;
        nearZombies(count, 2) = y;
        count = count + 1;
    end
end
% loc_zombies=ENV_DATA.food(xmin:xmax,ymin:ymax);    %extract distribution of food within the local search radius
loc_zombies=nearZombies;

