--[[
    Script (Script)
    Path: ReplicatedStorage → Items → LemonadeStall
    Parent: LemonadeStall
    Properties:
        Disabled: true
    Exported: 2026-07-30 17:33:33 (web)
]]

local model = script.Parent
local hitbox = script.Parent.PrimaryPart

-- Set the rotation angle in degrees
local rotationAngle = 45


-- Apply the same rotation to the hitbox
while true  do
	wait()
	-- Convert the rotation angle to radians
	local rotationRadians = math.rad(rotationAngle)

	-- Create a new rotated CFrame
	local newCFrame = CFrame.new(model.PrimaryPart.Orientation + Vector3.new(0, rotationRadians, 0))

	-- Apply the new CFrame to the model's primary part
	model:PivotTo(newCFrame)
end
