function [ad] = actuation_data(u)
    
    if( u < 1) % this is just the skeleton, function should return a 0 or 1 depending on something having gone wrong (0) or having been successful (1).
        ad = 1;
    else
        ad = 0;
    end    

end
