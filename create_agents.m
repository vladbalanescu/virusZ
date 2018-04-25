function [agent]=create_agents(pd1,pd2,nz)

 %creates the objects representing each agent

%agent - cell array containing list of objects representing agents
%np - number of persons
%nz - number of zombies

%global parameters
%ENV_DATA - data structure representing the environment (initialised in
%create_environment.m)
%MESSAGES is a data structure containing inzormation that agents need to
%broadcast to each other
%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation

 global ENV_DATA MESSAGES PARAM

bm_size=ENV_DATA.bm_size;
diffInterval = (pd2-pd1)/bm_size;
mapDivision = pd1:diffInterval:pd2;
nps = 1:bm_size;
globalPloc = [];

for i=1:bm_size-1
    xlocs = i + rand(nps(i),1)
    ylocs = (bm_size-2).*rand(nps(i),1)+1
    globalPloc = [globalPloc, cat(2,xlocs,ylocs)'];
end
globalPloc = globalPloc'; %transpose the x,y location matrix
                          %old ploc is now globalPloc


zloc=(bm_size-1)*rand(nz,2)+1;      %generate random initial positions for zombies
ENV_DATA.zombies_locs = zloc;
disp('create agents')
disp('zombie locs')
disp(ENV_DATA.zombies_locs);
disp('zombie locs length')
disp(length(ENV_DATA.zombies_locs(:, 1)))

MESSAGES.pos=[globalPloc;zloc];

%generate all person agents and record their positions in ENV_MAT_R
for r=1:np
    pos=globalPloc(r,:);
    %create person agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.P_BRDFQ);
    agent{r}=person(age,food,pos,PARAM.P_SPD,lbreed);
end

%generate all zombie agents and record their positions in ENV_MAT_F
for f=1:nz
    pos=zloc(f,:);
    %create zombie agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.Z_BRDFQ);
    agent{f}=zombie(age,food,pos,PARAM.Z_SPD,lbreed);
end
