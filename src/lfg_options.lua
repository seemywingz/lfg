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


function lfg.loadOptions()
  LFGSettings = lfg.defaults

  lfg.panel = CreateFrame("Frame");
  lfg.panel.name = addonName
  InterfaceOptions_AddCategory(lfg.panel);
  
  lfg.panel.title = lfg.panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  lfg.panel.title:SetPoint("TOPLEFT", 16, -16)
  lfg.panel.title:SetText(lfg.panel.name.." "..lfg.version)
  
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
      LFGSettings.channel[chanNum] = false
      local cb = lfg.createCheckBox(lfg.panel, chanNum..". "..chanName, "TOPLEFT", relFrame, "BOTTOMLEFT", function(self)
        LFGSettings.channel[chanNum] = self:GetChecked()
      end)
      cb:SetChecked(LFGSettings.channel[chanNum])
      table.insert(lfg.panel.chanCheckBox, cb)
      relFrame = cb
  end

  -- Criteria Edit Boxes
  lfg.panel.critEB = {}
  lfg.panel.critTitle = lfg.createTitle(lfg.panel, "Match Criteria: Leave Blank to Exclude", "TOPLEFT", relFrame, "BOTTOMLEFT")
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

  lfg.saveBTN = CreateFrame("Button", "LFG_SAVE_BTN", lfg.panel, "UIPanelButtonTemplate")
  lfg.saveBTN:SetSize(80 ,22) -- width, height
  lfg.saveBTN:SetText("Save")
  lfg.saveBTN:SetPoint("TOPLEFT", lfg.panel.inviteCB, "BOTTOMLEFT")
  lfg.saveBTN:SetScript("OnClick", function()
    lfg.panel.okay()
    print("LFG Configs Saved!")
  end) 

  -- Panel Event Callbacks
  function lfg.panel.okay()

      for i,eb in ipairs(lfg.panel.critEB) do
        LFGSettings.criteria[i] = eb:GetText():ToTable()
      end
      LFGSettings.whisperText = lfg.panel.whisperEditBox:GetText()

  end

  function lfg.panel.default()
      LFGSettings = lfg.defaults
  end

  function lfg.panel.refresh()

      lfg.panel.enabledCB:SetChecked(LFGSettings.enabled)

      for i,cb in ipairs(lfg.panel.chanCheckBox) do
        cb:SetChecked(LFGSettings.channel[i])
      end

      for i,eb in ipairs(lfg.panel.critEB) do
        print(eb, table.ToString(LFGSettings.criteria[i]))
        eb:SetText(table.ToString(LFGSettings.criteria[i]))
      end
  
      lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)
      lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
      lfg.panel.whisperEditBox:SetText(LFGSettings.whisperText)
    
  end
  
end