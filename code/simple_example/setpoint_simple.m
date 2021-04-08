function [r] = setpoint_simple(t)

    if (t<2.5)
        r = 4;
    else
        r = 1;
    end

end