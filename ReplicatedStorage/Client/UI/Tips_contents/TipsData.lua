--[[
    TipsData (ModuleScript)
    Path: ReplicatedStorage → Client → UI → Tips
    Parent: Tips
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Tips = {}

local Player = game.Players.LocalPlayer
local CollectionService = game:GetService("CollectionService")
local TipsFrame = Player.PlayerGui:WaitForChild("InfoGui").TipsFrame

local function PlaySound()
	
end

function Tips.TweenUI(UI)
	UI:TweenPosition(
		UDim2.new(0.177,0,0.933,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.5,
		true
	)
end

TipsFrame.CloseBtn.MouseButton1Down:Connect(function()
	PlaySound()
	TipsFrame:TweenPosition(
		UDim2.new(-1.5,0,933,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.9,
		true
	)
end)

function Tips.OrderStand(Plot)
	local Found = false
	
	while Found == false do
		wait()
		for i,v in pairs(Plot.Items:GetChildren()) do
			if CollectionService:HasTag(v, "OrderStall") then
				print("Found Order Stand")
				Found = true
			end
		end
	end
	
	if not Found then
		print("Tip: Place an order stand from Build Menu -> Stands so that the Npc can order!")
		Tips.TweenUI(TipsFrame)
		PlaySound()
		TipsFrame.Tips.Text = "Tip: Place an order stand from Build Menu -> Stands so that the Npc can order!"
		
	end
end

function Tips.Stand(Plot)
	local Found = false
	
	while Found == false do
		wait()
		for i,v in pairs(Plot.Items:GetChildren()) do
			if CollectionService:HasTag(v, "Stall") then
				Found = true
			end
		end
	end


	if not Found then
		print("Tip: Place a stand from Build Menu -> Stands so that you can give the Npc's their orders!")
		Tips.TweenUI(TipsFrame)
		PlaySound()
		TipsFrame.Tips.Text = "Tip: Place a stand from Build Menu -> Stands so that you can give the Npc's their orders!"
	end

end

function Tips.Table(Plot)
	local Found = false
	
	while Found == false do
		wait()
		for i,v in pairs(Plot.Items:GetChildren()) do
			if CollectionService:HasTag(v, "Table") then
				Found = true
			end
		end
	end

	if not Found then
		print("Tip: Place a stand from Build Menu -> Table so that the Npc's can eat!")
		Tips.TweenUI(TipsFrame)
		PlaySound()
		TipsFrame.Tips.Text = "Tip: Place a stand from Build Menu -> Table so that the Npc's can eat!"
	end
	
end

return Tips
