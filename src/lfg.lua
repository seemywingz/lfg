local addonName, lfg = ...

lfg.defaults = {

  version = GetAddOnMetadata(addonName, "Version"),
  enabled = false,
  autoInvite = false,
  autoWhisper = false,
  linkColor = "cffff00ff",
  whisperText = "I'm Down!",
  channel = {},
  autoPost = false,
  autoPostDelay = 30,
  autoPostText = "LFG",
  autoPostTicker = {},
  ignoreList = {},


  criteria = {
    [1] = {
      "HEALS",
      "TANK",
      "DPS",
    },

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

function lfg.postInChannels()
  for channel,listening in pairs(LFGSettings.channel) do
    if listening then
      SendChatMessage(LFGSettings.autoPostText, "CHANNEL", nil, channel)
    end
  end
end

function lfg.handleChatEvent(...)
  if not LFGSettings.enabled  then return value  end
  local msg, fromPlayerRealm, _, eventChannel = ...

  local fromPlayer = fromPlayerRealm:Split("-")[1]  -- chat event returns "playername-servername", so we split on `-` and take the first value
  local currentPlayer, realm = UnitName("player")
  if fromPlayer == currentPlayer then return end -- Ignore the Message if sent by the Player

  for i, ignoredPlayer in ipairs(LFGSettings.ignoreList) do
    if fromPlayer == ignoredPlayer   then
      print("LFG Ignored " .. ignoredPlayer)
      return -- don't process messages from ignored players
    end
    
  end
  
  for channelNumber, listening in pairs(LFGSettings.channel) do
    if eventChannel:find(channelNumber) and listening then
      lfg.parseMSG(msg, fromPlayer, channelNumber)
    end
  end

end

-- Parse the message to see if it meets our search criteria
function lfg.parseMSG(msg, playerName, channelNumber)
 
  local matches = {}
  local minCriteria = 0

  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..playerName.."|h["..playerName.."]|h|r";
  
  for _,searchCrit in pairs(LFGSettings.criteria) do
    if table.getn(searchCrit) > 0 then minCriteria = minCriteria + 1 end
    for _,crit in pairs(searchCrit) do
      if msg:FindI(crit) then
        table.insert(matches, crit)
        break
      end
    end
  end

  if table.getn(matches) >= minCriteria then
    PlaySound(SOUNDKIT.READY_CHECK)
    local id, chanName = GetChannelName(channelNumber);

    local whisperCB = function()
      SendChatMessage(LFGSettings.whisperText, "WHISPER", nil, playerName)
    end
    local inviteCB = function(_, _, reason)
      if reason == "clicked" then
        print("Inviting", playerName)
        InviteUnit(playerName)
      end
    end
    local ignoreCB = function(_, _, reason)
      print("LFG Ignoring: " .. playerName)
      table.insert(LFGSettings.ignoreList, playerName)
    end
    lfg.shoPopUp(playerLink.." "..msg, 30, "Whisper", "Invite", "Ignore", whisperCB, inviteCB, ignoreCB)

    -- if LFGSettings.autoWhisper then
    --   whisperCB()
    -- end
    
    if LFGSettings.autoInvite then
      inviteCB(nil,nil,"clicked" )
    end
    
  end
  
end

