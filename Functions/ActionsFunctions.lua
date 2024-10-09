local ActionsFunctions = {}

ActionsFunctions.TakeOut = function(VariablesTable, AllFunctionsTable) -- Gonna do Take out action in case it is what we shall do now!

	local MoveTo = VariablesTable.HumanoidRootPart.CFrame * CFrame.new(-1.35, 1, 2)

	AllFunctionsTable.FlyObject(VariablesTable.Viscerator, MoveTo, VariablesTable) 
	VariablesTable.CurrentTileVisceratorAt = VariablesTable.LastTileWhichWasChanged
	AllFunctionsTable.DestroyUnnecessaryTiles(VariablesTable.CurrentTileVisceratorAt, VariablesTable) -- destroy all no longer needed old tiles which no longer to be used in finding new path for Visc to Player1

end

ActionsFunctions.PlacedOnBack = function(VariablesTable, AllFunctionsTable) -- same for other act

	local MoveTo = VariablesTable.HumanoidRootPart.CFrame * CFrame.new(-1.35, -2, VariablesTable.Viscerator.Size.Z/2)

	AllFunctionsTable.FlyObject(VariablesTable.Viscerator, MoveTo, VariablesTable) 
end

ActionsFunctions.CheckIfRayCastReach = function(VariablesTable, AllFunctionsTable) -- quickly check if ray path blocked or no by some obstacles
	local TileToUseForPath = VariablesTable.PlayerTilesFolder:FindFirstChild(VariablesTable.LastTileWhichWasChanged)
	if TileToUseForPath:FindFirstChild("LastTimeTileUsed").Value ~= 0 then -- check if can straight move to Char
		local NewRayCastResults = AllFunctionsTable.CastNewRay(VariablesTable.Viscerator.Position, TileToUseForPath:FindFirstChild("SpecialPosition").Value, VariablesTable)

		if not NewRayCastResults then 

			AllFunctionsTable.FlyObject(VariablesTable.Viscerator, CFrame.new(TileToUseForPath:FindFirstChild("SpecialPosition").Value), VariablesTable)
			VariablesTable.LastTimeVisceratorPathUpdated = VariablesTable.LastTimeVisceratorPathUpdated
			VariablesTable.CurrentTileVisceratorAt = VariablesTable.LastTileWhichWasChanged
			AllFunctionsTable.DestroyUnnecessaryTiles(VariablesTable.CurrentTileVisceratorAt, VariablesTable)

			return true -- hope this will happen mostly! What could be better than simply fly from Visc to Character in one single and straight Line?!!!!!!!!

		end

	end
	
end

ActionsFunctions.CreateAndSortTilesTableForPath = function(FuncVarsTable ,VariablesTable) -- Quickly Create and sort tiles for finding Pathfind Waypoints by which Tiles were lastly used 
	
	local MinimalTileLastTimeUsed = FuncVarsTable.MinimalTileLastTimeUsed
	for _, CurrentTiles in pairs(VariablesTable.PlayerTilesFolder:GetChildren()) do -- Find all Tiles which were created after current one Viscerator At!

		if CurrentTiles:FindFirstChild("LastTimeTileUsed").Value >= MinimalTileLastTimeUsed then

			table.insert(FuncVarsTable.AllPassedTilesTable, {["TileLastTimeUsed"] = CurrentTiles:FindFirstChild("LastTimeTileUsed").Value; ["TileName"] = CurrentTiles:FindFirstChild("TileName").Value})

		end

	end

	table.sort(FuncVarsTable.AllPassedTilesTable, function(a, b) -- Sort them by their Tile last time used! (Will help to start from closest to Hrp and move closer to Visc)

		return a["TileLastTimeUsed"] > b["TileLastTimeUsed"]

	end)
	
	
end

ActionsFunctions.CheckPathfinding = function(FuncVarsTable, VariablesTable, AllFunctionsTable) -- CheckPathfinding 
	
	for _, TilesCheck in pairs(FuncVarsTable.AllPassedTilesTable) do -- check which tile cacn be used! which is closest to Char!
		FuncVarsTable.TileCorrectedPosition =  VariablesTable.PlayerTilesFolder:FindFirstChild(TilesCheck["TileName"]):FindFirstChild("SpecialPosition").Value
		FuncVarsTable.CurrentTileRayCastResult = AllFunctionsTable.CastNewRay(FuncVarsTable.TileCorrectedPosition, FuncVarsTable.TileCorrectedPosition + Vector3.new(0, - 1000, 0), VariablesTable)
		if FuncVarsTable.CurrentTileRayCastResult then

			FuncVarsTable.TileCorrectedPosition = Vector3.new(FuncVarsTable.TileCorrectedPosition.X, FuncVarsTable.CurrentTileRayCastResult.Position.Y + 3, FuncVarsTable.TileCorrectedPosition.Z)

		end
		FuncVarsTable.PossibleTilesWaypoints = AllFunctionsTable.MakeNewPath(VariablesTable.Viscerator.Position, FuncVarsTable.TileCorrectedPosition, VariablesTable) -- 

		if #FuncVarsTable.PossibleTilesWaypoints > 0 then -- if path found then! 

			FuncVarsTable.TilesWaypointFound = true
			VariablesTable.CurrentTileVisceratorAt = TilesCheck["TileName"] -- we mean now Viscerator will with high chances fly to last Tile we cheked succsefully!

			break

		end

	end
	
end

ActionsFunctions.FlyOnPathfind = function(FuncVarsTable, VariablesTable, AllFunctionsTable) -- Fly on path if found, also will hold moment of raching final goal failed
	
	if FuncVarsTable.TilesWaypointFound == true then
		FuncVarsTable.WholePathReached = true

		for _, NewWayPoint in pairs(FuncVarsTable.PossibleTilesWaypoints) do

			if not AllFunctionsTable.CastNewRay(VariablesTable.Viscerator.Position, NewWayPoint.Position, VariablesTable) and AllFunctionsTable.FlyObject(VariablesTable.Viscerator, CFrame.new(NewWayPoint.Position), VariablesTable) == true then

			else FuncVarsTable.WholePathReached = false break -- means we failed at somewhere...

			end

		end
	
	end
	
	
	

end

ActionsFunctions.UpdateVisceratorAtTile = function(FuncVarsTable, VariablesTable, AllFunctionsTable) -- Quiclu Update Visc Tile at
	
	if FuncVarsTable.WholePathReached == false then

		FuncVarsTable.MinimalTileLastTimeUsed = 10000 -- gonna use this var to help find out closeset tile to Visc! Don't worry about peformance as in most cases
		-- it will rarely reach more than 10-30 tiles at the same time!
		FuncVarsTable.PossibleTilesWaypoints = nil -- gonna use it for closeset tile too

		for _, GetAllTiles in pairs(VariablesTable.PlayerTilesFolder:GetChildren()) do

			if (GetAllTiles.TilePosition.Value - VariablesTable.Viscerator.Position).Magnitude < FuncVarsTable.MinimalTileLastTimeUsed then

				FuncVarsTable.PossibleTilesWaypoints = GetAllTiles.Name

			end

		end

		if FuncVarsTable.PossibleTilesWaypoints ~= nil then

			VariablesTable.CurrentTileVisceratorAt = FuncVarsTable.PossibleTilesWaypoints

		end

	end

	AllFunctionsTable.DestroyUnnecessaryTiles(VariablesTable.CurrentTileVisceratorAt, VariablesTable) -- means we anyways found some successful path and at least on some tiles moved closer to Final Pos
	-- now shall destroy them!
	
	end


ActionsFunctions.FollowCharacter = function(VariablesTable, AllFunctionsTable) -- Folow Char 
	
	VariablesTable.CurrentTileVisceratorAt = VariablesTable.CurrentTileVisceratorAt 

	if AllFunctionsTable.CheckIfLimitsReached(VariablesTable, AllFunctionsTable) == true then -- tp if one of following stats limits reached!

		VariablesTable.LastTimeVisceratorPathUpdated = os.clock()
		AllFunctionsTable.TeleportViscerator(VariablesTable, AllFunctionsTable)
		VariablesTable.CurrentTileVisceratorAt = VariablesTable.LastTileWhichWasChanged

			return -- therefore if limits now reached simply teleport Visc and make sure All unneccessary tiles will be destroyed now

	end
	
	if ActionsFunctions.CheckIfRayCastReach(VariablesTable, AllFunctionsTable) == true then
		
		return -- path reached from single RayCast! No longer needed to continue parts of function below this point!
		
	end

	

	-- therefore will fly to Visc final Pos! else shall use Pathfinding Service or wait for limits reached! 
	
	local FuncVarsTable = {} -- to quickly share table of variables accross few other functions to do what their names stands by

	FuncVarsTable.MinimalTileLastTimeUsed = VariablesTable.PlayerTilesFolder:FindFirstChild(VariablesTable.CurrentTileVisceratorAt):FindFirstChild("LastTimeTileUsed").Value
	FuncVarsTable.AllPassedTilesTable = {}
	FuncVarsTable.PossibleTilesWaypoints = nil
	FuncVarsTable.TilesWaypointFound = false
	FuncVarsTable.TileCorrectedPosition = nil
	FuncVarsTable.CurrentTileRayCastResult = nil

		ActionsFunctions.CreateAndSortTilesTableForPath(FuncVarsTable, VariablesTable)

		ActionsFunctions.CheckPathfinding(FuncVarsTable, VariablesTable, AllFunctionsTable)
	
		ActionsFunctions.FlyOnPathfind(FuncVarsTable, VariablesTable, AllFunctionsTable)


			

	if FuncVarsTable.WholePathReached == false then
		
		ActionsFunctions.UpdateVisceratorAtTile(FuncVarsTable, VariablesTable, AllFunctionsTable)
		
	end

	
	
	
end

ActionsFunctions.FlyToSpotAndStay = function(VariablesTable, AllFunctionsTable) -- fly to, given by buttons and mouse funcs and connectins!

	local MoveTo = CFrame.new(VariablesTable.PossiblePositionToMoveTo) 

	AllFunctionsTable.FlyObject(VariablesTable.Viscerator, MoveTo, VariablesTable) 

end

ActionsFunctions.AttackNearestPerson = function(VariablesTable, AllFunctionsTable) -- Attack nearest Civ person no matter if they are with gun or no

	local ClosestTarget = nil
	local ClosestTargetDistance = math.huge
	local CurrentTargetSearchingDistance = 0
	local HRP = VariablesTable.HumanoidRootPart
	local CurrentCivilianHRP = nil

	for _, GetAllCivilianPlayers in pairs(VariablesTable.CivilianTeam:GetChildren()) do
		CurrentCivilianHRP = GetAllCivilianPlayers:WaitForChild("HumanoidRootPart")
		CurrentTargetSearchingDistance = (CurrentCivilianHRP.Position - HRP.Position).Magnitude 
		
		if CurrentTargetSearchingDistance < ClosestTargetDistance and AllFunctionsTable.CastNewRay(VariablesTable.Viscerator.Position, CurrentCivilianHRP.Position, VariablesTable) == nil then
			
			ClosestTarget = GetAllCivilianPlayers
			ClosestTargetDistance = CurrentTargetSearchingDistance

		end

	end

	if ClosestTarget ~= nil then

		AllFunctionsTable.AttackTarget(VariablesTable.Viscerator, ClosestTarget)

	end

	

end

ActionsFunctions.AttackChosenPerson = function(ChosenTarget, VariablesTable, AllFunctionsTable) -- attach chosen person basically!

	AllFunctionsTable.AttackTarget(VariablesTable.Viscerator, ChosenTarget)  -- checked from func from which triggered, so such a person can be reached and etc!


end

ActionsFunctions.RemoveAddUpdateEnemiesList = function(ListOfAllAvailableEnemies, VariablesTable, AllFunctionsTable) -- Check Enemies List and change it
	
	local CurrentListOfEnemies = VariablesTable.CurrentListOfEnemies
	local CurrentAvailableEnemy = "None"
	
	for _, PlaceAllPlayersByTheirName in pairs(VariablesTable.CivilianTeam:GetChildren()) do

		ListOfAllAvailableEnemies[PlaceAllPlayersByTheirName.Name] =  PlaceAllPlayersByTheirName

	end

	for i, CompareNewToOldList in pairs(CurrentListOfEnemies) do

		if not ListOfAllAvailableEnemies[i] then

			CurrentListOfEnemies[i] = nil -- remove enemy players who are no longer to be with us... (on server)

		end

	end
	
	for i, CheckAllAvailablePlayers in pairs(ListOfAllAvailableEnemies) do 
       CurrentAvailableEnemy = CheckAllAvailablePlayers

		if CurrentListOfEnemies[i] then

			if CurrentListOfEnemies[i]["LastTimeDied"] < CurrentAvailableEnemy:FindFirstChild("LastTimeDied").Value then

				CurrentListOfEnemies[i] = nil -- means that enemy of Visc died some time after caught, remember that if Visc caught someone once in 
				-- lifetime, gonna remember till person dies/leave

			end
			continue -- to not waste time checking further
		end
		-- Here Below we gonna put all rebels as enemies from the start because they are lol, and now gonna check RayCast for civs! ONly those who caught!
		if CurrentAvailableEnemy:FindFirstChild("MainRank").Value == "Rebel"  or CurrentAvailableEnemy:FindFirstChild("GunEquipped").Value == true and not AllFunctionsTable.CastNewRay(VariablesTable.Viscerator.Position, CurrentAvailableEnemy:FindFirstChild("HumanoidRootPart").Position) then

			-- there just cast Ray and if no path blocked and Distnace <= 60 studs, put them on list of enemies!
			-- Remember that enemy we put in TableOf CurrentEnemies format will be : Table["EnemyInstance"]; Table["LastTimeDied"] -- .Value [i] = Plr.Name

			CurrentListOfEnemies[CurrentAvailableEnemy.Name] = {["LastTimeDied"] = CurrentAvailableEnemy:FindFirstChild("LastTimeDied").Value;
				["EnemyInstance"] = CurrentAvailableEnemy -- to quickly get their models to attack
			}

		end

	end
	
end

ActionsFunctions.ChooseEnemyToAttack = function(FuncVarsTable, VariablesTable) -- Simply choose enemy whom want to attack!
	
	for _, AvailableEnemies in pairs(VariablesTable.CurrentListOfEnemies) do

		FuncVarsTable.CurrentSearchingEnemyDistance = (AvailableEnemies["EnemyInstance"]:FindFirstChild("HumanoidRootPart").Position - VariablesTable.Viscerator.Position).Magnitude 
		FuncVarsTable.TableOfStudsAndEnemys[AvailableEnemies["EnemyInstance"].Name] = FuncVarsTable.CurrentSearchingEnemyDistance
		-- No need to cast ray again as we are already put only players who can be reached by Visc!!!
		if FuncVarsTable.CurrentSearchingEnemyDistance < FuncVarsTable.ClosestEnemyDistance then 

			FuncVarsTable.ChosenEnemyToAttack = AvailableEnemies["EnemyInstance"]

		end

	end
	
end

ActionsFunctions.AttackOppositeTeamEnemies = function(VariablsTable, AllFunctionsTable) -- Just destroy oppostite team enemies! using some memory to remember enemies

	-- Who equipped gun (of civs innocent rank)

	local ListOfAllAvailableEnemies = {} -- gonna get table of all players from civilian team

	ActionsFunctions.RemoveAddUpdateEnemiesList(ListOfAllAvailableEnemies, VariablsTable, AllFunctionsTable)

    local FuncVarsTable = {}

	FuncVarsTable.CurrentSearchingEnemyDistance = 0
	FuncVarsTable.ClosestEnemyDistance = VariablsTable.MaxAttackDistance -- Max Disctance of Visc!
	FuncVarsTable.ChosenEnemyToAttack = nil
	FuncVarsTable.TableOfStudsAndEnemys = {} -- just for tests ignore that part!
	
	ActionsFunctions.ChooseEnemyToAttack(FuncVarsTable, VariablsTable)

	warn(FuncVarsTable.TableOfStudsAndEnemys) -- ignore just for tests

	-- lastly just check if some enemy were found  then simply attack them!

	if FuncVarsTable.ChosenEnemyToAttack then

		AllFunctionsTable.AttackTarget(VariablsTable.Viscerator, FuncVarsTable.ChosenEnemyToAttack)
		--VariablsTable.LastEnemyAttacked = AllFunctionsTable.ChosenEnemyToAttack -- i guess both of Cur and Last enemy attacked variables will hold Instances

	end -- not used Last enemy for reason of some issues might happen with it so yeah (meant only gameplay illogical, not in scripting meaning!)


end

ActionsFunctions.TeleportViscerator = 1


return ActionsFunctions

