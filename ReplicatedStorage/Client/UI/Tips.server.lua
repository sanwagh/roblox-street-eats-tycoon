--[[
    Tips (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local PlayerPlot

local TipsData = require(script.TipsData)

local Data = {
	["OrderStand"] = false;
	["Stand"] = false;
	["Table"] = false;
}

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

-- Initial Check
for i,v in pairs(Data) do
	if not v then
		TipsData[i](PlayerPlot)
	end
end



-- Initially tells the player what to do and stuff in form of tips