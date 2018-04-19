classdef person   %declares person object
    properties    %define person properties (parameters)
        age;
        food;
        pos;
        speed;
        last_breed;
    end
    methods                         %note that this class definition mfile contains only the constructor method!
                                    %all additional member functions associated with this class are included as separate mfiles in the @person folder.
        function r=person(varargin) %constructor method for person - assigns values to person properties
                %r=person(age,food,pos....)
                %
                %age of agent (usually 0)
                %food - amount of food that person has eaten
                %pos - vector containg x,y, co-ords

                %Modified by Martin Bayley on 29/01/13


                switch nargin           %Use switch statement with nargin,varargin contructs to overload constructor methods
                    case 0				%create default object
                       r.age=[];
                       r.food=[];
                       r.pos=[];
                       r.speed=[];
                       r.last_breed=[];
                    case 1              %input is already a person, so just return!
                       if (isa(varargin{1},'person'))
                            r=varargin{1};
                       else
                            error('Input argument is not a person')

                       end
                    case 5               %create a new person (currently the only constructor method used)
                       r.age=varargin{1};               %age of person object in number of iterations
                       r.food=varargin{2};              %current food content (arbitrary units)
                       r.pos=varargin{3};               %current position in Cartesian co-ords [x y]
                       r.speed=varargin{4};             %number of kilometres person can migrate in 1 day
                       r.last_breed=varargin{5};        %number of iterations since person last reproduced.
                    otherwise
                       error('Invalid no. of input arguments')
                end
        end
    end
end
