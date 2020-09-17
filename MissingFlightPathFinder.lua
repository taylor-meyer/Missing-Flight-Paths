print("MISSING FP FINDER")

CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")

TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)

	if event == "TAXIMAP_OPENED" then
	
		print("TAXIMAP_OPENED fired success")
		taxiNodes = C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID())
		
		for i=1,table.getn(taxiNodes) do
		
			if taxiNodes[i].state == 2 then
			
			 print(i .. ": " .. taxiNodes[i].name .. "    Reachable: " .. taxiNodes[i].state)
			
			end
	
		end
	
	end

end)