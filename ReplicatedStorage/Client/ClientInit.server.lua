--[[
    ClientInit (Script)
    Path: ReplicatedStorage → Client
    Parent: Client
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local MainMenuModule = require(script.Parent.MainMenu)
local Player = game.Players.LocalPlayer
wait(0.5)
local Camera = game.Workspace.CurrentCamera

local StallSettingsClient = require(script.Parent.StallSettingsClient)

Camera.CameraType = Enum.CameraType.Scriptable

Camera.CFrame = game.Workspace:WaitForChild("CameraPart").CFrame
print("-> Set Camera: true")

print("-> Loading Menu...")
MainMenuModule.SetupMenu()

-- STALL UI
StallSettingsClient.CheckForClick()
print("Checking for click")
Player:WaitForChild("PlayerGui").InfoGui.ButtonFrame.StallBtn.MouseButton1Down:Connect(function()
	StallSettingsClient.CheckForClick()
end)

Player.PlayerGui.StallUI.Menu.ButtonFrame.Price.MouseButton1Up:Connect(function()
	StallSettingsClient.UpdatePrice()
	StallSettingsClient.ShowPrice()
end)

Player.PlayerGui.StallUI.Menu.ButtonFrame.Reviews.MouseButton1Up:Connect(function()
	StallSettingsClient.ShowReview()
end)

Player.PlayerGui.StallUI.Menu.ButtonFrame.Stats.MouseButton1Up:Connect(function()
	StallSettingsClient.ShowStats()
end)

Player.PlayerGui.StallUI.Menu.ButtonFrame.Stock.MouseButton1Up:Connect(function()
	StallSettingsClient.ShowStock()
end)

Player.PlayerGui.StallUI.Menu.ButtonFrame.Close.MouseButton1Up:Connect(function()
	StallSettingsClient.Close()
end)

