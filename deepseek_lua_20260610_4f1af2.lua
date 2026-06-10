-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // PURE ROBLOX UI - NO EXTERNAL LIBS - WORKS ON DELTA 🥀

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

print("ELITE HUB v1.0.0 - 9,338 MEMBERS 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6")

-- // FPS COUNTER
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

-- // SETTINGS
local Settings = {
    KillAura = false, KillAuraRange = 35,
    AutoFarmCops = false, AutoFarmPrisoners = false,
    AutoArrest = false, AutoTase = false,
    AutoBank = false, AutoJewelry = false, AutoMuseum = false,
    Fly = false, FlySpeed = 85, Noclip = false,
    WalkSpeed = 24, JumpPower = 65,
    ESP = false, FullBright = false,
    AutoDonut = false, AutoTeam = false, AntiAFK = true,
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
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then control = control + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then control = control - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then control = control - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then control = control + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then control = control + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then control = control - Vector3.new(0, 1, 0) end
                
                if control.Magnitude > 0 then control = control.Unit end
                bg.cframe = CFrame.new(hrp.Position, hrp.Position + control)
                bv.velocity = control * Settings.FlySpeed
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

-- // LOCATIONS
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
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

-- // AUTO ARREST
local function AutoArrestPlayer(player)
    if not player or not player.Character then return end
    local arrestRemote = ReplicatedStorage:FindFirstChild("Arrest") or ReplicatedStorage:FindFirstChild("Cuff")
    if arrestRemote then
        pcall(function() arrestRemote:FireServer(player) end)
    end
end

-- // AUTO LOOPS
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
            end
        end)
    end
end)

-- // CREATE UI (PURE ROBLOX, NO LIBRARY)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ELITE HUB | " .. fps .. " FPS"
titleLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 11
titleLabel.Parent = topBar

-- FPS UPDATE
task.spawn(function()
    while task.wait(1) do
        titleLabel.Text = "ELITE HUB | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- SCROLL FRAME
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 2
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- FUNCTION TO MAKE A TOGGLE BUTTON
local function MakeToggle(text, setting, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = scroll
    
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
        if callback then callback(Settings[setting]) end
    end)
    
    return frame
end

-- FUNCTION TO MAKE A SLIDER
local function MakeSlider(text, setting, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(Settings[setting])
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -70, 0, 4)
    sliderBg.Position = UDim2.new(0, 8, 0, 32)
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
    valueBtn.Position = UDim2.new(1, -53, 0, 26)
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

-- FUNCTION TO MAKE A BUTTON
local function MakeButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- FUNCTION TO MAKE A SECTION HEADER
local function MakeHeader(text)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    header.Text = "   " .. text
    header.TextColor3 = Color3.fromRGB(46, 204, 113)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 12
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = header
    
    return header
end

-- // BUILD UI
MakeHeader("⚡ AUTO FARM")
MakeToggle("Auto Farm Cops", "AutoFarmCops")
MakeToggle("Auto Farm Prisoners", "AutoFarmPrisoners")
MakeToggle("Kill Aura", "KillAura")
MakeSlider("Kill Range", "KillAuraRange", 10, 100, 35)

MakeHeader("🚔 POLICE (COP)")
MakeToggle("Auto Arrest", "AutoArrest")
MakeToggle("Auto Tase", "AutoTase")

MakeHeader("💰 ROBBERY")
MakeToggle("Auto Bank", "AutoBank")
MakeToggle("Auto Jewelry", "AutoJewelry")
MakeToggle("Auto Museum", "AutoMuseum")

MakeHeader("🌀 MOVEMENT")
MakeToggle("Fly", "Fly", function(v) ToggleFly() end)
MakeSlider("Fly Speed", "FlySpeed", 30, 250, 85)
MakeToggle("Noclip", "Noclip", function(v) ToggleNoclip() end)
MakeSlider("Walk Speed", "WalkSpeed", 16, 200, 24)
MakeSlider("Jump Power", "JumpPower", 50, 200, 65)

MakeHeader("👁️ VISUALS")
MakeToggle("ESP", "ESP", function(v) UpdateESP() end)
MakeToggle("Fullbright", "FullBright", function(v) ToggleFullBright() end)

MakeHeader("🛠️ UTILITY")
MakeToggle("Auto Donut", "AutoDonut")
MakeToggle("Auto Team", "AutoTeam", function(v) AutoTeam() end)
MakeToggle("Anti AFK", "AntiAFK")

MakeHeader("💬 DISCORD")
MakeButton("Copy Discord Link", function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "Link copied! 🥀",
        Duration = 2
    })
end)

MakeHeader("⚙️ SETTINGS")
MakeButton("Save Settings", function() SaveSettings() end)
MakeButton("Destroy UI", function() screenGui:Destroy() end)

-- UPDATE CANVAS
local function UpdateCanvas()
    local total = 0
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextLabel") then
            if v ~= layout then
                total = total + v.Size.Y.Offset + 6
            end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, total + 20)
end

task.wait(0.1)
UpdateCanvas()

-- // STARTUP
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED - 9,338 MEMBERS 🥀",
    Duration = 3
})

print("ELITE HUB LOADED - GO FUCK SHIT UP 🥀")