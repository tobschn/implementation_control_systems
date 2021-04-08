function [] = animate_trajectory(t, x)

    % parameters for visualisation
    arm_lenght = 0.5;
    pendulum_lenght = 1.5;

    figure();
    view(-50, 25);
    c = [.3 .3 .3]; % visualisation colour
    
    base_radius = 0.2;
    base_height = 2;
    [base_x, base_y, base_z] = cylinder(base_radius);
    base_z(2, :) = base_height;
    
    % draw the base
    surf(base_x, base_y, base_z, 'FaceColor', min(c+0.2, 1));
    
    hold on;
    axis off;
    grid off;
    
    % figure size
    xmin = -1.2;
    xmax = 1.2;
    ymin = -1.2;
    ymax = 1.2;
    zmin = -1.2;
    zmax = 4;
    axis([xmin xmax ymin ymax zmin zmax]);
    
    % pendulum initial position
    x_arm_h = [0 arm_lenght];
    y_arm_h = [0 0];
    z_arm_h = [base_height base_height];
    x_arm_v = [arm_lenght arm_lenght];
    y_arm_v = [0 0];
    z_arm_v = [base_height base_height-pendulum_lenght];
    
    % draw initial arms
    arm_h = fill3(x_arm_h, y_arm_h, z_arm_h, 'k', 'LineWidth', 5, 'EdgeColor', c);
    arm_v = fill3(x_arm_v, y_arm_v, z_arm_v, 'k', 'LineWidth', 5, 'EdgeColor', c);
    
    % and top
    top_size = 50;
    top = scatter3(x_arm_v(2), y_arm_v(2), z_arm_v(2), top_size, ...
        'filled', 'MarkerFaceColor', c, 'MarkerEdgeColor', c);
   
    timetext = annotation('textbox',[0.2 0.6 0.1 0.1], ...
        'String','Time: 0.00', 'FitBoxToText','on', 'BackgroundColor', [0.9 0.9 0.9]);
    timetext.FontSize = 14;
    
    % 20 is to make the plot faster
    for ti = 1:20:length(t)
        
        strtime = sprintf('Time: %.2f', t(ti));
        set(timetext, 'String', strtime);
        
        % get the angles
        phi = x(ti, 1);
        theta = - x(ti, 3) - pi;
        
        x_arm_h(2) = arm_lenght * cos(phi);
        y_arm_h(2) = arm_lenght * sin(phi);
        
        x_arm_v = [x_arm_h(2) -pendulum_lenght*sin(theta)*sin(phi)+arm_lenght*cos(phi)];
        y_arm_v = [y_arm_h(2) pendulum_lenght*sin(theta)*cos(phi)+arm_lenght*sin(phi)];
        z_arm_v(2) = -pendulum_lenght*cos(theta)+base_height;
        
        % reset coordinates
        set(arm_h, 'XData', x_arm_h);
        set(arm_h, 'YData', y_arm_h);
        set(arm_h, 'ZData', z_arm_h);
        set(arm_v, 'XData', x_arm_v);
        set(arm_v, 'YData', y_arm_v);
        set(arm_v, 'ZData', z_arm_v);        
        set(top, 'XData', x_arm_v(2));
        set(top, 'YData', y_arm_v(2));
        set(top, 'ZData', z_arm_v(2));
        
        drawnow;
        
    end

end

