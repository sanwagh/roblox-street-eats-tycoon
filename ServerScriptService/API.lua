--[[
    API (ModuleScript)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local API = {}

function API.GetPlayerPlot(Player)
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == Player.Name then
			return v
		end
	end
end

return API
