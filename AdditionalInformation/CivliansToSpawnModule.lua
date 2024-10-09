local CivliansToSpawnModule = {} -- Purely for usage of Npcs spawn, to quickly give table filled with what type of stats and values in them should be used by received Class/Type of Npc to spawn

CivliansToSpawnModule.TypesOfNpcsToSpawn = {

	["SpawnRebelion"] = {["MainRank"] = "Rebelion"; ["GunEquipped"] = true};
	["SpawnCivilianWithoutGun"] = {["MainRank"] = "Civilian"; ["GunEquipped"] = false};
	["SpawnCivilianWithGun"] = {["MainRank"] = "Civilian"; ["GunEquipped"] = true};

}


return CivliansToSpawnModule
