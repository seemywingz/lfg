local addonName, lfg = ...

-- EVENTS
local frame, events = CreateFrame("Frame"), {};

function events:CHAT_MSG_CHANNEL(...) -- Fired when the client receives a channel message.
  lfg.handleChatEvent(...)
end

function events:VARIABLES_LOADED(...) -- Player is Logged In
  print("LFG Loaded: /lfg help")
  lfg.loadOptions(self)
end

-- Register Events Frame to OnEvent handler of Main Frame
frame:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);

-- Register all events for which handlers have been defined above
for k, _ in pairs(events) do
  frame:RegisterEvent(k);
end