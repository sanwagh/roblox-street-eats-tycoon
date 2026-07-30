--[[
    PlacementClient (ModuleScript)
    Path: ReplicatedStorage → Client
    Parent: Client
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

--Settings

--Bools
local Interpolation = true
local moveByGrid = true
local BuildModePlacement = true

local Device = nil

--Ints
local RotationStep = 45
local MaxHeight = 90

--Numbers
local LerpLevel = 0.7

--Other
local GridTexture = "rbxassetid://2415319308"


local Placement = {}
Placement.__index = Placement

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Mouse = Player:GetMouse()

-- Constructor Vars
local GRID_SIZE
local ITEM_LOCATION
local ROTATE_KEY
local TERMINATE_KEY

-- Activation Vars
local Object
local PlacedObjects
local Plot
local Stackable
local Primary


local PosX
local PosY
local PosZ
local Speed = 1
local Rotation = 0
local RotationVal = false
local Placing = false
local Destroyed = false


local Collided = nil


local cframe = CFrame.new
local Angles = CFrame.fromEulerAnglesXYZ
local Clamp = math.clamp

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

local function ChangeHitboxColor()
	if Primary then
		if Collided then
			Primary.Transparency = 0.7
			Primary.Color = Color3.fromRGB(206, 0, 0)
		else
			Primary.Transparency = 0.7
			Primary.Color = Color3.fromRGB(0, 255, 0)
		end
	end
end

local function HandleCollisions()
	if Object then
		Collided = false
		
		local CollisionPoint = Primary.Touched:Connect(function() end)
		local CollisionPoints = Primary:GetTouchingParts()
		
		for i = 1,#CollisionPoints,1 do
			if not CollisionPoints[i]:IsDescendantOf(Object) and not CollisionPoints[i]:IsDescendantOf(Character) then
				Collided = true
				break
			end
		end
		
		CollisionPoint:Disconnect()
		
		return
	end
end

local function Bounds(cf, offsetx, offsetz)
	local LOWER_X_BOUND
	local LOWER_Z_BOUND
	
	local UPPER_X_BOUND
	local UPPER_Z_BOUND
	
	LOWER_X_BOUND = Plot.Position.X - (0.5*Plot.Size.X) + offsetx
	UPPER_X_BOUND = Plot.Position.X + (0.5*Plot.Size.X) - offsetx
	
	LOWER_Z_BOUND = Plot.Position.Z - (0.5*Plot.Size.Z) + offsetz
	UPPER_Z_BOUND = Plot.Position.Z + (0.5*Plot.Size.Z) - offsetz
	
	local NewX = Clamp(cf.X,LOWER_X_BOUND,UPPER_X_BOUND)
	local NewZ = Clamp(cf.Z,LOWER_Z_BOUND,UPPER_Z_BOUND)
	
	return cframe(NewX,PosY,NewZ)	
end

-- calc the initial Y pos above an obj | ToP: To Pos, ToS -  To Size, oS: Object size
local function CalculateYPosition(ToP, ToS, oS)
	return (ToP + ToS*0.5) + oS*0.5
end

local function Rotate(ActionName, InputState, InputObj) 
	if InputState == Enum.UserInputState.Begin then
		Rotation += RotationStep
		RotationVal = not RotationVal
	end
end


local function Cancel(ActionName, InputState, InputObj)
	if Destroyed then return end
	if InputState == Enum.UserInputState.Begin then
		Object:Destroy()
		Plot:FindFirstChild("Texture"):Destroy()
		Mouse.TargetFilter = nil
		
		Placing = false
		Destroyed = true
		Player.PlayerGui.Main.BuildMenu.Visible = true
		Player.PlayerGui.InfoGui.BuildKeybinds.Visible = false
	end
end

local function Snap(c)
	local NewX = math.round(c.X/GRID_SIZE)*GRID_SIZE
	local NewZ = math.round(c.Z/GRID_SIZE)*GRID_SIZE
	
	return cframe(NewX,0,NewZ)
end

local function CalculateItemPosition() --BUG: ITEM GETS PLACED ON THE POSITION THAT THE BUTTON WAS CLICKED
	local FinalCFrame = cframe(0,0,0)
	local x,z
	local OffsetX, OffsetZ
	
	if RotationVal then
		OffsetX,OffsetZ = Primary.Size.X*0.5, Primary.Size.Z*0.5
		x,z = Mouse.Hit.X - OffsetX, Mouse.Hit.Z - OffsetZ
	else
		OffsetX,OffsetZ = Primary.Size.Z*0.5, Primary.Size.X*0.5
		x,z = Mouse.Hit.X - OffsetX, Mouse.Hit.Z - OffsetZ
	end
	
	if Stackable and Mouse.Target and Mouse.Target:IsDescendantOf(Plot) then
		PosY = (CalculateYPosition(Mouse.Target.Position.Y,Mouse.Target.Size.Y,Primary.Size.Y)) -- TEST: No need to snap on the Y. 
	else
		PosY = (CalculateYPosition(Plot.Position.Y,Plot.Size.Y,Primary.Size.Y)) -- TEST: No need to snap on the Y. 
	end
	
	if moveByGrid then
		local PltCFrame = cframe(Plot.CFrame.X, Plot.CFrame.Y, Plot.CFrame.Z)
		local Pos = cframe(x,0,z)
		Pos = Snap(Pos*PltCFrame:Inverse())
		FinalCFrame = Pos*PltCFrame*cframe(OffsetX,0,OffsetZ)
	else
		FinalCFrame = cframe(Mouse.Hit.X, PosY,Mouse.Hit.Z)
	end
	
	FinalCFrame = Bounds(cframe(FinalCFrame.X,PosY, FinalCFrame.Z), OffsetX,OffsetZ)
	
	return FinalCFrame*Angles(0, math.rad(Rotation),0)
end

local function BindInputs()
	if Device == "Mobile" then
				
		ContextActionService:BindAction("Rotate",Rotate, true, ROTATE_KEY)
		ContextActionService:GetButton("Rotate").Position = UDim2.new(0.7,0,0.8,0)
		
		ContextActionService:GetButton("Rotate").Parent.AnchorPoint = Vector2.new(0.5,0.5)
		ContextActionService:GetButton("Rotate").Parent.Size = UDim2.new(1,0,1,0)
		ContextActionService:GetButton("Rotate").Parent.Position = UDim2.new(0.5,0,0.5,0)
	
		ContextActionService:BindAction("Cancel",Cancel, true, TERMINATE_KEY)
		ContextActionService:GetButton("Cancel").Position = UDim2.new(0.2,0,0.8,0)
		
	else
		ContextActionService:BindAction("Rotate",Rotate, true, ROTATE_KEY)
		ContextActionService:BindAction("Cancel",Cancel, false, TERMINATE_KEY)
	end
end

local function UnbindInputs()
	ContextActionService:UnbindAction("Rotate")
	ContextActionService:UnbindAction("Cancel")
end

--Sets the models position based on pivot
local function TranslateObj()
	if Object.Parent == PlacedObjects and PlacedObjects then
		
		HandleCollisions()
		ChangeHitboxColor()
		
		if Device == "Mobile" then
			Object:PivotTo(CalculateItemPosition())
		else
			Object:PivotTo(Object.PrimaryPart.CFrame:Lerp(CalculateItemPosition(), Speed))
		end
	end
end

local function GetInstantCFrame()
	if Device == "Mobile" then
		return Object.PrimaryPart.CFrame
	else
		return CalculateItemPosition()
	end
end

function Placement:Place(remote)
	if not Placing then print("Not Placing?") return end
	
	if not Collided and Object then
		local cf = GetInstantCFrame()
		
		Destroyed = false
		
		game.SoundService.SFX.PlaceSound:Play()
		
		remote:InvokeServer(Object.Name, PlacedObjects, cf, Plot)
	end
end

-- Constructor function

function Placement.new(g,objs,r,t) -- g - grid size, objs - object locations, r - rotate key, t - terminate key
	local data = {}
	local MetaData = setmetatable(data,Placement)
	GRID_SIZE = g
	ITEM_LOCATION = objs
	ROTATE_KEY = r
	TERMINATE_KEY = t
	
	data.Grid = GRID_SIZE
	data.ItemLocation = ITEM_LOCATION
	data.RotateKey = ROTATE_KEY or Enum.KeyCode.R
	data.TerminateKey = TERMINATE_KEY or Enum.KeyCode.X
	
	return data
end

-- checks iff model snaps evenly on the plot
local function VerifyPlane()
	return Plot.Size.X%GRID_SIZE == 0 and Plot.Size.Z%GRID_SIZE == 0
end

-- Confirms that the settins are valid of placement
local function ApprovePlacement()
	if not VerifyPlane() then
		warn("[PlacementClient]: ERROR -  The model cannot snap on the plot. (Report this bug)")
		
		return false
	end
	
	if GRID_SIZE > math.min(Plot.Size.X, Plot.Size.Z) then
		error("[PlacementClient]: MAJOR ERROR - GRID SIZE IS LARGER THAN THE PLOT.(Report this bug)")
		
		return false
	end
	return true
end

-- id:Name, pobj - placed_obj, plt: plot, stk: Stackable
function Placement:Activate(id, pobj, plt, stk)
	if Object then
		Object:Destroy()
	end
	
	if Placing then return end
	
	Object = ITEM_LOCATION:FindFirstChild(id):Clone()
	Primary = Object.PrimaryPart
	PlacedObjects = pobj
	Plot = plt
	Stackable = stk
	Rotation = 0
	RotationVal = true
	Placing = true
	Destroyed = false
	
	for i,v in pairs(Object:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
	
	if not ApprovePlacement() then return "[PlacementClient]: ERROR - Placement Could not be activated" end
	
	-- Filters out the obj from mouse depending on stackable var
	if not Stackable then
		Mouse.TargetFilter = PlacedObjects
	else
		Mouse.TargetFilter = Object
	end
	
	--Sets up interpolations speed
	local PreSpeed = 1
	
	if Interpolation then
		PreSpeed = math.clamp(math.abs(tonumber(1 - LerpLevel)), 0, 0.9)
		Speed = 1
	end
	
	RenderGrid()
	
	Object.Parent = PlacedObjects
	task.wait()
	
	BindInputs()
	Speed = PreSpeed
	
end

if UserInputService.TouchEnabled then
	Device = "Mobile"
else
	Device = "PC"
end

if Device == "Mobile" then
	print(Device)
	UserInputService.TouchTapInWorld:Connect(function(touchPositions: {any}, gameProcessedEvent: boolean) 
		if not gameProcessedEvent then
			TranslateObj()
		end	
	end)
else
	print(Device)
	RunService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, TranslateObj)

end

return Placement
