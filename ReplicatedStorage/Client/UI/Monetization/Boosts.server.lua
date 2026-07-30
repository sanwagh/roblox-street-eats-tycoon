--[[
    Boosts (Script)
    Path: ReplicatedStorage → Client → UI → Monetization
    Parent: Monetization
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local BoostFrame = Player:WaitForChild("PlayerGui"):WaitForChild("StoreUI").Main.DisplayFrame.Boosts

local CashBoost = 1722739566
local XPBoost = 1722739723

local function SetProductInfo(product)
	return
end

local function PromptPurchase(product)
	if product == "CashBoost" then
		MarketplaceService:PromptProductPurchase(Player,CashBoost)
	elseif product == "XPBoost" then
		MarketplaceService:PromptProductPurchase(Player,XPBoost)
	end
end

for i,v in pairs(BoostFrame:GetChildren()) do
	if v:IsA("Frame") then
		v.BuyBtn.MouseButton1Down:Connect(function()
			game.SoundService.SFX.Click:Play()
			SetProductInfo(v.Name)
			PromptPurchase(v.Name)
		end)
	end
end