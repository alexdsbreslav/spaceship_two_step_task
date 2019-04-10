function rect = screen_check
% ---- Screen setup
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
FlushEvents;
HideCursor;
PsychDefaultSetup(1);

% ---- Screen selection
screens = Screen('Screens'); %count the screen
whichScreen = max(screens);
[w, rect] = Screen('OpenWindow', whichScreen);

Screen('FillRect', w, [0 100 0]);
Screen(w, 'Flip');
KbWait([],2);

Screen('CloseAll');
end
