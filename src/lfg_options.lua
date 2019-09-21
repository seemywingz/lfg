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

  lfg.createCheckBox(panel, "Alert On LFG", "TOPLEFT", panel.title, "BOTTOMLEFT",function(self)
    if self:GetChecked() then
      print("Button is checked")
    else
      print("Button is unchecked")
    end
  end).tooltip = "Enable Alerting When Someone Says: LFG";
  
  function lfg.panel.okay()
    xpcall(function()
      print("!! LFG Updated !!")
    end, geterrorhandler())
  end
  
end