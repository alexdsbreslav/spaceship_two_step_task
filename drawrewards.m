function f = drawimage(w, snacks, tickets, type)

if type == 0
  X = snacks;
else
  X = tickets;
end

f = Screen('MakeTexture', w, X);
