%Set orbital elements (it's in a circular orbit)
altitude = 325e3;
i = deg2rad(18.46);
RA = deg2rad(128);
theta = deg2rad(45);

[r,v,orbit_plane_normal] = Mars_planet.CircularOrbitState(altitude,i,RA,theta);

orbit_data = struct("r_target", r, ...
                    "orbit_plane_normal", orbit_plane_normal, ...
                    "v_initial_orbital", v);

escape_burn_time = 1;     
mars_escape_data = escape(Mars_planet,orbit_data,transfer_inbound_data,escape_burn_time);

mars_escape_data.initial = struct("r_initial", r, ...
                                   "v_initial", v, ...
                                   "a_centripetal", 0);
open("Mars_escape_sim.slx");
clearvars altitude i RA theta r v orbit_plane_normal escape_burn_time