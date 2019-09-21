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

function lfg.listenToChannel(number)
  print("LFG Listening to Channel: "..number)
  LFGSettings.channel[number] = true
end

function lfg.ignoreChannel(number)
  print("LFG Ignoring Channel: "..number)
  LFGSettings.channel[number] = false
end


function lfg.loadOptions()
  -- print("LOADING OPTIONS!!!!!!!!!!!!")
  local panel = CreateFrame("Frame", "MainFrame", InterfaceOptionsFramePanelContainer);
  panel.name = addonName
  InterfaceOptions_AddCategory(panel);
  
  panel.title = panel:CreateFontString("LFG_OPTIONS_TITLE", "ARTWORK", "GameFontNormalLarge")
  panel.title:SetPoint("TOPLEFT", 16, -16)
  panel.title:SetText(panel.name)
  
  -- Always Set Defaults for testing
  LFGSettings = lfg.defaults
  local chan1CB = lfg.createCheckBox(panel, "Listen to Channel 1. General", "TOPLEFT", panel.title, "BOTTOMLEFT", function(self)
    if self:GetChecked() then
      lfg.listenToChannel(1)
    else
      lfg.ignoreChannel(1)
    end
  end)SetChecked(LFGSettings.channel["4"])
  
  local chan4CB = lfg.createCheckBox(panel, "Listen to Channel 4. Looking For Group", "TOPLEFT", chan1CB, "BOTTOMLEFT", function(self)
    if self:GetChecked() then
      lfg.listenToChannel(4)
    else
      lfg.ignoreChannel(4)
    end
  end):SetChecked(LFGSettings.listenChanLFG)

  lfg.createCheckBox(panel, "Alert On LFG", "TOPLEFT", chan4CB, "BOTTOMLEFT",function(self)
    if self:GetChecked() then
      print("check")
    else
      print("uncheck")
    end
  end).tooltip = "Enable Alerting When Someone Says: LFG";
  
  function lfg.panel.okay()
    xpcall(function()
      print("!! LFG Updated !!")
    end, geterrorhandler())
  end

  function lfg.panel.default()
    xpcall(function()
      print("!! LFG Set Defaults !!")
      LFGSettings = lfg.defaults
    end, geterrorhandler())
  end
  
end