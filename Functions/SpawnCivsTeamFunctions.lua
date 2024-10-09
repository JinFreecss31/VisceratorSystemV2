local SpawnCivsFunctions = {} -- simply function to spawn civs, by this i mean when certain button of type spawning npcs are pressed, gonna get NpcType and send its Values to Server!

SpawnCivsFunctions.SpawnChosenNpc = function(ChosenNpcTypeButton, VariablesTable) -- Simply spawn chosen Npc! By click on one of buttons from rigth side gui's frame!
	
	local ChosenNpcType = VariablesTable.OriginalModulesMainTable.AdditionalInformation.CivliansToSpawnModule.TypesOfNpcsToSpawn[ChosenNpcTypeButton.Name]
	local NewNpcToSpawnCFrame = CFrame.new()
	local MouseButtonConnection
	local Mouse = VariablesTable.Mouse
	local HumanoidRootPart = VariablesTable.HumanoidRootPart
	local CivExampleFullSize = VariablesTable.CivilianExample:GetExtentsSize()
	local ButtonConnection = ChosenNpcTypeButton.MouseButton1Up:Connect(function()
		
		MouseButtonConnection = Mouse.Button1Down:Connect(function() -- Basically each time certain button hit, get their type of npc to spawn and then
			-- Just create short Mouse button1 up connection till we do it once to get coords to where spawn npc and then simly using direction and limits spawn npc!
			-- limit 100 studs away from player!
			local StudsAwayToSpawn = math.clamp((Mouse.Hit.Position - HumanoidRootPart.Position).Magnitude, 12, 100)
			NewNpcToSpawnCFrame = HumanoidRootPart.CFrame
			NewNpcToSpawnCFrame = CFrame.lookAt(HumanoidRootPart.Position, Mouse.Hit.Position)
			NewNpcToSpawnCFrame = NewNpcToSpawnCFrame + NewNpcToSpawnCFrame.LookVector * StudsAwayToSpawn
			VariablesTable.SpawnNpcEvent:FireServer(ChosenNpcType["MainRank"], ChosenNpcType["GunEquipped"], NewNpcToSpawnCFrame * CFrame.new(0, CivExampleFullSize.Y/2,0))
			-- Yeah btw Server side thing too!! As Attacks as well going from Server Side!
			--  About Npcs, they have few of following stats -> MainRank (Civ/Reb), GunEquipped true/false BoolV, LastTimeDied Intval of os.clock() when died to make sure remove enemy from visc enemies list!
			MouseButtonConnection:Disconnect()

		end)
		
	end)

	

end

return SpawnCivsFunctions
