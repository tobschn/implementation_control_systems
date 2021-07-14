% Control Action with respect to channel
% channel output is rec
% if rec is 1, tranmission is success
% if rec is 0, transmission is not success, data is lost
% here, input is rec , output is ca 
% ca - control action




function [ca] = caocha(rec)
    global ca;
    
    if( rec == 1) 
        ca = 1; % if transmission is success, set ca to 1 ( to compute the control signal)
    else
        ca = 0; % if transmission is lost, set ca to 0 ( set the control signal to zero)
    end    

end
