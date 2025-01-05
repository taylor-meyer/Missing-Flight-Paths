------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

-- Debug mode options
local DEBUG_MODE = false
local SHOW_ALL_NODES = false
local SAVE_ALL_NODES = false;

-- Create 50 frames to reuse for pins
local emptyFramesCreated = false
local FlightMapPinFrames = {}
local PIN_MAX = 100

--- Event frame for opening and closing the taxi map.
CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")
TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)

	-- Open actions
	if event == "TAXIMAP_OPENED" then
		-- Create frames for pins if they have not yet been created
		if not emptyFramesCreated then ns:CreateEmptyPinFrames() ns:CreateButtonFrames() end
		if DEBUG_MODE then print("HBD:GetPlayerWorldPosition(): " .. ns:GetInstanceID()) end

		ns:PinFlightMap()
		ns:ShowScoutingMapButton()
	end

	-- Close actions
	if event == "TAXIMAP_CLOSED" then
		ns:HidePlacedPins()
		ns:HideAllMaps()
	end
end)

function ns:PinFlightMap()
	-- currentNode, unlockedNodes{}, lockedNodes{}, allNodes{}
	local c, u, l, a = ns:GetNodes()

	if c.textureKit ~= nil then
		if DEBUG_MODE then
			print("Non-nil texture kit at current node: " .. c.name)
			print("textureKit is: " .. c.textureKit)
			print("MFP not placing pins to FlightMap.")
		end
		return
	end

	if ns:IsBadNode(c) then
		if DEBUG_MODE then
			print("Current node found as bad node: " .. c.name)
			print("MFP not placing pins to FlightMap.")
		end
		return
	end

	-- Removes nodes we do not want to show on the flight map,
	-- either because they are broken or are not connected to the
	-- normal flight network
	local nodesToPin = nil
	if SAVE_ALL_NODES then
		ns:FilterBadNodes(a)
		nodesToPin = a
	else
		ns:FilterBadNodes(l)
		nodesToPin = l
	end

	-- Save filtered locked nodes to SavedVariable using HBD InstanceIDOverrides
	MFP_LockedNodes[ns:GetInstanceID()] =  {}
	for i=1,#(nodesToPin) do
		local instanceID = ns:GetInstanceID()
		local name = nodesToPin[i].name
		local nodeID = nodesToPin[i].nodeID
		local X,Y = ns:FindXYPos(name)
		local UiMapID = ns["mapIDs"][ns:GetInstanceID()]
		MFP_LockedNodes[instanceID][i] = {}
		MFP_LockedNodes[instanceID][i].name = name
		MFP_LockedNodes[instanceID][i].nodeId = nodeID
		MFP_LockedNodes[instanceID][i].X = X
		MFP_LockedNodes[instanceID][i].Y = Y
		MFP_LockedNodes[instanceID][i].UiMapID = UiMapID
		MFP_LockedNodes[instanceID][i].instanceID = instanceID
	end
	
	local nodesToPlace = nil
	if SHOW_ALL_NODES == true then
		nodesToPlace = a
	else
		nodesToPlace = l
	end

	-- Show locked nodes on flight map
	for i,v in pairs(nodesToPlace) do

		local pin = FlightMapPinFrames[i]
		pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(v.name, 0, 1, 0)
			GameTooltip:Show()
		end)
		pin:HookScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		local X,Y = ns:FindXYPos(v.name)
		local f = FlightMapFrame.ScrollContainer.Child
		pin:SetPoint("CENTER", f, "TOPLEFT", X * f:GetWidth(), - (Y) * f:GetHeight())
		pin:Show()
	end
end

function ns:GetNodes()
	local taxiNodes = nil

	if WorldMapFrame:GetMapID() == 2248 then -- Khaz'Algar & Dorn workaround
		taxiNodes = C_TaxiMap.GetAllTaxiNodes(2274)
	else
		taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	end

	local currentNode = nil
	local unlockedNodes = {}
	local lockedNodes = {}
	for _,v in pairs(taxiNodes) do
		if v.state == 0 then
			currentNode = v
		elseif v.state == 1 then
			table.insert(unlockedNodes, v)
		else
			table.insert(lockedNodes, v)
		end
	end
	return currentNode, unlockedNodes, lockedNodes, taxiNodes
end

function ns:HidePlacedPins()
	for _,v in pairs(FlightMapPinFrames) do v:Hide() end
end

function ns:CreateEmptyPinFrames()
	local f = FlightMapFrame.ScrollContainer.Child
	for i=1,PIN_MAX do
		local pin = CreateFrame("Frame", "MFPPin_" .. tostring(i), f)

		pin:SetWidth(75)
		pin:SetHeight(75)

		pin.texture = pin:CreateTexture()
		pin.texture:SetTexture("Interface\\MINIMAP\\ObjectIcons.blp")
		pin.texture:SetTexCoord(0.625, 0.750, 0.125, 0.250)
		pin.texture:SetAllPoints()

		pin:SetFrameStrata("TOOLTIP")
		pin:SetFrameLevel(f:GetFrameLevel() + 1)

		FlightMapPinFrames[i] = pin
	end
	emptyFramesCreated = true
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
