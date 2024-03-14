-- Enlighten Counter

function onNumberTyped(player_color, number)
  
    -- Check if number is valid.
    if number <= 20 then
        updateNameAndDescription(number)
    end

end

function updateNameAndDescription(num)

    -- Name and Description
    if num == 1 then
        self.setName("Enlighten Counter")
        self.setDescription("Need 2 more Enlighten Counters on the champion to be able to draw a card.")
    elseif num == 2 then
        self.setName("Enlighten Counters")
        self.setDescription("Need 1 more Enlighten Counter on the champion to be able to draw a card.")
    else
        self.setName("Enlighten Counters")
        self.setDescription("Can remove 3 Enlighten Counters from a champion to draw a card.")
    end

end