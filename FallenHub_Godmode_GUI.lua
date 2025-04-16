-- Instance new for GUI setup
local FallenHub = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

-- Utility function to create buttons
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

-- ESP Function with Box and Player Highlight
local function esp()
	local function createESP()
		for _, object in pairs(workspace:GetDescendants()) do
			if object:IsA("BasePart") then
				local espPart = Instance.new("BillboardGui")
				local label = Instance.new("TextLabel")
				local box = Instance.new("Frame")

				-- Create ESP Box
				box.Name = "ESPBox"
				box.Size = UDim2.new(0, 100, 0, 100)
				box.Position = UDim2.new(0, 10, 0, 10)
				box.BackgroundTransparency = 0.5
				box.BorderSizePixel = 2
				box.BorderColor3 = Color3.fromRGB(255, 0, 0)
				box.Parent = object

				-- Create ESP Label
				espPart.Parent = object
				espPart.Adornee = object
				espPart.Size = UDim2.new(0, 100, 0, 50)
				espPart.StudsOffset = Vector3.new(0, 2, 0)
				espPart.AlwaysOnTop = true
				label.Parent = espPart
				label.Text = object.Name
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.fromRGB(255, 0, 0)
				label.TextScaled = true
			end
		end
	end

	-- Create ESP function
	createButton("ESP", function()
		createESP()
	end)
end

-- Fly Function (Manual Control)
local flying = false
local bodyGyro, bodyVelocity, humanoid = nil, nil, nil

local function startFly()
	if not flying then
		flying = true
		humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		local character = LocalPlayer.Character
		bodyGyro = Instance.new("BodyGyro")
		bodyVelocity = Instance.new("BodyVelocity")
		
		bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
		bodyGyro.CFrame = character.HumanoidRootPart.CFrame
		bodyGyro.Parent = character.HumanoidRootPart
		
		bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = character.HumanoidRootPart

		-- Listen to WASD controls to adjust fly velocity
		game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode == Enum.KeyCode.W then
				bodyVelocity.Velocity = Vector3.new(0, 0, -50)  -- Forward movement
			elseif input.KeyCode == Enum.KeyCode.A then
				bodyVelocity.Velocity = Vector3.new(-50, 0, 0)  -- Left movement
			elseif input.KeyCode == Enum.KeyCode.S then
				bodyVelocity.Velocity = Vector3.new(0, 0, 50)  -- Backward movement
			elseif input.KeyCode == Enum.KeyCode.D then
				bodyVelocity.Velocity = Vector3.new(50, 0, 0)  -- Right movement
			end
		end)
	end
end

local function stopFly()
	if flying then
		flying = false
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
	end
end

createButton("Fly", function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

-- Noclip Function (No collision with parts)
local function noclip()
	game:GetService("RunService").Stepped:Connect(function()
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end

createButton("Noclip", noclip)

-- WalkSpeed Adjustment
createButton("WalkSpeed", function()
	local speed = Instance.new("IntValue")
	speed.Name = "WalkSpeed"
	speed.Parent = LocalPlayer.Character:WaitForChild("Humanoid")
	speed.Value = 16 -- default walk speed
	
	local slider = Instance.new("Frame")
	slider.Size = UDim2.new(1, -20, 0, 20)
	slider.Position = UDim2.new(0, 10, 0, 70)
	slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	slider.Parent = Main
	
	local valueText = Instance.new("TextLabel")
	valueText.Size = UDim2.new(1, 0, 0, 25)
	valueText.Position = UDim2.new(0, 0, 1, 0)
	valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
	valueText.TextScaled = true
	valueText.Text = "WalkSpeed: 16"
	valueText.Parent = slider
	
	-- Logic for adjusting speed
	local function adjustSpeed(value)
		LocalPlayer.Character.Humanoid.WalkSpeed = value
		valueText.Text = "WalkSpeed: " .. value
	end
	
	-- Slider to adjust speed
	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 15, 0, 15)
	knob.Position = UDim2.new(0, 0, 0, 5)
	knob.Text = ""
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = slider
end)

-- Teleport to Player Function (type player name)
createButton("Teleport", function()
	local playerName = game:GetService("Players").LocalPlayer.Name
	local inputBox = Instance.new("TextBox")
	inputBox.Parent = Main
	inputBox.Size = UDim2.new(1, -20, 0, 30)
	inputBox.Position = UDim2.new(0, 10, 0, 110)
	inputBox.Text = "Enter Player Name"
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	
	local teleportButton = Instance.new("TextButton")
	teleportButton.Parent = Main
	teleportButton.Size = UDim2.new(1, -20, 0, 40)
	teleportButton.Position = UDim2.new(0, 10, 0, 150)
	teleportButton.Text = "Teleport"
	teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	
	teleportButton.MouseButton1Click:Connect(function()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.Name == inputBox.Text then
				LocalPlayer.Character:MoveTo(player.Character.Head.Position)
				inputBox:Destroy()
			end
		end
	end)
end)

-- Close GUI Button
createButton("Close GUI", function()
	FallenHub:Destroy()
end)
