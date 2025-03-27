
%Set canister orbital elements (it's in a circular orbit)
canister_altitude = 350e3;
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

i_hat = r_canister/norm(r_canister);
j_hat = v_canister/norm(v_canister);
k_hat = cross(i_hat,j_hat);

%CHW to inertial
Q_xX = [i_hat,j_hat,k_hat];

n = norm(v_canister)/norm(r_canister);
omega = n*k_hat;

delta_r = r_orbiter - r_canister;
delta_v = v_orbiter - v_canister - cross(omega,delta_r);

delta_r_0 = Q_xX'*delta_r;
delta_v_0_minus = Q_xX'*delta_v;

t = 1000;

Phi_rr = [4-3*cos(n*t) 0 0;
          6*(sin(n*t)-n*t) 1 0;
          0 0 cos(n*t)];
Phi_rv = [(1/n)*sin(n*t) (2/n)*(1-cos(n*t)) 0;
          (2/n)*(cos(n*t)-1) (1/n)*(4*sin(n*t)-3*n*t) 0;
          0 0 (1/n)*sin(n*t)];
Phi_vr = [3*n*sin(n*t) 0 0;
          6*n*(cos(n*t)-1) 0 0;
          0 0 -n*sin(n*t)];
Phi_vv = [cos(n*t) 2*sin(n*t) 0;
          -2*sin(n*t) 4*cos(n*t)-3 0;
          0 0 cos(n*t)];

delta_v_0_plus = -inv(Phi_rv)*Phi_rr*delta_r_0;
delta_v_f_minus = Phi_vr*delta_r_0 + Phi_vv*delta_v_0_plus;
Delta_v_0 = delta_v_0_plus - delta_v_0_minus;
Delta_v_f = 0 - delta_v_f_minus;

axang = [Q_xX(:,3)' n*t];
rotm = axang2rotm(axang);
Q_xX_new = rotm*Q_xX;

target_1 = Q_xX*(Delta_v_0);
target_2 = Q_xX_new*(Delta_v_f);