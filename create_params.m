function create_params

%set up breeding, migration and starvation threshold parameters. These
%are all completely made up!

%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation

global PARAM

    PARAM.P_SPD=1;         %speed of movement - units per itn (person)
    PARAM.Z_SPD=1;         %speed of movement - units per itn (zombie)
    PARAM.P_BRDFQ=10;      %breeding frequency - iterations
    PARAM.Z_BRDFQ=20;
    PARAM.P_MINFOOD=0;      %minimum food threshold before agent dies
    PARAM.Z_MINFOOD=0;
    PARAM.P_FOODBRD=10;     %minimum food threshold for breeding
    PARAM.Z_FOODBRD=10;
    PARAM.P_MAXAGE=50;      %maximum age allowed
    PARAM.Z_MAXAGE=50;
