function restart_clicked = win_screen()

    % Create victory screen
    fig = figure('Name', 'You Win!', ...
                 'Position', [200, 100, 800, 600], ...
                 'Color', [0.86 0.96 0.90]);

    axes('Position', [0 0 1 1]);
    axis([0 100 0 100]);
    axis off;
    hold on;


    % =========================
    % WINNING MESSAGE
    % =========================

    text(50, 75, 'YOU WIN!', ...
         'FontSize', 35, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.1 0.55 0.25], ...
         'FontName', 'Britannic Bold');


    text(50, 62, 'You successfully protected the brain!', ...
         'FontSize', 20, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.15 0.25 0.20], ...
         'FontName', 'Britannic Bold');


% =========================
% WINNING PICTURE
% =========================

win_picture = imread('winning.jpg');

img_height = size(win_picture, 1);
img_width = size(win_picture, 2);

img_width_units = 22;
img_height_units = img_width_units * img_height / img_width;

x_center = 50;
y_top = 58;

x_left = x_center - img_width_units / 2;
x_right = x_center + img_width_units / 2;

y_bottom = y_top - img_height_units;

% Display picture with correct orientation
image([x_left x_right], [y_top y_bottom], win_picture);

hold on;


    % =========================
    % RESTART BUTTON
    % =========================

    global r_clicked;
    r_clicked = false;

    uicontrol('Style', 'pushbutton', ...
              'String', 'PLAY AGAIN', ...
              'Position', [300, 150, 200, 50], ...
              'FontSize', 14, ...
              'FontWeight', 'bold', ...
              'FontName', 'Britannic Bold', ...
              'BackgroundColor', [0.25 0.70 0.40], ...
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
