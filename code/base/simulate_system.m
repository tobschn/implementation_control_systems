function [t, x, y, u, s, recActRes, recSenRes, t_controller] = simulate_system( ...
    f, g, c, r, t_end, ctl_period, ctl_delay, x0, u0, z0, ...
    channel, initVector, errorHandling)
    %
    % SIMULATE_SYSTEM (f, g, c, r, t_end, ctl_period, ctl_delay, x0, u0)
    %
    % The function simulates the evolution of a system and its controller.
    % Initial conditions for the state of the system is given via x0 and
    % for the control signal via u0.
    %
    % System dynamics are specified (repsectively) using functions f and g.
    % The control signal computation is specified using function c.
    % Setpoint generation is achieved using the function r.
    %
    % The simulation is carried out from time 0 to time t_end. The control
    % function is executed every ctl_period and is assumed to have a
    % computational delay of ctl_delay.
    %
    % ---------------------------------------------------------------------
    %
    % REQUIREMENTS:
    %
    %     The computational delay should be not greater than the period
    %
    % INPUT:
    %
    %     f:          header for state dynamic function matching
    %                 function [x, t] = f(u, tend, x0)
    %     g:          header for the output computation matching
    %                 function [y] = g(x, u)
    %     c:          header for the control signal computation matching
    %                 function [u, z] = c(setpoint, y, z_old, period)
    %     r:          header for the setpoint generation matching
    %                 function [r] = setpoint_computation(t)
    %     t_end:      end time for the simulation
    %     ctl_period: controller period (passed to c)
    %     ctl_delay:  computational delay
    %     x0:         initial plant state
    %     u0:         initial control signal
    %     z0:         initial controller state
    %     channel:    probability channel 
    %                        function [rec] = channel(firstUse, initVector)
    %     initVector: probability vector for probability function 
    %
    % OUTPUT:
    %
    %     t:          time vector (vector with lenght |t|)
    %     x:          system states (matrix with |t| rows)
    %     y:          system output (matrix with |t| rows)
    %     u:          control signals (matrix with |t| rows)
    %     s:          setpoint (matrix with |t| rows)
    %
    % ---------------------------------------------------------------------

 
    % verify that the computational delay is not greater than period
    if (ctl_delay > ctl_period)
        disp('<SIMULATE_SYSTEM> ERROR: ctl_delay > ctl_period');
        return;
    end

    % initialization of results
    t = [];
    x = [];
    y = [];
    u = [];
    t_controller = [0:ctl_period:t_end-ctl_period];
    recActRes = [];
    recSenRes = [];

    % how many periods should we simulate
    num_periods = ceil(t_end/ctl_period);
    
    % initialization
    x0p = x0; % initial state setup
    u0p = u0; % initial control value
    z0p = z0; % initial controller state
    t0p = 0; % time at the start of the period (0 means also first execution)
    
    old_z = z0;

    for p = 1:num_periods

        sp = r(t0p); % get setpoint with function r
        y0p = g(x0p', u0p'); % get output value (reading sensor data)u
        
        %determines if the sensor data was/will be transmitted and received
        %correctly (sensor->controller)
        if(t0p == 0) %first execution
            recSensor = channel(1, initVector);
        else
            recSensor = channel(0);
        end
        
        [ctl_signal, zp] = c(sp, y0p, z0p, ctl_period, recSensor, errorHandling); % get u with function c
        
        %compute if there is data loss from controller -> actuator
        recActuator = channel(0);
        if recActuator == 0
            if(errorHandling == 0)
                %set the control signal to 0 (strategy zero)
                ctl_signal = 0;
            else
                %lets keep the control signal to previously
                %computed one (strategy hold)
                u = u_old1;
            end
            zp = old_z;
        end
        
        old_z = zp; %save the old zp for the next iteration
            
        
        
       
        
        % if I have computational delay I need to split the period in two
        % parts: one with the old control value and one with the new
        % if not, I can simply apply directly the new control signal
        % or if the computational delay is equal to the control period
        % (LET) I can use the old value

        % only new
        if (ctl_delay == 0)

            [xp, tp] = f(ctl_signal, ctl_period, x0p);
            yp = g(xp, ctl_signal);
            up = ones(size(tp)) * ctl_signal;

        % only old control value
        elseif (ctl_delay == ctl_period)

            [xp, tp] = f(u0p, ctl_period, x0p);
            yp = g(xp, u0p);
            up = ones(size(tp)) * u0p;

        % mix of old and new control value
        else

            % split the samples kind of evenly (does not mean that the
            % time is split evenly, not particularly exciting solution
            % but otherwise one would have to change this based on the
            % computational delay and it gets just overly complicated)
            
            [xu0, tu0] = f(u0p, ctl_delay, x0p);
            yu0 = g(xu0, u0p);
            x0p = xu0(end, :)';
            u0v = ones(size(tu0)) .* u0p; 
            
            [xu1, tu1] = f(ctl_signal, ctl_period-ctl_delay, x0p);
            yu1 = g(xu1, ctl_signal);
            tu1 = tu1 + ctl_delay; % rescale vector to start
            u1v = ones(size(tu1)) .* ctl_signal;

            xp = [xu0; xu1];
            yp = [yu0; yu1];
            tp = [tu0; tu1];
            up = [u0v; u1v];
            
        end

    t = [t; tp+t0p];
    x = [x; xp];
    y = [y; yp];
    u = [u; up];
    recActRes = [recActRes; recActuator]; %could be used for diagrams about
    recSenRes = [recSenRes; recSensor];
    %network errors
    

    % preparation for next step
    t0p = t0p + ctl_period; % we will start a new period
    x0p = xp(end, :)'; % initial state setup for next period
    u0p = ctl_signal; % control signal setup for next period
    z0p = zp; % controller state setup for next period

    end
    
    s = arrayfun(r,t); % get the vector of setpoints

end

