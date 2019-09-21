local addonName, lfg = ...

lfg.defaults = {

  linkColor = "cffff00ff",
  autoWhisper = false,

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

  criteria = {
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
 
  local matches = {}
  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local minCriteria = 0
  -- print(playerLink.." "..msg)

  for _,searchCrit in pairs(LFGSettings.criteria) do
    minCriteria = minCriteria + 1
    for _,crit in pairs(searchCrit) do
      if msg:find(crit) then
        table.insert(matches, crit)
        break
      end
    end
  end

  if table.getn(matches) >= minCriteria then
    PlaySound(SOUNDKIT.READY_CHECK)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("["..chanNum.."] "..playerLink.." "..msg)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    -- SendChatMessage("WOOT", "WHISPER", nil, UnitName("player"))
  end
  
end


