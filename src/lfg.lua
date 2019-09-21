local addonName, lfg = ...

lfgSettings = {}
lfgSettings.channels = {
  "4. LookingForGroup"
}

lfgSettings.searchTypes = {
  "LFG",
  "lfg",
  "LFM",
  "lfm",
  "LF1M",
  "LF2M",
  "lf1m",
  "lf2m",
  "LF",
  "lf"
}

lfgSettings.searchCrit = {
  "HEALS",
  "heals",
  "Heals",
  "healer",
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

lfgSettings.classes = {
  "rouge",
  "shamen",
  "mage",
  "warlock",
  "warrior",
  "palidan",
  "priest",
  "hunter"
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
  local playerLink = "|cffffc0c0|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local searchType, searchCrit, location = "", "", ""
  print(playerLink.." "..msg)

  -- parse tokens by whitespace
  for token in string.gmatch(msg, "[^%s]+") do
    table.insert(tokens, token)    
  end
  
  -- Evaluate tokens
  for _,token in pairs(tokens) do

    -- check is the message meest our search type
    for k,st in pairs(lfgSettings.searchTypes) do
      if token == st then
        searchType = st
      end
    end

    -- check is the message meest our search criteria
    for k,sc in pairs(lfgSettings.searchCrit) do
      if token == sc then
        searchCrit = sc
      end
    end

    -- check is the message meest our search criteria
    for k,l in pairs(lfgSettings.locations) do
      if token == l then
        location = l
      end
    end

  end

  if searchType ~= "" and searchCrit ~= "" and location ~= "" then
    PlaySound(SOUNDKIT.READY_CHECK)
  end
  
end


