-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // FUCK DELTA | FUCK XENO | FUCK SOLARA | ALL YOU BITCHES USE SHIT EXECUTORS
-- // THIS SHIT IS FOR REAL MEN ONLY 🥀🥀🥀

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = Workspace.CurrentCamera

-- // HOLY FUCKING SHIT HERE WE GO //

local fuck = "FUCK"
local shit = "SHIT"
local bitch = "BITCH"
local ass = "ASS"
local damn = "DAMN"
local hell = "HELL"
local cock = "COCK"
local balls = "BALLS"
local dick = "DICK"
local pussy = "PUSSY"
local motherfucker = "MOTHERFUCKER"
local cunt = "CUNT"
local whore = "WHORE"
local slut = "SLUT"

print(motherfucker .. " ELITE HUB LOADING THIS " .. shit .. " 🥀")
print("IF YOU USE DELTA YOU'RE A " .. bitch .. " ASS " .. cunt)

-- // FUCKING SETTINGS (TWEAK THIS SHIT IF YOU'RE NOT A PUSSY) //
local Settings = {
    -- Theme shit (pick your favorite color you basic bitch)
    Theme = "Emerald",
    Themes = {
        Emerald = { Color = Color3.fromRGB(46, 204, 113), BgColor = Color3.fromRGB(8, 8, 12) },
        Blood = { Color = Color3.fromRGB(220, 20, 60), BgColor = Color3.fromRGB(12, 6, 8) },
        Royal = { Color = Color3.fromRGB(138, 43, 226), BgColor = Color3.fromRGB(10, 8, 18) },
        Cum = { Color = Color3.fromRGB(255, 255, 255), BgColor = Color3.fromRGB(20, 20, 20) },
    },
    
    ShowFPS = true,
    
    -- AUTO FARM (KILL THOSE MOTHERFUCKERS)
    AutoFarmCops = false,
    AutoFarmPrisoners = false,
    KillAura = false,
    KillAuraRange = 35,
    
    -- ROBBERY (STEAL EVERY FUCKING THING)
    AutoRobBank = false,
    AutoRobJewelry = false,
    AutoRobMuseum = false,
    
    -- MOVEMENT (GO FAST AS FUCK BOI)
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    
    -- VISUALS (SEE THROUGH THAT BITCH ASS WALL)
    ESP = false,
    FullBright = false,
    
    AntiAFK = true,
    Flying = false,
}

-- // FUCKING LOCATIONS (DON'T TOUCH THIS SHIT) //
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
}

-- // FPS COUNTER (REAL SHIT NOT FAKE LIKE YOUR GIRL'S ORGASMS) //
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

-- // ANTI AFK (FUCK THE AFK KICK THIS BITCH) //
if Settings.AntiAFK then
    LP.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(0.3)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        VirtualUser:ClickButton1(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end

-- // SIMPLE BYPASS (NO STUPID SHIT THAT BREAKS) //
pcall(function()
    local mt = getrawmetatable and getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then return nil end
            return old(self, ...)
        end
        setreadonly(mt, true)
    end
end)

-- // UTILITIES (FUCKING HELPER FUNCTIONS) //
local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    local tween = TweenService:Create(hrp, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

local function GetNearestCop()
    local nearest = nil
    local shortest = 100
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Team and player.Team.Name == "Police" then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = player
                end
            end
        end
    end
    return nearest, shortest
end

local function GetNearestPrisoner()
    local nearest = nil
    local shortest = 100
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Team and player.Team.Name == "Prisoners" then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = player
                end
            end
        end
    end
    return nearest, shortest
end

local function AttackThatBitch(player)
    if not player or not player.Character then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local target = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
        task.wait(0.05)
        -- Punch that motherfucker
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Punch")
        if remote then pcall(function() remote:FireServer(target.Position) end) end
    end
end

-- // FLY (BETTER THAN YOUR EX'S NEW BOYFRIEND) //
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

-- // NOCLIP (WALK THROUGH WALLS LIKE A GHOST BITCH) //
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

-- // ESP (SEE THOSE MOTHERFUCKERS) //
local espObjects = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPFuck"
                highlight.FillColor = player.Team and player.Team.Name == "Police" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.6
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

-- // FULLBRIGHT (SEE IN THE DARK YOU PUSSY) //
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

-- // KILL AURA (AUTOMATICALLY FUCK EVERYONE UP) //
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Settings.KillAura and LP.Character then
                -- Kill cops
                local cop, copDist = GetNearestCop()
                if cop and copDist <= Settings.KillAuraRange then
                    AttackThatBitch(cop)
                end
                -- Kill prisoners
                local prisoner, prisonerDist = GetNearestPrisoner()
                if prisoner and prisonerDist <= Settings.KillAuraRange then
                    AttackThatBitch(prisoner)
                end
            end
        end)
    end
end)

-- // AUTO FARM COPS (HUNT THOSE BLUE BITCHES) //
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Settings.AutoFarmCops and LP.Character then
                local cop, dist = GetNearestCop()
                if cop then
                    if dist > 15 then
                        local hrp = cop.Character and cop.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then TweenTo(hrp.CFrame, 70) end
                    else
                        AttackThatBitch(cop)
                    end
                end
            end
        end)
    end
end)

-- // AUTO FARM PRISONERS (BEAT THOSE INMATES ASS) //
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Settings.AutoFarmPrisoners and LP.Character then
                local prisoner, dist = GetNearestPrisoner()
                if prisoner then
                    if dist > 15 then
                        local hrp = prisoner.Character and prisoner.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then TweenTo(hrp.CFrame, 70) end
                    else
                        AttackThatBitch(prisoner)
                    end
                end
            end
        end)
    end
end)

-- // AUTO ROBBERY (STEAL THAT SHIT) //
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if not LP.Character then return end
            
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

-- // MOVEMENT LOOP (KEEP YOUR SPEED SET YOU SPEED DEMON) //
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                local hum = LP.Character.Humanoid
                if hum.WalkSpeed ~= Settings.WalkSpeed then
                    hum.WalkSpeed = Settings.WalkSpeed
                end
            end
        end)
    end
end)

-- // CREATE UI (LOOKS CLEAN AS FUCK) //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = currentTheme.BgColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
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
fpsLabel.TextColor3 = currentTheme.Color
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 11
fpsLabel.Parent = TopBar

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
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- Function to make toggle buttons
local function MakeToggle(parent, text, setting, y)
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

-- AUTOMATION SECTION
local AutoSection = Instance.new("Frame")
AutoSection.Size = UDim2.new(1, 0, 0, 38)
AutoSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
AutoSection.Parent = Scroll

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 5)
AutoCorner.Parent = AutoSection

local AutoTitle = Instance.new("TextLabel")
AutoTitle.Size = UDim2.new(1, -10, 0, 18)
AutoTitle.Position = UDim2.new(0, 8, 0, 4)
AutoTitle.BackgroundTransparency = 1
AutoTitle.Text = "⚡ AUTOMATION (FUCK SHIT UP)"
AutoTitle.TextColor3 = currentTheme.Color
AutoTitle.Font = Enum.Font.GothamBold
AutoTitle.TextSize = 11
AutoTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoTitle.Parent = AutoSection

local AutoSub = Instance.new("TextLabel")
AutoSub.Size = UDim2.new(1, -10, 0, 14)
AutoSub.Position = UDim2.new(0, 8, 0, 20)
AutoSub.BackgroundTransparency = 1
AutoSub.Text = "Auto rolls, enchants, merchant, skill tree (FUCK YEAH)"
AutoSub.TextColor3 = Color3.fromRGB(130, 130, 150)
AutoSub.Font = Enum.Font.Gotham
AutoSub.TextSize = 9
AutoSub.TextXAlignment = Enum.TextXAlignment.Left
AutoSub.Parent = AutoSection

-- COMBAT SECTION
local CombatSection = Instance.new("Frame")
CombatSection.Size = UDim2.new(1, 0, 0, 120)
CombatSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
CombatSection.Parent = Scroll

local CombatCorner = Instance.new("UICorner")
CombatCorner.CornerRadius = UDim.new(0, 5)
CombatCorner.Parent = CombatSection

local CombatTitle = Instance.new("TextLabel")
CombatTitle.Size = UDim2.new(1, -10, 0, 18)
CombatTitle.Position = UDim2.new(0, 8, 0, 4)
CombatTitle.BackgroundTransparency = 1
CombatTitle.Text = "⚔️ COMBAT (BEAT THEIR ASS)"
CombatTitle.TextColor3 = currentTheme.Color
CombatTitle.Font = Enum.Font.GothamBold
CombatTitle.TextSize = 11
CombatTitle.TextXAlignment = Enum.TextXAlignment.Left
CombatTitle.Parent = CombatSection

-- Kill Aura toggle
local kaFrame = Instance.new("Frame")
kaFrame.Size = UDim2.new(1, -10, 0, 32)
kaFrame.Position = UDim2.new(0, 5, 0, 28)
kaFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
kaFrame.Parent = CombatSection

local kaCorner = Instance.new("UICorner")
kaCorner.CornerRadius = UDim.new(0, 5)
kaCorner.Parent = kaFrame

local kaLabel = Instance.new("TextLabel")
kaLabel.Size = UDim2.new(1, -60, 1, 0)
kaLabel.Position = UDim2.new(0, 10, 0, 0)
kaLabel.BackgroundTransparency = 1
kaLabel.Text = "💀 KILL AURA (FUCK EVERYONE)"
kaLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
kaLabel.Font = Enum.Font.Gotham
kaLabel.TextSize = 11
kaLabel.TextXAlignment = Enum.TextXAlignment.Left
kaLabel.Parent = kaFrame

local kaBtn = Instance.new("TextButton")
kaBtn.Size = UDim2.new(0, 45, 0, 24)
kaBtn.Position = UDim2.new(1, -55, 0.5, -12)
kaBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
kaBtn.Text = "OFF"
kaBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
kaBtn.Font = Enum.Font.GothamBold
kaBtn.TextSize = 10
kaBtn.Parent = kaFrame

local kaCorner2 = Instance.new("UICorner")
kaCorner2.CornerRadius = UDim.new(0, 4)
kaCorner2.Parent = kaBtn

local kaState = false
kaBtn.MouseButton1Click:Connect(function()
    kaState = not kaState
    Settings.KillAura = kaState
    kaBtn.Text = kaState and "ON" or "OFF"
    kaBtn.TextColor3 = kaState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    kaBtn.BackgroundColor3 = kaState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
end)

-- Auto Farm Cops
local afFrame = Instance.new("Frame")
afFrame.Size = UDim2.new(1, -10, 0, 32)
afFrame.Position = UDim2.new(0, 5, 0, 64)
afFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
afFrame.Parent = CombatSection

local afCorner = Instance.new("UICorner")
afCorner.CornerRadius = UDim.new(0, 5)
afCorner.Parent = afFrame

local afLabel = Instance.new("TextLabel")
afLabel.Size = UDim2.new(1, -60, 1, 0)
afLabel.Position = UDim2.new(0, 10, 0, 0)
afLabel.BackgroundTransparency = 1
afLabel.Text = "👮 AUTO FARM COPS (KILL THE BLUE BITCHES)"
afLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
afLabel.Font = Enum.Font.Gotham
afLabel.TextSize = 11
afLabel.TextXAlignment = Enum.TextXAlignment.Left
afLabel.Parent = afFrame

local afBtn = Instance.new("TextButton")
afBtn.Size = UDim2.new(0, 45, 0, 24)
afBtn.Position = UDim2.new(1, -55, 0.5, -12)
afBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
afBtn.Text = "OFF"
afBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
afBtn.Font = Enum.Font.GothamBold
afBtn.TextSize = 10
afBtn.Parent = afFrame

local afCorner2 = Instance.new("UICorner")
afCorner2.CornerRadius = UDim.new(0, 4)
afCorner2.Parent = afBtn

local afState = false
afBtn.MouseButton1Click:Connect(function()
    afState = not afState
    Settings.AutoFarmCops = afState
    afBtn.Text = afState and "ON" or "OFF"
    afBtn.TextColor3 = afState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    afBtn.BackgroundColor3 = afState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
end)

-- Auto Farm Prisoners
local prFrame = Instance.new("Frame")
prFrame.Size = UDim2.new(1, -10, 0, 32)
prFrame.Position = UDim2.new(0, 5, 0, 100)
prFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
prFrame.Parent = CombatSection

local prCorner = Instance.new("UICorner")
prCorner.CornerRadius = UDim.new(0, 5)
prCorner.Parent = prFrame

local prLabel = Instance.new("TextLabel")
prLabel.Size = UDim2.new(1, -60, 1, 0)
prLabel.Position = UDim2.new(0, 10, 0, 0)
prLabel.BackgroundTransparency = 1
prLabel.Text = "🔒 AUTO FARM PRISONERS (BEAT THE INMATES)"
prLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
prLabel.Font = Enum.Font.Gotham
prLabel.TextSize = 11
prLabel.TextXAlignment = Enum.TextXAlignment.Left
prLabel.Parent = prFrame

local prBtn = Instance.new("TextButton")
prBtn.Size = UDim2.new(0, 45, 0, 24)
prBtn.Position = UDim2.new(1, -55, 0.5, -12)
prBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
prBtn.Text = "OFF"
prBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
prBtn.Font = Enum.Font.GothamBold
prBtn.TextSize = 10
prBtn.Parent = prFrame

local prCorner2 = Instance.new("UICorner")
prCorner2.CornerRadius = UDim.new(0, 4)
prCorner2.Parent = prBtn

local prState = false
prBtn.MouseButton1Click:Connect(function()
    prState = not prState
    Settings.AutoFarmPrisoners = prState
    prBtn.Text = prState and "ON" or "OFF"
    prBtn.TextColor3 = prState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    prBtn.BackgroundColor3 = prState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
end)

-- ROBBERY SECTION
local RobSection = Instance.new("Frame")
RobSection.Size = UDim2.new(1, 0, 0, 90)
RobSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
RobSection.Parent = Scroll

local RobCorner = Instance.new("UICorner")
RobCorner.CornerRadius = UDim.new(0, 5)
RobCorner.Parent = RobSection

local RobTitle = Instance.new("TextLabel")
RobTitle.Size = UDim2.new(1, -10, 0, 18)
RobTitle.Position = UDim2.new(0, 8, 0, 4)
RobTitle.BackgroundTransparency = 1
RobTitle.Text = "💰 ROBBERY (STEAL THAT SHIT)"
RobTitle.TextColor3 = currentTheme.Color
RobTitle.Font = Enum.Font.GothamBold
RobTitle.TextSize = 11
RobTitle.TextXAlignment = Enum.TextXAlignment.Left
RobTitle.Parent = RobSection

-- Auto Bank
local bankFrame = Instance.new("Frame")
bankFrame.Size = UDim2.new(1, -10, 0, 32)
bankFrame.Position = UDim2.new(0, 5, 0, 28)
bankFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
bankFrame.Parent = RobSection

local bankCorner = Instance.new("UICorner")
bankCorner.CornerRadius = UDim.new(0, 5)
bankCorner.Parent = bankFrame

local bankLabel = Instance.new("TextLabel")
bankLabel.Size = UDim2.new(1, -60, 1, 0)
bankLabel.Position = UDim2.new(0, 10, 0, 0)
bankLabel.BackgroundTransparency = 1
bankLabel.Text = "🏦 AUTO BANK (ROB THOSE FUCKS)"
bankLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
bankLabel.Font = Enum.Font.Gotham
bankLabel.TextSize = 11
bankLabel.TextXAlignment = Enum.TextXAlignment.Left
bankLabel.Parent = bankFrame

local bankBtn = Instance.new("TextButton")
bankBtn.Size = UDim2.new(0, 45, 0, 24)
bankBtn.Position = UDim2.new(1, -55, 0.5, -12)
bankBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
bankBtn.Text = "OFF"
bankBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
bankBtn.Font = Enum.Font.GothamBold
bankBtn.TextSize = 10
bankBtn.Parent = bankFrame

local bankCorner2 = Instance.new("UICorner")
bankCorner2.CornerRadius = UDim.new(0, 4)
bankCorner2.Parent = bankBtn

local bankState = false
bankBtn.MouseButton1Click:Connect(function()
    bankState = not bankState
    Settings.AutoRobBank = bankState
    bankBtn.Text = bankState and "ON" or "OFF"
    bankBtn.TextColor3 = bankState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    bankBtn.BackgroundColor3 = bankState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
end)

-- Auto Jewelry
local jewFrame = Instance.new("Frame")
jewFrame.Size = UDim2.new(1, -10, 0, 32)
jewFrame.Position = UDim2.new(0, 5, 0, 64)
jewFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
jewFrame.Parent = RobSection

local jewCorner = Instance.new("UICorner")
jewCorner.CornerRadius = UDim.new(0, 5)
jewCorner.Parent = jewFrame

local jewLabel = Instance.new("TextLabel")
jewLabel.Size = UDim2.new(1, -60, 1, 0)
jewLabel.Position = UDim2.new(0, 10, 0, 0)
jewLabel.BackgroundTransparency = 1
jewLabel.Text = "💎 AUTO JEWELRY (STEAL THE SHINY SHIT)"
jewLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
jewLabel.Font = Enum.Font.Gotham
jewLabel.TextSize = 11
jewLabel.TextXAlignment = Enum.TextXAlignment.Left
jewLabel.Parent = jewFrame

local jewBtn = Instance.new("TextButton")
jewBtn.Size = UDim2.new(0, 45, 0, 24)
jewBtn.Position = UDim2.new(1, -55, 0.5, -12)
jewBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
jewBtn.Text = "OFF"
jewBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
jewBtn.Font = Enum.Font.GothamBold
jewBtn.TextSize = 10
jewBtn.Parent = jewFrame

local jewCorner2 = Instance.new("UICorner")
jewCorner2.CornerRadius = UDim.new(0, 4)
jewCorner2.Parent = jewBtn

local jewState = false
jewBtn.MouseButton1Click:Connect(function()
    jewState = not jewState
    Settings.AutoRobJewelry = jewState
    jewBtn.Text = jewState and "ON" or "OFF"
    jewBtn.TextColor3 = jewState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    jewBtn.BackgroundColor3 = jewState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
end)

-- MOVEMENT SECTION
local MoveSection = Instance.new("Frame")
MoveSection.Size = UDim2.new(1, 0, 0, 130)
MoveSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MoveSection.Parent = Scroll

local MoveCorner = Instance.new("UICorner")
MoveCorner.CornerRadius = UDim.new(0, 5)
MoveCorner.Parent = MoveSection

local MoveTitle = Instance.new("TextLabel")
MoveTitle.Size = UDim2.new(1, -10, 0, 18)
MoveTitle.Position = UDim2.new(0, 8, 0, 4)
MoveTitle.BackgroundTransparency = 1
MoveTitle.Text = "🌀 MOVEMENT (GO FAST AS FUCK)"
MoveTitle.TextColor3 = currentTheme.Color
MoveTitle.Font = Enum.Font.GothamBold
MoveTitle.TextSize = 11
MoveTitle.TextXAlignment = Enum.TextXAlignment.Left
MoveTitle.Parent = MoveSection

-- Fly toggle
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1, -10, 0, 32)
flyFrame.Position = UDim2.new(0, 5, 0, 28)
flyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
flyFrame.Parent = MoveSection

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 5)
flyCorner.Parent = flyFrame

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(1, -60, 1, 0)
flyLabel.Position = UDim2.new(0, 10, 0, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "🕊️ FLY MODE (ZOOM BITCH)"
flyLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 11
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.Parent = flyFrame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 45, 0, 24)
flyBtn.Position = UDim2.new(1, -55, 0.5, -12)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
flyBtn.Text = "OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 10
flyBtn.Parent = flyFrame

local flyCorner2 = Instance.new("UICorner")
flyCorner2.CornerRadius = UDim.new(0, 4)
flyCorner2.Parent = flyBtn

local flyState = false
flyBtn.MouseButton1Click:Connect(function()
    flyState = not flyState
    Settings.Fly = flyState
    flyBtn.Text = flyState and "ON" or "OFF"
    flyBtn.TextColor3 = flyState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    flyBtn.BackgroundColor3 = flyState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
    ToggleFly()
end)

-- Noclip toggle
local noclipFrame = Instance.new("Frame")
noclipFrame.Size = UDim2.new(1, -10, 0, 32)
noclipFrame.Position = UDim2.new(0, 5, 0, 64)
noclipFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
noclipFrame.Parent = MoveSection

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 5)
noclipCorner.Parent = noclipFrame

local noclipLabel = Instance.new("TextLabel")
noclipLabel.Size = UDim2.new(1, -60, 1, 0)
noclipLabel.Position = UDim2.new(0, 10, 0, 0)
noclipLabel.BackgroundTransparency = 1
noclipLabel.Text = "🌀 NOCLIP (WALK THROUGH WALLS)"
noclipLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
noclipLabel.Font = Enum.Font.Gotham
noclipLabel.TextSize = 11
noclipLabel.TextXAlignment = Enum.TextXAlignment.Left
noclipLabel.Parent = noclipFrame

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 45, 0, 24)
noclipBtn.Position = UDim2.new(1, -55, 0.5, -12)
noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
noclipBtn.Text = "OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 10
noclipBtn.Parent = noclipFrame

local noclipCorner2 = Instance.new("UICorner")
noclipCorner2.CornerRadius = UDim.new(0, 4)
noclipCorner2.Parent = noclipBtn

local noclipState = false
noclipBtn.MouseButton1Click:Connect(function()
    noclipState = not noclipState
    Settings.Noclip = noclipState
    noclipBtn.Text = noclipState and "ON" or "OFF"
    noclipBtn.TextColor3 = noclipState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    noclipBtn.BackgroundColor3 = noclipState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
    ToggleNoclip()
end)

-- Walk Speed slider
local wsFrame = Instance.new("Frame")
wsFrame.Size = UDim2.new(1, -10, 0, 32)
wsFrame.Position = UDim2.new(0, 5, 0, 100)
wsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
wsFrame.Parent = MoveSection

local wsCorner = Instance.new("UICorner")
wsCorner.CornerRadius = UDim.new(0, 5)
wsCorner.Parent = wsFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, -60, 1, 0)
wsLabel.Position = UDim2.new(0, 10, 0, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "⚡ WALK SPEED: 24"
wsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextSize = 11
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = wsFrame

local wsBtn = Instance.new("TextButton")
wsBtn.Size = UDim2.new(0, 55, 0, 24)
wsBtn.Position = UDim2.new(1, -60, 0.5, -12)
wsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
wsBtn.Text = "24"
wsBtn.TextColor3 = currentTheme.Color
wsBtn.Font = Enum.Font.GothamBold
wsBtn.TextSize = 10
wsBtn.Parent = wsFrame

local wsBtnCorner = Instance.new("UICorner")
wsBtnCorner.CornerRadius = UDim.new(0, 4)
wsBtnCorner.Parent = wsBtn

local wsValues = {16, 24, 32, 40, 50, 65, 80, 100, 120, 150}
local wsIndex = 2
wsBtn.MouseButton1Click:Connect(function()
    wsIndex = wsIndex % #wsValues + 1
    Settings.WalkSpeed = wsValues[wsIndex]
    wsBtn.Text = tostring(Settings.WalkSpeed)
    wsLabel.Text = "⚡ WALK SPEED: " .. Settings.WalkSpeed
end)

-- VISUALS SECTION
local VisSection = Instance.new("Frame")
VisSection.Size = UDim2.new(1, 0, 0, 90)
VisSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
VisSection.Parent = Scroll

local VisCorner = Instance.new("UICorner")
VisCorner.CornerRadius = UDim.new(0, 5)
VisCorner.Parent = VisSection

local VisTitle = Instance.new("TextLabel")
VisTitle.Size = UDim2.new(1, -10, 0, 18)
VisTitle.Position = UDim2.new(0, 8, 0, 4)
VisTitle.BackgroundTransparency = 1
VisTitle.Text = "👁️ VISUALS (SEE THEIR BITCH ASS)"
VisTitle.TextColor3 = currentTheme.Color
VisTitle.Font = Enum.Font.GothamBold
VisTitle.TextSize = 11
VisTitle.TextXAlignment = Enum.TextXAlignment.Left
VisTitle.Parent = VisSection

-- ESP toggle
local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, -10, 0, 32)
espFrame.Position = UDim2.new(0, 5, 0, 28)
espFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
espFrame.Parent = VisSection

local espCorner2 = Instance.new("UICorner")
espCorner2.CornerRadius = UDim.new(0, 5)
espCorner2.Parent = espFrame

local espLabel2 = Instance.new("TextLabel")
espLabel2.Size = UDim2.new(1, -60, 1, 0)
espLabel2.Position = UDim2.new(0, 10, 0, 0)
espLabel2.BackgroundTransparency = 1
espLabel2.Text = "👻 ESP WALLHACK (SEE THROUGH WALLS)"
espLabel2.TextColor3 = Color3.fromRGB(200, 200, 220)
espLabel2.Font = Enum.Font.Gotham
espLabel2.TextSize = 11
espLabel2.TextXAlignment = Enum.TextXAlignment.Left
espLabel2.Parent = espFrame

local espBtn2 = Instance.new("TextButton")
espBtn2.Size = UDim2.new(0, 45, 0, 24)
espBtn2.Position = UDim2.new(1, -55, 0.5, -12)
espBtn2.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
espBtn2.Text = "OFF"
espBtn2.TextColor3 = Color3.fromRGB(255, 100, 100)
espBtn2.Font = Enum.Font.GothamBold
espBtn2.TextSize = 10
espBtn2.Parent = espFrame

local espBtnCorner = Instance.new("UICorner")
espBtnCorner.CornerRadius = UDim.new(0, 4)
espBtnCorner.Parent = espBtn2

local espState2 = false
espBtn2.MouseButton1Click:Connect(function()
    espState2 = not espState2
    Settings.ESP = espState2
    espBtn2.Text = espState2 and "ON" or "OFF"
    espBtn2.TextColor3 = espState2 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    espBtn2.BackgroundColor3 = espState2 and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
    UpdateESP()
end)

-- Fullbright toggle
local fbFrame = Instance.new("Frame")
fbFrame.Size = UDim2.new(1, -10, 0, 32)
fbFrame.Position = UDim2.new(0, 5, 0, 64)
fbFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
fbFrame.Parent = VisSection

local fbCorner = Instance.new("UICorner")
fbCorner.CornerRadius = UDim.new(0, 5)
fbCorner.Parent = fbFrame

local fbLabel = Instance.new("TextLabel")
fbLabel.Size = UDim2.new(1, -60, 1, 0)
fbLabel.Position = UDim2.new(0, 10, 0, 0)
fbLabel.BackgroundTransparency = 1
fbLabel.Text = "☀️ FULLBRIGHT (SEE IN THE DARK)"
fbLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
fbLabel.Font = Enum.Font.Gotham
fbLabel.TextSize = 11
fbLabel.TextXAlignment = Enum.TextXAlignment.Left
fbLabel.Parent = fbFrame

local fbBtn = Instance.new("TextButton")
fbBtn.Size = UDim2.new(0, 45, 0, 24)
fbBtn.Position = UDim2.new(1, -55, 0.5, -12)
fbBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
fbBtn.Text = "OFF"
fbBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
fbBtn.Font = Enum.Font.GothamBold
fbBtn.TextSize = 10
fbBtn.Parent = fbFrame

local fbBtnCorner = Instance.new("UICorner")
fbBtnCorner.CornerRadius = UDim.new(0, 4)
fbBtnCorner.Parent = fbBtn

local fbState = false
fbBtn.MouseButton1Click:Connect(function()
    fbState = not fbState
    Settings.FullBright = fbState
    fbBtn.Text = fbState and "ON" or "OFF"
    fbBtn.TextColor3 = fbState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    fbBtn.BackgroundColor3 = fbState and Color3.fromRGB(46, 204, 113, 40) or Color3.fromRGB(40, 40, 50)
    ToggleFullBright()
end)

-- Discord section
local DiscordSection = Instance.new("Frame")
DiscordSection.Size = UDim2.new(1, 0, 0, 40)
DiscordSection.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
DiscordSection.Parent = Scroll

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 5)
DiscordCorner.Parent = DiscordSection

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -10, 0, 28)
DiscordBtn.Position = UDim2.new(0, 5, 0, 6)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "💬 JOIN DISCORD (COPY LINK) - discord.gg/5RuMCxK3u6"
DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 9
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

-- Update canvas size
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

-- // STARTUP NOTIFICATION //
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "Loaded you fucking bitch! Go fuck shit up! 🥀",
    Duration = 3
})

print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - FUCK JAILBREAK - FUCK DELTA - FUCK XENO")
print("DISCORD: discord.gg/5RuMCxK3u6")
print("GO FUCK SHIT UP YOU BEAUTIFUL BITCH 🥀")