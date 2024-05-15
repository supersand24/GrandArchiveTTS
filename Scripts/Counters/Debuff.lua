-- Debuff Counter

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name
    if num == 1 then
        self.setName("Debuff")
    else
        self.setName("Debuffs")
    end

    -- Description
    self.setDescription("-" .. num .. " Power\n-" .. num .. " Life")

end