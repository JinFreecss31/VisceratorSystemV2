local TableOfTriggetFunctions = {} -- simply use for trigger certain functions to happen! FinalSetupFunctions gonna connect them all with real Buttons/Values

TableOfTriggetFunctions.TakeOut = function(VariablesTable, AllFunctionsTable) -- Function to trigger take out and etc actions if such of them must to be by pressing buttons!
print(VariablesTable); print(AllFunctionsTable)
	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "TakeOut" then 
		VariablesTable.ChangeActionOnCooldown.Value = true
		VariablesTable.VisceratorActionToDo.Value = "TakeOut"
	end

end 

TableOfTriggetFunctions.PlacedOnBack = function(VariablesTable, AllFunctionsTable) -- same for dif act!

	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "PlacedOnBack" then
		VariablesTable.ChangeActionOnCooldown.Value = true
		VariablesTable.VisceratorActionToDo.Value = "PlacedOnBack"
	end
end

TableOfTriggetFunctions.FlyToSpotAndStay = function(VariablesTable, AllFunctionsTable)

	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "FlyToSpotAndStay" then
		VariablesTable.ChangeActionOnCooldown.Value = true
		local Mouse = VariablesTable.Mouse
		local ConnectionToRun
		ConnectionToRun = Mouse.Button1Down:Connect(function()

			if not AllFunctionsTable.CastNewRay(VariablesTable.Viscerator.Position, Mouse.Hit.Position, VariablesTable) then -- in case we got spot, set its position and then run changes!

				VariablesTable.PossiblePositionToMoveTo = Mouse.Hit.Position
				VariablesTable.VisceratorActionToDo.Value = "FlyToSpotAndStay"
				--ConnectionToRun:Dsconnect() -- 

			end

			ConnectionToRun:Disconnect() -- anyways first time we press mouse button, we remove this connection!

		end)
	end

end

TableOfTriggetFunctions.FollowCharacter = function(VariablesTable, AllFunctionsTable) -- Here same! EVen it is one of the "hardest" functions of system in fact 

	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "FollowCharacter" then
		VariablesTable.ChangeActionOnCooldown.Value = true
		VariablesTable.VisceratorActionToDo.Value = "FollowCharacter"
	end

end

TableOfTriggetFunctions.AttackNearestPerson = function(VariablesTable, AllFunctionsTable) -- same

	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "PlacedAtBack" then
		VariablesTable.ChangeActionOnCooldown.Value = true
		VariablesTable.VisceratorActionToDo.Value = "AttackNearestPerson"
	end

end
--local Target = "Target"
TableOfTriggetFunctions.AttackChosenPerson = function(VariablesTable, AllFunctionsTable) -- must make certain additions

	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "PlacedAtBack" then
		VariablesTable.ChangeActionOnCooldown.Value = true
		--VisceratorActionToDo.Value = "AttackChosenPerson"
		VariablesTable.PossibleTarget = nil
		local Mouse = VariablesTable.Mouse
		local Connection
		Connection = Mouse.Button1Down:Connect(function()

			if Mouse.Target then -- well everywhere target instead of hit lol

				if Mouse.Target.Parent and Mouse.Target.Parent:FindFirstChild("HumanoidRootPart") then

					VariablesTable.CurrentChosenEnemyToAttack = Mouse.Target.Parent

					VariablesTable.PossibleTarget = Mouse.Target.Parent -- in case we touched plrs body part

				elseif Mouse.Target.Parent.Parent and Mouse.Target.Parent.Parent:FindFirstChild("HumanoidRootPart") then

					VariablesTable.PossibleTarget = Mouse.Target.Parent.Parent -- in case we touched Accesory which is child of body part

				end
print(VariablesTable.PossibleTarget)
				if VariablesTable.Teams.CivilianTeam:FindFirstChild(VariablesTable.PossibleTarget.Name) and (VariablesTable.Teams.CivilianTeam:FindFirstChild(VariablesTable.PossibleTarget.Name):FindFirstChild("HumanoidRootPart").Position - VariablesTable.Viscerator.Position).Magnitude <= VariablesTable.MaxAttackDistance and not AllFunctionsTable.CastNewRay(VariablesTable.Viscerator.Position, VariablesTable.PossibleTarget:FindFirstChild("HumanoidRootPart").Position, VariablesTable) then -- means target mouse hit, is Body of Human and also its name stored in Civs Team!

					VariablesTable.VisceratorActionToDo.Value = "AttackChosenPerson"

				end
			end

			Connection:Disconnect()

		end) -- Bascially we if can to, open mouse event and first time button1down triggered, check if someone found and they are part of Civilian!
		-- Then Simply approve them as target and approve attacking them! else do not forget to remove/change unnecessary variables when need to!
	end

end

TableOfTriggetFunctions.AttackOppositeTeamEnemies = function(VariablesTable, AllFunctionsTable) -- same!

	if VariablesTable.ChangeActionOnCooldown.Value == false and VariablesTable.CurrentActionVisceratorDoing.Value ~= "PlacedAtBack" then
		VariablesTable.ChangeActionOnCooldown.Value = true
		VariablesTable.VisceratorActionToDo.Value = "AttackOppositeTeamEnemies"
	end

end



return TableOfTriggetFunctions
