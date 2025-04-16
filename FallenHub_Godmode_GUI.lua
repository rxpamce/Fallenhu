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

createButton("Fly", function()
    -- Fly Script
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
    bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space then
            bodyVelocity.Velocity = Vector3.new(0, 100, 0)
        elseif input.KeyCode == Enum.KeyCode.S then
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        end
    end)
end)

createButton("Noclip", function()
    -- Noclip Script
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end)

createButton("ESP", function()
    -- ESP Script
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = Instance.new("BillboardGui")
            esp.Parent = player.Character
            esp.Size = UDim2.new(0, 100, 0, 100)
            esp.Adornee = player.Character:FindFirstChild("Head")
            esp.AlwaysOnTop = true
            esp.StudsOffset = Vector3.new(0, 2, 0)
            
            local text = Instance.new("TextLabel")
            text.Text = player.Name
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextScaled = true
            text.Parent = esp
        end
    end
end)

createButton("Xray", function()
    -- Xray Script
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
            obj.Transparency = 0.7
        end
    end
end)

createButton("Fullbright", function()
    -- Fullbright Script
    game.Lighting.GlobalShadows = false
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end)

createButton("WalkSpeed", function()
    -- WalkSpeed Script
    LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)

createButton("Teleport to Player", function()
    -- Teleport to Player Script
    local playerName = game:GetService("Players").LocalPlayer.Name
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name == playerName then
            game.Players.LocalPlayer.Character:MoveTo(player.Character:WaitForChild("Head").Position)
        end
    end
end)

createButton("Close GUI", function()
    FallenHub:Destroy()
end)
