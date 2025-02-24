function launch_data = launch2orbit(planet,launch_site,altitude,i,RA,burn_time)

%Find orbital data for desired circular orbit
[r_vec,v_vec,orbit_plane_normal] = planet.CircularOrbitState(altitude,i,RA,0);
r = norm(r_vec);
v = norm(v_vec);

%Find how long it takes for the launch site to be in the plane of the
%desired orbit
site_coords = launch_site.coordinates;
site_vec = launch_site.unit_vec;
plane_angle = deg2rad(atan2d(orbit_plane_normal(2), orbit_plane_normal(1))) + pi;
site_angle = deg2rad(atan2d(site_vec(2), site_vec(1))) + planet.angle;
launch_angle = acos(cot(i)*(tan(site_coords(1))));

%Select the earliest launch opportunity that hasn't already passed
lower_delta = (angdiff(site_angle, plane_angle) - launch_angle)/planet.omega;
upper_delta = (angdiff(site_angle, plane_angle) + launch_angle)/planet.omega;
if lower_delta<0 && upper_delta<0
    wait_time = lower_delta + 2*pi/planet.omega;
elseif lower_delta<0 && upper_delta>0
    wait_time = upper_delta;
else
    wait_time = lower_delta;
end

%Rotate vectors from inertial to earth fixed at t=0
initial_rot = planet.PlanetRotation(0);
%Rotate vectors from inertial to earth fixed frame at t=wait_time
launch_rot = planet.PlanetRotation(wait_time);
%Difference between the two rotations above
delta_rot = initial_rot'*launch_rot;

%Magnitude of the planet's rotational velocity at the launch site
site_rot_v = planet.omega*cos(site_coords(1))*r;

%Find inital position, veloctiy, and centripetal acceleration
r_initial = r*initial_rot*site_vec;
v_initial = site_rot_v*cross([0;0;1], r_initial/norm(r_initial))/(norm(cross([0;0;1], r_initial/norm(r_initial))));
a_centripetal = site_rot_v^2/(r*cos(site_coords(1)));

%Position and delta-v required to reach the desired orbit at launch time
r_target = r*launch_rot*site_vec;
v_target = (v*cross(orbit_plane_normal, launch_rot*site_vec)) - delta_rot*v_initial;

launch_data = struct("wait_time", wait_time, ...
                "v_target", v_target, ...
                "r_target", r_target, ...
                "burn_time", burn_time, ...
                "ground2geo", launch_rot, ...
                "orbit_plane_normal", orbit_plane_normal, ...
                "r_initial", r_initial, ...
                "v_initial", v_initial, ...
                "a_centripetal", a_centripetal);

end

