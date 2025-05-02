classdef Launch_Site
    properties
        name
        planet
        coordinates
        unit_vec
    end
    
    methods
        function obj = Launch_Site(name,planet,coordinates)
            obj.name = name;
            obj.planet = planet;
            obj.coordinates = coordinates;
            obj.unit_vec = [cos(coordinates(1))*cos(coordinates(2)); 
                            cos(coordinates(1))*sin(coordinates(2)); 
                            sin(coordinates(1))];
        end
    end
end

