-- Refinement Counter

function onNumberTyped(player_color, number)

    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name
    if num == 1 then
        self.setName("Refinement Counter")
    else
        self.setName("Refinement Counters")
    end

end