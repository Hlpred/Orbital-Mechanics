planet = Earth_planet;
site = launch_site;

equ2ecl = planet.equ2ecl;
v_escape = equ2ecl'*transfer_data.v_escape;
v_inf = norm(v_escape);

altitude = 300e3;
[r,v] = planet.CircularOrbit(altitude);

v_target_transfer = v*(sqrt(2 + (v_inf/v)^2) - 1);
beta = acos(1/(1+(r*v_inf^2/planet.mu)));

current_anlge = acos(dot(launch_data.r_target, v_escape)/(norm(launch_data.r_target)*norm(v_escape)));

if dot(orbit_plane_normal, cross(launch_data.r_target, v_escape)) < 0
    wait_angle = (pi - current_anlge) + beta;
else
    wait_angle = (pi + current_anlge) + beta;
end

if 2*pi < wait_angle
    wait_angle = wait_angle - 2*pi;
end

omega_orbit = v/r;
escape_time = wait_angle/omega_orbit;

velocity_rot = axang2rotm([orbit_plane_normal', wait_angle]);
ground2geo = planet.PlanetRotation(launch_data.delta_t);
v_before_escape = velocity_rot*(v*cross(orbit_plane_normal, ground2geo*site.unit_vec));

