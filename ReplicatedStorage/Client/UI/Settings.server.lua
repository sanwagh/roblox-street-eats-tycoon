--[[
    Settings (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local SettingsFrame = PlayerGui:WaitForChild("Main").Settings
local SettingsBtn = PlayerGui.InfoGui.ButtonFrame.SettingsBtn

local Debounce = false


local function GetStatus()
	print("STATUSS")
	local Plot
	
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		print(v)
		if v.Owner.Value == Player.Name then
			Plot = v
			break
		end
	end	

	if Plot.Open.Value then
		print("true")
		SettingsFrame.Main.TycoonStatus.CurrentStatus.TextColor = BrickColor.new(0.333333, 0.666667, 0)
		SettingsFrame.Main.TycoonStatus.CurrentStatus.Text =  "Status: Open"
	else
		print("false")
		SettingsFrame.Main.TycoonStatus.CurrentStatus.TextColor = BrickColor.new(1, 0, 0)
		SettingsFrame.Main.TycoonStatus.CurrentStatus.Text =  "Status: Closed"
	end
end

SettingsBtn.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	SettingsFrame.Visible = true
	GetStatus()
end)

SettingsFrame.Close.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	SettingsFrame.Visible = false
end)

for i,v in pairs(SettingsFrame.Main.TycoonStatus:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Down:Connect(function()
			if not Debounce then
				Debounce = true
				
				game.SoundService.SFX.Click:Play()
				game.ReplicatedStorage.Events.TycoonStatus:FireServer(v.Name)
				print("-> Requesting Server to ", v.Name," the tycoon...")
				wait(0.2)
				GetStatus()
				Debounce = false
			end	
		end)
	end
end