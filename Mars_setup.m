%Everything is in SI units unless otherwise specified

%Universal Gravitational Constant
G = 6.674*10^-11;
%Mass
M = 641.9*10^21;
%Gravitaional Parameter
mu = G*M;
%Average radius
R = 3.396*10^6;
%Sideral Day Length
s = 24.62 * 3600;

%Define Mars object (obliquity and angle are set to zero because Mars'
%rotation doesn't affect the orbital maneuvers around it.
Mars_planet = Planet(mu,R,s,0,0);

altitude = 325e3;
r = altitude + Mars_planet.radius;
v_inf = norm(transfer_data.v_encounter);
delta = r*sqrt(1 + 2*Mars_planet.mu/(r*v_inf^2));
approach_dir = transfer_data.v_encounter / v_inf;

%Define altidue and inertial plane of circular orbit
i = deg2rad(18.46);
approach_RA = rad2deg(atan2(approach_dir(2),approach_dir(1)) + pi);
RA = deg2rad(approach_RA);
theta = deg2rad(43);

[r_canister,v_canister,orbit_plane_normal] = Mars_planet.CircularOrbitState(altitude,i,RA,theta);

canister_initial = struct("r_initial", r_canister, ...
                           "v_initial", v_canister, ...
                           "a_centripetal", 0);

offset_dir = cross(approach_dir, orbit_plane_normal);

r_orbiter = -1e9*approach_dir + delta*offset_dir;
r_orbiter_dir = r_orbiter/norm(r_orbiter);
theta_0 = acos(dot(r_orbiter_dir,approach_dir));

v_orbiter = transfer_data.v_encounter;

%{
h_orbiter = norm(cross(r_orbiter,v_orbiter));
e = (h_orbiter^2/(r*Mars_planet.mu)) - 1;
theta_inf = acos(-1/e);
F = sqrt((e+1)/(e-1))*tan((theta_inf-(pi-theta_0))/2);
M_h = e*sinh(F) - F;
t = (h_orbiter^3/(Mars_planet.mu)^2)*(1/(e^2 - 1)^(3/2))*M_h;
%}

orbiter_initial = struct("r_initial", r_orbiter, ...
                          "v_initial", v_orbiter, ...
                          "a_centripetal", 0);

delta_v = sqrt(v_inf^2 + (2*Mars_planet.mu)/r) - sqrt(Mars_planet.mu/r);
little_delta = 2*asin(1/(1+(r*v_inf^2/Mars_planet.mu)));

plane = cross(v_orbiter, r_orbiter)/norm(cross(v_orbiter, r_orbiter));
beta = acos(1/(1+(r*v_inf^2/Mars_planet.mu)));
burn_angle = (pi/2 - beta);
rot = axang2rotm([plane',-burn_angle]);

capture = delta_v*rot*v_orbiter/norm(v_orbiter);

open("Mars_sim.slx");