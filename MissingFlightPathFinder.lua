local Marks = {}

local InvalidNames = {
	"Southwind Village, Silithus",
	"Schnottz's Landing, Uldum",
	"Amber Ledge, Borean (to Coldarra)",
	"Transitus Shield, Coldarra (NOT USED)"
}

local DraenorMapIDs = {
	1116, -- Draenor
	1191, -- Ashran
	1464, -- Tanaan Jungle
	1152, -- Horde Garrison lv1
	1330, -- Horde Garrison lv2
	1153, -- Horde Garrison lv3
	1158, -- Alliance Garrison lv1
	1331, -- Alliance Garrison lv2
	1159  -- Alliance Garrison lv3
}

local PandariaMapIDs = {
	870, -- Pandaria
	1064 -- Isle of Thunder
}



CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")

TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		ClearAllMarks()
		
		if PlayerInDraenor() == true or PlayerInPandaria() == true then
			PlaceDraenorPoints()
		else -- PlayerInDraenor() == false
			taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
			--print("Size of C_TaxiMap :" .. table.getn(taxiNodes))
			--print("Size of NumTaxiNodes :" .. NumTaxiNodes())
			for i=1,NumTaxiNodes() do
				local x,y = TaxiNodePosition(i)
				local Type = TaxiNodeGetType(i)
				local name = TaxiNodeName(i)
			if Type == "DISTANT" and ValidFP(name) == true then
				PrintNodeInfo(i, name, Type, x, y)
				PlacePoint(TaxiNodeName(i), x*100, y*100)
			end
		end
		--print("Marks size: " .. table.getn(Marks))
		--print()
		--PrintInfoByIndex(53)
		--PrintInfoByIndex(55)
		end
	end
end)

function PlacePoint(name, x, y)

	f = FlightMapFrame.ScrollContainer.Child
	
	
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	pin:SetWidth(50)
	pin:SetHeight(50)
	
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
	
		elseif name == InvalidNames[i] then
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

function PrintNodeInfo(i, name, Type, x, y)
	print("i: " .. i)
	print("name: " .. name)
	print("type: " .. Type)
	print("x: " .. x*100 .. " y: " .. y*100)
	print()
end

function PlaceDraenorPoints()
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "DISTANT" and ValidFP(name) == true then
			--PrintNodeInfo(i, name, Type, x, y)
			PlaceDraenorPoint(TaxiNodeName(i), x*100, y*100, true)
		end
	end
end

function PlaceDraenorPoint(name, x, y)
	
	local f = TaxiRouteMap
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	
	pin:SetWidth(16)
	pin:SetHeight(16)
	
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

function PlayerInDraenor()
	local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
	for i=1,table.getn(DraenorMapIDs) do
		if DraenorMapIDs[i] == instanceID then
			return true
		end
	end
	return false
end

function PlayerInPandaria()
	local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
	for i=1,table.getn(DraenorMapIDs) do
		if PandariaMapIDs[i] == instanceID then
			return true
		end
	end
	return false
end

print("MFP loaded.")
















