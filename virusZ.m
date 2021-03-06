function [speed, time] = virusZ(size,pd1,pd2,nz, outbreakPos,nsteps,    fmode,outImages)

%VirusZ  agent-based predator-prey model, developed for
%demonstration purposes only for University of Sheffield module
%COM3001/6006/6009

%AUTHOR Dawn Walker d.c.walker@sheffield.ac.uk
%Created April 2008

%virusZ(size,np,nz,nsteps)
%size = size of model environmnet in km (sugested value for plotting
%purposes =50)
%pd1 - initial density of people in the first square
%pd2 - initial density of people in the second square
%nz - initial number of zombie agents
%outbreakPos - The initial outbreak position of zombies (keys from create_agents.m below)
% 'PD1' - start the outbreak at population density 1
% 'PD2' - start the outbreak at population density 2


%nsteps - number of iterations required

%definition of global variables:
%N_IT - current iteration number
%IT_STATS  -  is data structure containing statistics on model at each
%iteration (number of agents etc). iniitialised in initialise_results.m
%ENV_DATA - data structure representing the environment (initialised in
%create_environment.m)

    %clear any global variables/ close figures from previous simulations
    clear global
    close all

    global MAIN_SPEED MAIN_TIME N_IT IT_STATS ENV_DATA CONTROL_DATA N_STEPS OUT_POS
    
    N_STEPS = nsteps;
    OUT_POS = outbreakPos;

    if nargin == 4
        fmode=true;
        outImages=false;
    elseif nargin == 5
        outImages=false;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MODEL INITIALISATION
    create_control;                     %sets up the parameters to control fmode (speed up the code during experimental testing
    create_params;                      %sets the parameters for this simulation
    create_environment(size);           %creates environment data structure, given an environment size
    random_selection(1);                %randomises random number sequence (NOT agent order). If input=0, then simulation should be identical to previous for same initial values
    [agent]=create_agents(pd1,pd2,nz, outbreakPos);       %create np person and nz zombie agents and places them in a cell array called 'agents'
    
    
    
    thisClass = class(agent{1});
    if(strcmp(thisClass, 'double'))
       disp('Error generating agents - exiting.')
       return
    end
    
    create_messages(pd1,pd2,nz,agent);       %sets up the initial message lists
    initialise_results(pd1,pd2,nz,nsteps);   %initilaises structure for storing results
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
   
    %     Validation of input params
    % 0.5 * ENV_DATA.MAX_AGENTS
    if (size > 0.5 * ENV_DATA.MAX_AGENTS)
        disp('ERROR!')
        disp('Please enter a map size that is half or less than the maximum number of agents.')
        return
    end
    
    

    
    outDist = 0;
    
    
    %MODEL EXECUTION
    for n_it=1:nsteps                   %the main execution loop
        N_IT=n_it;
        [agent,n]=agnt_solve(agent);     %the function which calls the rules
        plot_results(agent,nsteps,fmode,outImages, false); %updates results figures and structures
        %mov(n_it)=getframe(fig3);
        if n<=0                          %if no more agents, then stop simulation
            break
            disp('General convergence criteria satisfied - no agents left alive! > ')
        end
        if fmode == true                                       % if fastmode is used ...
           for test_l=1 : 5                                    % this checks the total number agents and adjusts the CONTROL_DATA.fmode_display_every variable accoringly to help prevent extreme slowdown
               if n > CONTROL_DATA.fmode_control(1,test_l)     % CONTROL_DATA.fmode_control contains an array of thresholds for agent numbers and associated fmode_display_every values
                   CONTROL_DATA.fmode_display_every = CONTROL_DATA.fmode_control(2,test_l);
               end
           end
            if IT_STATS.tot_r(n_it) == 0             %fastmode convergence - all persons eaten - all zombies will now die
                disp('Fast mode convergence criteria satisfied - no persons left alive! > ')
                break
            end
            if IT_STATS.tot_f(n_it) == 0             %fastmode convergence - all zombies starved - persons will now proliferate unchecked until all vegitation is eaten
                disp('Fast mode convergence criteria satisfied - no zombies left alive ! > ')
                break
            end
            
            if outDist > (size - 1)
                disp('Fast mode convergence criteria satisfied - outbreak has spread to second population');
                break
            end
        end

        % Update outbreak progress
        if OUT_POS == 'PD1'    
            outDist = max(ENV_DATA.zombies_locs(:,1));
        else
            outDist = ENV_DATA.bm_size - (min(ENV_DATA.zombies_locs(:,1))) + 1;
        end

        IT_STATS.zdist(N_IT) = outDist;
    end

    plot_results(agent,nsteps,fmode,outImages, true);
    speed = MAIN_SPEED;
    time = MAIN_TIME;
eval(['save results_pd1_pd2_' num2str(pd1) '_' num2str(pd2) '_nz_' num2str(nz) '.mat IT_STATS ENV_DATA' ]);
clear global
