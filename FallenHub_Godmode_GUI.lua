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

-- Fly button
local flying = false
local speed = 50
local bodyVelocity = nil
local bodyGyro = nil
local userInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function toggleFly()
    if flying then
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
        end
        humanoid.PlatformStand = false
    else
        flying = true
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro = Instance.new("BodyGyro")
        
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        bodyGyro.Parent = character:WaitForChild("HumanoidRootPart")

        -- Kontrol gerakan fly
        userInputService.InputChanged:Connect(function(input)
            if flying then
                local moveDirection = Vector3.new(0, 0, 0)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    -- Menggerakkan kamera
                    local camera = game.Workspace.CurrentCamera
                    local lookAt = camera.CFrame.LookVector
                    moveDirection = lookAt * speed
                end
                bodyVelocity.Velocity = moveDirection
            end
        end)

        -- Kontrol rotasi
        userInputService.InputChanged:Connect(function(input)
            if flying and input.UserInputType == Enum.UserInputType.MouseMovement then
                local camera = game.Workspace.CurrentCamera
                bodyGyro.CFrame = camera.CFrame
            end
        end)
    end
end

createButton("Fly", function()
    toggleFly()
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
    loadstring(game:HttpGet("https://pastebin.com/raw/Jg1M3F3z"))()
end)

-- Xray button
createButton("Xray", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
            obj.Transparency = 0.7
        end
    end
end)

-- Close GUI button
createButton("Close GUI", function()
    FallenHub:Destroy()
end)
