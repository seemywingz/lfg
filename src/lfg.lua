local addonName, lfg = ...

lfg.defaults = {

  enabled = false,
  autoInvite = false,
  autoWhisper = false,
  linkColor = "cffff00ff",
  whisperText = "I'm Down!",

  channel = {
    [1] = true,
    [2] = true,
    [3] = false,
    [4] = true,
    [5] = false,
    [6] = false
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
    [1] = {
      "LF",
    },

    [2] = {
      "HEALS",
      "TANK",
      "DPS",
    },

    [3] = {
      "BFD",
      "SCHOLO",
      "ULD",
    }

  }

}
LFGSettings = LFGSettings or lfg.defaults

function lfg.toggle()
  if LFGSettings.enabled then
    print(addonName .. " Disabled")
    LFGSettings.enabled = false
  else
    print(addonName .. " Enabled")
    LFGSettings.enabled = true
  end
end


function lfg.handleChatEvent(...)
  if not LFGSettings.enabled  then return value  end
  local msg, fromPlayer, _, eventChannel = ...

  for channelNumber,listening in ipairs(LFGSettings.channel) do
    if eventChannel:find(channelNumber) and listening then
      lfg.parseMSG(msg, fromPlayer, channelNumber)
    end
  end

end

-- Parse the message to see if it meets our search criteria
function lfg.parseMSG(msg, fromPlayer, channelNumber)
 
  local matches = {}
  local minCriteria = 0
  local playerName = fromPlayer:Split("-")[1]
  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..playerName.."|h["..playerName.."]|h|r";
  
  for _,searchCrit in pairs(LFGSettings.criteria) do
    if table.getn(searchCrit) > 0 then minCriteria = minCriteria + 1 end
    for _,crit in pairs(searchCrit) do
      if msg:findI(crit) then
        table.insert(matches, crit)
        break
      end
    end
  end

  if table.getn(matches) >= minCriteria then
    PlaySound(SOUNDKIT.READY_CHECK)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("["..channelNumber.."] "..playerLink.." "..msg)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    if LFGSettings.autoWhisper then
      SendChatMessage(LFGSettings.whisperText, "WHISPER", nil, playerName)
    end
    if LFGSettings.autoInvite then
      InviteUnit(playerName)
    end

  end
  
end

function string:Split(sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(self, "([^"..sep.."]+)") do
      table.insert(t, str)
  end
  return t
end

function string:findI(pattern)
  -- find an optional '%' (group 1) followed by any character (group 2)
  local p = pattern:gsub("(%%?)(.)", function(percent, letter)
    if percent ~= "" or not letter:match("%a") then
      -- if the '%' matched, or `letter` is not a letter, return "as is"
      return percent .. letter
    else
      -- else, return a case-insensitive character class of the matched letter
      return string.format("[%s%s]", letter:lower(), letter:upper())
    end
  end)
  return self:find(p)
end


