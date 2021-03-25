------------------------------------------------------------------------------------------
-- Special Nodes --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

local addon, ns = ... -- Addon name & common namespace

--- The Kul Tiras ferry node names and x&y coordinates.
local KulTirasFerryNodes = {
	{
		name = "Anglepoint Wharf, Tiragarde Sound",
		x = "0.43265134096146",
		y = "0.53354406356812"
	},
	{
		name = "Old Drust Road, Tiragarde Sound",
		x = "0.50041884183884",
		y = "0.6606656908989"
	},
	{
		name = "Firebreaker Expedition, Tiragarde Sound",
		x = "0.55638957023621",
		y = "0.53236401081085"
	},
	{
		name = "Southwind Station, Tiragarde Sound",
		x = "0.57262217998505",
		y = "0.64078992605209"
	},
	{
		name = "Fallhaven, Drustvar",
		x = "0.44013005495071",
		y = "0.63971048593521"
	},
	{
		name = "Fletcher's Hollow, Drustvar",
		x = "0.47386223077774",
		y = "0.73052299022675"
	},
	{
		name = "Eastpoint Station, Tiragarde Sound",
		x = "0.61797845363617",
		y = "0.60975468158722"
	},
	{
		name = "Eastpoint Station, Tiragarde Sound",
		x = "0.61410176753998",
		y = "0.60993653535843"
	},
	{
		name = "Tradewinds Market, Tiragarde Sound",
		x = "0.62087142467499",
		y = "0.50514781475067"
	}
}

--- NPCs that operate the Kul Tiras ferries for Alliance players.
local TiragardeSoundNPCs = {
	"Rosha Carrol",
	"Will Melborne",
	"Denzel Crocker",
	"Barry Oliver",
	"Helen Waterview",
	"Ian Glassel",
	"Theresa Norman",
	"Bindy Bracklesprig"
}

-- Nodes that are for Vashj'ir travel.
local UnderwaterVashjirNodes = {
	{
		name = "Smuggler's Scar, Vashj'ir",
		x = "0.36059021949768",
		y = "0.58064758777618"
	},
	{
		name = "Silver Tide Hollow, Vashj'ir",
		x = "0.34085690975189",
		y = "0.63654386997223"
	},
	{
		name = "Legion's Rest, Vashj'ir",
		x = "0.34294891357422",
		y = "0.66232764720917"
	},
	{
		name = "Tenebrous Cavern, Vashj'ir",
		x = "0.29691690206528",
		y = "0.65136468410492"
	},
	{
		name = "Sandy Beach, Vashj'ir",
		x = "0.35492795705795",
		y = "0.62046921253204"
	},
	{
		name = "Sandy Beach, Vashj'ir",
		x = "0.35030215978622",
		y = "0.60566824674606"
	},
	{
		name = "Stygian Bounty, Vashj'ir",
		x = "0.34102922677994",
		y = "0.66507315635681"
	},
	{
		name = "Tranquil Wash, Vashj'ir",
		x = "0.34028750658035",
		y = "0.65535771846771"
	},
	{
		name = "Darkbreak Cove, Vashj'ir",
		x = "0.30014282464981",
		y = "0.66588640213013"
	},
	{
		name = "Voldrin's Hold, Vashj'ir",
		x = "0.34967428445816",
		y = "0.67721104621887"
	}
}

--- Nodes we want  to ignore in this addon.
-- We ignore flight points that are gone in present time
-- (Teldrassil, N'zoth Invasions, etc.)
-- Also ignore some broken nodes and nodes hidden to player normally.
local InvalidNames = {
	-- Have been destroyed or otherwise removed
	"Grove of the Ancients, Darkshore",
	"Lor'danel, Darkshore",
	"Rut'theran Village, Teldrassil",
	"Darnassus, Teldrassil",
	"Dolanaar, Teldrassil",
	"Schnottz's Landing, Uldum",
	-- Unused by both factions
	"Southwind Village, Silithus",
	"Dreadpearl, Zuldazar",
	-- For a quest, not in flight path network
	"Quest - Hellfire Peninsula (Alliance) End",
	-- One way from Borean Tundra to Coldarra, not in flight path network
	"Amber Ledge, Borean (to Coldarra)",
	"Transitus Shield, Coldarra (NOT USED)",
	-- These seem broken by always showing as missing
	"Atal'Gral, Zuldazar",
	"Devoted Sanctuary, Vol'dun",
	"Temple of Karabor, Shadowmoon Valley",
	-- Only useable by Kyrian players
	"Elysian Hold, Bastion",
	-- Bastion flight paths normally hidden from players
	"[Hidden] 9.0 Bastion Ground Points Hub (Ground TP out to here, TP to Sanctum from here)",
	"[Hidden] 9.0 Bastion Ground Hub (Sanctum TP out to here, TP to ground from here)"
}

ns[1] = KulTirasFerryNodes
ns[2] = TiragardeSoundNPCs
ns[3] = UnderwaterVashjirNodes
ns[4] = InvalidNames