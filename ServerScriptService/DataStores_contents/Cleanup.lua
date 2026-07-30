--[[
    Cleanup (ModuleScript)
    Path: ServerScriptService → DataStores
    Parent: DataStores
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Cleanup = {}

function Cleanup.CleanCache(Player, Plot)
	Plot.Items:ClearAllChildren()
	for i,v in pairs(game.Workspace.NPCFolder:GetChildren()) do
		if v:GetAttribute("Player") == Player.Name then
			v:Destroy()
		end
	end
	print("-> Cleanup Successsful for ", Player)
end

return Cleanup
