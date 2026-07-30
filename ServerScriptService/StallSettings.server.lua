--[[
    StallSettings (Script)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]


local function Price(price, stall)
	local Item = stall.ItemsCost:GetChildren()[1]
	wait(1)
	stall:SetAttribute(Item.Name, price)
	print("-> Updates Price for ", Item.Name)
end

local function Restock(Player,Amt, Stall)
	-- Costs 60% of items cost
	local Item = Stall.ItemsCost:GetChildren()[1]
	local CostPerItem = 0.6 * Stall.ItemsCost[Item.Name].Value
	local TotalCost = CostPerItem * Amt
	
	if Player.leaderstats.Cash.Value >= TotalCost then
		Player.leaderstats.Cash.Value -= TotalCost
		Stall:SetAttribute("Storage", Stall:GetAttribute("Storage") + Amt)
		
		print("-> Restocked ", Item.Name, " by ", Amt, " for $", TotalCost)
	else
		warn("Player does not have enough cash to restock", TotalCost)
	end
end

game.ReplicatedStorage:WaitForChild("Events").Stall.OnServerEvent:Connect(function(Player, Type, Data:NumberValue, Obj)
	if Type == "Price" then
		Price(Data, Obj)
	elseif Type == "Restock" then
		Restock(Player,Data,Obj)
	end
end)