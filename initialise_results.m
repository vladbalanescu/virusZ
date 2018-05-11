function initialise_results(pd1,pd2,nf,nsteps)
 
 global  IT_STATS ENV_DATA
 
%set up data structure to record statistics for each model iteration
%IT_STATS  -  is data structure containing statistics on model at each
%iteration (number of agents etc)
%ENV_DATA - data structure representing the environment
 
 IT_STATS=struct('div_r',[zeros(1,nsteps+1);],...            %no. births per iteration
                'div_f',[zeros(1,nsteps+1)],...
                'died_r',[zeros(1,nsteps+1)],...      %no. agents dying per iteration
                'died_f',[zeros(1,nsteps+1)],...
                'eaten',[zeros(1,nsteps+1)],...              %no. persons eaten per iteration
                'mig',[zeros(1,nsteps+1)],...                %no. agents migrating per iteration
                'tot',[zeros(1,nsteps+1)],...        %total no. agents in model per iteration
                'tot_r',[zeros(1,nsteps+1)],...             % total no. persons
                'tot_f',[zeros(1,nsteps+1)],...             % total no. zombies
                'tfood',[zeros(1,nsteps+1)]);               %remaining vegetation level
 
 
 tf=sum(sum(ENV_DATA.food));            %remaining food is summed over all squares in the environment
 tPeople = pd2-pd1;
 IT_STATS.tot(1)=tPeople+nf;
 IT_STATS.tot_r(1)=tPeople;
 IT_STATS.tot_f(1)=nf;
 IT_STATS.tfood(1)=tf;
 IT_STATS.zdist(1)=0;