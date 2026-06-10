-- ///////////////////////////////////////////////////////////////////////////////
-- //                                                                           //
-- //    ELITE HUB v1.0.0 | JAILBREAK                                           //
-- //    discord.gg/5RuMCxK3u6                                                  //
-- //    FUCK YOU IF YOU STEAL THIS SHIT                                        //
-- //    9,338 MEMBERS - DELTA FRIENDLY BITCH                                   //
-- //                                                                           //
-- ///////////////////////////////////////////////////////////////////////////////

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
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

print("███╗░░░███╗░█████╗░░█████╗░██████╗░██╗░░░██╗██████╗░")
print("████╗░████║██╔══██╗██╔══██╗██╔══██╗██║░░░██║██╔══██╗")
print("██╔████╔██║██║░░╚═╝██║░░██║██████╔╝██║░░░██║██║░░██║")
print("██║╚██╔╝██║██║░░██╗██║░░██║██╔══██╗██║░░░██║██║░░██║")
print("██║░╚═╝░██║╚█████╔╝╚█████╔╝██║░░██║╚██████╔╝██████╔╝")
print("╚═╝░░░░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - LOADED YOU BITCH 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - JOIN OR GET FUCKED CUNT")
print("9,338 MEMBERS - WE OWN THIS SHIT")

-- // FPS + MS COUNTER (REAL SHIT)
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

-- // FUCKING SETTINGS
local settingsKey = "EliteHub_Settings_" .. LP.UserId
local Settings = {
    -- Combat shit
    KillAura = false,
    KillAuraRange = 35,
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
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
    -- Visual shit
    ESP = false,
    FullBright = false,
    -- Utility shit
    AutoDonut = false,
    AutoTeam = false,
    AntiAFK = true,
    -- States
    Flying = false,
}

-- // LOAD SAVED SETTINGS
pcall(function()
    local storage = game:GetService("LocalStorage")
    local data = storage:FindFirstChild(settingsKey)
    if data then
        local saved = HttpService:JSONDecode(data.Value)
        for k, v in pairs(saved) do
            Settings[k] = v
        end
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
        end)
    end)
end

-- // AUTO TEAM (JOIN CRIMINALS BITCH)
local function AutoTeam()
    if Settings.AutoTeam then
        local criminalTeam = Teams:FindFirstChild("Criminals")
        if criminalTeam and LP.Team ~= criminalTeam then
            LP.Team = criminalTeam
            print("Joined Criminals you bitch")
        end
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    AutoTeam()
end)

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
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end

-- // FULLBRIGHT (SEE IN THE DARK YOU PUSSY)
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

-- // ESP (SEE THOSE MOTHERFUCKERS)
local espObjects = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
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
    while task.wait(0.1) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                local player, dist = GetNearestPlayer(nil)
                if player and dist <= Settings.KillAuraRange then
                    AttackPlayer(player)
                    task.wait(0.05)
                end
            end
        end)
    end
end)

-- // AUTO BANK (ROB THOSE FUCKS)
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

-- // AUTO JEWELRY (STEAL THAT SHINY SHIT)
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
            end
        end)
    end
end)

-- // CREATE LOADING SCREEN (FUCKING CLEAN)
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EliteLoading"
loadingGui.Parent = CoreGui
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loadingBg = Instance.new("Frame")
loadingBg.Size = UDim2.new(1, 0, 1, 0)
loadingBg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
loadingBg.Parent = loadingGui

local loadingCenter = Instance.new("Frame")
loadingCenter.Size = UDim2.new(0, 350, 0, 250)
loadingCenter.Position = UDim2.new(0.5, -175, 0.5, -125)
loadingCenter.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
loadingCenter.BackgroundTransparency = 0.05
loadingCenter.Parent = loadingBg

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingCenter

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 0, 50)
logoText.Position = UDim2.new(0, 0, 0, 20)
logoText.BackgroundTransparency = 1
logoText.Text = "ELITE HUB"
logoText.TextColor3 = Color3.fromRGB(46, 204, 113)
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 36
logoText.TextScaled = true
logoText.Parent = loadingCenter

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 0, 20)
statusText.Position = UDim2.new(0, 20, 0, 85)
statusText.BackgroundTransparency = 1
statusText.Text = "FUCKING LOADING..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 200)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 12
statusText.Parent = loadingCenter

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 6)
barBg.Position = UDim2.new(0.1, 0, 0, 120)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
barBg.Parent = loadingCenter

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

local skipBtn = Instance.new("TextButton")
skipBtn.Size = UDim2.new(0, 100, 0, 30)
skipBtn.Position = UDim2.new(0.5, -50, 0, 150)
skipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
skipBtn.Text = "SKIP 🥀"
skipBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
skipBtn.Font = Enum.Font.GothamBold
skipBtn.TextSize = 12
skipBtn.Parent = loadingCenter

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 6)
skipCorner.Parent = skipBtn

local skipPressed = false
skipBtn.MouseButton1Click:Connect(function()
    skipPressed = true
end)

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 20)
versionText.Position = UDim2.new(0, 0, 0, 200)
versionText.BackgroundTransparency = 1
versionText.Text = "v1.0.0 | 9,338 Members"
versionText.TextColor3 = Color3.fromRGB(100, 100, 120)
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 10
versionText.Parent = loadingCenter

-- LOADING SEQUENCE
local steps = {
    "INJECTING THIS SHIT...",
    "BYPASSING JAILBREAK...",
    "LOADING FEATURES...",
    "FUCKING READY 🥀"
}

for i, step in ipairs(steps) do
    if skipPressed then break end
    statusText.Text = step
    TweenService:Create(barFill, TweenInfo.new(0.3), {Size = UDim2.new(i / #steps, 0, 1, 0)}):Play()
    task.wait(0.4)
end

task.wait(0.2)
loadingGui:Destroy()

-- // CREATE MAIN UI (WIDER 500x400, MOVABLE)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 420)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ELITE HUB v1.0.0 | " .. fps .. " FPS | " .. ping .. " MS"
titleLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 11
titleLabel.Parent = topBar

-- UPDATE TITLE
task.spawn(function()
    while task.wait(1) do
        titleLabel.Text = "ELITE HUB v1.0.0 | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)

-- DISCORD NOTIFICATION BUTTON
local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0, 100, 0, 26)
discordBtn.Position = UDim2.new(1, -110, 0.5, -13)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.Text = "💬 DISCORD"
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 11
discordBtn.Parent = topBar

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 5)
discordCorner.Parent = discordBtn

discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "DISCORD LINK COPIED YOU BITCH 🥀",
        Duration = 2
    })
end)

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -36, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- SCROLL FRAME
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -42)
scroll.Position = UDim2.new(0, 5, 0, 37)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 3
scroll.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scroll

-- FUNCTION TO MAKE A SECTION
local function MakeSection(title, subtitle)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 42)
    section.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    section.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -12, 0, 18)
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -12, 0, 14)
    subLabel.Position = UDim2.new(0, 8, 0, 22)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = subtitle
    subLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 9
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = section
    
    return section
end

-- FUNCTION TO MAKE TOGGLE BUTTON
local function MakeToggle(parent, y, text, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = Settings[setting] and "ON" or "OFF"
    btn.TextColor3 = Settings[setting] and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        btn.Text = Settings[setting] and "ON" or "OFF"
        btn.TextColor3 = Settings[setting] and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        btn.BackgroundColor3 = Settings[setting] and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(35, 35, 45)
        SaveSettings()
        
        -- Handle special toggles
        if setting == "ESP" then UpdateESP() end
        if setting == "FullBright" then ToggleFullBright() end
        if setting == "Noclip" then ToggleNoclip() end
        if setting == "Fly" then ToggleFly() end
        if setting == "AutoTeam" then AutoTeam() end
    end)
    
    return frame
end

-- FUNCTION TO MAKE SLIDER
local function MakeSlider(parent, y, text, setting, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(Settings[setting])
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 4)
    sliderBg.Position = UDim2.new(0, 10, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local valueBtn = Instance.new("TextButton")
    valueBtn.Size = UDim2.new(0, 45, 0, 22)
    valueBtn.Position = UDim2.new(1, -55, 0, 32)
    valueBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    valueBtn.Text = tostring(Settings[setting])
    valueBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
    valueBtn.Font = Enum.Font.GothamBold
    valueBtn.TextSize = 10
    valueBtn.Parent = frame
    
    local valueCorner = Instance.new("UICorner")
    valueCorner.CornerRadius = UDim.new(0, 4)
    valueCorner.Parent = valueBtn
    
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local pos = math.clamp((Mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            Settings[setting] = value
            label.Text = text .. ": " .. value
            valueBtn.Text = tostring(value)
            SaveSettings()
        end
    end)
    
    return frame
end

-- // BUILD ALL SECTIONS

-- AUTOMATION SECTION
local autoSection = MakeSection("⚡ AUTOMATION", "Auto rolls, enchants, merchant, and skill tree.")
MakeToggle(autoSection, 42, "🎲 AUTO ROLLS", "AutoRoll")
MakeToggle(autoSection, 78, "📚 AUTO SKILL TREE", "AutoSkillTree")
MakeSlider(autoSection, 114, "ROLL COOLDOWN", "RollCooldown", 0.05, 2, 0.1)

-- COMBAT SECTION
local combatSection = MakeSection("⚔️ COMBAT", "Kill those motherfuckers")
MakeToggle(combatSection, 42, "💀 KILL AURA", "KillAura")
MakeSlider(combatSection, 78, "KILL AURA RANGE", "KillAuraRange", 10, 100, 35)
MakeToggle(combatSection, 124, "👮 AUTO FARM COPS", "AutoFarmCops")
MakeToggle(combatSection, 160, "🔒 AUTO FARM PRISONERS", "AutoFarmPrisoners")

-- ROBBERY SECTION
local robSection = MakeSection("💰 ROBBERY", "Steal that fucking shit")
MakeToggle(robSection, 42, "🏦 AUTO BANK", "AutoBank")
MakeToggle(robSection, 78, "💎 AUTO JEWELRY", "AutoJewelry")
MakeToggle(robSection, 114, "🏛️ AUTO MUSEUM", "AutoMuseum")

-- MOVEMENT SECTION
local moveSection = MakeSection("🌀 MOVEMENT", "Go fast as fuck")
MakeToggle(moveSection, 42, "🕊️ FLY MODE", "Fly")
MakeSlider(moveSection, 78, "FLY SPEED", "FlySpeed", 30, 250, 85)
MakeToggle(moveSection, 124, "🌀 NOCLIP", "Noclip")
MakeSlider(moveSection, 160, "WALK SPEED", "WalkSpeed", 16, 200, 24)
MakeSlider(moveSection, 206, "JUMP POWER", "JumpPower", 50, 200, 65)

-- VISUALS SECTION
local visSection = MakeSection("👁️ VISUALS", "See their bitch ass")
MakeToggle(visSection, 42, "👻 ESP WALLHACK", "ESP")
MakeToggle(visSection, 78, "☀️ FULLBRIGHT", "FullBright")

-- UTILITY SECTION
local utilSection = MakeSection("🛠️ UTILITY", "Quality of life shit")
MakeToggle(utilSection, 42, "🍩 AUTO DONUT", "AutoDonut")
MakeToggle(utilSection, 78, "🚔 AUTO TEAM", "AutoTeam")
MakeToggle(utilSection, 114, "💀 ANTI AFK", "AntiAFK")

-- UPDATE CANVAS SIZE
local function UpdateCanvas()
    local total = 0
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("Frame") and v ~= scrollLayout then
            total = total + v.Size.Y.Offset + 6
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, total + 20)
end

task.wait(0.1)
UpdateCanvas()

-- // STARTUP NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED YOU FUCKING BITCH - 9,338 MEMBERS 🥀",
    Duration = 3
})

print("ELITE HUB v1.0.0 FULLY LOADED - GO FUCK SHIT UP YOU BEAUTIFUL BITCH 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - 9,338 MEMBERS")