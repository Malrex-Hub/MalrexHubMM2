-- ///////////////////////////////////////////////////////////////////////////////////
-- //                                                                               //
-- //    ELITE HUB v1.0.0 | JAILBREAK                                               //
-- //    https://discord.gg/5RuMCxK3u6                                              //
-- //                                                                               //
-- //    FUCK XENO | FUCK SOLARA | BOTH ARE RAT INFESTED BITCHES                    //
-- //    KRNL IS DEAD | SYNAPSE X IS DEAD | USE SWIFT OR AWP YOU FUCKING IDIOT      //
-- //    STEAL THIS AND I FUCK YOUR ENTIRE BLOODLINE BACKWARDS 🥀                   //
-- //                                                                               //
-- ///////////////////////////////////////////////////////////////////////////////////

-- // LOADING FUCKING LIBRARIES //
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = Workspace.CurrentCamera

-- // FUCKING GLOBAL VARIABLES (DONT TOUCH THIS SHIT) //
_G.EliteHub = {
    Version = "1.0.0",
    Discord = "discord.gg/5RuMCxK3u6",
    Author = "Elite Team",
    Loaded = false,
    StartTime = tick(),
}

-- // FUCKING SETTINGS (CHANGE THIS SHIT IF YOU WANT) //
local Settings = {
    -- Theme shit
    Theme = "Emerald",
    Themes = {
        Emerald = { Color = Color3.fromRGB(46, 204, 113), BgColor = Color3.fromRGB(8, 8, 12), Accent = Color3.fromRGB(30, 40, 30) },
        Blood = { Color = Color3.fromRGB(220, 20, 60), BgColor = Color3.fromRGB(12, 6, 8), Accent = Color3.fromRGB(40, 20, 20) },
        Royal = { Color = Color3.fromRGB(138, 43, 226), BgColor = Color3.fromRGB(10, 8, 18), Accent = Color3.fromRGB(30, 20, 45) },
        Cyan = { Color = Color3.fromRGB(0, 255, 255), BgColor = Color3.fromRGB(6, 12, 15), Accent = Color3.fromRGB(20, 35, 40) },
        Gold = { Color = Color3.fromRGB(255, 215, 0), BgColor = Color3.fromRGB(15, 12, 6), Accent = Color3.fromRGB(45, 35, 15) },
        Pink = { Color = Color3.fromRGB(255, 105, 180), BgColor = Color3.fromRGB(18, 8, 15), Accent = Color3.fromRGB(45, 20, 35) },
        Purple = { Color = Color3.fromRGB(160, 32, 240), BgColor = Color3.fromRGB(10, 6, 18), Accent = Color3.fromRGB(35, 20, 50) },
        Orange = { Color = Color3.fromRGB(255, 140, 0), BgColor = Color3.fromRGB(18, 10, 6), Accent = Color3.fromRGB(50, 30, 15) },
    },
    
    -- UI shit
    ShowFPS = true,
    ShowWatermark = true,
    UISize = "Small", -- Small, Medium, Large
    UIOpacity = 0.95,
    
    -- FUCKING AUTO FARM (COP SLAYER) //
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    AutoFarmBounty = false,
    AutoFarmCash = false,
    AutoFarmXP = false,
    KillAura = false,
    KillAuraRange = 35,
    KillAuraDelay = 0.1,
    HitboxExtender = false,
    HitboxSize = 5,
    
    -- ROBBERY SHIT (STEAL EVERYTHING) //
    AutoRobBank = false,
    AutoRobJewelry = false,
    AutoRobMuseum = false,
    AutoRobTrain = false,
    AutoRobCargo = false,
    AutoRobPowerPlant = false,
    AutoRobCasino = false,
    RobberyDelay = 2,
    
    -- POLICE SHIT (ARREST THOSE BITCHES) //
    AutoArrest = false,
    AutoHandcuff = false,
    AutoTase = false,
    AutoSpikeStrip = false,
    AutoRadar = false,
    ArrestRange = 20,
    
    -- MOVEMENT SHIT (GO FAST AS FUCK) //
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    AutoSprint = false,
    AutoStairs = false,
    AntiStun = true,
    AntiRagdoll = true,
    
    -- VISUAL SHIT (SEE THROUGH WALLS BITCH) //
    ESP = false,
    ESPType = "Box", -- Box, Outline, Highlight
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTeamColors = true,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 255, 0),
    FullBright = false,
    NoFog = false,
    XRay = false,
    Tracer = false,
    NameTags = false,
    HealthBars = false,
    
    -- COMBAT SHIT (FUCK THEM UP) //
    AutoAttack = false,
    AutoGun = false,
    AutoReload = false,
    AutoSwitchWeapon = false,
    AimAssist = false,
    AimAssistSmoothness = 5,
    TriggerBot = false,
    TriggerBotDelay = 0.05,
    MeleeRange = 15,
    WeaponMods = false,
    NoRecoil = false,
    NoSpread = false,
    FastSwing = false,
    FastShoot = false,
    
    -- UTILITY SHIT (QOL BITCH) //
    AutoDonut = false,
    AutoKeycard = false,
    AutoGunBuy = false,
    AutoShield = false,
    AutoSkill = false,
    AutoUpgrade = false,
    AutoTeam = "Criminals", -- Criminals or Police
    AutoRevive = false,
    AutoRejoin = false,
    AutoCollectBounty = false,
    AutoSellItems = false,
    
    -- ESCAPE SHIT (GTFO) //
    AutoEscape = false,
    EscapeMethod = "Tunnel", -- Tunnel, Volcano, Sewer, Helicopter
    AutoDodge = false,
    AutoHide = false,
    
    -- MISC SHIT //
    AntiAFK = true,
    AntiCheatBypass = true,
    AntiBan = true,
    TeleportOnLowHealth = false,
    LowHealthThreshold = 30,
    SafeLocation = CFrame.new(0, 50, 0),
    NotificationSound = true,
}

-- // FUCKING THEME APPLIER //
local function ApplyTheme()
    local theme = Settings.Themes[Settings.Theme]
    if not theme then return end
    for _, frame in pairs({MainFrame, AutoSection, RollsSection, SkillSection, MerchantSection, CombatSection, VisualSection, SettingsSection}) do
        if frame then pcall(function() frame.BackgroundColor3 = theme.BgColor end) end
    end
    for _, label in pairs({TitleLabel, AutoTitle, RollsTitle, SkillTitle, MerchantTitle, CombatTitle, VisualTitle, SettingsTitle}) do
        if label then pcall(function() label.TextColor3 = theme.Color end) end
    end
    currentColor = theme.Color
end

-- // FPS COUNTER (REAL TIME BITCH) //
local fps = 60
local lastTime = tick()
local frameCount = 0
local fpsLabel = nil
local memUsage = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
        if Settings.ShowFPS and fpsLabel then
            fpsLabel.Text = "ELITE HUB " .. _G.EliteHub.Version .. " | " .. fps .. " FPS"
        elseif fpsLabel then
            fpsLabel.Text = "ELITE HUB " .. _G.EliteHub.Version
        end
        memUsage = collectgarbage("count")
    end
end)

-- // ANTI FUCKING AFK (FUCK THE AFK KICK) //
if Settings.AntiAFK then
    local afkConnection
    afkConnection = LP.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(0.2)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        VirtualUser:ClickButton1(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end

-- // ANTI CHEAT BYPASS (FUCK JAILBREAK ANTI CHEAT) //
if Settings.AntiCheatBypass then
    local mt = getrawmetatable and getrawmetatable(game) or nil
    if mt then
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        local newIndex = mt.__newindex
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            local selfStr = tostring(self)
            
            -- Block all reporting and banning shit
            if method == "FireServer" then
                if selfStr:find("Report") or selfStr:find("Ban") or selfStr:find("Log") or 
                   selfStr:find("AntiCheat") or selfStr:find("Admin") or selfStr:find("Moderation") then
                    return nil
                end
                if selfStr:find("Ragdoll") or selfStr:find("Stun") or selfStr:find("Arrest") then
                    if Settings.AntiRagdoll then return nil end
                end
            end
            
            if method == "Kick" or method == "Ban" then
                return nil
            end
            
            return oldNamecall(self, ...)
        end)
        
        mt.__index = newcclosure(function(self, key)
            if key == "Kick" or key == "Ban" or key == "Destroy" then
                return function() end
            end
            return oldIndex(self, key)
        end)
        
        mt.__newindex = newcclosure(function(self, key, value)
            if key == "Parent" and tostring(self):find("AntiCheat") then
                return nil
            end
            return newIndex(self, key, value)
        end)
        
        setreadonly(mt, true)
    end
    
    -- Kill remote spies
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            if remote.Name:lower():find("report") or remote.Name:lower():find("ban") or remote.Name:lower():find("log") then
                remote:Destroy()
            end
        end
    end
end

-- // FUCKING LOCATIONS (ALL OF THEM BITCH) //
local Locations = {
    -- Police shit
    Police = {
        Station = CFrame.new(640, 18, -460),
        HeliPad = CFrame.new(620, 45, -480),
        Jail = CFrame.new(810, 18, -380),
        Armory = CFrame.new(625, 18, -445),
        Garage = CFrame.new(580, 18, -420),
        Roof = CFrame.new(640, 50, -460),
    },
    -- Criminal shit
    Criminals = {
        Base = CFrame.new(-235, 18, 1610),
        Hideout = CFrame.new(-480, 18, -770),
        BlackMarket = CFrame.new(-650, 18, 780),
        DrugDealer = CFrame.new(-700, 18, 800),
    },
    -- Bank robbery shit
    Bank = {
        Entrance = CFrame.new(20, 18, 785),
        Vault = CFrame.new(20, 18, 790),
        Roof = CFrame.new(10, 85, 770),
        Escape = CFrame.new(-10, 18, 770),
        LaserRoom = CFrame.new(20, 18, 783),
        MoneyArea = CFrame.new(20, 18, 788),
        BackDoor = CFrame.new(-30, 18, 785),
    },
    -- Jewelry store shit
    Jewelry = {
        Entrance = CFrame.new(133, 18, 1315),
        Boxes = CFrame.new(130, 18, 1315),
        Roof = CFrame.new(133, 100, 1315),
        TurnIn = CFrame.new(-235, 18, 1610),
        BackRoom = CFrame.new(140, 18, 1310),
    },
    -- Museum shit
    Museum = {
        Entrance = CFrame.new(1060, 101, 1230),
        Mummy = CFrame.new(1060, 101, 1250),
        Painting = CFrame.new(1055, 101, 1245),
        Diamond = CFrame.new(1070, 101, 1240),
        TurnIn = CFrame.new(1630, 50, -1760),
    },
    -- Train shit
    Train = {
        Start = CFrame.new(730, 18, 2190),
        Cargo = CFrame.new(750, 18, 2200),
        End = CFrame.new(-500, 18, 2190),
    },
    -- Cargo plane shit
    CargoPlane = {
        Landing = CFrame.new(-2120, 120, 320),
        Crate = CFrame.new(-2120, 115, 330),
        Parachute = CFrame.new(-2120, 130, 320),
    },
    -- Power plant shit
    PowerPlant = {
        Entrance = CFrame.new(-480, 18, 2230),
        Generator = CFrame.new(-480, 18, 2240),
        ControlRoom = CFrame.new(-470, 18, 2250),
        Roof = CFrame.new(-480, 60, 2240),
    },
    -- Casino shit
    Casino = {
        Entrance = CFrame.new(-850, 18, 520),
        Vault = CFrame.new(-860, 18, 530),
        Roof = CFrame.new(-850, 60, 520),
    },
    -- Stores shit
    Merchant = {
        GunShop = CFrame.new(-665, 18, 765),
        DonutShop = CFrame.new(267, 18, -1763),
        GasStation = CFrame.new(-1583, 18, 715),
    },
    -- Escape shit
    Escape = {
        Tunnel = CFrame.new(-1200, 18, -500),
        Volcano = CFrame.new(1630, 50, -1760),
        Sewer = CFrame.new(120, 5, 70),
        Helicopter = CFrame.new(-480, 45, -770),
    },
    -- Safe spots
    Safe = {
        CriminalBase = CFrame.new(-235, 18, 1610),
        PoliceStation = CFrame.new(640, 18, -460),
        Hospital = CFrame.new(350, 18, -250),
    }
}

-- // FUCKING UTILITIES (USEFUL SHIT) //

local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local dist = (hrp.Position - cf.Position).Magnitude
    local time = math.max(0.1, dist / speed)
    local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
    return true
end

local function TeleportTo(cf)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

local function GetNearestPlayer(range, teamFilter)
    local nearest = nil
    local shortest = range
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if teamFilter then
                if teamFilter == "Police" and player.Team and player.Team.Name == "Police" then
                    -- Good for cops
                elseif teamFilter == "Criminals" and player.Team and player.Team.Name == "Criminals" then
                    -- Good for criminals
                else
                    goto continue
                end
            end
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = player
                end
            end
            ::continue::
        end
    end
    return nearest, shortest
end

local function AttackPlayer(player)
    if not player or not player.Character then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and targetHrp then
        -- Teleport to them like a bitch
        hrp.CFrame = CFrame.new(targetHrp.Position + Vector3.new(0, 0, 3), targetHrp.Position)
        task.wait(0.05)
        -- Punch that motherfucker
        local punchRemote = ReplicatedStorage:FindFirstChild("Punch") or ReplicatedStorage:FindFirstChild("Melee")
        if punchRemote then
            punchRemote:FireServer(targetHrp.Position)
        end
        -- Gun shit
        local shootRemote = ReplicatedStorage:FindFirstChild("Shoot") or ReplicatedStorage:FindFirstChild("Fire")
        if shootRemote and Settings.AutoGun then
            shootRemote:FireServer(targetHrp.Position)
        end
    end
end

local function GetPlayersInRange(range, includeCops, includePrisoners)
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local isCop = player.Team and player.Team.Name == "Police"
            local isPrisoner = player.Team and player.Team.Name == "Prisoners"
            
            if (includeCops and isCop) or (includePrisoners and isPrisoner) then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, player)
                    end
                end
            end
        end
    end
    return targets
end

-- // FUCKING FLY SYSTEM (BETTER THAN ANY EXECUTOR FLY) //
local function ToggleFly()
    Settings.Flying = not Settings.Flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if Settings.Flying then
        -- Kill humanoid controls so they don't fuck with flight
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = true
        end
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "EliteGyroFuck"
        bg.P = 9e4
        bg.D = 500
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "EliteVelocityFuck"
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
                
                -- Double speed with Ctrl
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then speed = speed * 2 end
                
                if control.Magnitude > 0 then control = control.Unit end
                bg.cframe = CFrame.new(hrp.Position, hrp.Position + control)
                bv.velocity = control * speed
                
                -- Keep platform stand on
                local hum2 = char:FindFirstChild("Humanoid")
                if hum2 then hum2.PlatformStand = true end
            end
            if hrp:FindFirstChild("EliteGyroFuck") then hrp.EliteGyroFuck:Destroy() end
            if hrp:FindFirstChild("EliteVelocityFuck") then hrp.EliteVelocityFuck:Destroy() end
            local hum3 = char:FindFirstChild("Humanoid")
            if hum3 then hum3.PlatformStand = false end
        end)
    else
        if hrp:FindFirstChild("EliteGyroFuck") then hrp.EliteGyroFuck:Destroy() end
        if hrp:FindFirstChild("EliteVelocityFuck") then hrp.EliteVelocityFuck:Destroy() end
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- // FUCKING NOCLIP (WALK THROUGH WALLS LIKE A GHOST) //
local noclipConnection = nil
local function ToggleNoclip()
    Settings.Noclip = not Settings.Noclip
    if Settings.Noclip then
        noclipConnection = RunService.RenderStepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

-- // FUCKING ESP (SEE THOSE BITCHES THROUGH WALLS) //
local espObjects = {}
local function CreateESP(player)
    if not player.Character then return end
    local color = Settings.ESPColor
    if Settings.ESPTeamColors and player.Team then
        if player.Team.Name == "Police" then
            color = Color3.fromRGB(0, 100, 255)
        elseif player.Team.Name == "Criminals" then
            color = Color3.fromRGB(255, 50, 50)
        end
    end
    
    if Settings.ESPType == "Highlight" then
        local highlight = Instance.new("Highlight")
        highlight.Name = "EliteESP"
        highlight.FillColor = color
        highlight.FillTransparency = 0.6
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.OutlineTransparency = 0.2
        highlight.Parent = player.Character
        espObjects[player] = highlight
    elseif Settings.ESPType == "Box" then
        -- Box ESP would go here but that's more complex, using highlight for now
        local highlight = Instance.new("Highlight")
        highlight.Name = "EliteESP"
        highlight.FillColor = color
        highlight.FillTransparency = 0.8
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
        espObjects[player] = highlight
    end
end

local function RemoveESP(player)
    if espObjects[player] then 
        pcall(function() espObjects[player]:Destroy() end)
        espObjects[player] = nil
    end
end

local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP then
                if player.Character and not espObjects[player] then
                    CreateESP(player)
                elseif not player.Character and espObjects[player] then
                    RemoveESP(player)
                end
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
Players.PlayerRemoving:Connect(RemoveESP)

-- // FULLBRIGHT SHIT (SEE IN THE DARK) //
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
    end
end

-- // AUTO TEAM SHIT //
local function AutoTeam()
    if Settings.AutoTeam == "Criminals" then
        local criminalTeam = Teams:FindFirstChild("Criminals")
        if criminalTeam and LP.Team ~= criminalTeam then
            LP.Team = criminalTeam
        end
    elseif Settings.AutoTeam == "Police" then
        local policeTeam = Teams:FindFirstChild("Police")
        if policeTeam and LP.Team ~= policeTeam then
            LP.Team = policeTeam
        end
    end
end

-- // HEAL WITH DONUTS (NOM NOM MOTHERFUCKER) //
local function AutoHeal()
    if not Settings.AutoDonut then return end
    local hum = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hum and hum.Health < 80 then
        TweenTo(Locations.Merchant.DonutShop, 60)
        task.wait(1)
        -- Buy donut logic
        task.wait(0.5)
        -- Eat donut
        for _, item in pairs(LP.Backpack:GetChildren()) do
            if item.Name:lower():find("donut") then
                -- Use donut
            end
        end
    end
end

-- // FUCKING KILL AURA (AUTOMATICALLY KILL ANYONE NEAR YOU) //
task.spawn(function()
    while task.wait(Settings.KillAuraDelay) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local cops = GetPlayersInRange(Settings.KillAuraRange, true, false)
                local prisoners = GetPlayersInRange(Settings.KillAuraRange, false, true)
                
                for _, target in pairs(cops) do
                    AttackPlayer(target)
                    task.wait(0.05)
                end
                for _, target in pairs(prisoners) do
                    AttackPlayer(target)
                    task.wait(0.05)
                end
            end
        end)
    end
end)

-- // FUCKING AUTO FARM COPS (HUNT THOSE BITCHES DOWN) //
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarmCops and LP.Character then
                local nearest, dist = GetNearestPlayer(100, "Police")
                if nearest and dist then
                    if dist > 15 then
                        local hrp = nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            TweenTo(hrp.CFrame, 70)
                        end
                    else
                        AttackPlayer(nearest)
                    end
                end
            end
        end)
    end
end)

-- // FUCKING AUTO FARM PRISONERS (BEAT THOSE INMATES) //
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarmPrisoners and LP.Character then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character and player.Team and player.Team.Name == "Prisoners" then
                        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and targetHrp then
                            local dist = (hrp.Position - targetHrp.Position).Magnitude
                            if dist > 15 then
                                TweenTo(targetHrp.CFrame, 70)
                            elseif dist < 10 then
                                AttackPlayer(player)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- // AUTO ROBBERY SHIT (STEAL EVERYTHING) //
task.spawn(function()
    while task.wait(Settings.RobberyDelay) do
        pcall(function()
            if not LP.Character then return end
            
            -- Bank robbery
            if Settings.AutoRobBank then
                local bank = Workspace:FindFirstChild("Banks")
                if bank and bank:GetAttribute("Open") then
                    TweenTo(Locations.Bank.Roof, 100)
                    task.wait(0.5)
                    TweenTo(Locations.Bank.Vault, 80)
                    task.wait(15)
                    TweenTo(Locations.Bank.Escape, 80)
                end
            end
            
            -- Jewelry robbery
            if Settings.AutoRobJewelry then
                local jewelry = Workspace:FindFirstChild("Jewelrys")
                if jewelry and jewelry:GetAttribute("Open") then
                    TweenTo(Locations.Jewelry.Roof, 100)
                    task.wait(0.5)
                    TweenTo(Locations.Jewelry.Boxes, 80)
                    task.wait(12)
                    TweenTo(Locations.Jewelry.TurnIn, 100)
                end
            end
            
            -- Museum robbery
            if Settings.AutoRobMuseum then
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

-- // MOVEMENT LOOP (KEEP SPEEDS SET) //
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

-- // ANTI RAGDOLL (FUCK GETTING STUNNED) //
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

-- // CREATE FUCKING UI (EXACT COPY OF THE PIC) //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
MainFrame.BackgroundColor3 = Settings.Themes[Settings.Theme].BgColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ELITE HUB v1.0.0 | 60 FPS"
TitleLabel.TextColor3 = Settings.Themes[Settings.Theme].Color
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 11TitleLabel.Parent = TopBar
fpsLabel = TitleLabel

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scroll Frame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -42)
Scroll.Position = UDim2.new(0, 5, 0, 37)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame

local Layout2 = Instance.new("UIListLayout")
Layout2.Padding = UDim.new(0, 6)
Layout2.SortOrder = Enum.SortOrder.LayoutOrder
Layout2.Parent = Scroll

-- Function to create sections
local function CreateSection(parent, title, yOffset)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 38)
    section.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 18)
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Settings.Themes[Settings.Theme].Color
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -10, 0, 14)
    subLabel.Position = UDim2.new(0, 8, 0, 20)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "Auto rolls, enchants, merchant, and skill tree."
    subLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 9
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = section
    
    return section
end

-- AUTOMATION SECTION
local AutoSection2 = CreateSection(Scroll, "⚡ AUTOMATION")

-- AUTO ROLLS SECTION (EXACT COPY OF PIC)
local RollsSection2 = Instance.new("Frame")
RollsSection2.Size = UDim2.new(1, 0, 0, 170)
RollsSection2.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
RollsSection2.Parent = Scroll

local RollsCorner = Instance.new("UICorner")
RollsCorner.CornerRadius = UDim.new(0, 5)
RollsCorner.Parent = RollsSection2

local RollsTitle2 = Instance.new("TextLabel")
RollsTitle2.Size = UDim2.new(1, -10, 0, 18)
RollsTitle2.Position = UDim2.new(0, 8, 0, 4)
RollsTitle2.BackgroundTransparency = 1
RollsTitle2.Text = "🎲 AUTO ROLLS"
RollsTitle2.TextColor3 = Settings.Themes[Settings.Theme].Color
RollsTitle2.Font = Enum.Font.GothamBold
RollsTitle2.TextSize = 12
RollsTitle2.TextXAlignment = Enum.TextXAlignment.Left
RollsTitle2.Parent = RollsSection2

local RollsSub2 = Instance.new("TextLabel")
RollsSub2.Size = UDim2.new(1, -10, 0, 14)
RollsSub2.Position = UDim2.new(0, 8, 0, 20)
RollsSub2.BackgroundTransparency = 1
RollsSub2.Text = "Auto roll for desired traits, races, clans, and bloodlines."
RollsSub2.TextColor3 = Color3.fromRGB(130, 130, 150)
RollsSub2.Font = Enum.Font.Gotham
RollsSub2.TextSize = 9
RollsSub2.TextXAlignment = Enum.TextXAlignment.Left
RollsSub2.Parent = RollsSection2

local function MakeRow(parent, y, label, value)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 22)
    row.Position = UDim2.new(0, 5, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 110, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, -120, 1, 0)
    val.Position = UDim2.new(0, 115, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = value
    val.TextColor3 = Settings.Themes[Settings.Theme].Color
    val.Font = Enum.Font.GothamBold
    val.TextSize = 10
    val.TextXAlignment = Enum.TextXAlignment.Left
    val.Parent = row
    
    return val
end

MakeRow(RollsSection2, 40, "Target Trails:", "None")
MakeRow(RollsSection2, 62, "Auto Roll Trails:", "None")
MakeRow(RollsSection2, 84, "Target Race:", "None")
MakeRow(RollsSection2, 106, "Auto Roll Race:", "None")
MakeRow(RollsSection2, 128, "Target Clan:", "None")
MakeRow(RollsSection2, 150, "Auto Roll Clan:", "None")

-- SKILL TREE SECTION
local SkillSection2 = Instance.new("Frame")
SkillSection2.Size = UDim2.new(1, 0, 0, 150)
SkillSection2.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
SkillSection2.Parent = Scroll

local SkillCorner2 = Instance.new("UICorner")
SkillCorner2.CornerRadius = UDim.new(0, 5)
SkillCorner2.Parent = SkillSection2

local SkillTitle2 = Instance.new("TextLabel")
SkillTitle2.Size = UDim2.new(1, -10, 0, 18)
SkillTitle2.Position = UDim2.new(0, 8, 0, 4)
SkillTitle2.BackgroundTransparency = 1
SkillTitle2.Text = "🌳 SKILL TREE"
SkillTitle2.TextColor3 = Settings.Themes[Settings.Theme].Color
SkillTitle2.Font = Enum.Font.GothamBold
SkillTitle2.TextSize = 12
SkillTitle2.TextXAlignment = Enum.TextXAlignment.Left
SkillTitle2.Parent = SkillSection2

local SkillSub2 = Instance.new("TextLabel")
SkillSub2.Size = UDim2.new(1, -10, 0, 14)
SkillSub2.Position = UDim2.new(0, 8, 0, 20)
SkillSub2.BackgroundTransparency = 1
SkillSub2.Text = "Upgrade skill tree nodes. Requires skill points."
SkillSub2.TextColor3 = Color3.fromRGB(130, 130, 150)
SkillSub2.Font = Enum.Font.Gotham
SkillSub2.TextSize = 9
SkillSub2.TextXAlignment = Enum.TextXAlignment.Left
SkillSub2.Parent = SkillSection2

local nodeRow = Instance.new("Frame")
nodeRow.Size = UDim2.new(1, -10, 0, 22)
nodeRow.Position = UDim2.new(0, 5, 0, 40)
nodeRow.BackgroundTransparency = 1
nodeRow.Parent = SkillSection2

local nodeLabel = Instance.new("TextLabel")
nodeLabel.Size = UDim2.new(0, 90, 1, 0)
nodeLabel.BackgroundTransparency = 1
nodeLabel.Text = "Node Index:"
nodeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
nodeLabel.Font = Enum.Font.Gotham
nodeLabel.TextSize = 10
nodeLabel.TextXAlignment = Enum.TextXAlignment.Left
nodeLabel.Parent = nodeRow

local nodeValue = Instance.new("TextButton")
nodeValue.Size = UDim2.new(0, 40, 1, 0)
nodeValue.Position = UDim2.new(0, 95, 0, 0)
nodeValue.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
nodeValue.Text = "1"
nodeValue.TextColor3 = Settings.Themes[Settings.Theme].Color
nodeValue.Font = Enum.Font.GothamBold
nodeValue.TextSize = 10
nodeValue.Parent = nodeRow

local nodeCorner = Instance.new("UICorner")
nodeCorner.CornerRadius = UDim.new(0, 3)
nodeCorner.Parent = nodeValue

local upgradeRow = Instance.new("Frame")
upgradeRow.Size = UDim2.new(1, -10, 0, 22)
upgradeRow.Position = UDim2.new(0, 5, 0, 62)
upgradeRow.BackgroundTransparency = 1
upgradeRow.Parent = SkillSection2

local upgradeLabel = Instance.new("TextLabel")
upgradeLabel.Size = UDim2.new(0, 90, 1, 0)
upgradeLabel.BackgroundTransparency = 1
upgradeLabel.Text = "Upgrade Node:"
upgradeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
upgradeLabel.Font = Enum.Font.Gotham
upgradeLabel.TextSize = 10
upgradeLabel.TextXAlignment = Enum.TextXAlignment.Left
upgradeLabel.Parent = upgradeRow

local upgradeValue = Instance.new("TextLabel")
upgradeValue.Size = UDim2.new(1, -100, 1, 0)
upgradeValue.Position = UDim2.new(0, 100, 0, 0)
upgradeValue.BackgroundTransparency = 1
upgradeValue.Text = "None"
upgradeValue.TextColor3 = Color3.fromRGB(150, 150, 170)
upgradeValue.Font = Enum.Font.Gotham
upgradeValue.TextSize = 10
upgradeValue.TextXAlignment = Enum.TextXAlignment.Left
upgradeValue.Parent = upgradeRow

local autoUpgradeBtn = Instance.new("TextButton")
autoUpgradeBtn.Size = UDim2.new(1, -10, 0, 28)
autoUpgradeBtn.Position = UDim2.new(0, 5, 0, 88)
autoUpgradeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
autoUpgradeBtn.Text = "Auto Upgrade Nodes"
autoUpgradeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
autoUpgradeBtn.Font = Enum.Font.GothamBold
autoUpgradeBtn.TextSize = 10
autoUpgradeBtn.Parent = SkillSection2

local autoCorner2 = Instance.new("UICorner")
autoCorner2.CornerRadius = UDim.new(0, 4)
autoCorner2.Parent = autoUpgradeBtn

local priorityRow = Instance.new("Frame")
priorityRow.Size = UDim2.new(1, -10, 0, 22)
priorityRow.Position = UDim2.new(0, 5, 0, 120)
priorityRow.BackgroundTransparency = 1
priorityRow.Parent = SkillSection2

local priorityLabel = Instance.new("TextLabel")
priorityLabel.Size = UDim2.new(0, 100, 1, 0)
priorityLabel.BackgroundTransparency = 1
priorityLabel.Text = "Auto Skill Tree:"
priorityLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
priorityLabel.Font = Enum.Font.Gotham
priorityLabel.TextSize = 10
priorityLabel.TextXAlignment = Enum.TextXAlignment.Left
priorityLabel.Parent = priorityRow

local priorityValue = Instance.new("TextButton")
priorityValue.Size = UDim2.new(0, 70, 1, 0)
priorityValue.Position = UDim2.new(0, 105, 0, 0)
priorityValue.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
priorityValue.Text = "Attack"
priorityValue.TextColor3 = Settings.Themes[Settings.Theme].Color
priorityValue.Font = Enum.Font.GothamBold
priorityValue.TextSize = 10
priorityValue.Parent = priorityRow

local priorityCorner = Instance.new("UICorner")
priorityCorner.CornerRadius = UDim.new(0, 3)
priorityCorner.Parent = priorityValue

-- MERCHANT SECTION
local MerchantSection2 = Instance.new("Frame")
MerchantSection2.Size = UDim2.new(1, 0, 0, 100)
MerchantSection2.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MerchantSection2.Parent = Scroll

local MerchantCorner2 = Instance.new("UICorner")
MerchantCorner2.CornerRadius = UDim.new(0, 5)
MerchantCorner2.Parent = MerchantSection2

local MerchantTitle2 = Instance.new("TextLabel")
MerchantTitle2.Size = UDim2.new(1, -10, 0, 18)
MerchantTitle2.Position = UDim2.new(0, 8, 0, 4)
MerchantTitle2.BackgroundTransparency = 1
MerchantTitle2.Text = "💰 MERCHANT"
MerchantTitle2.TextColor3 = Settings.Themes[Settings.Theme].Color
MerchantTitle2.Font = Enum.Font.GothamBold
MerchantTitle2.TextSize = 12
MerchantTitle2.TextXAlignment = Enum.TextXAlignment.Left
MerchantTitle2.Parent = MerchantSection2

local MerchantSub2 = Instance.new("TextLabel")
MerchantSub2.Size = UDim2.new(1, -10, 0, 14)
MerchantSub2.Position = UDim2.new(0, 8, 0, 20)
MerchantSub2.BackgroundTransparency = 1
MerchantSub2.Text = "Automatically visits the Merchant NPC and buys items."
MerchantSub2.TextColor3 = Color3.fromRGB(130, 130, 150)
MerchantSub2.Font = Enum.Font.Gotham
MerchantSub2.TextSize = 9
MerchantSub2.TextXAlignment = Enum.TextXAlignment.Left
MerchantSub2.Parent = MerchantSection2

local autoMerchantBtn2 = Instance.new("TextButton")
autoMerchantBtn2.Size = UDim2.new(1, -10, 0, 28)
autoMerchantBtn2.Position = UDim2.new(0, 5, 0, 42)
autoMerchantBtn2.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
autoMerchantBtn2.Text = "Auto Buy from Merchant:"
autoMerchantBtn2.TextColor3 = Color3.fromRGB(200, 200, 220)
autoMerchantBtn2.Font = Enum.Font.GothamBold
autoMerchantBtn2.TextSize = 10
autoMerchantBtn2.Parent = MerchantSection2

local merchantCorner2 = Instance.new("UICorner")
merchantCorner2.CornerRadius = UDim.new(0, 4)
merchantCorner2.Parent = autoMerchantBtn2

local teleportRow2 = Instance.new("Frame")
teleportRow2.Size = UDim2.new(1, -10, 0, 22)
teleportRow2.Position = UDim2.new(0, 5, 0, 74)
teleportRow2.BackgroundTransparency = 1
teleportRow2.Parent = MerchantSection2

local teleportLabel2 = Instance.new("TextLabel")
teleportLabel2.Size = UDim2.new(1, 0, 1, 0)
teleportLabel2.BackgroundTransparency = 1
teleportLabel2.Text = "Teleports to merchant each cycle"
teleportLabel2.TextColor3 = Color3.fromRGB(130, 130, 150)
teleportLabel2.Font = Enum.Font.Gotham
teleportLabel2.TextSize = 9
teleportLabel2.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel2.Parent = teleportRow2

-- COMBAT SECTION (NEW)
local CombatSection = Instance.new("Frame")
CombatSection.Size = UDim2.new(1, 0, 0, 160)
CombatSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
CombatSection.Parent = Scroll

local CombatCorner = Instance.new("UICorner")
CombatCorner.CornerRadius = UDim.new(0, 5)
CombatCorner.Parent = CombatSection

local CombatTitle = Instance.new("TextLabel")
CombatTitle.Size = UDim2.new(1, -10, 0, 18)
CombatTitle.Position = UDim2.new(0, 8, 0, 4)
CombatTitle.BackgroundTransparency = 1
CombatTitle.Text = "⚔️ COMBAT"
CombatTitle.TextColor3 = Settings.Themes[Settings.Theme].Color
CombatTitle.Font = Enum.Font.GothamBold
CombatTitle.TextSize = 12
CombatTitle.TextXAlignment = Enum.TextXAlignment.Left
CombatTitle.Parent = CombatSection

local killAuraRow = Instance.new("Frame")
killAuraRow.Size = UDim2.new(1, -10, 0, 22)
killAuraRow.Position = UDim2.new(0, 5, 0, 28)
killAuraRow.BackgroundTransparency = 1
killAuraRow.Parent = CombatSection

local killAuraLabel = Instance.new("TextLabel")
killAuraLabel.Size = UDim2.new(0, 100, 1, 0)
killAuraLabel.BackgroundTransparency = 1
killAuraLabel.Text = "Kill Aura:"
killAuraLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
killAuraLabel.Font = Enum.Font.Gotham
killAuraLabel.TextSize = 10
killAuraLabel.TextXAlignment = Enum.TextXAlignment.Left
killAuraLabel.Parent = killAuraRow

local killAuraBtn = Instance.new("TextButton")
killAuraBtn.Size = UDim2.new(0, 50, 1, 0)
killAuraBtn.Position = UDim2.new(0, 105, 0, 0)
killAuraBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
killAuraBtn.Text = "OFF"
killAuraBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
killAuraBtn.Font = Enum.Font.GothamBold
killAuraBtn.TextSize = 10
killAuraBtn.Parent = killAuraRow

local killAuraCorner = Instance.new("UICorner")
killAuraCorner.CornerRadius = UDim.new(0, 3)
killAuraCorner.Parent = killAuraBtn

local autoAttackRow = Instance.new("Frame")
autoAttackRow.Size = UDim2.new(1, -10, 0, 22)
autoAttackRow.Position = UDim2.new(0, 5, 0, 52)
autoAttackRow.BackgroundTransparency = 1
autoAttackRow.Parent = CombatSection

local autoAttackLabel = Instance.new("TextLabel")
autoAttackLabel.Size = UDim2.new(0, 100, 1, 0)
autoAttackLabel.BackgroundTransparency = 1
autoAttackLabel.Text = "Auto Attack:"
autoAttackLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
autoAttackLabel.Font = Enum.Font.Gotham
autoAttackLabel.TextSize = 10
autoAttackLabel.TextXAlignment = Enum.TextXAlignment.Left
autoAttackLabel.Parent = autoAttackRow

local autoAttackBtn = Instance.new("TextButton")
autoAttackBtn.Size = UDim2.new(0, 50, 1, 0)
autoAttackBtn.Position = UDim2.new(0, 105, 0, 0)
autoAttackBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
autoAttackBtn.Text = "OFF"
autoAttackBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
autoAttackBtn.Font = Enum.Font.GothamBold
autoAttackBtn.TextSize = 10
autoAttackBtn.Parent = autoAttackRow

local autoAttackCorner = Instance.new("UICorner")
autoAttackCorner.CornerRadius = UDim.new(0, 3)
autoAttackCorner.Parent = autoAttackBtn

local aimAssistRow = Instance.new("Frame")
aimAssistRow.Size = UDim2.new(1, -10, 0, 22)
aimAssistRow.Position = UDim2.new(0, 5, 0, 76)
aimAssistRow.BackgroundTransparency = 1
aimAssistRow.Parent = CombatSection

local aimAssistLabel = Instance.new("TextLabel")
aimAssistLabel.Size = UDim2.new(0, 100, 1, 0)
aimAssistLabel.BackgroundTransparency = 1
aimAssistLabel.Text = "Aim Assist:"
aimAssistLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
aimAssistLabel.Font = Enum.Font.Gotham
aimAssistLabel.TextSize = 10
aimAssistLabel.TextXAlignment = Enum.TextXAlignment.Left
aimAssistLabel.Parent = aimAssistRow

local aimAssistBtn = Instance.new("TextButton")
aimAssistBtn.Size = UDim2.new(0, 50, 1, 0)
aimAssistBtn.Position = UDim2.new(0, 105, 0, 0)
aimAssistBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
aimAssistBtn.Text = "OFF"
aimAssistBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
aimAssistBtn.Font = Enum.Font.GothamBold
aimAssistBtn.TextSize = 10
aimAssistBtn.Parent = aimAssistRow

local aimAssistCorner = Instance.new("UICorner")
aimAssistCorner.CornerRadius = UDim.new(0, 3)
aimAssistCorner.Parent = aimAssistBtn

local meleeRow = Instance.new("Frame")
meleeRow.Size = UDim2.new(1, -10, 0, 22)
meleeRow.Position = UDim2.new(0, 5, 0, 100)
meleeRow.BackgroundTransparency = 1
meleeRow.Parent = CombatSection

local meleeLabel = Instance.new("TextLabel")
meleeLabel.Size = UDim2.new(0, 100, 1, 0)
meleeLabel.BackgroundTransparency = 1
meleeLabel.Text = "Melee Range:"
meleeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
meleeLabel.Font = Enum.Font.Gotham
meleeLabel.TextSize = 10
meleeLabel.TextXAlignment = Enum.TextXAlignment.Left
meleeLabel.Parent = meleeRow

local meleeValue = Instance.new("TextButton")
meleeValue.Size = UDim2.new(0, 50, 1, 0)
meleeValue.Position = UDim2.new(0, 105, 0, 0)
meleeValue.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
meleeValue.Text = "15"
meleeValue.TextColor3 = Settings.Themes[Settings.Theme].Color
meleeValue.Font = Enum.Font.GothamBold
meleeValue.TextSize = 10
meleeValue.Parent = meleeRow

local meleeCorner = Instance.new("UICorner")
meleeCorner.CornerRadius = UDim.new(0, 3)
meleeCorner.Parent = meleeValue

local weaponModsRow = Instance.new("Frame")
weaponModsRow.Size = UDim2.new(1, -10, 0, 22)
weaponModsRow.Position = UDim2.new(0, 5, 0, 124)
weaponModsRow.BackgroundTransparency = 1
weaponModsRow.Parent = CombatSection

local weaponModsLabel = Instance.new("TextLabel")
weaponModsLabel.Size = UDim2.new(0, 100, 1, 0)
weaponModsLabel.BackgroundTransparency = 1
weaponModsLabel.Text = "No Recoil/Spread:"
weaponModsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
weaponModsLabel.Font = Enum.Font.Gotham
weaponModsLabel.TextSize = 10
weaponModsLabel.TextXAlignment = Enum.TextXAlignment.Left
weaponModsLabel.Parent = weaponModsRow

local weaponModsBtn = Instance.new("TextButton")
weaponModsBtn.Size = UDim2.new(0, 50, 1, 0)
weaponModsBtn.Position = UDim2.new(0, 105, 0, 0)
weaponModsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
weaponModsBtn.Text = "OFF"
weaponModsBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
weaponModsBtn.Font = Enum.Font.GothamBold
weaponModsBtn.TextSize = 10
weaponModsBtn.Parent = weaponModsRow

local weaponCorner = Instance.new("UICorner")
weaponCorner.CornerRadius = UDim.new(0, 3)
weaponCorner.Parent = weaponModsBtn

-- VISUAL SECTION
local VisualSection = Instance.new("Frame")
VisualSection.Size = UDim2.new(1, 0, 0, 130)
VisualSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
VisualSection.Parent = Scroll

local VisualCorner = Instance.new("UICorner")
VisualCorner.CornerRadius = UDim.new(0, 5)
VisualCorner.Parent = VisualSection

local VisualTitle = Instance.new("TextLabel")
VisualTitle.Size = UDim2.new(1, -10, 0, 18)
VisualTitle.Position = UDim2.new(0, 8, 0, 4)
VisualTitle.BackgroundTransparency = 1
VisualTitle.Text = "👁️ VISUALS"
VisualTitle.TextColor3 = Settings.Themes[Settings.Theme].Color
VisualTitle.Font = Enum.Font.GothamBold
VisualTitle.TextSize = 12
VisualTitle.TextXAlignment = Enum.TextXAlignment.Left
VisualTitle.Parent = VisualSection

local espRow = Instance.new("Frame")
espRow.Size = UDim2.new(1, -10, 0, 22)
espRow.Position = UDim2.new(0, 5, 0, 28)
espRow.BackgroundTransparency = 1
espRow.Parent = VisualSection

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0, 100, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "ESP (Wallhack):"
espLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
espLabel.Font = Enum.Font.Gotham
espLabel.TextSize = 10
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = espRow

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 50, 1, 0)
espBtn.Position = UDim2.new(0, 105, 0, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
espBtn.Text = "OFF"
espBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 10
espBtn.Parent = espRow

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 3)
espCorner.Parent = espBtn

local fullbrightRow = Instance.new("Frame")
fullbrightRow.Size = UDim2.new(1, -10, 0, 22)
fullbrightRow.Position = UDim2.new(0, 5, 0, 52)
fullbrightRow.BackgroundTransparency = 1
fullbrightRow.Parent = VisualSection

local fullbrightLabel = Instance.new("TextLabel")
fullbrightLabel.Size = UDim2.new(0, 100, 1, 0)
fullbrightLabel.BackgroundTransparency = 1
fullbrightLabel.Text = "Full Bright:"
fullbrightLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
fullbrightLabel.Font = Enum.Font.Gotham
fullbrightLabel.TextSize = 10
fullbrightLabel.TextXAlignment = Enum.TextXAlignment.Left
fullbrightLabel.Parent = fullbrightRow

local fullbrightBtn = Instance.new("TextButton")
fullbrightBtn.Size = UDim2.new(0, 50, 1, 0)
fullbrightBtn.Position = UDim2.new(0, 105, 0, 0)
fullbrightBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
fullbrightBtn.Text = "OFF"
fullbrightBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
fullbrightBtn.Font = Enum.Font.GothamBold
fullbrightBtn.TextSize = 10
fullbrightBtn.Parent = fullbrightRow

local fullCorner = Instance.new("UICorner")
fullCorner.CornerRadius = UDim.new(0, 3)
fullCorner.Parent = fullbrightBtn

local espColorRow = Instance.new("Frame")
espColorRow.Size = UDim2.new(1, -10, 0, 22)
espColorRow.Position = UDim2.new(0, 5, 0, 76)
espColorRow.BackgroundTransparency = 1
espColorRow.Parent = VisualSection

local espColorLabel = Instance.new("TextLabel")
espColorLabel.Size = UDim2.new(0, 100, 1, 0)
espColorLabel.BackgroundTransparency = 1
espColorLabel.Text = "ESP Color:"
espColorLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
espColorLabel.Font = Enum.Font.Gotham
espColorLabel.TextSize = 10
espColorLabel.TextXAlignment = Enum.TextXAlignment.Left
espColorLabel.Parent = espColorRow

local espColorBtn = Instance.new("TextButton")
espColorBtn.Size = UDim2.new(0, 70, 1, 0)
espColorBtn.Position = UDim2.new(0, 105, 0, 0)
espColorBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
espColorBtn.Text = "Red"
espColorBtn.TextColor3 = Settings.Themes[Settings.Theme].Color
espColorBtn.Font = Enum.Font.GothamBold
espColorBtn.TextSize = 10
espColorBtn.Parent = espColorRow

local espColorCorner = Instance.new("UICorner")
espColorCorner.CornerRadius = UDim.new(0, 3)
espColorCorner.Parent = espColorBtn

local tracersRow = Instance.new("Frame")
tracersRow.Size = UDim2.new(1, -10, 0, 22)
tracersRow.Position = UDim2.new(0, 5, 0, 100)
tracersRow.BackgroundTransparency = 1
tracersRow.Parent = VisualSection

local tracersLabel = Instance.new("TextLabel")
tracersLabel.Size = UDim2.new(0, 100, 1, 0)
tracersLabel.BackgroundTransparency = 1
tracersLabel.Text = "Tracers:"
tracersLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
tracersLabel.Font = Enum.Font.Gotham
tracersLabel.TextSize = 10
tracersLabel.TextXAlignment = Enum.TextXAlignment.Left
tracersLabel.Parent = tracersRow

local tracersBtn = Instance.new("TextButton")
tracersBtn.Size = UDim2.new(0, 50, 1, 0)
tracersBtn.Position = UDim2.new(0, 105, 0, 0)
tracersBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tracersBtn.Text = "OFF"
tracersBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
tracersBtn.Font = Enum.Font.GothamBold
tracersBtn.TextSize = 10
tracersBtn.Parent = tracersRow

local tracerCorner = Instance.new("UICorner")
tracerCorner.CornerRadius = UDim.new(0, 3)
tracerCorner.Parent = tracersBtn

-- SETTINGS/THEME SECTION
local SettingsSection = Instance.new("Frame")
SettingsSection.Size = UDim2.new(1, 0, 0, 100)
SettingsSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
SettingsSection.Parent = Scroll

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 5)
SettingsCorner.Parent = SettingsSection

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, -10, 0, 18)
SettingsTitle.Position = UDim2.new(0, 8, 0, 4)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "⚙️ SETTINGS"
SettingsTitle.TextColor3 = Settings.Themes[Settings.Theme].Color
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 12
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsSection

local themeRow = Instance.new("Frame")
themeRow.Size = UDim2.new(1, -10, 0, 22)
themeRow.Position = UDim2.new(0, 5, 0, 28)
themeRow.BackgroundTransparency = 1
themeRow.Parent = SettingsSection

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(0, 80, 1, 0)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "Theme:"
themeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
themeLabel.Font = Enum.Font.Gotham
themeLabel.TextSize = 10
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = themeRow

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 80, 1, 0)
themeBtn.Position = UDim2.new(0, 85, 0, 0)
themeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
themeBtn.Text = "Emerald"
themeBtn.TextColor3 = Settings.Themes[Settings.Theme].Color
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 10
themeBtn.Parent = themeRow

local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 3)
themeCorner.Parent = themeBtn

local discordRow = Instance.new("Frame")
discordRow.Size = UDim2.new(1, -10, 0, 28)
discordRow.Position = UDim2.new(0, 5, 0, 54)
discordRow.BackgroundTransparency = 1
discordRow.Parent = SettingsSection

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(1, 0, 1, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.Text = "💬 JOIN DISCORD (COPY LINK)"
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 10
discordBtn.Parent = discordRow

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 4)
discordCorner.Parent = discordBtn

discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "DISCORD LINK COPIED YOU BITCH 🥀",
        Duration = 2
    })
end)

-- Update canvas size
local function UpdateCanvas()
    local total = 0
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("Frame") and v ~= Layout2 then
            total = total + v.Size.Y.Offset + 6
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, total + 20)
end

task.wait(0.1)
UpdateCanvas()

-- // BUTTON FUNCTIONALITY //

-- Kill Aura button
local killAuraState = false
killAuraBtn.MouseButton1Click:Connect(function()
    killAuraState = not killAuraState
    Settings.KillAura = killAuraState
    killAuraBtn.Text = killAuraState and "ON" or "OFF"
    killAuraBtn.TextColor3 = killAuraState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    killAuraBtn.BackgroundColor3 = killAuraState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
end)

-- Auto Attack button
local autoAttackState = false
autoAttackBtn.MouseButton1Click:Connect(function()
    autoAttackState = not autoAttackState
    Settings.AutoAttack = autoAttackState
    autoAttackBtn.Text = autoAttackState and "ON" or "OFF"
    autoAttackBtn.TextColor3 = autoAttackState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    autoAttackBtn.BackgroundColor3 = autoAttackState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
end)

-- Aim Assist button
local aimAssistState = false
aimAssistBtn.MouseButton1Click:Connect(function()
    aimAssistState = not aimAssistState
    Settings.AimAssist = aimAssistState
    aimAssistBtn.Text = aimAssistState and "ON" or "OFF"
    aimAssistBtn.TextColor3 = aimAssistState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    aimAssistBtn.BackgroundColor3 = aimAssistState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
end)

-- Melee Range
local meleeValues = {10, 15, 20, 25, 30, 40, 50}
local meleeIndex = 2
meleeValue.MouseButton1Click:Connect(function()
    meleeIndex = meleeIndex % #meleeValues + 1
    Settings.MeleeRange = meleeValues[meleeIndex]
    meleeValue.Text = tostring(Settings.MeleeRange)
end)

-- Weapon Mods button
local weaponModsState = false
weaponModsBtn.MouseButton1Click:Connect(function()
    weaponModsState = not weaponModsState
    Settings.WeaponMods = weaponModsState
    Settings.NoRecoil = weaponModsState
    Settings.NoSpread = weaponModsState
    weaponModsBtn.Text = weaponModsState and "ON" or "OFF"
    weaponModsBtn.TextColor3 = weaponModsState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    weaponModsBtn.BackgroundColor3 = weaponModsState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
end)

-- ESP button
local espState = false
espBtn.MouseButton1Click:Connect(function()
    espState = not espState
    Settings.ESP = espState
    espBtn.Text = espState and "ON" or "OFF"
    espBtn.TextColor3 = espState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    espBtn.BackgroundColor3 = espState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
    UpdateESP()
end)

-- Fullbright button
local fullbrightState = false
fullbrightBtn.MouseButton1Click:Connect(function()
    fullbrightState = not fullbrightState
    Settings.FullBright = fullbrightState
    fullbrightBtn.Text = fullbrightState and "ON" or "OFF"
    fullbrightBtn.TextColor3 = fullbrightState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    fullbrightBtn.BackgroundColor3 = fullbrightState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
    ToggleFullBright()
end)

-- ESP Color button
local espColorsList = {"Red", "Blue", "Green", "Yellow", "Purple", "Orange", "Pink"}
local espColorIndex = 1
espColorBtn.MouseButton1Click:Connect(function()
    espColorIndex = espColorIndex % #espColorsList + 1
    local colorName = espColorsList[espColorIndex]
    espColorBtn.Text = colorName
    local colorMap = {
        Red = Color3.fromRGB(255, 0, 0),
        Blue = Color3.fromRGB(0, 0, 255),
        Green = Color3.fromRGB(0, 255, 0),
        Yellow = Color3.fromRGB(255, 255, 0),
        Purple = Color3.fromRGB(128, 0, 255),
        Orange = Color3.fromRGB(255, 128, 0),
        Pink = Color3.fromRGB(255, 105, 180),
    }
    Settings.ESPColor = colorMap[colorName]
    UpdateESP()
end)

-- Tracers button
local tracersState = false
tracersBtn.MouseButton1Click:Connect(function()
    tracersState = not tracersState
    Settings.Tracer = tracersState
    tracersBtn.Text = tracersState and "ON" or "OFF"
    tracersBtn.TextColor3 = tracersState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    tracersBtn.BackgroundColor3 = tracersState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(30, 30, 40)
end)

-- Theme button
local themeNames = {"Emerald", "Blood", "Royal", "Cyan", "Gold", "Pink", "Purple", "Orange"}
local themeIndex = 1
themeBtn.MouseButton1Click:Connect(function()
    themeIndex = themeIndex % #themeNames + 1
    Settings.Theme = themeNames[themeIndex]
    themeBtn.Text = Settings.Theme
    currentTheme = Settings.Themes[Settings.Theme]
    ApplyTheme()
    -- Update all text colors
    for _, obj in pairs({TitleLabel, AutoTitle, RollsTitle2, SkillTitle2, MerchantTitle2, CombatTitle, VisualTitle, SettingsTitle}) do
        if obj then pcall(function() obj.TextColor3 = currentTheme.Color end) end
    end
    for _, obj in pairs({nodeValue, priorityValue, meleeValue, espColorBtn}) do
        if obj then pcall(function() obj.TextColor3 = currentTheme.Color end) end
    end
end)

-- Auto Upgrade Nodes button
local autoUpgradeState = false
autoUpgradeBtn.MouseButton1Click:Connect(function()
    autoUpgradeState = not autoUpgradeState
    Settings.AutoSkill = autoUpgradeState
    autoUpgradeBtn.Text = autoUpgradeState and "✓ Auto Upgrade Nodes" or "Auto Upgrade Nodes"
    autoUpgradeBtn.TextColor3 = autoUpgradeState and currentTheme.Color or Color3.fromRGB(200, 200, 220)
    autoUpgradeBtn.BackgroundColor3 = autoUpgradeState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(25, 25, 35)
end)

-- Auto Merchant button
local autoMerchantState = false
autoMerchantBtn2.MouseButton1Click:Connect(function()
    autoMerchantState = not autoMerchantState
    Settings.AutoMerchant = autoMerchantState
    autoMerchantBtn2.Text = autoMerchantState and "✓ Auto Buy from Merchant:" or "Auto Buy from Merchant:"
    autoMerchantBtn2.TextColor3 = autoMerchantState and currentTheme.Color or Color3.fromRGB(200, 200, 220)
    autoMerchantBtn2.BackgroundColor3 = autoMerchantState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(25, 25, 35)
end)

-- Node value button
local nodeNum = 1
nodeValue.MouseButton1Click:Connect(function()
    nodeNum = nodeNum % 10 + 1
    nodeValue.Text = tostring(nodeNum)
    Settings.SkillNodeIndex = nodeNum
end)

-- Priority button
local priorities2 = {"Attack", "Defense", "Health", "Fruit", "Sword"}
local prioIndex2 = 1
priorityValue.MouseButton1Click:Connect(function()
    prioIndex2 = prioIndex2 % #priorities2 + 1
    priorityValue.Text = priorities2[prioIndex2]
    Settings.SkillPriority = priorities2[prioIndex2]
end)

-- // FUCKING STARTUP NOTIFICATION //
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "Loaded you fucking bitch! Enjoy the script! 🥀",
    Duration = 3
})

-- // AUTO TEAM ON SPAWN //
LP.CharacterAdded:Connect(function()
    task.wait(1)
    AutoTeam()
end)

-- // FPS AND WATERMARK UPDATE LOOP //
task.spawn(function()
    while task.wait(1) do
        if Settings.ShowFPS and fpsLabel then
            fpsLabel.Text = "ELITE HUB " .. _G.EliteHub.Version .. " | " .. fps .. " FPS"
        elseif fpsLabel then
            fpsLabel.Text = "ELITE HUB " .. _G.EliteHub.Version
        end
    end
end)

print("ELITE HUB v1.0.0 LOADED - GO FUCK SHIT UP 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6")