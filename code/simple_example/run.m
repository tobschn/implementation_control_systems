% ensure no interference
clear; clc;
close all;

% adding to the path the simulation function
addpath('../base'); 

t_end = 5;
x0 = [1; -1];
u0 = 0;
z0 = 0;

controller_period = 0.1;
computational_delay = 0;

f = @dynamics_simple;
g = @output_simple;
c = @pi_sol_simple;
r = @setpoint_simple;

[t, x, y, u, s] = simulate_system(f, g, c, r, t_end, ...
    controller_period, computational_delay, x0, u0, z0);

plot_results(t, x, y, u, s, t_end, controller_period, computational_delay, 1);
perf = compute_performance(t, y, s)