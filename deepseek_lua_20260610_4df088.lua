-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // 9,338 MEMBERS - FUCK YOU IF YOU STEAL 🥀

local HttpService = game:GetService("HttpService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local settingsKey = "EliteHub_Settings_" .. lp.UserId

// ALL FUCKING SETTINGS
local Settings = {
    KillAura = false, KillAuraRange = 35, KillAuraDelay = 0.1,
    AutoFarmCops = false, AutoFarmPrisoners = false,
    AutoBank = false, AutoJewelry = false, AutoMuseum = false,
    Fly = false, FlySpeed = 85, Noclip = false, WalkSpeed = 24, JumpPower = 65,
    AutoSprint = false, AntiRagdoll = true, InfiniteJump = false,
    ESP = false, ESPColor = Color3.fromRGB(255,0,0), FullBright = false, NoFog = false,
    AutoDonut = false, AutoKeycard = false, AutoTeam = false, AutoMerchant = false,
    AntiAFK = true, AutoSkillTree = false,
    Flying = false,
}

// LOAD SAVED SETTINGS BITCH
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

// LOAD MACLIB
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

// ==================== LOADING SCREEN (FUCK YES) ====================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EliteHubLoading"
loadingGui.Parent = CoreGui
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loadingBg = Instance.new("Frame")
loadingBg.Size = UDim2.new(1, 0, 1, 0)
loadingBg.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
loadingBg.Parent = loadingGui

local loadingCenter = Instance.new("Frame")
loadingCenter.Size = UDim2.new(0, 350, 0, 280)
loadingCenter.Position = UDim2.new(0.5, -175, 0.5, -140)
loadingCenter.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
loadingCenter.BackgroundTransparency = 0.05
loadingCenter.Parent = loadingBg

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingCenter

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 0, 50)
titleText.Position = UDim2.new(0, 0, 0, 20)
titleText.BackgroundTransparency = 1
titleText.Text = "ELITE HUB"
titleText.TextColor3 = Color3.fromRGB(46, 204, 113)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 36
titleText.TextScaled = true
titleText.Parent = loadingCenter

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 0, 25)
statusText.Position = UDim2.new(0, 20, 0, 85)
statusText.BackgroundTransparency = 1
statusText.Text = "FUCKING LOADING..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 200)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 12
statusText.Parent = loadingCenter

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 8)
barBg.Position = UDim2.new(0.1, 0, 0, 125)
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
skipBtn.Size = UDim2.new(0, 120, 0, 35)
skipBtn.Position = UDim2.new(0.5, -60, 0, 160)
skipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
skipBtn.Text = "SKIP THIS SHIT 🥀"
skipBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
skipBtn.Font = Enum.Font.GothamBold
skipBtn.TextSize = 12
skipBtn.Parent = loadingCenter

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 6)
skipCorner.Parent = skipBtn

local loadingSteps = {
    "INJECTING THIS BITCH...",
    "BYPASSING JAILBREAK SHIT...",
    "LOADING ESP AND CHEATS...",
    "FUCKING READY 🥀"
}

local loadingComplete = false
local skipPressed = false

skipBtn.MouseButton1Click:Connect(function()
    skipPressed = true
    loadingComplete = true
    TweenService:Create(loadingBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    loadingGui:Destroy()
    CreateUI()
end)

task.spawn(function()
    for i, step in ipairs(loadingSteps) do
        if skipPressed then break end
        statusText.Text = step
        TweenService:Create(barFill, TweenInfo.new(0.3), {Size = UDim2.new(i / #loadingSteps, 0, 1, 0)}):Play()
        task.wait(0.4)
    end
    if not skipPressed then
        task.wait(0.2)
        TweenService:Create(loadingBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        loadingGui:Destroy()
        CreateUI()
    end
end)

// ==================== DISCORD NOTIFICATION (FUCKING POPUP) ====================
task.wait(0.5)
local discordPopup = Instance.new("ScreenGui")
discordPopup.Name = "DiscordBitch"
discordPopup.Parent = CoreGui

local popupFrame = Instance.new("Frame")
popupFrame.Size = UDim2.new(0, 320, 0, 140)
popupFrame.Position = UDim2.new(0.5, -160, 0.5, -70)
popupFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
popupFrame.BackgroundTransparency = 1
popupFrame.Parent = discordPopup

local popupCorner = Instance.new("UICorner")
popupCorner.CornerRadius = UDim.new(0, 10)
popupCorner.Parent = popupFrame

local popupTitle = Instance.new("TextLabel")
popupTitle.Size = UDim2.new(1, 0, 0, 35)
popupTitle.Position = UDim2.new(0, 0, 0, 10)
popupTitle.BackgroundTransparency = 1
popupTitle.Text = "🔥 JOIN OUR DISCORD 🔥"
popupTitle.TextColor3 = Color3.fromRGB(46, 204, 113)
popupTitle.Font = Enum.Font.GothamBold
popupTitle.TextSize = 16
popupTitle.Parent = popupFrame

local popupMsg = Instance.new("TextLabel")
popupMsg.Size = UDim2.new(1, -20, 0, 40)
popupMsg.Position = UDim2.new(0, 10, 0, 50)
popupMsg.BackgroundTransparency = 1
popupMsg.Text = "9,338 MEMBERS BITCH!\ndiscord.gg/5RuMCxK3u6"
popupMsg.TextColor3 = Color3.fromRGB(180, 180, 200)
popupMsg.Font = Enum.Font.Gotham
popupMsg.TextSize = 11
popupMsg.TextWrapped = true
popupMsg.Parent = popupFrame

local joinBtn = Instance.new("TextButton")
joinBtn.Size = UDim2.new(0, 130, 0, 35)
joinBtn.Position = UDim2.new(0.5, -140, 0, 95)
joinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
joinBtn.Text = "JOIN (COPY LINK)"
joinBtn.TextColor3 = Color3.new(1,1,1)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 11
joinBtn.Parent = popupFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 80, 0, 35)
closeBtn.Position = UDim2.new(0.5, 50, 0, 95)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
closeBtn.Text = "FUCK OFF"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.Parent = popupFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = joinBtn

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = closeBtn

joinBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    TweenService:Create(popupFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    discordPopup:Destroy()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(popupFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    discordPopup:Destroy()
end)

TweenService:Create(popupFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

// ==================== FUNCTIONS ====================
print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - LOADED BITCH 🥀")
print("DISCORD: discord.gg/5RuMCxK3u6 - 9,338 MEMBERS")

// FPS + MS COUNTER
local fps = 60
local ping = 0
local lastTime = tick()
local frameCount = 0

local function GetPing()
    local stats = Stats:FindFirstChild("Network")
    if stats then
        local pingStat = stats:FindFirstChild("Ping")
        if pingStat then return math.floor(pingStat:GetValue()) end
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

// ANTI AFK
if Settings.AntiAFK then
    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.3)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
end

// ANTI RAGDOLL
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

// INFINITE JUMP
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

// AUTO TEAM
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

// FLY FUNCTION
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

// NOCLIP
local noclipConn = nil
local function ToggleNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    else
        noclipConn = RunService.RenderStepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

// FULLBRIGHT
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

// NO FOG
local function ToggleNoFog()
    Settings.NoFog = not Settings.NoFog
    if Settings.NoFog then Lighting.FogEnd = 100000 else Lighting.FogEnd = 1000 end
    SaveSettings()
end

// FOV CHANGER
if Settings.FOVChanger then
    task.spawn(function()
        while task.wait(0.1) do
            pcall(function() if Camera then Camera.FieldOfView = Settings.FOVAmount end end)
        end
    end)
end

// ESP
local espObjects = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Settings.ESPColor
                highlight.FillTransparency = 0.5
                highlight.Parent = player.Character
                espObjects[player] = highlight
            elseif (not player.Character or not Settings.ESP) and espObjects[player] then
                pcall(function() espObjects[player]:Destroy() end)
                espObjects[player] = nil
            end
        end
    else
        for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
        espObjects = {}
    end
end

Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(p) if espObjects[p] then pcall(function() espObjects[p]:Destroy() end) end end)

// LOCATIONS
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Donut = CFrame.new(267, 18, -1763),
}

local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    local tween = TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

local function GetNearestPlayer(team)
    local nearest, shortest = nil, 1000
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if team == nil or (player.Team and player.Team.Name == team) then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target then
                        local dist = (hrp.Position - target.Position).Magnitude
                        if dist < shortest then shortest, nearest = dist, player end
                    end
                end
            end
        end
    end
    return nearest, shortest
end

local function AttackPlayer(player)
    if not player or not player.Character then return end
    local hrp, target = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"), player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
        task.wait(0.05)
        local punch = ReplicatedStorage:FindFirstChild("Punch")
        if punch then pcall(function() punch:FireServer(target.Position) end) end
    end
end

// AUTO FARM LOOPS
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarmCops and LP.Character then
                local cop, dist = GetNearestPlayer("Police")
                if cop then
                    if dist > 15 then
                        local hrp = cop.Character and cop.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then TweenTo(hrp.CFrame, 70) end
                    else AttackPlayer(cop) end
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
                    else AttackPlayer(prisoner) end
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
                if player and dist <= Settings.KillAuraRange then AttackPlayer(player) end
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
                if hum and hum.Health < 80 then TweenTo(Locations.Donut, 60) task.wait(1) end
            end
        end)
    end
end)

// MOVEMENT LOOP
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                local hum = LP.Character.Humanoid
                if hum.WalkSpeed ~= Settings.WalkSpeed then hum.WalkSpeed = Settings.WalkSpeed end
                if hum.JumpPower ~= Settings.JumpPower then hum.JumpPower = Settings.JumpPower end
                if Settings.AutoSprint then hum.AutoRotate = true end
            end
        end)
    end
end)

// ==================== CREATE UI (WIDER + SHORTER + MOVABLE) ====================
function CreateUI()
    local Window = MacLib:Window({
        Title = "ELITE HUB v1.0.0",
        Subtitle = fps .. " FPS | " .. ping .. " MS | 9,338 MEMBERS",
        Size = UDim2.fromOffset(500, 400),
        DragStyle = 1,
        AcrylicBlur = true,
        Keybind = Enum.KeyCode.RightControl,
        Movable = true,
    })

    task.spawn(function()
        while task.wait(1) do
            pcall(function() Window.Settings.Subtitle = fps .. " FPS | " .. ping .. " MS | 9,338 MEMBERS 🥀" end)
        end
    end)

    local tabGroup = Window:TabGroup()

    // CALLBACK WRAPPERS
    local function makeToggleCallback(setting, callback)
        return function(v) Settings[setting] = v; SaveSettings(); if callback then callback(v) end end
    end
    local function makeSliderCallback(setting, callback)
        return function(v) Settings[setting] = v; SaveSettings(); if callback then callback(v) end end
    end

    // TAB 1: AUTOMATION
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
    autoRight:Toggle({ Name = "Buy Keycard", Default = false, Callback = makeToggleCallback("AutoKeycard") })

    // TAB 2: COMBAT
    local combatTab = tabGroup:Tab({ Name = "COMBAT" })
    local combatLeft = combatTab:Section({ Side = "Left" })
    local combatRight = combatTab:Section({ Side = "Right" })

    combatLeft:Header({ Name = "⚔️ KILL THAT BITCH" })
    combatLeft:Toggle({ Name = "Kill Aura", Default = Settings.KillAura, Callback = makeToggleCallback("KillAura") })
    combatLeft:Slider({ Name = "Range", Default = Settings.KillAuraRange, Minimum = 10, Maximum = 100, Callback = makeSliderCallback("KillAuraRange") })
    combatLeft:Slider({ Name = "Delay", Default = Settings.KillAuraDelay, Minimum = 0.05, Maximum = 1, Precision = 2, Callback = makeSliderCallback("KillAuraDelay") })
    combatLeft:Toggle({ Name = "Auto Farm Cops", Default = Settings.AutoFarmCops, Callback = makeToggleCallback("AutoFarmCops") })
    combatLeft:Toggle({ Name = "Auto Farm Prisoners", Default = Settings.AutoFarmPrisoners, Callback = makeToggleCallback("AutoFarmPrisoners") })

    combatRight:Header({ Name = "💰 ROBBERY" })
    combatRight:Toggle({ Name = "Auto Bank", Default = Settings.AutoBank, Callback = makeToggleCallback("AutoBank") })
    combatRight:Toggle({ Name = "Auto Jewelry", Default = Settings.AutoJewelry, Callback = makeToggleCallback("AutoJewelry") })
    combatRight:Toggle({ Name = "Auto Museum", Default = Settings.AutoMuseum, Callback = makeToggleCallback("AutoMuseum") })

    // TAB 3: MOVEMENT
    local moveTab = tabGroup:Tab({ Name = "MOVE" })
    local moveLeft = moveTab:Section({ Side = "Left" })
    local moveRight = moveTab:Section({ Side = "Right" })

    moveLeft:Header({ Name = "🌀 GO FAST AS FUCK" })
    moveLeft:Toggle({ Name = "Fly", Default = false, Callback = function(v) ToggleFly() end })
    moveLeft:Slider({ Name = "Fly Speed", Default = Settings.FlySpeed, Minimum = 30, Maximum = 250, Callback = makeSliderCallback("FlySpeed") })
    moveLeft:Toggle({ Name = "Noclip", Default = false, Callback = function(v) ToggleNoclip() end })
    moveLeft:Toggle({ Name = "Auto Sprint", Default = Settings.AutoSprint, Callback = makeToggleCallback("AutoSprint") })
    moveLeft:Toggle({ Name = "Infinite Jump", Default = Settings.InfiniteJump, Callback = function(v) ToggleInfiniteJump() end })

    moveRight:Header({ Name = "⚡ STATS" })
    moveRight:Slider({ Name = "Walk Speed", Default = Settings.WalkSpeed, Minimum = 16, Maximum = 200, Callback = makeSliderCallback("WalkSpeed") })
    moveRight:Slider({ Name = "Jump Power", Default = Settings.JumpPower, Minimum = 50, Maximum = 200, Callback = makeSliderCallback("JumpPower") })
    moveRight:Toggle({ Name = "Anti Ragdoll", Default = Settings.AntiRagdoll, Callback = makeToggleCallback("AntiRagdoll") })
    moveRight:Toggle({ Name = "No Fall Damage", Default = Settings.NoFallDamage, Callback = makeToggleCallback("NoFallDamage") })

    // TAB 4: VISUALS
    local visTab = tabGroup:Tab({ Name = "VISUALS" })
    local visLeft = visTab:Section({ Side = "Left" })
    local visRight = visTab:Section({ Side = "Right" })

    visLeft:Header({ Name = "👁️ SEE THEIR BITCH ASS" })
    visLeft:Toggle({ Name = "ESP", Default = Settings.ESP, Callback = makeToggleCallback("ESP", UpdateESP) })
    visLeft:Colorpicker({ Name = "ESP Color", Default = Settings.ESPColor, Callback = function(c) Settings.ESPColor = c; UpdateESP(); SaveSettings() end })
    visLeft:Toggle({ Name = "Fullbright", Default = Settings.FullBright, Callback = makeToggleCallback("FullBright", ToggleFullBright) })

    visRight:Header({ Name = "📷 CAMERA" })
    visRight:Toggle({ Name = "FOV Changer", Default = Settings.FOVChanger, Callback = makeToggleCallback("FOVChanger") })
    visRight:Slider({ Name = "FOV Amount", Default = Settings.FOVAmount, Minimum = 70, Maximum = 120, Callback = makeSliderCallback("FOVAmount") })
    visRight:Toggle({ Name = "No Fog", Default = Settings.NoFog, Callback = makeToggleCallback("NoFog", ToggleNoFog) })

    // TAB 5: UTILITY
    local utilTab = tabGroup:Tab({ Name = "UTILITY" })
    local utilLeft = utilTab:Section({ Side = "Left" })
    local utilRight = utilTab:Section({ Side = "Right" })

    utilLeft:Header({ Name = "🛠️ QOL SHIT" })
    utilLeft:Toggle({ Name = "Auto Donut (Heal)", Default = Settings.AutoDonut, Callback = makeToggleCallback("AutoDonut") })
    utilLeft:Toggle({ Name = "Auto Keycard", Default = Settings.AutoKeycard, Callback = makeToggleCallback("AutoKeycard") })
    utilLeft:Toggle({ Name = "Auto Team", Default = Settings.AutoTeam, Callback = makeToggleCallback("AutoTeam", AutoTeam) })
    utilLeft:Toggle({ Name = "Anti AFK", Default = Settings.AntiAFK, Callback = makeToggleCallback("AntiAFK") })

    utilRight:Header({ Name = "💬 DISCORD" })
    utilRight:Button({ Name = "JOIN DISCORD (COPY LINK)", Callback = function()
        setclipboard("https://discord.gg/5RuMCxK3u6")
        Window:Notify({ Title = "ELITE HUB", Description = "LINK COPIED BITCH 🥀", Lifetime = 2 })
    end })
    utilRight:Button({ Name = "DESTROY UI", Callback = function() Window:Unload() end })

    // TAB 6: SETTINGS
    local setTab = tabGroup:Tab({ Name = "SAVE" })
    setTab:InsertConfigSection("Left")
    setTab:Button({ Name = "SAVE ALL SETTINGS", Callback = function()
        SaveSettings()
        Window:Notify({ Title = "ELITE HUB", Description = "SETTINGS SAVED!", Lifetime = 2 })
    end })

    autoTab:Select()
    Window:Notify({ Title = "ELITE HUB v1.0.0", Description = "LOADED YOU BITCH - 9,338 MEMBERS 🥀", Lifetime = 3 })
    print("ELITE HUB FULLY LOADED - GO FUCK SHIT UP 🥀")
end