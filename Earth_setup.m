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

%Define Earth object
Earth_planet = Planet(mu,R,s,obliquity,deg2rad(9));

%Define altidue and inertial plane of circular orbit
altitude = 300e3;
i = deg2rad(obliquity + 1e-4);
RA = deg2rad(0);

launch_burn_time = 0.1;
launch_data = launch2orbit(Earth_planet,launch_site,altitude,i,RA,launch_burn_time);

run("Solar_system_setup.m");
escape_burn_time = 1;
escape_data = escape(Earth_planet,launch_site,launch_data,transfer_data,escape_burn_time);

open("Earth_sim.slx");
clearvars altitude angle G i M mu obliquity R RA s launch_burn_time escape_burn_time