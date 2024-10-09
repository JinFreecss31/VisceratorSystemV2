local FinalSetupFunctions = {}

FinalSetupFunctions.RequireModulesTable = function(Module)

	return require(Module)

end

FinalSetupFunctions.ReceiveAllVariables = function(MainTableOfVariables) -- Get Module with Table of different Vairables and put into single table

	local TableOfAllVariables = {}
	
	for i, VariablesTypesTable in pairs(MainTableOfVariables) do
		
		for Names, Values in pairs(VariablesTypesTable) do

			TableOfAllVariables[Names] = Values

		end

	end
	
	TableOfAllVariables.FunctionsAndTheirTicksToLoop = MainTableOfVariables.FunctionsAndTheirTicksToLoop
	TableOfAllVariables.TableWithNamesOfAllActionsTypes = MainTableOfVariables.TableWithNamesOfAllActionsTypes
	
	return TableOfAllVariables
	
end

FinalSetupFunctions.CreateOriginalModulesMainTable = function(VariablesTable) -- Create One table in VairablesTable to use for quickly get certain modules functions if needed to
	
	local OriginalModulesMainTable = {}
	
	for i, foldersOfModules in pairs(VariablesTable.StarterPlayerScripts.ModulesForVisceratorSystemFolder:GetChildren()) do
		
		if foldersOfModules.Name ~= "Variables" then
			OriginalModulesMainTable[foldersOfModules.Name] = {}
			local CurrentModuleTypeTable = OriginalModulesMainTable[foldersOfModules.Name]
			
			for Named, Modules in pairs(foldersOfModules:GetChildren()) do
				
				CurrentModuleTypeTable[Modules.Name] = FinalSetupFunctions.RequireModulesTable(Modules)
				
			end
			
		end
		
	end
	
	VariablesTable["OriginalModulesMainTable"] = OriginalModulesMainTable
	
end

FinalSetupFunctions.FinishVariablesByAddingCertainFunctions = function(Variables, FunctionsTypes) -- Final Step to add few things to Variables and to Functions Table
	
	local ActionsFunctions = FunctionsTypes.ActionsFunctions
	Variables.MovingLoop = {

		["TakeOut"] = ActionsFunctions.TakeOut;
		["PlacedOnBack"] = ActionsFunctions.PlacedOnBack;
		["FollowCharacter"] = ActionsFunctions.FollowCharacter;
		["FlyToSpotAndStay"] = ActionsFunctions.FlyToSpotAndStay;
	

	}
	Variables.AttackLoop = {

		["AttackNearestPerson"] = ActionsFunctions.AttackNearestPerson;
		["AttackChosenPerson"] = ActionsFunctions.AttackChosenPerson;
		["AttackOppositeTeamEnemies"] = ActionsFunctions.AttackOppositeTeamEnemies;

	}

	Variables.LoopsTypesAndTheirActionsFunctions = {} --
	Variables.LoopsTypesAndTheirActionsFunctions.MovingLoop = Variables.MovingLoop
	Variables.LoopsTypesAndTheirActionsFunctions.AttackLoop = Variables.AttackLoop

end

FinalSetupFunctions.PlaceAllFunctionsTypes = function(FunctionsFolder) -- Just place all functions types into single Table by functions names (From all modules)

	local FunctionsTypesTable = {}
	for _, FunctionsModules in pairs(FunctionsFolder:GetChildren()) do

		FunctionsTypesTable[FunctionsModules.Name] = FinalSetupFunctions.RequireModulesTable(FunctionsModules)

	end
	return FunctionsTypesTable

end

FinalSetupFunctions.FinallyReturnAllVarsAndFunctionsTables = function(VariablesTable, FunctionsMainTable) -- Just return all created vars and functions tables (also add the rest of functions)

	local FinalTableOfAllFunctions = {}

	for i, AllMainTables in pairs(FunctionsMainTable) do

		for Name, Functions in pairs(AllMainTables) do

			FinalTableOfAllFunctions[i] = AllMainTables

		end

	end

	return VariablesTable, FinalTableOfAllFunctions

end

FinalSetupFunctions.CreateButtonsConnections = function(VisceratorFrame, VariablesTable, FunctionsHolder, AllFunctionsTable) -- gonna be used to Create Connections to Buttons based on button name and function it is belong to
	local TableOfTriggerFunctions = require(FunctionsHolder.TableOfTriggerFunctions)
	local TableOfButtonsToActivate = {}

	for _,AllButtons in pairs(VisceratorFrame:GetChildren()) do

		if AllButtons:IsA("TextButton") then

			local ButtonFunctionToRun = TableOfTriggerFunctions[AllButtons.Name]

			TableOfButtonsToActivate[AllButtons.Name] = {["ButtonInstance"] = AllButtons;
				["Connection"] = AllButtons.MouseButton1Up:Connect(function()

					if VariablesTable.VisceratorSpawned.Value == true then

						ButtonFunctionToRun(VariablesTable, AllFunctionsTable) --VariablesTable.Viscerator)

					end

				end)

			}

		end

	end

	return TableOfButtonsToActivate

end

FinalSetupFunctions.CreateAllFunctionsTable = function(FunctionsMainTable) -- Gonna create Table with all functions 
	
	local TableWithAllFunctionsByTheirNames = {}
	
	for _, FunctionsMainTable in pairs(FunctionsMainTable) do
		
		local CurrentFunctionsTypeTable = FunctionsMainTable
		
		for i, Functions in pairs(CurrentFunctionsTypeTable) do
			
			TableWithAllFunctionsByTheirNames[i] = Functions
			
		end
		
	end
	
	return TableWithAllFunctionsByTheirNames
	
end

FinalSetupFunctions.CreateSpawnNpcsConnections = function(SpawnCivsFrame, VariablesTable, AllFunctionsTable) -- To create connections for npcs spawn when buttons clicked

	local CivSpawnButtonsConnections = {}
	local TypeOfNpcsToSpawnTable = require(VariablesTable.StarterPlayerScripts.ModulesForVisceratorSystemFolder.AdditionalInformation.CivliansToSpawnModule).TypeOfNpcsToSpawnModule

	for _, AllButtons in pairs(SpawnCivsFrame:GetChildren()) do

		if AllButtons:IsA("TextButton") then
			--print(VariablesTable.OriginalModulesMainTable)
			--VariablesTable.OriginalModulesMainTable.SpawnCivsFunctions.SpawnChosenNpc(AllButtons, VariablesTable)
			AllFunctionsTable.SpawnChosenNpc(AllButtons, VariablesTable)
			
		end

	end

	return CivSpawnButtonsConnections

end

FinalSetupFunctions.CreateConnectionsTable = function(VariablesTable, AllFunctionsTable) -- To create connections table
	
	local ConnectionsofVisceratorAndSomeMoreValuesTable = {}
	
	for i, AllConnectionsToDo in pairs(VariablesTable.OriginalModulesMainTable.Functions.ConnectionsFunctions) do
		
		ConnectionsofVisceratorAndSomeMoreValuesTable[i] = AllConnectionsToDo(VariablesTable, AllFunctionsTable)
		
	end
	
end

FinalSetupFunctions.CreateLoopsValueTable = function(VariablesTable) -- To create Values for loops to automatically use just like : Table[NameOfLoop] = Value; to then quickly Table[NewLoopToRun].Value = true (connection will catch and do the rest to spawn new loop)
	
	local TableForLoops = {}
	TableForLoops.AttackLoop = VariablesTable.CreateAttackLoop
	TableForLoops.MovingLoop = VariablesTable.CreateMovingLoop
	VariablesTable.LoopsToCreateValuesTable = TableForLoops
	
end

return FinalSetupFunctions
