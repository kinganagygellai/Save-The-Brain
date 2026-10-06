function game_v1()

    % Force fluid graphics toolkit under Octave if available
    try
        graphics_toolkit('qt');
    catch
        try
            graphics_toolkit('fltk');
        end
    end

    % Clear workspace and close figures
    clear;
    close all;
    clc;


    % =========================================================
    % 1. LAUNCH INTRO SCREEN
    % =========================================================

    try
        intro_screen();
    catch
        return;
    end

% =========================================================
% 2. CHOOSE DIFFICULTY
% =========================================================

difficulty = choose_difficulty();

% If the player closes the difficulty screen
if difficulty == 0
    return;
endif

% =========================================================
% DIFFICULTY SETTINGS
% =========================================================

if difficulty == 1

    % Beginner mode
    beginner_mode = true;

else

    % Advanced mode
    beginner_mode = false;


endif

    % =========================================================
    % 3. SETUP GAME BOARD AND HANDLES
    % =========================================================

    graphics();

    global h_time_text h_lives_text;

    lives = 3;
    isPlaying = true;
    game_duration = 30;

    neurons = struct('h', {}, ...
                     'x', {}, ...
                     'y', {}, ...
                     'type', {}, ...
                     'is_healthy', {});

    selected_idx = 0;

    global click_detected click_coords;

    click_detected = false;
    click_coords = [0, 0];

    fig = gcf;

    set(fig, ...
        'WindowButtonDownFcn', @(~,~) capture_click());


    % =========================================================
    % 4. MAIN GAME LOOP
    % =========================================================

    tic;

    last_spawn_time = -3.0;
    prev_time_left = -1;


    while isPlaying && lives > 0

        if ~ishghandle(fig)
            return;
        end


        % -----------------------------------------------------
        % TIME
        % -----------------------------------------------------

        current_time = toc;

        time_left = max(0, ...
                        round(game_duration - current_time));


% =========================
% PROGRESSIVE DIFFICULTY
% =========================

if difficulty == 1

    % =========================
    % BEGINNER MODE
    % =========================

    % Neurons gradually become faster
    if current_time < 5
        drop_speed = 0.6;

    elseif current_time < 10
        drop_speed = 0.7;

    elseif current_time < 15
        drop_speed = 0.8;

    elseif current_time < 25
        drop_speed = 1;

    else
        drop_speed = 1.2;
    endif


    % New neurons gradually appear more often
    if current_time < 5
        spawn_interval = 3.0;

    elseif current_time < 10
        spawn_interval = 2.7;

    elseif current_time < 15
        spawn_interval = 2.4;

    elseif current_time < 25
        spawn_interval = 2.2;

    else
        spawn_interval = 2;
    endif


else

    % =========================
    % ADVANCED MODE
    % =========================

    % Neurons become much faster
    if current_time < 5
        drop_speed = 0.7;

    elseif current_time < 10
        drop_speed = 1.1;

    elseif current_time < 15
        drop_speed = 1.4;

    elseif current_time < 25
        drop_speed = 1.8;

    else
        drop_speed = 2;
    endif


    % New neurons appear much more frequently
    if current_time < 5
        spawn_interval = 2.2;

    elseif current_time < 10
        spawn_interval = 1.8;

    elseif current_time < 15
        spawn_interval = 1.6;

    elseif current_time < 25
        spawn_interval = 1.3;

    else
        spawn_interval = 1.0;
    endif

endif


        % -----------------------------------------------------
        % UPDATE CLOCK
        % -----------------------------------------------------

        if time_left ~= prev_time_left

            if ~isempty(h_time_text) && ishghandle(h_time_text)

                set(h_time_text, ...
                    'String', ...
                    sprintf('TIME: %d', time_left));

            end

            prev_time_left = time_left;

        end


        % -----------------------------------------------------
        % CHECK TIMER
        % -----------------------------------------------------

        if current_time >= game_duration

            isPlaying = false;

            if win_screen()
                game_v1();
            end

            break;

        end


        % =====================================================
        % SPAWN NEW NEURON
        % =====================================================

        if current_time - last_spawn_time >= spawn_interval

            neuron_type = randi(2);

            is_healthy = (neuron_type == 1);


            spawn_x_options = [35, 50, 65];

            pos_x = spawn_x_options( ...
                randi(length(spawn_x_options)));

            pos_y = 72;


            hold on;

            h_list = drawneuron( ...
                pos_x, ...
                pos_y, ...
                neuron_type);


            new_neuron = struct( ...
                'h', h_list, ...
                'x', pos_x, ...
                'y', pos_y, ...
                'type', neuron_type, ...
                'is_healthy', is_healthy);


            neurons(end+1) = new_neuron;

            last_spawn_time = current_time;

        end


        % =====================================================
        % MOVE ALL NEURONS DOWN
        % =====================================================

        i = 1;

        while i <= length(neurons)

            neurons(i).y = ...
                neurons(i).y - drop_speed;


            % -------------------------------------------------
            % NEURON REACHES BOTTOM
            % -------------------------------------------------

            if neurons(i).y <= 34

                lives = lives - 1;


                hearts = repmat( ...
                    '♥ ', ...
                    1, ...
                    max(0, lives));


                if ~isempty(h_lives_text) && ...
                   ishghandle(h_lives_text)

                    set(h_lives_text, ...
                        'String', ...
                        ['LIVES: ', hearts]);

                end


                if ~isempty(neurons(i).h)

                    valid_h = neurons(i).h( ...
                        ishandle(neurons(i).h));

                    if ~isempty(valid_h)
                        delete(valid_h);
                    end

                end


                if selected_idx == i

                    selected_idx = 0;

                elseif selected_idx > i

                    selected_idx = selected_idx - 1;

                end


                neurons(i) = [];


            else

                % Move every graphical component
                % of the neuron by the same amount

                for h_handle = neurons(i).h

                    if ishandle(h_handle)

                        y_data = get( ...
                            h_handle, ...
                            'YData');

                        set( ...
                            h_handle, ...
                            'YData', ...
                            y_data - drop_speed);

                    end

                end

                i = i + 1;

            end

        end


        drawnow;


        % =====================================================
        % PROCESS USER CLICKS
        % =====================================================

        if click_detected

            click_detected = false;

            click_x = click_coords(1);
            click_y = click_coords(2);


            % -------------------------------------------------
            % SELECT A NEURON
            % -------------------------------------------------

            if selected_idx == 0

                for k = 1:length(neurons)

                    if abs(click_x - neurons(k).x) < 8 && ...
                       abs(click_y - neurons(k).y) < 8

                        selected_idx = k;

                        break;

                    end

                end


            % -------------------------------------------------
            % CHOOSE DESTINATION
            % -------------------------------------------------

            else

                target_is_trash = ...
                    (click_x >= 15 && ...
                     click_x <= 33 && ...
                     click_y >= 12 && ...
                     click_y <= 34);


                target_is_brain = ...
                    (click_x >= 67 && ...
                     click_x <= 85 && ...
                     click_y >= 12 && ...
                     click_y <= 34);


                if target_is_brain || target_is_trash

                    if selected_idx <= length(neurons)

                        is_healthy = ...
                            neurons(selected_idx).is_healthy;


                        % -------------------------------------
                        % CORRECT SORTING
                        % -------------------------------------

                        if (is_healthy && target_is_brain) || ...
   (~is_healthy && target_is_trash)

    if ~isempty(neurons(selected_idx).h)

        h_v = neurons(selected_idx).h( ...
            ishandle(neurons(selected_idx).h));

        if ~isempty(h_v)
            delete(h_v);
        end

    end

    neurons(selected_idx) = [];

    % Spawn the next neuron immediately
    last_spawn_time = current_time - spawn_interval;


                        % -------------------------------------
                        % WRONG SORTING
                        % -------------------------------------

                        else

                            lives = lives - 1;


                            hearts = repmat( ...
                                '♥ ', ...
                                1, ...
                                max(0, lives));


                            if ~isempty(h_lives_text) && ...
                               ishghandle(h_lives_text)

                                set(h_lives_text, ...
                                    'String', ...
                                    ['LIVES: ', hearts]);

                            end


                            if ~isempty( ...
                                    neurons(selected_idx).h)

                                h_v = neurons(selected_idx).h( ...
                                    ishandle( ...
                                    neurons(selected_idx).h));

                                if ~isempty(h_v)
                                    delete(h_v);
                                end

                            end


                            neurons(selected_idx) = [];

                        end

                    end


                    selected_idx = 0;

                end

            end

        end


        % Small pause to keep animation smooth
        pause(0.05);

    end


    % =========================================================
    % 5. LOSE SCREEN
    % =========================================================

    if lives <= 0 && ishghandle(fig)

        if lose_screen()
            game_v1();
        end

    end

end


% =============================================================
% CAPTURE MOUSE CLICK
% =============================================================

function capture_click()

    global click_detected click_coords;

    click_pos = get(gca, 'CurrentPoint');

    click_coords = [ ...
        click_pos(1, 1), ...
        click_pos(1, 2)];

    click_detected = true;

end
