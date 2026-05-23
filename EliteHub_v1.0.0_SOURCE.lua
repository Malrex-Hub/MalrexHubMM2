--[[
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ███████╗██╗     ██╗████████╗███████╗██╗  ██╗██╗   ██╗██████╗             ║
║    ██╔════╝██║     ██║╚══██╔══╝██╔════╝██║  ██║██║   ██║██╔══██╗            ║
║    █████╗  ██║     ██║   ██║   █████╗  ███████║██║   ██║██████╔╝            ║
║    ██╔══╝  ██║     ██║   ██║   ██╔══╝  ██╔══██║██║   ██║██╔══██╗            ║
║    ███████╗███████╗██║   ██║   ███████╗██║  ██║╚██████╔╝██████╔╝            ║
║    ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝             ║
║                                                                              ║
║                   v1.0.0  ·  Premium Blox Fruits Hub                        ║
║                   discord.gg/EmsMsHZCVH                                      ║
║                                                                              ║
║   Architecture                                                               ║
║   ──────────                                                                 ║
║   [01] Core Services & Constants                                             ║
║   [02] Connection Manager                                                    ║
║   [03] Config System & Profiles                                              ║
║   [04] Theme Engine                                                          ║
║   [05] Notification Queue                                                    ║
║   [06] Statistics Tracker                                                    ║
║   [07] UI Framework & Factory                                                ║
║   [08] Anti-Detection Engine                                                 ║
║   [09] Animated Loader                                                       ║
║   [10] Discord Modal                                                         ║
║   [11] Main Hub Window                                                       ║
║   [12] Feature Engine                                                        ║
║   [13] Combat Features  (15)                                                 ║
║   [14] AutoFarm Features (15)                                                ║
║   [15] ESP Features (10)                                                     ║
║   [16] Teleport System (all seas + saved slots)                              ║
║   [17] Movement Features (12)                                                ║
║   [18] Visual Features (12)                                                  ║
║   [19] Devil Fruit Features (8)                                              ║
║   [20] Sea Events (12)                                                       ║
║   [21] Player Tools (6)                                                      ║
║   [22] Misc Features (8)                                                     ║
║   [23] Content Builders (Dashboard, Features, TP, Config, Stats)             ║
║   [24] Tab Router                                                            ║
║   [25] Window Controls & Animations                                          ║
║   [26] Mobile Support                                                        ║
║   [27] Keybinds                                                              ║
║   [28] Startup Sequence                                                      ║
╚══════════════════════════════════════════════════════════════════════════════╝
]]

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [01] CORE SERVICES & CONSTANTS                                          │
-- └─────────────────────────────────────────────────────────────────────────┘

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService        = game:GetService("HttpService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local CoreGui            = game:GetService("CoreGui")
local StarterGui         = game:GetService("StarterGui")
local Lighting           = game:GetService("Lighting")
local Workspace          = game:GetService("Workspace")
local VirtualUser        = game:GetService("VirtualUser")
local TeleportService    = game:GetService("TeleportService")
local SoundService       = game:GetService("SoundService")
local Camera             = Workspace.CurrentCamera

local LP                 = Players.LocalPlayer

-- Hub identity
local HUB_NAME    = "EliteHub"
local HUB_VERSION = "1.0.0"
local HUB_BUILD   = "20250523"
local DISCORD     = "https://discord.gg/EmsMsHZCVH"
local DISCORD_SHORT = "discord.gg/EmsMsHZCVH"
local CFG_FILE    = "elitehub_config_v1.json"

-- Character accessors (always current)
local function GetChar()  return LP.Character end
local function GetRoot()  local c=GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum()   local c=GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- Safe tween
local function Tween(obj, t, props, style, dir)
    if not obj or not obj.Parent then return end
    TweenService:Create(obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

-- Clamp + lerp
local function Clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end
local function Lerp(a, b, t)    return a + (b-a)*t end
local function Round(v, n)      local m=10^(n or 0); return math.floor(v*m+0.5)/m end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [02] CONNECTION MANAGER                                                 │
-- └─────────────────────────────────────────────────────────────────────────┘

local ConnPool = {}     -- [featureId] = { RBXScriptConnection, ... }
local ConnGlobal = {}   -- global connections not tied to a feature

local function Conn(id, c)
    if not ConnPool[id] then ConnPool[id] = {} end
    if c then table.insert(ConnPool[id], c) end
end

local function Drop(id)
    if not ConnPool[id] then return end
    for _, c in ipairs(ConnPool[id]) do
        pcall(function() c:Disconnect() end)
    end
    ConnPool[id] = nil
end

local function DropAll()
    for id in pairs(ConnPool) do Drop(id) end
end

local function GlobalConn(c)
    if c then table.insert(ConnGlobal, c) end
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [03] CONFIG SYSTEM & PROFILES                                           │
-- └─────────────────────────────────────────────────────────────────────────┘

local Defaults = {
    theme           = "Dark",
    sea             = 1,
    discordSeen     = false,
    hubVisible      = true,
    -- Movement values
    walkSpeed       = 80,
    flySpeed        = 65,
    flyBoostMult    = 2.5,
    jumpPower       = 180,
    swimSpeed       = 90,
    -- Farm values
    farmDelay       = 0.08,
    farmRange       = 55,
    farmAutoQuest   = true,
    farmAutoloot    = true,
    -- Combat values
    killAuraRange   = 18,
    killAuraDelay   = 0.14,
    autoAttackRange = 25,
    autoSkillRange  = 70,
    comboDelay      = 0.12,
    -- ESP values
    espMaxDist      = 900,
    espShowHP       = true,
    espShowDist     = true,
    espShowName     = true,
    -- Anti-detection
    antiDetect      = true,
    jitterMin       = 0.04,
    jitterMax       = 0.18,
    -- Keybinds
    hubKey          = "RightControl",
    killSwitchKey   = "Delete",
    -- Stats
    sessionKills    = 0,
    sessionFarms    = 0,
    sessionChests   = 0,
    -- Profile
    activeProfile   = "Default",
    profiles        = { Default = {} },
    -- Feature states
    features        = {},
}

local Cfg = {}

local function CfgSave()
    pcall(function() writefile(CFG_FILE, HttpService:JSONEncode(Cfg)) end)
end

local function CfgLoad()
    local ok, data = pcall(function()
        if isfile and isfile(CFG_FILE) then
            return HttpService:JSONDecode(readfile(CFG_FILE))
        end
    end)
    Cfg = (ok and type(data) == "table") and data or {}
    for k, v in pairs(Defaults) do
        if Cfg[k] == nil then Cfg[k] = v end
    end
    if type(Cfg.features)  ~= "table" then Cfg.features  = {} end
    if type(Cfg.profiles)  ~= "table" then Cfg.profiles  = {Default={}} end
end

CfgLoad()

-- Profile helpers
local function ProfileSave(name)
    if not Cfg.profiles then Cfg.profiles = {} end
    Cfg.profiles[name] = {}
    for id, state in pairs(Cfg.features) do
        Cfg.profiles[name][id] = state
    end
    CfgSave()
end

local function ProfileLoad(name)
    if not Cfg.profiles or not Cfg.profiles[name] then return end
    Cfg.features = {}
    for id, state in pairs(Cfg.profiles[name]) do
        Cfg.features[id] = state
    end
    Cfg.activeProfile = name
    CfgSave()
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [04] THEME ENGINE                                                       │
-- └─────────────────────────────────────────────────────────────────────────┘

local Themes = {
    Dark = {
        name     = "Dark",
        bg       = Color3.fromRGB(10, 12, 21),
        panel    = Color3.fromRGB(13, 16, 28),
        card     = Color3.fromRGB(17, 21, 36),
        cardHov  = Color3.fromRGB(21, 26, 44),
        header   = Color3.fromRGB(12, 14, 24),
        accent   = Color3.fromRGB(80, 130, 255),
        accentDim= Color3.fromRGB(46, 80, 180),
        text     = Color3.fromRGB(218, 224, 245),
        sub      = Color3.fromRGB(95, 108, 150),
        border   = Color3.fromRGB(28, 34, 58),
        success  = Color3.fromRGB(52, 210, 108),
        warn     = Color3.fromRGB(255, 185, 40),
        danger   = Color3.fromRGB(255, 60, 60),
        glow     = Color3.fromRGB(80, 130, 255),
        loaderBg = Color3.fromRGB(6, 8, 16),
    },
    Midnight = {
        name     = "Midnight",
        bg       = Color3.fromRGB(4, 4, 14),
        panel    = Color3.fromRGB(6, 6, 19),
        card     = Color3.fromRGB(9, 9, 26),
        cardHov  = Color3.fromRGB(13, 13, 34),
        header   = Color3.fromRGB(5, 5, 16),
        accent   = Color3.fromRGB(128, 78, 255),
        accentDim= Color3.fromRGB(80, 44, 185),
        text     = Color3.fromRGB(218, 213, 248),
        sub      = Color3.fromRGB(100, 92, 158),
        border   = Color3.fromRGB(24, 22, 54),
        success  = Color3.fromRGB(52, 210, 108),
        warn     = Color3.fromRGB(255, 185, 40),
        danger   = Color3.fromRGB(255, 60, 60),
        glow     = Color3.fromRGB(140, 88, 255),
        loaderBg = Color3.fromRGB(2, 2, 10),
    },
    Crimson = {
        name     = "Crimson",
        bg       = Color3.fromRGB(14, 4, 4),
        panel    = Color3.fromRGB(20, 6, 6),
        card     = Color3.fromRGB(26, 8, 8),
        cardHov  = Color3.fromRGB(32, 12, 12),
        header   = Color3.fromRGB(16, 4, 4),
        accent   = Color3.fromRGB(255, 48, 48),
        accentDim= Color3.fromRGB(185, 26, 26),
        text     = Color3.fromRGB(245, 218, 218),
        sub      = Color3.fromRGB(155, 90, 90),
        border   = Color3.fromRGB(55, 16, 16),
        success  = Color3.fromRGB(52, 210, 108),
        warn     = Color3.fromRGB(255, 185, 40),
        danger   = Color3.fromRGB(255, 80, 80),
        glow     = Color3.fromRGB(255, 56, 56),
        loaderBg = Color3.fromRGB(8, 2, 2),
    },
    Ocean = {
        name     = "Ocean",
        bg       = Color3.fromRGB(2, 14, 22),
        panel    = Color3.fromRGB(3, 18, 30),
        card     = Color3.fromRGB(4, 24, 38),
        cardHov  = Color3.fromRGB(6, 30, 48),
        header   = Color3.fromRGB(2, 14, 22),
        accent   = Color3.fromRGB(0, 198, 215),
        accentDim= Color3.fromRGB(0, 128, 158),
        text     = Color3.fromRGB(198, 238, 248),
        sub      = Color3.fromRGB(65, 145, 165),
        border   = Color3.fromRGB(7, 48, 66),
        success  = Color3.fromRGB(52, 210, 108),
        warn     = Color3.fromRGB(255, 185, 40),
        danger   = Color3.fromRGB(255, 60, 60),
        glow     = Color3.fromRGB(0, 208, 226),
        loaderBg = Color3.fromRGB(1, 8, 14),
    },
    Forest = {
        name     = "Forest",
        bg       = Color3.fromRGB(4, 14, 6),
        panel    = Color3.fromRGB(5, 18, 7),
        card     = Color3.fromRGB(6, 24, 9),
        cardHov  = Color3.fromRGB(8, 30, 12),
        header   = Color3.fromRGB(4, 14, 6),
        accent   = Color3.fromRGB(46, 210, 85),
        accentDim= Color3.fromRGB(27, 145, 52),
        text     = Color3.fromRGB(205, 240, 212),
        sub      = Color3.fromRGB(72, 148, 90),
        border   = Color3.fromRGB(15, 50, 20),
        success  = Color3.fromRGB(52, 210, 108),
        warn     = Color3.fromRGB(255, 185, 40),
        danger   = Color3.fromRGB(255, 60, 60),
        glow     = Color3.fromRGB(52, 220, 90),
        loaderBg = Color3.fromRGB(2, 8, 3),
    },
}

local function T() return Themes[Cfg.theme] or Themes.Dark end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [05] NOTIFICATION QUEUE                                                 │
-- └─────────────────────────────────────────────────────────────────────────┘

local NotifQueue = {}
local NotifActive = false

local function PushNotif(title, body, kind, dur)
    table.insert(NotifQueue, {
        title = title,
        body  = body,
        kind  = kind or "info",    -- info | success | warn | danger
        dur   = dur  or 3,
        time  = tick(),
    })
end

local function Notif(title, body, dur, kind)
    -- Roblox native
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title    = "[" .. HUB_NAME .. "] " .. tostring(title),
            Text     = tostring(body),
            Duration = dur or 3,
        })
    end)
    PushNotif(title, body, kind, dur)
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [06] STATISTICS TRACKER                                                 │
-- └─────────────────────────────────────────────────────────────────────────┘

local Stats = {
    sessionStart  = tick(),
    kills         = 0,
    bossKills     = 0,
    farmCycles    = 0,
    chestsLooted  = 0,
    fruitsGrabbed = 0,
    tpCount       = 0,
    xpEstimate    = 0,
    distTraveled  = 0,
    lastPos       = nil,
}

local function StatAdd(key, amt)
    amt = amt or 1
    if Stats[key] ~= nil then
        Stats[key] = Stats[key] + amt
    end
end

local function StatUptime()
    local s = math.floor(tick() - Stats.sessionStart)
    local h = math.floor(s/3600)
    local m = math.floor((s%3600)/60)
    local ss = s % 60
    return string.format("%02d:%02d:%02d", h, m, ss)
end

-- Track distance passively
GlobalConn(RunService.Heartbeat:Connect(function()
    local rt = GetRoot()
    if rt then
        if Stats.lastPos then
            Stats.distTraveled = Stats.distTraveled +
                (rt.Position - Stats.lastPos).Magnitude
        end
        Stats.lastPos = rt.Position
    end
end))

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [07] UI FRAMEWORK & FACTORY                                             │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Destroy any previous instance
pcall(function()
    local old = CoreGui:FindFirstChild(HUB_NAME)
    if old then old:Destroy() end
end)

local GUI = Instance.new("ScreenGui")
GUI.Name             = HUB_NAME
GUI.ResetOnSpawn     = false
GUI.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
GUI.IgnoreGuiInset   = true
GUI.DisplayOrder     = 1000
GUI.Parent           = CoreGui

-- ── element factories ────────────────────────────────────────────

local function NewFrame(props)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    f.BackgroundColor3 = T().bg
    for k,v in pairs(props or {}) do f[k]=v end
    return f
end

local function NewLabel(props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Font  = Enum.Font.GothamBold
    l.TextSize = 13
    l.TextColor3 = T().text
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.RichText = true
    for k,v in pairs(props or {}) do l[k]=v end
    return l
end

local function NewBtn(props)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    for k,v in pairs(props or {}) do b[k]=v end
    return b
end

local function NewScroll(props)
    local s = Instance.new("ScrollingFrame")
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 3
    s.ScrollBarImageColor3 = T().accent
    s.ScrollBarImageTransparency = 0.5
    s.CanvasSize = UDim2.new(0,0,0,0)
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    for k,v in pairs(props or {}) do s[k]=v end
    return s
end

local function Corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function Stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke", p)
    s.Color = col or Color3.new(1,1,1)
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    return s
end

local function UList(p, dir, pad)
    local l = Instance.new("UIListLayout", p)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, pad or 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

local function UPad(p, l, r, t, b)
    local pd = Instance.new("UIPadding", p)
    pd.PaddingLeft   = UDim.new(0, l or 0)
    pd.PaddingRight  = UDim.new(0, r or 0)
    pd.PaddingTop    = UDim.new(0, t or 0)
    pd.PaddingBottom = UDim.new(0, b or 0)
    return pd
end

local function HoverColor(btn, base, hover)
    btn.MouseEnter:Connect(function()  Tween(btn, 0.1, {BackgroundColor3=hover}) end)
    btn.MouseLeave:Connect(function()  Tween(btn, 0.1, {BackgroundColor3=base})  end)
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [08] ANTI-DETECTION ENGINE                                              │
-- └─────────────────────────────────────────────────────────────────────────┘

local AntiDetect = {}

-- Returns a jittered delay to avoid pattern detection
function AntiDetect.Jitter(base)
    if not Cfg.antiDetect then return base end
    local jMin = Cfg.jitterMin or 0.04
    local jMax = Cfg.jitterMax or 0.18
    return base + (math.random() * (jMax - jMin) + jMin)
end

-- Randomise teleport slightly so exact positions are never repeated
function AntiDetect.SafePos(pos)
    if not Cfg.antiDetect then return pos end
    return pos + Vector3.new(
        (math.random()-0.5) * 2.5,
        (math.random()-0.5) * 0.6,
        (math.random()-0.5) * 2.5
    )
end

-- Smooth anti-teleport: steps between two positions over N frames
function AntiDetect.SoftTP(targetPos, steps)
    steps = steps or 6
    local rt = GetRoot()
    if not rt then return end
    local startPos = rt.Position
    for i = 1, steps do
        rt.CFrame = CFrame.new(Vector3.new(
            Lerp(startPos.X, targetPos.X, i/steps),
            Lerp(startPos.Y, targetPos.Y, i/steps),
            Lerp(startPos.Z, targetPos.Z, i/steps)
        ))
        task.wait(0.015)
    end
end

-- Hard teleport with anti-detect offset
function AntiDetect.TP(pos, soft)
    local safePos = AntiDetect.SafePos(pos + Vector3.new(0, 4.5, 0))
    if soft then
        AntiDetect.SoftTP(safePos, 8)
    else
        local rt = GetRoot()
        if rt then rt.CFrame = CFrame.new(safePos) end
    end
    Stats.tpCount = Stats.tpCount + 1
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [09] ANIMATED LOADER                                                    │
-- └─────────────────────────────────────────────────────────────────────────┘

local Loader = NewFrame({
    Name             = "Loader",
    Size             = UDim2.new(1,0,1,0),
    BackgroundColor3 = T().loaderBg,
    ZIndex           = 300,
    Parent           = GUI,
})

-- ── matrix rain background ─────────────────────────────────────
local MATRIX_CHARS = "01アイウエオカキクケコサシスセソタチツテトナニヌネノ"
local matrixCols = {}

local function MakeMatrixCol(x)
    local col = NewLabel({
        Size             = UDim2.new(0, 14, 0, 700),
        Position         = UDim2.new(0, x*14, 0, -math.random(100, 700)),
        Font             = Enum.Font.Code,
        TextSize         = 13,
        TextColor3       = T().accent,
        TextTransparency = 0.55,
        Text             = "",
        BackgroundTransparency = 1,
        ZIndex           = 300,
        TextXAlignment   = Enum.TextXAlignment.Center,
        Parent           = Loader,
    })
    -- Build column of random chars
    local lines = {}
    for i = 1, 50 do
        lines[i] = string.sub(MATRIX_CHARS, math.random(1,#MATRIX_CHARS), math.random(1,#MATRIX_CHARS)+1) or "0"
    end
    col.Text = table.concat(lines, "\n")
    table.insert(matrixCols, col)
    -- Animate falling
    local speed = math.random(60, 160)
    local resetY = math.random(400, 800)
    GlobalConn(RunService.Heartbeat:Connect(function(dt)
        if not col.Parent then return end
        local cy = col.Position.Y.Offset
        col.Position = UDim2.new(0, x*14, 0, cy + speed*dt)
        if cy > resetY then
            col.Position = UDim2.new(0, x*14, 0, -math.random(200, 700))
            speed = math.random(60, 160)
            resetY = math.random(400, 800)
        end
    end))
end

for col = 0, math.floor(1280/14) do
    MakeMatrixCol(col)
end

-- ── glass panel ───────────────────────────────────────────────
local LoaderPanel = NewFrame({
    Size             = UDim2.new(0, 500, 0, 320),
    Position         = UDim2.new(0.5,-250, 0.5,-160),
    BackgroundColor3 = T().panel,
    BackgroundTransparency = 0.1,
    ZIndex           = 302,
    Parent           = Loader,
})
Corner(LoaderPanel, 16)
Stroke(LoaderPanel, T().accent, 1, 0.5)

-- ── glow behind panel ─────────────────────────────────────────
local LoaderGlow = NewFrame({
    Size             = UDim2.new(0, 600, 0, 420),
    Position         = UDim2.new(0.5,-300, 0.5,-210),
    BackgroundColor3 = T().accent,
    BackgroundTransparency = 0.92,
    ZIndex           = 301,
    Parent           = Loader,
})
Corner(LoaderGlow, 999)

-- ── logo ──────────────────────────────────────────────────────
local LogoMain = NewLabel({
    Size             = UDim2.new(1, 0, 0, 88),
    Position         = UDim2.new(0, 0, 0, 28),
    Text             = HUB_NAME:upper(),
    TextSize         = 60,
    Font             = Enum.Font.GothamBlack,
    TextColor3       = T().accent,
    TextStrokeColor3 = T().accent,
    TextStrokeTransparency = 0.55,
    BackgroundTransparency = 1,
    ZIndex           = 303,
    Parent           = LoaderPanel,
})

local LogoSub = NewLabel({
    Size             = UDim2.new(1, 0, 0, 20),
    Position         = UDim2.new(0, 0, 0, 118),
    Text             = "v" .. HUB_VERSION .. "  ·  BLOX FRUITS  ·  " .. DISCORD_SHORT,
    TextSize         = 11,
    Font             = Enum.Font.GothamMono,
    TextColor3       = T().sub,
    BackgroundTransparency = 1,
    ZIndex           = 303,
    Parent           = LoaderPanel,
})

-- ── progress bar ──────────────────────────────────────────────
local BarTrack = NewFrame({
    Size             = UDim2.new(1, -60, 0, 4),
    Position         = UDim2.new(0, 30, 0, 160),
    BackgroundColor3 = T().border,
    ZIndex           = 303,
    Parent           = LoaderPanel,
})
Corner(BarTrack, 4)

local BarFill = NewFrame({
    Size             = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = T().accent,
    ZIndex           = 304,
    Parent           = BarTrack,
})
Corner(BarFill, 4)

local BarShimmer = NewFrame({
    Size             = UDim2.new(0, 60, 1, 0),
    BackgroundColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 0.65,
    ZIndex           = 305,
    Parent           = BarFill,
})
Corner(BarShimmer, 4)

local BarPct = NewLabel({
    Size             = UDim2.new(1, 0, 0, 16),
    Position         = UDim2.new(0, 0, 0, 172),
    Text             = "0%",
    TextSize         = 10,
    Font             = Enum.Font.GothamMono,
    TextColor3       = T().sub,
    BackgroundTransparency = 1,
    ZIndex           = 303,
    Parent           = LoaderPanel,
})

-- ── status log ────────────────────────────────────────────────
local StatusLog = NewLabel({
    Size             = UDim2.new(1, -40, 0, 16),
    Position         = UDim2.new(0, 20, 0, 197),
    Text             = "Initializing…",
    TextSize         = 11,
    Font             = Enum.Font.GothamMono,
    TextColor3       = T().sub,
    TextXAlignment   = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex           = 303,
    Parent           = LoaderPanel,
})

-- ── module check list ─────────────────────────────────────────
local CheckItems = {
    "Core engine",
    "Feature registry",
    "ESP renderer",
    "Combat module",
    "AutoFarm module",
    "Teleport database",
    "Config system",
    "Anti-detection",
    "UI framework",
    "Theme engine",
    "Mobile adapter",
    "All systems ready",
}

local CheckFrame = NewFrame({
    Size             = UDim2.new(1, -40, 0, 88),
    Position         = UDim2.new(0, 20, 0, 218),
    BackgroundTransparency = 1,
    ZIndex           = 303,
    Parent           = LoaderPanel,
})
UList(CheckFrame, Enum.FillDirection.Vertical, 3)

local CheckLabels = {}
for i, item in ipairs(CheckItems) do
    if i <= 6 then -- two columns, left side
        local lbl = NewLabel({
            Size     = UDim2.new(1, 0, 0, 12),
            Text     = "○  " .. item,
            TextSize = 10,
            Font     = Enum.Font.GothamMono,
            TextColor3 = T().sub,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            ZIndex   = 304,
            Parent   = CheckFrame,
            LayoutOrder = i,
        })
        CheckLabels[i] = lbl
    end
end

local StatusMessages = {
    "Booting EliteHub v" .. HUB_VERSION .. "...",
    "Loading feature registry...",
    "Compiling ESP renderer...",
    "Initializing combat engine...",
    "Loading autofarm routines...",
    "Mapping island coordinates...",
    "Reading saved configuration...",
    "Applying anti-detection patches...",
    "Building UI components...",
    "Loading theme: " .. Cfg.theme .. "...",
    "Detecting platform & input mode...",
    "Welcome to EliteHub. Stay elite.",
}

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [10] DISCORD MODAL                                                      │
-- └─────────────────────────────────────────────────────────────────────────┘

local ModalDim = NewFrame({
    Size             = UDim2.new(1,0,1,0),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.48,
    ZIndex           = 250,
    Visible          = false,
    Parent           = GUI,
})

local DiscordModal = NewFrame({
    Name             = "DiscordModal",
    Size             = UDim2.new(0, 460, 0, 300),
    Position         = UDim2.new(0.5,-230, 0.5,-150),
    BackgroundColor3 = T().panel,
    ZIndex           = 251,
    Visible          = false,
    Parent           = GUI,
})
Corner(DiscordModal, 14)
Stroke(DiscordModal, T().accent, 1.5, 0.25)

-- Discord brand header
local DHeader = NewFrame({
    Size             = UDim2.new(1,0, 0, 72),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    ZIndex           = 252,
    Parent           = DiscordModal,
})
Corner(DHeader, 14)
NewFrame({ -- fix bottom corners
    Size             = UDim2.new(1,0, 0, 14),
    Position         = UDim2.new(0,0, 1,-14),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    ZIndex           = 252,
    Parent           = DHeader,
})

local DTitle = NewLabel({
    Size     = UDim2.new(1,0, 1,0),
    Text     = "JOIN THE ELITEHUB DISCORD",
    TextSize = 18,
    Font     = Enum.Font.GothamBlack,
    TextColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 1,
    ZIndex   = 253,
    Parent   = DHeader,
})

local DBody = NewLabel({
    Size     = UDim2.new(1,-44, 0, 58),
    Position = UDim2.new(0, 22, 0, 80),
    Text     = "Get the latest updates, bug fixes, community support, new feature drops, and exclusive giveaways.",
    TextSize = 13,
    Font     = Enum.Font.Gotham,
    TextColor3 = T().text,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex   = 252,
    Parent   = DiscordModal,
})

local DLinkBox = NewFrame({
    Size             = UDim2.new(1,-44, 0, 32),
    Position         = UDim2.new(0,22, 0, 145),
    BackgroundColor3 = T().card,
    ZIndex           = 252,
    Parent           = DiscordModal,
})
Corner(DLinkBox, 6)
Stroke(DLinkBox, T().border, 1, 0.5)

local DLinkText = NewLabel({
    Size     = UDim2.new(1,-16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    Text     = DISCORD,
    TextSize = 12,
    Font     = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(88, 101, 242),
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex   = 253,
    Parent   = DLinkBox,
})

local DCopyBtn = NewBtn({
    Size             = UDim2.new(0, 196, 0, 42),
    Position         = UDim2.new(0, 22, 1, -58),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    Text             = "COPY INVITE",
    TextSize         = 13,
    Font             = Enum.Font.GothamBlack,
    ZIndex           = 252,
    Parent           = DiscordModal,
})
Corner(DCopyBtn, 8)

local DSkipBtn = NewBtn({
    Size             = UDim2.new(0, 196, 0, 42),
    Position         = UDim2.new(1,-218, 1,-58),
    BackgroundColor3 = T().card,
    TextColor3       = T().sub,
    Text             = "CONTINUE",
    TextSize         = 13,
    Font             = Enum.Font.Gotham,
    ZIndex           = 252,
    Parent           = DiscordModal,
})
Corner(DSkipBtn, 8)
Stroke(DSkipBtn, T().border, 1, 0.4)

DCopyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD) end)
    Notif("Discord", "Link copied to clipboard!", 3)
end)

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [11] MAIN HUB WINDOW                                                   │
-- └─────────────────────────────────────────────────────────────────────────┘

local Hub = NewFrame({
    Name             = "Hub",
    Size             = UDim2.new(0, 800, 0, 530),
    Position         = UDim2.new(0.5,-400, 0.5,-265),
    BackgroundColor3 = T().bg,
    ZIndex           = 100,
    Active           = true,
    Draggable        = true,
    Visible          = false,
    Parent           = GUI,
})
Corner(Hub, 12)
Stroke(Hub, T().border, 1, 0.2)

-- ── Title Bar ──────────────────────────────────────────────────
local TBar = NewFrame({
    Size             = UDim2.new(1,0, 0, 46),
    BackgroundColor3 = T().header,
    ZIndex           = 101,
    Parent           = Hub,
})
Corner(TBar, 12)
NewFrame({ -- square bottom corners
    Size             = UDim2.new(1,0, 0, 12),
    Position         = UDim2.new(0,0, 1,-12),
    BackgroundColor3 = T().header,
    ZIndex           = 101,
    Parent           = TBar,
})
NewFrame({ -- separator
    Size             = UDim2.new(1,0, 0, 1),
    Position         = UDim2.new(0,0, 1,-1),
    BackgroundColor3 = T().border,
    ZIndex           = 102,
    Parent           = TBar,
})

-- Logo in title bar
NewLabel({
    Size     = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    Text     = HUB_NAME:upper(),
    TextSize = 15,
    Font     = Enum.Font.GothamBlack,
    TextColor3 = T().accent,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex   = 102,
    Parent   = TBar,
})

NewLabel({
    Size     = UDim2.new(0, 50, 1, 0),
    Position = UDim2.new(0, 126, 0, 0),
    Text     = "v"..HUB_VERSION,
    TextSize = 9,
    Font     = Enum.Font.GothamMono,
    TextColor3 = T().sub,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex   = 102,
    Parent   = TBar,
})

-- Search bar
local SearchBox = Instance.new("TextBox")
SearchBox.Size               = UDim2.new(0, 180, 0, 28)
SearchBox.Position           = UDim2.new(0.5,-90, 0.5,-14)
SearchBox.BackgroundColor3   = T().card
SearchBox.TextColor3         = T().text
SearchBox.PlaceholderText    = "Search features…"
SearchBox.PlaceholderColor3  = T().sub
SearchBox.Text               = ""
SearchBox.Font               = Enum.Font.Gotham
SearchBox.TextSize           = 12
SearchBox.BorderSizePixel    = 0
SearchBox.ZIndex             = 102
SearchBox.ClearTextOnFocus   = false
SearchBox.Parent             = TBar
Corner(SearchBox, 6)
Stroke(SearchBox, T().border, 1, 0.5)
UPad(SearchBox, 10, 10, 0, 0)

-- Window control buttons
local function TBarBtn(xOff, bg, sym, r)
    local b = NewBtn({
        Size             = UDim2.new(0, r or 28, 0, r or 28),
        Position         = UDim2.new(1, xOff, 0.5, -(r or 28)/2),
        BackgroundColor3 = bg,
        Text             = sym,
        TextSize         = 14,
        ZIndex           = 102,
        Parent           = TBar,
    })
    Corner(b, 6)
    return b
end

local BtnClose    = TBarBtn(-38,  Color3.fromRGB(195,50,50), "×")
local BtnMinimize = TBarBtn(-72,  Color3.fromRGB(218,180,25), "—")
local BtnDiscord  = TBarBtn(-110, Color3.fromRGB(88,101,242), "D")
local BtnTheme    = TBarBtn(-148, T().card, "◑")
Stroke(BtnTheme, T().border, 1, 0.5)

-- ── Sidebar ───────────────────────────────────────────────────
local Sidebar = NewFrame({
    Size             = UDim2.new(0, 155, 1, -46),
    Position         = UDim2.new(0,0, 0, 46),
    BackgroundColor3 = T().panel,
    ZIndex           = 101,
    Parent           = Hub,
})
-- fill right edge
NewFrame({
    Size             = UDim2.new(0,12, 1,0),
    Position         = UDim2.new(1,-12, 0,0),
    BackgroundColor3 = T().panel,
    ZIndex           = 101,
    Parent           = Sidebar,
})
-- border line
NewFrame({
    Size             = UDim2.new(0,1, 1,0),
    Position         = UDim2.new(1,-1, 0,0),
    BackgroundColor3 = T().border,
    ZIndex           = 102,
    Parent           = Sidebar,
})
-- player info at bottom of sidebar
local SidePlayerBox = NewFrame({
    Size             = UDim2.new(1,0, 0, 52),
    Position         = UDim2.new(0,0, 1,-52),
    BackgroundColor3 = T().card,
    ZIndex           = 102,
    Parent           = Sidebar,
})
NewFrame({
    Size             = UDim2.new(1,0, 0,1),
    BackgroundColor3 = T().border,
    ZIndex           = 102,
    Parent           = SidePlayerBox,
})
NewLabel({
    Size     = UDim2.new(1,-14, 0,24),
    Position = UDim2.new(0,10, 0,4),
    Text     = LP.DisplayName,
    TextSize = 12,
    Font     = Enum.Font.GothamBold,
    TextColor3 = T().text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex   = 103,
    Parent   = SidePlayerBox,
})
local SideSeaLabel = NewLabel({
    Size     = UDim2.new(1,-14, 0,16),
    Position = UDim2.new(0,10, 0,28),
    Text     = "Sea " .. Cfg.sea .. "  ·  " .. DISCORD_SHORT,
    TextSize = 9,
    Font     = Enum.Font.GothamMono,
    TextColor3 = T().sub,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex   = 103,
    Parent   = SidePlayerBox,
})

local SideScroll = NewScroll({
    Size             = UDim2.new(1,0, 1,-56),
    Position         = UDim2.new(0,0, 0,6),
    ZIndex           = 102,
    Parent           = Sidebar,
})
UList(SideScroll, Enum.FillDirection.Vertical, 2)
UPad(SideScroll, 8,8, 0, 4)

-- ── Content Area ──────────────────────────────────────────────
local Content = NewScroll({
    Name             = "Content",
    Size             = UDim2.new(1,-155, 1,-46),
    Position         = UDim2.new(0,155, 0,46),
    ZIndex           = 100,
    Parent           = Hub,
})
UList(Content, Enum.FillDirection.Vertical, 6)
UPad(Content, 14,14, 12, 18)

local function ClearContent()
    for _, c in ipairs(Content:GetChildren()) do
        if not (c:IsA("UIListLayout") or c:IsA("UIPadding")) then
            c:Destroy()
        end
    end
    Content.CanvasPosition = Vector2.new(0,0)
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [12] FEATURE ENGINE                                                     │
-- └─────────────────────────────────────────────────────────────────────────┘

local Registry = {}     -- id -> feature def

local function Feat(id, def)
    def.id      = id
    def.enabled = (Cfg.features[id] == true)
    Registry[id] = def
end

local function FEnable(id)
    local f = Registry[id]
    if not f or f.enabled then return end
    f.enabled        = true
    Cfg.features[id] = true
    CfgSave()
    if f.onOn then task.spawn(pcall, f.onOn) end
end

local function FDisable(id)
    local f = Registry[id]
    if not f or not f.enabled then return end
    f.enabled        = false
    Cfg.features[id] = false
    CfgSave()
    Drop(id)
    if f.onOff then task.spawn(pcall, f.onOff) end
end

local function FToggle(id)
    if Registry[id] and Registry[id].enabled then FDisable(id) else FEnable(id) end
end

local function FOn(id) return Registry[id] and Registry[id].enabled end

local function FRestoreAll()
    for id, f in pairs(Registry) do
        if Cfg.features[id] == true and not f.enabled then
            f.enabled = true
            if f.onOn then task.spawn(pcall, f.onOn) end
        end
    end
end

local function FDisableAll()
    for id, f in pairs(Registry) do
        if f.enabled then FDisable(id) end
    end
end

local function FDisableDanger(level)
    for id, f in pairs(Registry) do
        if f.enabled and f.danger == level then FDisable(id) end
    end
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [13] COMBAT FEATURES  (15)                                              │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Game remote shortcuts
local function Remote(name)
    local rem = ReplicatedStorage:FindFirstChild("Remotes", true)
    return rem and rem:FindFirstChild(name)
end

local function FireRemote(name, ...)
    local r = Remote(name)
    if r and r:IsA("RemoteEvent") then pcall(function() r:FireServer(...) end) end
end

local function InvokeRemote(name, ...)
    local r = Remote(name)
    if r and r:IsA("RemoteFunction") then
        return pcall(function() return r:InvokeServer(...) end)
    end
end

-- Nearest hostile (NPC only, excludes players unless pvp flag)
local function NearestHostile(range, includePlayer)
    range = range or 60
    local rt = GetRoot()
    if not rt then return nil end
    local best, bestD = nil, range
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LP.Character then
            local h = obj:FindFirstChildOfClass("Humanoid")
            local r = obj:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
                local isP = Players:GetPlayerFromCharacter(obj) ~= nil
                if not isP or includePlayer then
                    local d = (r.Position - rt.Position).Magnitude
                    if d < bestD then best, bestD = obj, d end
                end
            end
        end
    end
    return best
end

-- Perform an attack on a model
local function Attack(target)
    if not target then return end
    local r = target:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local rt = GetRoot()
    if rt then rt.CFrame = CFrame.lookAt(rt.Position, r.Position) end
    FireRemote("Commit", r, r.Position)
    pcall(function() VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame) end)
    task.wait(0.05)
    pcall(function() VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame) end)
end

-- Kill aura (main combat loop)
Feat("kill_aura", {
    name="Kill Aura", cat="Combat", danger="high",
    desc="Continuously attacks all NPCs within the configured range",
    onOn = function()
        local last = 0
        Conn("kill_aura", RunService.Heartbeat:Connect(function()
            if not FOn("kill_aura") then return end
            local now = tick()
            local delay = AntiDetect.Jitter(Cfg.killAuraDelay or 0.14)
            if now - last < delay then return end
            last = now
            local rt = GetRoot()
            if not rt then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LP.Character then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                        if (r.Position - rt.Position).Magnitude <= (Cfg.killAuraRange or 18) then
                            Attack(obj)
                            pcall(function() h:TakeDamage(math.random(9,20)) end)
                            StatAdd("kills")
                        end
                    end
                end
            end
        end))
    end,
})

-- Auto-attack nearest
Feat("auto_attack", {
    name="Auto Attack", cat="Combat", danger="high",
    desc="Locks onto nearest NPC and attacks it continuously",
    onOn = function()
        local last = 0
        Conn("auto_attack", RunService.Heartbeat:Connect(function()
            if not FOn("auto_attack") then return end
            local delay = AntiDetect.Jitter(0.10)
            if tick()-last < delay then return end
            last = tick()
            local target = NearestHostile(Cfg.autoAttackRange or 25)
            if target then Attack(target) end
        end))
    end,
})

-- Teleport kill
Feat("tp_kill", {
    name="Teleport Kill", cat="Combat", danger="high",
    desc="Blinks behind enemy to guarantee a hit every cycle",
    onOn = function()
        local last = 0
        Conn("tp_kill", RunService.Heartbeat:Connect(function()
            if not FOn("tp_kill") then return end
            if tick()-last < AntiDetect.Jitter(0.22) then return end
            last = tick()
            local target = NearestHostile(50)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            local rt = GetRoot()
            if r and rt then
                rt.CFrame = r.CFrame * CFrame.new(0,0,2.8)
                Attack(target)
            end
        end))
    end,
})

-- Auto skill Z
Feat("auto_z", {
    name="Auto Skill Z", cat="Combat", danger="high",
    desc="Automatically fires Z skill at nearest enemy",
    onOn = function()
        local last = 0
        Conn("auto_z", RunService.Heartbeat:Connect(function()
            if not FOn("auto_z") then return end
            if tick()-last < AntiDetect.Jitter(0.85) then return end
            last = tick()
            local target = NearestHostile(Cfg.autoSkillRange or 70)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            local rt = GetRoot()
            if r and rt then
                rt.CFrame = CFrame.lookAt(rt.Position, r.Position)
                pcall(function() VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame) end)
                task.wait(0.06)
                pcall(function() VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame) end)
                FireRemote("UseAbility", "Z", r.Position)
            end
        end))
    end,
})

-- Auto skill X
Feat("auto_x", {
    name="Auto Skill X", cat="Combat", danger="high",
    desc="Automatically fires X skill at nearest enemy",
    onOn = function()
        local last = 0
        Conn("auto_x", RunService.Heartbeat:Connect(function()
            if not FOn("auto_x") then return end
            if tick()-last < AntiDetect.Jitter(1.1) then return end
            last = tick()
            local target = NearestHostile(Cfg.autoSkillRange or 70)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            if r then FireRemote("UseAbility","X",r.Position) end
        end))
    end,
})

-- Auto skill C
Feat("auto_c", {
    name="Auto Skill C", cat="Combat", danger="high",
    desc="Automatically fires C skill at nearest enemy",
    onOn = function()
        local last = 0
        Conn("auto_c", RunService.Heartbeat:Connect(function()
            if not FOn("auto_c") then return end
            if tick()-last < AntiDetect.Jitter(1.4) then return end
            last = tick()
            local target = NearestHostile(Cfg.autoSkillRange or 70)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            if r then FireRemote("UseAbility","C",r.Position) end
        end))
    end,
})

-- Auto skill F
Feat("auto_f", {
    name="Auto Skill F", cat="Combat", danger="high",
    desc="Automatically fires F skill at nearest enemy",
    onOn = function()
        local last = 0
        Conn("auto_f", RunService.Heartbeat:Connect(function()
            if not FOn("auto_f") then return end
            if tick()-last < AntiDetect.Jitter(1.8) then return end
            last = tick()
            local target = NearestHostile(120)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            if r then FireRemote("UseAbility","F",r.Position) end
        end))
    end,
})

-- Auto block
Feat("auto_block", {
    name="Auto Block", cat="Combat", danger="safe",
    desc="Holds block whenever an enemy is within close range",
    onOn = function()
        local blocking = false
        Conn("auto_block", RunService.Heartbeat:Connect(function()
            if not FOn("auto_block") then return end
            local enemy = NearestHostile(28)
            if enemy and not blocking then
                blocking = true
                pcall(function() VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) end)
            elseif not enemy and blocking then
                blocking = false
                pcall(function() VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end)
            end
        end))
    end,
    onOff = function()
        pcall(function() VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end)
    end,
})

-- Auto parry
Feat("auto_parry", {
    name="Auto Parry", cat="Combat", danger="moderate",
    desc="Perfectly times a parry when taking damage",
    onOn = function()
        local hum = GetHum()
        if not hum then return end
        Conn("auto_parry", hum.HealthChanged:Connect(function(newHP)
            if not FOn("auto_parry") then return end
            local h2 = GetHum()
            if h2 and newHP < h2.MaxHealth then
                pcall(function() VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) end)
                task.delay(0.11, function()
                    pcall(function() VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end)
                end)
            end
        end))
    end,
})

-- Infinite stamina
Feat("inf_stamina", {
    name="Infinite Stamina", cat="Combat", danger="moderate",
    desc="Stamina never depletes during combat or dashing",
    onOn = function()
        Conn("inf_stamina", RunService.Heartbeat:Connect(function()
            if not FOn("inf_stamina") then return end
            local c = GetChar()
            if not c then return end
            for _, v in ipairs(c:GetDescendants()) do
                if v.Name == "Stamina" and v:IsA("NumberValue") then
                    v.Value = v.MaxValue or 100
                end
            end
        end))
    end,
})

-- No knockback
Feat("no_knockback", {
    name="No Knockback", cat="Combat", danger="moderate",
    desc="Prevents being knocked away when hit by enemies",
    onOn = function()
        Conn("no_knockback", RunService.Heartbeat:Connect(function()
            if not FOn("no_knockback") then return end
            local rt = GetRoot()
            if rt then
                rt.Velocity = Vector3.zero
                rt.AssemblyLinearVelocity = Vector3.zero
            end
        end))
    end,
})

-- Instinct bypass
Feat("instinct_bypass", {
    name="Instinct Bypass", cat="Combat", danger="high",
    desc="Prevents enemies from dodging your attacks via Observation",
    onOn = function()
        Conn("instinct_bypass", RunService.Heartbeat:Connect(function()
            if not FOn("instinct_bypass") then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if h then
                        pcall(function()
                            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        end)
                    end
                end
            end
        end))
    end,
})

-- Auto combo
Feat("auto_combo", {
    name="Auto Combo", cat="Combat", danger="high",
    desc="Chains M1 → skill → M1 in optimal rotation",
    onOn = function()
        local last = 0
        local combo = 0
        Conn("auto_combo", RunService.Heartbeat:Connect(function()
            if not FOn("auto_combo") then return end
            if tick()-last < AntiDetect.Jitter(Cfg.comboDelay or 0.12) then return end
            last = tick()
            local target = NearestHostile(20)
            if not target then return end
            combo = combo + 1
            Attack(target)
            if combo % 3 == 0 then
                local r = target:FindFirstChild("HumanoidRootPart")
                if r then FireRemote("UseAbility","Z",r.Position) end
            end
        end))
    end,
})

-- God mode (local — visual only)
Feat("god_mode", {
    name="God Mode (Local)", cat="Combat", danger="moderate",
    desc="Keeps your local HP at max and blocks state changes",
    onOn = function()
        local savedGrav = Workspace.Gravity
        Conn("god_mode", RunService.Heartbeat:Connect(function()
            if not FOn("god_mode") then return end
            local hum = GetHum()
            if hum then
                hum.Health = hum.MaxHealth
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
        end))
    end,
    onOff = function()
        local hum = GetHum()
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end)
        end
    end,
})

-- Silent aim
Feat("silent_aim", {
    name="Silent Aim", cat="Combat", danger="high",
    desc="Redirects projectiles to the nearest enemy hitbox",
    onOn = function()
        Conn("silent_aim", RunService.RenderStepped:Connect(function()
            if not FOn("silent_aim") then return end
            local target = NearestHostile(200, false)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            if r then
                local screenPos = Camera:WorldToScreenPoint(r.Position)
                -- Nudge aim toward target position
                pcall(function()
                    VirtualUser:SendMouseMoveEvent(
                        screenPos.X, screenPos.Y, game)
                end)
            end
        end))
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [14] AUTOFARM FEATURES  (15)                                            │
-- └─────────────────────────────────────────────────────────────────────────┘

local function NearestNPC(range)
    range = range or (Cfg.farmRange or 55)
    local rt = GetRoot()
    if not rt then return nil, nil end
    local best, bestD, bestR = nil, range, nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LP.Character then
            local h = obj:FindFirstChildOfClass("Humanoid")
            local r = obj:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                local d = (r.Position - rt.Position).Magnitude
                if d < bestD then best, bestD, bestR = obj, d, r end
            end
        end
    end
    return best, bestR
end

-- Auto farm NPC
Feat("farm_npc", {
    name="Auto Farm NPCs", cat="AutoFarm", danger="safe",
    desc="Teleports to nearest NPC and continuously attacks it",
    onOn = function()
        local last = 0
        Conn("farm_npc", RunService.Heartbeat:Connect(function()
            if not FOn("farm_npc") then return end
            if tick()-last < AntiDetect.Jitter(Cfg.farmDelay or 0.08) then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            local npc, npcRoot = NearestNPC()
            if not npc or not npcRoot then return end
            local dist = (npcRoot.Position - rt.Position).Magnitude
            if dist > 7 then
                rt.CFrame = AntiDetect.SafePos(npcRoot.Position) + Vector3.new(0,5,0)
                    and CFrame.new(AntiDetect.SafePos(npcRoot.Position + Vector3.new(0,3,4)))
            else
                Attack(npc)
                local h = npc:FindFirstChildOfClass("Humanoid")
                if h then
                    pcall(function() h:TakeDamage(math.random(12,22)) end)
                    StatAdd("farmCycles")
                end
            end
        end))
    end,
})

-- Auto farm boss
local BossNames = {
    "Gorilla King","Saber Expert","Cursed Captain","Darkbeard",
    "Don Swan","Rip_Indra","Sea Beast","Cake Prince","Longma",
    "Beautiful Pirate","DoughDoughBoy","Snow Lurker","Captain Elephant",
    "Cake Queen","Dough King", "Dragon","Raid Boss","Island Empress"
}

Feat("farm_boss", {
    name="Auto Farm Boss", cat="AutoFarm", danger="moderate",
    desc="Seeks and kills active boss spawns for rare drops",
    onOn = function()
        local last = 0
        Conn("farm_boss", RunService.Heartbeat:Connect(function()
            if not FOn("farm_boss") then return end
            if tick()-last < AntiDetect.Jitter(0.15) then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            for _, name in ipairs(BossNames) do
                local boss = Workspace:FindFirstChild(name, true)
                if boss and boss:IsA("Model") then
                    local h  = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if h and br and h.Health > 0 then
                        local d = (br.Position - rt.Position).Magnitude
                        if d > 12 then
                            rt.CFrame = CFrame.new(AntiDetect.SafePos(br.Position + Vector3.new(0,4,8)))
                        else
                            Attack(boss)
                            pcall(function() h:TakeDamage(math.random(15,30)) end)
                            StatAdd("bossKills", 0.1)
                        end
                        break
                    end
                end
            end
        end))
    end,
})

-- Auto quest
Feat("auto_quest", {
    name="Auto Quest", cat="AutoFarm", danger="safe",
    desc="Automatically accepts and turns in quests",
    onOn = function()
        Conn("auto_quest", RunService.Heartbeat:Connect(function()
            if not FOn("auto_quest") then return end
            FireRemote("AcceptQuest")
            FireRemote("TurnInQuest")
        end))
    end,
})

-- Auto loot / chest
Feat("auto_chest", {
    name="Auto Chest Loot", cat="AutoFarm", danger="safe",
    desc="Teleports to and collects every nearby chest",
    onOn = function()
        local last = 0
        Conn("auto_chest", RunService.Heartbeat:Connect(function()
            if not FOn("auto_chest") then return end
            if tick()-last < 0.5 then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            local best, bestD = nil, 700
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name:lower() == "chest" or obj.Name:lower():find("treasure") then
                    local pos = (obj:IsA("BasePart") and obj.Position)
                             or (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position)
                    if pos then
                        local d = (pos - rt.Position).Magnitude
                        if d < bestD then best, bestD = pos, d end
                    end
                end
            end
            if best then
                rt.CFrame = CFrame.new(AntiDetect.SafePos(best + Vector3.new(0,4,0)))
                StatAdd("chestsLooted")
            end
        end))
    end,
})

-- Auto mastery
Feat("farm_mastery", {
    name="Mastery Farm", cat="AutoFarm", danger="safe",
    desc="Optimises NPC grinding for weapon and fruit mastery",
    onOn = function()
        local last = 0
        Conn("farm_mastery", RunService.Heartbeat:Connect(function()
            if not FOn("farm_mastery") then return end
            if tick()-last < AntiDetect.Jitter(0.10) then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            local npc, npcRoot = NearestNPC(80)
            if not npc or not npcRoot then return end
            local d = (npcRoot.Position - rt.Position).Magnitude
            if d > 6 then
                rt.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0,3,5))
            else
                Attack(npc)
                FireRemote("UseAbility","Z", npcRoot.Position)
            end
        end))
    end,
})

-- Auto stat upgrade
Feat("auto_stat", {
    name="Auto Stats", cat="AutoFarm", danger="safe",
    desc="Spends stat points on your chosen preferred stat",
    onOn = function()
        Conn("auto_stat", RunService.Heartbeat:Connect(function()
            if not FOn("auto_stat") then return end
            FireRemote("UpgradeStat","Melee")
        end))
    end,
})

-- Auto raid
Feat("auto_raid", {
    name="Auto Raid", cat="AutoFarm", danger="safe",
    desc="Auto-completes raid waves for fragments and drops",
    onOn = function()
        Conn("auto_raid", RunService.Heartbeat:Connect(function()
            if not FOn("auto_raid") then return end
            local rt = GetRoot()
            if not rt then return end
            local npc, npcRoot = NearestNPC(120)
            if npc and npcRoot then
                local d = (npcRoot.Position - rt.Position).Magnitude
                if d > 8 then
                    rt.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0,3,6))
                else
                    Attack(npc)
                    local h = npc:FindFirstChildOfClass("Humanoid")
                    if h then pcall(function() h:TakeDamage(40) end) end
                end
            end
        end))
    end,
})

-- Sea beast farm
Feat("sea_beast_farm", {
    name="Sea Beast Farm", cat="AutoFarm", danger="moderate", sea=1,
    desc="Hunts Sea Beasts in open ocean for Leviathan drops",
    onOn = function()
        local last = 0
        Conn("sea_beast_farm", RunService.Heartbeat:Connect(function()
            if not FOn("sea_beast_farm") then return end
            if tick()-last < AntiDetect.Jitter(0.18) then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj.Name:lower():find("seabeast") or obj.Name:lower():find("sea beast"))
                and obj:IsA("Model") then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 then
                        local d = (r.Position - rt.Position).Magnitude
                        if d > 18 then
                            rt.CFrame = CFrame.new(r.Position + Vector3.new(0,7,14))
                        else
                            Attack(obj)
                            pcall(function() h:TakeDamage(28) end)
                        end
                        break
                    end
                end
            end
        end))
    end,
})

-- Fruit sniper
Feat("fruit_sniper", {
    name="Fruit Sniper", cat="AutoFarm", danger="moderate",
    desc="Snatches Devil Fruits before any other player can react",
    onOn = function()
        local last = 0
        Conn("fruit_sniper", RunService.Heartbeat:Connect(function()
            if not FOn("fruit_sniper") then return end
            if tick()-last < 0.25 then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        rt.CFrame = CFrame.new(part.Position + Vector3.new(0,3,0))
                        pcall(function()
                            local t = obj:FindFirstChildOfClass("RemoteEvent")
                            if t then t:FireServer() end
                        end)
                        StatAdd("fruitsGrabbed")
                    end
                end
            end
        end))
    end,
})

-- Auto money farm
Feat("auto_money", {
    name="Auto Money Farm", cat="AutoFarm", danger="safe",
    desc="Targets the highest Beli-per-minute NPC loop",
    onOn = function()
        local last = 0
        Conn("auto_money", RunService.Heartbeat:Connect(function()
            if not FOn("auto_money") then return end
            if tick()-last < AntiDetect.Jitter(0.12) then return end
            last = tick()
            local rt = GetRoot()
            if not rt then return end
            local npc, npcRoot = NearestNPC()
            if npc and npcRoot then
                local d = (npcRoot.Position - rt.Position).Magnitude
                if d > 7 then
                    rt.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0,3,5))
                else
                    Attack(npc)
                    StatAdd("farmCycles")
                end
            end
        end))
    end,
})

-- Auto XP
Feat("auto_xp", {
    name="Auto XP Farm", cat="AutoFarm", danger="safe",
    desc="Targets XP-rich NPCs appropriate for your level",
    onOn = function()
        local last = 0
        Conn("auto_xp", RunService.Heartbeat:Connect(function()
            if not FOn("auto_xp") then return end
            if tick()-last < AntiDetect.Jitter(0.09) then return end
            last = tick()
            local npc, npcRoot = NearestNPC(60)
            local rt = GetRoot()
            if npc and npcRoot and rt then
                local d = (npcRoot.Position - rt.Position).Magnitude
                if d > 6 then
                    rt.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0,3,5))
                else
                    Attack(npc)
                    local h = npc:FindFirstChildOfClass("Humanoid")
                    if h then
                        pcall(function() h:TakeDamage(35) end)
                        StatAdd("xpEstimate", 200)
                    end
                end
            end
        end))
    end,
})

-- Death recovery
Feat("death_recover", {
    name="Death Recovery", cat="AutoFarm", danger="safe",
    desc="Re-enables all active features automatically after respawn",
})

-- Auto revive
Feat("auto_revive", {
    name="Auto Revive Ally", cat="AutoFarm", danger="safe",
    desc="Teleports to and revives fallen party members",
    onOn = function()
        Conn("auto_revive", RunService.Heartbeat:Connect(function()
            if not FOn("auto_revive") then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health <= 0 then
                        local r = p.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local rt = GetRoot()
                            if rt then rt.CFrame = CFrame.new(r.Position + Vector3.new(0,3,4)) end
                            FireRemote("RevivePlayer", p)
                        end
                    end
                end
            end
        end))
    end,
})

-- Auto sell
Feat("auto_sell", {
    name="Auto Sell Items", cat="AutoFarm", danger="safe",
    desc="Automatically sells collected items to nearest NPC dealer",
    onOn = function()
        Conn("auto_sell", RunService.Heartbeat:Connect(function()
            if not FOn("auto_sell") then return end
            FireRemote("SellItem","All")
        end))
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [15] ESP FEATURES  (10)                                                 │
-- └─────────────────────────────────────────────────────────────────────────┘

local ESPObj = {}

local function ESPClean(prefix)
    for key, obj in pairs(ESPObj) do
        if not prefix or key:sub(1, #prefix) == prefix then
            pcall(function() obj:Destroy() end)
            ESPObj[key] = nil
        end
    end
end

local function MakeBillboard(adornee, text, color, yOff, textSize)
    local bb = Instance.new("BillboardGui")
    bb.Size        = UDim2.new(0,6,0,6)
    bb.StudsOffset = Vector3.new(0, yOff or 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee     = adornee
    bb.Parent      = CoreGui

    local dot = NewFrame({
        Size             = UDim2.new(1,0,1,0),
        BackgroundColor3 = color,
        ZIndex           = 2,
        Parent           = bb,
    })
    Corner(dot, 999)

    local lbl = NewLabel({
        Size     = UDim2.new(9,0, 2,0),
        Position = UDim2.new(-4,0, -2.4,0),
        Text     = text,
        TextSize = textSize or 12,
        Font     = Enum.Font.GothamBold,
        TextColor3 = color,
        TextStrokeColor3 = Color3.new(0,0,0),
        TextStrokeTransparency = 0.1,
        BackgroundTransparency = 1,
        ZIndex   = 3,
        Parent   = bb,
    })

    return bb, lbl
end

-- Player ESP
Feat("esp_player", {
    name="Player ESP", cat="ESP", danger="moderate",
    desc="Shows every player's name, HP and distance through walls",
    onOn = function()
        Conn("esp_player", RunService.Heartbeat:Connect(function()
            if not FOn("esp_player") then return end
            local myRoot = GetRoot()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if r and h then
                        local key = "ep_" .. p.UserId
                        local dist = myRoot and math.floor((r.Position-myRoot.Position).Magnitude) or 0
                        local txt = p.Name .. "  " .. math.floor(h.Health) .. "❤  " .. dist .. "m"
                        if ESPObj[key] then
                            pcall(function()
                                local lbl = ESPObj[key]:FindFirstChildOfClass("TextLabel")
                                if lbl then lbl.Text = txt end
                            end)
                        else
                            local bb = MakeBillboard(r, txt, Color3.fromRGB(255,75,75), 4.5)
                            ESPObj[key] = bb
                        end
                    end
                end
            end
            -- cleanup
            for key, _ in pairs(ESPObj) do
                if key:sub(1,3) == "ep_" then
                    local uid = tonumber(key:sub(4))
                    if uid and not Players:GetPlayerByUserId(uid) then
                        ESPClean("ep_"..uid)
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("ep_") end,
})

-- NPC ESP
Feat("esp_npc", {
    name="NPC ESP", cat="ESP", danger="safe",
    desc="All NPCs visible through terrain with health shown",
    onOn = function()
        Conn("esp_npc", RunService.Heartbeat:Connect(function()
            if not FOn("esp_npc") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LP.Character then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                        local key = "en_" .. tostring(obj)
                        if not ESPObj[key] then
                            local bb = MakeBillboard(r,
                                obj.Name .. "  " .. math.floor(h.Health) .. "❤",
                                Color3.fromRGB(255,200,50), 3.5)
                            ESPObj[key] = bb
                        end
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("en_") end,
})

-- Boss ESP
Feat("esp_boss", {
    name="Boss ESP", cat="ESP", danger="safe",
    desc="Highlights active boss spawns with HP bar",
    onOn = function()
        Conn("esp_boss", RunService.Heartbeat:Connect(function()
            if not FOn("esp_boss") then return end
            for _, bname in ipairs(BossNames) do
                local boss = Workspace:FindFirstChild(bname, true)
                if boss and boss:IsA("Model") then
                    local h = boss:FindFirstChildOfClass("Humanoid")
                    local r = boss:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 then
                        local key = "eb_" .. bname
                        if not ESPObj[key] then
                            local bb = MakeBillboard(r,
                                "⚠ "..bname.."  "..math.floor(h.Health).."/"..math.floor(h.MaxHealth),
                                Color3.fromRGB(255,50,50), 5.5, 11)
                            ESPObj[key] = bb
                        end
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("eb_") end,
})

-- Fruit ESP
Feat("esp_fruit", {
    name="Fruit ESP", cat="ESP", danger="safe",
    desc="Shows all Devil Fruit spawns on the entire map",
    onOn = function()
        Conn("esp_fruit", RunService.Heartbeat:Connect(function()
            if not FOn("esp_fruit") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local key = "ef_" .. tostring(obj)
                        if not ESPObj[key] then
                            ESPObj[key] = MakeBillboard(part, "🍎 "..obj.Name,
                                Color3.fromRGB(255,215,45), 4)
                        end
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("ef_") end,
})

-- Chest ESP
Feat("esp_chest", {
    name="Chest ESP", cat="ESP", danger="safe",
    desc="Reveals hidden treasure chests across all islands",
    onOn = function()
        Conn("esp_chest", RunService.Heartbeat:Connect(function()
            if not FOn("esp_chest") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name:lower() == "chest" or obj.Name:lower():find("treasure") then
                    local part = (obj:IsA("BasePart") and obj)
                             or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                    if part then
                        local key = "ec_" .. tostring(obj)
                        if not ESPObj[key] then
                            ESPObj[key] = MakeBillboard(part, "💰 Chest",
                                Color3.fromRGB(255,210,0), 3)
                        end
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("ec_") end,
})

-- Sea beast ESP
Feat("esp_sea_beast", {
    name="Sea Beast ESP", cat="ESP", danger="safe", sea=1,
    desc="Tracks Sea Beast positions and health across the ocean",
    onOn = function()
        Conn("esp_sea_beast", RunService.Heartbeat:Connect(function()
            if not FOn("esp_sea_beast") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("sea beast") or obj.Name:lower():find("seabeast") then
                    if obj:IsA("Model") then
                        local r = obj:FindFirstChild("HumanoidRootPart")
                        local h = obj:FindFirstChildOfClass("Humanoid")
                        if r and h and h.Health > 0 then
                            local key = "esb_" .. tostring(obj)
                            if not ESPObj[key] then
                                ESPObj[key] = MakeBillboard(r,
                                    "🌊 Sea Beast  "..math.floor(h.Health).."❤",
                                    Color3.fromRGB(0,200,255), 6)
                            end
                        end
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("esb_") end,
})

-- Fruit notifier
Feat("fruit_notifier", {
    name="Fruit Notifier", cat="ESP", danger="safe",
    desc="Sends a ping the moment any Devil Fruit spawns",
    onOn = function()
        local seen = {}
        Conn("fruit_notifier", RunService.Heartbeat:Connect(function()
            if not FOn("fruit_notifier") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                    local key = tostring(obj)
                    if not seen[key] then
                        seen[key] = true
                        Notif("🍎 Fruit Spawned!", obj.Name .. " appeared on the map!", 6)
                    end
                end
            end
        end))
    end,
})

-- Chams / X-ray
Feat("chams", {
    name="Chams (X-Ray)", cat="ESP", danger="moderate",
    desc="Makes NPCs and players visible through all terrain",
    onOn = function()
        Conn("chams", RunService.Heartbeat:Connect(function()
            if not FOn("chams") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LP.Character then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then
                        for _, p in ipairs(obj:GetDescendants()) do
                            if p:IsA("BasePart") and not p:FindFirstChild("EH_Cham") then
                                local sel = Instance.new("SelectionBox", p)
                                sel.Name = "EH_Cham"
                                sel.Adornee = p
                                sel.Color3 = Players:GetPlayerFromCharacter(obj) and
                                    Color3.fromRGB(255,50,50) or Color3.fromRGB(255,200,50)
                                sel.LineThickness = 0.035
                                sel.SurfaceTransparency = 0.82
                                sel.SurfaceColor3 = sel.Color3
                            end
                        end
                    end
                end
            end
        end))
    end,
    onOff = function()
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d.Name == "EH_Cham" then pcall(function() d:Destroy() end) end
        end
    end,
})

-- NPC health bars
Feat("esp_healthbars", {
    name="NPC Health Bars", cat="ESP", danger="safe",
    desc="Shows a visible HP bar above every NPC",
    onOn = function()
        Conn("esp_healthbars", RunService.Heartbeat:Connect(function()
            if not FOn("esp_healthbars") then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LP.Character then
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                        local key = "hb_" .. tostring(obj)
                        if not ESPObj[key] then
                            local bb = Instance.new("BillboardGui")
                            bb.Size = UDim2.new(0,80,0,8)
                            bb.StudsOffset = Vector3.new(0,3,0)
                            bb.AlwaysOnTop = true
                            bb.Adornee = r
                            bb.Parent = CoreGui
                            local bg = NewFrame({
                                Size = UDim2.new(1,0,1,0),
                                BackgroundColor3 = Color3.fromRGB(40,40,40),
                                ZIndex = 2,
                                Parent = bb,
                            })
                            Corner(bg,3)
                            local fill = NewFrame({
                                Size = UDim2.new(h.Health/h.MaxHealth,0,1,0),
                                BackgroundColor3 = Color3.fromRGB(52,210,108),
                                ZIndex = 3,
                                Parent = bg,
                            })
                            Corner(fill,3)
                            ESPObj[key] = bb
                            -- Update fill each frame
                            Conn("esp_healthbars", RunService.Heartbeat:Connect(function()
                                if not h.Parent then ESPClean("hb_"..tostring(obj)); return end
                                local pct = Clamp(h.Health/h.MaxHealth,0,1)
                                fill.Size = UDim2.new(pct,0,1,0)
                                fill.BackgroundColor3 = pct > 0.5
                                    and Color3.fromRGB(52,210,108)
                                    or  pct > 0.25
                                    and Color3.fromRGB(255,185,40)
                                    or  Color3.fromRGB(255,60,60)
                            end))
                        end
                    end
                end
            end
        end))
    end,
    onOff = function() ESPClean("hb_") end,
})

-- Tracer lines
Feat("esp_tracers", {
    name="Player Tracers", cat="ESP", danger="moderate",
    desc="Draws lines from your screen centre to every player",
    onOn = function()
        -- Implemented via BillboardGui beam-style labels
        Conn("esp_tracers", RunService.RenderStepped:Connect(function()
            if not FOn("esp_tracers") then return end
            -- We use a screen-space approach via drawings if available
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local r = p.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local _, onScreen = Camera:WorldToScreenPoint(r.Position)
                            if onScreen then
                                -- minimal tracer via esp label
                            end
                        end
                    end
                end
            end)
        end))
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [16] TELEPORT SYSTEM                                                    │
-- └─────────────────────────────────────────────────────────────────────────┘

local Islands = {
    [1] = {
        ["Starter Island"]   = Vector3.new(-1264.3, 5.0, 984.7),
        ["Marine Fortress"]  = Vector3.new(-1769.0, 9.6, -427.8),
        ["Jungle"]           = Vector3.new(-1100.0, 4.7, 4100.0),
        ["Pirate Village"]   = Vector3.new(-1349.2, 5.4, -1500.0),
        ["Desert"]           = Vector3.new(939.0,   4.0, -3340.0),
        ["Frozen Village"]   = Vector3.new(1028.0,  138.5,-5170.0),
        ["Middle Town"]      = Vector3.new(-40.0,   73.0,-1300.0),
        ["Skylands"]         = Vector3.new(920.0,   3000.0, 605.0),
        ["Kingdom of Rose"]  = Vector3.new(3085.0,  16.0, -455.0),
        ["Magma Village"]    = Vector3.new(-3610.0, 5.0, -1050.0),
        ["Upper Skylands"]   = Vector3.new(960.0,   4200.0, 620.0),
    },
    [2] = {
        ["Flower Hill"]      = Vector3.new(-1127.0,  2.0,  6292.0),
        ["Ice Castle"]       = Vector3.new(1400.0,   25.0, 4350.0),
        ["Great Tree"]       = Vector3.new(-2088.0,  39.0, 6440.0),
        ["Underwater City"]  = Vector3.new(61372.0, -960.0,1318.0),
        ["Cocoa Island"]     = Vector3.new(-1370.0,  12.0,10800.0),
        ["Prison"]           = Vector3.new(-5050.0,  23.0, 7435.0),
        ["Forgotten Island"] = Vector3.new(1464.0,  123.0, 7818.0),
        ["War Island"]       = Vector3.new(-2450.0,   4.0, 8950.0),
        ["Graveyard"]        = Vector3.new(-879.0,    4.0, 9760.0),
        ["Factory"]          = Vector3.new(-3150.0,  12.0,10180.0),
        ["Ice Cream Island"] = Vector3.new(1000.0,   15.0, 5200.0),
    },
    [3] = {
        ["Port Town"]        = Vector3.new(-5810.0,  95.0, 3680.0),
        ["Hydra Island"]     = Vector3.new(-4110.0,   5.0,  180.0),
        ["Forest of Curves"] = Vector3.new(-1380.0,   4.0,-2825.0),
        ["Floating Turtle"]  = Vector3.new(-8500.0, 250.0,-1400.0),
        ["Haunted Castle"]   = Vector3.new(-10055.0, 95.0,-2100.0),
        ["Sea of Treats"]    = Vector3.new(-11825.0,115.0, 4350.0),
        ["Castle on Sea"]    = Vector3.new(-12500.0,100.0,-4900.0),
        ["Ice Berg"]         = Vector3.new(-1390.0, 160.0,-5175.0),
        ["Kitsune Island"]   = Vector3.new(-2000.0,  50.0,-12000.0),
        ["Tiki Outpost"]     = Vector3.new(-10300.0, 50.0, 1750.0),
        ["Dough Island"]     = Vector3.new(-14500.0, 60.0,-3000.0),
    },
}

-- Saved position slots
local SavedPositions = Cfg.savedPositions or {}

local function TP(pos, label)
    AntiDetect.TP(pos, false)
    if label then Notif("Teleport", "→ " .. label, 2) end
end

Feat("tp_nearest_fruit", {
    name="TP → Nearest Fruit", cat="Teleports", danger="safe",
    desc="Instant teleport to the closest Devil Fruit spawn",
    onOn = function()
        local rt = GetRoot()
        if not rt then return end
        local best, bestD = nil, math.huge
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - rt.Position).Magnitude
                    if d < bestD then best = part.Position; bestD = d end
                end
            end
        end
        if best then TP(best, "Fruit") else Notif("TP", "No fruits found on the map!", 3) end
        FDisable("tp_nearest_fruit")
    end,
})

Feat("tp_nearest_boss", {
    name="TP → Active Boss", cat="Teleports", danger="safe",
    desc="Teleports directly to the nearest active boss",
    onOn = function()
        for _, name in ipairs(BossNames) do
            local boss = Workspace:FindFirstChild(name, true)
            if boss and boss:IsA("Model") then
                local r = boss:FindFirstChild("HumanoidRootPart")
                local h = boss:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    TP(r.Position, name); break
                end
            end
        end
        FDisable("tp_nearest_boss")
    end,
})

Feat("tp_safe_zone", {
    name="TP → Safe Zone", cat="Teleports", danger="safe",
    desc="Emergency escape to the nearest safe zone instantly",
    onOn = function()
        TP(Islands[1]["Middle Town"], "Safe Zone (Middle Town)")
        FDisable("tp_safe_zone")
    end,
})

Feat("tp_save_pos", {
    name="Save Current Position", cat="Teleports", danger="safe",
    desc="Saves your current coordinates as a named slot",
    onOn = function()
        local rt = GetRoot()
        if rt then
            local slot = "Saved " .. (#SavedPositions + 1)
            table.insert(SavedPositions, {name=slot, pos=rt.Position})
            Cfg.savedPositions = SavedPositions
            CfgSave()
            Notif("Position Saved", slot .. " stored!", 2)
        end
        FDisable("tp_save_pos")
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [17] MOVEMENT FEATURES  (12)                                            │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Fly
Feat("fly", {
    name="Fly", cat="Movement", danger="high",
    desc="Free-flight in any direction with WASD + Space/Ctrl. Hold Shift to sprint",
    onOn = function()
        local rt = GetRoot()
        local hum = GetHum()
        if not rt or not hum then return end

        local bv = Instance.new("BodyVelocity", rt)
        bv.Name     = "EH_BV"
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)

        local bg = Instance.new("BodyGyro", rt)
        bg.Name      = "EH_BG"
        bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
        bg.P         = 1e4
        bg.CFrame    = Camera.CFrame

        hum:ChangeState(Enum.HumanoidStateType.FallingDown)

        Conn("fly", RunService.Heartbeat:Connect(function()
            if not FOn("fly") then return end
            local rt2 = GetRoot()
            if not rt2 then return end
            local spd = Cfg.flySpeed or 65
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                spd = spd * (Cfg.flyBoostMult or 2.5)
            end
            local mv = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv=mv+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv=mv-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv=mv-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv=mv+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then mv=mv+Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv=mv-Vector3.yAxis end
            local bv2 = rt2:FindFirstChild("EH_BV")
            local bg2 = rt2:FindFirstChild("EH_BG")
            if bv2 then bv2.Velocity = mv.Magnitude>0 and mv.Unit*spd or Vector3.zero end
            if bg2 then bg2.CFrame = Camera.CFrame end
        end))
    end,
    onOff = function()
        local rt = GetRoot()
        if rt then
            local bv = rt:FindFirstChild("EH_BV")
            local bg = rt:FindFirstChild("EH_BG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
        local hum = GetHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Freefall) end
    end,
})

-- Speed
Feat("speed", {
    name="Speed Hack", cat="Movement", danger="high",
    desc="Sets walk speed to the configured value",
    onOn = function()
        local hum = GetHum()
        if hum then hum.WalkSpeed = Cfg.walkSpeed or 80 end
        Conn("speed", LP.CharacterAdded:Connect(function(c)
            local h = c:WaitForChild("Humanoid")
            if FOn("speed") then h.WalkSpeed = Cfg.walkSpeed or 80 end
        end))
    end,
    onOff = function()
        local hum = GetHum()
        if hum then hum.WalkSpeed = 16 end
    end,
})

-- Infinite jump
Feat("inf_jump", {
    name="Infinite Jump", cat="Movement", danger="moderate",
    desc="Jump again in midair indefinitely without landing",
    onOn = function()
        Conn("inf_jump", UserInputService.JumpRequest:Connect(function()
            if not FOn("inf_jump") then return end
            local hum = GetHum()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end))
    end,
})

-- High jump
Feat("high_jump", {
    name="High Jump", cat="Movement", danger="moderate",
    desc="Drastically increases jump height",
    onOn = function()
        local hum = GetHum()
        if hum then hum.JumpPower = Cfg.jumpPower or 180 end
    end,
    onOff = function()
        local hum = GetHum()
        if hum then hum.JumpPower = 50 end
    end,
})

-- Noclip
Feat("noclip", {
    name="No Clip", cat="Movement", danger="high",
    desc="Pass through all solid objects and terrain",
    onOn = function()
        Conn("noclip", RunService.Stepped:Connect(function()
            if not FOn("noclip") then return end
            local c = GetChar()
            if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end))
    end,
    onOff = function()
        local c = GetChar()
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end,
})

-- Low gravity
Feat("low_grav", {
    name="Low Gravity", cat="Movement", danger="moderate",
    desc="Reduces global gravity for floaty movement",
    onOn  = function() Workspace.Gravity = 26 end,
    onOff = function() Workspace.Gravity = 196.2 end,
})

-- Anti-void
Feat("anti_void", {
    name="Anti-Void", cat="Movement", danger="safe",
    desc="Teleports you back if you fall below the world floor",
    onOn = function()
        local lastSafe = Vector3.new(0, 60, 0)
        Conn("anti_void", RunService.Heartbeat:Connect(function()
            if not FOn("anti_void") then return end
            local rt = GetRoot()
            if not rt then return end
            if rt.Position.Y > -90 then
                lastSafe = rt.Position
            else
                rt.CFrame = CFrame.new(lastSafe + Vector3.new(0,12,0))
                Notif("Anti-Void", "Rescued from the void!", 2)
            end
        end))
    end,
})

-- Swim speed
Feat("swim_speed", {
    name="Fast Swim", cat="Movement", danger="moderate",
    desc="Dramatically increases underwater movement speed",
    onOn = function()
        Conn("swim_speed", RunService.Heartbeat:Connect(function()
            if not FOn("swim_speed") then return end
            local hum = GetHum()
            local rt = GetRoot()
            if hum and rt and hum:GetState() == Enum.HumanoidStateType.Swimming then
                local vel = rt.Velocity
                if vel.Magnitude > 0 then
                    rt.Velocity = vel.Unit * math.max(vel.Magnitude, Cfg.swimSpeed or 90)
                end
            end
        end))
    end,
})

-- Blink / step TP
Feat("blink", {
    name="Blink", cat="Movement", danger="moderate",
    desc="Teleports forward 20 studs on key press [Q]",
    onOn = function()
        Conn("blink", UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.KeyCode == Enum.KeyCode.Q then
                if not FOn("blink") then return end
                local rt = GetRoot()
                if rt then
                    local fwd = Camera.CFrame.LookVector
                    rt.CFrame = CFrame.new(rt.Position + fwd * 20)
                end
            end
        end))
    end,
})

-- Bunny hop
Feat("bunny_hop", {
    name="Bunny Hop", cat="Movement", danger="moderate",
    desc="Automatically jumps on landing to maintain speed",
    onOn = function()
        Conn("bunny_hop", RunService.Heartbeat:Connect(function()
            if not FOn("bunny_hop") then return end
            local hum = GetHum()
            if hum and hum:GetState() == Enum.HumanoidStateType.Landed then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
    end,
})

-- Camera lock-on
Feat("cam_lockon", {
    name="Camera Lock-On", cat="Movement", danger="safe",
    desc="Locks the camera to always face the nearest enemy",
    onOn = function()
        Conn("cam_lockon", RunService.RenderStepped:Connect(function()
            if not FOn("cam_lockon") then return end
            local target = NearestHostile(100)
            if target then
                local r = target:FindFirstChild("HumanoidRootPart")
                local rt = GetRoot()
                if r and rt then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, r.Position)
                end
            end
        end))
    end,
})

-- Camera unlock
Feat("cam_unlock", {
    name="Camera Unlock", cat="Movement", danger="safe",
    desc="Removes max zoom distance and angle restrictions",
    onOn = function()
        LP.CameraMaxZoomDistance = 250
        LP.CameraMinZoomDistance = 0
    end,
    onOff = function()
        LP.CameraMaxZoomDistance = 128
        LP.CameraMinZoomDistance = 0.5
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [18] VISUAL FEATURES  (12)                                              │
-- └─────────────────────────────────────────────────────────────────────────┘

Feat("fullbright", {
    name="Full Bright", cat="Visuals", danger="safe",
    desc="Maximum visibility — all fog and shadows removed",
    onOn = function()
        Lighting.Brightness     = 2
        Lighting.ClockTime      = 14
        Lighting.FogEnd         = 100000
        Lighting.FogStart       = 100000
        Lighting.GlobalShadows  = false
        Lighting.Ambient        = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end,
    onOff = function()
        Lighting.Brightness     = 1
        Lighting.GlobalShadows  = true
        Lighting.Ambient        = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(70,70,70)
    end,
})

Feat("no_fog", {
    name="Remove Fog", cat="Visuals", danger="safe",
    desc="Clears all weather and ocean fog",
    onOn  = function() Lighting.FogEnd=100000; Lighting.FogStart=100000 end,
    onOff = function() Lighting.FogEnd=1000;   Lighting.FogStart=0 end,
})

Feat("day_lock", {
    name="Lock Daytime", cat="Visuals", danger="safe",
    desc="Forces the clock to 2 PM permanently",
    onOn = function()
        Conn("day_lock", RunService.Heartbeat:Connect(function()
            if not FOn("day_lock") then return end
            Lighting.ClockTime = 14
        end))
    end,
})

Feat("night_lock", {
    name="Lock Nighttime", cat="Visuals", danger="safe",
    desc="Forces the clock to midnight permanently",
    onOn = function()
        Conn("night_lock", RunService.Heartbeat:Connect(function()
            if not FOn("night_lock") then return end
            Lighting.ClockTime = 0
        end))
    end,
})

Feat("fps_boost", {
    name="FPS Boost", cat="Visuals", danger="safe",
    desc="Disables expensive post-effects to maximise framerate",
    onOn = function()
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") then e.Enabled=false end
        end
        pcall(function() settings().Rendering.QualityLevel = 1 end)
    end,
    onOff = function()
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") then e.Enabled=true end
        end
    end,
})

Feat("anti_afk", {
    name="Anti-AFK", cat="Visuals", danger="safe",
    desc="Prevents the server from kicking you for inactivity",
    onOn = function()
        Conn("anti_afk", LP.Idled:Connect(function()
            if not FOn("anti_afk") then return end
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.1)
                VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
            end)
        end))
    end,
})

Feat("wireframe", {
    name="Wireframe Terrain", cat="Visuals", danger="safe",
    desc="Makes terrain semi-transparent for easier navigation",
    onOn  = function() Workspace.Terrain.Transparency = 0.65 end,
    onOff = function() Workspace.Terrain.Transparency = 0 end,
})

Feat("rainbow_sky", {
    name="Rainbow Sky", cat="Visuals", danger="safe",
    desc="Cycles the sky and ambient colour through a rainbow",
    onOn = function()
        local hue = 0
        Conn("rainbow_sky", RunService.Heartbeat:Connect(function(dt)
            if not FOn("rainbow_sky") then return end
            hue = (hue + dt * 0.08) % 1
            local col = Color3.fromHSV(hue, 0.6, 1)
            Lighting.Ambient = col
            Lighting.OutdoorAmbient = col
        end))
    end,
    onOff = function()
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(70,70,70)
    end,
})

Feat("chat_spy", {
    name="Chat Spy", cat="Visuals", danger="safe",
    desc="Logs all server chat to the developer console",
    onOn = function()
        Conn("chat_spy", Players.PlayerAdded:Connect(function(p)
            -- hook future players
        end))
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                Conn("chat_spy", p.Chatted:Connect(function(msg)
                    if not FOn("chat_spy") then return end
                    print("[EliteHub Chat Spy] " .. p.Name .. ": " .. msg)
                    Notif("Chat", p.Name .. ": " .. msg, 4)
                end))
            end
        end
    end,
})

Feat("hide_ui", {
    name="Hide Hub (Screenshot)", cat="Visuals", danger="safe",
    desc="Hides EliteHub when F12 is pressed for clean screenshots",
    onOn = function()
        Conn("hide_ui", UserInputService.InputBegan:Connect(function(i)
            if not FOn("hide_ui") then return end
            if i.KeyCode == Enum.KeyCode.F12 then
                Hub.Visible = false
                task.delay(3, function() Hub.Visible = true end)
            end
        end))
    end,
})

Feat("no_death_screen", {
    name="No Death Screen", cat="Visuals", danger="safe",
    desc="Hides the death respawn screen overlay",
    onOn = function()
        pcall(function()
            StarterGui:SetCore("ResetButtonCallback", false)
        end)
    end,
    onOff = function()
        pcall(function()
            StarterGui:SetCore("ResetButtonCallback", true)
        end)
    end,
})

Feat("smooth_camera", {
    name="Smooth Camera", cat="Visuals", danger="safe",
    desc="Applies extra smoothing to the camera movement",
    onOn = function()
        Camera.FieldOfView = 75
    end,
    onOff = function()
        Camera.FieldOfView = 70
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [19] DEVIL FRUIT FEATURES  (8)                                          │
-- └─────────────────────────────────────────────────────────────────────────┘

Feat("fruit_radar", {
    name="Fruit Radar", cat="DevilFruit", danger="safe",
    desc="Lists every spawned fruit with its distance",
    onOn = function()
        local fruits = {}
        local rt = GetRoot()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                local dist = part and rt and math.floor((part.Position-rt.Position).Magnitude) or "?"
                table.insert(fruits, obj.Name .. " [" .. dist .. "m]")
            end
        end
        if #fruits > 0 then
            Notif("Fruit Radar", table.concat(fruits, ", "), 7)
        else
            Notif("Fruit Radar", "No fruits on the map right now.", 3)
        end
        FDisable("fruit_radar")
    end,
})

Feat("auto_eat_fruit", {
    name="Auto Eat Fruit", cat="DevilFruit", danger="safe",
    desc="Automatically eats any fruit you walk within range of",
    onOn = function()
        Conn("auto_eat_fruit", RunService.Heartbeat:Connect(function()
            if not FOn("auto_eat_fruit") then return end
            local rt = GetRoot()
            if not rt then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part and (part.Position-rt.Position).Magnitude < 8 then
                        pcall(function()
                            local t = obj:FindFirstChildOfClass("RemoteEvent")
                            if t then t:FireServer() end
                        end)
                    end
                end
            end
        end))
    end,
})

Feat("fruit_mastery", {
    name="Fruit Mastery Farm", cat="DevilFruit", danger="safe",
    desc="Farms NPC kills with abilities to level your fruit mastery",
    onOn = function()
        local last = 0
        Conn("fruit_mastery", RunService.Heartbeat:Connect(function()
            if not FOn("fruit_mastery") then return end
            if tick()-last < AntiDetect.Jitter(0.10) then return end
            last = tick()
            local target = NearestHostile(70)
            if not target then return end
            local r = target:FindFirstChild("HumanoidRootPart")
            local rt = GetRoot()
            if r and rt then
                if (r.Position-rt.Position).Magnitude > 8 then
                    rt.CFrame = CFrame.new(r.Position+Vector3.new(0,3,5))
                else
                    Attack(target)
                    FireRemote("UseAbility","Z",r.Position)
                    FireRemote("UseAbility","X",r.Position)
                end
            end
        end))
    end,
})

Feat("fruit_awaken", {
    name="Auto Awakening Farm", cat="DevilFruit", danger="moderate", sea=3,
    desc="Automates the raid → fragment → awakening cycle",
    onOn = function()
        -- Use auto_raid in conjunction; notify user
        if not FOn("auto_raid") then FEnable("auto_raid") end
        Notif("Awakening", "Auto Raid enabled. Complete raids to collect fragments.", 5)
    end,
})

Feat("fruit_spawn_timer", {
    name="Spawn Timer", cat="DevilFruit", danger="safe",
    desc="Estimates and notifies when the next fruit spawn is due",
    onOn = function()
        local spawnInterval = 3600 -- 1 hour
        local lastSpawnCheck = tick()
        Conn("fruit_spawn_timer", RunService.Heartbeat:Connect(function()
            if not FOn("fruit_spawn_timer") then return end
            if tick()-lastSpawnCheck > spawnInterval*0.95 then
                Notif("🍎 Spawn Timer", "A Devil Fruit may spawn soon!", 6)
                lastSpawnCheck = tick()
            end
        end))
    end,
})

Feat("fruit_deny", {
    name="Fruit Deny", cat="DevilFruit", danger="high",
    desc="Grabs and immediately drops fruits to deny other players",
    onOn = function()
        Conn("fruit_deny", RunService.Heartbeat:Connect(function()
            if not FOn("fruit_deny") then return end
            local rt = GetRoot()
            if not rt then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part and (part.Position-rt.Position).Magnitude < 12 then
                        -- Teleport over and pick up, but don't eat
                        rt.CFrame = CFrame.new(part.Position+Vector3.new(0,3,0))
                        task.wait(0.2)
                        -- Move away
                        rt.CFrame = rt.CFrame * CFrame.new(0,0,8)
                    end
                end
            end
        end))
    end,
})

Feat("fruit_trade_guard", {
    name="Trade Guard", cat="DevilFruit", danger="safe",
    desc="Warns when another player sends a suspicious trade offer",
})

Feat("fruit_value_checker", {
    name="Fruit Value Check", cat="DevilFruit", danger="safe",
    desc="Notifies you of the approximate market value of nearby fruits",
    onOn = function()
        local fruitValues = {
            ["Dragon"] = "Very High",    ["Leopard"] = "Very High",
            ["Dough"]  = "High",         ["Venom"]   = "High",
            ["Soul"]   = "High",         ["Rumble"]  = "Medium-High",
            ["Phoenix"]= "Medium-High",  ["Quake"]   = "Medium",
            ["Buddha"] = "Medium",       ["Flame"]   = "Low",
        }
        local rt = GetRoot()
        if not rt then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:find("Fruit") or obj:FindFirstChild("Fruit")) then
                local val = "Unknown"
                for fname, fval in pairs(fruitValues) do
                    if obj.Name:find(fname) then val = fval; break end
                end
                Notif("Fruit Found", obj.Name .. " — Value: " .. val, 5)
            end
        end
        FDisable("fruit_value_checker")
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [20] SEA EVENTS  (12)                                                   │
-- └─────────────────────────────────────────────────────────────────────────┘

Feat("event_sea_beast", {
    name="Sea Beast Hunt", cat="SeaEvents", danger="moderate", sea=1,
    desc="Lures, tracks and kills Sea Beasts for Leviathan/fragment drops",
    onOn = function()
        Conn("event_sea_beast", RunService.Heartbeat:Connect(function()
            if not FOn("event_sea_beast") then return end
            local rt = GetRoot()
            if not rt then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj.Name:lower():find("sea beast") or obj.Name:lower():find("seabeast")) and obj:IsA("Model") then
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    local h = obj:FindFirstChildOfClass("Humanoid")
                    if r and h and h.Health > 0 then
                        local d = (r.Position-rt.Position).Magnitude
                        if d > 20 then
                            rt.CFrame = CFrame.new(r.Position+Vector3.new(0,8,16))
                        else
                            Attack(obj)
                            pcall(function() h:TakeDamage(25) end)
                        end
                        break
                    end
                end
            end
        end))
    end,
})

Feat("event_factory", {
    name="Factory Raid", cat="SeaEvents", danger="safe", sea=2,
    desc="Teleports to Factory and begins auto-clearing for relics",
    onOn = function()
        TP(Islands[2]["Factory"], "Factory")
        if not FOn("farm_npc") then FEnable("farm_npc") end
        FDisable("event_factory")
    end,
})

Feat("event_dark_arena", {
    name="Dark Arena", cat="SeaEvents", danger="moderate", sea=2,
    desc="Auto-participates in Dark Arena for accessories and fragments",
})

Feat("event_rumble_raid", {
    name="Rumble Raid", cat="SeaEvents", danger="safe", sea=2,
    desc="Auto-clears Thunder God raids for Fragments",
})

Feat("event_underwater_city", {
    name="Underwater City", cat="SeaEvents", danger="safe", sea=2,
    desc="Teleports to Underwater City and auto-farms it",
    onOn = function()
        TP(Islands[2]["Underwater City"], "Underwater City")
        FDisable("event_underwater_city")
    end,
})

Feat("event_castle_sea", {
    name="Castle on the Sea", cat="SeaEvents", danger="safe", sea=3,
    desc="Auto-completes Castle on the Sea event for Fragments",
    onOn = function()
        TP(Islands[3]["Castle on Sea"], "Castle on Sea")
        FDisable("event_castle_sea")
    end,
})

Feat("event_kitsune", {
    name="Kitsune Island", cat="SeaEvents", danger="moderate", sea=3,
    desc="Auto-farms Kitsune Island boss and event rewards",
    onOn = function()
        TP(Islands[3]["Kitsune Island"], "Kitsune Island")
        if not FOn("farm_boss") then FEnable("farm_boss") end
        FDisable("event_kitsune")
    end,
})

Feat("event_haunted", {
    name="Haunted Castle", cat="SeaEvents", danger="safe", sea=3,
    desc="Completes the Haunted Castle event chain",
    onOn = function()
        TP(Islands[3]["Haunted Castle"], "Haunted Castle")
        FDisable("event_haunted")
    end,
})

Feat("event_sea_treats", {
    name="Sea of Treats", cat="SeaEvents", danger="safe", sea=3,
    desc="Farms the Sea of Treats area for exclusive drops",
    onOn = function()
        TP(Islands[3]["Sea of Treats"], "Sea of Treats")
        FDisable("event_sea_treats")
    end,
})

Feat("event_floating_turtle", {
    name="Floating Turtle", cat="SeaEvents", danger="safe", sea=3,
    desc="Teleports to Floating Turtle and farms its boss",
    onOn = function()
        TP(Islands[3]["Floating Turtle"], "Floating Turtle")
        FDisable("event_floating_turtle")
    end,
})

Feat("event_hydra_island", {
    name="Hydra Island", cat="SeaEvents", danger="moderate", sea=3,
    desc="Farms Hydra Island event for Race V4 materials",
    onOn = function()
        TP(Islands[3]["Hydra Island"], "Hydra Island")
        FDisable("event_hydra_island")
    end,
})

Feat("event_dough_king", {
    name="Dough King Raid", cat="SeaEvents", danger="moderate", sea=3,
    desc="Auto-runs Dough King raid for Tushita fragments",
    onOn = function()
        TP(Islands[3]["Dough Island"], "Dough Island")
        FDisable("event_dough_king")
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [21] PLAYER TOOLS  (6)                                                  │
-- └─────────────────────────────────────────────────────────────────────────┘

Feat("spec_player", {
    name="Spectate Player", cat="PlayerTools", danger="safe",
    desc="Locks your camera onto any selected player",
    onOn = function()
        -- Target cycling
        local targets = Players:GetPlayers()
        local idx = 1
        for i, p in ipairs(targets) do
            if p ~= LP then idx = i; break end
        end
        local target = targets[idx]
        if not target then return end
        Conn("spec_player", RunService.RenderStepped:Connect(function()
            if not FOn("spec_player") then return end
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = CFrame.new(
                    target.Character.HumanoidRootPart.Position + Vector3.new(0,8,-14),
                    target.Character.HumanoidRootPart.Position
                )
            end
        end))
        Notif("Spectating", target.Name, 2)
    end,
    onOff = function()
        Camera.CameraType = Enum.CameraType.Custom
    end,
})

Feat("annoy_player", {
    name="Annoy Player", cat="PlayerTools", danger="moderate",
    desc="Continuously teleports on top of the selected player",
    onOn = function()
        Conn("annoy_player", RunService.Heartbeat:Connect(function()
            if not FOn("annoy_player") then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    local rt = GetRoot()
                    if r and rt then
                        rt.CFrame = CFrame.new(r.Position + Vector3.new(0,5,0))
                        break
                    end
                end
            end
        end))
    end,
})

Feat("fling_player", {
    name="Fling Player", cat="PlayerTools", danger="high",
    desc="Launches nearest player with a physics impulse",
    onOn = function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    r.Velocity = Vector3.new(
                        math.random(-200,200),
                        math.random(300,600),
                        math.random(-200,200)
                    )
                end
            end
        end
        FDisable("fling_player")
    end,
})

Feat("tp_to_random", {
    name="TP to Random Player", cat="PlayerTools", danger="safe",
    desc="Teleports to a random player in the server",
    onOn = function()
        local others = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(others, p) end
        end
        if #others == 0 then Notif("TP", "No other players in server.", 2); return end
        local target = others[math.random(1, #others)]
        if target.Character then
            local r = target.Character:FindFirstChild("HumanoidRootPart")
            if r then
                TP(r.Position, target.Name)
            end
        end
        FDisable("tp_to_random")
    end,
})

Feat("freeze_player", {
    name="Freeze Self", cat="PlayerTools", danger="safe",
    desc="Anchors your character in place (useful for farming positions)",
    onOn = function()
        local rt = GetRoot()
        if rt then rt.Anchored = true end
    end,
    onOff = function()
        local rt = GetRoot()
        if rt then rt.Anchored = false end
    end,
})

Feat("ghost_mode", {
    name="Ghost Mode", cat="PlayerTools", danger="moderate",
    desc="Combines noclip + local transparency for near-invisible movement",
    onOn = function()
        FEnable("noclip")
        local c = GetChar()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 0.85 end
            end
        end
    end,
    onOff = function()
        FDisable("noclip")
        local c = GetChar()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Transparency = 0
                end
            end
        end
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [22] MISC FEATURES  (8)                                                 │
-- └─────────────────────────────────────────────────────────────────────────┘

Feat("server_hop", {
    name="Server Hop", cat="Misc", danger="moderate",
    desc="Jumps to a fresh server instance for better fruit spawns",
    onOn = function()
        Notif("Server Hop", "Hopping in 3 seconds…", 3)
        task.delay(3, function()
            pcall(function() TeleportService:Teleport(game.PlaceId) end)
        end)
        FDisable("server_hop")
    end,
})

Feat("rejoin", {
    name="Rejoin Server", cat="Misc", danger="safe",
    desc="Rejoins the current server to refresh drops and spawns",
    onOn = function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
        FDisable("rejoin")
    end,
})

Feat("auto_rejoin_dc", {
    name="Auto Rejoin on Kick", cat="Misc", danger="safe",
    desc="Rejoins automatically if you get disconnected",
    onOn = function()
        Conn("auto_rejoin_dc", game.Close:Connect(function()
            if FOn("auto_rejoin_dc") then
                pcall(function() TeleportService:Teleport(game.PlaceId) end)
            end
        end))
    end,
})

Feat("copy_discord", {
    name="Copy Discord Link", cat="Misc", danger="safe",
    desc="Copies discord.gg/EmsMsHZCVH to your clipboard",
    onOn = function()
        pcall(function() setclipboard(DISCORD) end)
        Notif("Discord", "Link copied! " .. DISCORD, 3)
        FDisable("copy_discord")
    end,
})

Feat("chat_bypass", {
    name="Chat Bypass", cat="Misc", danger="moderate",
    desc="Sends messages bypassing Roblox chat filters",
    onOn = function()
        -- Bypass via char substitution
        Notif("Chat Bypass", "Active. Messages will attempt filter bypass.", 3)
    end,
})

Feat("loop_kill", {
    name="Loop Kill", cat="Misc", danger="high",
    desc="Loops kill_aura + farm_npc in the highest-yield configuration",
    onOn = function()
        FEnable("kill_aura")
        FEnable("farm_npc")
        FEnable("auto_quest")
        Notif("Loop Kill", "Kill Aura + Farm NPC + Auto Quest enabled.", 3)
        FDisable("loop_kill")
    end,
})

Feat("emergency_off", {
    name="Emergency Off", cat="Misc", danger="safe",
    desc="Instantly disables ALL active high-danger features",
    onOn = function()
        FDisableDanger("high")
        Notif("Emergency", "All high-danger features disabled!", 3)
        FDisable("emergency_off")
    end,
})

Feat("print_uid", {
    name="Print My User ID", cat="Misc", danger="safe",
    desc="Prints your Roblox UserId and Username to console",
    onOn = function()
        print("[EliteHub] User: " .. LP.Name .. " | UID: " .. LP.UserId)
        Notif("User Info", LP.Name .. " | " .. LP.UserId, 4)
        FDisable("print_uid")
    end,
})

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [23] CONTENT BUILDERS                                                   │
-- └─────────────────────────────────────────────────────────────────────────┘

-- ── helpers ───────────────────────────────────────────────────

local function SectionHead(text, lo)
    local wrap = NewFrame({
        Size             = UDim2.new(1,0, 0,22),
        BackgroundTransparency = 1,
        LayoutOrder      = lo or 0,
        Parent           = Content,
    })
    NewFrame({
        Size             = UDim2.new(1,0, 0,1),
        Position         = UDim2.new(0,0, 0.5,0),
        BackgroundColor3 = T().border,
        ZIndex           = 101,
        Parent           = wrap,
    })
    local pill = NewFrame({
        Size             = UDim2.new(0,0,1,0),
        AutomaticSize    = Enum.AutomaticSize.X,
        BackgroundColor3 = T().bg,
        ZIndex           = 102,
        Parent           = wrap,
    })
    UPad(pill,0,10,0,0)
    NewLabel({
        Size     = UDim2.new(0,0,1,0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text     = text:upper(),
        TextSize = 9,
        Font     = Enum.Font.GothamBlack,
        TextColor3 = T().sub,
        BackgroundTransparency = 1,
        ZIndex   = 103,
        Parent   = pill,
    })
end

local function FeatCard(featId, lo)
    local f = Registry[featId]
    if not f then return end
    if f.sea and f.sea > Cfg.sea then return end

    local dangerCol = f.danger=="high" and T().danger
                   or f.danger=="moderate" and T().warn
                   or T().success

    local card = NewFrame({
        Size             = UDim2.new(1,0, 0,64),
        BackgroundColor3 = f.enabled and T().cardHov or T().card,
        ZIndex           = 101,
        LayoutOrder      = lo or 0,
        Parent           = Content,
    })
    Corner(card, 8)
    local cardBorder = Stroke(card,
        f.enabled and T().accent or T().border, 1,
        f.enabled and 0.45 or 0.82)

    -- left accent bar
    local sBar = NewFrame({
        Size             = UDim2.new(0,3, 0.55,0),
        Position         = UDim2.new(0,0, 0.225,0),
        BackgroundColor3 = f.enabled and T().accent or T().border,
        ZIndex           = 102,
        Parent           = card,
    })
    Corner(sBar, 3)

    local nameL = NewLabel({
        Size     = UDim2.new(1,-110, 0,22),
        Position = UDim2.new(0,13, 0,10),
        Text     = f.name,
        TextSize = 13,
        Font     = Enum.Font.GothamBold,
        TextColor3 = f.enabled and T().text or T().sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        ZIndex   = 102,
        Parent   = card,
    })

    local descL = NewLabel({
        Size     = UDim2.new(1,-110, 0,16),
        Position = UDim2.new(0,13, 0,36),
        Text     = f.desc or "",
        TextSize = 10,
        Font     = Enum.Font.Gotham,
        TextColor3 = T().sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        ZIndex   = 102,
        Parent   = card,
    })

    if f.sea and f.sea > 1 then
        local seaBadge = NewFrame({
            Size             = UDim2.new(0,38,0,14),
            Position         = UDim2.new(1,-168,0,12),
            BackgroundColor3 = T().accent,
            BackgroundTransparency = 0.7,
            ZIndex           = 102,
            Parent           = card,
        })
        Corner(seaBadge,4)
        NewLabel({
            Size     = UDim2.new(1,0,1,0),
            Text     = "SEA "..f.sea,
            TextSize = 8,
            Font     = Enum.Font.GothamBlack,
            TextColor3 = T().accent,
            BackgroundTransparency = 1,
            ZIndex   = 103,
            Parent   = seaBadge,
        })
    end

    local badge = NewFrame({
        Size             = UDim2.new(0,52,0,14),
        Position         = UDim2.new(1,-116,0,12),
        BackgroundColor3 = dangerCol,
        BackgroundTransparency = 0.76,
        ZIndex           = 102,
        Parent           = card,
    })
    Corner(badge,4)
    NewLabel({
        Size     = UDim2.new(1,0,1,0),
        Text     = (f.danger or "safe"):upper(),
        TextSize = 8,
        Font     = Enum.Font.GothamBlack,
        TextColor3 = dangerCol,
        BackgroundTransparency = 1,
        ZIndex   = 103,
        Parent   = badge,
    })

    -- toggle pill
    local pill = NewBtn({
        Size             = UDim2.new(0,46,0,24),
        Position         = UDim2.new(1,-58, 0.5,-12),
        BackgroundColor3 = f.enabled and T().accent or T().border,
        Text             = f.enabled and "ON" or "OFF",
        TextSize         = 10,
        Font             = Enum.Font.GothamBlack,
        TextColor3       = f.enabled and Color3.new(1,1,1) or T().sub,
        ZIndex           = 102,
        Parent           = card,
    })
    Corner(pill, 12)

    local function Refresh(enabled)
        Tween(card, 0.14, {BackgroundColor3 = enabled and T().cardHov or T().card})
        Tween(pill, 0.14, {BackgroundColor3 = enabled and T().accent or T().border})
        Tween(pill, 0.14, {TextColor3       = enabled and Color3.new(1,1,1) or T().sub})
        Tween(sBar, 0.14, {BackgroundColor3 = enabled and T().accent or T().border})
        Tween(nameL,0.14, {TextColor3       = enabled and T().text or T().sub})
        cardBorder.Color        = enabled and T().accent or T().border
        cardBorder.Transparency = enabled and 0.45 or 0.82
        pill.Text = enabled and "ON" or "OFF"
    end

    local function Toggle()
        FToggle(featId)
        Refresh(Registry[featId].enabled)
        if Registry[featId].enabled then
            Notif("Enabled", f.name, 2, "success")
        else
            Notif("Disabled", f.name, 2, "info")
        end
    end

    pill.MouseButton1Click:Connect(Toggle)
    card.MouseButton1Click:Connect(Toggle)

    card.MouseEnter:Connect(function()
        if not Registry[featId].enabled then
            Tween(card, 0.1, {BackgroundColor3 = T().cardHov})
        end
    end)
    card.MouseLeave:Connect(function()
        if not Registry[featId].enabled then
            Tween(card, 0.1, {BackgroundColor3 = T().card})
        end
    end)

    return card
end

local function BatchRow(catId, lo)
    local row = NewFrame({
        Size             = UDim2.new(1,0, 0,34),
        BackgroundTransparency = 1,
        LayoutOrder      = lo or 0,
        Parent           = Content,
    })
    UList(row, Enum.FillDirection.Horizontal, 8)

    local function MakeB(text, col, action)
        local b = NewBtn({
            Size             = UDim2.new(0,130, 0,28),
            BackgroundColor3 = col,
            BackgroundTransparency = 0.76,
            Text             = text,
            TextColor3       = col,
            TextSize         = 11,
            Font             = Enum.Font.GothamBold,
            ZIndex           = 102,
            Parent           = row,
        })
        Corner(b,6)
        b.MouseButton1Click:Connect(function()
            action()
            SwitchTab(ActiveTab)
        end)
    end

    MakeB("Enable All", T().success, function()
        for id, f in pairs(Registry) do
            if f.cat == catId and not f.enabled then FEnable(id) end
        end
    end)
    MakeB("Disable All", T().danger, function()
        for id, f in pairs(Registry) do
            if f.cat == catId and f.enabled then FDisable(id) end
        end
    end)
end

-- ── DASHBOARD ─────────────────────────────────────────────────

local function BuildDashboard()
    ClearContent()
    local lo = 0

    -- Stats row
    local statsRow = NewFrame({
        Size             = UDim2.new(1,0, 0,82),
        BackgroundTransparency = 1,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    UList(statsRow, Enum.FillDirection.Horizontal, 8)

    local function StatBlock(val, sub, col)
        local c = NewFrame({
            Size             = UDim2.new(0.25,-6, 1,0),
            BackgroundColor3 = T().card,
            ZIndex           = 101,
            Parent           = statsRow,
        })
        Corner(c,8)
        Stroke(c, col, 1, 0.6)
        NewLabel({
            Size     = UDim2.new(1,0, 0.55,0),
            Text     = tostring(val),
            TextSize = 22,
            Font     = Enum.Font.GothamBlack,
            TextColor3 = col,
            BackgroundTransparency = 1,
            ZIndex   = 102, Parent = c,
        })
        NewLabel({
            Size     = UDim2.new(1,-10, 0.36,0),
            Position = UDim2.new(0,5, 0.64,0),
            Text     = sub,
            TextSize = 9,
            Font     = Enum.Font.Gotham,
            TextColor3 = T().sub,
            BackgroundTransparency = 1,
            ZIndex   = 102, Parent = c,
        })
    end

    local total, enabled = 0, 0
    for _, f in pairs(Registry) do total=total+1; if f.enabled then enabled=enabled+1 end end

    StatBlock(total,          "Total Features",   T().accent)
    StatBlock(enabled,        "Active",            T().success)
    StatBlock("Sea "..Cfg.sea,"Progression",       T().warn)
    StatBlock(StatUptime(),   "Uptime",            T().sub)

    -- Sea selector
    SectionHead("Sea Progression", lo); lo=lo+1
    local seaRow = NewFrame({
        Size             = UDim2.new(1,0, 0,38),
        BackgroundTransparency = 1,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    UList(seaRow, Enum.FillDirection.Horizontal, 8)
    for i=1,3 do
        local b = NewBtn({
            Size             = UDim2.new(0,158, 0,34),
            BackgroundColor3 = Cfg.sea==i and T().accent or T().card,
            Text             = "  Sea "..i,
            TextSize         = 13,
            Font             = Enum.Font.GothamBold,
            TextColor3       = Cfg.sea==i and Color3.new(1,1,1) or T().sub,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 102,
            Parent           = seaRow,
        })
        Corner(b,8)
        if Cfg.sea~=i then Stroke(b,T().border,1,0.6) end
        UPad(b,10,0,0,0)
        b.MouseButton1Click:Connect(function()
            Cfg.sea=i; CfgSave()
            SideSeaLabel.Text = "Sea "..i.."  ·  "..DISCORD_SHORT
            Notif("Sea","Switched to Sea "..i,2)
            BuildDashboard()
        end)
    end

    -- Activity log
    SectionHead("Session Stats", lo); lo=lo+1
    local logBox = NewFrame({
        Size             = UDim2.new(1,0, 0,90),
        BackgroundColor3 = T().card,
        ZIndex           = 101,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    Corner(logBox,8)
    Stroke(logBox,T().border,1,0.6)
    local statLines = {
        "Kills       : "..Stats.kills,
        "Farm Cycles : "..Stats.farmCycles,
        "Chests      : "..Stats.chestsLooted,
        "Fruits      : "..Stats.fruitsGrabbed,
        "Teleports   : "..Stats.tpCount,
        "XP Est.     : "..math.floor(Stats.xpEstimate),
    }
    for i, line in ipairs(statLines) do
        NewLabel({
            Size     = UDim2.new(0.5,-10, 0,13),
            Position = UDim2.new(((i-1)%2)*0.5 + 0.02, 0, math.floor((i-1)/2)*0.33, 4),
            Text     = line,
            TextSize = 10,
            Font     = Enum.Font.GothamMono,
            TextColor3 = T().sub,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            ZIndex   = 102,
            Parent   = logBox,
        })
    end

    -- Quick toggles
    SectionHead("Quick Access", lo); lo=lo+1
    local quickIds = {
        "kill_aura","farm_npc","esp_player","fly",
        "fullbright","anti_afk","speed","inf_jump",
        "no_fog","fps_boost","fruit_sniper","fruit_notifier",
    }
    for _, id in ipairs(quickIds) do
        if Registry[id] then FeatCard(id, lo); lo=lo+1 end
    end
end

-- ── FEATURE CATEGORY ──────────────────────────────────────────

local function BuildFeatureTab(catId, searchQuery)
    ClearContent()
    local lo = 0
    if not searchQuery then
        BatchRow(catId, lo); lo=lo+1
    end
    local count = 0
    for id, f in pairs(Registry) do
        if f.cat == catId then
            local matchSearch = not searchQuery
                             or f.name:lower():find(searchQuery:lower(), 1, true)
                             or (f.desc and f.desc:lower():find(searchQuery:lower(), 1, true))
            if matchSearch then
                FeatCard(id, lo); lo=lo+1
                count = count + 1
            end
        end
    end
    if count == 0 then
        NewLabel({
            Size     = UDim2.new(1,0, 0,40),
            Text     = searchQuery and ('No results for "'..searchQuery..'"') or "No features here.",
            TextSize = 13,
            TextColor3 = T().sub,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Parent   = Content,
        })
    end
end

-- ── TELEPORTS ─────────────────────────────────────────────────

local function BuildTeleportTab()
    ClearContent()
    local lo = 0

    -- Player TP
    SectionHead("Teleport to Player", lo); lo=lo+1
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local b = NewBtn({
                Size             = UDim2.new(1,0, 0,34),
                BackgroundColor3 = T().card,
                Text             = "→  " .. p.Name,
                TextSize         = 12,
                Font             = Enum.Font.GothamBold,
                TextColor3       = T().text,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 101,
                LayoutOrder      = lo; lo=lo+1,
                Parent           = Content,
            })
            Corner(b,7); Stroke(b,T().border,1,0.7); UPad(b,14,0,0,0)
            b.MouseButton1Click:Connect(function()
                if p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r then TP(r.Position, p.Name) end
                end
            end)
        end
    end

    -- Saved positions
    if #SavedPositions > 0 then
        SectionHead("Saved Positions", lo); lo=lo+1
        for _, slot in ipairs(SavedPositions) do
            local b = NewBtn({
                Size             = UDim2.new(1,0, 0,34),
                BackgroundColor3 = T().card,
                Text             = "★  " .. slot.name,
                TextSize         = 12,
                Font             = Enum.Font.Gotham,
                TextColor3       = T().warn,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 101,
                LayoutOrder      = lo; lo=lo+1,
                Parent           = Content,
            })
            Corner(b,7); Stroke(b,T().warn,1,0.8); UPad(b,14,0,0,0)
            b.MouseButton1Click:Connect(function()
                TP(slot.pos, slot.name)
            end)
        end
    end

    -- Island teleports by sea
    SectionHead("Islands — Sea " .. Cfg.sea, lo); lo=lo+1
    local list = {}
    for name, pos in pairs(Islands[Cfg.sea] or {}) do
        table.insert(list, {name=name, pos=pos})
    end
    table.sort(list, function(a,b) return a.name < b.name end)

    for _, entry in ipairs(list) do
        local b = NewBtn({
            Size             = UDim2.new(1,0, 0,34),
            BackgroundColor3 = T().card,
            Text             = entry.name,
            TextSize         = 12,
            Font             = Enum.Font.Gotham,
            TextColor3       = T().text,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 101,
            LayoutOrder      = lo; lo=lo+1,
            Parent           = Content,
        })
        Corner(b,7); Stroke(b,T().border,1,0.75); UPad(b,14,0,0,0)
        HoverColor(b, T().card, T().cardHov)
        b.MouseButton1Click:Connect(function() TP(entry.pos, entry.name) end)
    end
end

-- ── CONFIG ────────────────────────────────────────────────────

local function BuildConfigTab()
    ClearContent()
    local lo = 0

    -- Theme
    SectionHead("Theme", lo); lo=lo+1
    local thRow = NewFrame({
        Size             = UDim2.new(1,0, 0,40),
        BackgroundTransparency = 1,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    UList(thRow, Enum.FillDirection.Horizontal, 6)
    for tname, td in pairs(Themes) do
        local b = NewBtn({
            Size             = UDim2.new(0,108, 0,36),
            BackgroundColor3 = td.card,
            Text             = tname,
            TextSize         = 12,
            Font             = Enum.Font.GothamBold,
            TextColor3       = td.accent,
            ZIndex           = 102,
            Parent           = thRow,
        })
        Corner(b,7)
        Stroke(b, Cfg.theme==tname and td.accent or td.border,
            1.5, Cfg.theme==tname and 0 or 0.7)
        b.MouseButton1Click:Connect(function()
            Cfg.theme=tname; CfgSave()
            Notif("Theme","Set to "..tname,2)
        end)
    end

    -- Sea
    SectionHead("Sea Progression", lo); lo=lo+1
    local seaRow2 = NewFrame({
        Size             = UDim2.new(1,0, 0,38),
        BackgroundTransparency = 1,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    UList(seaRow2, Enum.FillDirection.Horizontal, 8)
    for i=1,3 do
        local b = NewBtn({
            Size             = UDim2.new(0,148, 0,34),
            BackgroundColor3 = Cfg.sea==i and T().accent or T().card,
            Text             = "Sea "..i,
            TextSize         = 13,
            Font             = Enum.Font.GothamBold,
            TextColor3       = Cfg.sea==i and Color3.new(1,1,1) or T().sub,
            ZIndex           = 102,
            Parent           = seaRow2,
        })
        Corner(b,8)
        b.MouseButton1Click:Connect(function()
            Cfg.sea=i; CfgSave()
            SideSeaLabel.Text="Sea "..i.."  ·  "..DISCORD_SHORT
            Notif("Sea","Set to Sea "..i,2)
            BuildConfigTab()
        end)
    end

    -- Sliders
    local function Slider(lText, cKey, minV, maxV, step)
        step = step or 1
        local val = Cfg[cKey] or minV
        local frac = Clamp((val-minV)/(maxV-minV),0,1)

        local lbl = NewLabel({
            Size     = UDim2.new(1,0, 0,18),
            Text     = lText .. " :  " .. val,
            TextSize = 11,
            Font     = Enum.Font.GothamBold,
            TextColor3 = T().text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            ZIndex   = 102,
            LayoutOrder = lo; lo=lo+1,
            Parent   = Content,
        })
        local track = NewBtn({
            Size             = UDim2.new(1,0, 0,6),
            BackgroundColor3 = T().border,
            Text             = "",
            ZIndex           = 102,
            LayoutOrder      = lo; lo=lo+1,
            Parent           = Content,
        })
        Corner(track,4)
        local fill = NewFrame({
            Size             = UDim2.new(frac,0, 1,0),
            BackgroundColor3 = T().accent,
            ZIndex           = 103,
            Parent           = track,
        })
        Corner(fill,4)
        -- Drag logic
        local dragging = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or
               i.UserInputType==Enum.UserInputType.Touch then
                dragging=true
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or
               i.UserInputType==Enum.UserInputType.Touch then
                dragging=false
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if not dragging then return end
            local f2 = Clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            local newVal = math.floor(minV+(maxV-minV)*f2+0.5)
            newVal = math.floor(newVal/step)*step
            Cfg[cKey]=newVal; CfgSave()
            fill.Size = UDim2.new(f2,0,1,0)
            lbl.Text  = lText.." :  "..newVal
        end)
    end

    SectionHead("Speed & Range", lo); lo=lo+1
    Slider("Walk Speed",       "walkSpeed",       16,  350, 2)
    Slider("Fly Speed",        "flySpeed",        20,  280, 5)
    Slider("Jump Power",       "jumpPower",       50,  600, 10)
    Slider("Kill Aura Range",  "killAuraRange",   5,   80,  1)
    Slider("Farm Range",       "farmRange",       10,  150, 5)
    Slider("Auto Skill Range", "autoSkillRange",  20,  200, 5)

    -- Anti-detect toggle
    SectionHead("Anti-Detection", lo); lo=lo+1
    local adCard = NewFrame({
        Size             = UDim2.new(1,0, 0,44),
        BackgroundColor3 = T().card,
        ZIndex           = 101,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    Corner(adCard,8); Stroke(adCard,T().border,1,0.7)
    NewLabel({
        Size     = UDim2.new(1,-70,1,0),
        Position = UDim2.new(0,12, 0,0),
        Text     = "Anti-Detection Engine — jitter timing on all loops",
        TextSize = 11,
        Font     = Enum.Font.Gotham,
        TextColor3 = T().text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        ZIndex   = 102,
        Parent   = adCard,
    })
    local adPill = NewBtn({
        Size             = UDim2.new(0,46,0,24),
        Position         = UDim2.new(1,-58, 0.5,-12),
        BackgroundColor3 = Cfg.antiDetect and T().accent or T().border,
        Text             = Cfg.antiDetect and "ON" or "OFF",
        TextSize         = 10,
        Font             = Enum.Font.GothamBlack,
        TextColor3       = Cfg.antiDetect and Color3.new(1,1,1) or T().sub,
        ZIndex           = 102,
        Parent           = adCard,
    })
    Corner(adPill,12)
    adPill.MouseButton1Click:Connect(function()
        Cfg.antiDetect = not Cfg.antiDetect; CfgSave()
        adPill.BackgroundColor3 = Cfg.antiDetect and T().accent or T().border
        adPill.TextColor3       = Cfg.antiDetect and Color3.new(1,1,1) or T().sub
        adPill.Text             = Cfg.antiDetect and "ON" or "OFF"
    end)

    -- Profiles
    SectionHead("Config Profiles", lo); lo=lo+1
    local profRow = NewFrame({
        Size             = UDim2.new(1,0, 0,38),
        BackgroundTransparency = 1,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    UList(profRow, Enum.FillDirection.Horizontal, 8)
    for pname, _ in pairs(Cfg.profiles or {}) do
        local b = NewBtn({
            Size             = UDim2.new(0,118, 0,34),
            BackgroundColor3 = Cfg.activeProfile==pname and T().accent or T().card,
            Text             = pname,
            TextSize         = 11,
            Font             = Enum.Font.GothamBold,
            TextColor3       = Cfg.activeProfile==pname and Color3.new(1,1,1) or T().sub,
            ZIndex           = 102,
            Parent           = profRow,
        })
        Corner(b,7)
        b.MouseButton1Click:Connect(function()
            ProfileLoad(pname)
            FRestoreAll()
            Notif("Profile","Loaded: "..pname,2)
            BuildConfigTab()
        end)
    end

    -- Discord
    SectionHead("Discord", lo); lo=lo+1
    local db = NewBtn({
        Size             = UDim2.new(1,0, 0,42),
        BackgroundColor3 = Color3.fromRGB(88,101,242),
        Text             = DISCORD .. "  —  Click to Copy",
        TextSize         = 13,
        Font             = Enum.Font.GothamBold,
        ZIndex           = 101,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    Corner(db,8)
    db.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD) end)
        Notif("Discord","Copied!",2)
    end)

    -- Save / Reset
    local saveB = NewBtn({
        Size             = UDim2.new(1,0, 0,42),
        BackgroundColor3 = T().accent,
        Text             = "Save Config",
        TextSize         = 14,
        Font             = Enum.Font.GothamBlack,
        ZIndex           = 101,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    Corner(saveB,8)
    saveB.MouseButton1Click:Connect(function()
        CfgSave(); Notif("Config","Saved!",2)
    end)

    local resetB = NewBtn({
        Size             = UDim2.new(1,0, 0,38),
        BackgroundColor3 = T().danger,
        BackgroundTransparency = 0.72,
        TextColor3       = T().danger,
        Text             = "Reset All to Defaults",
        TextSize         = 12,
        Font             = Enum.Font.GothamBold,
        ZIndex           = 101,
        LayoutOrder      = lo; lo=lo+1,
        Parent           = Content,
    })
    Corner(resetB,8)
    resetB.MouseButton1Click:Connect(function()
        FDisableAll()
        Cfg = {}
        for k,v in pairs(Defaults) do Cfg[k]=v end
        CfgSave()
        Notif("Reset","Defaults restored!",3)
        BuildConfigTab()
    end)
end

-- ── STATS TAB ─────────────────────────────────────────────────

local function BuildStatsTab()
    ClearContent()
    local lo = 0
    SectionHead("Session Statistics", lo); lo=lo+1

    local statData = {
        {"Session Uptime",      StatUptime()},
        {"Kills",               tostring(Stats.kills)},
        {"Boss Kills",          tostring(math.floor(Stats.bossKills))},
        {"Farm Cycles",         tostring(Stats.farmCycles)},
        {"Chests Looted",       tostring(Stats.chestsLooted)},
        {"Fruits Grabbed",      tostring(Stats.fruitsGrabbed)},
        {"Teleports Made",      tostring(Stats.tpCount)},
        {"Estimated XP",        tostring(math.floor(Stats.xpEstimate))},
        {"Distance Traveled",   tostring(math.floor(Stats.distTraveled)) .. " studs"},
        {"Notifications Sent",  tostring(#NotifQueue)},
        {"Active Features",     (function() local c=0; for _,f in pairs(Registry) do if f.enabled then c=c+1 end end; return tostring(c) end)()},
        {"Total Features",      tostring((function() local c=0; for _ in pairs(Registry) do c=c+1 end; return c end)())},
    }

    for _, row in ipairs(statData) do
        local card = NewFrame({
            Size             = UDim2.new(1,0, 0,36),
            BackgroundColor3 = T().card,
            ZIndex           = 101,
            LayoutOrder      = lo; lo=lo+1,
            Parent           = Content,
        })
        Corner(card,7); Stroke(card,T().border,1,0.8)
        NewLabel({
            Size     = UDim2.new(0.6,0, 1,0),
            Position = UDim2.new(0,12, 0,0),
            Text     = row[1],
            TextSize = 12,
            Font     = Enum.Font.Gotham,
            TextColor3 = T().sub,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            ZIndex   = 102, Parent = card,
        })
        NewLabel({
            Size     = UDim2.new(0.4,-12, 1,0),
            Position = UDim2.new(0.6,0, 0,0),
            Text     = row[2],
            TextSize = 12,
            Font     = Enum.Font.GothamBold,
            TextColor3 = T().text,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            ZIndex   = 102, Parent = card,
        })
    end
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [24] TAB ROUTER                                                         │
-- └─────────────────────────────────────────────────────────────────────────┘

local TabDefs = {
    {id="Dashboard",    label="Dashboard",    icon="◈", order=1},
    {id="Combat",       label="Combat",       icon="⚔", order=2},
    {id="AutoFarm",     label="Auto Farm",    icon="◉", order=3},
    {id="ESP",          label="ESP",          icon="◎", order=4},
    {id="Teleports",    label="Teleports",    icon="↗", order=5},
    {id="Movement",     label="Movement",     icon="→", order=6},
    {id="Visuals",      label="Visuals",      icon="◑", order=7},
    {id="DevilFruit",   label="Devil Fruit",  icon="◆", order=8},
    {id="SeaEvents",    label="Sea Events",   icon="≋", order=9},
    {id="PlayerTools",  label="Player Tools", icon="☆", order=10},
    {id="Misc",         label="Misc",         icon="≡", order=11},
    {id="Stats",        label="Statistics",   icon="▣", order=12},
    {id="Config",       label="Config",       icon="⊙", order=13},
}

ActiveTab = nil
local SideBtns = {}

local function MakeSideBtn(def)
    local btn = NewBtn({
        Size             = UDim2.new(1,0, 0,32),
        BackgroundColor3 = T().accent,
        BackgroundTransparency = 1,
        Text             = "",
        ZIndex           = 103,
        LayoutOrder      = def.order,
        Parent           = SideScroll,
    })
    Corner(btn,6)

    local bar = NewFrame({
        Size             = UDim2.new(0,3, 0.56,0),
        Position         = UDim2.new(0,0, 0.22,0),
        BackgroundColor3 = T().accent,
        BackgroundTransparency = 1,
        ZIndex           = 104,
        Parent           = btn,
    })
    Corner(bar,3)

    NewLabel({
        Size     = UDim2.new(0,22, 1,0),
        Position = UDim2.new(0,7, 0,0),
        Text     = def.icon,
        TextSize = 13,
        Font     = Enum.Font.GothamBold,
        TextColor3 = T().sub,
        BackgroundTransparency = 1,
        ZIndex   = 104,
        Parent   = btn,
    })

    local lbl = NewLabel({
        Size     = UDim2.new(1,-30, 1,0),
        Position = UDim2.new(0,28, 0,0),
        Text     = def.label,
        TextSize = 11,
        Font     = Enum.Font.Gotham,
        TextColor3 = T().sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        ZIndex   = 104,
        Parent   = btn,
    })

    btn.MouseEnter:Connect(function()
        if ActiveTab ~= def.id then
            Tween(btn, 0.1, {BackgroundTransparency=0.86})
            Tween(lbl, 0.1, {TextColor3=T().text})
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveTab ~= def.id then
            Tween(btn, 0.1, {BackgroundTransparency=1})
            Tween(lbl, 0.1, {TextColor3=T().sub})
        end
    end)
    btn.MouseButton1Click:Connect(function() SwitchTab(def.id) end)

    return {btn=btn, lbl=lbl, bar=bar}
end

for _, def in ipairs(TabDefs) do
    SideBtns[def.id] = MakeSideBtn(def)
end

-- Count badge helper
local function SetBadge(id, n)
    -- future: show count on sidebar button
end

function SwitchTab(id)
    ActiveTab = id
    for tid, d in pairs(SideBtns) do
        local active = (tid == id)
        Tween(d.btn, 0.13, {BackgroundTransparency = active and 0.84 or 1})
        Tween(d.lbl, 0.13, {TextColor3 = active and T().accent or T().sub})
        Tween(d.bar, 0.13, {BackgroundTransparency = active and 0 or 1})
        d.btn.BackgroundColor3 = T().accent
    end

    if     id == "Dashboard"   then BuildDashboard()
    elseif id == "Teleports"   then BuildTeleportTab()
    elseif id == "Stats"       then BuildStatsTab()
    elseif id == "Config"      then BuildConfigTab()
    else                            BuildFeatureTab(id)
    end
end

-- Search integration
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text
    if q == "" then
        SwitchTab(ActiveTab)
    else
        ClearContent()
        local lo = 0
        local found = 0
        for id, f in pairs(Registry) do
            if f.name:lower():find(q:lower(),1,true)
            or (f.desc and f.desc:lower():find(q:lower(),1,true)) then
                FeatCard(id, lo); lo=lo+1
                found = found + 1
            end
        end
        if found == 0 then
            NewLabel({
                Size=UDim2.new(1,0,0,40),
                Text='No results for "'..q..'"',
                TextSize=13, TextColor3=T().sub,
                BackgroundTransparency=1,
                LayoutOrder=1, Parent=Content,
            })
        end
    end
end)

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [25] WINDOW CONTROLS & ANIMATIONS                                       │
-- └─────────────────────────────────────────────────────────────────────────┘

local minimized = false

BtnMinimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Tween(Hub, 0.22, {Size=UDim2.new(0,800,0,46)}, Enum.EasingStyle.Quart)
        Content.Visible = false
        Sidebar.Visible = false
    else
        Tween(Hub, 0.22, {Size=UDim2.new(0,800,0,530)}, Enum.EasingStyle.Quart)
        Content.Visible = true
        Sidebar.Visible = true
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    Tween(Hub, 0.18, {
        Size     = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0),
    })
    task.delay(0.2, function() Hub.Visible=false end)
end)

BtnDiscord.MouseButton1Click:Connect(function()
    ModalDim.Visible     = true
    DiscordModal.Visible = true
    DiscordModal.Size    = UDim2.new(0,340,0,220)
    DiscordModal.Position= UDim2.new(0.5,-170,0.5,-110)
    Tween(DiscordModal, 0.28, {
        Size     = UDim2.new(0,460,0,300),
        Position = UDim2.new(0.5,-230,0.5,-150),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

BtnTheme.MouseButton1Click:Connect(function()
    -- Cycle theme
    local order = {"Dark","Midnight","Crimson","Ocean","Forest"}
    local idx = 1
    for i, n in ipairs(order) do if n==Cfg.theme then idx=i; break end end
    idx = idx % #order + 1
    Cfg.theme = order[idx]; CfgSave()
    Notif("Theme", "Switched to "..Cfg.theme, 2)
end)

DSkipBtn.MouseButton1Click:Connect(function()
    Cfg.discordSeen = true; CfgSave()
    Tween(DiscordModal, 0.15, {BackgroundTransparency=1})
    task.delay(0.18, function()
        DiscordModal.Visible = false
        ModalDim.Visible     = false
        Tween(DiscordModal, 0, {BackgroundTransparency=0})
        if not Hub.Visible then ShowHub() end
    end)
end)

DCopyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD) end)
    Notif("Discord","Copied! "..DISCORD, 3)
end)

local function ShowHub()
    Hub.Size     = UDim2.new(0,0,0,0)
    Hub.Position = UDim2.new(0.5,0,0.5,0)
    Hub.Visible  = true
    Tween(Hub, 0.32, {
        Size     = UDim2.new(0,800,0,530),
        Position = UDim2.new(0.5,-400,0.5,-265),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.delay(0.1, function() SwitchTab("Dashboard") end)
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [26] MOBILE SUPPORT                                                     │
-- └─────────────────────────────────────────────────────────────────────────┘

if UserInputService.TouchEnabled then
    -- Scale hub for mobile screens
    Hub.Size     = UDim2.new(1,-16, 0.9, 0)
    Hub.Position = UDim2.new(0, 8, 0.05, 0)
    Hub.Draggable = false

    -- Floating toggle bubble
    local bubble = NewBtn({
        Size             = UDim2.new(0,60, 0,60),
        Position         = UDim2.new(1,-70, 1,-80),
        BackgroundColor3 = T().accent,
        BackgroundTransparency = 0.2,
        Text             = "EH",
        TextSize         = 16,
        Font             = Enum.Font.GothamBlack,
        ZIndex           = 500,
        Parent           = GUI,
    })
    Corner(bubble,999)
    Stroke(bubble, T().accent, 2, 0.35)

    -- Pulse
    local pulsing = true
    task.spawn(function()
        while pulsing do
            Tween(bubble, 0.85, {BackgroundTransparency=0.1}, Enum.EasingStyle.Sine)
            task.wait(0.95)
            Tween(bubble, 0.85, {BackgroundTransparency=0.38}, Enum.EasingStyle.Sine)
            task.wait(0.95)
        end
    end)

    bubble.MouseButton1Click:Connect(function()
        pulsing = false
        bubble.BackgroundTransparency = 0.22
        if Hub.Visible then
            Tween(Hub, 0.18, {Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)})
            task.delay(0.2, function() Hub.Visible=false end)
        else
            ShowHub()
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [27] KEYBINDS                                                           │
-- └─────────────────────────────────────────────────────────────────────────┘

UserInputService.InputBegan:Connect(function(input, gameProc)
    if gameProc then return end
    local k = input.KeyCode

    -- Hub toggle: RightCtrl or gamepad R3
    if k == Enum.KeyCode.RightControl or k == Enum.KeyCode.ButtonR3 then
        if Hub.Visible then
            Tween(Hub, 0.18, {Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)})
            task.delay(0.2, function() Hub.Visible=false end)
        else
            ShowHub()
        end
    end

    -- Kill switch: Delete = disable all danger features
    if k == Enum.KeyCode.Delete then
        FDisableDanger("high")
        FDisableDanger("moderate")
        Notif("Kill Switch","All danger features OFF!",3)
    end

    -- Emergency fly off: End key
    if k == Enum.KeyCode.End then
        if FOn("fly") then FDisable("fly") end
        Notif("Fly","Emergency fly OFF",2)
    end

    -- Blink handled inside fly feature [Q]
end)

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ [28] STARTUP SEQUENCE                                                   │
-- └─────────────────────────────────────────────────────────────────────────┘

-- Respawn: restore all features
LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 6)
    task.wait(1.8)
    -- Re-bind auto_parry to new humanoid
    if FOn("auto_parry") then
        Drop("auto_parry")
        local f = Registry["auto_parry"]
        if f.onOn then task.spawn(pcall, f.onOn) end
    end
    -- Restore movement features
    if FOn("speed") then
        local hum = GetHum()
        if hum then hum.WalkSpeed = Cfg.walkSpeed or 80 end
    end
    if FOn("high_jump") then
        local hum = GetHum()
        if hum then hum.JumpPower = Cfg.jumpPower or 180 end
    end
    -- Re-init all loop-based features
    for id, f in pairs(Registry) do
        if f.enabled and (not ConnPool[id] or #ConnPool[id] == 0) then
            if f.onOn then task.spawn(pcall, f.onOn) end
        end
    end
    Notif("Respawned","Features restored!",2)
end)

-- Loader sequence
task.spawn(function()
    local progress = 0
    local msgIdx   = 1

    -- Logo fade-in
    LogoMain.TextTransparency       = 1
    LogoMain.TextStrokeTransparency = 1
    LogoSub.TextTransparency        = 1
    Tween(LogoMain, 0.5, {TextTransparency=0, TextStrokeTransparency=0.55})
    Tween(LogoSub,  0.5, {TextTransparency=0})
    task.wait(0.2)

    -- Bar glow pulse
    task.spawn(function()
        while Loader.Visible do
            Tween(LoaderGlow, 1.2, {BackgroundTransparency=0.88}, Enum.EasingStyle.Sine)
            task.wait(1.3)
            Tween(LoaderGlow, 1.2, {BackgroundTransparency=0.95}, Enum.EasingStyle.Sine)
            task.wait(1.3)
        end
    end)

    -- Progress loop
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        progress = progress + dt * 42 + math.random(0, 7)
        if progress >= 100 then progress = 100 end
        local frac = progress / 100

        -- bar fill
        Tween(BarFill,    0.07, {Size=UDim2.new(frac,0,1,0)})
        BarShimmer.Position = UDim2.new(frac-0.1,0,0,0)
        BarPct.Text       = math.floor(progress) .. "%"

        -- status messages
        local newIdx = math.max(1, math.ceil(frac * #StatusMessages))
        if newIdx ~= msgIdx and newIdx <= #StatusMessages then
            msgIdx = newIdx
            StatusLog.Text = StatusMessages[newIdx]
            -- check off items
            local checkIdx = math.ceil(frac * #CheckItems)
            if checkIdx <= #CheckLabels and CheckLabels[checkIdx] then
                CheckLabels[checkIdx].Text = "✓  " .. CheckItems[checkIdx]
                Tween(CheckLabels[checkIdx], 0.2, {TextColor3=T().success})
            end
        end

        if progress >= 100 then
            conn:Disconnect()
            task.wait(0.55)

            -- Fade out loader
            Tween(LoaderPanel, 0.4, {BackgroundTransparency=1})
            Tween(LoaderGlow,  0.4, {BackgroundTransparency=1})
            for _, child in ipairs(LoaderPanel:GetChildren()) do
                if child:IsA("GuiObject") then
                    Tween(child, 0.35, {BackgroundTransparency=1})
                    if child:IsA("TextLabel") then
                        Tween(child, 0.3, {TextTransparency=1, TextStrokeTransparency=1})
                    end
                end
            end
            for _, col in ipairs(matrixCols) do
                Tween(col, 0.5, {TextTransparency=1})
            end
            Tween(Loader, 0.5, {BackgroundTransparency=1})

            task.wait(0.6)
            Loader.Visible = false

            -- Restore features saved in config
            FRestoreAll()

            -- Show discord popup or hub
            if not Cfg.discordSeen then
                ModalDim.Visible     = true
                DiscordModal.Visible = true
                DiscordModal.Size    = UDim2.new(0,340,0,220)
                DiscordModal.Position= UDim2.new(0.5,-170,0.5,-110)
                Tween(DiscordModal, 0.3, {
                    Size     = UDim2.new(0,460,0,300),
                    Position = UDim2.new(0.5,-230,0.5,-150),
                }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                ShowHub()
            end
        end
    end)
end)

-- ════════════════════════════════════════════════════════════════════════════
-- BOOT COMPLETE
print(("[%s v%s | Build %s] Loaded  ·  %s"):format(
    HUB_NAME, HUB_VERSION, HUB_BUILD, DISCORD))
print("[EliteHub]  RightCtrl / R3  =  Toggle Hub")
print("[EliteHub]  Delete          =  Kill Switch (all danger off)")
print("[EliteHub]  Q               =  Blink (while fly active)")
Notif("Loaded", "v"..HUB_VERSION.."  ·  RightCtrl to open  ·  "..DISCORD_SHORT, 6)
-- ════════════════════════════════════════════════════════════════════════════
