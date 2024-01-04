-- Age Counter Dice

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name
    if num == 1 then
        self.setName("Age Counter")
    else
        self.setName("Age Counters")
    end

    -- Description
    self.setDescription("Wildgrowth Elixir Exclusive")

end