clear all

%Everything is in SI units unless otherwise specified

%Universal Gravitational Constant
G = 6.674*10^-11;
%Mass
M = 5.974*10^24;
%Gravitaional Parameter
mu = G*M;
%Average radius
R = 6.378*10^6;
%Sideral Day Length
s = 23.9345 * 3600;
%Axial Tilt in degrees
obliquity = 23.44;

%Launch Site Latitude and Longitude
launch_site = Launch_Site("Kourou","Earth",deg2rad([5.264693257042033; -52.792193957435764]));

launch_burn_time = 0.1;

%Define Earth object
Earth_planet = Planet(mu,R,s,obliquity,deg2rad(9));

%Define altidue and inertial plane of circular orbit
altitude = 300e3;
i = deg2rad(obliquity + 1e-4);
RA = deg2rad(0);

[launch_data,launch_initial,orbit_plane_normal] = launch2orbit(Earth_planet,launch_site,altitude,i,RA);
run("Solar_system_setup.m");
escape_data = escape(Earth_planet,launch_site,launch_data,transfer_data,orbit_plane_normal);

%Maximum simulation step size
max_step_size = 10;

open("Earth_sim.slx");
clearvars altitude angle G i M obliquity R RA s