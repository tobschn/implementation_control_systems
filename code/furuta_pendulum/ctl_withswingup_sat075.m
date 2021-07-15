% The performance becomes better (0.4415 -> 0.3710)
% The controller is the same but the clamping at the end has a wider range
% of values but that is the only difference

function [u, z] = ctl_withswingup_sat075(setpoint, y, z_old, period, rec)

    % controller parameters
    u_min = -0.75;
    u_max = 0.75;
	
	% magic constants
	k = 3;
	c = 65;
	
	% derivative
	dy_dt = (y - z_old(1)) / period;
	% normalized energy (from paper)
	En = 0.5 / c * dy_dt^2 + cos(y) -1;
	
	if En < -0.1
		% modified version from paper to control energy of system
		v = k * En * sign_(dy_dt * sin(2*y));
	elseif abs(y) > 0.5
		% energy has good value but position is not close to the equilibrium
		v = 0;
	else 
		% energy has good value and position is close to the equilibrium
		v = ctl_linearisation(setpoint, y, z_old, period, rec);
	end
	
	 persistent u_old1; % Introducing new variable to keep track of the previous control signal value
	 if isempty(u_old1)
		u_old1 = 0;
	 end


	% if the state is good ( in terms of channel) / if the transmission is
	% success, control signal will be computed properly
	if (rec == 1)    
		u = min(max(u_min, v),u_max);
		z(1) = y;
		u_old1 = u;
	else
		% if the state is bad ( in terms of channel)/ if the transmission
		% is not success, lets keep the control signal to previously
		% computed one
		u = u_old1;
		z(1) = z_old(1);
	end    
end

function [u, z] = ctl_linearisation(setpoint, y, z_old, period, rec)
    % PD controller
    kpp = 0.06/period;      % kp of position
    kpv = -0.002/period;    % kp of velocity
    
    % calculate error
    ep = y - setpoint;   % error of position
    ev = (z_old - y) / period - 0;   % error of velocity (velocity should be 0)
    
    v = kpv * ev + kpp * ep;
    
    persistent u_old2; % Introducing new variable to keep track of the previous control signal value
    if isempty(u_old2)
           u_old2 = 0;
    end  
    
    % if the state is good ( in terms of channel) / if the transmission is
    % success, control signal will be computed properly
    if (rec == 1)
        u = v;
        z = y;
        u_old2 = u;
    else
        %if not, keep the previously computed control signal for this
        %iteration also
        u = u_old2;
        z = y;
    end  
end

function [res] = sign_(val)
	if val == 0
		res = 1;
	else
		res = sign(val);
	end
end
