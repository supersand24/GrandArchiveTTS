-- Pride Marker

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 10 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Description
    self.setDescription("This ally won't obey you unless your champion is at least level " .. num .. ".\n\nThis ally can still retaliate.")

end