% simplified gilbert-elliott channel
% On first use, set parameter firstUse and setup vektor: [alpha, beta, state]
% alpha: transistion probability to go from bad->bad
% beta:  transistion probability to go from good->good
% state: default state either 0 (bad) or 1 (good)
% otherwise the functions ignores those parameters and
% uses the already set ones
% a alpha, b beta, i initial state (0 bad, 1 good)
% alpha transition prob of bad->bad

function rec = sgem(firstUse, setup)
	persistent alpha;
	persistent beta;
	persistent state;
	if firstUse
		alpha = setup(1);
		beta = setup(2);
		state = setup(3);
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