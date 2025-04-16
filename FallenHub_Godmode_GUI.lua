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

        -- Kontrol pergerakan fly dengan keyboard
        userInputService.InputBegan:Connect(function(input)
            if flying then
                if input.KeyCode == Enum.KeyCode.W then
                    bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.LookVector * speed
                elseif input.KeyCode == Enum.KeyCode.S then
                    bodyVelocity.Velocity = -character.HumanoidRootPart.CFrame.LookVector * speed
                elseif input.KeyCode == Enum.KeyCode.A then
                    bodyVelocity.Velocity = -character.HumanoidRootPart.CFrame.RightVector * speed
                elseif input.KeyCode == Enum.KeyCode.D then
                    bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.RightVector * speed
                elseif input.KeyCode == Enum.KeyCode.Space then
                    bodyVelocity.Velocity = Vector3.new(0, speed, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    bodyVelocity.Velocity = Vector3.new(0, -speed, 0)
                end
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

-- ESP button (Added a basic ESP)
createButton("ESP", function()
    local players = game:GetService("Players")
    local espParts = {}

    -- Creating ESP for all players in the game
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            local espPart = Instance.new("BillboardGui")
            espPart.Size = UDim2.new(0, 200, 0, 50)
            espPart.Adornee = plr.Character:WaitForChild("Head")
            espPart.Parent = game.CoreGui
            espPart.StudsOffset = Vector3.new(0, 2, 0)

            local label = Instance.new("TextLabel")
            label.Text = plr.Name
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.Parent = espPart

            table.insert(espParts, espPart)
        end
    end

    -- Updating ESP if players move
    players.PlayerAdded:Connect(function(plr)
        if plr ~= player then
            local espPart = Instance.new("BillboardGui")
            espPart.Size = UDim2.new(0, 200, 0, 50)
            espPart.Adornee = plr.Character:WaitForChild("Head")
            espPart.Parent = game.CoreGui
            espPart.StudsOffset = Vector3.new(0, 2, 0)

            local label = Instance.new("TextLabel")
            label.Text = plr.Name
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.Parent = espPart

            table.insert(espParts, espPart)
        end
    end)

    -- Cleanup when players leave
    players.PlayerRemoving:Connect(function(plr)
        for i, espPart in ipairs(espParts) do
            if espPart.Adornee == plr.Character:FindFirstChild("Head") then
                espPart:Destroy()
                table.remove(espParts, i)
            end
        end
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

-- Close GUI button
createButton("Close GUI", function()
    FallenHub:Destroy()
end)
