% z_old(1): old y
% z: same but current
function [u, z] = ctl_withswingup_sat05(setpoint, y, z_old, period)
    % controller parameters
    u_min = -0.5;
    u_max = 0.5;
    
	% magic constants
	k = 3;
	c = 65;
	
	% derivative
	dy_dt = (y - z_old(1)) / period;
	% normalized energy (from paper)
	En = 0.5 / c * dy_dt^2 + cos(y) -1;
	
	if En < -0.1 || En > 1
		% modified version from paper to control energy of system
		v = k * En * sign_(dy_dt * sin(2*y));
	elseif abs(y) > 0.5
		% energy has good value but position is not close to the equilibrium
		v = 0;
	else 
		% energy has good value and position is close to the equilibrium
		v = ctl_linearisation(setpoint, y, z_old, period);
	end
	
	u = min(max(u_min, v),u_max);
	z(1) = y;
end

function [u, z] = ctl_linearisation(setpoint, y, z_old, period)
    % PD controller
    kpp = 0.06/period;      % kp of position
    kpv = -0.002/period;    % kp of velocity
    
    % calculate error
    ep = y - setpoint;   % error of position
    ev = (z_old - y) / period - 0;   % error of velocity (velocity should be 0)
    
    v = kpv * ev + kpp * ep;
    
    % generate output
    u = v;
    z = y;
    
end

function [res] = sign_(val)
	if val == 0
		res = 1;
	else
		res = sign(val);
	end
end