local addonName, lfg = ...

LFGSettings = {}
LFGSettings.linkColor = "cffffc0c0"
LFGSettings.channels = {
  "4. LookingForGroup"
}

LFGSettings.searchTypes = {
  "LF",
  "lf",
}

LFGSettings.searchCrit = {
  "HEAL",
  "heal",
  "Heal",
  "TANK",
  "tank",
  "Tank",
  "DPS",
  "dps"
}

LFGSettings.locations = {
  "RFC",
  "rfc",
  "SFK",
  "sfk",
  "WC",
  "wc"
}

function lfg.handleChatEvent(...)
  local msg, fromPlayer, _, eventChan = ...
 
  for k,channel in pairs(LFGSettings.channels) do
    if eventChan == channel then
      lfg.parseMSG(msg, fromPlayer)      
    end
  end
  
end

-- Parse the message to see if they meet our search criteria
function lfg.parseMSG(msg, fromPlayer)
 
  local tokens = {}
  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local searchType, searchCrit, location = "", "", ""

  for _,s in pairs(LFGSettings.searchTypes) do
    if msg:find(s) then
      searchType = s
      break
    end
  end

  for _,s in pairs(LFGSettings.searchCrit) do
    if msg:find(s) then
      searchCrit = s
      break
    end
  end

  for _,s in pairs(LFGSettings.locations) do
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


