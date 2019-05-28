% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function start

test = 99;
while ~ismember(test, [0 1])
    test = input(['\n\n' ...
      'Is this a test?' '\n' ...
      '1 = Yes' '\n' ...
      '0 = No' '\n' ...
      'Response: ' ]);

    if ~ismember(test, [0 1])
        disp('Invalid entry, please try again.')
    end
end

% clear everything from the workspace; everything is saved in the initialization_struct
Screen('CloseAll');
FlushEvents;

if test == 1
    % ------------------------------------------------------------------------------
    % ------------------------------------------------------------------------------
    % ---- Flexible parameters that need to be checked
    % ---- Task specificiations
    num_trials_practice = 5;
    num_trials_main_task = 5;

    % --- File specifications
    % --- get input from user on comptuer system
    comp_os = 99;
    while ~ismember(comp_os, [0 1])
        comp_os = input(['\n\n' ...
          'Are you on a Mac or a PC?' '\n' ...
          '1 = Mac' '\n' ...
          '0 = PC' '\n' ...
          'Response: ' ]);

        if ~ismember(comp_os, [0 1])
            disp('Invalid entry, please try again.')
        end
    end

    if comp_os == 1
      file_root = '/Users/alex/OneDrive - Duke University/1_research/2_mdt_thriving/6_raw_data'; % for Alex's computer
      sl = '/'; % for OSX
    else
      file_root = '\Users\ads48\Documents\mdt_thriving\raw_data'; % for the eye-tracker
      sl = '\'; % for Windows
    end

    % using a touchscreen or keyboard?
      if comp_os == 1
          input_source = 6;
      else
          input_source = 99;
          while ~ismember(input_source, [0 1])
              input_source = input(['\n\n' ...
                'Are you using a keyboard or touchscreen?' '\n' ...
                '0 = Keyboard' '\n' ...
                '1 = Touchscreen' '\n' ...
                'Response: ' ]);

                if ~ismember(input_source, [0 1])
                    disp('Invalid entry, please try again.')
                end
          end
      end
else
    num_trials_practice = 10;
    num_trials_main_task = 150;
    file_root = '\Users\ads48\Documents\MDT project files\run1\raw data\matlab'; % for the eye-tracker
    sl = '\'; % for Windows
    input_source = 1;
end


% ---- Text formatting specifications
textsize = 40;
textsize_feedback = 50;
textsize_tickets = 140;

% ---- loading bar formatting
load_bar_dimensions = [400, 15];

% ---- iti distributions N~(mean, sd)
win_iti = [5, 0.5];
loss_iti = [3, 0.5];

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

sub = input('Subject ID: '); %keep sub number as a string so we can validate easily below

% create subject folder in the raw data folder
filename_subnum = pad(num2str(sub), 4, 'left', '0');
data_file_path = [file_root sl 'sub' filename_subnum];
[~, msg, ~] = mkdir(data_file_path);

folder_already_exists = strcmp(msg, 'Directory already exists.');

if folder_already_exists
  sub_exists = 99;
  while ~ismember(sub_exists, [0 1])
     sub_exists = input(['\n\n' ...
     'Subject' filename_subnum ' already exists. Do you want to enter a new subject number?' '\n\n' ...
       '0 = No, I need to alter this subject''s data' '\n' ...
       '1 = Yes, I''ll restart and enter a new subject number.' '\n' ...
       'Response: ' ]);

     if ~ismember(sub_exists, [0 1])
       disp('Invalid entry, please try again.')
     end
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

    start_where = 99;
    while ~ismember(start_where, [0 1 2 3 4 5])
        start_where = input(['Where do you want to start?' '\n' ...
        'You will overwrite any existing data on and after the place you choose.' '\n\n' ...
        '0 = CANCEL and restart the function' '\n' ...
        '1 = Re-initialize the subject''s data (this completely starts over)' '\n' ...
        '2 = Tutorial Part 1' '\n' ...
        '3 = Practice Game' '\n' ...
        '4 = Tutorial Part 2' '\n' ...
        '5 = Main Game' '\n' ...
        'Response: ']);

        if ~ismember(start_where, [0 1 2 3 4 5])
          disp('Invalid entry, please try again.')
        end
    end

    if start_where == 0
         disp([fprintf('\n') ...
         'OK, you should restart the function to try again'])
         sca; return
    elseif start_where == 1
         rmdir(data_file_path, 's');
         mkdir(data_file_path);
    end

else
    start_where = 1;
end

if start_where <= 1;
    initialization_struct = struct;

    % Identify the researcher
    researchers = {'Alesha', 'Julie', 'Logan', 'Tatyana', 'Other'};
    researcher = 99;
    while ~ismember(researcher, [1 2 3 4 5])
        researcher = input(['\n\n' ...
          'What is the name of the researcher conducting the study?' '\n' ...
          '1 = Alesha' '\n' ...
          '2 = Julie' '\n' ...
          '3 = Logan' '\n' ...
          '4 = Tatyana' '\n' ...
          '5 = Other' '\n' ...
          'Response: ' ]);

        if ~ismember(researcher, [1 2 3 4 5])
            disp('Invalid entry, please try again.')
        end

        if researcher == 5
          researcher_specify = input(['\n\n' ...
            'You chose Other. Please type the first name of the researcher conducting the study?' '\n' ...
            'Make sure to capitalize your name (e.g. Alex not alex)' '\n' ...
            'Name: ' ], 's');
        end

    end

    % Enter the condition that the subject is in
    condition = 99;
    while ~ismember(condition, [1 2])
        condition = input(['\n\n' ...
          'What condition is this subject in?' '\n' ...
          '1 = Food Condition' '\n' ...
          '2 = Sticker Condition' '\n' ...
          'Response: ' ]);

        if ~ismember(condition, [1 2])
            disp('Invalid entry, please try again.')
        end
    end

    if condition == 1
        % pick salty food
        foods = {'CheezIts', 'Fritos', 'Goldfish', 'Popcorn', 'Poppables', 'Jellybeans', 'M&Ms', 'Reeses Pieces', 'Skittles', 'SweeTarts'};
        food_salt = 99;
        while ~ismember(food_salt, [1 2 3 4 5])
            food_salt = input(['Select the salty food for this participant.' '\n' ...
            'Please select one of the following foods.' '\n\n' ...
            '1 = ' foods{1} '\n' ...
            '2 = ' foods{2} '\n' ...
            '3 = ' foods{3} '\n' ...
            '4 = ' foods{4} '\n' ...
            '5 = ' foods{5} '\n' ...
            'Response: ']);

            if ~ismember(food_salt, [1 2 3 4 5])
                disp('Invalid entry, please try again.')
            end
        end

        initialization_struct.food_salt = foods{food_salt};
        initialization_struct.sticker = NaN;

        % pick sweet food
        food_sweet = 99;
        while ~ismember(food_sweet, [6 7 8 9 10])
            food_sweet = input(['Select the sweet food for this participant.' '\n' ...
            'Please select one of the following foods.' '\n\n' ...
            '6 = ' foods{6} '\n' ...
            '7 = ' foods{7} '\n' ...
            '8 = ' foods{8} '\n' ...
            '9 = ' foods{9} '\n' ...
            '10 = ' foods{10} '\n' ...
            'Response: ']);

            if ~ismember(food_sweet, [6 7 8 9 10])
                disp('Invalid entry, please try again.')
            end
        end

        initialization_struct.food_sweet = foods{food_sweet};
        initialization_struct.tattoo = NaN;
        % sweet left when equal zero
        initialization_struct.left_item = randi([0,1]);

        % identify which food is left or right
        if initialization_struct.left_item == 1
            initialization_struct.left_item = initialization_struct.food_sweet;
            initialization_struct.right_item = initialization_struct.food_salt;
        else
            initialization_struct.right_item = initialization_struct.food_sweet;
            initialization_struct.left_item = initialization_struct.food_salt;
        end
    else
        % pick sticker
        stickers_tattoos = {'s1', 's2', 's3', 's4', 's5', 't1', 't2', 't3', 't4', 't5'};
        sticker = 99;
        while ~ismember(sticker, [1 2 3 4 5])
            sticker = input(['Select the stickers for this participant.' '\n' ...
            'Please select one of the following stickers.' '\n\n' ...
            '1 = ' stickers_tattoos{1} '\n' ...
            '2 = ' stickers_tattoos{2} '\n' ...
            '3 = ' stickers_tattoos{3} '\n' ...
            '4 = ' stickers_tattoos{4} '\n' ...
            '5 = ' stickers_tattoos{5} '\n' ...
            'Response: ']);

            if ~ismember(sticker, [1 2 3 4 5])
                disp('Invalid entry, please try again.')
            end
        end

        initialization_struct.sticker = stickers_tattoos{sticker};
        initialization_struct.food_salt = NaN;

        % pick tattoo
        tattoo = 99;
        while ~ismember(tattoo, [6 7 8 9 10])
            tattoo = input(['Select the tattoos for this participant.' '\n' ...
            'Please select one of the following tattoos.' '\n\n' ...
            '6 = ' stickers_tattoos{6} '\n' ...
            '7 = ' stickers_tattoos{7} '\n' ...
            '8 = ' stickers_tattoos{8} '\n' ...
            '9 = ' stickers_tattoos{9} '\n' ...
            '10 = ' stickers_tattoos{10} '\n' ...
            'Response: ']);

            if ~ismember(tattoo, [6 7 8 9 10])
                disp('Invalid entry, please try again.')
            end
        end

        initialization_struct.tattoo = stickers_tattoos{tattoo};
        initialization_struct.food_sweet = NaN;
        % sweet left when equal zero
        initialization_struct.left_item = randi([0,1]);

        % identify which food is left or right
        if initialization_struct.left_item == 1
            initialization_struct.left_item = initialization_struct.sticker;
            initialization_struct.right_item = initialization_struct.tattoo;
        else
            initialization_struct.right_item = initialization_struct.tattoo;
            initialization_struct.left_item = initialization_struct.sticker;
        end
    end

    % Input initial WTP for snack food or stickers
    purchase_early = 99;
    while ~ismember(purchase_early, [0 1 2])
        purchase_early = input(['\n\n' ...
          'How many snacks did the subject buy?' '\n' ...
          '0 = Bought 0 bites/stickers, kept all 20 tickets' '\n' ...
          '1 = Bought 1 bite/sticker, kept 10 tickets' '\n' ...
          '2 = Bought 2 bites/stickers, kept 0 tickets' '\n' ...
          'Response: ' ]);

        if ~ismember(purchase_early, [0 1 2])
            disp('Invalid entry, please try again.')
        end
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

    if researcher == 5
        initialization_struct.researcher = researcher_specify;
    else
        initialization_struct.researcher = researchers{researcher}; % save the name of the researcher who conducted the study
    end

    if condition == 1
        initialization_struct.condition = 'food'; % save the condition that the subject was randomized into

    else
        initialization_struct.condition = 'sticker';
    end
    % bought snacks before task?
    initialization_struct.purchase_early = purchase_early;

    % stimuli sets
    spaceships = {'cornhusk', 'stingray', 'triangle', 'tripod'};
    aliens = {'gizmo', 'sully', 'bear', 'vlad', 'piglet', 'elmo', 'mac', 'sid'};
    step1_colors = {'blue', 'orange'};
    step2_color_pairs = {'red_purple', 'yellow_green'};
    step2_color = {'warm', 'cool'};

    % create shuffled arrays of each of the symbols and colors
    initialization_struct.stim_color_step1 = step1_colors(randperm(numel(step1_colors)));
    initialization_struct.stim_colors_step2 = step2_color_pairs(randperm(numel(step2_color_pairs)));
    initialization_struct.stim_step2_color_select = step2_color(randperm(numel(step2_color)));
    initialization_struct.spaceships = spaceships(randperm(numel(spaceships)));
    initialization_struct.aliens = aliens(randperm(numel(aliens)));

    % This was randomized when there was more than 1 block
    % however the code still uses this to differentiate between practice and main experiment
    initialization_struct.block = [0 1];

    % input the number of trials per block; 1 = practice trials, 2 = experimental blocks
    initialization_struct.num_trials = [num_trials_practice num_trials_main_task];

    % set the file root and backslash vs. forwardslash convention
    initialization_struct.file_root = file_root;
    initialization_struct.slash_convention = sl;

    % set the text formatting specs
    initialization_struct.textsize = textsize;
    initialization_struct.textsize_feedback = textsize_feedback;
    initialization_struct.textsize_tickets = textsize_tickets;

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

    save([data_file_path sl 'initialization_structure'], 'initialization_struct', '-v6');


    % --- Double check everything
    double_check = 99;
    while ~ismember(double_check, [0 1])
        double_check = input(['\n\n' ...
          'Researcher = ' initialization_struct.researcher '\n' ...
          'Subject ID = ' num2str(initialization_struct.sub) '\n' ...
          'Condition = ' initialization_struct.condition '\n' ...
          'Left item = ' initialization_struct.left_item '\n' ...
          'Right item = ' initialization_struct.right_item '\n' ...
          'Number of bites/stickers purchased = ' num2str(initialization_struct.purchase_early) '\n\n' ...'
          '0 = I need to fix something; restart the function.' '\n' ...
          '1 = This is correct; continue.' '\n' ...
          'Response: ' ]);

        if ~ismember(double_check, [0 1])
          disp('Invalid entry, please try again.')
        end
    end

    if double_check == 0
       disp([fprintf('\n') ...
       'OK, you should restart the function to try again'])
       sca;
       return
    end

end

if start_where <= 2
% ---- 1: Tutorial
    exit_flag = tutorial_part1(initialization_struct);

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

if start_where <= 3
% ---- 2: practice trials (Block 0 in code)
    exit_flag = practice_trials(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1));

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

if start_where <= 4
% ---- 1: Tutorial
    exit_flag = tutorial_part2(initialization_struct);

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

if start_where <= 5
% ---- 3: main experiment trials
% ---- space prepped?
    reward_bowl_prep = 99;
    while ~ismember(reward_bowl_prep, [0 1])
        if strcmp(initialization_struct.condition, 'food')
          reward_bowl_prep = input(['\n\n' ...
            'Left Food = ' initialization_struct.left_item '\n'...
            'Right Food = ' initialization_struct.right_item '\n\n' ...
            '**Left and right is from the participant''s perspective**' '\n\n' ...
            '1 = Food is set up/participant has water; continue.' '\n' ...
            '0 = I need to fix something; exit the script.' '\n' ...
            'Response: ' ]);
        else
          reward_bowl_prep = input(['\n\n' ...
            'Left Bowl = ' initialization_struct.left_item '\n'...
            'Right Bowl = ' initialization_struct.right_item '\n\n' ...
            '**Left and right is from the participant''s perspective**' '\n\n' ...
            '1 = Bowls are set up; continue.' '\n' ...
            '0 = I need to fix something; exit the script.' '\n' ...
            'Response: ' ]);
        end

        if ~ismember(reward_bowl_prep, [0 1])
            disp('Invalid entry, please try again.')
        end
    end

    if reward_bowl_prep == 0
        disp([fprintf('\n') ...
        'OK, you should restart the function to try again'])
        sca;
        return
    end

% --- run the task
    exit_flag = main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end
%
% --- display winnings
load([data_file_path sl 'task.mat']);
task_func.output_for_food_choice(initialization_struct);
disp([fprintf('\n\n\n') ...
'The participant earned ' num2str(task_struct.ticket_sum) ' tickets'])

end
