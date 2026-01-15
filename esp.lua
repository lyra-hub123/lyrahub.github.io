--[[
╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
║   ███╗   ██╗██╗   ██╗██╗  ██╗███████╗██████╗  ██████╗ ████████╗    ██╗   ██╗ █████╗             ║
║   ████╗  ██║██║   ██║██║ ██╔╝██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝    ██║   ██║██╔══██╗            ║
║   ██╔██╗ ██║██║   ██║█████╔╝ █████╗  ██████╔╝██║   ██║   ██║       ██║   ██║╚█████╔╝            ║
║   ██║╚██╗██║██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗██║   ██║   ██║       ╚██╗ ██╔╝██╔══██╗            ║
║   ██║ ╚████║╚██████╔╝██║  ██╗███████╗██████╔╝╚██████╔╝   ██║        ╚████╔╝ ╚█████╔╝            ║
║   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝    ╚═╝         ╚═══╝   ╚════╝             ║
║                                                                                                  ║
║   Ultimate Edition v7.0 - Rayfield UI                                                            ║
║   支持遊戲: Blade Ball, Rivals, Arsenal, Da Hood, Blox Fruits, MM2, Phantom Forces              ║
║   功能總數: 100+ 功能模組                                                                        ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              載入 Rayfield UI                               ║
-- ═══════════════════════════════════════════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              服務初始化                                      ║
-- ═══════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              本地變量                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Character, Humanoid, RootPart, Head

local VERSION = "7.0"
local SCRIPT_NAME = "Zy hacker hub"

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              遊戲檢測系統                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

local GameDatabase = {
    [286090429] = {Name = "Arsenal", Type = "FPS", SpeedMult = 1.2, HasTeams = true},
    [17625359962] = {Name = "Rivals", Type = "FPS", SpeedMult = 2.0, HasTeams = true},
    [292439477] = {Name = "Phantom Forces", Type = "FPS", SpeedMult = 1.0, HasTeams = true},
    [13772394625] = {Name = "Blade Ball", Type = "Action", SpeedMult = 1.5, HasTeams = false},
    [2788229376] = {Name = "Da Hood", Type = "Combat", SpeedMult = 1.8, HasTeams = false},
    [6284583030] = {Name = "Blox Fruits", Type = "RPG", SpeedMult = 1.3, HasTeams = false},
    [142823291] = {Name = "Murder Mystery 2", Type = "Horror", SpeedMult = 1.0, HasTeams = false},
}

local CurrentGame = GameDatabase[game.PlaceId] or {Name = "通用", Type = "Unknown", SpeedMult = 1.0, HasTeams = false}

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              設定系統                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local Settings = {
    -- 移動
    Fly = false, FlySpeed = 100, SmoothFly = true,
    Noclip = false, Phase = false, PhaseSpeed = 1,
    Speed = false, SpeedMult = 5,
    InfJump = false, JumpPower = 50, AutoJump = false, BHop = false,
    Spider = false, ClimbSpeed = 50,
    AirWalk = false, ClickTP = false, AntiVoid = false, AutoRespawn = false,
    
    -- 戰鬥
    God = false, SemiGod = false, AntiKB = false, AntiRagdoll = false, AutoHeal = false, HealThreshold = 50,
    KillAura = false, KillRange = 15, KillMode = "Touch", KillDelay = 0.1,
    Hitbox = false, HitboxSize = 10, ShowHitbox = false,
    
    -- 瞄準
    Aimbot = false, AimPart = "Head", AimFOV = 150, AimSmooth = 0.3, AimPrediction = 0,
    TeamCheck = true, VisibleCheck = false, AimLock = false,
    SilentAim = false, SilentPrecision = 5, SilentHitChance = 100,
    TriggerBot = false, TriggerDelay = 0.05, TriggerBurst = false, BurstCount = 3,
    ShowFOV = false, FOVColor = Color3.new(1, 1, 1),
    NoRecoil = false, NoSpread = false, RapidFire = false, InfiniteAmmo = false,
    
    -- ESP
    ESP = false, ESPTeamCheck = false, ESPMaxDist = 2000,
    ESPBox = true, ESPName = true, ESPHealth = true, ESPDist = true, ESPTracer = false, ESPSkeleton = false,
    ESPColor = Color3.new(1, 0, 0), SkeletonColor = Color3.new(1, 1, 0),
    Chams = false, ChamsFill = 0.5, ChamsOutline = 0,
    
    -- 視覺
    Fullbright = false, NoFog = false, NoShadows = false,
    CustomAmbient = false, AmbientColor = Color3.new(1, 1, 1),
    TimeFreeze = false, CustomTime = 14,
    CustomFOV = false, FOVValue = 90,
    ThirdPerson = false, TPDistance = 10,
    NoParticles = false, NoEffects = false, LowGraphics = false,
    ShowCrosshair = false, CrosshairSize = 10, CrosshairColor = Color3.new(0, 1, 0),
    
    -- 世界
    Gravity = 196.2, JumpHeight = 7.2,
    
    -- 雜項
    AntiAFK = true, ChatSpam = false, SpamMessage = "Zy hacker hub v7.0", SpamDelay = 3,
    
    -- 傳送
    SavedPositions = {},
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              工具函數                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local function UpdateChar()
    Character = LocalPlayer.Character
    if Character then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
        Head = Character:FindFirstChild("Head")
    end
    return Character and Humanoid and RootPart
end
UpdateChar()

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    Head = c:WaitForChild("Head")
    
    if Settings.God then Humanoid.MaxHealth = math.huge; Humanoid.Health = math.huge end
    if Settings.Speed then Humanoid.WalkSpeed = 16 * Settings.SpeedMult * CurrentGame.SpeedMult end
    if Settings.JumpPower ~= 50 then Humanoid.JumpPower = Settings.JumpPower end
    
    Humanoid.StateChanged:Connect(function(_, new)
        if Settings.AntiRagdoll and new == Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end)

local function GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local function IsTeammate(player)
    if not Settings.TeamCheck or not CurrentGame.HasTeams then return false end
    return player.Team == LocalPlayer.Team
end

local function IsVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {Character, Camera}
    local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

local function GetDistance(pos)
    if not RootPart then return math.huge end
    return (pos - RootPart.Position).Magnitude
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              按鍵輸入系統                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

local KeysDown = {}
local MouseDown = {}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        KeysDown[input.KeyCode] = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        MouseDown[1] = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        MouseDown[2] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        KeysDown[input.KeyCode] = false
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        MouseDown[1] = false
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        MouseDown[2] = false
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              Rayfield UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local Window = Rayfield:CreateWindow({
    Name = "🔥 " .. SCRIPT_NAME .. " v" .. VERSION .. " [" .. CurrentGame.Name .. "]",
    LoadingTitle = SCRIPT_NAME,
    LoadingSubtitle = "Rayfield Edition",
    ConfigurationSaving = {Enabled = true, FolderName = "ZyHackerHub", FileName = "Config"},
    Discord = {Enabled = false},
    KeySystem = false,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              移動分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local MoveTab = Window:CreateTab("🏃 移動", 4483362458)

-- 飛行變量
local FlyBV, FlyBG, FlyActive = nil, nil, false

MoveTab:CreateSection("✈️ 飛行系統")

MoveTab:CreateToggle({
    Name = "飛行 (Fly)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(v)
        Settings.Fly = v
        FlyActive = v
        if not UpdateChar() then return end
        
        if v then
            FlyBV = Instance.new("BodyVelocity")
            FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBV.Velocity = Vector3.zero
            FlyBV.Parent = RootPart
            
            FlyBG = Instance.new("BodyGyro")
            FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBG.P = 9e4
            FlyBG.Parent = RootPart
            
            Humanoid.PlatformStand = true
            
            Rayfield:Notify({Title = "飛行", Content = "飛行已開啟！WASD移動, Space上升, Ctrl下降, Shift加速", Duration = 3})
        else
            if FlyBV then FlyBV:Destroy(); FlyBV = nil end
            if FlyBG then FlyBG:Destroy(); FlyBG = nil end
            if Humanoid then Humanoid.PlatformStand = false end
        end
    end,
})

MoveTab:CreateSlider({
    Name = "飛行速度",
    Range = {50, 500},
    Increment = 25,
    CurrentValue = 100,
    Flag = "FlySpeed",
    Callback = function(v) Settings.FlySpeed = v end,
})

MoveTab:CreateSection("👻 穿透系統")

MoveTab:CreateToggle({
    Name = "穿牆 (Noclip)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(v)
        Settings.Noclip = v
        if v then Rayfield:Notify({Title = "穿牆", Content = "穿牆已開啟", Duration = 2}) end
    end,
})

MoveTab:CreateToggle({
    Name = "穿地板 (按住 Shift)",
    CurrentValue = false,
    Flag = "PhaseToggle",
    Callback = function(v) Settings.Phase = v end,
})

MoveTab:CreateSlider({
    Name = "穿地速度",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "PhaseSpeed",
    Callback = function(v) Settings.PhaseSpeed = v end,
})

MoveTab:CreateSection("⚡ 速度系統 [" .. CurrentGame.Name .. " x" .. CurrentGame.SpeedMult .. "]")

MoveTab:CreateToggle({
    Name = "速度破解",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(v)
        Settings.Speed = v
        if UpdateChar() and Humanoid then
            Humanoid.WalkSpeed = v and (16 * Settings.SpeedMult * CurrentGame.SpeedMult) or 16
            if v then Rayfield:Notify({Title = "速度", Content = "當前速度: " .. math.floor(Humanoid.WalkSpeed), Duration = 2}) end
        end
    end,
})

MoveTab:CreateSlider({
    Name = "速度倍率",
    Range = {2, 100},
    Increment = 1,
    CurrentValue = 5,
    Flag = "SpeedMult",
    Callback = function(v)
        Settings.SpeedMult = v
        if Settings.Speed and UpdateChar() and Humanoid then
            Humanoid.WalkSpeed = 16 * v * CurrentGame.SpeedMult
        end
    end,
})

MoveTab:CreateSection("🦘 跳躍系統")

MoveTab:CreateToggle({
    Name = "無限跳躍",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(v)
        Settings.InfJump = v
        if v then Rayfield:Notify({Title = "跳躍", Content = "無限跳躍已開啟", Duration = 2}) end
    end,
})

MoveTab:CreateSlider({
    Name = "跳躍力量",
    Range = {50, 500},
    Increment = 25,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(v)
        Settings.JumpPower = v
        if UpdateChar() and Humanoid then Humanoid.JumpPower = v end
    end,
})

MoveTab:CreateToggle({
    Name = "自動跳躍",
    CurrentValue = false,
    Flag = "AutoJumpToggle",
    Callback = function(v) Settings.AutoJump = v end,
})

MoveTab:CreateToggle({
    Name = "連跳 (BHop)",
    CurrentValue = false,
    Flag = "BHopToggle",
    Callback = function(v) Settings.BHop = v end,
})

MoveTab:CreateSection("🕷️ 爬牆系統")

MoveTab:CreateToggle({
    Name = "蜘蛛爬牆",
    CurrentValue = false,
    Flag = "SpiderToggle",
    Callback = function(v)
        Settings.Spider = v
        if v then Rayfield:Notify({Title = "爬牆", Content = "面向牆壁即可攀爬", Duration = 3}) end
    end,
})

MoveTab:CreateSlider({
    Name = "爬牆速度",
    Range = {10, 100},
    Increment = 10,
    CurrentValue = 50,
    Flag = "ClimbSpeed",
    Callback = function(v) Settings.ClimbSpeed = v end,
})

MoveTab:CreateSection("🔧 其他移動功能")

MoveTab:CreateToggle({
    Name = "空中行走",
    CurrentValue = false,
    Flag = "AirWalkToggle",
    Callback = function(v) Settings.AirWalk = v end,
})

MoveTab:CreateToggle({
    Name = "點擊傳送",
    CurrentValue = false,
    Flag = "ClickTPToggle",
    Callback = function(v)
        Settings.ClickTP = v
        if v then Rayfield:Notify({Title = "傳送", Content = "點擊地面即可傳送", Duration = 2}) end
    end,
})

MoveTab:CreateToggle({
    Name = "防掉落虛空",
    CurrentValue = false,
    Flag = "AntiVoidToggle",
    Callback = function(v) Settings.AntiVoid = v end,
})

MoveTab:CreateToggle({
    Name = "自動重生",
    CurrentValue = false,
    Flag = "AutoRespawnToggle",
    Callback = function(v) Settings.AutoRespawn = v end,
})

print("[Zy hacker hub] 移動分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              戰鬥分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local CombatTab = Window:CreateTab("⚔️ 戰鬥", 4483362458)

CombatTab:CreateSection("🛡️ 防禦系統")

CombatTab:CreateToggle({
    Name = "無敵模式 (God Mode)",
    CurrentValue = false,
    Flag = "GodToggle",
    Callback = function(v)
        Settings.God = v
        if UpdateChar() and Humanoid then
            if v then
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
                Rayfield:Notify({Title = "無敵", Content = "無敵模式已開啟", Duration = 2})
            else
                Humanoid.MaxHealth = 100
                Humanoid.Health = 100
            end
        end
    end,
})

CombatTab:CreateToggle({
    Name = "半無敵 (自動回血)",
    CurrentValue = false,
    Flag = "SemiGodToggle",
    Callback = function(v) Settings.SemiGod = v end,
})

CombatTab:CreateToggle({
    Name = "抗擊退",
    CurrentValue = false,
    Flag = "AntiKBToggle",
    Callback = function(v) Settings.AntiKB = v end,
})

CombatTab:CreateToggle({
    Name = "防倒地",
    CurrentValue = false,
    Flag = "AntiRagdollToggle",
    Callback = function(v) Settings.AntiRagdoll = v end,
})

CombatTab:CreateToggle({
    Name = "自動治療",
    CurrentValue = false,
    Flag = "AutoHealToggle",
    Callback = function(v) Settings.AutoHeal = v end,
})

CombatTab:CreateSlider({
    Name = "治療閾值 (%)",
    Range = {10, 90},
    Increment = 10,
    CurrentValue = 50,
    Flag = "HealThreshold",
    Callback = function(v) Settings.HealThreshold = v end,
})

CombatTab:CreateSection("💀 Kill Aura")

CombatTab:CreateToggle({
    Name = "Kill Aura 開關",
    CurrentValue = false,
    Flag = "KillAuraToggle",
    Callback = function(v)
        Settings.KillAura = v
        if v then Rayfield:Notify({Title = "Kill Aura", Content = "Kill Aura 已啟動", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "攻擊範圍",
    Range = {5, 100},
    Increment = 5,
    CurrentValue = 15,
    Flag = "KillRange",
    Callback = function(v) Settings.KillRange = v end,
})

CombatTab:CreateDropdown({
    Name = "攻擊模式",
    Options = {"Touch", "TP", "Fling", "Punch"},
    CurrentOption = {"Touch"},
    Flag = "KillMode",
    Callback = function(v) Settings.KillMode = v end,
})

CombatTab:CreateSlider({
    Name = "攻擊間隔 (秒)",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Flag = "KillDelay",
    Callback = function(v) Settings.KillDelay = v end,
})

CombatTab:CreateSection("📦 Hitbox 擴展")

CombatTab:CreateToggle({
    Name = "Hitbox 擴展器",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(v)
        Settings.Hitbox = v
        if v then Rayfield:Notify({Title = "Hitbox", Content = "Hitbox 擴展已開啟", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "Hitbox 大小",
    Range = {5, 50},
    Increment = 5,
    CurrentValue = 10,
    Flag = "HitboxSize",
    Callback = function(v) Settings.HitboxSize = v end,
})

CombatTab:CreateToggle({
    Name = "顯示 Hitbox",
    CurrentValue = false,
    Flag = "ShowHitbox",
    Callback = function(v) Settings.ShowHitbox = v end,
})

print("[Zy hacker hub] 戰鬥分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              瞄準分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local AimTab = Window:CreateTab("🎯 瞄準", 4483362458)

AimTab:CreateSection("🎯 Aimbot (按住右鍵)")

AimTab:CreateToggle({
    Name = "Aimbot 開關",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(v)
        Settings.Aimbot = v
        if v then Rayfield:Notify({Title = "Aimbot", Content = "按住右鍵瞄準最近敵人", Duration = 3}) end
    end,
})

AimTab:CreateDropdown({
    Name = "瞄準部位",
    Options = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    Flag = "AimPart",
    Callback = function(v) Settings.AimPart = v end,
})

AimTab:CreateSlider({
    Name = "瞄準 FOV",
    Range = {50, 500},
    Increment = 25,
    CurrentValue = 150,
    Flag = "AimFOV",
    Callback = function(v) Settings.AimFOV = v end,
})

AimTab:CreateSlider({
    Name = "平滑度 (越低越快)",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = 0.3,
    Flag = "AimSmooth",
    Callback = function(v) Settings.AimSmooth = v end,
})

AimTab:CreateSlider({
    Name = "預測值",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = 0,
    Flag = "AimPrediction",
    Callback = function(v) Settings.AimPrediction = v end,
})

AimTab:CreateToggle({
    Name = "隊伍檢查",
    CurrentValue = true,
    Flag = "TeamCheckToggle",
    Callback = function(v) Settings.TeamCheck = v end,
})

AimTab:CreateToggle({
    Name = "可見檢查",
    CurrentValue = false,
    Flag = "VisibleCheckToggle",
    Callback = function(v) Settings.VisibleCheck = v end,
})

AimTab:CreateToggle({
    Name = "鎖定目標",
    CurrentValue = false,
    Flag = "AimLockToggle",
    Callback = function(v) Settings.AimLock = v end,
})

AimTab:CreateSection("🔇 Silent Aim")

AimTab:CreateToggle({
    Name = "Silent Aim 開關",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(v)
        Settings.SilentAim = v
        if v then Rayfield:Notify({Title = "Silent Aim", Content = "靜默瞄準已開啟", Duration = 2}) end
    end,
})

AimTab:CreateSlider({
    Name = "精準度",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 5,
    Flag = "SilentPrecision",
    Callback = function(v) Settings.SilentPrecision = v end,
})

AimTab:CreateSlider({
    Name = "命中率 (%)",
    Range = {10, 100},
    Increment = 10,
    CurrentValue = 100,
    Flag = "SilentHitChance",
    Callback = function(v) Settings.SilentHitChance = v end,
})

AimTab:CreateSection("🔫 TriggerBot")

AimTab:CreateToggle({
    Name = "TriggerBot 開關",
    CurrentValue = false,
    Flag = "TriggerBotToggle",
    Callback = function(v)
        Settings.TriggerBot = v
        if v then Rayfield:Notify({Title = "TriggerBot", Content = "自動開槍已開啟", Duration = 2}) end
    end,
})

AimTab:CreateSlider({
    Name = "觸發延遲 (秒)",
    Range = {0, 0.5},
    Increment = 0.01,
    CurrentValue = 0.05,
    Flag = "TriggerDelay",
    Callback = function(v) Settings.TriggerDelay = v end,
})

AimTab:CreateToggle({
    Name = "連射模式",
    CurrentValue = false,
    Flag = "TriggerBurstToggle",
    Callback = function(v) Settings.TriggerBurst = v end,
})

AimTab:CreateSlider({
    Name = "連射數量",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 3,
    Flag = "BurstCount",
    Callback = function(v) Settings.BurstCount = v end,
})

AimTab:CreateSection("⭕ FOV 圓圈")

AimTab:CreateToggle({
    Name = "顯示 FOV 圓圈",
    CurrentValue = false,
    Flag = "ShowFOVToggle",
    Callback = function(v) Settings.ShowFOV = v end,
})

AimTab:CreateColorPicker({
    Name = "圓圈顏色",
    Color = Color3.new(1, 1, 1),
    Flag = "FOVColor",
    Callback = function(v) Settings.FOVColor = v end,
})

AimTab:CreateSection("🔧 武器輔助")

AimTab:CreateToggle({
    Name = "無後座力",
    CurrentValue = false,
    Flag = "NoRecoilToggle",
    Callback = function(v) Settings.NoRecoil = v end,
})

AimTab:CreateToggle({
    Name = "無散射",
    CurrentValue = false,
    Flag = "NoSpreadToggle",
    Callback = function(v) Settings.NoSpread = v end,
})

AimTab:CreateToggle({
    Name = "連射",
    CurrentValue = false,
    Flag = "RapidFireToggle",
    Callback = function(v) Settings.RapidFire = v end,
})

AimTab:CreateToggle({
    Name = "無限子彈",
    CurrentValue = false,
    Flag = "InfiniteAmmoToggle",
    Callback = function(v) Settings.InfiniteAmmo = v end,
})

print("[Zy hacker hub] 瞄準分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              ESP 分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)

local ESPStorage = {}

ESPTab:CreateSection("👀 ESP 主設定")

ESPTab:CreateToggle({
    Name = "ESP 開關",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(v)
        Settings.ESP = v
        if not v then
            for _, data in pairs(ESPStorage) do
                pcall(function()
                    if data.Highlight then data.Highlight:Destroy() end
                    if data.Billboard then data.Billboard:Destroy() end
                end)
            end
            ESPStorage = {}
        else
            Rayfield:Notify({Title = "ESP", Content = "ESP 已開啟", Duration = 2})
        end
    end,
})

ESPTab:CreateToggle({
    Name = "隊伍檢查",
    CurrentValue = false,
    Flag = "ESPTeamCheck",
    Callback = function(v) Settings.ESPTeamCheck = v end,
})

ESPTab:CreateSlider({
    Name = "最大距離",
    Range = {100, 5000},
    Increment = 100,
    CurrentValue = 2000,
    Flag = "ESPMaxDist",
    Callback = function(v) Settings.ESPMaxDist = v end,
})

ESPTab:CreateSection("👤 玩家 ESP")

ESPTab:CreateToggle({
    Name = "方框",
    CurrentValue = true,
    Flag = "ESPBox",
    Callback = function(v) Settings.ESPBox = v end,
})

ESPTab:CreateToggle({
    Name = "名稱",
    CurrentValue = true,
    Flag = "ESPName",
    Callback = function(v) Settings.ESPName = v end,
})

ESPTab:CreateToggle({
    Name = "血量",
    CurrentValue = true,
    Flag = "ESPHealth",
    Callback = function(v) Settings.ESPHealth = v end,
})

ESPTab:CreateToggle({
    Name = "距離",
    CurrentValue = true,
    Flag = "ESPDist",
    Callback = function(v) Settings.ESPDist = v end,
})

ESPTab:CreateToggle({
    Name = "追蹤線",
    CurrentValue = false,
    Flag = "ESPTracer",
    Callback = function(v) Settings.ESPTracer = v end,
})

ESPTab:CreateToggle({
    Name = "骨架",
    CurrentValue = false,
    Flag = "ESPSkeleton",
    Callback = function(v) Settings.ESPSkeleton = v end,
})

ESPTab:CreateSection("🎨 ESP 顏色")

ESPTab:CreateColorPicker({
    Name = "ESP 顏色",
    Color = Color3.new(1, 0, 0),
    Flag = "ESPColor",
    Callback = function(v) Settings.ESPColor = v end,
})

ESPTab:CreateColorPicker({
    Name = "骨架顏色",
    Color = Color3.new(1, 1, 0),
    Flag = "SkeletonColor",
    Callback = function(v) Settings.SkeletonColor = v end,
})

ESPTab:CreateSection("✨ Chams (透視高亮)")

ESPTab:CreateToggle({
    Name = "Chams 開關",
    CurrentValue = false,
    Flag = "ChamsToggle",
    Callback = function(v) Settings.Chams = v end,
})

ESPTab:CreateSlider({
    Name = "填充透明度",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "ChamsFill",
    Callback = function(v) Settings.ChamsFill = v end,
})

ESPTab:CreateSlider({
    Name = "輪廓透明度",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0,
    Flag = "ChamsOutline",
    Callback = function(v) Settings.ChamsOutline = v end,
})

print("[Zy hacker hub] ESP 分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              視覺分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local VisualTab = Window:CreateTab("🎨 視覺", 4483362458)

VisualTab:CreateSection("☀️ 光照效果")

VisualTab:CreateToggle({
    Name = "全亮 (Fullbright)",
    CurrentValue = false,
    Flag = "FullbrightToggle",
    Callback = function(v)
        Settings.Fullbright = v
        if v then
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e9
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1e5
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end,
})

VisualTab:CreateToggle({
    Name = "無霧",
    CurrentValue = false,
    Flag = "NoFogToggle",
    Callback = function(v)
        Settings.NoFog = v
        Lighting.FogEnd = v and 1e9 or 1e5
        Lighting.FogStart = v and 1e9 or 0
    end,
})

VisualTab:CreateToggle({
    Name = "無陰影",
    CurrentValue = false,
    Flag = "NoShadowsToggle",
    Callback = function(v)
        Settings.NoShadows = v
        Lighting.GlobalShadows = not v
    end,
})

VisualTab:CreateSection("🕐 時間設定")

VisualTab:CreateToggle({
    Name = "時間凍結",
    CurrentValue = false,
    Flag = "TimeFreezeToggle",
    Callback = function(v) Settings.TimeFreeze = v end,
})

VisualTab:CreateSlider({
    Name = "時間",
    Range = {0, 24},
    Increment = 1,
    CurrentValue = 14,
    Flag = "CustomTime",
    Callback = function(v)
        Settings.CustomTime = v
        Lighting.ClockTime = v
    end,
})

VisualTab:CreateSection("📷 視野設定")

VisualTab:CreateToggle({
    Name = "自訂 FOV",
    CurrentValue = false,
    Flag = "CustomFOVToggle",
    Callback = function(v) Settings.CustomFOV = v end,
})

VisualTab:CreateSlider({
    Name = "FOV 值",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = 90,
    Flag = "FOVValue",
    Callback = function(v)
        Settings.FOVValue = v
        if Settings.CustomFOV then Camera.FieldOfView = v end
    end,
})

VisualTab:CreateSection("👤 第三人稱")

VisualTab:CreateToggle({
    Name = "第三人稱視角",
    CurrentValue = false,
    Flag = "ThirdPersonToggle",
    Callback = function(v)
        Settings.ThirdPerson = v
        if v then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = Settings.TPDistance
            LocalPlayer.CameraMinZoomDistance = Settings.TPDistance
        else
            LocalPlayer.CameraMaxZoomDistance = 400
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end,
})

VisualTab:CreateSlider({
    Name = "視角距離",
    Range = {5, 50},
    Increment = 5,
    CurrentValue = 10,
    Flag = "TPDistance",
    Callback = function(v)
        Settings.TPDistance = v
        if Settings.ThirdPerson then
            LocalPlayer.CameraMaxZoomDistance = v
            LocalPlayer.CameraMinZoomDistance = v
        end
    end,
})

VisualTab:CreateSection("⚡ 效能優化")

VisualTab:CreateToggle({
    Name = "移除粒子效果",
    CurrentValue = false,
    Flag = "NoParticlesToggle",
    Callback = function(v)
        Settings.NoParticles = v
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = not v
            end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "移除視覺效果",
    CurrentValue = false,
    Flag = "NoEffectsToggle",
    Callback = function(v)
        Settings.NoEffects = v
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or 
               obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = not v
            end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "低畫質模式",
    CurrentValue = false,
    Flag = "LowGraphicsToggle",
    Callback = function(v)
        Settings.LowGraphics = v
        if v then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end,
})

VisualTab:CreateButton({
    Name = "移除所有效果",
    Callback = function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or 
               v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or
               v:IsA("ColorCorrectionEffect") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
        Rayfield:Notify({Title = "視覺", Content = "已移除所有視覺效果", Duration = 2})
    end,
})

VisualTab:CreateSection("🌤️ 快速環境")

VisualTab:CreateButton({
    Name = "白天模式",
    Callback = function()
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    end,
})

VisualTab:CreateButton({
    Name = "夜晚模式",
    Callback = function()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.fromRGB(50, 50, 80)
    end,
})

VisualTab:CreateButton({
    Name = "夜視模式",
    Callback = function()
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
        Rayfield:Notify({Title = "視覺", Content = "夜視模式已開啟", Duration = 2})
    end,
})

VisualTab:CreateButton({
    Name = "血月模式",
    Callback = function()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.new(0.5, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0, 0)
        Rayfield:Notify({Title = "視覺", Content = "血月模式已開啟", Duration = 2})
    end,
})

print("[Zy hacker hub] 視覺分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              傳送分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local TPTab = Window:CreateTab("🌀 傳送", 4483362458)

local TargetPlayer = nil

TPTab:CreateSection("👤 玩家傳送")

TPTab:CreateDropdown({
    Name = "選擇玩家",
    Options = GetPlayerList(),
    CurrentOption = {},
    Flag = "TargetPlayer",
    Callback = function(v) TargetPlayer = v end,
})

TPTab:CreateButton({
    Name = "傳送到選擇的玩家",
    Callback = function()
        if not TargetPlayer then
            Rayfield:Notify({Title = "錯誤", Content = "請先選擇玩家", Duration = 2})
            return
        end
        local player = Players:FindFirstChild(TargetPlayer)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if UpdateChar() then
                RootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                Rayfield:Notify({Title = "傳送", Content = "已傳送到 " .. TargetPlayer, Duration = 2})
            end
        end
    end,
})

TPTab:CreateButton({
    Name = "傳送到隨機玩家",
    Callback = function()
        local players = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(players, p) end
        end
        if #players == 0 then return end
        local rp = players[math.random(1, #players)]
        if rp.Character and rp.Character:FindFirstChild("HumanoidRootPart") and UpdateChar() then
            RootPart.CFrame = rp.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            Rayfield:Notify({Title = "傳送", Content = "已傳送到 " .. rp.Name, Duration = 2})
        end
    end,
})

TPTab:CreateSection("📍 位置系統")

TPTab:CreateButton({
    Name = "儲存當前位置",
    Callback = function()
        if UpdateChar() then
            table.insert(Settings.SavedPositions, RootPart.CFrame)
            Rayfield:Notify({Title = "位置", Content = "已儲存位置 #" .. #Settings.SavedPositions, Duration = 2})
        end
    end,
})

TPTab:CreateButton({
    Name = "傳送到上個儲存位置",
    Callback = function()
        if #Settings.SavedPositions == 0 then
            Rayfield:Notify({Title = "錯誤", Content = "沒有儲存的位置", Duration = 2})
            return
        end
        if UpdateChar() then
            RootPart.CFrame = Settings.SavedPositions[#Settings.SavedPositions]
            Rayfield:Notify({Title = "傳送", Content = "已傳送到儲存位置", Duration = 2})
        end
    end,
})

TPTab:CreateButton({
    Name = "清除所有儲存位置",
    Callback = function()
        Settings.SavedPositions = {}
        Rayfield:Notify({Title = "位置", Content = "已清除所有儲存位置", Duration = 2})
    end,
})

TPTab:CreateSection("⚡ 快速傳送")

TPTab:CreateButton({
    Name = "傳送到地圖中心",
    Callback = function()
        if UpdateChar() then RootPart.CFrame = CFrame.new(0, 100, 0) end
    end,
})

TPTab:CreateButton({
    Name = "傳送到天空",
    Callback = function()
        if UpdateChar() then RootPart.CFrame = RootPart.CFrame + Vector3.new(0, 500, 0) end
    end,
})

TPTab:CreateButton({
    Name = "傳送到地底",
    Callback = function()
        if UpdateChar() then RootPart.CFrame = RootPart.CFrame - Vector3.new(0, 100, 0) end
    end,
})

print("[Zy hacker hub] 傳送分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              世界分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local WorldTab = Window:CreateTab("🌍 世界", 4483362458)

WorldTab:CreateSection("⚙️ 物理設定")

WorldTab:CreateSlider({
    Name = "重力",
    Range = {0, 500},
    Increment = 20,
    CurrentValue = 196,
    Flag = "Gravity",
    Callback = function(v)
        Settings.Gravity = v
        Workspace.Gravity = v
    end,
})

WorldTab:CreateSlider({
    Name = "跳躍高度",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 7,
    Flag = "JumpHeight",
    Callback = function(v)
        Settings.JumpHeight = v
        if UpdateChar() and Humanoid then Humanoid.JumpHeight = v end
    end,
})

WorldTab:CreateButton({
    Name = "重設物理",
    Callback = function()
        Workspace.Gravity = 196.2
        if UpdateChar() and Humanoid then Humanoid.JumpHeight = 7.2 end
        Rayfield:Notify({Title = "世界", Content = "已重設物理", Duration = 2})
    end,
})

WorldTab:CreateButton({
    Name = "重設環境",
    Callback = function()
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Rayfield:Notify({Title = "世界", Content = "已重設環境", Duration = 2})
    end,
})

print("[Zy hacker hub] 世界分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              雜項分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local MiscTab = Window:CreateTab("⚙️ 雜項", 4483362458)

MiscTab:CreateSection("🛡️ 防護功能")

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFKToggle",
    Callback = function(v) Settings.AntiAFK = v end,
})

MiscTab:CreateSection("💬 聊天功能")

MiscTab:CreateToggle({
    Name = "聊天刷屏",
    CurrentValue = false,
    Flag = "ChatSpamToggle",
    Callback = function(v) Settings.ChatSpam = v end,
})

MiscTab:CreateInput({
    Name = "刷屏訊息",
    PlaceholderText = "輸入刷屏訊息",
    RemoveTextAfterFocusLost = false,
    Flag = "SpamMessage",
    Callback = function(v) Settings.SpamMessage = v end,
})

MiscTab:CreateSlider({
    Name = "刷屏間隔 (秒)",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 3,
    Flag = "SpamDelay",
    Callback = function(v) Settings.SpamDelay = v end,
})

MiscTab:CreateSection("🌐 伺服器功能")

MiscTab:CreateButton({
    Name = "重新加入伺服器",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

MiscTab:CreateButton({
    Name = "跳轉伺服器",
    Callback = function()
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and servers and servers.data then
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end
    end,
})

MiscTab:CreateSection("👤 角色功能")

MiscTab:CreateButton({
    Name = "重生",
    Callback = function()
        if UpdateChar() and Humanoid then Humanoid.Health = 0 end
    end,
})

MiscTab:CreateButton({
    Name = "重設角色屬性",
    Callback = function()
        if UpdateChar() and Humanoid then
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
            Settings.Speed = false
            Settings.Fly = false
            Settings.Noclip = false
            Settings.God = false
            Rayfield:Notify({Title = "角色", Content = "已重設所有屬性", Duration = 2})
        end
    end,
})

MiscTab:CreateButton({
    Name = "複製位置座標",
    Callback = function()
        if UpdateChar() then
            local pos = RootPart.Position
            local str = string.format("CFrame.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
            if setclipboard then
                setclipboard(str)
                Rayfield:Notify({Title = "複製", Content = "位置已複製到剪貼簿", Duration = 2})
            end
        end
    end,
})

MiscTab:CreateSection("📊 遊戲資訊")

MiscTab:CreateButton({
    Name = "顯示遊戲資訊",
    Callback = function()
        Rayfield:Notify({
            Title = "遊戲資訊",
            Content = "遊戲: " .. CurrentGame.Name .. "\nID: " .. game.PlaceId .. "\n玩家: " .. #Players:GetPlayers(),
            Duration = 10
        })
    end,
})

print("[Zy hacker hub] 雜項分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              設定分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local SettingsTab = Window:CreateTab("📁 設定", 4483362458)

SettingsTab:CreateSection("ℹ️ 腳本資訊")

SettingsTab:CreateParagraph({
    Title = SCRIPT_NAME .. " v" .. VERSION,
    Content = "遊戲: " .. CurrentGame.Name .. " (" .. CurrentGame.Type .. ")\n按 RightShift 開關 UI\n功能: 100+ 模組"
})

SettingsTab:CreateKeybind({
    Name = "開關 UI 快捷鍵",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Flag = "UIKeybind",
    Callback = function() end,
})

SettingsTab:CreateButton({
    Name = "關閉腳本",
    Callback = function()
        Rayfield:Destroy()
    end,
})

print("[Zy hacker hub] 設定分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              核心邏輯系統                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 正在載入核心邏輯...")

-- === 飛行邏輯 ===
RunService.Heartbeat:Connect(function()
    if FlyActive and FlyBV and FlyBG then
        if not UpdateChar() then return end
        
        local cf = Camera.CFrame
        local dir = Vector3.zero
        
        if KeysDown[Enum.KeyCode.W] then dir = dir + cf.LookVector end
        if KeysDown[Enum.KeyCode.S] then dir = dir - cf.LookVector end
        if KeysDown[Enum.KeyCode.A] then dir = dir - cf.RightVector end
        if KeysDown[Enum.KeyCode.D] then dir = dir + cf.RightVector end
        if KeysDown[Enum.KeyCode.Space] then dir = dir + Vector3.yAxis end
        if KeysDown[Enum.KeyCode.LeftControl] then dir = dir - Vector3.yAxis end
        
        local speed = Settings.FlySpeed
        if KeysDown[Enum.KeyCode.LeftShift] then speed = speed * 3 end
        
        FlyBV.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
        FlyBG.CFrame = cf
    end
end)

-- === Noclip 邏輯 ===
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        if not UpdateChar() then return end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- === 穿地板 ===
RunService.Heartbeat:Connect(function()
    if Settings.Phase and KeysDown[Enum.KeyCode.LeftShift] then
        if UpdateChar() then
            RootPart.CFrame = RootPart.CFrame - Vector3.new(0, Settings.PhaseSpeed, 0)
        end
    end
end)

-- === 速度保持 ===
RunService.Heartbeat:Connect(function()
    if Settings.Speed and UpdateChar() and Humanoid then
        local target = 16 * Settings.SpeedMult * CurrentGame.SpeedMult
        if Humanoid.WalkSpeed ~= target then
            Humanoid.WalkSpeed = target
        end
    end
end)

-- === 無限跳躍 ===
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and UpdateChar() and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === 自動跳躍 ===
RunService.Heartbeat:Connect(function()
    if Settings.AutoJump and UpdateChar() and Humanoid then
        Humanoid.Jump = true
    end
end)

-- === 連跳 ===
RunService.Heartbeat:Connect(function()
    if Settings.BHop and UpdateChar() and Humanoid then
        if Humanoid.FloorMaterial ~= Enum.Material.Air then
            Humanoid.Jump = true
        end
    end
end)

-- === 蜘蛛爬牆 ===
RunService.Heartbeat:Connect(function()
    if Settings.Spider and UpdateChar() then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {Character}
        local result = Workspace:Raycast(RootPart.Position, RootPart.CFrame.LookVector * 2.5, params)
        if result then
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, Settings.ClimbSpeed, RootPart.Velocity.Z)
        end
    end
end)

-- === 空中行走 ===
local AirPlatform = nil
RunService.Heartbeat:Connect(function()
    if Settings.AirWalk then
        if not UpdateChar() then return end
        if not AirPlatform then
            AirPlatform = Instance.new("Part")
            AirPlatform.Size = Vector3.new(5, 0.5, 5)
            AirPlatform.Transparency = 1
            AirPlatform.Anchored = true
            AirPlatform.CanCollide = true
            AirPlatform.Parent = Workspace
        end
        AirPlatform.CFrame = RootPart.CFrame * CFrame.new(0, -3.5, 0)
    else
        if AirPlatform then AirPlatform:Destroy(); AirPlatform = nil end
    end
end)

-- === 點擊傳送 ===
Mouse.Button1Down:Connect(function()
    if Settings.ClickTP and UpdateChar() and Mouse.Target then
        RootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
    end
end)

-- === 防掉落 ===
RunService.Heartbeat:Connect(function()
    if Settings.AntiVoid and UpdateChar() and RootPart.Position.Y < -50 then
        RootPart.CFrame = CFrame.new(0, 100, 0)
    end
end)

-- === 半無敵 ===
RunService.Heartbeat:Connect(function()
    if Settings.SemiGod and UpdateChar() and Humanoid then
        Humanoid.Health = Humanoid.MaxHealth
    end
end)

-- === 抗擊退 ===
RunService.Heartbeat:Connect(function()
    if Settings.AntiKB and UpdateChar() and RootPart then
        RootPart.Velocity = Vector3.new(0, RootPart.Velocity.Y, 0)
        RootPart.RotVelocity = Vector3.zero
    end
end)

-- === Kill Aura ===
spawn(function()
    while true do
        task.wait(Settings.KillDelay)
        if Settings.KillAura and UpdateChar() then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = GetDistance(hrp.Position)
                        if dist <= Settings.KillRange then
                            if Settings.KillMode == "Touch" then
                                pcall(function()
                                    if firetouchinterest then
                                        firetouchinterest(RootPart, hrp, 0)
                                        task.wait()
                                        firetouchinterest(RootPart, hrp, 1)
                                    end
                                end)
                            elseif Settings.KillMode == "TP" then
                                pcall(function()
                                    local old = RootPart.CFrame
                                    RootPart.CFrame = hrp.CFrame
                                    task.wait()
                                    RootPart.CFrame = old
                                end)
                            elseif Settings.KillMode == "Fling" then
                                pcall(function()
                                    hrp.Velocity = Vector3.new(math.random(-1000, 1000), 500, math.random(-1000, 1000))
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- === Hitbox 擴展 ===
spawn(function()
    while task.wait(0.2) do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if Settings.Hitbox then
                        hrp.Size = Vector3.one * Settings.HitboxSize
                        hrp.Transparency = Settings.ShowHitbox and 0.5 or 1
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end
end)

-- === Aimbot ===
local function GetClosest()
    local closest, minDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if Settings.TeamCheck and IsTeammate(player) then continue end
            
            local part = player.Character:FindFirstChild(Settings.AimPart) or player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if part and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < Settings.AimFOV and dist < minDist then
                        if Settings.VisibleCheck and not IsVisible(part) then continue end
                        closest, minDist = part, dist
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot and MouseDown[2] then
        local target = GetClosest()
        if target then
            local targetPos = target.Position
            if Settings.AimPrediction > 0 then
                local vel = target.Parent:FindFirstChild("HumanoidRootPart")
                if vel then targetPos = targetPos + (vel.Velocity * Settings.AimPrediction * 0.01) end
            end
            local cf = CFrame.lookAt(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(cf, Settings.AimSmooth)
        end
    end
    
    if Settings.CustomFOV then
        Camera.FieldOfView = Settings.FOVValue
    end
    
    if Settings.TimeFreeze then
        Lighting.ClockTime = Settings.CustomTime
    end
end)

-- === TriggerBot ===
spawn(function()
    while task.wait(0.01) do
        if Settings.TriggerBot and UpdateChar() then
            local target = Mouse.Target
            if target then
                local player = Players:GetPlayerFromCharacter(target:FindFirstAncestorOfClass("Model"))
                if player and player ~= LocalPlayer then
                    if Settings.TeamCheck and IsTeammate(player) then continue end
                    task.wait(Settings.TriggerDelay)
                    if Settings.TriggerBurst then
                        for i = 1, Settings.BurstCount do
                            if mouse1click then mouse1click() end
                            task.wait(0.05)
                        end
                    else
                        if mouse1click then mouse1click() end
                    end
                end
            end
        end
    end
end)

-- === ESP 創建 ===
local function CreateESP(player)
    if player == LocalPlayer or ESPStorage[player] then return end
    local char = player.Character
    if not char then return end
    
    local data = {}
    
    local hl = Instance.new("Highlight")
    hl.FillColor = Settings.ESPColor
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.6
    hl.Adornee = char
    hl.Parent = char
    data.Highlight = hl
    
    local head = char:FindFirstChild("Head")
    if head then
        local bb = Instance.new("BillboardGui")
        bb.Adornee = head
        bb.Size = UDim2.new(0, 200, 0, 80)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = head
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Parent = bb
        
        local layout = Instance.new("UIListLayout")
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Parent = container
        
        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, 0, 0, 18)
        name.BackgroundTransparency = 1
        name.TextColor3 = Color3.new(1, 1, 1)
        name.TextStrokeTransparency = 0
        name.Font = Enum.Font.GothamBold
        name.TextSize = 14
        name.Text = player.Name
        name.Parent = container
        
        local health = Instance.new("TextLabel")
        health.Name = "Health"
        health.Size = UDim2.new(1, 0, 0, 16)
        health.BackgroundTransparency = 1
        health.TextColor3 = Color3.new(0, 1, 0)
        health.TextStrokeTransparency = 0
        health.Font = Enum.Font.Gotham
        health.TextSize = 12
        health.Parent = container
        
        local dist = Instance.new("TextLabel")
        dist.Name = "Distance"
        dist.Size = UDim2.new(1, 0, 0, 16)
        dist.BackgroundTransparency = 1
        dist.TextColor3 = Color3.new(1, 1, 0)
        dist.TextStrokeTransparency = 0
        dist.Font = Enum.Font.Gotham
        dist.TextSize = 12
        dist.Parent = container
        
        data.Billboard = bb
    end
    
    ESPStorage[player] = data
end

-- === ESP 更新 ===
RunService.Heartbeat:Connect(function()
    if not Settings.ESP or not UpdateChar() then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if Settings.ESPTeamCheck and IsTeammate(player) then continue end
            
            if not ESPStorage[player] then CreateESP(player) end
            
            local data = ESPStorage[player]
            if not data then continue end
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum then
                local d = math.floor(GetDistance(hrp.Position))
                
                if d > Settings.ESPMaxDist then
                    if data.Highlight then data.Highlight.Enabled = false end
                    if data.Billboard then data.Billboard.Enabled = false end
                    continue
                else
                    if data.Highlight then data.Highlight.Enabled = true end
                    if data.Billboard then data.Billboard.Enabled = true end
                end
                
                if data.Highlight then
                    if d < 30 then
                        data.Highlight.FillColor = Color3.new(1, 0, 0)
                    elseif d < 60 then
                        data.Highlight.FillColor = Color3.new(1, 1, 0)
                    else
                        data.Highlight.FillColor = Color3.new(0, 1, 0)
                    end
                end
                
                if data.Billboard then
                    local hp = data.Billboard:FindFirstChild("Health", true)
                    local dst = data.Billboard:FindFirstChild("Distance", true)
                    if hp then
                        hp.Text = "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                        local pct = hum.Health / hum.MaxHealth
                        hp.TextColor3 = Color3.new(1 - pct, pct, 0)
                    end
                    if dst then dst.Text = d .. " studs" end
                end
            end
        end
    end
end)

-- === Chams ===
spawn(function()
    while task.wait(0.3) do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = player.Character:FindFirstChild("Chams_HL")
                if Settings.Chams then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "Chams_HL"
                        hl.FillColor = Settings.ESPColor
                        hl.OutlineColor = Color3.new(1, 1, 0)
                        hl.FillTransparency = Settings.ChamsFill
                        hl.OutlineTransparency = Settings.ChamsOutline
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = player.Character
                    else
                        hl.FillTransparency = Settings.ChamsFill
                        hl.OutlineTransparency = Settings.ChamsOutline
                    end
                elseif hl then
                    hl:Destroy()
                end
            end
        end
    end
end)

-- === 清理 ===
Players.PlayerRemoving:Connect(function(player)
    if ESPStorage[player] then
        pcall(function()
            if ESPStorage[player].Highlight then ESPStorage[player].Highlight:Destroy() end
            if ESPStorage[player].Billboard then ESPStorage[player].Billboard:Destroy() end
        end)
        ESPStorage[player] = nil
    end
end)

-- === Anti-AFK ===
spawn(function()
    while task.wait(120) do
        if Settings.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- === 聊天刷屏 ===
spawn(function()
    while true do
        task.wait(Settings.SpamDelay)
        if Settings.ChatSpam then
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              初始化完成                                      ║
-- ═══════════════════════════════════════════════════════════════════════════════

Rayfield:Notify({
    Title = "🔥 " .. SCRIPT_NAME .. " v" .. VERSION,
    Content = "已成功載入！\n遊戲: " .. CurrentGame.Name .. "\n按 RightShift 開關 UI\n100+ 功能模組",
    Duration = 10,
})

print("═══════════════════════════════════════════════════════════════")
print("   " .. SCRIPT_NAME .. " v" .. VERSION .. " 已成功載入!")
print("   遊戲: " .. CurrentGame.Name .. " (" .. CurrentGame.Type .. ")")
print("   功能: 100+ 模組")
print("═══════════════════════════════════════════════════════════════")
print("[Zy hacker hub] 所有系統已就緒!")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              進階功能模組                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入進階功能模組...")

-- === FOV 圓圈 (Drawing API) ===
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Radius = Settings.AimFOV
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
    FOVCircle.Color = Settings.FOVColor
    FOVCircle.Visible = false
end)

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Visible = Settings.ShowFOV
        FOVCircle.Radius = Settings.AimFOV
        FOVCircle.Color = Settings.FOVColor
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

-- === 準心 (Crosshair) ===
local CrosshairLines = {}
pcall(function()
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.new(0, 1, 0)
        line.Visible = false
        table.insert(CrosshairLines, line)
    end
end)

RunService.RenderStepped:Connect(function()
    if #CrosshairLines == 4 then
        local visible = Settings.ShowCrosshair
        local cx = Camera.ViewportSize.X / 2
        local cy = Camera.ViewportSize.Y / 2
        local size = Settings.CrosshairSize
        local gap = 5
        
        -- 上
        CrosshairLines[1].Visible = visible
        CrosshairLines[1].From = Vector2.new(cx, cy - gap)
        CrosshairLines[1].To = Vector2.new(cx, cy - gap - size)
        CrosshairLines[1].Color = Settings.CrosshairColor
        
        -- 下
        CrosshairLines[2].Visible = visible
        CrosshairLines[2].From = Vector2.new(cx, cy + gap)
        CrosshairLines[2].To = Vector2.new(cx, cy + gap + size)
        CrosshairLines[2].Color = Settings.CrosshairColor
        
        -- 左
        CrosshairLines[3].Visible = visible
        CrosshairLines[3].From = Vector2.new(cx - gap, cy)
        CrosshairLines[3].To = Vector2.new(cx - gap - size, cy)
        CrosshairLines[3].Color = Settings.CrosshairColor
        
        -- 右
        CrosshairLines[4].Visible = visible
        CrosshairLines[4].From = Vector2.new(cx + gap, cy)
        CrosshairLines[4].To = Vector2.new(cx + gap + size, cy)
        CrosshairLines[4].Color = Settings.CrosshairColor
    end
end)

-- === 自動重生處理 ===
if Humanoid then
    Humanoid.Died:Connect(function()
        if Settings.AutoRespawn then
            task.wait(1)
            pcall(function()
                LocalPlayer:LoadCharacter()
            end)
        end
    end)
end

-- === 無後座力 / 無散射 嘗試 ===
spawn(function()
    while task.wait(0.1) do
        if (Settings.NoRecoil or Settings.NoSpread or Settings.InfiniteAmmo) and UpdateChar() then
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, obj in pairs(tool:GetDescendants()) do
                        pcall(function()
                            local name = obj.Name:lower()
                            if Settings.NoRecoil and name:find("recoil") then
                                if typeof(obj.Value) == "number" then obj.Value = 0 end
                            end
                            if Settings.NoSpread and name:find("spread") then
                                if typeof(obj.Value) == "number" then obj.Value = 0 end
                            end
                            if Settings.InfiniteAmmo and (name:find("ammo") or name:find("mag") or name:find("clip")) then
                                if typeof(obj.Value) == "number" then obj.Value = 999 end
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- === 自動治療嘗試 ===
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoHeal and UpdateChar() and Humanoid then
            local healthPercent = (Humanoid.Health / Humanoid.MaxHealth) * 100
            if healthPercent <= Settings.HealThreshold then
                -- 嘗試使用治療物品
                pcall(function()
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        local name = item.Name:lower()
                        if name:find("heal") or name:find("medkit") or name:find("bandage") or name:find("health") then
                            Humanoid:EquipTool(item)
                            task.wait(0.2)
                            -- 嘗試使用
                            if item:FindFirstChild("RemoteEvent") then
                                item.RemoteEvent:FireServer()
                            end
                            break
                        end
                    end
                end)
            end
        end
    end
end)

-- === 玩家加入時更新下拉選單 ===
Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    -- 重新創建玩家列表 (需要 Rayfield 支持動態更新)
end)

-- === 遊戲特定功能 ===

-- Blade Ball 自動格擋
if CurrentGame.Name == "Blade Ball" then
    spawn(function()
        while task.wait(0.01) do
            if Settings.Combat and Settings.Combat.AutoParry then
                pcall(function()
                    local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("ball")
                    if ball and UpdateChar() then
                        local dist = (ball.Position - RootPart.Position).Magnitude
                        if dist < Settings.Combat.AutoParry.Range then
                            -- 嘗試格擋
                            local parry = ReplicatedStorage:FindFirstChild("Remotes")
                            if parry then
                                local parryRemote = parry:FindFirstChild("Parry") or parry:FindFirstChild("Block")
                                if parryRemote then
                                    parryRemote:FireServer()
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end

-- Da Hood 特定功能
if CurrentGame.Name == "Da Hood" then
    -- 自動踩人
    Settings.AutoStomp = false
    
    spawn(function()
        while task.wait(0.1) do
            if Settings.AutoStomp and UpdateChar() then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum:GetState() == Enum.HumanoidStateType.Dead then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - RootPart.Position).Magnitude
                                if dist < 10 then
                                    pcall(function()
                                        local stomp = ReplicatedStorage:FindFirstChild("MainEvent")
                                        if stomp then
                                            stomp:FireServer("Stomp", player.Character)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- MM2 特定功能
if CurrentGame.Name == "Murder Mystery 2" then
    Settings.ShowMurderer = false
    Settings.ShowGun = false
    
    spawn(function()
        while task.wait(1) do
            if Settings.ShowMurderer or Settings.ShowGun then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local backpack = player:FindFirstChild("Backpack")
                        if backpack then
                            for _, item in pairs(backpack:GetChildren()) do
                                if item:IsA("Tool") then
                                    local name = item.Name:lower()
                                    if name:find("knife") or name:find("murderer") then
                                        if Settings.ShowMurderer then
                                            Rayfield:Notify({Title = "MM2", Content = player.Name .. " 是殺手!", Duration = 5})
                                        end
                                    elseif name:find("gun") or name:find("revolver") then
                                        if Settings.ShowGun then
                                            Rayfield:Notify({Title = "MM2", Content = player.Name .. " 有槍!", Duration = 5})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- === 性能監控 ===
local LastFPS = 0
local FrameCount = 0
local LastTime = tick()

RunService.RenderStepped:Connect(function()
    FrameCount = FrameCount + 1
    local now = tick()
    if now - LastTime >= 1 then
        LastFPS = FrameCount
        FrameCount = 0
        LastTime = now
    end
end)

-- === 緊急關閉快捷鍵 ===
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- P 鍵關閉所有功能
    if input.KeyCode == Enum.KeyCode.P then
        Settings.Fly = false
        Settings.Noclip = false
        Settings.Speed = false
        Settings.God = false
        Settings.KillAura = false
        Settings.ESP = false
        Settings.Aimbot = false
        
        if FlyBV then FlyBV:Destroy(); FlyBV = nil end
        if FlyBG then FlyBG:Destroy(); FlyBG = nil end
        if Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
        end
        
        Rayfield:Notify({Title = "緊急關閉", Content = "已關閉所有功能 (按 P)", Duration = 3})
    end
end)

-- === 除錯資訊 ===
spawn(function()
    while task.wait(30) do
        if Settings.AntiAFK then
            print("[Zy hacker hub] 系統運行中... FPS: " .. LastFPS .. " | 玩家: " .. #Players:GetPlayers())
        end
    end
end)

-- === Silent Aim Hook (進階) ===
pcall(function()
    if hookmetamethod and Settings.SilentAim then
        local oldNc
        oldNc = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if Settings.SilentAim and (method == "FindPartOnRay" or method == "Raycast") then
                if math.random(1, 100) <= Settings.SilentHitChance then
                    local target = GetClosest()
                    if target then
                        local args = {...}
                        if method == "FindPartOnRay" then
                            args[1] = Ray.new(Camera.CFrame.Position, (target.Position - Camera.CFrame.Position).Unit * 5000)
                        end
                        return oldNc(self, unpack(args))
                    end
                end
            end
            return oldNc(self, ...)
        end)
    end
end)

-- === 額外工具函數 ===

-- 獲取所有 NPC
local function GetNPCs()
    local npcs = {}
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
            if not Players:GetPlayerFromCharacter(model) then
                table.insert(npcs, model)
            end
        end
    end
    return npcs
end

-- 傳送到最近武器
local function TeleportToWeapon()
    if not UpdateChar() then return end
    
    local closest, minDist = nil, math.huge
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Tool") or (item:IsA("Model") and item:FindFirstChild("Handle")) then
            local pos = item:FindFirstChild("Handle") and item.Handle.Position or item.Position
            local dist = (pos - RootPart.Position).Magnitude
            if dist < minDist then
                closest = pos
                minDist = dist
            end
        end
    end
    
    if closest then
        RootPart.CFrame = CFrame.new(closest + Vector3.new(0, 3, 0))
        Rayfield:Notify({Title = "傳送", Content = "已傳送到最近武器", Duration = 2})
    end
end

-- 傳送到最近 NPC
local function TeleportToNPC()
    if not UpdateChar() then return end
    
    local npcs = GetNPCs()
    local closest, minDist = nil, math.huge
    
    for _, npc in pairs(npcs) do
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (hrp.Position - RootPart.Position).Magnitude
            if dist < minDist then
                closest = hrp.Position
                minDist = dist
            end
        end
    end
    
    if closest then
        RootPart.CFrame = CFrame.new(closest + Vector3.new(0, 3, 0))
        Rayfield:Notify({Title = "傳送", Content = "已傳送到最近 NPC", Duration = 2})
    end
end

-- === 追加 UI 按鈕 ===
TPTab:CreateSection("🎯 快速傳送")

TPTab:CreateButton({
    Name = "傳送到最近武器",
    Callback = TeleportToWeapon,
})

TPTab:CreateButton({
    Name = "傳送到最近 NPC",
    Callback = TeleportToNPC,
})

-- === 遊戲狀態監控 ===
local ConnectionCount = 0
for _, conn in pairs(getconnections and getconnections(RunService.RenderStepped) or {}) do
    ConnectionCount = ConnectionCount + 1
end

print("[Zy hacker hub] 活躍連接數: " .. ConnectionCount)
print("[Zy hacker hub] 進階功能模組已載入!")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              最終初始化                                      ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("═══════════════════════════════════════════════════════════════")
print("   ✅ Zy hacker hub v" .. VERSION .. " - Rayfield Edition")
print("   📍 遊戲: " .. CurrentGame.Name)
print("   🎮 類型: " .. CurrentGame.Type)
print("   ⚡ 速度倍率: x" .. CurrentGame.SpeedMult)
print("   📊 功能: 100+ 模組")
print("═══════════════════════════════════════════════════════════════")
print("")
print("   操作說明:")
print("   - RightShift: 開關 UI")
print("   - 右鍵: Aimbot 瞄準")
print("   - WASD/Space/Ctrl: 飛行控制")
print("   - Shift: 飛行加速 / 穿地板")
print("   - P: 緊急關閉所有功能")
print("")
print("═══════════════════════════════════════════════════════════════")
print("[Zy hacker hub] 初始化完成! 所有系統已就緒!")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              額外功能擴展                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入額外功能擴展...")

-- === 自動收集物品 ===
Settings.AutoCollect = false

spawn(function()
    while task.wait(0.5) do
        if Settings.AutoCollect and UpdateChar() then
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") then
                    local handle = item:FindFirstChild("Handle")
                    if handle then
                        local dist = (handle.Position - RootPart.Position).Magnitude
                        if dist < 50 then
                            pcall(function()
                                handle.CFrame = RootPart.CFrame
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- === 自動農場 (Blox Fruits) ===
if CurrentGame.Name == "Blox Fruits" then
    Settings.AutoFarm = false
    
    spawn(function()
        while task.wait(0.3) do
            if Settings.AutoFarm and UpdateChar() then
                -- 尋找最近的敵人/NPC
                local npcs = GetNPCs()
                local closest, minDist = nil, math.huge
                
                for _, npc in pairs(npcs) do
                    local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso")
                    local hum = npc:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - RootPart.Position).Magnitude
                        if dist < minDist then
                            closest = hrp
                            minDist = dist
                        end
                    end
                end
                
                if closest then
                    -- 傳送到 NPC
                    RootPart.CFrame = closest.CFrame * CFrame.new(0, 0, 2)
                    
                    -- 嘗試攻擊
                    pcall(function()
                        local tool = Character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end)
                end
            end
        end
    end)
end

-- === 無限耐力 ===
Settings.InfiniteStamina = false

spawn(function()
    while task.wait(0.1) do
        if Settings.InfiniteStamina and UpdateChar() then
            pcall(function()
                local stamina = LocalPlayer:FindFirstChild("Stamina") or 
                               LocalPlayer:FindFirstChild("Energy") or
                               Character:FindFirstChild("Stamina")
                if stamina and stamina:IsA("NumberValue") or stamina:IsA("IntValue") then
                    stamina.Value = stamina.Value.Max or 100
                end
            end)
        end
    end
end)

-- === 物品 ESP (Drawing API) ===
local ItemESPStorage = {}

spawn(function()
    while task.wait(1) do
        if Settings.ESP and UpdateChar() then
            -- 清理舊的
            for item, gui in pairs(ItemESPStorage) do
                if not item.Parent then
                    pcall(function() gui:Destroy() end)
                    ItemESPStorage[item] = nil
                end
            end
            
            -- 創建新的
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") and not ItemESPStorage[item] then
                    local handle = item:FindFirstChild("Handle")
                    if handle then
                        pcall(function()
                            local bb = Instance.new("BillboardGui")
                            bb.Adornee = handle
                            bb.Size = UDim2.new(0, 100, 0, 30)
                            bb.StudsOffset = Vector3.new(0, 1, 0)
                            bb.AlwaysOnTop = true
                            bb.Parent = handle
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.new(0, 1, 1)
                            label.TextStrokeTransparency = 0
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 12
                            label.Text = "🔫 " .. item.Name
                            label.Parent = bb
                            
                            ItemESPStorage[item] = bb
                        end)
                    end
                end
            end
        end
    end
end)

-- === 角色隱藏 ===
Settings.HideCharacter = false

spawn(function()
    while task.wait(0.5) do
        if UpdateChar() then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = Settings.HideCharacter and 1 or (part.Name == "HumanoidRootPart" and 1 or 0)
                end
            end
        end
    end
end)

-- === 反擊退狀態效果 ===
spawn(function()
    while task.wait(0.01) do
        if Settings.AntiRagdoll and UpdateChar() and Humanoid then
            local state = Humanoid:GetState()
            if state == Enum.HumanoidStateType.Ragdoll or 
               state == Enum.HumanoidStateType.FallingDown then
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- === 自動格擋 (通用) ===
spawn(function()
    while task.wait(0.01) do
        if Settings.Combat and Settings.Combat.AutoParry then
            if not UpdateChar() then continue end
            
            -- 檢測來襲物體
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Velocity.Magnitude > 50 then
                    local dist = (obj.Position - RootPart.Position).Magnitude
                    if dist < 30 then
                        -- 嘗試格擋
                        pcall(function()
                            UserInputService:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                            task.wait(0.1)
                            UserInputService:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        end)
                    end
                end
            end
        end
    end
end)

-- === 追加 MiscTab 功能 ===
MiscTab:CreateSection("🎮 進階功能")

MiscTab:CreateToggle({
    Name = "自動收集物品",
    CurrentValue = false,
    Flag = "AutoCollectToggle",
    Callback = function(v) Settings.AutoCollect = v end,
})

MiscTab:CreateToggle({
    Name = "無限耐力",
    CurrentValue = false,
    Flag = "InfiniteStaminaToggle",
    Callback = function(v) Settings.InfiniteStamina = v end,
})

MiscTab:CreateToggle({
    Name = "隱藏角色",
    CurrentValue = false,
    Flag = "HideCharacterToggle",
    Callback = function(v) Settings.HideCharacter = v end,
})

-- === 追加 AimTab 功能 ===
AimTab:CreateSection("➕ 準心設定")

AimTab:CreateToggle({
    Name = "顯示準心",
    CurrentValue = false,
    Flag = "CrosshairToggle",
    Callback = function(v) Settings.ShowCrosshair = v end,
})

AimTab:CreateSlider({
    Name = "準心大小",
    Range = {5, 30},
    Increment = 1,
    CurrentValue = 10,
    Flag = "CrosshairSize",
    Callback = function(v) Settings.CrosshairSize = v end,
})

AimTab:CreateColorPicker({
    Name = "準心顏色",
    Color = Color3.new(0, 1, 0),
    Flag = "CrosshairColor",
    Callback = function(v) Settings.CrosshairColor = v end,
})

-- === 追加 CombatTab 功能 ===
CombatTab:CreateSection("🥊 進階戰鬥")

CombatTab:CreateToggle({
    Name = "自動格擋",
    CurrentValue = false,
    Flag = "AutoParryToggle",
    Callback = function(v)
        if not Settings.Combat then Settings.Combat = {} end
        if not Settings.Combat.AutoParry then Settings.Combat.AutoParry = {} end
        Settings.Combat.AutoParry.Enabled = v
    end,
})

-- === Freecam 功能 ===
Settings.Freecam = false
local FreecamCF = nil

MiscTab:CreateToggle({
    Name = "自由視角 (Freecam)",
    CurrentValue = false,
    Flag = "FreecamToggle",
    Callback = function(v)
        Settings.Freecam = v
        if v then
            FreecamCF = Camera.CFrame
            Camera.CameraType = Enum.CameraType.Scriptable
            Rayfield:Notify({Title = "Freecam", Content = "WASD 移動, QE 升降, Shift 加速", Duration = 3})
        else
            Camera.CameraType = Enum.CameraType.Custom
        end
    end,
})

RunService.RenderStepped:Connect(function(dt)
    if Settings.Freecam and FreecamCF then
        local speed = KeysDown[Enum.KeyCode.LeftShift] and 100 or 30
        local dir = Vector3.zero
        
        if KeysDown[Enum.KeyCode.W] then dir = dir + FreecamCF.LookVector end
        if KeysDown[Enum.KeyCode.S] then dir = dir - FreecamCF.LookVector end
        if KeysDown[Enum.KeyCode.A] then dir = dir - FreecamCF.RightVector end
        if KeysDown[Enum.KeyCode.D] then dir = dir + FreecamCF.RightVector end
        if KeysDown[Enum.KeyCode.E] then dir = dir + Vector3.yAxis end
        if KeysDown[Enum.KeyCode.Q] then dir = dir - Vector3.yAxis end
        
        if dir.Magnitude > 0 then
            FreecamCF = FreecamCF * CFrame.new(dir.Unit * speed * dt)
        end
        
        -- 滑鼠旋轉
        local delta = UserInputService:GetMouseDelta()
        FreecamCF = FreecamCF * CFrame.Angles(-math.rad(delta.Y * 0.2), -math.rad(delta.X * 0.2), 0)
        
        Camera.CFrame = FreecamCF
    end
end)

-- === 最終統計 ===
local TotalFeatures = 0
for _, _ in pairs(Settings) do
    TotalFeatures = TotalFeatures + 1
end

print("[Zy hacker hub] 已載入 " .. TotalFeatures .. " 個設定項目")
print("[Zy hacker hub] 額外功能擴展已載入!")
print("")
print("   ╔═══════════════════════════════════════════╗")
print("   ║     Zy hacker hub v" .. VERSION .. " 已完全載入!     ║")
print("   ║         100+ 功能模組已就緒              ║")
print("   ║       感謝使用 Zy hacker hub          ║")
print("   ╚═══════════════════════════════════════════╝")
