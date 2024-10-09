local ModulesForVisceratorSystemFolder = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"):FindFirstChild("ModulesForVisceratorSystemFolder")
local FolderOfAllVariables = ModulesForVisceratorSystemFolder:FindFirstChild("Variables")
local FolderOfAllFunctions = ModulesForVisceratorSystemFolder:FindFirstChild("Functions")
local FinalSetupFunctions = require(ModulesForVisceratorSystemFolder:FindFirstChild("FinalSetups"):FindFirstChild("FinalSetupFunctions"))
local VariablesHolder = {}
local FunctionsHolder = {}
VariablesHolder = FinalSetupFunctions.RequireModulesTable(FolderOfAllVariables:FindFirstChild("ImportantVariables"))
FunctionsHolder = FolderOfAllFunctions
local VariablesTable = FinalSetupFunctions.ReceiveAllVariables(VariablesHolder) 
VariablesTable.PlayerTilesFolder.Parent = workspace
local CreateOriginalModulesTable = FinalSetupFunctions.CreateOriginalModulesMainTable(VariablesTable) 
local FunctionsMainTable = FinalSetupFunctions.PlaceAllFunctionsTypes(FolderOfAllFunctions)
FinalSetupFunctions.FinishVariablesByAddingCertainFunctions(VariablesTable, FunctionsMainTable)
local VariablesTable, AllFunctionsTable = FinalSetupFunctions.FinallyReturnAllVarsAndFunctionsTables(VariablesTable, FunctionsMainTable)
AllFunctionsTable = FinalSetupFunctions.CreateAllFunctionsTable(FunctionsMainTable)

local VisceratorFrame = VariablesTable.VisceratorFrame
local TableOfVisceratorFrameButtonsAndTheirConnections = FinalSetupFunctions.CreateButtonsConnections(VisceratorFrame, VariablesTable, FunctionsHolder, AllFunctionsTable)
local SpawnCivsFrame = VariablesTable.SpawnCivsFrame
local TableOfSpawnNpcsFrameConnections = FinalSetupFunctions.CreateSpawnNpcsConnections(SpawnCivsFrame, VariablesTable, AllFunctionsTable)



local CreateConnectionsTable = FinalSetupFunctions.CreateConnectionsTable(VariablesTable, AllFunctionsTable)

VariablesTable.NewRaycastParams.FilterDescendantsInstances = {VariablesTable.Character,VariablesTable.Teams, VariablesTable.VisceratorsFolder, VariablesTable.PlayerTilesFolder}
VariablesTable.HumanoidRootPart = VariablesTable.Character:FindFirstChild("HumanoidRootPart")

require(FunctionsHolder.TilesFunctions).VarsT = VariablesTable
FinalSetupFunctions.CreateLoopsValueTable(VariablesTable)
VariablesTable.CurrentActionDoingLabel.Text = "Current State : Not Spawned!" 

-- Basically just require main module which will setup all previous modules in two main tables 1.VariablesTable and 2.AllFunctionsTable
-- They will hold each variable and function which exist in game (except FinalSetups as they are ones which run only once in this place to finish things)
-- For example of what they gonna do is create Connections and place them in certain place inside VaraiblesTable using some information from VariablesTable
-- and Certain functions from AllFunctionsTable 
