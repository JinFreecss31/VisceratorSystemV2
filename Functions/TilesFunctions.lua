local TilesFunctions = {} -- Functions for Tiles 
TilesFunctions.VarsT = nil
TilesFunctions.CreateCurrentTileAndItsName = function(CurrentPosition, VariablesTable) -- Create Tile Name And Axis! (Will be used a lot to create or check and update tiles, to destroy as well, in some rare cases!)
	
	VariablesTable = TilesFunctions.VarsT
	local TileAxis = Vector3.new(math.floor((VariablesTable.TilesCenter.X - CurrentPosition.X) / VariablesTable.SingleTileSize), math.floor((VariablesTable.TilesCenter.Y - CurrentPosition.Y) / VariablesTable.SingleTileSize), math.floor((VariablesTable.TilesCenter.Z - CurrentPosition.Z) / VariablesTable.SingleTileSize) )
	local TileName = "X"..tostring(TileAxis.X).."Y"..tostring(TileAxis.Y).."Z"..tostring(TileAxis.Z)

	return TileAxis, TileName

end

TilesFunctions.GetAndSortAlllTilesFunction = function(VariablesTable)
	
	local SortedTilesTable = {}
	
	for _,Tiles in pairs(VariablesTable.PlayerTilesFolder:GetChildren()) do
		
		table.insert(SortedTilesTable, {["LastTimeTileUsed"] = Tiles:FindFirstChild("LastTimeTileUsed").Value; ["TileInstance"] = Tiles})
		
	end
	
	table.sort(SortedTilesTable, function(a, b)
		
		return a["LastTimeTileUsed"] < b["LastTimeTileUsed"]
		
	end)
	
	return SortedTilesTable
	
end

TilesFunctions.StoreTilesOrderInArray = function(SortedTilesToStore)
	
	local TilesTableToSearch = {}
	
	for i, SortedTiles in pairs(SortedTilesToStore) do

		TilesTableToSearch[i] = SortedTiles["TileInstance"]

	end
	
end

TilesFunctions.DestroyGivenSetOfTiles = function(FuncVarsTable, VariablesTable)
	
	repeat  -- destroy tiles quickly!

		FuncVarsTable.TotalTilesDestroyed += 1
		FuncVarsTable.CurrentTileToSearch += VariablesTable.TilesIncrementPerDestroy
		FuncVarsTable.TilesTableToSearch[FuncVarsTable.CurrentTileToSearch]:Destroy()

	until FuncVarsTable.TotalTilesDestroyed >= FuncVarsTable.TilesToDestroy

	if FuncVarsTable.NewFakeTile and FuncVarsTable.NewFakeTile.Parent == VariablesTable.PlayerTilesFolder then -- check if fake tile still exist then destroy it!

		FuncVarsTable.NewFakeTile:Destroy()

	end

	FuncVarsTable.HideTileAtVisc.Parent = VariablesTable.PlayerTilesFolder
	-- finished i guess!!!
	
end


TilesFunctions.DestroyTilesOnExhausting = function(VariablesTable) -- Destroy all tiles but only in case when Limit of them per the same moment are reached!
	
	local FunctionsVariablesTable = {}
	FunctionsVariablesTable.TilesToDestroy = VariablesTable.TilesToDestroyInTotal 
	FunctionsVariablesTable.TotalTilesDestroyed = 0
	FunctionsVariablesTable.CurrentTileToSearch = -1
	FunctionsVariablesTable.SortedTilesTable = {} -- Use this table to get all tiles and sort by when they were updated lastly!
	FunctionsVariablesTable.TilesTableToSearch = {} -- Final table which will help to put sorted tables in keys and easily receive them to destroy then!
	FunctionsVariablesTable.HideTileAtVisc = VariablesTable.PlayerTilesFolder:FindFirstChild(VariablesTable.CurrentTileVisceratorAt) -- just cur tile which is using to hide if it somehow can be destroyed!
	FunctionsVariablesTable.HideTileAtVisc.Parent = game.ReplicatedStorage -- gonna switch it to rep and clone other of it to use for destroying and and then return original one tile!
	FunctionsVariablesTable.NewFakeTile = FunctionsVariablesTable.HideTileAtViscHideTileAtVisc:Clone() -- Fake Tile for the trick above!
	FunctionsVariablesTable.NewFakeTile.Parent = VariablesTable.PlayerTilesFolder

	FunctionsVariablesTable.SortedTilesTable = TilesFunctions.GetAndSortAlllTilesFunction(VariablesTable)

	FunctionsVariablesTable.TilesTableToSearch = TilesFunctions.StoreTilesOrderInArray(FunctionsVariablesTable.SortedTilesTable)

	TilesFunctions.DestroyGivenSetOfTiles(FunctionsVariablesTable, VariablesTable)
	

end

TilesFunctions.CreateTilePartPosition = function(TileAxis, VariablesTable)
	
	return Vector3.new(VariablesTable.TilesCenter.X - (TileAxis.X * VariablesTable.SingleTileSize) - (VariablesTable.SingleTileSize/2), VariablesTable.TilesCenter.Y - (TileAxis.Y * VariablesTable.SingleTileSize) - (VariablesTable.SingleTileSize/2), VariablesTable.TilesCenter.Z - (TileAxis.Z * VariablesTable.SingleTileSize) - (VariablesTable.SingleTileSize/2))
	
end

TilesFunctions.CreateTileFolder = function(TileAxis, TileName, HumanoidRootPartPosition, VariablesTable)
	
	VariablesTable.TotalTilesCreated += 1
	--TotalTimesTilesUsed += 1
	local NewTileFolder = VariablesTable.TileFolderExample:Clone()
	NewTileFolder.Name = TileName
	NewTileFolder.TileName.Value = TileName -- Unique name
	NewTileFolder.TilePosition.Value = TileAxis -- Vector3
	NewTileFolder.SpecialPosition.Value = HumanoidRootPartPosition -- HRP.Position!
	NewTileFolder.TileCreatedOrder.Value = VariablesTable.TotalTilesCreated -- Just unique numb of when tile was created
	NewTileFolder.LastTimeTileUsed.Value = VariablesTable.TotalTimesTilesUsed -- Last time was used for any purposes!
	NewTileFolder.Parent = VariablesTable.PlayerTilesFolder

	local NewTilePart = VariablesTable.TilePartExample:Clone() -- this part for showcase purpose only!
	NewTilePart.Name = "TilePart"
	NewTilePart.Position = TilesFunctions.CreateTilePartPosition(TileAxis, VariablesTable)
	NewTilePart.Parent = NewTileFolder

	local NewSpecialPointPart = VariablesTable.SpecialPointPartExample:Clone() -- Same showcase only! 
	NewSpecialPointPart.Name = "SpecialPointPart"
	NewSpecialPointPart.Position = HumanoidRootPartPosition
	NewSpecialPointPart.Parent = NewTileFolder
	
end

TilesFunctions.UpdateTileStats = function(Tile, HumanoidRootPartPosition, TotalTimesTilesUsed)
	
	Tile:FindFirstChild("SpecialPosition").Value = HumanoidRootPartPosition
	Tile:FindFirstChild("LastTimeTileUsed").Value = TotalTimesTilesUsed -- very important, main usage of sorting tiles for pathfind and destroy tiles actions!
	Tile:FindFirstChild("SpecialPointPart").Position = HumanoidRootPartPosition -- only for showcase purpose
	
end


TilesFunctions.CheckAndCreateOrUpdateTileFolder = function(TileAxis, TileName, HumanoidRootPartPosition, VariablesTable) -- just check if tile exist or create if no, then simply update Char position in tile last time were!(use for smoother pathfinding!)
VariablesTable = TilesFunctions.VarsT
	local PossibleCurrentTileFolder = VariablesTable.PlayerTilesFolder:FindFirstChild(TileName)
	VariablesTable.TotalTimesTilesUsed += 1

	if PossibleCurrentTileFolder then -- if exist already, just update quickly important stats!
		
		TilesFunctions.UpdateTileStats(PossibleCurrentTileFolder, HumanoidRootPartPosition, VariablesTable.TotalTimesTilesUsed)


	else -- if not exist then simply create! I think not much desc needed here

		TilesFunctions.CreateTileFolder(TileAxis, TileName, HumanoidRootPartPosition, VariablesTable)

	end
	VariablesTable.LastTileWhichWasChanged = TileName -- which tile was changed last time! Using for destroying and most important, to where start from using pathfind as well checking if quickly can be reached by raycast and then flying to char!

	if #VariablesTable.PlayerTilesFolder:GetChildren() >= VariablesTable.TilesAtDestroy then -- if too many exsit at same moment then simply destroy some!

		TilesFunctions.DestroyTilesOnExhausting(VariablesTable) -- use this exact function!

	end

end



TilesFunctions.CheckIfViscTileAtExist = function(TileAtVisceratorNow, VariablesTable)
	
	if not VariablesTable.PlayerTilesFolder:FindFirstChild(VariablesTable.TileAtVisceratorNow) then -- if Current Tile in which Visc now staying not exist for reasons by unknown, create one quickly!

		local Axis, Name = TilesFunctions.CreateCurrentTileAndItsName(VariablesTable.Viscerator.Position, VariablesTable)
		TilesFunctions.CheckAndCreateOrUpdateTileFolder(Axis, Name, VariablesTable.HumanoidRootPart.Position, VariablesTable)
		VariablesTable.CurrentTileVisceratorAt = Name
		VariablesTable.TileAtVisceratorNow = Name


	end
	
end

TilesFunctions.DestroyAllOutdatedTiles = function(MinTilesLastTimeUsedNumber, VariablesTable)
	
	local TilesWereDestroyed = 0
	
	for _, AllTiles in pairs(VariablesTable.PlayerTilesFolder:GetChildren()) do -- Destroy all Tiles which were updated before of last tile at which Visc is now (those who no longer needed as they are even older than Tile at which Visc now)

		if AllTiles:FindFirstChild("LastTimeTileUsed").Value < MinTilesLastTimeUsedNumber then

			TilesWereDestroyed += 1
			AllTiles:Destroy()

		end

	end
	
	return TilesWereDestroyed
	
end


TilesFunctions.DestroyUnnecessaryTiles = function(TileAtVisceratorNow, VariablesTable) -- Destroy all of unnecessary Tiles but not when limit reached, only when some of tiles no longer needed!

	TilesFunctions.CheckIfViscTileAtExist(TileAtVisceratorNow, VariablesTable)

	local MinTilesLastTimeUsedNumber = VariablesTable.PlayerTilesFolder:WaitForChild(TileAtVisceratorNow):FindFirstChild("LastTimeTileUsed").Value -- gonna use tile at which Visc is currently
	local TilesWereDestroyed = 0 
	
	TilesWereDestroyed = TilesFunctions.DestroyAllOutdatedTiles(MinTilesLastTimeUsedNumber, VariablesTable)
	VariablesTable.CurrentTilesInUse -= TilesWereDestroyed
	
end



return TilesFunctions


-- probably gonna be the hardest part lol!
-- if i am not mistaken it seems like we are finished creating tiles functions! Only problem i see is if we store all possible functions there...
-- it might be truly hard time, isn't it? 
-- I think we shall move to different modules for different functions!
-- Such as Helpful/Tiles/MainLoops/MainFunctions and the rest if some are needed!
-- Btw tiles will receive VariablesTable from kind of Loops which will receive from other functions i guess start from... good question from where lol!
-- Probably Connections -> Functions of main -> The Rest! And connections from main handwrite i guess by require() do!
-- So yeah we may need only in final script/connections to use require(ModulesForVisceratorSystemFolder.ImportantVariables)
-- and trick is to make every single thing easy! By simply get em all as tables stored as arrays in main table which we require and
-- do for i, Tables to then give to main VariablesTable[i] = tables and whatever they will store!!!
-- Would fr be perfect idea!

-- Do not forget to check that Names we gonna use in functions are correct to table or funcs from where we got those stats and vars to use and give as args!

