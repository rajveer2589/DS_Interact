---------------------------------------
---@author YOLTIX
---@time 22/09/2025 15:16
---@creation ©️ Interact - DS-Store
---@description Interact System - DS-Store
---@version 1.0.0
---------------------------------------

function GetExportInteract()
    local tReturn = {}

    function tReturn:Create(sName)
        if not sName or sName == "" then
            error("[DSInteract] - You must provide a valid name for the interact.")
            return
        end

        local oInteract <const> = DSInteract:Create(sName)

        local tReturn = {}

        tReturn.tData = {
            sName = oInteract.sName,
            sText = oInteract.sText,
            sKey = oInteract.sKey,
            tCoords = oInteract.tCoords,
            tColors = oInteract.tColors,
            iRangeView = oInteract.iRangeView,
            iRangeInteract = oInteract.iRangeInteract,
            iHoldingDuration = oInteract.iHoldingDuration,
            bHolding = oInteract.bHolding,
            bShow = oInteract.bShow,
            fcCallback = oInteract.fcCallback,
        }

        function tReturn:Show(bShow)
            oInteract:Show(bShow)
            return self
        end

        function tReturn:SetHolding(bHolding)
            oInteract:SetHolding(bHolding)
            return self
        end

        function tReturn:SetText(sText)
            oInteract:SetText(sText)
            return self
        end

        function tReturn:SetKey(sKey)
            oInteract:SetKey(sKey)
            return self
        end

        function tReturn:SetCoords(tCoords)
            oInteract:SetCoords(tCoords)
            return self
        end

        function tReturn:SetColors(tColors)
            oInteract:SetColors(tColors)
            return self
        end

        function tReturn:SetRangeView(iRangeView)
            oInteract:SetRangeView(iRangeView)
            return self
        end

        function tReturn:SetRangeInteract(iRangeInteract)
            oInteract:SetRangeInteract(iRangeInteract)
            return self
        end

        function tReturn:SetCallback(fcCallback)
            oInteract:SetCallback(fcCallback)
            return self
        end

        function tReturn:SetHoldingDuration(iHoldingDuration)
            oInteract:SetHoldingDuration(iHoldingDuration)
            return self
        end

        function tReturn:SetBackgroundColor(r, g, b, a)
            oInteract:SetBackgroundColor(r, g, b, a)
            return self
        end

        function tReturn:SetSecondaryBackgroundColor(r, g, b, a)
            oInteract:SetSecondaryBackgroundColor(r, g, b, a)
            return self
        end

        function tReturn:SetKeyColors(r, g, b, a)
            oInteract:SetKeyColors(r, g, b, a)
            return self
        end

        function tReturn:SetTextColors(r, g, b, a)
            oInteract:SetTextColors(r, g, b, a)
            return self
        end

        function tReturn:SetBorderColors(r, g, b, a)
            oInteract:SetBorderColors(r, g, b, a)
            return self
        end

        function tReturn:SetHoldingColors(r, g, b, a)
            oInteract:SetHoldingColors(r, g, b, a)
            return self
        end

        function tReturn:Delete()
            oInteract:Delete()
            self = nil
        end


        return tReturn
    end

    function tReturn:Remove(sName)
        if not sName or sName == "" then
            error("[DSInteract] - You must provide a valid name for the interact.")
            return
        end

        DSInteract:Remove(sName)
    end

    function tReturn:GetInteract(sName)
        DSInteract:GetInteract(sName)
    end

    return tReturn
end

exports("GetExportInteract", GetExportInteract)
