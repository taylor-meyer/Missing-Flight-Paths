------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

-- Create 1000 frames to reuse for pins on the map
local emptyFramesCreated = false
local MapPinFrames = {}
local PIN_MAX = 1000

-- Table that correlates instanceIDs to mapIDs
ns["mapIDs"] = {
	[0] = 13,
	[1] = 12,
	[530] = 101,
	[571] = 113,
	[870] = 424,
	[1116] = 572,
	[1220] = 619,
	[1642] = 875,
	[1643] = 876,
	[2222] = 1550,
	[2444] = 1978,
	[2454] = 2133
}

--- Event frame that refreshes pins on the world map.
CreateFrame("Frame", "mapupdateframe", UIParent)
mapupdateframe:RegisterEvent("QUEST_LOG_UPDATE")
mapupdateframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "QUEST_LOG_UPDATE" then
		-- Create frames for pins if they have not yet been created
		if not emptyFramesCreated then ns:CreateEmptyPinMapFrames() end
		ns:RefreshMap()
	end
end)

function ns:CreateEmptyPinMapFrames()
	for i=1,PIN_MAX do
		local pin = CreateFrame("Frame", "MFPPin_" .. tostring(i), nil)

		pin:SetWidth(16)
		pin:SetHeight(16)

		pin.texture = pin:CreateTexture()
		pin.texture:SetTexture("Interface\\MINIMAP\\ObjectIcons.blp")
		pin.texture:SetTexCoord(0.625, 0.750, 0.125, 0.250)
		pin.texture:SetAllPoints()

		pin:SetFrameStrata("TOOLTIP")

		MapPinFrames[i] = pin
	end
	emptyFramesCreated = true
end

--- Runs through entire missing nodes database and places pins on map in appropriate locations.
function ns:RefreshMap()
	-- Hide all map pins
	for i=1,#(MapPinFrames) do
		MapPinFrames[i]:Hide()
	end

	local pinIndex = 1

	-- Loop through database
	for instanceID, lockedNodes in pairs(MFP_LockedNodes) do

		-- Loop through each group of locked nodes
		for i=1,#(lockedNodes) do
			if pinIndex > PIN_MAX then
				break
			else
				ns:PlaceNodeOnWorldMap(lockedNodes[i], pinIndex)
			end
			pinIndex = pinIndex + 1
		end
	end
end

--- Creates the pin, sets its attributes, and places it on the map.
-- Using HereBeDragons-Pins-2.
-- @param UiMapID The map ID to place pins on.
-- @param nodes List of nodes from the missing database, where the key is the instanceID.
function ns:PlaceNodeOnWorldMap(node, pinIndex)

	local pin = MapPinFrames[pinIndex]

	pin:HookScript("OnEnter", function()
		GameTooltip:SetOwner(pin, "ANCHOR_TOP")
		GameTooltip:AddLine(node.name, 0, 1, 0)
		GameTooltip:Show()
	end)
	
	pin:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	if node.UiMapID then
		MFPGlobal.pins:AddWorldMapIconMap(self, pin, node.UiMapID, node.X, node.Y, HBD_PINS_WORLDMAP_SHOW_WORLD)
	end
end
