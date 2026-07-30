--[[
    Boosts (Script)
    Path: ServerScriptService → Monetization
    Parent: Monetization
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

game.Players.PlayerAdded:Connect(function(player)
	player:WaitForChild("MonetizationData").CashBoost:GetPropertyChangedSignal("Value"):Connect(function()
		if player.MonetizationData.CashBoost.Value > 0 then
			--for i = player.MonetizationData.CashBoost.Value,1,-1 do -- FIX THE COUNTDoWN OVERLAP
			--	player.MonetizationData.CashBoost.Value = i
			--	wait(1)
			--end
			wait(1)
			player.MonetizationData.CashBoost.Value -= 1
		end
	end)
end)
