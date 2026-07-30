--[[
    BugReportServer (Script)
    Path: ServerScriptService
    Parent: ServerScriptService
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local RobaseModule = require(script.Parent.RobaseService)
local DatabaseKeyStore = game:GetService("DataStoreService"):GetDataStore("DatabaseKey")

local URL = DatabaseKeyStore:GetAsync("URL")
local AUTH = DatabaseKeyStore:GetAsync("AUTH")

local RobaseService = RobaseModule.new(URL, AUTH)

game.ReplicatedStorage.Events.BugReport.OnServerEvent:Connect(function(Player, BugType, BugDesc, Log)
	local BugBase = RobaseService:GetRobase(tostring(Player.UserId.. " "..os.date()))
	local Data = {
		Player.Name, os.date() , BugType,BugDesc, Log
	}

	local success, errormessage = BugBase:SetAsync("Bug",Data)
	if success then
		print("-> Pushed Data to server")
	end
end)



--local DataStore = game:GetService("DataStoreService"):GetDataStore("DatabaseKey")
--DataStore:SetAsync("URL", "https://street-eats-tycoon-7d331-default-rtdb.asia-southeast1.firebasedatabase.app/")
--DataStore:SetAsync("AUTH", "oMq67NgNdGkz8bEgXyW7wmONYqo11YSiedQpbjDw")