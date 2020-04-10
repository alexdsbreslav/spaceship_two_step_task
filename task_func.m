classdef task_func
    methods(Static)
        function f = drawimage(w, A1, B1, A2, B2, A3, B3, type, state)
            if state == 1

                if type == 0
                X = A1;
                else
                X = B1;
                end

            end

            if state == 2

                if type == 0
                X = A2;
                else
                X = B2;
                end

            end

            if state == 3

                if type == 0
                X = A3;
                else
                X = B3;
                end

            end

            f = Screen('MakeTexture', w, X);
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function f = drawrewards(w, condition, snacks, stickers, tickets, type)
            if strcmp(condition, 'food')

                if type == 0
                  X = snacks;
                else
                  X = tickets;
                end

            else
                if type == 0
                  X = stickers;
                else
                  X = tickets;
                end
            end

            f = Screen('MakeTexture', w, X);
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function f = drawspaceship(w, A1_out, A1_return, B1_out, B1_return, type, direction)
            if type == 0
                if strcmp(direction, 'out')
                    X = A1_out;
                else
                    X = A1_return;
                end
            else
                if strcmp(direction, 'out')
                    X = B1_out;
                else
                    X = B1_return;
                end
            end

            f = Screen('MakeTexture', w, X);
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function [pull, check_trial]  = pull_ticket(m, r, trial, checks)

            if (nnz(checks) < 2) || ...
               (trial >= 30 && trial < 60 && nnz(checks) < 4) || ...
               (trial >= 60 && trial < 90 && nnz(checks) < 6) || ...
               (trial >= 90 && trial < 120 && nnz(checks) < 8) || ...
               (trial >= 120 && nnz(checks) < 10)

                if checks(trial) ~= 0
                    check_trial = checks(trial)*-1;
                    pull = round(m + check_trial*15);
                else
                    check_trial = randi([-1 1]);
                    if check_trial == 0
                        pull = randi([round(m - r), round(m + r)]);
                    else
                        pull = round(m + check_trial*15);
                    end
                end
            else
                pull = randi([round(m - r), round(m + r)]);
                check_trial = 0;
            end

            if pull < 1
                pull = 1;
            end
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function countdown_text = rewards_text(condition, block, trial, trials, win, action, ticks)
            if block == 1
                if strcmp(condition, 'food')
                    if win == 1
                        if action == 0
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Collect your snack!'];
                            elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                                countdown_text = ['A break will begin shortly...' '\n' ...
                                'Collect your snack!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Collect your snack!'];
                            end
                        else
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                                countdown_text = ['A break will begin shortly...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            end
                        end
                    else
                        if trial == trials
                            countdown_text = 'The quest will end shortly...';
                        elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                            countdown_text = 'A break will begin shortly...';
                        else
                            countdown_text = 'Returning Home...';
                        end
                    end
                else
                    if win == 1
                        if action == 0
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Collect a sticker or tattoo!'];
                            elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                                countdown_text = ['A break will begin shortly...' '\n' ...
                                'Collect a sticker or tattoo!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Collect a sticker or tattoo!'];
                            end
                        else
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                                countdown_text = ['A break will begin shortly...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            end
                        end
                    else
                        if trial == trials
                            countdown_text = 'The quest will end shortly...';
                        elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                            countdown_text = 'A break will begin shortly...';
                        else
                            countdown_text = 'Returning Home...';
                        end
                    end
                end
            else
                if strcmp(condition, 'food')
                    if win == 1
                        if action == 0
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Collect your snack!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Collect your snack!'];
                            end
                        else
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            end
                        end
                    else
                        if trial == trials
                            countdown_text = 'The quest will end shortly...';
                        else
                            countdown_text = 'Returning Home...';
                        end
                    end
                else
                    if win == 1
                        if action == 0
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Collect a sticker or tattoo!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Collect a sticker or tattoo!'];
                            end
                        else
                            if trial == trials
                                countdown_text = ['The quest will end shortly...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            else
                                countdown_text = ['Returning Home...' '\n' ...
                                'Adding ' num2str(ticks) ' tickets to your total!'];
                            end
                        end
                    else
                        if trial == trials
                            countdown_text = 'The quest will end shortly...';
                        else
                            countdown_text = 'Returning Home...';
                        end
                    end
                end
            end
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function advance_screen(input_source)
            if input_source == 1
                KbWait(input_source, 2);
            else
                RestrictKeysForKbCheck(KbName('space'));
                KbWait(input_source, 2);
            end
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function [selection, x, y]  = selection(input_source, keys, w, rects)
            % the code below is adapted from code written by Rosa Li (Duke University)
            if input_source == 1

                  % ---- choose the rects
                  if keys(1) == KbName('LeftArrow')
                      rects_idx = 1;
                  else
                      rects_idx = 2;
                  end

                  % ---- capture useful key clicks
                  KbQueueStart(input_source);
                  useable_click = 0;
                  while useable_click == 0 %wait for click inside designated area
                      pressed = KbQueueCheck(input_source);
                      if pressed %if touched
                          [x, y, buttons] = GetMouse(w); %get touch location
                          if (x > rects{rects_idx, 1}(1) && x < rects{rects_idx, 1}(3) && y > rects{rects_idx, 1}(2) && y < rects{rects_idx, 1}(4)) %click inside chosen box
                              useable_click = 1;
                              selection_idx = 1;
                          elseif (x > rects{rects_idx, 2}(1) && x < rects{rects_idx, 2}(3) && y > rects{rects_idx, 2}(2) && y < rects{rects_idx, 2}(4))
                              useable_click = 1;
                              selection_idx = 2;
                          end %click inside chosen box
                      end %if touched
                  end %click inside a designated area

                  selection = keys(selection_idx);
                  KbQueueStop(input_source);
                  KbQueueFlush(input_source);

            else
                % ---- capture selection
                key_is_down = 0;
                FlushEvents;
                RestrictKeysForKbCheck(keys);
                [key_is_down, secs, key_code] = KbCheck(input_source);

                if length(keys) == 2
                    while key_code(keys(1)) == 0 && key_code(keys(2)) == 0
                            [key_is_down, secs, key_code] = KbCheck(input_source);
                    end
                else
                    while key_code(keys(1)) == 0
                            [key_is_down, secs, key_code] = KbCheck(input_source);
                    end
                end

                down_key = find(key_code,1);
                selection = down_key;
                x = NaN;
                y = NaN;
            end
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function [action, choice_loc] = choice(type, keys, selection, x, y)
            if (selection==keys(1) && type == 0) || (selection==keys(2) && type == 1)
                action = 0;
            elseif (selection==keys(1) && type == 1) || (selection==keys(2) && type == 0)
                action = 1;
            end

            choice_loc = selection;
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function img_idx = get_img(img_idx, init, img_collect_on, w)
            if img_collect_on == 1
                imageArray = Screen('GetImage', w);
                imwrite(imageArray, [init.file_root '/tutorial_screen_' num2str(img_idx) '.jpg'], 'Quality', 50);
                img_idx = img_idx + 1;
            end
        end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
        function output_for_food_choice(init)
            data_file_path = init.data_file_path;
            sl = init.slash_convention;

            % load all of the necessary structures
            load([data_file_path sl 'task.mat']);

            % number of trials/size of the array
            trials = init.num_trials(2);
            df = cell(trials, 9);
            df(:, 1) = num2cell(init.sub);
            df(:, 2) = cellstr(init.researcher);
            df(:, 3) = cellstr(init.condition);
            df(:, 4) = cellstr(init.left_item);
            df(:, 5) = cellstr(init.right_item);
            df(:, 6) = num2cell(1:trials);
            df(:, 7) = num2cell(nansum(task.payoff, 2));
            df(:, 8) = num2cell((task.action(:,4) - 1)*-1);

            % convert array to table
            T = table(df(:,1), df(:,2), df(:,3), df(:,4), df(:,5), df(:,6), df(:,7), df(:,8), df(:,9), ...
            'VariableNames', {'subject', 'researcher', 'condition', 'left_item', 'right_item', 'trial', 'win', 'choose_snack_stick', 'choose_left'});

            % print table to excel
            writetable(T, [data_file_path sl 'food_choice.xlsx']);
        end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
    end
end
