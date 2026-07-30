--[[
    PlotSelection (ModuleScript)
    Path: ReplicatedStorage → Client → MainMenu
    Parent: MainMenu
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local PlotSelection = {}

local TweenService = game:GetService("TweenService")
local Info = TweenInfo.new(0.5,Enum.EasingStyle.Sine, Enum.EasingDirection.In,0,false,0)

local Player = game.Players.LocalPlayer
local PlotSelectionGui = Player:WaitForChild("PlayerGui"):WaitForChild("Main").PlotSelection

local CurrentPlot = 1
local TotalPlots = #game.Workspace.Plots:GetChildren()
local ChosenPlot = nil

local Debounce = false

local CurrentCamera = game.Workspace.CurrentCamera
CurrentCamera.CameraType = Enum.CameraType.Scriptable

function PlotSelection.ShowPlots()
	-- Shows CurrentPlot
	-- when the next/prev btn is clicked the func will be called +1/-1 to the current plot, ShowPlots will be called again
	-- Load clicked, Call load
	
	PlotSelectionGui:TweenPosition(
		UDim2.new(0.5,0,0.85,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quart,
		0.4,
		true
	)
	
	game.Lighting.Blur.Enabled = false
	
	for i,plots in pairs(game.Workspace.Plots:GetChildren()) do
		if plots:GetAttribute("PlotNum") == CurrentPlot then
			local Goal = {}
			Goal.CFrame = CFrame.new(plots.Plot.Position + Vector3.new(0,60,(plots.Plot.Size.Z*0.5)+50))
			
			local Tween = TweenService:Create(CurrentCamera,Info,Goal)
			
			Tween:Play()
			
			if plots.Owner.Value ~= "" then
				PlotSelectionGui.Load.Visible = false
				PlotSelectionGui.PlotDisplay.Text =  plots.Owner.Value.."'s Plot"
			else
				PlotSelectionGui.Load.Visible = true
				PlotSelectionGui.PlotDisplay.Text = "Empty Plot"
				
				ChosenPlot = plots
			end
			
			break
		end
	end
	-- Next Button
	
end

PlotSelectionGui.Next.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	if CurrentPlot == TotalPlots then
		CurrentPlot = 1
	else
		CurrentPlot += 1
	end

	PlotSelection.ShowPlots()
end)
-- Prevoius Button
PlotSelectionGui.Previous.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	if CurrentPlot == 1 then
		CurrentPlot = TotalPlots
	else
		CurrentPlot -= 1
	end

	PlotSelection.ShowPlots()
end)
-- Load Button
PlotSelectionGui.Load.MouseButton1Down:Connect(function()
	game.SoundService.SFX.Click:Play()
	PlotSelection.Load()

end)


function PlotSelection.Load()
	print("-> Requesting server to load data for ".. Player.Name.." on "..tostring(ChosenPlot))
	game.ReplicatedStorage.Events.LoadPlot:FireServer(ChosenPlot)

	PlotSelectionGui:TweenPosition(
		UDim2.new(0.5,0,1.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quart,
		0.4,
		true
	)
	
	CurrentCamera.CameraType = Enum.CameraType.Custom
	CurrentCamera.CameraSubject = Player.Character.Humanoid
	
	Player.PlayerGui.InfoGui.LevelUpFrame.Visible = true
	Player.PlayerGui.InfoGui.ButtonFrame.Visible = true

	
end

return PlotSelection
