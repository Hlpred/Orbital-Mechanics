%Set canister orbital elements (it's in a circular orbit)
canister_altitude = 330e3;
canister_i = deg2rad(18.46);
canister_RA = deg2rad(128);
canister_theta = deg2rad(45);

[r_canister,v_canister,~] = Mars_planet.CircularOrbitState(canister_altitude,canister_i,canister_RA,canister_theta);

rendezvous_data.canister_initial = struct("r_initial", r_canister, ...
                                          "v_initial", v_canister, ...
                                          "a_centripetal", 0);

%Set orbiter orbital elements (it's in a circular orbit)
orbiter_altitude = 325e3;
orbiter_i = deg2rad(18.46);
orbiter_RA = deg2rad(128);
orbiter_theta = deg2rad(45);

[r_orbiter,v_orbiter,~] = Mars_planet.CircularOrbitState(orbiter_altitude,orbiter_i,orbiter_RA,orbiter_theta);

rendezvous_data.orbiter_initial = struct("r_initial", r_orbiter, ...
                                         "v_initial", v_orbiter, ...
                                         "a_centripetal", 0);

t = 500;
rendezvous_data = rendezvous(rendezvous_data,t);

clearvars canister_altitude canister_i canister_RA canister_theta orbiter_altitude orbiter_i orbiter_RA orbiter_theta r_canister v_canister r_orbiter v_orbiter t