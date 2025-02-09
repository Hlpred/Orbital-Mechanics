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

%Define altidue and inertial plane of circular orbit
altitude = 325e3;
i = deg2rad(18.46);
RA = deg2rad(251);
theta = deg2rad(43);

[r_canister,v_canister,orbit_plane_normal] = Mars_planet.CircularOrbitState(altitude,i,RA,theta);

canister_initial = struct("r_initial", r_canister, ...
                           "v_initial", v_canister, ...
                           "a_centripetal", 0);
r = norm(r_canister);

v_inf = norm(transfer_data.v_encounter);
approach_dir = transfer_data.v_encounter / v_inf;
delta = r*sqrt(1 + 2*Mars_planet.mu/(r*v_inf^2));

offset_dir = cross(approach_dir,[0;sqrt(2)/2;sqrt(2)/2])/norm(cross(approach_dir,[0;sqrt(2)/2;sqrt(2)/2]));

r_orbiter = -1e9*approach_dir + delta*offset_dir;
v_orbiter = transfer_data.v_encounter;

orbiter_initial = struct("r_initial", r_orbiter, ...
                          "v_initial", v_orbiter, ...
                          "a_centripetal", 0);

delta_v = v_inf*sqrt(2)/2;
little_delta = 2*asin(1/(1+(r*v_inf^2/Mars_planet.mu)));

plane = cross(v_orbiter, r_orbiter)/norm(cross(v_orbiter, r_orbiter));
rot = axang2rotm([plane',-deg2rad(45)]);

capture = delta_v*rot*v_orbiter/norm(v_orbiter);

%open("Mars_sim.slx");