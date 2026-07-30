--[[
    Tutorial (Script)
    Path: ReplicatedStorage → Client
    Parent: Client
    Properties:
        Disabled: false
    Exported: 2026-07-30 17:33:33 (web)
]]

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local TutorialFrame = PlayerGui:WaitForChild("TutorialGui")
local NextBtn = TutorialFrame.Main.Next

local CollectionService = game:GetService("CollectionService")

local DialougeTable = {
	"Hello, Welcome to Street Eats Tycoon",
	"Let's start.Close your tycoon from settings [⚙️]. Then Open the Build Menu [🔨] on the left side of the screen then navigate to Stalls and click on OrderStand and place it.",
	"Great! Now, add a Lemonade Stand from the Build menu under Stalls and Place it",
	"Now, place tables for the Npc's from the Build Menu under Tables. Select the StandingTable and place it",
	"Now, from settings [⚙️] open your tycoon.",
	"Time to serve the Npc's. Go into the Order Stand and accept their order.",
	"Once the Npc orders, Go to your lemonade stand and get the lemonade from the cooler and walk to the Npc and give them their drink.",
	"Now just rinse and repeat. You can also change the prices of your food items from the Stall Menu. Edit your stall by clicking on the stall and pressing 'B'.",
	"You can expand your business by placing more Stalls and tables! Your sales will depend upon the cost that you set!"
}

local function AnimateText(Text)
	for i = 1, #Text do
		TutorialFrame.Main.MainText.Text = string.sub(Text,1,i)
		wait(0.05)
	end	
end

local function GetPlayerPlot()
	wait(0.2)
	for i,v in pairs(game.Workspace.Plots:GetChildren()) do
		if v.Owner.Value == Player.Name  then
			return v
		end
	end
end

game.ReplicatedStorage:WaitForChild("Events").StartTutorial.OnClientEvent:Connect(function()
	local PlayerPlot = GetPlayerPlot()

	local CurrentStep = 2
	
	local Part
	local PlacedItem

	local function CheckForItemPlaced(Item)
		while #PlayerPlot.Items:GetChildren() <= 0 do
			wait()
		end
		
		while true do
			wait()
			for i,v in pairs(PlayerPlot.Items:GetChildren()) do
				if v.Name == Item then
					print(Item, v)
					print("Got Plot")
					return true
				end
			end
		end
	end

	TutorialFrame.Main:TweenPosition(
		UDim2.new(0.5,0,0.885,0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Sine,
		0.5,
		true
	)
	wait(0.1)

	AnimateText(DialougeTable[1])

	NextBtn.MouseButton1Down:Connect(function()
		if CurrentStep == 2 then
			NextBtn.Visible = false
			AnimateText(DialougeTable[2])

			-- Create the Placement Part
			Part = Instance.new("Part")
			Part.Size = Vector3.new(12,0.2,12)
			Part.Transparency = 0.5
			Part.Anchored = true
			Part.CanCollide = false
			Part.Position = Vector3.new(PlayerPlot.Plot.Position.X * 0.5 + (Part.Size.X * 0.5), PlayerPlot.Plot.Position.Y + (Part.Size.Y), PlayerPlot.Plot.Position.Z +(Part.Size.Z * 0.5) )
			
			print(Part.Position)
			Part.Material = Enum.Material.Neon
			Part.Color = Color3.new(1, 1, 1)
			Part.Parent = PlayerPlot

			PlacedItem = CheckForItemPlaced("OrderStall")

			while PlacedItem == false do
				wait()
			end
			NextBtn.Visible = true
			PlacedItem = false
			CurrentStep += 1
		elseif CurrentStep == 3 then
			NextBtn.Visible = false
			AnimateText(DialougeTable[3])
			Part.Position = Vector3.new(PlayerPlot.Plot.Position.X + (Part.Size.X * 0.5) + 12, PlayerPlot.Plot.Position.Y + (Part.Size.Y), PlayerPlot.Plot.Position.Z)

			PlacedItem = CheckForItemPlaced("LemonadeStall")
			while PlacedItem == false do
				wait()
			end
			NextBtn.Visible = true
			Part:Destroy()
			
			PlacedItem = false
			CurrentStep += 1
			
		elseif CurrentStep == 4 then
			NextBtn.Visible = false
			AnimateText(DialougeTable[4])
			

			PlacedItem = CheckForItemPlaced("StandingTable")
			while PlacedItem == false do
				wait()
			end
			NextBtn.Visible = true
			
			PlacedItem = false
			CurrentStep += 1
			
		elseif CurrentStep == 5 then
			AnimateText(DialougeTable[5])
			CurrentStep += 1
			
		elseif CurrentStep == 6 then
			AnimateText(DialougeTable[6])
			CurrentStep += 1
			
		elseif CurrentStep == 7 then
			AnimateText(DialougeTable[7])
			CurrentStep += 1
			
		elseif CurrentStep == 8 then
			AnimateText(DialougeTable[8])
			CurrentStep += 1
			
		elseif CurrentStep == 9 then
			AnimateText(DialougeTable[9])

			TutorialFrame.Main:TweenPosition(
				UDim2.new(1.5,0,0.5,0),
				Enum.EasingDirection.In,
				Enum.EasingStyle.Sine,
				0.5,
				true
			)
			warn("Tutorial Finished!")
			game.ReplicatedStorage.Events.StartTutorial:FireServer()
		end
	end)
end)



