local addonName, lfg = ...

function lfg.showHelp()
  print("LFG Usage:")
  print("  Show Help: /lfg help")
  print("  Enable: /lfg enable")
  print("  Disable: /lfg disable")
  print("  Configure: /lfg config")
  print("  Print LFG Info: /lfg info")
end

function lfg.showInfo()
  print("LFG:")
end

-- SLASH COMMANDS
function lfg.commands(msg, editbox)
  -- pattern matching that skips leading whitespace and whitespace between cmd and args
  -- any whitespace at end of args is retained
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
   
  if cmd == "help" then
    lfg.showHelp()
    
  elseif cmd == "info" then
    lfg.showInfo()

  elseif cmd == "config" then
    -- Note: Call this function twice (in a row), 
    -- there is a bug in Blizzard's code which makes the first call (after login or /reload) fail. 
    -- It opens interface options, but not on the addon's interface options, just the default interface options. 
    InterfaceOptionsFrame_OpenToCategory(addonName);
    InterfaceOptionsFrame_OpenToCategory(addonName);  

  elseif cmd == "disable" then
    DisableAddOn(addonName)
    print(addonName .. " Disabled")
    
  elseif cmd == "enable" then
    EnableAddOn(addonName)
    print(addonName .. " Enabled")
    
  -- elseif cmd == "remove" and args ~= "" then
  --   print("removing " .. args)
      
  else
    lfg.showHelp()
  end
end

SLASH_LFG1 = '/lfg'
SlashCmdList["LFG"] = lfg.commands