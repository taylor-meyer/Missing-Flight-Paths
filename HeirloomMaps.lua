------------------------------------------------------------------------------------------
-- Heirloom Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

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
else
	MakeEKMapIcon(150745)
	MakeKalimdorMapIcon(150744)
end

ns[6] = MapFrames
