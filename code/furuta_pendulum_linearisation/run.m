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

t_end = 0.5;
x0 = [0; 0; 0.5; 0];
u0 = 0;
z0 = 0;

controller_period = 0.01;
computational_delay = 0;

f = @dynamics_furuta_linearisation;
g = @output_furuta_linearisation;
c = @ctl_sol_linearisation;
r = @setpoint_furuta_linearisation;

[t, x, y, u, s] = simulate_system(f, g, c, r, t_end, ...
    controller_period, computational_delay, x0, u0, z0);

plot_results(t, x, y, u, s, t_end, controller_period, computational_delay, 1);
perf = compute_performance(t, y, s)