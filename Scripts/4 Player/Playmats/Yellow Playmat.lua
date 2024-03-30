local zones = {
  field = {
    x = 0,
    y = 3,
    z = -5.5
  },
  memory = {
    x = 0,
    y = 3,
    z = -7.25
  },
  banishment = {
    x = -18.3,
    y = 3,
    z = -6.6,
    rot = 270
  },
  mainDeck = {
    x = -17.6,
    y = 3,
    z = -1.2
  },
  graveyard = {
    x = -17.6,
    y = 3,
    z = 4.75
  },
  tokens = {
    x = 18.3,
    y = 3,
    z = -6.6,
    rot = 90
  },
  materialDeck = {
    x = 17.6,
    y = 3,
    z = -1.2
  },
  sideboard = {
    x = 17.6,
    y = 3,
    z = 4.75
  },
}

local fieldZone = nil
local memoryZone = nil
local banishmentZone = nil
local mainDeckZone = nil
local graveyardZone = nil
local tokensZone = nil
local materialDeckZone = nil
local sideDeckZone = nil

local damageTakenCounterCount = 0
local banishmentCardCounterCount = 0
local drawCounterCount = 0
local graveyardFloatingCardCounterCount = 0
local graveyardCardCounterCount = 0

local banishmentCardCounterRevealed = false
local graveyardCardCounterRevealed = false

local fieldMagnets = false
local trustOthers = true

local memoryButtonsVisible = true

local myPlayer = Player.Yellow
local playerVisibilities = {
  mySide = { visible = "Blue|Yellow", invisible = "Yellow"},
  oppositeSide = { visible = "Red|Green|Grey|Black", invisible = "Grey|Black"},
}
local mod = 1

local deckURL = "https://build.silvie.org/"

function getTokensZone()
  return tokensZone
end

function syncTextFields(player, value, id)
--Set deckURL while trimming whitespace.
deckURL = string.gsub(value, "%s+", "");
end

--When the Import Deck Button is pressed.
function importDeck()

--Error Handling
if mainDeckZone == nil then log("Main Deck Zone is nil.") return end
if materialDeckZone == nil then log("Material Deck Zone is nil.") return end
if sideDeckZone == nil then log("Side Deck Zone is nil.") return end
if tokensZone == nil then log("Tokens Zone is nil.") return end

--Append http://
if Global.call("stringStartsWith",{string=deckURL,startsWith="https://"}) == false then
  deckURL = "https://" .. deckURL
end

--Silvie
if Global.call("stringStartsWith",{string=deckURL,startsWith="https://build"}) then
  --Append ?format=json if it isn't there.
  if Global.call("stringEndsWith",{string=deckURL,endsWith="?format=json"}) == false then
    deckURL = deckURL .. "?format=json"
  end

--Shout at your decks
elseif Global.call("stringStartsWith",{string=deckURL,startsWith="https://www.shout"}) or Global.call("stringStartsWith",{string=deckURL,startsWith="https://shout"}) then
  --Sub http://shoutatyourdecks.com/decks/ -> http://shoutatyourdecks.com/api/
  deckURL = deckURL:gsub("/decks/","/api/")
else
  broadcastToColor("Unknown Deck Import Link", myPlayer.color, {255,0,0})
  return
end

log("Importing " .. deckURL)

--Get Deck from URL
WebRequest.get(deckURL, function(request)
  if request.is_error then
    log(request.error)
  else

    json = JSON.decode(request.text)

    --Check for Error from silve.org
    if json.error ~= nil then
      log(json.error)
      if json.error == "silvie/bad-request" then
        broadcastToColor("Could not find a Deck under that URL!", myPlayer.color, {255,0,0})
      else
        broadcastToColor("Unknown Error!", myPlayer.color, {255,0,0})
      end
    else
      --Start Spawning Cards
      --broadcastToColor("Importing " .. json.name .. " from " .. json.creator, myPlayer.color, {255,255,255})

      new = {x = tokensZone.getRotation().x, y = (tokensZone.getRotation().x-90), z = tokensZone.getRotation().z}

      Global.call("importDecks", {
        decks=json.cards,
        mainDeck={
          position = mainDeckZone.getPosition(),
          rotation = mainDeckZone.getRotation()
        },
        materialDeck={
          position = materialDeckZone.getPosition(),
          rotation = materialDeckZone.getRotation()
        },
        sideDeck={
          position = sideDeckZone.getPosition(),
          rotation = sideDeckZone.getRotation()
        },
        tokens={
          position = tokensZone.getPosition(),
          rotation = {y = zones.tokens.rot}
        }
      })

      -- Hide Import Button UI
      hideDeckImport()

    end

  end

end)

end

function hideDeckImport()
self.UI.hide(string.lower(myPlayer.color) .. "DeckImport")
end

function showDeckImport()
self.UI.show(string.lower(myPlayer.color) .. "DeckImport")
end

function resetPlayspace()

if fieldZone == nil then log("Field Zone is nil.") return end
if memoryZone == nil then log("Memory Zone is nil.") return end
if banishmentZone == nil then log("Banishment Zone is nil.") return end
if mainDeckZone == nil then log("Main Deck Zone is nil.") return end
if graveyardZone == nil then log("Graveyard Zone is nil.") return end
if tokensZone == nil then log("Tokens Zone is nil.") return end
if materialDeckZone == nil then log("Material Deck Zone is nil.") return end
if sideDeckZone == nil then log("Side Deck Zone is nil.") return end

myPlayer.showConfirmDialog("Reset your placespace?",
  function (player_color)
    for _, obj in pairs(fieldZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end
  
    for _, obj in pairs(memoryZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end
  
    for _, obj in pairs(banishmentZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end
  
    for _, obj in pairs(mainDeckZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end

    for _, obj in pairs(graveyardZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end
  
    for _, obj in pairs(materialDeckZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end
  
    for _, obj in pairs(sideDeckZone.getObjects()) do
      if obj.type == "Card" or obj.type == "Deck" then
        destroyObject(obj)
      end
    end

    for _, obj in pairs(myPlayer.getHoldingObjects()) do
      destroyObject(obj)
    end

  end)

end

function toggleMagnets()

snapPoints = getNewSnapPoints()

if fieldMagnets then
  broadcastToColor("Added Magnets to Field", myPlayer.color, {255, 255, 255})
  addFieldMagnets(snapPoints)
else
  broadcastToColor("Removed Magnets from Field", myPlayer.color, {255, 255, 255})
end

fieldMagnets = not fieldMagnets
addMemoryMagnets(snapPoints)
self.setSnapPoints(snapPoints)

end

function addFieldMagnets(snapPoints)
-- Field Snap Points
fieldRow = {}
fieldRow[1] = 0
fieldRow[2] = fieldRow[1] - 0.185
fieldRow[3] = fieldRow[2] - 0.185
fieldRow[4] = fieldRow[3] - 0.185
fieldRow[5] = fieldRow[4] - 0.185
fieldCardSpacing = 0.175
for _, row in ipairs(fieldRow) do
  for i=-6, 6 do
    snapPoints[#snapPoints + 1] = { position = {fieldCardSpacing*i,0,row},
                                    rotation = {0,0,0},
                                    rotation_snap = false,
                                    tags = {"Card"}
                                  }
  end
end

return snapPoints
end

function addMemoryMagnets(snapPoints)
-- Memory Snap Points
memoryRow = {}
memoryRow[1] = 0.475
memoryRow[2] = memoryRow[1] + 0.185
memoryCardSpacing = 0.135
for _, row in ipairs(memoryRow) do
  for i=-8, 8 do
    snapPoints[#snapPoints + 1] = { position = {memoryCardSpacing*i,0,row},
                                    rotation = {0,0,0},
                                    rotation_snap = true,
                                    tags = {"Card"}
                                  }
  end
end

return snapPoints
end

function getNewSnapPoints()
return {
  -- Tokens
  { position = { (zones.tokens.x / self.getScale().x), 0, (zones.tokens.z / self.getScale().z) },
    rotation = {0,270,0},
    rotation_snap = true
  },
  -- Material Deck
  { position = { (zones.materialDeck.x / self.getScale().x), 0, (zones.materialDeck.z / self.getScale().z) },
    rotation = {0,0,0},
    rotation_snap = true
  },
  -- Side Deck
  { position = { (zones.sideboard.x / self.getScale().x), 0, (zones.sideboard.z / self.getScale().z) },
    rotation = {0,0,0},
    rotation_snap = true
  },
  -- Banishment
  { position = { (zones.banishment.x / self.getScale().x), 0, (zones.banishment.z / self.getScale().z) },
    rotation = {0,90,0},
    rotation_snap = true
  },
  -- Main Deck
  { position = { (zones.mainDeck.x / self.getScale().x), 0, (zones.mainDeck.z / self.getScale().z) },
    rotation = {0,0,0},
    rotation_snap = true
  },
  -- Graveyard
  { position = { (zones.graveyard.x / self.getScale().x), 0, (zones.graveyard.z / self.getScale().z) },
    rotation = {0,0,0},
    rotation_snap = true
  }
}
end

function toggleTrustOthers()
if trustOthers then
  broadcastToColor("Hid Counter Buttons to Opponents", myPlayer.color, {255, 255, 255})
  self.UI.setAttribute(string.lower(myPlayer.color) .. "DamageTakenCounterButtons", "visibility", myPlayer.color)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "BanishmentCardCounterButtons", "visibility", myPlayer.color)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "DrawCounterButton1", "visibility", myPlayer.color)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "DrawCounterButton2", "visibility", myPlayer.color)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardFloatingCardCounterButton1", "visibility", myPlayer.color)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardFloatingCardCounterButton2", "visibility", myPlayer.color)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardCardCounterButtons", "visibility", myPlayer.color)

else
  broadcastToColor("Revealed Counter Buttons to Opponents", myPlayer.color, {255, 255, 255})
  self.UI.setAttribute(string.lower(myPlayer.color) .. "DamageTakenCounterButtons", "visibility", "")
  self.UI.setAttribute(string.lower(myPlayer.color) .. "BanishmentCardCounterButtons", "visibility", "")
  self.UI.setAttribute(string.lower(myPlayer.color) .. "DrawCounterButton1", "visibility", "")
  self.UI.setAttribute(string.lower(myPlayer.color) .. "DrawCounterButton2", "visibility", "")
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardFloatingCardCounterButton1", "visibility", "")
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardFloatingCardCounterButton2", "visibility", "")
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardCardCounterButtons", "visibility", "")
end

trustOthers = not trustOthers
end

function updateDamageTakenCounter()
self.UI.setValue(string.lower(myPlayer.color) .. "DamageTakenCounter", damageTakenCounterCount .. " Damage")
self.UI.setValue(string.lower(myPlayer.color) .. "DamageTakenCounterOpposite", damageTakenCounterCount .. " Damage")
end

function incrementDamageTakenCounter()
if damageTakenCounterCount >= 999 then return end
damageTakenCounterCount = damageTakenCounterCount + 1
updateDamageTakenCounter()
end

function decrementDamageTakenCounter()
if damageTakenCounterCount <= 0 then return end
damageTakenCounterCount = damageTakenCounterCount - 1
updateDamageTakenCounter()
end

function clearDamageTakenCounter()
damageTakenCounterCount = 0
updateDamageTakenCounter()
end

function updateBanishmentCardCounter()
if banishmentCardCounterCount == 1 then
  self.UI.setValue(string.lower(myPlayer.color) .. "BanishmentCardCounter", "1 Card")
  self.UI.setValue(string.lower(myPlayer.color) .. "BanishmentCardCounterOpposite", "1 Card")
else
  self.UI.setValue(string.lower(myPlayer.color) .. "BanishmentCardCounter", banishmentCardCounterCount .. " Cards")
  self.UI.setValue(string.lower(myPlayer.color) .. "BanishmentCardCounterOpposite", banishmentCardCounterCount .. " Cards")
end
end

function incrementBanishmentCardCounter()
if banishmentCardCounterCount >= 999 then return end
banishmentCardCounterCount = banishmentCardCounterCount + 1
updateBanishmentCardCounter()
end

function decrementBanishmentCardCounter()
if banishmentCardCounterCount <= 0 then return end
banishmentCardCounterCount = banishmentCardCounterCount - 1
updateBanishmentCardCounter()
end

function clearBanishmentCardCounter()
banishmentCardCounterCount = 0
updateBanishmentCardCounter()
end

function toggleVisibilityBanishmentCardCounter()
if banishmentCardCounterRevealed then
  broadcastToColor("Hid Banishment Card Counter", myPlayer.color, {255, 255, 255})
  self.UI.setAttribute(string.lower(myPlayer.color) .. "BanishmentCardCounterPanel", "visibility", playerVisibilities.mySide.invisible)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "BanishmentCardCounterPanelOpposite", "visibility", playerVisibilities.oppositeSide.invisible)
else
  broadcastToColor("Revealed Banishment Card Counter", myPlayer.color, {255, 255, 255})
  self.UI.setAttribute(string.lower(myPlayer.color) .. "BanishmentCardCounterPanel", "visibility", playerVisibilities.mySide.visible)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "BanishmentCardCounterPanelOpposite", "visibility", playerVisibilities.oppositeSide.visible)
end

banishmentCardCounterRevealed = not banishmentCardCounterRevealed
end

function updateDrawCounter()
self.UI.setValue(string.lower(myPlayer.color) .. "DrawCounter", drawCounterCount .. "\nDrawn")
self.UI.setValue(string.lower(myPlayer.color) .. "DrawCounterOpposite", drawCounterCount .. "\nDrawn")
end

function incrementDrawCounter()
if drawCounterCount >= 999 then return end
drawCounterCount = drawCounterCount + 1
updateDrawCounter()
end

function decrementDrawCounter()
if drawCounterCount <= 0 then return end
drawCounterCount = drawCounterCount - 1
updateDrawCounter()
end

function clearDrawCounter()
drawCounterCount = 0
updateDrawCounter()
end

function updateGraveyardFloatingCardCounter()
self.UI.setValue(string.lower(myPlayer.color) .. "GraveyardFloatingCardCounter", graveyardFloatingCardCounterCount .. "\nFloating")
self.UI.setValue(string.lower(myPlayer.color) .. "GraveyardFloatingCardCounterOpposite", graveyardFloatingCardCounterCount .. "\nFloating")
end

function incrementGraveyardFloatingCardCounter()
if graveyardFloatingCardCounterCount >= 999 then return end
graveyardFloatingCardCounterCount = graveyardFloatingCardCounterCount + 1
updateGraveyardFloatingCardCounter()
end

function decrementGraveyardFloatingCardCounter()
if graveyardFloatingCardCounterCount <= 0 then return end
graveyardFloatingCardCounterCount = graveyardFloatingCardCounterCount - 1
updateGraveyardFloatingCardCounter()
end

function updateGraveyardCardCounter()
if graveyardCardCounterCount == 1 then
  self.UI.setValue(string.lower(myPlayer.color) .. "GraveyardCardCounter", "1 Card")
  self.UI.setValue(string.lower(myPlayer.color) .. "GraveyardCardCounterOpposite", "1 Card")
else
  self.UI.setValue(string.lower(myPlayer.color) .. "GraveyardCardCounter", graveyardCardCounterCount .. " Cards")
  self.UI.setValue(string.lower(myPlayer.color) .. "GraveyardCardCounterOpposite", graveyardCardCounterCount .. " Cards")
end
end

function incrementGraveyardCardCounter()
if graveyardCardCounterCount >= 999 then return end
graveyardCardCounterCount = graveyardCardCounterCount + 1
updateGraveyardCardCounter()
end

function decrementGraveyardCardCounter()
if graveyardCardCounterCount <= 0 then return end
graveyardCardCounterCount = graveyardCardCounterCount - 1
updateGraveyardCardCounter()
end

function clearGraveyardCardCounter()
graveyardCardCounterCount = 0
updateGraveyardCardCounter()
end

function toggleVisibilityGraveyardCardCounter()
if graveyardCardCounterRevealed then
  broadcastToColor("Hid Banishment Card Counter", myPlayer.color, {255, 255, 255})
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardCardCounterPanel", "visibility", playerVisibilities.mySide.invisible)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardCardCounterPanelOpposite", "visibility", playerVisibilities.oppositeSide.invisible)
else
  broadcastToColor("Revealed Banishment Card Counter", myPlayer.color, {255, 255, 255})
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardCardCounterPanel", "visibility", playerVisibilities.mySide.visible)
  self.UI.setAttribute(string.lower(myPlayer.color) .. "GraveyardCardCounterPanelOpposite", "visibility", playerVisibilities.oppositeSide.visible)
end

graveyardCardCounterRevealed = not graveyardCardCounterRevealed
end

function payOneMemoryCard()

if memoryZone == nil then log("Memory Zone is nil.") return end

local memoryCards = 0
local memoryCheck = 0

if (memoryZone.getObjects()) != nil then
  memoryCards = #memoryZone.getObjects()-1
  randomCard = math.random(memoryCards)

  for _,item in ipairs(memoryZone.getObjects()) do
    if item.tag == "Card" then
      memoryCheck = memoryCheck + 1
      if memoryCheck == randomCard then
        rotation = self.getRotation()
        item.setPositionSmooth(banishmentZone.getPosition())
        item.setRotationSmooth({rotation.x,zones.banishment.rot,rotation.z})
      end
    end
  end
end
end

function revealRandomMemoryCard()

if memoryZone == nil then log("Memory Zone is nil.") return end

local memoryCards = 0
local memoryCheck = 0

if (memoryZone.getObjects()) != nil then
  memoryCards = #memoryZone.getObjects()-1
  randomCard = math.random(memoryCards)

  for _,item in ipairs(memoryZone.getObjects()) do
    if item.tag == "Card" then
      memoryCheck = memoryCheck + 1
      if memoryCheck == randomCard then
        item.flip()
      end
    end
  end
end
end

function recollectMemory()

if memoryZone == nil then log("Memory Zone is nil.") return end

if (memoryZone.getObjects()) != nil then
  for _,item in ipairs(memoryZone.getObjects()) do
    if item.tag == "Card" then
      item.deal(1,myPlayer.color)
    end
  end
end

end

function hideMemoryButtons()

  memoryButtonsVisible = not memoryButtonsVisible

  if memoryButtonsVisible then
    self.UI.show(string.lower(myPlayer.color) .. "MemoryButtons")
  else
    self.UI.hide(string.lower(myPlayer.color) .. "MemoryButtons")
  end

end

function spawnZones()
  boardPos = self.getPosition()

  fieldZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.field.x * mod),
      2,
      boardPos.z + (zones.field.z * mod)
    },
    rotation          = self.getRotation(),
    scale             = {30,2,15},
    sound             = false,
    snap_to_grid      = false,
  })

  memoryZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.memory.x * mod),
      2,
      boardPos.z - (zones.memory.z * mod)
    },
    rotation          = self.getRotation(),
    scale             = {30,2,10},
    sound             = false,
    snap_to_grid      = false,
  })

  graveyardZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.graveyard.x * mod),
      2,
      boardPos.z + (zones.graveyard.z * mod)
    },
    rotation          = self.getRotation(),
    scale             = {4,2,5},
    sound             = false,
    snap_to_grid      = false,
  })

  mainDeckZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.mainDeck.x * mod),
      2,
      boardPos.z + (zones.mainDeck.z * mod)
    },
    rotation          = self.getRotation(),
    scale             = {4,2,5},
    sound             = false,
    snap_to_grid      = false,
  })

  banishmentZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.banishment.x * mod),
      2,
      boardPos.z + (zones.banishment.z * mod)
    },
    rotation          = {x = self.getRotation().x, y = zones.banishment.rot, z = self.getRotation().z},
    scale             = {4,2,5},
    sound             = false,
    snap_to_grid      = false,
  })

  tokensZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.tokens.x * mod),
      2,
      boardPos.z + (zones.tokens.z * mod)
    },
    rotation          = {x = self.getRotation().x, y = zones.tokens.rot, z = self.getRotation().z},
    scale             = {4,2,5},
    sound             = false,
    snap_to_grid      = false,
  })

  materialDeckZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.materialDeck.x * mod),
      2,
      boardPos.z + (zones.materialDeck.z * mod)
    },
    rotation          = self.getRotation(),
    scale             = {4,2,5},
    sound             = false,
    snap_to_grid      = false,
  })

  sideDeckZone = spawnObject({
    type              = 'ScriptingTrigger',
    position          = {
      boardPos.x + (zones.sideboard.x * mod),
      2,
      boardPos.z + (zones.sideboard.z * mod)
    },
    rotation          = self.getRotation(),
    scale             = {4,2,5},
    sound             = false,
    snap_to_grid      = false,
  })

end

function onLoad()

--Prevent ALT Interaction
self.interactable = false

--Developer Use Only
self.addContextMenuItem("Spawn Zones", spawnZones)
spawnZones()

snapPoints = getNewSnapPoints()
addFieldMagnets(snapPoints)
addMemoryMagnets(snapPoints)
self.setSnapPoints(snapPoints)
end