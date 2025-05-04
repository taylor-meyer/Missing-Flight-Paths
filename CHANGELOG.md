# Changelog
## v2.1.4
* Updated for The War Within 11.1.5

## v2.1.3
* Updated for The War Within 11.1.0
* Add map compatibility with Undermine
* Remove calls to scouting map functions

## v2.1.2
* Fix bug in Nerub-ar Palace

## v2.1.1
* Updated for The War Within 11.0.7

## v2.1.0
* Updated for The War Within 11.0.0

## v2.0.0
* Complete rework under the hood
* Updated for Dragonflight 10.1.0

## v1.3.8
* Removed leftover print statements used for tests

## v1.3.7
* Updated to work with patch 9.1.5
* Fixed bug where a Pandaren's faction being set to neutral caused a crash when trying to determine the correct scouting map for use with quick use button.

## v1.3.6
* Stopped excess creation of frames on the world map when player opens the map

## v1.3.5
* Update to work with patch 9.1.0
* Using the Animaflow Teleporters in the Maw/Korthia will no longer mark all of the Shadowlands flight points as missing

## v1.3.4
* Using Kyrian transport network no longer marks all Shadowlands flight paths as missing

## v1.3.3
* Ignore node named "Temple of Karabor, Shadowmoon Valley" as it appears to be unused and always appears as missing

## v1.3.2
* Update to work with patch 9.0.5
* Buttons for quick use of account-bound map toys now only appear when talking to a flight master on Eastern Kingdoms or Kalimdor
* Major code cleanup

## v1.3
* Added missing nodes to world map. Players need to talk to flight master once for database of missing nodes to update. Pins will show up on the continent view of any particular landmass
* Minor code cleanup

## v1.2
* Reduced size of exclamation marks on Shadowlands map to appear more readable
* Fixed issue where Kyrian players would see all normal flight paths as missing when opening the Bastion transport network

## v1.1
* Fixed issue where an Alliance character opening the taxi/flight map in Kul Tiras would cause a lua error
* Added Kyrian covenant sanctum flight node to list of ignored nodes. Kyrian players will already have it, non-Kyrian players will never need it
