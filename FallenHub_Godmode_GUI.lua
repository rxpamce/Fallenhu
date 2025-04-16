local FallenHub = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
FallenHub.Name = "FallenHub"
FallenHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
FallenHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = FallenHub
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.Size = UDim2.new(0, 250, 0, 350)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

Title.Name = "Title"
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Fallen Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true

UIListLayout.Parent = Main
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Function to create buttons
local function createButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Parent = Main
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name
	btn.TextScaled = true
	btn.MouseButton1Click:Connect(callback)
end

-- Function to create sliders
local function createSlider(name, min, max, def, callback)
	local slider = Instance.new("Frame")
	local sliderBar = Instance.new("Frame")
	local knob = Instance.new("TextButton")
	local valueLabel = Instance.new("TextLabel")

	slider.Name = name
	slider.Parent = Main
	slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	slider.Size = UDim2.new(1, -20, 0, 40)
	slider.Position = UDim2.new(0, 10, 0, 0)

	sliderBar.Name = "SliderBar"
	sliderBar.Parent = slider
	sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sliderBar.Size = UDim2.new(1, -20, 0, 5)
	sliderBar.Position = UDim2.new(0, 10, 0, 15)

	knob.Name = "Knob"
	knob.Parent = sliderBar
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Size = UDim2.new(0, 10, 0, 10)
	knob.Position = UDim2.new((def - min) / (max - min), -5, 0, -2)
	knob.Text = ""
	knob.TextButton.MouseButton1Down:Connect(function()
		-- Add drag logic here
	end)

	valueLabel.Name = "ValueLabel"
	valueLabel.Parent = slider
	valueLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	valueLabel.TextScaled = true
	valueLabel.Size = UDim2.new(1, 0, 0, 25)
	valueLabel.Position = UDim2.new(0, 0, 1, 5)
end

-- Function to Teleport to Player
createButton("Teleport to Player", function()
	local playerName = game:GetService("Players").LocalPlayer.Name
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Name == playerName then
			game.Players.LocalPlayer.Character:MoveTo(player.Character:WaitForChild("Head").Position)
		end
	end
end)

-- Fly Button (Modified for Freefly)
createButton("Fly", function()
	local bodyVelocity = Instance.new("BodyVelocity")
	local bodyGyro = Instance.new("BodyGyro")

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	local torso = LocalPlayer.Character:WaitForChild("HumanoidRootPart")

	bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = torso

	bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
	bodyGyro.CFrame = torso.CFrame
	bodyGyro.Parent = torso
	
	-- Hover and Control Mechanism for Fly
	local function onUpdate()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			torso = LocalPlayer.Character.HumanoidRootPart
			bodyVelocity.Velocity = (Mouse.Hit.p - torso.Position).unit * 50
		end
	end
	
	-- Attach to update event
	game:GetService("RunService").Heartbeat:Connect(onUpdate)
end)

-- Noclip Button
createButton("Noclip", function()
	game:GetService("RunService").Stepped:Connect(function()
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end)

-- ESP Button
createButton("ESP", function()
	local espPart = Instance.new("Part")
	espPart.Size = Vector3.new(1, 1, 1)
	espPart.Anchored = true
	espPart.CanCollide = false
	espPart.Transparency = 0.5
	espPart.Color = Color3.fromRGB(255, 0, 0)

	-- Add ESP around all players
	for _, player in pairs(game.Players:GetPlayers()) do
		local espClone = espPart:Clone()
		espClone.Parent = workspace
		espClone.CFrame = player.Character.HumanoidRootPart.CFrame
		espClone.Anchored = true
	end
end)

-- Fullbright Button
createButton("Fullbright", function()
	game.Lighting.GlobalShadows = false
	game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end)

-- WalkSpeed Slider
createSlider("WalkSpeed", 16, 100, 16, function(value)
	LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Close GUI
createButton("Close GUI", function()
	FallenHub:Destroy()
end)
