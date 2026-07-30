--[[
    ServerPlacement (Script)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]


local function HandleCollisions(Object, Char)
	local Collided = false
	
	
	if Object then
		local CollisionPoint = Object.PrimaryPart.Touched:Connect(function() end)
		local CollisionPoints = Object.PrimaryPart:GetTouchingParts()

		for i = 1,#CollisionPoints,1 do
			if not CollisionPoints[i]:IsDescendantOf(Object) and not CollisionPoints[i]:IsDescendantOf(Char) then
				Collided = true
				break
			end
		end

		CollisionPoint:Disconnect()

		return Collided
	end
end

local function CheckBounds(Plot, primary)
	local LOWER_X_BOUND
	local LOWER_Z_BOUND

	local UPPER_X_BOUND
	local UPPER_Z_BOUND
	
	local CurrentPos = primary.Position

	LOWER_X_BOUND = Plot.Position.X - (0.5*Plot.Size.X) 
	UPPER_X_BOUND = Plot.Position.X + (0.5*Plot.Size.X)

	LOWER_Z_BOUND = Plot.Position.Z - (0.5*Plot.Size.Z) 
	UPPER_Z_BOUND = Plot.Position.Z + (0.5*Plot.Size.Z) 

	return CurrentPos.X > UPPER_X_BOUND or CurrentPos.X < LOWER_X_BOUND or CurrentPos.Z > UPPER_Z_BOUND or CurrentPos.Z < LOWER_Z_BOUND
end



local function Place(plr, ItemName, ItemLocation, ItemPos, Plot)
	local Item = game.ReplicatedStorage.Items:FindFirstChild(ItemName):Clone()
	
	Item.PrimaryPart.CanCollide = false
	Item.PrimaryPart.Transparency = 1
	
	Item:PivotTo(ItemPos)
	
	
	
	-- CHECK ITEMS FOR COST AND OTHER PARAMS HERE
	-- To move an obj, destroy the current one and make sure that the player is not charged when placing the moved one
	
	warn("CHANGE THIS")
	if Plot  then
		if plr.leaderstats.Cash.Value - Item.Cost.Value >= 0 then
			if plr.LevelStats.Level.Value >= Item.Level.Value then
				Item.Parent = ItemLocation

				
				if not not CheckBounds(Plot, Item.PrimaryPart) then
					Item:Destroy()
					
					plr:Kick("Placing Items out of the plot boundries.")

					return false
				end

				if HandleCollisions(Item, plr.Character) then
					Item:Destroy()
					
					return false
				end
				plr.Character.Sounds.ItemBuy:Play()
				plr.leaderstats.Cash.Value -= Item.Cost.Value
			else
				warn("Higher level needed")
			end
		end
	end
	
	return true
end

game.ReplicatedStorage.Events.Place.OnServerInvoke = Place