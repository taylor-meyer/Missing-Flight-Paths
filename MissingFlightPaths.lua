------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

-- Table of placed pins
local Marks = {}

-- These zones use a different frame
-- "TaxiFrame"
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
		
		if instanceID == 0 or instanceID == 1 then
			ns:ShowMapButtonForCurrentContinent()
		end
		
		if instanceID == 1643 then -- Kul Tiras
			PlaceKulTirasNodes()
		
		elseif instanceID == 0 then -- Eastern Kingdoms
			if ns:AtUnderwaterNode() == true then
				PlaceUnderwaterVashjirNodes()
			else
				PlaceEasternKingdomsNodes()
			end
		elseif PlayerInPandaria(instanceID) == true then
			PlacePandariaNodes()
		elseif instanceID == 2222 then
			
			if IsKyrianTransportNode() == false then
				PlaceNonSpecialNodes()
			else
				ns:HideHeirloomMaps()
			end
			
		else
			PlaceNonSpecialNodes()
		end
	end
	if event == "TAXIMAP_CLOSED" then
		ns.EKMapButton:Hide()
		ns.KaliMapButton:Hide()
	end
end)

function PlaceNonSpecialNodes()
	local tabl = ns[4]
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		local tabl = ns[4]
		for j=1,table.getn(tabl) do
			if Type == "DISTANT" and ns:IsIgnoredNode(name) == false then
				PlacePoint(name, x, y, false)
				break
			end
		end
	end
end

function ns:IsIgnoredNode(name)

	local tabl = ns[4]
	
	for i=1,table.getn(tabl) do
		if tabl[i] == name then
			return true
		end
	end
	return false
end

function PlacePoint(name, x, y, isDraenor)

	local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
	local f = nil
	local width = nil
	local height = nil
	if isDraenor == true then
		f = TaxiRouteMap
		width = 16
		height = 16
	else
		f = FlightMapFrame.ScrollContainer.Child
		if instanceID == 2222 then
			width = 40
			height = 40
		else
			width = 75
			height = 75
		end
	end
	
	
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	pin:SetWidth(width)
	pin:SetHeight(height)
	
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
	pin:SetPoint("CENTER", f, "TOPLEFT", x * f:GetWidth(), -y * f:GetHeight())
	
	Marks[table.getn(Marks) + 1] = pin
	pin:Show()
end

function IsKyrianTransportNode()

	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	
	for i=1,table.getn(taxiNodes) do
		
		if taxiNodes[i].state == 0 then -- current node

			if taxiNodes[i].textureKit ~= nil then
				return true
			end
			
			return false
			
		end
	end
	return false
end

function ClearAllMarks()
	for i=1,table.getn(Marks) do
		Marks[i]:Hide()
	end
	Marks = {}
end

function PlaceKulTirasNodes()
	local targetname = GetUnitName("target")
	local ferrynames = ns[2]
	for i=1,table.getn(ferrynames) do
		if ferrynames[i] == targetname then
			return
		end
	end
	PlaceNonFerryNodes()
end

function PlaceNonFerryNodes()
	for i=1,NumTaxiNodes() do
		local X,Y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		
		if IsFerryNode(X,Y) == false then
			if Type == "DISTANT" then
				PlacePoint(name, X, Y, false)
			end
		end		
	end
end

function IsFerryNode(X,Y)
	local ferryNodes = ns[1]
	for i=1,table.getn(ferryNodes) do
		if (tostring(X) == ferryNodes[i].x) and (tostring(Y) == ferryNodes[i].y) then
			return true
		end
	end
	return false
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

function PlacePandariaNodes()
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "DISTANT" then
			PlacePoint(name, x, y, true)
		end
	end
end

function PlayerInPandaria(instanceID)
	for i=1,table.getn(TaxiFrameIDs) do
		if TaxiFrameIDs[i] == instanceID then
			return true
		end
	end
	return false
end

function ns:AtUnderwaterNode()
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
		if ns:IsUnderwaterNode(name, x, y) == false then
			if Type == "DISTANT" then
				PlacePoint(name, x, y)
			end
		end
	end
end

function ns:IsUnderwaterNode(name, x, y)
	local tabl = ns[3]
	for i=1,#(tabl) do
		if (tabl[i].name == name and tabl[i].x == tostring(x) and tabl[i].y == tostring(y))
		then
			return true
		end
	end
	return false
end

function ns:GetInstanceID()
	local _,_,_,_,_,_,_,instanceID = GetInstanceInfo()
	return instanceID
end

function ns:IsFerryNode(x,y)
	local ferryNodes = ns[1]
	for i=1,#(ferryNodes) do
		if (tostring(x) == ferryNodes[i].x) and (tostring(y) == ferryNodes[i].y) then
			return true
		end
	end
	return false
end

function ns:TargetIsFerryMaster()
	local targetname = GetUnitName("target")
	local npcs = ns[2]
	for i=1,#(npcs) do
		if targetname == npcs[i] then
			return true
		end
	end
	return false
end

function ns:TargetIsSeahorse()
	if GetUnitName("target") == "Swift Seahorse" then
		return true
	else
		return false
	end
end
