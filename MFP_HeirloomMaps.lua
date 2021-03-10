------------------------------------------------------------------------------------------
-- Heirloom Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

--- Returns player faction as a string, "Alliance" or "Horde".
-- Pandaren on The Wandering Isle will return "Neutral".
function ns:GetPlayerFaction()
	local englishFaction = UnitFactionGroup("player")
	return englishFaction
end

--- Returns ID of the Eastern Kingdoms map toy for appropriate faction.
-- @param faction String of the players faction, "Alliance or "Horde". Use ns:GetPlayerFaction().
function ns:GetEKMapID(faction)
	if faction == "Alliance" then
		return 150746
	elseif faction == "Horde" then
		return 150745
	end
end

--- Returns ID of the Kalimdor map toy for appropriate faction.
-- @param faction String of the players faction, "Alliance or "Horde". Use ns:GetPlayerFaction().
function ns:GetKaliMapID(faction)
	if faction == "Alliance" then
		return 150743
	elseif faction == "Horde" then
		return 150744
	end
end

--- Creates secure button frame that can use Easter Kingdoms map toy when pressed.
-- @param toyID The ID of the Eastern Kingdoms toy for appropriate player faction. Use ns:GetEKMapID(faction).
function ns:MakeEKMapButton(toyID)
	local itemLink = C_ToyBox.GetToyLink(toyID)
	
	-- Create frame
	local f = CreateFrame("Button", "MFPSecureEKButton", UIParent, "SecureActionButtonTemplate")
	f:SetSize(25,25)
	
	-- Texture
	local tex = GetItemIcon(toyID)
	f.texture = f:CreateTexture()
	f.texture:SetTexture(tex)
	f.texture:SetAllPoints(f)
		
	-- Mouseover tooltip
	f:HookScript("OnEnter", function()
		if (itemLink) then
			GameTooltip:SetOwner(f, "ANCHOR_TOP")
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show()
		end
	end)
	f:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Secure button click to use toy
	f:SetAttribute("type", "toy")
	f:SetAttribute("toy", toyID)

	ns.EKMapButton = f
end

--- Creates secure button frame that can use Kalimdor map toy when pressed.
-- @param toyID The ID of the Kalimdor toy for appropriate player faction. Use ns:GetKaliMapID(faction).
function ns:MakeKaliMapButton(toyID)
	local itemLink = C_ToyBox.GetToyLink(toyID)
	
	-- Create frame
	local f = CreateFrame("Button", "MFPSecureKalimdorButton", UIParent, "SecureActionButtonTemplate")
	f:SetSize(25,25)
	
	-- Texture
	local tex = GetItemIcon(toyID)
	f.texture = f:CreateTexture()
	f.texture:SetTexture(tex)
	f.texture:SetAllPoints(f)
		
	-- Mouseover tooltip
	f:HookScript("OnEnter", function()
		if (itemLink) then
			GameTooltip:SetOwner(f, "ANCHOR_TOP")
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show()
		end
	end)
	f:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Secure button click to use toy
	f:SetAttribute("type", "toy")
	f:SetAttribute("toy", toyID)

	ns.KaliMapButton = f
end

--- Shows map toy button appropriate for either the Eastern Kingdoms or Kalimdor when player talks to a flight master.
-- If player does not have the toy for that continent, it is not shown.
function ns:ShowMapButtonForCurrentContinent()
	local _,_,_,_,_,_,_,instanceID = GetInstanceInfo()
	
	if instanceID == 0 and PlayerHasToy(ns:GetEKMapID(ns:GetPlayerFaction())) then
		ns.KaliMapButton:Hide()
		ns.EKMapButton:SetPoint("BOTTOM", FlightMapFrame, "TOP", -15, 5)
		ns.EKMapButton:Show()
	elseif instanceID == 1 and PlayerHasToy(ns:GetKaliMapID(ns:GetPlayerFaction())) then
		ns.EKMapButton:Hide()
		ns.KaliMapButton:SetPoint("BOTTOM", FlightMapFrame, "TOP", -15, 5)
		ns.KaliMapButton:Show()
	end
end

ns:MakeEKMapButton(ns:GetEKMapID(ns:GetPlayerFaction()))
ns:MakeKaliMapButton(ns:GetKaliMapID(ns:GetPlayerFaction()))
