--[[
    LevelManager (ModuleScript)
    Path: ServerScriptService → DataStores
    Parent: DataStores
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local LevelManager = {}


function LevelManager.Update(Player:Player)
	local LevelFolder = Player.LevelStats
	local XP = LevelFolder.XP
	local Level = LevelFolder.Level
	local RequiredXP = LevelFolder.RequiredXP
	
	local LevelUpLogic = Level.Value*100 + (50*(Level.Value*2))
	
	RequiredXP.Value = LevelUpLogic
	if XP.Value >= RequiredXP.Value then
		print("LevelUp")
		Level.Value += 1
		XP.Value = 0
		RequiredXP.Value = Level.Value*100 + (50*(Level.Value*2))
	end
end

return LevelManager
