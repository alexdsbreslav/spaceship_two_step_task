function f = drawrewards(w, condition, snacks, stickers, tickets, type)

if strcmp(condition, 'food')

    if type == 0
      X = snacks;
    else
      X = tickets;
    end

else
    if type == 0
      X = stickers;
    else
      X = tickets;
    end
end

f = Screen('MakeTexture', w, X);
