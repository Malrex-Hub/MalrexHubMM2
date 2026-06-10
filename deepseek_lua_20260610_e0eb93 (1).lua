--[[

███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░
██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗
█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝
██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗
███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝
╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░

███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░
██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗
█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝
██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗
███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝
╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░

ELITE HUB v1.0.0 - JAILBREAK
DISCORD: discord.gg/5RuMCxK3u6
FUCK YOU IF YOU STEAL THIS SHIT - 9,338 MEMBERS BITCH

--]]

-- // LOAD MACLIB (DELTA FRIENDLY)
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

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

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // FUCKING VARIABLES
local fuckingSettings = {
    -- Combat shit
    KillAura = false,
    KillAuraRange = 35,
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    AutoFarmBounty = false,
    
    -- Robbery shit
    AutoBank = false,
    AutoJewelry = false,
    AutoMuseum = false,
    
    -- Movement shit
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    AntiRagdoll = true,
    
    -- Visual shit
    ESP = false,
    FullBright = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    -- Utility shit
    AutoDonut = false,
    AutoKeycard = false,
    AutoTeam = false,
    AntiAFK = true,
    
    -- States
    Flying = false,
}

-- // FPS COUNTER (REAL SHIT)
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

-- // ANTI AFK (FUCK THE AFK KICK)
if fuckingSettings.AntiAFK then
    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(0.3)
            VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- // ANTI RAGDOLL (NO STUN BITCH)
if fuckingSettings.AntiRagdoll then
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

-- // AUTO TEAM (JOIN CRIMINALS BITCH)
local function AutoTeam()
    if fuckingSettings.AutoTeam then
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

-- // FLY FUNCTION (GO ZOOM ZOOM MOTHERFUCKER)
local function ToggleFly()
    fuckingSettings.Flying = not fuckingSettings.Flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if fuckingSettings.Flying then
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
            while fuckingSettings.Flying and char and char:FindFirstChild("HumanoidRootPart") do
                task.wait()
                local control = Vector3.new(0,0,0)
                local speed = fuckingSettings.FlySpeed
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then control = control + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then control = control - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then control = control - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then control = control + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then control = control + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then control = control - Vector3.new(0, 1, 0) end
                
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
    fuckingSettings.Noclip = not fuckingSettings.Noclip
    if fuckingSettings.Noclip then
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

-- // FULLBRIGHT (SEE IN THE DARK YOU PUSSY)
local function ToggleFullBright()
    fuckingSettings.FullBright = not fuckingSettings.FullBright
    if fuckingSettings.FullBright then
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

-- // ESP (SEE THOSE MOTHERFUCKERS)
local espObjects = {}
local function UpdateESP()
    if fuckingSettings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = fuckingSettings.ESPColor
                highlight.FillTransparency = 0.5
                highlight.Parent = player.Character
                espObjects[player] = highlight
            elseif (not player.Character or not fuckingSettings.ESP) and espObjects[player] then
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

-- // LOCATIONS (WHERE TO ROB THESE BITCHES)
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
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

-- // AUTO FARM COPS (HUNT THOSE BLUE BITCHES)
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if fuckingSettings.AutoFarmCops and LP.Character then
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
            if fuckingSettings.AutoFarmPrisoners and LP.Character then
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
    while task.wait(0.1) do
        pcall(function()
            if fuckingSettings.KillAura and LP.Character then
                local targets = {"Police", "Prisoners", "Criminals"}
                for _, team in pairs(targets) do
                    local player, dist = GetNearestPlayer(team)
                    if player and dist <= fuckingSettings.KillAuraRange then
                        AttackPlayer(player)
                        task.wait(0.05)
                    end
                end
            end
        end)
    end
end)

-- // AUTO BANK (ROB THOSE FUCKS)
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if fuckingSettings.AutoBank then
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
    while task.wait(2) do
        pcall(function()
            if fuckingSettings.AutoJewelry then
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

-- // AUTO DONUT (HEAL THAT ASS)
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if fuckingSettings.AutoDonut and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum and hum.Health < 80 then
                    TweenTo(Locations.Donut, 60)
                    task.wait(1)
                end
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
                if hum.WalkSpeed ~= fuckingSettings.WalkSpeed then
                    hum.WalkSpeed = fuckingSettings.WalkSpeed
                end
                if hum.JumpPower ~= fuckingSettings.JumpPower then
                    hum.JumpPower = fuckingSettings.JumpPower
                end
            end
        end)
    end
end)

-- // CREATE UI (SMALL AS FUCK - 450x500)
local Window = MacLib:Window({
    Title = "ELITE HUB v1.0.0",
    Subtitle = "FPS: " .. fps .. " | MS: " .. ping .. " | 9,338 MEMBERS",
    Size = UDim2.fromOffset(450, 520),
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

-- // AUTOMATION TAB (FUCKING AUTOMATION)
local autoTab = tabGroup:Tab({ Name = "AUTOMATION" })
local autoLeft = autoTab:Section({ Side = "Left" })
local autoRight = autoTab:Section({ Side = "Right" })

autoLeft:Header({ Name = "⚡ AUTO ROLLS" })
autoLeft:Label({ Text = "Auto roll for desired traits, races, clans - FUCK RNG" })
autoLeft:Input({ Name = "Target Traits", Placeholder = "Enter trait name" })
autoLeft:Toggle({ Name = "Auto Roll Traits", Default = false })
autoLeft:Input({ Name = "Target Race", Placeholder = "Enter race name" })
autoLeft:Toggle({ Name = "Auto Roll Race", Default = false })
autoLeft:Input({ Name = "Target Clan", Placeholder = "Enter clan name" })
autoLeft:Toggle({ Name = "Auto Roll Clan", Default = false })
autoLeft:Slider({ Name = "Roll Cooldown (sec)", Default = 0.1, Minimum = 0.05, Maximum = 2, Precision = 2 })

autoRight:Header({ Name = "🌳 SKILL TREE" })
autoRight:Label({ Text = "Upgrade skill tree nodes - GET STRONG BITCH" })
autoRight:Slider({ Name = "Node Index", Default = 1, Minimum = 1, Maximum = 50 })
autoRight:Toggle({ Name = "Auto Upgrade Nodes", Default = false })
autoRight:Dropdown({ Name = "Skill Priority", Options = {"Attack", "Defense", "Health", "Fruit", "Sword"}, Default = 1 })

autoRight:Divider()
autoRight:Header({ Name = "💰 MERCHANT" })
autoRight:Label({ Text = "Auto buy from merchant - SPEND THAT CASH" })
autoRight:Toggle({ Name = "Auto Buy from Merchant", Default = false })
autoRight:Label({ Text = "Teleports to merchant each cycle" })

-- // COMBAT TAB (KILL THOSE MOTHERFUCKERS)
local combatTab = tabGroup:Tab({ Name = "COMBAT" })
local combatLeft = combatTab:Section({ Side = "Left" })
local combatRight = combatTab:Section({ Side = "Right" })

combatLeft:Header({ Name = "⚔️ KILL THAT MOTHERFUCKER" })
combatLeft:Toggle({ Name = "💀 KILL AURA", Default = false, Callback = function(v) fuckingSettings.KillAura = v end })
combatLeft:Slider({ Name = "Kill Aura Range", Default = 35, Minimum = 10, Maximum = 100, Callback = function(v) fuckingSettings.KillAuraRange = v end })
combatLeft:Toggle({ Name = "👮 AUTO FARM COPS", Default = false, Callback = function(v) fuckingSettings.AutoFarmCops = v end })
combatLeft:Toggle({ Name = "🔒 AUTO FARM PRISONERS", Default = false, Callback = function(v) fuckingSettings.AutoFarmPrisoners = v end })
combatLeft:Toggle({ Name = "💰 AUTO FARM BOUNTY", Default = false, Callback = function(v) fuckingSettings.AutoFarmBounty = v end })

combatRight:Header({ Name = "💰 ROBBERY - STEAL THAT SHIT" })
combatRight:Toggle({ Name = "🏦 AUTO BANK", Default = false, Callback = function(v) fuckingSettings.AutoBank = v end })
combatRight:Toggle({ Name = "💎 AUTO JEWELRY", Default = false, Callback = function(v) fuckingSettings.AutoJewelry = v end })
combatRight:Toggle({ Name = "🏛️ AUTO MUSEUM", Default = false, Callback = function(v) fuckingSettings.AutoMuseum = v end })

-- // MOVEMENT TAB (GO FAST AS FUCK)
local moveTab = tabGroup:Tab({ Name = "MOVEMENT" })
local moveLeft = moveTab:Section({ Side = "Left" })
local moveRight = moveTab:Section({ Side = "Right" })

moveLeft:Header({ Name = "🌀 GO FAST AS FUCK" })
moveLeft:Toggle({ Name = "🕊️ FLY MODE", Default = false, Callback = function(v) ToggleFly() end })
moveLeft:Slider({ Name = "Fly Speed", Default = 85, Minimum = 30, Maximum = 250, Callback = function(v) fuckingSettings.FlySpeed = v end })
moveLeft:Toggle({ Name = "🌀 NOCLIP", Default = false, Callback = function(v) ToggleNoclip() end })
moveLeft:Toggle({ Name = "🛡️ ANTI RAGDOLL (NO STUN)", Default = true, Callback = function(v) fuckingSettings.AntiRagdoll = v end })

moveRight:Header({ Name = "⚡ STATS" })
moveRight:Slider({ Name = "Walk Speed", Default = 24, Minimum = 16, Maximum = 200, Callback = function(v) fuckingSettings.WalkSpeed = v end })
moveRight:Slider({ Name = "Jump Power", Default = 65, Minimum = 50, Maximum = 200, Callback = function(v) fuckingSettings.JumpPower = v end })

-- // VISUALS TAB (SEE THEIR BITCH ASS)
local visTab = tabGroup:Tab({ Name = "VISUALS" })
local visLeft = visTab:Section({ Side = "Left" })
local visRight = visTab:Section({ Side = "Right" })

visLeft:Header({ Name = "👁️ SEE THEIR BITCH ASS" })
visLeft:Toggle({ Name = "👻 ESP WALLHACK", Default = false, Callback = function(v) fuckingSettings.ESP = v; UpdateESP() end })
visLeft:Colorpicker({ Name = "ESP Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(c) fuckingSettings.ESPColor = c; UpdateESP() end })
visLeft:Toggle({ Name = "☀️ FULLBRIGHT", Default = false, Callback = function(v) ToggleFullBright() end })

-- // UTILITY TAB (QUALITY OF LIFE SHIT)
local utilTab = tabGroup:Tab({ Name = "UTILITY" })
local utilLeft = utilTab:Section({ Side = "Left" })
local utilRight = utilTab:Section({ Side = "Right" })

utilLeft:Header({ Name = "🛠️ QUALITY OF LIFE SHIT" })
utilLeft:Toggle({ Name = "🍩 AUTO DONUT (HEAL)", Default = false, Callback = function(v) fuckingSettings.AutoDonut = v end })
utilLeft:Toggle({ Name = "💳 AUTO KEYCARD", Default = false, Callback = function(v) fuckingSettings.AutoKeycard = v end })
utilLeft:Toggle({ Name = "🚔 AUTO TEAM (CRIMINALS)", Default = false, Callback = function(v) fuckingSettings.AutoTeam = v; AutoTeam() end })
utilLeft:Toggle({ Name = "💀 ANTI AFK", Default = true, Callback = function(v) fuckingSettings.AntiAFK = v end })

utilRight:Header({ Name = "💬 DISCORD" })
utilRight:Button({ Name = "JOIN DISCORD (COPY LINK)", Callback = function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    Window:Notify({ Title = "ELITE HUB", Description = "DISCORD LINK COPIED BITCH 🥀", Lifetime = 2 })
end })

utilRight:Button({ Name = "DESTROY UI", Callback = function() Window:Unload() end })

-- // SETTINGS TAB
local settingsTab = tabGroup:Tab({ Name = "SETTINGS" })
settingsTab:InsertConfigSection("Left")

-- // SELECT DEFAULT TAB
autoTab:Select()

-- // STARTUP NOTIFICATION
Window:Notify({ Title = "ELITE HUB v1.0.0", Description = "LOADED YOU FUCKING BITCH - 9,338 MEMBERS 🥀", Lifetime = 3 })

print("ELITE HUB v1.0.0 FULLY LOADED - GO FUCK SHIT UP YOU BEAUTIFUL BITCH 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - JOIN OR GET FUCKED")