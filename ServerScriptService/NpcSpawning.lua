--[[
    NpcSpawning (ModuleScript)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local NpcSpawning = {}
NpcSpawning.__index = NpcSpawning

local SerialTable = {}

local CollectionService = game:GetService("CollectionService")

local NpcBuyModule = require(script.NpcBuy)
local TableManagerModule = require(script.TableManager)

local NpcServerCount = 0

function NpcSpawning.new(plr)
	local self = setmetatable({}, NpcSpawning)
	
	self.Player = plr
	
	self.PlayerPlot = nil
	
	self.Npc = nil
	
	self.Item = nil
	self.Stall = nil
	self.StallLocation = nil
	
	self.Table = nil -- Have SerialNums for tables
	self.TableLocation = nil
	self.NoOfSeats = 0
	
	self.OrderStandLocation = nil
	
	self.CostByNpc = 0
	self.ActualCost = 0
	self.PlayerCost = 0
	
	return self
end



function NpcSpawning:Init()
	-- Get the tables and places on table. If all are full, stop. Search for available places then run this again
	-- Use a while loop/recursion and to check if any tables are free. the while loop will be checking for freed up seats
	-- and/or new tables added.
	--Once this is done, the function will check if the OrderStand , a stall and a table is present using ContextActionService
	-- The function loops until all of them are true
	
	--The spawn function is called where the npc's will spawn with the cost, item, Stall Location then pathfind to it
	wait(0.1)

	self.PlayerPlot = self:GetPlayerPlot() -- INSTANCE
	
	if self.PlayerPlot.Open.Value == false then
		warn("TYCOON CLOSED!")
		return
	end
	
	print("-> Tycoon is Open!")
	
	print("-> Checking for Items: Waiting for response...")
	local ValidateSpawn = self:CheckForMainItems()

	self.NoOfSeats = self:GetTotalSeats()
	
	while not ValidateSpawn do
		wait()
	end
	
	print("-> Checks completed, spawning Npcs")
	warn(self.NoOfSeats)
	for i = 1,self.NoOfSeats,1 do
		--wait(0.5)
		warn(i)
		self:Spawn()
	end
	print("-> All tables are full. Rerunning")
	
	--while self.NoOfSeats <= 0 do
	--	wait()
	--end
	
	self:Init() -- Once the tables are full, the whole function will run again and everything will be checked again
	-- Tables full -> Check -> [0] else Spawn -> [0]
end

function NpcSpawning:Spawn()	
	if self.PlayerPlot.Open.Value == false then return end
	local GetNpcCharacter = self:GetCharacterModel() -- Should return a model
	
	self.Npc = GetNpcCharacter:Clone()
	self.Npc.Name = self:GetSerializedName() -- BUG: Multiple Npc with the same UUID OR Check the serial with the player
	-- check if the npc is owned by the Player if not then go ahead until an npc with that uuid is found that the player owns
	self.Npc.Parent = game.Workspace.NPCFolder
	self.Item = self:GetItem()
	self.CostByNpc = self:GetCostByNpc() 
	print("Cost: ", self.CostByNpc)
	
	
	-- OrderStandLocation is fetched during the checkso
	
	self.Stall = self:GetStallFromItem()	
	self.StallLocation = self:GetStallLocation()
	
	self.PlayerCost = self.Stall:GetAttribute(self.Item.Name)
	
	self.Table = self:GetTable()
	self.TableLocation = self:GetTableLocation()
	
	print(self.Item, self.CostByNpc,self.PlayerCost ,self.Stall, self.StallLocation, self.Table, self.TableLocation)
	
	-- Attributes
	self.Npc:SetAttribute("Player",self.Player.Name)
	self.Npc:SetAttribute("Item", self.Item.Name)
	self.Npc:SetAttribute("Cost", self.CostByNpc)
	self.Npc:SetAttribute("OrderGiven", false)
	self.Npc:SetAttribute("OrderReceived", false)
	self.Npc:SetAttribute("Pathfinding", false)
	self.Npc:SetAttribute("Seated", false)
	
	-- The Table Manager will set the part which the npc is standing on(as a seat)
	
	 -- checks if the same plr is firing and recieving
	-- wait for a bool value which will tell if the npcs order has been taken or not
	-- CALL THE NPC BUY MODULE 
	if self.PlayerPlot.Open.Value == false then return end

	self.Npc:PivotTo(CFrame.new(self.OrderStandLocation ) * CFrame.Angles(0,math.rad(90),0))

	wait(0.2)
	
	local NpcBuy = NpcBuyModule.new(self.Player, self.Npc, self.PlayerCost)
	if not NpcBuy:CheckStats() then self.NoOfSeats += 1 return end
	

	if self.PlayerPlot.Open.Value == false then return end

	-- CALL THE NPC  WORKER MODULE AND SET ORDER GIVEN TO TRUE ONLY IF THE NPC BUYS IT (DO THIS IS NPCBUY MODULE)
	while self.Npc:GetAttribute("OrderGiven") == false do
		wait()
	end
	
	self.Npc.HumanoidRootPart.GiveOrderPrompt.Enabled = false
	print("-> The Npc has given its order. Proceeding to Stall...")
	
	wait(0.5)
	
	self:SubmitToStand()
	-- FOR WORKERS: Call a new module where the delivering will be dealt with
	if self.PlayerPlot.Open.Value == false then return end

	local NewDestination = self.OrderStandLocation + Vector3.new(5,0,0)
	
	self.Npc:SetAttribute("Pathfinding", true)
	game.ReplicatedStorage.Events.Pathfind:Fire(self.Player, self.Npc, NewDestination) 
	
	
	
	if self.PlayerPlot.Open.Value == false then return end

	while self.Npc:GetAttribute("Pathfinding") == true do
		wait()
	end
	
	self.Npc:PivotTo(CFrame.new(self.TableLocation))
	
	self:OrderManager()	 
	
	--while true do
	--	wait()
	--end
	
	return 
end


function NpcSpawning:SubmitToStand()
	if self.PlayerPlot.Open.Value == false then return end

	local Order = Instance.new("StringValue")
	Order.Name = self.Item.Name
	Order.Value = self.Npc.Name
	Order.Parent = self.Stall.Orders
	
end

function NpcSpawning:OrderManager()
	
	task.spawn(function()
		if self.PlayerPlot.Open.Value == false then return end

		local Npc = self.Npc
		-- Table will be fetched thru the data from the TableManager script
		warn(Npc)
		while Npc:GetAttribute("OrderReceived") == false do
			wait()
		end
		
		print("-> Order Given to Npc")
		
		TableManagerModule.WaitForDeletion(Npc,self.PlayerPlot) -- Standalone function
		
	end)
	return
end

-------------------------------------------------[API]-------------------------------------------------------

function NpcSpawning:GetPlayerPlot()
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == self.Player.Name then
			return v
		else
			print("Not found")
		end
	end
end

function NpcSpawning:GetTotalSeats()
	local Count = 0
	for i, item in pairs(self.PlayerPlot.Items:GetChildren()) do
		if CollectionService:HasTag(item,"Table") and item:GetAttribute("Occupied") == false then
			Count += item:GetAttribute("TotalSeats")
		else
		end
	end
	return Count
end

function NpcSpawning:CheckForMainItems()
	-- Checks for them OrderStand, a stall, a table
	
	while #self.PlayerPlot.Items:GetChildren() == 0 do
		wait()
	end
	
	-- Get OrderStall
	
	local OrderStandFound = false

	while OrderStandFound == false do
		wait()
		for i,item in pairs(self.PlayerPlot.Items:GetChildren()) do
			if CollectionService:HasTag(item, "OrderStall") then
				OrderStandFound = true
				self.OrderStandLocation = item.Endpoint.Position
			end
		end
	end
	
	
	-- Stall
	local StallFound = false
	
	while StallFound == false do
		wait()
		for i,item in pairs(self.PlayerPlot.Items:GetChildren()) do
			if CollectionService:HasTag(item, "Stall") then
				StallFound = true
			end
		end

	end
	
	-- Table
	local TableFound = false

	while TableFound == false do
		wait()
		for i,item in pairs(self.PlayerPlot.Items:GetChildren()) do
			if CollectionService:HasTag(item, "Table") then
				TableFound = true
			end
		end
	end
	
	print("-> Found all items: TRUE")
	return true
end

function NpcSpawning:GetCharacterModel()
	local ModelFolder = game.ServerStorage.NPC
	
	local RawNum = math.random(1,#ModelFolder:GetChildren())
	
	return ModelFolder:GetChildren()[RawNum]
end

function NpcSpawning:GetSerializedName()
	NpcServerCount += 1 
	return self.Npc.Name..NpcServerCount
end

function NpcSpawning:GetItem()
	
	local ItemsTable = {}
	
	for i,items in pairs(self.PlayerPlot.Items:GetChildren()) do
		for _,v in pairs(items.ItemsCost:GetChildren()) do
			table.insert(ItemsTable, v)
		end
	end	
	
	local RandNum  = math.random(1,#ItemsTable)
	
	return ItemsTable[RandNum]
end

function NpcSpawning:GetStallFromItem()
	return self.Item.Parent.Parent
end

function NpcSpawning:GetStallLocation()
	return self.Stall.Endpoint.Position
end

function NpcSpawning:GetCostByNpc()
	
	for i,v in pairs(self.PlayerPlot.Items:GetChildren()) do
		if v.ItemsCost:FindFirstChild(self.Item.Name) then
			self.ActualCost = v.ItemsCost:FindFirstChild(self.Item.Name).Value
			break
		end
	end
	
	-- Get the cost decided by the npc on the original Cost
	local RawNum
	

		RawNum = math.random(1,6)
	
	 
	local SignNum = math.random(1,2)
	
	if SignNum == 1 then
		return self.ActualCost + RawNum
	elseif SignNum == 2 then
		return self.ActualCost - RawNum
	end
end

function NpcSpawning:GetTable()
	
	local Table = {}
	
	for i,item in pairs(self.PlayerPlot.Items:GetChildren()) do
		if CollectionService:HasTag(item, "Table") then
			table.insert(Table, item)
		end
	end	
	
	local RawNum = math.random(1, #Table)
	
	return Table[RawNum] -- Instance of the table
end

function NpcSpawning:GetTableLocation()
	return self.Table.Endpoint.Position
end

return NpcSpawning
