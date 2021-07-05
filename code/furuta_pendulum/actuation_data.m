function [ad] = actuation_data(u)
    
    if( u < 1) % actuation successful
        ad = 1;
    else
        ad = 0;
    end    

end