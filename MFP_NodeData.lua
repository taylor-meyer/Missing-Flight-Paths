------------------------------------------------------------------------------------------
-- Node Data --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

local addon, ns = ... -- Addon name & common namespace

-- Ignored Nodes
ns["badnodes"] = {
	-- Darnassus has been destroyed. If you are in present
	-- time phase, these old nodes appear as locked.
	-- TODO: Investigate a way to detect current phase.
	26, -- Lor'danel, Darkshore
	27, -- Rut'theran Village, Teldrassil
	339, -- Grove of the Ancients, Darkshore
	456, -- Dolanaar, Teldrassil
	457, -- Darnassus, Teldrassil

	-- These nodes are for the Vashj'ir seahorse network
	-- TODO: Determine best way to differentiate between the two networks.
	521, -- Smuggler's Scar, Vashj'ir
	522, -- Silver Tide Hollow, Vashj'ir
	523, -- Tranquil Wash, Vashj'ir (Alliance only)
	524, -- Darkbreak Cove, Vashj'ir (Alliance only)
	525, -- Legion's Rest, Vashj'ir
	526, -- Tenebrous Cavern, Vashj'ir
	607, -- Sandy Beach, Vashj'ir (Alliance only)
	609, -- Sandy Beach, Vashj'ir
	611, -- Voldrin's Hold, Vashj'r (Alliance only)
	612, -- Stygian Bounty, Vashj'ir

	-- Schnottz's Landing is active in the Cataclysm phase of Uldum.
	-- The N'Zoth Assaults removed this node from their phase, but 
	-- the node still appears as missing until you change the phase
	-- back. This is true even if player is browing FlightMap from
	-- a different zone.
	-- TODO: Investigate a way to detect current phase.
	674, -- Schnottz's Landing, Uldum

	-- Broken or unused at max level
	-- Possibly used while leveling/questing
	2066, -- Atal'Gral, Zuldazar
	2071, -- Dreadpearl, Zuldazar

	-- BFA Alliance Ferry
	2105, -- Tradewinds Market, Tiragarde Sound
	2052, -- Anglepoint Wharf, Tiragarde Sound
	2053, -- Old Drust Road, Tiragarde Sound
	2054, -- Firebreaker Expedition, Tiragarde Sound
	2055, -- Southwind Station, Tiragarde Sound
	2056, -- Fallhaven, Drustvar
	2057, -- Fletcher's Hollow, Drustvar
	2104, -- Eastpoint Station, Tiragarde Sound

	-- Broken or unused at max level
	-- Possibly used while leveling/questing
	2162, -- Devoted Sanctuary, Vol'dun

	-- For Kyrian players only, and they will automatically have it
	2528,-- Elysian Hold, Bastion

	-- The Maw
	2698, -- Keeper's Respite, Korthia
	2700, -- Ve'nari's Refuge, The Maw

	-- Dragonflight, Ancient Waygates
	2836,
	2837,
	2838,
	2839,
	2841,
	2842,

	-- Dragonflight, Zaralek Cavern transitions
	2866,
	2867,
	2874,
	2875,
	2876,
	2877
}
