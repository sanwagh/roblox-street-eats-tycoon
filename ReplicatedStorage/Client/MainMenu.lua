--[[
    MainMenu (ModuleScript)
    Path: ReplicatedStorage → Client
    Parent: Client
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local MainMenu = {}

local PlotSelectionModule = require(script.PlotSelection)

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Intro = PlayerGui.Main.IntroFrame

function MainMenu.SetupMenu()
	game.Lighting.Blur.Enabled = true
	Intro.Visible = true
	
	Intro.Play.MouseButton1Down:Connect(function()
		MainMenu.PlayClicked()
		print("-> Showing PlotMenu ")
	end)
end

function MainMenu.PlayClicked()
	game.SoundService.SFX.Click:Play()
	Intro:TweenPosition(
		UDim2.new(0.5,0,1.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quart,
		0.4,
		true
	)
	PlotSelectionModule.ShowPlots()
end


return MainMenu
