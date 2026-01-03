local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)  
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Active = true
mainFrame.Draggable = true  

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = mainFrame
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.Text = "Fly Controller"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Center

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = mainFrame
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.BorderSizePixel = 0
flyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
flyButton.Size = UDim2.new(0.8, 0, 0, 30)
flyButton.Font = Enum.Font.Gotham
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyButton

local flyGradient = Instance.new("UIGradient")
flyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
}
flyGradient.Parent = flyButton

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = mainFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0.1, 0, 0.65, 0)
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Center

local plusButton = Instance.new("TextButton")
plusButton.Name = "PlusButton"
plusButton.Parent = mainFrame
plusButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
plusButton.BorderSizePixel = 0
plusButton.Position = UDim2.new(0.25, 0, 0.85, 0)
plusButton.Size = UDim2.new(0, 30, 0, 25)
plusButton.Font = Enum.Font.GothamBold
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.TextSize = 18

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusButton

local minusButton = Instance.new("TextButton")
minusButton.Name = "MinusButton"
minusButton.Parent = mainFrame
minusButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
minusButton.BorderSizePixel = 0
minusButton.Position = UDim2.new(0.65, 0, 0.85, 0)
minusButton.Size = UDim2.new(0, 30, 0, 25)
minusButton.Font = Enum.Font.GothamBold
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.TextSize = 18

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 6)
minusCorner.Parent = minusButton

local flying = false
local speed = 16
local bodyVelocity
local bodyGyro
local function toggleFly()
    flying = not flying
    flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
    if flying then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.P = 2000
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not flying then
                connection:Disconnect()
                return
            end
            
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            if moveVector.Magnitude > 0 then
                bodyVelocity.Velocity = moveVector.Unit * speed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            bodyGyro.CFrame = camera.CFrame
        end)
        
    else
        humanoid.PlatformStand = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end

flyButton.MouseButton1Click:Connect(toggleFly)

plusButton.MouseButton1Click:Connect(function()
    speed = speed + 4
    if speed > 100 then speed = 500 end
    speedLabel.Text = "Speed: " .. speed
end)

minusButton.MouseButton1Click:Connect(function()
    speed = speed - 4
    if speed < 4 then speed = 4 end
    speedLabel.Text = "Speed: " .. speed
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    flying = false
    flyButton.Text = "Fly: OFF"
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Fly GUI Loaded";
    Text = "by lyar hub";
    Duration = 3;
})
