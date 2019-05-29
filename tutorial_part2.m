% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function exit_flag = tutorial_v4(init)
% ---- Initial set up
% capture screenshots
img_idx = 300;

% sets the exit flag default to 0; throws a flag if you exit the function to leave the start function
exit_flag = 0;

% file set up; enables flexibility between OSX and Windows
sl = init.slash_convention;

% ---- psychtoolbox set up
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
FlushEvents;
HideCursor;
PsychDefaultSetup(1);

% ---- Screen selection
screens = Screen('Screens'); %count the screen
whichScreen = max(screens); %select the screen; ALTERED THIS BECAUSE IT KEPT SHOWING UP ON MY LAPTOP INSTEAD OF THE ATTACHED MONITOR
if init.test == 0
    [w, rect] = Screen('OpenWindow', whichScreen);
else
    % [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1440 810]); % for opening into a small rectangle instead
    [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1920 1080]); % for opening into a small rectangle instead
end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 2 - Define image locations and stimuli used across blocks

% ---- display coordinates setup
r = [0,0,800,600]; %stimuli rectangle
r_small = [0,0,600,400]; % smaller rect for stimuli and rewards
rc_small = [0,0,600,425];
r_space = [0,0,1920,1080];
r_ship = [0,0,400,290];
r_tick_text = [0,0,300,150];
r_txt_bg = [0,0,1550,75];
rects = cell(2,2); % rectangles for touchscreen

% ---- tutorial locations
left_above_text = CenterRectOnPoint(r_small, rect(3)*0.25, rect(4)*0.4);
right_above_text = CenterRectOnPoint(r_small, rect(3)*0.75, rect(4)*0.4);
center_above_text = CenterRectOnPoint(r_small, rect(3)*0.5, rect(4)*0.4);
txt_bg = CenterRectOnPoint(r_txt_bg, rect(3)*0.5, rect(4)*0.9);

% ---- backgrounds
space_bg = CenterRectOnPoint(r_space, rect(3)*0.5, rect(4)*0.5);
spaceship_out = CenterRectOnPoint(r_ship, rect(3)*0.38, rect(4)*0.4);
spaceship_return = CenterRectOnPoint(r_ship, rect(3)*0.2, rect(4)*0.4);

% ---- locations on the win screen
alien_win = CenterRectOnPoint(r_small, rect(3)*.3, rect(4)*0.5);
treasure_win = CenterRectOnPoint(r_small, rect(3)*.7, rect(4)*0.5);
alien_lose = CenterRectOnPoint(r_small, rect(3)*.5, rect(4)*0.5);

% ---- locations on the trade screen
treasure_trade = CenterRectOnPoint(r_small, rect(3)*.25, rect(4)*0.55);
reward_top_point = CenterRectOnPoint(r_small, rect(3)*.75, rect(4)*0.25);
reward_bot_point = CenterRectOnPoint(r_small, rect(3)*.75, rect(4)*0.75);
reward_text = CenterRectOnPoint([0,0,200,75], rect(3)*.25, rect(4)*0.35);
tick_text_top = CenterRectOnPoint(r_tick_text, rect(3)*.75, rect(4)*0.25);
tick_text_bot = CenterRectOnPoint(r_tick_text, rect(3)*.75, rect(4)*0.75);

% ---- frames during the trade screen
reward_top_frame = CenterRectOnPoint(rc_small, rect(3)*0.75, rect(4)*0.25);
reward_bot_frame = CenterRectOnPoint(rc_small, rect(3)*0.75, rect(4)*0.75);

% ---- define touchscreen rectangles to click (top/bottom)
rects{2,1} = [rect(3)*0.75 - rc_small(3)/2, rect(4)*0.25 - rc_small(4)/2, rect(3)*0.75 + rc_small(3)/2, rect(4)*0.25 + rc_small(4)/2];
rects{2,2} = [rect(3)*0.75 - rc_small(3)/2, rect(4)*0.75 - rc_small(4)/2, rect(3)*0.75 + rc_small(3)/2, rect(4)*0.75 + rc_small(4)/2];

% ---- location of the aliens
alien_Lpoint = CenterRectOnPoint(r, rect(3)*0.25, rect(4)*0.5);
alien_Rpoint = CenterRectOnPoint(r, rect(3)*0.75, rect(4)*0.5);

% ---- frames - white during every trial; green when chosen
alien_Lframe = CenterRectOnPoint(r, rect(3)*0.25, rect(4)*0.5);
alien_Rframe = CenterRectOnPoint(r, rect(3)*0.75, rect(4)*0.5);

% ---- define touchscreen rectangles to click (left/right)
rects{1,1} = [rect(3)*0.25 - r(3)/2, rect(4)*0.5 - r(4)/2, rect(3)*0.25 + r(3)/2, rect(4)*0.5 + r(4)/2];
rects{1,2} = [rect(3)*0.75 - r(3)/2, rect(4)*0.5 - r(4)/2, rect(3)*0.75 + r(3)/2, rect(4)*0.5 + r(4)/2];

% ---- read/draw the treasure
treasure = imread(['stimuli' sl 'treasure.png'],'png');
treasure_spent = imread(['stimuli' sl 'treasure_spent.png'],'png');
earth = imread(['stimuli' sl 'earth.png'],'png');
return_home = imread(['stimuli' sl 'return_home.png'],'png');

treasure = Screen('MakeTexture', w, treasure);
treasure_spent = Screen('MakeTexture', w, treasure_spent);
earth = Screen('MakeTexture', w, earth);
return_home = Screen('MakeTexture', w, return_home);

% ---- these are drawn later because their location is randomized
if strcmp(init.condition, 'food')
    im_reward = imread(['stimuli' sl 'snacks.png'],'png');
    im_reward_txt = 'snacks';
    condition = 1;
else
    im_reward = imread(['stimuli' sl 'stickers.png'],'png');
    im_reward_txt = 'stickers and tattoos';
    condition = 0;
end

tickets = imread(['stimuli' sl 'tickets.png'],'png');

im_reward_drawn = Screen('MakeTexture', w, im_reward);
tickets_drawn = Screen('MakeTexture', w, tickets);


% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% --- spaceships
A1 = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(1)) sl 'docked.png'],'png');
B1 = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(2)) sl 'docked.png'],'png');

A1_out = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(1)) sl 'out.png'],'png');
A1_return = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(1)) sl 'return.png'],'png');

B1_out = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(2)) sl 'out.png'],'png');
B1_return = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(2)) sl 'return.png'],'png');

% ---- aliens
A2 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(1)) sl ...
  char(init.aliens(1)) '.png'],'png');
B2 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(1)) sl ...
  char(init.aliens(2)) '.png'],'png');

A3 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(2)) sl ...
  char(init.aliens(3)) '.png'],'png');
B3 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(2)) sl ...
  char(init.aliens(4)) '.png'],'png');

% read and draw background stimuli
space = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl 'space.png'],'png');
planet_home = imread(['stimuli' sl 'home_planet.png'],'png');
planet_2 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(1)) sl 'planet.png'],'png');
planet_3 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(2)) sl 'planet.png'],'png');

space = Screen('MakeTexture', w, space);
planet_home = Screen('MakeTexture', w, planet_home);
planet_2 = Screen('MakeTexture', w, planet_2);
planet_3 = Screen('MakeTexture', w, planet_3);
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 6 - Additional set up
% ---- Keyboard
KbName('UnifyKeyNames');
L = KbName('LeftArrow');
R = KbName('RightArrow');
U = KbName('UpArrow');
D = KbName('DownArrow');

% ---- Colors
black = 0;
white = [253 252 250];
chosen_color = [0 220 0];
frame_color = white;

% ---- formatting for loading bar
hor_align = rect(3)*0.5;
ver_align = rect(4)*0.55;
rate_obj = robotics.Rate(24);

% --- keep track of actions
action = NaN(3,4);

% ---- Waiting screen
Screen('FillRect', w, black);
Screen('Textsize', w, init.textsize);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 1 - Intro
DrawFormattedText(w,[
    'Now that you are an experienced Space Captain,' '\n' ...
    'it is time to go on your big quest for space treasure.' ...
    ], 'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'Each time you find space treasure during your big quest,' '\n' ...
    'you will be able to trade it with ' init.researcher ' for prizes!' ...
    ], 'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, im_reward_drawn, [], left_above_text);
Screen('DrawTexture', w, tickets_drawn, [], right_above_text);
Screen('TextSize', w, init.textsize_tickets);
DrawFormattedText(w, '10', 'center', 'center', white, [],[],[],[],[], right_above_text);
Screen('Textsize', w, init.textsize);
DrawFormattedText(w,[
    'You can trade you space treasure for ' im_reward_txt ' or for tickets.' ...
    ], 'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

if condition == 1
    Screen('DrawTexture', w, im_reward_drawn, [], center_above_text);
    DrawFormattedText(w,[
        'If you choose the snacks, you will get to take one bite of' '\n' ...
        'either the ' init.food_sweet ' or the ' init.food_salt '.' ...
        ], 'center',rect(4)*0.75, white, [], [], [], 1.6);
else
  Screen('DrawTexture', w, im_reward_drawn, [], center_above_text);
  DrawFormattedText(w,[
      'If you choose the stickers and tattoos, you will get to pick one.'...
      ], 'center',rect(4)*0.75, white, [], [], [], 1.6);
end
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, tickets_drawn, [], center_above_text);
Screen('TextSize', w, init.textsize_tickets);
DrawFormattedText(w, '10', 'center', 'center', white, [],[],[],[],[], center_above_text);
Screen('Textsize', w, init.textsize);
DrawFormattedText(w,[
    'If you choose the tickets, you will get the number of tickets it says.' '\n' ...
    'Right now, that is 10 tickets!' ...
    ], 'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, tickets_drawn, [], center_above_text);
Screen('TextSize', w, init.textsize_tickets);
DrawFormattedText(w, '10', 'center', 'center', white, [],[],[],[],[], center_above_text);
Screen('Textsize', w, init.textsize);
DrawFormattedText(w,[
    'At the end of the game, you will be able to use all your tickets to buy a prize.' ...
    ], 'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'Let''s practice exploring for space treasure three more times.' '\n' ...
    'This time, we will trade your space treasure for prizes!' ...
    ], 'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Trade practice
trials = 3;
type = 0;
state = [2 2; 2 2; 3 3];
payoff = [1 1; 0 0; 1 1];
tick = [5 10 12];

for trial = 1:trials
  % ---- Draw original stimuli using a function that Arkady wrote: drawimage
  picL = task_func.drawimage(w, A1, B1, A2, B2, A3, B3,type,1);
  picR = task_func.drawimage(w, A1, B1, A2, B2, A3, B3,1-type,1);

  % ---- Draw trial screen
  % draw background
  Screen('DrawTexture', w, planet_home, [], space_bg);
  % draw original stimuli
  Screen('DrawTexture', w, picL, [], alien_Lpoint);
  Screen('DrawTexture', w, picR, [], alien_Rpoint);
  % draw frames around original stimuli
  Screen('FrameRect',w,frame_color,alien_Lframe,10);
  Screen('FrameRect',w,frame_color,alien_Rframe,10);
  Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

  % ---- capture key press
  [selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);
  % ---- capture selection
  [action(trial,1), choice_loc] = task_func.choice(type, [L,R], selection, x, y);

  % ---- feedback screen
  if choice_loc == L
      % draw background
      Screen('DrawTexture', w, planet_home, [], space_bg);
      % draw original stimuli
      Screen('DrawTexture', w, picL, [], alien_Lpoint);
      Screen('DrawTexture', w, picR, [], alien_Rpoint);
      % draw frames around original stimuli
      Screen('FrameRect',w,chosen_color,alien_Lframe,10);
      Screen('FrameRect',w,frame_color,alien_Rframe,10);
      Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

  elseif choice_loc == R
     % draw background
     Screen('DrawTexture', w, planet_home, [], space_bg);
     % draw original stimuli
     Screen('DrawTexture', w, picL, [], alien_Lpoint);
     Screen('DrawTexture', w, picR, [], alien_Rpoint);
     % draw frames around original stimuli
     Screen('FrameRect',w,frame_color,alien_Lframe,10);
     Screen('FrameRect',w,chosen_color,alien_Rframe,10);
     Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

  end

  % ---- wait 1 second on the feedback screen
  WaitSecs(1);

  % ---- space exploration page
  Screen('DrawTexture', w, space, [], space_bg);
  ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'out');
  Screen('DrawTexture', w, ship, [], spaceship_out);
  Screen('Flip', w);
  WaitSecs(1); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9.2A State 2

  if state(trial,1) == 2

  % ---- Randomize the left/right position of the original stimuli
      Screen(w, 'FillRect', black);

  % ---- Draw original stimuli using a function that Arkady wrote: drawimage
      picL = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, type,2);
      picR = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, 1-type,2);

  % ---- Draw trial screen
      % draw background
      Screen('DrawTexture', w, planet_2, [], space_bg);
      % draw original stimuli
      Screen('DrawTexture', w, picL, [], alien_Lpoint);
      Screen('DrawTexture', w, picR, [], alien_Rpoint);
      % draw frames around original stimuli
      Screen('FrameRect',w,white,alien_Lframe,10);
      Screen('FrameRect',w,white,alien_Rframe,10);

      Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

  % ---- capture key press
      [selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);

  % ---- capture selection and determine payoff
      [action(trial,2), choice_loc] = task_func.choice(type, [L,R], selection, x, y);

  % ---- feedback screen
      if choice_loc == L
        % draw background
        Screen('DrawTexture', w, planet_2, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,chosen_color,alien_Lframe,10);
        Screen('FrameRect',w,white,alien_Rframe,10);
        Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
        % wait 1 second
        WaitSecs(1);

     elseif choice_loc == R
        % draw background
        Screen('DrawTexture', w, planet_2, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,white,alien_Lframe,10);
        Screen('FrameRect',w,chosen_color,alien_Rframe,10);
        Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
        % wait 1 second
        WaitSecs(1);
      end

      % ---- payoff screen
      % ---- show feedback
      picD = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, action(trial,2),2);
      Screen('TextSize', w, init.textsize_feedback);
      if payoff(trial,1) == 1
          Screen('DrawTexture', w, picD, [], alien_win);
          Screen('DrawTexture', w, treasure, [], treasure_win);
          DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
      else
          Screen('DrawTexture', w, picD, [], alien_lose);
          DrawFormattedText(w, 'Lose', 'center', rect(4)*0.8, white);
      end
      Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
      WaitSecs(1);

    % ---- reward trade screen
      % ---- Draw reward stimuli; this randomizes their location
      reward_top = task_func.drawrewards(w, condition, im_reward, im_reward, tickets, type);
      reward_bot = task_func.drawrewards(w, condition, im_reward, im_reward, tickets, 1 - type);

      if payoff(trial, 1) == 1
      % ---- Draw trial screen
            % draw treasure to trade
            Screen('TextSize', w, init.textsize_feedback);
            Screen('DrawTexture', w, treasure, [], treasure_trade);
            DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
            % draw rewards
            Screen('DrawTexture', w, reward_top, [], reward_top_point);
            Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
            % draw frames around rewards
            Screen('FrameRect',w,frame_color,reward_top_frame,10);
            Screen('FrameRect',w,frame_color,reward_bot_frame,10);
            % draw number of tickets
            Screen('TextSize', w, init.textsize_tickets);
            if type == 0
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
            else
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
            end
            Screen('Textsize', w, init.textsize);
            Screen('FillRect', w, black, txt_bg);
            if condition == 1
                DrawFormattedText(w,[
                    'Look! You can trade your space treasure for snacks or ' num2str(tick(trial)) ' tickets.' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            else
                DrawFormattedText(w,[
                    'Look! You can trade your space treasure for stickers and tattoos or ' num2str(tick(trial)) ' tickets.' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            end
            Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
            task_func.advance_screen(init.input_source);

            % draw treasure to trade
            Screen('TextSize', w, init.textsize_feedback);
            Screen('DrawTexture', w, treasure, [], treasure_trade);
            DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
            % draw rewards
            Screen('DrawTexture', w, reward_top, [], reward_top_point);
            Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
            % draw frames around rewards
            Screen('FrameRect',w,frame_color,reward_top_frame,10);
            Screen('FrameRect',w,frame_color,reward_bot_frame,10);
            % draw number of tickets
            Screen('TextSize', w, init.textsize_tickets);
            if type == 0
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
            else
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
            end
            Screen('Textsize', w, init.textsize);
            Screen('FillRect', w, black, txt_bg);
            if condition == 1
                DrawFormattedText(w,[
                    'Let''s trade your space treasure for a bite of the snacks.' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            else
                DrawFormattedText(w,[
                    'Let''s trade your space treasure for a sticker or tattoo.' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            end
            Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

      % ---- capture key press
            [selection, x, y] = task_func.selection(init.input_source, [U], w, rects);
      % ---- capture selection
            [action(trial,4), choice_loc] = task_func.choice(type, [U], selection, x, y);

      % ---- feedback screen
            if choice_loc == U
                % draw treasure to trade
                Screen('TextSize', w, init.textsize_feedback);
                Screen('DrawTexture', w, treasure_spent, [], treasure_trade);
                DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
                % draw original stimuli
                Screen('DrawTexture', w, reward_top, [], reward_top_point);
                Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
                % draw frames around original stimuli
                Screen('FrameRect',w,chosen_color,reward_top_frame,10);
                Screen('FrameRect',w,frame_color,reward_bot_frame,10);
                % draw number of tickets
                Screen('TextSize', w, init.textsize_tickets);
                if type == 0
                    DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
                else
                    DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
                end
                Screen('Flip', w);
                % wait 1 second
                WaitSecs(1); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

           elseif choice_loc == D
               % draw treasure to trade
               Screen('TextSize', w, init.textsize_feedback);
               Screen('DrawTexture', w, treasure_spent, [], treasure_trade);
               DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
               % draw original stimuli
               Screen('DrawTexture', w, reward_top, [], reward_top_point);
               Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
               % draw frames around original stimuli
               Screen('FrameRect',w,frame_color,reward_top_frame,10);
               Screen('FrameRect',w,chosen_color,reward_bot_frame,10);
               % draw number of tickets
               Screen('TextSize', w, init.textsize_tickets);
               if type == 0
                   DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
               else
                   DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
               end
               Screen('Flip', w);
               % wait 1 second
               WaitSecs(1); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
            end

            Screen('DrawTexture', w, return_home, [], space_bg);
            ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'return');
            Screen('DrawTexture', w, ship, [], spaceship_return);
            Screen('FillRect', w, black, txt_bg);
            Screen('Textsize', w, init.textsize);
            if condition == 1
                DrawFormattedText(w,[
                    'Make sure to eat your snack before your spaceship returns home!' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            else
                DrawFormattedText(w,[
                    'Make sure to collect your sticker or tattoo before your spaceship returns home!' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            end

            Screen('Flip', w);
            WaitSecs(3); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
      else
          if type == 0
              earth_loc = reward_top_point;
              earth_frame = reward_top_frame;
              RestrictKeysForKbCheck([U]);
          else
              earth_loc = reward_bot_point;
              earth_frame = reward_bot_frame;
              RestrictKeysForKbCheck([D]);
          end

          % ---- Draw trial screen
          % draw original stimuli
          Screen('TextSize', w, init.textsize_feedback);
          DrawFormattedText(w, 'Select Earth to return home', rect(3)*0.125, 'center', white);
          Screen('DrawTexture', w, earth, [], earth_loc);
          % draw frames around original stimuli
          Screen('FrameRect',w,frame_color,earth_frame,10);
          Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

          % ---- capture key press
          [selection, x, y] = task_func.selection(init.input_source, [U,D], w, rects);

          % ---- capture selection
          [action(trial,4), choice_loc] = task_func.choice(type, [U,D], selection, x, y);

          % ---- feedback screen
          if choice_loc == U
              % draw original stimuli
              DrawFormattedText(w, 'Select Earth to return home', rect(3)*0.125, 'center', white);
              Screen('DrawTexture', w, earth, [], earth_loc);
              % draw frames around original stimuli
              Screen('FrameRect',w,chosen_color,earth_frame,10);
              Screen('Flip', w);
              % wait 1 second
              WaitSecs(1); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

         elseif choice_loc == D
             % draw original stimuli
             DrawFormattedText(w, 'Select Earth to return home', rect(3)*0.125, 'center', white);
             Screen('DrawTexture', w, earth, [], earth_loc);
             % draw frames around original stimuli
             Screen('FrameRect',w,chosen_color,earth_frame,10);
             Screen('Flip', w);
             % wait 1 second
             WaitSecs(1); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
         end
     end

      % variable text that will change on the last trial of the game
      Screen('Textsize', w, init.textsize);
      countdown_text = task_func.rewards_text(init.condition, 0, trial, trials, payoff(trial,1), action(trial,4), tick(trial));
      % countdown to next trial
      for i = 1:init.iti_init(trial, payoff(trial,1)+3)
          % ---- space exploration page
          Screen('DrawTexture', w, return_home, [], space_bg);
          ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'return');
          Screen('DrawTexture', w, ship, [], spaceship_return);

          % countdown text
          DrawFormattedText(w, [
              countdown_text ...
              ], 'center', 'center', white, [], [], [], 1.6);

          % load bar fill calculation
          fill_width = init.iti_init(trial, nansum(payoff(trial, 1))+5) * i;

          % fill for the load bar
          Screen('FillRect',w, [255 255 255], ...
          CenterRectOnPoint([0,0,fill_width, init.load_bar_dimensions(2)], hor_align - init.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

         % outline for the load bar
          Screen('FrameRect',w, [255 255 255], ...
          CenterRectOnPoint([0,0,init.load_bar_dimensions(1),init.load_bar_dimensions(2)], hor_align, ver_align), 3);

         Screen(w, 'Flip');
         if i == 15
             img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
         end
         waitfor(rate_obj);
      end

  % -----------------------------------------------------------------------------
  % -----------------------------------------------------------------------------
  % -----------------------------------------------------------------------------
  % -----------------------------------------------------------------------------
  % 9.2B State 3
  else

  % Randomize the left/right position of the original stimuli
      Screen(w, 'FillRect', black);

  % ---- Draw original stimuli using a function that Arkady wrote: drawimage
      picL = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, type,3);
      picR = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, 1-type,3);

  % ---- Draw trial screen
      % draw background
      Screen('DrawTexture', w, planet_3, [], space_bg);
      % draw original stimuli
      Screen('DrawTexture', w, picL, [], alien_Lpoint);
      Screen('DrawTexture', w, picR, [], alien_Rpoint);
      % draw frames around original stimuli
      Screen('FrameRect',w,white,alien_Lframe,10);
      Screen('FrameRect',w,white,alien_Rframe,10);

      Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

  % ---- capture key press
      [selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);

  % ---- capture selection and determine payoff
      [action(trial,3), choice_loc] = task_func.choice(type, [L,R], selection, x, y);

  % ---- feedback screen
      if choice_loc == L
        % draw background
        Screen('DrawTexture', w, planet_3, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,chosen_color,alien_Lframe,10);
        Screen('FrameRect',w,white,alien_Rframe,10);
        Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
        % wait 1 second
        WaitSecs(1);

      elseif choice_loc == R
        % draw background
        Screen('DrawTexture', w, planet_3, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,white,alien_Lframe,10);
        Screen('FrameRect',w,chosen_color,alien_Rframe,10);
        Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
        % wait 1 second
        WaitSecs(1);
      end

  % ---- payoff screen
  % ---- determine second step choice
      picD = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, action(trial,3),3);
      Screen('TextSize', w, init.textsize_feedback);
      if payoff(trial,2) == 1
          Screen('DrawTexture', w, picD, [], alien_win);
          Screen('DrawTexture', w, treasure, [], treasure_win);
          DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
      else
          Screen('DrawTexture', w, picD, [], alien_lose);
          DrawFormattedText(w, 'Lose', 'center', rect(4)*0.8, white);
      end
      Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
      WaitSecs(1);

      % ---- reward trade screen
      % ---- Draw reward stimuli; this randomizes their location
      reward_top = task_func.drawrewards(w, condition, im_reward, im_reward, tickets, type);
      reward_bot = task_func.drawrewards(w, condition, im_reward, im_reward, tickets, 1 - type);

      if payoff(trial, 2) == 1
      % ---- Draw trial screen
            % draw treasure to trade
            Screen('TextSize', w, init.textsize_feedback);
            Screen('DrawTexture', w, treasure, [], treasure_trade);
            DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
            % draw rewards
            Screen('DrawTexture', w, reward_top, [], reward_top_point);
            Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
            % draw frames around rewards
            Screen('FrameRect',w,frame_color,reward_top_frame,10);
            Screen('FrameRect',w,frame_color,reward_bot_frame,10);
            % draw number of tickets
            Screen('TextSize', w, init.textsize_tickets);
            if type == 0
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
            else
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
            end
            Screen('Textsize', w, init.textsize);
            Screen('FillRect', w, black, txt_bg);
            if condition == 1
                DrawFormattedText(w,[
                    'Look! You can trade your space treasure for snacks or ' num2str(tick(trial)) ' tickets.' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            else
                DrawFormattedText(w,[
                    'Look! You can trade your space treasure for stickers and tattoos or ' num2str(tick(trial)) ' tickets.' ...
                    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            end
            Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
            task_func.advance_screen(init.input_source);


            % draw treasure to trade
            Screen('TextSize', w, init.textsize_feedback);
            Screen('DrawTexture', w, treasure, [], treasure_trade);
            DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
            % draw original stimuli
            Screen('DrawTexture', w, reward_top, [], reward_top_point);
            Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
            % draw frames around original stimuli
            Screen('FrameRect',w,frame_color,reward_top_frame,10);
            Screen('FrameRect',w,frame_color,reward_bot_frame,10);
            % draw number of tickets
            Screen('TextSize', w, init.textsize_tickets);
            if type == 0
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
            else
                DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
            end

            Screen('Textsize', w, init.textsize);
            Screen('FillRect', w, black, txt_bg);
            DrawFormattedText(w,[
                'Now let''s trade your space treasure for tickets.' ...
                ],'center','center', white, [], [], [], 1.6, [], txt_bg);
            Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

      % ---- capture key press
            [selection, x, y] = task_func.selection(init.input_source, [D], w, rects);
      % ---- capture selection
            [action(trial,4), choice_loc] = task_func.choice(type, [D], selection, x, y);

      % ---- feedback screen
            if choice_loc == U
                % draw treasure to trade
                Screen('TextSize', w, init.textsize_feedback);
                Screen('DrawTexture', w, treasure_spent, [], treasure_trade);
                DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
                % draw original stimuli
                Screen('DrawTexture', w, reward_top, [], reward_top_point);
                Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
                % draw frames around original stimuli
                Screen('FrameRect',w,chosen_color,reward_top_frame,10);
                Screen('FrameRect',w,frame_color,reward_bot_frame,10);
                % draw number of tickets
                Screen('TextSize', w, init.textsize_tickets);
                if type == 0
                    DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
                else
                    DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
                end
                Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
                % wait 1 second
                WaitSecs(1);

           elseif choice_loc == D
               % draw treasure to trade
               Screen('TextSize', w, init.textsize_feedback);
               Screen('DrawTexture', w, treasure_spent, [], treasure_trade);
               DrawFormattedText(w, 'Trade your space treasure', 'center', 'center', white, [],[],[],[],[],reward_text);
               % draw original stimuli
               Screen('DrawTexture', w, reward_top, [], reward_top_point);
               Screen('DrawTexture', w, reward_bot, [], reward_bot_point);
               % draw frames around original stimuli
               Screen('FrameRect',w,frame_color,reward_top_frame,10);
               Screen('FrameRect',w,chosen_color,reward_bot_frame,10);
               % draw number of tickets
               Screen('TextSize', w, init.textsize_tickets);
               if type == 0
                   DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_bot);
               else
                   DrawFormattedText(w, num2str(tick(trial)), 'center', 'center', white, [],[],[],[],[],tick_text_top);
               end
               Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
               % wait 1 second
               WaitSecs(1);
            end
      else
          if type == 0
              earth_loc = reward_top_point;
              earth_frame = reward_top_frame;
              RestrictKeysForKbCheck([U]);
          else
              earth_loc = reward_bot_point;
              earth_frame = reward_bot_frame;
              RestrictKeysForKbCheck([D]);
          end

          % ---- Draw trial screen
          % draw original stimuli
          DrawFormattedText(w, 'Select Earth to return home', rect(3)*0.125, 'center', white);
          Screen('DrawTexture', w, earth, [], earth_loc);
          % draw frames around original stimuli
          Screen('FrameRect',w,frame_color,earth_frame,10);
          Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

          % ---- capture key press
          [selection, x, y] = task_func.selection(init.input_source, [U,D], w, rects);
          % ---- capture selection
          [action(trial,4), choice_loc] = task_func.choice(type, [U,D], selection, x, y);

          % ---- feedback screen
          if choice_loc == U
              % draw original stimuli
              DrawFormattedText(w, 'Select Earth to return home', rect(3)*0.125, 'center', white);
              Screen('DrawTexture', w, earth, [], earth_loc);
              % draw frames around original stimuli
              Screen('FrameRect',w,chosen_color,earth_frame,10);
              Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
              % wait 1 second
              WaitSecs(1);

         elseif choice_loc == D
             % draw original stimuli
             DrawFormattedText(w, 'Select Earth to return home', rect(3)*0.125, 'center', white);
             Screen('DrawTexture', w, earth, [], earth_loc);
             % draw frames around original stimuli
             Screen('FrameRect',w,chosen_color,earth_frame,10);
             Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
             % wait 1 second
             WaitSecs(1);
         end
     end

      % variable text that will change based on their reward choice and trial
      Screen('Textsize', w, init.textsize);
      countdown_text = task_func.rewards_text(init.condition, 0, trial, trials, payoff(trial,2), 1, tick(trial));
      % countdown to next trial
      for i = 1:init.iti_init(trial, payoff(trial,2)+3)
          % ---- space exploration page
          Screen('DrawTexture', w, return_home, [], space_bg);
          ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'return');
          Screen('DrawTexture', w, ship, [], spaceship_return);

          % countdown text
          DrawFormattedText(w, [
              countdown_text ...
              ], 'center', 'center', white, [], [], [], 1.6);

          % load bar fill calculation
          fill_width = init.iti_init(trial, nansum(payoff(trial,1))+5) * i;

          % fill for the load bar
          Screen('FillRect',w, [255 255 255], ...
          CenterRectOnPoint([0,0,fill_width, init.load_bar_dimensions(2)], hor_align - init.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

         % outline for the load bar
          Screen('FrameRect',w, [255 255 255], ...
          CenterRectOnPoint([0,0,init.load_bar_dimensions(1),init.load_bar_dimensions(2)], hor_align, ver_align), 3);

         Screen(w, 'Flip');
         if i == 15
             img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
         end
         waitfor(rate_obj);
      end
  end % close the if/else for state
end % close the entire for loop

Screen('Textsize', w, init.textsize);
Screen(w, 'FillRect', black);
DrawFormattedText(w,[
    'Good job - you are ready to start the big quest!' ...
    ],'center','center', white, [], [], [], 1.6);
Screen(w, 'Flip');
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('Textsize', w, init.textsize);
Screen(w, 'FillRect', black);
DrawFormattedText(w,[
    'When you are ready, ' init.researcher ' will load the big quest.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen(w, 'Flip');
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

ShowCursor;
Screen('CloseAll');
FlushEvents;

end
