function [loc_zombies,xmin,ymin]=extract_local_zombies(cpos,spd, agent)

%Extracts array representing distribution of zombies surrounding the local
%area of an agent at position cpos [x,y] and with search radius = spd.
%This function also makes corrections in the case that the agent is close
%to the model edge

global ENV_DATA

%ENV_DATA is a data structure containing information about the model
   %environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution
   %    of food

x=cpos(1)
y=cpos(2)
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
loc_zombies=ENV_DATA.food(xmin:xmax,ymin:ymax);    %extract distribution of food within the local search radius

for n = 1:length(agent)
    disp(agent(1))
    input('look here')
end

