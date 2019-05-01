% The code that this is based on was initially written for Konovalov (2016) Nature Communications.
% The original code was shared with me and I have maintained some of the basic structure
% and notation; however, I have substantially altered the code for my own purposes.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function exit_flag = main_task(initialization_struct, trials, block)

% 1 - Initial setup
    format shortg
    exit_flag = 0;

    % ---- file set up; enables flexibility between OSX and Windows
    sl = initialization_struct.slash_convention;

    % ---- test or not?
    test = initialization_struct.test;
    input_source = initialization_struct.input_source;

    % ---- shuffle the rng and save the seed
    rng('shuffle');
    rng_seed = rng;
    rng_seed = rng_seed.Seed;

    % ---- Screen setup
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
    FlushEvents;
    if test == 0
        HideCursor;
    end
    PsychDefaultSetup(1);

    % ---- Screen selection
    screens = Screen('Screens'); %count the screen
    whichScreen = max(screens); %select the screen; ALTERED THIS BECAUSE IT KEPT SHOWING UP ON MY LAPTOP INSTEAD OF THE ATTACHED MONITOR
    if test == 0
        [w, rect] = Screen('OpenWindow', whichScreen);
    else
        % [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1440 810]); % for opening into a small rectangle instead
        [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1920 1080]); % for opening into a small rectangle instead
    end

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
    r = [0,0,800,600]; %stimuli rectangle
    r_small = [0,0,400,290]
    rc = [0,0,750,620]; %choice rectangle
    r_next_arrow = [0,0,150,108.75]; % next arrow rectangle

% ---- location of the alien when alone
    Mpoint = CenterRectOnPoint(r_small, rect(3)*.5, rect(4)*0.5);

% ---- location of the aliens
    alien_Lpoint = CenterRectOnPoint(r, rect(3)*0.25, rect(4)*0.5);
    alien_Rpoint = CenterRectOnPoint(r, rect(3)*0.75, rect(4)*0.5);

% ---- frames - white during every trial; green when chosen
    alien_Lframe = CenterRectOnPoint(rc, rect(3)*0.25, rect(4)*0.5);
    alien_Rframe = CenterRectOnPoint(rc, rect(3)*0.75, rect(4)*0.5);

% ---- next arrow location
    next_arrow_loc = CenterRectOnPoint(r_next_arrow, rect(3)*0.9, rect(4)*0.9);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 3 - Load images for practice block
    if block == 0
% --- load basic stimuli
        A1 = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
          char(initialization_struct.spaceships(1)) '.png'],'png');
        B1 = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
          char(initialization_struct.spaceships(2)) '.png'],'png');

        A2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.aliens(1)) '.png'],'png');
        B2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.aliens(2)) '.png'],'png');

        A3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.aliens(3)) '.png'],'png');
        B3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.aliens(4)) '.png'],'png');

% ---- read next arrow file
        next_arrow = imread(['stimuli' sl 'main_task' sl 'next arrow.png'],'png');

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 4 - Load and create images for money block
    else
% --- load basic stimuli files
        A1 = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
          char(initialization_struct.spaceships(3)) '.png'],'png');
        B1 = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
          char(initialization_struct.spaceships(4)) '.png'],'png');

        A2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.aliens(5)) '.png'],'png');
        B2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
          char(initialization_struct.aliens(6)) '.png'],'png');

        A3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.aliens(7)) '.png'],'png');
        B3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
          char(initialization_struct.aliens(8)) '.png'],'png');

% ---- read next arrow file
        next_arrow = imread(['stimuli' sl 'main_task' sl 'next arrow.png'],'png');

    end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 6 - Additional set up
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
        % Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        KbWait(input_source, 2);

        DrawFormattedText(w,[
            'After you finish the practice rounds,' '\n' ...
            'you''ll play the strategy game for real rewards!' ....
            ], 'center','center', white, [], [], [], 1.6);
        % Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
        Screen('Flip',w);
        KbWait(input_source, 2);

        DrawFormattedText(w, 'Press p to begin the practice rounds.', 'center', 'center', white);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck(input_source);
          if keyIsDown && any(keyCode(exitKeys))
              exit_flag = 1; Screen('CloseAll'); FlushEvents;
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

% ---- Intro screen for food block
    else
    % % ---- Food version
    %     DrawFormattedText(w, [
    %         'In this version of the game, you will be playing for food rewards!' ...
    %         ],'center', 'center', white, [], [], [], 1.6);
    %     Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
    %     Screen('Flip',w);
    %     WaitSecs(1)
    %     KbWait(input_source, 2);
    %
    % % ---- New rooms
    %     Screen('DrawTexture', w, token_room, [], room_Lpoint);
    %     Screen('DrawTexture', w, prize_room, [], room_Rpoint);
    %     DrawFormattedText(w, [
    %         'In the food version of the game, there is' '\n' ...
    %         'a new TOKEN ROOM, and a FOOD PRIZE ROOM!'
    %         ],'center', rect(4)*0.75, white, [], [], [], 1.6);
    %     Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
    %     Screen('Flip',w);
    %     WaitSecs(1)
    %     KbWait(input_source, 2);
    %
    % % ---- New colors and labels
    %     Screen('DrawTexture', w, token_room, [], room_Lpoint);
    %     Screen('DrawTexture', w, prize_room, [], room_Rpoint);
    %     DrawFormattedText(w, [
    %         'The slots are labeled with new colors and new symbols.' ...
    %         ],'center', rect(4)*0.75, white, [], [], [], 1.6);
    %     Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
    %     Screen('Flip',w);
    %     WaitSecs(1)
    %     KbWait(input_source, 2);
    %
    % % ---- Reset chances
    %     Screen('DrawTexture', w, token_room, [], room_Lpoint);
    %     Screen('DrawTexture', w, prize_room, [], room_Rpoint);
    %     DrawFormattedText(w, [
    %         'All of your chances of winning have been reset,' '\n' ...
    %         'but the rules of the game and all of the' '\n' ...
    %         'programming are exactly the same.'
    %         ],'center', rect(4)*0.75, white, [], [], [], 1.6);
    %     Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
    %     Screen('Flip',w);
    %     WaitSecs(1)
    %     KbWait(input_source, 2);
    %
    % % ---- Win = food
    %     Screen('DrawTexture', w, token_room, [], room_Lpoint);
    %     Screen('DrawTexture', w, prize_room, [], room_Rpoint);
    %     DrawFormattedText(w, [
    %         'Each time you win in the FOOD PRIZE' '\n' ...
    %         'ROOM, you''ll get to take a one bite of' '\n' ...
    %         'either one of your two snacks!'
    %         ],'center', rect(4)*0.75, white, [], [], [], 1.6);
    %     Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
    %     Screen('Flip',w);
    %     WaitSecs(1)
    %     KbWait(input_source, 2);
    %
    % % ---- Eat as much of either as you like
    %     DrawFormattedText(w, [
    %         'You can choose either snack as much or as little as you like.' '\n\n'...
    %         'We have given you enough of each snack to' '\n' ...
    %         'make sure that you cannot run out.' ...
    %         ],'center', 'center', white, [], [], [], 1.6);
    %     Screen(w, 'Flip');
    %     KbWait(input_source, 2);

    % ---- Questions? Begin
        DrawFormattedText(w, [
            'If you have any questions at all about the the food version' '\n' ...
            'of the game, this is a great time to ask the experimenter.' '\n\n' ...
            'Once the experimenter has answered all of your questions,' '\n' ...
            'press d to begin the food version of the game!' ...
            ], 'center', 'center', white, [], [], [], 1.6);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck(input_source);
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
                  [keyIsDown, ~, keyCode] = KbCheck(input_source);
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
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,step1_frame_color,alien_Lframe,10);
        Screen('FrameRect',w,step1_frame_color,alien_Rframe,10);
        Screen('Flip', w);

% ---- start reaction timer
        choice_on_time(trial,1) = GetSecs - t0;
        choice_on_datetime{trial,1} = clock;

% ---- capture key press
        key_is_down = 0;
        FlushEvents;
        [key_is_down, secs, key_code] = KbCheck(input_source);

        while key_code(L) == 0 && key_code(R) == 0
                [key_is_down, secs, key_code] = KbCheck(input_source);
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
            % draw original stimuli
            Screen('DrawTexture', w, picL, [], alien_Lpoint);
            Screen('DrawTexture', w, picR, [], alien_Rpoint);
            % draw frames around original stimuli
            Screen('FrameRect',w,chosen_color,alien_Lframe,10);
            Screen('FrameRect',w,step1_frame_color,alien_Rframe,10);
            Screen('Flip', w);

       elseif down_key == R

           % draw original stimuli
           Screen('DrawTexture', w, picL, [], alien_Lpoint);
           Screen('DrawTexture', w, picR, [], alien_Rpoint);
           % draw frames around original stimuli
           Screen('FrameRect',w,step1_frame_color,alien_Lframe,10);
           Screen('FrameRect',w,chosen_color,alien_Rframe,10);
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
            % draw original stimuli
            Screen('DrawTexture', w, picL, [], alien_Lpoint);
            Screen('DrawTexture', w, picR, [], alien_Rpoint);
            % draw frames around original stimuli
            Screen('FrameRect',w,white,alien_Lframe,10);
            Screen('FrameRect',w,white,alien_Rframe,10);

            Screen('Flip', w);

% ---- start reaction timer
            choice_on_time(trial,2) = GetSecs - t0;
            choice_on_datetime{trial,2} = clock;

% ---- capture key press
            key_is_down = 0;
            FlushEvents;
            RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(input_source);
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
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], alien_Lpoint);
              Screen('DrawTexture', w, picR, [], alien_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,chosen_color,alien_Lframe,10);
              Screen('FrameRect',w,white,alien_Rframe,10);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1)

           elseif down_key == R
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], alien_Lpoint);
              Screen('DrawTexture', w, picR, [], alien_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,white,alien_Lframe,10);
              Screen('FrameRect',w,chosen_color,alien_Rframe,10);
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
            % draw original stimuli
            Screen('DrawTexture', w, picL, [], alien_Lpoint);
            Screen('DrawTexture', w, picR, [], alien_Rpoint);
            % draw frames around original stimuli
            Screen('FrameRect',w,white,alien_Lframe,10);
            Screen('FrameRect',w,white,alien_Rframe,10);

            Screen('Flip', w);

% ---- start reaction timer
            choice_on_time(trial,3) = GetSecs - t0;
            choice_on_datetime{trial,3} = clock;

% ---- capture key press
            key_is_down = 0;
            FlushEvents;
            RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(input_source);
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
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], alien_Lpoint);
              Screen('DrawTexture', w, picR, [], alien_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,chosen_color,alien_Lframe,10);
              Screen('FrameRect',w,white,alien_Rframe,10);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1)

            elseif down_key == R
              % draw original stimuli
              Screen('DrawTexture', w, picL, [], alien_Lpoint);
              Screen('DrawTexture', w, picR, [], alien_Rpoint);
              % draw frames around original stimuli
              Screen('FrameRect',w,white,alien_Lframe,10);
              Screen('FrameRect',w,chosen_color,alien_Rframe,10);
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
        practice_struct.spaceships = initialization_struct.spaceships(1:2);
        practice_struct.aliens = initialization_struct.aliens(1:4);
        save([initialization_struct.data_file_path sl 'practice'], 'practice_struct', '-v6');

    elseif block == 1 % main task block
        task_struct = struct;
        task_struct.rng_seed = rng_seed; % save the rng seed set at the top of the script
        task_struct.subject = initialization_struct.sub;
        task_struct.stim_color_step1 = initialization_struct.stim_color_step1(block+1); % stimuli are always selected where 1st item in array goes to practice, then money, then food
        task_struct.stim_colors_step2 = initialization_struct.stim_colors_step2(block+1);
        task_struct.position = position;
        task_struct.action = action;
        task_struct.on = choice_on_time;
        task_struct.off = choice_off_time;

        task_struct.on_datetime = choice_on_datetime;
        task_struct.off_datetime = choice_off_datetime;

        task_struct.rt = choice_off_time-choice_on_time;
        task_struct.reward_feedback_on = reward_feedback_on;
        task_struct.iti_actual = iti_actual;
        task_struct.iti_selected = iti_selected;
        task_struct.transition_prob = a;
        task_struct.transition_det = r;
        task_struct.payoff_det = payoff_det;
        task_struct.payoff = payoff;
        task_struct.state = state;

% ---- unique to this block
        task_struct.block = find(initialization_struct.block == 1);
        practice_struct.spaceships = initialization_struct.spaceships(3:4);
        practice_struct.aliens = initialization_struct.aliens(5:8);
        task_struct.payoff_sum = sum(nansum(payoff))/10;
        task_struct.payoff_total = 10 + ceil(task_struct.payoff_sum);
        save([initialization_struct.data_file_path sl 'money'], 'task_struct', '-v6');
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
          [keyIsDown, ~, keyCode] = KbCheck(input_source);
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
            'You earned: $' sprintf('%.2f', task_struct.payoff_sum) '\n\n' ...
            'Please alert the experimenter, and' '\n' ...
            'press ESCAPE to close to game.'
            ], 'center', 'center', white);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck(input_source);
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
          [keyIsDown, ~, keyCode] = KbCheck(input_source);
          if keyIsDown && any(keyCode(exitKeys))
              break
          end
        end

    end

    ShowCursor;
    Screen('CloseAll');
    FlushEvents;

end
