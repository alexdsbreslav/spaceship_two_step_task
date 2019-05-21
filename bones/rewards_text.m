function countdown_text = rewards_text(condition, block, trial, trials, win, action)
if block == 1
    if strcmp(condition, 'food')
        if win == 1
            if action == 0
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
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
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Adding tickets to your total!'];
                elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                    countdown_text = ['A break will begin shortly...' '\n' ...
                    'Adding tickets to your total!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Adding tickets to your total!'];
                end
            end
        else
            if trial == trials
                countdown_text = 'The game will end shortly...'
            elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                countdown_text = 'A break will begin shortly...';
            else
                countdown_text = 'Returning Home...'
            end
        end
    else
        if win == 1
            if action == 0
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Collect your stickers!'];
                elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                    countdown_text = ['A break will begin shortly...' '\n' ...
                    'Collect your stickers!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Collect your stickers!'];
                end
            else
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Adding tickets to your total!'];
                elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                    countdown_text = ['A break will begin shortly...' '\n' ...
                    'Adding tickets to your total!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Adding tickets to your total!'];
                end
            end
        else
            if trial == trials
                countdown_text = 'The game will end shortly...'
            elseif trial == (trials/5) || trial == (2*trials/5) || trial == (3*trials/5) || trial == (4*trials/5)
                countdown_text = 'A break will begin shortly...';
            else
                countdown_text = 'Returning Home...'
            end
        end
    end
else
    if strcmp(condition, 'food')
        if win == 1
            if action == 0
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Collect your snack!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Collect your snack!'];
                end
            else
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Adding tickets to your total!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Adding tickets to your total!'];
                end
            end
        else
            if trial == trials
                countdown_text = 'The game will end shortly...'
            else
                countdown_text = 'Returning Home...'
            end
        end
    else
        if win == 1
            if action == 0
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Collect your stickers!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Collect your stickers!'];
                end
            else
                if trial == trials
                    countdown_text = ['The game will end shortly...' '\n' ...
                    'Adding tickets to your total!'];
                else
                    countdown_text = ['Returning Home...' '\n' ...
                    'Adding tickets to your total!'];
                end
            end
        else
            if trial == trials
                countdown_text = 'The game will end shortly...'
            else
                countdown_text = 'Returning Home...'
            end
        end
    end
end
