local FallenHub = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local WalkSpeedSlider = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local WalkSpeedLabel = Instance.new("TextLabel")

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

-- Walkspeed Slider
createButton("Walkspeed", function()
    -- Create the slider frame
    WalkSpeedSlider.Name = "WalkSpeedSlider"
    WalkSpeedSlider.Parent = Main
    WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    WalkSpeedSlider.Size = UDim2.new(1, -20, 0, 40)
    WalkSpeedSlider.Position = UDim2.new(0, 10, 0, 0)
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = WalkSpeedSlider
    
    -- Slider Button
    SliderButton.Name = "SliderButton"
    SliderButton.Parent = WalkSpeedSlider
    SliderButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderButton.Size = UDim2.new(0, 20, 1, 0)
    SliderButton.Text = ""
    
    -- WalkSpeed Label
    WalkSpeedLabel.Name = "WalkSpeedLabel"
    WalkSpeedLabel.Parent = WalkSpeedSlider
    WalkSpeedLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    WalkSpeedLabel.Size = UDim2.new(1, 0, 1, 0)
    WalkSpeedLabel.Text = "Walkspeed: 16"
    WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkSpeedLabel.TextScaled = true

    -- Update WalkSpeed based on slider position
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local dragging = true
            local lastX = input.Position.X
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging then
                    local delta = input.Position.X - lastX
                    local sliderPos = SliderButton.Position.X.Offset + delta
                    local maxWidth = WalkSpeedSlider.AbsoluteSize.X - SliderButton.AbsoluteSize.X
                    local newSliderPos = math.clamp(sliderPos, 0, maxWidth)
                    SliderButton.Position = UDim2.new(0, newSliderPos, 0, 0)
                    
                    local newWalkSpeed = math.floor((newSliderPos / maxWidth) * 100)
                    WalkSpeedLabel.Text = "Walkspeed: " .. tostring(newWalkSpeed)
                    humanoid.WalkSpeed = newWalkSpeed
                    lastX = input.Position.X
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end
    end)
end)

-- Fly button
createButton("Fly", function()
    local flying = false
    local speed = 50
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")

    local function startFlying()
        if not flying then
            flying = true
            local character = game.Players.LocalPlayer.Character
            local humanoid = character:WaitForChild("Humanoid")
            bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
            bodyGyro.CFrame = character.HumanoidRootPart.CFrame
            bodyGyro.Parent = character.HumanoidRootPart
            bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
            bodyVelocity.Velocity = Vector3.new(0, speed, 0)
            bodyVelocity.Parent = character.HumanoidRootPart
        end
    end

    local function stopFlying()
        if flying then
            flying = false
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
        end
    end

    if flying then
        stopFlying()
    else
        startFlying()
    end
end)

-- Noclip button
createButton("Noclip", function()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end)

-- ESP button
createButton("ESP", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local player = game.Players.LocalPlayer
    local espTable = {}

    local function createESP(target)
        if target == player.Character then return end
        if espTable[target] then return end

        local box = Instance.new("Frame")
        box.Parent = game.CoreGui
        box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        box.BorderSizePixel = 2
        box.Size = UDim2.new(0, 100, 0, 100)
        box.Visible = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = box
        nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = target.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true

        local function updateESP()
            if target.Parent == nil then
                box:Destroy()
                return
            end

            local char = target.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrpPos = char.HumanoidRootPart.Position
                local screenPos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(hrpPos)

                if onScreen then
                    box.Position = UDim2.new(0, screenPos.X - box.Size.X.Offset / 2, 0, screenPos.Y - box.Size.Y.Offset / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end

        espTable[target] = updateESP
        game:GetService("RunService").Heartbeat:Connect(updateESP)
    end

    for _, target in pairs(Players:GetPlayers()) do
        if target.Character then
            createESP(target)
        end
    end

    Players.PlayerAdded:Connect(function(target)
        target.CharacterAdded:Connect(function()
            createESP(target)
        end)
    end)
end)

-- Xray button
createButton("Xray", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obj.Transparency = 0.7
        end
    end
end)

-- Fullbright button
createButton("Fullbright", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- Invisible button
createButton("Invisible", function()
    local character = game.Players.LocalPlayer.Character
    character:WaitForChild("Head").Transparency = 1
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end)

-- Teleport to player button
createButton("Teleport to Player", function()
    local targetPlayer = game.Players.LocalPlayer
    local character = targetPlayer.Character
    character:SetPrimaryPartCFrame(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
end)

-- Close GUI button
createButton("Close GUI", function()
    FallenHub:Destroy()
end)
