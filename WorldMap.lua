------------------------------------------------------------------------------------------
-- Missing Flight Paths --
--------------------
-- Author: Lypidius @ US-MoonGuard

--Continents TODO:
-- EK
-- Kalimdor
-- Outland
-- Northrend
-- Pandaria
-- Draenor
-- Broken Isles
-- KT & Zandalar
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace

MFPGlobal = { }

MFPGlobal.hbd = LibStub("HereBeDragons-2.0")
MFPGlobal.pins = LibStub("HereBeDragons-Pins-2.0")

CreateFrame("Frame", "savedvariableframe", UIParent)
savedvariableframe:RegisterEvent("ADDON_LOADED")
savedvariableframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MissingFlightPaths" then 
        if MissingNodes == nil then
            MissingNodes = {}
        end
	end
end)

CreateFrame("Frame", "refreshdbframe", UIParent)
refreshdbframe:RegisterEvent("TAXIMAP_OPENED")
refreshdbframe:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
		local _,_,instanceID = MFPGlobal.hbd:GetPlayerWorldPosition()
		ns:SaveMissingNodes(instanceID)
	end
end)

CreateFrame("Frame", "mapupdateframe", UIParent)
mapupdateframe:RegisterEvent("QUEST_LOG_UPDATE")
mapupdateframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "QUEST_LOG_UPDATE" then
		ns:RefreshMap()
	end
end)

function ns:RefreshDB()
end

function ns:SaveMissingNodes(instanceID)
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	MissingNodes[instanceID] = {}
	local nodes = {}
		for i=1,table.getn(taxiNodes) do
			if taxiNodes[i].state == 2 then
				local X,Y = ns:FindXYPos(taxiNodes[i].name)
				local node = {
					name = taxiNodes[i].name,
					x = X,
					y = Y
				}
				nodes[#(nodes) + 1] = node
			end
		end
	MissingNodes[instanceID] = nodes
end

function ns:FindXYPos(n)
	local numNodes = NumTaxiNodes()
	for i=1,numNodes do
		if TaxiNodeName(i) == n then
			return TaxiNodePosition(i);
		end
	end
end

function ns:IsKyrianTransportNode(nodes)
	for i=1,table.getn(nodes) do
		if nodes[i].state == 0 then -- current node
			if nodes[i].textureKit ~= nil then
				return true
			end
			return false
		end
	end
	return false
end

function ns:RefreshMap()

	--print("#(MissingNodes): " .. #(MissingNodes))

	MFPGlobal.pins:RemoveAllWorldMapIcons(self)
	
	if MissingNodes[0] ~= nil then
		ns:PlacePointsOnWorldMap(13, MissingNodes[0])
	end
	
	if MissingNodes[1116] ~= nil then
		ns:PlacePointsOnWorldMap(572, MissingNodes[1116])
	end
	
	if MissingNodes[1220] ~= nil then
		ns:PlacePointsOnWorldMap(619, MissingNodes[1220])
	end

	
end

function ns:PlacePointsOnWorldMap(UiMapID, nodes)

	for i=1,#(nodes) do
	
		local node = nodes[i]
	
		local pin = CreateFrame("Frame", "MFPWorldMapPin_" .. node.name, nil)
		pin:SetWidth(16)
		pin:SetHeight(16)
	
		pin:HookScript("OnEnter", function()
			GameTooltip:SetOwner(pin, "ANCHOR_TOP")
			GameTooltip:AddLine(node.name, 0, 1, 0)
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
		
		MFPGlobal.pins:AddWorldMapIconMap(self, pin, UiMapID, node.x, node.y)
		
		pin:Show()
		
	end
end

