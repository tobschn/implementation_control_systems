function [x, t] = dynamics_simple(u, tend, x0)

    % this will simulate a linear system with matrices
    A = [-0.01 0.03; 0.02 0.02];
    B = [0.1; 0.2];
    
    % the linear dynamics
    fx = @(t,x)[A*x + B*u];
    
    tspan = [0 tend];
    sol = ode45(fx, tspan, x0);
    
    % generate result vectors
    t = linspace(0, tend, 20)';
    x = deval(sol, t)';

end