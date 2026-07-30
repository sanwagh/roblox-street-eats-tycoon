--[[
    BuyCash (Script)
    Path: ReplicatedStorage → Client → UI → Monetization
    Parent: Monetization
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local CashFrame = Player:WaitForChild("PlayerGui"):WaitForChild("StoreUI").Main.DisplayFrame.Cash

local Cash1000 = 1721837836
local Cash2000 = 1721837984
local Cash5000 = 1721838139

local function SetProductInfo(product)
	return
end

local function PromptPurchase(product)
	if product == "Cash1000" then
		MarketplaceService:PromptProductPurchase(Player, Cash1000)
	elseif product == "Cash2000" then
		MarketplaceService:PromptProductPurchase(Player, Cash2000)
	elseif product == "Cash5000" then
		MarketplaceService:PromptProductPurchase(Player, Cash5000)
	end
end

for i,v in pairs(CashFrame:GetChildren()) do
	if v:IsA("Frame") then
		v.BuyBtn.MouseButton1Down:Connect(function()
			game.SoundService.SFX.Click:Play()
			SetProductInfo(v.Name)
			PromptPurchase(v.Name)
		end)
	end
end