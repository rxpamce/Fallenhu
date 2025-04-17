-- Fallen Hub v1.1 [Dark Hacker Style] by @fallenhu

-- Instances
local FallenUI = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local CloseBtn = Instance.new("TextButton")

FallenUI.Name = "FallenHub"
FallenUI.Parent = game.CoreGui

Main.Name = "Main"
Main.Parent = FallenUI
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 380, 0, 500)
Main.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

Title.Name = "Title"
Title.Parent = Main
Title.Text = "Fallen Hub [v1.1]"
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1

ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Parent = Main
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800)

CloseBtn.Parent = Main
CloseBtn.Text = "Tutup"
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CloseBtn.Position = UDim2.new(1, -90, 0, 5)
CloseBtn.Size = UDim2.new(0, 80, 0, 30)
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
	FallenUI:Destroy()
end)

-- FUNCTION: Style Button
local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = ScrollingFrame
	btn.Text = text
	btn.Font = Enum.Font.Code
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.Position = UDim2.new(0, 20, 0, yPos)
	btn.Size = UDim2.new(0, 320, 0, 40)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(25, 25, 25)
		callback(toggled)
	end)
	return btn
end

-- Teleport to Player
local TpInput = Instance.new("TextBox")
TpInput.Parent = ScrollingFrame
TpInput.PlaceholderText = "Nama Player"
TpInput.Font = Enum.Font.Code
TpInput.TextColor3 = Color3.fromRGB(0, 255, 255)
TpInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TpInput.Position = UDim2.new(0, 20, 0, 420)
TpInput.Size = UDim2.new(0, 320, 0, 30)
TpInput.BorderSizePixel = 0
Instance.new("UICorner", TpInput).CornerRadius = UDim.new(0, 6)

local TpBtn = createButton("Teleport ke Player", 460, function()
	local targetName = TpInput.Text
	local plr = game.Players:FindFirstChild(targetName)
	if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		game.Players.LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
	end
end)

-- WalkSpeed Input
local WalkSpeedInput = Instance.new("TextBox")
WalkSpeedInput.Parent = ScrollingFrame
WalkSpeedInput.PlaceholderText = "Masukkan WalkSpeed"
WalkSpeedInput.Font = Enum.Font.Code
WalkSpeedInput.TextColor3 = Color3.fromRGB(0, 255, 255)
WalkSpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
WalkSpeedInput.Position = UDim2.new(0, 20, 0, 520)
WalkSpeedInput.Size = UDim2.new(0, 320, 0, 30)
WalkSpeedInput.BorderSizePixel = 0
Instance.new("UICorner", WalkSpeedInput).CornerRadius = UDim.new(0, 6)

createButton("Set WalkSpeed", 560, function()
	local speed = tonumber(WalkSpeedInput.Text)
	if speed then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
	end
end)

-- Fitur Toggle
createButton("Noclip", 0, function(toggled)
	game:GetService("RunService").Stepped:Connect(function()
		if toggled then
			for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	end)
end)

createButton("Fly (WASD + Camera)", 50, function(toggled)
	local plr = game.Players.LocalPlayer
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	local UIS = game:GetService("UserInputService")
	local moveVec = Vector3.zero

	local function update()
		local camCF = workspace.CurrentCamera.CFrame
		bv.Velocity = camCF:VectorToWorldSpace(moveVec * 50)
	end

	local conn = game:GetService("RunService").Heartbeat:Connect(update)

	UIS.InputBegan:Connect(function(input, g)
		if g then return end
		if input.KeyCode == Enum.KeyCode.W then moveVec = Vector3.new(0, 0, -1) end
		if input.KeyCode == Enum.KeyCode.S then moveVec = Vector3.new(0, 0, 1) end
		if input.KeyCode == Enum.KeyCode.A then moveVec = Vector3.new(-1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.D then moveVec = Vector3.new(1, 0, 0) end
	end)

	UIS.InputEnded:Connect(function(input)
		moveVec = Vector3.zero
	end)

	if not toggled then
		conn:Disconnect()
		bv:Destroy()
	end
end)

createButton("Godmode", 100, function(toggled)
	local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	if toggled and hum then
		hum.Health = hum.MaxHealth
		hum:GetPropertyChangedSignal("Health"):Connect(function()
			if hum.Health < hum.MaxHealth then
				hum.Health = hum.MaxHealth
			end
		end)
	end
end)

createButton("Xray", 150, function(toggled)
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			if toggled then
				obj.Transparency = 0.8
				obj.Material = Enum.Material.ForceField
			else
				obj.Transparency = 0
				obj.Material = Enum.Material.Plastic
			end
		end
	end
end)

createButton("Fullbright", 200, function(toggled)
	if toggled then
		local lighting = game:GetService("Lighting")
		lighting.Brightness = 10
		lighting.ClockTime = 14
		lighting.FogEnd = 100000
	else
		local lighting = game:GetService("Lighting")
		lighting.Brightness = 2
		lighting.ClockTime = 14
	end
end)

-- ESP
createButton("ESP (Kotak + Jarak)", 250, function(toggled)
	local RunService = game:GetService("RunService")
	local cam = workspace.CurrentCamera
	local plr = game.Players.LocalPlayer

	local boxes = {}

	local function drawBox(char, name)
		local box = Drawing.new("Square")
		box.Thickness = 1
		box.Transparency = 1
		box.Color = Color3.fromRGB(0, 255, 0)
		box.Filled = false
		box.Visible = true
		boxes[name] = box
	end

	local function removeBoxes()
		for _, box in pairs(boxes) do
			box:Remove()
		end
		boxes = {}
	end

	if toggled then
		RunService.RenderStepped:Connect(function()
			for _,_
