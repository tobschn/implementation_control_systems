% simplified gilbert-elliott channel
% if first use, set parameter p
% otherwise ignore parameter and use already set p
% a alpha, b beta, i initial state (0 bad, 1 good)
% alpha transition prob of bad->bad

function rec = sgem(firstUse, a, b, i)
	global alpha;
	global beta;
	global state;
	if firstUse
		alpha = a;
		beta = b;
		state = i;
		rec = state;
		return;
	end
	
	if state == 0
		% bad state
		if rand() <= alpha
			% stay here
			rec = 0;
		else
			% move to good
			state = 1;
			rec = 1;
		end
	else
		% good state
		if rand() <= beta
			% stay here
			rec = 1;
		else
			% move to bad
			state = 0;
			rec = 0;
		end
	end
end