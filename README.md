# MissingFlightPaths

## Description
In the World of Warcraft, there is no easy way to see what flight points any given character has not yet unlocked at a glance. With this addon, you will be able to display all locked flight points on your world map. This can help you to remember to grab them when you are nearby, or check to see if you are missing any old ones for curiosity's sake.

## Download Locations
* [GitHub release](https://github.com/taylor-meyer/Missing-Flight-Paths/releases)
* [CurseForge](https://www.curseforge.com/wow/addons/missingflightpaths)
* [WoWInterface](https://www.wowinterface.com/downloads/info25772-MissingFlightPaths.html)

## How to Install
Download the latest [release](https://github.com/taylor-meyer/Missing-Flight-Paths/releases), and extract it to "World of Warcraft\\_retail_\Interface\AddOns\\" folder.

## How to Use
Talking to any flight master will refresh the addon's database of the flight points you do not yet have access to. Now that those missing points have been saved to the database, you can open your world map and those points will appear on the continent view for whichever continent you are on. You will need to go to a flight master on each continent in order for the database to refresh for said continent.

A unique database is saved for each character. The flight points only appear on continent view of the world map e.g. a flight point in Durotar will not show as missing on the Durotar map, but it will show as missing on the Kalimdor map.

For convience sake, two buttons have been added to the top of the taxi frame (the map that opens when you talk to a flight master) that will let you use your account bound maps to discover some of the flight points. These are named [[The Azeroth Campaign]](https://www.wowhead.com/item=150745/the-azeroth-campaign), and so on.

Some less important flight points will not be saved to the database. These include, the underwater Vashj'ir "flight" points, the old flight points in Teldrassil and Darkshore, and one flight point in Uldum that is not because of the N'zoth invasion, to name a few. Any flight point that requires you to speak with a bronze dragon to travel to an old phase is not saved to the database. This might change in the future however, if there is demand for it.

## Issues
* Flight points marked as missing on your world map for Pandaria and Draenor are skewed a bit from their actual location. I suspect this is because the taxi frames from where those coordinates are are different and are sized differently then the type of frame used in every other continent. Checking the flight point's name by mouse over will indicate to you where to go to unlock it.

## Future
* Will remove account bound map buttons from showing if the player is not located on the appropriate continent.
* Missing flight points will be appropriately shown on the zone map, in addition to the continent map.

## Contact
Please email me at lypidius@gmail.com to report a bug or give feedback. Screenshots help! You can also comment on either download page, or open an issue on GitHub.