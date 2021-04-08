function [] = plot_results(t, x, y, u, s, t_end, ctl_period, ctl_delay, annotate)

    % annotate determine if you want to have vertical lines
    % for periods and computational delays

    % create a figure and maximise it on the screen
    % in the figure we'll have three subplots
    f = figure('WindowState','maximized');
    pause(1);
    %f.Position;
    
    % first subplot: output and setpoint
    subplot(3,1,1);
    
        hold on; grid on;
        plot(t, y, 'o', 'LineWidth', 2);
        plot(t, s, ':k', 'LineWidth', 2);
        title('Output (and Setpoint)');
        legend('y','r');
        xlim([0 t_end]);
        
    subplot(3,1,2);
    
        hold on; grid on;
        plot(t, x, 'o', 'LineWidth', 2);
        title('System States');
        legend("x" + string(1:size(x,2)));
        xlim([0 t_end]);
        
    subplot(3,1,3);
    
        hold on;  grid on;
        plot(t, u, 'o', 'LineWidth', 2);
        title('Control Signal');
        legend('u');
        xlim([0 t_end]);
        
        if (annotate)
            
            for p = 1:round(t_end/ctl_period)
                xline(p*ctl_period, '-', 'HandleVisibility', 'off', 'LineWidth', 2);
                xline(ctl_delay+(p-1)*ctl_period,':', 'HandleVisibility', 'off', 'LineWidth', 2);
            end
            
        end

end




