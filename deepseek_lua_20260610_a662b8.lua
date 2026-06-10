-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // FUCK EVERYONE THIS SHIT IS CLEAN NOW 🥀

-- // LOAD MACLIB
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

-- // CHECK EXECUTOR
local isDelta = game:GetService("CoreGui"):FindFirstChild("Delta") ~= nil
local isSolara = game:GetService("CoreGui"):FindFirstChild("Solara") ~= nil
local isXeno = game:GetService("CoreGui"):FindFirstChild("Xeno") ~= nil

if isSolara or isXeno then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "SOLARA AND XENO ARE RAT INFESTED BITCHES. USE DELTA OR SWIFT 🥀",
        Duration = 5
    })
end

print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - LOADED YOU BITCH 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - JOIN OR GET FUCKED")

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

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // FUCKING SETTINGS
local Settings = {
    -- Automation
    AutoRoll = false,
    AutoEnchant = false,
    AutoMerchant = false,
    AutoSkill = false,
    
    -- Roll Targets
    TargetTraits = "None",
    AutoRollTraits = false,
    TargetRace = "None",
    AutoRollRace = false,
    TargetClan = "None",
    AutoRollClan = false,
    RollCooldown = 0.1,
    
    -- Skill Tree
    NodeIndex = 1,
    UpgradeNode = "None",
    AutoUpgradeNodes = false,
    SkillPriority = "Attack",
    
    -- Merchant
    AutoBuyMerchant = false,
    BuyKeycard = false,
    BuyGun = false,
    
    -- Combat
    KillAura = false,
    KillAuraRange = 35,
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    AutoAttack = false,
    AutoArrest = false,
    AutoTase = false,
    
    -- Robbery
    AutoBank = false,
    AutoJewelry = false,
    AutoMuseum = false,
    AutoTrain = false,
    AutoCargo = false,
    
    -- Movement
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    AutoSprint = false,
    AntiRagdoll = true,
    
    -- Visuals
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    FullBright = false,
    NoFog = false,
    TeamColors = true,
    
    -- Utility
    AutoDonut = false,
    AutoKeycard = false,
    AutoTeam = false,
    AntiAFK = true,
    AutoRevive = false,
    AutoEscape = false,
    
    -- States
    Flying = false,
}

-- // FPS AND MS COUNTER
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

-- // AUTO TEAM
local function AutoTeam()
    if Settings.AutoTeam then
        local criminalTeam = Teams:FindFirstChild("Criminals")
        if criminalTeam and LP.Team ~= criminalTeam then
            LP.Team = criminalTeam
        end
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    AutoTeam()
end)

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
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
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
end

-- // ESP
local espObjects = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local color = Settings.ESPColor
                if Settings.TeamColors and player.Team then
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

-- // LOCATIONS
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
    Merchant = CFrame.new(-25, 18, 250),
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
    while task.wait(0.1) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local targets = {"Police", "Prisoners", "Criminals"}
                for _, team in pairs(targets) do
                    local player, dist = GetNearestPlayer(team)
                    if player and dist <= Settings.KillAuraRange then
                        AttackPlayer(player)
                        task.wait(0.05)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
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
        end)
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
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

-- // CREATE MACLIB UI
MacLib:SetFolder("Elite Hub")

local Window = MacLib:Window({
    Title = "ELITE HUB v1.0.0",
    Subtitle = "FPS: " .. fps .. " | MS: " .. ping .. " | discord.gg/5RuMCxK3u6",
    Size = UDim2.fromOffset(900, 700),
    DragStyle = 1,
    AcrylicBlur = true,
    Keybind = Enum.KeyCode.RightControl,
})

-- Update subtitle with real FPS and MS
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            Window.Settings.Subtitle = "FPS: " .. fps .. " | MS: " .. ping .. " | FUCK JAILBREAK 🥀"
        end)
    end
end)

local tabGroup = Window:TabGroup()

-- // AUTOMATION TAB
local autoTab = tabGroup:Tab({ Name = "AUTOMATION", Image = "rbxassetid://18821914323" })

local autoLeft = autoTab:Section({ Side = "Left" })
local autoRight = autoTab:Section({ Side = "Right" })

autoLeft:Header({ Name = "⚡ AUTO ROLLS" })
autoLeft:Label({ Text = "Auto roll for desired traits, races, clans, and bloodlines." })

autoLeft:Input({
    Name = "Target Traits",
    Placeholder = "Enter trait name",
    Callback = function(input)
        Settings.TargetTraits = input
    end,
})

autoLeft:Toggle({
    Name = "Auto Roll Traits",
    Default = false,
    Callback = function(value)
        Settings.AutoRollTraits = value
    end,
})

autoLeft:Input({
    Name = "Target Race",
    Placeholder = "Enter race name",
    Callback = function(input)
        Settings.TargetRace = input
    end,
})

autoLeft:Toggle({
    Name = "Auto Roll Race",
    Default = false,
    Callback = function(value)
        Settings.AutoRollRace = value
    end,
})

autoLeft:Input({
    Name = "Target Clan",
    Placeholder = "Enter clan name",
    Callback = function(input)
        Settings.TargetClan = input
    end,
})

autoLeft:Toggle({
    Name = "Auto Roll Clan",
    Default = false,
    Callback = function(value)
        Settings.AutoRollClan = value
    end,
})

autoLeft:Slider({
    Name = "Roll Cooldown (sec)",
    Default = 0.1,
    Minimum = 0.05,
    Maximum = 2,
    DisplayMethod = "Value",
    Precision = 2,
    Callback = function(value)
        Settings.RollCooldown = value
    end,
})

autoRight:Header({ Name = "🌳 SKILL TREE" })
autoRight:Label({ Text = "Upgrade skill tree nodes. Requires skill points." })

autoRight:Slider({
    Name = "Node Index",
    Default = 1,
    Minimum = 1,
    Maximum = 50,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        Settings.NodeIndex = math.floor(value)
    end,
})

autoRight:Label({ Text = "Upgrade Node: None" })

autoRight:Toggle({
    Name = "Auto Upgrade Nodes",
    Default = false,
    Callback = function(value)
        Settings.AutoUpgradeNodes = value
    end,
})

local priorities = {"Attack", "Defense", "Health", "Fruit", "Sword"}
autoRight:Dropdown({
    Name = "Auto Skill Tree Priority",
    Multi = false,
    Options = priorities,
    Default = 1,
    Callback = function(value)
        Settings.SkillPriority = value
    end,
})

autoRight:Divider()
autoRight:Header({ Name = "💰 MERCHANT" })
autoRight:Label({ Text = "Automatically visits the Merchant NPC and buys items." })

autoRight:Toggle({
    Name = "Auto Buy from Merchant",
    Default = false,
    Callback = function(value)
        Settings.AutoBuyMerchant = value
    end,
})

autoRight:Label({ Text = "Teleports to merchant each cycle" })

-- // COMBAT TAB
local combatTab = tabGroup:Tab({ Name = "COMBAT", Image = "rbxassetid://18821914323" })

local combatLeft = combatTab:Section({ Side = "Left" })
local combatRight = combatTab:Section({ Side = "Right" })

combatLeft:Header({ Name = "⚔️ KILL THAT MOTHERFUCKER" })

combatLeft:Toggle({
    Name = "💀 KILL AURA",
    Default = false,
    Callback = function(value)
        Settings.KillAura = value
    end,
})

combatLeft:Slider({
    Name = "Kill Aura Range",
    Default = 35,
    Minimum = 10,
    Maximum = 100,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        Settings.KillAuraRange = value
    end,
})

combatLeft:Toggle({
    Name = "👮 AUTO FARM COPS",
    Default = false,
    Callback = function(value)
        Settings.AutoFarmCops = value
    end,
})

combatLeft:Toggle({
    Name = "🔒 AUTO FARM PRISONERS",
    Default = false,
    Callback = function(value)
        Settings.AutoFarmPrisoners = value
    end,
})

combatLeft:Toggle({
    Name = "⚡ AUTO ATTACK",
    Default = false,
    Callback = function(value)
        Settings.AutoAttack = value
    end,
})

combatRight:Header({ Name = "💰 ROBBERY - STEAL THAT SHIT" })

combatRight:Toggle({
    Name = "🏦 AUTO BANK",
    Default = false,
    Callback = function(value)
        Settings.AutoRobBank = value
    end,
})

combatRight:Toggle({
    Name = "💎 AUTO JEWELRY",
    Default = false,
    Callback = function(value)
        Settings.AutoRobJewelry = value
    end,
})

combatRight:Toggle({
    Name = "🏛️ AUTO MUSEUM",
    Default = false,
    Callback = function(value)
        Settings.AutoRobMuseum = value
    end,
})

combatRight:Toggle({
    Name = "🚂 AUTO TRAIN",
    Default = false,
    Callback = function(value)
        Settings.AutoTrain = value
    end,
})

combatRight:Toggle({
    Name = "✈️ AUTO CARGO",
    Default = false,
    Callback = function(value)
        Settings.AutoCargo = value
    end,
})

-- // MOVEMENT TAB
local moveTab = tabGroup:Tab({ Name = "MOVEMENT", Image = "rbxassetid://18821914323" })

local moveLeft = moveTab:Section({ Side = "Left" })
local moveRight = moveTab:Section({ Side = "Right" })

moveLeft:Header({ Name = "🌀 GO FAST AS FUCK" })

moveLeft:Toggle({
    Name = "🕊️ FLY MODE",
    Default = false,
    Callback = function(value)
        Settings.Fly = value
        ToggleFly()
    end,
})

moveLeft:Slider({
    Name = "Fly Speed",
    Default = 85,
    Minimum = 30,
    Maximum = 250,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        Settings.FlySpeed = value
    end,
})

moveLeft:Toggle({
    Name = "🌀 NOCLIP",
    Default = false,
    Callback = function(value)
        Settings.Noclip = value
        ToggleNoclip()
    end,
})

moveLeft:Toggle({
    Name = "🏃 AUTO SPRINT",
    Default = false,
    Callback = function(value)
        Settings.AutoSprint = value
    end,
})

moveLeft:Toggle({
    Name = "🛡️ ANTI RAGDOLL (NO STUN)",
    Default = true,
    Callback = function(value)
        Settings.AntiRagdoll = value
    end,
})

moveRight:Header({ Name = "⚡ STATS" })

moveRight:Slider({
    Name = "Walk Speed",
    Default = 24,
    Minimum = 16,
    Maximum = 200,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        Settings.WalkSpeed = value
    end,
})

moveRight:Slider({
    Name = "Jump Power",
    Default = 65,
    Minimum = 50,
    Maximum = 200,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        Settings.JumpPower = value
    end,
})

-- // VISUALS TAB
local visTab = tabGroup:Tab({ Name = "VISUALS", Image = "rbxassetid://18821914323" })

local visLeft = visTab:Section({ Side = "Left" })
local visRight = visTab:Section({ Side = "Right" })

visLeft:Header({ Name = "👁️ SEE THEIR BITCH ASS" })

visLeft:Toggle({
    Name = "👻 ESP WALLHACK",
    Default = false,
    Callback = function(value)
        Settings.ESP = value
        UpdateESP()
    end,
})

visLeft:Colorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        Settings.ESPColor = color
        UpdateESP()
    end,
})

visLeft:Toggle({
    Name = "🎨 Team Colors",
    Default = true,
    Callback = function(value)
        Settings.TeamColors = value
        UpdateESP()
    end,
})

visLeft:Toggle({
    Name = "☀️ FULLBRIGHT",
    Default = false,
    Callback = function(value)
        Settings.FullBright = value
        ToggleFullBright()
    end,
})

visLeft:Toggle({
    Name = "🌫️ NO FOG",
    Default = false,
    Callback = function(value)
        Settings.NoFog = value
        if value then
            Lighting.FogEnd = 100000
        else
            Lighting.FogEnd = 1000
        end
    end,
})

-- // UTILITY TAB
local utilTab = tabGroup:Tab({ Name = "UTILITY", Image = "rbxassetid://18821914323" })

local utilLeft = utilTab:Section({ Side = "Left" })
local utilRight = utilTab:Section({ Side = "Right" })

utilLeft:Header({ Name = "🛠️ QUALITY OF LIFE SHIT" })

utilLeft:Toggle({
    Name = "🍩 AUTO DONUT (HEAL)",
    Default = false,
    Callback = function(value)
        Settings.AutoDonut = value
    end,
})

utilLeft:Toggle({
    Name = "💳 AUTO KEYCARD",
    Default = false,
    Callback = function(value)
        Settings.AutoKeycard = value
    end,
})

utilLeft:Toggle({
    Name = "🚔 AUTO TEAM (CRIMINALS)",
    Default = false,
    Callback = function(value)
        Settings.AutoTeam = value
        AutoTeam()
    end,
})

utilLeft:Toggle({
    Name = "💀 ANTI AFK",
    Default = true,
    Callback = function(value)
        Settings.AntiAFK = value
    end,
})

utilRight:Header({ Name = "🏃 ESCAPE" })

utilRight:Toggle({
    Name = "🚪 AUTO ESCAPE",
    Default = false,
    Callback = function(value)
        Settings.AutoEscape = value
    end,
})

utilRight:Dropdown({
    Name = "Escape Method",
    Multi = false,
    Options = {"Tunnel", "Volcano", "Sewer", "Helicopter"},
    Default = 1,
    Callback = function(value)
        Settings.EscapeMethod = value
    end,
})

-- // SETTINGS TAB
local settingsTab = tabGroup:Tab({ Name = "SETTINGS", Image = "rbxassetid://10734950309" })

local settingsLeft = settingsTab:Section({ Side = "Left" })
local settingsRight = settingsTab:Section({ Side = "Right" })

settingsLeft:Header({ Name = "⚙️ UI SETTINGS" })

local uiBlur = settingsLeft:Toggle({
    Name = "UI Blur",
    Default = true,
    Callback = function(value)
        Window:SetAcrylicBlurState(value)
    end,
})

local notifications = settingsLeft:Toggle({
    Name = "Notifications",
    Default = true,
    Callback = function(value)
        Window:SetNotificationsState(value)
    end,
})

settingsRight:Header({ Name = "💬 DISCORD" })

settingsRight:Button({
    Name = "JOIN DISCORD (COPY LINK)",
    Callback = function()
        setclipboard("https://discord.gg/5RuMCxK3u6")
        Window:Notify({
            Title = "ELITE HUB",
            Description = "DISCORD LINK COPIED YOU BITCH 🥀",
            Lifetime = 3
        })
    end,
})

settingsRight:Button({
    Name = "DESTROY UI",
    Callback = function()
        Window:Unload()
    end,
})

-- // CONFIG SECTION
tabs.Settings:InsertConfigSection("Left")

-- // UNLOAD
Window.onUnloaded(function()
    print("ELITE HUB UNLOADED - FUCK YOU FOR LEAVING 🥀")
end)

-- // SELECT DEFAULT TAB
autoTab:Select()

-- // STARTUP NOTIFICATION
Window:Notify({
    Title = "ELITE HUB v1.0.0",
    Description = "Loaded you fucking bitch! Go fuck shit up! 🥀",
    Lifetime = 4
})

print("ELITE HUB v1.0.0 FULLY LOADED - GO FUCK SHIT UP WITH MACLIB 🥀")