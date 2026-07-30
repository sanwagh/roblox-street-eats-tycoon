--[[
    BuyGamepass (Script)
    Path: ReplicatedStorage → Client → UI → Monetization
    Parent: Monetization
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local GamepassFrame = Player:WaitForChild("PlayerGui"):WaitForChild("StoreUI").Main.DisplayFrame.Gamepasses

local DoubleCash = 681725785
local DoubleXp = 682114170
local ReducedWT = 681830692

local function PromptPurchase(product)
	if product == "DoubleCash" then
		MarketplaceService:PromptGamePassPurchase(Player,DoubleCash)
	elseif product == "DoubleXP" then
		MarketplaceService:PromptGamePassPurchase(Player,DoubleXp)
	elseif product == "ReducedWaitTime" then
		MarketplaceService:PromptGamePassPurchase(Player,ReducedWT)	
	end
end

for i,v in pairs(GamepassFrame:GetChildren()) do
	if v:IsA("Frame") then
		v.BuyBtn.MouseButton1Down:Connect(function()
			game.SoundService.SFX.Click:Play()
			PromptPurchase(v.Name)
		end)
	end
end