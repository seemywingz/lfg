local addonName, lfg = ...

local uniquealyzer = 1;
function lfg.createTitle(parent, text, point, relFrame, relPoinit)
  uniquealyzer = uniquealyzer + 1;
  local fs = parent:CreateFontString("LFG_PANEL_TITLE"..uniquealyzer, "ARTWORK", "GameFontNormalLarge")
  fs:SetPoint(point, relFrame, relPoinit)
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
  return t
end

function lfg.loadOptions()

  lfg.panel = CreateFrame("Frame");
  lfg.panel.name = addonName
  InterfaceOptions_AddCategory(lfg.panel);
  
  lfg.panel.title = lfg.panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  lfg.panel.title:SetPoint("TOPLEFT", 16, -16)
  lfg.panel.title:SetText(lfg.panel.name)

  lfg.panel.chanCBTitle = lfg.createTitle(lfg.panel, "Listen to Channel:", "TOPLEFT", lfg.panel.title, "BOTTOMLEFT")
  
  local relFrame = lfg.panel.chanCBTitle
  for i,chanName in ipairs(LFGSettings.channelNames) do
    local cb = lfg.createCheckBox(lfg.panel, chanName, "TOPLEFT", relFrame, "BOTTOMLEFT", function(self)
      LFGSettings.channel[i] = self:GetChecked()
    end)
    cb:SetChecked(LFGSettings.channel[i])
    relFrame = cb
  end

  lfg.panel.crit1Title = lfg.createTitle(lfg.panel, "Search Criteria 1:", "TOPLEFT", relFrame, "BOTTOMLEFT")
  lfg.panel.crit1EB = lfg.createEditBox(lfg.panel, lfg.tableToString(LFGSettings.criteria["1"]), "TOPLEFT", lfg.panel.crit1Title, "BOTTOMLEFT")
  
  lfg.panel.crit2Title = lfg.createTitle(lfg.panel, "Search Criteria 2:", "TOPLEFT", lfg.panel.crit1EB, "BOTTOMLEFT")
  lfg.panel.crit2EB = lfg.createEditBox(lfg.panel, lfg.tableToString(LFGSettings.criteria["2"]), "TOPLEFT", lfg.panel.crit2Title, "BOTTOMLEFT")
  
  lfg.panel.crit3Title = lfg.createTitle(lfg.panel, "Search Criteria 3:", "TOPLEFT", lfg.panel.crit2EB, "BOTTOMLEFT")
  lfg.panel.crit3EB = lfg.createEditBox(lfg.panel, lfg.tableToString(LFGSettings.criteria["3"]), "TOPLEFT", lfg.panel.crit3Title, "BOTTOMLEFT")
  
  function lfg.panel.okay()
      print("!! LFG Updated !!")
      LFGSettings.criteria["1"] = lfg.stringToTable(lfg.panel.crit1EB:GetText())
      LFGSettings.criteria["2"] = lfg.stringToTable(lfg.panel.crit2EB:GetText())
      LFGSettings.criteria["3"] = lfg.stringToTable(lfg.panel.crit3EB:GetText())
  end

  function lfg.panel.default()
      LFGSettings = lfg.defaults
  end
  
end