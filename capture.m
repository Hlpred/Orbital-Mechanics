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
r_orbiter_dir = r_orbiter/norm(r_orbiter);
theta_0 = acos(dot(r_orbiter_dir,approach_dir));

v_orbiter = transfer_data.v_encounter;

%{
h_orbiter = norm(cross(r_orbiter,v_orbiter));
e = (h_orbiter^2/(r*planet.mu)) - 1;
theta_inf = acos(-1/e);
F = sqrt((e+1)/(e-1))*tan((theta_inf-(pi-theta_0))/2);
M_h = e*sinh(F) - F;
t = (h_orbiter^3/(planet.mu)^2)*(1/(e^2 - 1)^(3/2))*M_h;
%}

capture_data.orbiter_initial = struct("r_initial", r_orbiter, ...
                                      "v_initial", v_orbiter, ...
                                      "a_centripetal", 0);

delta_v = sqrt(v_inf^2 + (2*planet.mu)/r) - sqrt(planet.mu/r);
little_delta = 2*asin(1/(1+(r*v_inf^2/planet.mu)));

plane = cross(v_orbiter, r_orbiter)/norm(cross(v_orbiter, r_orbiter));
beta = acos(1/(1+(r*v_inf^2/planet.mu)));
burn_angle = (pi/2 - beta);
rot = axang2rotm([plane',-burn_angle]);

capture_data.target = delta_v*rot*v_orbiter/norm(v_orbiter);

end

