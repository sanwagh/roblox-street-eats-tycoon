--[[
    StoreUI (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer

local StoreFrame = Player:WaitForChild("PlayerGui"):WaitForChild("StoreUI").Main
local CashBtn = Player.PlayerGui.InfoGui.ButtonFrame.CashFrame.BuyCash
local StoreBtn = Player.PlayerGui.InfoGui.ButtonFrame.StoreBtn

CashBtn.MouseButton1Up:Connect(function()
	game.SoundService.SFX.Click:Play()
	
	StoreFrame:TweenPosition(
		UDim2.new(0.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.8,
		true
	)
end)

StoreBtn.MouseButton1Up:Connect(function()
	game.SoundService.SFX.Click:Play()

	StoreFrame:TweenPosition(
		UDim2.new(0.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.8,
		true
	)
end)

StoreFrame.Close.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()

	StoreFrame:TweenPosition(
		UDim2.new(1.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.8,
		true
	)
end)

for i,v in pairs(StoreFrame.ButtonFrame:GetChildren()) do
	if v:IsA("TextButton") then
		game.SoundService.SFX.Click:Play()
		v.MouseButton1Down:Connect(function()
			for _,x in pairs(StoreFrame.DisplayFrame:GetChildren()) do
				if x:IsA("ScrollingFrame") then
					x.Visible = false
				end
			end
			print(v.Name)
			StoreFrame.DisplayFrame[v.Name].Visible = true
		end)
	end
end