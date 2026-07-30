--[[
    TypeFrame (ModuleScript)
    Path: ReplicatedStorage → Client
    Parent: Client
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local StallSettings = {}

-- RECALL THE SCRIPT AT ALL TIMES

local CollectionService = game:GetService("CollectionService")

local Player = game.Players.LocalPlayer
local StallMenu = Player:WaitForChild("PlayerGui").StallUI.Menu

local RestockClientModule = require(script.Parent.RestockClient)

local Stall = nil

local Debounce = false
local Enabled = true
local DeadTime = false

function StallSettings.CheckForClick()
	task.spawn(function()

		game.SoundService.SFX.Click:Play()

		StallMenu.Parent.SelectFrame.Visible = true
		Enabled = true
		if Enabled then
			local Mouse = Player:GetMouse()
			local Target = nil

			Mouse.Move:Connect(function()
				if not Enabled then return end

				Target = Mouse.Target

				if not CollectionService:HasTag(Target.Parent, "Stall") then return end

				if Target.Name == "Hitbox" then
					Mouse.Button1Up:Connect(function()
						if not Enabled then return end

						if CollectionService:HasTag(Target.Parent, "Stall") then
							if not DeadTime then
								DeadTime = true
								Stall = Target.Parent
								if not Enabled then return end

								StallSettings.Open()
								Enabled = false

								wait(0.5)
								DeadTime = false
							end
						end
					end)
				end
			end)
		end
	end)
	return
end

function StallSettings.Open()
	game.SoundService.SFX.Click:Play()
	StallSettings.UpdatePrice()
	StallMenu:TweenPosition(
		UDim2.new(0.5,0,0.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.8,
		true
	)
end

function StallSettings.Close()
	game.SoundService.SFX.Click:Play()

	StallMenu:TweenPosition(
		UDim2.new(0.5,0,1.5,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quad,
		0.8,
		true
	)
end

function StallSettings.UpdatePrice()
	StallMenu.Main.PriceFrame.PriceBox:GetPropertyChangedSignal("Text"):Connect(function()
		StallMenu.Main.PriceFrame.NewPriceLabel.Text = "Price: $"..tostring(StallMenu.Main.PriceFrame.PriceBox.Text)
		local Price = tonumber(StallMenu.Main.PriceFrame.PriceBox.Text)

		StallMenu.Main.PriceFrame.ConfirmBtn.MouseButton1Down:Connect(function()
			if not Debounce then
				Debounce = true
				game.ReplicatedStorage.Events.Stall:FireServer("Price", Price, Stall)
				wait(0.2)
				Debounce = false
			end
		end)
	end)
end

function StallSettings.ShowPrice()
	game.SoundService.SFX.Click:Play()
	for i,v in pairs(StallMenu.Main:GetChildren()) do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
	StallMenu.Main.PriceFrame.Visible = true
end

function StallSettings.ShowReview()
	game.SoundService.SFX.Click:Play()
	for i,v in pairs(StallMenu.Main:GetChildren()) do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
	StallMenu.Main.ReviewFrame.Visible = true
end

function StallSettings.ShowStats()
	game.SoundService.SFX.Click:Play()
	for i,v in pairs(StallMenu.Main:GetChildren()) do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
	StallMenu.Main.StatsFrame.Visible = true
end

function StallSettings.ShowStock()
	game.SoundService.SFX.Click:Play()
	for i,v in pairs(StallMenu.Main:GetChildren()) do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
	
	print("Out of for loop")
	StallMenu.Main.StockFrame.Visible = true
	StallMenu.Main.StockFrame.CostPerItem.Text = "Cost Per Item: $"..(Stall.ItemsCost:GetChildren()[1].Value)*0.6 --60%

	StallMenu.Main.StockFrame.CurrentStockLabel.Text = Stall:GetAttribute("Storage")
	Stall:GetAttributeChangedSignal("Storage"):Connect(function()
		StallMenu.Main.StockFrame.CurrentStockLabel.Text = Stall:GetAttribute("Storage")
	end)
	
	local Debounce = false
	
	for i,v in pairs(StallMenu.Main.StockFrame.RestockBtnFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Up:Connect(function()
				if not Debounce then
					Debounce = true
					game.SoundService.SFX.Click:Play()
					
					local Amt = v.Amt.Value
					
					game.ReplicatedStorage.Events.Stall:FireServer("Restock", Amt, Stall)
					
					if Player.leaderstats.Cash.Value - tonumber((Stall.ItemsCost:GetChildren()[1].Value)*0.6*Amt) >= 0 then
						print("-> Restock Success ", Player.leaderstats.Cash.Value - tonumber((Stall.ItemsCost:GetChildren()[1].Value)*0.6*Amt))
						game.SoundService.SFX.Restock:Play()
						StallMenu.Main.StockFrame.TopupLabel.Text = "+"..Amt
						StallMenu.Main.StockFrame.MoneyDeductedLabel.Text = "- $"..tonumber((Stall.ItemsCost:GetChildren()[1].Value)*0.6*Amt)
						StallMenu.Main.StockFrame.TopupLabel.Visible = true
						StallMenu.Main.StockFrame.MoneyDeductedLabel.Visible = true
						wait(1)
						StallMenu.Main.StockFrame.TopupLabel.Visible = false
						StallMenu.Main.StockFrame.MoneyDeductedLabel.Visible = false
					else
						Stall.Main.StockFrame.ErrorPopup.Visible = true
						wait(1)
						Stall.Main.StockFrame.ErrorPopup.Visible = true
					end
					
					wait(0.1)
					Debounce = false
				end
			end)
		end
	end
end

return StallSettings
