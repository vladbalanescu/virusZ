function [agt,eaten,new]=eat(agt,cn)

global PARAM IT_STATS N_IT
%eating function for class zombie
%agt=zombie object
%cn - current agent number
%eaten = 1 if zombie successfully finds a person, =0 otherwise

%SUMMARY OF zombie EAT RULE
%zombie calculates distance to all persons
%zombie identifies nearest persons(s)
%If more than one equidistant within search radius, one is randomly picked
%Probability of zombie killing person =1 - distance of person/speed of zombie
%If probability > rand, zombie moves to person location and person is
%killed
%If zombie does not kill person, it's food is decremented by one unit

%GLOBAL VARIABLES
%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%MESSAGES is a data structure containing information that agents need to
%broadcast to each other
   %    MESSAGES.atype - n x 1 array listing the type of each agent in the model
   %    (1=person, 2-zombie, 3=dead agent)
   %    MESSAGES.pos - list of every agent position in [x y]
   %    MESSAGE.dead - n x1 array containing ones for agents that have died
   %    in the current iteration


%Modified by D Walker 3/4/08

global  IT_STATS N_IT MESSAGES

pos=agt.pos;                        %extract current position
cfood=agt.food;                     %get current agent food level
spd=agt.speed;                      %zombie migration speed in units per iteration - this is equal to the food search radius
hungry=1;
eaten=0;

% FIND THE NEAREST person
typ=MESSAGES.atype;                                         %extract types of all agents
rb=find(typ==1);                                            %indices of all persons
rpos=MESSAGES.pos(rb,:);                                     %extract positions of all persons
csep=sqrt((rpos(:,1)-pos(:,1)).^2+(rpos(:,2)-pos(:,2)).^2);  %calculate distance to all persons
[d,ind]=min(csep);                                            %d is distance to closest person, ind is index of that person
nrst=rb(ind);                                                %index of nearest person(s)
new=[];

if d<=spd&length(nrst)>0    %if there is at least one  person within the search radius
    if length(nrst)>1       %if more than one person located at same distance then randomly pick one to head towards
        s=round(rand*(length(nrst)-1))+1
        nrst=nrst(s);
    end
    pk=1-(d/spd);                       %probability that zombie will kill person is ratio of speed to distance
    if pk>rand
        nx=MESSAGES.pos(nrst,1);    %extract exact location of this person
        ny=MESSAGES.pos(nrst,2);
        npos=[nx ny];
        agt.food=cfood+1;           %increase agent food by one unit
        agt.pos=npos;               %move agent to position of this person
        IT_STATS.eaten(N_IT+1)=IT_STATS.eaten(N_IT+1)+1;                %update model statistics
        eaten=1;
        hungry=0;
        MESSAGES.dead(nrst)=1;       %send message to person so it knows it's dead!

        %make new zombie
        [agt, new] = breed(agt,cn);
%         new=zombie(0,cfood/2,pos,PARAM.F_SPD,0);
    end
end
if hungry==1
    agt.food=cfood-0;     %if no food, then reduce agent food by one unit
end
