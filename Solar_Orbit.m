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
        function output = v_calc(obj, time)
            delta_angle = obj.omega*time;
            output = obj.velocity*[-sin(obj.angle + delta_angle); cos(obj.angle + delta_angle); 0];
        end
    end
end
