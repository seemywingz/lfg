local addonName, lfg = ...

function lfg.handleChatEvent(...)
  local msg, _, _, channel = ...
  print("Chat Message " .. channel)
end

