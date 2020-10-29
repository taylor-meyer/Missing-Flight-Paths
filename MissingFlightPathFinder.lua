MissingFPsTable = {}

CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")

TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
		for i=1,table.getn(taxiNodes) do
			if taxiNodes[i].state == 2 then
				--print(i .. ": " .. taxiNodes[i].name .. "    Reachable: " .. taxiNodes[i].state)
				local coordX, coordY = taxiNodes[i].position:GetXY()
				local item = MissingFPListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				item:SetPoint("TOP", 0, -25-(i*10))
				item:SetText(i .. ": " .. taxiNodes[i].name)
				MissingFPsTable[i] = taxiNodes[i]
			end
		end
		if(table.getn(MissingFPsTable) ~= 0) then
			MissingFPListFrame:Show()
		end
	end
	if event == "TAXIMAP_CLOSED" then
		MissingFPListFrame:Hide()
	end
end)

local f = CreateFrame("Frame", "MissingFPListFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
f:SetPoint("RIGHT", -300, 0)
f:SetSize(300, 700)
f:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
-- Movable
f:SetMovable(false)



local fTitle = MissingFPListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fTitle:SetPoint("TOP", 0, -25)
fTitle:SetText("Missing Flight Paths")

f:Hide()

--[=[
function PlacePoint(x, y)
	local frameT = FlightMapFrame
	local pin = CreateFrame("Frame", "MYPIN", frameT)
	pin:SetWidth(16)
	pin:SetHeight(16)
	pin:EnableMouse(true)
	
	pin:SetScript("OnEnter", function(pin)
		print("x: " .. x .. "     y: " .. y)
	end) -- this routine you need to write
	
	pin:SetScript("OnLeave", function()
	end) -- this routine you need to write
	
	pin.texture = pin:CreateTexture()
	-- You need to set the texture of the pin you want to display.  Here is an example
	pin.texture:SetTexture("Interface\\MINIMAP\\ObjectIcons.blp")
	pin.texture:SetTexCoord(0.125, 0.250, 0.125, 0.250)
	pin.texture:SetAllPoints()
	-- Make it appear at different levels in the map as desired (other icons can cover it based on what you choose)
	pin:SetFrameStrata("TOOLTIP")
	pin:SetFrameLevel(frameT:GetFrameLevel() + 1)
	pin:SetPoint("CENTER", frameT, "CENTER", x*10, -y*10)
	pin:Show()
end
]=]
