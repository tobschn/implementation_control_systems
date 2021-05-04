function [y] = output_furuta(x, u)

    % this expects a matrix x with number of rows corresponding to data
    % points and number of columns corresponding to states
    % and a matrix u with number of rows corresponding to data points
    % and number of columns corresponding to control signals
    
    C = [0, 0, 1, 0]; % we measure just the angle
    D = 0;
    
    uv = ones(size(x, 1), size(u, 1)) .* u; % because of single u
    y = x*C' + uv*D'; % corresponds to Cx + Du but with the (x, u) above

end