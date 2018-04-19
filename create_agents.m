function [agent]=create_agents(np,nz)

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
ploc=(bm_size-1)*rand(np,2)+1;      %generate random initial positions for persons
zloc=(bm_size-1)*rand(nz,2)+1;      %generate random initial positions for zombiees

MESSAGES.pos=[ploc;zloc];

%generate all person agents and record their positions in ENV_MAT_R
for r=1:np
    pos=ploc(r,:);
    %create person agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.P_BRDFQ);
    agent{r}=person(age,food,pos,PARAM.P_SPD,lbreed);
end

%generate all zombie agents and record their positions in ENV_MAT_F
for f=np+1:np+nz
    pos=zloc(f-np,:);
    %create zombie agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.Z_BRDFQ);
    agent{f}=zombie(age,food,pos,PARAM.Z_SPD,lbreed);
end
