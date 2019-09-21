local addonName, lfg = ...

lfg.defaults = {

  linkColor = "cffff00ff",

  channel = {
    ["1"] = true,
    ["2"] = true,
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
    "6. Guild Recruitment"
  },

  searchCrit = {
    ["1"] = {
      "LF",
      "lf"
    },

    ["2"] = {
      "HEAL",
      "heal",
      "Heal",
      "TANK",
      "tank",
      "Tank",
      "DPS",
      "dps",
    },

    ["3"] = {
      "RFC",
      "rfc",
      "rfk",
      "RFK",
      "SFK",
      "sfk",
      "WC",
      "wc",
    }

  }

}
LFGSettings = LFGSettings or lfg.defaults
-- LFGSettings = lfg.defaults

function lfg.handleChatEvent(...)
  local msg, fromPlayer, _, eventChan = ...
  -- print("Chat Message: "..eventChan)

  for channel,listening in pairs(LFGSettings.channel) do
    if eventChan:find(channel) and listening then
      lfg.parseMSG(msg, fromPlayer, channel)
    end
  end

end

-- Parse the message to see if it meets our search criteria
function lfg.parseMSG(msg, fromPlayer, chanNum)
 
  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local searchCrit1, searchCrit2, searchCrit3 = "", "", ""
  -- print(playerLink.." "..msg)

  for _,s in pairs(LFGSettings.searchCrit["1"]) do
    if msg:find(s) then
      searchCrit1 = s
      break
    end
  end

  for _,s in pairs(LFGSettings.searchCrit["2"]) do
    if msg:find(s) then
      searchCrit2 = s
      break
    end
  end

  for _,s in pairs(LFGSettings.searchCrit["3"]) do
    if msg:find(s) then
      searchCrit3 = s
      break
    end
  end
  
  if searchCrit1 ~= "" and searchCrit2 ~="" and searchCrit3 ~="" then
    -- print("Found Possible Group:",playerLink, searchCrit1, searchCrit2, searchCrit3)
    PlaySound(SOUNDKIT.READY_CHECK)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("["..chanNum.."] "..playerLink.." "..msg)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    -- SendChatMessage("WOOT", "WHISPER", nil, UnitName("player"))
  end
  
end


