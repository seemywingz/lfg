local addonName, lfg = ...

-- EVENTS
local frame, events = CreateFrame("Frame"), {};

function events:CHAT_MSG_CHANNEL(...) -- Fired when the client receives a channel message.
  -- print("Chat Message Sent")
  lfg.handleChatEvent(...)
end

function events:PLAYER_LOGIN(...) -- Player is Logged In
  print("LFG Loaded: /lfg help")
  local current = GetAddOnMetadata(addonName, "Version")
  if LFGSettings.version ~= current then
    -- Make sure to load Defaults when updating
    print("LFG Updating Defaults to Release: "..current)
    LFGSettings = lfg.defaults
  end
  lfg.loadOptions()
  lfg.registerMiniMap()
end

-- Register Events Frame to OnEvent handler of Main Frame
frame:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);

-- Register all events for which handlers have been defined above
for k, _ in pairs(events) do
  frame:RegisterEvent(k);
end