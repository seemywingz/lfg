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

function lfg.tableToString(t)
  local s = ""
  for k,v in pairs(t) do
    s = s .." ".. v
  end
  return s
end

function lfg.stringToTable(s)
  local t = {}
  for word in s:gmatch("%w+") do 
    table.insert(t, word) 
  end
  return t or {}
end

function lfg.loadOptions()

  lfg.panel = CreateFrame("Frame");
  lfg.panel.name = addonName
  InterfaceOptions_AddCategory(lfg.panel);
  
  lfg.panel.title = lfg.panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  lfg.panel.title:SetPoint("TOPLEFT", 16, -16)
  lfg.panel.title:SetText(lfg.panel.name)
  
  -- Enabled Check Box
  lfg.panel.enabledCB = lfg.createCheckBox(lfg.panel, "Enabled", "TOPLEFT", lfg.panel.title, "BOTTOMLEFT", function(self)
    LFGSettings.enabled = self:GetChecked()
  end)
  lfg.panel.enabledCB:SetChecked(LFGSettings.enabled)

  -- Channel Selction Check Boxes
  lfg.panel.chanCB = {}
  lfg.panel.chanCBTitle = lfg.createTitle(lfg.panel, "Listen to Channel:", "TOPLEFT", lfg.panel.enabledCB, "BOTTOMLEFT")
  local relFrame = lfg.panel.chanCBTitle
  for i,chanName in ipairs(LFGSettings.channelNames) do
    local cb = lfg.createCheckBox(lfg.panel, chanName, "TOPLEFT", relFrame, "BOTTOMLEFT", function(self)
      LFGSettings.channel[i] = self:GetChecked()
    end)
    cb:SetChecked(LFGSettings.channel[i])
    table.insert(lfg.panel.chanCB, cb)
    relFrame = cb
  end

  -- Criteria Edit Boxes
  lfg.panel.critTitle = lfg.createTitle(lfg.panel, "Match Criteria: Leave Blank to Exclude", "TOPLEFT", relFrame, "BOTTOMLEFT")
  lfg.panel.crit1Title = lfg.createTitle(lfg.panel, "  1:", "TOPLEFT", lfg.panel.critTitle, "BOTTOMLEFT")
  lfg.panel.crit1EB = lfg.createEditBox(lfg.panel, lfg.tableToString(LFGSettings.criteria["1"]), "LEFT", lfg.panel.crit1Title, "RIGHT")
  
  lfg.panel.crit2Title = lfg.createTitle(lfg.panel, "  2:", "TOPLEFT", lfg.panel.crit1Title, "BOTTOMLEFT")
  lfg.panel.crit2EB = lfg.createEditBox(lfg.panel, lfg.tableToString(LFGSettings.criteria["2"]), "LEFT", lfg.panel.crit2Title, "RIGHT")
  
  lfg.panel.crit3Title = lfg.createTitle(lfg.panel, "  3:", "TOPLEFT", lfg.panel.crit2Title, "BOTTOMLEFT")
  lfg.panel.crit3EB = lfg.createEditBox(lfg.panel, lfg.tableToString(LFGSettings.criteria["3"]), "LEFT", lfg.panel.crit3Title, "RIGHT")
  
  -- Auto Whisper Check Box
  lfg.panel.autoTitle = lfg.createTitle(lfg.panel, "Auto Response:", "TOPLEFT", lfg.panel.crit3Title, "BOTTOMLEFT")
  lfg.panel.whisperCB = lfg.createCheckBox(lfg.panel, "Whisper:", "TOPLEFT", lfg.panel.autoTitle, "BOTTOMLEFT", function(self)
    LFGSettings.autoWhisper = self:GetChecked()
  end)
  lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
  lfg.panel.whisperEB = lfg.createEditBox(lfg.panel, LFGSettings.whisperText, "LEFT", lfg.panel.whisperCB, "RIGHT")
  lfg.panel.whisperEB:SetPoint("LEFT", lfg.panel.whisperCB, "RIGHT", 70, 0)

  lfg.panel.inviteCB = lfg.createCheckBox(lfg.panel, "Invite -- In Development", "TOPLEFT", lfg.panel.whisperCB, "BOTTOMLEFT", function(self)
    LFGSettings.autoInvite = self:GetChecked()
  end)
  lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)
  lfg.panel.inviteCB:Disable()

  -- Event Callbacks
  function lfg.panel.okay()
    xpcall(function()
      LFGSettings.criteria["1"] = lfg.stringToTable(lfg.panel.crit1EB:GetText())
      LFGSettings.criteria["2"] = lfg.stringToTable(lfg.panel.crit2EB:GetText())
      LFGSettings.criteria["3"] = lfg.stringToTable(lfg.panel.crit3EB:GetText())
      LFGSettings.whisperText = lfg.panel.whisperEB:GetText()
    end, geterrorhandler())
  end

  function lfg.panel.default()
      LFGSettings = lfg.defaults
  end

  function lfg.panel.refresh()
      lfg.panel.enabledCB:SetChecked(LFGSettings.enabled)

      for i,cb in ipairs(lfg.panel.chanCB) do
        cb:SetChecked(LFGSettings.channel[i])
      end
  
      lfg.panel.crit1EB:SetText(lfg.tableToString(LFGSettings.criteria["1"]))
      lfg.panel.crit2EB:SetText(lfg.tableToString(LFGSettings.criteria["2"]))
      lfg.panel.crit3EB:SetText(lfg.tableToString(LFGSettings.criteria["3"]))
  
      lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)
      lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
      lfg.panel.whisperEB:SetText(LFGSettings.whisperText)
  end
  
end