--[[
    DataStores (Script)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

function PlotInit()
	for i,plots in pairs(game.Workspace.Plots:GetDescendants()) do
		if plots:IsA("BasePart") then
			plots.Transparency = 1
		end
	end
end

PlotInit()

local DataStoreModule = require(script._DataStore)

local PlayersLeft = 0
local BindableEvent = Instance.new("BindableEvent")

local NpcSpawningModule = require(script.Parent.NpcSpawning)
local TableManagerModule = require(script.Parent.NpcSpawning.TableManager)
local LevelManagerModule = require(script.LevelManager)


game.ReplicatedStorage:WaitForChild("Events").LoadPlot.OnServerEvent:Connect(function(Player:Player, Plot)
	
	Plot.Owner.Value = Player.Name

	Player.Character:PivotTo(CFrame.new(Plot.Plot.Position + Vector3.new(0,20,Plot.Plot.Size.Z*0.5)))
	
	local DataStore = DataStoreModule.new(Player)
	DataStore:CreateData()
	DataStore:LoadData()
	
	Plot.Open.Value = true
	game.ReplicatedStorage.Events.Loaded:Fire(Player)
	
	if Player.TutorialDone.Value == false then
		game.ReplicatedStorage.Events.StartTutorial:FireClient(Player)
	end
	
	task.spawn(function()
		game.ReplicatedStorage.Events.StartTutorial.OnServerEvent:Connect(function()
			print("-> Player has completed the tutorial.")
			Player.TutorialDone.Value = true
		end)
	end)
	
	task.spawn(function()
		LevelManagerModule.Update(Player)
		Player.LevelStats.XP:GetPropertyChangedSignal("Value"):Connect(function()
			LevelManagerModule.Update(Player)
		end)
	end)
	
	task.spawn(function()
		Plot.Open:GetPropertyChangedSignal("Value"):Connect(function()
			if Plot.Open.Value == true then
				local NpcModule = NpcSpawningModule.new(Player)
				NpcModule:Init()  
			else
				print("Closed tycoon!")
			end
		end)
	end)
	
	task.spawn(function()
		wait(0.1)
		local NpcModule = NpcSpawningModule.new(Player)
		NpcModule:Init()  -- Use NpcModule instead of NpcSpawningModule
	end)
	
	task.spawn(function()
		wait(0.1)
		local TableManager = TableManagerModule.new(Player)
		TableManager:Init()
		task.spawn(function()
			print("Checking occupancy")
			TableManager:CheckOccupancy()
		end)
	end)
end)

game.Players.PlayerRemoving:Connect(function(Player)
	local DataStore = DataStoreModule.new(Player)

	local function ServerShutdown()
		for i,players in pairs(game.Players:GetPlayers()) do
			task.spawn(function()
				DataStore:SaveData()
				print("-> Saved from Bindable Event")
			end)
		end
	end
	warn(Player, "Left")
	print("-> Requesting DataStore to Save Player Data: Waiting for response ", Player)
	
	DataStore:SaveData()
	
	game:BindToClose(ServerShutdown)
end)