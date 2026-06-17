-- ts file was generated at discord.gg/EmsMsHZCVH

-- Delta executor compatibility shims
local function safeGetgenv()
    if getgenv then return getgenv() end
    return _G
end
local function safeGetfenv()
    if getfenv then return getfenv() end
    return {}
end
local function safeGetsenv(script)
    if getsenv then
        local ok, result = pcall(getsenv, script)
        if ok and result then return result end
    end
    return {}
end
local function safeSethiddenproperty(obj, prop, val)
    if sethiddenproperty then
        pcall(sethiddenproperty, obj, prop, val)
    end
end
local function safeSetreadonly(t, val)
    if setreadonly then
        pcall(setreadonly, t, val)
    end
end
local function safeGetrawmetatable(obj)
    if getrawmetatable then
        local ok, result = pcall(getrawmetatable, obj)
        if ok then return result end
    end
    return {}
end
local function safeNewcclosure(fn)
    if newcclosure then return newcclosure(fn) end
    return fn
end
local function safeDrawingNew(dtype)
    if Drawing then
        local ok, result = pcall(Drawing.new, dtype)
        if ok then return result end
    end
    return setmetatable({}, {__index = function() return function() end end, __newindex = function() end})
end

local genv = safeGetgenv()
local fenv = safeGetfenv()

-- =============================================
-- EXECUTOR DETECTION & KICK (Solara / Xeno)
-- =============================================
local function getExecutorName()
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok and name then return tostring(name):lower() end
    end
    if syn and syn.request then return "synapse" end
    if KRNL_LOADED then return "krnl" end
    if rconsoleprint then return "scriptware" end
    -- Solara detection
    if Solara or solara or (genv and genv.Solara) then return "solara" end
    -- Xeno detection
    if Xeno or xeno or (genv and genv.Xeno) then return "xeno" end
    return "unknown"
end

local execName = getExecutorName()
local banned = {"solara", "xeno"}
for _, rat in ipairs(banned) do
    if execName:find(rat) then
        -- Kick with message
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        if lp then
            lp:Kick("\n\n🚫 Elite Hub\n\nYou are using a detected RAT executor (" .. execName .. ").\nElite Hub does not support this executor.\ndiscord.gg/EmsMsHZCVH")
        end
        return
    end
end

-- =============================================
-- LOADING SCREEN
-- =============================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")

-- Create ScreenGui
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "EliteHubLoader"
loadGui.ResetOnSpawn = false
loadGui.IgnoreGuiInset = true
loadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadGui.Parent = playerGui

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
bg.BorderSizePixel = 0
bg.ZIndex = 10
bg.Parent = loadGui

-- Gradient overlay
local uiGrad = Instance.new("UIGradient")
uiGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10)),
})
uiGrad.Rotation = 135
uiGrad.Parent = bg

-- Center container
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 420, 0, 280)
container.Position = UDim2.new(0.5, -210, 0.5, -140)
container.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
container.BorderSizePixel = 0
container.ZIndex = 11
container.Parent = bg

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = container

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(80, 60, 200)
containerStroke.Thickness = 1.5
containerStroke.Transparency = 0.3
containerStroke.Parent = container

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "ELITE HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 32
title.Font = Enum.Font.GothamBold
title.ZIndex = 12
title.Parent = container

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 78)
subtitle.BackgroundTransparency = 1
subtitle.Text = "discord.gg/EmsMsHZCVH"
subtitle.TextColor3 = Color3.fromRGB(120, 100, 220)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.ZIndex = 12
subtitle.Parent = container

-- Divider line
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 0, 0, 1)
divider.Position = UDim2.new(0.1, 0, 0, 115)
divider.BackgroundColor3 = Color3.fromRGB(80, 60, 200)
divider.BorderSizePixel = 0
divider.ZIndex = 12
divider.Parent = container

-- Progress bar background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 320, 0, 6)
barBg.Position = UDim2.new(0.5, -160, 0, 165)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
barBg.BorderSizePixel = 0
barBg.ZIndex = 12
barBg.Parent = container

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

-- Progress bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 13
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 60, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 100, 255)),
})
barGrad.Parent = barFill

-- Status text
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Position = UDim2.new(0, 0, 0, 185)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(160, 150, 200)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.ZIndex = 12
statusText.Parent = container

-- Version text
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 20)
versionText.Position = UDim2.new(0, 0, 0, 240)
versionText.BackgroundTransparency = 1
versionText.Text = "v1.0  |  Blox Fruits"
versionText.TextColor3 = Color3.fromRGB(70, 65, 100)
versionText.TextSize = 12
versionText.Font = Enum.Font.Gotham
versionText.ZIndex = 12
versionText.Parent = container

-- Animate divider
TweenService:Create(divider, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.new(0.8, 0, 0, 1)}):Play()

-- Loading steps
local steps = {
    {text = "Checking executor...",   pct = 0.15},
    {text = "Loading WindUI...",       pct = 0.40},
    {text = "Building interface...",   pct = 0.65},
    {text = "Applying settings...",    pct = 0.85},
    {text = "Done!",                   pct = 1.00},
}

local function setProgress(pct, label)
    statusText.Text = label
    TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(pct, 0, 1, 0)
    }):Play()
end

for i, step in ipairs(steps) do
    setProgress(step.pct, step.text)
    task.wait(0.55)
end

task.wait(0.3)

-- Fade out
TweenService:Create(bg, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
for _, obj in ipairs(container:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("Frame") or obj:IsA("UIStroke") then
        pcall(function()
            TweenService:Create(obj, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, TextTransparency = 1, Transparency = 1}):Play()
        end)
    end
end
task.wait(0.65)
loadGui:Destroy()

-- =============================================
local _5 = loadstring(game:HttpGet('https://github.com/Footagesus/WindUI/releases/latest/download/main.lua'))()
if not _5 then
    warn('Elite Hub: Failed to load WindUI library. Check your executor HTTP permissions.')
    return
end
local _call13 = _5:CreateWindow({
    HideSearchBar = true,
    User = {
        Enabled = true,
        Callback = function(_14, _14_2)
            _5:Notify({
                Icon = 'rbxassetid://94790049029001',
                Duration = 3,
                Title = 'Welcome to Elite Hub',
                Content = 'Thank you for use Script',
            })
        end,
        Anonymous = false,
    },
    ScrollBarEnabled = false,
    SideBarWidth = 200,
    Author = 'Blox Fruit\u{2728}',
    Resizable = true,
    BackgroundImageTransparency = 0.42,
    Folder = 'Elite-Hub',
    Theme = 'Dark',
    Title = 'Elite Hub\u{1f468}\u{200d}\u{1f4bb}',
    Transparent = true,
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Icon = 'rbxassetid://94790049029001',
    Size = UDim2.fromOffset(580, 460),
})

_call13:EditOpenButton({
    StrokeThickness = 2,
    Draggable = true,
    Title = 'Elite Hub\u{1f468}\u{200d}\u{1f4bb}',
    Enabled = true,
    Color = ColorSequence.new(Color3.fromHex('000000'), Color3.fromHex('FFFFFF')),
    OnlyMobile = false,
    Icon = 'rbxassetid://94790049029001',
    CornerRadius = UDim.new(0, 16),
})

_G.AutoStats = false
_G.AutoFruit = false
_G.SelectedStats = {
    ['Demon Fruit'] = false,
    Defense = false,
    Melee = false,
    Sword = false,
    Gun = false,
}

local _call28 = game:GetService('Players')
local _LocalPlayer29 = _call28.LocalPlayer

game:GetService('TweenService')

local _call33 = game:GetService('Workspace')
local _call35 = game:GetService('ReplicatedStorage')

game:GetService('CollectionService')
game:GetService('TeleportService')
game:GetService('VirtualUser')
_LocalPlayer29.Idled:Connect(function(_47, _47_2, _47_3)
    local _ = _G.AutoFarm
end)
task.spawn(function(_50, _50_2, _50_3)
    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    task.wait(60)

    local _ = _G.AutoFarm

    error('internal 579: <25ms: infinitelooperror>')
end)
_LocalPlayer29:FindFirstChild('PlayerGui')
task.wait()
_LocalPlayer29:FindFirstChild('PlayerGui')
_LocalPlayer29.PlayerGui:FindFirstChild('Main')
task.wait()
_LocalPlayer29.PlayerGui:FindFirstChild('Main')
_LocalPlayer29.PlayerGui.Main:FindFirstChild('Quest')
task.wait()
_LocalPlayer29.PlayerGui.Main:FindFirstChild('Quest')
_LocalPlayer29:FindFirstChild('Data')
_LocalPlayer29.Data:FindFirstChild('Level')
task.wait()
_LocalPlayer29:FindFirstChild('Data')
_LocalPlayer29.Data:FindFirstChild('Level')
_call33:FindFirstChild('Enemies')
task.wait()
_call33:FindFirstChild('Enemies')
_LocalPlayer29.Character:WaitForChild('HumanoidRootPart')
_LocalPlayer29.CharacterAdded:Connect(function(_89, _89_2, _89_3, _89_4)
    error('internal 579: <25ms: infinitelooperror>')
end)

_G.AutoFarm = false

Vector3.new(0, 30, 0)
game:GetService('RunService').Heartbeat:Connect(function(_96, _96_2, _96_3, _96_4) end)
task.spawn(function(_99, _99_2, _99_3) end)
task.spawn(function(_102, _102_2, _102_3, _102_4) end)
require(_call35:WaitForChild('Quests'))
require(_call35:WaitForChild('GuideModule'))

local _LocalPlayer110 = game.Players.LocalPlayer

workspace:WaitForChild('Enemies')

local _call117 = game.ReplicatedStorage:WaitForChild('Modules'):WaitForChild('Net')

_call117:WaitForChild('RE/RegisterAttack')
_call117:WaitForChild('RE/RegisterHit')

local _ = _LocalPlayer110.Character

_LocalPlayer110.Character:FindFirstChildOfClass('Tool')
task.spawn(function(_128, _128_2, _128_3) end)

local _G134 = safeGetsenv(_LocalPlayer110:WaitForChild('PlayerScripts'):FindFirstChildOfClass('LocalScript'))
local _ = _G134.SendHitsToServer

fenv.FastAttack = nil

task.spawn(function(_138) end)
task.spawn(function(_141, _141_2, _141_3, _141_4) end)

local _ = _G.SendHitsToServer

if debug and debug.getupvalue then pcall(debug.getupvalue, nil, 1) end

local _ = _call35.Modules.Net['RE/RegisterAttack']

task.spawn(function(_148, _148_2, _148_3, _148_4, _148_5) end)
task.spawn(function(_151, _151_2, _151_3, _151_4) end)
safeSethiddenproperty(_LocalPlayer29, 'SimulationRadius', math.huge)

local _ = _call28.LocalPlayer

fenv.FindWeaponsByType = function(_154, _154_2) end
fenv.equip_weapon = function(_155, _155_2, _155_3) end
fenv.Eq = function(_156, _156_2, _156_3, _156_4, _156_5, _156_6) end

task.spawn(function(_159, _159_2) end)

local _ = game:GetService('Players').LocalPlayer

game:GetService('RunService').Stepped:Connect(function() end)

local _call170 = _call13:Tab({
    Title = 'Main',
    Icon = 'house',
})
local _call172 = _call13:Tab({
    Title = 'Fruit',
    Icon = 'apple',
})
local _call174 = _call13:Tab({
    Title = 'Stats',
    Icon = 'chart-no-axes-column-increasing',
})
local _call176 = _call13:Tab({
    Title = 'Teleport',
    Icon = 'globe',
})

_call170:Section({
    Title = 'Auto Farm',
})
_call170:Toggle({
    Callback = function(_181, _181_2) end,
    Default = false,
    Title = 'Auto Farm Level',
    Desc = 'Smart world check and auto farming',
})
_call172:Section({
    Title = 'Fruit Settings',
})
_call172:Button({
    Title = 'Random Fruit (Buy)',
    Callback = function(_186, _186_2, _186_3, _186_4) end,
})
_call172:Toggle({
    Callback = function(_189) end,
    Title = 'Auto Bring Fruit',
    Default = false,
})
_call174:Section({
    Title = 'Auto Add Stats',
})
_call174:Toggle({
    Callback = function(_194, _194_2, _194_3, _194_4, _194_5, _194_6) end,
    Default = false,
    Title = 'Enable Auto Stats',
    Desc = 'Master switch for auto adding stats',
})
_call174:Toggle({
    Callback = function(_197, _197_2, _197_3, _197_4) end,
    Title = 'Add Melee',
    Default = false,
})
_call174:Toggle({
    Callback = function(_200, _200_2, _200_3, _200_4) end,
    Title = 'Add Defense',
    Default = false,
})
_call174:Toggle({
    Callback = function(_203, _203_2, _203_3, _203_4) end,
    Title = 'Add Sword',
    Default = false,
})
_call174:Toggle({
    Callback = function(_206, _206_2, _206_3, _206_4) end,
    Title = 'Add Gun',
    Default = false,
})
_call174:Toggle({
    Callback = function(_209, _209_2, _209_3, _209_4) end,
    Title = 'Add Demon Fruit',
    Default = false,
})
_call176:Section({
    Title = 'World Teleport (Stable)',
})
_call176:Button({
    Title = 'Teleport to World 1',
    Callback = function() end,
})
_call176:Button({
    Title = 'Teleport to World 2',
    Callback = function(_217, _217_2) end,
})
_call176:Button({
    Title = 'Teleport to World 3',
    Callback = function(_220) end,
})
_call176:Section({
    Title = 'Auto Sea',
})
CFrame.new(1298.05078, 26.9509659, -1377.30994, 0.999336004, -7.26770253e-8, -0.0364349782, 7.20341617e-8, 1, -1.89569196e-8, 0.0364349782, 1.6319768599999998e-8, 0.999336004)
_call176:Button({
    Callback = function(_227) end,
    Title = 'Auto World 2 (One Click)',
    Desc = 'Quest \u{2192} Ice Admiral \u{2192} Kill \u{2192} World 2',
})

local _call229 = _call13:Tab({
    Title = 'Combat',
    Icon = 'crosshair',
})

_call229:Section({
    Title = 'Aimbot',
})

genv.AimbotEnabled = false
genv.FOV = 70
genv.TargetPosition = nil
genv.ShowFOV = false
genv.RainbowFOV = false
genv.LockedColor = Color3.fromRGB(0, 255, 0)

local _ = workspace.CurrentCamera
local _ = game:GetService('Players').LocalPlayer
local _call241 = safeDrawingNew('Circle')

_call241.Color = Color3.new(1, 1, 1)
_call241.Thickness = 2
_call241.NumSides = 100
_call241.Filled = false
_call241.Transparency = 1
_call241.Visible = false

local _call245 = safeDrawingNew('Line')

_call245.Color = Color3.fromRGB(255, 0, 0)
_call245.Thickness = 2
_call245.Transparency = 1
_call245.Visible = false

game:GetService('RunService').RenderStepped:Connect(function(_251, _251_2, _251_3, _251_4, _251_5) end)
task.spawn(function(_254, _254_2, _254_3) end)

local _callgetrawmetatable255 = safeGetrawmetatable(game)
local _ = _callgetrawmetatable255.__namecall

safeSetreadonly(_callgetrawmetatable255, false)
safeNewcclosure(function(...) end)

_callgetrawmetatable255.__namecall = function(...) end

safeSetreadonly(_callgetrawmetatable255, true)
_call229:Toggle({
    Value = false,
    Callback = function(_263, _263_2) end,
    Title = 'Silent Aim',
    Desc = '',
})
_call229:Toggle({
    Value = false,
    Callback = function(_266, _266_2, _266_3, _266_4, _266_5) end,
    Title = 'Show FOV Circle',
    Desc = '',
})
_call229:Toggle({
    Value = false,
    Callback = function(_269, _269_2, _269_3, _269_4) end,
    Title = 'Rainbow FOV',
    Desc = '',
})
_call229:Slider({
    Title = 'FOV',
    Value = {
        Min = 20,
        Default = 70,
        Max = 500,
    },
    Callback = function(_272, _272_2, _272_3) end,
    Step = 1,
    Desc = '',
})

local _call274 = _call13:Tab({
    Title = 'Player',
    Icon = 'user',
})

_call274:Section({
    Title = 'invisible',
})
CFrame.new(-1232.1594238281, 13.274794578552, 4113.931640625)
_call274:Button({
    Callback = function(_281, _281_2, _281_3) end,
    Title = 'Invisible',
    Description = '',
})
_call274:Section({
    Title = 'Player',
})

local _LocalPlayer286 = game:GetService('Players').LocalPlayer
local _Character287 = _LocalPlayer286.Character

task.wait(0.1)
_Character287:SetAttribute('DashLength', 16)
_Character287:SetAttribute('SpeedMultiplier', 1)
_Character287:SetAttribute('WaterWalking', false)
_LocalPlayer286.CharacterAdded:Connect(function() end)
_call274:Slider({
    Title = 'Dash Length',
    Value = {
        Min = 16,
        Default = 16,
        Max = 1000,
    },
    Callback = function(_300, _300_2, _300_3, _300_4) end,
    Step = 5,
    Desc = '',
})
_call274:Slider({
    Title = 'SpeedMultiplier',
    Value = {
        Min = 1,
        Default = 1,
        Max = 10,
    },
    Callback = function(_303, _303_2, _303_3) end,
    Step = 5,
    Desc = '',
})
_call274:Toggle({
    Value = false,
    Callback = function(_306, _306_2, _306_3) end,
    Title = 'Speed Boost',
    Desc = '',
})
_call170:Toggle({
    Value = true,
    Callback = function(_309, _309_2) end,
    Title = 'Walking On Water',
    Desc = 'Not Close',
})
_call274:Toggle({
    Value = false,
    Callback = function(_312) end,
    Title = 'Noclip',
    Desc = '',
})

_G.NoclipEnabled = false

game:GetService('RunService').Stepped:Connect(function() end)
game:GetService('Players').LocalPlayer.CharacterAdded:Connect(function(_325) end)

local _Character331 = game:GetService('Players').LocalPlayer.Character

_Character331:WaitForChild('Humanoid')
_Character331:WaitForChild('HumanoidRootPart')

_G.AutoSafeMode = false

game:GetService('RunService').Heartbeat:Connect(function(_339, _339_2) end)
_call229:Toggle({
    Title = 'Safe Mode',
    Value = false,
    Callback = function(_342, _342_2, _342_3) end,
    Icon = 'shield',
    Desc = '',
})
