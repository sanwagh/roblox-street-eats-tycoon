--[[
    TableManager (ModuleScript)
    Path: ServerScriptService → NpcSpawning
    Parent: NpcSpawning
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local TableManager = {}
TableManager.__index = TableManager

local API = require(script.Parent.Parent.API)

local CollectionService = game:GetService("CollectionService")

function TableManager.new(plr)
	local self = setmetatable({}, TableManager)
	
	self.Player = plr
	self.Npc = nil
	self.PlayerPlot = nil
	
	return self
end

function TableManager:Init()
	wait()
	self.PlayerPlot = API.GetPlayerPlot(self.Player)
	
	local Found = false
	
	while not Found do
		wait()
		for i,v in pairs(self.PlayerPlot.Items:GetChildren()) do
			if CollectionService:HasTag(v, "Table") then
				Found = true
				break
			end
		end
	end
	
	for i, v in pairs(self.PlayerPlot.Items:GetChildren()) do
		if CollectionService:HasTag(v, "Table") then
			v.PrimaryPart.Touched:Connect(function(hit)
				if hit.Parent:FindFirstChild("HumanoidRootPart") and CollectionService:HasTag(hit.Parent, "Npc") and hit.Parent:GetAttribute("Seated") == false then
					warn("HIT")
					hit.Parent:SetAttribute('Seated', true)
					-- Get the seats
					local function GetSeat()
						local SeatsTable = {}
						
						for i,v in pairs(v.Seats:GetChildren()) do
							if v:GetAttribute("Occupied") == false then
								table.insert(SeatsTable, v)
							end
						end
						
						for i,v in pairs(SeatsTable) do
							if v:GetAttribute("Occupied") == false then
								hit.Parent:SetAttribute("Pathfinding", false)
								
								v:SetAttribute("Occupied", true)
								
								--hit.Parent.HumanoidRootPart:PivotTo(CFrame.new(v.Position))
								local sitPosition = v.Position + Vector3.new(0, hit.Parent.HumanoidRootPart.Size.Y, 0)
								local facingDirection = ((sitPosition - hit.Parent.HumanoidRootPart.Position)).Unit
								local sitCFrame = CFrame.new(sitPosition, sitPosition + Vector3.new(facingDirection.X, 0, facingDirection.Z))

								hit.Parent.HumanoidRootPart.CFrame = sitCFrame*CFrame.Angles(0,math.rad(180),0)
								
								print("SIT")
								wait(0.2)
								--hit.Parent.HumanoidRootPart.Anchored = true
								v:SetAttribute("Npc", hit.Parent.Name) -- There should NOT be two npc's with the same name
								break
							end
						end
					end
					GetSeat()
				end
			end)
		end
	end
end

function TableManager.WaitForDeletion(npc, plot) -- Standalone function
	local WaitTime = math.random(2,4)
	print("Leaving in ", WaitTime)
	wait(WaitTime)
	
	for i,v in pairs(plot.Items:GetChildren()) do
		if CollectionService:HasTag(v, "Table") then
			for _, seats in pairs(v.Seats:GetChildren()) do
				if seats:GetAttribute("Npc") == npc.Name then
					print("Npc found")
					seats:SetAttribute("Npc", "")
					seats:SetAttribute("Occupied", false)
					npc:Destroy()
					return
				else
					warn(seats:GetAttribute("Npc"), npc)
				end
			end
		end
	end
end


function TableManager:CheckOccupancy()
	-- Other way is to have an atr with the npc name and then loop thru all the seats and if one has the atr, set it to 
	-- un occupied
	while true do
		wait(0.1)
		for i,v in pairs(self.PlayerPlot.Items:GetChildren()) do
			if CollectionService:HasTag(v, "Table") then
				local Count = 0
				for _, seats in pairs(v.Seats:GetChildren()) do
					if seats:GetAttribute("Occupied", true) then
						Count += 1
					end
				end
				if Count >= v:GetAttribute("DefaultSeats") then
					v:SetAttribute("Occupied",true)
				else
					v:SetAttribute("Occupied",false)
				end
			end
		end
	end
end


----------------------------------------------------[API]---------------------------------------------------------------



return TableManager
