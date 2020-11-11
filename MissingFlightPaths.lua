------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

-- Table of placed pins
local Marks = {}

-- These zones use a different frame
-- "TaxiFrame"
local TaxiFrameIDs = {
	870, -- Pandaria
	1064, -- Isle of Thunder
	1116, -- Draenor
	1191, -- Ashran
	1464, -- Tanaan Jungle
	1152, -- Horde Garrison lv1
	1330, -- Horde Garrison lv2
	1153, -- Horde Garrison lv3
	1158, -- Alliance Garrison lv1
	1331, -- Alliance Garrison lv2
	1159  -- Alliance Garrison lv3
}

-- Event frame
CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")
TaxiOpenEventFrame:RegisterEvent("TAXIMAP_CLOSED")
TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		ClearAllMarks()
		local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
		
		--if PlayerInPandaria(instanceID) == true then
			--CreateHeirloomFrame(TaxiFrame)
		--else
		--	CreateHeirloomFrame(FlightMapFrame)
		--end
		
		if instanceID == 1643 then -- Kul Tiras
			PlaceKulTirasNodes()
		
		elseif instanceID == 0 then -- Eastern Kingdoms
			if AtUnderwaterNode() == true then
				PlaceUnderwaterVashjirNodes()
			else
				PlaceEasternKingdomsNodes()
			end
		elseif PlayerInPandaria(instanceID) == true then
			PlacePandariaNodes()
		else
			PlaceNonSpecialNodes()
		end
	end
end)

function PlaceNonSpecialNodes()
	local tabl = ns[4]
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		local tabl = ns[4]
		for j=1,table.getn(tabl) do
			if Type == "DISTANT" and IsIgnoredNode(name) == false then
				PlacePoint(name, x, y, false)
			end
		end
	end
end

function IsIgnoredNode(name)

	local tabl = ns[4]
	
	for i=1,table.getn(tabl) do
		if tabl[i] == name then
			return true
		end
	end
	return false
end

function PlacePoint(name, x, y, isDraenor)

	local f = nil
	local width = nil
	local height = nil
	if isDraenor == true then
		f = TaxiRouteMap
		width = 16
		height = 16
	else
		f = FlightMapFrame.ScrollContainer.Child
		width = 75
		height = 75
	end
	
	
	local pin = CreateFrame("Frame", "MFPPin_" .. name, f)
	pin:SetWidth(width)
	pin:SetHeight(height)
	
	pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(name, 0, 1, 0)
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
	pin:SetFrameLevel(f:GetFrameLevel() + 1)
	pin:SetPoint("CENTER", f, "TOPLEFT", x * f:GetWidth(), -y * f:GetHeight())
	
	Marks[table.getn(Marks) + 1] = pin
	pin:Show()
end

function ClearAllMarks()
	for i=1,table.getn(Marks) do
		Marks[i]:Hide()
	end
	Marks = {}
end

function PlaceKulTirasNodes()
	local targetname = GetUnitName("target")
	local ferrynames = ns[2]
	for i=1,table.getn(ferrynames) do
		if ferrynames[i] == targetname then
			return
		end
	end
	PlaceNodes(false)
end

function PlaceUnderwaterVashjirNodes()
	local tabl = ns[3]
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		for j=1,table.getn(tabl) do
			if (tabl[j].name == name and tabl[j].x == tostring(x) and tabl[j].y == tostring(y))
			then
				if Type == "DISTANT" then
					PlacePoint(name, x, y, false)
				end
			end
		end
	end
end

function PlacePandariaNodes()
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if Type == "DISTANT" then
			PlacePoint(name, x, y, true)
		end
	end
end

function PlayerInPandaria(instanceID)
	for i=1,table.getn(TaxiFrameIDs) do
		if TaxiFrameIDs[i] == instanceID then
			return true
		end
	end
	return false
end

function AtUnderwaterNode()
	local targetname = GetUnitName("target")
	if targetname == "Swift Seahorse" then
		return true
	end
	return false
end

function PlaceEasternKingdomsNodes()
	local tabl = ns[3]
	for i=1,NumTaxiNodes() do
		local x,y = TaxiNodePosition(i)
		local Type = TaxiNodeGetType(i)
		local name = TaxiNodeName(i)
		if IsUnderwaterNode(name, x, y) == false then
			if Type == "DISTANT" then
				PlacePoint(name, x, y)
			end
		end
	end
end

function IsUnderwaterNode(name, x, y)
	local tabl = ns[3]
	for i=1,table.getn(tabl) do
		if (tabl[i].name == name and tabl[i].x == tostring(x) and tabl[i].y == tostring(y))
		then
			return true
		end
	end
	return false
end




print("MFP loaded. Thanks for downloading!")









-- Surviving Kalimdor
local _,itemLink1,_,_,_,_,_,_,_,_,_ = GetItemInfo(150743)
--print(itemLink1)
local f = CreateFrame("Frame", "HeirloomIcon1", UIPARENT, BackdropTemplateMixin and "BackdropTemplate") 
f:SetPoint("CENTER", 250, 250)
f:SetSize(25,25)

local tex = GetItemIcon(150743)
f.texture = f:CreateTexture()
f.texture:SetTexture(tex)
f.texture:SetAllPoints(f)
f:HookScript("OnEnter", function()
	if (tex) then
		GameTooltip:SetOwner(f, "ANCHOR_TOP")
		GameTooltip:SetHyperlink(itemLink1)
		GameTooltip:Show()
	end
end)
	
f:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)




-- To Modernize the Provisioning of2 Azeroth
local _,itemLink2,_,_,_,_,_,_,_,_,_ = GetItemInfo(150746)
--print(itemLink2)
f2 = CreateFrame("Frame", "HeirloomIcon2", UIPARENT, BackdropTemplateMixin and "BackdropTemplate") 
f2:SetPoint("TOP", HeirloomIcon1, "BOTTOM", 0, 0)
f2:SetSize(25,25)

tex = GetItemIcon(150746)
f2.texture = f2:CreateTexture()
f2.texture:SetTexture(tex)
f2.texture:SetAllPoints(f2)
f2:HookScript("OnEnter", function()
	if (tex) then
		GameTooltip:SetOwner(f2, "ANCHOR_TOP")
		GameTooltip:SetHyperlink(itemLink2)
		GameTooltip:Show()
	end
end)
	
f2:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)





-- Walking Kalimdor with the Earthmother
local _,itemLink3,_,_,_,_,_,_,_,_,_ = GetItemInfo(150745)
f3 = CreateFrame("Frame", "HeirloomIcon3", UIPARENT, BackdropTemplateMixin and "BackdropTemplate") 
f3:SetPoint("TOP", HeirloomIcon2, "BOTTOM", 0, 0)
f3:SetSize(25,25)

tex = GetItemIcon(150745)
f3.texture = f3:CreateTexture()
f3.texture:SetTexture(tex)
f3.texture:SetAllPoints(f3)
f3:HookScript("OnEnter", function()
	if (tex) then
		GameTooltip:SetOwner(f3, "ANCHOR_TOP")
		GameTooltip:SetHyperlink(itemLink3)
		GameTooltip:Show()
	end
end)
	
f3:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)




-- The Azeroth Campaign
local _,itemLink4,_,_,_,_,_,_,_,_,_ = GetItemInfo(150744)
f4 = CreateFrame("Frame", "HeirloomIcon4", UIPARENT, BackdropTemplateMixin and "BackdropTemplate") 
f4:SetPoint("TOP", HeirloomIcon3, "BOTTOM", 0, 0)
f4:SetSize(25,25)

tex = GetItemIcon(150744)
f4.texture = f4:CreateTexture()
f4.texture:SetTexture(tex)
f4.texture:SetAllPoints(f4)
f4:HookScript("OnEnter", function()
	if (tex) then
		GameTooltip:SetOwner(f4, "ANCHOR_TOP")
		GameTooltip:SetHyperlink(itemLink4)
		GameTooltip:Show()
	end
end)
	
f4:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)












