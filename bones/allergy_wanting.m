% This code was initially written by Nikki Sullivan (Duke University) and was
% generously shared upon request. I have superficially altered the code for the
% purposes of my study.

% Please do not share or use this code without the written permission of all authors.
% Authors: Nikki Sullivan, Alex Breslav

function [exit_flag, eligible, food_salt, food_sweet] = allergy_wanting(initialization_struct)

% psychtoolbox setup
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
FlushEvents;
HideCursor;
PsychDefaultSetup(1);

% sets the exit flag default to 0; throws a flag if you exit the function to leave the start function
exit_flag = 0;

% file set up; enables flexibility between OSX and Windows
sl = initialization_struct.slash_convention;
results_file_name = [initialization_struct.data_file_path sl 'allergy_wanting'];

% open window
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
[exp_screen, ~] = Screen('OpenWindow', max(Screen('Screens')));
%[exp_screen, ~] = Screen('OpenWindow', max(Screen('Screens')), [], [0 0 1200 800]); % for opening into a small rectangle instead
[allergy_wanting.width, allergy_wanting.height] = Screen('WindowSize',exp_screen);
allergy_wanting.screenRefreshRate = Screen('GetFlipInterval', exp_screen);

Screen('TextFont',exp_screen,'Arial');

% style settings
wrapat = 53;
vSpacing = 3;
bg_color = BlackIndex(exp_screen);
txt_color = WhiteIndex(exp_screen);
chosen_color= [0 220 0];
textsize_directions = initialization_struct.textsize_directions;
textsize_rateguide = initialization_struct.textsize_allergy_wanting_rateGuide;

% response key set up
KbName('UnifyKeyNames');
exitKeys = KbName({'ESCAPE'});
rightKey = KbName('rightarrow');
leftKey = KbName('leftarrow');
spaceKey = KbName('space');

%ratings: set up task
% retrieve image names from directory
tmp = dir(['food_images' sl '*.png']);
allergy_wanting.image_names = {tmp(1:length(tmp)).name}';

allergy_wanting.nTrials = length(allergy_wanting.image_names);

% randomize order of foods and order of ratings
allergy_wanting.rand_img_order_allergic = randperm(length(allergy_wanting.image_names))'; % food presentation order; the first item is the global question

% timing
allergy_wanting.feedbackSecs = .2; % feedback duration

% ITI
tmp = repmat([.2 .3 .4 .5], 1, ceil(allergy_wanting.nTrials/4))';
tmp = tmp(1:allergy_wanting.nTrials);
allergy_wanting.reset_screen = sortrows([rand(allergy_wanting.nTrials,1), tmp]);
allergy_wanting.reset_screen = allergy_wanting.reset_screen(:,2);

% location of text keyboard guide:
allergy_wanting.guideLocs = linspace(.15,.96,6) * allergy_wanting.width;
allergy_wanting.yesno_guideLocs = {allergy_wanting.guideLocs(2), allergy_wanting.guideLocs(4)};

% response key guides
allergy_wanting.resp_keys = {'c' 'v' 'b' 'n' 'm'};
allergy_wanting.yesno_resp_keys = {'c', 'm'};
allergy_wanting.resp_key_codes = KbName(allergy_wanting.resp_keys);
allergy_wanting.yesno_resp_key_codes = KbName(allergy_wanting.yesno_resp_keys);
allergy_wanting.keyguide = 'cvbnm'; % set key labels
allergy_wanting.yesno_keyguide = {'Press c', 'Press m'};
allergy_wanting.guide = {'I really do no want to eat it right now', 'I do not want to eat it right now', 'I do not know', 'I want to eat it right now', 'I really want to eat it right now'};
allergy_wanting.yesno_guide = {'Yes', 'No'};
allergy_wanting.yesno_allergic_guide = {'      Yes\nI am allergic.', '         No\nI am not allergic.'};
allergy_wanting.guideTwo = {'I really do not\nwant to eat\nit right now', 'I do not want to\neat it right now', 'I do not know', 'I want to eat\nit right now', 'I really want to\neat it right now'};
allergy_wanting.want_numeric_guide = repmat(-2:2,1,1);
allergy_wanting.yesnovalence_guide = ([1,0]);


% randomly set the left-right scale direction on a participant-by-participant basis
allergy_wanting.scaleFlip = randi(2)-1; % 1=flip it, 0=don't
% flip scale if necessary
if allergy_wanting.scaleFlip
    allergy_wanting.guide = fliplr(allergy_wanting.guide);
    allergy_wanting.guideTwo = fliplr(allergy_wanting.guideTwo);
    allergy_wanting.want_numeric_guide = fliplr(allergy_wanting.want_numeric_guide);
end

% preallocate
allergy_wanting.allergic_keypress = cell(allergy_wanting.nTrials + 1,1); % individual questions about food allergies; key pressed
allergy_wanting.allergic_text = cell(allergy_wanting.nTrials + 1,1); % text associated with each key
allergy_wanting.allergic_numeric = NaN(allergy_wanting.nTrials + 1,1); % 1 allergic, 0 not allergic
allergy_wanting.allergic_RT = NaN(allergy_wanting.nTrials + 1, 1); % RT
allergy_wanting.allergic_stimOn = NaN(allergy_wanting.nTrials + 1, 1); % time stamp
allergy_wanting.allergic_feedbackOn = NaN(allergy_wanting.nTrials + 1, 1); % time stamp

allergy_wanting.want_keypress = cell(allergy_wanting.nTrials, 1); % letter pressed
allergy_wanting.want_text = cell(allergy_wanting.nTrials, 1); % text of response
allergy_wanting.want_numeric = NaN(allergy_wanting.nTrials, 1); % number of response
allergy_wanting.want_RT = NaN(allergy_wanting.nTrials, 1); % RT
allergy_wanting.want_stimOn = NaN(allergy_wanting.nTrials, 1); % time stamp
allergy_wanting.want_feedbackOn = NaN(allergy_wanting.nTrials, 1); % time stamp

keyguide_loc_low = allergy_wanting.height*.88;
guide_loc_low = allergy_wanting.height*.75;

yesno_allergic_guide_offset = -35;
yesno_guide_offset = 25;
want_guide_offset = -60; %start to the left

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ---- intro
tic;
t0 = GetSecs;
Screen('TextSize', exp_screen, textsize_directions);
Screen(exp_screen, 'FillRect', bg_color);
DrawFormattedText(exp_screen,[
    'The purpose of this section is to ensure that you can complete the' '\n'...
    'Strategy Game for Food and Money study.' '\n\n' ...
    'We will ask you a few questions about ten foods.' '\n\n' ...
    'Press any key to continue.' ...
    ], 'center', 'center' ,txt_color,[],[],[],1.6);
Screen('Flip', exp_screen);
KbWait([], 2) % normal
% KbWait(6, 2) % for bluetooth keyboard

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ---- global food allergy question

DrawFormattedText(exp_screen,[
    'During the study, we will ask you to eat certain foods.' '\n\n' ...
    'Do you have any known food allergies?' ...
    ], 'center', 'center',txt_color,[],[],[],1.6);

% -------- show response options
Screen('TextSize', exp_screen, textsize_directions);
for n = 1:2
    DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
        allergy_wanting.yesno_guideLocs{n},keyguide_loc_low,txt_color,wrapat,[],[],vSpacing);
    DrawFormattedText(exp_screen,char(allergy_wanting.yesno_guide(n)),...
        allergy_wanting.yesno_guideLocs{n} + yesno_guide_offset,guide_loc_low,txt_color,wrapat,[],[],1.6);
end

Screen('Flip', exp_screen);
allergy_wanting.allergic_stimOn(1) = GetSecs - t0;

WaitSecs(.2) %force .2 sesconds on the screen so people wont hold down the key; this means that RT's cannot be < 0.2


% -------- listen for response
while 1
    [keyIsDown, ~, keyCode] = KbCheck; % normal
    % [keyIsDown, ~, keyCode] = KbCheck(6); % bluetooth keyboard
    if keyIsDown && any(keyCode(allergy_wanting.yesno_resp_key_codes)) && length(KbName(keyCode)) == 1

        allergy_wanting.allergic_RT(1) = GetSecs - t0;
        allergy_wanting.allergic_RT(1) = allergy_wanting.allergic_RT(1) - allergy_wanting.allergic_stimOn(1);

        allergy_wanting.allergic_keypress{1} = KbName(keyCode); % letter code

        allergy_wanting.allergic_text{1} = allergy_wanting.yesno_guide{allergy_wanting.allergic_keypress{1} ...
            == cell2mat(allergy_wanting.yesno_resp_keys)}; % string

        allergy_wanting.allergic_numeric(1) = allergy_wanting.yesnovalence_guide(allergy_wanting.allergic_keypress{1} ...
            ==cell2mat(allergy_wanting.yesno_resp_keys)); % number code

        break
    elseif keyIsDown && any(keyCode(exitKeys)) && length(KbName(keyCode)) == 1
        exit_flag = 1; Screen('CloseAll'); FlushEvents;
        sca; return;
    end
end
save(results_file_name,'allergy_wanting');

% ------- show their response
% -------- show the image:
Screen(exp_screen, 'FillRect', bg_color);
DrawFormattedText(exp_screen,[
    'During the study, we will ask you to eat certain foods.' '\n\n' ...
    'Do you have any known food allergies?' ...
    ], 'center', 'center',txt_color,[],[],[],1.6);

% -------- show ratings scale
Screen('TextSize', exp_screen, textsize_directions);
for n = 1:2
    if strcmp(allergy_wanting.allergic_text{1}, char(allergy_wanting.yesno_guide{n}))
        DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
            allergy_wanting.yesno_guideLocs{n},keyguide_loc_low,chosen_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(allergy_wanting.yesno_guide(n)),...
            allergy_wanting.yesno_guideLocs{n} + yesno_guide_offset,guide_loc_low,chosen_color,wrapat,[],[],1.6);
    else
        DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
            allergy_wanting.yesno_guideLocs{n},keyguide_loc_low,txt_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(allergy_wanting.yesno_guide(n)),...
            allergy_wanting.yesno_guideLocs{n} + yesno_guide_offset,guide_loc_low,txt_color,wrapat,[],[],1.6);
    end
end
Screen('Flip', exp_screen);
allergy_wanting.allergic_feedbackOn(1) = GetSecs - t0;
WaitSecs(allergy_wanting.feedbackSecs);

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ---- individual food allergy ratings
if allergy_wanting.allergic_numeric(1) == 0
    allergy_wanting.allergic_keypress(2:allergy_wanting.nTrials + 1, 1) = {'m'};
    allergy_wanting.allergic_text(2:allergy_wanting.nTrials + 1, 1) = {'No'};
    allergy_wanting.allergic_numeric(2:allergy_wanting.nTrials + 1, 1) = 0;
    allergy_wanting.allergic_RT(2:allergy_wanting.nTrials + 1, 1) = 0;
    allergy_wanting.allergic_stimOn(2:allergy_wanting.nTrials + 1, 1) = 0;
    allergy_wanting.allergic_feedbackOn(2:allergy_wanting.nTrials + 1, 1) = 0;
else
% -------- intro allergy questions
    Screen('TextSize', exp_screen, textsize_directions);
    Screen(exp_screen, 'FillRect', bg_color);
    DrawFormattedText(exp_screen,['Please indicate if you are allergic ' '\n' ...
        'to any of the following foods, using the keys and the scale below.'],...
        'center',allergy_wanting.height*.2,txt_color,[],[],[],1.6);

    Screen('TextSize', exp_screen, textsize_directions);
    for n = 1:2
        DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
            allergy_wanting.yesno_guideLocs{n},allergy_wanting.height*.65,txt_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(allergy_wanting.yesno_allergic_guide(n)),...
            allergy_wanting.yesno_guideLocs{n} + yesno_allergic_guide_offset,allergy_wanting.height*.52,txt_color,wrapat,[],[],1.6);
    end

    Screen('TextSize', exp_screen, textsize_directions);
    DrawFormattedText(exp_screen,'Press the spacebar to begin!',...
        'center', allergy_wanting.height*.8, txt_color, wrapat, [], [], vSpacing);
    Screen(exp_screen, 'Flip');
    WaitSecs(.2);
    % wait for spacebar to begin
    while 1
        [keyIsDown, ~, keyCode] = KbCheck; % normal
        % [keyIsDown, ~, keyCode] = KbCheck(6); % bluetooth keyboard
        if keyIsDown && keyCode(spaceKey)
            break
        elseif any(keyCode(exitKeys))
            exit_flag = 1; Screen('CloseAll'); FlushEvents;
            sca; return
        end
    end

    for trial = allergy_wanting.rand_img_order_allergic' % run trials in the pre-determined randomized order

% -------- display stimuli/get the food stimuli
        imgfile = imread(['food_images' sl allergy_wanting.image_names{trial}]);
        img = Screen(exp_screen, 'MakeTexture', imgfile);
        % show the image
        Screen(exp_screen, 'FillRect', bg_color);
        Screen('DrawTexture', exp_screen, img, [], ...
            [allergy_wanting.width*.5-200 allergy_wanting.height*.5-300 ...
            allergy_wanting.width*.5+200 allergy_wanting.height*.5+100]);

% -------- show response options
        Screen('TextSize', exp_screen, textsize_directions);
        for n = 1:2
            DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
                allergy_wanting.yesno_guideLocs{n},keyguide_loc_low,txt_color,wrapat,[],[],vSpacing);
            DrawFormattedText(exp_screen,char(allergy_wanting.yesno_allergic_guide(n)),...
                allergy_wanting.yesno_guideLocs{n} + yesno_allergic_guide_offset,guide_loc_low,txt_color,wrapat,[],[],1.6);
        end

        Screen('Flip', exp_screen);
        allergy_wanting.allergic_stimOn(trial+1) = GetSecs - t0;
        WaitSecs(.2) %force .2 sesconds on the screen so people wont hold down the key; this means that RT's cannot be < 0.2


% -------- listen for response
        while 1
            [keyIsDown, ~, keyCode] = KbCheck; % normal
            % [keyIsDown, ~, keyCode] = KbCheck(6); % bluetooth keyboard
            if keyIsDown && any(keyCode(allergy_wanting.yesno_resp_key_codes)) && length(KbName(keyCode)) == 1

                allergy_wanting.allergic_RT(trial+1) = GetSecs - t0;
                allergy_wanting.allergic_RT(trial+1) = allergy_wanting.allergic_RT(trial+1) - allergy_wanting.allergic_stimOn(trial+1);

                allergy_wanting.allergic_keypress{trial+1} = KbName(keyCode); % letter code

                allergy_wanting.allergic_text{trial+1} = allergy_wanting.yesno_guide{allergy_wanting.allergic_keypress{trial+1} ...
                    ==cell2mat(allergy_wanting.yesno_resp_keys)}; % string

                allergy_wanting.allergic_numeric(trial+1) = allergy_wanting.yesnovalence_guide(allergy_wanting.allergic_keypress{trial+1} ...
                    ==cell2mat(allergy_wanting.yesno_resp_keys)); % number code

                break
            elseif keyIsDown && any(keyCode(exitKeys)) && length(KbName(keyCode)) == 1
                exit_flag = 1; Screen('CloseAll'); FlushEvents;
                sca; return;
            end
        end
        save(results_file_name,'allergy_wanting');

% ------- show their response
% -------- show the image:
        Screen(exp_screen, 'FillRect', bg_color);

    % -------- show ratings scale
        Screen('TextSize', exp_screen, textsize_directions);
        for n = 1:2
            if strcmp(allergy_wanting.allergic_text{trial+1}, char(allergy_wanting.yesno_guide{n}))
                DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
                    allergy_wanting.yesno_guideLocs{n},keyguide_loc_low,chosen_color,wrapat,[],[],vSpacing);
                DrawFormattedText(exp_screen,char(allergy_wanting.yesno_allergic_guide(n)),...
                    allergy_wanting.yesno_guideLocs{n} + yesno_allergic_guide_offset,guide_loc_low,chosen_color,wrapat,[],[],1.6);
            else
                DrawFormattedText(exp_screen,allergy_wanting.yesno_keyguide{n},...
                    allergy_wanting.yesno_guideLocs{n},keyguide_loc_low,txt_color,wrapat,[],[],vSpacing);
                DrawFormattedText(exp_screen,char(allergy_wanting.yesno_allergic_guide(n)),...
                    allergy_wanting.yesno_guideLocs{n} + yesno_allergic_guide_offset,guide_loc_low,txt_color,wrapat,[],[],1.6);
            end
        end
        Screen('Flip', exp_screen);
        allergy_wanting.allergic_feedbackOn(trial+1) = GetSecs - t0;
        Screen('Close', img);
        WaitSecs(allergy_wanting.feedbackSecs);
    end
end

not_allergic = reshape(logical(~allergy_wanting.allergic_numeric(2:11)), [10,1]);
allergy_wanting.foods_not_allergic = allergy_wanting.image_names(not_allergic);
allergy_wanting.rand_img_order_want = randperm(length(allergy_wanting.foods_not_allergic))';


% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ---- wanting ratings

if isempty(allergy_wanting.foods_not_allergic) > 0 % end if they are allergic to every food!
    allergy_wanting.eligible = 0;
    eligible = 0;
    food_salt = {};
    food_sweet = {};

    Screen(exp_screen, 'FillRect', bg_color);
    DrawFormattedText(exp_screen,[
        'Based on your responses in this section, you may' '\n' ...
        'not be eligible to continue with the study.' '\n' ...
        'Please tell the experimenter that you''ve encountered an issue.' ...
        ], 'center', 'center',txt_color,[],[],[],1.6);
    Screen('Flip', exp_screen)
    KbWait([], 2) % normal
    % KbWait(6, 2) % for bluetooth keyboard

    disp(['not allergic: ' allergy_wanting.foods_not_allergic' ' ||| want sweet: ' allergy_wanting.sweet_food_want' ' ||| want salt: ' allergy_wanting.salt_food_want'])

    allergy_wanting.taskDur(2) = toc;
    save(results_file_name,'allergy_wanting');

    Screen('CloseAll');
    FlushEvents;
    sca; return;

else % otherwise, carry on as expected
    % --- show ratings instructions & key guide
    Screen('TextSize', exp_screen, textsize_directions);
    Screen(exp_screen, 'FillRect', bg_color);
    DrawFormattedText(exp_screen,['Please rate the following foods ' '\n' ...
        'based on how much you want to eat them right now, using the keys and the scale below.'],...
        'center',allergy_wanting.height*.2,txt_color,wrapat,[],[],1.6);

    Screen('TextSize', exp_screen, textsize_rateguide);
    for n = 1:length(allergy_wanting.keyguide)
        DrawFormattedText(exp_screen,allergy_wanting.keyguide(n),...
            allergy_wanting.guideLocs(n),allergy_wanting.height*.5,txt_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(allergy_wanting.guideTwo(n)),allergy_wanting.guideLocs(n) + want_guide_offset,allergy_wanting.height*.58,txt_color,wrapat,[],[],1.6);
    end

    Screen('TextSize', exp_screen, textsize_directions);
    DrawFormattedText(exp_screen,'Press the spacebar to begin!',...
        'center', allergy_wanting.height*.8, txt_color, wrapat, [], [], vSpacing);
    Screen(exp_screen, 'Flip');
    WaitSecs(.2);
    % wait for spacebar to begin
    while 1
        [keyIsDown, ~, keyCode] = KbCheck; % normal
        % [keyIsDown, ~, keyCode] = KbCheck(6); % bluetooth keyboard
        if keyIsDown && keyCode(spaceKey)
            break
        elseif any(keyCode(exitKeys))
            exit_flag = 1; Screen('CloseAll'); FlushEvents;
            sca; return
        end
    end
    %%

    for trial = allergy_wanting.rand_img_order_want' % run trials in the pre-determined randomized order

        % display stimuli
        % get the food image
        imgfile = imread(['food_images' sl allergy_wanting.foods_not_allergic{trial}]);
        img = Screen(exp_screen, 'MakeTexture', imgfile);
        % show the image
        Screen(exp_screen, 'FillRect', bg_color);
        Screen('DrawTexture', exp_screen, img, [], ...
            [allergy_wanting.width*.5-200 allergy_wanting.height*.5-300 ...
            allergy_wanting.width*.5+200 allergy_wanting.height*.5+100]);
        % show ratings scale
        Screen('TextSize', exp_screen, textsize_rateguide);
        for n = 1:length(allergy_wanting.keyguide)
            DrawFormattedText(exp_screen,allergy_wanting.keyguide(n),...
                allergy_wanting.guideLocs(n),keyguide_loc_low,txt_color,wrapat,[],[],vSpacing);
            DrawFormattedText(exp_screen,char(allergy_wanting.guideTwo(n)),...
                allergy_wanting.guideLocs(n) + want_guide_offset,guide_loc_low,txt_color,wrapat,[],[],1.6);
        end
        Screen('Flip', exp_screen);
        allergy_wanting.want_stimOn(trial) = GetSecs - t0;

        WaitSecs(.2) %force .2 sesconds on the screen so people wont hold down the key; this means that RT's cannot be < 0.2

        % listen for response
        while 1
            [keyIsDown, ~, keyCode] = KbCheck; % normal
            % [keyIsDown, ~, keyCode] = KbCheck(6); % bluetooth keyboard
            if keyIsDown && any(keyCode(allergy_wanting.resp_key_codes)) && length(KbName(keyCode)) == 1

                allergy_wanting.want_RT(trial) = GetSecs - t0;
                allergy_wanting.want_RT(trial) = allergy_wanting.want_RT(trial) ...
                    - allergy_wanting.want_stimOn(trial);

                allergy_wanting.want_keypress{trial} = KbName(keyCode); % letter code

                allergy_wanting.want_text{trial} = allergy_wanting.guide{allergy_wanting.want_keypress{trial} ...
                    ==cell2mat(allergy_wanting.resp_keys)}; % string

                allergy_wanting.want_numeric(trial) = ... % -2 to 2
                    allergy_wanting.want_numeric_guide(allergy_wanting.want_keypress{trial} == ...
                    cell2mat(allergy_wanting.resp_keys));

                break
            elseif keyIsDown && any(keyCode(exitKeys)) && length(KbName(keyCode)) == 1
                exit_flag = 1; Screen('CloseAll'); FlushEvents;
                sca; return;
            end
        end
        save(results_file_name,'allergy_wanting');

        % --- show their response
        % show the image:
        Screen(exp_screen, 'FillRect', bg_color);
        Screen('DrawTexture', exp_screen, img, [], ...
            [allergy_wanting.width*.5-200 allergy_wanting.height*.5-300 ...
            allergy_wanting.width*.5+200 allergy_wanting.height*.5+100]);
        % show ratings scale
        Screen('TextSize', exp_screen, textsize_rateguide);
        for n = 1:length(allergy_wanting.keyguide)
            if strcmp(allergy_wanting.want_text{trial}, char(allergy_wanting.guide{n}))
                DrawFormattedText(exp_screen,allergy_wanting.keyguide(n),...
                    allergy_wanting.guideLocs(n),keyguide_loc_low,chosen_color,wrapat,[],[],vSpacing);
                DrawFormattedText(exp_screen,char(allergy_wanting.guideTwo(n)),...
                    allergy_wanting.guideLocs(n) + want_guide_offset,guide_loc_low,chosen_color,wrapat,[],[],1.6);
            else
                DrawFormattedText(exp_screen,allergy_wanting.keyguide(n),...
                    allergy_wanting.guideLocs(n),keyguide_loc_low,txt_color,wrapat,[],[],vSpacing);
                DrawFormattedText(exp_screen,char(allergy_wanting.guideTwo(n)),...
                    allergy_wanting.guideLocs(n) + want_guide_offset,guide_loc_low,txt_color,wrapat,[],[],1.6);
            end
        end
        Screen('Flip', exp_screen);
        allergy_wanting.want_feedbackOn(trial) = GetSecs - t0;
        Screen('Close', img);
        WaitSecs(allergy_wanting.feedbackSecs);
        %imwrite(Screen('GetImage', exp_screen), sprintf('%d_%d.png',nB,trial))

    end

    allergy_wanting.foods_want = allergy_wanting.foods_not_allergic(logical(allergy_wanting.want_numeric > 0));
    allergy_wanting.sweet_food_want = allergy_wanting.foods_want(find(contains(allergy_wanting.foods_want, 'sweet')));
    allergy_wanting.salt_food_want = allergy_wanting.foods_want(find(contains(allergy_wanting.foods_want, 'salt')));

    allergy_wanting.foods_reallywant = allergy_wanting.foods_not_allergic(logical(allergy_wanting.want_numeric == 2));
    allergy_wanting.sweet_food_reallywant = allergy_wanting.foods_reallywant(find(contains(allergy_wanting.foods_reallywant, 'sweet')));
    allergy_wanting.salt_food_reallywant = allergy_wanting.foods_reallywant(find(contains(allergy_wanting.foods_reallywant, 'salt')));

    if length(allergy_wanting.sweet_food_want) > 0 && length(allergy_wanting.salt_food_want) > 0
        allergy_wanting.eligible = 1;
        eligible = 1;

        % select sweet food
        if length(allergy_wanting.sweet_food_reallywant) > 0
            food_sweet = datasample(allergy_wanting.sweet_food_reallywant, 1);
        else
            food_sweet = datasample(allergy_wanting.sweet_food_want, 1);
        end

        % select salt food
        if length(allergy_wanting.salt_food_reallywant) > 0
            food_salt = datasample(allergy_wanting.salt_food_reallywant, 1);
        else
            food_salt = datasample(allergy_wanting.salt_food_want, 1);
        end

        allergy_wanting.food_salt_select = food_salt;
        allergy_wanting.food_sweet_select = food_sweet;

        Screen(exp_screen, 'FillRect', bg_color);
        DrawFormattedText(exp_screen,[
            'You have completed this section.' '\n' ...
            'Please alert the experimenter and' '\n' ...
            'press any key to close this section.' ...
            ], 'center', 'center',txt_color,[],[],[],1.6);
        Screen('Flip', exp_screen)
        KbWait([], 2) % normal

    else
        allergy_wanting.eligible = 0;
        eligible = 0;
        food_salt = {};
        food_sweet = {};
    end

    allergy_wanting.taskDur(2) = toc;
    save(results_file_name,'allergy_wanting');

    ShowCursor;
    Screen('CloseAll');
    FlushEvents;
end
end
