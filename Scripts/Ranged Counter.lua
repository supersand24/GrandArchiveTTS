-- Ranged Counter Dice

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name
    if num == 1 then
        self.setName("Ranged Counter")
    else
        self.setName("Ranged Counters")
    end

    -- Description
    self.setDescription("+" .. num .. " Power while distant")

end