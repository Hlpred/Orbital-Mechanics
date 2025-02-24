function escape_data = escape(planet,site,launch_data,transfer_data,burn_time)

%Matrix to convert a vector from equatorial to the ecliptic coordinates
equ2ecl = planet.equ2ecl;
%Find the desired velcoity after escaping Earth in equatorial coordinates
v_escape = equ2ecl'*transfer_data.v_escape;
v_inf = norm(v_escape);

altitude = norm(launch_data.r_target) - planet.radius;
[r,v] = planet.CircularOrbit(altitude);

%Delta-v required to put be put on desired escape trajectory
v_target_transfer = v*(sqrt(2 + (v_inf/v)^2) - 1);
%Angle relative to the escape line (in the direction of v_escape) at the start
%of the burn
beta = acos(1/(1+(r*v_inf^2/planet.mu)));
%Find current angle relative to the escape line
current_anlge = acos(dot(launch_data.r_target, v_escape)/(norm(launch_data.r_target)*norm(v_escape)));

%Calculate how long to wait before starting the escape burn
orbit_plane_normal = launch_data.orbit_plane_normal;
if dot(orbit_plane_normal, cross(launch_data.r_target, v_escape)) < 0
    wait_angle = (pi - current_anlge) + beta;
else
    wait_angle = (pi + current_anlge) + beta;
end
if 2*pi < wait_angle
    wait_angle = wait_angle - 2*pi;
end
omega_orbit = v/r;
time = wait_angle/omega_orbit;

%Matrix that roatates vectors by one wait angle in the direciton of the
%orbit (rotate them into their position at the time of the escape burn)
escape_rot = axang2rotm([orbit_plane_normal', wait_angle]);
ground2geo = planet.PlanetRotation(launch_data.wait_time);
%Orbital velocity the moment before the escape burn starts
v_before_escape = escape_rot*(v*cross(orbit_plane_normal, ground2geo*site.unit_vec));
%Delta_v to put the spacecraft on the desired escape trajectory
v_target = v_target_transfer*(v_before_escape/norm(v_before_escape));

escape_data = struct("v_target", v_target, ...
                     "burn_time", burn_time, ...
                     "time", time);

end

