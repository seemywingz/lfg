local addonName, ns = ...

-- String Helpers
function string:FindI(pattern)
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

function string:ToTable()
  local t = {}
  for word in self:gmatch("%w+") do 
    table.insert(t, word) 
  end
  return t or {}
end

function ns.combineCriteria(t)
  return strjoin(" ", unpack(t))
end

-- Interface Addon UI Components
local uniquealyzer = 1;
function ns.createTitle(parent, text, point, relFrame, relPoinit)
  uniquealyzer = uniquealyzer + 1;
  local fs = parent:CreateFontString(addonName.."_PANEL_TITLE_"..uniquealyzer, "ARTWORK", "GameFontNormalLarge")
  fs:SetPoint(point, relFrame, relPoinit, 0, -10)
  fs:SetText(text)
  return fs
end

function ns.createCheckBox(parent, text, point, relFrame, relPoinit, onClick)
  uniquealyzer = uniquealyzer + 1;
  local globalName = addonName.."_CHECKBOX_"..uniquealyzer
  local cb = CreateFrame("CheckButton", globalName, parent, "ChatConfigCheckButtonTemplate") --frameType, frameName, frameParent, frameTemplate    
  _G[globalName.."Text"]:SetText(text)
  cb:SetPoint(point, relFrame, relPoinit)
  cb:SetScript("OnClick", onClick)
  return cb
end

function ns.createEditBox(parent, text, point, relFrame, relPoint)
  uniquealyzer = uniquealyzer + 1
  local eb = CreateFrame("EditBox", addonName.."_EDITBOX_"..uniquealyzer, parent, "InputBoxTemplate")
  eb:SetSize(200, 40)
  eb:SetPoint(point, relFrame, relPoint)
  eb:SetAutoFocus(false)
  eb:SetText(text)
  eb:SetCursorPosition(0)
  return eb
end

function ns.createButton(parent, text, point, relFrame, relPoinit, onClick)
  uniquealyzer = uniquealyzer + 1
  local btn = CreateFrame("Button", addonName.."_BTN_"..uniquealyzer, parent, "UIPanelButtonTemplate")
  btn:SetText(text)
  btn:SetPoint(point, relFrame, relPoinit)
  btn:SetScript("OnClick", onClick) 
  return btn
end

function ns.createSlider(parent, sliderMin, sliderMax, value, valueStep, text, point, relFrame, relPoinit, callBack)
  uniquealyzer = uniquealyzer + 1
  local slider = CreateFrame("Slider", addonName.."_SLIDER_" .. uniquealyzer, parent, "OptionsSliderTemplate")
  slider:SetEnabled(true)
  slider:Show()
  slider:SetWidth(200)
  slider:SetHeight(30)
  slider:SetPoint(point, relFrame, relPoinit, 0 , -20)
  slider:SetOrientation('HORIZONTAL')
  slider:SetValue(value)
  slider:SetValueStep(valueStep)
  slider:SetMinMaxValues(sliderMin,sliderMax);
  -- slider.tooltipText = toolTip --Creates a tooltip on mouseover.
  getglobal(slider:GetName() .. 'Low'):SetText(sliderMin); --Sets the left-side slider text (default is "Low").
  getglobal(slider:GetName() .. 'High'):SetText(sliderMax); --Sets the right-side slider text (default is "High").
  getglobal(slider:GetName() .. 'Text'):SetText(text .. ": " .. value); --Sets the "title" text (top-centre of slider).
  slider:SetScript("OnValueChanged", callBack)
  return slider
end


function ns.getChannels()

  local channels = {}
  local maxChannels = 10
  for i = 1, maxChannels do
    local id, chanName = GetChannelName(i);
    if (id > 0 and chanName ~= nil) then
      channels[id] = chanName
    end
  end
  return channels
  
end

function ns.removeInterfaceOptions(frameName, bParent)
  -- Ensure that the variables passed are valid
  assert(type(frameName) == "string" and (type(bParent) == "boolean" or bParent == nil), 'Syntax: RemoveInterfaceOptions(frameName[, bParent])');
  
  -- Setup local variables
  local removeList = {};
  local nextFreeArraySpace = 1;
  
  -- If the name given is NOT a parent frame
  if not(bParent) then
      -- Add this frame to the list to be deleted
      removeList[frameName] = true;
  end
  
  -- Loop though Bliz's Interface Options Frames looking for the frames to remove
  for i=1, #INTERFACEOPTIONS_ADDONCATEGORIES do
      -- Store this Interface frame
      local v = INTERFACEOPTIONS_ADDONCATEGORIES[i];
      
      -- Check if this is the frame we want to remove or if bParent
      -- the child of the want we want to remove
      -- or just one we want to keep
      if (removeList[v.name] or (bParent and v.parent == frameName)) or (bParent and removeList[v.parent]) then
          -- Wipe this frame from the array by making it 'true'
          removeList[v.name] = true;
      else
          -- We want to keep this frame so move it up the array
          -- to remove any holes caused by the deleted frames
          INTERFACEOPTIONS_ADDONCATEGORIES[nextFreeArraySpace] = INTERFACEOPTIONS_ADDONCATEGORIES[i];
          nextFreeArraySpace = nextFreeArraySpace + 1;
      end;
  end;
  
  -- Loop though all of the interface frames after the last good one removing them
  for i=nextFreeArraySpace, #INTERFACEOPTIONS_ADDONCATEGORIES do
      INTERFACEOPTIONS_ADDONCATEGORIES[i] = nil;
  end;
  
  -- Tell Bliz's interface frame to update now to reflect the removed frames
  InterfaceAddOnsList_Update();
end

function ns.refreshInterfaceOptions(callBack)
  ns.removeInterfaceOptions(addonName, false)
  InterfaceOptionsFrame_Show() 
  callBack()
  InterfaceOptionsFrame_OpenToCategory(addonName);
  InterfaceOptionsFrame_OpenToCategory(addonName);
end

function ns.shoPopUp(text, timeout, btn1, btn2, btn3, acceptCB, cancelCB, altCB, hideOnEscape)
  uniquealyzer = uniquealyzer + 1;
  local popupName = addonName .. "_POPUP_ALERT_" .. uniquealyzer
  StaticPopupDialogs[popupName] = {
    text = text,
    button1 = btn1,
    button2 = btn2,
    button3 = btn3,
    OnAccept = acceptCB,
    OnCancel = cancelCB,
    OnAlt = altCB,
    timeout = timeout,
    whileDead = true,
    hideOnEscape = hideOnEscape,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
  }
  StaticPopup_Show (popupName)
end

-- Example Login Event
-- function events:PLAYER_LOGIN(...) -- Player is Logged In
--   print("LFG Loaded: /lfg help")
--   local current = GetAddOnMetadata(addonName, "Version")
--   if LFGSettings.version ~= 1 then
--     -- Make sure to load Defaults when updating
--     print("LFG Updating Defaults to Release: "..current)
--     LFGSettings = lfg.defaults
--   end
--   lfg.loadOptions()
-- end