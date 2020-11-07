

local Marks = {}

local InvalidNames = {
	"Southwind Village, Silithus",
	"Schnottz's Landing, Uldum",
	"Quest - Hellfire Peninsula (Alliance) End",
	"Amber Ledge, Borean (to Coldarra)",
	"Transitus Shield, Coldarra (NOT USED)",
	
	-- These are temporary until I learn what is broken about them
	"Atal'Gral, Zuldazar",
	"Dreadpearl, Zuldazar",
	"Devoted Sanctuary, Vol'dun"
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

-- For Vashj'ir
local SeahorseIDs = {
	"Creature-0-3777-0-242-43293-0000256D1B", -- Stygian Bounty
	"Creature-0-3777-0-242-43216-0000256D1B", -- Sandy Beach
	"Creature-0-3777-0-242-40851-0000256D1B", -- Silver Tide Hollow
	"Creature-0-3777-0-242-40852-0000256D1B", -- Smuggler's Scar
	"Creature-0-3777-0-242-40871-0000256D1B", -- Legion's Rest
	"Creature-0-3777-0-242-40873-0000256D1B" -- Tenebrous Cavern
}
local UnderwaterNodesNonDK = {22,23,24,25,30,32}
local UnderwaterNodesDK = {23,24,25,26,31,33}


CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")

TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		ClearAllMarks()
		
		--PrintAllNodesAlt()
		
		-- Vashj'ir
		local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
		if instanceID == 0 then -- Eastern Kingdoms
		
			
			if AtUnderwaterNode() == true then -- Show underwater nodes but not rest of continent
				PlaceVashjirUnderwaterNodes()
			else -- Show EK nodes but not the underwater ones
				PlaceEasternKingdomsNodes()
			end
		
		
		elseif PlayerInDraenor() == true or PlayerInPandaria() == true then
			PlaceDraenorPoints()
		
		
		else
			for i=1,NumTaxiNodes() do
				local x,y = TaxiNodePosition(i)
				local Type = TaxiNodeGetType(i)
				local name = TaxiNodeName(i)
				
				--PrintNodeInfo(i, name, Type, x, y)
				
				
				--PrintNodeInfo(i, name, Type, x, y)

				--[=[
				if name == "Devoted Sanctuary, Vol'dun" then
					PrintNodeInfo(i, name, Type, x, y)
				end
				]=]
				
				if Type == "REACHABLE" and ValidFP(name) == true then
					--PrintNodeInfo(i, name, Type, x, y)
				end
					
				if Type == "DISTANT" and ValidFP(name) == true then
					--PrintNodeInfo(i, name, Type, x, y)
					PlacePoint(TaxiNodeName(i), x*100, y*100)
				end
			end
		end
		
		
	end
end)

function PlacePoint(name, x, y)

	local f = FlightMapFrame.ScrollContainer.Child
	
	
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	pin:SetWidth(75)
	pin:SetHeight(75)
	
	pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(name, 0, 1, 0)
			GameTooltip:Show()
	end)
	
	pin:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
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
	print("i: " .. i .. " name: " .. name .. " type: " .. Type)
	--print("x: " .. x*100 .. " y: " .. y*100)
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
	
	
	
	pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(name, 0, 1, 0)
			GameTooltip:Show()
	end)
	
	pin:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	
	
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




function AtUnderwaterNode()
	local guid = UnitGUID("target")
	for i=1,table.getn(SeahorseIDs) do
		if SeahorseIDs[i] == guid then
			return true
		end
	end
	return false
end




function PrintAllNodes()
	taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	for i=1,table.getn(taxiNodes) do
		print("i: " .. i .. "  nodeID: " .. taxiNodes[i].nodeID .. "  name: " .. taxiNodes[i].name .. "  type: " .. taxiNodes[i].state)
	end
end

function PrintAllNodesAlt()
	print(GetTaxiMapID())
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		print("i: " .. i .. " name: " .. name .. " type: " .. Type)
	end
end

function PrintAllNodesAltDistant()
	print(GetTaxiMapID())
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "DISTANT" then
			print("i: " .. i .. " name: " .. name .. " type: " .. Type)
		end
	end
end

function PrintAllNodesAltReachable()
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "REACHABLE" or Type == "CURRENT" then
			print("i: " .. i .. " name: " .. name .. " type: " .. Type)
		end
	end
end

function PlaceVashjirUnderwaterNodes()
		local _, classFilename, _ = UnitClass("player")
		
		-- Death Knight flight table is different, so we use the other table for underwater nodes
		if classFilename == "DEATHKNIGHT" then
			
			for i=1,table.getn(UnderwaterNodesDK) do
			
				local x,y = TaxiNodePosition(UnderwaterNodesDK[i])
				local Type = TaxiNodeGetType(UnderwaterNodesDK[i])
				local name = TaxiNodeName(UnderwaterNodesDK[i])
				
				if Type == "DISTANT" then
					PlacePoint(name, x*100, y*100)
				end
			
			
			end
			
			
			
		else
		
			for i=1,table.getn(UnderwaterNodesNonDK) do
			
				local x,y = TaxiNodePosition(UnderwaterNodesNonDK[i])
				local Type = TaxiNodeGetType(UnderwaterNodesNonDK[i])
				local name = TaxiNodeName(UnderwaterNodesNonDK[i])
				
				if Type == "DISTANT" then
					PlacePoint(name, x*100, y*100)
				end
			
			
			end
		
		
		end
end

function PlaceEasternKingdomsNodes()
	for i=1,NumTaxiNodes() do
		
		if IsUnderwaterIndex(i) == false then
		
			local x,y = TaxiNodePosition(i)
			local Type = TaxiNodeGetType(i)
			local name = TaxiNodeName(i)
			if Type == "DISTANT" then
				--print("i: " .. i .. " name: " .. name .. " type: " .. Type)
				PlacePoint(name, x*100, y*100)
			end
			
		end
	end
end

function IsUnderwaterIndex(index)

	local _, classFilename, _ = UnitClass("player")
		
	-- Death Knight flight table is different, so we use the other table for underwater nodes
	if classFilename == "DEATHKNIGHT" then
		for i=1,table.getn(UnderwaterNodesDK) do
			if UnderwaterNodesDK[i] == index then
				return true
			end
		end
	else
		for i=1,table.getn(UnderwaterNodesNonDK) do
			if UnderwaterNodesNonDK[i] == index then
				return true
			end
		end
	end
	return false
end


print("MFP loaded.")




















