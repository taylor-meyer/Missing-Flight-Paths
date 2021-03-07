------------------------------------------------------------------------------------------
-- Heirloom Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

local EKMapID = nil
local KalMapID = nil
local MapFrames = {}


local function MakeEKMapIcon(itemID)
	local itemLink = C_ToyBox.GetToyLink(itemID)
	
	-- Create frame
	local f = CreateFrame("Button", "MFPSecureEKButton", UIParent, "SecureActionButtonTemplate")
	f:SetSize(25,25)
	
	-- Texture
	local tex = GetItemIcon(itemID)
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
	f:SetAttribute("toy", itemID)

	MapFrames[1] = f
end

local function MakeKalimdorMapIcon(itemID)
	local itemLink = C_ToyBox.GetToyLink(itemID)
	
	-- Create frame
	local f = CreateFrame("Button", "MFPSecureKalimdorButton", UIParent, "SecureActionButtonTemplate")
	f:SetSize(25,25)
	f:SetPoint("LEFT", MFPSecureEKButton, "RIGHT", 5, 0)
	
	-- Texture
	local tex = GetItemIcon(itemID)
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
	f:SetAttribute("toy", itemID)

	MapFrames[2] = f
end

function ns:ShowHeirloomMaps(frameType)
	if frameType == TaxiFrame then
		MapFrames[1]:SetPoint("BOTTOM", frameType, "TOP", -15, 5)
	else
		MapFrames[1]:SetPoint("BOTTOM", frameType, "TOP", -15, 5)
	end
	
	if PlayerHasToy(EKMapID) == false then
		MapFrames[1].texture:SetVertexColor(0.7, 0, 0, 1)
	else
		--MapFrames[1].texture:SetVertexColor(0, 0.7, 0, 1)
	end
	
	if PlayerHasToy(KalMapID) == false then
		MapFrames[2].texture:SetVertexColor(0.7, 0, 0, 1)
	else
		--MapFrames[2].texture:SetVertexColor(0, 0.7, 0, 1)
	end
	
	MapFrames[1]:Show()
	MapFrames[2]:Show()
end

function ns:HideHeirloomMaps()
	MapFrames[1]:Hide()
	MapFrames[2]:Hide()
end

------------------------------------------------------------------------------------------

local englishFaction = UnitFactionGroup("player")
if englishFaction == "Alliance" then
	MakeEKMapIcon(150746)
	MakeKalimdorMapIcon(150743)
	EKMapID = 150746
	KalMapID = 150743
else
	MakeEKMapIcon(150745)
	MakeKalimdorMapIcon(150744)
	EKMapID = 150745
	KalMapID = 150744
end

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

ns[6] = MapFrames
