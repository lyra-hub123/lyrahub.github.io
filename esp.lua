--[[
╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                  ║
║   ███╗   ██╗██╗   ██╗██╗  ██╗███████╗██████╗  ██████╗ ████████╗    ██╗   ██╗ █████╗             ║
║   ████╗  ██║██║   ██║██║ ██╔╝██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝    ██║   ██║██╔══██╗            ║
║   ██╔██╗ ██║██║   ██║█████╔╝ █████╗  ██████╔╝██║   ██║   ██║       ██║   ██║╚█████╔╝            ║
║   ██║╚██╗██║██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗██║   ██║   ██║       ╚██╗ ██╔╝██╔══██╗            ║
║   ██║ ╚████║╚██████╔╝██║  ██╗███████╗██████╔╝╚██████╔╝   ██║        ╚████╔╝ ╚█████╔╝            ║
║   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝    ╚═╝         ╚═══╝   ╚════╝             ║
║                                                                                                  ║
║   Ultimate Edition v7.0 - 完整功能版本                                                           ║
║   支持遊戲: Blade Ball, Rivals, Arsenal, Da Hood, Blox Fruits, MM2, Phantom Forces              ║
║   功能總數: 100+ 功能模組                                                                        ║
║                                                                                                  ║
║   操作說明:                                                                                      ║
║   - RightShift: 開關 UI                                                                         ║
║   - 右鍵: Aimbot 瞄準                                                                           ║
║   - WASD/Space/Ctrl: 飛行控制                                                                   ║
║   - Shift: 飛行加速 / 穿地板                                                                    ║
║                                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

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
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local PathfindingService = game:GetService("PathfindingService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              本地變量                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Character = nil
local Humanoid = nil
local RootPart = nil
local Head = nil

-- 版本信息
local VERSION = "7.0"
local BUILD_DATE = "2026-01-15"
local SCRIPT_NAME = "NukeBot Ultimate"

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              遊戲檢測系統                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

local GameDatabase = {
    -- FPS 遊戲
    [286090429] = {
        Name = "Arsenal",
        Type = "FPS",
        SpeedMult = 1.2,
        HasTeams = true,
        AimPart = "Head",
        Features = {"Aimbot", "ESP", "NoRecoil", "InfiniteAmmo"}
    },
    [17625359962] = {
        Name = "Rivals",
        Type = "FPS",
        SpeedMult = 2.0,
        HasTeams = true,
        AimPart = "Head",
        Features = {"Aimbot", "ESP", "NoRecoil", "SilentAim"}
    },
    [292439477] = {
        Name = "Phantom Forces",
        Type = "FPS",
        SpeedMult = 1.0,
        HasTeams = true,
        AimPart = "Head",
        Features = {"Aimbot", "ESP", "NoRecoil", "NoSpread"}
    },
    
    -- 動作遊戲
    [13772394625] = {
        Name = "Blade Ball",
        Type = "Action",
        SpeedMult = 1.5,
        HasTeams = false,
        AimPart = "HumanoidRootPart",
        Features = {"AutoParry", "ESP", "Speed", "Fly"}
    },
    [2788229376] = {
        Name = "Da Hood",
        Type = "Combat",
        SpeedMult = 1.8,
        HasTeams = false,
        AimPart = "Head",
        Features = {"Aimbot", "ESP", "AutoStomp", "AntiLock"}
    },
    
    -- RPG 遊戲
    [6284583030] = {
        Name = "Blox Fruits",
        Type = "RPG",
        SpeedMult = 1.3,
        HasTeams = false,
        AimPart = "HumanoidRootPart",
        Features = {"AutoFarm", "ESP", "Teleport", "BringMobs"}
    },
    [142823291] = {
        Name = "Murder Mystery 2",
        Type = "Horror",
        SpeedMult = 1.0,
        HasTeams = false,
        AimPart = "Head",
        Features = {"ESP", "MurdererAlert", "GunAlert", "Teleport"}
    },
}

local CurrentGame = GameDatabase[game.PlaceId] or {
    Name = "通用",
    Type = "Unknown",
    SpeedMult = 1.0,
    HasTeams = false,
    AimPart = "Head",
    Features = {"All"}
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              設定系統                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local Settings = {
    -- ═══════════════ 移動設定 ═══════════════
    Movement = {
        -- 飛行
        Fly = {
            Enabled = false,
            Speed = 100,
            SmoothFly = true,
            UseAlignPosition = false,
            VerticalSpeed = 100,
            Acceleration = 1.5,
            Deceleration = 0.8,
        },
        -- 穿牆
        Noclip = {
            Enabled = false,
            Mode = "Full", -- Full, Partial
        },
        -- 穿地板
        Phase = {
            Enabled = false,
            Speed = 1,
        },
        -- 速度
        Speed = {
            Enabled = false,
            Multiplier = 5,
            AutoAdjust = true,
        },
        -- 跳躍
        Jump = {
            InfiniteJump = false,
            JumpPower = 50,
            AutoJump = false,
            BHop = false,
            DoubleJump = false,
            DoubleJumpPower = 100,
        },
        -- 爬牆
        Spider = {
            Enabled = false,
            ClimbSpeed = 50,
            AutoClimb = false,
        },
        -- 其他
        AirWalk = false,
        ClickTP = false,
        AntiVoid = false,
        AutoRespawn = false,
    },
    
    -- ═══════════════ 戰鬥設定 ═══════════════
    Combat = {
        -- 防禦
        Defense = {
            GodMode = false,
            SemiGod = false,
            AntiKnockback = false,
            AntiRagdoll = false,
            AntiGrab = false,
            AntiFall = false,
            AntiDeath = false,
            AutoHeal = false,
            HealThreshold = 50,
        },
        -- Kill Aura
        KillAura = {
            Enabled = false,
            Range = 15,
            Mode = "Touch", -- Touch, TP, Fling, Punch
            Delay = 0.1,
            TargetPlayers = true,
            TargetNPCs = false,
        },
        -- Hitbox
        Hitbox = {
            Enabled = false,
            Size = 10,
            Transparency = 0.5,
            ShowHitbox = false,
        },
        -- 自動格擋
        AutoParry = {
            Enabled = false,
            Timing = 0.5,
            Range = 50,
        },
    },
    
    -- ═══════════════ 瞄準設定 ═══════════════
    Aim = {
        -- Aimbot
        Aimbot = {
            Enabled = false,
            Key = Enum.UserInputType.MouseButton2,
            Part = "Head",
            FOV = 150,
            Smoothness = 0.3,
            Prediction = 0,
            TeamCheck = true,
            VisibleCheck = false,
            WallCheck = false,
            ClosestToMouse = true,
            StickyAim = false,
            AimLock = false,
        },
        -- Silent Aim
        SilentAim = {
            Enabled = false,
            Precision = 5,
            HitChance = 100,
            Method = "Raycast", -- Raycast, Mouse, Camera
        },
        -- TriggerBot
        TriggerBot = {
            Enabled = false,
            Delay = 0.05,
            BurstMode = false,
            BurstCount = 3,
        },
        -- FOV 圓圈
        FOVCircle = {
            Visible = false,
            Color = Color3.new(1, 1, 1),
            Thickness = 1,
            Filled = false,
        },
    },
    
    -- ═══════════════ 武器設定 ═══════════════
    Weapon = {
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        InfiniteAmmo = false,
        InstantReload = false,
        AutoReload = false,
        DamageMultiplier = 1,
        RangeMultiplier = 1,
    },
    
    -- ═══════════════ ESP 設定 ═══════════════
    ESP = {
        -- 主開關
        Enabled = false,
        TeamCheck = false,
        MaxDistance = 2000,
        
        -- 玩家 ESP
        Players = {
            Enabled = true,
            Box = true,
            Name = true,
            Health = true,
            Distance = true,
            Tracer = false,
            Skeleton = false,
            HeadDot = false,
            Weapon = false,
            FillBox = false,
        },
        
        -- NPC ESP
        NPCs = {
            Enabled = false,
            Box = true,
            Name = true,
            Health = true,
        },
        
        -- 物品 ESP
        Items = {
            Enabled = false,
            Weapons = true,
            Coins = true,
            Chests = false,
        },
        
        -- 顏色
        Colors = {
            Enemy = Color3.new(1, 0, 0),
            Team = Color3.new(0, 1, 0),
            NPC = Color3.new(1, 1, 0),
            Item = Color3.new(0, 1, 1),
            Visible = Color3.new(0, 1, 0),
            NotVisible = Color3.new(1, 0, 0),
            Skeleton = Color3.new(1, 1, 0),
        },
        
        -- Chams
        Chams = {
            Enabled = false,
            FillTransparency = 0.5,
            OutlineTransparency = 0,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        },
    },
    
    -- ═══════════════ 視覺設定 ═══════════════
    Visual = {
        -- 光照
        Fullbright = false,
        NoFog = false,
        NoShadows = false,
        CustomAmbient = false,
        AmbientColor = Color3.new(1, 1, 1),
        
        -- 時間
        TimeFreeze = false,
        CustomTime = 14,
        
        -- 視野
        CustomFOV = false,
        FOVValue = 90,
        
        -- 第三人稱
        ThirdPerson = false,
        ThirdPersonDistance = 10,
        
        -- 自由視角
        Freecam = false,
        FreecamSpeed = 1,
        
        -- 效果
        NoParticles = false,
        NoEffects = false,
        LowGraphics = false,
        
        -- 隱藏
        HideCharacter = false,
        HideOthers = false,
        HideArms = false,
        
        -- 其他
        Crosshair = {
            Enabled = false,
            Size = 10,
            Thickness = 2,
            Gap = 5,
            Color = Color3.new(0, 1, 0),
            Outline = true,
        },
    },
    
    -- ═══════════════ 世界設定 ═══════════════
    World = {
        Gravity = 196.2,
        JumpHeight = 7.2,
        Atmosphere = {
            Enabled = false,
            Density = 0.3,
            Color = Color3.new(0, 0, 0),
        },
    },
    
    -- ═══════════════ 傳送設定 ═══════════════
    Teleport = {
        Mode = "Instant", -- Instant, Tween
        TweenSpeed = 500,
        SavedPositions = {},
    },
    
    -- ═══════════════ 雜項設定 ═══════════════
    Misc = {
        AntiAFK = true,
        AntiDetection = false,
        ChatSpam = {
            Enabled = false,
            Message = "NukeBot v7.0",
            Delay = 3,
        },
        FPSUnlocker = false,
        TargetFPS = 240,
        AutoRejoin = false,
        ServerHop = false,
    },
    
    -- ═══════════════ UI 設定 ═══════════════
    UI = {
        Theme = "Dark",
        Keybind = Enum.KeyCode.RightShift,
        Notifications = true,
        Sounds = true,
    },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              工具函數                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

-- 更新角色引用
local function UpdateCharacter()
    Character = LocalPlayer.Character
    if Character then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
        Head = Character:FindFirstChild("Head")
    end
    return Character and Humanoid and RootPart
end

-- 初始化角色
UpdateCharacter()

-- 監聽角色重生
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 10)
    RootPart = char:WaitForChild("HumanoidRootPart", 10)
    Head = char:WaitForChild("Head", 10)
    
    -- 重新應用設定
    if Settings.Combat.Defense.GodMode then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    end
    
    if Settings.Movement.Speed.Enabled then
        Humanoid.WalkSpeed = 16 * Settings.Movement.Speed.Multiplier * CurrentGame.SpeedMult
    end
    
    if Settings.Movement.Jump.JumpPower ~= 50 then
        Humanoid.JumpPower = Settings.Movement.Jump.JumpPower
    end
end)

-- 獲取玩家列表
local function GetPlayers()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player)
        end
    end
    return players
end

-- 獲取玩家名稱列表
local function GetPlayerNames()
    local names = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- 檢查是否為隊友
local function IsTeammate(player)
    if not Settings.Aim.Aimbot.TeamCheck then
        return false
    end
    
    if not CurrentGame.HasTeams then
        return false
    end
    
    return player.Team == LocalPlayer.Team
end

-- 檢查是否可見
local function IsVisible(part)
    if not part then return false end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {Character, Camera}
    
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    
    local result = Workspace:Raycast(origin, direction, params)
    
    if result then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    
    return true
end

-- 計算螢幕距離
local function GetScreenDistance(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    if not onScreen then return math.huge end
    
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
end

-- 計算實際距離
local function GetDistance(position)
    if not RootPart then return math.huge end
    return (position - RootPart.Position).Magnitude
end

-- 創建通知
local function Notify(title, text, duration)
    if not Settings.UI.Notifications then return end
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

-- 安全執行
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[NukeBot] Error: " .. tostring(result))
    end
    return success, result
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              按鍵輸入系統                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

local KeysDown = {}
local MouseButtonsDown = {}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        KeysDown[input.KeyCode] = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        MouseButtonsDown[1] = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        MouseButtonsDown[2] = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
        MouseButtonsDown[3] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        KeysDown[input.KeyCode] = false
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        MouseButtonsDown[1] = false
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        MouseButtonsDown[2] = false
    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
        MouseButtonsDown[3] = false
    end
end)

local function IsKeyDown(keyCode)
    return KeysDown[keyCode] == true
end

local function IsMouseButtonDown(button)
    return MouseButtonsDown[button] == true
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              UI 系統 - Orion Library                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- 創建主視窗
local Window = OrionLib:MakeWindow({
    Name = "🔥 " .. SCRIPT_NAME .. " v" .. VERSION .. " [" .. CurrentGame.Name .. "]",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "NukeBotUltimate",
    IntroEnabled = false,
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              移動系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local MovementTab = Window:MakeTab({
    Name = "🏃 移動",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === 飛行系統 ===
MovementTab:AddSection({Name = "✈️ 飛行系統"})

local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local FlyActive = false

MovementTab:AddToggle({
    Name = "飛行 (Fly)",
    Default = false,
    Callback = function(value)
        Settings.Movement.Fly.Enabled = value
        FlyActive = value
        
        if not UpdateCharacter() then return end
        
        if value then
            -- 創建飛行控制
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyVelocity.Velocity = Vector3.zero
            FlyBodyVelocity.Parent = RootPart
            
            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyGyro.P = 9e4
            FlyBodyGyro.Parent = RootPart
            
            Humanoid.PlatformStand = true
            
            Notify("飛行", "飛行已開啟 - WASD移動, Space上升, Ctrl下降, Shift加速", 3)
        else
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
            if Humanoid then Humanoid.PlatformStand = false end
            
            Notify("飛行", "飛行已關閉", 2)
        end
    end
})

MovementTab:AddSlider({
    Name = "飛行速度",
    Min = 50,
    Max = 500,
    Default = 100,
    Increment = 25,
    Callback = function(value)
        Settings.Movement.Fly.Speed = value
    end
})

MovementTab:AddToggle({
    Name = "平滑飛行",
    Default = true,
    Callback = function(value)
        Settings.Movement.Fly.SmoothFly = value
    end
})

-- === 穿透系統 ===
MovementTab:AddSection({Name = "👻 穿透系統"})

MovementTab:AddToggle({
    Name = "穿牆 (Noclip)",
    Default = false,
    Callback = function(value)
        Settings.Movement.Noclip.Enabled = value
        if value then
            Notify("穿牆", "穿牆已開啟", 2)
        end
    end
})

MovementTab:AddToggle({
    Name = "穿地板 (按住 Shift)",
    Default = false,
    Callback = function(value)
        Settings.Movement.Phase.Enabled = value
    end
})

MovementTab:AddSlider({
    Name = "穿地速度",
    Min = 0.5,
    Max = 5,
    Default = 1,
    Increment = 0.5,
    Callback = function(value)
        Settings.Movement.Phase.Speed = value
    end
})

-- === 速度系統 ===
MovementTab:AddSection({Name = "⚡ 速度系統 [" .. CurrentGame.Name .. " x" .. CurrentGame.SpeedMult .. "]"})

MovementTab:AddToggle({
    Name = "速度破解",
    Default = false,
    Callback = function(value)
        Settings.Movement.Speed.Enabled = value
        
        if UpdateCharacter() and Humanoid then
            if value then
                Humanoid.WalkSpeed = 16 * Settings.Movement.Speed.Multiplier * CurrentGame.SpeedMult
                Notify("速度", "當前速度: " .. math.floor(Humanoid.WalkSpeed), 2)
            else
                Humanoid.WalkSpeed = 16
            end
        end
    end
})

MovementTab:AddSlider({
    Name = "速度倍率",
    Min = 2,
    Max = 100,
    Default = 5,
    Increment = 1,
    Callback = function(value)
        Settings.Movement.Speed.Multiplier = value
        
        if Settings.Movement.Speed.Enabled and UpdateCharacter() and Humanoid then
            Humanoid.WalkSpeed = 16 * value * CurrentGame.SpeedMult
        end
    end
})

MovementTab:AddToggle({
    Name = "自動調整 (根據遊戲)",
    Default = true,
    Callback = function(value)
        Settings.Movement.Speed.AutoAdjust = value
    end
})

-- === 跳躍系統 ===
MovementTab:AddSection({Name = "🦘 跳躍系統"})

MovementTab:AddToggle({
    Name = "無限跳躍",
    Default = false,
    Callback = function(value)
        Settings.Movement.Jump.InfiniteJump = value
        if value then
            Notify("跳躍", "無限跳躍已開啟", 2)
        end
    end
})

MovementTab:AddSlider({
    Name = "跳躍力量",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 25,
    Callback = function(value)
        Settings.Movement.Jump.JumpPower = value
        
        if UpdateCharacter() and Humanoid then
            Humanoid.JumpPower = value
        end
    end
})

MovementTab:AddToggle({
    Name = "自動跳躍",
    Default = false,
    Callback = function(value)
        Settings.Movement.Jump.AutoJump = value
    end
})

MovementTab:AddToggle({
    Name = "連跳 (BHop)",
    Default = false,
    Callback = function(value)
        Settings.Movement.Jump.BHop = value
    end
})

MovementTab:AddToggle({
    Name = "二段跳",
    Default = false,
    Callback = function(value)
        Settings.Movement.Jump.DoubleJump = value
    end
})

-- === 爬牆系統 ===
MovementTab:AddSection({Name = "🕷️ 爬牆系統"})

MovementTab:AddToggle({
    Name = "蜘蛛爬牆",
    Default = false,
    Callback = function(value)
        Settings.Movement.Spider.Enabled = value
        if value then
            Notify("爬牆", "蜘蛛爬牆已開啟 - 面向牆壁即可攀爬", 3)
        end
    end
})

MovementTab:AddSlider({
    Name = "爬牆速度",
    Min = 10,
    Max = 100,
    Default = 50,
    Increment = 10,
    Callback = function(value)
        Settings.Movement.Spider.ClimbSpeed = value
    end
})

MovementTab:AddToggle({
    Name = "自動爬牆",
    Default = false,
    Callback = function(value)
        Settings.Movement.Spider.AutoClimb = value
    end
})

-- === 其他移動功能 ===
MovementTab:AddSection({Name = "🔧 其他移動功能"})

MovementTab:AddToggle({
    Name = "空中行走",
    Default = false,
    Callback = function(value)
        Settings.Movement.AirWalk = value
    end
})

MovementTab:AddToggle({
    Name = "點擊傳送",
    Default = false,
    Callback = function(value)
        Settings.Movement.ClickTP = value
        if value then
            Notify("傳送", "點擊地面即可傳送", 2)
        end
    end
})

MovementTab:AddToggle({
    Name = "防掉落虛空",
    Default = false,
    Callback = function(value)
        Settings.Movement.AntiVoid = value
    end
})

MovementTab:AddToggle({
    Name = "自動重生",
    Default = false,
    Callback = function(value)
        Settings.Movement.AutoRespawn = value
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              戰鬥系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local CombatTab = Window:MakeTab({
    Name = "⚔️ 戰鬥",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === 防禦系統 ===
CombatTab:AddSection({Name = "🛡️ 防禦系統"})

CombatTab:AddToggle({
    Name = "無敵模式 (God Mode)",
    Default = false,
    Callback = function(value)
        Settings.Combat.Defense.GodMode = value
        
        if UpdateCharacter() and Humanoid then
            if value then
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
                Notify("無敵", "無敵模式已開啟", 2)
            else
                Humanoid.MaxHealth = 100
                Humanoid.Health = 100
            end
        end
    end
})

CombatTab:AddToggle({
    Name = "半無敵 (自動回血)",
    Default = false,
    Callback = function(value)
        Settings.Combat.Defense.SemiGod = value
    end
})

CombatTab:AddToggle({
    Name = "抗擊退",
    Default = false,
    Callback = function(value)
        Settings.Combat.Defense.AntiKnockback = value
    end
})

CombatTab:AddToggle({
    Name = "防倒地",
    Default = false,
    Callback = function(value)
        Settings.Combat.Defense.AntiRagdoll = value
    end
})

CombatTab:AddToggle({
    Name = "防抓取",
    Default = false,
    Callback = function(value)
        Settings.Combat.Defense.AntiGrab = value
    end
})

CombatTab:AddToggle({
    Name = "自動治療",
    Default = false,
    Callback = function(value)
        Settings.Combat.Defense.AutoHeal = value
    end
})

CombatTab:AddSlider({
    Name = "治療閾值 (%)",
    Min = 10,
    Max = 90,
    Default = 50,
    Increment = 10,
    Callback = function(value)
        Settings.Combat.Defense.HealThreshold = value
    end
})

-- === Kill Aura ===
CombatTab:AddSection({Name = "💀 Kill Aura"})

CombatTab:AddToggle({
    Name = "Kill Aura 開關",
    Default = false,
    Callback = function(value)
        Settings.Combat.KillAura.Enabled = value
        if value then
            Notify("Kill Aura", "Kill Aura 已啟動", 2)
        end
    end
})

CombatTab:AddSlider({
    Name = "攻擊範圍",
    Min = 5,
    Max = 100,
    Default = 15,
    Increment = 5,
    Callback = function(value)
        Settings.Combat.KillAura.Range = value
    end
})

CombatTab:AddDropdown({
    Name = "攻擊模式",
    Default = "Touch",
    Options = {"Touch", "TP", "Fling", "Punch"},
    Callback = function(value)
        Settings.Combat.KillAura.Mode = value
    end
})

CombatTab:AddSlider({
    Name = "攻擊間隔",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Increment = 0.05,
    Callback = function(value)
        Settings.Combat.KillAura.Delay = value
    end
})

CombatTab:AddToggle({
    Name = "攻擊玩家",
    Default = true,
    Callback = function(value)
        Settings.Combat.KillAura.TargetPlayers = value
    end
})

CombatTab:AddToggle({
    Name = "攻擊 NPC",
    Default = false,
    Callback = function(value)
        Settings.Combat.KillAura.TargetNPCs = value
    end
})

-- === Hitbox 擴展 ===
CombatTab:AddSection({Name = "📦 Hitbox 擴展"})

CombatTab:AddToggle({
    Name = "Hitbox 擴展器",
    Default = false,
    Callback = function(value)
        Settings.Combat.Hitbox.Enabled = value
        if value then
            Notify("Hitbox", "Hitbox 擴展已開啟", 2)
        end
    end
})

CombatTab:AddSlider({
    Name = "Hitbox 大小",
    Min = 5,
    Max = 50,
    Default = 10,
    Increment = 5,
    Callback = function(value)
        Settings.Combat.Hitbox.Size = value
    end
})

CombatTab:AddToggle({
    Name = "顯示 Hitbox",
    Default = false,
    Callback = function(value)
        Settings.Combat.Hitbox.ShowHitbox = value
    end
})

-- === 自動格擋 ===
CombatTab:AddSection({Name = "🥊 自動格擋"})

CombatTab:AddToggle({
    Name = "自動格擋",
    Default = false,
    Callback = function(value)
        Settings.Combat.AutoParry.Enabled = value
    end
})

CombatTab:AddSlider({
    Name = "格擋時機",
    Min = 0.1,
    Max = 1,
    Default = 0.5,
    Increment = 0.1,
    Callback = function(value)
        Settings.Combat.AutoParry.Timing = value
    end
})

CombatTab:AddSlider({
    Name = "偵測範圍",
    Min = 10,
    Max = 100,
    Default = 50,
    Increment = 10,
    Callback = function(value)
        Settings.Combat.AutoParry.Range = value
    end
})

print("[NukeBot] 戰鬥系統已載入")
-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              瞄準系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local AimTab = Window:MakeTab({
    Name = "🎯 瞄準",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === Aimbot 設定 ===
AimTab:AddSection({Name = "🎯 Aimbot (按住右鍵)"})

AimTab:AddToggle({
    Name = "Aimbot 開關",
    Default = false,
    Callback = function(value)
        Settings.Aim.Aimbot.Enabled = value
        if value then
            Notify("Aimbot", "Aimbot 已開啟 - 按住右鍵瞄準", 3)
        end
    end
})

AimTab:AddDropdown({
    Name = "瞄準部位",
    Default = "Head",
    Options = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"},
    Callback = function(value)
        Settings.Aim.Aimbot.Part = value
    end
})

AimTab:AddSlider({
    Name = "瞄準 FOV",
    Min = 50,
    Max = 500,
    Default = 150,
    Increment = 25,
    Callback = function(value)
        Settings.Aim.Aimbot.FOV = value
    end
})

AimTab:AddSlider({
    Name = "平滑度 (越低越快)",
    Min = 0.1,
    Max = 1,
    Default = 0.3,
    Increment = 0.1,
    Callback = function(value)
        Settings.Aim.Aimbot.Smoothness = value
    end
})

AimTab:AddSlider({
    Name = "預測值",
    Min = 0,
    Max = 10,
    Default = 0,
    Increment = 1,
    Callback = function(value)
        Settings.Aim.Aimbot.Prediction = value
    end
})

AimTab:AddToggle({
    Name = "隊伍檢查",
    Default = true,
    Callback = function(value)
        Settings.Aim.Aimbot.TeamCheck = value
    end
})

AimTab:AddToggle({
    Name = "可見檢查",
    Default = false,
    Callback = function(value)
        Settings.Aim.Aimbot.VisibleCheck = value
    end
})

AimTab:AddToggle({
    Name = "穿牆檢查",
    Default = false,
    Callback = function(value)
        Settings.Aim.Aimbot.WallCheck = value
    end
})

AimTab:AddToggle({
    Name = "鎖定目標",
    Default = false,
    Callback = function(value)
        Settings.Aim.Aimbot.AimLock = value
    end
})

-- === Silent Aim ===
AimTab:AddSection({Name = "🔇 Silent Aim"})

AimTab:AddToggle({
    Name = "Silent Aim 開關",
    Default = false,
    Callback = function(value)
        Settings.Aim.SilentAim.Enabled = value
        if value then
            Notify("Silent Aim", "靜默瞄準已開啟", 2)
        end
    end
})

AimTab:AddSlider({
    Name = "精準度",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 1,
    Callback = function(value)
        Settings.Aim.SilentAim.Precision = value
    end
})

AimTab:AddSlider({
    Name = "命中率 (%)",
    Min = 10,
    Max = 100,
    Default = 100,
    Increment = 10,
    Callback = function(value)
        Settings.Aim.SilentAim.HitChance = value
    end
})

AimTab:AddDropdown({
    Name = "方法",
    Default = "Raycast",
    Options = {"Raycast", "Mouse", "Camera"},
    Callback = function(value)
        Settings.Aim.SilentAim.Method = value
    end
})

-- === TriggerBot ===
AimTab:AddSection({Name = "🔫 TriggerBot"})

AimTab:AddToggle({
    Name = "TriggerBot 開關",
    Default = false,
    Callback = function(value)
        Settings.Aim.TriggerBot.Enabled = value
        if value then
            Notify("TriggerBot", "自動開槍已開啟", 2)
        end
    end
})

AimTab:AddSlider({
    Name = "觸發延遲 (秒)",
    Min = 0,
    Max = 0.5,
    Default = 0.05,
    Increment = 0.01,
    Callback = function(value)
        Settings.Aim.TriggerBot.Delay = value
    end
})

AimTab:AddToggle({
    Name = "連射模式",
    Default = false,
    Callback = function(value)
        Settings.Aim.TriggerBot.BurstMode = value
    end
})

AimTab:AddSlider({
    Name = "連射數量",
    Min = 1,
    Max = 10,
    Default = 3,
    Increment = 1,
    Callback = function(value)
        Settings.Aim.TriggerBot.BurstCount = value
    end
})

-- === FOV 圓圈 ===
AimTab:AddSection({Name = "⭕ FOV 圓圈"})

AimTab:AddToggle({
    Name = "顯示 FOV 圓圈",
    Default = false,
    Callback = function(value)
        Settings.Aim.FOVCircle.Visible = value
    end
})

AimTab:AddColorpicker({
    Name = "圓圈顏色",
    Default = Color3.new(1, 1, 1),
    Callback = function(value)
        Settings.Aim.FOVCircle.Color = value
    end
})

AimTab:AddSlider({
    Name = "圓圈粗細",
    Min = 1,
    Max = 5,
    Default = 1,
    Increment = 1,
    Callback = function(value)
        Settings.Aim.FOVCircle.Thickness = value
    end
})

-- === 武器輔助 ===
AimTab:AddSection({Name = "🔧 武器輔助"})

AimTab:AddToggle({
    Name = "無後座力",
    Default = false,
    Callback = function(value)
        Settings.Weapon.NoRecoil = value
    end
})

AimTab:AddToggle({
    Name = "無散射",
    Default = false,
    Callback = function(value)
        Settings.Weapon.NoSpread = value
    end
})

AimTab:AddToggle({
    Name = "連射",
    Default = false,
    Callback = function(value)
        Settings.Weapon.RapidFire = value
    end
})

AimTab:AddToggle({
    Name = "無限子彈",
    Default = false,
    Callback = function(value)
        Settings.Weapon.InfiniteAmmo = value
    end
})

AimTab:AddToggle({
    Name = "即時換彈",
    Default = false,
    Callback = function(value)
        Settings.Weapon.InstantReload = value
    end
})

AimTab:AddToggle({
    Name = "自動換彈",
    Default = false,
    Callback = function(value)
        Settings.Weapon.AutoReload = value
    end
})

print("[NukeBot] 瞄準系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              ESP 系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local ESPTab = Window:MakeTab({
    Name = "👁️ ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === ESP 主開關 ===
ESPTab:AddSection({Name = "👀 ESP 主設定"})

local ESPStorage = {}

ESPTab:AddToggle({
    Name = "ESP 開關",
    Default = false,
    Callback = function(value)
        Settings.ESP.Enabled = value
        
        if not value then
            -- 清理所有 ESP
            for player, data in pairs(ESPStorage) do
                pcall(function()
                    if data.Highlight then data.Highlight:Destroy() end
                    if data.Billboard then data.Billboard:Destroy() end
                    if data.Tracer then data.Tracer:Destroy() end
                end)
            end
            ESPStorage = {}
        else
            Notify("ESP", "ESP 已開啟", 2)
        end
    end
})

ESPTab:AddToggle({
    Name = "隊伍檢查",
    Default = false,
    Callback = function(value)
        Settings.ESP.TeamCheck = value
    end
})

ESPTab:AddSlider({
    Name = "最大距離",
    Min = 100,
    Max = 5000,
    Default = 2000,
    Increment = 100,
    Callback = function(value)
        Settings.ESP.MaxDistance = value
    end
})

-- === 玩家 ESP ===
ESPTab:AddSection({Name = "👤 玩家 ESP"})

ESPTab:AddToggle({
    Name = "方框",
    Default = true,
    Callback = function(value)
        Settings.ESP.Players.Box = value
    end
})

ESPTab:AddToggle({
    Name = "名稱",
    Default = true,
    Callback = function(value)
        Settings.ESP.Players.Name = value
    end
})

ESPTab:AddToggle({
    Name = "血量",
    Default = true,
    Callback = function(value)
        Settings.ESP.Players.Health = value
    end
})

ESPTab:AddToggle({
    Name = "距離",
    Default = true,
    Callback = function(value)
        Settings.ESP.Players.Distance = value
    end
})

ESPTab:AddToggle({
    Name = "追蹤線",
    Default = false,
    Callback = function(value)
        Settings.ESP.Players.Tracer = value
    end
})

ESPTab:AddToggle({
    Name = "骨架",
    Default = false,
    Callback = function(value)
        Settings.ESP.Players.Skeleton = value
    end
})

ESPTab:AddToggle({
    Name = "頭部點",
    Default = false,
    Callback = function(value)
        Settings.ESP.Players.HeadDot = value
    end
})

ESPTab:AddToggle({
    Name = "武器顯示",
    Default = false,
    Callback = function(value)
        Settings.ESP.Players.Weapon = value
    end
})

-- === NPC ESP ===
ESPTab:AddSection({Name = "🤖 NPC ESP"})

ESPTab:AddToggle({
    Name = "NPC ESP 開關",
    Default = false,
    Callback = function(value)
        Settings.ESP.NPCs.Enabled = value
    end
})

ESPTab:AddToggle({
    Name = "NPC 方框",
    Default = true,
    Callback = function(value)
        Settings.ESP.NPCs.Box = value
    end
})

ESPTab:AddToggle({
    Name = "NPC 名稱",
    Default = true,
    Callback = function(value)
        Settings.ESP.NPCs.Name = value
    end
})

ESPTab:AddToggle({
    Name = "NPC 血量",
    Default = true,
    Callback = function(value)
        Settings.ESP.NPCs.Health = value
    end
})

-- === 物品 ESP ===
ESPTab:AddSection({Name = "📦 物品 ESP"})

ESPTab:AddToggle({
    Name = "物品 ESP 開關",
    Default = false,
    Callback = function(value)
        Settings.ESP.Items.Enabled = value
    end
})

ESPTab:AddToggle({
    Name = "武器",
    Default = true,
    Callback = function(value)
        Settings.ESP.Items.Weapons = value
    end
})

ESPTab:AddToggle({
    Name = "金幣",
    Default = true,
    Callback = function(value)
        Settings.ESP.Items.Coins = value
    end
})

ESPTab:AddToggle({
    Name = "寶箱",
    Default = false,
    Callback = function(value)
        Settings.ESP.Items.Chests = value
    end
})

-- === ESP 顏色 ===
ESPTab:AddSection({Name = "🎨 ESP 顏色"})

ESPTab:AddColorpicker({
    Name = "敵人顏色",
    Default = Color3.new(1, 0, 0),
    Callback = function(value)
        Settings.ESP.Colors.Enemy = value
    end
})

ESPTab:AddColorpicker({
    Name = "隊友顏色",
    Default = Color3.new(0, 1, 0),
    Callback = function(value)
        Settings.ESP.Colors.Team = value
    end
})

ESPTab:AddColorpicker({
    Name = "NPC 顏色",
    Default = Color3.new(1, 1, 0),
    Callback = function(value)
        Settings.ESP.Colors.NPC = value
    end
})

ESPTab:AddColorpicker({
    Name = "骨架顏色",
    Default = Color3.new(1, 1, 0),
    Callback = function(value)
        Settings.ESP.Colors.Skeleton = value
    end
})

-- === Chams ===
ESPTab:AddSection({Name = "✨ Chams (透視高亮)"})

ESPTab:AddToggle({
    Name = "Chams 開關",
    Default = false,
    Callback = function(value)
        Settings.ESP.Chams.Enabled = value
    end
})

ESPTab:AddSlider({
    Name = "填充透明度",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Increment = 0.1,
    Callback = function(value)
        Settings.ESP.Chams.FillTransparency = value
    end
})

ESPTab:AddSlider({
    Name = "輪廓透明度",
    Min = 0,
    Max = 1,
    Default = 0,
    Increment = 0.1,
    Callback = function(value)
        Settings.ESP.Chams.OutlineTransparency = value
    end
})

print("[NukeBot] ESP 系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              視覺系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local VisualTab = Window:MakeTab({
    Name = "🎨 視覺",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === 光照效果 ===
VisualTab:AddSection({Name = "☀️ 光照效果"})

VisualTab:AddToggle({
    Name = "全亮 (Fullbright)",
    Default = false,
    Callback = function(value)
        Settings.Visual.Fullbright = value
        
        if value then
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
    end
})

VisualTab:AddToggle({
    Name = "無霧",
    Default = false,
    Callback = function(value)
        Settings.Visual.NoFog = value
        
        Lighting.FogEnd = value and 1e9 or 1e5
        Lighting.FogStart = value and 1e9 or 0
    end
})

VisualTab:AddToggle({
    Name = "無陰影",
    Default = false,
    Callback = function(value)
        Settings.Visual.NoShadows = value
        Lighting.GlobalShadows = not value
    end
})

VisualTab:AddToggle({
    Name = "自訂環境光",
    Default = false,
    Callback = function(value)
        Settings.Visual.CustomAmbient = value
    end
})

VisualTab:AddColorpicker({
    Name = "環境光顏色",
    Default = Color3.new(1, 1, 1),
    Callback = function(value)
        Settings.Visual.AmbientColor = value
        if Settings.Visual.CustomAmbient then
            Lighting.Ambient = value
            Lighting.OutdoorAmbient = value
        end
    end
})

-- === 時間設定 ===
VisualTab:AddSection({Name = "🕐 時間設定"})

VisualTab:AddToggle({
    Name = "時間凍結",
    Default = false,
    Callback = function(value)
        Settings.Visual.TimeFreeze = value
    end
})

VisualTab:AddSlider({
    Name = "時間",
    Min = 0,
    Max = 24,
    Default = 14,
    Increment = 1,
    Callback = function(value)
        Settings.Visual.CustomTime = value
        Lighting.ClockTime = value
    end
})

-- === 視野設定 ===
VisualTab:AddSection({Name = "📷 視野設定"})

VisualTab:AddToggle({
    Name = "自訂 FOV",
    Default = false,
    Callback = function(value)
        Settings.Visual.CustomFOV = value
    end
})

VisualTab:AddSlider({
    Name = "FOV 值",
    Min = 30,
    Max = 120,
    Default = 90,
    Increment = 5,
    Callback = function(value)
        Settings.Visual.FOVValue = value
        if Settings.Visual.CustomFOV then
            Camera.FieldOfView = value
        end
    end
})

-- === 第三人稱 ===
VisualTab:AddSection({Name = "👤 第三人稱"})

VisualTab:AddToggle({
    Name = "第三人稱視角",
    Default = false,
    Callback = function(value)
        Settings.Visual.ThirdPerson = value
        
        if value then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = Settings.Visual.ThirdPersonDistance
            LocalPlayer.CameraMinZoomDistance = Settings.Visual.ThirdPersonDistance
        else
            LocalPlayer.CameraMaxZoomDistance = 400
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end
})

VisualTab:AddSlider({
    Name = "視角距離",
    Min = 5,
    Max = 50,
    Default = 10,
    Increment = 5,
    Callback = function(value)
        Settings.Visual.ThirdPersonDistance = value
        
        if Settings.Visual.ThirdPerson then
            LocalPlayer.CameraMaxZoomDistance = value
            LocalPlayer.CameraMinZoomDistance = value
        end
    end
})

-- === 效能優化 ===
VisualTab:AddSection({Name = "⚡ 效能優化"})

VisualTab:AddToggle({
    Name = "移除粒子效果",
    Default = false,
    Callback = function(value)
        Settings.Visual.NoParticles = value
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = not value
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "移除視覺效果",
    Default = false,
    Callback = function(value)
        Settings.Visual.NoEffects = value
        
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or 
               obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") or
               obj:IsA("ColorCorrectionEffect") then
                obj.Enabled = not value
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "低畫質模式",
    Default = false,
    Callback = function(value)
        Settings.Visual.LowGraphics = value
        
        if value then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end
})

VisualTab:AddButton({
    Name = "移除所有效果",
    Callback = function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or 
               v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or
               v:IsA("ColorCorrectionEffect") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
        Notify("視覺", "已移除所有視覺效果", 2)
    end
})

-- === 準心 ===
VisualTab:AddSection({Name = "➕ 準心"})

VisualTab:AddToggle({
    Name = "顯示準心",
    Default = false,
    Callback = function(value)
        Settings.Visual.Crosshair.Enabled = value
    end
})

VisualTab:AddSlider({
    Name = "準心大小",
    Min = 5,
    Max = 30,
    Default = 10,
    Increment = 1,
    Callback = function(value)
        Settings.Visual.Crosshair.Size = value
    end
})

VisualTab:AddSlider({
    Name = "準心粗細",
    Min = 1,
    Max = 5,
    Default = 2,
    Increment = 1,
    Callback = function(value)
        Settings.Visual.Crosshair.Thickness = value
    end
})

VisualTab:AddSlider({
    Name = "準心間隙",
    Min = 0,
    Max = 20,
    Default = 5,
    Increment = 1,
    Callback = function(value)
        Settings.Visual.Crosshair.Gap = value
    end
})

VisualTab:AddColorpicker({
    Name = "準心顏色",
    Default = Color3.new(0, 1, 0),
    Callback = function(value)
        Settings.Visual.Crosshair.Color = value
    end
})

print("[NukeBot] 視覺系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              傳送系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local TeleportTab = Window:MakeTab({
    Name = "🌀 傳送",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === 玩家傳送 ===
TeleportTab:AddSection({Name = "👤 玩家傳送"})

local TargetPlayer = nil

TeleportTab:AddDropdown({
    Name = "選擇玩家",
    Default = "",
    Options = GetPlayerNames(),
    Callback = function(value)
        TargetPlayer = value
    end
})

TeleportTab:AddButton({
    Name = "傳送到選擇的玩家",
    Callback = function()
        if not TargetPlayer then
            Notify("錯誤", "請先選擇玩家", 2)
            return
        end
        
        local player = Players:FindFirstChild(TargetPlayer)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if UpdateCharacter() then
                RootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                Notify("傳送", "已傳送到 " .. TargetPlayer, 2)
            end
        else
            Notify("錯誤", "找不到目標玩家", 2)
        end
    end
})

TeleportTab:AddButton({
    Name = "傳送到隨機玩家",
    Callback = function()
        local players = GetPlayers()
        if #players == 0 then
            Notify("錯誤", "沒有其他玩家", 2)
            return
        end
        
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if UpdateCharacter() then
                RootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                Notify("傳送", "已傳送到 " .. randomPlayer.Name, 2)
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "傳送所有人到我身邊",
    Callback = function()
        if not UpdateCharacter() then return end
        
        for _, player in pairs(GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    player.Character.HumanoidRootPart.CFrame = RootPart.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
                end)
            end
        end
        Notify("傳送", "已嘗試傳送所有人", 2)
    end
})

-- === 位置傳送 ===
TeleportTab:AddSection({Name = "📍 位置系統"})

TeleportTab:AddButton({
    Name = "儲存當前位置",
    Callback = function()
        if UpdateCharacter() then
            table.insert(Settings.Teleport.SavedPositions, RootPart.CFrame)
            Notify("位置", "已儲存位置 #" .. #Settings.Teleport.SavedPositions, 2)
        end
    end
})

TeleportTab:AddButton({
    Name = "傳送到上個儲存位置",
    Callback = function()
        if #Settings.Teleport.SavedPositions == 0 then
            Notify("錯誤", "沒有儲存的位置", 2)
            return
        end
        
        if UpdateCharacter() then
            RootPart.CFrame = Settings.Teleport.SavedPositions[#Settings.Teleport.SavedPositions]
            Notify("傳送", "已傳送到儲存位置 #" .. #Settings.Teleport.SavedPositions, 2)
        end
    end
})

TeleportTab:AddButton({
    Name = "清除所有儲存位置",
    Callback = function()
        Settings.Teleport.SavedPositions = {}
        Notify("位置", "已清除所有儲存位置", 2)
    end
})

-- === 快速傳送 ===
TeleportTab:AddSection({Name = "⚡ 快速傳送"})

TeleportTab:AddButton({
    Name = "傳送到地圖中心",
    Callback = function()
        if UpdateCharacter() then
            RootPart.CFrame = CFrame.new(0, 100, 0)
        end
    end
})

TeleportTab:AddButton({
    Name = "傳送到天空",
    Callback = function()
        if UpdateCharacter() then
            RootPart.CFrame = RootPart.CFrame + Vector3.new(0, 500, 0)
        end
    end
})

TeleportTab:AddButton({
    Name = "傳送到地底",
    Callback = function()
        if UpdateCharacter() then
            RootPart.CFrame = RootPart.CFrame - Vector3.new(0, 100, 0)
        end
    end
})

TeleportTab:AddButton({
    Name = "傳送到重生點",
    Callback = function()
        local spawns = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildOfClass("SpawnLocation")
        if spawns and UpdateCharacter() then
            RootPart.CFrame = spawns.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

print("[NukeBot] 傳送系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              世界系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local WorldTab = Window:MakeTab({
    Name = "🌍 世界",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === 物理設定 ===
WorldTab:AddSection({Name = "⚙️ 物理設定"})

WorldTab:AddSlider({
    Name = "重力",
    Min = 0,
    Max = 500,
    Default = 196,
    Increment = 20,
    Callback = function(value)
        Settings.World.Gravity = value
        Workspace.Gravity = value
    end
})

WorldTab:AddSlider({
    Name = "跳躍高度",
    Min = 1,
    Max = 50,
    Default = 7.2,
    Increment = 1,
    Callback = function(value)
        Settings.World.JumpHeight = value
        if UpdateCharacter() and Humanoid then
            Humanoid.JumpHeight = value
        end
    end
})

WorldTab:AddButton({
    Name = "重設物理",
    Callback = function()
        Workspace.Gravity = 196.2
        if UpdateCharacter() and Humanoid then
            Humanoid.JumpHeight = 7.2
        end
        Notify("世界", "已重設物理", 2)
    end
})

-- === 環境設定 ===
WorldTab:AddSection({Name = "🌤️ 環境設定"})

WorldTab:AddButton({
    Name = "白天模式",
    Callback = function()
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    end
})

WorldTab:AddButton({
    Name = "夜晚模式",
    Callback = function()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.fromRGB(50, 50, 80)
    end
})

WorldTab:AddButton({
    Name = "夜視模式",
    Callback = function()
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
        Notify("視覺", "夜視模式已開啟", 2)
    end
})

WorldTab:AddButton({
    Name = "血月模式",
    Callback = function()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.new(0.5, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0, 0)
        Notify("視覺", "血月模式已開啟", 2)
    end
})

WorldTab:AddButton({
    Name = "重設環境",
    Callback = function()
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Notify("世界", "已重設環境", 2)
    end
})

print("[NukeBot] 世界系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              雜項系統 UI                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local MiscTab = Window:MakeTab({
    Name = "⚙️ 雜項",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- === 防護功能 ===
MiscTab:AddSection({Name = "🛡️ 防護功能"})

MiscTab:AddToggle({
    Name = "Anti-AFK",
    Default = true,
    Callback = function(value)
        Settings.Misc.AntiAFK = value
    end
})

MiscTab:AddToggle({
    Name = "反檢測",
    Default = false,
    Callback = function(value)
        Settings.Misc.AntiDetection = value
    end
})

-- === 聊天功能 ===
MiscTab:AddSection({Name = "💬 聊天功能"})

MiscTab:AddToggle({
    Name = "聊天刷屏",
    Default = false,
    Callback = function(value)
        Settings.Misc.ChatSpam.Enabled = value
    end
})

MiscTab:AddTextbox({
    Name = "刷屏訊息",
    Default = "NukeBot v7.0",
    TextDisappear = false,
    Callback = function(value)
        Settings.Misc.ChatSpam.Message = value
    end
})

MiscTab:AddSlider({
    Name = "刷屏間隔 (秒)",
    Min = 1,
    Max = 10,
    Default = 3,
    Increment = 1,
    Callback = function(value)
        Settings.Misc.ChatSpam.Delay = value
    end
})

-- === 伺服器功能 ===
MiscTab:AddSection({Name = "🌐 伺服器功能"})

MiscTab:AddButton({
    Name = "重新加入伺服器",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

MiscTab:AddButton({
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
    end
})

-- === 角色功能 ===
MiscTab:AddSection({Name = "👤 角色功能"})

MiscTab:AddButton({
    Name = "重生",
    Callback = function()
        if UpdateCharacter() and Humanoid then
            Humanoid.Health = 0
        end
    end
})

MiscTab:AddButton({
    Name = "重設角色屬性",
    Callback = function()
        if UpdateCharacter() and Humanoid then
            Humanoid.WalkSpeed = 16
            Humanoid.JumpPower = 50
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
            
            Settings.Movement.Speed.Enabled = false
            Settings.Movement.Fly.Enabled = false
            Settings.Movement.Noclip.Enabled = false
            Settings.Combat.Defense.GodMode = false
            
            Notify("角色", "已重設所有屬性", 2)
        end
    end
})

MiscTab:AddButton({
    Name = "複製位置座標",
    Callback = function()
        if UpdateCharacter() then
            local pos = RootPart.Position
            local str = string.format("CFrame.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
            
            if setclipboard then
                setclipboard(str)
                Notify("複製", "位置已複製到剪貼簿", 2)
            else
                Notify("錯誤", "剪貼簿功能不可用", 2)
            end
        end
    end
})

-- === 遊戲資訊 ===
MiscTab:AddSection({Name = "📊 遊戲資訊"})

MiscTab:AddButton({
    Name = "顯示遊戲資訊",
    Callback = function()
        local info = string.format(
            "遊戲名稱: %s\n遊戲 ID: %d\n伺服器 ID: %s\n玩家數量: %d\nFPS: %.0f",
            CurrentGame.Name,
            game.PlaceId,
            game.JobId,
            #Players:GetPlayers(),
            1 / RunService.Heartbeat:Wait()
        )
        Notify("遊戲資訊", info, 10)
    end
})

MiscTab:AddButton({
    Name = "列出所有玩家",
    Callback = function()
        local list = "玩家列表:\n"
        for _, player in pairs(Players:GetPlayers()) do
            list = list .. "• " .. player.Name .. "\n"
        end
        Notify("玩家", list, 10)
    end
})

print("[NukeBot] 雜項系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              設定 UI                                         ║
-- ═══════════════════════════════════════════════════════════════════════════════

local SettingsTab = Window:MakeTab({
    Name = "📁 設定",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddSection({Name = "🎨 UI 設定"})

SettingsTab:AddDropdown({
    Name = "主題",
    Default = "Dark",
    Options = {"Dark", "Light", "Blue", "Red", "Green"},
    Callback = function(value)
        Settings.UI.Theme = value
    end
})

SettingsTab:AddToggle({
    Name = "顯示通知",
    Default = true,
    Callback = function(value)
        Settings.UI.Notifications = value
    end
})

SettingsTab:AddToggle({
    Name = "播放音效",
    Default = true,
    Callback = function(value)
        Settings.UI.Sounds = value
    end
})

SettingsTab:AddSection({Name = "ℹ️ 腳本資訊"})

SettingsTab:AddLabel(SCRIPT_NAME .. " v" .. VERSION)
SettingsTab:AddLabel("遊戲: " .. CurrentGame.Name)
SettingsTab:AddLabel("類型: " .. CurrentGame.Type)
SettingsTab:AddLabel("按 RightShift 開關 UI")

SettingsTab:AddButton({
    Name = "關閉腳本",
    Callback = function()
        OrionLib:Destroy()
    end
})

print("[NukeBot] 設定系統已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              核心邏輯系統                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[NukeBot] 正在載入核心邏輯...")

-- === 飛行邏輯 ===
RunService.Heartbeat:Connect(function()
    if FlyActive and FlyBodyVelocity and FlyBodyGyro then
        if not UpdateCharacter() then return end
        
        local cf = Camera.CFrame
        local direction = Vector3.zero
        
        -- WASD 移動
        if IsKeyDown(Enum.KeyCode.W) then direction = direction + cf.LookVector end
        if IsKeyDown(Enum.KeyCode.S) then direction = direction - cf.LookVector end
        if IsKeyDown(Enum.KeyCode.A) then direction = direction - cf.RightVector end
        if IsKeyDown(Enum.KeyCode.D) then direction = direction + cf.RightVector end
        
        -- 上下移動
        if IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.yAxis end
        if IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.yAxis end
        
        -- 速度計算
        local speed = Settings.Movement.Fly.Speed
        if IsKeyDown(Enum.KeyCode.LeftShift) then
            speed = speed * 3 -- Shift 加速
        end
        
        -- 應用速度
        if direction.Magnitude > 0 then
            FlyBodyVelocity.Velocity = direction.Unit * speed
        else
            FlyBodyVelocity.Velocity = Vector3.zero
        end
        
        -- 保持方向
        FlyBodyGyro.CFrame = cf
    end
end)

-- === Noclip 邏輯 ===
RunService.Stepped:Connect(function()
    if Settings.Movement.Noclip.Enabled then
        if not UpdateCharacter() then return end
        
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- === 穿地板邏輯 ===
RunService.Heartbeat:Connect(function()
    if Settings.Movement.Phase.Enabled then
        if not UpdateCharacter() then return end
        
        if IsKeyDown(Enum.KeyCode.LeftShift) then
            RootPart.CFrame = RootPart.CFrame - Vector3.new(0, Settings.Movement.Phase.Speed, 0)
        end
    end
end)

-- === 速度保持 ===
RunService.Heartbeat:Connect(function()
    if Settings.Movement.Speed.Enabled then
        if not UpdateCharacter() or not Humanoid then return end
        
        local targetSpeed = 16 * Settings.Movement.Speed.Multiplier * CurrentGame.SpeedMult
        if Humanoid.WalkSpeed ~= targetSpeed then
            Humanoid.WalkSpeed = targetSpeed
        end
    end
end)

-- === 無限跳躍 ===
UserInputService.JumpRequest:Connect(function()
    if Settings.Movement.Jump.InfiniteJump then
        if UpdateCharacter() and Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- === 自動跳躍 ===
RunService.Heartbeat:Connect(function()
    if Settings.Movement.Jump.AutoJump then
        if UpdateCharacter() and Humanoid then
            Humanoid.Jump = true
        end
    end
end)

-- === 連跳 (BHop) ===
RunService.Heartbeat:Connect(function()
    if Settings.Movement.Jump.BHop then
        if UpdateCharacter() and Humanoid then
            if Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid.Jump = true
            end
        end
    end
end)

-- === 蜘蛛爬牆 ===
RunService.Heartbeat:Connect(function()
    if Settings.Movement.Spider.Enabled then
        if not UpdateCharacter() or not Humanoid then return end
        
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {Character}
        
        local result = Workspace:Raycast(RootPart.Position, RootPart.CFrame.LookVector * 2.5, params)
        
        if result then
            RootPart.Velocity = Vector3.new(
                RootPart.Velocity.X,
                Settings.Movement.Spider.ClimbSpeed,
                RootPart.Velocity.Z
            )
        end
    end
end)

-- === 空中行走 ===
local AirWalkPlatform = nil
RunService.Heartbeat:Connect(function()
    if Settings.Movement.AirWalk then
        if not UpdateCharacter() then return end
        
        if not AirWalkPlatform then
            AirWalkPlatform = Instance.new("Part")
            AirWalkPlatform.Name = "AirWalkPlatform"
            AirWalkPlatform.Size = Vector3.new(5, 0.5, 5)
            AirWalkPlatform.Transparency = 1
            AirWalkPlatform.Anchored = true
            AirWalkPlatform.CanCollide = true
            AirWalkPlatform.Parent = Workspace
        end
        
        AirWalkPlatform.CFrame = RootPart.CFrame * CFrame.new(0, -3.5, 0)
    else
        if AirWalkPlatform then
            AirWalkPlatform:Destroy()
            AirWalkPlatform = nil
        end
    end
end)

-- === 點擊傳送 ===
Mouse.Button1Down:Connect(function()
    if Settings.Movement.ClickTP then
        if UpdateCharacter() and Mouse.Target then
            RootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- === 防掉落虛空 ===
RunService.Heartbeat:Connect(function()
    if Settings.Movement.AntiVoid then
        if UpdateCharacter() and RootPart.Position.Y < -50 then
            RootPart.CFrame = CFrame.new(0, 100, 0)
        end
    end
end)

-- === 自動重生 ===
if Humanoid then
    Humanoid.Died:Connect(function()
        if Settings.Movement.AutoRespawn then
            task.wait(1)
            pcall(function()
                LocalPlayer:LoadCharacter()
            end)
        end
    end)
end

-- === 半無敵 (自動回血) ===
RunService.Heartbeat:Connect(function()
    if Settings.Combat.Defense.SemiGod then
        if UpdateCharacter() and Humanoid then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end
end)

-- === 抗擊退 ===
RunService.Heartbeat:Connect(function()
    if Settings.Combat.Defense.AntiKnockback then
        if UpdateCharacter() and RootPart then
            RootPart.Velocity = Vector3.new(0, RootPart.Velocity.Y, 0)
            RootPart.RotVelocity = Vector3.zero
        end
    end
end)

-- === 防倒地 ===
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.StateChanged:Connect(function(old, new)
        if Settings.Combat.Defense.AntiRagdoll then
            if new == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
end)

-- === Kill Aura ===
spawn(function()
    while task.wait(Settings.Combat.KillAura.Delay) do
        if Settings.Combat.KillAura.Enabled then
            if not UpdateCharacter() then continue end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                    
                    if targetRoot and targetHum and targetHum.Health > 0 then
                        local distance = GetDistance(targetRoot.Position)
                        
                        if distance <= Settings.Combat.KillAura.Range then
                            -- 根據模式執行
                            if Settings.Combat.KillAura.Mode == "Touch" then
                                pcall(function()
                                    if firetouchinterest then
                                        firetouchinterest(RootPart, targetRoot, 0)
                                        task.wait()
                                        firetouchinterest(RootPart, targetRoot, 1)
                                    end
                                end)
                            elseif Settings.Combat.KillAura.Mode == "TP" then
                                pcall(function()
                                    local oldCF = RootPart.CFrame
                                    RootPart.CFrame = targetRoot.CFrame
                                    task.wait()
                                    RootPart.CFrame = oldCF
                                end)
                            elseif Settings.Combat.KillAura.Mode == "Fling" then
                                pcall(function()
                                    targetRoot.Velocity = Vector3.new(
                                        math.random(-1000, 1000),
                                        500,
                                        math.random(-1000, 1000)
                                    )
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
                    if Settings.Combat.Hitbox.Enabled then
                        hrp.Size = Vector3.one * Settings.Combat.Hitbox.Size
                        hrp.Transparency = Settings.Combat.Hitbox.ShowHitbox and 0.5 or 1
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
local function GetClosestTarget()
    local closest = nil
    local closestDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- 隊伍檢查
            if Settings.Aim.Aimbot.TeamCheck and IsTeammate(player) then
                continue
            end
            
            local part = player.Character:FindFirstChild(Settings.Aim.Aimbot.Part) or
                         player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if part and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    
                    if dist < Settings.Aim.Aimbot.FOV and dist < closestDist then
                        -- 可見檢查
                        if Settings.Aim.Aimbot.VisibleCheck then
                            if not IsVisible(part) then
                                continue
                            end
                        end
                        
                        closest = part
                        closestDist = dist
                    end
                end
            end
        end
    end
    
    return closest
end

RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Settings.Aim.Aimbot.Enabled and IsMouseButtonDown(2) then
        local target = GetClosestTarget()
        
        if target then
            local targetPos = target.Position
            
            -- 預測
            if Settings.Aim.Aimbot.Prediction > 0 then
                local targetVel = target.Parent:FindFirstChild("HumanoidRootPart")
                if targetVel then
                    targetPos = targetPos + (targetVel.Velocity * Settings.Aim.Aimbot.Prediction * 0.01)
                end
            end
            
            local targetCF = CFrame.lookAt(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Aim.Aimbot.Smoothness)
        end
    end
    
    -- FOV
    if Settings.Visual.CustomFOV then
        Camera.FieldOfView = Settings.Visual.FOVValue
    end
    
    -- 時間凍結
    if Settings.Visual.TimeFreeze then
        Lighting.ClockTime = Settings.Visual.CustomTime
    end
end)

-- === TriggerBot ===
spawn(function()
    while task.wait(0.01) do
        if Settings.Aim.TriggerBot.Enabled then
            if not UpdateCharacter() then continue end
            
            local target = Mouse.Target
            if target then
                local player = Players:GetPlayerFromCharacter(target:FindFirstAncestorOfClass("Model"))
                
                if player and player ~= LocalPlayer then
                    if Settings.Aim.Aimbot.TeamCheck and IsTeammate(player) then
                        continue
                    end
                    
                    task.wait(Settings.Aim.TriggerBot.Delay)
                    
                    if Settings.Aim.TriggerBot.BurstMode then
                        for i = 1, Settings.Aim.TriggerBot.BurstCount do
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

-- === ESP 創建函數 ===
local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    if ESPStorage[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local data = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Settings.ESP.Colors.Enemy
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.Parent = char
    data.Highlight = highlight
    
    -- Billboard
    local head = char:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Parent = billboard
        
        local layout = Instance.new("UIListLayout")
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Parent = container
        
        -- 名稱
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.Size = UDim2.new(1, 0, 0, 18)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Text = player.Name
        nameLabel.Parent = container
        
        -- 血量
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Name = "Health"
        healthLabel.Size = UDim2.new(1, 0, 0, 16)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextColor3 = Color3.new(0, 1, 0)
        healthLabel.TextStrokeTransparency = 0
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextSize = 12
        healthLabel.Parent = container
        
        -- 距離
        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "Distance"
        distLabel.Size = UDim2.new(1, 0, 0, 16)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.new(1, 1, 0)
        distLabel.TextStrokeTransparency = 0
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 12
        distLabel.Parent = container
        
        data.Billboard = billboard
    end
    
    ESPStorage[player] = data
end

-- === ESP 更新 ===
RunService.Heartbeat:Connect(function()
    if not Settings.ESP.Enabled then return end
    if not UpdateCharacter() then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- 隊伍檢查
            if Settings.ESP.TeamCheck and IsTeammate(player) then
                continue
            end
            
            -- 創建 ESP
            if not ESPStorage[player] then
                CreatePlayerESP(player)
            end
            
            local data = ESPStorage[player]
            if not data then continue end
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum then
                local dist = math.floor(GetDistance(hrp.Position))
                
                -- 距離檢查
                if dist > Settings.ESP.MaxDistance then
                    if data.Highlight then data.Highlight.Enabled = false end
                    if data.Billboard then data.Billboard.Enabled = false end
                    continue
                else
                    if data.Highlight then data.Highlight.Enabled = true end
                    if data.Billboard then data.Billboard.Enabled = true end
                end
                
                -- 更新顏色 (根據距離)
                if data.Highlight then
                    if dist < 30 then
                        data.Highlight.FillColor = Color3.new(1, 0, 0) -- 紅色 (近)
                    elseif dist < 60 then
                        data.Highlight.FillColor = Color3.new(1, 1, 0) -- 黃色 (中)
                    else
                        data.Highlight.FillColor = Color3.new(0, 1, 0) -- 綠色 (遠)
                    end
                end
                
                -- 更新資訊
                if data.Billboard then
                    local healthLabel = data.Billboard:FindFirstChild("Health", true)
                    local distLabel = data.Billboard:FindFirstChild("Distance", true)
                    
                    if healthLabel then
                        healthLabel.Text = "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                        
                        local healthPercent = hum.Health / hum.MaxHealth
                        healthLabel.TextColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
                    end
                    
                    if distLabel then
                        distLabel.Text = dist .. " studs"
                    end
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
                local existing = player.Character:FindFirstChild("Chams_Highlight")
                
                if Settings.ESP.Chams.Enabled then
                    if not existing then
                        local hl = Instance.new("Highlight")
                        hl.Name = "Chams_Highlight"
                        hl.FillColor = Settings.ESP.Colors.Enemy
                        hl.OutlineColor = Color3.new(1, 1, 0)
                        hl.FillTransparency = Settings.ESP.Chams.FillTransparency
                        hl.OutlineTransparency = Settings.ESP.Chams.OutlineTransparency
                        hl.DepthMode = Settings.ESP.Chams.DepthMode
                        hl.Parent = player.Character
                    else
                        existing.FillTransparency = Settings.ESP.Chams.FillTransparency
                        existing.OutlineTransparency = Settings.ESP.Chams.OutlineTransparency
                    end
                else
                    if existing then
                        existing:Destroy()
                    end
                end
            end
        end
    end
end)

-- === 玩家離開清理 ===
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
        if Settings.Misc.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- === 聊天刷屏 ===
spawn(function()
    while task.wait(Settings.Misc.ChatSpam.Delay) do
        if Settings.Misc.ChatSpam.Enabled then
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                    Settings.Misc.ChatSpam.Message,
                    "All"
                )
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              初始化完成                                      ║
-- ═══════════════════════════════════════════════════════════════════════════════

-- 初始化 Orion
OrionLib:Init()

-- 顯示載入通知
Notify(
    SCRIPT_NAME .. " v" .. VERSION,
    "已成功載入！\n遊戲: " .. CurrentGame.Name .. "\n按 RightShift 開關 UI\n共 100+ 功能模組",
    10
)

-- 控制台輸出
print("═══════════════════════════════════════════════════════════════")
print("   " .. SCRIPT_NAME .. " v" .. VERSION .. " 已成功載入!")
print("   遊戲: " .. CurrentGame.Name .. " (" .. CurrentGame.Type .. ")")
print("   日期: " .. BUILD_DATE)
print("   功能: 100+ 模組")
print("═══════════════════════════════════════════════════════════════")
print("[NukeBot] 所有系統已就緒!")
