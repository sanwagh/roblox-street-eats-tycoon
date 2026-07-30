--[[
    CashAndBoost (Script)
    Path: ServerScriptService → Monetization
    Parent: Monetization
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local ProductFunctions = {}

-- Cash 1000
ProductFunctions[1721837836] = function(reciept, player)
	player.leaderstats.Cash.Value += 1000
	print("Updated Player Cash!")
end

-- Cash2000
ProductFunctions[1721837984] = function(reciept, player)
	player.leaderstats.Cash.Value += 2000
	print("Updated Player Cash!")
end

-- Cash 5000
ProductFunctions[1721838139] = function(reciept, player)
	player.leaderstats.Cash.Value += 5000
	print("Updated Player Cash!")
end

-- BOOSTS

-- CashBoost
ProductFunctions[1722739566] = function(reciept, player)
	player.MonetizationData.CashBoost.Value += 300 --5 mins
	
	
end

-- XP Boost
ProductFunctions[1722739723] = function(reciept, player)
	player.MonetizationData.XPBoost.Value += 300 --5 mins
end

local function ProcessReciept(ReceiptInfo)
	local UserId = ReceiptInfo.PlayerId
	local ProductId = ReceiptInfo.ProductId
	
	local Player = game.Players:GetPlayerByUserId(UserId)
	
	if Player then
		local Handler =  ProductFunctions[ProductId]
		
		local success, errormessage = pcall(Handler, ReceiptInfo, Player)
		
		if success then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to Process Receipt:", ReceiptInfo,errormessage)
		end
		
	end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

MarketplaceService.ProcessReceipt = ProcessReciept