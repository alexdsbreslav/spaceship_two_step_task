function KidORP_wrapper_mouse(subType, subNum, cond, datadir)

% PSYCHTOOLBOX SCRIPT
% Rosa Li

%

%get rand seed
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));


%% get file names and locations

workdir = pwd;
doPrac = 1;
%if not correct number of inputs, prompt from user, run randstream again,
%and use 'data' as datadir
if nargin ~= 4
    inputNeeded = 1;
    datadir = [workdir, filesep, 'data'];
    if ~exist(datadir, 'dir')
        mkdir(datadir);
    end
    while inputNeeded
        subTypeComplete = 0;
        while subTypeComplete == 0
            subTypeCode = input('\nEnter 1 for Child, 2 for Adult: ');
            
            if subTypeCode == 1
                subType = 'Child';
                subTypeComplete = 1;
            elseif subTypeCode == 2
                subType = 'Adult';
                subTypeComplete = 1;
            elseif subTypeCode == 3
                subType = 'Test';
                subTypeComplete = 1;
            else
                fprintf('Error in subType. Try again');
            end
        end %correct subType
        
        
        subNum = input('\nEnter participant number: ');
        cond = input('\nEnter condition (1 or 2): ');
        
        fileName = sprintf('%s_KidORP_Sub%03d_Cond%d.mat', subType, subNum, cond);
        fullFileName = fullfile(datadir, fileName);
        
        %make sure fileName doesn't already exist
        while exist(fullFileName, 'file')
            overwrite = input('File exists. Overwrite y/n? ', 's');
            if strcmpi(overwrite, 'Y')
                break;
            else
                fprintf('Ending program. \n');
                return;
            end
        end
        inputComplete = input(['Filename is ' fileName '. Correct y/n? '], 's');
        if strcmpi(inputComplete, 'Y')
            inputNeeded = 0;
        end
    end %input complete
else
    fileName = sprintf('%s_KidORP_Sub%03d_Cond%d.mat', subType, subNum, cond);
    fullFileName = fullfile(datadir, fileName);
end %not enough input args



%easy debug option
if strcmpi(subType, 'Test')
    debugMode = 1;
else
    debugMode = 0;
end

%begin data structure
data.subNum = subNum;
data.subType = subType;
data.cond = cond;
data.date = datestr(now, 2);
data.time = datestr(now, 13);

%load directions
slideDir = fullfile(workdir, 'TaskInstr', sprintf('InstrCond%d', cond));
slideInfo = dir(fullfile(slideDir, '*.png'));
for i = 1:length(slideInfo)
    fileName = slideInfo(i).name;
    params.instr.pics{i} = imread(fullfile(slideDir, fileName));
end

params.instr.choseL = imread(fullfile(slideDir, 'SpecImages', 'ChoseL.png'));
params.instr.choseR = imread(fullfile(slideDir, 'SpecImages', 'ChoseR.png'));
params.instr.pracReady = imread(fullfile(slideDir, 'SpecImages', 'PracReady.png'));
params.instr.realReady = imread(fullfile(slideDir, 'SpecImages', 'RealReady.png'));

%% =============================================================
%                   GENERAL PARAMETERS
%%=============================================================

%use second monitor if exists
params.screen.idx = max(Screen('Screens'));
Screen('Preference', 'ConserveVRAM', 4096);
Screen('Preference', 'SkipSyncTests', 1);

%colors
params.color.white = [255 255 255];
params.color.black = [0 0 0];
params.color.grey = [177 177 177];
params.color.red = [255 0 0];
params.color.blue = [0 0 255];

% keys
KbName('UnifyKeyNames');
params.button.esckey = KbName('escape');
params.button.spacebar = KbName('space');
params.button.leftarrow = KbName('leftarrow');
params.button.rightarrow = KbName('rightarrow');
params.button.leftkey = KbName('f');
params.button.rightkey = KbName('j');

%text
params.text.font = 'Arial';
params.text.size = 40;
params.text.color = params.color.white;

%% ==================================================
%                   TASK PARAMETERS
%%===================================================

% timing
params.timing.iti = 1;
%params.timing.choiceShown = 1.5;
params.give_break = 10; %give break every X trials

%assign colors
if cond == 1
    params.color.self = params.color.red;
    params.color.other = params.color.blue;
else
    params.color.self = params.color.blue;
    params.color.other = params.color.red;
end

%generate trials
[x,y] = meshgrid(0:1:6, 0:1:6);
allCombos = [x(:), y(:)];

%remove reference 3/3
remove = allCombos(:,1)==3 & allCombos(:,2)==3;
allCombos(remove,:) = [];

%remove 0/0
remove = allCombos(:,1)==0 & allCombos(:,2)==0;
allCombos(remove,:) = [];

%remove both options <= 3
remove = allCombos(:,1) <=3 & allCombos(:,2) <= 3;
worseThanRef = allCombos(remove,:);
allCombos(remove,:) = [];

%% for piloting only
% remove both options >=3
remove = allCombos(:,1) >=3 & allCombos(:,2) >= 3;
betterThanRef = allCombos(remove,:);
allCombos(remove,:) = [];

%show each combo twice
params.trial_list = [allCombos;allCombos];

%randomize order
params.trial_list = params.trial_list(randperm(length(params.trial_list)),:);

params.pracTrials = [4,4; 6,6; 5,5];

%% ==================================================
%                   RUN TASK
%%===================================================
try
    if debugMode == 0
        %         screenRect = [0,0, 1280, 1024]; %Tobii dimensions
        screenRect = [];
        ListenChar(2); %keep keyboard input from MatLab
        %HideCursor; %hides cursor
    else %smaller screen; keep cursor when debugging
        %         screenRect = [100, 100, 1380, 1124];
        screenRect = [0 0 1200 960];
        screenRect = [0 0 800 500];
    end
    % open window
    dev.win = Screen('OpenWindow', params.screen.idx, params.color.black, screenRect);
    
    %get mouse indices
    dev.mouseIdx = GetMouseIndices;
    
    % font
    Screen('TextStyle', dev.win, 0);
    Screen('TextFont', dev.win, params.text.font);
    Screen('TextSize', dev.win, params.text.size);
    
    % positions
    [params.screen.width, params.screen.height] = Screen('WindowSize', dev.win);
    params.screen.centerx = params.screen.width/2; %x coord for center of screen
    params.screen.centery = params.screen.height/2; % y coord for center of screen
    params.screen.leftxstart = params.screen.width/8; %left start x coord
    params.screen.rightxstart = params.screen.width/8 * 5; %right start x coord
    params.screen.topy = params.screen.height/8 * 3; %top half y
    params.screen.bottomy = params.screen.height/8 * 5; %bottom half y
    
    %circle dimensions
    params.circle.diam = params.screen.width/24;
    params.circle.leftTopRect = [params.screen.leftxstart, params.screen.topy-params.circle.diam/2, ...
        params.screen.leftxstart + params.circle.diam, params.screen.topy+params.circle.diam/2];
    params.circle.leftBottomRect = [params.screen.leftxstart, params.screen.bottomy-params.circle.diam/2, ...
        params.screen.leftxstart + params.circle.diam, params.screen.bottomy+params.circle.diam/2];
    params.circle.rightTopRect = [params.screen.rightxstart, params.screen.topy-params.circle.diam/2, ...
        params.screen.rightxstart + params.circle.diam, params.screen.topy+params.circle.diam/2];
    params.circle.rightBottomRect = [params.screen.rightxstart, params.screen.bottomy-params.circle.diam/2, ...
        params.screen.rightxstart + params.circle.diam, params.screen.bottomy+params.circle.diam/2];
    
    %selection box dimensions
    params.box.leftRect = [params.screen.width/10, params.screen.height/4, params.screen.width/10*4, params.screen.height/4*3];
    params.box.rightRect = [params.screen.width/10*6, params.screen.height/4, params.screen.width/10*9, params.screen.height/4*3];
    
    %fixation cross
    params.screen.centerbox = [params.screen.centerx, params.screen.centery, params.screen.centerx, params.screen.centery];
    params.screen.fixCross = [[-30 -1 30 1] + params.screen.centerbox; [-1 -30 1 30] + params.screen.centerbox]';
    
    %flip interval
    dev.flipint = Screen('GetFlipInterval', dev.win);
    
    %% Practice
    if doPrac == 1;
        ipage = 1;
        
        while ipage <= length(params.instr.pics)
            keyCode = [];
            tex.intro = Screen('MakeTexture', dev.win, params.instr.pics{ipage});
            Screen('DrawTexture', dev.win, tex.intro);
            Screen('Flip', dev.win);
            
            if ipage == 1
                dev.keyNav = [params.button.rightarrow params.button.esckey];
            elseif ipage > 1 && ipage < length(params.instr.pics)
                dev.keyNav = [params.button.rightarrow params.button.leftarrow params.button.esckey];
            elseif ipage == length(params.instr.pics)
                break
                %dev.keyNav = [params.button.leftarrow params.button.esckey]; %currently isn't called
            end
            
            while ~any(ismember(dev.keyNav, find(keyCode)))
                [secs, keyCode, ~] = KbWait ([], 3);
            end
            
            if keyCode(params.button.leftarrow)
                ipage = ipage - 1;
            elseif keyCode(params.button.rightarrow) %not final page
                ipage = ipage + 1;
            elseif keyCode(params.button.esckey)
                Screen('CloseAll');
                save(fullFileName, 'data', 'dev', 'params');
                ShowCursor;
                ListenChar(0);
                Priority(0);
                return;
            end
        end %while in practice instructions
        
        KbQueueStart(dev.mouseIdx(1));
        useableClick = 0;
        while useableClick == 0 %wait for click inside designated area
          [pressed] = KbQueueCheck(dev.mouseIdx(1)); %checks for fast touchscreen touch; GetMouseClicks too slow to register touchscreen
           if pressed %if touch
               [x, y] = GetMouse(dev.win); %get location of touch
                %show practice choice
                if ((x < params.screen.centerx) && (y > params.screen.centery) && (y < params.screen.height)) %left side, bottom half click/touch
                    tex.intro = Screen('MakeTexture', dev.win, params.instr.choseL);
                    Screen('DrawTexture', dev.win, tex.intro);
                    Screen('Flip', dev.win);
                    useableClick = 1;
                elseif ((x > params.screen.centerx) && (x < params.screen.width) && (y > params.screen.centery) && (y < params.screen.height)) %right side, bottom half click/touch
                    tex.intro = Screen('MakeTexture', dev.win, params.instr.choseR);
                    Screen('DrawTexture', dev.win, tex.intro);
                    Screen('Flip', dev.win);
                    useableClick = 1;
                end
            end
        end
        KbQueueStop(dev.mouseIdx(1));
        
        %after making choice, press right arrow to see next screen
        keyCode = [];
        while KbCheck; end %wait until all keys released
        dev.keyNav = [params.button.esckey params.button.rightarrow];
        while ~any(ismember(dev.keyNav, find(keyCode)))
            [keyIsDown, secs, keyCode, ~] = KbCheck;
        end
        if keyCode(params.button.rightarrow)
            tex.intro = Screen('MakeTexture', dev.win, params.instr.pracReady);
            Screen('DrawTexture', dev.win, tex.intro);
            Screen('Flip', dev.win);
        elseif keyCode(params.button.esckey)
            Screen('CloseAll');
            save(fullFileName, 'data', 'dev', 'params');
            ShowCursor;
            ListenChar(0);
            Priority(0);
            return;
        end
        
        %wait for spacebar to start practice
        cont = 0;
        keyCode = [];
        while KbCheck; end %wait until all keys released
        while cont == 0
            dev.keyNav = [params.button.esckey params.button.spacebar];
            
            while ~any(ismember(dev.keyNav, find(keyCode)))
                [secs, keyCode, deltaSecs] = KbWait ([], 3);
            end
            if keyCode(params.button.spacebar)
                cont = 1;
                data.pracStart = secs;
            elseif keyCode(params.button.esckey)
                Screen('CloseAll');
                save(fullFileName, 'data', 'dev', 'params');
                ShowCursor;
                ListenChar(0);
                Priority(0);
                return;
            end
        end
        
        %initalize practice
        
        for pracTrial = 1:size(params.pracTrials,1);
            trialInfo = params.pracTrials(pracTrial,:);
            quitProg = 0;
            [results, data, quitProg] = KidORP_runTrials_mouse(params, dev, data, trialInfo, pracTrial, quitProg);
            if quitProg
                save(fullFileName, 'data', 'dev', 'params');
                Screen('CloseAll');
                ShowCursor;
                ListenChar(0);
                Priority(0);
                return
            end
            data.pracResults(pracTrial,:) = results;
            save(fullFileName, 'data', 'dev', 'params');
            
        end %practice trials
    end
    %% Real trials
    
    
    tex.intro = Screen('MakeTexture', dev.win, params.instr.realReady);
    Screen('DrawTexture', dev.win, tex.intro);
    Screen('Flip', dev.win); 
    
    keyCode = [];
    dev.keyNav = [params.button.spacebar, params.button.esckey];
    while ~any(ismember(dev.keyNav, find(keyCode)))
        [secs, keyCode, deltaSecs] = KbWait([], 3);
    end
    if keyCode(params.button.spacebar)
        instrEnd = secs; %timestamp on space to end block instructions
    elseif keyCode(params.button.esckey)
        Screen('CloseAll');
        save(fullFileName, 'data', 'dev', 'params');
        ShowCursor;
        ListenChar(0);
        Priority(0);
        return;
    end
    
    if debugMode %reduced set of trials
        params.trial_list = [5,5; 1,5; 5,1; 3,4; 4,3];
    end
    
    for iTrial = 1:length(params.trial_list)
        
        trialInfo = params.trial_list(iTrial,:);
        quitProg = 0;
        [results, data, quitProg] = KidORP_runTrials_mouse(params, dev, data, trialInfo, iTrial, quitProg);
        if quitProg
            save(fullFileName, 'data', 'dev', 'params');
            Screen('CloseAll');
            ShowCursor;
            ListenChar(0);
            Priority(0);
            return
        end
        data.realResults(iTrial,:) = results;
        
        save(fullFileName, 'data', 'dev', 'params');
        
        %give break
        if iTrial ~= length(params.trial_list) %if not last trial
            if rem(iTrial, params.give_break) == 0 %if time for a break
                DrawFormattedText(dev.win, 'You may now take a break.\n\nPress spacebar to continue', 'center', 'center', params.text.color, 60, [], [], 1.5);
                Screen('Flip', dev.win);
                keyCode = [];
                dev.keyNav = [params.button.spacebar, params.button.esckey];
                while ~any(ismember(dev.keyNav, find(keyCode)))
                    [secs, keyCode, deltaSecs] = KbWait([], 3);
                end
                if keyCode(params.button.spacebar)
                    instrEnd = secs; %timestamp on space to end block instructions
                elseif keyCode(params.button.esckey)
                    Screen('CloseAll');
                    save(fullFileName, 'data', 'dev', 'params');
                    ShowCursor;
                    ListenChar(0);
                    Priority(0);
                    return;
                end
            end %end if time for a break
        end %end if final trial
        
    end % iterate through real trials
    
    DrawFormattedText(dev.win, 'End of this game.', 'center', 'center', params.text.color, 60, [], [], 1.5);
    Screen('Flip', dev.win);
    WaitSecs(3);
    
    Screen('CloseAll');
    save(fullFileName, 'data', 'dev', 'params');
    ShowCursor;
    ListenChar(0);
    Priority(0);
catch
    psychrethrow(psychlasterror);
    Screen('CloseAll');
    save(fullFileName, 'data', 'dev', 'params');
    ShowCursor;
    ListenChar(0);
    Priority(0);
end

