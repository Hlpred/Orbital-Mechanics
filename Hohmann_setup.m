%Everything is in SI units unless otherwise specified

%Universal Gravitational Constant
G = 6.674*10^-11;
%Mass
M = 1.989*10^30;
%Gravitaional Parameter
Sun_mu = G*M;

%Earth's Orbit
R_earth = 149.6*10^9;
%Earth's Orbital Period
T_earth = 365.256 * 24 * 3600;
%Set arbitrary starting angle
Earth_outbound = Solar_Orbit(R_earth,T_earth,deg2rad(51));

%Mars' Orbit
R_mars = 227.9*10^9;
%Mars' Orbital Period
T_mars = 1.881*T_earth;
%Set arbitrary starting angle
Mars_outbound = Solar_Orbit(R_mars,T_mars,deg2rad(143));

burn_time = 1;
%Calculate the outbound transfer (from Earth to Mars)
transfer_outbound_data = hohmann_transfer(Earth_outbound,Mars_outbound,Sun_mu,burn_time);

%Change the initial conditions (angle, r, and v) of Earth and Mars to their 
%values after the duration of the transit.
delta_t = transfer_outbound_data.wait_time + transfer_outbound_data.transfer_time;
Earth_inbound = Earth_outbound.reset_initials(delta_t);
Mars_inbound = Mars_outbound.reset_initials(delta_t);

%Calculate the inbound transfer (from Mars to Earth)
transfer_inbound_data = hohmann_transfer(Mars_inbound,Earth_inbound,Sun_mu,burn_time);

clearvars R_earth T_earth R_mars T_mars G M burn_time