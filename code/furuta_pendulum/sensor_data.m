function [sd] = sensor_data(y)
    
    if( y<1)
        sd = 1;
    else
        sd = 0;
    end    
end