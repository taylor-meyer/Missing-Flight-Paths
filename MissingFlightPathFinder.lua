local Marks = {}

local InvalidNames = {
	"Southwind Village, Silithus",
	"Schnottz's Landing, Uldum",
	"Amber Ledge, Borean (to Coldarra)",
	"Transitus Shield, Coldarra (NOT USED)"
}


CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")

TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
	
		ClearAllMarks()
		
		taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
		--print("Size of C_TaxiMap :" .. table.getn(taxiNodes))
		--print("Size of NumTaxiNodes :" .. NumTaxiNodes())
	
		
	
		for i=1,NumTaxiNodes() do
			local x,y = TaxiNodePosition(i)
			local Type = TaxiNodeGetType(i)
			local name = TaxiNodeName(i)
			
			
			
			if Type == "DISTANT" and ValidFP(name) == true then
				print("i: " .. i)
				print("name: " .. name)
				print("type: " .. Type)
				print("x: " .. x*100 .. " y: " .. y*100)
				print()
				PlacePoint(TaxiNodeName(i), x*100, y*100)
			end
		end
		
		print("Marks size: " .. table.getn(Marks))
		print()
		
		--PrintInfoByIndex(53)
		--PrintInfoByIndex(55)
		
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
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
f:SetBackdropBorderColor(0, .44, .87, 0.5)
f:SetMovable(false)



local fTitle = MissingFPListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fTitle:SetPoint("TOP", 0, -25)
fTitle:SetText("Missing Flight Paths")

f:Hide()


function PlacePoint(name, x, y)
	local f = FlightMapFrame.ScrollContainer.Child
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	pin:SetWidth(100)
	pin:SetHeight(100)
	
	--[=[
	pin:SetScript("OnEnter", function(pin)
	end)
	pin:SetScript("OnLeave", function()
	end)
	]=]
	
	pin.texture = pin:CreateTexture()
	pin.texture:SetTexture("Interface\\MINIMAP\\ObjectIcons.blp")
	pin.texture:SetTexCoord(0.625, 0.750, 0.125, 0.250)
	pin.texture:SetAllPoints()
	
	pin:SetFrameStrata("TOOLTIP")
	pin:SetFrameLevel(f:GetFrameLevel() + 1)
	pin:SetPoint("CENTER", f, "TOPLEFT", x / 100 * f:GetWidth(), -y / 100 * f:GetHeight())
	
	Marks[table.getn(Marks) + 1] = pin
	pin:Show()
end

function ValidFP(name)

	local uiMapID = C_Map.GetBestMapForUnit("player")

	for i=1,table.getn(InvalidNames) do
	
		if name == "Schnottz's Landing, Uldum" and uiMapID == 1527 then
			return false
	
		elseif name == InvalidNames[i] thens
			return false
		end
	end
	return true
end

function ClearAllMarks()
	for i=1,table.getn(Marks) do
		Marks[i]:Hide()
	end
	Marks = {}
end

function PrintInfoByIndex(i)

	local x,y = TaxiNodePosition(i)
	local Type = TaxiNodeGetType(i)
	local name = TaxiNodeName(i)

	print("i: " .. i)
	print("name: " .. name)
	print("type: " .. Type)
	print("x: " .. x*100 .. " y: " .. y*100)
	print()
	
end

-- uiMapID = C_Map.GetBestMapForUnit("player")
-- print(uiMapID)
print("MFP loaded.")




