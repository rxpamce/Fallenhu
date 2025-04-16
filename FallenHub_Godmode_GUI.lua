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
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rxpamce/FallenHu/main/fly_script.lua"))()
end)

createButton("Noclip", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end)

createButton("ESP", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rxpamce/FallenHu/main/esp_script.lua"))()
end)

createButton("Xray", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
            obj.Transparency = 0.7
        end
    end
end)

createButton("Fullbright", function()
    game.Lighting.GlobalShadows = false
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end)

createButton("WalkSpeed", function()
    local speed = Instance.new("TextBox")
    speed.Size = UDim2.new(0, 100, 0, 30)
    speed.Position = UDim2.new(0.5, -50, 0.5, -15)
    speed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    speed.TextColor3 = Color3.fromRGB(0, 0, 0)
    speed.Text = "16"
    speed.Parent = FallenHub

    speed.FocusLost:Connect(function()
        local newSpeed = tonumber(speed.Text)
        if newSpeed then
            LocalPlayer.Character.Humanoid.WalkSpeed = newSpeed
        end
    end)
end)

createButton("Teleport to Player", function()
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
