function pull = ticket_pull(mean, sd)

  pull = round(normrnd(mean, sd));
  if pull == 0
      pull = 1;
  end
end
