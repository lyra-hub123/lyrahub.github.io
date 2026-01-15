-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    NukeBot Ultimate v4.0 - Perfect Edition                   ║
-- ║                         Rayfield UI + 完美功能整合                            ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ═══════════════════════════ 服務初始化 ═══════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Character, Humanoid, RootPart
local function RefreshCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid", 10)
    RootPart = Character:WaitForChild("HumanoidRootPart", 10)
end
RefreshCharacter()

-- ═══════════════════════════ 遊戲檢測 ═══════════════════════════
local GameId = game.PlaceId
local GameData = {
    [13772394625] = {Name="Blade Ball", Speed=1.5, Type="Combat"},
    [17625359962] = {Name="Rivals", Speed=2, Type="FPS"},
    [286090429] = {Name="Arsenal", Speed=1.2, Type="FPS"},
    [2788229376] = {Name="Da Hood", Speed=1.8, Type="Combat"},
    [6284583030] = {Name="Blox Fruits", Speed=1.3, Type="RPG"},
}
local CurrentGame = GameData[GameId] or {Name="通用", Speed=1, Type="Unknown"}

-- ═══════════════════════════ 設定系統 ═══════════════════════════
local CFG = {
    -- 移動
    Fly=false, FlySpeed=100, SmoothFly=true,
    Noclip=false, PhaseDown=false,
    SpeedHack=false, SpeedMult=5,
    InfJump=false, HighJump=false, JumpMult=1,
    Spider=false, ClimbSpeed=50,
    AutoJump=false, BHop=false,
    -- 戰鬥
    God=false, SemiGod=false, AntiKB=false, AntiRagdoll=false,
    KillAura=false, KillRange=15, KillMode="Touch",
    SilentAim=false, AimPart="Head", AimFOV=180, AimSmooth=5,
    NoRecoil=false, NoSpread=false, RapidFire=false,
    AutoParry=false, AutoBlock=false,
    Hitbox=false, HitboxSize=10,
    -- ESP
    ESP=false, ESP_Box=true, ESP_Skel=true, ESP_HP=true,
    ESP_Name=true, ESP_Dist=true, ESP_Tracer=false,
    ESP_Color=Color3.new(1,0,0), ESP_SkelColor=Color3.new(1,1,0),
    ESP_TeamCheck=false, ESP_MaxDist=1000,
    -- 視覺
    Fullbright=false, NoFog=false, NoShadows=false,
    Chams=false, ChamsColor=Color3.new(1,0.3,0.3),
    XRay=false, FPSBoost=false, NoParticles=false,
    CustomFOV=false, FOVValue=90,
    ThirdPerson=false, TPDistance=10,
    Freecam=false, FreecamSpeed=1,
    -- 世界
    Gravity=196.2, JumpHeight=7.2,
    TimeFreeze=false, CustomTime=14,
    -- 傳送
    TPMode="Instant", SavedPos={},
    -- 雜項
    AntiAFK=true, ChatSpam=false, SpamMsg="NukeBot v4.0", SpamDelay=3,
    InfYield="Off", AutoRespawn=false, AutoHeal=false,
    ClickTP=false, AirWalk=false,
}

-- ═══════════════════════════ Rayfield 介面 ═══════════════════════════
local Window = Rayfield:CreateWindow({
    Name = "🔥 NukeBot Ultimate v4.0",
    LoadingTitle = "NukeBot Ultimate",
    LoadingSubtitle = "Perfect Edition - " .. CurrentGame.Name,
    ConfigurationSaving = {Enabled=true, FolderName="NukeBotUltimate", FileName="Config_v4"},
    Discord = {Enabled=false},
    KeySystem = false,
})

-- ══════════════════════════ 移動分頁 ══════════════════════════
local MoveTab = Window:CreateTab("🏃 移動", 4483362458)

MoveTab:CreateSection("飛行系統")
MoveTab:CreateToggle({Name="飛行 (Fly)", CurrentValue=false, Callback=function(v) CFG.Fly=v end})
MoveTab:CreateSlider({Name="飛行速度", Range={50,500}, Increment=25, CurrentValue=100, Callback=function(v) CFG.FlySpeed=v end})
MoveTab:CreateToggle({Name="平滑飛行", CurrentValue=true, Callback=function(v) CFG.SmoothFly=v end})

MoveTab:CreateSection("穿透系統")
MoveTab:CreateToggle({Name="穿牆 (Noclip)", CurrentValue=false, Callback=function(v) CFG.Noclip=v end})
MoveTab:CreateToggle({Name="穿地板", CurrentValue=false, Callback=function(v) CFG.PhaseDown=v end})

MoveTab:CreateSection("速度系統")
MoveTab:CreateToggle({Name="速度破解", CurrentValue=false, Callback=function(v)
    CFG.SpeedHack=v
    if Humanoid then Humanoid.WalkSpeed = v and 16*CFG.SpeedMult*CurrentGame.Speed or 16 end
end})
MoveTab:CreateSlider({Name="速度倍率", Range={2,100}, Increment=2, CurrentValue=5, Callback=function(v)
    CFG.SpeedMult=v
    if CFG.SpeedHack and Humanoid then Humanoid.WalkSpeed=16*v*CurrentGame.Speed end
end})

MoveTab:CreateSection("跳躍系統")
MoveTab:CreateToggle({Name="無限跳躍", CurrentValue=false, Callback=function(v) CFG.InfJump=v end})
MoveTab:CreateToggle({Name="超級跳躍", CurrentValue=false, Callback=function(v)
    CFG.HighJump=v
    if Humanoid then Humanoid.JumpPower = v and 150 or 50 end
end})
MoveTab:CreateSlider({Name="跳躍倍率", Range={1,20}, Increment=1, CurrentValue=1, Callback=function(v)
    CFG.JumpMult=v
    if Humanoid then Humanoid.JumpPower=50*v end
end})
MoveTab:CreateToggle({Name="自動跳躍", CurrentValue=false, Callback=function(v) CFG.AutoJump=v end})
MoveTab:CreateToggle({Name="連跳 (BHop)", CurrentValue=false, Callback=function(v) CFG.BHop=v end})

MoveTab:CreateSection("爬牆系統")
MoveTab:CreateToggle({Name="蜘蛛爬牆", CurrentValue=false, Callback=function(v) CFG.Spider=v end})
MoveTab:CreateSlider({Name="爬牆速度", Range={10,100}, Increment=10, CurrentValue=50, Callback=function(v) CFG.ClimbSpeed=v end})

MoveTab:CreateSection("特殊移動")
MoveTab:CreateToggle({Name="空中行走", CurrentValue=false, Callback=function(v) CFG.AirWalk=v end})
MoveTab:CreateToggle({Name="點擊傳送", CurrentValue=false, Callback=function(v) CFG.ClickTP=v end})

-- ══════════════════════════ 戰鬥分頁 ══════════════════════════
local CombatTab = Window:CreateTab("⚔️ 戰鬥", 4483362458)

CombatTab:CreateSection("防禦系統")
CombatTab:CreateToggle({Name="無敵模式 (God)", CurrentValue=false, Callback=function(v)
    CFG.God=v
    if v and Humanoid then Humanoid.MaxHealth=math.huge; Humanoid.Health=math.huge end
end})
CombatTab:CreateToggle({Name="半無敵 (自動回血)", CurrentValue=false, Callback=function(v) CFG.SemiGod=v end})
CombatTab:CreateToggle({Name="抗擊退", CurrentValue=false, Callback=function(v) CFG.AntiKB=v end})
CombatTab:CreateToggle({Name="防倒地", CurrentValue=false, Callback=function(v) CFG.AntiRagdoll=v end})
CombatTab:CreateToggle({Name="自動格擋", CurrentValue=false, Callback=function(v) CFG.AutoBlock=v end})

CombatTab:CreateSection("攻擊系統")
CombatTab:CreateToggle({Name="Kill Aura", CurrentValue=false, Callback=function(v) CFG.KillAura=v end})
CombatTab:CreateSlider({Name="攻擊範圍", Range={5,100}, Increment=5, CurrentValue=15, Callback=function(v) CFG.KillRange=v end})
CombatTab:CreateDropdown({Name="攻擊模式", Options={"Touch","TP","Fling"}, CurrentOption={"Touch"}, Callback=function(v) CFG.KillMode=v[1] end})

CombatTab:CreateSection("瞄準系統 (Silent Aim)")
CombatTab:CreateToggle({Name="Silent Aim 開關", CurrentValue=false, Callback=function(v) CFG.SilentAim=v end})
CombatTab:CreateDropdown({Name="瞄準部位", Options={"Head","UpperTorso","HumanoidRootPart"}, CurrentOption={"Head"}, Callback=function(v) CFG.AimPart=v[1] end})
CombatTab:CreateSlider({Name="瞄準 FOV", Range={30,360}, Increment=10, CurrentValue=180, Callback=function(v) CFG.AimFOV=v end})
CombatTab:CreateSlider({Name="平滑度", Range={1,10}, Increment=1, CurrentValue=5, Callback=function(v) CFG.AimSmooth=v end})

CombatTab:CreateSection("武器輔助")
CombatTab:CreateToggle({Name="無後座力", CurrentValue=false, Callback=function(v) CFG.NoRecoil=v end})
CombatTab:CreateToggle({Name="無散射", CurrentValue=false, Callback=function(v) CFG.NoSpread=v end})
CombatTab:CreateToggle({Name="連射", CurrentValue=false, Callback=function(v) CFG.RapidFire=v end})

CombatTab:CreateSection("Hitbox 擴展")
CombatTab:CreateToggle({Name="Hitbox 擴展器", CurrentValue=false, Callback=function(v) CFG.Hitbox=v end})
CombatTab:CreateSlider({Name="Hitbox 大小", Range={5,50}, Increment=5, CurrentValue=10, Callback=function(v) CFG.HitboxSize=v end})

-- ══════════════════════════ ESP 分頁 ══════════════════════════
local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)

ESPTab:CreateSection("ESP 主開關")
ESPTab:CreateToggle({Name="啟用 ESP", CurrentValue=false, Callback=function(v) CFG.ESP=v end})
ESPTab:CreateToggle({Name="隊伍檢查", CurrentValue=false, Callback=function(v) CFG.ESP_TeamCheck=v end})
ESPTab:CreateSlider({Name="最大距離", Range={100,2000}, Increment=100, CurrentValue=1000, Callback=function(v) CFG.ESP_MaxDist=v end})

ESPTab:CreateSection("顯示選項")
ESPTab:CreateToggle({Name="方框", CurrentValue=true, Callback=function(v) CFG.ESP_Box=v end})
ESPTab:CreateToggle({Name="骨架", CurrentValue=true, Callback=function(v) CFG.ESP_Skel=v end})
ESPTab:CreateToggle({Name="血條", CurrentValue=true, Callback=function(v) CFG.ESP_HP=v end})
ESPTab:CreateToggle({Name="名稱", CurrentValue=true, Callback=function(v) CFG.ESP_Name=v end})
ESPTab:CreateToggle({Name="距離", CurrentValue=true, Callback=function(v) CFG.ESP_Dist=v end})
ESPTab:CreateToggle({Name="追蹤線", CurrentValue=false, Callback=function(v) CFG.ESP_Tracer=v end})

ESPTab:CreateSection("顏色設定")
local colorMap = {["紅"]=Color3.new(1,0,0),["藍"]=Color3.new(0,0,1),["綠"]=Color3.new(0,1,0),["黃"]=Color3.new(1,1,0),["紫"]=Color3.new(1,0,1),["橙"]=Color3.new(1,0.5,0),["白"]=Color3.new(1,1,1),["青"]=Color3.new(0,1,1)}
ESPTab:CreateDropdown({Name="ESP 顏色", Options={"紅","藍","綠","黃","紫","橙","白","青"}, CurrentOption={"紅"}, Callback=function(v) CFG.ESP_Color=colorMap[v[1]] end})
ESPTab:CreateDropdown({Name="骨架顏色", Options={"紅","藍","綠","黃","紫","橙","白","青"}, CurrentOption={"黃"}, Callback=function(v) CFG.ESP_SkelColor=colorMap[v[1]] end})

-- ══════════════════════════ 視覺分頁 ══════════════════════════
local VisualTab = Window:CreateTab("🎨 視覺", 4483362458)

VisualTab:CreateSection("光照效果")
VisualTab:CreateToggle({Name="全亮 (Fullbright)", CurrentValue=false, Callback=function(v)
    CFG.Fullbright=v
    Lighting.Brightness=v and 3 or 1
    Lighting.Ambient=v and Color3.new(1,1,1) or Color3.fromRGB(127,127,127)
    Lighting.GlobalShadows=not v
end})
VisualTab:CreateToggle({Name="無霧", CurrentValue=false, Callback=function(v) CFG.NoFog=v; Lighting.FogEnd=v and 1e9 or 1e5 end})
VisualTab:CreateToggle({Name="無陰影", CurrentValue=false, Callback=function(v) CFG.NoShadows=v; Lighting.GlobalShadows=not v end})
VisualTab:CreateSlider({Name="時間設定", Range={0,24}, Increment=1, CurrentValue=14, Callback=function(v) CFG.CustomTime=v; Lighting.ClockTime=v end})

VisualTab:CreateSection("玩家視覺")
VisualTab:CreateToggle({Name="玩家透視 (Chams)", CurrentValue=false, Callback=function(v) CFG.Chams=v end})
VisualTab:CreateColorPicker({Name="Chams 顏色", Color=Color3.new(1,0.3,0.3), Callback=function(v) CFG.ChamsColor=v end})
VisualTab:CreateToggle({Name="X 光視覺", CurrentValue=false, Callback=function(v) CFG.XRay=v end})

VisualTab:CreateSection("效能優化")
VisualTab:CreateToggle({Name="FPS 優化器", CurrentValue=false, Callback=function(v)
    CFG.FPSBoost=v
    if v then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _,obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled=false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1 end
        end
    end
end})
VisualTab:CreateToggle({Name="移除粒子", CurrentValue=false, Callback=function(v)
    CFG.NoParticles=v
    for _,obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then obj.Enabled=not v end
    end
end})

VisualTab:CreateSection("視角設定")
VisualTab:CreateToggle({Name="自訂 FOV", CurrentValue=false, Callback=function(v) CFG.CustomFOV=v end})
VisualTab:CreateSlider({Name="FOV 值", Range={30,120}, Increment=5, CurrentValue=90, Callback=function(v) CFG.FOVValue=v end})
VisualTab:CreateToggle({Name="自由視角", CurrentValue=false, Callback=function(v) CFG.Freecam=v end})

-- ══════════════════════════ 傳送分頁 ══════════════════════════
local TPTab = Window:CreateTab("🌀 傳送", 4483362458)

TPTab:CreateSection("玩家傳送")
local playerList = {}
for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(playerList,p.Name) end end
local selectedPlayer = nil

TPTab:CreateDropdown({Name="選擇玩家", Options=playerList, Callback=function(v) selectedPlayer=v[1] end})
TPTab:CreateButton({Name="傳送到玩家", Callback=function()
    local p = Players:FindFirstChild(selectedPlayer)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,3)
        Rayfield:Notify({Title="傳送成功", Content="已傳送到 "..selectedPlayer, Duration=3})
    end
end})
TPTab:CreateButton({Name="傳送到隨機玩家", Callback=function()
    local ps = Players:GetPlayers()
    local t = ps[math.random(1,#ps)]
    while t==LocalPlayer do t=ps[math.random(1,#ps)] end
    if t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,3)
    end
end})

TPTab:CreateSection("位置系統")
TPTab:CreateButton({Name="儲存當前位置", Callback=function()
    table.insert(CFG.SavedPos, RootPart.CFrame)
    Rayfield:Notify({Title="已儲存", Content="位置 #"..#CFG.SavedPos, Duration=2})
end})
TPTab:CreateButton({Name="傳送到上個位置", Callback=function()
    if #CFG.SavedPos>0 then RootPart.CFrame=CFG.SavedPos[#CFG.SavedPos] end
end})
TPTab:CreateButton({Name="清除所有位置", Callback=function() CFG.SavedPos={} end})

TPTab:CreateSection("快速傳送")
TPTab:CreateButton({Name="傳送到地圖中心", Callback=function() RootPart.CFrame=CFrame.new(0,100,0) end})
TPTab:CreateButton({Name="傳送到天空", Callback=function() RootPart.CFrame=CFrame.new(RootPart.Position.X,5000,RootPart.Position.Z) end})

-- ══════════════════════════ 破壞分頁 ══════════════════════════
local ExploitTab = Window:CreateTab("💥 破壞", 4483362458)

ExploitTab:CreateSection("群體攻擊")
ExploitTab:CreateButton({Name="Fling All (甩飛所有人)", Callback=function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                spawn(function()
                    for i=1,50 do
                        pcall(function()
                            hrp.CFrame = RootPart.CFrame * CFrame.new(0,50,0)
                            hrp.Velocity = Vector3.new(math.random(-2000,2000),1000,math.random(-2000,2000))
                        end)
                        task.wait()
                    end
                end)
            end
        end
    end
end})
ExploitTab:CreateButton({Name="Void All (丟入虛空)", Callback=function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            pcall(function() p.Character.HumanoidRootPart.CFrame=CFrame.new(0,-500,0) end)
        end
    end
end})
ExploitTab:CreateButton({Name="Freeze All (凍結)", Callback=function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            pcall(function() p.Character.HumanoidRootPart.Anchored=true end)
        end
    end
end})
ExploitTab:CreateButton({Name="Spin All (旋轉)", Callback=function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bav = Instance.new("BodyAngularVelocity")
                bav.AngularVelocity = Vector3.new(0,100,0)
                bav.MaxTorque = Vector3.new(1e9,1e9,1e9)
                bav.Parent = hrp
                Debris:AddItem(bav,5)
            end
        end
    end
end})

ExploitTab:CreateSection("自身功能")
ExploitTab:CreateButton({Name="重生", Callback=function() Humanoid.Health=0 end})
ExploitTab:CreateButton({Name="重設屬性", Callback=function()
    if Humanoid then Humanoid.WalkSpeed=16; Humanoid.JumpPower=50 end
end})

-- ══════════════════════════ 世界分頁 ══════════════════════════
local WorldTab = Window:CreateTab("🌍 世界", 4483362458)

WorldTab:CreateSection("物理設定")
WorldTab:CreateSlider({Name="重力", Range={0,500}, Increment=20, CurrentValue=196, Callback=function(v) Workspace.Gravity=v end})

WorldTab:CreateSection("環境效果")
WorldTab:CreateButton({Name="移除所有效果", Callback=function()
    for _,v in pairs(Lighting:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
    end
end})
WorldTab:CreateButton({Name="夜視模式", Callback=function()
    Lighting.Brightness=5; Lighting.Ambient=Color3.new(1,1,1); Lighting.GlobalShadows=false
end})
WorldTab:CreateButton({Name="血月模式", Callback=function()
    Lighting.ClockTime=0; Lighting.Ambient=Color3.new(0.4,0,0); Lighting.OutdoorAmbient=Color3.new(0.4,0,0)
end})

-- ══════════════════════════ 雜項分頁 ══════════════════════════
local MiscTab = Window:CreateTab("⚙️ 雜項", 4483362458)

MiscTab:CreateSection("防護功能")
MiscTab:CreateToggle({Name="Anti-AFK", CurrentValue=true, Callback=function(v) CFG.AntiAFK=v end})
MiscTab:CreateToggle({Name="自動重生", CurrentValue=false, Callback=function(v) CFG.AutoRespawn=v end})

MiscTab:CreateSection("聊天功能")
MiscTab:CreateToggle({Name="聊天刷屏", CurrentValue=false, Callback=function(v) CFG.ChatSpam=v end})
MiscTab:CreateInput({Name="刷屏訊息", PlaceholderText="輸入訊息...", Callback=function(t) CFG.SpamMsg=t end})
MiscTab:CreateSlider({Name="刷屏間隔", Range={1,10}, Increment=1, CurrentValue=3, Callback=function(v) CFG.SpamDelay=v end})

MiscTab:CreateSection("遊戲資訊")
MiscTab:CreateButton({Name="顯示遊戲資訊", Callback=function()
    Rayfield:Notify({Title="遊戲資訊", Content="ID: "..game.PlaceId.."\n版本: "..game.PlaceVersion.."\n類型: "..CurrentGame.Type, Duration=10})
end})
MiscTab:CreateButton({Name="複製遊戲連結", Callback=function()
    if setclipboard then setclipboard("roblox://placeId="..game.PlaceId) end
    Rayfield:Notify({Title="已複製", Content="遊戲連結已複製", Duration=3})
end})

-- ══════════════════════════ 設定分頁 ══════════════════════════
local SettingsTab = Window:CreateTab("📁 設定", 4483362458)

SettingsTab:CreateSection("UI 設定")
SettingsTab:CreateKeybind({Name="開關 UI", CurrentKeybind="RightShift", HoldToInteract=false, Callback=function() end})
SettingsTab:CreateButton({Name="關閉 GUI", Callback=function() Rayfield:Destroy() end})
SettingsTab:CreateParagraph({Title="NukeBot Ultimate v4.0", Content="Perfect Edition\n遊戲: "..CurrentGame.Name.."\n類型: "..CurrentGame.Type})

-- ═══════════════════════════ 核心邏輯 ═══════════════════════════

-- AlignPosition 飛行
local alignPos, alignOri, flyAttach
local keys = {}
UserInputService.InputBegan:Connect(function(i,g) if not g then keys[i.KeyCode.Name]=true end end)
UserInputService.InputEnded:Connect(function(i) keys[i.KeyCode.Name]=false end)

RunService.RenderStepped:Connect(function()
    if CFG.Fly then
        if not alignPos then
            flyAttach = Instance.new("Attachment", RootPart)
            alignPos = Instance.new("AlignPosition")
            alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            alignPos.MaxForce = 1e6
            alignPos.MaxVelocity = CFG.FlySpeed
            alignPos.Responsiveness = CFG.SmoothFly and 30 or 200
            alignPos.Attachment0 = flyAttach
            alignPos.Parent = RootPart
            alignOri = Instance.new("AlignOrientation")
            alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
            alignOri.MaxTorque = 1e6
            alignOri.Responsiveness = 30
            alignOri.Attachment0 = flyAttach
            alignOri.Parent = RootPart
        end
        local dir = Vector3.new((keys.D and 1 or 0)-(keys.A and 1 or 0),(keys.Space and 1 or 0)-(keys.LeftControl and 1 or 0),(keys.S and 1 or 0)-(keys.W and 1 or 0))
        if dir.Magnitude > 0 then
            local spd = CFG.FlySpeed * (keys.LeftShift and 2.5 or 1)
            alignPos.Position = RootPart.Position + (Camera.CFrame:VectorToWorldSpace(dir.Unit) * spd * 0.1)
            alignPos.MaxVelocity = spd
        else
            alignPos.Position = RootPart.Position
        end
        alignOri.CFrame = Camera.CFrame
    elseif alignPos then
        alignPos:Destroy(); alignOri:Destroy(); flyAttach:Destroy()
        alignPos, alignOri, flyAttach = nil, nil, nil
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Character then
        for _,p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = not (CFG.Noclip or CFG.PhaseDown) end
        end
        if CFG.PhaseDown and keys.LeftShift then
            RootPart.CFrame = RootPart.CFrame * CFrame.new(0,-1,0)
        end
    end
end)

-- 無限跳躍
UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- 蜘蛛爬牆
RunService.Heartbeat:Connect(function()
    if CFG.Spider and Humanoid then
        local ray = Ray.new(RootPart.Position, RootPart.CFrame.LookVector*2.5)
        if Workspace:FindPartOnRay(ray, Character) then
            Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
            RootPart.Velocity = Vector3.new(RootPart.Velocity.X, CFG.ClimbSpeed, RootPart.Velocity.Z)
        end
    end
end)

-- 自動跳躍/連跳
RunService.Heartbeat:Connect(function()
    if Humanoid then
        if CFG.AutoJump then Humanoid.Jump = true end
        if CFG.BHop and Humanoid.FloorMaterial ~= Enum.Material.Air then Humanoid.Jump = true end
    end
end)

-- 點擊傳送
Mouse.Button1Down:Connect(function()
    if CFG.ClickTP and Mouse.Target then
        RootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
    end
end)

-- 空中行走
RunService.Heartbeat:Connect(function()
    if CFG.AirWalk and RootPart then
        local platform = Workspace:FindFirstChild("AirWalkPlatform_"..LocalPlayer.UserId)
        if not platform then
            platform = Instance.new("Part")
            platform.Name = "AirWalkPlatform_"..LocalPlayer.UserId
            platform.Size = Vector3.new(5,0.5,5)
            platform.Transparency = 1
            platform.Anchored = true
            platform.CanCollide = true
            platform.Parent = Workspace
        end
        platform.CFrame = RootPart.CFrame * CFrame.new(0,-3.5,0)
    else
        local p = Workspace:FindFirstChild("AirWalkPlatform_"..LocalPlayer.UserId)
        if p then p:Destroy() end
    end
end)

-- Semi-God
RunService.Heartbeat:Connect(function()
    if CFG.SemiGod and Humanoid and Humanoid.Health < Humanoid.MaxHealth then
        Humanoid.Health = Humanoid.MaxHealth
    end
end)

-- Anti-KB
RunService.Stepped:Connect(function()
    if CFG.AntiKB and RootPart then
        RootPart.Velocity = Vector3.new(0, RootPart.Velocity.Y, 0)
    end
end)

-- Anti-Ragdoll
if Humanoid then
    Humanoid.StateChanged:Connect(function(_,new)
        if CFG.AntiRagdoll and new == Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

-- Kill Aura
spawn(function()
    while true do
        task.wait(0.05)
        if not CFG.KillAura then continue end
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChild("Humanoid")
                if hrp and hum and (hrp.Position-RootPart.Position).Magnitude <= CFG.KillRange then
                    pcall(function() hum.Health = 0 end)
                end
            end
        end
    end
end)

-- Hitbox 擴展
spawn(function()
    while true do
        task.wait(0.2)
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if CFG.Hitbox then
                        hrp.Size = Vector3.one * CFG.HitboxSize
                        hrp.Transparency = 0.6
                    else
                        hrp.Size = Vector3.new(2,2,1)
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end
end)

-- FOV
RunService.RenderStepped:Connect(function()
    if CFG.CustomFOV then Camera.FieldOfView = CFG.FOVValue end
end)

-- Drawing API ESP
local ESPCache = {}

local function MakeESP(plr)
    if ESPCache[plr] then return end
    ESPCache[plr] = {
        Box = Drawing.new("Square"), Name = Drawing.new("Text"), Dist = Drawing.new("Text"),
        HPBG = Drawing.new("Line"), HP = Drawing.new("Line"), Tracer = Drawing.new("Line"), Skel = {}
    }
    local e = ESPCache[plr]
    e.Box.Thickness=1; e.Box.Filled=false
    e.Name.Center=true; e.Name.Size=13; e.Name.Outline=true
    e.Dist.Center=true; e.Dist.Size=12; e.Dist.Outline=true
    e.HPBG.Thickness=4; e.HP.Thickness=2; e.Tracer.Thickness=1
    for i=1,14 do e.Skel[i]=Drawing.new("Line"); e.Skel[i].Thickness=1 end
end

local bones = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}

RunService.RenderStepped:Connect(function()
    for plr, e in pairs(ESPCache) do
        local c = plr.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local head = c and c:FindFirstChild("Head")
        local hum = c and c:FindFirstChild("Humanoid")
        local show = CFG.ESP and hrp and head and hum and hum.Health>0
        
        if show then
            local dist = (hrp.Position - RootPart.Position).Magnitude
            if dist > CFG.ESP_MaxDist then show = false end
            if CFG.ESP_TeamCheck and plr.Team == LocalPlayer.Team then show = false end
        end
        
        if show then
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            if vis then
                local sz = Vector2.new(2200/pos.Z, 2800/pos.Z)
                e.Box.Visible=CFG.ESP_Box; e.Box.Size=sz; e.Box.Position=Vector2.new(pos.X-sz.X/2,pos.Y-sz.Y/2); e.Box.Color=CFG.ESP_Color
                e.Name.Visible=CFG.ESP_Name; e.Name.Position=Vector2.new(pos.X,pos.Y-sz.Y/2-16); e.Name.Text=plr.Name; e.Name.Color=CFG.ESP_Color
                e.Dist.Visible=CFG.ESP_Dist; e.Dist.Position=Vector2.new(pos.X,pos.Y+sz.Y/2+2); e.Dist.Text=math.floor(dist).." studs"; e.Dist.Color=Color3.new(1,1,1)
                local hp = math.clamp(hum.Health/hum.MaxHealth,0,1)
                e.HPBG.Visible=CFG.ESP_HP; e.HPBG.From=Vector2.new(pos.X-sz.X/2-6,pos.Y-sz.Y/2); e.HPBG.To=Vector2.new(pos.X-sz.X/2-6,pos.Y+sz.Y/2); e.HPBG.Color=Color3.new(0.2,0.2,0.2)
                e.HP.Visible=CFG.ESP_HP; e.HP.From=Vector2.new(pos.X-sz.X/2-6,pos.Y+sz.Y/2-sz.Y*hp); e.HP.To=Vector2.new(pos.X-sz.X/2-6,pos.Y+sz.Y/2); e.HP.Color=Color3.fromRGB(255*(1-hp),255*hp,0)
                e.Tracer.Visible=CFG.ESP_Tracer; e.Tracer.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); e.Tracer.To=Vector2.new(pos.X,pos.Y); e.Tracer.Color=CFG.ESP_Color
                if CFG.ESP_Skel then
                    for i,b in ipairs(bones) do
                        local p1,p2 = c:FindFirstChild(b[1]), c:FindFirstChild(b[2])
                        if p1 and p2 and e.Skel[i] then
                            local v1,s1=Camera:WorldToViewportPoint(p1.Position)
                            local v2,s2=Camera:WorldToViewportPoint(p2.Position)
                            e.Skel[i].Visible=s1 and s2; e.Skel[i].From=Vector2.new(v1.X,v1.Y); e.Skel[i].To=Vector2.new(v2.X,v2.Y); e.Skel[i].Color=CFG.ESP_SkelColor
                        end
                    end
                else for _,l in pairs(e.Skel) do l.Visible=false end end
            else
                e.Box.Visible=false; e.Name.Visible=false; e.Dist.Visible=false; e.HP.Visible=false; e.HPBG.Visible=false; e.Tracer.Visible=false
                for _,l in pairs(e.Skel) do l.Visible=false end
            end
        else
            e.Box.Visible=false; e.Name.Visible=false; e.Dist.Visible=false; e.HP.Visible=false; e.HPBG.Visible=false; e.Tracer.Visible=false
            for _,l in pairs(e.Skel) do l.Visible=false end
        end
    end
end)

for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then MakeESP(p) end end
Players.PlayerAdded:Connect(function(p) MakeESP(p) end)
Players.PlayerRemoving:Connect(function(p)
    if ESPCache[p] then
        for k,v in pairs(ESPCache[p]) do
            if type(v)=="table" then for _,l in pairs(v) do pcall(function() l:Remove() end) end
            else pcall(function() v:Remove() end) end
        end
        ESPCache[p]=nil
    end
end)

-- Chams
spawn(function()
    while true do
        task.wait(0.3)
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("_Chams")
                if CFG.Chams then
                    if not hl then hl=Instance.new("Highlight"); hl.Name="_Chams"; hl.FillTransparency=0.5; hl.Parent=p.Character end
                    hl.FillColor=CFG.ChamsColor; hl.OutlineColor=CFG.ChamsColor
                elseif hl then hl:Destroy() end
            end
        end
    end
end)

-- X-Ray
spawn(function()
    while true do
        task.wait(1)
        if CFG.XRay then
            for _,v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(Character) then
                    v.LocalTransparencyModifier = 0.7
                end
            end
        end
    end
end)

-- Silent Aim (hookmetamethod)
if hookmetamethod then
    local oldNc
    oldNc = hookmetamethod(game, "__namecall", function(self, ...)
        local m = getnamecallmethod()
        if CFG.SilentAim and (m=="FindPartOnRay" or m=="FindPartOnRayWithIgnoreList" or m=="Raycast") then
            local best, bestD = nil, math.huge
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    local part = p.Character:FindFirstChild(CFG.AimPart)
                    if part then
                        local sp, vis = Camera:WorldToViewportPoint(part.Position)
                        if vis then
                            local fovDist = (Vector2.new(sp.X,sp.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                            if fovDist < CFG.AimFOV and fovDist < bestD then best, bestD = part, fovDist end
                        end
                    end
                end
            end
            if best then
                local args = {...}
                args[1] = Ray.new(Camera.CFrame.Position, (best.Position-Camera.CFrame.Position).Unit*5000)
                return oldNc(self, unpack(args))
            end
        end
        return oldNc(self, ...)
    end)
end

-- Anti-AFK
spawn(function()
    while true do
        task.wait(120)
        if CFG.AntiAFK then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end
    end
end)

-- 聊天刷屏
spawn(function()
    while true do
        task.wait(CFG.SpamDelay)
        if CFG.ChatSpam then
            pcall(function() ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(CFG.SpamMsg,"All") end)
        end
    end
end)

-- 自動重生
if Humanoid then
    Humanoid.Died:Connect(function()
        if CFG.AutoRespawn then task.wait(1); pcall(function() LocalPlayer:LoadCharacter() end) end
    end)
end

-- 角色重生
LocalPlayer.CharacterAdded:Connect(function(c)
    RefreshCharacter()
    if CFG.God then Humanoid.MaxHealth=math.huge; Humanoid.Health=math.huge end
    if CFG.SpeedHack then Humanoid.WalkSpeed=16*CFG.SpeedMult*CurrentGame.Speed end
    if CFG.HighJump then Humanoid.JumpPower=150 end
    Humanoid.StateChanged:Connect(function(_,n)
        if CFG.AntiRagdoll and n==Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end)

-- 載入完成
Rayfield:Notify({Title="🔥 NukeBot Ultimate v4.0", Content="完美版已載入！\n遊戲: "..CurrentGame.Name.."\n按 RightShift 開關 UI", Duration=6})
print("✅ NukeBot Ultimate v4.0 Perfect Edition 已載入")
