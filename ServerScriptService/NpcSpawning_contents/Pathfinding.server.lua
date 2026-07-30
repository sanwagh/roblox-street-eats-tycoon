--[[
    Pathfinding (Script)
    Path: ServerScriptService → NpcSpawning
    Parent: NpcSpawning
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local PathfindingService = game:GetService("PathfindingService")
local Connection

-- instead of pathfinding, the npc will spawn first at the orderstand then after the order is accepted it will disapper
-- then spawn at the table while giving its order to the stand

Connection = game.ReplicatedStorage:WaitForChild("Events").Pathfind.Event:Connect(function(Player, Npc, Location)
	local PlayerPlot
	for	i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == Player.Name then
			PlayerPlot = v
		end
	end
	print(Player, Npc, Location)
	
	local Path = PathfindingService:CreatePath({
		Costs = {
			Concrete = 2;
			Cobblestone = 1,
			
			WoodPlanks = 20000;
			Grass = 20000;
			SmoothPlastic = math.huge;
			Plastic = math.huge;
		}
	})
	
	Path:ComputeAsync(Npc.HumanoidRootPart.Position, Location)
	
	local Waypoints = Path:GetWaypoints()
	local WalkAnimation = Npc.Humanoid:LoadAnimation(Npc.WalkAnim)
	local Reached = false
	
	local PathStatus = Path.Status
	print("Path Status:", PathStatus)
	
	Npc:SetAttribute("Pathfinding", true)
	WalkAnimation:Play()
	task.spawn(function()
		Npc:GetAttributeChangedSignal("Pathfinding"):Connect(function()
			WalkAnimation:Stop()
		end)
	end)
	for i, waypoint in pairs(Waypoints) do
		--local Ball = Instance.new("Part")
		--Ball.Shape = "Ball"
		--Ball.Size = Vector3.new(0.5,0.5,0.5)
		--Ball.Position = waypoint.Position + Vector3.new(0,1,0)
		--Ball.Anchored = true
		--Ball.CanCollide = false
		--Ball.Material = Enum.Material.Neon
		--Ball.Parent = workspace
		-- CHECK IF ANIMATION IS CAUSING LAG
		
		
		
		--if waypoint.Action == Enum.PathWaypointAction.Jump then
		--	Npc.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		--end
			
		Npc.Humanoid:MoveTo(waypoint.Position)
		Npc.Humanoid.MoveToFinished:Wait()
	end
	WalkAnimation:Stop()
	Reached = true
	Npc:SetAttribute("Pathfinding", false)
	
	
	print("Pathfinding Memory: "..tostring(gcinfo()))
	Npc.HumanoidRootPart.Orientation = Vector3.new(0,180,0)
	while Reached == false do
		wait()
	end
	print("-> Reached Destination.")
	--Connection:Disconnect()
end)


