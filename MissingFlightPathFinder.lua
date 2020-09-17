print("MISSING FP FINDER")

CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")


TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)

	if event == "TAXIMAP_OPENED" then
	
		print("TAXIMAP_OPENED fired success")
		taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
		
		for i=1,table.getn(taxiNodes) do
		
			if taxiNodes[i].state == 2 then
			
			 print(i .. ": " .. taxiNodes[i].name .. "    Reachable: " .. taxiNodes[i].state)
			
			end
	
		end
		
		f:Show()
	
	end
	
	if event == "TAXIMAP_CLOSED" then
	
		f:Hide()
	
	end

end)



f = CreateFrame("Frame", "box", UIParent)
f:SetPoint("RIGHT", -300, -25)
f:SetSize(300, 1000)
f:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
-- Movable
f:SetMovable(false)



fTitle = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fTitle:SetPoint("TOP", 0, -25)
fTitle:SetText("Missing Flight Paths")

f:Hide()