-- Music Counter

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name
    if num == 1 then
        self.setName("Music Counter")
    else
        self.setName("Music Counters")
    end

end