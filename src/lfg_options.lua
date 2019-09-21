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
  local panel = CreateFrame("Frame", "MainFrame", InterfaceOptionsFramePanelContainer);
  panel.name = addonName
  InterfaceOptions_AddCategory(panel);
  
  panel.title = panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  panel.title:SetPoint("TOPLEFT", 16, -16)
  panel.title:SetText(panel.name)
  
  -- Force Defaults for Testing
  -- LFGSettings = lfg.defaults
  local chan1CB = lfg.createCheckBox(panel, "Listen to Channel 1. General", "TOPLEFT", panel.title, "BOTTOMLEFT", function(self)
    LFGSettings.channel["1"] = self:GetChecked()
  end)
  chan1CB:SetChecked(LFGSettings.channel["1"])

  local chan2CB = lfg.createCheckBox(panel, "Listen to Channel 2. Trade", "TOPLEFT", chan1CB, "BOTTOMLEFT", function(self)
    LFGSettings.channel["2"] = self:GetChecked()
  end)
  chan1CB:SetChecked(LFGSettings.channel["1"])

  local chan4CB = lfg.createCheckBox(panel, "Listen to Channel 4. Looking For Group", "TOPLEFT", chan2CB, "BOTTOMLEFT", function(self)
    LFGSettings.channel["4"] = self:GetChecked()
  end)
  chan4CB:SetChecked(LFGSettings.channel["4"])
  
  function lfg.panel.okay()
    xpcall(function()
      print("!! LFG Updated !!")
    end, geterrorhandler())
  end

  -- function lfg.panel.default()
  --   xpcall(function()
  --     print("!! LFG Set Defaults !!")
  --     LFGSettings = lfg.defaults
  --   end, geterrorhandler())
  -- end
  
end