classdef Solar_Orbit
    properties
        radius
        period
        omega
        velocity
        angle
        r_vec
        v_vec
    end
    methods
        function obj = Solar_Orbit(orbit_radius, orbit_period, angle)
            if nargin > 0
                obj.radius = orbit_radius;
                obj.period = orbit_period;
                obj.omega = 2*pi/orbit_period;
                obj.velocity = orbit_radius*obj.omega;
                obj.angle = angle;
                obj.r_vec = orbit_radius*[cos(angle); sin(angle); 0];
                obj.v_vec = obj.velocity*[-sin(angle); cos(angle); 0];
            end
        end
        %Find what the velocity will be at some time in the future
        function output = v_calc(obj, time)
            delta_angle = obj.omega*time;
            output = obj.velocity*[-sin(obj.angle + delta_angle); cos(obj.angle + delta_angle); 0];
        end
        %Reset angle, r, and v variables to their values after a certian
        %amount of time passes
        function output = reset_initials(obj, time)
            obj.angle = obj.angle + obj.omega*time;
            obj.r_vec = obj.radius*[cos(obj.angle); sin(obj.angle); 0];
            obj.v_vec = obj.velocity*[-sin(obj.angle); cos(obj.angle); 0];
            output = obj;
        end
    end
end
