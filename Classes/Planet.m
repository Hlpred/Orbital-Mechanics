classdef Planet
    properties
        mu
        radius
        day_length
        omega
        angle
        obliquity
        equ2ecl
    end
    methods
        function obj = Planet(mu, planet_radius, rotational_period, obliquity, angle)
            if nargin > 0
                obj.mu = mu;
                obj.radius = planet_radius;
                obj.day_length = rotational_period;
                obj.omega = 2*pi/rotational_period;
                obj.obliquity = obliquity;
                %Note this only works for Earth right now because the omega
                %vectors of other planets point in other direcitons
                obj.equ2ecl = [1, 0, 0;
                               0, cos(deg2rad(obliquity)), sin(deg2rad(obliquity));
                               0, -sin(deg2rad(obliquity)), cos(deg2rad(obliquity))];
                obj.angle = angle;
            end
        end
        function rotation = PlanetRotation(obj, delta_t)
            rot_angle = obj.omega*delta_t + obj.angle;
            rotation = [cos(rot_angle), -sin(rot_angle), 0;
                        sin(rot_angle), cos(rot_angle), 0;
                        0, 0, 1];
        end
        function [r,v] = CircularOrbit(obj, altitude)
            r = altitude + obj.radius;
            v = sqrt(obj.mu/r);
        end
        function [r_vec,v_vec,orbit_plane_normal] = CircularOrbitState(obj, altitude, i, RA, theta)
            [r,v] = obj.CircularOrbit(altitude);
            h = r*v;
            r_vec_peri = (h^2/obj.mu)*[cos(theta);sin(theta);0];
            v_vec_peri = (obj.mu/h)*[-sin(theta); cos(theta); 0];
            Q2 = [1, 0, 0;
                  0, cos(i), sin(i);
                  0, -sin(i), cos(i)];
            Q3 = [cos(RA), sin(RA), 0;
                  -sin(RA), cos(RA), 0;
                  0, 0, 1];
            peri2geo = (Q2*Q3)';
            orbit_plane_normal = peri2geo*[0;0;1];
            r_vec = peri2geo*r_vec_peri;
            v_vec = peri2geo*v_vec_peri;
        end
    end
end
