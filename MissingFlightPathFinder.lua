print("MISSING FP FINDER")

CreateFrame("Frame", "TaxiOpenEventFrame", UIParent)

TaxiOpenEventFrame:RegisterEvent("TAXIMAP_OPENED")

TaxiOpenEventFrame:SetScript("OnEvent", function(self, event, ...)

	if event == "TAXIMAP_OPENED" then
	
		print("TAXIMAP_OPENED fired success")
	
	end

end)