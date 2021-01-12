
local addon, ns = ... -- Addon name & common namespace

local marks = {}

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
		ns:RefreshDB()
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

	MissingNodes = {}
	
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	
	if ns:IsKyrianTransportNode(taxiNodes) == false then
		for i=1,table.getn(taxiNodes) do
			if ns:DBContains(taxiNodes[i].nodeID) == false then
				if taxiNodes[i].state == 2 then
					local node = {
						name = taxiNodes[i].name,
						x = ns:FindXPos(taxiNodes[i].name),
						y = ns:FindYPos(taxiNodes[i].name)
					}
					MissingNodes[#(MissingNodes)+1] = node
				end
			end
		end
	end
end

function ns:FindXPos(n)
	local numNodes = NumTaxiNodes()
	for i=1,numNodes do
		if TaxiNodeName(i) == n then
			local x = TaxiNodePosition(i);
			return x
		end
	end
end

function ns:FindYPos(n)
	local numNodes = NumTaxiNodes()
	for i=1,numNodes do
		if TaxiNodeName(i) == n then
			local _,y = TaxiNodePosition(i);
			return y
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

function ns:DBContains(id)
	for i=1,table.getn(MissingNodes) do
		if MissingNodes[i].nodeID == id then
			return true
		end
	end
	return false
end




function ns:RefreshMap()
	ns:ClearAllMarks()
	if MissingNodes ~= nil then
		for i=1,#(MissingNodes) do
			ns:PlacePointOnWorldMap(MissingNodes[i])
		end
	end
end

function ns:ClearAllMarks()
	--ViragDevTool_AddData(marks, "marks")
	for i=1,#(marks) do
		marks[i]:Hide()
	end
	marks = {}
end

function ns:PlacePointOnWorldMap(node)

	local width = 100
	local height = 100
	
	local x = node.x
	local y = node.y
	
	local f = WorldMapFrame.ScrollContainer.Child
	
	
	local pin = CreateFrame("Frame", "MFPWorldMapPin_" .. node.name, f)
	pin:SetWidth(width)
	pin:SetHeight(height)
	
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
	pin:SetFrameLevel(f:GetFrameLevel() + 1)
	
	
	
	pin:SetPoint("CENTER", f, "TOPLEFT", x * f:GetWidth(), -y * f:GetHeight())
	
	marks[#(marks) + 1] = pin
	
	pin:Show()
	
	
	
	--ViragDevTool_AddData(node.name, "node.name")
	--ViragDevTool_AddData(x * f:GetWidth(), "x * f:GetWidth()")
	--ViragDevTool_AddData(y * f:GetHeight(), "y * f:GetWidth()")
	
	
	
	
	
end

