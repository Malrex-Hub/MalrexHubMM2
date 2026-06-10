-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // 9,338 MEMBERS - FULL FEATURE PACKED BITCH 🥀

local HttpService = game:GetService("HttpService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

local settingsKey = "EliteHub_Settings_" .. lp.UserId
local savedSettings = nil

-- // ALL FUCKING SETTINGS (EVERYTHING)
local Settings = {
    -- Combat
    KillAura = false,
    KillAuraRange = 35,
    KillAuraDelay = 0.1,
    KillAuraTeamCheck = true,
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
    
    -- Robbery
    AutoBank = false,
    AutoJewelry = false,
    AutoMuseum = false,
    AutoTrain = false,
    AutoCargo = false,
    AutoPowerPlant = false,
    AutoCasino = false,
    AutoTomb = false,
    RobberyDelay = 2,
    AutoCollectMoney = false,
    AutoSellItems = false,
    
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
    
    -- States
    Flying = false,
    CurrentTarget = nil,
}

-- // LOAD SAVED SETTINGS
pcall(function()
    local syn = syn and syn.io or (getgenv and getgenv().syn and syn.io)
    if syn then
        if syn.file_exists(settingsKey) then
            local data = syn.read_file(settingsKey)
            if data and data ~= "" then
                savedSettings = HttpService:JSONDecode(data)
                for k, v in pairs(savedSettings) do
                    Settings[k] = v
                end
            end
        end
    else
        local data = game:GetService("LocalStorage"):FindFirstChild(settingsKey)
        if data then
            savedSettings = HttpService:JSONDecode(data.Value)
            for k, v in pairs(savedSettings) do
                Settings[k] = v
            end
        end
    end
end)

-- // SAVE SETTINGS
local function SaveSettings()
    pcall(function()
        local json = HttpService:JSONEncode(Settings)
        local syn = syn and syn.io or (getgenv and getgenv().syn and syn.io)
        if syn then
            syn.write_file(settingsKey, json)
        else
            local storage = game:GetService("LocalStorage")
            local existing = storage:FindFirstChild(settingsKey)
            if existing then existing:Destroy() end
            local newData = Instance.new("StringValue")
            newData.Name = settingsKey
            newData.Value = json
            newData.Parent = storage
        end
    end)
end

-- // LOAD MACLIB
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

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
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FULL FEATURE PACKED")
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
end)

-- // ANTI AFK
if Settings.AntiAFK then
    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.3)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
end

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
        if infiniteJumpConn then infiniteJumpConn:Disconnect() infiniteJumpConn = nil end
    end
    SaveSettings()
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

-- // ANTI RAGDOLL
if Settings.AntiRagdoll then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum and (hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.Stunned) then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
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

-- // FOV CHANGER
if Settings.FOVChanger then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if Camera then
                    Camera.FieldOfView = Settings.FOVAmount
                end
            end)
        end
    end)
end

-- // FLY FUNCTION
local flying = false
local function ToggleFly()
    flying = not flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if flying then
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
            while flying and char and char:FindFirstChild("HumanoidRootPart") do
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
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    else
        noclipConn = RunService.RenderStepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
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
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 8
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
    SaveSettings()
end

-- // NO FOG
local function ToggleNoFog()
    Settings.NoFog = not Settings.NoFog
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 1000
    end
    SaveSettings()
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
                            local smooth = Settings.AimAssistSmoothness
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction * smooth)
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
    CriminalBase = CFrame.new(-235, 18, 1610),
    PoliceStation = CFrame.new(640, 18, -460),
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

local function AttackPlayer(player)
    if not player or not player.Character then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local target = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
        task.wait(0.05)
        local punch = ReplicatedStorage:FindFirstChild("Punch")
        if punch then pcall(function() punch:FireServer(target.Position) end) end
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
    while task.wait(Settings.KillAuraDelay) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local player, dist = GetNearestPlayer(nil)
                if player and dist <= Settings.KillAuraRange then
                    AttackPlayer(player)
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
                TweenTo(Locations.PoliceStation, 80)
                task.wait(2)
                if Settings.BuyKeycard then
                    -- Buy keycard logic
                end
                if Settings.BuyGun then
                    -- Buy gun logic
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

-- // CALLBACK WRAPPERS WITH AUTO SAVE
local function makeToggleCallback(setting, callback)
    return function(v)
        Settings[setting] = v
        SaveSettings()
        if callback then callback(v) end
    end
end

local function makeSliderCallback(setting, callback)
    return function(v)
        Settings[setting] = v
        SaveSettings()
        if callback then callback(v) end
    end
end

-- // CREATE UI (SMALL - 380x480)
local Window = MacLib:Window({
    Title = "ELITE HUB v1.0.0",
    Subtitle = fps .. " FPS | " .. ping .. " MS | 9,338 MEMBERS",
    Size = UDim2.fromOffset(380, 480),
    DragStyle = 1,
    AcrylicBlur = true,
    Keybind = Enum.KeyCode.RightControl,
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            Window.Settings.Subtitle = fps .. " FPS | " .. ping .. " MS | 9,338 MEMBERS"
        end)
    end
end)

local tabGroup = Window:TabGroup()

-- // TAB 1: AUTOMATION
local autoTab = tabGroup:Tab({ Name = "AUTO" })
local autoLeft = autoTab:Section({ Side = "Left" })
local autoRight = autoTab:Section({ Side = "Right" })

autoLeft:Header({ Name = "⚡ AUTO ROLLS" })
autoLeft:Input({ Name = "Target Traits", Placeholder = "None" })
autoLeft:Toggle({ Name = "Auto Roll Traits", Default = false })
autoLeft:Input({ Name = "Target Race", Placeholder = "None" })
autoLeft:Toggle({ Name = "Auto Roll Race", Default = false })
autoLeft:Input({ Name = "Target Clan", Placeholder = "None" })
autoLeft:Toggle({ Name = "Auto Roll Clan", Default = false })
autoLeft:Slider({ Name = "Roll Cooldown", Default = 0.1, Minimum = 0.05, Maximum = 2, Precision = 2 })

autoRight:Header({ Name = "🌳 SKILL TREE" })
autoRight:Slider({ Name = "Node Index", Default = 1, Minimum = 1, Maximum = 50 })
autoRight:Toggle({ Name = "Auto Upgrade Nodes", Default = false })
autoRight:Dropdown({ Name = "Skill Priority", Options = {"Attack", "Defense", "Health"}, Default = 1 })

autoRight:Divider()
autoRight:Header({ Name = "💰 MERCHANT" })
autoRight:Toggle({ Name = "Auto Merchant", Default = false, Callback = makeToggleCallback("AutoMerchant") })
autoRight:Toggle({ Name = "Buy Keycard", Default = false, Callback = makeToggleCallback("BuyKeycard") })
autoRight:Toggle({ Name = "Buy Gun", Default = false, Callback = makeToggleCallback("BuyGun") })
autoRight:Toggle({ Name = "Buy Ammo", Default = false, Callback = makeToggleCallback("BuyAmmo") })

-- // TAB 2: COMBAT
local combatTab = tabGroup:Tab({ Name = "COMBAT" })
local combatLeft = combatTab:Section({ Side = "Left" })
local combatRight = combatTab:Section({ Side = "Right" })

combatLeft:Header({ Name = "⚔️ KILL AURA" })
combatLeft:Toggle({ Name = "Kill Aura", Default = Settings.KillAura, Callback = makeToggleCallback("KillAura") })
combatLeft:Slider({ Name = "Range", Default = Settings.KillAuraRange, Minimum = 10, Maximum = 100, Callback = makeSliderCallback("KillAuraRange") })
combatLeft:Slider({ Name = "Delay (sec)", Default = Settings.KillAuraDelay, Minimum = 0.05, Maximum = 1, Precision = 2, Callback = makeSliderCallback("KillAuraDelay") })

combatLeft:Divider()
combatLeft:Header({ Name = "👮 AUTO FARM" })
combatLeft:Toggle({ Name = "Auto Farm Cops", Default = Settings.AutoFarmCops, Callback = makeToggleCallback("AutoFarmCops") })
combatLeft:Toggle({ Name = "Auto Farm Prisoners", Default = Settings.AutoFarmPrisoners, Callback = makeToggleCallback("AutoFarmPrisoners") })
combatLeft:Toggle({ Name = "Auto Farm Bounty", Default = Settings.AutoFarmBounty, Callback = makeToggleCallback("AutoFarmBounty") })

combatRight:Header({ Name = "🎯 AIM ASSIST" })
combatRight:Toggle({ Name = "Aim Assist", Default = Settings.AimAssist, Callback = makeToggleCallback("AimAssist") })
combatRight:Slider({ Name = "FOV", Default = Settings.AimAssistFOV, Minimum = 20, Maximum = 120, Callback = makeSliderCallback("AimAssistFOV") })
combatRight:Slider({ Name = "Smoothness", Default = Settings.AimAssistSmoothness, Minimum = 1, Maximum = 10, Callback = makeSliderCallback("AimAssistSmoothness") })

combatRight:Divider()
combatRight:Header({ Name = "🔫 WEAPON MODS" })
combatRight:Toggle({ Name = "No Recoil", Default = Settings.NoRecoil, Callback = makeToggleCallback("NoRecoil") })
combatRight:Toggle({ Name = "No Spread", Default = Settings.NoSpread, Callback = makeToggleCallback("NoSpread") })
combatRight:Toggle({ Name = "Fast Swing", Default = Settings.FastSwing, Callback = makeToggleCallback("FastSwing") })
combatRight:Toggle({ Name = "Infinite Ammo", Default = Settings.InfiniteAmmo, Callback = makeToggleCallback("InfiniteAmmo") })

-- // TAB 3: ROBBERY
local robTab = tabGroup:Tab({ Name = "ROBBERY" })
local robLeft = robTab:Section({ Side = "Left" })
local robRight = robTab:Section({ Side = "Right" })

robLeft:Header({ Name = "💰 AUTO ROBBERY" })
robLeft:Toggle({ Name = "Auto Bank", Default = Settings.AutoBank, Callback = makeToggleCallback("AutoBank") })
robLeft:Toggle({ Name = "Auto Jewelry", Default = Settings.AutoJewelry, Callback = makeToggleCallback("AutoJewelry") })
robLeft:Toggle({ Name = "Auto Museum", Default = Settings.AutoMuseum, Callback = makeToggleCallback("AutoMuseum") })
robLeft:Toggle({ Name = "Auto Train", Default = Settings.AutoTrain, Callback = makeToggleCallback("AutoTrain") })
robLeft:Toggle({ Name = "Auto Cargo", Default = Settings.AutoCargo, Callback = makeToggleCallback("AutoCargo") })
robLeft:Toggle({ Name = "Auto Power Plant", Default = Settings.AutoPowerPlant, Callback = makeToggleCallback("AutoPowerPlant") })

robRight:Header({ Name = "⏱️ SETTINGS" })
robRight:Slider({ Name = "Robbery Delay (sec)", Default = Settings.RobberyDelay, Minimum = 1, Maximum = 10, Callback = makeSliderCallback("RobberyDelay") })
robRight:Toggle({ Name = "Auto Collect Money", Default = Settings.AutoCollectMoney, Callback = makeToggleCallback("AutoCollectMoney") })
robRight:Toggle({ Name = "Auto Sell Items", Default = Settings.AutoSellItems, Callback = makeToggleCallback("AutoSellItems") })

-- // TAB 4: MOVEMENT
local moveTab = tabGroup:Tab({ Name = "MOVE" })
local moveLeft = moveTab:Section({ Side = "Left" })
local moveRight = moveTab:Section({ Side = "Right" })

moveLeft:Header({ Name = "🌀 MOVEMENT" })
moveLeft:Toggle({ Name = "Fly", Default = false, Callback = function(v) ToggleFly() end })
moveLeft:Slider({ Name = "Fly Speed", Default = Settings.FlySpeed, Minimum = 30, Maximum = 250, Callback = makeSliderCallback("FlySpeed") })
moveLeft:Toggle({ Name = "Noclip", Default = false, Callback = function(v) ToggleNoclip() end })
moveLeft:Toggle({ Name = "Auto Sprint", Default = Settings.AutoSprint, Callback = makeToggleCallback("AutoSprint") })
moveLeft:Toggle({ Name = "Infinite Jump", Default = Settings.InfiniteJump, Callback = function(v) ToggleInfiniteJump() end })

moveRight:Header({ Name = "⚡ STATS" })
moveRight:Slider({ Name = "Walk Speed", Default = Settings.WalkSpeed, Minimum = 16, Maximum = 200, Callback = makeSliderCallback("WalkSpeed") })
moveRight:Slider({ Name = "Jump Power", Default = Settings.JumpPower, Minimum = 50, Maximum = 200, Callback = makeSliderCallback("JumpPower") })

moveRight:Divider()
moveRight:Header({ Name = "🛡️ PROTECTION" })
moveRight:Toggle({ Name = "Anti Ragdoll", Default = Settings.AntiRagdoll, Callback = makeToggleCallback("AntiRagdoll") })
moveRight:Toggle({ Name = "No Fall Damage", Default = Settings.NoFallDamage, Callback = makeToggleCallback("NoFallDamage") })
moveRight:Toggle({ Name = "Anti Stun", Default = Settings.AntiStun, Callback = makeToggleCallback("AntiStun") })

-- // TAB 5: VISUALS
local visTab = tabGroup:Tab({ Name = "VISUALS" })
local visLeft = visTab:Section({ Side = "Left" })
local visRight = visTab:Section({ Side = "Right" })

visLeft:Header({ Name = "👁️ ESP" })
visLeft:Toggle({ Name = "ESP", Default = Settings.ESP, Callback = makeToggleCallback("ESP", UpdateESP) })
visLeft:Colorpicker({ Name = "ESP Color", Default = Settings.ESPColor, Callback = function(c) Settings.ESPColor = c; UpdateESP(); SaveSettings() end })
visLeft:Toggle({ Name = "Team Colors", Default = Settings.ESPTeamColors, Callback = makeToggleCallback("ESPTeamColors", UpdateESP) })
visLeft:Toggle({ Name = "ESP Tracers", Default = Settings.ESPTracers, Callback = makeToggleCallback("ESPTracers") })

visRight:Header({ Name = "🌅 WORLD" })
visRight:Toggle({ Name = "Fullbright", Default = Settings.FullBright, Callback = makeToggleCallback("FullBright", ToggleFullBright) })
visRight:Toggle({ Name = "No Fog", Default = Settings.NoFog, Callback = makeToggleCallback("NoFog", ToggleNoFog) })
visRight:Toggle({ Name = "No Shadows", Default = Settings.NoShadow, Callback = makeToggleCallback("NoShadow") })

visRight:Divider()
visRight:Header({ Name = "📷 CAMERA" })
visRight:Toggle({ Name = "FOV Changer", Default = Settings.FOVChanger, Callback = makeToggleCallback("FOVChanger") })
visRight:Slider({ Name = "FOV Amount", Default = Settings.FOVAmount, Minimum = 70, Maximum = 120, Callback = makeSliderCallback("FOVAmount") })

-- // TAB 6: UTILITY
local utilTab = tabGroup:Tab({ Name = "UTILITY" })
local utilLeft = utilTab:Section({ Side = "Left" })
local utilRight = utilTab:Section({ Side = "Right" })

utilLeft:Header({ Name = "🛠️ AUTO" })
utilLeft:Toggle({ Name = "Auto Donut (Heal)", Default = Settings.AutoDonut, Callback = makeToggleCallback("AutoDonut") })
utilLeft:Toggle({ Name = "Auto Keycard", Default = Settings.AutoKeycard, Callback = makeToggleCallback("AutoKeycard") })
utilLeft:Toggle({ Name = "Auto Team", Default = Settings.AutoTeam, Callback = makeToggleCallback("AutoTeam", AutoTeam) })
utilLeft:Toggle({ Name = "Auto Revive", Default = Settings.AutoRevive, Callback = makeToggleCallback("AutoRevive") })
utilLeft:Toggle({ Name = "Anti AFK", Default = Settings.AntiAFK, Callback = makeToggleCallback("AntiAFK") })

utilRight:Header({ Name = "🏃 ESCAPE" })
utilRight:Toggle({ Name = "Auto Escape", Default = Settings.AutoEscape, Callback = makeToggleCallback("AutoEscape") })
utilRight:Dropdown({ Name = "Escape Method", Options = {"Tunnel", "Volcano", "Sewer"}, Default = 1, Callback = function(v) Settings.EscapeMethod = v; SaveSettings() end })

utilRight:Divider()
utilRight:Header({ Name = "💬 DISCORD" })
utilRight:Button({ Name = "Join Discord (Copy Link)", Callback = function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    Window:Notify({ Title = "ELITE HUB", Description = "Link copied!", Lifetime = 2 })
end })

-- // TAB 7: SETTINGS
local setTab = tabGroup:Tab({ Name = "SETTINGS" })
setTab:InsertConfigSection("Left")

setTab:Button({ Name = "Save All Settings", Callback = function()
    SaveSettings()
    Window:Notify({ Title = "ELITE HUB", Description = "Settings saved!", Lifetime = 2 })
end })

setTab:Button({ Name = "Destroy UI", Callback = function() Window:Unload() end })

-- // SELECT DEFAULT TAB
autoTab:Select()

Window:Notify({ Title = "ELITE HUB v1.0.0", Description = "Loaded - 9,338 Members - Auto Save ON", Lifetime = 3 })
print("ELITE HUB FULLY LOADED - 50+ FEATURES BITCH")