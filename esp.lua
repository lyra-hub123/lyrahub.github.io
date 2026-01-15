-- NukeBot Style All-in-One GUI (2025-2026 common edition)
-- 這東西活不久，請有心理準備

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 設定區 ────────────────────────────────────────
local SETTINGS = {
    FlySpeed = 50,
    WalkSpeed = 16,
    SpeedMultiplier = 5,
    JumpPower = 50,
    InfiniteJump = false,
    SpiderClimb = false,
    Noclip = false,
    PhaseDown = false,
    Godmode = false,
    SemiGod = false,
    HealthSteal = false,
    AntiKnockback = false,
    AntiRagdoll = false,
    Fullbright = false,
    NoFog = false,
    ESP_Enabled = false,
    Chams_Enabled = false,
    SilentAim_Enabled = false,
    KillAura_Range = 15,
    KillAura_Enabled = false,
}

-- GUI 主體 ────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NukeBotUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 560)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- 標題列
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NUKEBOT ULTIMATE v2.1 - Academic Test Only"
Title.TextColor3 = Color3.fromRGB(220, 60, 60)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 分頁系統
local TabButtons = {}
local Pages = {}

local function CreateTab(name, posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 35)
    btn.Position = UDim2.new(0, posX, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 15
    btn.Parent = MainFrame
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -90)
    page.Position = UDim2.new(0, 10, 0, 90)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 6
    page.Visible = false
    page.Parent = MainFrame
    
    table.insert(TabButtons, btn)
    Pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
        
        for _, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(35,35,45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
    end)
    
    return page
end

-- 建立各分頁
local MovementPage = CreateTab("Movement", 10)
local CombatPage  = CreateTab("Combat", 130)
local VisualPage  = CreateTab("Visual", 250)
local ExploitsPage = CreateTab("Exploits", 370)

MovementPage.Visible = true  -- 預設開啟第一頁
TabButtons[1].BackgroundColor3 = Color3.fromRGB(60,60,80)

-- 快速開關模板函式
local function CreateToggle(parent, name, yPos, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 30)
    label.Position = UDim2.new(0, 15, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 15
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 26)
    toggle.Position = UDim2.new(1, -80, 0, yPos+2)
    toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255,80,80)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 14
    toggle.Parent = parent

    local state = false

    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(60,180,60)
            toggle.Text = "ON"
            toggle.TextColor3 = Color3.new(1,1,1)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(255,80,80)
        end
        callback(state)
    end)

    return function(v)
        state = v
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(60,180,60)
            toggle.Text = "ON"
            toggle.TextColor3 = Color3.new(1,1,1)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(255,80,80)
        end
        callback(state)
    end
end

-- 快速數字選擇器
local function CreateMultiplier(parent, name, yPos, options, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 30)
    label.Position = UDim2.new(0, 15, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 15
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local current = default
    local display = Instance.new("TextLabel")
    display.Size = UDim2.new(0, 80, 0, 30)
    display.Position = UDim2.new(1, -140, 0, yPos)
    display.BackgroundColor3 = Color3.fromRGB(40,40,50)
    display.Text = tostring(options[default])
    display.TextColor3 = Color3.new(1,1,1)
    display.TextSize = 16
    display.Parent = parent

    local left = Instance.new("TextButton")
    left.Size = UDim2.new(0, 30, 0, 30)
    left.Position = UDim2.new(1, -200, 0, yPos)
    left.BackgroundColor3 = Color3.fromRGB(60,60,70)
    left.Text = "<"
    left.TextColor3 = Color3.new(1,1,1)
    left.Parent = parent

    local right = Instance.new("TextButton")
    right.Size = UDim2.new(0, 30, 0, 30)
    right.Position = UDim2.new(1, -40, 0, yPos)
    right.BackgroundColor3 = Color3.fromRGB(60,60,70)
    right.Text = ">"
    right.TextColor3 = Color3.new(1,1,1)
    right.Parent = parent

    left.MouseButton1Click:Connect(function()
        current = math.max(1, current-1)
        display.Text = tostring(options[current])
        callback(options[current])
    end)

    right.MouseButton1Click:Connect(function()
        current = math.min(#options, current+1)
        display.Text = tostring(options[current])
        callback(options[current])
    end)
end

-- ======================= 運動相關 =======================
CreateToggle(MovementPage, "飛行 (Fly)", 10, function(v)
    SETTINGS.Fly = v
end)

CreateToggle(MovementPage, "穿牆 (Noclip)", 50, function(v)
    SETTINGS.Noclip = v
end)

CreateToggle(MovementPage, "下穿地板 (Phase)", 90, function(v)
    SETTINGS.PhaseDown = v
end)

CreateToggle(MovementPage, "無限跳躍", 130, function(v)
    SETTINGS.InfiniteJump = v
end)

CreateToggle(MovementPage, "蜘蛛爬牆", 170, function(v)
    SETTINGS.SpiderClimb = v
end)

CreateMultiplier(MovementPage, "速度倍率", 220, {1,2,3,4,5,6,8,10,15,20,30,50,100}, 5, function(v)
    SETTINGS.SpeedMultiplier = v
    if Humanoid then
        Humanoid.WalkSpeed = 16 * v
    end
end)

-- ======================= 戰鬥相關 =======================
CreateToggle(CombatPage, "Kill Aura", 10, function(v)
    SETTINGS.KillAura_Enabled = v
end)

CreateMultiplier(CombatPage, "Kill Aura 範圍", 50, {5,8,10,12,15,18,20,25,30}, 8, function(v)
    SETTINGS.KillAura_Range = v
end)

CreateToggle(CombatPage, "Silent Aim (靜默瞄準)", 100, function(v)
    SETTINGS.SilentAim_Enabled = v
end)

CreateToggle(CombatPage, "無敵模式 (God)", 150, function(v)
    SETTINGS.Godmode = v
    if v and Humanoid then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    end
end)

CreateToggle(CombatPage, "半無敵 (Semi-God)", 190, function(v)
    SETTINGS.SemiGod = v
end)

CreateToggle(CombatPage, "吸血鬼模式", 230, function(v)
    SETTINGS.HealthSteal = v
end)

CreateToggle(CombatPage, "抗擊退", 270, function(v)
    SETTINGS.AntiKnockback = v
end)

CreateToggle(CombatPage, "防倒地", 310, function(v)
    SETTINGS.AntiRagdoll = v
end)

-- ======================= 視覺相關 =======================
CreateToggle(VisualPage, "敵人ESP", 10, function(v)
    SETTINGS.ESP_Enabled = v
end)

CreateToggle(VisualPage, "Player Chams", 50, function(v)
    SETTINGS.Chams_Enabled = v
end)

CreateToggle(VisualPage, "全亮 (Fullbright)", 90, function(v)
    SETTINGS.Fullbright = v
    if v then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(VisualPage, "無霧", 130, function(v)
    SETTINGS.NoFog = v
    if v then
        Lighting.FogEnd = 9e9
    end
end)

-- ======================= 高級破壞類 =======================
CreateToggle(ExploitsPage, "Fling All (全圖甩人)", 10, function(state)
    if not state then return end
    
    spawn(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for i=1, 60 do
                        pcall(function()
                            hrp.CFrame = RootPart.CFrame * CFrame.new(0,100,0)
                            hrp.Velocity = Vector3.new(math.random(-1000,1000), 500, math.random(-1000,1000))
                        end)
                        task.wait()
                    end
                end
            end
        end
    end)
end)

CreateToggle(ExploitsPage, "Void All (全圖丟虚空)", 60, function(state)
    if not state then return end
    
    spawn(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                pcall(function()
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(0,-500,0)
                end)
            end
        end
    end)
end)

-- ╔══════════════════════════════════════════════════════╗
-- ║                   核心迴圈與功能實作                  ║
-- ╚══════════════════════════════════════════════════════╝

-- 飛行控制
local flyingConnection
local function StartFly()
    if flyingConnection then flyingConnection:Disconnect() end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new()
    bodyVelocity.Parent = RootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.P = 20000
    bodyGyro.Parent = RootPart

    local keys = {W=false, A=false, S=false, D=false, Space=false, Ctrl=false}
    
    local conn1 = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then keys.W = true
        elseif input.KeyCode == Enum.KeyCode.A then keys.A = true
        elseif input.KeyCode == Enum.KeyCode.S then keys.S = true
        elseif input.KeyCode == Enum.KeyCode.D then keys.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = true end
    end)

    local conn2 = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keys.W = false
        elseif input.KeyCode == Enum.KeyCode.A then keys.A = false
        elseif input.KeyCode == Enum.KeyCode.S then keys.S = false
        elseif input.KeyCode == Enum.KeyCode.D then keys.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = false end
    end)

    flyingConnection = RunService.RenderStepped:Connect(function(dt)
        if not SETTINGS.Fly then 
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            flyingConnection:Disconnect()
            flyingConnection = nil
            return 
        end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(
            (keys.D and 1 or 0) - (keys.A and 1 or 0),
            (keys.Space and 1 or 0) - (keys.Ctrl and 1 or 0),
            (keys.S and 1 or 0) - (keys.W and 1 or 0)
        )

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            local worldMove = (cam.CFrame * CFrame.new(moveDir)).Position - cam.CFrame.Position
            bodyVelocity.Velocity = worldMove * SETTINGS.FlySpeed * (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 3 or 1)
        else
            bodyVelocity.Velocity = Vector3.new()
        end

        bodyGyro.CFrame = cam.CFrame
    end)
end

-- 監聽飛行開關變化
local prevFly = false
RunService.Heartbeat:Connect(function()
    if SETTINGS.Fly ~= prevFly then
        prevFly = SETTINGS.Fly
        if SETTINGS.Fly then
            StartFly()
        end
    end
end)

-- Noclip & Phase
RunService.Stepped:Connect(function()
    if not Character then return end
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not (SETTINGS.Noclip or SETTINGS.PhaseDown)
        end
    end
    
    if SETTINGS.PhaseDown and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -0.8, 0)
    end
end)

-- 無限跳躍
UserInputService.JumpRequest:Connect(function()
    if SETTINGS.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 蜘蛛爬牆
local prevSpider = false
RunService.Heartbeat:Connect(function()
    if SETTINGS.SpiderClimb then
        Humanoid.PlatformStand = false
        Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
    end
end)

-- 速度
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if Humanoid.WalkSpeed ~= 16 * SETTINGS.SpeedMultiplier then
        Humanoid.WalkSpeed = 16 * SETTINGS.SpeedMultiplier
    end
end)

-- Kill Aura 簡單實現
spawn(function()
    while true do
        task.wait(0.1)
        
        if not SETTINGS.KillAura_Enabled then continue end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer or not plr.Character then continue end
            
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            local dist = (hrp.Position - RootPart.Position).Magnitude
            if dist <= SETTINGS.KillAura_Range then
                pcall(function()
                    plr.Character.Humanoid.Health = 0
                end)
            end
        end
    end
end)

-- 超簡易ESP (只做框框+名字)
local espConnections = {}

local function CreateESP(plr)
    if espConnections[plr] then return end
    
    local bill = Instance.new("BillboardGui")
    bill.Adornee = plr.Character:WaitForChild("Head")
    bill.Size = UDim2.new(0, 100, 0, 150)
    bill.StudsOffset = Vector3.new(0,3,0)
    bill.AlwaysOnTop = true
    bill.Parent = plr.Character
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = plr.Name
    text.TextColor3 = Color3.fromRGB(255,50,50)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0,0,0)
    text.TextScaled = true
    text.Parent = bill
    
    espConnections[plr] = bill
    
    plr.CharacterRemoving:Connect(function()
        if espConnections[plr] then
            espConnections[plr]:Destroy()
            espConnections[plr] = nil
        end
    end)
end

local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        
        if SETTINGS.ESP_Enabled and plr.Character and plr.Character:FindFirstChild("Head") then
            CreateESP(plr)
        elseif espConnections[plr] then
            espConnections[plr]:Destroy()
            espConnections[plr] = nil
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        UpdateESP()
    end)
end)

RunService.Heartbeat:Connect(UpdateESP)

-- 簡易 Chams (外發光)
spawn(function()
    while true do
        task.wait(0.5)
        
        if not SETTINGS.Chams_Enabled then continue end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer or not plr.Character then continue end
            
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("ChamsHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ChamsHighlight"
                    hl.FillColor = Color3.fromRGB(255, 80, 80)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0
                    hl.Adornee = part
                    hl.Parent = part
                end
            end
        end
    end
end)

print("NukeBot Ultimate 已載入")
