------------------------------------------------------------------------------------------
-- Scouting Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
--- This file is now OBE. Needs rework after introduction of Warbands.

-- Addon name & common namespace
local addon, ns = ...

ns.ButtonFrames = {}

-- Table of scouting maps within the toybox.
-- [instanceID] -> [toyName], [toyID]
ns["scoutingMaps"] = {
	[0] = {
		["toyName"] = "Scouting Map: Modern Provisioning of the Eastern Kingdoms",
		["toyID"] = 150746
	},
	[1] = {
		["toyName"] = "Scouting Map: Surviving Kalimdor",
		["toyID"] = 150743
	},
	[2] = {
		["toyName"] = "Scouting Map: The Eastern Kingdoms Campaign",
		["toyID"] = 150745
	},
	[3] = {
		["toyName"] = "Scouting Map: Walking Kalimdor with the Earthmother",
		["toyID"] = 150744
	},
	[530] = {
		["toyName"] = "Scouting Map: The Many Curiosities of Outland",
		["toyID"] = 187899
	},
	[571] = {
		["toyName"] = "Scouting Map: True Cost of the Northrend Campaign",
		["toyID"] = 187898
	},
	[646] = {
		["toyName"] = "Scouting Map: Cataclysm's Consequences",
		["toyID"] = 187897
	},
	[870] = {
		["toyName"] = "Scouting Map: A Stormstout's Guide to Pandaria",
		["toyID"] = 187896
	},
	[1116] = {
		["toyName"] = "Scouting Map: The Dangers of Draenor",
		["toyID"] = 187895
	},
	[1220] = {
		["toyName"] = "Scouting Map: United Fronts of the Broken Isles",
		["toyID"] = 187875
	},
	[1642] = {
		["toyName"] = "Scouting Map: The Wonders of Kul Tiras and Zandalar",
		["toyID"] = 187900
	},
	[2222] = {
		["toyName"] = "Scouting Map: Into the Shadowlands",
		["toyID"] = 187869
	}
}

function ns:CreateButtonFrames()
	for k,v in pairs(ns["scoutingMaps"]) do
		local f = CreateFrame("Button", "MFP_Button_" .. v["toyName"], UIParent, "SecureActionButtonTemplate")
		f:RegisterForClicks("AnyUp", "AnyDown")
		f:SetSize(50,50)

		f.texture = f:CreateTexture()
		f.texture:SetTexture(GetItemIcon(v["toyID"]))
		f.texture:SetAllPoints(f)

		f:HookScript("OnEnter", function()
			if (C_ToyBox.GetToyLink(v["toyID"])) then
				GameTooltip:SetOwner(f, "ANCHOR_TOP")
				GameTooltip:SetHyperlink(C_ToyBox.GetToyLink(v["toyID"]))
				GameTooltip:Show()
			end
		end)
		f:HookScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		f:SetAttribute("type", "toy")
		f:SetAttribute("toy", v["toyID"])

		ns.ButtonFrames[k] = f
	end
end

function ns:HideAllMaps()
	for _,v in pairs(ns.ButtonFrames) do
		v:Hide()
	end
end

function ns:ShowScoutingMapButton()
	local player_faction = UnitFactionGroup("player")
	if player_faction == "Neutral" then
		return
	end

	local _,_,instanceID = ns:GetInstanceID()
	
	if ns.ButtonFrames[instanceID] == nil then return end
	
	-- If player in E(0), Kalimdor(1), or Cata zone(646)
	-- we show the Cataclysm button as well
	-- button, cataclysmButton
	local b, cb = nil, nil
	
	if instanceID <= 1 then
		if player_faction == "Horde" then
			b = ns.ButtonFrames[instanceID + 2]
		else
			b = ns.ButtonFrames[instanceID]
		end
		cb = ns.ButtonFrames[646]
	else
		b = ns.ButtonFrames[instanceID]
	end


	b:SetPoint("BOTTOM", FlightMapFrame, "TOP", -15, 5)
	b:Show()
	if cb ~= nil then
		cb:SetPoint("LEFT", b, "RIGHT", 5, 0)
		cb:Show()
	end
end
