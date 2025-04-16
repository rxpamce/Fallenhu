local FallenHub = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")

FallenHub.Name = "FallenHub"
FallenHub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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

-- Fly
local flying = false
local speed = 50
local bodyVelocity = nil

local function toggleFly()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if flying then
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        humanoid.PlatformStand = false
    else
        flying = true
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
    end
end

createButton("Fly", function()
    toggleFly()
end)

-- Noclip
createButton("Noclip", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end)

-- ESP
local function createESP(player)
    local esp = Instance.new("BillboardGui")
    esp.Parent = player.Character
    esp.Adornee = player.Character:WaitForChild("Head")
    esp.Size = UDim2.new(0, 100, 0, 50)
    esp.StudsOffset = Vector3.new(0, 2, 0)
    esp.AlwaysOnTop = true
    esp.ExtentsOffset = Vector3.new(0, 1, 0)

    local label = Instance.new("TextLabel")
    label.Parent = esp
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.8
    label.TextSize = 14
    label.Size = UDim2.new(1, 0, 1, 0)
end

createButton("ESP", function()
    game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            createESP(player)
        end)
    end)
end)

-- Xray
createButton("Xray", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obj.Transparency = 0.7
        end
    end
end)

-- Close GUI
createButton("Close GUI", function()
    FallenHub:Destroy()
end)
