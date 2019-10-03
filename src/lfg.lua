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
  autoPostTicker = C_Timer.NewTicker(999, function(args)
    print("Auto Post Ticker")
  end, 0),


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

function lfg.handleChatEvent(...)
  if not LFGSettings.enabled  then return value  end
  local msg, fromPlayer, _, eventChannel = ...

  for channelNumber, listening in pairs(LFGSettings.channel) do
    if eventChannel:find(channelNumber) and listening then
      lfg.parseMSG(msg, fromPlayer, channelNumber)
    end
  end

end

-- Parse the message to see if it meets our search criteria
function lfg.parseMSG(msg, fromPlayer, channelNumber)
 
  local matches = {}
  local minCriteria = 0

  -- chat event returns "playername-servername", so we split on `-` and take the first value
  local playerName = fromPlayer:Split("-")[1] 
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
    local inviteCB = function()
      print("Inviting", playerName)
      InviteUnit(playerName)
    end
    lfg.shoPopUp(playerLink.." "..msg, "Whisper", "Invite", "Ignore", whisperCB, inviteCB)

    if LFGSettings.autoWhisper then
      whisperCB()
    end
    
    if LFGSettings.autoInvite then
      inviteCB()
    end
    
  end
  
end

local uniquealyzer = 0;
function lfg.shoPopUp(text, btn1, btn2, btn3, accept, cancel, hide )
  uniquealyzer = uniquealyzer + 1;
  local popupName = addonName .. "POPUP_ALERT_" .. uniquealyzer
  StaticPopupDialogs[popupName] = {
    text = text,
    button1 = btn1,
    button2 = btn2,
    button3 = btn3,
    OnAccept = accept,
    OnCancel = cancel,
    OnHide = hide,
    timeout = 30,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
  }
  StaticPopup_Show (popupName)
end
