---------------------------------------
---@author YOLTIX
---@time 22/09/2025 15:16
---@creation ©️ Interact - DS-Store
---@description Interact System - DS-Store
---@version 1.0.0
---------------------------------------


tShowInteract = {}

---Function to Draw the interact
---@param sName string
function DSInteract:DrawInteract(sName)

    local tData <const> = self.tDui[sName]
    if not tData then return end

    local tInfo <const> = tData.tInfoData
    if not tInfo or not tInfo.bShow then return end

    if not tData.tDuiData then
        tData.tDuiData = self:CreateDui(sName)
    end

    local tDui <const> = tData.tDuiData

    if not tShowInteract[sName] then
        SetTimeout(250, function()
            if not tDui.oDui or not IsDuiAvailable(tDui.oDui) then return end
            SendDuiMessage(tDui.oDui, json.encode{
                type = "DSInteract:ShowInteract",
                data = {
                    sText = tInfo.sText,
                    sKey = tInfo.sKey,
                    bHolding = tInfo.bHolding,
                    tColors = tInfo.tColors,
                }
            })

            tShowInteract[sName] = true
        end)
    end

    if tShowInteract[sName] then
        local bRetval, ix, iZ = GetScreenCoordFromWorldCoord(tInfo.tCoords.x, tInfo.tCoords.y, tInfo.tCoords.z)
        if bRetval then
            DrawSprite("ds_interact_txd"..sName, tDui.sTextureName, ix, iZ,  0.85, 0.85, 0.0, 255, 255, 255, 255)
        end
    end
end

CreateThread(function()
    local iPlayerId = PlayerPedId()
    local iTime = 750
    local iDist = 0
    local tHoldingData = {}

    while true do
        iTime = 750
        iPlayerId = PlayerPedId()

        for sName, tData in pairs(DSInteract.tDui) do
            local tInfoData <const> = tData.tInfoData
            if not tInfoData or not tInfoData.bShow then goto continue end

            iDist = #(GetEntityCoords(iPlayerId) - tInfoData.tCoords)

            if iDist <= tInfoData.iRangeView then
                iTime = 0
                DSInteract:DrawInteract(sName)

                if iDist <= tInfoData.iRangeInteract then
                    local iKeyCode = GetKeyCode(tInfoData.sKey)
                    local bKeyPressed = IsControlPressed(0, iKeyCode) or IsDisabledControlPressed(0, iKeyCode)
                    local bKeyJustPressed = IsControlJustPressed(0, iKeyCode) or IsDisabledControlJustPressed(0, iKeyCode)
                    local bKeyJustReleased = IsControlJustReleased(0, iKeyCode) or IsDisabledControlJustReleased(0, iKeyCode)

                    if tInfoData.bHolding then

                        if not tHoldingData[sName] then
                            tHoldingData[sName] = {
                                bHolding = false,
                                iStartTime = 0,
                                iHoldDuration = tInfoData.iHoldingDuration or 2000,
                                bCompleted = false,
                                iLastUpdate    = 0.0,
                            }
                        end

                        local tHold <const> = tHoldingData[sName]

                        if bKeyJustPressed and not tHold.bIsHolding then
                            DSInteract:StartHolding(tData, tInfoData, tHold)
                        elseif bKeyPressed and tHold.bIsHolding then
                            DSInteract:UpdateHolding(tData, tInfoData, tHold)
                        elseif (bKeyJustReleased or not bKeyPressed) and tHold.bIsHolding then
                            DSInteract:CancelHolding(tData, tInfoData, tHold)
                        end

                    else
                        if bKeyJustPressed then
                            if type(tInfoData.fcCallback) == "function" then
                                tInfoData.fcCallback()
                            end
                        end
                    end
                end
            else
                if tHoldingData[sName] and tHoldingData[sName].bIsHolding then
                    tHoldingData[sName].bIsHolding = false
                    tHoldingData[sName].bCompleted = false

                    SendDuiMessage(tData.tDuiData.oDui, json.encode{
                    type = "DSInteract:CancelHolding"
                    })
                end

                if tShowInteract[sName] then
                    tShowInteract[sName] = nil
                end

                if tData.tDuiData then
                    DSInteract:DestroyDui(tData.tDuiData)
                    tData.tDuiData = nil
                end

            end
            ::continue::
        end
        Wait(iTime)
    end
end)


AddEventHandler("onResourceStop", function(sResourceName)
    if DSInteract and DSInteract.tOwner and DSInteract.tOwner[sResourceName] then
        for sName, _ in pairs(DSInteract.tOwner[sResourceName]) do
            DSInteract:Remove(sName)
            print(("[DS_Interact] Auto-clean '%s' from ressource '%s'"):format(sName, sResourceName))
        end
        DSInteract.tOwner[sResourceName] = nil
    end
end)