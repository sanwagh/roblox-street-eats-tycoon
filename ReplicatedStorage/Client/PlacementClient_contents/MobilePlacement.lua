--[[
    MobilePlacement (ModuleScript)
    Path: ReplicatedStorage → Client → PlacementClient
    Parent: PlacementClient
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Mouse = Player:GetMouse()

local UserInputService = game:GetService("UserInputService")

local RotationStep = 45
local LerpLevel = 0.2
local Rotation = 0

local GridTexture = "rbxassetid://2415319308"

local Speed = 1

local Moved = false
local MoveByGrid = true
local Stackable = false
local Interpolation = true

local Plot
local Object
local PlacedObjects

local ItemCFrame
local PosY

local GRID_SIZE
local ITEM_LOCATION
local ROTATE_BTN
local TERMINATE_BTN

local Placement = {}
Placement.__index = Placement

function Placement.new(g:NumberValue, objs:StringValue, r, t)
	local self = setmetatable({},Placement)
	
	GRID_SIZE = g
	ITEM_LOCATION = objs
	ROTATE_BTN = r
	TERMINATE_BTN = t
	
	return self
end

local function RenderGrid()

	if Plot:FindFirstChildOfClass("Texure") then
		Plot:FindFirstChildOfClass("Texture"):Destroy()
	end

	local Texture = Instance.new("Texture")
	Texture.StudsPerTileU = GRID_SIZE
	Texture.StudsPerTileV = GRID_SIZE
	Texture.Texture = GridTexture
	Texture.Parent = Plot
	Texture.Face = Enum.NormalId.Top
end

-- The players taps on the position that the item is to be placed. A check variable is used so that the item does not move-
--  -when the player clicks the place/rotate/cancel button.
-- The placement system uses 1x1 grids. There will be no stacking for mobile placement.

local function Snap(x,z)
	local NewX = math.round(x/GRID_SIZE)*GRID_SIZE --math.round(x/GRID_SIZE)*GRID_SIZE
	local NewZ = math.round(z/GRID_SIZE)*GRID_SIZE
	print("Snapped Obj: ", NewX, NewZ)
	
	return CFrame.new(NewX,PosY,NewZ)
end

local function GetYPosition(ToPos, ToSize, ObjSize)
	return (ToPos + ToSize*0.5) + ObjSize*0.5
end

local function GetPosition()
	
	if Stackable and Mouse.Target and Mouse.Target:IsDescendantOf(Plot) then
		print("Stackable")
		PosY = GetYPosition(Mouse.Hit.Position.Y, Mouse.Target.Size.Y, Object.PrimaryPart.Size.Y)
	else
		PosY = GetYPosition(Mouse.Hit.Position.Y, Plot.Size.Y, Object.PrimaryPart.Size.Y)
	end
	return Snap(Mouse.Hit.X,Mouse.Hit.Z) 
end

function Placement:Activate(id:StringValue ,pobj:Instance,plt:Instance, stk:boolean)
	if Object then
		Object:Destroy()
		
	end
	
	Object = ITEM_LOCATION:FindFirstChild(id):Clone()
	PlacedObjects = pobj
	Plot = plt
	Stackable = stk
	
	if not Stackable then
		Mouse.TargetFilter = PlacedObjects
	else
		Mouse.TargetFilter = Object
	end
	
	
	local PreSpeed = 1

	if Interpolation then
		PreSpeed = math.clamp(math.abs(tonumber(1 - LerpLevel)), 0, 0.9)
		Speed = 1
	end
	
	Object.Parent = PlacedObjects
	
	task	.wait()
	
	RenderGrid()
	
	print(GRID_SIZE, Plot,Object,PlacedObjects)
	
	Speed = PreSpeed
	
	UserInputService.TouchTapInWorld:Connect(function(touchPositions: {any}, gameProcessedEvent: boolean) 
		if not gameProcessedEvent then
			Object:PivotTo(GetPosition()) --Mouse.Hit.Position.X, Plot.Position.Y, Mouse.Hit.Position.Z
		end	
	end)
end







return Placement
