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

%Set canister orbital elements (it's in a circular orbit)
altitude = 350e3;
i = deg2rad(18.46);
theta = deg2rad(43);

%Find the inital position
capture_data = capture(Mars_planet,altitude,i,theta,transfer_outbound_data);

open("Mars_capture_sim.slx");
clearvars altitude G i M mu R s theta