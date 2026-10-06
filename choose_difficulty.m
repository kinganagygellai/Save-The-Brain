function difficulty = choose_difficulty()

    % Create difficulty selection window
    fig = figure('Name', 'Choose Difficulty', ...
                 'Position', [250, 120, 700, 550], ...
                 'Color', [0.91 0.87 0.98]);

    axes('Position', [0 0 1 1]);
    axis([0 100 0 100]);
    axis off;
    hold on;


    % =========================
    % TITLE
    % =========================

    text(50, 84, 'CHOOSE YOUR DIFFICULTY', ...
         'FontSize', 24, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.1 0.1 0.1], ...
         'FontName', 'Britannic Bold');


    % =========================
    % BEGINNER DESCRIPTION
    % =========================

    text(50, 70, 'BEGINNER', ...
         'FontSize', 19, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.1 0.55 0.2], ...
         'FontName', 'Britannic Bold');

    text(50, 64, 'A slower and more relaxed challenge', ...
         'FontSize', 14, ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.2 0.2 0.2], ...
         'FontName', 'Britannic Bold');


    % =========================
    % ADVANCED DESCRIPTION
    % =========================

    text(50, 39, 'ADVANCED', ...
         'FontSize', 19, ...
         'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.75 0.1 0.1], ...
         'FontName', 'Britannic Bold');

    text(50, 33, 'Faster neurons and a greater challenge', ...
         'FontSize', 14, ...
         'HorizontalAlignment', 'center', ...
         'Color', [0.2 0.2 0.2], ...
         'FontName', 'Britannic Bold');


    % =========================
    % BUTTONS
    % =========================

    global difficulty_selected;
    difficulty_selected = 0;


    % Beginner button
    uicontrol('Style', 'pushbutton', ...
              'String', 'BEGINNER', ...
              'Position', [250, 275, 200, 55], ...
              'FontSize', 14, ...
              'FontWeight', 'bold', ...
              'FontName', 'Britannic Bold', ...
              'BackgroundColor', [0.25 0.70 0.35], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) select_beginner(fig));


    % Advanced button
    uicontrol('Style', 'pushbutton', ...
              'String', 'ADVANCED', ...
              'Position', [250, 110, 200, 55], ...
              'FontSize', 14, ...
              'FontWeight', 'bold', ...
              'FontName', 'Britannic Bold', ...
              'BackgroundColor', [0.80 0.20 0.20], ...
              'ForegroundColor', [1 1 1], ...
              'Callback', @(~,~) select_advanced(fig));


    % =========================
    % WAIT FOR SELECTION
    % =========================

    while ishghandle(fig)
        pause(0.1);
    end

    difficulty = difficulty_selected;

end


% =========================================================
% BEGINNER BUTTON
% =========================================================

function select_beginner(fig)

    global difficulty_selected;

    difficulty_selected = 1;

    if ishghandle(fig)
        close(fig);
    endif

end


% =========================================================
% ADVANCED BUTTON
% =========================================================

function select_advanced(fig)

    global difficulty_selected;

    difficulty_selected = 2;

    if ishghandle(fig)
        close(fig);
    endif

end
