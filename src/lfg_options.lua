local addonName, lfg = ...

local uniquealyzer = 1;
function lfg.createTitle(parent, text, point, relFrame, relPoinit)
  uniquealyzer = uniquealyzer + 1;
  local fs = parent:CreateFontString("LFG_PANEL_TITLE"..uniquealyzer, "ARTWORK", "GameFontNormalLarge")
  fs:SetPoint(point, relFrame, relPoinit, 0, -10)
  fs:SetText(text)
  return fs
end

function lfg.createCheckBox(parent, text, point, relFrame, relPoinit, onClick)
  uniquealyzer = uniquealyzer + 1;
  local globalName = "FL_CHECKBOX_"..uniquealyzer
  local cb = CreateFrame("CheckButton", globalName, parent, "ChatConfigCheckButtonTemplate") --frameType, frameName, frameParent, frameTemplate    
  _G[globalName.."Text"]:SetText(text)
  cb:SetPoint(point, relFrame, relPoinit)
  cb:SetScript("OnClick", onClick)
  return cb
end

function lfg.createEditBox(parent, text, point, relFrame, relPoint)
  uniquealyzer = uniquealyzer + 1
  local eb = CreateFrame("EditBox", "LFG_EDITBOX_"..uniquealyzer, parent, "InputBoxTemplate")
  eb:SetSize(200, 40)
  eb:SetPoint(point, relFrame, relPoint)
  eb:SetAutoFocus(false)
  eb:SetText(text)
  eb:SetCursorPosition(0)
  return eb
end

function lfg.getChannels()

  local channels = {}
  for i = 1, LFGSettings.maxChannels do
    local id, chanName = GetChannelName(i);
    if (id > 0 and chanName ~= nil) then
      channels[id] = chanName
    end
  end
  return channels
  
end

function lfg.createButton(parent, text, point, relFrame, relPoinit, onClick)
  uniquealyzer = uniquealyzer + 1
  local btn = CreateFrame("Button", "LFG_BTN_"..uniquealyzer, parent, "UIPanelButtonTemplate")
  btn:SetText(text)
  btn:SetPoint(point, relFrame, relPoinit)
  btn:SetScript("OnClick", onClick) 
  return btn
end

function lfg.refresh()
  lfg.removeInterfaceOptions(addonName, false)
  InterfaceOptionsFrame_Show() 
  lfg.loadOptions()
  InterfaceOptionsFrame_OpenToCategory(addonName);
  InterfaceOptionsFrame_OpenToCategory(addonName);
end


function lfg.loadOptions()

  lfg.panel = CreateFrame("Frame");
  lfg.panel.name = addonName
  InterfaceOptions_AddCategory(lfg.panel);
  
  lfg.panel.title = lfg.panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  lfg.panel.title:SetPoint("TOPLEFT", 16, -16)
  lfg.panel.title:SetText(lfg.panel.name.." "..LFGSettings.version)
  
  -- Enabled Check Box
  lfg.panel.enabledCB = lfg.createCheckBox(lfg.panel, "Enabled", "TOPLEFT", lfg.panel.title, "BOTTOMLEFT", function(self)
    LFGSettings.enabled = self:GetChecked()
  end)
  lfg.panel.enabledCB:SetChecked(LFGSettings.enabled)

  -- Channel Selction Check Boxes
  lfg.panel.chanCheckBox = {}
  lfg.panel.chanCheckBoxTitle = lfg.createTitle(lfg.panel, "Listen to Channel:", "TOPLEFT", lfg.panel.enabledCB, "BOTTOMLEFT")
  local relFrame = lfg.panel.chanCheckBoxTitle
  
  for chanNum,chanName in pairs(lfg.getChannels()) do
      LFGSettings.channel[chanNum] = LFGSettings.channel[chanNum] or false
      local cb = lfg.createCheckBox(lfg.panel, chanNum..". "..chanName, "TOPLEFT", relFrame, "BOTTOMLEFT", function(self)
        LFGSettings.channel[chanNum] = self:GetChecked()
      end)
      cb:SetChecked(LFGSettings.channel[chanNum])
      table.insert(lfg.panel.chanCheckBox, cb)
      relFrame = cb
  end

  -- Criteria 
  lfg.panel.critEB = {}
  lfg.panel.critTitle = lfg.createTitle(lfg.panel, "Match Criteria: ", "TOPLEFT", relFrame, "BOTTOMLEFT")
 
  lfg.panel.critAddBTN = lfg.createButton(lfg.panel, "+", "LEFT", lfg.panel.critTitle, "RIGHT", function()
    table.insert(LFGSettings.criteria, {"New", "Criteria"})
    lfg.refresh()
  end)
  lfg.panel.critAddBTN:SetSize(20 ,22) -- width, height

  lfg.panel.critRemoveBTN = lfg.createButton(lfg.panel, "-", "LEFT", lfg.panel.critAddBTN, "RIGHT", function()
    table.RemoveLast(LFGSettings.criteria)
    lfg.refresh()
  end)
  lfg.panel.critRemoveBTN:SetSize(20 ,22) -- width, height

  relFrame = lfg.panel.critTitle
  for i,crit in ipairs(LFGSettings.criteria) do
    local title = lfg.createTitle(lfg.panel, "  "..i..":  ", "TOPLEFT", relFrame, "BOTTOMLEFT")
    local eb = lfg.createEditBox(lfg.panel, table.ToString(LFGSettings.criteria[i]), "LEFT", title, "RIGHT")
    table.insert(lfg.panel.critEB, eb)
    relFrame = title
  end

  -- Auto Whisper Check Box
  lfg.panel.autoTitle = lfg.createTitle(lfg.panel, "Auto Response:", "TOPLEFT", relFrame, "BOTTOMLEFT")
  lfg.panel.whisperCB = lfg.createCheckBox(lfg.panel, "Whisper:", "TOPLEFT", lfg.panel.autoTitle, "BOTTOMLEFT", function(self)
    LFGSettings.autoWhisper = self:GetChecked()
  end)
  lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
  lfg.panel.whisperEditBox = lfg.createEditBox(lfg.panel, LFGSettings.whisperText, "LEFT", lfg.panel.whisperCB, "RIGHT")
  lfg.panel.whisperEditBox:SetPoint("LEFT", lfg.panel.whisperCB, "RIGHT", 80, 0)

  lfg.panel.inviteCB = lfg.createCheckBox(lfg.panel, "Invite", "TOPLEFT", lfg.panel.whisperCB, "BOTTOMLEFT", function(self)
    LFGSettings.autoInvite = self:GetChecked()
  end)
  lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)

  
  lfg.panel.saveBTN = lfg.createButton(lfg.panel, "Save", "TOPLEFT", lfg.panel.inviteCB, "BOTTOMLEFT", function()
    lfg.panel.okay()
    print("LFG Configs Saved!")
  end)
  lfg.panel.saveBTN:SetSize(80 ,22) -- width, height

  -- Panel Event Callbacks
  function lfg.panel.okay()

      for i,eb in ipairs(lfg.panel.critEB) do
        LFGSettings.criteria[i] = eb:GetText():ToTable()
      end
      LFGSettings.whisperText = lfg.panel.whisperEditBox:GetText()

  end

  function lfg.panel.default()
      LFGSettings = lfg.defaults
      lfg.refresh()
  end

  function lfg.panel.refresh()

      lfg.panel.enabledCB:SetChecked(LFGSettings.enabled)

      for i,cb in ipairs(lfg.panel.chanCheckBox) do
        cb:SetChecked(LFGSettings.channel[i])
      end

      for i,eb in ipairs(lfg.panel.critEB) do
        eb:SetText(table.ToString(LFGSettings.criteria[i]))
      end
  
      lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)
      lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
      lfg.panel.whisperEditBox:SetText(LFGSettings.whisperText)
    
  end
  
end


function lfg.removeInterfaceOptions(frameName, bParent)
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