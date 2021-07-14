% ensure no interference
clear; clc;
close all;

% adding to the path the simulation function
addpath('../base'); 

% the state of the pendulum is
% x = [arm angle;
%      arm angular velocity;
%      pendulum angle;
%      pendulum angolar velocity]
% the objective of control is to get the pendulum angle to zero
% y = x(3)

t_end = 3;
x0 = [0; 0; pi; 0];
u0 = 0;
z0 = [0; 0]; % state of the controller

controller_period = 0.01;
computational_delay = 0.005;

f = @dynamics_furuta;
g = @output_furuta;
%c = @ctl_sol_withswingup_sat05;
c = @ctl_withswingup_sat075;
r = @setpoint_furuta;

%channel (gilbert-elliot)
%based on markov chain

channel = @sgem;
alpha = 0.01;          %transistion probability to go from bad->bad
beta =  0.65;          %transistion probability to go from good->good
initState = 1;         %initial state

initVector = [alpha; beta; initState];

%alternative channel
% channel = @bsc;
% p = 0.63;           %probability to receive correctly
% initVector = p;




[t, x, y, u, s] = simulate_system(f, g, c, r, t_end, ...
    controller_period, computational_delay, x0, u0, z0, ...
    channel, initVector);

plot_results(t, x, y, u, s, t_end, controller_period, computational_delay, 0);
perf = compute_performance(t, y, s);
