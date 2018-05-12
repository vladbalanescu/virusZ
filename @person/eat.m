function [agt,eaten]=eat(agt,cn)

%eating function for class person
%agt=person object
%cn - current agent number
%eaten = 1 if person finds food, =0 otherwise

%ENV_DATA is a data structure containing information about the model
   %environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution of food

%SUMMARY OF person EAT RULE
%person detects food level in its 1km x 1km square of the environment
%if food> 1, person will consume food
%otherwise person food level decremented by 1.

%Modified by D Walker 3/4/08


global  ENV_DATA
eaten = 0;

% pos=agt.pos;                            %extract current position
% cfood=agt.food;                         %get current agent food level
% cpos=round(pos);                        %round up position to nearest grid point
% pfood=ENV_DATA.food(cpos(1),cpos(2));   %obtain environment food level at current location
% 
% if pfood>=1                             %if food exists at this location
% %     ENV_DATA.food(cpos(1),cpos(2))=ENV_DATA.food(cpos(1),cpos(2))-1;  %reduce environment food by one unit
%     agt.food=cfood+0;                    %increase agent food by one unit
%     eaten=1;                             %person has eaten - set flag to one
% else
%     agt.food=cfood-0;                   %decrease agent food by one unit
%     eaten=0;                            %flag tells person to migrate
% end

