local addonName, lfg = ...

function lfg:loadOptions()
  -- print("LOADING OPTIONS!!!!!!!!!!!!")
  lfg.options = CreateFrame("Frame", "name", self);
  lfg.options.name = addonName
  InterfaceOptions_AddCategory(lfg.options);
  
  -- lfg.title = lfg.options:CreateFontString("lfg_title", "ARTWORK", "GameFontNormalLarge")
  -- lfg.title:SetPoint("TOPLEFT", 16, -16)
  -- lfg.title:SetText(lfg.options.name)
  
  function lfg.options.okay(...)
    local foo = ...
    print("!! LFG Updated !!" .. foo)
  end

end