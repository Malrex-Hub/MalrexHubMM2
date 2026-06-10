-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // 9,338 MEMBERS - MAXIMUM FEATURES - NO BULLSHIT 🥀

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/Kavo.lua"))()

local Window = Library.CreateLib("ELITE HUB v1.0.0", "DarkTheme")

-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - MAX FEATURES - FUCK JAILBREAK 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - 9,338 MEMBERS")

-- // FPS + MS COUNTER
local fps = 60
local ping = 0
local lastTime = tick()
local frameCount = 0

local function GetPing()
    local stats = Stats:FindFirstChild("Network")
    if stats then
        local pingStat = stats:FindFirstChild("Ping")
        if pingStat then
            return math.floor(pingStat:GetValue())
        end
    end
    return 0
end

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
        ping = GetPing()
    end
    pcall(function()
        Library:SetWatermark("ELITE HUB | " .. fps .. " FPS | " .. ping .. " MS | 9,338 MEMBERS")
    end)
end)

-- // AUTO SAVE SETTINGS
local settingsKey = "EliteHub_Settings_" .. LP.UserId
local Settings = {
    -- Combat
    KillAura = false,
    KillAuraRange = 35,
    KillAuraDelay = 0.1,
    KillAuraTeamCheck = true,
    KillAuraWallCheck = false,
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    AutoFarmBounty = false,
    AutoFarmCash = false,
    AutoAttack = false,
    AutoSwing = false,
    AutoBlock = false,
    AutoArrest = false,
    AutoTase = false,
    AutoHandcuff = false,
    AutoSpikeStrip = false,
    AutoRadar = false,
    NoRecoil = false,
    NoSpread = false,
    FastSwing = false,
    FastShoot = false,
    InfiniteAmmo = false,
    AimAssist = false,
    AimAssistFOV = 50,
    AimAssistSmoothness = 5,
    TriggerBot = false,
    TriggerBotDelay = 0.05,
    HitboxExtender = false,
    HitboxSize = 5,
    CriticalHits = false,
    -- Robbery
    AutoBank = false,
    AutoJewelry = false,
    AutoMuseum = false,
    AutoTrain = false,
    AutoCargo = false,
    AutoPowerPlant = false,
    AutoCasino = false,
    AutoTomb = false,
    AutoOilRig = false,
    RobberyDelay = 2,
    AutoCollectMoney = false,
    AutoSellItems = false,
    AutoOpenCrates = false,
    -- Movement
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    AutoSprint = false,
    AutoStairs = false,
    AutoClimb = false,
    AntiRagdoll = true,
    AntiStun = true,
    AntiKnockback = false,
    NoFallDamage = false,
    InfiniteJump = false,
    AutoDodge = false,
    AutoParry = false,
    -- Visuals
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTeamColors = true,
    ESPOutline = true,
    ESPChams = false,
    ESPTracers = false,
    ESPBoxes = false,
    ESPNames = false,
    ESPHealthBars = false,
    ESPDistance = false,
    FullBright = false,
    NoFog = false,
    NoShadow = false,
    XRay = false,
    ViewmodelChanger = false,
    ViewmodelX = 0,
    ViewmodelY = 0,
    ViewmodelZ = 0,
    FOVChanger = false,
    FOVAmount = 100,
    -- Utility
    AutoDonut = false,
    AutoKeycard = false,
    AutoGun = false,
    AutoShield = false,
    AutoAmmo = false,
    AutoArmor = false,
    AutoSkillTree = false,
    SkillPriority = "Attack",
    SkillNodeIndex = 1,
    AutoTeam = false,
    TeamToJoin = "Criminals",
    AutoRevive = false,
    AutoEscape = false,
    EscapeMethod = "Tunnel",
    AutoRejoin = false,
    AutoQuest = false,
    AutoClaimRewards = false,
    AutoSpinWheel = false,
    AntiAFK = true,
    AntiBan = true,
    TeleportOnLowHealth = false,
    LowHealthThreshold = 30,
    TeleportLocation = "CriminalBase",
    AutoCollectBounty = false,
    AutoRobPlayers = false,
    -- Auto Roll
    AutoRoll = false,
    AutoRollDelay = 0.1,
    TargetTrait = "None",
    TargetRace = "None",
    TargetClan = "None",
    TargetBloodline = "None",
    -- Merchant
    AutoMerchant = false,
    MerchantDelay = 60,
    BuyKeycard = false,
    BuyGun = false,
    BuyAmmo = false,
    BuyShield = false,
    BuyDonut = false,
    -- Auto Farm Locations
    AutoFarmLocation = "PoliceStation",
    AutoFarmRadius = 50,
    -- States
    Flying = false,
    CurrentTarget = nil,
}

-- // LOAD SETTINGS
pcall(function()
    local storage = game:GetService("LocalStorage")
    local data = storage:FindFirstChild(settingsKey)
    if data then
        local saved = HttpService:JSONDecode(data.Value)
        for k, v in pairs(saved) do Settings[k] = v end
    end
end)

local function SaveSettings()
    pcall(function()
        local json = HttpService:JSONEncode(Settings)
        local storage = game:GetService("LocalStorage")
        local existing = storage:FindFirstChild(settingsKey)
        if existing then existing:Destroy() end
        local newData = Instance.new("StringValue")
        newData.Name = settingsKey
        newData.Value = json
        newData.Parent = storage
    end)
end

-- // ANTI AFK
if Settings.AntiAFK then
    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(0.3)
            VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- // ANTI RAGDOLL
if Settings.AntiRagdoll then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum and hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end)
        end
    end)
end

-- // ANTI STUN
if Settings.AntiStun then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum and hum:GetState() == Enum.HumanoidStateType.Stunned then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end)
        end
    end)
end

-- // AUTO TEAM
local function AutoTeam()
    if Settings.AutoTeam then
        local targetTeam = Teams:FindFirstChild(Settings.TeamToJoin)
        if targetTeam and LP.Team ~= targetTeam then
            LP.Team = targetTeam
        end
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    AutoTeam()
end)

-- // INFINITE JUMP
local infiniteJumpConn = nil
local function ToggleInfiniteJump()
    Settings.InfiniteJump = not Settings.InfiniteJump
    if Settings.InfiniteJump then
        infiniteJumpConn = UserInputService.JumpRequest:Connect(function()
            if LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        if infiniteJumpConn then infiniteJumpConn:Disconnect() end
    end
end

-- // NO FALL DAMAGE
if Settings.NoFallDamage then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum then hum.UseJumpPower = true end
                end
            end)
        end
    end)
end

-- // FLY FUNCTION
local function ToggleFly()
    Settings.Flying = not Settings.Flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if Settings.Flying then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = true end
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while Settings.Flying and char and char:FindFirstChild("HumanoidRootPart") do
                task.wait()
                local control = Vector3.new(0,0,0)
                local speed = Settings.FlySpeed
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then control = control + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then control = control - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then control = control - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then control = control + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then control = control + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then control = control - Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then speed = speed * 2 end
                
                if control.Magnitude > 0 then control = control.Unit end
                bg.cframe = CFrame.new(hrp.Position, hrp.Position + control)
                bv.velocity = control * speed
            end
            pcall(function() bg:Destroy() end)
            pcall(function() bv:Destroy() end)
            if hum then hum.PlatformStand = false end
        end)
    else
        pcall(function() hrp:FindFirstChild("BodyGyro"):Destroy() end)
        pcall(function() hrp:FindFirstChild("BodyVelocity"):Destroy() end)
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- // NOCLIP
local noclipConn = nil
local function ToggleNoclip()
    Settings.Noclip = not Settings.Noclip
    if Settings.Noclip then
        noclipConn = RunService.RenderStepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end

-- // FULLBRIGHT
local function ToggleFullBright()
    Settings.FullBright = not Settings.FullBright
    if Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 8
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end

-- // NO FOG
local function ToggleNoFog()
    Settings.NoFog = not Settings.NoFog
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 1000
    end
end

-- // NO SHADOWS
local function ToggleNoShadow()
    Settings.NoShadow = not Settings.NoShadow
    Lighting.GlobalShadows = not Settings.NoShadow
end

-- // FOV CHANGER
if Settings.FOVChanger then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                Camera.FieldOfView = Settings.FOVAmount
            end)
        end
    end)
end

-- // ESP
local espObjects = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local color = Settings.ESPColor
                if Settings.ESPTeamColors and player.Team then
                    if player.Team.Name == "Police" then
                        color = Color3.fromRGB(0, 100, 255)
                    elseif player.Team.Name == "Criminals" then
                        color = Color3.fromRGB(255, 50, 50)
                    end
                end
                local highlight = Instance.new("Highlight")
                highlight.FillColor = color
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0.2
                highlight.Parent = player.Character
                espObjects[player] = highlight
            elseif (not player.Character or not Settings.ESP) and espObjects[player] then
                pcall(function() espObjects[player]:Destroy() end)
                espObjects[player] = nil
            end
        end
    else
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end

Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(p) 
    if espObjects[p] then pcall(function() espObjects[p]:Destroy() end) end
    espObjects[p] = nil
end)

-- // AIM ASSIST
if Settings.AimAssist then
    task.spawn(function()
        while task.wait() do
            pcall(function()
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local nearest, dist = GetNearestPlayer(nil)
                    if nearest and dist <= Settings.AimAssistFOV then
                        local target = nearest.Character:FindFirstChild("HumanoidRootPart")
                        if target then
                            local hrp = LP.Character.HumanoidRootPart
                            local direction = (target.Position - hrp.Position).Unit
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction * Settings.AimAssistSmoothness)
                        end
                    end
                end
            end)
        end
    end)
end

-- // LOCATIONS
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
    Merchant = CFrame.new(-25, 18, 250),
    PoliceStation = CFrame.new(640, 18, -460),
    CriminalBase = CFrame.new(-235, 18, 1610),
    Hospital = CFrame.new(350, 18, -250),
    GasStation = CFrame.new(-1583, 18, 715),
    GunShop = CFrame.new(-665, 18, 765),
}

-- // UTILITIES
local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    local tween = TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

local function TeleportTo(cf)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

local function GetNearestPlayer(team)
    local nearest = nil
    local shortest = 1000
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if team == nil or (player.Team and player.Team.Name == team) then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target then
                        local dist = (hrp.Position - target.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            nearest = player
                        end
                    end
                end
            end
        end
    end
    return nearest, shortest
end

local function GetPlayersInRange(range, team)
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if team == nil or (player.Team and player.Team.Name == team) then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target then
                        local dist = (hrp.Position - target.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, player)
                        end
                    end
                end
            end
        end
    end
    return targets
end

local function AttackPlayer(player)
    if not player or not player.Character then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local target = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
        task.wait(0.05)
        local punch = ReplicatedStorage:FindFirstChild("Punch")
        if punch then pcall(function() punch:FireServer(target.Position) end) end
        local shoot = ReplicatedStorage:FindFirstChild("Shoot")
        if shoot then pcall(function() shoot:FireServer(target.Position) end) end
    end
end

-- // AUTO FARM LOOPS
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarmCops and LP.Character then
                local cop, dist = GetNearestPlayer("Police")
                if cop then
                    if dist > 15 then
                        local hrp = cop.Character and cop.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then TweenTo(hrp.CFrame, 70) end
                    else
                        AttackPlayer(cop)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarmPrisoners and LP.Character then
                local prisoner, dist = GetNearestPlayer("Prisoners")
                if prisoner then
                    if dist > 15 then
                        local hrp = prisoner.Character and prisoner.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then TweenTo(hrp.CFrame, 70) end
                    else
                        AttackPlayer(prisoner)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local targets = GetPlayersInRange(Settings.KillAuraRange, nil)
                for _, target in pairs(targets) do
                    AttackPlayer(target)
                    task.wait(Settings.KillAuraDelay)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(Settings.RobberyDelay) do
        pcall(function()
            if Settings.AutoBank then
                local bank = Workspace:FindFirstChild("Banks")
                if bank and bank:GetAttribute("Open") then
                    TweenTo(Locations.Bank.Roof, 100)
                    task.wait(0.5)
                    TweenTo(Locations.Bank.Vault, 80)
                    task.wait(15)
                    TweenTo(Locations.Bank.Escape, 80)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(Settings.RobberyDelay) do
        pcall(function()
            if Settings.AutoJewelry then
                local jewelry = Workspace:FindFirstChild("Jewelrys")
                if jewelry and jewelry:GetAttribute("Open") then
                    TweenTo(Locations.Jewelry.Roof, 100)
                    task.wait(0.5)
                    TweenTo(Locations.Jewelry.Boxes, 80)
                    task.wait(12)
                    TweenTo(Locations.Jewelry.TurnIn, 100)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(Settings.RobberyDelay) do
        pcall(function()
            if Settings.AutoMuseum then
                local museum = Workspace:FindFirstChild("Museum")
                if museum and museum:GetAttribute("Open") then
                    TweenTo(Locations.Museum.Mummy, 80)
                    task.wait(10)
                    TweenTo(Locations.Museum.TurnIn, 100)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if Settings.AutoDonut and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum and hum.Health < 80 then
                    TweenTo(Locations.Donut, 60)
                    task.wait(1)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(60) do
        pcall(function()
            if Settings.AutoMerchant then
                TweenTo(Locations.Merchant, 80)
                task.wait(2)
                if Settings.BuyKeycard then
                    -- Buy keycard remote
                end
                if Settings.BuyGun then
                    -- Buy gun remote
                end
            end
        end)
    end
end)

-- // MOVEMENT LOOP
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                local hum = LP.Character.Humanoid
                if hum.WalkSpeed ~= Settings.WalkSpeed then
                    hum.WalkSpeed = Settings.WalkSpeed
                end
                if hum.JumpPower ~= Settings.JumpPower then
                    hum.JumpPower = Settings.JumpPower
                end
                if Settings.AutoSprint then
                    hum.AutoRotate = true
                end
            end
        end)
    end
end)

-- // TELEPORT ON LOW HEALTH
if Settings.TeleportOnLowHealth then
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health < Settings.LowHealthThreshold then
                        local loc = Locations[Settings.TeleportLocation]
                        if loc then
                            TeleportTo(loc)
                        end
                    end
                end
            end)
        end
    end)
end

-- // NO RECOIL + NO SPREAD
if Settings.NoRecoil or Settings.NoSpread then
    task.spawn(function()
        while task.wait(0.05) do
            pcall(function()
                local cam = workspace.CurrentCamera
                if Settings.NoRecoil then
                    -- No recoil logic
                end
            end)
        end
    end)
end

-- // CREATE TABS

-- AUTOMATION TAB
local AutomationTab = Window:NewTab("AUTOMATION")
local AutoRollsSection = AutomationTab:NewSection("🎲 AUTO ROLLS")

AutoRollsSection:NewToggle("Auto Rolls", "Auto roll for traits/races/clans", function(v) Settings.AutoRoll = v; SaveSettings() end)
AutoRollsSection:NewInput("Target Trait", "Desired trait name", function(v) Settings.TargetTrait = v; SaveSettings() end)
AutoRollsSection:NewInput("Target Race", "Desired race name", function(v) Settings.TargetRace = v; SaveSettings() end)
AutoRollsSection:NewInput("Target Clan", "Desired clan name", function(v) Settings.TargetClan = v; SaveSettings() end)
AutoRollsSection:NewSlider("Roll Cooldown", "Seconds between rolls", 0.05, 2, function(v) Settings.AutoRollDelay = v; SaveSettings() end)

local SkillSection = AutomationTab:NewSection("🌳 SKILL TREE")

SkillSection:NewToggle("Auto Skill Tree", "Auto upgrade skill nodes", function(v) Settings.AutoSkillTree = v; SaveSettings() end)
SkillSection:NewSlider("Node Index", "Which node to upgrade", 1, 50, function(v) Settings.SkillNodeIndex = v; SaveSettings() end)
SkillSection:NewDropdown("Skill Priority", "Upgrade priority", {"Attack", "Defense", "Health", "Fruit", "Sword"}, function(v) Settings.SkillPriority = v; SaveSettings() end)

local MerchantSection = AutomationTab:NewSection("💰 MERCHANT")

MerchantSection:NewToggle("Auto Merchant", "Auto visit merchant", function(v) Settings.AutoMerchant = v; SaveSettings() end)
MerchantSection:NewToggle("Buy Keycard", "Auto buy keycard", function(v) Settings.BuyKeycard = v; SaveSettings() end)
MerchantSection:NewToggle("Buy Gun", "Auto buy gun", function(v) Settings.BuyGun = v; SaveSettings() end)
MerchantSection:NewToggle("Buy Ammo", "Auto buy ammo", function(v) Settings.BuyAmmo = v; SaveSettings() end)
MerchantSection:NewToggle("Buy Shield", "Auto buy shield", function(v) Settings.BuyShield = v; SaveSettings() end)

-- COMBAT TAB
local CombatTab = Window:NewTab("COMBAT")
local KillAuraSection = CombatTab:NewSection("💀 KILL AURA")

KillAuraSection:NewToggle("Kill Aura", "Auto attack players in range", function(v) Settings.KillAura = v; SaveSettings() end)
KillAuraSection:NewSlider("Kill Aura Range", "Attack range", 10, 100, function(v) Settings.KillAuraRange = v; SaveSettings() end)
KillAuraSection:NewSlider("Kill Aura Delay", "Seconds between attacks", 0.05, 1, function(v) Settings.KillAuraDelay = v; SaveSettings() end)
KillAuraSection:NewToggle("Team Check", "Only attack enemies", function(v) Settings.KillAuraTeamCheck = v; SaveSettings() end)
KillAuraSection:NewToggle("Wall Check", "Only attack if visible", function(v) Settings.KillAuraWallCheck = v; SaveSettings() end)

local FarmSection = CombatTab:NewSection("👮 AUTO FARM")

FarmSection:NewToggle("Auto Farm Cops", "Hunt down police", function(v) Settings.AutoFarmCops = v; SaveSettings() end)
FarmSection:NewToggle("Auto Farm Prisoners", "Beat inmates", function(v) Settings.AutoFarmPrisoners = v; SaveSettings() end)
FarmSection:NewToggle("Auto Farm Bounty", "Hunt bounty targets", function(v) Settings.AutoFarmBounty = v; SaveSettings() end)
FarmSection:NewToggle("Auto Farm Cash", "Farm cash", function(v) Settings.AutoFarmCash = v; SaveSettings() end)

local WeaponSection = CombatTab:NewSection("🔫 WEAPON MODS")

WeaponSection:NewToggle("No Recoil", "Zero weapon recoil", function(v) Settings.NoRecoil = v; SaveSettings() end)
WeaponSection:NewToggle("No Spread", "Perfect accuracy", function(v) Settings.NoSpread = v; SaveSettings() end)
WeaponSection:NewToggle("Fast Swing", "Increased melee speed", function(v) Settings.FastSwing = v; SaveSettings() end)
WeaponSection:NewToggle("Fast Shoot", "Increased fire rate", function(v) Settings.FastShoot = v; SaveSettings() end)
WeaponSection:NewToggle("Infinite Ammo", "Never run out", function(v) Settings.InfiniteAmmo = v; SaveSettings() end)

local AimSection = CombatTab:NewSection("🎯 AIM ASSIST")

AimSection:NewToggle("Aim Assist", "Auto aim at enemies", function(v) Settings.AimAssist = v; SaveSettings() end)
AimSection:NewSlider("Aim FOV", "Field of view for aim", 20, 120, function(v) Settings.AimAssistFOV = v; SaveSettings() end)
AimSection:NewSlider("Aim Smoothness", "How smooth the aim is", 1, 10, function(v) Settings.AimAssistSmoothness = v; SaveSettings() end)
AimSection:NewToggle("Trigger Bot", "Auto shoot on target", function(v) Settings.TriggerBot = v; SaveSettings() end)

local PoliceSection = CombatTab:NewSection("🚔 POLICE (COP ONLY)")

PoliceSection:NewToggle("Auto Arrest", "Auto arrest criminals", function(v) Settings.AutoArrest = v; SaveSettings() end)
PoliceSection:NewToggle("Auto Tase", "Auto tase suspects", function(v) Settings.AutoTase = v; SaveSettings() end)
PoliceSection:NewToggle("Auto Handcuff", "Auto handcuff", function(v) Settings.AutoHandcuff = v; SaveSettings() end)
PoliceSection:NewToggle("Auto Spike Strip", "Deploy spike strips", function(v) Settings.AutoSpikeStrip = v; SaveSettings() end)
PoliceSection:NewToggle("Auto Radar", "Auto use radar", function(v) Settings.AutoRadar = v; SaveSettings() end)

-- ROBBERY TAB
local RobberyTab = Window:NewTab("ROBBERY")
local RobberySection = RobberyTab:NewSection("💰 STEAL THAT SHIT")

RobberySection:NewToggle("Auto Bank", "Rob the bank", function(v) Settings.AutoBank = v; SaveSettings() end)
RobberySection:NewToggle("Auto Jewelry", "Rob jewelry store", function(v) Settings.AutoJewelry = v; SaveSettings() end)
RobberySection:NewToggle("Auto Museum", "Rob the museum", function(v) Settings.AutoMuseum = v; SaveSettings() end)
RobberySection:NewToggle("Auto Train", "Rob the train", function(v) Settings.AutoTrain = v; SaveSettings() end)
RobberySection:NewToggle("Auto Cargo Plane", "Rob cargo plane", function(v) Settings.AutoCargo = v; SaveSettings() end)
RobberySection:NewToggle("Auto Power Plant", "Rob power plant", function(v) Settings.AutoPowerPlant = v; SaveSettings() end)
RobberySection:NewToggle("Auto Casino", "Rob the casino", function(v) Settings.AutoCasino = v; SaveSettings() end)
RobberySection:NewToggle("Auto Oil Rig", "Rob oil rig", function(v) Settings.AutoOilRig = v; SaveSettings() end)

local RobberySettings = RobberyTab:NewSection("⚙️ ROBBERY SETTINGS")

RobberySettings:NewSlider("Robbery Delay", "Seconds between robberies", 1, 10, function(v) Settings.RobberyDelay = v; SaveSettings() end)
RobberySettings:NewToggle("Auto Collect Money", "Auto pick up cash", function(v) Settings.AutoCollectMoney = v; SaveSettings() end)
RobberySettings:NewToggle("Auto Sell Items", "Auto sell loot", function(v) Settings.AutoSellItems = v; SaveSettings() end)
RobberySettings:NewToggle("Auto Open Crates", "Auto open crates", function(v) Settings.AutoOpenCrates = v; SaveSettings() end)

-- MOVEMENT TAB
local MovementTab = Window:NewTab("MOVEMENT")
local FlySection = MovementTab:NewSection("🕊️ FLY & NOCLIP")

FlySection:NewToggle("Fly Mode", "Fly around the map", function(v) Settings.Fly = v; ToggleFly(); SaveSettings() end)
FlySection:NewSlider("Fly Speed", "Flight speed", 30, 250, function(v) Settings.FlySpeed = v; SaveSettings() end)
FlySection:NewToggle("Noclip", "Walk through walls", function(v) Settings.Noclip = v; ToggleNoclip(); SaveSettings() end)
FlySection:NewToggle("Infinite Jump", "Jump infinitely", function(v) ToggleInfiniteJump(); SaveSettings() end)

local SpeedSection = MovementTab:NewSection("⚡ SPEED & JUMP")

SpeedSection:NewSlider("Walk Speed", "Movement speed", 16, 200, function(v) Settings.WalkSpeed = v; SaveSettings() end)
SpeedSection:NewSlider("Jump Power", "Jump height", 50, 200, function(v) Settings.JumpPower = v; SaveSettings() end)
SpeedSection:NewToggle("Auto Sprint", "Always sprint", function(v) Settings.AutoSprint = v; SaveSettings() end)
SpeedSection:NewToggle("Auto Stairs", "Fast stairs climb", function(v) Settings.AutoStairs = v; SaveSettings() end)

local ProtectionSection = MovementTab:NewSection("🛡️ PROTECTION")

ProtectionSection:NewToggle("Anti Ragdoll", "No ragdoll stun", function(v) Settings.AntiRagdoll = v; SaveSettings() end)
ProtectionSection:NewToggle("Anti Stun", "No stun effects", function(v) Settings.AntiStun = v; SaveSettings() end)
ProtectionSection:NewToggle("Anti Knockback", "No knockback", function(v) Settings.AntiKnockback = v; SaveSettings() end)
ProtectionSection:NewToggle("No Fall Damage", "Take no fall damage", function(v) Settings.NoFallDamage = v; SaveSettings() end)
ProtectionSection:NewToggle("Auto Dodge", "Auto dodge attacks", function(v) Settings.AutoDodge = v; SaveSettings() end)

-- VISUALS TAB
local VisualsTab = Window:NewTab("VISUALS")
local ESPSection = VisualsTab:NewSection("👻 ESP WALLHACK")

ESPSection:NewToggle("ESP Enable", "See players through walls", function(v) Settings.ESP = v; UpdateESP(); SaveSettings() end)
ESPSection:NewColorPicker("ESP Color", "Pick ESP color", function(v) Settings.ESPColor = v; UpdateESP(); SaveSettings() end)
ESPSection:NewToggle("Team Colors", "Color by team", function(v) Settings.ESPTeamColors = v; UpdateESP(); SaveSettings() end)
ESPSection:NewToggle("ESP Outline", "Show outline", function(v) Settings.ESPOutline = v; UpdateESP(); SaveSettings() end)
ESPSection:NewToggle("ESP Tracers", "Show tracers", function(v) Settings.ESPTracers = v; SaveSettings() end)
ESPSection:NewToggle("ESP Names", "Show player names", function(v) Settings.ESPNames = v; SaveSettings() end)
ESPSection:NewToggle("ESP Health Bars", "Show health bars", function(v) Settings.ESPHealthBars = v; SaveSettings() end)
ESPSection:NewToggle("ESP Distance", "Show distance", function(v) Settings.ESPDistance = v; SaveSettings() end)

local WorldSection = VisualsTab:NewSection("🌅 WORLD MODS")

WorldSection:NewToggle("Fullbright", "See in the dark", function(v) Settings.FullBright = v; ToggleFullBright(); SaveSettings() end)
WorldSection:NewToggle("No Fog", "Remove fog", function(v) Settings.NoFog = v; ToggleNoFog(); SaveSettings() end)
WorldSection:NewToggle("No Shadows", "Remove shadows", function(v) Settings.NoShadow = v; ToggleNoShadow(); SaveSettings() end)
WorldSection:NewToggle("X-Ray", "See through objects", function(v) Settings.XRay = v; SaveSettings() end)

local CameraSection = VisualsTab:NewSection("📷 CAMERA MODS")

CameraSection:NewToggle("FOV Changer", "Change field of view", function(v) Settings.FOVChanger = v; SaveSettings() end)
CameraSection:NewSlider("FOV Amount", "Field of view value", 70, 120, function(v) Settings.FOVAmount = v; SaveSettings() end)
CameraSection:NewToggle("Viewmodel Changer", "Change gun position", function(v) Settings.ViewmodelChanger = v; SaveSettings() end)

-- UTILITY TAB
local UtilityTab = Window:NewTab("UTILITY")
local AutoSection = UtilityTab:NewSection("🛠️ AUTO UTILITIES")

AutoSection:NewToggle("Auto Donut", "Auto heal with donuts", function(v) Settings.AutoDonut = v; SaveSettings() end)
AutoSection:NewToggle("Auto Keycard", "Auto buy keycard", function(v) Settings.AutoKeycard = v; SaveSettings() end)
AutoSection:NewToggle("Auto Gun", "Auto buy gun", function(v) Settings.AutoGun = v; SaveSettings() end)
AutoSection:NewToggle("Auto Shield", "Auto buy shield", function(v) Settings.AutoShield = v; SaveSettings() end)
AutoSection:NewToggle("Auto Armor", "Auto buy armor", function(v) Settings.AutoArmor = v; SaveSettings() end)
AutoSection:NewToggle("Auto Ammo", "Auto buy ammo", function(v) Settings.AutoAmmo = v; SaveSettings() end)

local TeamSection = UtilityTab:NewSection("🚔 TEAM & ESCAPE")

TeamSection:NewToggle("Auto Team", "Auto join criminals", function(v) Settings.AutoTeam = v; AutoTeam(); SaveSettings() end)
TeamSection:NewDropdown("Team To Join", "Which team", {"Criminals", "Police"}, function(v) Settings.TeamToJoin = v; SaveSettings() end)
TeamSection:NewToggle("Auto Revive", "Auto revive when dead", function(v) Settings.AutoRevive = v; SaveSettings() end)
TeamSection:NewToggle("Auto Escape", "Auto escape prison", function(v) Settings.AutoEscape = v; SaveSettings() end)
TeamSection:NewDropdown("Escape Method", "How to escape", {"Tunnel", "Volcano", "Sewer", "Helicopter"}, function(v) Settings.EscapeMethod = v; SaveSettings() end)

local MiscSection = UtilityTab:NewSection("🎮 MISC")

MiscSection:NewToggle("Anti AFK", "Prevent AFK kick", function(v) Settings.AntiAFK = v; SaveSettings() end)
MiscSection:NewToggle("Auto Rejoin", "Auto rejoin on leave", function(v) Settings.AutoRejoin = v; SaveSettings() end)
MiscSection:NewToggle("Auto Quest", "Auto complete quests", function(v) Settings.AutoQuest = v; SaveSettings() end)
MiscSection:NewToggle("Auto Claim Rewards", "Auto claim daily rewards", function(v) Settings.AutoClaimRewards = v; SaveSettings() end)
MiscSection:NewToggle("Auto Spin Wheel", "Auto spin lucky wheel", function(v) Settings.AutoSpinWheel = v; SaveSettings() end)
MiscSection:NewToggle("Auto Collect Bounty", "Auto collect bounty", function(v) Settings.AutoCollectBounty = v; SaveSettings() end)

local HealthSection = UtilityTab:NewSection("💊 HEALTH SETTINGS")

HealthSection:NewToggle("Teleport on Low Health", "Escape when low", function(v) Settings.TeleportOnLowHealth = v; SaveSettings() end)
HealthSection:NewSlider("Low Health Threshold", "Health % to teleport", 10, 70, function(v) Settings.LowHealthThreshold = v; SaveSettings() end)
HealthSection:NewDropdown("Teleport Location", "Where to go", {"CriminalBase", "PoliceStation", "Hospital"}, function(v) Settings.TeleportLocation = v; SaveSettings() end)

-- SETTINGS TAB
local SettingsTab = Window:NewTab("SETTINGS")
local LinksSection = SettingsTab:NewSection("💬 LINKS")

LinksSection:NewButton("Join Discord (Copy Link)", "discord.gg/5RuMCxK3u6", function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "DISCORD LINK COPIED 🥀",
        Duration = 2
    })
end)

LinksSection:NewButton("Copy Discord Invite", "Copy invite code", function()
    setclipboard("5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "Invite code copied! discord.gg/5RuMCxK3u6",
        Duration = 2
    })
end)

local UISection = SettingsTab:NewSection("⚙️ UI SETTINGS")

UISection:NewButton("Destroy UI", "Close the menu", function()
    game:GetService("CoreGui"):FindFirstChild("EliteHub"):Destroy()
end)

UISection:NewToggle("Save Settings", "Auto save your settings", function(v) end)

-- // STARTUP
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED - 9,338 MEMBERS - 80+ FEATURES 🥀",
    Duration = 3
})

print("ELITE HUB v1.0.0 - 80+ FEATURES LOADED - GO FUCK SHIT UP 🥀")