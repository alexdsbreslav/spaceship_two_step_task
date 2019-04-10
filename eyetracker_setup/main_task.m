% The code that this is based on was initially written for Konovalov (2016) Nature Communications.
% The original code was shared with me and I have maintained some of the basic structure
% and notation; however, I have substantially altered the code for my own purposes.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function exit_flag = main_task(initialization_struct, trials, block, tutorial_timing_struct)

% 1 - Initial setup
    format shortg
    exit_flag = 0;

    % ---- file set up; enables flexibility between OSX and Windows
    sl = initialization_struct.slash_convention;

    % ---- shuffle the rng and save the seed
    rng('shuffle');
    rng_seed = rng;
    rng_seed = rng_seed.Seed;

    % ---- Screen setup
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
    FlushEvents;
    HideCursor;
    PsychDefaultSetup(1);

    % ---- Screen selection
    screens = Screen('Screens'); %count the screen
    whichScreen = max(screens); %select the screen; ALTERED THIS BECAUSE IT KEPT SHOWING UP ON MY LAPTOP INSTEAD OF THE ATTACHED MONITOR
    [w, rect] = Screen('OpenWindow', whichScreen);

    % --- font sizes
    textsize_fixcross = initialization_struct.textsize_fixcross;
    textsize_countdown = initialization_struct.textsize_countdown;
    textsize_directions = initialization_struct.textsize_directions;

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 2 - Define image locations

% ---- display coordinates setup
    r = [0,0,400,290]; %stimuli rectangle
    rc = [0,0,420,310]; %choice rectangle
    slot_r = [0,0,600,480]; % slot rectangle
    r_spenttoken = [0,0,400*.4, 290*.4]; % spent token rectangle
    r_coinslot = [0,0,400*.8, 290*.8]; % coin slot rectangle
    r_next_arrow = [0,0,150,108.75]; % next arrow rectangle
    room_r = [0,0,620*.9,500*.9]; % room rectangle

% ---- locations of original stimuli alone
    Mpoint = CenterRectOnPoint(r, rect(3)*.5, rect(4)*0.5);

% ---- slot machine locations
    slot_Lpoint = CenterRectOnPoint(slot_r, rect(3)*0.2, rect(4)*0.375);
    slot_Rpoint = CenterRectOnPoint(slot_r, rect(3)*0.8, rect(4)*0.375);

% ---- stimuli within slot locations
    slot_label_Lpoint = CenterRectOnPoint(r, rect(3)*0.2, rect(4)*0.4);
    slot_label_Rpoint = CenterRectOnPoint(r, rect(3)*0.8, rect(4)*0.4);

% ---- frames - white during every trial; green when chosen
    slot_label_Lframe = CenterRectOnPoint(rc, rect(3)*0.2, rect(4)*0.4);
    slot_label_Rframe = CenterRectOnPoint(rc, rect(3)*0.8, rect(4)*0.4);

% ---- coin/coin slot locations
    coinslot_Lpoint = CenterRectOnPoint(r_coinslot, rect(3)*0.2, rect(4)*0.8);
    coinslot_Rpoint = CenterRectOnPoint(r_coinslot, rect(3)*0.8, rect(4)*0.8);
    spent_token_Mpoint = CenterRectOnPoint(r_spenttoken, rect(3)*0.5, rect(4)*0.8);

% ---- next arrow location
    next_arrow_loc = CenterRectOnPoint(r_next_arrow, rect(3)*0.9, rect(4)*0.9);

% ---- room locations
    room_Lpoint = CenterRectOnPoint(room_r, rect(3)*.25, rect(4)*0.3);
    room_Rpoint = CenterRectOnPoint(room_r, 3*rect(3)*.25, rect(4)*0.3);


% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 3 - Load images for practice block
    if block == 0
% --- load basic stimuli
        A1 = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_color_step1(1)) sl ...
          char(initialization_struct.stim_prac_symbol(1)) '.png'],'png');
        B1 = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_color_step1(1)) sl ...
          char(initialization_struct.stim_prac_symbol(2)) '.png'],'png');

        A2 = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.stim_prac_symbol(3)) '.png'],'png');
        B2 = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.stim_prac_symbol(4)) '.png'],'png');

        A3 = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.stim_prac_symbol(5)) '.png'],'png');
        B3 = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.stim_prac_symbol(6)) '.png'],'png');

% ---- load slot machine files
        step1_slot_L = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_color_step1(1)) sl 'Slot Machine_L.png'],'png');
        step1_slot_R = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_color_step1(1)) sl 'Slot Machine_R.png'],'png');

        state2_slot_L = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'Slot Machine_L.png'],'png');
        state2_slot_R = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'Slot Machine_R.png'],'png');

        state3_slot_L = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'Slot Machine_L.png'],'png');
        state3_slot_R = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'Slot Machine_R.png'],'png');

% ---- load coin slot files
        state2_coin_slot = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'coin slot.png'],'png');
        state3_coin_slot = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'coin slot.png'],'png');

% ---- read token files
        state2_token = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
           'token.png'],'png');
        state3_token = imread(['stimuli' sl 'practice' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          'token.png'],'png');
        spent_token = imread(['stimuli' sl 'practice' sl 'spent token.png'],'png');

% ---- read next arrow file
        next_arrow = imread(['stimuli' sl 'main_task' sl 'next arrow.png'],'png');

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 4 - Load and create images for money block
    elseif block == 1
% --- load basic stimuli files
        A1 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(2)) sl ...
          char(initialization_struct.stim_symbol(1)) '.png'],'png');
        B1 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(2)) sl ...
          char(initialization_struct.stim_symbol(2)) '.png'],'png');

        A2 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.stim_symbol(3)) '.png'],'png');
        B2 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.stim_symbol(4)) '.png'],'png');

        A3 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.stim_symbol(5)) '.png'],'png');
        B3 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.stim_symbol(6)) '.png'],'png');

% ---- load slot machine files
        step1_slot_L = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(2)) sl 'Slot Machine_L.png'],'png');
        step1_slot_R = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(2)) sl 'Slot Machine_R.png'],'png');

        state2_slot_L = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'Slot Machine_L.png'],'png');
        state2_slot_R = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'Slot Machine_R.png'],'png');

        state3_slot_L = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'Slot Machine_L.png'],'png');
        state3_slot_R = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'Slot Machine_R.png'],'png');

% ---- load coin slot files
        state2_coin_slot = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'coin slot.png'],'png');
        state3_coin_slot = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'coin slot.png'],'png');

% ---- read token files
        state2_token = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
           'token.png'],'png');
        state3_token = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          'token.png'],'png');
        spent_token = imread(['stimuli' sl 'main_task' sl 'spent token.png'],'png');

% ---- read next arrow file
        next_arrow = imread(['stimuli' sl 'main_task' sl 'next arrow.png'],'png');

% ---- load room stimuli
        token_room = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(2)) sl 'token room.png'],'png');
        prize_room = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(2)) sl 'money prize room.png'],'png');

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 5 - Load and create images for food block
    else
% --- load basic stimuli
        A1 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(3)) sl ...
          char(initialization_struct.stim_symbol(7)) '.png'],'png');
        B1 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(3)) sl ...
          char(initialization_struct.stim_symbol(8)) '.png'],'png');

        A2 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.stim_symbol(9)) '.png'],'png');
        B2 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.stim_symbol(10)) '.png'],'png');

        A3 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.stim_symbol(11)) '.png'],'png');
        B3 = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.stim_symbol(12)) '.png'],'png');

% ---- load slot machine files
        step1_slot_L = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(3)) sl 'Slot Machine_L.png'],'png');
        step1_slot_R = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(3)) sl 'Slot Machine_R.png'],'png');

        state2_slot_L = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'Slot Machine_L.png'],'png');
        state2_slot_R = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'Slot Machine_R.png'],'png');

        state3_slot_L = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'Slot Machine_L.png'],'png');
        state3_slot_R = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'Slot Machine_R.png'],'png');

% ---- load coin slot files
        state2_coin_slot = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'coin slot.png'],'png');
        state3_coin_slot = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'coin slot.png'],'png');

% ---- read token files
        state2_token = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
           'token.png'],'png');
        state3_token = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          'token.png'],'png');
        spent_token = imread(['stimuli' sl 'main_task' sl 'spent token.png'],'png');

% ---- read next arrow file
        next_arrow = imread(['stimuli' sl 'main_task' sl 'next arrow.png'],'png');

% ---- load room stimuli
        token_room = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_color_step1(3)) sl 'token room.png'],'png');
        prize_room = imread(['stimuli' sl 'main_task' sl char(initialization_struct.stim_colors_step2(3)) sl 'food prize room.png'],'png');

    end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 6 - Additional set up
% ---- create image files to draw that are not randomized later on (i.e. the original stimuli)
    % ---- create slot machines
    step1_slot_L = Screen('MakeTexture', w, step1_slot_L);
    state2_slot_L = Screen('MakeTexture', w, state2_slot_L);
    state3_slot_L = Screen('MakeTexture', w, state3_slot_L);

    step1_slot_R = Screen('MakeTexture', w, step1_slot_R);
    state2_slot_R = Screen('MakeTexture', w, state2_slot_R);
    state3_slot_R = Screen('MakeTexture', w, state3_slot_R);

    % ---- create coin slots
    state2_coin_slot = Screen('MakeTexture', w, state2_coin_slot);
    state3_coin_slot = Screen('MakeTexture', w, state3_coin_slot);

    % ---- create tokens
    state2_token = Screen('MakeTexture', w, state2_token);
    state3_token = Screen('MakeTexture', w, state3_token);
    spent_token = Screen('MakeTexture', w, spent_token);

    % ---- create next arrow
    next_arrow = Screen('MakeTexture', w, next_arrow);

    % ---- create rooms
    if block ~= 0
        token_room = Screen('MakeTexture', w, token_room);
        prize_room = Screen('MakeTexture', w, prize_room);
    end
% ---- Keyboard
    KbName('UnifyKeyNames');
    L = KbName('LeftArrow');
    R = KbName('RightArrow');
    exitKeys = KbName('ESCAPE');
    startFirstKeys = KbName({'p', 'y', 'd'});
    spacekey = KbName({'space'});

% ---- Transition variables
    a = 0.4 + 0.6.*rand(trials,2); %transition probabilities
    r = rand(trials, 2); %transition determinant

% ---- Colors
    gray = 203;
    black = 0;
    white = [253 252 250];
    chosen_color = [0 220 0];

    % --- set the frame color to gray if the stimuli are white
    if strcmp(initialization_struct.stim_color_step1(block+1), 'white') == 1
      step1_frame_color = gray;
    else
      step1_frame_color = white;
    end

% ---- formatting for loading bar
    hor_align = rect(3)*0.5;
    ver_align = rect(4)*0.55;
    rate_obj = robotics.Rate(24);

% ---- blank matrices for variables
    action = NaN(trials,3);
    choice_on_time = NaN(trials,3);
    choice_off_time = NaN(trials,3);
    choice_on_datetime = cell(trials,3);
    choice_off_datetime = cell(trials,3);
    position = NaN(trials,3);
    state = NaN(trials,1);
    reward_feedback_on = NaN(trials,1);

    payoff_det = rand(trials,4);
    payoff = NaN(trials,2);

    iti_selected = zeros(trials, 1);
    iti_actual = zeros(trials, 1);

% ---- Waiting screen
    Screen('FillRect', w, black);
    Screen('TextSize', w, textsize_directions);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 7 - Task intro screens
% ---- Intro screen for practice block
    if block == 0
        DrawFormattedText(w,[
            'This is the last part of the tutorial.' '\n' ...
            'You''ll get to play 15 practice rounds.' ....
            ], 'center','center', white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        KbWait([],2);

        DrawFormattedText(w,[
            'After you finish the practice rounds,' '\n' ...
            'you''ll play the strategy game for real rewards!' ....
            ], 'center','center', white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        KbWait([],2);

        DrawFormattedText(w, 'Press p to begin the practice rounds.', 'center', 'center', white);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              exit_flag = 1; Screen('CloseAll'); FlushEvents;
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

% ---- Intro screen for food block
    elseif block == 2 % block == 2 is food
    % ---- Food version
        DrawFormattedText(w, [
            'In this version of the game, you will be playing for food rewards!' ...
            ],'center', 'center', white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- New rooms
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'In the food version of the game, there is' '\n' ...
            'a new TOKEN ROOM, and a FOOD PRIZE ROOM!'
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- New colors and labels
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'The slots are labeled with new colors and new symbols.' ...
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- Reset chances
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'All of your chances of winning have been reset,' '\n' ...
            'but the rules of the game and all of the' '\n' ...
            'programming are exactly the same.'
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- Win = food
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'Each time you win in the FOOD PRIZE' '\n' ...
            'ROOM, you''ll get to take a one bite of' '\n' ...
            'either one of your two snacks!'
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- Eat as much of either as you like
        DrawFormattedText(w, [
            'You can choose either snack as much or as little as you like.' '\n\n'...
            'We have given you enough of each snack to' '\n' ...
            'make sure that you cannot run out.' ...
            ],'center', 'center', white, [], [], [], 1.6);
        Screen(w, 'Flip');
        KbWait([],2);

    % ---- Questions? Begin
        DrawFormattedText(w, [
            'If you have any questions at all about the the food version' '\n' ...
            'of the game, this is a great time to ask the experimenter.' '\n\n' ...
            'Once the experimenter has answered all of your questions,' '\n' ...
            'press d to begin the food version of the game!' ...
            ], 'center', 'center', white, [], [], [], 1.6);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              exit_flag = 1; Screen('CloseAll'); FlushEvents;
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

% ---- Intro screen for money block
    else % block = 1 is money
    % ---- Money version
        DrawFormattedText(w, [
            'In this version of the game, you will be playing for money!' ...
            ],'center', 'center', white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- New rooms
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'In the money version of the game, there is' '\n' ...
            'a new TOKEN ROOM, and a MONEY PRIZE ROOM!'
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- New colors and labels
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'The slots are labeled with new colors and new symbols.' ...
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- Reset chances
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'All of your chances of winning have been reset,' '\n' ...
            'but the rules of the game and all of the' '\n' ...
            'programming are exactly the same.'
            ],'center', rect(4)*0.75, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- Win = food
        Screen('DrawTexture', w, token_room, [], room_Lpoint);
        Screen('DrawTexture', w, prize_room, [], room_Rpoint);
        DrawFormattedText(w, [
            'Each time you win in the MONEY PRIZE ROOM,' '\n' ...
            'you''ll earn 10 cents. Each time you win' '\n' ...
            '10 cents, you''ll take a dime out of one' '\n' ...
            'of the two bowls and place it in your bank.' ...
            ],'center', rect(4)*0.7, white, [], [], [], 1.6);
        Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        WaitSecs(1)
        KbWait([],2);

    % ---- Eat as much of either as you like
        DrawFormattedText(w, [
            'You can choose from either bowl as much or as little' '\n'...
            'as you like. We have given you enough dimes in' '\n' ...
            'each bowl to make sure that you cannot run out.' ...
            ],'center', 'center', white, [], [], [], 1.6);
        Screen(w, 'Flip');
        KbWait([],2);

    % ---- Questions? Begin
        DrawFormattedText(w, [
            'If you have any questions at all about the the money version' '\n' ...
            'of the game, this is a great time to ask the experimenter.' '\n\n' ...
            'Once the experimenter has answered all of your questions,' '\n' ...
            'press y to begin the money version of the game!' ...
            ], 'center', 'center', white, [], [], [], 1.6);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              exit_flag = 1; Screen('CloseAll'); FlushEvents;
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

    end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 8 - Begin trials
    t0 = GetSecs;
    
    if block ~= 0
        Screen('TextSize', w,10);
        DrawFormattedText(w, [
            'subject: ' num2str(initialization_struct.sub) '\n'...
            'block index: ' num2str(find(initialization_struct.block == block)) '\n' ...
            'block type (1 = money, 2 = food): ' num2str(block) ...
            ],rect(3)*0.8, rect(4)*0.8, white, [], [], [], 1.6);
        Screen(w, 'Flip');
        WaitSecs(1/10)
    end


    for trial = 1:trials

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9.1 - Stage 1
% ---- Signal a short break every 50 trials on blocks 1,2

        if block ~= 0
            RestrictKeysForKbCheck([]);
            if trial == (trials/5) + 1 || trial == (2*trials/5) + 1 || trial == (3*trials/5) + 1 || trial == (4*trials/5) + 1
                Screen('FillRect', w, black);
                Screen('TextSize', w, textsize_directions);

                if block == 1
                    DrawFormattedText(w, [
                        'You can take a short break.' '\n\n' ...
                        'Press space to continue' ...
                        ],'center', 'center', white);
                elseif block == 2
                    DrawFormattedText(w, [
                        'You can take a short break.' '\n' ...
                        'This is a good time to take a sip of water.' '\n\n' ...
                        'Press space to continue' ...
                        ],'center', 'center', white, [], [], [], 1.6);
                end

                Screen(w, 'Flip');
                while 1 %wait for response and allow exit if necessesary
                  [keyIsDown, ~, keyCode] = KbCheck;
%                   if keyIsDown && any(keyCode(exitKeys))
%                       exit_flag = 1; Screen('CloseAll'); FlushEvents;
%                       sca; return
                  if keyIsDown && any(keyCode(spacekey))
                      break
                  end
                end

            end
        end

% ---- Fixation screen
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, textsize_fixcross);
        DrawFormattedText(w, '+', 'center', 'center', white);
        Screen(w, 'Flip');
        WaitSecs(0.5)

% ---- Drawimage indicators
        Screen(w, 'FillRect', black);
        position(trial,1) = round(rand); %randomizing images positions
        type = position(trial,1);

% ---- Draw original stimuli using a function that Arkady wrote: drawimage
        picL = drawimage(w, A1, B1, A2, B2, A3, B3,type,1);
        picR = drawimage(w, A1, B1, A2, B2, A3, B3,1-type,1);

% ---- Draw trial screen
        % draw slots
        Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
        Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
        Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,step1_frame_color,slot_label_Lframe,10);
        Screen('FrameRect',w,step1_frame_color,slot_label_Rframe,10);
        Screen('Flip', w);

% ---- start reaction timer
        choice_on_time(trial,1) = GetSecs - t0;
        choice_on_datetime{trial,1} = clock;

% ---- capture key press
        key_is_down = 0;
        FlushEvents;
        [key_is_down, secs, key_code] = KbCheck;

        while key_code(L) == 0 && key_code(R) == 0
                [key_is_down, secs, key_code] = KbCheck;
        end

% ---- stop reaction timer
        choice_off_time(trial,1) = GetSecs - t0;
        choice_off_datetime{trial,1} = clock;

% ---- capture selection
        down_key = find(key_code,1);

        if (down_key==L && type == 0) || (down_key==R && type == 1)
            action(trial,1)=0;
        elseif (down_key==L && type == 1) || (down_key==R && type == 0)
            action(trial,1)=1;
        end

% ---- feedback screen
        if down_key == L
            % draw slots
            Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
            Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
            % draw original stimuli
            Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
            Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
            % draw frames around original stimuli
            Screen('FrameRect',w,chosen_color,slot_label_Lframe,10);
            Screen('FrameRect',w,step1_frame_color,slot_label_Rframe,10);
            Screen('Flip', w);

       elseif down_key == R

           % draw slots
           Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
           Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
           % draw original stimuli
           Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
           Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
           % draw frames around original stimuli
           Screen('FrameRect',w,step1_frame_color,slot_label_Lframe,10);
           Screen('FrameRect',w,chosen_color,slot_label_Rframe,10);
           Screen('Flip', w);

        end


% ---- Determine the state for the second state
    % ---- a ~ U[0.4,1]
    % ---- r ~ U[0,1]
    % ---- p(r < a) = 0.70
    % ---- p(r > a) = 0.30
    % ---- If we discretize the "a" distribution, remember that there is a 1/7
    % ---- chance of "a" taking the any value [0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]

        if action(trial,1) == 0
            if  r(trial, 1) < a(trial,1)
                state(trial,1) = 2;
            else state(trial,1) = 3;
            end
        else
            if  r(trial, 2) > a(trial,2)
                state(trial,1) = 2;
            else state(trial,1) = 3;
            end
        end

% ---- wait 1 second on the feedback screen
        WaitSecs(1)

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9.2A State 2

        if state(trial,1) == 2

% ---- Fixation screen
            Screen(w, 'FillRect', black);
            Screen('TextSize', w, textsize_fixcross);
            DrawFormattedText(w, '+', 'center', 'center', white);
            Screen(w, 'Flip');
            % wait 0.5 second
            WaitSecs(0.5)

% ---- Randomize the left/right position of the original stimuli
            Screen(w, 'FillRect', black);
            position(trial,2) = round(rand);
            type = position(trial,2);

% ---- Draw original stimuli using a function that Arkady wrote: drawimage
            picL = drawimage(w, A1, B1, A2, B2, A3, B3, type,2);
            picR = drawimage(w, A1, B1, A2, B2, A3, B3, 1-type,2);

% ---- Draw trial screen
            % draw slots
            Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
            Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
            % draw original stimuli
            Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
            Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
            % draw frames around original stimuli
            Screen('FrameRect',w,white,slot_label_Lframe,10);
            Screen('FrameRect',w,white,slot_label_Rframe,10);
            % draw token
            Screen('DrawTexture', w, state2_token, [], spent_token_Mpoint);

            Screen('Flip', w);

% ---- start reaction timer
            choice_on_time(trial,2) = GetSecs - t0;
            choice_on_datetime{trial,2} = clock;

% ---- capture key press
            key_is_down = 0;
            FlushEvents;
            RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(-3);
            end

% ---- stop reaction timer
            choice_off_time(trial,2) = GetSecs - t0;
            choice_off_datetime{trial,2} = clock;

% ---- capture selection and determine payoff
            down_key = find(key_code,1);

            if (down_key==L && type == 0) || (down_key==R && type == 1)
                action(trial,2)=0;
                if payoff_det(trial, 1) <  initialization_struct.payoff_prob(trial,1)
                    payoff(trial,1) = 1;
                else payoff(trial,1) = 0;
                end
            elseif (down_key==L && type == 1) || (down_key==R && type == 0)
                action(trial,2)=1;
                if payoff_det(trial, 2) <  initialization_struct.payoff_prob(trial,2)
                    payoff(trial,1) = 1;
                else payoff(trial,1) = 0;
                end
            end

% ---- feedback screen
            if down_key == L
              % draw slots
              Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
              Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
              Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,chosen_color,slot_label_Lframe,10);
              Screen('FrameRect',w,white,slot_label_Rframe,10);
              % draw coinslot and spent token
              Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
              Screen('DrawTexture', w, state2_coin_slot, [], coinslot_Lpoint);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1)

           elseif down_key == R
              % draw slots
              Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
              Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
              Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,white,slot_label_Lframe,10);
              Screen('FrameRect',w,chosen_color,slot_label_Rframe,10);
              % draw coinslot and spent token
              Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
              Screen('DrawTexture', w, state2_coin_slot, [], coinslot_Rpoint);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1)
            end

% ---- payoff screen
    % ---- determine reward based on block
            if block == 0
                reward = 'Win!';
                noreward = 'Lose';
            elseif block == 1
                reward = '+10 cents';
                noreward = 'Lose';
            else
                reward = 'Take one bite of a snack';
                noreward = 'Lose';
            end

    % ---- determine second step choice
            picD = drawimage(w, A1, B1, A2, B2, A3, B3, action(trial,2),2);
            Screen('DrawTexture', w, picD, [], Mpoint);
            if payoff(trial,1) == 1
                DrawFormattedText(w, reward, 'center', rect(4)*0.8, white);
            else
                DrawFormattedText(w, noreward, 'center', rect(4)*0.8, white);
            end

    % ---- show feedback for 1 second and then show countdown
            Screen('Flip', w);
            reward_feedback_on(trial) = GetSecs - t0;
            WaitSecs(1)

            % variable tex that will change on the last trial of the game
            if block == 0
                if trial == trials
                    countdown_text = 'The game will end shortly.';
                else
                    countdown_text = 'The next trial will begin shortly.';
                end
            else
                if trial == trials
                    countdown_text = 'The game will end shortly.';
                elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                    countdown_text = 'A break will begin shortly.';
                else
                    countdown_text = 'The next trial will begin shortly.';
                end
            end

            % countdown to next trial
            for i = 1:initialization_struct.iti_init(trial, payoff(trial,1)+3)
                Screen(w, 'FillRect', black);
                Screen('TextSize', w, textsize_countdown);

                % countdown text
                DrawFormattedText(w, [
                    countdown_text ...
                    ], 'center', 'center', white, [], [], [], 1.6);

                % feedback text
                Screen('TextSize', w, textsize_fixcross);
                if payoff(trial,1) == 1
                    DrawFormattedText(w, reward, 'center', rect(4)*0.8, white);
                else
                    DrawFormattedText(w, noreward, 'center', rect(4)*0.8, white);
                end

                % load bar fill calculation
                fill_width = initialization_struct.iti_init(trial, nansum(payoff(trial,:))+5) * i;

                % fill for the load bar
                Screen('FillRect',w, [255 255 255], ...
                CenterRectOnPoint([0,0,fill_width, initialization_struct.load_bar_dimensions(2)], hor_align - initialization_struct.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

               % outline for the load bar
                Screen('FrameRect',w, [255 255 255], ...
                CenterRectOnPoint([0,0,initialization_struct.load_bar_dimensions(1),initialization_struct.load_bar_dimensions(2)], hor_align, ver_align), 3);

               Screen(w, 'Flip');
               waitfor(rate_obj);
            end

            iti_actual(trial) = GetSecs - t0 - reward_feedback_on(trial);
            iti_selected(trial) = initialization_struct.iti_init(trial, payoff(trial,1)+1);


% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9.2B State 3

        else
% ---- Fixation screen
            Screen(w, 'FillRect', black);
            Screen('TextSize', w, textsize_fixcross);
            DrawFormattedText(w, '+', 'center', 'center', white);
            Screen(w, 'Flip');
            % wait 0.5 second
            WaitSecs(0.5)

% Randomize the left/right position of the original stimuli
            Screen(w, 'FillRect', black);
            position(trial,3) = round(rand);
            type = position(trial,3);

% ---- Draw original stimuli using a function that Arkady wrote: drawimage
            picL = drawimage(w, A1, B1, A2, B2, A3, B3, type,3);
            picR = drawimage(w, A1, B1, A2, B2, A3, B3, 1-type,3);

% ---- Draw trial screen
            % draw slots
            Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
            Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
            % draw original stimuli
            Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
            Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
            % draw frames around original stimuli
            Screen('FrameRect',w,white,slot_label_Lframe,10);
            Screen('FrameRect',w,white,slot_label_Rframe,10);
            % draw token
            Screen('DrawTexture', w, state3_token, [], spent_token_Mpoint);
            Screen('Flip', w);

% ---- start reaction timer
            choice_on_time(trial,3) = GetSecs - t0;
            choice_on_datetime{trial,3} = clock;

% ---- capture key press
            key_is_down = 0;
            FlushEvents;
            RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(-3);
            end

% ---- stop reaction timer
            choice_off_time(trial,3) = GetSecs - t0;
            choice_off_datetime{trial,3} = clock;
            down_key = find(key_code,1);

% ---- capture selection and determine payoff
            if (down_key==L && type == 0) || (down_key==R && type == 1)
                action(trial,3)=0;
                if payoff_det(trial, 3) <  initialization_struct.payoff_prob(trial,3)
                    payoff(trial,2) = 1;
                else payoff(trial,2) = 0;
                end
            elseif (down_key==L && type == 1) || (down_key==R && type == 0)
                action(trial,3)=1;
                if payoff_det(trial, 4) <  initialization_struct.payoff_prob(trial,4)
                    payoff(trial,2) = 1;
                else payoff(trial,2) = 0;
                end
            end

% ---- feedback screen
            if down_key == L
              % draw slots
              Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
              Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
              Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,chosen_color,slot_label_Lframe,10);
              Screen('FrameRect',w,white,slot_label_Rframe,10);
              % draw spent token and coin slot
              Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
              Screen('DrawTexture', w, state3_coin_slot, [], coinslot_Lpoint);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1)

            elseif down_key == R
              % draw slots
              Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
              Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], slot_label_Lpoint);
              Screen('DrawTexture', w, picR, [], slot_label_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,white,slot_label_Lframe,10);
              Screen('FrameRect',w,chosen_color,slot_label_Rframe,10);
              % draw spent token and coin slot
              Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
              Screen('DrawTexture', w, state3_coin_slot, [], coinslot_Rpoint);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1)
            end

% ---- payoff screen
    % ---- determine reward based on block
            if block == 0
               reward = 'Win!';
               noreward = 'Lose';
            elseif block == 1
               reward = '+10 cents';
               noreward = 'Lose';
            else
               reward = 'Take one bite of a snack';
               noreward = 'Lose';
            end

    % ---- determine second step choice
            picD = drawimage(w, A1, B1, A2, B2, A3, B3, action(trial,3),3);
            Screen('DrawTexture', w, picD, [], Mpoint);
            if payoff(trial,2) == 1
                DrawFormattedText(w, reward, 'center', rect(4)*0.8, white);
            else
                DrawFormattedText(w, noreward, 'center', rect(4)*0.8, white);
            end

    % ---- show feedback for 1 second and then show countdown
            Screen('Flip', w);
            reward_feedback_on(trial) = GetSecs - t0;
            WaitSecs(1)

            % variable tex that will change on the last trial of the game
            if block == 0
                if trial == trials
                    countdown_text = 'The game will end shortly.';
                else
                    countdown_text = 'The next trial will begin shortly.';
                end
            else
                if trial == trials
                    countdown_text = 'The game will end shortly.';
                elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                    countdown_text = 'A break will begin shortly.';
                else
                    countdown_text = 'The next trial will begin shortly.';
                end
            end

            % countdown to next trial
            for i = 1:initialization_struct.iti_init(trial, payoff(trial,2)+3)
                Screen(w, 'FillRect', black);
                Screen('TextSize', w, textsize_countdown);

                % countdown text
                DrawFormattedText(w, [
                    countdown_text ...
                    ], 'center', 'center', white, [], [], [], 1.6);

                % feedback text
                Screen('TextSize', w, textsize_fixcross);
                if payoff(trial,2) == 1
                    DrawFormattedText(w, reward, 'center', rect(4)*0.8, white);
                else
                    DrawFormattedText(w, noreward, 'center', rect(4)*0.8, white);
                end

                % load bar fill calculation
                fill_width = initialization_struct.iti_init(trial, nansum(payoff(trial,:))+5) * i;

                % fill for the load bar
                Screen('FillRect',w, [255 255 255], ...
                CenterRectOnPoint([0,0,fill_width, initialization_struct.load_bar_dimensions(2)], hor_align - initialization_struct.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

               % outline for the load bar
                Screen('FrameRect',w, [255 255 255], ...
                CenterRectOnPoint([0,0,initialization_struct.load_bar_dimensions(1),initialization_struct.load_bar_dimensions(2)], hor_align, ver_align), 3);

               Screen(w, 'Flip');
               waitfor(rate_obj);
            end

            iti_actual(trial) = GetSecs - t0 - reward_feedback_on(trial);
            iti_selected(trial) = initialization_struct.iti_init(trial, payoff(trial,2)+1);
        end % close the if/else for state
    end % close the entire for loop
    RestrictKeysForKbCheck([]);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9 - Saving data
    if block == 0 % practice trials
        practice_struct = struct;
        practice_struct.rng_seed = rng_seed; % save the rng seed set at the top of the script
        practice_struct.subject = initialization_struct.sub;
        practice_struct.stim_color_step1 = initialization_struct.stim_color_step1(block+1); % stimuli are always selected where 1st item in array goes to practice, then money, then food
        practice_struct.stim_colors_step2 = initialization_struct.stim_colors_step2(block+1);
        practice_struct.position = position;
        practice_struct.action = action;
        practice_struct.on = choice_on_time;
        practice_struct.off = choice_off_time;

        practice_struct.on_datetime = choice_on_datetime;
        practice_struct.off_datetime = choice_off_datetime;

        practice_struct.rt = choice_off_time-choice_on_time;
        practice_struct.reward_feedback_on = reward_feedback_on;
        practice_struct.iti_actual = iti_actual;
        practice_struct.iti_selected = iti_selected;
        practice_struct.transition_prob = a;
        practice_struct.transition_det = r;
        practice_struct.payoff_det = payoff_det;
        practice_struct.payoff = payoff;
        practice_struct.state = state;

% ---- unique to this block
        practice_struct.block = find(initialization_struct.block == 0);
        practice_struct.stim_symbol = initialization_struct.stim_prac_symbol;
        practice_struct.tutorial_timing_names = tutorial_timing_struct.names; % these are the times pulled during the tutorial
        practice_struct.tutorial_timing_times = tutorial_timing_struct.times; % these are the names of the timed chunks of the tutorial
        delete([initialization_struct.data_file_path sl 'tutorial_timing.mat']);
        save([initialization_struct.data_file_path sl 'practice'], 'practice_struct', '-v6');

    elseif block == 1 % money block
        money_struct = struct;
        money_struct.rng_seed = rng_seed; % save the rng seed set at the top of the script
        money_struct.subject = initialization_struct.sub;
        money_struct.stim_color_step1 = initialization_struct.stim_color_step1(block+1); % stimuli are always selected where 1st item in array goes to practice, then money, then food
        money_struct.stim_colors_step2 = initialization_struct.stim_colors_step2(block+1);
        money_struct.position = position;
        money_struct.action = action;
        money_struct.on = choice_on_time;
        money_struct.off = choice_off_time;

        money_struct.on_datetime = choice_on_datetime;
        money_struct.off_datetime = choice_off_datetime;

        money_struct.rt = choice_off_time-choice_on_time;
        money_struct.reward_feedback_on = reward_feedback_on;
        money_struct.iti_actual = iti_actual;
        money_struct.iti_selected = iti_selected;
        money_struct.transition_prob = a;
        money_struct.transition_det = r;
        money_struct.payoff_det = payoff_det;
        money_struct.payoff = payoff;
        money_struct.state = state;

% ---- unique to this block
        money_struct.block = find(initialization_struct.block == 1);
        money_struct.stim_symbol = initialization_struct.stim_symbol(1:6); % first 6 symbols always go to money block
        money_struct.payoff_sum = sum(nansum(payoff))/10;
        money_struct.payoff_total = 10 + ceil(money_struct.payoff_sum);
        save([initialization_struct.data_file_path sl 'money'], 'money_struct', '-v6');

    else % food block
        food_struct = struct;
        food_struct.rng_seed = rng_seed; % save the rng seed set at the top of the script
        food_struct.subject = initialization_struct.sub;
        food_struct.stim_color_step1 = initialization_struct.stim_color_step1(block+1); % stimuli are always selected where 1st item in array goes to practice, then money, then food
        food_struct.stim_colors_step2 = initialization_struct.stim_colors_step2(block+1);
        food_struct.position = position;
        food_struct.action = action;
        food_struct.on = choice_on_time;
        food_struct.off = choice_off_time;

        food_struct.on_datetime = choice_on_datetime;
        food_struct.off_datetime = choice_off_datetime;

        food_struct.rt = choice_off_time-choice_on_time;
        food_struct.reward_feedback_on = reward_feedback_on;
        food_struct.iti_actual = iti_actual;
        food_struct.iti_selected = iti_selected;

        food_struct.transition_prob = a;
        food_struct.transition_det = r;
        food_struct.payoff_det = payoff_det;
        food_struct.payoff = payoff;
        food_struct.state = state;

% ---- unique to this block
        food_struct.block = find(initialization_struct.block == 2);
        food_struct.stim_symbol = initialization_struct.stim_symbol(7:12); % second 6 symbols in the arrary always go to food block
        save([initialization_struct.data_file_path sl 'food'], 'food_struct', '-v6');

    end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9 - Payoff screens
% ---- Practice block end screens
    if block == 0 % practice
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, textsize_directions);
        DrawFormattedText(w,[
            'You have completed the practice rounds!' '\n' ...
            'Please alert the experimenter, and' '\n' ...
            'press ESCAPE to close to practice game.'
            ],'center','center', white, [], [], [], 1.6);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              break
          end
        end

% ---- Money block end screen
    elseif block == 1 % money block
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, textsize_directions);
        DrawFormattedText(w, [
            'You have completed the money rounds.' '\n\n' ...
            'You earned: $' sprintf('%.2f', money_struct.payoff_sum) '\n\n' ...
            'Please alert the experimenter, and' '\n' ...
            'press ESCAPE to close to game.'
            ], 'center', 'center', white);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              break
          end
        end

% ---- Food block end screen
    elseif block == 2 % food block
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, textsize_directions);
        DrawFormattedText(w,[
            'You have completed the food rounds!' '\n' ...
            'Please alert the experimenter, and' '\n' ...
            'press ESCAPE to close to the game.'
            ],'center','center', white, [], [], [], 1.6);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              break
          end
        end

    end

    ShowCursor;
    Screen('CloseAll');
    FlushEvents;

end
