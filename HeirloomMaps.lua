------------------------------------------------------------------------------------------
-- Heirloom Maps --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

local MapFrames = {}

local MapIDs = {
	150743, -- Surviving Kalimdor
	150746, -- To Modernize the Provisioning of Azeroth
	150744, -- Walking Kalimdor with the Earthmother
	150745  -- The Azeroth Campaign
}

function ns:CreateNewHeirloomIcons(loc)
	local tabl = ns[5]

	local frameType = nil
	for i=1,#tabl do
		if tabl[i] == loc then
			frameType = TaxiFrame
			break
		else
			frameType = FlightMapFrame
		end
	end
	
	for i=1,4 do
		local itemID, toyName = C_ToyBox.GetToyInfo(MapIDs[i])
		local itemLink = C_ToyBox.GetToyLink(itemID)
		
		-- Create frame
		local f = nil
		if i == 1 then
			f = CreateFrame("Button", "HeirloomIcon1", frameType, "SecureActionButtonTemplate")
			
			if frameType == TaxiFrame then
				f:SetPoint("BOTTOM", 0, -30)
			else
				f:SetPoint("TOP", 0, 30)
			end
			
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
	
	local tf = CreateFrame("Frame", "TextFrame", MapFrames[1])
	tf:SetPoint("CENTER", -60, 0)
	tf:SetSize(60,40)
	
	local text = TextFrame:CreateFontString("ClickText", "OVERLAY", "GameFontNormal")
	text:SetPoint("CENTER", 0, 0)
	text:SetText("Click these ->")
end
