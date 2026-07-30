--[[
    ServerDeletion (Script)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

game.ReplicatedStorage:WaitForChild("Events").Delete.OnServerEvent:Connect(function(Player, Stall)
	if Stall.Parent.Parent.Owner.Value == Player.Name then
		print("-> Received a request to delete ", Stall.name, "for ", Player.Name)
		Player.leaderstats.Cash.Value += Stall.Cost.Value
		Stall:Destroy()
	else
		warn("Not You Plot!")
	end
end)