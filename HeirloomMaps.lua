------------------------------------------------------------------------------------------
-- Heirloom Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

MapFrames = {}

MapIDs = {
	150743, -- Surviving Kalimdor
	150746, -- To Modernize the Provisioning of Azeroth
	150744, -- Walking Kalimdor with the Earthmother
	150745  -- The Azeroth Campaign
}

for i=1,4 do

	local itemID, toyName = C_ToyBox.GetToyInfo(MapIDs[i])
	local itemLink = C_ToyBox.GetToyLink(itemID)
	
	-- Create frame
	local f = nil
	if i == 1 then
		f = CreateFrame("Button", "HeirloomIcon1", UIPARENT, "SecureActionButtonTemplate")
		f:SetPoint("CENTER", 0, 0)
	else
		f = CreateFrame("Button", "HeirloomIcon1", MapFrames[i-1], "SecureActionButtonTemplate")
		f:SetPoint("RIGHT", 30, 0)
	end
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

	MapFrames[i] = f
end
