% The code that this is based on was initially written for Konovalov (2016) Nature Communications.
% The original code was shared with me and I have maintained some of the basic structure
% and notation; however, I have substantially altered the code for my own purposes.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function start

test = input(['\n\n' ...
  'Is this a test?' '\n' ...
  '1 = Yes' '\n' ...
  '0 = No' '\n' ...
  'Response: ' ]);

if ~ismember(test, [0 1])
    disp('Invalid entry, please try again.')
    sca; return
end

% clear everything from the workspace; everything is saved in the initialization_struct
Screen('CloseAll');
FlushEvents;

if test == 1
    % ------------------------------------------------------------------------------
    % ------------------------------------------------------------------------------
    % ---- Flexible parameters that need to be checked
    % ---- Task specificiations
    num_trials_practice = 2;
    num_trials_main_task = 2;

    % --- File specifications
    % --- get input from user on comptuer system
    comp_os = input(['\n\n' ...
      'Are you on a Mac or a PC?' '\n' ...
      '1 = Mac' '\n' ...
      '0 = PC' '\n' ...
      'Response: ' ]);

    if ~ismember(comp_os, [0 1])
        disp('Invalid entry, please try again.')
        sca; return
    end

    if comp_os == 1
      file_root = '/Users/alex/OneDrive - Duke University/1_research/2_mdt_thriving/4_raw_data'; % for Alex's computer
      sl = '/'; % for OSX
    else
      file_root = '\Users\ads48\Documents\mdt_thriving\raw_data'; % for the eye-tracker
      sl = '\'; % for Windows
    end

    % using a touchscreen or keyboard?
      if comp_os == 1
          input_source = input(['\n\n' ...
            'Are you using a keyboard or touchscreen?' '\n' ...
            '3 = Local Keyboard' '\n' ...
            '6 = External Keyboard' '\n' ...
            'Response: ' ]);

            if ~ismember(input_source, [3 6])
                disp('Invalid entry, please try again.')
                sca; return
            end
      else
        input_source = input(['\n\n' ...
          'Are you using a keyboard or touchscreen?' '\n' ...
          '0 = Local Keyboard' '\n' ...
          '1 = Touchscreen' '\n' ...
          'Response: ' ]);

          if ~ismember(input_source, [0 1])
              disp('Invalid entry, please try again.')
              sca; return
          end
      end

    % --- Check that file root is correct
    file_root_cor = input(['Is the file root correct?' '\n' ...
    file_root '\n\n' ...
    '0 = No; restart the function' '\n' ...
    '1 = Yes' '\n' ...
    'Response: ']);

    if ~ismember(file_root_cor, [0 1])
      disp('Invalid entry, please try again.')
      sca; return
    end

    if file_root_cor == 0
       disp([fprintf('\n') ...
       'OK, fix the file root and restart the function to try again'])
       sca; return
    end
else
    num_trials_practice = 15;
    num_trials_main_task = 150;
    file_root = '\Users\ads48\Documents\MDT project files\run1\raw data\matlab'; % for the eye-tracker
    sl = '\'; % for Windows
    input_source = 1;
end


% ---- Text formatting specifications
textsize_directions = 30;
textsize_allergy_wanting_rateGuide = 20;
textsize_fixcross = 40;
textsize_countdown = 20;

% ---- loading bar formatting
load_bar_dimensions = [400, 15];

% ---- iti distributions N~(mean, sd)
win_iti = [5, 0.5];
loss_iti = [3, 0.5];

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

sub = input('Nest ID: '); %keep sub number as a string so we can validate easily below

% create subject folder in the raw data folder
filename_subnum = pad(num2str(sub), 4, 'left', '0');
data_file_path = [file_root sl 'sub' filename_subnum];
[~, msg, ~] = mkdir(data_file_path);

folder_already_exists = strcmp(msg, 'Directory already exists.');

if folder_already_exists
   sub_exists = input(['\n\n' ...
   'Subject' filename_subnum ' already exists. Do you want to enter a new subject number?' '\n\n' ...
     '1 = Yes, I''ll restart and enter a new subject number.' '\n' ...
     '0 = No, I need to alter this subject''s data' '\n' ...
     'Response: ' ]);

     if ~ismember(sub_exists, [0 1])
       disp('Invalid entry, please try again.')
       sca;
       return
     end
else
   sub_exists = 99;
end


if sub_exists == 1
   disp([ fprintf('\n') ...
   'OK, you should restart the function to try again'])
   sca;
   return


elseif sub_exists == 0
    load([data_file_path sl 'initialization_structure.mat']);

    start_where = input(['Where do you want to start?' '\n' ...
    'You will overwrite any existing data on and after the place you choose.' '\n\n' ...
    '0 = CANCEL and restart the function' '\n' ...
    '1 = Tutorial' '\n' ...
    '2 = Practice Rounds' '\n' ...
    '3 = Test Rounds' '\n' ...
    'Response: ']);

    if ~ismember(start_where, [0 1 2 3])
      disp('Invalid entry, please try again.')
      sca; return
    end

    if start_where == 0
       disp([fprintf('\n') ...
       'OK, you should restart the function to try again'])
       sca; return
    end

else
    start_where = 1;
    initialization_struct = struct;

    % Enter the condition that the subject is in
    condition = input(['\n\n' ...
      'What condition is this subject in?' '\n' ...
      '1 = Food Condition' '\n' ...
      '2 = Sticker Condition' '\n' ...
      'Response: ' ]);

    if ~ismember(condition, [1 2])
        disp('Invalid entry, please try again.')
        sca;
        clear initialization_struct;
        return
    end

    if condition == 1
        % pick salty food
        img_files = dir(['food_images' sl '*.png']);
        img_file_names = {img_files(1:length(img_files)).name}';
        img_file_index = find(contains(img_file_names, 'salt'))';

        food_salt = input(['Select the salty food for this participant.' '\n' ...
        'Please select one of the following foods.' '\n\n' ...
        num2str(img_file_index(1)) ' = ' img_file_names{img_file_index(1)} '\n' ...
        num2str(img_file_index(2)) ' = ' img_file_names{img_file_index(2)} '\n' ...
        num2str(img_file_index(3)) ' = ' img_file_names{img_file_index(3)} '\n' ...
        num2str(img_file_index(4)) ' = ' img_file_names{img_file_index(4)} '\n' ...
        num2str(img_file_index(5)) ' = ' img_file_names{img_file_index(5)} '\n' ...
        'Response: ']);

        if ~ismember(food_salt, [1 2 3 4 5])
            disp('Invalid entry, please try again.')
            sca;
            clear initialization_struct;
            return
        end

        initialization_struct.food_salt = cellstr(img_file_names{food_salt});

        % pick sweet food
        img_file_names = {img_files(1:length(img_files)).name}';
        img_file_index = find(contains(img_file_names, 'sweet'))';

        food_sweet = input(['Select the sweet food for this participant.' '\n' ...
        'Please select one of the following foods.' '\n\n' ...
        num2str(img_file_index(1)) ' = ' img_file_names{img_file_index(1)} '\n' ...
        num2str(img_file_index(2)) ' = ' img_file_names{img_file_index(2)} '\n' ...
        num2str(img_file_index(3)) ' = ' img_file_names{img_file_index(3)} '\n' ...
        num2str(img_file_index(4)) ' = ' img_file_names{img_file_index(4)} '\n' ...
        num2str(img_file_index(5)) ' = ' img_file_names{img_file_index(5)} '\n' ...
        'Response: ']);

        if ~ismember(food_sweet, [6 7 8 9 10])
            disp('Invalid entry, please try again.')
            sca;
            clear initialization_struct;
            return
        end

        initialization_struct.food_sweet = cellstr(img_file_names{food_sweet});
        % sweet left when equal zero
        initialization_struct.left_item = randi([0,1]);

        % identify which food is left or right
        if initialization_struct.left_item == 1
            initialization_struct.left_item = initialization_struct.food_sweet{1}(7:end-4);
            initialization_struct.right_item = initialization_struct.food_salt{1}(6:end-4);
        else
            initialization_struct.right_item = initialization_struct.food_sweet{1}(7:end-4);
            initialization_struct.left_item = initialization_struct.food_salt{1}(6:end-4);
        end
    else
      % this is where stuff for the sticker condition needs to go that I haven't figure out yet
      % NEED CODE HERE
      % NEED CODE HERE
      % NEED CODE HERE
    end

    % save whether this is a test or not
    initialization_struct.test = test;
    initialization_struct.input_source = input_source;

    % shuffle the rng and save the seed
    rng('shuffle');
    init_rng_seed = rng;
    init_rng_seed = init_rng_seed.Seed;

    % create stimuli structure
    initialization_struct.sub = sub; % save the subject number into the structure
    initialization_struct.data_file_path = data_file_path; % save the data file path as well
    initialization_struct.rng_seed = init_rng_seed; % save the rng seed for the initialization_structure
    if condition == 1
        initialization_struct.condition = 'food'; % save the condition that the subject was randomized into

    else
        initialization_struct.condition = 'sticker';
    end
    % stimuli sets
    spaceships = {'cornhusk', 'stingray', 'triangle', 'tripod'}
    aliens = {'gizmo', 'sully', 'bear', 'vlad', 'piglet', 'elmo', 'mac', 'sid'};
    step1_colors = {'blue', 'orange'};
    step2_color_pairs = {'red_purple', 'yellow_green'};
    step2_color = {'warm', 'cool'};

    % create shuffled arrays of each of the symbols and colors
    initialization_struct.stim_color_step1 = step1_colors(randperm(numel(step1_colors)));
    initialization_struct.stim_colors_step2 = step2_color_pairs(randperm(numel(step2_color_pairs)));
    initialization_struct.stim_step2_color_select = step2_color(randperm(numel(step2_color)));
    initialization_struct.spaceships = prac_symbols(randperm(numel(spaceships)));
    initialization_struct.aliens = symbols(randperm(numel(aliens)));

    % This was randomized when there was more than 1 block
    % however the code still uses this to differentiate between practice and main experiment
    initialization_struct.block = [0 1];

    % input the number of trials per block; 1 = practice trials, 2 = experimental blocks
    initialization_struct.num_trials = [num_trials_practice num_trials_main_task];

    % set the file root and backslash vs. forwardslash convention
    initialization_struct.file_root = file_root;
    initialization_struct.slash_convention = sl;

    % set the text formatting specs
    initialization_struct.textsize_directions = textsize_directions;
    initialization_struct.textsize_allergy_wanting_rateGuide = textsize_allergy_wanting_rateGuide;
    initialization_struct.textsize_fixcross = textsize_fixcross;
    initialization_struct.textsize_countdown = textsize_countdown;

    % set the load bar formaating
    initialization_struct.load_bar_dimensions = load_bar_dimensions;

    % create the ITIs
    iti_init = zeros(150,6);
    % loss iti
    iti_init(:,1) = normrnd(loss_iti(1),loss_iti(2),150,1);
    % win iti
    iti_init(:,2) = normrnd(win_iti(1),win_iti(2),150,1);
    % number of frames per iti; subtract 24 frames because the chosen stimulus is shown for 1 second before the loading bar
    iti_init(:,3:4) = floor(iti_init(:,1:2)*24) - 24;
    %number of pixels per frame
    iti_init(:,5:6) = (ones(150,2)*load_bar_dimensions(1))./iti_init(:,3:4);
    initialization_struct.iti_init = iti_init;

    % load the walk
    load(['walks.mat']);
    walk_idx = randi(length(walks.payoff_prob));
    initialization_struct.walk_idx = walk_idx;
    initialization_struct.payoff_prob = walks.payoff_prob(:,:,walk_idx);
    initialization_struct.walk_seed = walks.seed(walk_idx);

    save([data_file_path sl 'initialization_structure'], 'initialization_struct', '-v6')


    % --- Double check everything
    double_check = input(['\n\n' ...
      'Nest ID = ' num2str(initialization_struct.sub) '\n' ...
      'Condition = ' initialization_struct.condition '\n' ...
      'Left item = ' initialization_struct.left_item '\n' ...
      'Right item = ' initialization_struct.right_item '\n\n' ...
      '0 = I need to fix something; restart the function.' '\n' ...
      '1 = This is correct; continue.' '\n' ...
      'Response: ' ]);

    if ~ismember(double_check, [0 1])
      disp('Invalid entry, please try again.')
      sca;
      return
    end

    if double_check == 0
       disp([fprintf('\n') ...
       'OK, you should restart the function to try again'])
       sca;
       return
    end

end

% if start_where == 1
% % ---- 1: Tutorial
%     exit_flag = tutorial_v4(initialization_struct);
%
%     if exit_flag == 1
%         disp('The script was exited because ESCAPE was pressed')
%         sca; return
%     end
% end

if start_where <= 2
% ---- 2: practice trials (Block 0 in code)
    exit_flag = main_task(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1));

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

% if start_where <= 3
% % ---- 3: main experiment trials
% % ---- space prepped?
%     if condition == 1
%       reward_bowl_prep = input(['\n\n' ...
%         'Left Food = ' initialization_struct.left_item '\n'...
%         'Right Food = ' initialization_struct.right_item '\n\n' ...
%         '1 = Food is set up/participant has water; continue.' '\n' ...
%         '0 = I need to fix something; exit the script.' '\n' ...
%         'Response: ' ]);
%     else
%       reward_bowl_prep = input(['\n\n' ...
%         'Left Bowl = ' initialization_struct.left_item '\n'...
%         'Right Bowl = ' initialization_struct.right_item '\n\n' ...
%         '1 = Bowls are set up; continue.' '\n' ...
%         '0 = I need to fix something; exit the script.' '\n' ...
%         'Response: ' ]);
%     end
%
%     if ~ismember(reward_bowl_prep, [0 1])
%         disp('Invalid entry, please try again.')
%         sca; return
%     elseif reward_bowl_prep == 0
%         disp([fprintf('\n') ...
%         'OK, you should restart the function to try again'])
%         sca; return
%     end
%
% % --- run the task
%     exit_flag = main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));
%
%     if exit_flag == 1
%         disp('The script was exited because ESCAPE was pressed')
%         sca; return
%     end
% end
%
% % --- display winnings
% load([data_file_path sl 'money.mat']);
% fprintf('\n\n\n\n\n\n\n\n\n\nThe participant earned $ %.2f during the money rounds', money_struct.payoff_sum);
% fprintf('\nRound up to the nearest dollar and pay them (show up fee included) = $ %.2f', money_struct.payoff_total);

end
