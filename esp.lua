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

local VERSION = "7.5"
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
    
    -- 自動格擋 (新功能)
    AutoParry = false, AutoParryRange = 25, AutoParryDelay = 0.12,
    
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
    
    -- 物品/寶箱透視 (新功能)
    ItemESP = false, ChestESP = false,
    
    -- 視覺
    Fullbright = false, NoFog = false, NoShadows = false,
    CustomAmbient = false, AmbientColor = Color3.new(1, 1, 1),
    TimeFreeze = false, CustomTime = 14,
    CustomFOV = false, FOVValue = 90,
    ThirdPerson = false, TPDistance = 10,
    NoParticles = false, NoEffects = false, LowGraphics = false,
    ShowCrosshair = false, CrosshairSize = 10, CrosshairColor = Color3.new(0, 1, 0),
    
    -- 透視鏡頭 (新功能)
    WallHack = false,
    
    -- 世界
    Gravity = 196.2, JumpHeight = 7.2,
    
    -- 雜項
    AntiAFK = true, ChatSpam = false, SpamMessage = "Zy hacker hub v7.0", SpamDelay = 3,
    
    -- 自動刷怪 (新功能)
    AutoFarm = false, FarmRadius = 100, FarmTarget = "NPC",
    
    -- 反瞄準 & 旋轉 (新功能)
    AntiAim = false, AntiAimSpeed = 500,
    SpinBot = false, SpinSpeed = 10,
    
    -- 聊天指令 (新功能)
    ChatCommands = true,
    
    -- 傳送 & 航點 (增強)
    SavedPositions = {},
    Waypoints = {},
    
    -- 快捷鍵綁定 (新功能)
    Keybinds = {
        Fly = Enum.KeyCode.F,
        Noclip = Enum.KeyCode.V,
        Speed = Enum.KeyCode.G,
        ESP = Enum.KeyCode.X,
        God = Enum.KeyCode.H,
    },
    KeybindsEnabled = true,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ║                    進階功能設定 v2.0                        ║
    -- ═══════════════════════════════════════════════════════════════
    
    -- 進階戰鬥
    ReachHack = false, ReachDistance = 15,
    AutoCombo = false, ComboDelay = 0.1,
    PunchAura = false, PunchRange = 10,
    TargetLock = false, LockedTarget = nil,
    TeleportAura = false, TPAuraRange = 20,
    
    -- 進階 ESP
    NPCESP = false,
    TracerLines = false, TracerColor = Color3.new(1, 0, 0),
    SkeletonESP = false,
    
    -- 進階移動
    LongJump = false, LongJumpPower = 100,
    AutoLadder = false,
    PlatformStand = false,
    
    -- Blade Ball 專用
    BladeBall = {
        AutoDodge = false,
        BallESP = false,
        AutoWin = false,
    },
    
    -- Blox Fruits 專用
    BloxFruits = {
        AutoQuest = false,
        FruitNotifier = false,
        IslandTP = false,
        AutoMastery = false,
    },
    
    -- Da Hood 專用
    DaHood = {
        AutoStomp = false,
        CashESP = false,
        SilentPunch = false,
    },
    
    -- Arsenal 專用
    Arsenal = {
        AutoSwap = false,
        AmmoESP = false,
        MeleeAura = false,
    },
    
    -- Rivals 專用
    Rivals = {
        SilentAim = false,
        NoRecoil = false,
        NoSpread = false,
        RapidFire = false,
        InfiniteAmmo = false,
        AutoShoot = false,
        HitboxExpander = false, HitboxSize = 5,
        ESP = false,
    },
    
    -- 防禦功能
    AntiDetect = false,
    SafeTP = false,
    LagSwitch = false, LagDuration = 0.5,
    
    -- 效能
    FPSBooster = false,
    SoundNotify = true,
    
    -- 進階瞄準
    AimbotPrediction = false, PredictionAmount = 0.1,
    HeadshotOnly = false,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ║                    原始功能增強 v3.0                        ║
    -- ═══════════════════════════════════════════════════════════════
    
    -- 飛行增強
    FlyMode = "Normal", -- Normal, Glide, Helicopter, Noclip
    FlyAcceleration = 50,
    FlyInertia = false,
    FlyStabilizer = true,
    
    -- 速度增強
    SpeedMode = "Constant", -- Constant, Acceleration, Burst
    SpeedAccel = 2,
    MaxSpeed = 500,
    SpeedBoostKey = Enum.KeyCode.LeftShift,
    
    -- Aimbot 增強
    AimMode = "Closest", -- Closest, Lowest HP, Highest Threat
    AimBone = "Head", -- Head, Torso, Random
    AimStickyTarget = false,
    AimThroughWalls = false,
    AimNotify = true,
    AimCircleAnim = true,
    
    -- ESP 增強
    ESPHealthBar = true,
    ESPArmorBar = false,
    ESPWeaponInfo = true,
    ESPTeamColor = true,
    ESPRainbow = false,
    ESPGlow = false,
    ESPOutlineOnly = false,
    
    -- Kill Aura 增強
    KillPriority = "Closest", -- Closest, Lowest HP, Random
    KillMultiTarget = false,
    MaxTargets = 3,
    KillSafeMode = false,
    KillVisualFX = true,
    
    -- God Mode 增強
    GodType = "Full", -- Full, Semi, Regen
    RegenRate = 10,
    RegenDelay = 0.5,
    
    -- Hitbox 增強
    HitboxShape = "Sphere", -- Sphere, Box, Cylinder
    HitboxHeadOnly = false,
    HitboxTransparency = 0.7,
    
    -- 視覺增強
    CustomSkybox = false,
    SkyboxID = "rbxassetid://1234567890",
    NightVision = false,
    XRay = false,
    
    -- 音效
    HitSound = false,
    HitSoundID = "rbxassetid://12221967",
    KillSound = false,
    KillSoundID = "rbxassetid://12221967",
    
    -- 角色外觀
    CharacterGlow = false,
    GlowColor = Color3.new(0, 1, 1),
    InvisibleArms = false,
    NoFace = false,
    
    -- 自動功能
    AutoCollect = false,
    AutoEquip = false,
    AutoUse = false,
    
    -- 記錄功能
    LogKills = true,
    LogDeaths = true,
    KillCount = 0,
    DeathCount = 0,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ║                    終極功能設定 v4.0                        ║
    -- ═══════════════════════════════════════════════════════════════
    
    -- 相機特效
    CameraShake = false, ShakeIntensity = 5,
    FOVAnimation = false, FOVPulse = false,
    CameraTilt = false, TiltAmount = 15,
    SmoothCamera = false, CameraSmoothness = 0.5,
    FreeLook = false,
    
    -- 武器增強
    AutoReload = false,
    InstantReload = false,
    NoReloadAnim = false,
    WeaponSway = false,
    NoGunBob = false,
    InstaKill = false,
    
    -- 進階移動
    BunnyHop = false,
    AutoStrafe = false,
    AirControl = false, AirControlAmount = 50,
    SlideHop = false,
    EdgeGlide = false,
    
    -- 進階戰鬥
    RageMode = false, RageMultiplier = 2,
    AutoBlock = false,
    PerfectParry = false,
    ComboExtend = false,
    CriticalHit = false, CritChance = 25,
    Backstab = false, BackstabMultiplier = 2,
    
    -- HUD 覆蓋
    ShowKillFeed = false,
    DamageNumbers = false,
    TargetInfo = false,
    Watermark = true,
    SessionStats = true,
    
    -- 準心進階
    DynamicCrosshair = false,
    CrosshairStyle = "Cross", -- Cross, Dot, Circle, Custom
    CrosshairGap = 5,
    CrosshairLength = 10,
    CrosshairThickness = 2,
    
    -- 統計追蹤
    SessionTime = 0,
    TotalDamage = 0,
    Headshots = 0,
    Accuracy = 0,
    ShotsFired = 0,
    ShotsHit = 0,
    
    -- 巨集系統
    MacroEnabled = false,
    MacroDelay = 50,
    
    -- 安全系統
    AutoDisable = false,
    DisableOnDeath = false,
    DisableNearAdmin = false,
    
    -- 網路
    PingDisplay = false,
    FPSDisplay = false,
    
    -- 通知
    NotifyOnKill = true,
    NotifyOnDeath = true,
    NotifyOnDamage = false,
    
    -- 遊戲內覆蓋
    ShowPlayerList = false,
    ShowRadar = false,
    RadarSize = 150,
    RadarZoom = 1,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ║                    精英功能設定 v5.0                        ║
    -- ═══════════════════════════════════════════════════════════════
    
    -- 設定檔系統
    CurrentProfile = "Default",
    Profiles = {},
    AutoSave = true,
    
    -- 巨集系統
    Macros = {},
    MacroRecording = false,
    CurrentMacro = nil,
    MacroPlaySpeed = 1,
    
    -- 反作弊繞過
    AntiCheatBypass = false,
    SpoofWalkSpeed = false,
    SpoofPosition = false,
    HideFromAdmins = false,
    AdminList = {},
    
    -- 玩家管理
    FriendList = {},
    EnemyList = {},
    TargetPriority = "Enemy", -- Enemy, All, Friend
    IgnoreFriends = true,
    HighlightFriends = true,
    HighlightEnemies = true,
    
    -- 觀戰模式
    SpectatorMode = false,
    SpectatedPlayer = nil,
    SpectatorDistance = 10,
    
    -- 世界操控
    CustomGravity = false, GravityValue = 196.2,
    CustomJumpHeight = false, JumpHeightValue = 50,
    TimeControl = false, TimeValue = 14,
    WeatherControl = false, WeatherType = "Clear",
    
    -- 物體操控
    ObjectManipulation = false,
    GrabDistance = 50,
    ThrowPower = 100,
    
    -- 角色複製
    CharacterClone = false,
    CloneCount = 1,
    
    -- 聊天功能
    ChatBypass = false,
    AutoTranslate = false,
    ChatLogger = false,
    ChatLogs = {},
    
    -- 調試工具
    ShowDebugInfo = false,
    LogErrors = true,
    ErrorLogs = {},
    RemoteLogger = false,
    
    -- 自動化
    AutoPlay = false,
    AFKFarm = false,
    AutoDodge = false,
    AutoHealItems = false,
    
    -- 社交功能
    PlayerNotes = {},
    
    -- UI 主題
    UITheme = "Cyber", -- Cyber, Dark, Light, Neon, Blood
    AccentColor = Color3.new(0, 1, 1),
    
    -- 快捷選單
    QuickMenu = true,
    QuickMenuKey = Enum.KeyCode.Tab,
    
    -- 目標資訊
    TargetBone = "Head",
    ShowTargetHealth = true,
    ShowTargetDistance = true,
    ShowTargetWeapon = true,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ║                    終極功能設定 v6.0                        ║
    -- ═══════════════════════════════════════════════════════════════
    
    -- 高級 ESP
    ESPPrediction = false,
    ESPVelocity = false,
    ESPAimLine = false,
    ESPBoundingBox = true,
    ESP3DBox = false,
    ESPCornerBox = false,
    ESPFilledBox = false,
    ESPSnaplines = false,
    ESPLookDirection = false,
    
    -- 高級 Aimbot
    AimbotFlick = false, FlickSpeed = 0.1,
    AimbotMagnetism = false, MagnetismStrength = 50,
    AimbotAutoFire = false,
    AimbotLeading = false, LeadAmount = 0.15,
    AimbotBodyAim = false,
    AimbotNearestBone = false,
    AimbotAntiRecoil = false,
    AimbotShakeReduction = 50,
    
    -- 流暢移動
    MomentumBased = false,
    AutoSlide = false,
    WallRun = false, WallRunSpeed = 30,
    DoubleJump = false, DoubleJumpPower = 50,
    DashAbility = false, DashDistance = 20, DashCooldown = 1,
    GrappleHook = false, GrappleRange = 100,
    
    -- 自動功能擴展
    AutoAim = false,
    AutoShoot = false,
    AutoKill = false,
    AutoLoot = false,
    AutoRevive = false,
    AutoBuild = false,
    
    -- 效能增強
    UltraLowGraphics = false,
    DisableRenderDistance = false,
    StreamingEnabled = true,
    TextureQuality = "High",
    ShadowQuality = "Medium",
    ParticleQuality = "High",
    
    -- 網路優化
    LagCompensation = false,
    InterpolationAmount = 0.1,
    ExtrapolationEnabled = false,
    
    -- 視覺增強
    MotionBlur = false, BlurAmount = 0.5,
    ChromaticAberration = false,
    Vignette = false, VignetteIntensity = 0.3,
    FilmGrain = false,
    ColorGrading = false,
    Saturation = 1,
    Contrast = 1,
    Brightness = 1,
    
    -- 高級準心
    CrosshairDot = true,
    CrosshairOutline = true,
    CrosshairT = false,
    CrosshairX = false,
    HitmarkerEnabled = true,
    HitmarkerSound = true,
    HitmarkerColor = Color3.new(1, 0, 0),
    
    -- 擊殺特效
    KillEffect = false,
    KillEffectType = "Confetti", -- Confetti, Explosion, Fade
    KillCamera = false,
    KillReplay = false,
    
    -- 第一人稱角色隱藏 (Arsenal/Rivals 專用)
    FirstPersonInvisible = false,
    HideHead = true,
    HideTorso = true,
    HideArms = false,  -- 保留手臂以便看到武器
    HideLegs = true,
    HideAccessories = true,
    AutoHideInFPS = true,  -- 自動偵測第一人稱
    
    -- 角色透明度
    CharacterTransparency = false,
    TransparencyAmount = 0.5,
    GhostMode = false,  -- 完全隱形
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

MoveTab:CreateDropdown({
    Name = "飛行模式",
    Options = {"Normal", "Glide", "Helicopter", "Noclip"},
    CurrentOption = {"Normal"},
    Flag = "FlyMode",
    Callback = function(v) Settings.FlyMode = v end,
})

MoveTab:CreateToggle({
    Name = "飛行慣性 (滑翔效果)",
    CurrentValue = false,
    Flag = "FlyInertiaToggle",
    Callback = function(v) Settings.FlyInertia = v end,
})

MoveTab:CreateToggle({
    Name = "飛行穩定器",
    CurrentValue = true,
    Flag = "FlyStabilizerToggle",
    Callback = function(v) Settings.FlyStabilizer = v end,
})

MoveTab:CreateSlider({
    Name = "飛行加速度",
    Range = {10, 200},
    Increment = 10,
    CurrentValue = 50,
    Flag = "FlyAcceleration",
    Callback = function(v) Settings.FlyAcceleration = v end,
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

MoveTab:CreateDropdown({
    Name = "速度模式",
    Options = {"Constant", "Acceleration", "Burst"},
    CurrentOption = {"Constant"},
    Flag = "SpeedMode",
    Callback = function(v)
        Settings.SpeedMode = v
        Rayfield:Notify({Title = "速度", Content = "模式: " .. v, Duration = 2})
    end,
})

MoveTab:CreateSlider({
    Name = "最大速度",
    Range = {100, 1000},
    Increment = 50,
    CurrentValue = 500,
    Flag = "MaxSpeed",
    Callback = function(v) Settings.MaxSpeed = v end,
})

MoveTab:CreateSlider({
    Name = "加速率",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 2,
    Flag = "SpeedAccel",
    Callback = function(v) Settings.SpeedAccel = v end,
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

MoveTab:CreateSection("🚀 進階移動")

MoveTab:CreateToggle({
    Name = "Long Jump (超長跳躍)",
    CurrentValue = false,
    Flag = "LongJumpToggle",
    Callback = function(v)
        Settings.LongJump = v
        if v then Rayfield:Notify({Title = "跳躍", Content = "超長跳躍已開啟 - 按住 Space", Duration = 2}) end
    end,
})

MoveTab:CreateSlider({
    Name = "跳躍力量",
    Range = {50, 300},
    Increment = 25,
    CurrentValue = 100,
    Flag = "LongJumpPower",
    Callback = function(v) Settings.LongJumpPower = v end,
})

MoveTab:CreateToggle({
    Name = "Auto Ladder (自動爬梯)",
    CurrentValue = false,
    Flag = "AutoLadderToggle",
    Callback = function(v)
        Settings.AutoLadder = v
        if v then Rayfield:Notify({Title = "移動", Content = "自動爬梯子已開啟", Duration = 2}) end
    end,
})

MoveTab:CreateToggle({
    Name = "Platform Stand (空中懸停)",
    CurrentValue = false,
    Flag = "PlatformStandToggle",
    Callback = function(v)
        Settings.PlatformStand = v
        if UpdateChar() and Humanoid then
            Humanoid.PlatformStand = v
        end
        if v then Rayfield:Notify({Title = "移動", Content = "空中懸停已開啟", Duration = 2}) end
    end,
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

CombatTab:CreateSection("🛡️ 自動格擋 (Auto Parry)")

CombatTab:CreateToggle({
    Name = "自動格擋",
    CurrentValue = false,
    Flag = "AutoParryToggle",
    Callback = function(v)
        Settings.AutoParry = v
        if v then Rayfield:Notify({Title = "格擋", Content = "自動格擋已開啟 - 適用於 Blade Ball", Duration = 3}) end
    end,
})

CombatTab:CreateSlider({
    Name = "格擋範圍",
    Range = {5, 50},
    Increment = 5,
    CurrentValue = 25,
    Flag = "AutoParryRange",
    Callback = function(v) Settings.AutoParryRange = v end,
})

CombatTab:CreateSlider({
    Name = "格擋延遲 (秒)",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.12,
    Flag = "AutoParryDelay",
    Callback = function(v) Settings.AutoParryDelay = v end,
})

CombatTab:CreateSection("🌀 反瞄準 & 旋轉")

CombatTab:CreateToggle({
    Name = "Anti-Aim (反瞄準)",
    CurrentValue = false,
    Flag = "AntiAimToggle",
    Callback = function(v)
        Settings.AntiAim = v
        if v then
            Settings.SpinBot = false
            Rayfield:Notify({Title = "Anti-Aim", Content = "反瞄準已開啟 - 讓敵人難以瞄準", Duration = 2})
        end
    end,
})

CombatTab:CreateSlider({
    Name = "Anti-Aim 速度",
    Range = {100, 1000},
    Increment = 50,
    CurrentValue = 500,
    Flag = "AntiAimSpeed",
    Callback = function(v) Settings.AntiAimSpeed = v end,
})

CombatTab:CreateToggle({
    Name = "Spin Bot (旋轉)",
    CurrentValue = false,
    Flag = "SpinBotToggle",
    Callback = function(v)
        Settings.SpinBot = v
        if v then
            Settings.AntiAim = false
            Rayfield:Notify({Title = "Spin Bot", Content = "角色旋轉已開啟", Duration = 2})
        end
    end,
})

CombatTab:CreateSlider({
    Name = "旋轉速度",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 10,
    Flag = "SpinSpeed",
    Callback = function(v) Settings.SpinSpeed = v end,
})

CombatTab:CreateSection("⚔️ 進階戰鬥")

CombatTab:CreateToggle({
    Name = "Reach Hack (延長攻擊距離)",
    CurrentValue = false,
    Flag = "ReachHackToggle",
    Callback = function(v)
        Settings.ReachHack = v
        if v then Rayfield:Notify({Title = "Reach", Content = "攻擊距離已延長", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "Reach 距離",
    Range = {5, 50},
    Increment = 5,
    CurrentValue = 15,
    Flag = "ReachDistance",
    Callback = function(v) Settings.ReachDistance = v end,
})

CombatTab:CreateToggle({
    Name = "Auto Combo (自動連擊)",
    CurrentValue = false,
    Flag = "AutoComboToggle",
    Callback = function(v)
        Settings.AutoCombo = v
        if v then Rayfield:Notify({Title = "Combo", Content = "自動連擊已開啟", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "連擊間隔 (秒)",
    Range = {0.05, 0.5},
    Increment = 0.05,
    CurrentValue = 0.1,
    Flag = "ComboDelay",
    Callback = function(v) Settings.ComboDelay = v end,
})

CombatTab:CreateToggle({
    Name = "Punch Aura (自動揮拳)",
    CurrentValue = false,
    Flag = "PunchAuraToggle",
    Callback = function(v)
        Settings.PunchAura = v
        if v then Rayfield:Notify({Title = "Punch", Content = "自動揮拳攻擊已開啟", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "揮拳範圍",
    Range = {5, 30},
    Increment = 5,
    CurrentValue = 10,
    Flag = "PunchRange",
    Callback = function(v) Settings.PunchRange = v end,
})

CombatTab:CreateToggle({
    Name = "Target Lock (鎖定目標)",
    CurrentValue = false,
    Flag = "TargetLockToggle",
    Callback = function(v)
        Settings.TargetLock = v
        if v then Rayfield:Notify({Title = "Lock", Content = "目標鎖定已開啟 - 按 Q 鎖定最近敵人", Duration = 3}) end
    end,
})

CombatTab:CreateToggle({
    Name = "Teleport Aura (瞬移攻擊)",
    CurrentValue = false,
    Flag = "TeleportAuraToggle",
    Callback = function(v)
        Settings.TeleportAura = v
        if v then Rayfield:Notify({Title = "TP Aura", Content = "瞬移到敵人背後攻擊", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "瞬移範圍",
    Range = {10, 50},
    Increment = 5,
    CurrentValue = 20,
    Flag = "TPAuraRange",
    Callback = function(v) Settings.TPAuraRange = v end,
})

CombatTab:CreateSection("💥 終極戰鬥")

CombatTab:CreateToggle({
    Name = "Rage Mode (狂暴模式)",
    CurrentValue = false,
    Flag = "RageModeToggle",
    Callback = function(v)
        Settings.RageMode = v
        if v then Rayfield:Notify({Title = "RAGE", Content = "狂暴模式已開啟！攻擊力 x" .. Settings.RageMultiplier, Duration = 3}) end
    end,
})

CombatTab:CreateSlider({
    Name = "狂暴倍率",
    Range = {1.5, 5},
    Increment = 0.5,
    CurrentValue = 2,
    Flag = "RageMultiplier",
    Callback = function(v) Settings.RageMultiplier = v end,
})

CombatTab:CreateToggle({
    Name = "Auto Block (自動格擋)",
    CurrentValue = false,
    Flag = "AutoBlockToggle",
    Callback = function(v)
        Settings.AutoBlock = v
        if v then Rayfield:Notify({Title = "Block", Content = "自動格擋已開啟", Duration = 2}) end
    end,
})

CombatTab:CreateToggle({
    Name = "Perfect Parry (完美格擋)",
    CurrentValue = false,
    Flag = "PerfectParryToggle",
    Callback = function(v)
        Settings.PerfectParry = v
        if v then Rayfield:Notify({Title = "Parry", Content = "完美格擋時機已開啟", Duration = 2}) end
    end,
})

CombatTab:CreateToggle({
    Name = "Critical Hit (暴擊)",
    CurrentValue = false,
    Flag = "CriticalHitToggle",
    Callback = function(v)
        Settings.CriticalHit = v
        if v then Rayfield:Notify({Title = "暴擊", Content = "暴擊率: " .. Settings.CritChance .. "%", Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "暴擊率 (%)",
    Range = {5, 100},
    Increment = 5,
    CurrentValue = 25,
    Flag = "CritChance",
    Callback = function(v) Settings.CritChance = v end,
})

CombatTab:CreateToggle({
    Name = "Backstab (背刺加成)",
    CurrentValue = false,
    Flag = "BackstabToggle",
    Callback = function(v)
        Settings.Backstab = v
        if v then Rayfield:Notify({Title = "背刺", Content = "背後攻擊傷害 x" .. Settings.BackstabMultiplier, Duration = 2}) end
    end,
})

CombatTab:CreateSlider({
    Name = "背刺倍率",
    Range = {1.5, 5},
    Increment = 0.5,
    CurrentValue = 2,
    Flag = "BackstabMultiplier",
    Callback = function(v) Settings.BackstabMultiplier = v end,
})

CombatTab:CreateToggle({
    Name = "Insta Kill (秒殺模式)",
    CurrentValue = false,
    Flag = "InstaKillToggle",
    Callback = function(v)
        Settings.InstaKill = v
        if v then Rayfield:Notify({Title = "⚠️ 秒殺", Content = "秒殺模式已開啟 - 高風險", Duration = 3}) end
    end,
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

AimTab:CreateSection("🎯 Aimbot 進階設定")

AimTab:CreateDropdown({
    Name = "瞄準模式",
    Options = {"Closest", "Lowest HP", "Highest Threat"},
    CurrentOption = {"Closest"},
    Flag = "AimMode",
    Callback = function(v)
        Settings.AimMode = v
        Rayfield:Notify({Title = "Aimbot", Content = "模式: " .. v, Duration = 2})
    end,
})

AimTab:CreateToggle({
    Name = "黏性目標 (保持鎖定)",
    CurrentValue = false,
    Flag = "AimStickyToggle",
    Callback = function(v) Settings.AimStickyTarget = v end,
})

AimTab:CreateToggle({
    Name = "穿牆瞄準",
    CurrentValue = false,
    Flag = "AimThroughWallsToggle",
    Callback = function(v) Settings.AimThroughWalls = v end,
})

AimTab:CreateToggle({
    Name = "只打頭",
    CurrentValue = false,
    Flag = "HeadshotOnlyToggle",
    Callback = function(v) Settings.HeadshotOnly = v end,
})

AimTab:CreateToggle({
    Name = "瞄準通知",
    CurrentValue = true,
    Flag = "AimNotifyToggle",
    Callback = function(v) Settings.AimNotify = v end,
})

AimTab:CreateToggle({
    Name = "FOV 圓圈動畫",
    CurrentValue = true,
    Flag = "AimCircleAnimToggle",
    Callback = function(v) Settings.AimCircleAnim = v end,
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

ESPTab:CreateSection("📊 ESP 進階顯示")

ESPTab:CreateToggle({
    Name = "血量條",
    CurrentValue = true,
    Flag = "ESPHealthBarToggle",
    Callback = function(v) Settings.ESPHealthBar = v end,
})

ESPTab:CreateToggle({
    Name = "武器資訊",
    CurrentValue = true,
    Flag = "ESPWeaponInfoToggle",
    Callback = function(v) Settings.ESPWeaponInfo = v end,
})

ESPTab:CreateToggle({
    Name = "隊伍顏色",
    CurrentValue = true,
    Flag = "ESPTeamColorToggle",
    Callback = function(v) Settings.ESPTeamColor = v end,
})

ESPTab:CreateToggle({
    Name = "彩虹模式 🌈",
    CurrentValue = false,
    Flag = "ESPRainbowToggle",
    Callback = function(v)
        Settings.ESPRainbow = v
        if v then Rayfield:Notify({Title = "ESP", Content = "彩虹模式已開啟!", Duration = 2}) end
    end,
})

ESPTab:CreateToggle({
    Name = "發光效果",
    CurrentValue = false,
    Flag = "ESPGlowToggle",
    Callback = function(v) Settings.ESPGlow = v end,
})

ESPTab:CreateToggle({
    Name = "只顯示輪廓",
    CurrentValue = false,
    Flag = "ESPOutlineOnlyToggle",
    Callback = function(v) Settings.ESPOutlineOnly = v end,
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

ESPTab:CreateSection("📦 物品透視")

ESPTab:CreateToggle({
    Name = "物品 ESP",
    CurrentValue = false,
    Flag = "ItemESPToggle",
    Callback = function(v)
        Settings.ItemESP = v
        if v then Rayfield:Notify({Title = "ESP", Content = "物品透視已開啟 - 顯示掉落武器", Duration = 2}) end
    end,
})

ESPTab:CreateToggle({
    Name = "寶箱 ESP (Blox Fruits)",
    CurrentValue = false,
    Flag = "ChestESPToggle",
    Callback = function(v)
        Settings.ChestESP = v
        if v then Rayfield:Notify({Title = "ESP", Content = "寶箱透視已開啟", Duration = 2}) end
    end,
})

ESPTab:CreateSection("🔮 透視功能")

ESPTab:CreateToggle({
    Name = "透視牆壁 (Wall Hack)",
    CurrentValue = false,
    Flag = "WallHackToggle",
    Callback = function(v)
        Settings.WallHack = v
        if v then Rayfield:Notify({Title = "透視", Content = "透視模式已開啟", Duration = 2}) end
    end,
})

ESPTab:CreateSection("🤖 進階 ESP")

ESPTab:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Flag = "NPCESPToggle",
    Callback = function(v)
        Settings.NPCESP = v
        if v then Rayfield:Notify({Title = "ESP", Content = "NPC 透視已開啟", Duration = 2}) end
    end,
})

ESPTab:CreateToggle({
    Name = "Tracer Lines (追蹤線)",
    CurrentValue = false,
    Flag = "TracerLinesToggle",
    Callback = function(v)
        Settings.TracerLines = v
        if v then Rayfield:Notify({Title = "ESP", Content = "從螢幕底部畫線到目標", Duration = 2}) end
    end,
})

ESPTab:CreateColorPicker({
    Name = "追蹤線顏色",
    Color = Color3.new(1, 0, 0),
    Flag = "TracerColor",
    Callback = function(v) Settings.TracerColor = v end,
})

ESPTab:CreateToggle({
    Name = "Skeleton ESP (骨架透視)",
    CurrentValue = false,
    Flag = "SkeletonESPToggle",
    Callback = function(v)
        Settings.SkeletonESP = v
        if v then Rayfield:Notify({Title = "ESP", Content = "骨架透視已開啟", Duration = 2}) end
    end,
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

VisualTab:CreateSection("🔮 進階視覺效果")

VisualTab:CreateToggle({
    Name = "夜視功能",
    CurrentValue = false,
    Flag = "NightVisionToggle",
    Callback = function(v)
        Settings.NightVision = v
        if v then
            Lighting.Brightness = 5
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        end
    end,
})

VisualTab:CreateToggle({
    Name = "X-Ray 視覺",
    CurrentValue = false,
    Flag = "XRayToggle",
    Callback = function(v)
        Settings.XRay = v
        if v then Rayfield:Notify({Title = "視覺", Content = "X-Ray 已開啟", Duration = 2}) end
    end,
})

VisualTab:CreateToggle({
    Name = "角色發光",
    CurrentValue = false,
    Flag = "CharacterGlowToggle",
    Callback = function(v)
        Settings.CharacterGlow = v
        if UpdateChar() then
            local existing = Character:FindFirstChild("CharGlow")
            if v then
                if not existing then
                    local hl = Instance.new("Highlight")
                    hl.Name = "CharGlow"
                    hl.FillColor = Settings.GlowColor
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.5
                    hl.Parent = Character
                end
            else
                if existing then existing:Destroy() end
            end
        end
    end,
})

VisualTab:CreateColorPicker({
    Name = "發光顏色",
    Color = Color3.new(0, 1, 1),
    Flag = "GlowColor",
    Callback = function(v)
        Settings.GlowColor = v
        if UpdateChar() then
            local hl = Character:FindFirstChild("CharGlow")
            if hl then hl.FillColor = v end
        end
    end,
})

VisualTab:CreateSection("🔊 音效設定")

VisualTab:CreateToggle({
    Name = "擊中音效",
    CurrentValue = false,
    Flag = "HitSoundToggle",
    Callback = function(v)
        Settings.HitSound = v
        if v then Rayfield:Notify({Title = "音效", Content = "擊中音效已開啟", Duration = 2}) end
    end,
})

VisualTab:CreateToggle({
    Name = "擊殺音效",
    CurrentValue = false,
    Flag = "KillSoundToggle",
    Callback = function(v)
        Settings.KillSound = v
        if v then Rayfield:Notify({Title = "音效", Content = "擊殺音效已開啟", Duration = 2}) end
    end,
})

VisualTab:CreateSection("👤 角色外觀")

VisualTab:CreateToggle({
    Name = "隱形手臂",
    CurrentValue = false,
    Flag = "InvisibleArmsToggle",
    Callback = function(v)
        Settings.InvisibleArms = v
        if UpdateChar() then
            for _, part in pairs({"Left Arm", "Right Arm", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand"}) do
                local p = Character:FindFirstChild(part)
                if p then p.Transparency = v and 1 or 0 end
            end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "移除臉部",
    CurrentValue = false,
    Flag = "NoFaceToggle",
    Callback = function(v)
        Settings.NoFace = v
        if UpdateChar() and Head then
            local face = Head:FindFirstChild("face") or Head:FindFirstChild("Face")
            if face then face.Transparency = v and 1 or 0 end
        end
    end,
})

VisualTab:CreateSection("👻 第一人稱角色隱藏 (Arsenal/Rivals)")

VisualTab:CreateToggle({
    Name = "第一人稱隱藏",
    CurrentValue = false,
    Flag = "FirstPersonInvisibleToggle",
    Callback = function(v)
        Settings.FirstPersonInvisible = v
        if v then
            Rayfield:Notify({Title = "角色隱藏", Content = "第一人稱角色隱藏已開啟", Duration = 2})
        end
    end,
})

VisualTab:CreateToggle({
    Name = "自動偵測第一人稱",
    CurrentValue = true,
    Flag = "AutoHideInFPSToggle",
    Callback = function(v) Settings.AutoHideInFPS = v end,
})

VisualTab:CreateToggle({
    Name = "隱藏頭部",
    CurrentValue = true,
    Flag = "HideHeadToggle",
    Callback = function(v) Settings.HideHead = v end,
})

VisualTab:CreateToggle({
    Name = "隱藏身體",
    CurrentValue = true,
    Flag = "HideTorsoToggle",
    Callback = function(v) Settings.HideTorso = v end,
})

VisualTab:CreateToggle({
    Name = "隱藏手臂",
    CurrentValue = false,
    Flag = "HideArmsToggle",
    Callback = function(v) Settings.HideArms = v end,
})

VisualTab:CreateToggle({
    Name = "隱藏腿部",
    CurrentValue = true,
    Flag = "HideLegsToggle",
    Callback = function(v) Settings.HideLegs = v end,
})

VisualTab:CreateToggle({
    Name = "隱藏飾品",
    CurrentValue = true,
    Flag = "HideAccessoriesToggle",
    Callback = function(v) Settings.HideAccessories = v end,
})

VisualTab:CreateSection("👤 角色透明度")

VisualTab:CreateToggle({
    Name = "角色半透明",
    CurrentValue = false,
    Flag = "CharacterTransparencyToggle",
    Callback = function(v) Settings.CharacterTransparency = v end,
})

VisualTab:CreateSlider({
    Name = "透明度",
    Range = {0.1, 0.9},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "TransparencyAmount",
    Callback = function(v) Settings.TransparencyAmount = v end,
})

VisualTab:CreateToggle({
    Name = "Ghost Mode (完全隱形)",
    CurrentValue = false,
    Flag = "GhostModeToggle",
    Callback = function(v)
        Settings.GhostMode = v
        if v then Rayfield:Notify({Title = "⚠️ Ghost", Content = "完全隱形已開啟", Duration = 2}) end
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

TPTab:CreateSection("📍 命名航點系統")

local WaypointName = ""

TPTab:CreateInput({
    Name = "航點名稱",
    PlaceholderText = "輸入航點名稱 (例: 商店, 基地)",
    RemoveTextAfterFocusLost = false,
    Flag = "WaypointName",
    Callback = function(v) WaypointName = v end,
})

TPTab:CreateButton({
    Name = "儲存命名航點",
    Callback = function()
        if WaypointName == "" then
            Rayfield:Notify({Title = "錯誤", Content = "請先輸入航點名稱", Duration = 2})
            return
        end
        if UpdateChar() then
            Settings.Waypoints[WaypointName] = RootPart.CFrame
            Rayfield:Notify({Title = "航點", Content = "已儲存航點: " .. WaypointName, Duration = 2})
        end
    end,
})

TPTab:CreateButton({
    Name = "傳送到命名航點",
    Callback = function()
        if WaypointName == "" then
            Rayfield:Notify({Title = "錯誤", Content = "請先輸入航點名稱", Duration = 2})
            return
        end
        if Settings.Waypoints[WaypointName] then
            if UpdateChar() then
                RootPart.CFrame = Settings.Waypoints[WaypointName]
                Rayfield:Notify({Title = "傳送", Content = "已傳送到: " .. WaypointName, Duration = 2})
            end
        else
            Rayfield:Notify({Title = "錯誤", Content = "找不到航點: " .. WaypointName, Duration = 2})
        end
    end,
})

TPTab:CreateButton({
    Name = "列出所有航點",
    Callback = function()
        local list = ""
        local count = 0
        for name, _ in pairs(Settings.Waypoints) do
            list = list .. name .. ", "
            count = count + 1
        end
        if count == 0 then
            Rayfield:Notify({Title = "航點", Content = "沒有儲存的航點", Duration = 3})
        else
            Rayfield:Notify({Title = "航點 (" .. count .. ")", Content = list:sub(1, -3), Duration = 5})
        end
    end,
})

TPTab:CreateSection("🌾 自動刷怪")

TPTab:CreateToggle({
    Name = "自動刷怪 (Auto Farm)",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(v)
        Settings.AutoFarm = v
        if v then Rayfield:Notify({Title = "農場", Content = "自動刷怪已開啟 - 會自動攻擊附近 NPC", Duration = 3}) end
    end,
})

TPTab:CreateSlider({
    Name = "刷怪範圍",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = 100,
    Flag = "FarmRadius",
    Callback = function(v) Settings.FarmRadius = v end,
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

MiscTab:CreateSection("💬 聊天指令系統")

MiscTab:CreateToggle({
    Name = "啟用聊天指令",
    CurrentValue = true,
    Flag = "ChatCommandsToggle",
    Callback = function(v)
        Settings.ChatCommands = v
        if v then
            Rayfield:Notify({
                Title = "聊天指令",
                Content = "輸入 /help 查看所有指令\n支援: /fly, /speed, /god, /esp, /tp 等",
                Duration = 5
            })
        end
    end,
})

MiscTab:CreateParagraph({
    Title = "可用指令",
    Content = "/fly - 飛行\n/speed - 速度\n/god - 無敵\n/esp - 透視\n/tp [玩家] - 傳送\n/noclip - 穿牆\n/help - 說明"
})

MiscTab:CreateSection("⌨️ 快捷鍵設定")

MiscTab:CreateToggle({
    Name = "啟用快捷鍵",
    CurrentValue = true,
    Flag = "KeybindsEnabledToggle",
    Callback = function(v)
        Settings.KeybindsEnabled = v
        Rayfield:Notify({Title = "快捷鍵", Content = v and "快捷鍵已啟用" or "快捷鍵已停用", Duration = 2})
    end,
})

MiscTab:CreateParagraph({
    Title = "預設快捷鍵",
    Content = "F - 飛行\nV - 穿牆\nG - 速度\nX - ESP\nH - 無敵\nP - 緊急關閉全部"
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

SettingsTab:CreateSection("🛡️ 進階設定")

SettingsTab:CreateToggle({
    Name = "Anti-Detect (防偵測)",
    CurrentValue = false,
    Flag = "AntiDetectToggle",
    Callback = function(v)
        Settings.AntiDetect = v
        if v then Rayfield:Notify({Title = "防護", Content = "防偵測模式已開啟", Duration = 2}) end
    end,
})

SettingsTab:CreateToggle({
    Name = "Safe TP (安全傳送)",
    CurrentValue = false,
    Flag = "SafeTPToggle",
    Callback = function(v)
        Settings.SafeTP = v
        if v then Rayfield:Notify({Title = "防護", Content = "安全傳送已開啟 - 避免反作弊", Duration = 2}) end
    end,
})

SettingsTab:CreateToggle({
    Name = "Lag Switch (延遲模擬)",
    CurrentValue = false,
    Flag = "LagSwitchToggle",
    Callback = function(v)
        Settings.LagSwitch = v
        if v then Rayfield:Notify({Title = "Lag", Content = "延遲模擬已開啟", Duration = 2}) end
    end,
})

SettingsTab:CreateSlider({
    Name = "延遲時間 (秒)",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "LagDuration",
    Callback = function(v) Settings.LagDuration = v end,
})

SettingsTab:CreateSection("⚡ 效能優化")

SettingsTab:CreateToggle({
    Name = "FPS Booster",
    CurrentValue = false,
    Flag = "FPSBoosterToggle",
    Callback = function(v)
        Settings.FPSBooster = v
        if v then
            -- 效能優化
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                end
            end
            Rayfield:Notify({Title = "FPS", Content = "FPS Booster 已開啟", Duration = 2})
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end,
})

SettingsTab:CreateToggle({
    Name = "音效通知",
    CurrentValue = true,
    Flag = "SoundNotifyToggle",
    Callback = function(v) Settings.SoundNotify = v end,
})

print("[Zy hacker hub] 設定分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              HUD 分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local HUDTab = Window:CreateTab("📊 HUD", 4483362458)

HUDTab:CreateSection("📈 統計顯示")

HUDTab:CreateToggle({
    Name = "顯示擊殺統計",
    CurrentValue = true,
    Flag = "SessionStatsToggle",
    Callback = function(v) Settings.SessionStats = v end,
})

HUDTab:CreateToggle({
    Name = "顯示 FPS",
    CurrentValue = false,
    Flag = "FPSDisplayToggle",
    Callback = function(v) Settings.FPSDisplay = v end,
})

HUDTab:CreateToggle({
    Name = "顯示 Ping",
    CurrentValue = false,
    Flag = "PingDisplayToggle",
    Callback = function(v) Settings.PingDisplay = v end,
})

HUDTab:CreateToggle({
    Name = "浮水印",
    CurrentValue = true,
    Flag = "WatermarkToggle",
    Callback = function(v) Settings.Watermark = v end,
})

HUDTab:CreateSection("💀 Kill Feed")

HUDTab:CreateToggle({
    Name = "顯示 Kill Feed",
    CurrentValue = false,
    Flag = "ShowKillFeedToggle",
    Callback = function(v)
        Settings.ShowKillFeed = v
        if v then Rayfield:Notify({Title = "HUD", Content = "Kill Feed 已開啟", Duration = 2}) end
    end,
})

HUDTab:CreateToggle({
    Name = "傷害數字",
    CurrentValue = false,
    Flag = "DamageNumbersToggle",
    Callback = function(v)
        Settings.DamageNumbers = v
        if v then Rayfield:Notify({Title = "HUD", Content = "傷害數字已開啟", Duration = 2}) end
    end,
})

HUDTab:CreateToggle({
    Name = "目標資訊面板",
    CurrentValue = false,
    Flag = "TargetInfoToggle",
    Callback = function(v) Settings.TargetInfo = v end,
})

HUDTab:CreateSection("⊕ 準心自訂")

HUDTab:CreateDropdown({
    Name = "準心樣式",
    Options = {"Cross", "Dot", "Circle", "Custom"},
    CurrentOption = {"Cross"},
    Flag = "CrosshairStyle",
    Callback = function(v) Settings.CrosshairStyle = v end,
})

HUDTab:CreateToggle({
    Name = "動態準心",
    CurrentValue = false,
    Flag = "DynamicCrosshairToggle",
    Callback = function(v) Settings.DynamicCrosshair = v end,
})

HUDTab:CreateSlider({
    Name = "準心間距",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 5,
    Flag = "CrosshairGap",
    Callback = function(v) Settings.CrosshairGap = v end,
})

HUDTab:CreateSlider({
    Name = "準心長度",
    Range = {5, 30},
    Increment = 1,
    CurrentValue = 10,
    Flag = "CrosshairLength",
    Callback = function(v) Settings.CrosshairLength = v end,
})

HUDTab:CreateSlider({
    Name = "準心粗細",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 2,
    Flag = "CrosshairThickness",
    Callback = function(v) Settings.CrosshairThickness = v end,
})

HUDTab:CreateSection("📡 雷達")

HUDTab:CreateToggle({
    Name = "顯示雷達",
    CurrentValue = false,
    Flag = "ShowRadarToggle",
    Callback = function(v)
        Settings.ShowRadar = v
        if v then Rayfield:Notify({Title = "HUD", Content = "雷達已開啟", Duration = 2}) end
    end,
})

HUDTab:CreateSlider({
    Name = "雷達大小",
    Range = {100, 300},
    Increment = 25,
    CurrentValue = 150,
    Flag = "RadarSize",
    Callback = function(v) Settings.RadarSize = v end,
})

HUDTab:CreateSlider({
    Name = "雷達縮放",
    Range = {0.5, 3},
    Increment = 0.25,
    CurrentValue = 1,
    Flag = "RadarZoom",
    Callback = function(v) Settings.RadarZoom = v end,
})

HUDTab:CreateSection("📷 相機特效")

HUDTab:CreateToggle({
    Name = "相機震動",
    CurrentValue = false,
    Flag = "CameraShakeToggle",
    Callback = function(v) Settings.CameraShake = v end,
})

HUDTab:CreateSlider({
    Name = "震動強度",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 5,
    Flag = "ShakeIntensity",
    Callback = function(v) Settings.ShakeIntensity = v end,
})

HUDTab:CreateToggle({
    Name = "相機傾斜",
    CurrentValue = false,
    Flag = "CameraTiltToggle",
    Callback = function(v) Settings.CameraTilt = v end,
})

HUDTab:CreateSlider({
    Name = "傾斜角度",
    Range = {5, 30},
    Increment = 5,
    CurrentValue = 15,
    Flag = "TiltAmount",
    Callback = function(v) Settings.TiltAmount = v end,
})

HUDTab:CreateToggle({
    Name = "平滑相機",
    CurrentValue = false,
    Flag = "SmoothCameraToggle",
    Callback = function(v) Settings.SmoothCamera = v end,
})

HUDTab:CreateToggle({
    Name = "自由觀看 (按住 Alt)",
    CurrentValue = false,
    Flag = "FreeLookToggle",
    Callback = function(v)
        Settings.FreeLook = v
        if v then Rayfield:Notify({Title = "相機", Content = "按住 Alt 自由觀看", Duration = 2}) end
    end,
})

HUDTab:CreateSection("🔫 武器增強")

HUDTab:CreateToggle({
    Name = "自動換彈",
    CurrentValue = false,
    Flag = "AutoReloadToggle",
    Callback = function(v) Settings.AutoReload = v end,
})

HUDTab:CreateToggle({
    Name = "瞬間換彈",
    CurrentValue = false,
    Flag = "InstantReloadToggle",
    Callback = function(v) Settings.InstantReload = v end,
})

HUDTab:CreateToggle({
    Name = "移除換彈動畫",
    CurrentValue = false,
    Flag = "NoReloadAnimToggle",
    Callback = function(v) Settings.NoReloadAnim = v end,
})

HUDTab:CreateToggle({
    Name = "移除槍枝晃動",
    CurrentValue = false,
    Flag = "NoGunBobToggle",
    Callback = function(v) Settings.NoGunBob = v end,
})

HUDTab:CreateSection("🐰 進階移動")

HUDTab:CreateToggle({
    Name = "Bunny Hop (連跳)",
    CurrentValue = false,
    Flag = "BunnyHopToggle",
    Callback = function(v)
        Settings.BunnyHop = v
        if v then Rayfield:Notify({Title = "移動", Content = "Bunny Hop 已開啟", Duration = 2}) end
    end,
})

HUDTab:CreateToggle({
    Name = "Auto Strafe",
    CurrentValue = false,
    Flag = "AutoStrafeToggle",
    Callback = function(v) Settings.AutoStrafe = v end,
})

HUDTab:CreateToggle({
    Name = "空中控制",
    CurrentValue = false,
    Flag = "AirControlToggle",
    Callback = function(v) Settings.AirControl = v end,
})

HUDTab:CreateSlider({
    Name = "空中控制量",
    Range = {10, 100},
    Increment = 10,
    CurrentValue = 50,
    Flag = "AirControlAmount",
    Callback = function(v) Settings.AirControlAmount = v end,
})

HUDTab:CreateToggle({
    Name = "Slide Hop",
    CurrentValue = false,
    Flag = "SlideHopToggle",
    Callback = function(v) Settings.SlideHop = v end,
})

print("[Zy hacker hub] HUD 分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              遊戲專用分頁                                    ║
-- ═══════════════════════════════════════════════════════════════════════════════

local GameTab = Window:CreateTab("🎮 遊戲專用", 4483362458)

GameTab:CreateSection("⚔️ Blade Ball")

GameTab:CreateToggle({
    Name = "Auto Dodge (自動閃避)",
    CurrentValue = false,
    Flag = "BBAutoDodge",
    Callback = function(v)
        Settings.BladeBall.AutoDodge = v
        if v then Rayfield:Notify({Title = "Blade Ball", Content = "自動閃避已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Ball ESP (球追蹤)",
    CurrentValue = false,
    Flag = "BBBallESP",
    Callback = function(v)
        Settings.BladeBall.BallESP = v
        if v then Rayfield:Notify({Title = "Blade Ball", Content = "球追蹤 ESP 已開啟", Duration = 2}) end
    end,
})

GameTab:CreateSection("🍎 Blox Fruits")

GameTab:CreateToggle({
    Name = "Auto Quest (自動任務)",
    CurrentValue = false,
    Flag = "BFAutoQuest",
    Callback = function(v)
        Settings.BloxFruits.AutoQuest = v
        if v then Rayfield:Notify({Title = "Blox Fruits", Content = "自動任務已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Fruit Notifier (水果通知)",
    CurrentValue = false,
    Flag = "BFFruitNotifier",
    Callback = function(v)
        Settings.BloxFruits.FruitNotifier = v
        if v then Rayfield:Notify({Title = "Blox Fruits", Content = "水果通知已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Flag = "BFAutoMastery",
    Callback = function(v)
        Settings.BloxFruits.AutoMastery = v
        if v then Rayfield:Notify({Title = "Blox Fruits", Content = "自動精通已開啟", Duration = 2}) end
    end,
})

GameTab:CreateSection("🔫 Da Hood")

GameTab:CreateToggle({
    Name = "Auto Stomp (自動踩人)",
    CurrentValue = false,
    Flag = "DHAutoStomp",
    Callback = function(v)
        Settings.DaHood.AutoStomp = v
        if v then Rayfield:Notify({Title = "Da Hood", Content = "自動踩人已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Cash ESP",
    CurrentValue = false,
    Flag = "DHCashESP",
    Callback = function(v)
        Settings.DaHood.CashESP = v
        if v then Rayfield:Notify({Title = "Da Hood", Content = "現金透視已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Silent Punch",
    CurrentValue = false,
    Flag = "DHSilentPunch",
    Callback = function(v)
        Settings.DaHood.SilentPunch = v
        if v then Rayfield:Notify({Title = "Da Hood", Content = "無聲揮拳已開啟", Duration = 2}) end
    end,
})

GameTab:CreateSection("🎯 Arsenal")

GameTab:CreateToggle({
    Name = "Auto Swap (自動換槍)",
    CurrentValue = false,
    Flag = "ARAutoSwap",
    Callback = function(v)
        Settings.Arsenal.AutoSwap = v
        if v then Rayfield:Notify({Title = "Arsenal", Content = "自動換槍已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Ammo ESP",
    CurrentValue = false,
    Flag = "ARAmmoESP",
    Callback = function(v)
        Settings.Arsenal.AmmoESP = v
        if v then Rayfield:Notify({Title = "Arsenal", Content = "彈藥透視已開啟", Duration = 2}) end
    end,
})

GameTab:CreateToggle({
    Name = "Melee Aura",
    CurrentValue = false,
    Flag = "ARMeleeAura",
    Callback = function(v)
        Settings.Arsenal.MeleeAura = v
        if v then Rayfield:Notify({Title = "Arsenal", Content = "近戰光環已開啟", Duration = 2}) end
    end,
})

print("[Zy hacker hub] 遊戲專用分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              精英分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local EliteTab = Window:CreateTab("👑 精英", 4483362458)

EliteTab:CreateSection("👥 玩家管理")

EliteTab:CreateDropdown({
    Name = "目標優先級",
    Options = {"Enemy", "All", "Friend"},
    CurrentOption = {"Enemy"},
    Flag = "TargetPriority",
    Callback = function(v)
        Settings.TargetPriority = v
        Rayfield:Notify({Title = "目標", Content = "優先級: " .. v, Duration = 2})
    end,
})

EliteTab:CreateToggle({
    Name = "忽略好友",
    CurrentValue = true,
    Flag = "IgnoreFriendsToggle",
    Callback = function(v) Settings.IgnoreFriends = v end,
})

EliteTab:CreateToggle({
    Name = "高亮好友 (綠色)",
    CurrentValue = true,
    Flag = "HighlightFriendsToggle",
    Callback = function(v) Settings.HighlightFriends = v end,
})

EliteTab:CreateToggle({
    Name = "高亮敵人 (紅色)",
    CurrentValue = true,
    Flag = "HighlightEnemiesToggle",
    Callback = function(v) Settings.HighlightEnemies = v end,
})

EliteTab:CreateButton({
    Name = "添加目標為敵人",
    Callback = function()
        if TargetPlayer then
            table.insert(Settings.EnemyList, TargetPlayer)
            Rayfield:Notify({Title = "敵人", Content = TargetPlayer .. " 已添加到敵人列表", Duration = 2})
        end
    end,
})

EliteTab:CreateButton({
    Name = "添加目標為好友",
    Callback = function()
        if TargetPlayer then
            table.insert(Settings.FriendList, TargetPlayer)
            Rayfield:Notify({Title = "好友", Content = TargetPlayer .. " 已添加到好友列表", Duration = 2})
        end
    end,
})

EliteTab:CreateSection("👁️ 觀戰模式")

EliteTab:CreateToggle({
    Name = "觀戰模式",
    CurrentValue = false,
    Flag = "SpectatorModeToggle",
    Callback = function(v)
        Settings.SpectatorMode = v
        if v then
            Rayfield:Notify({Title = "觀戰", Content = "觀戰模式已開啟 - 選擇玩家後按住 C 觀戰", Duration = 3})
        end
    end,
})

EliteTab:CreateSlider({
    Name = "觀戰距離",
    Range = {5, 30},
    Increment = 5,
    CurrentValue = 10,
    Flag = "SpectatorDistance",
    Callback = function(v) Settings.SpectatorDistance = v end,
})

EliteTab:CreateSection("🌍 世界控制")

EliteTab:CreateToggle({
    Name = "自訂重力",
    CurrentValue = false,
    Flag = "CustomGravityToggle",
    Callback = function(v)
        Settings.CustomGravity = v
        if v then
            Workspace.Gravity = Settings.GravityValue
        else
            Workspace.Gravity = 196.2
        end
    end,
})

EliteTab:CreateSlider({
    Name = "重力值",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = 196,
    Flag = "GravityValue",
    Callback = function(v)
        Settings.GravityValue = v
        if Settings.CustomGravity then Workspace.Gravity = v end
    end,
})

EliteTab:CreateToggle({
    Name = "時間控制",
    CurrentValue = false,
    Flag = "TimeControlToggle",
    Callback = function(v) Settings.TimeControl = v end,
})

EliteTab:CreateSlider({
    Name = "時間",
    Range = {0, 24},
    Increment = 1,
    CurrentValue = 14,
    Flag = "TimeValue",
    Callback = function(v)
        Settings.TimeValue = v
        if Settings.TimeControl then Lighting.ClockTime = v end
    end,
})

EliteTab:CreateDropdown({
    Name = "天氣",
    Options = {"Clear", "Foggy", "Rainy", "Storm"},
    CurrentOption = {"Clear"},
    Flag = "WeatherType",
    Callback = function(v)
        Settings.WeatherType = v
        if Settings.WeatherControl then
            if v == "Foggy" then Lighting.FogEnd = 500
            elseif v == "Clear" then Lighting.FogEnd = 100000
            end
        end
    end,
})

EliteTab:CreateSection("💾 設定檔")

EliteTab:CreateInput({
    Name = "設定檔名稱",
    PlaceholderText = "輸入名稱",
    RemoveTextAfterFocusLost = false,
    Flag = "ProfileName",
    Callback = function(v) Settings.CurrentProfile = v end,
})

EliteTab:CreateButton({
    Name = "保存設定檔",
    Callback = function()
        Settings.Profiles[Settings.CurrentProfile] = table.clone(Settings)
        Rayfield:Notify({Title = "保存", Content = "設定檔 '" .. Settings.CurrentProfile .. "' 已保存", Duration = 2})
    end,
})

EliteTab:CreateButton({
    Name = "載入設定檔",
    Callback = function()
        if Settings.Profiles[Settings.CurrentProfile] then
            for k, v in pairs(Settings.Profiles[Settings.CurrentProfile]) do
                Settings[k] = v
            end
            Rayfield:Notify({Title = "載入", Content = "設定檔 '" .. Settings.CurrentProfile .. "' 已載入", Duration = 2})
        else
            Rayfield:Notify({Title = "錯誤", Content = "找不到設定檔", Duration = 2})
        end
    end,
})

EliteTab:CreateSection("🛡️ 反作弊繞過")

EliteTab:CreateToggle({
    Name = "Anti-Cheat Bypass",
    CurrentValue = false,
    Flag = "AntiCheatBypassToggle",
    Callback = function(v)
        Settings.AntiCheatBypass = v
        if v then Rayfield:Notify({Title = "⚠️ 警告", Content = "反作弊繞過已開啟 - 使用風險自負", Duration = 3}) end
    end,
})

EliteTab:CreateToggle({
    Name = "偽裝行走速度",
    CurrentValue = false,
    Flag = "SpoofWalkSpeedToggle",
    Callback = function(v) Settings.SpoofWalkSpeed = v end,
})

EliteTab:CreateToggle({
    Name = "隱藏於管理員",
    CurrentValue = false,
    Flag = "HideFromAdminsToggle",
    Callback = function(v)
        Settings.HideFromAdmins = v
        if v then Rayfield:Notify({Title = "隱藏", Content = "當管理員在場時自動禁用功能", Duration = 2}) end
    end,
})

EliteTab:CreateSection("🤖 自動化")

EliteTab:CreateToggle({
    Name = "Auto Play (自動遊玩)",
    CurrentValue = false,
    Flag = "AutoPlayToggle",
    Callback = function(v)
        Settings.AutoPlay = v
        if v then Rayfield:Notify({Title = "自動化", Content = "自動遊玩已開啟", Duration = 2}) end
    end,
})

EliteTab:CreateToggle({
    Name = "AFK Farm",
    CurrentValue = false,
    Flag = "AFKFarmToggle",
    Callback = function(v)
        Settings.AFKFarm = v
        if v then Rayfield:Notify({Title = "自動化", Content = "AFK 農場已開啟", Duration = 2}) end
    end,
})

EliteTab:CreateToggle({
    Name = "Auto Dodge (自動閃避)",
    CurrentValue = false,
    Flag = "AutoDodgeToggle",
    Callback = function(v) Settings.AutoDodge = v end,
})

EliteTab:CreateToggle({
    Name = "自動使用治療物品",
    CurrentValue = false,
    Flag = "AutoHealItemsToggle",
    Callback = function(v) Settings.AutoHealItems = v end,
})

EliteTab:CreateSection("💬 聊天功能")

EliteTab:CreateToggle({
    Name = "聊天繞過過濾",
    CurrentValue = false,
    Flag = "ChatBypassToggle",
    Callback = function(v) Settings.ChatBypass = v end,
})

EliteTab:CreateToggle({
    Name = "聊天記錄器",
    CurrentValue = false,
    Flag = "ChatLoggerToggle",
    Callback = function(v)
        Settings.ChatLogger = v
        if v then Rayfield:Notify({Title = "聊天", Content = "聊天記錄器已開啟", Duration = 2}) end
    end,
})

EliteTab:CreateSection("🎨 主題")

EliteTab:CreateDropdown({
    Name = "UI 主題",
    Options = {"Cyber", "Dark", "Light", "Neon", "Blood"},
    CurrentOption = {"Cyber"},
    Flag = "UITheme",
    Callback = function(v)
        Settings.UITheme = v
        Rayfield:Notify({Title = "主題", Content = "主題已更改為 " .. v, Duration = 2})
    end,
})

EliteTab:CreateColorPicker({
    Name = "強調色",
    Color = Color3.new(0, 1, 1),
    Flag = "AccentColor",
    Callback = function(v) Settings.AccentColor = v end,
})

EliteTab:CreateSection("🔧 調試工具")

EliteTab:CreateToggle({
    Name = "顯示調試資訊",
    CurrentValue = false,
    Flag = "ShowDebugInfoToggle",
    Callback = function(v) Settings.ShowDebugInfo = v end,
})

EliteTab:CreateToggle({
    Name = "Remote 記錄器",
    CurrentValue = false,
    Flag = "RemoteLoggerToggle",
    Callback = function(v)
        Settings.RemoteLogger = v
        if v then Rayfield:Notify({Title = "調試", Content = "Remote 事件記錄已開啟", Duration = 2}) end
    end,
})

EliteTab:CreateButton({
    Name = "顯示統計資訊",
    Callback = function()
        local stats = string.format(
            "遊戲時間: %d 分鐘\n擊殺數: %d\n死亡數: %d\nK/D: %.2f",
            math.floor(Settings.SessionTime / 60),
            Settings.KillCount,
            Settings.DeathCount,
            Settings.DeathCount > 0 and Settings.KillCount / Settings.DeathCount or Settings.KillCount
        )
        Rayfield:Notify({Title = "📊 統計", Content = stats, Duration = 10})
    end,
})

print("[Zy hacker hub] 精英分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              終極分頁                                        ║
-- ═══════════════════════════════════════════════════════════════════════════════

local UltimateTab = Window:CreateTab("💎 終極", 4483362458)

UltimateTab:CreateSection("👁️ 高級 ESP")

UltimateTab:CreateToggle({
    Name = "ESP 預測線",
    CurrentValue = false,
    Flag = "ESPPredictionToggle",
    Callback = function(v) Settings.ESPPrediction = v end,
})

UltimateTab:CreateToggle({
    Name = "顯示速度向量",
    CurrentValue = false,
    Flag = "ESPVelocityToggle",
    Callback = function(v) Settings.ESPVelocity = v end,
})

UltimateTab:CreateToggle({
    Name = "3D Box ESP",
    CurrentValue = false,
    Flag = "ESP3DBoxToggle",
    Callback = function(v)
        Settings.ESP3DBox = v
        if v then Rayfield:Notify({Title = "ESP", Content = "3D Box 已開啟", Duration = 2}) end
    end,
})

UltimateTab:CreateToggle({
    Name = "Corner Box ESP",
    CurrentValue = false,
    Flag = "ESPCornerBoxToggle",
    Callback = function(v) Settings.ESPCornerBox = v end,
})

UltimateTab:CreateToggle({
    Name = "視線方向顯示",
    CurrentValue = false,
    Flag = "ESPLookDirectionToggle",
    Callback = function(v) Settings.ESPLookDirection = v end,
})

UltimateTab:CreateSection("🎯 高級 Aimbot")

UltimateTab:CreateToggle({
    Name = "Flick Aim (快速瞄準)",
    CurrentValue = false,
    Flag = "AimbotFlickToggle",
    Callback = function(v)
        Settings.AimbotFlick = v
        if v then Rayfield:Notify({Title = "Aimbot", Content = "Flick Aim 已開啟", Duration = 2}) end
    end,
})

UltimateTab:CreateSlider({
    Name = "Flick 速度",
    Range = {0.01, 0.5},
    Increment = 0.01,
    CurrentValue = 0.1,
    Flag = "FlickSpeed",
    Callback = function(v) Settings.FlickSpeed = v end,
})

UltimateTab:CreateToggle({
    Name = "Magnetism (磁吸瞄準)",
    CurrentValue = false,
    Flag = "AimbotMagnetismToggle",
    Callback = function(v)
        Settings.AimbotMagnetism = v
        if v then Rayfield:Notify({Title = "Aimbot", Content = "磁吸瞄準已開啟", Duration = 2}) end
    end,
})

UltimateTab:CreateSlider({
    Name = "磁吸強度",
    Range = {10, 100},
    Increment = 10,
    CurrentValue = 50,
    Flag = "MagnetismStrength",
    Callback = function(v) Settings.MagnetismStrength = v end,
})

UltimateTab:CreateToggle({
    Name = "Auto Fire (自動開槍)",
    CurrentValue = false,
    Flag = "AimbotAutoFireToggle",
    Callback = function(v) Settings.AimbotAutoFire = v end,
})

UltimateTab:CreateToggle({
    Name = "Leading (預判射擊)",
    CurrentValue = false,
    Flag = "AimbotLeadingToggle",
    Callback = function(v) Settings.AimbotLeading = v end,
})

UltimateTab:CreateSlider({
    Name = "預判量",
    Range = {0.05, 0.5},
    Increment = 0.05,
    CurrentValue = 0.15,
    Flag = "LeadAmount",
    Callback = function(v) Settings.LeadAmount = v end,
})

UltimateTab:CreateSection("🏃 流暢移動")

UltimateTab:CreateToggle({
    Name = "Double Jump (雙段跳)",
    CurrentValue = false,
    Flag = "DoubleJumpToggle",
    Callback = function(v)
        Settings.DoubleJump = v
        if v then Rayfield:Notify({Title = "移動", Content = "雙段跳已開啟", Duration = 2}) end
    end,
})

UltimateTab:CreateSlider({
    Name = "二段跳力量",
    Range = {30, 100},
    Increment = 10,
    CurrentValue = 50,
    Flag = "DoubleJumpPower",
    Callback = function(v) Settings.DoubleJumpPower = v end,
})

UltimateTab:CreateToggle({
    Name = "Wall Run (跑牆)",
    CurrentValue = false,
    Flag = "WallRunToggle",
    Callback = function(v)
        Settings.WallRun = v
        if v then Rayfield:Notify({Title = "移動", Content = "跑牆已開啟", Duration = 2}) end
    end,
})

UltimateTab:CreateSlider({
    Name = "跑牆速度",
    Range = {10, 100},
    Increment = 10,
    CurrentValue = 30,
    Flag = "WallRunSpeed",
    Callback = function(v) Settings.WallRunSpeed = v end,
})

UltimateTab:CreateToggle({
    Name = "Dash (衝刺)",
    CurrentValue = false,
    Flag = "DashAbilityToggle",
    Callback = function(v)
        Settings.DashAbility = v
        if v then Rayfield:Notify({Title = "移動", Content = "衝刺已開啟 - 按 E 使用", Duration = 2}) end
    end,
})

UltimateTab:CreateSlider({
    Name = "衝刺距離",
    Range = {10, 50},
    Increment = 5,
    CurrentValue = 20,
    Flag = "DashDistance",
    Callback = function(v) Settings.DashDistance = v end,
})

UltimateTab:CreateToggle({
    Name = "Grapple Hook (鉤爪)",
    CurrentValue = false,
    Flag = "GrappleHookToggle",
    Callback = function(v)
        Settings.GrappleHook = v
        if v then Rayfield:Notify({Title = "移動", Content = "鉤爪已開啟 - 按 R 使用", Duration = 2}) end
    end,
})

UltimateTab:CreateSlider({
    Name = "鉤爪範圍",
    Range = {50, 200},
    Increment = 25,
    CurrentValue = 100,
    Flag = "GrappleRange",
    Callback = function(v) Settings.GrappleRange = v end,
})

UltimateTab:CreateSection("🤖 自動功能")

UltimateTab:CreateToggle({
    Name = "Auto Aim",
    CurrentValue = false,
    Flag = "AutoAimToggle",
    Callback = function(v) Settings.AutoAim = v end,
})

UltimateTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShootToggle",
    Callback = function(v) Settings.AutoShoot = v end,
})

UltimateTab:CreateToggle({
    Name = "Auto Loot (自動拾取)",
    CurrentValue = false,
    Flag = "AutoLootToggle",
    Callback = function(v) Settings.AutoLoot = v end,
})

UltimateTab:CreateToggle({
    Name = "Auto Revive (自動復活隊友)",
    CurrentValue = false,
    Flag = "AutoReviveToggle",
    Callback = function(v) Settings.AutoRevive = v end,
})

UltimateTab:CreateSection("⚡ 效能設定")

UltimateTab:CreateToggle({
    Name = "Ultra Low Graphics",
    CurrentValue = false,
    Flag = "UltraLowGraphicsToggle",
    Callback = function(v)
        Settings.UltraLowGraphics = v
        if v then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then obj.Transparency = 1 end
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then obj.Enabled = false end
            end
            Rayfield:Notify({Title = "效能", Content = "Ultra Low 已開啟 - 最大 FPS", Duration = 2})
        end
    end,
})

UltimateTab:CreateDropdown({
    Name = "紋理品質",
    Options = {"High", "Medium", "Low", "Off"},
    CurrentOption = {"High"},
    Flag = "TextureQuality",
    Callback = function(v) Settings.TextureQuality = v end,
})

UltimateTab:CreateSection("✨ 視覺特效")

UltimateTab:CreateToggle({
    Name = "Motion Blur",
    CurrentValue = false,
    Flag = "MotionBlurToggle",
    Callback = function(v) Settings.MotionBlur = v end,
})

UltimateTab:CreateToggle({
    Name = "Vignette (暗角)",
    CurrentValue = false,
    Flag = "VignetteToggle",
    Callback = function(v) Settings.Vignette = v end,
})

UltimateTab:CreateSlider({
    Name = "飽和度",
    Range = {0, 2},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "Saturation",
    Callback = function(v) Settings.Saturation = v end,
})

UltimateTab:CreateSlider({
    Name = "對比度",
    Range = {0, 2},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "Contrast",
    Callback = function(v) Settings.Contrast = v end,
})

UltimateTab:CreateSection("⊕ 高級準心")

UltimateTab:CreateToggle({
    Name = "Hitmarker (命中標記)",
    CurrentValue = true,
    Flag = "HitmarkerEnabledToggle",
    Callback = function(v) Settings.HitmarkerEnabled = v end,
})

UltimateTab:CreateToggle({
    Name = "Hitmarker 音效",
    CurrentValue = true,
    Flag = "HitmarkerSoundToggle",
    Callback = function(v) Settings.HitmarkerSound = v end,
})

UltimateTab:CreateColorPicker({
    Name = "Hitmarker 顏色",
    Color = Color3.new(1, 0, 0),
    Flag = "HitmarkerColor",
    Callback = function(v) Settings.HitmarkerColor = v end,
})

UltimateTab:CreateSection("💀 擊殺特效")

UltimateTab:CreateToggle({
    Name = "擊殺特效",
    CurrentValue = false,
    Flag = "KillEffectToggle",
    Callback = function(v) Settings.KillEffect = v end,
})

UltimateTab:CreateDropdown({
    Name = "特效類型",
    Options = {"Confetti", "Explosion", "Fade"},
    CurrentOption = {"Confetti"},
    Flag = "KillEffectType",
    Callback = function(v) Settings.KillEffectType = v end,
})

UltimateTab:CreateToggle({
    Name = "擊殺攝影機",
    CurrentValue = false,
    Flag = "KillCameraToggle",
    Callback = function(v) Settings.KillCamera = v end,
})

print("[Zy hacker hub] 終極分頁已載入")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              Rivals 專區                                     ║
-- ═══════════════════════════════════════════════════════════════════════════════

local RivalsTab = Window:CreateTab("⚔️ Rivals", 4483362458)

RivalsTab:CreateSection("🔫 戰鬥輔助")

RivalsTab:CreateToggle({
    Name = "Silent Aim (靜默瞄準)",
    CurrentValue = false,
    Flag = "RivalsSilentAim",
    Callback = function(v)
        Settings.Rivals.SilentAim = v
        if v then Rayfield:Notify({Title = "Rivals", Content = "Silent Aim 已開啟 - 子彈自動追蹤", Duration = 2}) end
    end,
})

RivalsTab:CreateToggle({
    Name = "Auto Shoot (自動射擊)",
    CurrentValue = false,
    Flag = "RivalsAutoShoot",
    Callback = function(v) Settings.Rivals.AutoShoot = v end,
})

RivalsTab:CreateToggle({
    Name = "Hitbox Expander (碰撞箱擴大)",
    CurrentValue = false,
    Flag = "RivalsHitbox",
    Callback = function(v) Settings.Rivals.HitboxExpander = v end,
})

RivalsTab:CreateSlider({
    Name = "碰撞箱大小",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 5,
    Flag = "RivalsHitboxSize",
    Callback = function(v) Settings.Rivals.HitboxSize = v end,
})

RivalsTab:CreateSection("🔧 武器修改")

RivalsTab:CreateToggle({
    Name = "No Recoil (無後座力)",
    CurrentValue = false,
    Flag = "RivalsNoRecoil",
    Callback = function(v) Settings.Rivals.NoRecoil = v end,
})

RivalsTab:CreateToggle({
    Name = "No Spread (無擴散)",
    CurrentValue = false,
    Flag = "RivalsNoSpread",
    Callback = function(v) Settings.Rivals.NoSpread = v end,
})

RivalsTab:CreateToggle({
    Name = "Rapid Fire (快速射擊)",
    CurrentValue = false,
    Flag = "RivalsRapidFire",
    Callback = function(v) Settings.Rivals.RapidFire = v end,
})

RivalsTab:CreateToggle({
    Name = "Infinite Ammo (無限子彈)",
    CurrentValue = false,
    Flag = "RivalsInfAmmo",
    Callback = function(v) Settings.Rivals.InfiniteAmmo = v end,
})

RivalsTab:CreateSection("👁️ 視覺輔助")

RivalsTab:CreateToggle({
    Name = "Rivals ESP",
    CurrentValue = false,
    Flag = "RivalsESP",
    Callback = function(v) Settings.Rivals.ESP = v end,
})

RivalsTab:CreateToggle({
    Name = "第一人稱角色隱藏",
    CurrentValue = false,
    Flag = "RivalsInvis",
    Callback = function(v) Settings.FirstPersonInvisible = v end,
})

print("[Zy hacker hub] Rivals 分頁已載入")

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

-- === 穿地板 (修復版) ===
RunService.Heartbeat:Connect(function()
    if Settings.Phase then
        if UpdateChar() then
            if KeysDown[Enum.KeyCode.LeftShift] then
                -- 按住 Shift 時下降並禁用碰撞
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                RootPart.CFrame = RootPart.CFrame - Vector3.new(0, Settings.PhaseSpeed * 0.5, 0)
            end
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

-- === 半無敵 (修復版) ===
local LastHealTime = 0
RunService.Heartbeat:Connect(function()
    if Settings.SemiGod and UpdateChar() and Humanoid then
        if Humanoid.Health < Humanoid.MaxHealth then
            if tick() - LastHealTime > 0.05 then
                -- 快速回血但不是瞬間滿血
                Humanoid.Health = math.min(Humanoid.Health + 5, Humanoid.MaxHealth)
                LastHealTime = tick()
            end
        end
    end
end)

-- === 抗擊退 (修復版) ===
local LastKBPosition = nil
local LastKBUpdate = 0
RunService.Heartbeat:Connect(function()
    if Settings.AntiKB and UpdateChar() and RootPart then
        local now = tick()
        if now - LastKBUpdate > 0.1 then
            LastKBPosition = RootPart.Position
            LastKBUpdate = now
        end
        
        -- 只在檢測到大幅移動時重置
        if LastKBPosition then
            local horizontalVel = Vector3.new(RootPart.Velocity.X, 0, RootPart.Velocity.Z)
            if horizontalVel.Magnitude > 50 then
                RootPart.Velocity = Vector3.new(0, math.min(RootPart.Velocity.Y, 50), 0)
                RootPart.RotVelocity = Vector3.zero
            end
        end
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              新功能核心邏輯                                  ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入新功能核心邏輯...")

-- === 自動格擋 (通用版) ===
spawn(function()
    while task.wait(0.01) do
        if Settings.AutoParry and UpdateChar() then
            -- 檢測所有快速移動的物體 (球、刀等)
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                    local velocity = obj.Velocity.Magnitude
                    if velocity > 40 then
                        local dist = (obj.Position - RootPart.Position).Magnitude
                        if dist < Settings.AutoParryRange then
                            -- 計算是否朝向玩家
                            local toPlayer = (RootPart.Position - obj.Position).Unit
                            local objDir = obj.Velocity.Unit
                            local dot = toPlayer:Dot(objDir)
                            
                            if dot > 0.4 then -- 朝向玩家
                                task.wait(Settings.AutoParryDelay)
                                -- 嘗試多種格擋方式
                                pcall(function()
                                    -- 模擬按下 F 鍵
                                    if keypress then
                                        keypress(0x46) -- F key
                                        task.wait(0.05)
                                        keyrelease(0x46)
                                    end
                                    -- 嘗試 Remote
                                    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
                                    for _, remote in pairs(remotes:GetDescendants()) do
                                        if remote:IsA("RemoteEvent") then
                                            local name = remote.Name:lower()
                                            if name:find("parry") or name:find("block") or name:find("deflect") then
                                                remote:FireServer()
                                            end
                                        end
                                    end
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- === Anti-Aim (反瞄準) ===
local AntiAimAngle = 0
RunService.Heartbeat:Connect(function()
    if Settings.AntiAim and UpdateChar() and RootPart then
        AntiAimAngle = AntiAimAngle + Settings.AntiAimSpeed * 0.016
        local randomOffset = math.random(-30, 30)
        -- 只旋轉角色模型，不影響移動
        pcall(function()
            local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * 
                    CFrame.Angles(0, math.rad(AntiAimAngle + randomOffset), 0)
            end
        end)
    end
end)

-- === Spin Bot (旋轉) ===
local SpinAngle = 0
RunService.Heartbeat:Connect(function()
    if Settings.SpinBot and UpdateChar() and RootPart then
        SpinAngle = SpinAngle + Settings.SpinSpeed
        RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, math.rad(SpinAngle), 0)
    end
end)

-- === 聊天指令系統 ===
LocalPlayer.Chatted:Connect(function(message)
    if not Settings.ChatCommands then return end
    
    local args = string.split(message:lower(), " ")
    local cmd = args[1]
    
    if cmd == "/fly" then
        Settings.Fly = not Settings.Fly
        -- 觸發飛行邏輯
        if Settings.Fly then
            if UpdateChar() then
                local FlyBV = RootPart:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
                FlyBV.Name = "FlyBV"
                FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                FlyBV.Velocity = Vector3.zero
                FlyBV.Parent = RootPart
                Humanoid.PlatformStand = true
            end
        else
            if UpdateChar() then
                local bv = RootPart:FindFirstChild("FlyBV")
                if bv then bv:Destroy() end
                Humanoid.PlatformStand = false
            end
        end
        Rayfield:Notify({Title = "指令", Content = "飛行: " .. (Settings.Fly and "開" or "關"), Duration = 2})
        
    elseif cmd == "/speed" then
        Settings.Speed = not Settings.Speed
        if UpdateChar() and Humanoid then
            Humanoid.WalkSpeed = Settings.Speed and (16 * Settings.SpeedMult) or 16
        end
        Rayfield:Notify({Title = "指令", Content = "速度: " .. (Settings.Speed and "開" or "關"), Duration = 2})
        
    elseif cmd == "/god" then
        Settings.God = not Settings.God
        if UpdateChar() and Humanoid then
            if Settings.God then
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
            else
                Humanoid.MaxHealth = 100
                Humanoid.Health = 100
            end
        end
        Rayfield:Notify({Title = "指令", Content = "無敵: " .. (Settings.God and "開" or "關"), Duration = 2})
        
    elseif cmd == "/esp" then
        Settings.ESP = not Settings.ESP
        Rayfield:Notify({Title = "指令", Content = "ESP: " .. (Settings.ESP and "開" or "關"), Duration = 2})
        
    elseif cmd == "/noclip" then
        Settings.Noclip = not Settings.Noclip
        Rayfield:Notify({Title = "指令", Content = "穿牆: " .. (Settings.Noclip and "開" or "關"), Duration = 2})
        
    elseif cmd == "/tp" and args[2] then
        local targetName = args[2]
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(targetName) then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if UpdateChar() then
                        RootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        Rayfield:Notify({Title = "指令", Content = "已傳送到 " .. player.Name, Duration = 2})
                    end
                end
                break
            end
        end
        
    elseif cmd == "/help" then
        Rayfield:Notify({
            Title = "聊天指令說明",
            Content = "/fly - 飛行開關\n/speed - 速度開關\n/god - 無敵開關\n/esp - 透視開關\n/noclip - 穿牆開關\n/tp [玩家] - 傳送到玩家",
            Duration = 10
        })
    end
end)

-- === 快捷鍵系統 ===
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if not Settings.KeybindsEnabled then return end
    
    -- F - 飛行
    if input.KeyCode == Enum.KeyCode.F then
        Settings.Fly = not Settings.Fly
        if UpdateChar() then
            if Settings.Fly then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "KeybindFlyBV"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Parent = RootPart
                Humanoid.PlatformStand = true
            else
                local bv = RootPart:FindFirstChild("KeybindFlyBV")
                if bv then bv:Destroy() end
                Humanoid.PlatformStand = false
            end
        end
        Rayfield:Notify({Title = "快捷鍵", Content = "飛行: " .. (Settings.Fly and "開" or "關"), Duration = 1})
        
    -- V - 穿牆
    elseif input.KeyCode == Enum.KeyCode.V then
        Settings.Noclip = not Settings.Noclip
        Rayfield:Notify({Title = "快捷鍵", Content = "穿牆: " .. (Settings.Noclip and "開" or "關"), Duration = 1})
        
    -- G - 速度
    elseif input.KeyCode == Enum.KeyCode.G then
        Settings.Speed = not Settings.Speed
        if UpdateChar() and Humanoid then
            Humanoid.WalkSpeed = Settings.Speed and (16 * Settings.SpeedMult) or 16
        end
        Rayfield:Notify({Title = "快捷鍵", Content = "速度: " .. (Settings.Speed and "開" or "關"), Duration = 1})
        
    -- X - ESP
    elseif input.KeyCode == Enum.KeyCode.X then
        Settings.ESP = not Settings.ESP
        Rayfield:Notify({Title = "快捷鍵", Content = "ESP: " .. (Settings.ESP and "開" or "關"), Duration = 1})
        
    -- H - 無敵
    elseif input.KeyCode == Enum.KeyCode.H then
        Settings.God = not Settings.God
        if UpdateChar() and Humanoid then
            if Settings.God then
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
            else
                Humanoid.MaxHealth = 100
                Humanoid.Health = 100
            end
        end
        Rayfield:Notify({Title = "快捷鍵", Content = "無敵: " .. (Settings.God and "開" or "關"), Duration = 1})
    end
end)

-- === 物品 ESP ===
local ItemESPData = {}
spawn(function()
    while task.wait(0.5) do
        if Settings.ItemESP and UpdateChar() then
            -- 清理舊的
            for item, gui in pairs(ItemESPData) do
                if not item.Parent then
                    pcall(function() gui:Destroy() end)
                    ItemESPData[item] = nil
                end
            end
            
            -- 創建新的物品 ESP
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") and not ItemESPData[item] then
                    local handle = item:FindFirstChild("Handle")
                    if handle then
                        pcall(function()
                            local bb = Instance.new("BillboardGui")
                            bb.Adornee = handle
                            bb.Size = UDim2.new(0, 120, 0, 40)
                            bb.StudsOffset = Vector3.new(0, 2, 0)
                            bb.AlwaysOnTop = true
                            bb.Parent = handle
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.new(0, 1, 1)
                            label.TextStrokeTransparency = 0
                            label.TextStrokeColor3 = Color3.new(0, 0, 0)
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 14
                            label.Text = "🔫 " .. item.Name
                            label.Parent = bb
                            
                            ItemESPData[item] = bb
                        end)
                    end
                end
            end
        else
            -- 清除所有
            for _, gui in pairs(ItemESPData) do
                pcall(function() gui:Destroy() end)
            end
            ItemESPData = {}
        end
    end
end)

-- === 寶箱 ESP (Blox Fruits) ===
local ChestESPData = {}
spawn(function()
    while task.wait(1) do
        if Settings.ChestESP and UpdateChar() then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    if name:find("chest") or name:find("treasure") or name:find("fruit") then
                        if not ChestESPData[obj] then
                            pcall(function()
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                                if part then
                                    local hl = Instance.new("Highlight")
                                    hl.FillColor = Color3.new(1, 0.8, 0)
                                    hl.OutlineColor = Color3.new(1, 1, 0)
                                    hl.FillTransparency = 0.4
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Parent = obj
                                    
                                    local bb = Instance.new("BillboardGui")
                                    bb.Size = UDim2.new(0, 100, 0, 30)
                                    bb.StudsOffset = Vector3.new(0, 3, 0)
                                    bb.AlwaysOnTop = true
                                    bb.Adornee = part
                                    bb.Parent = part
                                    
                                    local label = Instance.new("TextLabel")
                                    label.Size = UDim2.new(1, 0, 1, 0)
                                    label.BackgroundTransparency = 1
                                    label.TextColor3 = Color3.new(1, 0.8, 0)
                                    label.TextStrokeTransparency = 0
                                    label.Font = Enum.Font.GothamBold
                                    label.TextSize = 12
                                    label.Text = "📦 " .. obj.Name
                                    label.Parent = bb
                                    
                                    ChestESPData[obj] = {hl, bb}
                                end
                            end)
                        end
                    end
                end
            end
        else
            for _, data in pairs(ChestESPData) do
                pcall(function()
                    for _, v in pairs(data) do v:Destroy() end
                end)
            end
            ChestESPData = {}
        end
    end
end)

-- === Wall Hack (透視牆壁) ===
spawn(function()
    while task.wait(0.5) do
        if Settings.WallHack then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Transparency < 0.5 then
                    if not obj:IsDescendantOf(Character or {}) then
                        local name = obj.Name:lower()
                        if name:find("wall") or name:find("brick") or name:find("concrete") then
                            obj.Transparency = 0.7
                        end
                    end
                end
            end
        end
    end
end)


spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm and UpdateChar() then
            local closestNPC = nil
            local closestDist = Settings.FarmRadius
            for _, model in pairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                    if not Players:GetPlayerFromCharacter(model) then
                        local hum = model:FindFirstChildOfClass("Humanoid")
                        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                        if hum and hrp and hum.Health > 0 then
                            local dist = (hrp.Position - RootPart.Position).Magnitude
                            if dist < closestDist then
                                closestNPC = {model = model, hrp = hrp, hum = hum}
                                closestDist = dist
                            end
                        end
                    end
                end
            end
            
            if closestNPC then

                RootPart.CFrame = closestNPC.hrp.CFrame * CFrame.new(0, 0, 3)
                pcall(function()
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                    if firetouchinterest then
                        firetouchinterest(RootPart, closestNPC.hrp, 0)
                        task.wait()
                        firetouchinterest(RootPart, closestNPC.hrp, 1)
                    end
                end)
            end
        end
    end
end)

print("[Zy hacker hub] 新功能核心邏輯已載入!")

-- === 最終統計 ===
local TotalFeatures = 0
for _, _ in pairs(Settings) do
    TotalFeatures = TotalFeatures + 1
end

print("[Zy hacker hub] 已載入 " .. TotalFeatures .. " 個設定項目")
print("[Zy hacker hub] 額外功能擴展已載入!")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              進階功能核心邏輯 v2.0                          ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入進階功能核心邏輯 v2.0...")

-- === Reach Hack ===
spawn(function()
    while task.wait(0.1) do
        if Settings.ReachHack and UpdateChar() then
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        handle.Size = Vector3.new(Settings.ReachDistance, Settings.ReachDistance, Settings.ReachDistance)
                        handle.Transparency = 0.8
                    end
                end
            end
        end
    end
end)

-- === Auto Combo ===
spawn(function()
    while true do
        task.wait(Settings.ComboDelay)
        if Settings.AutoCombo and UpdateChar() then
            pcall(function()
                local tool = Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                if mouse1click then mouse1click() end
            end)
        end
    end
end)

-- === Punch Aura ===
spawn(function()
    while task.wait(0.1) do
        if Settings.PunchAura and UpdateChar() then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - RootPart.Position).Magnitude
                        if dist <= Settings.PunchRange then
                            pcall(function()
                                if mouse1click then mouse1click() end
                                if firetouchinterest then
                                    firetouchinterest(RootPart, hrp, 0)
                                    task.wait()
                                    firetouchinterest(RootPart, hrp, 1)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- === Target Lock ===
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Q and Settings.TargetLock then
        local closest, minDist = nil, math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and UpdateChar() then
                    local dist = (hrp.Position - RootPart.Position).Magnitude
                    if dist < minDist then
                        closest = player
                        minDist = dist
                    end
                end
            end
        end
        Settings.LockedTarget = closest
        if closest then
            Rayfield:Notify({Title = "鎖定", Content = "已鎖定: " .. closest.Name, Duration = 2})
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Settings.TargetLock and Settings.LockedTarget and UpdateChar() then
        local target = Settings.LockedTarget
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
        else
            Settings.LockedTarget = nil
        end
    end
end)

-- === Teleport Aura ===
spawn(function()
    while task.wait(0.3) do
        if Settings.TeleportAura and UpdateChar() then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local dist = (hrp.Position - RootPart.Position).Magnitude
                        if dist <= Settings.TPAuraRange then
                            local behindPos = hrp.CFrame * CFrame.new(0, 0, 3)
                            RootPart.CFrame = behindPos
                            pcall(function() if mouse1click then mouse1click() end end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- === Long Jump ===
UserInputService.JumpRequest:Connect(function()
    if Settings.LongJump and UpdateChar() and Humanoid then
        local moveDir = Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            RootPart.Velocity = Vector3.new(
                moveDir.X * Settings.LongJumpPower,
                Settings.LongJumpPower * 0.5,
                moveDir.Z * Settings.LongJumpPower
            )
        end
    end
end)

-- === NPC ESP ===
local NPCESPData = {}
spawn(function()
    while task.wait(1) do
        if Settings.NPCESP and UpdateChar() then
            for npc, gui in pairs(NPCESPData) do
                if not npc.Parent then
                    pcall(function() gui:Destroy() end)
                    NPCESPData[npc] = nil
                end
            end
            for _, model in pairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                    if not Players:GetPlayerFromCharacter(model) and not NPCESPData[model] then
                        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                        if hrp then
                            pcall(function()
                                local hl = Instance.new("Highlight")
                                hl.FillColor = Color3.new(1, 0.5, 0)
                                hl.OutlineColor = Color3.new(1, 1, 0)
                                hl.FillTransparency = 0.5
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = model
                                NPCESPData[model] = hl
                            end)
                        end
                    end
                end
            end
        else
            for _, gui in pairs(NPCESPData) do pcall(function() gui:Destroy() end) end
            NPCESPData = {}
        end
    end
end)

-- === Blade Ball 專用 ===
spawn(function()
    while task.wait(0.01) do
        if Settings.BladeBall.AutoDodge and CurrentGame.Name == "Blade Ball" then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
                        if UpdateChar() then
                            local dist = (obj.Position - RootPart.Position).Magnitude
                            if dist < 15 then
                                local dodgeDir = (RootPart.Position - obj.Position).Unit
                                RootPart.CFrame = RootPart.CFrame + (dodgeDir * 10)
                            end
                        end
                    end
                end
            end)
        end
        if Settings.BladeBall.BallESP and CurrentGame.Name == "Blade Ball" then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("ball") and not obj:FindFirstChild("BallHL") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "BallHL"
                    hl.FillColor = Color3.new(1, 0, 1)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = obj
                end
            end
        end
    end
end)

-- === Blox Fruits 水果通知 ===
spawn(function()
    while task.wait(1) do
        if Settings.BloxFruits.FruitNotifier and CurrentGame.Name == "Blox Fruits" then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("fruit") and not obj:FindFirstChild("FruitNotified") then
                    local tag = Instance.new("BoolValue")
                    tag.Name = "FruitNotified"
                    tag.Parent = obj
                    Rayfield:Notify({Title = "🍎 水果發現!", Content = obj.Name .. " 已出現!", Duration = 10})
                end
            end
        end
    end
end)

-- === Da Hood 自動踩人 ===
spawn(function()
    while task.wait(0.1) do
        if Settings.DaHood.AutoStomp and CurrentGame.Name == "Da Hood" and UpdateChar() then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum:GetState() == Enum.HumanoidStateType.Dead then
                        local dist = (hrp.Position - RootPart.Position).Magnitude
                        if dist < 10 then
                            pcall(function()
                                local e = ReplicatedStorage:FindFirstChild("MainEvent")
                                if e then e:FireServer("Stomp", player.Character) end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- === Lag Switch ===
spawn(function()
    while task.wait(0.1) do
        if Settings.LagSwitch then
            pcall(function() settings().Network.IncomingReplicationLag = Settings.LagDuration end)
        else
            pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        end
    end
end)

print("[Zy hacker hub] 進階功能核心邏輯 v2.0 已載入!")
print("")
print("   ╔═══════════════════════════════════════════╗")
print("   ║     Zy hacker hub v" .. VERSION .. " 已完全載入!     ║")
print("   ║         150+ 功能模組已就緒              ║")
print("   ║       感謝使用 Zy hacker hub          ║")
print("   ╚═══════════════════════════════════════════╝")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              原始功能增強邏輯 v3.0                          ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入原始功能增強邏輯 v3.0...")

-- === 飛行模式增強 ===
local FlyVelocity = Vector3.zero
RunService.Heartbeat:Connect(function(dt)
    if FlyActive and FlyBV and FlyBG and UpdateChar() then
        local cf = Camera.CFrame
        local targetDir = Vector3.zero
        
        if KeysDown[Enum.KeyCode.W] then targetDir = targetDir + cf.LookVector end
        if KeysDown[Enum.KeyCode.S] then targetDir = targetDir - cf.LookVector end
        if KeysDown[Enum.KeyCode.A] then targetDir = targetDir - cf.RightVector end
        if KeysDown[Enum.KeyCode.D] then targetDir = targetDir + cf.RightVector end
        if KeysDown[Enum.KeyCode.Space] then targetDir = targetDir + Vector3.yAxis end
        if KeysDown[Enum.KeyCode.LeftControl] then targetDir = targetDir - Vector3.yAxis end
        
        local speed = Settings.FlySpeed
        if KeysDown[Enum.KeyCode.LeftShift] then speed = speed * 3 end
        
        local targetVel = targetDir.Magnitude > 0 and targetDir.Unit * speed or Vector3.zero
        
        -- 根據飛行模式調整
        if Settings.FlyMode == "Glide" then
            -- 滑翔效果
            FlyVelocity = FlyVelocity:Lerp(targetVel, 0.05)
            if targetDir.Magnitude == 0 then
                FlyVelocity = FlyVelocity - Vector3.new(0, 10 * dt, 0)
            end
        elseif Settings.FlyMode == "Helicopter" then
            -- 直升機效果
            FlyVelocity = Vector3.new(targetVel.X, targetDir.Y > 0 and speed * 0.5 or (targetDir.Y < 0 and -speed * 0.5 or 0), targetVel.Z)
        elseif Settings.FlyInertia then
            -- 慣性飛行
            FlyVelocity = FlyVelocity:Lerp(targetVel, Settings.FlyAcceleration / 1000)
        else
            FlyVelocity = targetVel
        end
        
        FlyBV.Velocity = FlyVelocity
        
        if Settings.FlyStabilizer then
            FlyBG.CFrame = cf
        end
    end
end)

-- === 速度模式增強 ===
local CurrentSpeed = 16
RunService.Heartbeat:Connect(function(dt)
    if Settings.Speed and UpdateChar() and Humanoid then
        local targetSpeed = 16 * Settings.SpeedMult * CurrentGame.SpeedMult
        
        if Settings.SpeedMode == "Acceleration" then
            -- 加速模式
            if Humanoid.MoveDirection.Magnitude > 0 then
                CurrentSpeed = math.min(CurrentSpeed + Settings.SpeedAccel, Settings.MaxSpeed)
            else
                CurrentSpeed = 16
            end
            Humanoid.WalkSpeed = CurrentSpeed
        elseif Settings.SpeedMode == "Burst" then
            -- 爆發模式
            if KeysDown[Settings.SpeedBoostKey] then
                Humanoid.WalkSpeed = Settings.MaxSpeed
            else
                Humanoid.WalkSpeed = targetSpeed
            end
        else
            Humanoid.WalkSpeed = targetSpeed
        end
    end
end)

-- === Kill Aura 增強 ===
local function GetKillTargets()
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = GetDistance(hrp.Position)
                if dist <= Settings.KillRange then
                    if not IsTeammate(player) then
                        table.insert(targets, {player = player, hrp = hrp, hum = hum, dist = dist})
                    end
                end
            end
        end
    end
    
    -- 根據優先級排序
    if Settings.KillPriority == "Closest" then
        table.sort(targets, function(a, b) return a.dist < b.dist end)
    elseif Settings.KillPriority == "Lowest HP" then
        table.sort(targets, function(a, b) return a.hum.Health < b.hum.Health end)
    elseif Settings.KillPriority == "Random" then
        for i = #targets, 2, -1 do
            local j = math.random(i)
            targets[i], targets[j] = targets[j], targets[i]
        end
    end
    
    return targets
end

-- === ESP Rainbow Mode ===
spawn(function()
    local hue = 0
    while true do
        task.wait(0.05)
        if Settings.ESPRainbow then
            hue = (hue + 0.01) % 1
            Settings.ESPColor = Color3.fromHSV(hue, 1, 1)
        end
    end
end)

-- === X-Ray 透視邏輯 ===
spawn(function()
    while task.wait(0.5) do
        if Settings.XRay then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Transparency < 0.5 then
                    if not obj:IsDescendantOf(Character or {}) then
                        pcall(function()
                            obj.LocalTransparencyModifier = 0.7
                        end)
                    end
                end
            end
        end
    end
end)

-- === 音效系統 ===
local function PlaySound(soundId)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 1
        sound.Parent = Workspace
        sound:Play()
        Debris:AddItem(sound, 2)
    end)
end

-- 監聽擊中事件
if UpdateChar() and Humanoid then
    Humanoid.HealthChanged:Connect(function(health)
        if Settings.HitSound and health < Humanoid.MaxHealth then
            PlaySound(Settings.HitSoundID)
        end
    end)
end

-- === Kill Count 追蹤 ===
spawn(function()
    while task.wait(0.5) do
        if Settings.LogKills then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 0 then
                        local lastKiller = player.Character:GetAttribute("LastDamagedBy")
                        if lastKiller == LocalPlayer.Name then
                            Settings.KillCount = Settings.KillCount + 1
                            if Settings.KillSound then
                                PlaySound(Settings.KillSoundID)
                            end
                            Rayfield:Notify({Title = "擊殺", Content = "擊殺數: " .. Settings.KillCount, Duration = 2})
                        end
                    end
                end
            end
        end
    end
end)

-- === Auto Collect ===
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoCollect and UpdateChar() then
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") then
                    local handle = item:FindFirstChild("Handle")
                    if handle then
                        local dist = (handle.Position - RootPart.Position).Magnitude
                        if dist < 15 then
                            pcall(function()
                                if firetouchinterest then
                                    firetouchinterest(RootPart, handle, 0)
                                    task.wait()
                                    firetouchinterest(RootPart, handle, 1)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- === Auto Equip ===
spawn(function()
    while task.wait(1) do
        if Settings.AutoEquip and UpdateChar() then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = Character
                end
            end
        end
    end
end)

print("[Zy hacker hub] 原始功能增強邏輯 v3.0 已載入!")
print("")
print("   ╔═══════════════════════════════════════════════════╗")
print("   ║     Zy hacker hub v" .. VERSION .. " Ultimate Edition        ║")
print("   ║              200+ 功能模組已就緒                  ║")
print("   ║           感謝使用 Zy hacker hub               ║")
print("   ╚═══════════════════════════════════════════════════╝")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              終極功能邏輯 v4.0                              ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入終極功能邏輯 v4.0...")

-- === Bunny Hop ===
UserInputService.JumpRequest:Connect(function()
    if Settings.BunnyHop and UpdateChar() and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === Air Control ===
RunService.Heartbeat:Connect(function()
    if Settings.AirControl and UpdateChar() and Humanoid and RootPart then
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                RootPart.Velocity = Vector3.new(
                    RootPart.Velocity.X + moveDir.X * Settings.AirControlAmount * 0.1,
                    RootPart.Velocity.Y,
                    RootPart.Velocity.Z + moveDir.Z * Settings.AirControlAmount * 0.1
                )
            end
        end
    end
end)

-- === Camera Shake ===
RunService.RenderStepped:Connect(function()
    if Settings.CameraShake then
        local intensity = Settings.ShakeIntensity * 0.01
        local shake = CFrame.Angles(
            math.random() * intensity - intensity/2,
            math.random() * intensity - intensity/2,
            math.random() * intensity - intensity/2
        )
        Camera.CFrame = Camera.CFrame * shake
    end
end)

-- === Camera Tilt ===
RunService.RenderStepped:Connect(function()
    if Settings.CameraTilt and UpdateChar() and Humanoid then
        local moveDir = Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local tilt = math.rad(Settings.TiltAmount * moveDir.X)
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, -tilt * 0.1)
        end
    end
end)

-- === Free Look ===
local FreeLookActive = false
local OriginalCFrame = nil
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt and Settings.FreeLook then
        FreeLookActive = true
        OriginalCFrame = Camera.CFrame
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        FreeLookActive = false
    end
end)

-- === Rage Mode 邏輯 ===
spawn(function()
    while task.wait(0.1) do
        if Settings.RageMode and UpdateChar() then
            -- 攻擊動畫加速
            pcall(function()
                for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
                    track:AdjustSpeed(Settings.RageMultiplier)
                end
            end)
        end
    end
end)

-- === Auto Block 邏輯 ===
spawn(function()
    while task.wait(0.05) do
        if Settings.AutoBlock and UpdateChar() then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (hrp.Position - RootPart.Position).Magnitude
                        if dist < 15 then
                            -- 檢測攻擊
                            local hum = player.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                                    if track.Name:lower():find("attack") or track.Name:lower():find("punch") then
                                        -- 觸發格擋
                                        pcall(function()
                                            if keypress then keypress(0x46); task.wait(0.1); keyrelease(0x46) end
                                        end)
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

-- === Critical Hit 邏輯 ===
-- 儲存原始傷害數值 (在支援的遊戲中)

-- === Watermark ===
local WatermarkLabel = nil
spawn(function()
    task.wait(1)
    if Settings.Watermark then
        pcall(function()
            local sg = Instance.new("ScreenGui")
            sg.Name = "ZyWatermark"
            sg.ResetOnSpawn = false
            sg.Parent = LocalPlayer:FindFirstChild("PlayerGui")
            
            WatermarkLabel = Instance.new("TextLabel")
            WatermarkLabel.Size = UDim2.new(0, 300, 0, 30)
            WatermarkLabel.Position = UDim2.new(0, 10, 0, 10)
            WatermarkLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            WatermarkLabel.BackgroundTransparency = 0.5
            WatermarkLabel.TextColor3 = Color3.new(0, 1, 1)
            WatermarkLabel.Font = Enum.Font.GothamBold
            WatermarkLabel.TextSize = 14
            WatermarkLabel.Text = "Zy hacker hub v" .. VERSION .. " | " .. CurrentGame.Name
            WatermarkLabel.Parent = sg
            
            -- FPS & Ping 顯示
            local StatsLabel = Instance.new("TextLabel")
            StatsLabel.Size = UDim2.new(0, 200, 0, 20)
            StatsLabel.Position = UDim2.new(0, 10, 0, 45)
            StatsLabel.BackgroundTransparency = 1
            StatsLabel.TextColor3 = Color3.new(1, 1, 1)
            StatsLabel.Font = Enum.Font.Gotham
            StatsLabel.TextSize = 12
            StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
            StatsLabel.Parent = sg
            
            spawn(function()
                local lastTime = tick()
                local frameCount = 0
                while task.wait(0.1) do
                    frameCount = frameCount + 1
                    if tick() - lastTime >= 1 then
                        local fps = math.floor(frameCount / (tick() - lastTime))
                        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                        
                        local text = ""
                        if Settings.FPSDisplay then text = text .. "FPS: " .. fps .. " | " end
                        if Settings.PingDisplay then text = text .. "Ping: " .. ping .. "ms | " end
                        text = text .. "Kills: " .. Settings.KillCount
                        
                        StatsLabel.Text = text
                        frameCount = 0
                        lastTime = tick()
                    end
                end
            end)
        end)
    end
end)

-- === Session Timer ===
spawn(function()
    while task.wait(1) do
        Settings.SessionTime = Settings.SessionTime + 1
    end
end)

-- === Radar 系統 ===
local RadarFrame = nil
spawn(function()
    task.wait(2)
    pcall(function()
        local sg = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ZyWatermark")
        if not sg then return end
        
        RadarFrame = Instance.new("Frame")
        RadarFrame.Name = "Radar"
        RadarFrame.Size = UDim2.new(0, Settings.RadarSize, 0, Settings.RadarSize)
        RadarFrame.Position = UDim2.new(1, -Settings.RadarSize - 10, 0, 10)
        RadarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        RadarFrame.BackgroundTransparency = 0.5
        RadarFrame.BorderSizePixel = 2
        RadarFrame.BorderColor3 = Color3.new(0, 1, 1)
        RadarFrame.Visible = false
        RadarFrame.Parent = sg
        
        local CenterDot = Instance.new("Frame")
        CenterDot.Size = UDim2.new(0, 6, 0, 6)
        CenterDot.Position = UDim2.new(0.5, -3, 0.5, -3)
        CenterDot.BackgroundColor3 = Color3.new(0, 1, 0)
        CenterDot.BorderSizePixel = 0
        CenterDot.Parent = RadarFrame
        
        spawn(function()
            while task.wait(0.1) do
                RadarFrame.Visible = Settings.ShowRadar
                RadarFrame.Size = UDim2.new(0, Settings.RadarSize, 0, Settings.RadarSize)
                
                if Settings.ShowRadar and UpdateChar() then
                    -- 清除舊點
                    for _, c in pairs(RadarFrame:GetChildren()) do
                        if c.Name == "PlayerDot" then c:Destroy() end
                    end
                    
                    -- 添加玩家點
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local offset = hrp.Position - RootPart.Position
                                local x = offset.X / Settings.RadarZoom / 10
                                local z = offset.Z / Settings.RadarZoom / 10
                                
                                if math.abs(x) < Settings.RadarSize/2 and math.abs(z) < Settings.RadarSize/2 then
                                    local dot = Instance.new("Frame")
                                    dot.Name = "PlayerDot"
                                    dot.Size = UDim2.new(0, 4, 0, 4)
                                    dot.Position = UDim2.new(0.5, x - 2, 0.5, z - 2)
                                    dot.BackgroundColor3 = IsTeammate(player) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                                    dot.BorderSizePixel = 0
                                    dot.Parent = RadarFrame
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end)

-- === Damage Numbers ===
local function ShowDamageNumber(position, damage)
    if not Settings.DamageNumbers then return end
    pcall(function()
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Position = position + Vector3.new(0, 3, 0)
        part.Parent = Workspace
        
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 100, 0, 50)
        bb.AlwaysOnTop = true
        bb.Parent = part
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = damage > 50 and Color3.new(1, 0, 0) or Color3.new(1, 1, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 24
        label.Text = "-" .. math.floor(damage)
        label.Parent = bb
        
        spawn(function()
            for i = 1, 20 do
                part.Position = part.Position + Vector3.new(0, 0.1, 0)
                label.TextTransparency = i / 20
                task.wait(0.05)
            end
            part:Destroy()
        end)
    end)
end

-- === Auto Reload ===
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoReload and UpdateChar() then
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("ammo")
                    if ammo and ammo.Value <= 0 then
                        if keypress then keypress(0x52); task.wait(0.1); keyrelease(0x52) end -- R key
                    end
                end)
            end
        end
    end
end)

print("[Zy hacker hub] 終極功能邏輯 v4.0 已載入!")
print("")
print("   ╔═══════════════════════════════════════════════════════╗")
print("   ║        Zy hacker hub v" .. VERSION .. " SUPREME EDITION          ║")
print("   ║                  250+ 功能模組已就緒                  ║")
print("   ║              感謝使用 Zy hacker hub                ║")
print("   ╚═══════════════════════════════════════════════════════╝")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              終極功能邏輯 v4.0                              ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入終極功能邏輯 v4.0...")

-- === Bunny Hop ===
UserInputService.JumpRequest:Connect(function()
    if Settings.BunnyHop and UpdateChar() and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === Air Control ===
RunService.Heartbeat:Connect(function()
    if Settings.AirControl and UpdateChar() and Humanoid and RootPart then
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                RootPart.Velocity = Vector3.new(
                    RootPart.Velocity.X + moveDir.X * Settings.AirControlAmount * 0.1,
                    RootPart.Velocity.Y,
                    RootPart.Velocity.Z + moveDir.Z * Settings.AirControlAmount * 0.1
                )
            end
        end
    end
end)

-- === Camera Shake ===
RunService.RenderStepped:Connect(function()
    if Settings.CameraShake then
        local intensity = Settings.ShakeIntensity * 0.01
        local shake = CFrame.Angles(
            math.random() * intensity - intensity/2,
            math.random() * intensity - intensity/2,
            math.random() * intensity - intensity/2
        )
        Camera.CFrame = Camera.CFrame * shake
    end
end)

-- === Camera Tilt ===
RunService.RenderStepped:Connect(function()
    if Settings.CameraTilt and UpdateChar() and Humanoid then
        local moveDir = Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local tilt = math.rad(Settings.TiltAmount * moveDir.X)
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, -tilt * 0.1)
        end
    end
end)

-- === Rage Mode 邏輯 ===
spawn(function()
    while task.wait(0.1) do
        if Settings.RageMode and UpdateChar() then
            pcall(function()
                for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
                    track:AdjustSpeed(Settings.RageMultiplier)
                end
            end)
        end
    end
end)

-- === Session Timer ===
spawn(function()
    while task.wait(1) do
        Settings.SessionTime = Settings.SessionTime + 1
    end
end)

-- === Auto Reload ===
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoReload and UpdateChar() then
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("ammo")
                    if ammo and ammo.Value <= 0 then
                        if keypress then keypress(0x52); task.wait(0.1); keyrelease(0x52) end
                    end
                end)
            end
        end
    end
end)

print("[Zy hacker hub] 終極功能邏輯 v4.0 已載入!")
print("")
print("   ╔═══════════════════════════════════════════════════════╗")
print("   ║        Zy hacker hub v" .. VERSION .. " SUPREME EDITION          ║")
print("   ║                  250+ 功能模組已就緒                  ║")
print("   ║              感謝使用 Zy hacker hub                ║")
print("   ╚═══════════════════════════════════════════════════════╝")


-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              精英功能邏輯 v5.0                              ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入精英功能邏輯 v5.0...")

-- === 觀戰模式 ===
RunService.RenderStepped:Connect(function()
    if Settings.SpectatorMode and Settings.SpectatedPlayer then
        local target = Players:FindFirstChild(Settings.SpectatedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(targetPos + Vector3.new(0, Settings.SpectatorDistance, Settings.SpectatorDistance), targetPos)
        end
    end
end)

-- 按 C 觀戰選中玩家
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.C and Settings.SpectatorMode then
        if TargetPlayer then
            Settings.SpectatedPlayer = TargetPlayer
            Rayfield:Notify({Title = "觀戰", Content = "正在觀戰 " .. TargetPlayer, Duration = 2})
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        Settings.SpectatedPlayer = nil
    end
end)

-- === 時間控制循環 ===
spawn(function()
    while task.wait(0.5) do
        if Settings.TimeControl then
            Lighting.ClockTime = Settings.TimeValue
        end
    end
end)

-- === 聊天記錄器 ===
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if Settings.ChatLogger then
            table.insert(Settings.ChatLogs, {
                time = os.date("%H:%M:%S"),
                player = player.Name,
                message = message
            })
        end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.Chatted:Connect(function(message)
            if Settings.ChatLogger then
                table.insert(Settings.ChatLogs, {
                    time = os.date("%H:%M:%S"),
                    player = player.Name,
                    message = message
                })
            end
        end)
    end
end

-- === 管理員檢測 ===
local AdminNames = {"Admin", "Mod", "Moderator", "Owner", "Developer"}
spawn(function()
    while task.wait(5) do
        if Settings.HideFromAdmins then
            for _, player in pairs(Players:GetPlayers()) do
                for _, admin in pairs(AdminNames) do
                    if player.Name:lower():find(admin:lower()) or 
                       (player:GetRankInGroup(game.CreatorId) or 0) >= 200 then
                        -- 禁用危險功能
                        Settings.Speed = false
                        Settings.Fly = false
                        Settings.God = false
                        Rayfield:Notify({Title = "⚠️ 警告", Content = "管理員在場！已禁用功能", Duration = 5})
                        break
                    end
                end
            end
        end
    end
end)

-- === Auto Play 邏輯 ===
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoPlay and UpdateChar() then
            -- 自動移動到最近敵人並攻擊
            local closest = nil
            local minDist = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (hrp.Position - RootPart.Position).Magnitude
                        if dist < minDist then
                            closest = hrp
                            minDist = dist
                        end
                    end
                end
            end
            if closest and minDist > 10 then
                Humanoid:MoveTo(closest.Position)
            elseif closest then
                pcall(function()
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end)
            end
        end
    end
end)

-- === Auto Dodge 邏輯 ===
spawn(function()
    while task.wait(0.05) do
        if Settings.AutoDodge and UpdateChar() then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                            if track.Name:lower():find("attack") or track.Name:lower():find("swing") then
                                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local dist = (hrp.Position - RootPart.Position).Magnitude
                                    if dist < 15 then
                                        local dodgeDir = (RootPart.Position - hrp.Position).Unit
                                        RootPart.CFrame = RootPart.CFrame + (dodgeDir * 5)
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

-- === Remote Logger ===
if Settings.RemoteLogger then
    pcall(function()
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
            print("[Remote] " .. tostring(self) .. " : ", ...)
            return oldFire(self, ...)
        end)
    end)
end

-- === 高亮好友/敵人 ===
spawn(function()
    while task.wait(1) do
        if Settings.HighlightFriends or Settings.HighlightEnemies then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local existing = player.Character:FindFirstChild("FriendEnemyHL")
                    
                    local isFriend = table.find(Settings.FriendList, player.Name)
                    local isEnemy = table.find(Settings.EnemyList, player.Name)
                    
                    if isFriend and Settings.HighlightFriends then
                        if not existing then
                            local hl = Instance.new("Highlight")
                            hl.Name = "FriendEnemyHL"
                            hl.FillColor = Color3.new(0, 1, 0)
                            hl.OutlineColor = Color3.new(0, 1, 0)
                            hl.FillTransparency = 0.5
                            hl.Parent = player.Character
                        end
                    elseif isEnemy and Settings.HighlightEnemies then
                        if not existing then
                            local hl = Instance.new("Highlight")
                            hl.Name = "FriendEnemyHL"
                            hl.FillColor = Color3.new(1, 0, 0)
                            hl.OutlineColor = Color3.new(1, 0, 0)
                            hl.FillTransparency = 0.5
                            hl.Parent = player.Character
                        end
                    else
                        if existing then existing:Destroy() end
                    end
                end
            end
        end
    end
end)

print("[Zy hacker hub] 精英功能邏輯 v5.0 已載入!")
print("")
print("   ╔═══════════════════════════════════════════════════════════╗")
print("   ║          Zy hacker hub v" .. VERSION .. " LEGENDARY EDITION           ║")
print("   ║                    300+ 功能模組已就緒                    ║")
print("   ║                 感謝使用 Zy hacker hub                 ║")
print("   ╚═══════════════════════════════════════════════════════════╝")


-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              終極功能邏輯 v6.0                              ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入終極功能邏輯 v6.0...")

-- === Double Jump 邏輯 ===
local CanDoubleJump = true
local HasDoubleJumped = false

UserInputService.JumpRequest:Connect(function()
    if Settings.DoubleJump and UpdateChar() and Humanoid then
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and not HasDoubleJumped and CanDoubleJump then
            HasDoubleJumped = true
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, Settings.DoubleJumpPower, RootPart.Velocity.Z)
        end
    end
end)

Humanoid.StateChanged:Connect(function(old, new)
    if new == Enum.HumanoidStateType.Landed then
        HasDoubleJumped = false
    end
end)

-- === Dash 邏輯 ===
local DashCooldownActive = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E and Settings.DashAbility and UpdateChar() then
        if not DashCooldownActive then
            DashCooldownActive = true
            local dir = Humanoid.MoveDirection
            if dir.Magnitude > 0 then
                RootPart.CFrame = RootPart.CFrame + (dir * Settings.DashDistance)
            else
                RootPart.CFrame = RootPart.CFrame + (Camera.CFrame.LookVector * Settings.DashDistance)
            end
            task.delay(Settings.DashCooldown, function()
                DashCooldownActive = false
            end)
        end
    end
end)

-- === Grapple Hook 邏輯 ===
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.R and Settings.GrappleHook and UpdateChar() then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {Character}
        local result = Workspace:Raycast(RootPart.Position, Camera.CFrame.LookVector * Settings.GrappleRange, params)
        if result then
            local targetPos = result.Position
            local tween = TweenService:Create(RootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
            tween:Play()
        end
    end
end)

-- === Wall Run 邏輯 ===
RunService.Heartbeat:Connect(function()
    if Settings.WallRun and UpdateChar() and Humanoid then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {Character}
        local rightRay = Workspace:Raycast(RootPart.Position, RootPart.CFrame.RightVector * 3, params)
        local leftRay = Workspace:Raycast(RootPart.Position, -RootPart.CFrame.RightVector * 3, params)
        
        if (rightRay or leftRay) and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            RootPart.Velocity = Vector3.new(
                RootPart.Velocity.X,
                Settings.WallRunSpeed,
                RootPart.Velocity.Z
            )
        end
    end
end)

-- === Auto Shoot 邏輯 ===
spawn(function()
    while task.wait(0.1) do
        if Settings.AutoShoot and UpdateChar() then
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

-- === Auto Loot 邏輯 ===
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoLoot and UpdateChar() then
            for _, item in pairs(Workspace:GetDescendants()) do
                if item:IsA("Tool") or (item:IsA("Model") and item:FindFirstChild("Handle")) then
                    local pos = item:IsA("Tool") and item.Handle.Position or item:FindFirstChild("Handle").Position
                    if (pos - RootPart.Position).Magnitude < 20 then
                        pcall(function()
                            if firetouchinterest then
                                local handle = item:IsA("Tool") and item.Handle or item:FindFirstChild("Handle")
                                firetouchinterest(RootPart, handle, 0)
                                task.wait()
                                firetouchinterest(RootPart, handle, 1)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- === Hitmarker 邏輯 ===
local HitmarkerLines = {}
local function ShowHitmarker()
    if not Settings.HitmarkerEnabled then return end
    
    pcall(function()
        if Settings.HitmarkerSound then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://160432334"
            sound.Volume = 0.5
            sound.Parent = Workspace
            sound:Play()
            Debris:AddItem(sound, 1)
        end
        
        -- 清除舊的
        for _, line in pairs(HitmarkerLines) do
            pcall(function() line:Remove() end)
        end
        HitmarkerLines = {}
        
        local center = Camera.ViewportSize / 2
        local size = 10
        
        for i = 1, 4 do
            local line = Drawing.new("Line")
            line.Color = Settings.HitmarkerColor
            line.Thickness = 2
            line.Visible = true
            
            if i == 1 then line.From = center + Vector2.new(-size, -size); line.To = center + Vector2.new(-size/2, -size/2)
            elseif i == 2 then line.From = center + Vector2.new(size, -size); line.To = center + Vector2.new(size/2, -size/2)
            elseif i == 3 then line.From = center + Vector2.new(-size, size); line.To = center + Vector2.new(-size/2, size/2)
            else line.From = center + Vector2.new(size, size); line.To = center + Vector2.new(size/2, size/2) end
            
            table.insert(HitmarkerLines, line)
        end
        
        task.delay(0.2, function()
            for _, line in pairs(HitmarkerLines) do
                pcall(function() line:Remove() end)
            end
            HitmarkerLines = {}
        end)
    end)
end

-- === Kill Effect 邏輯 ===
local function ShowKillEffect(position)
    if not Settings.KillEffect then return end
    pcall(function()
        if Settings.KillEffectType == "Confetti" then
            for i = 1, 20 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(0.2, 0.2, 0.2)
                part.Position = position + Vector3.new(math.random(-3, 3), math.random(0, 5), math.random(-3, 3))
                part.Color = Color3.fromHSV(math.random(), 1, 1)
                part.Anchored = false
                part.CanCollide = false
                part.Parent = Workspace
                Debris:AddItem(part, 2)
            end
        elseif Settings.KillEffectType == "Explosion" then
            local exp = Instance.new("Explosion")
            exp.Position = position
            exp.BlastRadius = 0
            exp.BlastPressure = 0
            exp.Parent = Workspace
        end
    end)
end

-- === Magnetism Aimbot 邏輯 ===
RunService.RenderStepped:Connect(function()
    if Settings.AimbotMagnetism and Settings.Aimbot and UpdateChar() then
        local closest = nil
        local minDist = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild(Settings.AimPart) or player.Character:FindFirstChild("Head")
                if part then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                    if onScreen then
                        local center = Camera.ViewportSize / 2
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < Settings.AimFOV and dist < minDist then
                            closest = part
                            minDist = dist
                        end
                    end
                end
            end
        end
        if closest then
            local targetCF = CFrame.lookAt(Camera.CFrame.Position, closest.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.MagnetismStrength / 1000)
        end
    end
end)

print("[Zy hacker hub] 終極功能邏輯 v6.0 已載入!")
print("")
print("   ╔═══════════════════════════════════════════════════════════════╗")
print("   ║            Zy hacker hub v" .. VERSION .. " ULTIMATE EDITION              ║")
print("   ║                      350+ 功能模組已就緒                      ║")
print("   ║                   感謝使用 Zy hacker hub                   ║")
print("   ╚═══════════════════════════════════════════════════════════════╝")


-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                       第一人稱角色隱藏邏輯 (Arsenal/Rivals)                 ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入第一人稱角色隱藏邏輯...")

-- 隱藏部位列表
local HeadParts = {"Head", "face", "Face", "HumanoidRootPart"}
local TorsoParts = {"Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
local ArmParts = {"Left Arm", "Right Arm", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand"}
local LegParts = {"Left Leg", "Right Leg", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"}

local function SetPartTransparency(partName, transparency)
    if not UpdateChar() then return end
    local part = Character:FindFirstChild(partName)
    if part and part:IsA("BasePart") then
        part.LocalTransparencyModifier = transparency
    end
end

local function SetCharacterVisibility()
    if not UpdateChar() then return end
    
    local isFirstPerson = (Camera.CFrame.Position - (Head and Head.Position or RootPart.Position)).Magnitude < 2
    local shouldHide = Settings.FirstPersonInvisible and (isFirstPerson or not Settings.AutoHideInFPS)
    
    if shouldHide or Settings.GhostMode then
        local trans = Settings.GhostMode and 1 or 1
        
        -- 隱藏頭部
        if Settings.HideHead then
            for _, partName in pairs(HeadParts) do
                SetPartTransparency(partName, trans)
            end
            -- 隱藏頭上的飾品
            if Settings.HideAccessories and Head then
                for _, acc in pairs(Character:GetDescendants()) do
                    if acc:IsA("Accessory") then
                        local handle = acc:FindFirstChild("Handle")
                        if handle then handle.LocalTransparencyModifier = trans end
                    end
                end
            end
            -- 隱藏臉部
            if Head then
                local face = Head:FindFirstChild("face") or Head:FindFirstChild("Face")
                if face then face.LocalTransparencyModifier = trans end
            end
        end
        
        -- 隱藏身體
        if Settings.HideTorso then
            for _, partName in pairs(TorsoParts) do
                SetPartTransparency(partName, trans)
            end
        end
        
        -- 隱藏手臂
        if Settings.HideArms then
            for _, partName in pairs(ArmParts) do
                SetPartTransparency(partName, trans)
            end
        end
        
        -- 隱藏腿部
        if Settings.HideLegs then
            for _, partName in pairs(LegParts) do
                SetPartTransparency(partName, trans)
            end
        end
    else
        -- 恢復可見
        local trans = Settings.CharacterTransparency and Settings.TransparencyAmount or 0
        
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = trans
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.LocalTransparencyModifier = trans
            end
        end
    end
end

-- 主要循環
RunService.RenderStepped:Connect(function()
    if Settings.FirstPersonInvisible or Settings.GhostMode or Settings.CharacterTransparency then
        SetCharacterVisibility()
    end
end)

-- 角色重生時重新應用
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Settings.FirstPersonInvisible or Settings.GhostMode then
        SetCharacterVisibility()
    end
end)

print("[Zy hacker hub] 第一人稱角色隱藏邏輯已載入!")


-- ═══════════════════════════════════════════════════════════════════════════════
-- ║                              Rivals 專區邏輯                                 ║
-- ═══════════════════════════════════════════════════════════════════════════════

print("[Zy hacker hub] 載入 Rivals 專區邏輯...")

-- === Silent Aim 邏輯 ===
local function GetClosestToCrosshair()
    local closest = nil
    local minDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- 檢查是否為隊友
            if IsTeammate(player) then continue end
            
            local part = player.Character:FindFirstChild("Head")
            if part then
                local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local center = Camera.ViewportSize / 2
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < 300 and dist < minDist then -- FOV 300
                        closest = part
                        minDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Settings.Rivals.SilentAim and method == "Raycast" or method == "FindPartOnRay" then
        local target = GetClosestToCrosshair()
        if target then
            if method == "Raycast" then
                -- 修改 Raycast 方向
                args[2] = (target.Position - args[1]).Unit * 1000
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- === Gun Mods 邏輯 ===
spawn(function()
    while task.wait(0.5) do
        -- 針對 Rivals 的武器系統進行修改
        -- 注意: 這需要根據遊戲具體的武器腳本調整，這裡是通用概念
        if Settings.Rivals.NoRecoil or Settings.Rivals.NoSpread or Settings.Rivals.RapidFire then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Recoil") then
                    if Settings.Rivals.NoRecoil then v.Recoil = 0 end
                    if Settings.Rivals.NoSpread then v.Spread = 0 end
                    if Settings.Rivals.RapidFire then v.FireRate = 0.05 end
                    if Settings.Rivals.InfiniteAmmo then v.Ammo = 999; v.StoredAmmo = 999 end
                end
            end
        end
    end
end)

-- === Hitbox Expander 邏輯 ===
spawn(function()
    while task.wait(1) do
        if Settings.Rivals.HitboxExpander then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not IsTeammate(player) then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(Settings.Rivals.HitboxSize, Settings.Rivals.HitboxSize, Settings.Rivals.HitboxSize)
                        hrp.Transparency = 0.5
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- === Rivals ESP 邏輯 ===
-- 復用主 ESP 系統，但添加 Rivals 特定的高亮
spawn(function()
    while task.wait(1) do
        if Settings.Rivals.ESP then
            Settings.ESP = true -- 強制開啟主 ESP
            Settings.ESPBox = true
        end
    end
end)

print("[Zy hacker hub] Rivals 專區邏輯已載入!")

