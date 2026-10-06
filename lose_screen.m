function restart_clicked = lose_screen()

    % Create game over screen
    fig = figure('Name', 'Game Over', ...
                 'Position', [200, 100, 800, 600], ...
                 'Color', [1 1 1]);

    axes('Position', [0 0 1 1]);
    axis([0 100 0 100]);
    axis off;
    hold on;


    % =========================
    % LOSING BACKGROUND
    % =========================

    losing_picture = imread('losing.jpg');

    % Display background across the whole screen
    image([0 100], [100 0], losing_picture);

    hold on;


    % =========================
    % GAME OVER TEXT
    % =========================

    text(50, 65, 'GAME OVER', ...
         'FontSize', 37, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.8 0.1 0.1], ...
         'FontName', 'Britannic Bold');


    text(50, 50, 'Oops! You killed the brain.', ...
         'FontSize', 23, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.2 0.2 0.2], ...
         'FontName', 'Britannic Bold');


    % =========================
    % RESTART BUTTON
    % =========================

    global r_clicked;
    r_clicked = false;

    uicontrol('Style', 'pushbutton', ...
              'String', 'TRY AGAIN', ...
              'Position', [300, 220, 200, 50], ...
              'FontSize', 14, ...
              'FontWeight', 'bold', ...
              'FontName', 'Britannic Bold', ...
              'BackgroundColor', [0.8 0.2 0.2], ...
              'ForegroundColor', [1 1 1]);


    % =========================
    % WAIT FOR RESTART
    % =========================

    set(findall(fig, 'Type', 'uicontrol'), ...
        'Callback', @(~,~) trig_restart(fig));

    while ishghandle(fig)
        pause(0.1);
    end

    restart_clicked = r_clicked;

end


% =========================
% RESTART FUNCTION
% =========================

function trig_restart(fig)

    global r_clicked;

    r_clicked = true;

    if ishghandle(fig)
        close(fig);
    endif

end
