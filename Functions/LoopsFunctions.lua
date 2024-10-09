local LoopsFunctions = {} -- just functions of creating loops, gonna be called by connections of Next loop to do or either way from (usually) already running loops! (but anyways using ObjectValues BoolValues for it)

LoopsFunctions.GiveNewTickToLoop = function(NewFunction, VariablesTable) -- Gonna use to find out based on new action which tick and its amount to use in main loop!

	return VariablesTable.FunctionsAndTheirTicksToLoop[NewFunction]

end

LoopsFunctions.CheckIfLimitsReached = function(VariablesTable, AllFunctionsTable) -- Check if Limits reached, gonna be used in Moving loop to see if Visc must be teleported to player!

	local LimitsReachedState = false

	if os.clock() - VariablesTable.LastTimeVisceratorPathUpdated >= VariablesTable.MaxTimeWithoutUpdatePath or (VariablesTable.Viscerator.Position - VariablesTable.HumanoidRootPart.Position).Magnitude >= VariablesTable.MaxDistance then

		AllFunctionsTable.TeleportViscerator(VariablesTable, AllFunctionsTable) -- use to send HRp of plr and Visc Part with Position property!

		LimitsReachedState = true

	end

	return LimitsReachedState

end

LoopsFunctions.CheckIfActionAndLoopMustBeChanged = function(TableOfChangesVars, VariablesTable) -- this function will help to decide if new action shall be started and if so, if can continue in same loop or must use new one!

	
	if VariablesTable.CurrentActionVisceratorDoing.Value ~= VariablesTable.VisceratorActionToDo.Value then -- if actiont to which must use is not the same as action using now! 

		TableOfChangesVars.ChangeAction = true

		if VariablesTable.TableWithNamesOfAllActionsTypes[VariablesTable.CurrentActionVisceratorDoing.Value]["LoopType"] == VariablesTable.TableWithNamesOfAllActionsTypes[VariablesTable.VisceratorActionToDo.Value]["LoopType"] then

		else TableOfChangesVars.ChangeLoop = true
			
			TableOfChangesVars.LoopToChange = VariablesTable.TableWithNamesOfAllActionsTypes[VariablesTable.VisceratorActionToDo.Value]["LoopType"]

		end

	end
    -- NO need to return anymore as it will set keys from table which were shared from previous function that called it
	--return ChangeAction, ChangeLoop, LoopToChange

end 

LoopsFunctions.ChangeActionAndLoop = function(VariablesTable, AllFunctionsTable) -- Gonna be used to Change to new Loop from old one! Same for action!
	
	local TableOfChangesVars = {}
	TableOfChangesVars.ChangeAction = false
	TableOfChangesVars.ChangeLoop = false
	TableOfChangesVars.LoopToChange = nil
	TableOfChangesVars.ActionToChangeTo = nil

	LoopsFunctions.CheckIfActionAndLoopMustBeChanged(TableOfChangesVars, VariablesTable)

	if TableOfChangesVars.ChangeAction == true then -- if must change act

		VariablesTable.CurrentActionVisceratorDoing.Value = VariablesTable.VisceratorActionToDo.Value -- Change Action and check about loop!

		if TableOfChangesVars.ChangeLoop ==  true then -- in case we must change loop to other type as well!

			VariablesTable.LoopsToCreateValuesTable[TableOfChangesVars.LoopToChange].Value = true -- Activate New Loop!
			-- Break Current Loop! 
			TableOfChangesVars.ActionToChangeTo = VariablesTable.CurrentActionVisceratorDoing.Value -- to switch current action to new one and then use it instead! FuncsTable[CurAc.V](Args)
			-- for loop same but with FunctsToLoopsT[CurAc.V](Args)
		end

		TableOfChangesVars.ActionToChangeTo = VariablesTable.CurrentActionVisceratorDoing.Value -- to which action to change if no loop must be destroyed!
		-- just small spot to check if for certain new current states some things which run must be stopped to, or which not run, to be created!
		if TableOfChangesVars.ActionToChangeTo == "PlacedOnBack" and VariablesTable.TilesLoopActive == true then 

			VariablesTable.BreakTilesLoop = true

		elseif TableOfChangesVars.ActionToChangeTo ~= "PlacedOnBack" and VariablesTable.TilesLoopActive == false then -- Solution here instad of old "PlacedAtBack" new "PlacedOnBack!"

			VariablesTable.CreateTilesLoop.Value = true -- will create tiles loop!

		end

		if TableOfChangesVars.ActionToChangeTo == "FollowCharacter" then -- create new tile or update to right pos and tile visc in case of it found!

			local NewTileAxis, NewTileName = AllFunctionsTable.CreateCurrentTileAndItsName(VariablesTable.Viscerator.Position) 
			AllFunctionsTable.CheckAndCreateOrUpdateTileFolder(NewTileAxis, NewTileName, VariablesTable.Viscerator.Position)
			VariablesTable.PlayerTilesFolder:FindFirstChild(NewTileName):FindFirstChild("LastTimeTileUsed").Value = 0 
			VariablesTable.CurrentTileVisceratorAt = NewTileName 

		end

	end

	return TableOfChangesVars.ChangeLoop, TableOfChangesVars.ActionToChangeTo

end

LoopsFunctions.CheckAndChangeTilesLoop = function(VariablesTable) -- Just check and change if needed tiles Loop! Aka Destroy/Create and etc (usually used only for Spawn Visc Time and Destroying it!)

	if VariablesTable.CurrentActionVisceratorDoing.Value ~= "PlacedOnBack" and VariablesTable.TilesLoopActive == false and VariablesTable.VisceratorSpawned.Value == true then -- added if visc spawned himself
		VariablesTable.CreateTilesLoop.Value = true
		VariablesTable.TilesLoopActive = true 
		
	elseif VariablesTable.CurrentActionVisceratorDoing.Value == "PlacedOnBack" and VariablesTable.TilesLoopActive == true then
		VariablesTable.BreakTilesLoop = true
		VariablesTable.TilesLoopActive = false 

	end

end


-- remember to then add them to main functions table from Tiles main local script (to important variables one table)
LoopsFunctions.CreateTilesLoopFunction = function(VariablesTable, AllFunctionsTable) -- Func for doing Tiles function! 
	

	local CurrentLoopTick = VariablesTable.FunctionsAndTheirTicksToLoop["CreateTiles"] -- to use for tick changing but in this loop only for running!

	while VariablesTable.HumanoidRootPart do -- loop

		task.wait(CurrentLoopTick)
		


		if VariablesTable.BreakTilesLoop == true then -- if must break (from other loops and functions checks) then do so!
			VariablesTable.TilesLoopRunning.Value = false 
			VariablesTable.TilesLoopActive = false
			AllFunctionsTable.DestroyUnnecessaryTiles(VariablesTable.LastTileWhichWasChanged, VariablesTable)
			VariablesTable.PlayerTilesFolder:FindFirstChild(VariablesTable.LastTileWhichWasChanged):Destroy() -- Destroy all no longer needed loops! Those which not gonna be used
			-- for main pathfinding part!
			break 

		end

		local CurTileAix, CurTileName = AllFunctionsTable.CreateCurrentTileAndItsName(VariablesTable.HumanoidRootPart.Position, VariablesTable) -- just in case create one more tile at where Hrp now
		AllFunctionsTable.CheckAndCreateOrUpdateTileFolder(CurTileAix, CurTileName, VariablesTable.HumanoidRootPart.Position, VariablesTable)


	end

end


LoopsFunctions.CreateMovingLoopFunction = function(VariablesTable, AllFunctionsTable)
	
	local ActionFunctionToDo = VariablesTable.CurrentActionVisceratorDoing.Value
	local ChangeLoop = false
	local PossibleNewFunction = nil
	local CurrentLoop = "MovingLoop"
	ActionFunctionToDo = VariablesTable.LoopsTypesAndTheirActionsFunctions[CurrentLoop][ActionFunctionToDo] -- for those parts tho!
	local CurrentLoopTick = VariablesTable.FunctionsAndTheirTicksToLoop[VariablesTable.CurrentActionVisceratorDoing.Value] -- ganna change from inside of loop if new func with new loop tick appeared in current loop!
	VariablesTable.LastTimeVisceratorPathUpdated = os.clock() 
	
	while VariablesTable.HumanoidRootPart do

		task.wait(CurrentLoopTick)



		ChangeLoop, PossibleNewFunction = AllFunctionsTable.ChangeActionAndLoop(VariablesTable, AllFunctionsTable) -- check if must destroy/make new loop and new func! Shall be used in BoolV.Change tho!

		if ChangeLoop then -- if change then change! Func only or even loop if cur new func is from different loop type!
			
			break

		elseif PossibleNewFunction then

			ActionFunctionToDo = PossibleNewFunction
			CurrentLoopTick = VariablesTable.FunctionsAndTheirTicksToLoop[PossibleNewFunction] -- new tick based on function
			PossibleNewFunction = false
			ActionFunctionToDo = VariablesTable.LoopsTypesAndTheirActionsFunctions[CurrentLoop][ActionFunctionToDo]

		end

		ActionFunctionToDo(VariablesTable, AllFunctionsTable) -- Well simply use current/new function if it related to Current Loop! That easy hehe!


	end

	
end

LoopsFunctions.CreateAttackLoopFunction = function(VariablesTable, AllFunctionsTable) -- For Attacking! Almost the same as in other loop!
	
	local ActionFunctionToDo = VariablesTable.CurrentActionVisceratorDoing.Value; 
	local ChangeLoop = false
	local PossibleNewFunction = nil
	local CurrentLoop = "AttackLoop"
	ActionFunctionToDo = VariablesTable.LoopsTypesAndTheirActionsFunctions[CurrentLoop][ActionFunctionToDo]; 
	local CurrentLoopTick = VariablesTable.FunctionsAndTheirTicksToLoop[VariablesTable.CurrentActionVisceratorDoing.Value]

	while VariablesTable.Viscerator do

		task.wait(CurrentLoopTick)



		ChangeLoop, PossibleNewFunction = AllFunctionsTable.ChangeActionAndLoop(VariablesTable, AllFunctionsTable) -- might remove at least one useless function as we do almost same loool

		if ChangeLoop then
			
			break

		elseif PossibleNewFunction then

			ActionFunctionToDo = PossibleNewFunction
			CurrentLoopTick = VariablesTable.FunctionsAndTheirTicksToLoop[PossibleNewFunction]
			PossibleNewFunction = false
			ActionFunctionToDo = VariablesTable.LoopsTypesAndTheirActionsFunctions[CurrentLoop][ActionFunctionToDo]

		end

		-- Time To Start Doing Actions!

		ActionFunctionToDo(VariablesTable, AllFunctionsTable)

	end

end



return LoopsFunctions


-- Okay Tip 1. First all ARgs 2nd Vars Table 3rd AllFuncs Table in case we gonna send all of possible args lol!
-- no way! Seems like we are finished everything?!!!! Good job!

-- for moving objects there may be certain problems so instead of Tikc and etc can use Functions from either way AllFunctionsTable or
-- as well add those functions to MainVariablesFunctions just in case! To Table they are meant to be!

-- Example To Move To : 	ActionFunctionToDo = LoopsTypesAndTheirActionsFunctions[CurrentLoop][ActionFunctionToDo]; 
--local CurrentIterationOfChar = CharacterIteration
--local CurrentLoopTick = FunctionsAndTheirTicksToLoop[CurrentActionVisceratorDoing.Value]
