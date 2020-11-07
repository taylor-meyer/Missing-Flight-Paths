------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius <Axiom> @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace




local Marks = {}

local InvalidNames = {
	-- Unused by both factions
	"Southwind Village, Silithus",
	-- For a quest, not in flight path network
	"Quest - Hellfire Peninsula (Alliance) End",
	-- One way from Borean Tundra to Coldarra, not in flight path network
	"Amber Ledge, Borean (to Coldarra)",
	"Transitus Shield, Coldarra (NOT USED)",
	-- Unused by both factions
	"Dreadpearl, Zuldazar",
	-- These are temporarily ignored until I learn what is broken about them
	"Atal'Gral, Zuldazar",
	"Devoted Sanctuary, Vol'dun",
	-- In present time Uldum, this node is unavailable. Temporarily ignored
	"Schnottz's Landing, Uldum"
}

local TaxiFrameIDs = {
	870, -- Pandaria
	1064, -- Isle of Thunder
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

-- For Vashj'ir ignoring
local VashjirNames = {
"Smuggler's Scar, Vashj'ir",
"Silver Tide Hollow, Vashj'ir",
"Legion's Rest, Vashj'ir",
"Tenebrous Cavern, Vashj'ir",
"Sandy Beach, Vashj'ir",
"Stygian Bounty, Vashj'ir",
"Darkbreak Cove, Vashj'ir",
"Tranquil Wash, Vashj'ir",
"Voldrin's Hold, Vashj'ir"
}

-- Event frame
CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")
TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		ClearAllMarks()
		
		--PrintAllNodesDistant()
		
		-- Vashj'ir
		local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
		if instanceID == 0 then -- Eastern Kingdoms
			-- Ignoring Vashj'ir
			if AtUnderwaterNode() == false then
				PlaceEasternKingdomsNodes()
			end
		elseif DraenorOrPandaria() == true then
			PlaceNodes(true)
		else
			PlaceNodes(false)
		end
	end
end)

function PlacePoint(name, x, y, isDraenor)

	local f = nil
	local width = nil
	local height = nil
	if isDraenor == true then
		f = TaxiRouteMap
		width = 16
		height = 16
	else
		f = FlightMapFrame.ScrollContainer.Child
		width = 75
		height = 75
	end
	
	
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	pin:SetWidth(width)
	pin:SetHeight(height)
	
	pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(name .. " " .. x .. " " .. y, 0, 1, 0)
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
	pin:SetPoint("CENTER", f, "TOPLEFT", x * f:GetWidth(), -y * f:GetHeight())
	
	Marks[table.getn(Marks) + 1] = pin
	pin:Show()
end

function ValidFP(name, x, y)
	for i=1,table.getn(ns) do
		local tabl = ns[i]
		for j=1,table.getn(tabl) do
			if (tabl[j].name == name and tabl[j].x == tostring(x) and tabl[j].y == tostring(y))
			then
				return false
			end
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

function PlaceNodes(isTaxiFrame)

	
	


	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		
		
		
		
		if Type == "DISTANT" and ValidFP(name, x, y) == true then
			PlacePoint(TaxiNodeName(i), x, y, isTaxiFrame)
		end
		
		
		
	end
end

function DraenorOrPandaria()
	local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
	for i=1,table.getn(TaxiFrameIDs) do
		if TaxiFrameIDs[i] == instanceID then
			return true
		end
	end
	return false
end

function AtUnderwaterNode()
	local name,_ = UnitName("target")
	if name == "Swift Seahorse" then
		return true
	else
		return false
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
					PlacePoint(name, x, y)
				end
			end
		else
			for i=1,table.getn(UnderwaterNodesNonDK) do
				local x,y = TaxiNodePosition(UnderwaterNodesNonDK[i])
				local Type = TaxiNodeGetType(UnderwaterNodesNonDK[i])
				local name = TaxiNodeName(UnderwaterNodesNonDK[i])
				if Type == "DISTANT" then
					PlacePoint(name, x, y)
				end
			end
		end
end

function PlaceEasternKingdomsNodes()
	for i=1,NumTaxiNodes() do
		if IsUnderwaterName(TaxiNodeName(i)) == false then
			local x,y = TaxiNodePosition(i)
			local Type = TaxiNodeGetType(i)
			local name = TaxiNodeName(i)
			if Type == "DISTANT" then
				PlacePoint(name, x, y)
			end
		end
	end
end

function IsUnderwaterName(name)
	for i=1,table.getn(VashjirNames) do
		if VashjirNames[i] == name then
			return true
		end
	end
	return false
end


-- Printouts for testing
function PrintAllNodes()
	print("TaxiMapID: " .. GetTaxiMapID())
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		print("i: " .. i .. " name: " .. name .. " type: " .. Type)
	end
end

function PrintAllNodesDistant()
	print("TaxiMapID: " .. GetTaxiMapID())
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "DISTANT" then
			print("i: " .. i .. " name: " .. name .. " type: " .. Type .. " x: " .. x .. " y: " .. y)
		end
	end
end

function PrintAllNodesReachable()
	print("TaxiMapID: " .. GetTaxiMapID())
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "REACHABLE" or Type == "CURRENT" then
			print("i: " .. i .. " name: " .. name .. " type: " .. Type)
		end
	end
end

print("MFP loaded.")
