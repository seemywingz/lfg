local addonName, lfg = ...

local uniquealyzer = 1;
function lfg.createCheckBox(parent, text, point, uiPoint, relPoinit, onClick)
  uniquealyzer = uniquealyzer + 1;
  local globalName = "FL_CHECKBOX_"..uniquealyzer
  local cb = CreateFrame("CheckButton", globalName, parent, "ChatConfigCheckButtonTemplate") --frameType, frameName, frameParent, frameTemplate    
  _G[globalName.."Text"]:SetText(text)
  cb:SetPoint(point, uiPoint,relPoinit)
  cb:SetScript("OnClick", onClick)
  return cb
end

function lfg.loadOptions()
  -- print("LOADING OPTIONS!!!!!!!!!!!!")
  -- LFGSettings = lfg.defaults

  local panel = CreateFrame("Frame");
  panel.name = addonName
  InterfaceOptions_AddCategory(panel);
  
  panel.title = panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  panel.title:SetPoint("TOPLEFT", 16, -16)
  panel.title:SetText(panel.name)

  panel.chanCBTitle = panel:CreateFontString("LFG_CHANCB_TITLE", "ARTWORK", "GameFontNormalLarge")
  panel.chanCBTitle:SetPoint("TOPLEFT", panel.title, "BOTTOMLEFT")
  panel.chanCBTitle:SetText("Listen to Channel:")
  
  local relFrame = panel.chanCBTitle
  for i,chanName in ipairs(LFGSettings.channelNames) do
    local cb = lfg.createCheckBox(panel, chanName, "TOPLEFT", relFrame, "BOTTOMLEFT", function(self)
      LFGSettings.channel[i] = self:GetChecked()
    end)
    cb:SetChecked(LFGSettings.channel[i])
    relFrame = cb
  end

  panel.SC1Title = panel:CreateFontString("LFG_CRIT1_TITLE", "ARTWORK", "GameFontNormalLarge")
  panel.SC1Title:SetPoint("TOPLEFT", relFrame, "BOTTOMLEFT")
  panel.SC1Title:SetText("Search Criteria 1:")
  
  function lfg.panel.okay()
    xpcall(function()
      print("!! LFG Updated !!")
    end, geterrorhandler())
  end

  function lfg.panel.default()
      print("!! LFG Set Defaults !!")
      LFGSettings = lfg.defaults
  end
  
end