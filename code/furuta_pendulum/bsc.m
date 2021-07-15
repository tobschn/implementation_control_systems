% binary symmetric channel
% if first use, set parameter p
% otherwise ignore parameter and use already set p
% p: probability to receive correctly

function rec = bsc(firstUse, p)
	persistent prob;
	if firstUse
		prob = p;
	end
	if rand() <= prob
		rec = 1;
	else
		rec = 0;
	end
end