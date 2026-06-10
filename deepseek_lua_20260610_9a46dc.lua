-- // ELITE HUB v1.0.0 | JAILBREAK (FULL FUCKING FEATURES)
-- // discord.gg/5RuMCxK3u6
-- // THIS SHIT IS PACKED WITH FUCKING FEATURES YOU BITCH 🥀

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = Workspace.CurrentCamera

print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - LOADED YOU BITCH 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6")

-- // COLORS (HARDCODED BITCH)
local ThemeColor = Color3.fromRGB(46, 204, 113)
local BgColor = Color3.fromRGB(8, 8, 12)
local RedColor = Color3.fromRGB(255, 50, 50)
local BlueColor = Color3.fromRGB(50, 100, 255)

-- // FUCKING SETTINGS (ALL OF THEM)
local Settings = {
    -- UI SHIT
    ShowFPS = true,
    ShowWatermark = true,
    
    -- COMBAT SHIT (KILL THOSE MOTHERFUCKERS)
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    AutoFarmBounty = false,
    KillAura = false,
    KillAuraRange = 35,
    KillAuraDelay = 0.1,
    AutoArrest = false,
    AutoHandcuff = false,
    AutoTase = false,
    AutoAttack = false,
    HitboxExtender = false,
    HitboxSize = 5,
    
    -- ROBBERY SHIT (STEAL EVERYTHING)
    AutoRobBank = false,
    AutoRobJewelry = false,
    AutoRobMuseum = false,
    AutoRobTrain = false,
    AutoRobCargo = false,
    AutoRobPower = false,
    AutoRobCasino = false,
    RobberyDelay = 2,
    
    -- MOVEMENT SHIT (GO FAST AS FUCK)
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    AutoSprint = false,
    AutoStairs = false,
    AntiRagdoll = true,
    AntiStun = true,
    
    -- VISUAL SHIT (SEE THEIR BITCH ASS)
    ESP = false,
    ESPType = "Highlight",
    ESPColor = RedColor,
    TeamColors = true,
    FullBright = false,
    NoFog = false,
    XRay = false,
    Tracers = false,
    Chams = false,
    
    -- UTILITY SHIT (QOL BITCH)
    AutoDonut = false,
    AutoKeycard = false,
    AutoGun = false,
    AutoShield = false,
    AutoSkill = false,
    AutoTeam = "Criminals",
    AutoRevive = false,
    AutoEscape = false,
    AutoCollect = false,
    
    -- MISC SHIT
    AntiAFK = true,
    AutoRejoin = false,
    TeleportLowHealth = false,
    LowHealthThreshold = 30,
    
    -- FLY STATE
    Flying = false,
}

-- // FPS COUNTER (REAL SHIT)
local fps = 60
local lastTime = tick()
local frameCount = 0
local fpsLabel = nil

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
        if fpsLabel and Settings.ShowFPS then
            fpsLabel.Text = "ELITE HUB | " .. fps .. " FPS | FUCK YOU 🥀"
        end
    end
end)

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

-- // ANTI RAGDOLL (FUCK GETTING STUNNED)
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

-- // AUTO TEAM (JOIN THE BETTER SIDE BITCH)
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

LP.CharacterAdded:Connect(function()
    task.wait(1)
    AutoTeam()
end)

-- // FUCKING LOCATIONS (ALL OF THEM)
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
    GunShop = CFrame.new(-665, 18, 765),
    Merchant = CFrame.new(-25, 18, 250),
    CriminalBase = CFrame.new(-235, 18, 1610),
    PoliceStation = CFrame.new(640, 18, -460),
}

-- // UTILITIES (HELPER FUNCTIONS)
local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local dist = (hrp.Position - cf.Position).Magnitude
    local tween = TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
    return true
end

local function TeleportTo(cf)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

local function GetNearestPlayer(targetTeam)
    local nearest = nil
    local shortest = 1000
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if targetTeam == nil or (player.Team and player.Team.Name == targetTeam) then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        local dist = (hrp.Position - targetHrp.Position).Magnitude
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
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        local dist = (hrp.Position - targetHrp.Position).Magnitude
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
        -- Teleport to them like a bitch
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
        task.wait(0.05)
        
        -- Punch that motherfucker
        local punch = ReplicatedStorage:FindFirstChild("Punch") or ReplicatedStorage:FindFirstChild("Melee")
        if punch then pcall(function() punch:FireServer(target.Position) end) end
        
        -- Gun shit
        local shoot = ReplicatedStorage:FindFirstChild("Shoot") or ReplicatedStorage:FindFirstChild("Fire")
        if shoot then pcall(function() shoot:FireServer(target.Position) end) end
    end
end

local function HealAtDonut()
    local hum = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hum and hum.Health < 80 then
        TweenTo(Locations.Donut, 60)
        task.wait(1)
        -- Buy and eat donut logic
        task.wait(0.5)
    end
end

-- // FLY SYSTEM (BETTER THAN YOUR EX)
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
        bg.Name = "FlyShit"
        bg.P = 9e4
        bg.D = 500
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyShit2"
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
                
                local hum2 = char:FindFirstChild("Humanoid")
                if hum2 then hum2.PlatformStand = true end
            end
            pcall(function() hrp:FindFirstChild("FlyShit"):Destroy() end)
            pcall(function() hrp:FindFirstChild("FlyShit2"):Destroy() end)
            if hum then hum.PlatformStand = false end
        end)
    else
        pcall(function() hrp:FindFirstChild("FlyShit"):Destroy() end)
        pcall(function() hrp:FindFirstChild("FlyShit2"):Destroy() end)
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- // NOCLIP (WALK THROUGH WALLS LIKE A GHOST)
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

-- // ESP (SEE THOSE MOTHERFUCKERS)
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

-- // FULLBRIGHT (SEE IN THE DARK BITCH)
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

-- // KILL AURA (AUTO FUCK EVERYONE UP)
task.spawn(function()
    while task.wait(Settings.KillAuraDelay) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local targets = GetPlayersInRange(Settings.KillAuraRange, nil)
                for _, target in pairs(targets) do
                    AttackPlayer(target)
                    task.wait(0.05)
                end
            end
        end)
    end
end)

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

-- // AUTO ROBBERY (STEAL THAT FUCKING SHIT)
task.spawn(function()
    while task.wait(Settings.RobberyDelay) do
        pcall(function()
            if not LP.Character then return end
            
            -- Auto Bank
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
            
            -- Auto Jewelry
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
            
            -- Auto Museum
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

-- // AUTO DONUT (HEAL THAT ASS)
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if Settings.AutoDonut then
                HealAtDonut()
            end
        end)
    end
end)

-- // MOVEMENT LOOP (KEEP YOUR SPEED)
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

-- // CREATE UI (LOOKS CLEAN AS FUCK)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
MainFrame.BackgroundColor3 = BgColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -10, 1, 0)
fpsLabel.Position = UDim2.new(0, 10, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "ELITE HUB | 60 FPS | FUCK YOU 🥀"
fpsLabel.TextColor3 = ThemeColor
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 11
fpsLabel.Parent = TopBar

-- CLOSE BUTTON
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

-- SCROLL FRAME
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -42)
Scroll.Position = UDim2.new(0, 5, 0, 37)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- FUNCTION TO CREATE SECTIONS
local function CreateSection(parent, title, subtitle)
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
    titleLabel.TextColor3 = ThemeColor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    if subtitle then
        local subLabel = Instance.new("TextLabel")
        subLabel.Size = UDim2.new(1, -10, 0, 14)
        subLabel.Position = UDim2.new(0, 8, 0, 20)
        subLabel.BackgroundTransparency = 1
        subLabel.Text = subtitle
        subLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
        subLabel.Font = Enum.Font.Gotham
        subLabel.TextSize = 9
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        subLabel.Parent = section
    end
    
    return section
end

-- FUNCTION TO CREATE TOGGLE BUTTONS
local function MakeToggle(parent, y, text, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 24)
    btn.Position = UDim2.new(1, -55, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        Settings[setting] = state
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        btn.BackgroundColor3 = state and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
    end)
    
    return frame
end

-- FUNCTION TO CREATE SLIDER BUTTONS
local function MakeSlider(parent, y, text, setting, values)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(Settings[setting])
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = tostring(Settings[setting])
    btn.TextColor3 = ThemeColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local index = 1
    for i, v in pairs(values) do
        if v == Settings[setting] then index = i end
    end
    
    btn.MouseButton1Click:Connect(function()
        index = index % #values + 1
        Settings[setting] = values[index]
        btn.Text = tostring(Settings[setting])
        label.Text = text .. ": " .. tostring(Settings[setting])
    end)
    
    return frame
end

-- // BUILD UI SECTIONS

-- AUTOMATION SECTION
local AutoSection = CreateSection(Scroll, "⚡ AUTOMATION", "Auto rolls, enchants, merchant, and skill tree.")

-- COMBAT SECTION
local CombatSection = CreateSection(Scroll, "⚔️ COMBAT", "Kill those motherfuckers")
MakeToggle(CombatSection, 42, "💀 KILL AURA (AUTO ATTACK)", "KillAura")
MakeToggle(CombatSection, 78, "👮 AUTO FARM COPS (HUNT BLUE BITCHES)", "AutoFarmCops")
MakeToggle(CombatSection, 114, "🔒 AUTO FARM PRISONERS (BEAT INMATES)", "AutoFarmPrisoners")
MakeSlider(CombatSection, 150, "🎯 KILL AURA RANGE", "KillAuraRange", {20, 25, 30, 35, 40, 50})

-- ROBBERY SECTION
local RobSection = CreateSection(Scroll, "💰 ROBBERY", "Steal that fucking shit")
MakeToggle(RobSection, 42, "🏦 AUTO BANK (ROB THOSE FUCKS)", "AutoRobBank")
MakeToggle(RobSection, 78, "💎 AUTO JEWELRY (STEAL SHINY SHIT)", "AutoRobJewelry")
MakeToggle(RobSection, 114, "🏛️ AUTO MUSEUM (TAKE THAT ART)", "AutoRobMuseum")

-- MOVEMENT SECTION
local MoveSection = CreateSection(Scroll, "🌀 MOVEMENT", "Go fast as fuck")
MakeToggle(MoveSection, 42, "🕊️ FLY MODE (ZOOM BITCH)", "Fly")
MakeToggle(MoveSection, 78, "🌀 NOCLIP (WALK THROUGH WALLS)", "Noclip")
MakeToggle(MoveSection, 114, "🏃 AUTO SPRINT (RUN FAST)", "AutoSprint")
MakeSlider(MoveSection, 150, "⚡ WALK SPEED", "WalkSpeed", {16, 24, 32, 40, 50, 65, 80, 100})
MakeSlider(MoveSection, 186, "🦘 JUMP POWER", "JumpPower", {50, 65, 80, 100, 120, 150})

-- VISUALS SECTION
local VisSection = CreateSection(Scroll, "👁️ VISUALS", "See their bitch ass")
MakeToggle(VisSection, 42, "👻 ESP WALLHACK (SEE THROUGH WALLS)", "ESP")
MakeToggle(VisSection, 78, "☀️ FULLBRIGHT (SEE IN THE DARK)", "FullBright")
MakeToggle(VisSection, 114, "🎨 TEAM COLORS (COPS BLUE / CRIMS RED)", "TeamColors")

-- UTILITY SECTION
local UtilSection = CreateSection(Scroll, "🛠️ UTILITY", "Quality of life shit")
MakeToggle(UtilSection, 42, "🍩 AUTO DONUT (HEAL THAT ASS)", "AutoDonut")
MakeToggle(UtilSection, 78, "💳 AUTO KEYCARD (BUY FROM MERCHANT)", "AutoKeycard")
MakeToggle(UtilSection, 114, "🚔 AUTO TEAM (JOIN BETTER SIDE)", "AutoTeam")
MakeToggle(UtilSection, 150, "🛡️ ANTI RAGDOLL (NO STUN BITCH)", "AntiRagdoll")

-- DISCORD SECTION
local DiscordSection = Instance.new("Frame")
DiscordSection.Size = UDim2.new(1, 0, 0, 44)
DiscordSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
DiscordSection.Parent = Scroll

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 5)
DiscordCorner.Parent = DiscordSection

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -10, 0, 32)
DiscordBtn.Position = UDim2.new(0, 5, 0, 6)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "💬 JOIN DISCORD (COPY LINK) - discord.gg/5RuMCxK3u6"
DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 10
DiscordBtn.Parent = DiscordSection

local DiscordCorner2 = Instance.new("UICorner")
DiscordCorner2.CornerRadius = UDim.new(0, 4)
DiscordCorner2.Parent = DiscordBtn

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "DISCORD LINK COPIED YOU BITCH 🥀",
        Duration = 2
    })
end)

-- UPDATE CANVAS SIZE
local function UpdateCanvas()
    local total = 0
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("Frame") and v ~= Layout then
            total = total + v.Size.Y.Offset + 6
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, total + 20)
end

task.wait(0.1)
UpdateCanvas()

-- // FLY BUTTON CONNECTION (NEEDED SEPARATELY)
for _, btn in pairs(Scroll:GetDescendants()) do
    if btn:IsA("TextButton") and btn.Parent and btn.Parent:IsA("Frame") then
        local label = btn.Parent:FindFirstChildWhichIsA("TextLabel")
        if label and label.Text == "🕊️ FLY MODE (ZOOM BITCH)" then
            local originalClick = btn.MouseButton1Click
            local conn
            conn = btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                ToggleFly()
            end)
        end
        if label and label.Text == "🌀 NOCLIP (WALK THROUGH WALLS)" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                ToggleNoclip()
            end)
        end
        if label and label.Text == "☀️ FULLBRIGHT (SEE IN THE DARK)" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                ToggleFullBright()
            end)
        end
        if label and label.Text == "👻 ESP WALLHACK (SEE THROUGH WALLS)" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                UpdateESP()
            end)
        end
        if label and label.Text == "🚔 AUTO TEAM (JOIN BETTER SIDE)" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                AutoTeam()
            end)
        end
    end
end

-- // STARTUP NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "Loaded you fucking bitch! Go fuck shit up! 🥀",
    Duration = 3
})

print("ELITE HUB FULLY LOADED - GO FUCKING KILL THEM ALL 🥀")