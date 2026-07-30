--[[
    DisplayUpdate (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local LevelUpFrame = Player:WaitForChild("PlayerGui"):WaitForChild("InfoGui").LevelUpFrame
local CashFrame = Player:WaitForChild("PlayerGui").InfoGui.ButtonFrame.CashFrame

local PlayerPlot

local function GetPlayerPlot()
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == Player.Name then
			PlayerPlot = v
			return true
		end
	end
	--return false
end


while not GetPlayerPlot() do
	wait()
end

print("GotPlot!")

local function UpdateStats(Stat)
	if Stat == "Cash" then
		CashFrame.CashDisplay.Text = "$"..Player:WaitForChild("leaderstats").Cash.Value
	elseif Stat == "Level" then
		LevelUpFrame.LevelNumber.LevelText.Text = Player.LevelStats.Level.Value
		print(Player.LevelStats.Level.Value)
		local CurrentXP = Player.LevelStats.XP
		local RequiredXP = Player.LevelStats.RequiredXP
		
		local Pos = LevelUpFrame.LevelBar.Position
		LevelUpFrame.LevelBar.Size = UDim2.new(CurrentXP.Value/RequiredXP.Value,0,LevelUpFrame.LevelBar.Size.Y.Scale,1)
		LevelUpFrame.LevelBar.Position = Pos
	end
end


wait(1)

UpdateStats("Cash")
UpdateStats("Level")


Player.leaderstats.Cash:GetPropertyChangedSignal("Value"):Connect(function()
	UpdateStats("Cash")
end)

Player.LevelStats.XP:GetPropertyChangedSignal("Value"):Connect(function()
	UpdateStats("Level")

end)