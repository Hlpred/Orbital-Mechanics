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

Earth = Solar_Orbit(R_earth,T_earth,deg2rad(51));

%Mars' Orbit
R_mars = 227.9*10^9;
%Mars' Orbital Period
T_mars = 1.881*T_earth;

Mars = Solar_Orbit(R_mars,T_mars,deg2rad(143));

[transfer_data, transfer_initial] = hohmann_transfer(Earth,Mars,Sun_mu);
transfer_burn_time = 1;
open("Solar_system_sim.slx");

clearvars R_earth T_earth R_mars T_mars G M