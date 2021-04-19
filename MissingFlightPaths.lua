------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

-- Table of placed pins
local TaxiMapPins = {}

--- Event frame for opening and closing the taxi map.
CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")
TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)

	if event == "TAXIMAP_OPENED" then

		ns:ClearAllPins()
		local instanceID = ns:GetInstanceID()
		
		-- Place map toys if player in Eastern Kingdoms or Kalimdor.
		if (instanceID == 0 or instanceID == 1) and ns:TargetIsSeahorse() == false then
			ns:ShowMapButtonForCurrentContinent()
		end
		
		ns:GetValidNodes()
		
		if ns:TargetIsFerryMaster() == false and
		   ns:TargetIsSeahorse() == false and
		   ns:IsKyrianTransportNode() == false then
			local _,_,instanceID = MFPGlobal.hbd:GetPlayerWorldPosition()		
			ns:SaveMissingNodes(instanceID)
		end
		
		
		
	end
	
	-- Hide map toys when frame is closed, otherwise they persist.
	if event == "TAXIMAP_CLOSED" then
		ns.EKMapButton:Hide()
		ns.KaliMapButton:Hide()
	end
end)

--- Gets all taxi nodes and passes them to ns:PlacePinOnTaxiMap function one at a time.
-- This function ensures node.textureKit ~= nil.
-- Node with non-nil textureKit value is a ferry node, etc.
function ns:GetValidNodes()

	-- If player is using ferry, do nothing.
	-- If player is using Kyrian transport network, do nothing.
	-- If target is seahorse, do nothing (temporarily).
	if ns:TargetIsFerryMaster() == true or
	ns:IsKyrianTransportNode() == true or
	ns:TargetIsSeahorse() == true then
		return
	end
	
	-- This conditional is temporary and will be reworked soon.
	-- Looking for method to filter out underwater nodes.
	if ns:GetInstanceID() == 0 then
		ns:PlaceEasternKingdomsNodes()
		return
	end

	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	
	for i=1,#(taxiNodes) do
		if taxiNodes[i].state == 2 and taxiNodes[i].textureKit == nil and
		ns:IsIgnoredNode(name) == false and taxiNodes[i].nodeID ~= 1567 then
		   
			local X,Y = ns:FindXYPos(taxiNodes[i].name)
			local node = {
				name = taxiNodes[i].name,
				x = X,
				y = Y
			}
			
			if ns:IsUnderwaterNode(node.name, node.x, node.y) == false then
				ns:PlacePinOnFlightMap(node)
			end
		end
	end
end

--- This function is temporary and will be reworked.
function ns:PlaceEasternKingdomsNodes()
	local tabl = ns[3]
	for i=1,NumTaxiNodes() do
		local X,Y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local Name = TaxiNodeName(i)
		if ns:IsUnderwaterNode(Name, X, Y) == false then
			if Type == "DISTANT" then
				local node = {
					name = Name,
					x = X,
					y = Y
				}
				ns:PlacePinOnFlightMap(node)
			end
		end
	end
end

--- Gets all underwater taxi nodes and passes them to ns:PlacePinOnFlightMap() one at a time.
function ns:GetValidUnderwaterNodes()
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	
	for i=1,#(taxiNodes) do
		if taxiNodes[i].state == 2 then
			local X,Y = ns:FindXYPos(taxiNodes[i].name)
			if ns:IsUnderwaterNode(taxiNodes[i].name, X, Y) == true then
				local node = {
					name = taxiNodes[i].name,
					x = X,
					y = Y
				}
				ns:PlacePinOnFlightMap(node)
			end
		end
	end
end

--- Creates pin icon w/ texture and makes it visible on the flight map.
-- Checks if player is in Pandaria or Draenor because flight map is different on those continents.
-- @param pin Structure that contains name, and x&y coordinates.
function ns:PlacePinOnFlightMap(node)

	local f = nil
	local width = nil
	local height = nil
	if ns:UsingTaxiFrame() == true then
		f = TaxiRouteMap
		width = 16
		height = 16
	else
		f = FlightMapFrame.ScrollContainer.Child
		if ns:PlayerIsInShadowlands() == true then
			width = 40
			height = 40
		else
			width = 75
			height = 75
		end
	end
	
	local pin = CreateFrame("Frame", "MFPPin_" .. node.name, f)
	pin:SetWidth(width)
	pin:SetHeight(height)
	
	pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(node.name, 0, 1, 0)
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
	
	pin:SetPoint("CENTER", f, "TOPLEFT", node.x * f:GetWidth(), -(node.y) * f:GetHeight())
	
	TaxiMapPins[#(TaxiMapPins) + 1] = pin
	pin:Show()
end

--- Finds current node and returns true if its textureKit value is non-nil.
-- Event frame checks if player is in The Shadowlands before this is called.
function ns:IsKyrianTransportNode()
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	for i=1,#(taxiNodes) do
		if taxiNodes[i].state == 0 then
			if taxiNodes[i].textureKit ~= nil then
				return true
			end
			return false
		end
	end
	return false
end

--- Returns true if node name and x&y coords match already known underwater nodes.
-- Is called by ns:GetValidUnderwaterNodes() before node is passed to place function.
-- @param name The name of the node to be checked.
-- @param x The x coordinate of the node to be checked.
-- @param y the y coordinate of the node to be checked.
function ns:IsUnderwaterNode(name, x, y)
	local underwaterNodes = ns[3]
	for i=1,#(underwaterNodes) do
		if (underwaterNodes[i].name == name and
		underwaterNodes[i].x == tostring(x) and
		underwaterNodes[i].y == tostring(y)) then
			return true
		end
	end
	
	return false
end

--- Uses HereBeDragons library to return player's current instanceID.
-- If in a garrison, will return Draenor ID, not garrison ID.
-- If in Tanaan Jungle, will return Draenor ID.
-- Always returns continent ID, not any sub instanceID.
function ns:GetInstanceID()
	local _,_,instanceID = MFPGlobal.hbd:GetPlayerWorldPosition()	
	return instanceID
end

--- Hides all pins stored in TaxiMapPins and empties the list.
-- If a player moved from one continent to another, the old pins would persist if they weren't hidden.
function ns:ClearAllPins()
	for i=1,#(TaxiMapPins) do
		TaxiMapPins[i]:Hide()
	end
	TaxiMapPins = {}
end

--- Checks list of ignored nodes against param, returns true if there is a match.
-- @param name The name of the node being checked.
function ns:IsIgnoredNode(name)
	local IgnoredNodes = ns[4]
	for i=1,#(IgnoredNodes) do
		if IgnoredNodes[i] == name then
			return true
		end
	end
	return false
end

--- Returns true if x & y parameters equal any known ferry node x & y
function ns:IsFerryNode(x,y)
	local ferryNodes = ns[1]
	for i=1,#(ferryNodes) do
		if (tostring(x) == ferryNodes[i].x) and (tostring(y) == ferryNodes[i].y) then
			return true
		end
	end
	return false
end

--- Checks targeted npc and returns true if target is an Alliance Kul Tiran ferry master.
-- Runs through list of ferry master names and returns true if target name is a match.
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

--- Checks targeted npc and returns true if target is "Swift Seahorse".
function ns:TargetIsSeahorse()
	if GetUnitName("target") == "Swift Seahorse" then
		return true
	else
		return false
	end
end

--- Returns true if player is talking to flight master in Pandaria or Draenor.
function ns:UsingTaxiFrame()
	if ns:GetInstanceID() == 870 or ns:GetInstanceID() == 1116 then
		return true
	end
	return false
end

--- Returns true if player is in The Shadowlands.
function ns:PlayerIsInShadowlands()
	if ns:GetInstanceID() == 2222 then
		return true
	end
	return false
end

--- UNDER CONSTRUCTION:
-- Want a way to filter out underwater nodes and return list of only on land Eastern Kingdoms nodes.
function ns:RemoveUnderwaterNodes(taxiNodes)
	local filteredNodes = {}
	for i=1,#(taxiNodes) do
		if taxiNodes[i].state == 2 then
			local X,Y = ns:FindXYPos(taxiNodes[i].name)
			if ns:IsUnderwaterNode(taxiNodes[i].name, X, Y) == false then
				filteredNodes[#(filteredNodes) + 1] = taxiNodes[i]
			end
		end
	end
	return filteredNodes
end
