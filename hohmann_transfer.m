function [transfer_data, transfer_initial] = hohmann_transfer(Start,End,mu)

%Define constants for hohmann transfer orbit
h = sqrt(2*mu)*sqrt(Start.radius*End.radius/(Start.radius + End.radius));
v_transfer_start = h/Start.radius;
v_transfer_end = h/End.radius;
a = (Start.radius + End.radius)/2;
T = pi*a^(3/2)/sqrt(mu);

%Planetary Orbit Constants
a_centripetal = Start.velocity^2/Start.radius;

%Find the angle of the ending body relative to the starting body
%(start_angle) at the start of the hohmann transfer
rel_angle = angdiff(Start.angle, End.angle);
rel_omega = End.omega - Start.omega;
delta_angle = End.omega*T;
start_angle = angdiff(delta_angle, pi);

%Ensure that wait_time is positive by offseting wait_angle by 2*pi or -2*pi
%depending on the sign of rel_omega
direction = sign(rel_omega);
if angdiff(rel_angle, start_angle) > 0 && direction == -1
    wait_angle = angdiff(rel_angle, start_angle) - 2*pi;
elseif angdiff(rel_angle, start_angle) < 0 && direction == 1
    wait_angle = angdiff(rel_angle, start_angle) + 2*pi;
else
    wait_angle = angdiff(rel_angle, start_angle);
end
wait_time = wait_angle/rel_omega;

%Find initial planetary state vectors for the simulation
start_r = Start.r_vec;
start_v = Start.v_vec;

%Find the inertial velocity of the starting planet at the start of the
%hohmann transfer
start_maneuver_v = Start.v_calc(wait_time);

%Find the delta-V by subtracting the initial planetary
%velocity from the velocity at the start of the hohmann transfer
v_escape = v_transfer_start*(start_maneuver_v/norm(start_maneuver_v)) - start_maneuver_v;

%Find the inertial velocity of the ending planet at the end of the
%hohmann transfer
end_maneuver_v = End.v_calc(wait_time + T);

%Find the delta-V by subtracting velocity at end of the hohmann transfer
%from the final planetary velocity
v_encounter = end_maneuver_v - v_transfer_end*(end_maneuver_v/norm(end_maneuver_v));

transfer_data = struct("wait_time", wait_time, ...
                        "v_escape", v_escape, ...
                        "v_encounter", v_encounter, ...
                        "T", T);
transfer_initial = struct("r_initial", start_r, ...
                          "v_initial", start_v, ...
                          "a_centripetal", a_centripetal);

end

