function capture_data = capture(planet,altitude,i,theta,transfer_data)

r = altitude + planet.radius;
v_inf = norm(transfer_data.v_encounter);
delta = r*sqrt(1 + 2*planet.mu/(r*v_inf^2));
approach_dir = transfer_data.v_encounter / v_inf;

%Define altidue and inertial plane of circular orbit
approach_RA = rad2deg(atan2(approach_dir(2),approach_dir(1)) + pi);
RA = deg2rad(approach_RA);

[r_canister,v_canister,orbit_plane_normal] = planet.CircularOrbitState(altitude,i,RA,theta);

capture_data.canister_initial = struct("r_initial", r_canister, ...
                                       "v_initial", v_canister, ...
                                       "a_centripetal", 0);

offset_dir = cross(approach_dir, orbit_plane_normal);

r_orbiter = -1e9*approach_dir + delta*offset_dir;
v_orbiter = transfer_data.v_encounter;

h_orbiter = norm(cross(r_orbiter,v_orbiter));
v_r = dot(r_orbiter,v_orbiter)/norm(r_orbiter);
e_vec = (1/planet.mu)*((norm(v_orbiter)^2-(planet.mu/norm(r_orbiter)))*r_orbiter - norm(r_orbiter)*v_r*v_orbiter);
e = norm(e_vec);
theta_inf = acos(((1/(norm(r_orbiter)*(planet.mu/h_orbiter^2))) - 1)/e);
F = 2*atanh(tan((theta_inf)/2)/sqrt((e+1)/(e-1)));
M_h = e*sinh(F) - F;
t = (h_orbiter^3/(planet.mu)^2)*(1/(e^2 - 1)^(3/2))*M_h;
r_p = (h_orbiter^2/planet.mu)*(1/(1+e));
v_p_i = h_orbiter/r_p;
v_p_f = sqrt(planet.mu/r_p);
delta_v = v_p_i-v_p_f;

capture_data.orbiter_initial = struct("r_initial", r_orbiter, ...
                                      "v_initial", v_orbiter, ...
                                      "a_centripetal", 0);

plane = cross(v_orbiter, r_orbiter)/norm(cross(v_orbiter, r_orbiter));
beta = acos(1/(1+(r_p*v_inf^2/planet.mu)));
burn_angle = (pi/2 - beta);
rot = axang2rotm([plane',-burn_angle]);

capture_data.target = delta_v*rot*v_orbiter/norm(v_orbiter);
capture_data.burn_time = t;

end

