------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

-- libs
MFPGlobal = { }
MFPGlobal.hbd = LibStub("HereBeDragons-2.0")
MFPGlobal.pins = LibStub("HereBeDragons-Pins-2.0")

--- Saved Variable frame
CreateFrame("Frame", "savedvariableframe", UIParent)
savedvariableframe:RegisterEvent("ADDON_LOADED")
savedvariableframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MissingFlightPaths" then
		if MFP_MissingNodes == nil then
            MFP_MissingNodes = {}
        end
	end
end)

--- Event frame that refreshes list of missing flight points for current instanceID when player talks to the flight master.
-- Note: First confirms that target is not a Kul Tiras ferry master.
CreateFrame("Frame", "refreshdbframe", UIParent)
refreshdbframe:RegisterEvent("TAXIMAP_OPENED")
refreshdbframe:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		if ns:TargetIsFerryMaster() == false and
		   ns:TargetIsSeahorse() == false then
			local _,_,instanceID = MFPGlobal.hbd:GetPlayerWorldPosition()		
			ns:SaveMissingNodes(instanceID)
		end
	end
end)

--- Event frame that refreshes pins on the world map.
CreateFrame("Frame", "mapupdateframe", UIParent)
mapupdateframe:RegisterEvent("QUEST_LOG_UPDATE")
mapupdateframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "QUEST_LOG_UPDATE" then
		ns:RefreshMap()
	end
end)

--- Refreshes the database with missing flight points.
-- Is called when ever the player talks to a flight master.
-- instanceID is used as the key for which list is getting refreshed.
-- @param instanceID The instanceID of player's location.
function ns:SaveMissingNodes(instanceID)
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	MFP_MissingNodes[instanceID] = {}
	local nodes = {}
		for i=1,#(taxiNodes) do
			if taxiNodes[i].state == 2 and
			   taxiNodes[i].textureKit == nil then
				local X,Y = ns:FindXYPos(taxiNodes[i].name)
				local node = {
					name = taxiNodes[i].name,
					x = X,
					y = Y
				}
				nodes[#(nodes) + 1] = node
			end
		end
	MFP_MissingNodes[instanceID] = nodes
end

--- Returns x and y coordinate of flight point.
-- Different api called used to get list of x and y coordinates.
-- Correct x and y is returned by looking for a matching name.
-- @param n The flight point's name.
function ns:FindXYPos(n)
	local numNodes = NumTaxiNodes()
	for i=1,numNodes do
		if TaxiNodeName(i) == n then
			return TaxiNodePosition(i);
		end
	end
end

--- Checks if player is using Kyrian transport network.
-- Kyrian transport nodes disrupt addon, so we check to make sure player is not using it.
-- @param nodes List of nodes obtained from C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
function ns:IsKyrianTransportNode(nodes)
	for i=1,#(nodes) do
		if nodes[i].state == 0 then
			if nodes[i].textureKit ~= nil then
				return true
			end
			return false
		end
	end
	return false
end

--- Runs through entire missing nodes database and places pins on map in appropriate locations.
-- If statements check for nil values.
-- Draenor/Pandaria locations are skewed because the way their flight master taxi map is built is different.
function ns:RefreshMap()

	MFPGlobal.pins:RemoveAllWorldMapIcons(self)
	
	if MFP_MissingNodes[0] ~= nil then
		ns:PlacePointsOnWorldMap(13, MFP_MissingNodes[0])
	end
	
	if MFP_MissingNodes[1] ~= nil then
		ns:PlacePointsOnWorldMap(12, MFP_MissingNodes[1])
	end
	
	if MFP_MissingNodes[530] ~= nil then
		ns:PlacePointsOnWorldMap(101, MFP_MissingNodes[530])
	end
	
	if MFP_MissingNodes[571] ~= nil then
		ns:PlacePointsOnWorldMap(113, MFP_MissingNodes[571])
	end
	
	if MFP_MissingNodes[870] ~= nil then
		ns:PlacePointsOnWorldMap(424, MFP_MissingNodes[870])
	end
	
	if MFP_MissingNodes[1116] ~= nil then
		ns:PlacePointsOnWorldMap(572, MFP_MissingNodes[1116])
	end
	
	if MFP_MissingNodes[1220] ~= nil then
		ns:PlacePointsOnWorldMap(619, MFP_MissingNodes[1220])
	end
	
	if MFP_MissingNodes[1642] ~= nil then
		ns:PlacePointsOnWorldMap(875, MFP_MissingNodes[1642])
	end
	
	if MFP_MissingNodes[1643] ~= nil then
		ns:PlacePointsOnWorldMap(876, MFP_MissingNodes[1643])
	end
	
	if MFP_MissingNodes[2222] ~= nil then
		ns:PlacePointsOnWorldMap(1550, MFP_MissingNodes[2222])
	end

end

--- Creates the pin, sets its attributes, and places it on the map.
-- Using HereBeDragons-Pins-2.
-- @param UiMapID The map ID to place pins on.
-- @param nodes List of nodes from the missing database, where the key is the instanceID.
function ns:PlacePointsOnWorldMap(UiMapID, nodes)

	for i=1,#(nodes) do
		local node = nodes[i]
			if ns:IsIgnoredNode(node.name) == false and
			   ns:IsUnderwaterNode(node.name, node.x, node.y) == false and
			   ns:IsFerryNode(node.x,node.y) == false then
			
				local pin = CreateFrame("Frame", "MFPWorldMapPin_" .. node.name, nil)
				pin:SetWidth(16)
				pin:SetHeight(16)
			
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
				
				MFPGlobal.pins:AddWorldMapIconMap(self, pin, UiMapID, node.x, node.y)
				
				pin:Show()
				
		end
	end
end
