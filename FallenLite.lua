-- Instances
local FallenUI = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local NoclipBtn = Instance.new("TextButton")
local FloatBtn = Instance.new("TextButton")
local XrayBtn = Instance.new("TextButton")
local TpInput = Instance.new("TextBox")
local TpBtn = Instance.new("TextButton")

-- Properties
FallenUI.Name = "FallenHub"
FallenUI.Parent = game.CoreGui

Main.Name = "Main"
Main.Parent = FallenUI
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Position = UDim2.new(0.3, 0, 0.25, 0)
Main.Size = UDim2.new(0, 260, 0, 250)
Main.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

Title.Name = "Title"
Title.Parent = Main
Title.Text = "Fallen Hub [v1]"
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1

-- Button Styling Function
local function styleButton(btn, text, pos)
	btn.Parent = Main
	btn.Text = text
	btn.Font = Enum.Font.Code
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.Position = pos
	btn.Size = UDim2.new(0, 220, 0, 30)
	btn.BorderSizePixel = 0
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
end

styleButton(NoclipBtn, "Noclip", UDim2.new(0, 20, 0, 40))
styleButton(FloatBtn, "Float", UDim2.new(0, 20, 0, 80))
styleButton(XrayBtn, "Xray", UDim2.new(0, 20, 0, 120))

TpInput.Parent = Main
TpInput.PlaceholderText = "Nama Player"
TpInput.Font = Enum.Font.Code
TpInput.TextColor3 = Color3.fromRGB(0, 255, 255)
TpInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TpInput.Position = UDim2.new(0, 20, 0, 160)
TpInput.Size = UDim2.new(0, 220, 0, 30)
TpInput.BorderSizePixel = 0
local TpInputCorner = Instance.new("UICorner")
TpInputCorner.CornerRadius = UDim.new(0, 6)
TpInputCorner.Parent = TpInput

styleButton(TpBtn, "Teleport to Player", UDim2.new(0, 20, 0, 200))

-- Functionality
local noclip = false
NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	game:GetService("RunService").Stepped:Connect(function()
		if noclip then
			for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)
end)

FloatBtn.MouseButton1Click:Connect(function()
	local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local floatPart = Instance.new("Part", workspace)
		floatPart.Anchored = true
		floatPart.CanCollide = false
		floatPart.Size = Vector3.new(4, 0.5, 4)
		floatPart.Position = hrp.Position - Vector3.new(0, 3, 0)
		hrp.CFrame = floatPart.CFrame + Vector3.new(0, 3, 0)
	end
end)

XrayBtn.MouseButton1Click:Connect(function()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Transparency < 0.5 then
			obj.Transparency = 0.8
			obj.Material = Enum.Material.ForceField
		end
	end
end)

TpBtn.MouseButton1Click:Connect(function()
	local targetName = TpInput.Text
	local plr = game.Players:FindFirstChild(targetName)
	if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		game.Players.LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
	end
end)
