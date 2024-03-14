--[[
Grand Archive TCG
Grand Archive created by Weebs of the Shore LLC, all rights reserved.
Updated Mod Created by supersand24 (supersand24 on Discord)
Original Mod Created by Chris Orrell (Australian TCG)

Grand Archive Website : https://www.grandarchivetcg.com/
Grand Archive Discord : https://discord.gg/8gM49zN2XD

Version 1.0

--]]

RED_HANDBOOK = '477299'
RED_TABLET = '55c6df'
RED_TOKENS = '38fce2'
RED_DRAW_COUNTER = '8f73ae'
RED_PLAYMAT = 'dacc34'

BLUE_HANDBOOK = 'df0233'
BLUE_TABLET = '6ceec1'
BLUE_TOKENS = 'd3281b'
BLUE_DRAW_COUNTER = '1d4bc4'
BLUE_PLAYMAT = '609cf2'

GREEN_HANDBOOK = '6eec32'
GREEN_TABLET = '89c0cf'
GREEN_TOKENS = '96e172'
GREEN_DRAW_COUNTER = '760afb'
GREEN_PLAYMAT = 'ebfacc'

YELLOW_HANDBOOK = 'a6c2e6'
YELLOW_TABLET = '1a66e5'
YELLOW_TOKENS = 'c8c527'
YELLOW_DRAW_COUNTER = '167ada'
YELLOW_PLAYMAT = 'b90a1d'

privacyZones = {
  Red = {"Blue"},
  Blue = {"Red"}
}

playmats = {
  Red = 'dacc34',
  Blue = '609cf2'
}

--TTS is lacking in this area...
--Was looking forward to adding some kind of Log for card movement.
--Can't give variables to cards in a deck, making drawing cards throw an error. :(
gameZones = {
  mainDeck = {
    ttsName = "Main Deck",
    movementFlavorText = {
      mainDeck = "added?",        -- Main Deck -> Main Deck
      materialDeck = "added",     -- Material Deck -> Main Deck
      sideDeck = "added",         -- Side Deck -> Main Deck
      graveyard = "added",        -- Graveyard -> Main Deck
      banishment = "unbanished",  -- Banishment -> Main Deck
      field = "returned",         -- Field -> Main Deck
      memory = "returned",        -- Memory -> Main Deck
      hand = "returned"           -- Hand -> Main Deck
    },
    private = true,
    logRevealActions = false
  },
  materialDeck = {
    ttsName = "Material Deck",
    movementFlavorText = {
      mainDeck = "added",         -- Main Deck -> Material Deck
      materialDeck = "added?",    -- Material Deck -> Material Deck
      sideDeck = "added",         -- Side Deck -> Material Deck
      graveyard = "added",        -- Graveyard -> Material Deck
      banishment = "unbanished",  -- Banishment -> Material Deck
      field = "preserved",        -- Field -> Material Deck
      memory = "added",           -- Memory -> Material Deck
      hand = "added"              -- Hand -> Material Deck
    },
    private = true,
    logRevealActions = false
  },
  sideDeck = {
    ttsName = "Side Deck",
    movementFlavorText = {
      mainDeck = "added",         -- Main Deck -> Side Deck
      materialDeck = "added",     -- Material Deck -> Side Deck
      sideDeck = "added?",        -- Side Deck -> Side Deck
      graveyard = "added",        -- Graveyard -> Side Deck
      banishment = "added",       -- Banishment -> Side Deck
      field = "added",            -- Field -> Side Deck
      memory = "added",           -- Memory -> Side Deck
      hand = "added"              -- Hand -> Side Deck
    },
    private = true,
    logRevealActions = false
  },
  graveyard = {
    ttsName = "Graveyard",
    movementFlavorText = {
      mainDeck = "milled",        -- Main Deck -> Graveyard
      materialDeck = "moved",     -- Material Deck -> Graveyard
      sideDeck = "moved",         -- Side Deck -> Graveyard
      graveyard = "added?",       -- Graveyard -> Graveyard
      banishment = "unbanished",  -- Banishment -> Graveyard
      field = "buried",           -- Field -> Graveyard
      memory = "moved",           -- Memory -> Graveyard
      hand = "discarded"          -- Hand -> Graveyard
    },
    private = false,
    logRevealActions = false
  },
  banishment = {
    ttsName = "Banishment",
    movementFlavorText = {
      mainDeck = "milled",        -- Main Deck -> Banishment
      materialDeck = "banished",  -- Material Deck -> Banishment
      sideDeck = "moved",         -- Side Deck -> Banishment
      graveyard = "banished",     -- Graveyard -> Banishment
      banishment = "unbanished?", -- Banishment -> Banishment
      field = "banished",         -- Field -> Banishment
      memory = "banished",        -- Memory -> Banishment
      hand = "banished"           -- Hand -> Banishment
    },
    private = false,
    logRevealActions = false
  },
  field = {
    ttsName = "Field",
    movementFlavorText = {
      mainDeck = "played",            -- Main Deck -> Field
      materialDeck = "materialized",  -- Material Deck -> Field
      sideDeck = "moved",             -- Side Deck -> Field
      graveyard = "revived",          -- Graveyard -> Field
      banishment = "unbanished",      -- Banishment -> Field
      field = "played",               -- Field -> Field
      memory = "played",              -- Memory -> Field
      hand = "played"                 -- Hand -> Field
    },
    private = false,
    logRevealActions = true
  },
  memory = {
    ttsName = "Memory",
    movementFlavorText = {
      mainDeck = "drew",          -- Main Deck -> Memory
      materialDeck = "moved",     -- Material Deck -> Memory
      sideDeck = "moved",         -- Side Deck -> Memory
      graveyard = "moved",        -- Graveyard -> Memory
      banishment = "unbanished",  -- Banishment -> Memory
      field = "removed",          -- Field -> Memory
      memory = "moved",           -- Memory -> Memory
      hand = "paid"               -- Hand -> Memory
    },
    private = true,
    logRevealActions = true
  },
  hand = {
    ttsName = "Hand",
    movementFlavorText = {
      mainDeck = "drew",          -- Main Deck -> Hand
      materialDeck = "returned",  -- Material Deck -> Hand
      sideDeck = "moved",         -- Side Deck -> Hand
      graveyard = "dug up",       -- Graveyard -> Hand
      banishment = "unbanished",  -- Banishment -> Hand
      field = "returned",         -- Field -> Hand
      memory = "recollected",     -- Memory -> Hand
      hand = "gave"               -- Hand -> Hand
    },
    private = true,
    logRevealActions = false
  }
}

function onObjectLeaveContainer(container, leave_object)
  if (leave_object.name != "CardCustom") then return end
  leave_object.addTag("Card")
end


function onObjectDrop(colorName, object)
  inHand = false
  for _, zone in ipairs(object.getZones()) do
    if zone.name == "HandTrigger" then
      inHand = true
    end
  end

  if inHand then
    object.setHiddenFrom(privacyZones[colorName])
  else
    object.setHiddenFrom({})
  end
end

function onObjectEnterZone(zone, object)
  if zone.name == "HandTrigger" and object.held_by_color == nil then
    object.setHiddenFrom(privacyZones[zone.getValue()])
  end
end

function importDecks(params)

  local temp = 0;

  --Main Deck
  local ii = 0
  for c,card in pairs(params.decks.main) do
    for i=1, card.quantity do
      Wait.frames(function()
        spawnGrandArchiveCard({name = card.name, image = card.image, pos = params.mainDeck.position, rot = params.mainDeck.rotation})
      end, 3 * temp)
      temp = temp + 1
    end
  end

  temp = 0;

  --Material Deck
  local materialDeck = params.decks.material
  for c = #materialDeck, 1, -1 do
    local card = materialDeck[c]
    Wait.frames(function()
      for i=1, card.quantity do
        spawnGrandArchiveCard({name = card.name, image = card.image, pos = params.materialDeck.position, rot = params.materialDeck.rotation})
      end
    end, 5 * temp)
    temp = temp + 1
  end

  temp = 0;

  --Side Deck
  local sideDeck = params.decks.sideboard
  for c = #sideDeck, 1, -1 do
    local card = sideDeck[c]
    for i=1, card.quantity do
      Wait.frames(function()
        spawnGrandArchiveCard({name = card.name, image = card.image, pos = params.sideDeck.position, rot = params.sideDeck.rotation})
      end, 5 * temp)
      temp = temp + 1
    end
  end

  --Tokens & Generated
  local tokens = params.decks.token
  for c = #tokens, 1, -1 do
    local card = tokens[c]
    for i=1, card.quantity do
      Wait.frames(function()
        spawnGrandArchiveCard({name = card.name, image = card.image, pos = params.tokens.position, rot = params.tokens.rotation})
      end, 5 * temp)
      temp = temp + 1
    end
  end
  tokens = params.decks.generated
  for c = #tokens, 1, -1 do
    local card = tokens[c]
    for i=1, card.quantity do
      Wait.frames(function()
        spawnGrandArchiveCard({name = card.name, image = card.image, pos = params.tokens.position, rot = params.tokens.rotation})
      end, 5 * temp)
      temp = temp + 1
    end
  end

end

function spawnGrandArchiveCard(params)

  spawnObjectData({
    data = {
        Name = "CardCustom",
        Transform = {
            posX = params.pos.x,
            posY = params.pos.y,
            posZ = params.pos.z,
            rotX = 0,
            rotY = params.rot.y,
            rotZ = 180,
            scaleX = 1.42055011,
            scaleY = 1,
            scaleZ = 1.42055011
        },
        Nickname = params.name,
        CardID = 10000,
        CustomDeck = {
          [100] = {
            FaceURL = params.image,
            BackURL = "https://img.silvie.org/cdn/deck-builder/card-back.png",
            NumWidth = 1,
            NumHeight = 1,
            BackIsHidden = true,
            UniqueBack = false,
            Type = 0
          }
        }
    }
  })

end

function onPlayerAction(player, action, targets)
  -- Rotate Scripted Counter Left
  -- If Value is 1, delete it.
  -- Else, Update UI
  if action == Player.Action.RotateIncrementalLeft then
    for _, target in ipairs(targets) do
      if target.hasTag("Scripted Counter") == false then return true end
      if target.getValue() == 1 then target.destroy() else
        target.call("updateNameAndDescription", target.getValue() - 1)
      end
    end

  -- Rotate Scripted Counter Right
  -- If Value is 20, create another counter next to it.
  -- Else, Update UI
  elseif action == Player.Action.RotateIncrementalRight then
    for _, target in ipairs(targets) do
      if target.hasTag("Scripted Counter") == false then return true end
      if target.getValue() == 20 then return false else
        target.call("updateNameAndDescription", target.getValue() + 1)
      end
    end

  end

  -- Allow the action.
  return true
end

function onPlayerTurnEnd(player_color_end, player_color_next)
  -- Delete All Temporary Counters
  for _, object in ipairs(getObjectsWithTag("Temporary")) do
    destroyObject(object)
  end

  -- Reset Cards Drawn Counters
  getObjectFromGUID(RED_PLAYMAT).call("clearDrawCounter")
  getObjectFromGUID(BLUE_PLAYMAT).call("clearDrawCounter")
  getObjectFromGUID(GREEN_PLAYMAT).call("clearDrawCounter")
  getObjectFromGUID(YELLOW_PLAYMAT).call("clearDrawCounter")
end

function onLoad(save_state)
  --[[
  for k,v in pairs(getSeatedPlayers()) do
    if Player[v].host then
      Player[v].showOptionsDialog("Game Settings", {"1","2"}, 2)
    end
  end
  --]]

  getObjectFromGUID(RED_TABLET).setInvisibleTo(privacyZones["Red"])
  getObjectFromGUID(RED_HANDBOOK).setInvisibleTo(privacyZones["Red"])
  for _, bag in ipairs(getObjectFromGUID(RED_TOKENS).getObjects()) do
    bag.setInvisibleTo(privacyZones["Red"])
  end

  getObjectFromGUID(BLUE_TABLET).setInvisibleTo(privacyZones["Blue"])
  getObjectFromGUID(BLUE_HANDBOOK).setInvisibleTo(privacyZones["Blue"])
  for _, bag in ipairs(getObjectFromGUID(BLUE_TOKENS).getObjects()) do
    bag.setInvisibleTo(privacyZones["Blue"])
  end

  --Pay 1 Memory Card Keybind
  addHotkey("Pay 1 Memory Card", function(playerColor, object, pointerPosition, isKeyUp)
    local playmat = getObjectFromGUID(playmats[playerColor]).call("payOneMemoryCard")
  end)

  --Reveal Random Memory Card Keybind
  addHotkey("Reveal Random Memory Card", function(playerColor, object, pointerPosition, isKeyUp)
    local playmat = getObjectFromGUID(playmats[playerColor]).call("revealRandomMemoryCard")
  end)

  --Recollect Memory Keybind
  addHotkey("Recollect Memory", function(playerColor, object, pointerPosition, isKeyUp)
    local playmat = getObjectFromGUID(playmats[playerColor]).call("recollectMemory")
  end)

  --Hide Memory Buttons Keybind
  addHotkey("Hide Memory Buttons", function(playerColor, object, pointerPosition, isKeyUp)
    local playmat = getObjectFromGUID(playmats[playerColor]).call("hideMemoryButtons")
  end)

end

--Returns true if str starts with start.
function stringStartsWith(params)
   return params.string:sub(1, #params.startsWith) == params.startsWith
end

function removeStringFromStart(params)
    return params.string:sub(#params.remove + 1)
end

--Returns true if str end with ending.
function stringEndsWith(params)
  return params.endsWith == "" or params.string:sub(-#params.endsWith) == params.endsWith
end