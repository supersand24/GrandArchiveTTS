-- Durability Counter

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Description
    if num == 1 then
        self.setDescription("This weapon can only be used 1 more time before it breaks.")
    else
        self.setDescription("This weapon can only be used " .. num .. " more times before it breaks.")
    end

end