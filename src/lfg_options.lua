local addonName, lfg = ...

function lfg.loadOptions()

  lfg.panel = CreateFrame("Frame");
  lfg.panel.name = addonName
  InterfaceOptions_AddCategory(lfg.panel);
  
  lfg.panel.title = lfg.panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  lfg.panel.title:SetPoint("TOPLEFT", 16, -16)
  lfg.panel.title:SetText(lfg.panel.name.." "..LFGSettings.version)
  
  -- Enabled Check Box
  lfg.panel.enabledCB = lfg.createCheckBox(lfg.panel, "Enabled", "TOPLEFT", lfg.panel.title, "BOTTOMLEFT", function(self)
    lfg.panel.okay()
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
  lfg.panel.critEditBox = {}
  lfg.panel.critTitle = lfg.createTitle(lfg.panel, "Match Criteria: ", "TOPLEFT", relFrame, "BOTTOMLEFT")
 
  lfg.panel.critAddBTN = lfg.createButton(lfg.panel, "+", "LEFT", lfg.panel.critTitle, "RIGHT", function()
    table.insert(LFGSettings.criteria, {"New", "Criteria"})
    lfg.refreshInterfaceOptions(lfg.loadOptions)
  end)
  lfg.panel.critAddBTN:SetSize(20 ,22) -- width, height

  lfg.panel.critRemoveBTN = lfg.createButton(lfg.panel, "-", "LEFT", lfg.panel.critAddBTN, "RIGHT", function()
    table.RemoveLast(LFGSettings.criteria)
    lfg.refreshInterfaceOptions(lfg.loadOptions)
  end)
  lfg.panel.critRemoveBTN:SetSize(20 ,22) -- width, height

  relFrame = lfg.panel.critTitle
  for i,crit in ipairs(LFGSettings.criteria) do
    local title = lfg.createTitle(lfg.panel, "  "..i..":  ", "TOPLEFT", relFrame, "BOTTOMLEFT")
    local eb = lfg.createEditBox(lfg.panel, table.ToString(LFGSettings.criteria[i]), "LEFT", title, "RIGHT")
    table.insert(lfg.panel.critEditBox, eb)
    relFrame = title
  end

  -- Auto Whisper Check Box
  lfg.panel.autoRespTitle = lfg.createTitle(lfg.panel, "Auto Response:", "TOPLEFT", relFrame, "BOTTOMLEFT")
  lfg.panel.whisperCB = lfg.createCheckBox(lfg.panel, "Whisper:", "TOPLEFT", lfg.panel.autoRespTitle, "BOTTOMLEFT", function(self)
    lfg.panel.okay()
    LFGSettings.autoWhisper = self:GetChecked()
  end)
  lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
  lfg.panel.whisperEditBox = lfg.createEditBox(lfg.panel, LFGSettings.whisperText, "LEFT", lfg.panel.whisperCB, "RIGHT")
  lfg.panel.whisperEditBox:SetPoint("LEFT", lfg.panel.whisperCB, "RIGHT", 80, 0)

  lfg.panel.inviteCB = lfg.createCheckBox(lfg.panel, "Invite", "TOPLEFT", lfg.panel.whisperCB, "BOTTOMLEFT", function(self)
    LFGSettings.autoInvite = self:GetChecked()
  end)
  lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)

  -- Auto Post
  lfg.panel.autoPostTitle = lfg.createTitle(lfg.panel, "Auto Post:", "TOPLEFT", lfg.panel.inviteCB, "BOTTOMLEFT")
  lfg.panel.autoPostCheckBox = lfg.createCheckBox(lfg.panel, "", "LEFT", lfg.panel.autoPostTitle, "RIGHT", function(self)
    LFGSettings.autoPost = self:GetChecked()
    if LFGSettings.autoPost then
      lfg.panel.okay()
      print("LFG Auto Post Enabled!")
      lfg.postInChannels()
      LFGSettings.autoPostTicker =  C_Timer.NewTicker(LFGSettings.autoPostDelay, function(args)
        lfg.postInChannels()
      end)
    else
      print("LFG Auto Post Canceled!")
      LFGSettings.autoPostTicker._cancelled = true
    end
  end)
  lfg.panel.autoPostCheckBox:SetChecked(LFGSettings.autoPost)
  lfg.panel.autoPostSlider = lfg.createSlider(lfg.panel, 1, 300, LFGSettings.autoPostDelay, 1, "Delay Seconds", "TOPLEFT", lfg.panel.autoPostTitle, "BOTTOMLEFT", function(self, value)
    local newDelay = floor(value)
    LFGSettings.autoPostDelay = newDelay
    _G[self:GetName() .. 'Text']:SetText("Delay Seconds: " .. newDelay);
  end
  )
  lfg.panel.autoPostSlider.tooltipText = "Posts Supplied Message in Selected Channels at given interval"
  lfg.panel.autoPostEditBox = lfg.createEditBox(lfg.panel, LFGSettings.autoPostText, "TOPLEFT", lfg.panel.autoPostSlider, "BOTTOMLEFT")

  -- Buttons
  lfg.panel.saveBTN = lfg.createButton(lfg.panel, "Save", "TOPLEFT", lfg.panel.autoPostEditBox, "BOTTOMLEFT", function()
    lfg.panel.okay()
    print("LFG Configs Saved!")
  end)
  lfg.panel.saveBTN:SetSize(80 ,22)

  lfg.panel.refreshBTN = lfg.createButton(lfg.panel, "Refresh", "LEFT", lfg.panel.saveBTN, "RIGHT", function()
    lfg.refreshInterfaceOptions(lfg.loadOptions)
  end)
  lfg.panel.refreshBTN:SetSize(80 ,22) -- width, height

  -- Panel Event Callbacks
  function lfg.panel.okay()

      for i,eb in ipairs(lfg.panel.critEditBox) do
        LFGSettings.criteria[i] = eb:GetText():ToTable()
      end
      LFGSettings.whisperText = lfg.panel.whisperEditBox:GetText()
      LFGSettings.autoPostText = lfg.panel.autoPostEditBox:GetText()

  end

  function lfg.panel.default()
      LFGSettings = lfg.defaults
      lfg.refreshInterfaceOptions(lfg.loadOptions)
  end

  function lfg.panel.refresh()

      lfg.panel.enabledCB:SetChecked(LFGSettings.enabled)

      for i,cb in ipairs(lfg.panel.chanCheckBox) do
        cb:SetChecked(LFGSettings.channel[i])
      end

      for i,eb in ipairs(lfg.panel.critEditBox) do
        eb:SetText(table.ToString(LFGSettings.criteria[i]))
      end
  
      lfg.panel.inviteCB:SetChecked(LFGSettings.autoInvite)
      lfg.panel.whisperCB:SetChecked(LFGSettings.autoWhisper)
      lfg.panel.whisperEditBox:SetText(LFGSettings.whisperText)
    
  end
  
end