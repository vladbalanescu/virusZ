classdef zombie           %declares zombie object
    properties         %define zombie properties (parameters)
        age;
        food;
        pos;
        speed;
        last_breed;
    end
    methods                         %note that this class definition mfile contains only the constructor method!
                                    %all additional member functions associated with this class are included as separate mfiles in the @zombie folder.
        function f=zombie(varargin) %constructor method for zombie  - assigns values to zombie properties
                %f=zombie(age,food,pos....)
                %
                %age of agent (usually 0)
                %food - amount of food that person has eaten
                %pos - vector containg x,y, co-ords

                %Modified by Martin Bayley on 29/01/13

            switch nargin                     %Use switch statement with nargin,varargin contructs to overload constructor methods
                case 0                        %create default object
                    f.age=[];
                    f.food=[];
                    f.pos=[];
                    f.speed=[];
                    f.last_breed=[];
                case 1                         %input is already a zombie, so just return!
                    if (isa(varargin{1},'zombie'))
                        f=varargin{1};
                    else
                        error('Input argument is not a zombie')
                    end
                case 5                          %create a new zombie (currently the only constructor method used)
                    f.age=varargin{1};               %age of zombie object in number of iterations
                    f.food=varargin{2};              %current food content (arbitrary units)
                    f.pos=varargin{3};               %current position in Cartesian co-ords [x y]
                    f.speed=varargin{4};             %number of kilometres zombie can migrate in 1 day
                    f.last_breed=varargin{5};        %number of iterations since zombie last reproduced.
                otherwise
                    error('Invalid no. of input arguments for zombie')
            end
        end
    end
end
