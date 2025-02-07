function [launch_data,launch_initial,orbit_plane_normal] = launch2orbit(planet,launch_site,altitude,i,RA)

%TODO replace with CircularOrbitState

[r,v] = planet.CircularOrbit(altitude);
%Find the unit vector normal to the plane of the orbit (z axis in perifocal
%frame)
Q2 = [1, 0, 0;
      0, cos(i), sin(i);
      0, -sin(i), cos(i)];
Q3 = [cos(RA), sin(RA), 0;
      -sin(RA), cos(RA), 0;
      0, 0, 1];
peri2geo = (Q2*Q3)';
orbit_plane_normal = peri2geo*[0;0;1];

%Find how long it takes for the launch site to be in the plane of the
%desired orbit. Assume inertial and geocentric earth axes are aligned at
%t=0
site_coords = launch_site.coordinates;
site_vec = launch_site.unit_vec;
plane_angle = deg2rad(atan2d(orbit_plane_normal(2), orbit_plane_normal(1))) + pi;
site_angle = deg2rad(atan2d(site_vec(2), site_vec(1))) + planet.angle;
launch_angle = acos(cot(i)*(tan(site_coords(1))));

%Select the earliest launch opportunity that hasn't already passed
lower_delta = (angdiff(site_angle, plane_angle) - launch_angle)/planet.omega;
upper_delta = (angdiff(site_angle, plane_angle) + launch_angle)/planet.omega;
if lower_delta<0 && upper_delta<0
    delta_t = lower_delta + 2*pi/planet.omega;
elseif lower_delta<0 && upper_delta>0
    delta_t = upper_delta;
else
    delta_t = lower_delta;
end

initial_rot = planet.PlanetRotation(0);
ground2geo = planet.PlanetRotation(delta_t);
delta_rot = initial_rot'*ground2geo;

site_rot_v = planet.omega*cos(site_coords(1))*r;

r_initial = r*initial_rot*site_vec;
v_initial = site_rot_v*cross([0;0;1], r_initial/norm(r_initial))/(norm(cross([0;0;1], r_initial/norm(r_initial))));
a_centripetal = site_rot_v^2/(r*cos(site_coords(1)));

r_target = r*ground2geo*site_vec;
v_target = (v*cross(orbit_plane_normal, ground2geo*site_vec)) - delta_rot*v_initial;

launch_data = struct("delta_t", delta_t, ...
                     "v_target", v_target, ...
                     "r_target", r_target, ...
                     "ground2geo", ground2geo);
launch_initial = struct("r_initial", r_initial, ...
                        "v_initial", v_initial, ...
                        "a_centripetal", a_centripetal);

end

