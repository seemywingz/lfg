local addonName, lfg = ...

lfg.defaults = {

  linkColor = "cffffc0c0",

  channel = {
    ["1"] = true,
    ["2"] = false,
    ["3"] = false,
    ["4"] = true,
    ["5"] = false,
    ["6"] = false
  },

  channelNames = {
    "1. General",
    "2. Trade",
    "3. Local Defense",
    "4. Looking For Group",
    "5. World Defense",
    "6. Cuild Recruitment"
  },

  searchTypes = {
    "LF",
    "lf",
  },

  searchCrit = {
    "HEAL",
    "heal",
    "Heal",
    "TANK",
    "tank",
    "Tank",
    "DPS",
    "dps"
  },

  locations = {
    "RFC",
    "rfc",
    "SFK",
    "sfk",
    "WC",
    "wc"
  }

}
LFGSettings = LFGSettings or lfg.defaults

function lfg.handleChatEvent(...)
  local msg, fromPlayer, _, eventChan = ...
  print("Chat Message: "..eventChan)

  for channel,listening in pairs(LFGSettings.channel) do
    if eventChan:find(channel) and listening then
      lfg.parseMSG(msg, fromPlayer)
    end
  end

end

-- Parse the message to see if they meet our search criteria
function lfg.parseMSG(msg, fromPlayer)
 
  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local searchType, searchCrit, location = "", "", ""
  print(playerLink.." "..msg)

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


