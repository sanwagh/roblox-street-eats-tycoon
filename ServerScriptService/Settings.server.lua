--[[
    Settings (Script)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local CollectionService = game:GetService("CollectionService")

game.ReplicatedStorage:WaitForChild("Events").TycoonStatus.OnServerEvent:Connect(function(Player, Status)
	local Api = require(script.Parent.API)
	
	local Plot = Api.GetPlayerPlot(Player)
	
	if Status == "Open" then
		Plot.Open.Value = true
		print("OPEN")
	elseif Status == "Close" then
		Plot.Open.Value = false
		for i,v in pairs(game.Workspace.NPCFolder:GetChildren()) do
			if v:GetAttribute("Player") == Player.Name then
				v:Destroy()
			end
		end
		
		for i,v in pairs(Plot.Items:GetChildren()) do
			if CollectionService:HasTag(v, "Stall") then
				v.Orders:ClearAllChildren()
				print(v.Orders:GetChildren())
			end
		end
		print("-> Closed Tycoon for ", Player.Name)
	end
end)