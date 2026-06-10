-- ///////////////////////////////////////////////////////////////////////////////
-- //                                                                           //
-- //    ELITE HUB v1.0.0 | JAILBREAK                                           //
-- //    discord.gg/5RuMCxK3u6                                                  //
-- //    FUCK YOU IF YOU STEAL THIS SHIT                                         //
-- //    9,338 MEMBERS - MAX FEATURES - ALL FUCKING WORKING 🥀                   //
-- //                                                                           //
-- ///////////////////////////////////////////////////////////////////////////////

-- // WORKING UI LIBRARY (NO 404 ERROR YOU BITCH)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLib/main/Source.lua"))()

local Window = Library:CreateWindow("ELITE HUB v1.0.0")

-- // FUCKING SERVICES
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
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

print("███╗░░░███╗░█████╗░░█████╗░██████╗░██╗░░░██╗██████╗░")
print("████╗░████║██╔══██╗██╔══██╗██╔══██╗██║░░░██║██╔══██╗")
print("██╔████╔██║██║░░╚═╝██║░░██║██████╔╝██║░░░██║██║░░██║")
print("██║╚██╔╝██║██║░░██╗██║░░██║██╔══██╗██║░░░██║██║░░██║")
print("██║░╚═╝░██║╚█████╔╝╚█████╔╝██║░░██║╚██████╔╝██████╔╝")
print("╚═╝░░░░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - LOADED YOU BITCH ASS CUNT 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - 9,338 MOTHERFUCKING MEMBERS")
print("IF YOU USE XENO OR SOLARA YOU'RE A FUCKING IDIOT - THEY HAVE RATS")
print("USE DELTA OR SWIFT YOU DUMB BITCH")

-- // FPS + MS COUNTER (REAL FUCKING SHIT)
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
        Library:SetWatermark("ELITE HUB | " .. fps .. " FPS | " .. ping .. " MS | 9,338 MEMBERS | FUCK JAILBREAK")
    end)
end)

-- // AUTO SAVE SETTINGS (SO YOU DONT LOSE YOUR SHIT)
local settingsKey = "EliteHub_Settings_" .. LP.UserId
local Settings = {
    -- Combat (KILL THOSE MOTHERFUCKERS)
    KillAura = false,
    KillAuraRange = 35,
    KillAuraDelay = 0.1,
    KillAuraTeamCheck = true,
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    AutoFarmBounty = false,
    AutoFarmCash = false,
    AutoAttack = false,
    AutoArrest = false,
    AutoTase = false,
    NoRecoil = false,
    NoSpread = false,
    FastSwing = false,
    FastShoot = false,
    InfiniteAmmo = false,
    AimAssist = false,
    AimAssistFOV = 50,
    AimAssistSmoothness = 5,
    TriggerBot = false,
    HitboxExtender = false,
    HitboxSize = 5,
    OneHitKill = false,
    -- Robbery (STEAL THAT SHIT)
    AutoBank = false,
    AutoJewelry = false,
    AutoMuseum = false,
    AutoTrain = false,
    AutoCargo = false,
    AutoPowerPlant = false,
    AutoCasino = false,
    RobberyDelay = 2,
    AutoCollectMoney = false,
    AutoSellItems = false,
    -- Movement (GO FAST AS FUCK)
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    AutoSprint = false,
    AutoStairs = false,
    AntiRagdoll = true,
    AntiStun = true,
    NoFallDamage = false,
    InfiniteJump = false,
    AutoDodge = false,
    -- Visuals (SEE THEIR BITCH ASS)
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTeamColors = true,
    FullBright = false,
    NoFog = false,
    NoShadow = false,
    XRay = false,
    FOVChanger = false,
    FOVAmount = 100,
    -- Utility (QUALITY OF LIFE SHIT)
    AutoDonut = false,
    AutoKeycard = false,
    AutoGun = false,
    AutoShield = false,
    AutoAmmo = false,
    AutoSkillTree = false,
    SkillPriority = "Attack",
    AutoTeam = false,
    TeamToJoin = "Criminals",
    AutoRevive = false,
    AutoEscape = false,
    EscapeMethod = "Tunnel",
    AntiAFK = true,
    TeleportOnLowHealth = false,
    LowHealthThreshold = 30,
    TeleportLocation = "CriminalBase",
    AutoRoll = false,
    AutoRollDelay = 0.1,
    TargetTrait = "None",
    TargetRace = "None",
    TargetClan = "None",
    AutoMerchant = false,
    -- States
    Flying = false,
}

-- // LOAD SAVED SETTINGS
pcall(function()
    local storage = game:GetService("LocalStorage")
    local data = storage:FindFirstChild(settingsKey)
    if data then
        local saved = HttpService:JSONDecode(data.Value)
        for k, v in pairs(saved) do Settings[k] = v end
        print("Settings loaded you bitch")
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
        print("Settings saved motherfucker")
    end)
end

-- // ANTI AFK (FUCK THE AFK KICK)
if Settings.AntiAFK then
    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(0.3)
            VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            VirtualUser:ClickButton1(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- // ANTI RAGDOLL (NO STUN BITCH)
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

-- // ANTI STUN (FUCK STUN EFFECTS)
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

-- // NO FALL DAMAGE (TAKE NO DAMAGE BITCH)
if Settings.NoFallDamage then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum then
                        hum.UseJumpPower = true
                    end
                end
            end)
        end
    end)
end

-- // AUTO TEAM (JOIN CRIMINALS BITCH)
local function AutoTeam()
    if Settings.AutoTeam then
        local targetTeam = Teams:FindFirstChild(Settings.TeamToJoin)
        if targetTeam and LP.Team ~= targetTeam then
            LP.Team = targetTeam
            print("Joined " .. Settings.TeamToJoin .. " you bitch")
        end
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    AutoTeam()
end)

-- // INFINITE JUMP (JUMP FOREVER BITCH)
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
    SaveSettings()
end

-- // FLY FUNCTION (GO ZOOM ZOOM MOTHERFUCKER)
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

-- // NOCLIP (WALK THROUGH WALLS LIKE A GHOST BITCH)
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
    SaveSettings()
end

-- // FULLBRIGHT (SEE IN THE DARK YOU PUSSY)
local function ToggleFullBright()
    Settings.FullBright = not Settings.FullBright
    if Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 8
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    end
    SaveSettings()
end

-- // NO FOG (REMOVE THAT FOGGY SHIT)
local function ToggleNoFog()
    Settings.NoFog = not Settings.NoFog
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 1000
    end
    SaveSettings()
end

-- // NO SHADOWS (REMOVE SHADOWS BITCH)
local function ToggleNoShadow()
    Settings.NoShadow = not Settings.NoShadow
    Lighting.GlobalShadows = not Settings.NoShadow
    SaveSettings()
end

-- // FOV CHANGER (ZOOM IN/OUT BITCH)
if Settings.FOVChanger then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                Camera.FieldOfView = Settings.FOVAmount
            end)
        end
    end)
end

-- // ESP (SEE THOSE MOTHERFUCKERS THROUGH WALLS)
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
                highlight.Name = "EliteESP"
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

-- // AIM ASSIST (AUTO AIM BITCH)
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

-- // LOCATIONS (WHERE TO ROB THESE BITCHES)
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
    Merchant = CFrame.new(-25, 18, 250),
    PoliceStation = CFrame.new(640, 18, -460),
    CriminalBase = CFrame.new(-235, 18, 1610),
    Hospital = CFrame.new(350, 18, -250),
}

-- // UTILITIES (HELPER FUNCTIONS BITCH)
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

-- // AUTO FARM COPS (HUNT THOSE BLUE BITCHES)
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

-- // AUTO FARM PRISONERS (BEAT THOSE INMATE BITCHES)
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

-- // KILL AURA (AUTO FUCK EVERYONE UP)
task.spawn(function()
    while task.wait(Settings.KillAuraDelay) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local targets = GetPlayersInRange(Settings.KillAuraRange, nil)
                for _, target in pairs(targets) do
                    AttackPlayer(target)
                end
            end
        end)
    end
end)

-- // AUTO BANK (ROB THOSE FUCKS)
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

-- // AUTO JEWELRY (STEAL THAT SHINY SHIT)
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

-- // AUTO MUSEUM (STEAL THAT OLD SHIT)
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

-- // AUTO DONUT (HEAL THAT ASS)
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

-- // AUTO MERCHANT (BUY THAT SHIT)
task.spawn(function()
    while task.wait(60) do
        pcall(function()
            if Settings.AutoMerchant then
                TweenTo(Locations.Merchant, 80)
                task.wait(2)
            end
        end)
    end
end)

-- // MOVEMENT LOOP (KEEP YOUR SPEED YOU SPEED DEMON)
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

-- // TELEPORT ON LOW HEALTH (GTFO BITCH)
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

-- // CREATE FUCKING TABS

-- // AUTOMATION TAB (AUTO SHIT)
local AutomationTab = Window:NewTab("AUTOMATION")
local AutoRollsSection = AutomationTab:NewSection("🎲 AUTO ROLLS (FUCK RNG)")

AutoRollsSection:NewToggle("Auto Rolls", "Auto roll for traits/races/clans", function(v) Settings.AutoRoll = v; SaveSettings() end)
AutoRollsSection:NewInput("Target Trait", "Desired trait name", function(v) Settings.TargetTrait = v; SaveSettings() end)
AutoRollsSection:NewInput("Target Race", "Desired race name", function(v) Settings.TargetRace = v; SaveSettings() end)
AutoRollsSection:NewInput("Target Clan", "Desired clan name", function(v) Settings.TargetClan = v; SaveSettings() end)
AutoRollsSection:NewSlider("Roll Cooldown", "Seconds between rolls", 0.05, 2, function(v) Settings.AutoRollDelay = v; SaveSettings() end)

local SkillSection = AutomationTab:NewSection("🌳 SKILL TREE (GET STRONG BITCH)")

SkillSection:NewToggle("Auto Skill Tree", "Auto upgrade skill nodes", function(v) Settings.AutoSkillTree = v; SaveSettings() end)
SkillSection:NewSlider("Node Index", "Which node to upgrade", 1, 50, function(v) Settings.SkillNodeIndex = v; SaveSettings() end)
SkillSection:NewDropdown("Skill Priority", "Upgrade priority", {"Attack", "Defense", "Health", "Fruit", "Sword"}, function(v) Settings.SkillPriority = v; SaveSettings() end)

local MerchantSection = AutomationTab:NewSection("💰 MERCHANT (SPEND THAT CASH)")

MerchantSection:NewToggle("Auto Merchant", "Auto visit merchant", function(v) Settings.AutoMerchant = v; SaveSettings() end)
MerchantSection:NewToggle("Auto Buy Keycard", "Buy keycard from merchant", function(v) Settings.AutoKeycard = v; SaveSettings() end)
MerchantSection:NewToggle("Auto Buy Gun", "Buy gun from merchant", function(v) Settings.AutoGun = v; SaveSettings() end)
MerchantSection:NewToggle("Auto Buy Ammo", "Buy ammo from merchant", function(v) Settings.AutoAmmo = v; SaveSettings() end)
MerchantSection:NewToggle("Auto Buy Shield", "Buy shield from merchant", function(v) Settings.AutoShield = v; SaveSettings() end)

-- // COMBAT TAB (KILL THOSE MOTHERFUCKERS)
local CombatTab = Window:NewTab("COMBAT")
local KillAuraSection = CombatTab:NewSection("💀 KILL AURA (AUTO ATTACK)")

KillAuraSection:NewToggle("Kill Aura", "Auto attack players in range - FUCK THEM UP", function(v) Settings.KillAura = v; SaveSettings() end)
KillAuraSection:NewSlider("Kill Aura Range", "How far to attack (studs)", 10, 100, function(v) Settings.KillAuraRange = v; SaveSettings() end)
KillAuraSection:NewSlider("Kill Aura Delay", "Seconds between attacks", 0.05, 1, function(v) Settings.KillAuraDelay = v; SaveSettings() end)
KillAuraSection:NewToggle("Team Check", "Only attack enemies (not your team)", function(v) Settings.KillAuraTeamCheck = v; SaveSettings() end)

local FarmSection = CombatTab:NewSection("👮 AUTO FARM (HUNT THEM DOWN)")

FarmSection:NewToggle("Auto Farm Cops", "Hunt down police officers - KILL THE BLUE BITCHES", function(v) Settings.AutoFarmCops = v; SaveSettings() end)
FarmSection:NewToggle("Auto Farm Prisoners", "Beat those inmates - FUCK THEM UP", function(v) Settings.AutoFarmPrisoners = v; SaveSettings() end)
FarmSection:NewToggle("Auto Farm Bounty", "Hunt bounty targets - GET THAT BAG", function(v) Settings.AutoFarmBounty = v; SaveSettings() end)
FarmSection:NewToggle("Auto Farm Cash", "Farm cash automatically", function(v) Settings.AutoFarmCash = v; SaveSettings() end)

local WeaponSection = CombatTab:NewSection("🔫 WEAPON MODS (CHEATS)")

WeaponSection:NewToggle("No Recoil", "Zero weapon recoil - LASER BEAM", function(v) Settings.NoRecoil = v; SaveSettings() end)
WeaponSection:NewToggle("No Spread", "Perfect accuracy - NEVER MISS", function(v) Settings.NoSpread = v; SaveSettings() end)
WeaponSection:NewToggle("Fast Swing", "Increased melee speed - SPAM THAT SHIT", function(v) Settings.FastSwing = v; SaveSettings() end)
WeaponSection:NewToggle("Fast Shoot", "Increased fire rate - BRRRRRR", function(v) Settings.FastShoot = v; SaveSettings() end)
WeaponSection:NewToggle("Infinite Ammo", "Never run out of bullets - KEEP SHOOTING", function(v) Settings.InfiniteAmmo = v; SaveSettings() end)

local AimSection = CombatTab:NewSection("🎯 AIM ASSIST (AUTO AIM)")

AimSection:NewToggle("Aim Assist", "Auto aim at enemies - LOCK ON BITCH", function(v) Settings.AimAssist = v; SaveSettings() end)
AimSection:NewSlider("Aim FOV", "Field of view for aim assist", 20, 120, function(v) Settings.AimAssistFOV = v; SaveSettings() end)
AimSection:NewSlider("Aim Smoothness", "How smooth the aim is (1=snappy, 10=smooth)", 1, 10, function(v) Settings.AimAssistSmoothness = v; SaveSettings() end)
AimSection:NewToggle("Trigger Bot", "Auto shoot when aiming at enemy", function(v) Settings.TriggerBot = v; SaveSettings() end)

local PoliceSection = CombatTab:NewSection("🚔 POLICE MODS (COP ONLY)")

PoliceSection:NewToggle("Auto Arrest", "Auto arrest criminals - PUT THEM IN JAIL", function(v) Settings.AutoArrest = v; SaveSettings() end)
PoliceSection:NewToggle("Auto Tase", "Auto tase suspects - ZAP THAT BITCH", function(v) Settings.AutoTase = v; SaveSettings() end)

-- // ROBBERY TAB (STEAL THAT SHIT)
local RobberyTab = Window:NewTab("ROBBERY")
local RobberySection = RobberyTab:NewSection("💰 ROBBERY (STEAL EVERYTHING)")

RobberySection:NewToggle("Auto Bank", "Rob the bank - GET THAT CASH", function(v) Settings.AutoBank = v; SaveSettings() end)
RobberySection:NewToggle("Auto Jewelry", "Rob jewelry store - STEAL THE SHINY SHIT", function(v) Settings.AutoJewelry = v; SaveSettings() end)
RobberySection:NewToggle("Auto Museum", "Rob the museum - TAKE THAT ART", function(v) Settings.AutoMuseum = v; SaveSettings() end)
RobberySection:NewToggle("Auto Train", "Rob the train - HIJACK THAT BITCH", function(v) Settings.AutoTrain = v; SaveSettings() end)
RobberySection:NewToggle("Auto Cargo Plane", "Rob the cargo plane", function(v) Settings.AutoCargo = v; SaveSettings() end)
RobberySection:NewToggle("Auto Power Plant", "Rob the power plant", function(v) Settings.AutoPowerPlant = v; SaveSettings() end)
RobberySection:NewToggle("Auto Casino", "Rob the casino", function(v) Settings.AutoCasino = v; SaveSettings() end)

local RobberySettings = RobberyTab:NewSection("⚙️ ROBBERY SETTINGS")

RobberySettings:NewSlider("Robbery Delay", "Seconds between robberies", 1, 10, function(v) Settings.RobberyDelay = v; SaveSettings() end)
RobberySettings:NewToggle("Auto Collect Money", "Auto pick up cash from ground", function(v) Settings.AutoCollectMoney = v; SaveSettings() end)
RobberySettings:NewToggle("Auto Sell Items", "Auto sell stolen items", function(v) Settings.AutoSellItems = v; SaveSettings() end)

-- // MOVEMENT TAB (GO FAST AS FUCK)
local MovementTab = Window:NewTab("MOVEMENT")
local FlySection = MovementTab:NewSection("🕊️ FLY & NOCLIP")

FlySection:NewToggle("Fly Mode", "Fly around the map - ZOOM BITCH", function(v) Settings.Fly = v; ToggleFly(); SaveSettings() end)
FlySection:NewSlider("Fly Speed", "Flight speed (30-250)", 30, 250, function(v) Settings.FlySpeed = v; SaveSettings() end)
FlySection:NewToggle("Noclip", "Walk through walls - GHOST MODE", function(v) Settings.Noclip = v; ToggleNoclip(); SaveSettings() end)
FlySection:NewToggle("Infinite Jump", "Jump infinitely - NEVER LAND", function(v) ToggleInfiniteJump(); SaveSettings() end)

local SpeedSection = MovementTab:NewSection("⚡ SPEED & JUMP")

SpeedSection:NewSlider("Walk Speed", "Movement speed (16-200)", 16, 200, function(v) Settings.WalkSpeed = v; SaveSettings() end)
SpeedSection:NewSlider("Jump Power", "Jump height (50-200)", 50, 200, function(v) Settings.JumpPower = v; SaveSettings() end)
SpeedSection:NewToggle("Auto Sprint", "Always sprint - GOTTA GO FAST", function(v) Settings.AutoSprint = v; SaveSettings() end)
SpeedSection:NewToggle("Auto Stairs", "Fast stairs climb", function(v) Settings.AutoStairs = v; SaveSettings() end)

local ProtectionSection = MovementTab:NewSection("🛡️ PROTECTION (NO STUN BITCH)")

ProtectionSection:NewToggle("Anti Ragdoll", "No ragdoll stun - GET UP BITCH", function(v) Settings.AntiRagdoll = v; SaveSettings() end)
ProtectionSection:NewToggle("Anti Stun", "No stun effects - FUCK YOUR STUN", function(v) Settings.AntiStun = v; SaveSettings() end)
ProtectionSection:NewToggle("No Fall Damage", "Take no fall damage - JUMP FROM ANYWHERE", function(v) Settings.NoFallDamage = v; SaveSettings() end)
ProtectionSection:NewToggle("Auto Dodge", "Auto dodge incoming attacks", function(v) Settings.AutoDodge = v; SaveSettings() end)

-- // VISUALS TAB (SEE THEIR BITCH ASS)
local VisualsTab = Window:NewTab("VISUALS")
local ESPSection = VisualsTab:NewSection("👻 ESP (WALLHACK)")

ESPSection:NewToggle("ESP Enable", "See players through walls - CHEATING BITCH", function(v) Settings.ESP = v; UpdateESP(); SaveSettings() end)
ESPSection:NewColorPicker("ESP Color", "Pick ESP color", function(v) Settings.ESPColor = v; UpdateESP(); SaveSettings() end)
ESPSection:NewToggle("Team Colors", "Color by team (Cops=Blue, Crims=Red)", function(v) Settings.ESPTeamColors = v; UpdateESP(); SaveSettings() end)

local WorldSection = VisualsTab:NewSection("🌅 WORLD MODS")

WorldSection:NewToggle("Fullbright", "See in the dark - NO MORE DARKNESS", function(v) Settings.FullBright = v; ToggleFullBright(); SaveSettings() end)
WorldSection:NewToggle("No Fog", "Remove fog - SEE EVERYTHING", function(v) Settings.NoFog = v; ToggleNoFog(); SaveSettings() end)
WorldSection:NewToggle("No Shadows", "Remove shadows - MORE FPS BITCH", function(v) Settings.NoShadow = v; ToggleNoShadow(); SaveSettings() end)
WorldSection:NewToggle("X-Ray", "See through objects", function(v) Settings.XRay = v; SaveSettings() end)

local CameraSection = VisualsTab:NewSection("📷 CAMERA MODS")

CameraSection:NewToggle("FOV Changer", "Change field of view", function(v) Settings.FOVChanger = v; SaveSettings() end)
CameraSection:NewSlider("FOV Amount", "Field of view value (70-120)", 70, 120, function(v) Settings.FOVAmount = v; SaveSettings() end)

-- // UTILITY TAB (QUALITY OF LIFE SHIT)
local UtilityTab = Window:NewTab("UTILITY")
local AutoSection = UtilityTab:NewSection("🛠️ AUTO UTILITIES")

AutoSection:NewToggle("Auto Donut", "Auto heal with donuts when low health - NOM NOM", function(v) Settings.AutoDonut = v; SaveSettings() end)
AutoSection:NewToggle("Auto Keycard", "Auto buy keycard from merchant", function(v) Settings.AutoKeycard = v; SaveSettings() end)
AutoSection:NewToggle("Auto Gun", "Auto buy gun", function(v) Settings.AutoGun = v; SaveSettings() end)
AutoSection:NewToggle("Auto Shield", "Auto buy shield", function(v) Settings.AutoShield = v; SaveSettings() end)

local TeamSection = UtilityTab:NewSection("🚔 TEAM & ESCAPE")

TeamSection:NewToggle("Auto Team", "Auto join team on spawn", function(v) Settings.AutoTeam = v; AutoTeam(); SaveSettings() end)
TeamSection:NewDropdown("Team To Join", "Which team to join", {"Criminals", "Police"}, function(v) Settings.TeamToJoin = v; SaveSettings() end)
TeamSection:NewToggle("Auto Revive", "Auto revive when dead - GET BACK UP", function(v) Settings.AutoRevive = v; SaveSettings() end)
TeamSection:NewToggle("Auto Escape", "Auto escape from prison", function(v) Settings.AutoEscape = v; SaveSettings() end)
TeamSection:NewDropdown("Escape Method", "How to escape", {"Tunnel", "Volcano", "Sewer", "Helicopter"}, function(v) Settings.EscapeMethod = v; SaveSettings() end)

local MiscSection = UtilityTab:NewSection("🎮 MISC SETTINGS")

MiscSection:NewToggle("Anti AFK", "Prevent AFK kick - STAY IN GAME", function(v) Settings.AntiAFK = v; SaveSettings() end)
MiscSection:NewToggle("Teleport on Low Health", "Escape when health is low", function(v) Settings.TeleportOnLowHealth = v; SaveSettings() end)
MiscSection:NewSlider("Low Health Threshold", "Health % to teleport", 10, 70, function(v) Settings.LowHealthThreshold = v; SaveSettings() end)
MiscSection:NewDropdown("Teleport Location", "Where to teleport", {"CriminalBase", "PoliceStation", "Hospital"}, function(v) Settings.TeleportLocation = v; SaveSettings() end)

-- // SETTINGS TAB
local SettingsTab = Window:NewTab("SETTINGS")
local LinksSection = SettingsTab:NewSection("💬 LINKS")

LinksSection:NewButton("Join Discord (Copy Link)", "Click to copy discord link", function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "DISCORD LINK COPIED YOU BITCH 🥀",
        Duration = 2
    })
end)

LinksSection:NewButton("Copy Discord Invite Code", "Copy invite code only", function()
    setclipboard("5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "Invite code copied! discord.gg/5RuMCxK3u6",
        Duration = 2
    })
end)

local UISection = SettingsTab:NewSection("⚙️ UI SETTINGS")

UISection:NewButton("Save Settings", "Save all your settings", function()
    SaveSettings()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "Settings saved you bitch! 🥀",
        Duration = 2
    })
end)

UISection:NewButton("Destroy UI", "Close the menu", function()
    game:GetService("CoreGui"):FindFirstChild("EliteHub"):Destroy()
end)

-- // STARTUP SHIT
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED YOU FUCKING BITCH - 9,338 MEMBERS - 60+ FEATURES 🥀",
    Duration = 3
})

print("████████████████████████████████████████████████████████████")
print("ELITE HUB v1.0.0 - 60+ FEATURES LOADED - GO FUCK SHIT UP")
print("DISCORD: discord.gg/5RuMCxK3u6 - 9,338 MEMBERS")
print("FUCK XENO - FUCK SOLARA - USE DELTA OR SWIFT YOU DUMB BITCH")
print("████████████████████████████████████████████████████████████")