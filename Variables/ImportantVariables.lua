local Variables = {}

local Services = {} -- All Services
Services.PathfindingService = game:GetService("PathfindingService")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.Workspace = game:GetService("Workspace")
Services.Players = game:GetService("Players")
Services.PlayerGuis = game:GetService("StarterGui")
Services.ServerScriptService = game:GetService("ServerScriptService")

local PlayerVariables = {} -- Player Variables which will store all important things of player, such as Char/HRP/Mouse/Player VAlues which are related to Viscerator as well
PlayerVariables.Player = Services.Players.LocalPlayer
PlayerVariables.PlayerGuis = PlayerVariables.Player.PlayerGui
PlayerVariables.StarterPlayerScripts = PlayerVariables.Player.PlayerScripts
PlayerVariables.Character = PlayerVariables.Player.Character or PlayerVariables.Player.CharacterAdded:Wait()
PlayerVariables.CharacterFullHeight = PlayerVariables.Character:GetExtentsSize()
PlayerVariables.HumanoidRootPart = PlayerVariables.Character:WaitForChild("HumanoidRootPart")
PlayerVariables.Mouse = PlayerVariables.Player:GetMouse()
PlayerVariables.Mouse.TargetFilter = PlayerVariables.Character
PlayerVariables.ServerStats = PlayerVariables.Player:WaitForChild("ServerStats")
PlayerVariables.LastViscAttackHappened = PlayerVariables.ServerStats.LastViscAttackHappened
PlayerVariables.VisceratorSpawned = PlayerVariables.ServerStats.VisceratorSpawned


local CreateLoopsVariables = {} -- Variables to store loops instances and then later use functions connections on FinalSetupModule functions to check and apply changes when those Variables are changed!
CreateLoopsVariables.CreateTilesLoop = Instance.new("BoolValue") 
CreateLoopsVariables.CreateTilesLoop.Name = "CreateTilesLoop"
CreateLoopsVariables.CreateTilesLoop.Value = false

CreateLoopsVariables.CreateMovingLoop = Instance.new("BoolValue")
CreateLoopsVariables.CreateMovingLoop.Name = "CreateMovingLoop"
CreateLoopsVariables.CreateMovingLoop.Value = false

CreateLoopsVariables.CreateAttackLoop = Instance.new("BoolValue")
CreateLoopsVariables.CreateAttackLoop.Name = "CreateAttackLoop"
CreateLoopsVariables.CreateAttackLoop.Value = false


local CreateActionsVariables = {} -- Just VariableForActions, somehow only stored ChangeActionOnCooldown here and its time to wait when on CD
CreateLoopsVariables.ChangeActionOnCooldown = Instance.new("BoolValue") -- which next action want to change!
CreateLoopsVariables.ChangeActionOnCooldown.Name = "ChangeActionOnCooldown" -- Some Cooldown and other settings!
CreateLoopsVariables.ChangeActionOnCooldown.Value = false
CreateLoopsVariables.CooldownOfAction = 0.21

local VariablesForViscerator = {} -- All Variables for Viscerator 
VariablesForViscerator.MaxAttackDistance = Services.ReplicatedStorage:FindFirstChild("MaxDistanceOfAttack").Value
VariablesForViscerator.Teams = Services.Workspace:FindFirstChild("Teams")
VariablesForViscerator.CivilianTeam = VariablesForViscerator.Teams:FindFirstChild("CivilianTeam")
VariablesForViscerator.Viscerator = nil
VariablesForViscerator.TypeOfActionToDo = nil
VariablesForViscerator.CurrentListOfEnemies = {}
VariablesForViscerator.CurrentChosenEnemyToAttack = nil
VariablesForViscerator.VisceratorSpawned = false -- those two replace with above new ObjectValues Variables of playervars
VariablesForViscerator.LastViscAttackHappened = 0
VariablesForViscerator.LastTimeVisceratorPathWasUpdated = os.clock() 
VariablesForViscerator.LastTimeVisceratorPathUpdated = os.clock() -- use this tho
VariablesForViscerator.MaxTimeWithoutUpdatePath = 6 
VariablesForViscerator.MaxDistance = 120
VariablesForViscerator.VisceratorOffset = CFrame.new(-1.35, 1, 2)
VariablesForViscerator.CurrentVisceratorActionDoing = Instance.new("StringValue") 
VariablesForViscerator.CurrentVisceratorActionDoing.Name = "CurrentVisceratorActionDoing"
VariablesForViscerator.CurrentVisceratorActionDoing.Value = "None"
VariablesForViscerator.CurrentActionVisceratorDoing = VariablesForViscerator.CurrentVisceratorActionDoing
VariablesForViscerator.VisceratorActionToDo = Instance.new("StringValue") -- Use to check what action viscerator should do next
VariablesForViscerator.VisceratorActionToDo.Name = "VisceratorActionToDo"
VariablesForViscerator.VisceratorActionToDo.Value = "None"
VariablesForViscerator.PossiblePositionToMoveTo = "nil"
VariablesForViscerator.PossibleTarget = nil
VariablesForViscerator.AdjustSizeToVisc = PlayerVariables.CharacterFullHeight.Y/2
VariablesForViscerator.AdjustCFrameToVisc = CFrame.new(0, VariablesForViscerator.AdjustSizeToVisc, 0)
VariablesForViscerator.VisceratorsFolder = Services.Workspace:FindFirstChild("Viscerators")
VariablesForViscerator.NegativeAdjustmentCFrame = CFrame.new(-VariablesForViscerator.AdjustCFrameToVisc.X, -VariablesForViscerator.AdjustCFrameToVisc.Y, -VariablesForViscerator.AdjustCFrameToVisc.Z)
VariablesForViscerator.NewWayPathForViscerator = Services.PathfindingService:CreatePath()


local TilesVariables = {} -- All Tiles Variables, gonna be used for things like create/run/check/delete Tiles and etc
TilesVariables.CurrentTileVisceratorAt = nil
TilesVariables.TilesLoopActive = nil
TilesVariables.LastEnemyAttack = "None"
TilesVariables.TilesCenter = Vector3.new(0, 3, 0)
TilesVariables.SingleTileSize = 6
TilesVariables.PlayerTilesFolder = Services.ReplicatedStorage:FindFirstChild("PlayersTilesFolder"):Clone()
TilesVariables.TilePartExample = Services.ReplicatedStorage:FindFirstChild("TilePartExample"):Clone()
TilesVariables.SpecialPointPartExample = Services.ReplicatedStorage:FindFirstChild("SpecialPointPartExample")
TilesVariables.TotalTilesCreated = 0
TilesVariables.CurrentTilesInUse = 0
TilesVariables.TotalTimesTilesUsed = 0
TilesVariables.LastTileWhichWasChanged = "None"
TilesVariables.TilesAtDestroy = 210
TilesVariables.TilesToDestroyInTotal = 105
TilesVariables.TilesIncrementPerDestroy = 2
TilesVariables.TileAtVisceratorNow = "None"
TilesVariables.TileFolderExample = Services.ReplicatedStorage:FindFirstChild("TileFolderExample")


local LoopsStates = {} -- Loops states for monitor when certain Loop is running or no, i think the way i've designed system, only TilesLloop will be usefull
LoopsStates.TilesLoopRunning = Instance.new("BoolValue")
LoopsStates.TilesLoopRunning.Value = false
LoopsStates.RunningLoopRunning = Instance.new("BoolValue")
LoopsStates.RunningLoopRunning.Value = false
LoopsStates.AttackLoopRunning = Instance.new("BoolValue")
LoopsStates.AttackLoopRunning.Value = false




local LoopsTicksVariables = {} -- to quickly get Loops ticks 
LoopsTicksVariables.TilesLoopTick = 1/6
LoopsTicksVariables.MovingLoopTick = 1/6
LoopsTicksVariables.AttackLoopTick = 0.666

local FunctionsAndTheirTicksToLoop = {} -- To change Current loop Ticks when new action in effect 
FunctionsAndTheirTicksToLoop["TakeOut"] = 0.015
FunctionsAndTheirTicksToLoop["PlacedOnBack"] = 0.015
FunctionsAndTheirTicksToLoop["FlyToSpotAndStay"] = 1/6
FunctionsAndTheirTicksToLoop["FollowCharacter"] = 1/6
FunctionsAndTheirTicksToLoop["AttackNearestPerson"] = 0.666 
FunctionsAndTheirTicksToLoop["AttackChosenPerson"] = 0.666
FunctionsAndTheirTicksToLoop["AttackOppositeTeamEnemies"] = 0.666
FunctionsAndTheirTicksToLoop["CreateTiles"] = 1/6 

local RemoteEvents = {} -- Just few remote events
RemoteEvents.SpawnViscEvent = Services.ReplicatedStorage:FindFirstChild("SpawnVisc")
RemoteEvents.DoAttackEvent = Services.ReplicatedStorage:FindFirstChild("DoAttack")
RemoteEvents.SpawnNpcEvent = Services.ReplicatedStorage:FindFirstChild("SpawnNpcs")



local RayCastVariables = {} -- RayCast params to use for any Raycasting function, in VisceratorSystem local script will set it to all Instnaces to avoid
RayCastVariables.NewRaycastParams = RaycastParams.new()
RayCastVariables.NewRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
RayCastVariables.NewRaycastParams.FilterDescendantsInstances = {}

local MainFunctionsTable = {} -- Will be useful to quickly get Tiles names from this like : VariablesTable[MainFunctionsTable[CurrentLoop.Name]].Value = true
MainFunctionsTable.CreateTilesloopFunction = "" -- kind of like when CreateTilesLoop changed instead of write it do like : from name of changed loop receive its Object BoolValue to activate quickly
MainFunctionsTable.CreateMovingLoopFunction = ""
MainFunctionsTable.CreateAttackLoopFunction = ""

local TableWithNamesOfAllActionsTypes = {} -- help to figure out to which Loop each action type is related!
TableWithNamesOfAllActionsTypes["TakeOut"] = {["LoopType"] = "MovingLoop"}
TableWithNamesOfAllActionsTypes["PlacedOnBack"] = {["LoopType"] = "MovingLoop"}
TableWithNamesOfAllActionsTypes["FlyToSpotAndStay"] = {["LoopType"] = "MovingLoop"}
TableWithNamesOfAllActionsTypes["FollowCharacter"] = {["LoopType"] = "MovingLoop"}
TableWithNamesOfAllActionsTypes["AttackNearestPerson"] = {["LoopType"] = "AttackLoop"} 
TableWithNamesOfAllActionsTypes["AttackChosenPerson"] = {["LoopType"] = "AttackLoop"}
TableWithNamesOfAllActionsTypes["AttackOppositeTeamEnemies"] = {["LoopType"] = "AttackLoop"}
TableWithNamesOfAllActionsTypes["CreateTiles"] = {["LoopType"] = "TilesLoop"} -- last one kind of no needed tho

local LoopsToCreateValuesTable = {} -- hold loops BoolValue Objects by their type to then quickly activate when needed to!
LoopsToCreateValuesTable.MovingLoop = LoopsToCreateValuesTable.MovingLoop
LoopsToCreateValuesTable.AttackLoop = LoopsToCreateValuesTable.AttackLoop
LoopsToCreateValuesTable.TilesLoop = LoopsToCreateValuesTable.TilesLoop

local MovingObjectsFunctions = {} -- Will Store of an main functions for move!

local AttackMethodsFunctions = {} -- Will store of an main functions for attack!

local LoopsTypesAndTheirActionsFunctions = {} -- gonna use them to help figure out to which loop each function belong and to use them easily and fast!
LoopsTypesAndTheirActionsFunctions.MovingLoop = MovingObjectsFunctions
LoopsTypesAndTheirActionsFunctions.AttackLoop = AttackMethodsFunctions
-- filled at Viscerator sysyem, if i am not mistaken

local VisceratorGuiVariables = {} -- Gui Varaibles of Viscerator Frame from where gonna trigger functions to run by buttons like MoveTo/Attack/Fly etc
VisceratorGuiVariables.VisceratorGui = PlayerVariables.PlayerGuis:FindFirstChild("VisceratorGui") --Services.PlayerGuis:FindFirstChild("VisceratorGui") -- Gui Buttons By names gonna trigger certain events! Such as stop Attack and start follow or etc!
VisceratorGuiVariables.VisceratorFrame = VisceratorGuiVariables.VisceratorGui:FindFirstChild("VisceratorFrame")
VisceratorGuiVariables.CurrentActionDoingLabel = VisceratorGuiVariables.VisceratorFrame:FindFirstChild("CurrentActionDoingLabel")
VisceratorGuiVariables.TableOfButtonsToActivate = {}
VisceratorGuiVariables.TableOfTriggetFunctions = {}
VisceratorGuiVariables.CurrentActionDoingLabel.Text = "Current State : Not Spawned!"
VisceratorGuiVariables.SpawnVisceratorButton = VisceratorGuiVariables.VisceratorGui:WaitForChild("SpawnVisc") -- Button to spawn visc when can to
VisceratorGuiVariables.SpawnViscConnection = "" 
VisceratorGuiVariables.SpawnViscConnection = VisceratorGuiVariables.SpawnVisceratorButton.MouseButton1Click:Connect(function()

	RemoteEvents.SpawnViscEvent:FireServer() -- gonna call remote even to server and if sever accept, will spawn on server, give network ownership to Visc part
	VisceratorGuiVariables.SpawnVisceratorButton.Visible = false -- and gonna use on client then to do everything except deal damage, will hold that part on server!

end)

local SpawnCiviliansGuiVariables = {} -- Same as above but for Spawn Civs Gui and its buttons
SpawnCiviliansGuiVariables.SpawnCiviliansTeamNpcsGui = PlayerVariables.PlayerGuis:FindFirstChild("SpawnCivilianTeamNpcsGui") --Services.PlayerGuis:WaitForChild("SpawnCivilianTeamNpcsGui") -- part to help spawn some Pseudo "Civilian Players"!
SpawnCiviliansGuiVariables.SpawnCivsFrame = SpawnCiviliansGuiVariables.SpawnCiviliansTeamNpcsGui:WaitForChild("SpawnCivTeamNpcsFrame")
SpawnCiviliansGuiVariables.TotalCiviliansSpawned = 0
SpawnCiviliansGuiVariables.TypesOfNpcsToSpawn = require(PlayerVariables.StarterPlayerScripts.ModulesForVisceratorSystemFolder.AdditionalInformation.CivliansToSpawnModule).TypesOfNpcsToSpawn
SpawnCiviliansGuiVariables.CivilianExample = Services.ReplicatedStorage:WaitForChild("CivilianExample")

RayCastVariables.NewRaycastParams.FilterDescendantsInstances = {PlayerVariables.Character, VariablesForViscerator.Teams, VariablesForViscerator.VisceratorsFolder, TilesVariables.PlayerTilesFolder}
-- first setting, will be used and corrected again at VisceratorSystem after all of FinalSetupFunctions are ran and connected all different Varaibles/Functions/Connections into single system

Variables.Services = Services
Variables.PlayerVariables = PlayerVariables  
Variables.CreateLoopsVariables = CreateLoopsVariables  
Variables.CreateActionsVariables = CreateActionsVariables
Variables.VariablesForViscerator = VariablesForViscerator
Variables.TilesVariables = TilesVariables
Variables.LoopsTicksVariables = LoopsTicksVariables
Variables.FunctionsAndTheirTicksToLoop = FunctionsAndTheirTicksToLoop  
Variables.RemoteEvents = RemoteEvents 
Variables.RayCastVariables = RayCastVariables
Variables.MainFunctionsTable = MainFunctionsTable
Variables.TableWithNamesOfAllActionsTypes = TableWithNamesOfAllActionsTypes  
Variables.LoopsToCreateValuesTable = LoopsToCreateValuesTable  
Variables.MovingObjectsFunctions = MovingObjectsFunctions  
Variables.AttackMethodsFunctions = AttackMethodsFunctions 
Variables.LoopsTypesAndTheirActionsFunctions = LoopsTypesAndTheirActionsFunctions
Variables.VisceratorGuiVariables = VisceratorGuiVariables
Variables.SpawnCiviliansGuiVariables = SpawnCiviliansGuiVariables
Variables.LoopsStates = LoopsStates

-- just to then set all of those tables of Variables related to different types of thigns into Main Table and then return it!
-- Gonna use VariablesTable by FinalSetupFuncitons(Variables) to turn all of those into Single Table, so therefore it will be VarsTable.Player and not VarsTable.PlayerVariables.Player
-- Not sure if it is good idea but for me seems kind of not bad

return Variables

-- seems like all variables are finished! Last thing to mention! Not Services.StarterGuis but Player.PlayerGuis.GuiToFind! Or othreways it will not manipulate
-- With Player Guis! Instead with StarterGuis! (Not 100% if starter gui wont become main gui for current case but for some it is not so we shall simply
-- use playergui directly instead to not face any possible errors in future!)
-- Okay now, at first look seems like everything is finished finally! Now shall move to the rest! And eventually maybe return here to fix or change/add some
-- things to increase overall level of code format!

-- May fullfill 120-122 lines of code with actual loops names before of finish everything!
-- To then easily call funcs itself from them!
-- aka before of all, Vars,MainFuncs,Tiles/Fly/Attack = LoopsFuncs.CreateTiles/Fly/Attack! 
-- Oh also about connections, we may need to first fullfill some of their STATS LIKE VARS/FUNCTIONS!Will think about it tho!
