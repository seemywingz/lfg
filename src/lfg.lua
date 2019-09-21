local addonName, lfg = ...

lfgSettings = {}
lfgSettings.linlColor = "cffffc0c0"
lfgSettings.channels = {
  "4. LookingForGroup"
}

lfgSettings.searchTypes = {
  "LF",
  "lf",
}

lfgSettings.searchCrit = {
  "HEAL",
  "heal",
  "Heal",
  "TANK",
  "tank",
  "Tank",
  "DPS",
  "dps"
}

lfgSettings.locations = {
  "RFC",
  "rfc",
  "SFK",
  "sfk",
  "ULD",
  "uld",
  "WC",
  "wc",
  "mara",
  "MARA"
}

function lfg.handleChatEvent(...)
  local msg, fromPlayer, _, eventChan = ...
 
  for k,channel in pairs(lfgSettings.channels) do
    if eventChan == channel then
      lfg.parseMSG(msg, fromPlayer)      
    end
  end
  
end

-- Parse the message to see if they meet our search criteria
function lfg.parseMSG(msg, fromPlayer)
 
  local tokens = {}
  local playerLink = "|"..lfgSettings.linlColor.."|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local searchType, searchCrit, location = "", "", ""

  for _,s in pairs(lfgSettings.searchTypes) do
    if msg:find(s) then
      searchType = s
      break
    end
  end

  for _,s in pairs(lfgSettings.searchCrit) do
    if msg:find(s) then
      searchCrit = s
      break
    end
  end

  for _,s in pairs(lfgSettings.locations) do
    if msg:find(s) then
      location = s
      break
    end
  end
  
  if searchType ~= "" and searchCrit ~="" and location ~="" then
    PlaySound(SOUNDKIT.READY_CHECK)
    print(playerLink.." "..msg)
  end
  
end


