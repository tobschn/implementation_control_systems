function [x, t] = dynamics_furuta_linearisation(u, tend, x0)

    % modelling constants
    alpha = 0.0033472;
    beta = 0.0038852;
    gamma = 0.0024879;
    delta = 0.097625;
    
    % the control signal that goes in is the torque applied on the
    % pendulum rotation axis, and the second component is in principle
    % trying to represent effects like friction, so we will not use it
    % here
    u_in = [u; 0]; 
    
    % this corresponds to the linearised version of the pendulum
    % around the equilibrium point upright position x(3)=0
    A = [0, 1, 0, 0 ; ...
         0, 0 -(delta*gamma)/(alpha*beta-gamma^2), 0; ...
         0, 0, 0, 1; ...
         0, 0, (alpha*delta)/(alpha*beta-gamma^2), 0];
    
    B = [0, 0; ...
        (beta)/(alpha*beta-gamma^2), -(gamma)/(alpha*beta-gamma^2); ...
        0, 0; ...
        -(gamma)/(alpha*beta-gamma^2), (alpha)/(alpha*beta-gamma^2)];
     
    % the linear dynamics
    fx = @(t,x)[A*x + B*u_in];
    
    tspan = [0 tend];
    sol = ode45(fx, tspan, x0);
    
    % generate result vectors
    t = linspace(0, tend, 20)';
    x = deval(sol, t)';

end