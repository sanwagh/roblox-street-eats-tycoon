--[[
    BugReportUI (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local LogService = game:GetService("LogService")

local BugReportFrame = PlayerGui:WaitForChild("Main").BugReportFrame
local BugReportBtn = PlayerGui.Main.BugReportBtn

local BugType = nil
local BugDesc = nil
local Output = nil

local Debounce = false

BugReportBtn.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	
	BugReportFrame:TweenPosition(
		UDim2.new(0.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quad,
		0.8,
		true
	)
end)

BugReportFrame.Main.Close.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()

	BugReportFrame:TweenPosition(
		UDim2.new(1.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quad,
		0.8,
		true
	)
end)

for i,v in pairs(BugReportFrame.Main.TypeFrame:GetChildren()) do
	if v:IsA("TextButton") then
		v.BackgroundTransparency = 0
		v.MouseButton1Down:Connect(function()
			game.SoundService.SFX.Click:Play()
			v.BackgroundTransparency = 0.5
			BugType = v.Name
		end)
	end
end

BugReportFrame.Main.Description:GetPropertyChangedSignal("Text"):Connect(function()
	BugDesc = BugReportFrame.Main.Description.Text
end)

BugReportFrame.Main.Submit.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	
	if BugType == nil then
		BugReportFrame.Main.Status.TextColor = BrickColor.new(1, 0, 0)
		BugReportFrame.Main.Status.Text = "Please Select a bug type!"
		BugReportFrame.Main.Status.Visible = true
		wait(2)
		BugReportFrame.Main.Status.Visible = false
		
	elseif BugDesc == nil then
		BugReportFrame.Main.Status.TextColor = BrickColor.new(1, 0, 0)
		BugReportFrame.Main.Status.Text = "Please describe the bug!"
		BugReportFrame.Main.Status.Visible = true
		wait(2)
		BugReportFrame.Main.Status.Visible = false
	end
	
	if BugDesc ~= nil and BugType ~= nil then
		if not Debounce then 
			Debounce = true
			
			Output = LogService:GetLogHistory()
			
			game.ReplicatedStorage.Events.BugReport:FireServer(BugType, BugDesc, Output)
			
			BugReportFrame.Main.Status.TextColor = BrickColor.new(0, 0.666667, 0)
			BugReportFrame.Main.Status.Text = "Sent!"
			BugReportFrame.Main.Status.Visible = true
			wait(2)
			BugReportFrame.Main.Status.Visible = false
			
			BugDesc = nil
			BugType = nil
			
			BugReportFrame.Main.Description.Text = ""
						
			wait(0.50)
			Debounce = false
		end
	end
end)

