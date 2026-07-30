--[[
    ItemDeletion (Script)
    Path: ReplicatedStorage → Client → UI
    Parent: UI
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CollectionService = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")

local BuildMenu = PlayerGui:WaitForChild("Main").BuildMenu

local Debounce = false
local Enabled = false
local DeadTime = false
local Cancel = false

BuildMenu.Main.DeleteBtn.MouseButton1Down:Connect(function()
	BuildMenu.Visible = false
	BuildMenu.Parent.CancelDeletion.Visible = true
	if not Debounce then 
		Debounce = true
		Enabled = true
		
		local Mouse = Player:GetMouse()
		local Stall = nil
		local Target = nil
		
		task.spawn(function()
			BuildMenu.Parent.CancelDeletion.MouseButton1Down:Connect(function()
				BuildMenu.Parent.CancelDeletion.Visible = false
				Enabled = false
				DeadTime = false
				Cancel = false
				BuildMenu.Visible = true
			end)
		end)
		
		Mouse.Move:Connect(function()
			Target = Mouse.Target
			
			if not Target then return end
			
			if Target.Name == "Hitbox" then 
				Mouse.Button1Down:Connect(function()
					if not Enabled then return end
					
					if not DeadTime then
						DeadTime = true
						
						Stall = Mouse.Target.Parent
						
						if not Enabled then return end
						if Target.Name == "Hitbox" then 
							if Target.Parent.Parent.Parent.Owner.Value == Player.Name then

								print("-> Requesting server to destory "..Stall.Name)			

								game.ReplicatedStorage.Events.Delete:FireServer(Stall)
								Enabled = false
								BuildMenu.Visible = true
								BuildMenu.Parent.CancelDeletion.Visible = false
								game.SoundService.SFX.Delete:Play()
								wait(0.2)
								DeadTime = false
							else
								warn("NOT YOUR PLOT")
							end
						end
					end
					
				end)
			end		
		end)
		
		wait(0.2)
		Debounce = false
	end
end)