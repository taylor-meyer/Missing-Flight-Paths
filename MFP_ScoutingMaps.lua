------------------------------------------------------------------------------------------
-- Scouting Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

function ns:CreateMapButton(ExpansionName, instanceID, toyID)

	local f = CreateFrame("Button", "MFP_" .. ExpansionName .. "MapButton", UIParent, "SecureActionButtonTemplate")
	f:SetSize(50,50)

	f.texture = f:CreateTexture()
	f.texture:SetTexture(GetItemIcon(toyID))
	f.texture:SetAllPoints(f)

	f:HookScript("OnEnter", function()
		if (C_ToyBox.GetToyLink(toyID)) then
			GameTooltip:SetOwner(f, "ANCHOR_TOP")
			GameTooltip:SetHyperlink(C_ToyBox.GetToyLink(toyID))
			GameTooltip:Show()
		end
	end)
	f:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	f:SetAttribute("type", "toy")
	f:SetAttribute("toy", toyID)

	ns.MapButtonFrames[instanceID] = f
end

function ns:HideAllMaps()
	for key,_ in pairs(ns.MapButtonFrames) do
		ns.MapButtonFrames[key]:Hide()
	end
end

ns.MapButtonFrames = {}

ns:CreateMapButton("AllianceEasternKingdoms", 0, 150746)
ns:CreateMapButton("AllianceKalimdor", 1, 150743)
ns:CreateMapButton("HordeEasternKingdoms", 2, 150745)
ns:CreateMapButton("HordeKalimdor", 3, 150744)
ns:CreateMapButton("TheBurningCrusade", 530, 187899)
ns:CreateMapButton("WrathOfTheLichKing", 571, 187898)
ns:CreateMapButton("Cataclysm", 646, 187897)
ns:CreateMapButton("MistsOfPandaria", 870, 187896)
ns:CreateMapButton("WarlordsOfDraenor", 1116, 187895)
ns:CreateMapButton("Legion", 1220, 187875)
ns:CreateMapButton("BattleForAzeroth", 1642, 187900)
ns:CreateMapButton("Shadowlands", 2222, 187869)

-- Event frame
CreateFrame("Frame", "MFP_MapHideShowFrame", UIParent)
MFP_MapHideShowFrame:RegisterEvent("TAXIMAP_OPENED")
MFP_MapHideShowFrame:RegisterEvent("TAXIMAP_CLOSED")
MFP_MapHideShowFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then

		local player_faction = UnitFactionGroup("player")
		if player_faction == "Neutral" then
			--print("Neutral faction, breaking.")
			return
		end

		local _,_,instanceID = MFPGlobal.hbd:GetPlayerWorldPosition()
		
		local button = nil

		--print("instanceID: " .. tostring(instanceID))
		if instanceID == 0 and player_faction == 'Alliance' then
			--print("Alliance EK")
			button = ns.MapButtonFrames[0]
			local CataclysmButton = ns.MapButtonFrames[646]
			CataclysmButton:SetPoint("LEFT", button, "RIGHT", 5, 0)
			CataclysmButton:Show()
		elseif instanceID == 1 and player_faction == 'Alliance' then
			--print("Alliance Kalim")
			button = ns.MapButtonFrames[1]
			local CataclysmButton = ns.MapButtonFrames[646]
			CataclysmButton:SetPoint("LEFT", button, "RIGHT", 5, 0)
			CataclysmButton:Show()
		elseif instanceID == 0 and player_faction == 'Horde' then
			--print("Horde EK")
			button = ns.MapButtonFrames[2]
			local CataclysmButton = ns.MapButtonFrames[646]
			CataclysmButton:SetPoint("LEFT", button, "RIGHT", 5, 0)
			CataclysmButton:Show()
		elseif instanceID == 1 and player_faction == 'Horde' then
			--print("Horde Kalim")
			button = ns.MapButtonFrames[3]
			local CataclysmButton = ns.MapButtonFrames[646]
			CataclysmButton:SetPoint("LEFT", button, "RIGHT", 5, 0)
			CataclysmButton:Show()
		elseif instanceID == 530 then
			button = ns.MapButtonFrames[530]
		elseif instanceID == 571 then
			button = ns.MapButtonFrames[571]
		elseif instanceID == 870 then
			button = ns.MapButtonFrames[870]
		elseif instanceID == 1116 then
			button = ns.MapButtonFrames[1116]
		elseif instanceID == 1220 then
			button = ns.MapButtonFrames[1220]
		elseif instanceID == 1642 or instanceID == 1643 or instanceID == 1718 then
			button = ns.MapButtonFrames[1642]
		elseif instanceID == 2222 then
			button = ns.MapButtonFrames[2222]
		end

		if button ~= nil then
			button:SetPoint("BOTTOM", FlightMapFrame, "TOP", -15, 5)
			button:Show()
		end
	end

	if event == "TAXIMAP_CLOSED" then
		ns:HideAllMaps()
	end
end)