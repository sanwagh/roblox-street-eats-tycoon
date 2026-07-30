--[[
    NpcBuy (ModuleScript)
    Path: ServerScriptService → NpcSpawning
    Parent: NpcSpawning
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local NpcBuy = {}
NpcBuy.__index = NpcBuy

-- use os.time() for uuid


function NpcBuy.new(plr, Npc, PlayerCost)
	local self = setmetatable({}, NpcBuy)
	
	self.Player = plr
	self.Npc = Npc
	self.PlayerCost = tonumber(PlayerCost)
	
	self.Item = nil
	self.CostByNpc = 0
	
	
	
	return self
end

local ChatService = game:GetService("Chat")


function NpcBuy:CheckStats()
	warn(self.Npc)
	ChatService.BubbleChatEnabled = true
	
	
	self.Item = self.Npc:GetAttribute("Item")
	self.CostByNpc = tonumber(self.Npc:GetAttribute("Cost"))
	warn("COST: ", self.CostByNpc, self.PlayerCost, type(self.CostByNpc), type(self.PlayerCost))
	local Response = self:GetResponse()
	local Connection
	local Given = false
	
	if not Response then
		wait(2) 
		self.Npc.Humanoid:MoveTo(self.Npc.HumanoidRootPart.Position - Vector3.new(20,0,0)) 
		self.Npc:Destroy() 
		return false 
	end
	
	self.Npc.HumanoidRootPart.GiveOrderPrompt.Enabled = true

	
	Connection = self.Npc.HumanoidRootPart.GiveOrderPrompt.Triggered:Connect(function()
		Given = true
		self.Npc:SetAttribute("OrderGiven", true)
	end)
	
	while Given == false do
		wait()
	end 
	print("Order Given")
	return Response
end

function NpcBuy:GetResponse() -- returns boolean
	-- BUG: Pricing is wrong
	ChatService.BubbleChatEnabled = true

	local Item = self.Npc:GetAttribute("Item")
	
	if self.CostByNpc < self.PlayerCost + 10 and self.CostByNpc > self.PlayerCost + 5 then 
		ChatService:Chat(self.Npc.Head,Item.." is too Expensive.")
		return false
		
	elseif self.CostByNpc < self.PlayerCost + 6 and self.CostByNpc > self.PlayerCost + 10  then

		ChatService:Chat(self.Npc.Head,"Expensive, But I may consider buying "..Item)
		
		local RandNum = math.random(1,10)
		if RandNum%10 == 0 then
			
			ChatService:Chat(self.Npc.Head,"Ig Ill buy the "..Item)
			return true
		else
			ChatService:Chat(self.Npc.Head,"Nope, forget about it.")
			return false
		end
		
	elseif self.CostByNpc < self.PlayerCost + 3 and self.CostByNpc > self.PlayerCost + 6  then
		
		ChatService:Chat(self.Npc.Head,"Ok ill buy "..Item)
		return true
	elseif self.CostByNpc == self.PlayerCost then		
		ChatService:Chat(self.Npc.Head,"The price is perfect! Ill get "..Item)
		return true
		
	elseif self.CostByNpc > self.PlayerCost and self.CostByNpc > self.PlayerCost - 3 then
		
		ChatService:Chat(self.Npc.Head,"Cheap! Ill Buy "..Item)
		return true
	elseif self.CostByNpc < self.PlayerCost - 3 and self.CostByNpc > self.PlayerCost then
	
		ChatService:Chat(self.Npc.Head,"Cheap! Ill Buy "..Item)
		return true
	elseif self.CostByNpc < self.PlayerCost - 6 and self.CostByNpc > self.PlayerCost - 3 then

		ChatService:Chat(self.Npc.Head,"Wow Pretty Cheap, ill Buy "..Item)
		return true
	elseif self.CostByNpc < self.PlayerCost - 10  and self.CostByNpc > self.PlayerCost - 6 then

		ChatService:Chat(self.Npc.Head,"Super Cheap! Can't skip this offer! Ill get the "..Item)
		return true
	elseif self.CostByNpc < self.PlayerCost and self.CostByNpc > self.PlayerCost - 10  then
		ChatService:Chat(self.Npc.Head,"Id like to buy "..Item)
		return true
	else
		warn("Something went wrong| Cost by Npc: ", self.CostByNpc,"|",self.PlayerCost)
	end
end

return NpcBuy
