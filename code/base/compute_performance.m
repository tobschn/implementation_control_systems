function [performance] = compute_performance(t, y, s)

    % normalised ise  -- ise/number of points
    performance = sum(sum((s-y).^2)) / length(t);
    
    % normalised iste  -- iste/number of points
    % performance = sum(sum(t.*(s-y).^2)) / length(t);

end




