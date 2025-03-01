------------------------------------------------------------------------------------------
-- Missing Flight Paths Helpers --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

-- libs
MFPGlobal = {}
MFPGlobal.hbd = LibStub("HereBeDragons-2.0")
MFPGlobal.pins = LibStub("HereBeDragons-Pins-2.0")

--- Saved Variable frame
CreateFrame("Frame", "savedvariableframe", UIParent)
savedvariableframe:RegisterEvent("ADDON_LOADED")
savedvariableframe:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MissingFlightPaths" then
		if MFP_LockedNodes == nil then
            MFP_LockedNodes = {}
        end
	end
end)

function ns:GetInstanceID()
    local _,_,id = MFPGlobal.hbd:GetPlayerWorldPosition()
	return id
end

function ns:FilterBadNodes(t)
    for i = #t, 1, -1 do
        for j=1, #ns["badnodes"] do
            if t[i].nodeID == ns["badnodes"][j] then
                table.remove(t, i)
                break
            end
        end
    end
end

function ns:IsBadNode(node)
    if ns.DEBUG_MODE == true then DevTool:AddData(node, "IsBadNode:node") end
    for _,v in pairs(ns["badnodes"]) do
        if v == node.nodeID then return true end
    end
    return false
end


function ns:printNodeIDsfromNodes(tab)
    for i,v in pairs(tab) do
        print("i: " .. i .. "      v: " .. v.nodeID)
    end
end