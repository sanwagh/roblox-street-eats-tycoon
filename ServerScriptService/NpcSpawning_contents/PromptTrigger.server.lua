--[[
    PromptTrigger (Script)
    Path: ServerScriptService → NpcSpawning
    Parent: NpcSpawning
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local MarketplaceService = game:GetService("MarketplaceService")

game.ReplicatedStorage:WaitForChild("Events").Loaded.Event:Connect(function(plr)
	task.spawn(function()
		warn("FOR", plr)
		local Debounce = false

		local PlayerPlot
		local function GetPlayerPlot()
			wait()
			for i,v in pairs(game.Workspace.Plots:GetChildren()) do
				if v.Owner.Value == plr.Name then
					PlayerPlot = v
					return true
				end
			end
			warn("NO Plot Found")
			return false
		end
		wait(1)
		GetPlayerPlot()

		--while not GetPlayerPlot() do
		--	wait(0.1)
		--end

		warn("FOIUND PLOT ", plr.Name, PlayerPlot)
		local function CheckStock(stall)
			if tonumber(stall.Parent:GetAttribute("Storage")) > 0 then
				return true
			else
				return false
			end
		end

		local function GetOrderData(order)
			local OrderTable = {}
			table.insert(OrderTable, order.Name)
			table.insert(OrderTable, order.Value)

			return OrderTable
		end

		while true do
			wait()
			for i,v in pairs(PlayerPlot.Items:GetDescendants()) do
				if v.Name == "ItemBox" then
					v.Main.ProximityPrompt.Triggered:Connect(function()
						if not Debounce then
							Debounce = true
							print("Trigger", plr.Name)
							local HasStock = CheckStock(v)

							if HasStock then
								for i,x in pairs(v.Parent.Orders:GetChildren()) do
									local OrderData = GetOrderData(x)

									local OrderNpc = nil
									
									for _,npc in pairs(game.Workspace.NPCFolder:GetChildren()) do
										if npc.Name == OrderData[2] and npc:GetAttribute("Player") == plr.Name then
											print("NPC is Correct")
											OrderNpc = npc.HumanoidRootPart
										end
									end
									warn(OrderNpc, "ORDERNPC STATUS")
									local OrderDestination = OrderNpc.Position -- FOR WORKERS

									local Attachment0 = Instance.new("Attachment")
									Attachment0.Parent = OrderNpc

									local Attachment1 = Instance.new("Attachment")
									Attachment1.Parent = plr.Character.HumanoidRootPart

									local Beam = Instance.new("Beam")
									Beam.Parent = plr.Character
									Beam.Attachment0 = Attachment0
									Beam.Attachment1 = Attachment1
									Beam.FaceCamera = true

									OrderNpc.GiveOrderPrompt.Enabled = true

									local Given = false
									

									OrderNpc.GiveOrderPrompt.TriggerEnded:Connect(function()
										OrderNpc.GiveOrderPrompt.Enabled = false
										
										plr.Character.Sounds.Cash:Play()
										
										if MarketplaceService:UserOwnsGamePassAsync(plr.UserId,681725785) then
											if plr.MonetizationData.CashBoost.Value > 2 then
												plr.leaderstats.Cash.Value += (tonumber(v.Parent:GetAttribute(OrderData[1]))*2*1.5)
												print("Player has gamepass and cashboost")	
											else
												plr.leaderstats.Cash.Value += (tonumber(v.Parent:GetAttribute(OrderData[1]))*2)
											end
											
											print("Player Has Double Cash")
										else
											print("No Double cash")
											if plr.MonetizationData.CashBoost.Value > 2 then
												plr.leaderstats.Cash.Value += (tonumber(v.Parent:GetAttribute(OrderData[1]))*1.5)
												print("Player has cash boost")
											else
												plr.leaderstats.Cash.Value += (tonumber(v.Parent:GetAttribute(OrderData[1])))
											end
										end
										
										v.Parent:SetAttribute("Storage", v.Parent:GetAttribute("Storage") - 1)

										local RandNum = math.random(3,v.Parent.Exp.Value)
										
										if MarketplaceService:UserOwnsGamePassAsync(plr.UserId,682114170) then
											if plr.MonetizationData.XPBoost.Value > 2 then
												plr.LevelStats.XP.Value += (v.Parent.Exp.Value*2*1.5)
												print("Player has gamepass and xp boost")
											else
												plr.LevelStats.XP.Value += (v.Parent.Exp.Value*2)
												print("Player Has Double XP")
											end
											
										else
											if plr.MonetizationData.XPBoost.Value > 2 then
												plr.LevelStats.XP.Value += (RandNum*1.5)
												print("Player has xp boost")
											else
												plr.LevelStats.XP.Value += RandNum
											end
										end
																				
										

										OrderNpc.Parent:SetAttribute("OrderReceived", true)
										Given = true
										local IModel = v.Parent.StallItems.Model:Clone()
										IModel.Parent = OrderNpc.Parent
										IModel:PivotTo(CFrame.new(OrderNpc.Parent.RightLowerArm.Position+Vector3.new(-3,0,0)))
										-- ANIMATION

										local TotalCash = v.Parent:GetAttribute("TotalCash")

										v.Parent:SetAttribute("TotalCash", TotalCash + OrderNpc.Parent:GetAttribute("Cost"))


										x:Destroy()
										Beam:Destroy()
										Attachment0:Destroy()
										Attachment1:Destroy()
										IModel:Destroy()
										OrderNpc.GiveOrderPrompt.Enabled = false
										wait(0.2)
										Debounce = false
										warn("DEBOUCE FALSE")
										return
									end)
									while Given == false do
										wait()
									end
									print("Given")
									--wait(0.2)
									--Debounce = false
									--warn("DEBOUCE FALSE")
									return
								end
							else
								plr.PlayerGui.InfoGui.WarningLabel.Text = "Out Of Stock. Please Restock from stall settings"
								plr.PlayerGui.InfoGui.WarningLabel.Visible = true
								wait(1)
								plr.PlayerGui.InfoGui.WarningLabel.Visible = false
							end
							wait(0.2)
							Debounce = false
							warn("DEBOUCE FALSE")
						end
					end)
				end
			end
		end
	end)
end)