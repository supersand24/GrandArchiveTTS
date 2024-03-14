-- Critical Marker

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 4 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Description
    if num == 1 then
        self.setDescription("If attack damage is dealt, double that damage unless an opponent discards 1 card.")
    else
        self.setDescription("If attack damage is dealt, double that damage unless an opponent discards " .. num .. " cards.")
    end

end