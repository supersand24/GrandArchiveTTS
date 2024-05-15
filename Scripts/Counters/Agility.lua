-- Agility Counter

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name
    self.setName("Agility")

    -- Description
    if num == 1 then
        self.setDescription("At the start of the end phase, pick up 1 card from your Memory.")
    else
        self.setDescription("At the start of the end phase, pick up " .. num .. " cards from your Memory.")
    end


end