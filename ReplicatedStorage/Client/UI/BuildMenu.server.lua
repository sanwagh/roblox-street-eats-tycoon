--[[
    BuildMenu (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

-- Move the Module Code over here
local Player = game.Players.LocalPlayer
local BuildMenu = Player:WaitForChild("PlayerGui"):WaitForChild("Main").BuildMenu

local UIS = game:GetService("UserInputService")

local SelectedFrame = nil
local ItemName = nil
local PlayerPlot = nil

local Debounce = false

local function GetPlot()
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == Player.Name then
			return v
		end
	end
end

task.spawn(function()
	-- Level lock items
	while true do
		wait()
		for i,v in pairs(BuildMenu.Main.CategoryFrame:GetDescendants()) do
			if v:IsA("Frame") then
				local Item = game.ReplicatedStorage.Items:FindFirstChild(v.Name)
				
				if not Item then break end
				if Player:WaitForChild("LevelStats").Level.Value < Item.Level.Value then
					v.LevelLockedLabel.Visible = true
					v.LevelLockedLabel.Text = "Level "..Item.Level.Value 
				else
					v.LevelLockedLabel.Visible = false
				end
			end
		end
	end
end)

for i,v in pairs(BuildMenu.Main.CategoryFrame:GetDescendants()) do
	if v:IsA("Frame") then
		local Item = game.ReplicatedStorage.Items:FindFirstChild(v.Name)
		if not Item then break end
		v.CostLabel.Text = "$"..Item.Cost.Value
	end
end


Player.PlayerGui.InfoGui.ButtonFrame.BuildBtn.MouseButton1Up:Connect(function()
	game.SoundService.SFX.Click:Play()
	local PlayerPlot = GetPlot()
	BuildMenu:TweenPosition(
		UDim2.new(0.912,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.5,
		true
	)
	-- Set this to a variable. The Frame Name
	for i,btn in pairs(BuildMenu.Main.ButtonFrame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.MouseButton1Down:Connect(function()
				game.SoundService.SFX.Click:Play()
				btn.Parent.Visible = false
				for _,v in pairs(BuildMenu.Main.CategoryFrame:GetChildren()) do
					if v:IsA("ScrollingFrame") or v:IsA("Frame") then
						v.Visible = false
					end
				end
				BuildMenu.Main.CategoryFrame[btn.Name].Visible = true
				BuildMenu.Main.BackBtn.Visible = true
				BuildMenu.Main.CancelBtn.Visible = false

				SelectedFrame = BuildMenu.Main.CategoryFrame[btn.Name]

				--while SelectedFrame == nil do
				--	wait()
				--end

				for i, btn in pairs(SelectedFrame:GetChildren()) do
					if btn:IsA("Frame") then
						-- CHECK FOR LEVEL REQUIREMENT!!!
						btn.Button.MouseButton1Down:Connect(function()
							if PlayerPlot.Open.Value == true then
								Player.PlayerGui.InfoGui.WarningLabel.Visible = true
								Player.PlayerGui.InfoGui.WarningLabel.Text = "Please Close the tycoon from the settings before editing!"
								wait(2)
								Player.PlayerGui.InfoGui.WarningLabel.Visible = false
								return 
							end
							if not Debounce then
								Debounce = true
								
								Player.PlayerGui.InfoGui.BuildKeybinds.Visible = true
								
								local Level = game.ReplicatedStorage.Items:FindFirstChild(btn.Name).Level
								if Player.LevelStats.Level.Value >= Level.Value then

									game.SoundService.SFX.Click:Play()
									ItemName = btn.Name
									game.SoundService.SFX.Click:Play()

									local PlayerPlot = GetPlot()

									if game.ReplicatedStorage.Items:FindFirstChild(ItemName) then 

										local PlacementModule = require(game.ReplicatedStorage.Client.PlacementClient)
										local Placement = PlacementModule.new(4, game.ReplicatedStorage.Items, Enum.KeyCode.R, Enum.KeyCode.X)

										warn(ItemName.." ITEM!", PlayerPlot)
										Placement:Activate(ItemName,PlayerPlot.Items ,PlayerPlot.Plot, true) 

										BuildMenu.Visible = false

										local Mouse = Player:GetMouse()

										UIS.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) 
											if not gameProcessedEvent then
												if input.KeyCode == Enum.KeyCode.E then
													Placement:Place(game.ReplicatedStorage.Events.Place)
												end
											end	
										end)

										UIS.TouchTapInWorld:Connect(function(touchPositions: {any}, gameProcessedEvent: boolean) 
											if gameProcessedEvent then
												Player.PlayerGui.InfoGui.BuildKeybinds.Place.TouchTap:Connect(function() 
													Placement:Place(game.ReplicatedStorage.Events.Place)
												end)
											end	
										end)


										--Mouse.Button1Up:Connect(function()
										--	Placement:Place(game.ReplicatedStorage.Events.Place)
										--end)		
									end
								else
									warn("Higher Level Needed!")
								end
								wait(0.5)
								Debounce = false
							end
						end)
					end
				end
			end)
		end
	end
end)

BuildMenu:WaitForChild("Main").CancelBtn.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()

	BuildMenu:TweenPosition(
		UDim2.new(1.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.9,
		true
	)
	return
end)

BuildMenu.Main.BackBtn.MouseButton1Down:Connect(function()
	BuildMenu.Main.CancelBtn.Visible = true
	BuildMenu.Main.ButtonFrame.Visible = true
	BuildMenu.Main.BackBtn.Visible = false

	game.SoundService.SFX.Click:Play()

	for i,v in pairs(BuildMenu.Main.CategoryFrame:GetChildren()) do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
end)





-- Loop the frame
