---------------------------------------
---@author YOLTIX
---@time 22/09/2025 15:16
---@creation ©️ Interact - DS-Store
---@description Interact System - DS-Store
---@version 1.0.0
---------------------------------------

local DSInteract = exports["DS_Interact"]:GetExportInteract()


---------- Simple Interact ----------

local vecPos <const> = vec3(-333.03, -902.20, 31.06)
local oInteract = DSInteract:Create("simple_interact")
oInteract:SetText("Press E to say Hello")
oInteract:SetKey("E")
oInteract:SetCoords(vecPos)
oInteract:SetRangeView(10.0)
oInteract:SetRangeInteract(2.0)
oInteract:SetCallback(function()
    print("Hello from DS Store !")
end)

---------- Holding Interact ----------

local oHoldInteract= DSInteract:Create("hold_interact")
oHoldInteract:SetText("Hold F to open")
oHoldInteract:SetKey("F")
oHoldInteract:SetCoords(vecPos)
oHoldInteract:SetRangeView(10.0)
oHoldInteract:SetRangeInteract(2.0)
oHoldInteract:SetHolding(true)
oHoldInteract:SetHoldingDuration(1500)
oHoldInteract:SetCallback(function()
    print("Hello from DS Store !")
end)

---------- Advanced Interact ----------

local oAdvancedInteract <const> = DSInteract:Create("advanced_interact")
oAdvancedInteract:SetText("Appuie sur E pour Entrer")
oAdvancedInteract:SetKey("E")
oAdvancedInteract:SetCoords(vecPos)
oAdvancedInteract:SetRangeView(10.0)
oAdvancedInteract:SetRangeInteract(2.0)
oAdvancedInteract:SetHolding(false)
oAdvancedInteract:SetBackgroundColor(245, 245, 245, 255)
oAdvancedInteract:SetSecondaryBackgroundColor(255, 255, 255, 1)
oAdvancedInteract:SetKeyColors(33, 150, 243, 255)
oAdvancedInteract:SetTextColors(34, 34, 34, 255)
oAdvancedInteract:SetBorderColors(220, 220, 220, 255)
oAdvancedInteract:SetCallback(function()
    print("Hello from DS Store !")
    oInteract:Show(false)
    SetTimeout(3000, function()
        oInteract:Show(true)
    end)
end)


---------- Get Interact ----------

local oInteract1 <const> = DSInteract:Get("simple_interact")

oInteract1:SetText("Press E to say Hello (Modified)")
oInteract1:SetCallback(function()
    print("Hello from DS Store ! (Modified)")
end)