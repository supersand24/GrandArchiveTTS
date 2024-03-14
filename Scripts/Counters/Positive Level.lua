-- Positive Level Counter

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name and Description
    if num == 1 then
        self.setName("Level (+)")
        self.setDescription("+1 Level")
    else
        self.setName("Levels (+)")
        self.setDescription("+" .. num .. " Levels")
    end

end