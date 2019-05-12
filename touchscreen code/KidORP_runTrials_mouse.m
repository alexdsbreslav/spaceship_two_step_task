function [results, data, quitProg] = KidORP_runTrials_mouse(params, dev, data, trialInfo, iTrial, quitProg)

results = nan(1,7); %initalize results
results(1) = iTrial; %trial num
results(2) = trialInfo(1); %self offer val
results(3) = trialInfo(2); %other offer val
results(4) = round(rand()); %default L
%5 for choice
%6 for trial start time
%7 for click time

topColor = params.color.other; %other always on top
bottomColor = params.color.self; %self always on bottom

if results(4) %default on the L
    topLeft = 3;
    bottomLeft = 3;
    topRight = results(3); %top right is other
    bottomRight = results(2); %bottom right is self
else %default on the R
    topRight = 3;
    bottomRight = 3;
    topLeft = results(3); %top left is other
    bottomLeft = results(2); %bottom left is self
end

%fixation cross
Screen('FillRect', dev.win, params.color.white, params.screen.fixCross);
Screen('Flip', dev.win); %keep on screen
WaitSecs(params.timing.iti);


%% draw dividing line down middle of screen
Screen('DrawLine', dev.win, params.text.color, params.screen.centerx, 0, params.screen.centerx, params.screen.height, 5);
%% draw circles

%top left
rect = params.circle.leftTopRect;
for i = 1:topLeft
    Screen('FillOval', dev.win, topColor, rect);
    rect = rect + [params.circle.diam, 0, params.circle.diam, 0];
end

%bottom left
rect = params.circle.leftBottomRect;
for i = 1:bottomLeft
    Screen('FillOval', dev.win, bottomColor, rect);
    rect = rect + [params.circle.diam, 0, params.circle.diam, 0];
end

%top right
rect = params.circle.rightTopRect;
for i = 1:topRight
    Screen('FillOval', dev.win, topColor, rect);
    rect = rect + [params.circle.diam, 0, params.circle.diam, 0];
end

%bottom right
rect = params.circle.rightBottomRect;
for i = 1:bottomRight
    Screen('FillOval', dev.win, bottomColor, rect);
    rect = rect + [params.circle.diam, 0, params.circle.diam, 0];
end

[~, ~, results(6)] = Screen('Flip', dev.win, [], 1); %keep on screen for subsequent flips

%% participant choice

KbQueueStart(dev.mouseIdx(1));
useableClick = 0;
while useableClick == 0 %wait for click inside designated area
    pressed = KbQueueCheck(dev.mouseIdx(1));
    
    if pressed %if touched
    [x, y, buttons] = GetMouse(dev.win); %get touch location
        if (x > params.box.leftRect(1) && x < params.box.leftRect(3) && y > params.box.leftRect(2) && y < params.box.leftRect(4)) %click inside left box
            results(5) = 1; %chose left
            results(7) = GetSecs;
            useableClick = 1;
        elseif (x > params.box.rightRect(1) && x < params.box.rightRect(3) && y > params.box.rightRect(2) && y < params.box.rightRect(4)) %click inside right box
            results(5) = 0; %chose right
            results(7) = GetSecs;
            useableClick = 1;
        end
    end
    
    [keyIsDown, secs, keyCode] = KbCheck; %check for esc while waiting for mouseclick
    if keyIsDown
        if(find(keyCode) == params.button.esckey) %esc to quit
            quitProg = 1;
            return
        end
    end
    
end %click inside a designated area
KbQueueStop(dev.mouseIdx(1));

if (results(5) == 1) %chose left
    Screen('FrameRect', dev.win, params.color.white, params.box.leftRect, 5);
elseif (results(5) == 0) %chose right
    Screen('FrameRect', dev.win, params.color.white, params.box.rightRect, 5);
end %flipping between choices

Screen('Flip', dev.win);
WaitSecs(params.timing.iti);