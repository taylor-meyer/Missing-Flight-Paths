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

-- Event frame
CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")
TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		ClearAllMarks()
		local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
		
		if instanceID == 1643 then -- Kul Tiras
			PlaceKulTirasNodes()
		
		elseif instanceID == 0 then -- Eastern Kingdoms
		
			if AtUnderwaterNode() == true then
				PlaceUnderwaterVashjirNodes()
			else
				PlaceEasternKingdomsNodes()
			end
			
			
		elseif DraenorOrPandaria() == true then
			PlaceNodes(true)
		else
			PlaceNodes(false)
		end
	end
end)

function PlaceKulTirasNodes()
	local targetname = GetUnitName("target")
	local ferrynames = ns[2]
	
	for i=1,table.getn(ferrynames) do
		if ferrynames[i] == targetname then
			return
		end
	end
	
	PlaceNodes(false)

end

function PlaceUnderwaterVashjirNodes()

	local tabl = ns[3]
	
	
	for i=1,NumTaxiNodes() do
	
	
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		
		
		
		for j=1,table.getn(tabl) do
		
			if (tabl[j].name == name and tabl[j].x == tostring(x) and tabl[j].y == tostring(y))
			then
				if Type == "DISTANT" then
					PlacePoint(name, x, y, false)
				end
			end
		end
	end
end




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
	local targetname = GetUnitName("target")
	if targetname == "Swift Seahorse" then
		return true
	end
	return false
end

function PlaceEasternKingdomsNodes()
	local tabl = ns[3]
	
	for i=1,NumTaxiNodes() do
	
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
	
		if IsUnderwaterNode(name, x, y) == false then
			
			if Type == "DISTANT" then
				PlacePoint(name, x, y)
			end
		end
	end
end

function IsUnderwaterNode(name, x, y)
	local tabl = ns[3]
	for i=1,table.getn(tabl) do
		if (tabl[i].name == name and tabl[i].x == tostring(x) and tabl[i].y == tostring(y))
		then
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
