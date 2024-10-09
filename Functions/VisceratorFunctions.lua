local VisceratorFunctions = {} -- Visc action functions!

VisceratorFunctions.MakeNewPath = function(StarterPos, FinalPos, VariablesTable) -- Gonna use it to make new Pathfinding!

	return VariablesTable.NewWayPathForViscerator:GetWaypoints(VariablesTable.NewWayPathForViscerator:ComputeAsync(StarterPos, FinalPos)) 

end

VisceratorFunctions.CastNewRay = function(StarterPos, FinalPos, VariablesTable) -- Casting new ray by given Positions!
	
	local Distance = (StarterPos - FinalPos).Magnitude
	return workspace:Raycast(StarterPos, (FinalPos - StarterPos).Unit * Distance, VariablesTable.NewRayCastParams)

end

VisceratorFunctions.TeleportViscerator = function(VariablesTable, AllFunctonsTable) -- To instantly Teleport Viscerator To Goal Position!
	
	VariablesTable.Viscerator.CFrame = VariablesTable.HumanoidRootPart.CFrame * VariablesTable.VisceratorOffset 
	VariablesTable.LastTimeVisceratorPathUpdated = os.clock()


end

VisceratorFunctions.FlyObject = function(Object, MoveTo, VariablesTable) -- To Simply fly object, i've used pretty strange method of Lerping from cur to final goal respecting to
	-- 1.Each tick real time take around 0.015 probably, 2.Make sure that visc using this exact method will travel to given distance in given time 
	-- in this example around 32 studs per second!
	-- Anchoring to make changes be visible on both server and client as cannot update pos without anch = false using Network Ownership
	Object.Anchored = false
	local FlyTo = MoveTo * VariablesTable.AdjustCFrameToVisc --PosTo * AdjustCFrameToVisc
	local Successs = false
	local DistanceToFly = 0 
	DistanceToFly = (Object.CFrame.Position - FlyTo.Position).Magnitude 
	local SecondMoveToDistance = 32

	local SingleTickCanMoveToDistance = SecondMoveToDistance / (1/0.015)
	local ItterationsToUseCurrentFly = math.clamp(DistanceToFly / SingleTickCanMoveToDistance, 1, 1000000)
	local StarterPosOfFlyFrom = Object.CFrame

	for i = 0, ItterationsToUseCurrentFly, 1 do
		task.wait()
		Object.Velocity = Vector3.new(0, 0, 0) -- VERY IMPORTANT PART TO MAKE SURE PART WILL NEVER BE GLITCHED!!!
		Object.CFrame = StarterPosOfFlyFrom:Lerp(FlyTo, i/ItterationsToUseCurrentFly)
		VariablesTable.LastTimeVisceratorPathUpdated = os.clock()
	end; Object.Anchored = true
	Successs = true
	return Successs
end

VisceratorFunctions.AttackTarget = function(Object, Target,VariablesTable, AllFunctionsTable) -- To just attack Enemies! Object Is Visc part and Target is Instance of Enemy!
	local FinalPosToReturn = Object.CFrame
	local OriginalStarterPos = Object.CFrame; 
	if Target == nil or Target:FindFirstChild("HumanoidRootPart") == nil  then return end -- if no part exist anymore!
	local OriginalEnemyPosToAttack = Target:FindFirstChild("HumanoidRootPart").CFrame

	OriginalStarterPos = CFrame.lookAt(OriginalStarterPos.Position, OriginalEnemyPosToAttack.Position)
	OriginalStarterPos = OriginalStarterPos + OriginalStarterPos.LookVector * ((OriginalStarterPos.Position - OriginalEnemyPosToAttack.Position).Magnitude - 3) --OriginalStarterPos + OriginalStarterPos.LookVector(OriginalEnemyPosToAttack.Position) * ((OriginalStarterPos.Position - OriginalEnemyPosToAttack.Position).Magnitude - 3)
	AllFunctionsTable.FlyObject(Object, OriginalStarterPos, VariablesTable)
	-- Basically doing some manipulations with 3D space to make Visc look at direction to attack and fly to nearby of of person whom to attack
	-- but 2 studs away from them, from posiion started attack!
	if VariablesTable.LastViscAttackHappened.Value + VariablesTable.AttackLoopTick <= os.clock() then -- if cooldown of last attack passed then time for real damage!!!!

		VariablesTable.DoAttackEvent:FireServer(Target.Name) -- to check if target exist and right on rank etc on server, and cd passed so dmg them!

	end
	AllFunctionsTable.FlyObject(Object, FinalPosToReturn * VariablesTable.NegativeAdjustmentCFrame, VariablesTable ) -- fly back to starter pos before of doing any attack!
	-- Could change to player but much of issues could happen + not always need to so
	-- Better to keep like this in my opinion!

end


VisceratorFunctions.SpawnViscerator = function(VariablesTable, AllFunctionsTable) -- Spawn visc itself! Gonna manually trigger and create some functions to start first default loop and action which is
	-- Moving Loop and FollowingCharacter Function!

	VariablesTable.Viscerator.Anchored = true
	VariablesTable.Viscerator.CFrame = VariablesTable.HumanoidRootPart.CFrame * VariablesTable.VisceratorOffset
	local NewTileAxis, NewTileName = AllFunctionsTable.CreateCurrentTileAndItsName(VariablesTable.Viscerator.Position, VariablesTable) 
	AllFunctionsTable.CheckAndCreateOrUpdateTileFolder(NewTileAxis, NewTileName, VariablesTable.Viscerator.Position, VariablesTable)
	VariablesTable.PlayerTilesFolder:FindFirstChild(NewTileName):FindFirstChild("LastTimeTileUsed").Value = 0 
	VariablesTable.CurrentTileVisceratorAt = NewTileName
	VariablesTable.VisceratorActionToDo.Value = "FollowCharacter"
	VariablesTable.CurrentActionVisceratorDoing.Value = "FollowCharacter"
	print("Check Loops")
	print("???????")
	if VariablesTable.TilesLoopRunning.Value == false then -- in case not running!

		VariablesTable.CreateTilesLoop.Value = true

	end

	if VariablesTable.RunningLoopRunning.Value == false then -- in case this loop and fucntion did not started!

		VariablesTable.CreateMovingLoop.Value = true 

	end

end


return VisceratorFunctions
