--[[
    _DataStore (ModuleScript)
    Path: ServerScriptService → DataStores
    Parent: DataStores
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local DataStore = {}
DataStore.__index = DataStore

local DataStoreService = game:GetService("DataStoreService")

local DataStoreOptions = Instance.new("DataStoreOptions")
DataStoreOptions.AllScopes = true

local PlayerData = DataStoreService:GetDataStore("PlotDataAlpha","", DataStoreOptions)
local CleanupModule = require(script.Parent.Cleanup)


local PlotData = {}
local StatsData = {}

function DataStore.new(plr)
	local self = setmetatable({}, DataStore)
	
	self.Player = plr
	
	
	return self
end

local function GetPlot(plr)
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == plr.Name then
			return v
		end
	end
end

function DataStore:CreateData()
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = self.Player
	
	local Cash = Instance.new("IntValue")
	Cash.Name = "Cash"
	Cash.Value = 700
	Cash.Parent = leaderstats
	
	local LevelStats = Instance.new("Folder")
	LevelStats.Name = "LevelStats"
	LevelStats.Parent = self.Player
	
	local Level = Instance.new("IntValue")
	Level.Name = "Level"
	Level.Value = 1
	Level.Parent = LevelStats
	
	local XP = Instance.new("IntValue")
	XP.Name = "XP"
	XP.Value = 0
	XP.Parent = LevelStats
	
	local RequiredXP = Instance.new("IntValue")
	RequiredXP.Name = "RequiredXP"
	RequiredXP.Value = 0
	RequiredXP.Parent = LevelStats
	
	local Tutorial = Instance.new("BoolValue")
	Tutorial.Name = "TutorialDone"
	Tutorial.Parent = self.Player
	
	local MonetizationData = Instance.new("Folder")
	MonetizationData.Name = "MonetizationData"
	MonetizationData.Parent = self.Player
	
	local CashBoost = Instance.new("IntValue")
	CashBoost.Name = "CashBoost"
	CashBoost.Parent = MonetizationData
	
	local XPBoost = Instance.new("IntValue")
	XPBoost.Name = "XPBoost"
	XPBoost.Parent = MonetizationData
end

function DataStore:LoadData()
	local Key = "Data:"..self.Player.UserId
	
	local PlayerPlot = GetPlot(self.Player)
	
	local success, errormessage = pcall(function()
		PlotData = PlayerData:GetAsync("Plot/"..tostring(Key))
		StatsData = PlayerData:GetAsync("Stats/"..tostring(Key))
	end)
	
	if success then
		if PlotData == nil or StatsData == nil then PlotData = {} StatsData = {} warn("-> No Saved Data found! "..self.Player.Name) self.Player.TutorialDone.Value = false return end 
		
		for i, val in pairs(PlotData) do
			task.wait()
			local Item = game.ReplicatedStorage.Items:FindFirstChild(PlotData[i][1]):Clone()
			Item.Parent = PlayerPlot.Items
			Item:PivotTo(CFrame.new(PlayerPlot.Plot.Position.X - PlotData[i][3],PlayerPlot.Plot.Position.Y - PlotData[i][4], PlayerPlot.Plot.Position.Z - PlotData[i][5])*CFrame.Angles(0,math.rad(PlotData[i][6]),0))
			
			local Attribute = Item:GetAttributes()
			
			for x, atr in pairs(Attribute) do
				if PlotData[i][2][x] == nil then
					local ActualAtr = game.ReplicatedStorage.Items:FindFirstChild(PlotData[i][1]):GetAttribute(x)
					Item:SetAttribute(x, ActualAtr)
				else
					Item:SetAttribute(x, PlotData[i][2][x])	
				end
			end
		end	
		
		self.Player.leaderstats.Cash.Value = StatsData.Cash
		
		self.Player.LevelStats.Level.Value = StatsData.Level
		self.Player.LevelStats.XP.Value = StatsData.XP
		
		self.Player.TutorialDone.Value = StatsData.TutorialDone
		
		self.Player.MonetizationData.CashBoost.Value = StatsData.CashBoost
		self.Player.MonetizationData.XPBoost.Value = StatsData.XPBoost
	end
end

function DataStore:SaveData()
	local Key = "Data:"..self.Player.UserId

	local PlayerPlot = GetPlot(self.Player)
	
	PlotData = {}
	
	for i,items:Model in pairs(PlayerPlot.Items:GetChildren()) do
		table.insert(PlotData,{
			items.Name, -- Data[i][1]: CONSTANT

			items:GetAttributes(); --Data[i][2]: CONSTANT

			PlayerPlot.Plot.Position.X - items.PrimaryPart.Position.X,
			PlayerPlot.Plot.Position.Y - items.PrimaryPart.Position.Y,
			PlayerPlot.Plot.Position.Z - items.PrimaryPart.Position.Z,

			items.PrimaryPart.Orientation.Y,
		})
	end
	
	StatsData = {
		Cash = self.Player.leaderstats.Cash.Value,
		
		Level = self.Player.LevelStats.Level.Value,
		XP = self.Player.LevelStats.XP.Value,
		
		TutorialDone = self.Player.TutorialDone.Value,
		
		CashBoost = self.Player.MonetizationData.CashBoost.Value;
		XPBoost = self.Player.MonetizationData.XPBoost.Value;
	}
	
	local success, errormessage = pcall(function()
		PlayerData:SetAsync("Plot/"..tostring(Key),PlotData)
		PlayerData:SetAsync("Stats/"..tostring(Key), StatsData)
	end)
	
	if success then
		print("-> Saved Data for player ", self.Player)
		CleanupModule.CleanCache(self.Player, PlayerPlot)
	else
		warn(errormessage, self.Player)
	end
end

return DataStore
