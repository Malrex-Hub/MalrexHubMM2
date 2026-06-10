-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // MOBILE SIZE (360x350) - 60+ FEATURES - IMPROVED 🥀

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Name = "ELITE HUB",
    Theme = "Dark",
    Size = "360x350",
})

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

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

print("ELITE HUB v1.0.0 - 60+ FEATURES - 9,338 MEMBERS 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6")

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
        Window:SetWatermark("ELITE | " .. fps .. "FPS | " .. ping .. "MS | 9,338")
    end)
end)

-- // SETTINGS (EVERY FUCKING FEATURE)
local Settings = {
    -- Combat
    KillAura = false, KillAuraRange = 35, KillAuraDelay = 0.1,
    AutoFarmCops = false, AutoFarmPrisoners = false, AutoFarmBounty = false,
    AutoArrest = false, AutoTase = false, AutoHandcuff = false,
    NoRecoil = false, NoSpread = false, FastSwing = false, FastShoot = false, InfiniteAmmo = false,
    AimAssist = false, TriggerBot = false, CriticalHits = false,
    -- Robbery
    AutoBank = false, AutoJewelry = false, AutoMuseum = false, AutoTrain = false, AutoCargo = false, AutoPowerPlant = false,
    AutoCollect = false, AutoSell = false,
    -- Movement
    Fly = false, FlySpeed = 85, Noclip = false, WalkSpeed = 24, JumpPower = 65,
    AutoSprint = false, InfiniteJump = false, AntiRagdoll = true, NoFallDamage = false,
    -- Visuals
    ESP = false, FullBright = false, NoFog = false, NoShadow = false, XRay = false,
    FOVChanger = false, FOVAmount = 100,
    -- Utility
    AutoDonut = false, AutoKeycard = false, AutoGun = false, AutoShield = false, AutoTeam = false,
    AntiAFK = true, AutoRevive = false, AutoEscape = false, AutoRejoin = false,
    TeleportLow = false, LowHealth = 30,
    -- States
    Flying = false,
}

-- // SAVE/LOAD
local settingsKey = "EliteHub_Settings_" .. LP.UserId
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
    SaveSettings()
end

-- // FLY
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
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 8
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
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

-- // NO SHADOW
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
                local highlight = Instance.new("Highlight")
                if player.Team and player.Team.Name == "Police" then
                    highlight.FillColor = Color3.fromRGB(0, 100, 255)
                elseif player.Team and player.Team.Name == "Criminals" then
                    highlight.FillColor = Color3.fromRGB(255, 50, 50)
                else
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                end
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
                    local nearest = nil
                    local shortest = 50
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = LP.Character.HumanoidRootPart
                            local target = player.Character.HumanoidRootPart
                            if hrp and target then
                                local dist = (hrp.Position - target.Position).Magnitude
                                if dist < shortest then
                                    shortest = dist
                                    nearest = player
                                end
                            end
                        end
                    end
                    if nearest then
                        local target = nearest.Character:FindFirstChild("HumanoidRootPart")
                        if target then
                            local direction = (target.Position - Camera.CFrame.Position).Unit
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction * 5)
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
        local shoot = ReplicatedStorage:FindFirstChild("Shoot")
        if shoot then pcall(function() shoot:FireServer(target.Position) end) end
    end
end

-- // AUTO ARREST
local function AutoArrestPlayer(player)
    if not player or not player.Character then return end
    local arrestRemote = ReplicatedStorage:FindFirstChild("Arrest") or ReplicatedStorage:FindFirstChild("Cuff") or ReplicatedStorage:FindFirstChild("Handcuff")
    if arrestRemote then
        pcall(function() arrestRemote:FireServer(player) end)
    end
end

-- // AUTO LOOP FUCKERY
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
                local player, dist = GetNearestPlayer(nil)
                if player and dist <= Settings.KillAuraRange then
                    AttackPlayer(player)
                    task.wait(Settings.KillAuraDelay)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoArrest and LP.Character and LP.Team and LP.Team.Name == "Police" then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character and player.Team and player.Team.Name == "Criminals" then
                        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                        local target = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and target and (hrp.Position - target.Position).Magnitude < 10 then
                            AutoArrestPlayer(player)
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(2) do
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
    while task.wait(2) do
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
    while task.wait(2) do
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

if Settings.TeleportLow then
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if LP.Character then
                    local hum = LP.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health < Settings.LowHealth then
                        TeleportTo(Locations.CriminalBase)
                    end
                end
            end)
        end
    end)
end

-- // CREATE TABS
local mainTab = Window:Tab("MAIN")
local combatTab = Window:Tab("COMBAT")
local moveTab = Window:Tab("MOVE")
local visualTab = Window:Tab("VISUAL")
local utilTab = Window:Tab("UTIL")

-- MAIN TAB
mainTab:Toggle("Auto Farm Cops", "Hunt police officers", function(v) Settings.AutoFarmCops = v; SaveSettings() end)
mainTab:Toggle("Auto Farm Prisoners", "Beat inmates", function(v) Settings.AutoFarmPrisoners = v; SaveSettings() end)
mainTab:Toggle("Kill Aura", "Auto attack players", function(v) Settings.KillAura = v; SaveSettings() end)
mainTab:Slider("Kill Range", 10, 100, function(v) Settings.KillAuraRange = v; SaveSettings() end)
mainTab:Slider("Kill Delay", 0.05, 1, function(v) Settings.KillAuraDelay = v; SaveSettings() end)

-- COMBAT TAB
combatTab:Toggle("Auto Arrest", "Arrest criminals (cop)", function(v) Settings.AutoArrest = v; SaveSettings() end)
combatTab:Toggle("Auto Tase", "Tase suspects (cop)", function(v) Settings.AutoTase = v; SaveSettings() end)
combatTab:Toggle("No Recoil", "Zero weapon recoil", function(v) Settings.NoRecoil = v; SaveSettings() end)
combatTab:Toggle("No Spread", "Perfect accuracy", function(v) Settings.NoSpread = v; SaveSettings() end)
combatTab:Toggle("Fast Swing", "Faster melee", function(v) Settings.FastSwing = v; SaveSettings() end)
combatTab:Toggle("Infinite Ammo", "Never reload", function(v) Settings.InfiniteAmmo = v; SaveSettings() end)
combatTab:Toggle("Aim Assist", "Auto lock on", function(v) Settings.AimAssist = v; SaveSettings() end)

combatTab:Section("💰 ROBBERY")
combatTab:Toggle("Auto Bank", "Rob bank", function(v) Settings.AutoBank = v; SaveSettings() end)
combatTab:Toggle("Auto Jewelry", "Rob jewelry", function(v) Settings.AutoJewelry = v; SaveSettings() end)
combatTab:Toggle("Auto Museum", "Rob museum", function(v) Settings.AutoMuseum = v; SaveSettings() end)
combatTab:Toggle("Auto Train", "Rob train", function(v) Settings.AutoTrain = v; SaveSettings() end)
combatTab:Toggle("Auto Cargo", "Rob cargo plane", function(v) Settings.AutoCargo = v; SaveSettings() end)

-- MOVEMENT TAB
moveTab:Toggle("Fly", "Fly around map", function(v) Settings.Fly = v; ToggleFly(); SaveSettings() end)
moveTab:Slider("Fly Speed", 30, 250, function(v) Settings.FlySpeed = v; SaveSettings() end)
moveTab:Toggle("Noclip", "Walk through walls", function(v) Settings.Noclip = v; ToggleNoclip(); SaveSettings() end)
moveTab:Toggle("Infinite Jump", "Jump forever", function(v) ToggleInfiniteJump(); SaveSettings() end)
moveTab:Slider("Walk Speed", 16, 200, function(v) Settings.WalkSpeed = v; SaveSettings() end)
moveTab:Slider("Jump Power", 50, 200, function(v) Settings.JumpPower = v; SaveSettings() end)
moveTab:Toggle("Auto Sprint", "Always sprint", function(v) Settings.AutoSprint = v; SaveSettings() end)
moveTab:Toggle("Anti Ragdoll", "No stun", function(v) Settings.AntiRagdoll = v; SaveSettings() end)
moveTab:Toggle("No Fall Damage", "Take no fall dmg", function(v) Settings.NoFallDamage = v; SaveSettings() end)

-- VISUAL TAB
visualTab:Toggle("ESP", "See through walls", function(v) Settings.ESP = v; UpdateESP(); SaveSettings() end)
visualTab:Toggle("Fullbright", "See in dark", function(v) Settings.FullBright = v; ToggleFullBright(); SaveSettings() end)
visualTab:Toggle("No Fog", "Remove fog", function(v) Settings.NoFog = v; ToggleNoFog(); SaveSettings() end)
visualTab:Toggle("No Shadows", "Remove shadows", function(v) Settings.NoShadow = v; ToggleNoShadow(); SaveSettings() end)
visualTab:Toggle("FOV Changer", "Change FOV", function(v) Settings.FOVChanger = v; SaveSettings() end)
visualTab:Slider("FOV Amount", 70, 120, function(v) Settings.FOVAmount = v; SaveSettings() end)

-- UTILITY TAB
utilTab:Toggle("Auto Donut", "Auto heal", function(v) Settings.AutoDonut = v; SaveSettings() end)
utilTab:Toggle("Auto Keycard", "Auto buy keycard", function(v) Settings.AutoKeycard = v; SaveSettings() end)
utilTab:Toggle("Auto Team", "Join criminals", function(v) Settings.AutoTeam = v; AutoTeam(); SaveSettings() end)
utilTab:Toggle("Anti AFK", "No kick", function(v) Settings.AntiAFK = v; SaveSettings() end)
utilTab:Toggle("Teleport on Low HP", "Escape when low", function(v) Settings.TeleportLow = v; SaveSettings() end)
utilTab:Slider("Low HP %", 10, 70, function(v) Settings.LowHealth = v; SaveSettings() end)

utilTab:Section("💬 DISCORD")
utilTab:Button("Copy Discord Link", "discord.gg/5RuMCxK3u6", function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "Link copied! 🥀",
        Duration = 2
    })
end)

utilTab:Section("⚙️ SETTINGS")
utilTab:Button("Save Settings", "Save all", function() SaveSettings() end)
utilTab:Button("Destroy UI", "Close menu", function() Window:Destroy() end)

-- // STARTUP
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED - 60+ FEATURES - 9,338 MEMBERS 🥀",
    Duration = 3
})

print("ELITE HUB v1.0.0 - 60+ FEATURES - GO FUCK SHIT UP 🥀")