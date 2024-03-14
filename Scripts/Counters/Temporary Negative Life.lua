-- Temporary Negative Life Counter

function onNumberTyped(player_color, number)

    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Description
    self.setDescription("-" .. num .. " Life until the End of Turn\n\n(This will delete itself when passing turns)")

end