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

-- Fly function
local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local speed = 50

local function toggleFly()
    if flying then
        bodyVelocity:Destroy()
        bodyGyro:Destroy()
        flying = false
    else
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        flying = true
    end
end

-- Noclip function
local function toggleNoclip()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

-- ESP function
local function toggleESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
            obj.Transparency = 0.5
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(255, 0, 0)  -- Red ESP
        end
    end
end

-- Fullbright function
local function toggleFullbright()
    game.Lighting.GlobalShadows = false
    game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

-- WalkSpeed slider
local function createWalkSpeedSlider()
    local slider = Instance.new("Frame")
    local sliderBar = Instance.new("Frame")
    local knob = Instance.new("TextButton")
    local valueLabel = Instance.new("TextLabel")

    slider.Name = "WalkSpeedSlider"
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
    knob.Position = UDim2.new(0, 10, 0, -2)
    knob.Text = ""
    knob.MouseButton1Down:Connect(function()
        -- Slide Logic
    end)

    valueLabel.Name = "ValueLabel"
    valueLabel.Parent = slider
    valueLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextScaled = true
    valueLabel.Size = UDim2.new(1, 0, 0, 25)
    valueLabel.Position = UDim2.new(0, 0, 1, 5)
end

-- Create GUI buttons
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

-- Add buttons to GUI
createButton("Fly", toggleFly)
createButton("Noclip", toggleNoclip)
createButton("ESP", toggleESP)
createButton("Fullbright", toggleFullbright)
createWalkSpeedSlider()

-- Close GUI
createButton("Close GUI", function()
    FallenHub:Destroy()
end)
