-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // MOBILE FRIENDLY - BIG BLOODY BUTTONS - CLEAN AF UI 🥀

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

print("███╗░░░███╗░█████╗░░█████╗░██████╗░██╗░░░██╗██████╗░")
print("████╗░████║██╔══██╗██╔══██╗██╔══██╗██║░░░██║██╔══██╗")
print("██╔████╔██║██║░░╚═╝██║░░██║██████╔╝██║░░░██║██║░░██║")
print("██║╚██╔╝██║██║░░██╗██║░░██║██╔══██╗██║░░░██║██║░░██║")
print("██║░╚═╝░██║╚█████╔╝╚█████╔╝██║░░██║╚██████╔╝██████╔╝")
print("╚═╝░░░░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - 9,338 MEMBERS 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - JOIN OR GET FUCKED")

-- // FIND REMOTES
local Remotes = {}
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        Remotes[v.Name] = v
    end
end

-- // SETTINGS WITH AUTO SAVE
local Settings = {
    KillAura = false, KillAuraRange = 30,
    AutoFarm = false, AutoArrest = false, AutoTase = false,
    AutoRob = false, Fly = false, FlySpeed = 85,
    Noclip = false, WalkSpeed = 24, JumpPower = 65,
    ESP = false, FullBright = false,
    AutoDonut = false, AntiAFK = true,
    Flying = false,
}

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

-- // AUTO TEAM (CRIMINALS)
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if Settings.AutoTeam then
        local criminalTeam = Teams:FindFirstChild("Criminals")
        if criminalTeam and LP.Team ~= criminalTeam then
            LP.Team = criminalTeam
        end
    end
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

-- // FLY SYSTEM
local flying = false
local flyBV, flyBG

local function ToggleFly()
    flying = not flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flying then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = true end

        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
        flyBG.Parent = hrp

        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        flyBV.Parent = hrp

        task.spawn(function()
            while flying and hrp and hrp.Parent do
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
                flyBV.Velocity = move * Settings.FlySpeed
                flyBG.CFrame = Camera.CFrame
                task.wait()
            end
        end)
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
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
                    if part:IsA("BasePart") then part.CanCollide = false end
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
local espHighlights = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                if not espHighlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = (player.Team and player.Team.Name == "Police") and Color3.fromRGB(0,100,255) or Color3.fromRGB(255,50,50)
                    hl.FillTransparency = 0.6
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.Parent = player.Character
                    espHighlights[player] = hl
                end
            elseif espHighlights[player] then
                espHighlights[player]:Destroy()
                espHighlights[player] = nil
            end
        end
    else
        for _, hl in pairs(espHighlights) do hl:Destroy() end
        espHighlights = {}
    end
end

Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(p) if espHighlights[p] then espHighlights[p]:Destroy() end end)

-- // UTILITIES
local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    local tween = TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

local function GetNearestEnemy()
    local nearest, shortest = nil, 1000
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LP.Team then
                if (LP.Team.Name == "Police" and p.Team and p.Team.Name == "Criminals") or
                   (LP.Team.Name == "Criminals" and p.Team and p.Team.Name == "Police") then
                    local hrp = LP.Character.HumanoidRootPart
                    local target = p.Character.HumanoidRootPart
                    local dist = (hrp.Position - target.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        nearest = p
                    end
                end
            end
        end
    end
    return nearest, shortest
end

local function AttackPlayer(player)
    if not player or not player.Character then return end
    local target = player.Character:FindFirstChild("HumanoidRootPart")
    if not target then return end
    local punch = Remotes["Punch"] or Remotes["Melee"]
    if punch then pcall(function() punch:FireServer(target.Position) end) end
end

-- // AUTO LOOP
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if Settings.AutoFarm and LP.Character then
                local enemy, dist = GetNearestEnemy()
                if enemy then
                    if dist > 8 then
                        local hrp = enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then TweenTo(hrp.CFrame, 70) end
                    else
                        AttackPlayer(enemy)
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
                local enemy, dist = GetNearestEnemy()
                if enemy and dist <= Settings.KillAuraRange then
                    AttackPlayer(enemy)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoArrest and LP.Team and LP.Team.Name == "Police" then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Criminals" then
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        local target = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and target and (hrp.Position - target.Position).Magnitude < 8 then
                            local arrest = Remotes["Arrest"] or Remotes["Cuff"]
                            if arrest then arrest:FireServer(p) end
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Settings.AutoTase and LP.Team and LP.Team.Name == "Police" then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Team and p.Team.Name == "Criminals" then
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        local target = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and target and (hrp.Position - target.Position).Magnitude < 15 then
                            local tase = Remotes["Tase"] or Remotes["Taser"]
                            if tase then tase:FireServer(p) end
                        end
                    end
                end
            end
        end)
    end
end)

-- // AUTO ROBBERY
task.spawn(function()
    local bankVault = CFrame.new(20,18,790)
    local bankRoof = CFrame.new(10,85,770)
    local bankEscape = CFrame.new(-10,18,770)
    local jewelryBoxes = CFrame.new(130,18,1315)
    local jewelryRoof = CFrame.new(133,100,1315)
    local jewelryTurnIn = CFrame.new(-235,18,1610)
    local museumMummy = CFrame.new(1060,101,1250)
    local museumTurnIn = CFrame.new(1630,50,-1760)

    while task.wait(2) do
        pcall(function()
            if Settings.AutoRob then
                local bank = Workspace:FindFirstChild("Banks")
                if bank and bank:GetAttribute("Open") then
                    TweenTo(bankRoof, 100)
                    task.wait(0.5)
                    TweenTo(bankVault, 80)
                    task.wait(15)
                    TweenTo(bankEscape, 80)
                end
                local jewelry = Workspace:FindFirstChild("Jewelrys")
                if jewelry and jewelry:GetAttribute("Open") then
                    TweenTo(jewelryRoof, 100)
                    task.wait(0.5)
                    TweenTo(jewelryBoxes, 80)
                    task.wait(12)
                    TweenTo(jewelryTurnIn, 100)
                end
                local museum = Workspace:FindFirstChild("Museum")
                if museum and museum:GetAttribute("Open") then
                    TweenTo(museumMummy, 80)
                    task.wait(10)
                    TweenTo(museumTurnIn, 100)
                end
            end
        end)
    end
end)

-- // AUTO DONUT (HEAL)
task.spawn(function()
    local donutShop = CFrame.new(267,18,-1763)
    while task.wait(5) do
        pcall(function()
            if Settings.AutoDonut and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum and hum.Health < 80 then
                    TweenTo(donutShop, 60)
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
                if hum.WalkSpeed ~= Settings.WalkSpeed then hum.WalkSpeed = Settings.WalkSpeed end
                if hum.JumpPower ~= Settings.JumpPower then hum.JumpPower = Settings.JumpPower end
            end
        end)
    end
end)

-- // ========== UI (MOBILE OPTIMIZED - CLEAN AF) ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 500)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ELITE HUB v1.0.0"
title.TextColor3 = Color3.fromRGB(46, 204, 113)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 70, 1, 0)
fpsLabel.Position = UDim2.new(1, -85, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "60 FPS"
fpsLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 13
fpsLabel.Parent = titleBar

-- FPS counter update
local frameCount = 0
local lastSecond = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastSecond >= 1 then
        fpsLabel.Text = frameCount .. " FPS"
        frameCount = 0
        lastSecond = tick()
    end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- SCROLLING FRAME
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 3
scroll.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scroll

-- Helper: large mobile button
local function MakeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 55)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = scroll
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function MakeToggle(text, setting, onColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = scroll
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,240)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 40)
    btn.Position = UDim2.new(1, -85, 0.5, -20)
    btn.BackgroundColor3 = Settings[setting] and (onColor or Color3.fromRGB(46,204,113)) or Color3.fromRGB(50,50,60)
    btn.Text = Settings[setting] and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        btn.Text = Settings[setting] and "ON" or "OFF"
        btn.BackgroundColor3 = Settings[setting] and (onColor or Color3.fromRGB(46,204,113)) or Color3.fromRGB(50,50,60)
        SaveSettings()
        if setting == "Fly" then ToggleFly() end
        if setting == "Noclip" then ToggleNoclip() end
        if setting == "ESP" then UpdateESP() end
        if setting == "FullBright" then ToggleFullBright() end
    end)
end

local function MakeSlider(text, setting, min, max)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 75)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = scroll
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(Settings[setting])
    label.TextColor3 = Color3.fromRGB(220,220,240)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 6)
    sliderBg.Position = UDim2.new(0, 15, 0, 45)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45,45,55)
    sliderBg.Parent = frame
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1,0)
    bgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(46,204,113)
    fill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1,0)
    fillCorner.Parent = fill

    local valueBtn = Instance.new("TextButton")
    valueBtn.Size = UDim2.new(0, 55, 0, 30)
    valueBtn.Position = UDim2.new(1, -70, 0, 40)
    valueBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
    valueBtn.Text = tostring(Settings[setting])
    valueBtn.TextColor3 = Color3.fromRGB(46,204,113)
    valueBtn.Font = Enum.Font.GothamBold
    valueBtn.TextSize = 14
    valueBtn.Parent = frame
    local valCorner = Instance.new("UICorner")
    valCorner.CornerRadius = UDim.new(0, 6)
    valCorner.Parent = valueBtn

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
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
end

-- // BUILD UI
MakeToggle("🤖 AUTO FARM (Cops/Prisoners)", "AutoFarm")
MakeToggle("⚔️ KILL AURA", "KillAura")
MakeSlider("🎯 KILL RANGE", "KillAuraRange", 10, 80)

MakeToggle("🚔 AUTO ARREST (Cop)", "AutoArrest")
MakeToggle("⚡ AUTO TASE (Cop)", "AutoTase")

MakeToggle("💰 AUTO ROBBERY", "AutoRob")
MakeToggle("🍩 AUTO DONUT (Heal)", "AutoDonut")

MakeToggle("🕊️ FLY MODE", "Fly")
MakeSlider("💨 FLY SPEED", "FlySpeed", 30, 250)
MakeToggle("🌀 NOCLIP", "Noclip")
MakeSlider("🏃 WALK SPEED", "WalkSpeed", 16, 200)
MakeSlider("🦘 JUMP POWER", "JumpPower", 50, 200)

MakeToggle("👻 ESP (Wallhack)", "ESP")
MakeToggle("☀️ FULLBRIGHT", "FullBright")

MakeToggle("💀 ANTI AFK", "AntiAFK")

MakeButton("💬 DISCORD (COPY LINK)", Color3.fromRGB(88,101,242), function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="ELITE HUB", Text="LINK COPIED BITCH 🥀", Duration=2})
end)

MakeButton("💾 SAVE SETTINGS", Color3.fromRGB(46,204,113), function() SaveSettings() end)
MakeButton("❌ DESTROY UI", Color3.fromRGB(200,50,50), function() screenGui:Destroy() end)

-- Update canvas height
local function UpdateCanvas()
    local total = 0
    for _, v in pairs(scroll:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") then
            total = total + v.Size.Y.Offset + 8
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, total + 20)
end
task.wait(0.1)
UpdateCanvas()

-- // STARTUP NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED YOU BITCH - 9,338 MEMBERS 🥀",
    Duration = 3
})

print("ELITE HUB v1.0.0 - MOBILE OPTIMIZED - GO FUCK SHIT UP 🥀")