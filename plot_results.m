function plot_results(agent,nsteps,fmode,outImages, final)

    %Plots 2d patch images of agents onto background
    %%%%%%%%%%%
    %plot_results(agent,nr,nf)
    %%%%%%%%%%%
    %agent - current list of agent structures
    %nr -  no. persons
    %nf -  no. persons

    % Modified by D Walker 3/4/08

    global MAIN_TIME MAIN_SPEED N_IT IT_STATS ENV_DATA OUT_POS MESSAGES CONTROL_DATA N_STEPS AGENT_WORTH TOTAL_POP
    %declare variables that can be seen by all functions
    %N_IT is current iteration number
    %ENV_DATA - data structure representing the environment (initialised in
    %create_environment.m)
    %IT_STATS is data structure containing statistics on model at each
    %iteration (no. agents etc)
    %MESSAGES is a data structure containing information that agents need to
    %broadcast to each other

    %write results to the screen
    nr=IT_STATS.tot_r;
    nf=IT_STATS.tot_f;
    disp(strcat('Iteration = ',num2str(N_IT)))
    disp(strcat('No. new persons = ',num2str(IT_STATS.div_r(N_IT+1))))
    disp(strcat('No. new zombies = ',num2str(IT_STATS.div_f(N_IT+1))))
    disp(strcat('No. zombiees dying = ',num2str(IT_STATS.died_f(N_IT+1))))
    disp(strcat('No. persons eaten = ',num2str(IT_STATS.eaten(N_IT+1))))

    if final
        final_IT = size(IT_STATS.zdist, 2)
        thisTime = num2str(final_IT);
        thisSpeed = num2str(IT_STATS.zdist(final_IT) / final_IT);
        
        disp('')
        disp('')
        disp('-- FINAL RESULT --')
        
        if IT_STATS.zdist(final_IT) > ENV_DATA.bm_size - 1
            disp('Outbreak has spread between the populations')
        else
            disp('Outbreak has not spread between the populations')
        end

        disp(strcat('Time: ', thisTime, 'days'))
        disp(strcat('Avg. Speed:', thisSpeed, 'km per day'))
        
        MAIN_SPEED = thisSpeed;
        MAIN_TIME = thisTime;
    end

    %plot line graphs of agent numbers and remaining food
    if (fmode==false) || (N_IT==nsteps) || ((fmode==true) && (rem(N_IT , CONTROL_DATA.fmode_display_every)==0)) || final

        %Plotting takes time so fmode has been introduced to only plot every n=CONTROL_DATA.fmode_display_every iterations
        %This value increases with the number of agents (see virusZ.m L57-61) as plotting more agents takes longer.
        %fmode can be turned off in the command line - see virusZ documentation

        col{1}='g-';                   %set up colours that will represent different cell types red for persons, blue for zombiees
        col{2}='r-';

        tot_food=IT_STATS.tfood;       %total food remaining
        n=ENV_DATA.MAX_AGENTS;            %current agent number
        f2=figure(2);
        set(f2,'Units','Normalized');
        set(f2,'Position',[0.55 0.55 0.4 0.3]);

        thisTitle = [' no.= ' num2str(N_IT) '/' num2str(N_STEPS) ' -  No. agents = ' num2str(n) ' [1 agent ~ ' AGENT_WORTH ' people]'];

        if final
            nsteps = N_IT;
        end
        

        subplot(3,1,1),cla
        subplot(3,1,1),plot((1:N_IT+1),nr(1:N_IT+1),col{1});
        subplot(3,1,1),axis([0 nsteps 0 1.1*max(nr)]);
        subplot(3,1,1),title('No. healthy people');
        
        subplot(3,1,2),cla
        subplot(3,1,2),plot((1:N_IT+1),nf(1:N_IT+1),col{2});
        subplot(3,1,2),axis([0 nsteps 0 1.1*max(nf)]);
        subplot(3,1,2),title('No. zombies');
        
        subplot(3,1,3),cla                
        subplot(3,1,3),plot((1:N_IT-2),IT_STATS.zdist(1:N_IT -2),'m-');
        subplot(3,1,3),axis([0 nsteps 0 ENV_DATA.bm_size]);
        subplot(3,1,3),title('Outbreak distance');
        drawnow

        % subplot(3,1,1),cla 
        % subplot(3,1,1),plot((1:N_IT+1),nr(1:N_IT+1),col{1}); 
        % subplot(3,1,1),axis([0 nsteps 0 1.1*max(nr)]); 
        % subplot(3,1,2),cla 
        % subplot(3,1,2),plot((1:N_IT+1),nf(1:N_IT+1),col{2}); 
        % subplot(3,1,2),axis([0 nsteps 0 1.1*max(nf)]); 
        % subplot(3,1,3),cla 
        % subplot(3,1,3),plot((1:N_IT+1),tot_food(1:N_IT+1),'m-'); 
        % subplot(3,1,3),axis([0 nsteps 0 tot_food(1)]); 
        % subplot(3,1,1),title('No. live rabbits'); 
        % subplot(3,1,2),title('No. live foxes'); 
        % subplot(3,1,3),title('Total food'); 
        % drawnow 

        %create plot of agent locations.
        f3=figure(3);

        bm=ENV_DATA.bm_size;
        typ=MESSAGES.atype;
        clf                             %clear previous plot
        set(f3,'Units','Normalized');
        set(f3,'Position',[0 0.03 0.50 0.50]);
        v=(1:bm);
        [X,Y]=meshgrid(v);
        Z=ENV_DATA.food;
        H=zeros(bm,bm);
        hs=surf(Y,X,H,Z);               %plot food distribution on plain background
        cm=colormap('gray');
        icm=flipud(cm);
        colormap(icm);
        set(hs,'SpecularExponent',1);       %sets up lighting
        set(hs,'SpecularStrength',0.1);
        hold on

        for cn=1:length(agent)                          %cycle through each agent in turn
            if typ(cn)>0                                %only plot live agents
                pos=get(agent{cn},'pos');               %extract current position
                if isa(agent{cn},'person')              %choose plot colour depending on agent type
                    ro=plot(pos(1),pos(2),'g.');
                    set(ro,'MarkerSize',30);
                else   
                    fo=plot(pos(1),pos(2),'rx'); 
                    set(fo,'MarkerSize',20);
                end
            end
        end

        h=findobj(gcf,'type','surface');			%Once all cells are plotted, set up perspective, lighting etc.
        set(h,'edgecolor','none');
        lighting flat
        h=findobj(gcf,'type','surface');
        set(h,'linewidth',0.1)
        set(h,'specularstrength',0.2)
        axis off
        axis equal
        set(gcf,'color',[1 1 1]);

        uicontrol('Style','pushbutton',...
                  'String','PAUSE',...
                  'Position',[20 20 60 20], ...
                  'Callback', 'global ENV_DATA; ENV_DATA.pause=true; display(ENV_DATA.pause); clear ENV_DATA;');

        while CONTROL_DATA.pause==true    % pause/resume functionality - allows pan and zoom during pause...
            pan on
            axis off
           Iteration title(thisTitle);
            text(-2.6, 7.7, 'PAUSED', 'Color', 'r');
            drawnow
            uicontrol('Style','pushbutton',...
                      'String','ZOOM IN',...
                      'Position',[100 20 60 20],...
                      'Callback','if camva <= 1;return;else;camva(camva-1);end');
            uicontrol('Style','pushbutton',...
                      'String','ZOOM OUT',...
                      'Position',[180 20 60 20],...
                      'Callback','if camva >= 179;return;else;camva(camva+1);end');

            uicontrol('Style','pushbutton',...
                      'String','RESUME',...
                      'Position',[20 20 60 20], ...
                      'Callback', 'global ENV_DATA; ENV_DATA.pause=false; clear ENV_DATA;');
        end
        title(thisTitle);
        axis off
        drawnow
        if outImages==true  %this outputs images if outImage parameter set to true!!
            if fmode==true; %this warning is to show not all iterations are being output if fmode=true!
                    disp('WARNING*** fastmode set - To output all Images for a movie, set fmode to false(fast mode turned off) ');
            end
            filenamejpg=[sprintf('%04d',N_IT)];
            eval(['print -djpeg90 agent_plot_' filenamejpg]); %print new jpeg to create movie later
        end
    end
end
