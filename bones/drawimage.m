% This function was written by Arkady Konovalov, PhD (University of Zurich)
% and generously shared on request. This function is used within main_task.

% Please do not share or use this script without the permission of all invovled parties.
% Author: Arkady Konovalov

function f = drawimage(w, A1, B1, A2, B2, A3, B3, type, state)

if state == 1

    if type == 0
    X = A1;
    else
    X = B1;
    end

end

if state == 2

    if type == 0
    X = A2;
    else
    X = B2;
    end

end

if state == 3

    if type == 0
    X = A3;
    else
    X = B3;
    end

end

f = Screen('MakeTexture', w, X);
