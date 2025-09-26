---------------------------------------
---@author YOLTIX
---@time 22/09/2025 15:16
---@creation ©️ Interact - DS-Store
---@description Interact System - DS-Store
---@version 1.0.0
---------------------------------------


DSInteract.tDui = DSInteract.tDui or {}
DSInteract.tOwner = DSInteract.tOwner or {}


local tInteract = {}
tInteract.__index = tInteract

local sDuiUrl <const> = "nui://DS_Interact/web/dist/index.html"

---Function To Create An Interact
---@param sName string - The name of the interact
---@return table - The interact object
function DSInteract:Create(sName)

    if not sName or sName == "" then
        error("[DSInteract] - You must provide a valid name for the interact.")
        return
    end

    local sOwner <const> = GetInvokingResource() or GetCurrentResourceName()

    local tData <const> = {
        sName = sName,
        sText = "Press To Interact",
        sKey = "E",
        tCoords = vector3(0.0, 0.0, 0.0),
        tColors = {},
        iRangeView = 5.0,
        iRangeInteract = 2.0,
        iHoldingDuration = 2000,
        bHolding = false,
        bShow = true,
        fcCallback = nil,
    }

    setmetatable(tData, tInteract)

    self.tDui[sName] = {
        tInfoData = tData,
        tDuiData = nil,
        sOwner = sOwner,
    }

    tShowInteract[sName] = false
    self.tOwner[sOwner] = self.tOwner[sOwner] or {}
    self.tOwner[sOwner][sName] = true

    return tData
end

---Function To Get An Interact
---@param sName string - The name of the interact
---@return table - The interact object
function DSInteract:GetInteract(sName)
    if not self.tDui[sName] then
        error("[DS_Interact] - The interact with the name '"..sName.."' does not exist.")
        return nil
    end

    return self.tDui[sName].tInfoData
end

---Function To Update The Dui
function tInteract:UpdateDui()
    if not self.sName then return end

    local tData <const> = {
        type = "DSInteract:UpdateInteract",
        data = {
            sText = self.sText,
            sKey = self.sKey,
            bShow = self.bShow,
            bHolding = self.bHolding,
            tColors = self.tColors,
        }
    }

    local tDui <const> = DSInteract.tDui[self.sName] and DSInteract.tDui[self.sName].tDuiData
    if tDui?.oDui then
        SendDuiMessage(tDui.oDui, json.encode(tData))
    end
end

---Function To Show/Hide The Interact
---@param bShow boolean - Whether to show or hide the interact
---@return table - The interact object
function tInteract:Show(bShow)
    if type(bShow) == "boolean" then
        self.bShow = bShow
    end
    self:UpdateDui()
    return self
end

---Function To Enable/Disable Holding
---@param bHolding boolean - Whether to enable or disable holding
---@return table - The interact object
function tInteract:SetHolding(bHolding)
    if type(bHolding) == "boolean" then
        self.bHolding = bHolding
    end
    self:UpdateDui()
    return self
end

---Function To Set The Text
---@param sText string - The text to display
---@return table - The interact object
function tInteract:SetText(sText)
    self.sText = sText or self.sText
    self:UpdateDui()
    return self
end

---Function To Set The Key
---@param sKey string - The key to press
---@return table - The interact object
function tInteract:SetKey(sKey)
    self.sKey = sKey or self.sKey
    self:UpdateDui()
    return self
end

---Function To Set The Coordinates
---@param tCoords table - The coordinates to set
---@return table - The interact object
function tInteract:SetCoords(tCoords)
    tCoords = type(tCoords) == "vector3" and tCoords or vector3(tCoords.x or 0.0, tCoords.y or 0.0, tCoords.z or 0.0)
    self.tCoords = tCoords
    self:UpdateDui()
    return self
end

---Function To Set The Colors
---@param tColors table - The colors to set
---@return table - The interact object
function tInteract:SetColors(tColors)
    self.tColors = type(tColors) == "table" and tColors or self.tColors
    self:UpdateDui()
    return self
end

---Function To Set The View Range
---@param iRangeView number - The view range to set
---@return table - The interact object
function tInteract:SetRangeView(iRangeView)
    self.iRangeView = type(iRangeView) == "number" and iRangeView or self.iRangeView
    self:UpdateDui()
    return self
end

---Function To Set The Interact Range
---@param iRangeInteract number - The interact range to set
---@return table - The interact object
function tInteract:SetRangeInteract(iRangeInteract)
    self.iRangeInteract = type(iRangeInteract) == "number" and iRangeInteract or self.iRangeInteract
    self:UpdateDui()
    return self
end

---Function To Set The Callback
---@param fcCallback function - The callback function to set
---@return table - The interact object
function tInteract:SetCallback(fcCallback)
    if type(fcCallback) == "function" then
        self.fcCallback = fcCallback
    elseif type(fcCallback) == "table" then
        local tMetaTable = getmetatable(fcCallback)
        if tMetaTable and type(tMetaTable.__call) == "function" then
            self.fcCallback = function(...)
                return tMetaTable.__call(fcCallback, ...)
            end
        end
    end

    self:UpdateDui()
    return self
end

---Function To Set The Holding Duration
---@param iDuration number - The holding duration to set in milliseconds
---@return table - The interact object
function tInteract:SetHoldingDuration(iDuration)
    if not self.bHolding then
        error("[DS_Interact] - You must enable holding to set holding duration.")
        return self
    end

    self.iHoldingDuration = type(iDuration) == "number" and iDuration or 2000

    self:UpdateDui()

    return self
end

---Function To Set The Background Color
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return table - The interact object
function tInteract:SetBackgroundColor(r, g, b, a)
    self.tColors.background = DSInteract:ReformatColor(r, g, b, a)
    self:UpdateDui()
    return self
end

---Function To Set The Secondary Background Color
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return table - The interact object
function tInteract:SetSecondaryBackgroundColor(r, g, b, a)
    self.tColors.secondaryBackground = DSInteract:ReformatColor(r, g, b, a)
    self:UpdateDui()
    return self
end

---Function To Set The Key Colors
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return table - The interact object
function tInteract:SetKeyColors(r, g, b, a)
    self.tColors.key = DSInteract:ReformatColor(r, g, b, a)
    self:UpdateDui()
    return self
end

---Function To Set The Text Colors
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return table - The interact object
function tInteract:SetTextColors(r, g, b, a)
    self.tColors.text = DSInteract:ReformatColor(r, g, b, a)
    self:UpdateDui()
    return self
end

---Function To Set The Border Colors
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return table - The interact object
function tInteract:SetBorderColors(r, g, b, a)
    self.tColors.border = DSInteract:ReformatColor(r, g, b, a)
    self:UpdateDui()
    return self
end

---Function To Set The Holding Colors
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return table - The interact object
function tInteract:SetHoldingColors(r, g, b, a)
    if not self.bHolding then
        error("[DS_Interact] - You must enable holding to set holding colors.")
        return self
    end

    self.tColors.holding = DSInteract:ReformatColor(r, g, b, a)
    self:UpdateDui()
    return self
end

---Function To Delete The Interact
function tInteract:Delete()
    if not self.sName then return end
    DSInteract:Remove(self.sName)
end

---Function To Reformat Color
---@param r number - The red component (0-255)
---@param g number - The green component (0-255)
---@param b number - The blue component (0-255)
---@param a number - The alpha component (0-255)
---@return string - The reformatted color in rgba format
function DSInteract:ReformatColor(r, g, b, a)
    r = type(r) == "number" and r or 255
    g = type(g) == "number" and g or 255
    b = type(b) == "number" and b or 255
    a = type(a) == "number" and a or 255

    local iAlpha <const> = a / 255

    return string.format("rgba(%d, %d, %d, %.2f)", r, g, b, iAlpha)
end

---Function To Remove An Interact
---@param sName string - The name of the interact to remove
function DSInteract:Remove(sName)
    local tData <const> = self.tDui[sName]
    if not tData then return end

    self:DestroyDui(tData.tDuiData)

    local sOwner <const> = tData.sOwner
    if sOwner and self.tOwner[sOwner] then
        self.tOwner[sOwner][sName] = nil
        if not next(self.tOwner[sOwner]) then
            self.tOwner[sOwner] = nil
        end
    end

    if tShowInteract[sName] then
        tShowInteract[sName] = nil
    end

    self.tDui[sName] = nil
end

---Function To Create A Dui
---@param sName string - The name of the interact
---@return table - The Dui data
function DSInteract:CreateDui(sName)
    local oDui <const> = CreateDui(sDuiUrl, 1920, 1080)
    local nDui <const> = GetDuiHandle(oDui)
    local tDui <const> = CreateRuntimeTxd("ds_interact_txd"..sName)

    CreateRuntimeTextureFromDuiHandle(tDui, "ds_interact_img"..sName, nDui)

    local tData <const> = {
        oDui = oDui,
        oDui_texture = tDui,
        oDuiHandle = nDui,
        sTextureName = "ds_interact_img"..sName,
    }

    self.tDui[sName].tDuiData = tData

    return tData
end

---Function To Destroy A Dui
---@param tData table - The Dui data
---@return boolean - True if the Dui was destroyed, false otherwise
function DSInteract:DestroyDui(tData)
    if not tData?.oDui then return false end
    DestroyDui(tData.oDui)
    return true
end

---Function To Start Holding
---@param tData table - The interact data
---@param tInfoData table - The interact info data
---@param tHold table - The holding data
function DSInteract:StartHolding(tData, tInfoData, tHold)
    if not tData or not tInfoData or not tHold then return end

    tHold.bIsHolding = true
    tHold.iStartTime = GetGameTimer()
    tHold.bCompleted = false
    tHold.iLastUpdate = 0.0
    tHold.iHoldDuration = tInfoData.iHoldingDuration or 2000

    SendDuiMessage(tData.tDuiData.oDui, json.encode{
        type = "DSInteract:StartHolding",
        data = {
            iDuration = tHold.iHoldDuration
        }
    })
end

local iCurrentTime
local iElapsedTime
local fProgress

---Function To Update Holding
---@param tData table - The interact data
---@param tInfoData table - The interact info data
---@param tHold table - The holding data
function DSInteract:UpdateHolding(tData, tInfoData, tHold)
    iCurrentTime = GetGameTimer()
    iElapsedTime = iCurrentTime - tHold.iStartTime
    fProgress = math.min(iElapsedTime / tHold.iHoldDuration, 1.0)

    if iCurrentTime - (tHold.iLastUpdate or 0) >= 50 then
        tHold.iLastUpdate = iCurrentTime
        SendDuiMessage(tData.tDuiData.oDui, json.encode{
            type = "DSInteract:UpdateHolding",
            data = { fProgress = fProgress }
        })
    end

    if fProgress >= 1.0 and not tHold.bCompleted then
        tHold.bCompleted = true
        tHold.bIsHolding = false

        SendDuiMessage(tData.tDuiData.oDui, json.encode{
            type = "DSInteract:CompleteHolding"
        })

        if type(tInfoData.fcCallback) == "function" then
            tInfoData.fcCallback()
        end
    end
end

---Function To Cancel Holding
---@param tData table - The interact data
---@param tHold table - The holding data
function DSInteract:CancelHolding(tData, tHold)
    if not tData or not tHold then return end

    tHold.bIsHolding = false
    tHold.bCompleted = false

    SendDuiMessage(tData.tDuiData.oDui, json.encode{
        type = "DSInteract:CancelHolding"
    })
end