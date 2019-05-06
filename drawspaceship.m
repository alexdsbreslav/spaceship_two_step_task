function f = drawspaceship(w, A1_out, A1_return, B1_out, B1_return, type, direction)

if type == 0
    if strcmp(direction, 'out')
        X = A1_out;
    else
        X = A1_return;
    end
else
    if strcmp(direction, 'out')
        X = B1_out;
    else
        X = B1_return;
    end
end
f = Screen('MakeTexture', w, X);
