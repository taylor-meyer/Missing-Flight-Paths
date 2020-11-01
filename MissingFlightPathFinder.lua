Marks = {}



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
			
			
			
			if Type == "DISTANT" then
				print("name: " .. name)
				print("type: " .. Type)
				print("x: " .. x*100 .. " y: " .. y*100)
				print()
				PlacePoint(x*100,y*100)
			end
		end
		
		
		
		print("Marks size: " .. table.getn(Marks))
		
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
-- Movable
f:SetMovable(false)



local fTitle = MissingFPListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fTitle:SetPoint("TOP", 0, -25)
fTitle:SetText("Missing Flight Paths")

f:Hide()


function PlacePoint(x, y)
	-- print("Placing: " .. x .. "   " .. y)
	local frameT = FlightMapFrame.ScrollContainer.Child
	local pin = CreateFrame("Frame", "MYPIN", frameT)
	pin:SetWidth(50)
	pin:SetHeight(50)
	pin:EnableMouse(true)
	
	
	pin:SetScript("OnEnter", function(pin)
		-- print("x: " .. x .. "     y: " .. y)
	end)
	
	pin:SetScript("OnLeave", function()
	end)
	
	pin.texture = pin:CreateTexture()
	
	pin.texture:SetTexture("Interface\\MINIMAP\\ObjectIcons.blp")
	pin.texture:SetTexCoord(0.125, 0.250, 0.125, 0.250)
	pin.texture:SetAllPoints()
	pin:SetFrameStrata("TOOLTIP")
	pin:SetFrameLevel(frameT:GetFrameLevel() + 1)
	pin:SetPoint("CENTER", frameT, "TOPLEFT", x / 100 * frameT:GetWidth(), -y / 100 * frameT:GetHeight())
	
	Marks[table.getn(Marks) + 1] = pin
	pin:Show()
end

function ClearAllMarks()
	Marks = {}
end

print("MFP loaded.")
