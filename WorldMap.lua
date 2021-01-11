
local addon, ns = ... -- Addon name & common namespace

local savedvariableframe = CreateFrame("Frame")
savedvariableframe:RegisterEvent("ADDON_LOADED")
savedvariableframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MissingFlightPaths" then
        -- Our saved variables, if they exist, have been loaded at this point.
        if MissingNodes == nil then
            -- This is the first time this addon is loaded; set SVs to default values
            MissingNodes = {}
        end
	end
end)

-- Event frame
CreateFrame("Frame", "eventFrame", UIParent)
eventFrame:RegisterEvent("TAXIMAP_OPENED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "TAXIMAP_OPENED" then
	
		ns:RefreshDB()
		
	end
end)

function ns:RefreshDB()
	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
	if ns:IsKyrianTransportNode(taxiNodes) == false then
		
		for i=1,table.getn(taxiNodes) do
		
			if ns:DBContains(taxiNodes[i].nodeID) == false then
			
				if taxiNodes[i].state == 2 then
				
					MissingNodes[table.getn(MissingNodes)+1] = taxiNodes[i]
				
				end
			
			end
		
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
			print("true")
			return true
		end
	
	end
	print("return false")
	return false
end

function ns:PlacePointOnWorldMap(name, x, y)

	local _, _, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
	local f = nil
	local width = nil
	local height = nil
	if isDraenor == true then
		f = TaxiRouteMap
		width = 16
		height = 16
	else
		f = FlightMapFrame.ScrollContainer.Child
		if instanceID == 2222 then
			width = 40
			height = 40
		else
			width = 75
			height = 75
		end
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

