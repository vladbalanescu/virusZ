function [nagent,nn]=agnt_solve(agent)

%sequence of functions called to apply agent rules to current agent population.
%%%%%%%%%%%%
%[nagent,nn]=agnt_solve(agent)
%%%%%%%%%%%
%agent - list of existing agent structures
%nagent - list of updated agent structures
%nn - total number of live agents at end of update

%Created by Dawn Walker 3/4/08

global ENV_DATA

n=length(agent);    %current no. of agents
n_new=0;    %no. new agents
prev_n=n;   %remember current agent number at the start of this iteration

new_zombie_locs=nan(0,2);
zombie_count=1;
%execute existing agent update loop
for cn=1:n
	curr=agent{cn};
    if isa(curr,'person')|isa(curr,'zombie')
        if isa(curr,'zombie')
            [curr,eaten,newZ]=eat(curr,cn);               %eating rules (persons eat food, zombies eat persons)
            n_new=n_new+1;
            agent{n+n_new}=newZ;
        elseif (isa(curr,'person'))
            [curr,eaten]=eat(curr,cn);               %eating rules (persons eat food, zombies eat persons)
        end
        
        if isa(curr,'person')
            curr=migrate(curr,cn, agent);              %if no food was eaten, then migrate in search of some
        elseif isa(curr,'zombie')
            curr=migrate(curr,cn);
            new_zombie_locs(zombie_count, :) = curr.pos;
            zombie_count = zombie_count + 1;
        end
        
        [curr,klld]=die(curr,cn);                %death rule (from starvation or old age)
        if klld==0
            new=[];
%           [curr,new]=breed(curr,cn);			%breeding rule
            if ~isempty(new)					%if current agent has bred during this iteration
                 n_new=n_new+1;                 %increase new agent number
                 agent{n+n_new}=new;			%add new to end of agent list
             end
        end
       agent{cn}=curr;                          %up date cell array with modified agent data structure
    end
end

% Finished processing all agents for this itteration
ENV_DATA.zombies_locs = new_zombie_locs;

temp_n=n+n_new; %new agent number (before accounting for agent deaths)
[nagent,nn]=update_messages(agent,prev_n,temp_n);   %function which update message list and 'kills off' dead agents.
