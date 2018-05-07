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

global ENV_DATA MESSAGES PARAM AGENT_WORTH

% Calculate a spread of agents to represtnt a population gradiant.
% This is done by splitting the map into columns and generating agents proportional to the population density in said column
no_people = ENV_DATA.MAX_AGENTS - nz;
bm_size = ENV_DATA.bm_size;
pd_step = (pd2-pd1)/(bm_size-1);
pd_array = pd1:pd_step:pd2
pd_sum = sum(pd_array);
pop_array = no_people * (pd_array / pd_sum);

% Calculate how many people each agent represents (using unrounded
% populations)
population_in_column = bm_size * pd_array(1);
AGENT_WORTH = num2str(round(population_in_column / pop_array(1)));

% Round the populations
pop_array = round(pop_array)




% Generate positions for the population according to the gradiant
ploc = [];
for i=1:bm_size-1   
    xlocs = i + rand(pop_array(i),1);
    ylocs = (bm_size-2).*rand(pop_array(i),1)+1;
    ploc = [ploc, cat(2,xlocs,ylocs)'];
end
ploc = ploc';


zloc=(bm_size-1)*rand(nz,2)+1;      %generate random initial positions for zombiees
ENV_DATA.zombies_locs = zloc;
disp('create agents')
disp('zombie locs')
disp(ENV_DATA.zombies_locs);
disp('zombie locs length');
disp(length(ENV_DATA.zombies_locs(:, 1)));

MESSAGES.pos=[ploc;zloc];

%generate all person agents and record their positions in ENV_MAT_R
for p=1:length(ploc)    
    pos=ploc(p,:);
    %create person agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.P_BRDFQ);
    agent{p}=person(age,food,pos,PARAM.P_SPD,lbreed);
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
