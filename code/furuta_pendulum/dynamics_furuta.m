function [x, t] = dynamics_simple(u, tend, x0)

    % modelling constants
    alpha = 0.0033472;
    beta = 0.0038852;
    gamma = 0.0024879;
    delta = 0.097625;
    
    tau_phi = u; % torque applied to the rotational arm
    tau_theta = 0; % torque applied to the pendulum
    
    % the state of the pendulum is
    % x = [arm angle;
    %      arm angular velocity;
    %      pendulum angle;
    %      pendulum angolar velocity]
    % and with this we can write
    % der(x) = [x(2);
    %           ...; complex expression taken from literature
    %           x(4);
    %           ...] complex expression taken from literature
    
    % here we define the nonlinear model
    fx = @(t,x)[ ...
        x(2);
        1/(alpha*beta-gamma^2+(beta^2+gamma^2)*sin(x(3))^2) * ...
           (beta*gamma*(sin(x(3))^2-1)*sin(x(3))*x(2)^2- ...
            2*beta^2*cos(x(3))*sin(x(3))*x(2)*x(4)+ ...
            beta*gamma*sin(x(3))*x(4)^2- ...
            gamma*delta*cos(x(3))*sin(x(3))+ ...
            beta*tau_phi- ...
            gamma*cos(x(3))*tau_theta);
        x(4);
        1/(alpha*beta-gamma^2+(beta^2+gamma^2)*sin(x(3))^2) * ...
           (beta*(alpha+beta*sin(x(3))^2)*cos(x(3))*sin(x(3))*x(2)^2+ ...
           2*beta*gamma*(1-(sin(x(3))^2))*sin(x(3))*x(2)*x(4)- ...
           gamma^2*cos(x(3))*sin(x(3))*x(4)^2+ ...
           delta*(alpha+beta*(sin(x(3)))^2)*sin(x(3))- ...
           gamma*cos(x(3))*tau_phi+(alpha+beta*(sin(x(3)))^2)*tau_theta) ...
        ];
    
    tspan = [0 tend];
    sol = ode45(fx, tspan, x0);
    
    % generate result vectors
    t = linspace(0, tend, 20)';
    x = deval(sol, t)';

end