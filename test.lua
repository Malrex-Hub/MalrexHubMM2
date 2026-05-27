-- ╔══════════════════════════════════════════════╗
-- ║   ELITE HUB  v1.0.0                         ║
-- ║   Blox Fruits  |  All Seas  |  Lv 1 - 2800  ║
-- ║   Optimized for Delta Executor               ║
-- ║   discord.gg/EmsMsHZCVH                      ║
-- ╚══════════════════════════════════════════════╝

-- ════════════════════════════════════════
--  EXECUTOR DETECTION & COMPAT LAYER
-- ════════════════════════════════════════
local IS_DELTA      = false
local HAS_DRAW      = typeof(Drawing)           == "table"
local HAS_WRITEFILE = typeof(writefile)         == "function"
local HAS_READFILE  = typeof(readfile)          == "function"
local HAS_FTI       = typeof(firetouchinterest) == "function"
local HAS_NCC       = typeof(newcclosure)       == "function"
local HAS_CLONEREF  = typeof(cloneref)          == "function"
local EXEC_NAME     = "Unknown"

pcall(function()
    if identifyexecutor then
        EXEC_NAME = identifyexecutor()
        IS_DELTA  = EXEC_NAME:lower():find("delta") ~= nil
    end
end)

local function wrap(f) return (HAS_NCC and newcclosure or function(x) return x end)(f) end
local function ref(s)  return (HAS_CLONEREF and cloneref or function(x) return x end)(s) end

-- ════════════════════════════════════════
--  SERVICES
-- ════════════════════════════════════════
local Players          = ref(game:GetService("Players"))
local RunService       = ref(game:GetService("RunService"))
local UserInputService = ref(game:GetService("UserInputService"))
local TweenService     = ref(game:GetService("TweenService"))
local VirtualUser      = ref(game:GetService("VirtualUser"))
local Lighting         = ref(game:GetService("Lighting"))
local TeleportService  = ref(game:GetService("TeleportService"))
local LP               = Players.LocalPlayer
local Mouse            = LP:GetMouse()
local PG               = LP:WaitForChild("PlayerGui")
local Camera           = workspace.CurrentCamera

-- ════════════════════════════════════════
--  CONFIG  (save / load via writefile)
-- ════════════════════════════════════════
local CFG_PATH = "EliteHub_v1_config.json"

local function cfgDefault()
    return {
        AutoFarm=false, TargetMob="Bandit", FarmMethod="Melee",
        SafeMode=false,  FarmDelay=0.12,
        AutoLevelFarm=false,
        AutoBoss=false,  SelectedBoss="Gorilla King",
        AutoRaid=false,  SelectedRaid="Flame",
        TPFruit=false,   AutoChest=false,
        AutoQuest=false, AutoEatFruit=false,
        KillAura=false,  KillAuraRange=25,
        FlyEnabled=false, FlySpeed=60,
        NoClip=false,    GodMode=false,
        AntiAFK=true,    AutoRespawn=true, InfJump=false,
        ShowFPS=true,    ShowWatermark=true,
        PlayerESP=false, MobESP=false, FruitESP=false,
        Fullbright=false, NoFog=false, FOV=70,
        WalkSpeed=16,    JumpPower=50,
    }
end

-- Proper JSON serialize (no corruption on strings with commas/braces)
local function toJSON(data)
    local out = {}
    for k, v in pairs(data) do
        local val
        if     type(v) == "boolean" then val = v and "true" or "false"
        elseif type(v) == "number"  then val = tostring(v)
        else
            local esc = tostring(v):gsub("\\","\\\\"):gsub('"','\\"')
            val = '"'..esc..'"'
        end
        table.insert(out, '"'..tostring(k)..'":'..val)
    end
    return "{"..table.concat(out,",").."}"
end

local function fromJSON(raw, defaults)
    local d = {}
    for k, def in pairs(defaults) do d[k] = def end
    pcall(function()
        for k in pairs(defaults) do
            -- Match value after the key, stopping at , or }
            local v = raw:match('"'..k..'":%s*(.-)%s*[,}%]]')
            if v then
                v = v:match("^%s*(.-)%s*$")
                if     v == "true"   then d[k] = true
                elseif v == "false"  then d[k] = false
                elseif tonumber(v)   then d[k] = tonumber(v)
                else d[k] = v:gsub('^"',''):gsub('"$','') end
            end
        end
    end)
    return d
end

local function saveConfig(data)
    if not HAS_WRITEFILE then return end
    pcall(function() writefile(CFG_PATH, toJSON(data)) end)
end

local function loadConfig()
    if not HAS_READFILE then return cfgDefault() end
    local ok, raw = pcall(readfile, CFG_PATH)
    if not ok or not raw or #raw < 2 then return cfgDefault() end
    return fromJSON(raw, cfgDefault())
end

local S = loadConfig()

-- ════════════════════════════════════════
--  MOB DATABASE  (Sea 1, 2, 3 — Lv 1-2800)
-- ════════════════════════════════════════
local MOBS = {
    -- ─── SEA 1 ─────────────────────────────────────────────────
    {sea=1,name="Bandit",            minLv=1,   maxLv=14,  pos=Vector3.new(   979,125,  1570)},
    {sea=1,name="Monkey",            minLv=15,  maxLv=29,  pos=Vector3.new( -1500,125,  -200)},
    {sea=1,name="Gorilla",           minLv=30,  maxLv=59,  pos=Vector3.new( -1700,125,  -310)},
    {sea=1,name="Pirate",            minLv=60,  maxLv=99,  pos=Vector3.new( -1200,125,  4350)},
    {sea=1,name="Brute",             minLv=100, maxLv=124, pos=Vector3.new( -1100,125,  4500)},
    {sea=1,name="Desert Bandit",     minLv=125, maxLv=149, pos=Vector3.new(   870,125,  4000)},
    {sea=1,name="Desert Officer",    minLv=150, maxLv=174, pos=Vector3.new(  1050,125,  4200)},
    {sea=1,name="Snow Bandit",       minLv=175, maxLv=199, pos=Vector3.new(  1200,125, -2700)},
    {sea=1,name="Snowman",           minLv=200, maxLv=249, pos=Vector3.new(  1300,125, -2850)},
    {sea=1,name="Marine",            minLv=250, maxLv=299, pos=Vector3.new(  -900,125,  -350)},
    {sea=1,name="Sky Bandit",        minLv=300, maxLv=374, pos=Vector3.new( -4700,875,  -700)},
    {sea=1,name="Dark Master",       minLv=375, maxLv=449, pos=Vector3.new( -4950,1410, -700)},
    {sea=1,name="Toga Warrior",      minLv=450, maxLv=624, pos=Vector3.new(  3324,127, -2640)},
    {sea=1,name="Carpenter",         minLv=60,  maxLv=99,  pos=Vector3.new( -1190,125,  4380)},
    -- ─── SEA 2 ─────────────────────────────────────────────────
    {sea=2,name="Hoodlum",           minLv=625, maxLv=699, pos=Vector3.new(  -750,266,   550)},
    {sea=2,name="Trader",            minLv=700, maxLv=774, pos=Vector3.new(  -900,266,   650)},
    {sea=2,name="Forest Pirate",     minLv=775, maxLv=849, pos=Vector3.new( -3550,125,  1850)},
    {sea=2,name="Factory Staff",     minLv=850, maxLv=924, pos=Vector3.new( -3300,125,  2000)},
    {sea=2,name="Zombie",            minLv=925, maxLv=999, pos=Vector3.new( -5800,125,  -620)},
    {sea=2,name="Vampire",           minLv=1000,maxLv=1049,pos=Vector3.new( -5900,125,  -700)},
    {sea=2,name="Living Zombie",     minLv=1050,maxLv=1099,pos=Vector3.new( -5950,125,  -750)},
    {sea=2,name="Demonic Soul",      minLv=1100,maxLv=1174,pos=Vector3.new( -5200,125, -1720)},
    {sea=2,name="Ship Crew",         minLv=1175,maxLv=1249,pos=Vector3.new( -5200,125, -1780)},
    {sea=2,name="Cursed Pirate",     minLv=1250,maxLv=1324,pos=Vector3.new( -5300,125, -1800)},
    {sea=2,name="Military Soldier",  minLv=1325,maxLv=1399,pos=Vector3.new(-10000,125, -2000)},
    {sea=2,name="Military Spy",      minLv=1325,maxLv=1399,pos=Vector3.new( -9800,125, -1900)},
    {sea=2,name="Assassin",          minLv=1400,maxLv=1474,pos=Vector3.new( -9500,125, -1700)},
    {sea=2,name="Arctic Warrior",    minLv=1475,maxLv=1549,pos=Vector3.new( -4300,1000,-1000)},
    {sea=2,name="Snow Lurker",       minLv=1550,maxLv=1624,pos=Vector3.new( -4600,1020,-1100)},
    {sea=2,name="Snow Demon",        minLv=1625,maxLv=1699,pos=Vector3.new( -4500,1010,-1050)},
    {sea=2,name="Dragon Crew Warrior",minLv=1700,maxLv=1774,pos=Vector3.new( 3600,125, 29450)},
    {sea=2,name="Dragon Crew Archer",minLv=1775,maxLv=1849,pos=Vector3.new(  3700,125, 29550)},
    {sea=2,name="Swan Pirate",       minLv=1850,maxLv=1924,pos=Vector3.new(   880,125, 29250)},
    {sea=2,name="Poseidon Soldier",  minLv=1925,maxLv=1999,pos=Vector3.new( 61350,125,  1780)},
    {sea=2,name="Poseidon Knight",   minLv=2000,maxLv=2099,pos=Vector3.new( 61450,125,  1850)},
    -- ─── SEA 3 ─────────────────────────────────────────────────
    {sea=3,name="Galley Pirate",     minLv=1500,maxLv=1574,pos=Vector3.new( -2000, 50, -4200)},
    {sea=3,name="Pirate Millionaire",minLv=1575,maxLv=1649,pos=Vector3.new( -2100, 50, -4300)},
    {sea=3,name="Jungle Bug",        minLv=1650,maxLv=1724,pos=Vector3.new( -3200,125, -3800)},
    {sea=3,name="Laboon",            minLv=1725,maxLv=1799,pos=Vector3.new( -3350,125, -3950)},
    {sea=3,name="Forest Dragon",     minLv=1800,maxLv=1874,pos=Vector3.new( -9000,400, -2500)},
    {sea=3,name="Tree Spider",       minLv=1875,maxLv=1949,pos=Vector3.new( -9100,400, -2600)},
    {sea=3,name="Reborn Skeleton",   minLv=1950,maxLv=2049,pos=Vector3.new(-11400,400, -1000)},
    {sea=3,name="Cursed Skeleton",   minLv=2050,maxLv=2124,pos=Vector3.new(-11500,400, -1040)},
    {sea=3,name="Soul Reaper",       minLv=2125,maxLv=2199,pos=Vector3.new(-11600,400, -1080)},
    {sea=3,name="Demonic Soul",      minLv=2200,maxLv=2274,pos=Vector3.new( -6600,125, -2750)},
    {sea=3,name="Diablo",            minLv=2275,maxLv=2349,pos=Vector3.new( -8300,125,  1600)},
    {sea=3,name="Beautiful Pirate",  minLv=2350,maxLv=2424,pos=Vector3.new( -8350,125,  1650)},
    {sea=3,name="Tiki Outpost Raider",minLv=2425,maxLv=2499,pos=Vector3.new(-8280,125, -1000)},
    {sea=3,name="Chocolate Bar Battler",minLv=2500,maxLv=2574,pos=Vector3.new(-13950,125,3800)},
    {sea=3,name="Ice Cream Staff",   minLv=2575,maxLv=2649,pos=Vector3.new(-14050,125,  3780)},
    {sea=3,name="Baking Staff",      minLv=2650,maxLv=2699,pos=Vector3.new(-14100,125,  3900)},
    {sea=3,name="Cake Guard",        minLv=2700,maxLv=2749,pos=Vector3.new(-14000,125,  3850)},
    {sea=3,name="Candy Rebel",       minLv=2750,maxLv=2799,pos=Vector3.new(-11650,125,  5450)},
    {sea=3,name="Cocoa Warrior",     minLv=2800,maxLv=9999,pos=Vector3.new(-12300,125,  4950)},
    {sea=3,name="Mythological Pirate",minLv=2800,maxLv=9999,pos=Vector3.new(-15100,125,-1750)},
    {sea=3,name="Brawler Crab",      minLv=2425,maxLv=2499,pos=Vector3.new(-14500,243, -1000)},
    {sea=3,name="Terrorshark",       minLv=2425,maxLv=2499,pos=Vector3.new(-14600,243, -1050)},
    {sea=3,name="Sea Soldier",       minLv=1500,maxLv=1574,pos=Vector3.new( -2050, 50, -4180)},
    {sea=3,name="Leviathan",         minLv=2800,maxLv=9999,pos=Vector3.new(-13050,125, -4650)},
    {sea=3,name="Snow Lurker",       minLv=2550,maxLv=2649,pos=Vector3.new(-14250,125, -2050)},
    {sea=3,name="Longma",            minLv=2800,maxLv=9999,pos=Vector3.new(  3640,125, 29500)},
}

-- Build lookup tables
local MOB_SPAWN = {}
local SEA1_MOBS, SEA2_MOBS, SEA3_MOBS = {}, {}, {}
local seenName = {}
for _, m in ipairs(MOBS) do
    if not MOB_SPAWN[m.name] then MOB_SPAWN[m.name] = m.pos end
    local uid = m.name.."|"..m.sea
    if not seenName[uid] then
        seenName[uid] = true
        if     m.sea==1 then table.insert(SEA1_MOBS, m.name)
        elseif m.sea==2 then table.insert(SEA2_MOBS, m.name)
        else                 table.insert(SEA3_MOBS, m.name) end
    end
end

local SEA_MOBS = { ["Sea 1"]=SEA1_MOBS, ["Sea 2"]=SEA2_MOBS, ["Sea 3"]=SEA3_MOBS }

-- ════════════════════════════════════════
--  LEVEL PROGRESSION ENGINE  (Lv 1 → 2800)
-- ════════════════════════════════════════
local function getPlayerLevel()
    local lv = 1
    pcall(function()
        local paths = {
            function() return LP:WaitForChild("Data",0.5):WaitForChild("Level",0.5).Value end,
            function() return LP:WaitForChild("PlayerData",0.5):WaitForChild("Level",0.5).Value end,
            function() return LP:WaitForChild("leaderstats",0.5):WaitForChild("Level",0.5).Value end,
            function() return LP:WaitForChild("leaderstats",0.5):WaitForChild("Lv",0.5).Value end,
        }
        for _, fn in ipairs(paths) do
            local ok, v = pcall(fn)
            if ok and type(v)=="number" and v > 0 then lv = v return end
        end
    end)
    return lv
end

local function getMobForLevel(lv)
    local best = nil
    for _, m in ipairs(MOBS) do
        if lv >= m.minLv and lv <= m.maxLv then
            if not best or m.minLv > best.minLv then best = m end
        end
    end
    return best and best.name or "Bandit"
end

-- ════════════════════════════════════════
--  ISLAND TELEPORT DATA
-- ════════════════════════════════════════
local SEA1_ISLANDS = {
    {"Starter Island",  Vector3.new(  1260,125,  1612)},
    {"Marine Starter",  Vector3.new( -1180,125, -1174)},
    {"Middle Town",     Vector3.new(  -192,125,  -559)},
    {"Jungle",          Vector3.new( -1646,125,  -261)},
    {"Pirate Village",  Vector3.new( -1189,125,  4403)},
    {"Desert",          Vector3.new(   924,125,  4089)},
    {"Frozen Village",  Vector3.new(  1175,125, -1818)},
    {"Snowy Village",   Vector3.new(  1326,125, -2882)},
    {"Marine Fortress", Vector3.new(  -965,125,  -380)},
    {"Skylands",        Vector3.new( -4755,872,  -718)},
    {"Upper Skylands",  Vector3.new( -5004,1400, -718)},
    {"Fountain City",   Vector3.new(  3324,127, -2610)},
}
local SEA2_ISLANDS = {
    {"Kingdom of Rose", Vector3.new(  -804,266,   604)},
    {"Dark Arena",      Vector3.new( -9564,125, -1754)},
    {"Usoapp Island",   Vector3.new( -2581,125,  1500)},
    {"Green Zone",      Vector3.new( -3626,125,  1900)},
    {"Graveyard",       Vector3.new( -5878,125,  -670)},
    {"Snow Mountain",   Vector3.new( -4550,1000,-1100)},
    {"Hot and Cold",    Vector3.new( -3620,125, -2945)},
    {"Cursed Ship",     Vector3.new( -5237,125, -1765)},
    {"Ice Castle",      Vector3.new( -3966,125, -1120)},
    {"Forgotten Island",Vector3.new( -6000,125, -1700)},
    {"Colosseum",       Vector3.new(   926,125, 29310)},
    {"Magma Village",   Vector3.new(   500,125, 29650)},
    {"Underwater City", Vector3.new( 61421,125,  1819)},
    {"Wano",            Vector3.new(  3640,125, 29500)},
}
local SEA3_ISLANDS = {
    {"Port Town",       Vector3.new( -2076, 49, -4246)},
    {"Hydra Island",    Vector3.new( -3281,125, -3900)},
    {"Great Tree",      Vector3.new( -9084,400, -2573)},
    {"Mansion",         Vector3.new( -6640,125, -2800)},
    {"Tiki Outpost",    Vector3.new( -8279,125, -1024)},
    {"Buggy Island",    Vector3.new( -8420,125,  1630)},
    {"Floating Turtle", Vector3.new(-14553,243, -1014)},
    {"Haunted Castle",  Vector3.new(-11540,400, -1044)},
    {"Distant Island",  Vector3.new(-13000,125, -4700)},
    {"Sea of Treats",   Vector3.new(-14055,125,  3829)},
    {"Peanut Island",   Vector3.new(-13350,125,  4100)},
    {"Cake Land",       Vector3.new(-12350,125,  5000)},
    {"Candy Island",    Vector3.new(-11700,125,  5500)},
    {"Ice Berg",        Vector3.new(-14300,125, -2100)},
    {"Labyrinth",       Vector3.new(-15200,125, -1800)},
}

-- ════════════════════════════════════════
--  RAID & BOSS DATA
-- ════════════════════════════════════════
local RAID_POS = {
    Flame=Vector3.new(3066,28,2760),    Ice=Vector3.new(1227,28,-2204),
    Rumble=Vector3.new(-4755,872,-718), Quake=Vector3.new(-1180,28,-1174),
    Light=Vector3.new(3324,28,-2610),   Dark=Vector3.new(-9084,28,-2573),
    Buddha=Vector3.new(-804,28,604),    Venom=Vector3.new(-5237,28,-1765),
    Phoenix=Vector3.new(-3966,28,-1120),Dough=Vector3.new(-12350,28,5000),
    Shadow=Vector3.new(-11540,28,-1044),Portal=Vector3.new(-14553,28,-1014),
    Control=Vector3.new(-15200,28,-1800),Dragon=Vector3.new(-9564,28,-1754),
    Leopard=Vector3.new(-14300,28,-2100),["T-Rex"]=Vector3.new(-13000,28,-4700),
}
local BOSS_POS = {
    ["Gorilla King"]=Vector3.new(-1700,125,-310),
    ["Bobby"]=Vector3.new(-1189,125,4403),
    ["Yeti"]=Vector3.new(1300,125,-2880),
    ["Darkbeard"]=Vector3.new(-9564,125,-1754),
    ["Rip_Indra"]=Vector3.new(-9084,400,-2573),
    ["Thunder God"]=Vector3.new(-4755,872,-718),
    ["Tide Keeper"]=Vector3.new(61421,125,1819),
    ["Stone"]=Vector3.new(-5237,125,-1765),
    ["Island Empress"]=Vector3.new(-3966,125,-1120),
    ["Longma"]=Vector3.new(3640,125,29500),
    ["Cake Prince"]=Vector3.new(-12350,125,5000),
    ["Kilo Admiral"]=Vector3.new(924,125,4089),
    ["Vice Admiral"]=Vector3.new(-965,125,-380),
    ["Magma Admiral"]=Vector3.new(500,125,29650),
    ["Order"]=Vector3.new(-14553,243,-1014),
    ["Cursed Captain"]=Vector3.new(-14300,125,-2100),
    ["Bartolomeo"]=Vector3.new(926,125,29310),
    ["Greybeard"]=Vector3.new(-965,125,-380),
    ["Don Swan"]=Vector3.new(-9564,125,-1754),
}

-- ════════════════════════════════════════
--  THEME
-- ════════════════════════════════════════
local T = {
    BG      = Color3.fromRGB(  7,  7,  7),
    Panel   = Color3.fromRGB( 15, 15, 15),
    Panel2  = Color3.fromRGB( 22, 22, 22),
    Panel3  = Color3.fromRGB( 30, 30, 30),
    Border  = Color3.fromRGB( 48, 48, 48),
    Border2 = Color3.fromRGB( 36, 36, 36),
    Accent  = Color3.fromRGB(255,255,255),
    Text    = Color3.fromRGB(235,235,235),
    Sub     = Color3.fromRGB(120,120,120),
    Dim     = Color3.fromRGB( 55, 55, 55),
    Green   = Color3.fromRGB( 80,200, 80),
    Red     = Color3.fromRGB(210, 65, 65),
    Gold    = Color3.fromRGB(215,170, 50),
    Blue    = Color3.fromRGB( 90,130,245),
    Purple  = Color3.fromRGB(150, 90,240),
    TabOn   = Color3.fromRGB( 32, 32, 32),
    TabOff  = Color3.fromRGB( 15, 15, 15),
}

-- ════════════════════════════════════════
--  CORE UTILS
-- ════════════════════════════════════════
local function tw(obj, props, dur, sty, dir)
    local ti = TweenInfo.new(dur or 0.18,
        sty or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, ti, props):Play()
end

local function inst(cls, props)
    local o = Instance.new(cls)
    for k,v in pairs(props) do if k~="Parent" then o[k]=v end end
    if props.Parent then o.Parent=props.Parent end
    return o
end

local function corner(o, r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 6)
    c.Parent=o
    return c
end

local function stroke(o, col, thk)
    local s=Instance.new("UIStroke")
    s.Color=col or T.Border s.Thickness=thk or 1
    s.Parent=o return s
end

local function pad(o,t,l,r,b)
    local p=Instance.new("UIPadding")
    p.PaddingTop=UDim.new(0,t or 0) p.PaddingLeft=UDim.new(0,l or 0)
    p.PaddingRight=UDim.new(0,r or 0) p.PaddingBottom=UDim.new(0,b or 0)
    p.Parent=o
end

local function listLayout(o, dir, gap)
    local l=Instance.new("UIListLayout")
    l.FillDirection=dir or Enum.FillDirection.Vertical
    l.SortOrder=Enum.SortOrder.LayoutOrder
    if gap then l.Padding=UDim.new(0,gap) end
    l.Parent=o return l
end

-- Character helpers
local function getChar()   return LP.Character end
local function getHum()    local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()   local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive()   local h=getHum()  return h and h.Health > 0 end

-- Stepped TP (anti-kick, 6 steps)
local function tp(pos, instant)
    local root=getRoot() if not root then return end
    local goal = pos + Vector3.new(0,3.5,0)
    if instant then root.CFrame=CFrame.new(goal) return end
    local from = root.CFrame.Position
    for i=1,6 do
        root.CFrame = CFrame.new(from:Lerp(goal, i/6))
        task.wait(0.025)
    end
end

-- Find nearest living mob of given name within radius
local function findMob(name, radius)
    local root=getRoot() if not root then return nil end
    local best, bestDist = nil, radius or 9999
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar()
        and (obj.Name==name or obj.Name:lower():find(name:lower(),1,true)) then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            local hrp=obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                local d=(hrp.Position-root.Position).Magnitude
                if d<bestDist then best,bestDist=obj,d end
            end
        end
    end
    return best
end

-- Check if mob actually died
local function isDead(mob)
    if not mob or not mob.Parent then return true end
    local hum=mob:FindFirstChildOfClass("Humanoid")
    return not hum or hum.Health<=0
end

-- Attack mob, return true if it dies
local function attack(mob)
    if not mob or not mob.Parent then return false end
    local hrp=mob:FindFirstChild("HumanoidRootPart") if not hrp then return false end
    local hum=mob:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health<=0 then return true end -- already dead

    -- Step towards the mob
    tp(hrp.Position + Vector3.new(0,0,3))

    -- firetouchinterest (Delta)
    if HAS_FTI then
        local root=getRoot()
        if root then
            pcall(firetouchinterest,hrp,root,0) task.wait(0.05)
            pcall(firetouchinterest,hrp,root,1)
        end
    end

    -- Fire tool remotes
    local char=getChar()
    if char then
        for _,tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _,v in pairs(tool:GetDescendants()) do
                    if v:IsA("RemoteEvent")    then pcall(function() v:FireServer()   end) end
                    if v:IsA("RemoteFunction") then pcall(function() v:InvokeServer() end) end
                end
            end
        end
    end

    -- TakeDamage fallback
    pcall(function() if hum and hum.Health>0 then hum:TakeDamage(9999) end end)

    task.wait(0.2)
    return isDead(mob)
end

-- Scan workspace for fruits
local FRUIT_KW = {"fruit","devil","df_","logia","paramecia","zoan","ancient","mythical","awaken"}
local function scanFruits()
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        for _,kw in ipairs(FRUIT_KW) do
            if n:find(kw,1,true) then
                local base=obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if base then table.insert(found,{name=obj.Name,pos=base.Position,obj=obj,part=base}) end
                break
            end
        end
    end
    return found
end

-- Scan workspace for chests
local function scanChests()
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if n:find("chest",1,true) or n:find("box",1,true) or n:find("crate",1,true) then
            local base=obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if base then table.insert(found,{name=obj.Name,pos=base.Position,obj=obj,part=base}) end
        end
    end
    return found
end

-- ════════════════════════════════════════
--  STAT TRACKER
-- ════════════════════════════════════════
local STATS = {
    kills=0, deaths=0, fruitsTP=0, chestsTP=0, quests=0,
    startTime=os.time(),
    charLoaded=false,  -- prevents first CharacterAdded from counting as death
}

-- ════════════════════════════════════════
--  STATUS STRING  (shown in status bar)
-- ════════════════════════════════════════
local STATUS = "Idle"
local function setStatus(s) STATUS=s end

-- ════════════════════════════════════════
--  NOTIFICATIONS
-- ════════════════════════════════════════
local _nGui
local function notify(title, body, dur, accent)
    dur = dur or 3.5
    accent = accent or T.Accent
    if not _nGui or not _nGui.Parent then
        _nGui=inst("ScreenGui",{Name="_EHN",ResetOnSpawn=false,
            ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    end
    -- Shift existing cards up
    for _,f in pairs(_nGui:GetChildren()) do
        if f:IsA("Frame") then
            tw(f,{Position=UDim2.new(1,-296,1,f.Position.Y.Offset-76)},0.14)
        end
    end
    local card=inst("Frame",{
        Size=UDim2.new(0,284,0,62),
        Position=UDim2.new(1,10,1,-72),
        BackgroundColor3=T.Panel, BorderSizePixel=0, Parent=_nGui
    })
    corner(card,8)
    stroke(card,T.Border2)
    -- Accent left bar
    inst("Frame",{Size=UDim2.new(0,2,1,0),BackgroundColor3=accent,BorderSizePixel=0,Parent=card})
    -- Inner top border glow
    inst("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=accent,
        BackgroundTransparency=0.7,BorderSizePixel=0,Parent=card})
    inst("TextLabel",{
        Size=UDim2.new(1,-14,0,18),Position=UDim2.new(0,12,0,5),
        BackgroundTransparency=1,Text=title,
        Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=card
    })
    inst("TextLabel",{
        Size=UDim2.new(1,-14,0,30),Position=UDim2.new(0,12,0,24),
        BackgroundTransparency=1,Text=body,
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=card
    })
    tw(card,{Position=UDim2.new(1,-296,1,-72)},0.28,Enum.EasingStyle.Back)
    task.delay(dur,function()
        tw(card,{Position=UDim2.new(1,10,1,-72)},0.2)
        task.wait(0.22) pcall(function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════
--  LOADING SCREEN  (improved)
-- ════════════════════════════════════════
local function showLoader()
    local sg=inst("ScreenGui",{Name="_EHL",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=PG})
    local bg=inst("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,3,3),BorderSizePixel=0,Parent=sg})

    -- Subtle grid
    for i=1,16 do
        inst("Frame",{Size=UDim2.new(1,0,0,1),
            Position=UDim2.new(0,0,(i-1)/16,0),
            BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.97,
            BorderSizePixel=0,Parent=bg})
        inst("Frame",{Size=UDim2.new(0,1,1,0),
            Position=UDim2.new((i-1)/16,0,0,0),
            BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.97,
            BorderSizePixel=0,Parent=bg})
    end

    -- Diagonal accent line (top-left to center)
    inst("Frame",{
        Size=UDim2.new(0,2,0,200),
        Position=UDim2.new(0.5,-200,0.5,-250),
        BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.92,
        BorderSizePixel=0,Rotation=45,Parent=bg
    })
    inst("Frame",{
        Size=UDim2.new(0,2,0,300),
        Position=UDim2.new(0.5,-100,0.5,-300),
        BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.94,
        BorderSizePixel=0,Rotation=45,Parent=bg
    })

    -- Center card
    local card=inst("Frame",{
        Size=UDim2.new(0,320,0,220),
        Position=UDim2.new(0.5,-160,0.5,-110),
        BackgroundColor3=Color3.fromRGB(9,9,9),
        BorderSizePixel=0,Parent=bg
    })
    corner(card,10)
    stroke(card,Color3.fromRGB(52,52,52))
    -- Top accent strip
    local topStrip=inst("Frame",{
        Size=UDim2.new(1,0,0,2),BackgroundColor3=Color3.new(1,1,1),
        BackgroundTransparency=0,BorderSizePixel=0,Parent=card
    })
    corner(topStrip,10)

    inst("TextLabel",{
        Size=UDim2.new(1,0,0,52),Position=UDim2.new(0,0,0,22),
        BackgroundTransparency=1,Text="ELITE HUB",
        Font=Enum.Font.GothamBlack,TextSize=32,
        TextColor3=Color3.new(1,1,1),Parent=card
    })
    inst("TextLabel",{
        Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,66),
        BackgroundTransparency=1,Text="BLOX FRUITS  |  ALL SEAS  |  Lv 1 - 2800",
        Font=Enum.Font.GothamBold,TextSize=9,
        TextColor3=Color3.fromRGB(70,70,70),Parent=card
    })
    inst("TextLabel",{
        Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,84),
        BackgroundTransparency=1,
        Text="Executor: "..EXEC_NAME..(IS_DELTA and "  [DELTA DETECTED]" or ""),
        Font=Enum.Font.Gotham,TextSize=8.5,
        TextColor3=Color3.fromRGB(55,55,55),Parent=card
    })

    -- Separator
    inst("Frame",{
        Size=UDim2.new(0,240,0,1),
        Position=UDim2.new(0.5,-120,0,104),
        BackgroundColor3=Color3.fromRGB(40,40,40),
        BorderSizePixel=0,Parent=card
    })

    -- Status label
    local statLbl=inst("TextLabel",{
        Size=UDim2.new(1,-28,0,16),Position=UDim2.new(0,14,0,114),
        BackgroundTransparency=1,Text="Initializing...",
        Font=Enum.Font.Gotham,TextSize=10,
        TextColor3=Color3.fromRGB(75,75,75),
        TextXAlignment=Enum.TextXAlignment.Left,Parent=card
    })

    -- Progress bar track
    local barBg=inst("Frame",{
        Size=UDim2.new(1,-28,0,4),
        Position=UDim2.new(0,14,0,140),
        BackgroundColor3=Color3.fromRGB(22,22,22),
        BorderSizePixel=0,Parent=card
    })
    corner(barBg,3)

    local bar=inst("Frame",{
        Size=UDim2.new(0,0,1,0),
        BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0,Parent=barBg
    })
    corner(bar,3)

    -- Shimmer effect on bar
    local shimmer=inst("Frame",{
        Size=UDim2.new(0.3,0,1,0),
        Position=UDim2.new(0,0,0,0),
        BackgroundColor3=Color3.new(1,1,1),
        BackgroundTransparency=0.7,
        BorderSizePixel=0,Parent=bar
    })
    corner(shimmer,3)

    -- Pct label
    local pctLbl=inst("TextLabel",{
        Size=UDim2.new(0,40,0,14),
        Position=UDim2.new(1,-44,0,148),
        BackgroundTransparency=1,Text="0%",
        Font=Enum.Font.GothamBold,TextSize=9,
        TextColor3=Color3.fromRGB(55,55,55),
        TextXAlignment=Enum.TextXAlignment.Right,Parent=card
    })

    -- Version tag bottom
    inst("TextLabel",{
        Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-20),
        BackgroundTransparency=1,
        Text="v1.0.0  —  discord.gg/EmsMsHZCVH",
        Font=Enum.Font.Gotham,TextSize=9,
        TextColor3=Color3.fromRGB(42,42,42),Parent=card
    })

    -- Live clock — top-right corner
    local clockLbl=inst("TextLabel",{
        Size=UDim2.new(0,200,0,48),
        Position=UDim2.new(1,-214,0,16),
        BackgroundTransparency=1,Text="",
        Font=Enum.Font.GothamBlack,TextSize=38,
        TextColor3=Color3.fromRGB(255,255,255),
        TextXAlignment=Enum.TextXAlignment.Right,Parent=bg
    })
    local dateLbl=inst("TextLabel",{
        Size=UDim2.new(0,200,0,16),
        Position=UDim2.new(1,-214,0,66),
        BackgroundTransparency=1,Text="",
        Font=Enum.Font.Gotham,TextSize=11,
        TextColor3=Color3.fromRGB(60,60,60),
        TextXAlignment=Enum.TextXAlignment.Right,Parent=bg
    })

    local DAYS   = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"}
    local MONTHS = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
    local clockConn
    clockConn=RunService.Heartbeat:Connect(wrap(function()
        if not clockLbl.Parent then clockConn:Disconnect() return end
        local d=os.date("*t",os.time())
        local h,m,s=d.hour,d.min,d.sec
        local ap=h>=12 and "PM" or "AM"
        h=h%12==0 and 12 or h%12
        clockLbl.Text=string.format("%02d:%02d:%02d %s",h,m,s,ap)
        dateLbl.Text=string.format("%s  %s %d, %d",DAYS[d.wday],MONTHS[d.month],d.day,d.year)
    end))

    -- Animate entry
    card.Position=UDim2.new(0.5,-160,0.5,-110)
    card.BackgroundTransparency=1
    tw(card,{BackgroundTransparency=0},0.35)

    local steps={
        {0.12,"Detecting executor...",         T.Blue},
        {0.26,"Loading GUI framework...",      T.Accent},
        {0.40,"Injecting mob database...",     T.Accent},
        {0.52,"Mapping all three seas...",     T.Accent},
        {0.64,"Configuring ESP system...",     T.Accent},
        {0.76,"Building level engine (1-2800)...",T.Gold},
        {0.88,"Starting automation engine...", T.Gold},
        {0.96,"Applying config...",            T.Accent},
        {1.00,"Ready.",                        T.Green},
    }

    local shimmerConn
    shimmerConn=RunService.Heartbeat:Connect(wrap(function()
        if not shimmer.Parent then shimmerConn:Disconnect() return end
        local t=tick()%1
        shimmer.Position=UDim2.new(t-0.3,0,0,0)
    end))

    for _,step in ipairs(steps) do
        task.wait(0.22)
        statLbl.Text      = step[2]
        statLbl.TextColor3= step[3]
        pctLbl.Text       = math.floor(step[1]*100).."%"
        tw(bar,{Size=UDim2.new(step[1],0,1,0)},0.22)
        tw(bar,{BackgroundColor3=step[3]},0.15)
    end

    task.wait(0.5)
    shimmerConn:Disconnect()

    -- Fade out
    tw(bg,{BackgroundTransparency=1},0.45)
    for _,d in pairs(bg:GetDescendants()) do
        if d:IsA("GuiObject") then
            pcall(tw,d,{BackgroundTransparency=1,TextTransparency=1},0.45)
        end
    end
    task.wait(0.55)
    sg:Destroy()
end

-- ════════════════════════════════════════
--  DRAWING ESP
-- ════════════════════════════════════════
local espDrawings={}
local function clearDrawings()
    for _,o in pairs(espDrawings) do pcall(function() o:Remove() end) end
    espDrawings={}
end
local function newDraw(class, props)
    if not HAS_DRAW then return nil end
    local ok,o=pcall(Drawing.new,class)
    if not ok then return nil end
    for k,v in pairs(props) do pcall(function() o[k]=v end) end
    table.insert(espDrawings,o)
    return o
end
local function w2s(pos)
    local vp,vis=Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X,vp.Y),vis,vp.Z
end

local espConn
local function startDrawESP()
    if espConn then espConn:Disconnect() end
    clearDrawings()
    espConn=RunService.RenderStepped:Connect(wrap(function()
        local old=espDrawings espDrawings={}
        for _,o in pairs(old) do pcall(function() o:Remove() end) end

        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    local hum=p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp then
                        local sc,vis,dep=w2s(hrp.Position)
                        if vis and dep>0 then
                            local sz=math.clamp(1600/dep,18,160)
                            newDraw("Square",{Size=Vector2.new(sz,sz*1.65),
                                Position=Vector2.new(sc.X-sz/2,sc.Y-sz*0.82),
                                Color=Color3.new(1,1,1),Thickness=1.2,Filled=false,Visible=true,ZIndex=5})
                            local hp=hum and (" ["..math.floor(hum.Health).."]") or ""
                            newDraw("Text",{Text=p.Name..hp,
                                Position=Vector2.new(sc.X,sc.Y-sz*0.82-14),
                                Size=13,Color=Color3.new(1,1,1),
                                Center=true,Outline=true,Visible=true,ZIndex=5})
                        end
                    end
                end
            end
        end

        if S.MobESP then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj~=getChar()
                and not Players:GetPlayerFromCharacter(obj) then
                    local hum=obj:FindFirstChildOfClass("Humanoid")
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 then
                        local sc,vis,dep=w2s(hrp.Position)
                        if vis and dep>0 and dep<700 then
                            local sz=math.clamp(1400/dep,12,100)
                            newDraw("Square",{Size=Vector2.new(sz,sz*1.65),
                                Position=Vector2.new(sc.X-sz/2,sc.Y-sz*0.82),
                                Color=Color3.fromRGB(255,155,50),
                                Thickness=1,Filled=false,Visible=true,ZIndex=4})
                            newDraw("Text",{Text=obj.Name.." ["..math.floor(hum.Health).."]",
                                Position=Vector2.new(sc.X,sc.Y-sz*0.82-12),
                                Size=12,Color=Color3.fromRGB(255,175,70),
                                Center=true,Outline=true,Visible=true,ZIndex=4})
                        end
                    end
                end
            end
        end

        if S.FruitESP then
            for _,f in ipairs(scanFruits()) do
                if f.part and f.part.Parent then
                    local sc,vis,dep=w2s(f.pos)
                    if vis and dep>0 then
                        newDraw("Text",{Text="[FRUIT] "..f.name,
                            Position=sc,Size=13,
                            Color=Color3.fromRGB(80,220,80),
                            Center=true,Outline=true,Visible=true,ZIndex=6})
                    end
                end
            end
        end
    end))
end

-- BillboardGui fallback ESP
local billESP={}
task.spawn(function()
    while task.wait(1) do
        if HAS_DRAW then continue end
        for _,b in pairs(billESP) do pcall(function() b:Destroy() end) end
        billESP={}
        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bb=inst("BillboardGui",{Size=UDim2.new(0,90,0,24),
                            StudsOffset=Vector3.new(0,3.5,0),AlwaysOnTop=true,Parent=hrp})
                        inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                            Text=p.Name,Font=Enum.Font.GothamBold,TextSize=11,
                            TextColor3=Color3.new(1,1,1),TextStrokeTransparency=0,Parent=bb})
                        table.insert(billESP,bb)
                    end
                end
            end
        end
        if S.MobESP then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local hum=obj:FindFirstChildOfClass("Humanoid")
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 then
                        local bb=inst("BillboardGui",{Size=UDim2.new(0,100,0,24),
                            StudsOffset=Vector3.new(0,2.5,0),AlwaysOnTop=true,Parent=hrp})
                        inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                            Text=obj.Name,Font=Enum.Font.GothamBold,TextSize=10,
                            TextColor3=Color3.fromRGB(255,175,70),TextStrokeTransparency=0,Parent=bb})
                        table.insert(billESP,bb)
                    end
                end
            end
        end
        if S.FruitESP then
            for _,f in ipairs(scanFruits()) do
                if f.part and f.part.Parent then
                    local bb=inst("BillboardGui",{Size=UDim2.new(0,110,0,24),
                        StudsOffset=Vector3.new(0,2,0),AlwaysOnTop=true,Parent=f.part})
                    inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                        Text="[FRUIT] "..f.name,Font=Enum.Font.GothamBold,TextSize=10,
                        TextColor3=T.Green,TextStrokeTransparency=0,Parent=bb})
                    table.insert(billESP,bb)
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  MAIN GUI
-- ════════════════════════════════════════
local function buildGUI()
    pcall(function() PG:FindFirstChild("EliteHub"):Destroy() end)

    local sg=inst("ScreenGui",{Name="EliteHub",ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,Parent=PG})

    local WIN_W, WIN_H = 620, 468
    local win=inst("Frame",{
        Size=UDim2.new(0,WIN_W,0,WIN_H),
        Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2),
        BackgroundColor3=T.BG,BorderSizePixel=0,Active=true,Parent=sg
    })
    corner(win,8)
    stroke(win,T.Border)

    -- Drag
    local dragging,dOffX,dOffY=false,0,0
    RunService.RenderStepped:Connect(wrap(function()
        if dragging then
            win.Position=UDim2.new(0,Mouse.X-dOffX,0,Mouse.Y-dOffY)
        end
    end))

    -- ── TITLEBAR ──────────────────────────────────
    local tb=inst("Frame",{Size=UDim2.new(1,0,0,40),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=win})
    corner(tb,8)
    -- Patch rounded bottom corners of titlebar
    inst("Frame",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=tb})
    -- Bottom border line
    inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=T.Border2,BorderSizePixel=0,Parent=tb})

    -- Logo text
    inst("TextLabel",{Size=UDim2.new(0,130,1,0),Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,Text="ELITE HUB",
        Font=Enum.Font.GothamBlack,TextSize=14,TextColor3=T.Accent,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})
    inst("TextLabel",{Size=UDim2.new(0,260,1,0),Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,Text="               Blox Fruits  |  v1.0.0  |  Lv 1-2800",
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})

    -- Delta badge
    if IS_DELTA then
        local badge=inst("Frame",{Size=UDim2.new(0,58,0,20),
            Position=UDim2.new(0,190,0.5,-10),
            BackgroundColor3=Color3.fromRGB(18,22,40),BorderSizePixel=0,Parent=tb})
        corner(badge,4) stroke(badge,T.Blue,1)
        inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            Text="DELTA",Font=Enum.Font.GothamBlack,TextSize=9,TextColor3=T.Blue,Parent=badge})
    end

    -- Window controls
    local function winBtn(xOff, bgCol, lbl, cb)
        local b=inst("TextButton",{
            Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,xOff,0.5,-11),
            BackgroundColor3=bgCol,Text=lbl,Font=Enum.Font.GothamBold,
            TextSize=12,TextColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=tb
        })
        corner(b,11)
        b.MouseButton1Click:Connect(cb)
        b.MouseEnter:Connect(function() tw(b,{BackgroundTransparency=0.3}) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundTransparency=0}) end)
        return b
    end
    winBtn(-32,Color3.fromRGB(190,55,55),"x",function()
        tw(win,{Size=UDim2.new(0,WIN_W,0,0),BackgroundTransparency=1},0.2)
        task.wait(0.25) sg:Destroy()
    end)
    local minimized=false
    winBtn(-60,T.Dim,"-",function()
        minimized=not minimized
        tw(win,{Size=minimized and UDim2.new(0,WIN_W,0,40) or UDim2.new(0,WIN_W,0,WIN_H)},
            0.22,Enum.EasingStyle.Back)
    end)

    -- Drag connection
    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dOffX=Mouse.X-win.AbsolutePosition.X
            dOffY=Mouse.Y-win.AbsolutePosition.Y
        end
    end)
    tb.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    -- ── SIDEBAR ───────────────────────────────────
    local SB_W = 126
    local sb=inst("Frame",{
        Size=UDim2.new(0,SB_W,1,-42),
        Position=UDim2.new(0,0,0,41),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=win
    })
    -- Patch right edge
    inst("Frame",{Size=UDim2.new(0,SB_W/2,1,0),Position=UDim2.new(0,SB_W/2,0,0),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sb})
    inst("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=T.Border2,BorderSizePixel=0,Parent=sb})
    pad(sb,8,6,6,4)
    listLayout(sb,nil,3)

    -- ── CONTENT AREA ──────────────────────────────
    local ca=inst("Frame",{
        Size=UDim2.new(1,-(SB_W+8),1,-56),
        Position=UDim2.new(0,SB_W+6,0,43),
        BackgroundTransparency=1,Parent=win
    })

    -- ── STATUS BAR (bottom) ───────────────────────
    local statBar=inst("Frame",{
        Size=UDim2.new(1,0,0,16),
        Position=UDim2.new(0,0,1,-16),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=win
    })
    corner(statBar,0)
    inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),
        BackgroundColor3=T.Border2,BorderSizePixel=0,Parent=statBar})
    local statDot=inst("Frame",{Size=UDim2.new(0,5,0,5),
        Position=UDim2.new(0,10,0.5,-2.5),
        BackgroundColor3=T.Dim,BorderSizePixel=0,Parent=statBar})
    corner(statDot,3)
    local statTxt=inst("TextLabel",{Size=UDim2.new(0.6,0,1,0),
        Position=UDim2.new(0,20,0,0),BackgroundTransparency=1,
        Text="Idle",Font=Enum.Font.Gotham,TextSize=9,
        TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=statBar})
    local killsTxt=inst("TextLabel",{Size=UDim2.new(0.4,-10,1,0),
        Position=UDim2.new(0.6,0,0,0),BackgroundTransparency=1,
        Text="",Font=Enum.Font.Gotham,TextSize=9,
        TextColor3=T.Dim,TextXAlignment=Enum.TextXAlignment.Right,Parent=statBar})

    -- Update status bar
    RunService.Heartbeat:Connect(wrap(function()
        if not statTxt.Parent then return end
        local active = S.AutoFarm or S.AutoLevelFarm or S.KillAura or S.AutoBoss or S.AutoRaid
        statDot.BackgroundColor3 = active and T.Green or T.Dim
        statTxt.Text = STATUS
        killsTxt.Text = "K: "..STATS.kills.."  D: "..STATS.deaths
    end))

    -- Page / tab system
    local pages,tabs,curPage={},{},nil

    local function makePage(id)
        local sc=inst("ScrollingFrame",{
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            BorderSizePixel=0,ScrollBarThickness=2,
            ScrollBarImageColor3=T.Dim,CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=ca
        })
        listLayout(sc,nil,5)
        pad(sc,4,2,7,8)
        pages[id]=sc
        return sc
    end

    local function activatePage(id)
        if curPage then
            pages[curPage].Visible=false
            local pb=tabs[curPage]
            if pb then
                tw(pb,{BackgroundColor3=T.TabOff})
                local l=pb:FindFirstChildOfClass("TextLabel")
                if l then tw(l,{TextColor3=T.Sub}) end
            end
        end
        curPage=id
        pages[id].Visible=true
        local pb=tabs[id]
        if pb then
            tw(pb,{BackgroundColor3=T.TabOn})
            local l=pb:FindFirstChildOfClass("TextLabel")
            if l then tw(l,{TextColor3=T.Text}) end
        end
    end

    local function makeTab(id, label, order)
        local btn=inst("TextButton",{
            Size=UDim2.new(1,0,0,30),
            BackgroundColor3=T.TabOff,Text="",
            BorderSizePixel=0,LayoutOrder=order,Parent=sb
        })
        corner(btn,6)
        inst("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=label,
            Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Sub,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=btn})
        tabs[id]=btn
        btn.MouseButton1Click:Connect(function() activatePage(id) end)
        btn.MouseEnter:Connect(function()
            if curPage~=id then tw(btn,{BackgroundColor3=T.Panel2}) end
        end)
        btn.MouseLeave:Connect(function()
            if curPage~=id then tw(btn,{BackgroundColor3=T.TabOff}) end
        end)
        return function() activatePage(id) end
    end

    -- ── WIDGET BUILDERS ───────────────────────────

    local function section(page, title, order)
        local f=inst("Frame",{
            Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,
            LayoutOrder=order,Parent=page
        })
        inst("TextLabel",{Size=UDim2.new(1,-4,0,18),
            Position=UDim2.new(0,2,0,4),BackgroundTransparency=1,
            Text=title:upper(),Font=Enum.Font.GothamBold,TextSize=8.5,
            TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
            BackgroundColor3=T.Border2,BorderSizePixel=0,Parent=f})
    end

    local function toggle(page, label, key, order, cb)
        local row=inst("Frame",{
            Size=UDim2.new(1,0,0,34),BackgroundColor3=T.Panel2,
            BorderSizePixel=0,LayoutOrder=order,Parent=page
        })
        corner(row,6)
        inst("TextLabel",{Size=UDim2.new(1,-52,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=label,
            Font=Enum.Font.Gotham,TextSize=11,TextColor3=T.Text,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=row})

        local on = key and S[key] or false
        local track=inst("Frame",{
            Size=UDim2.new(0,36,0,18),
            Position=UDim2.new(1,-42,0.5,-9),
            BackgroundColor3=on and T.Green or T.Dim,
            BorderSizePixel=0,Parent=row
        })
        corner(track,9)
        local thumb=inst("Frame",{
            Size=UDim2.new(0,14,0,14),
            Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=track
        })
        corner(thumb,7)

        local function setState(v)
            on=v if key then S[key]=v end
            tw(track,{BackgroundColor3=on and T.Green or T.Dim})
            tw(thumb,{Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)})
        end

        inst("TextButton",{Size=UDim2.fromScale(1,1),
            BackgroundTransparency=1,Text="",Parent=row
        }).MouseButton1Click:Connect(function()
            setState(not on)
            if cb then cb(on) end
        end)

        return setState
    end

    local function button(page, label, col, order, cb)
        col = col or T.Panel2
        local b=inst("TextButton",{
            Size=UDim2.new(1,0,0,32),BackgroundColor3=col,
            Text=label,Font=Enum.Font.GothamBold,TextSize=11,
            TextColor3=T.Text,BorderSizePixel=0,LayoutOrder=order,Parent=page
        })
        corner(b,6)
        stroke(b,T.Border2)
        b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=T.Panel3}) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=col}) end)
        b.MouseButton1Click:Connect(function()
            tw(b,{Size=UDim2.new(0.97,0,0,28)},0.06)
            task.wait(0.07)
            tw(b,{Size=UDim2.new(1,0,0,32)},0.06)
            if cb then task.spawn(cb) end
        end)
        return b
    end

    -- Dropdown — returns container, selected label, and a setOptions(list, key) function
    local function dropdown(page, label, options, key, order, cb)
        local open=false
        local c=inst("Frame",{
            Size=UDim2.new(1,0,0,34),BackgroundColor3=T.Panel2,
            BorderSizePixel=0,LayoutOrder=order,
            ClipsDescendants=true,Parent=page
        })
        corner(c,6) stroke(c,T.Border2)

        inst("TextLabel",{Size=UDim2.new(0.44,0,0,34),
            Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,
            Text=label,Font=Enum.Font.Gotham,TextSize=11,
            TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=c})

        local selLbl=inst("TextLabel",{
            Size=UDim2.new(0.56,-14,0,34),
            Position=UDim2.new(0.44,0,0,0),
            BackgroundTransparency=1,
            Text=(key and S[key]) or (options[1] or ""),
            Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Text,
            TextXAlignment=Enum.TextXAlignment.Right,Parent=c
        })
        inst("TextLabel",{Size=UDim2.new(0,16,0,34),
            Position=UDim2.new(1,-16,0,0),BackgroundTransparency=1,
            Text="v",Font=Enum.Font.GothamBold,TextSize=9,
            TextColor3=T.Dim,Parent=c})

        local listFrame=inst("Frame",{
            Size=UDim2.new(1,0,0,#options*26),
            Position=UDim2.new(0,0,0,34),
            BackgroundColor3=Color3.fromRGB(12,12,12),
            BorderSizePixel=0,Parent=c
        })
        stroke(listFrame,T.Border2)
        listLayout(listFrame,nil,0)

        local optBtns={}

        local function buildOptions(opts, newKey)
            for _,b in pairs(optBtns) do pcall(function() b:Destroy() end) end
            optBtns={}
            listFrame.Size=UDim2.new(1,0,0,#opts*26)
            selLbl.Text=(newKey and S[newKey]) or (opts[1] or "")
            for i,opt in ipairs(opts) do
                local ob=inst("TextButton",{
                    Size=UDim2.new(1,0,0,26),
                    BackgroundColor3=Color3.fromRGB(12,12,12),
                    Text=opt,Font=Enum.Font.Gotham,TextSize=11,
                    TextColor3=T.Sub,BorderSizePixel=0,
                    LayoutOrder=i,Parent=listFrame
                })
                ob.MouseButton1Click:Connect(function()
                    local k=newKey or key
                    if k then S[k]=opt end
                    selLbl.Text=opt
                    open=false
                    tw(c,{Size=UDim2.new(1,0,0,34)},0.15)
                    if cb then cb(opt) end
                end)
                ob.MouseEnter:Connect(function()
                    tw(ob,{TextColor3=T.Text,BackgroundColor3=Color3.fromRGB(22,22,22)})
                end)
                ob.MouseLeave:Connect(function()
                    tw(ob,{TextColor3=T.Sub,BackgroundColor3=Color3.fromRGB(12,12,12)})
                end)
                table.insert(optBtns,ob)
            end
        end

        buildOptions(options, key)

        inst("TextButton",{Size=UDim2.new(1,0,0,34),
            BackgroundTransparency=1,Text="",Parent=c
        }).MouseButton1Click:Connect(function()
            open=not open
            tw(c,{Size=UDim2.new(1,0,0,open and 34+#optBtns*26 or 34)},0.18,Enum.EasingStyle.Back)
        end)

        local function setOptions(opts, newKey)
            buildOptions(opts, newKey)
            if open then
                open=false
                tw(c,{Size=UDim2.new(1,0,0,34)},0.12)
            end
        end

        return c, selLbl, setOptions
    end

    local function infoRow(page, label, value, order)
        local row=inst("Frame",{
            Size=UDim2.new(1,0,0,30),BackgroundColor3=T.Panel2,
            BorderSizePixel=0,LayoutOrder=order,Parent=page
        })
        corner(row,6)
        inst("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=label,
            Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
        local vl=inst("TextLabel",{Size=UDim2.new(0.5,-10,1,0),
            Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,
            Text=tostring(value),Font=Enum.Font.GothamBold,TextSize=10,
            TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
        return vl
    end

    -- ════════════════════════════════════════
    --  TAB: AUTO FARM
    -- ════════════════════════════════════════
    local pFarm  = makePage("Farm")
    local goFarm = makeTab("Farm","  Farm",1)

    section(pFarm,"Smart Level Farm — Lv 1 to 2800",1)

    -- Live recommended mob display
    local recRow=inst("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=T.Panel2,
        BorderSizePixel=0,LayoutOrder=2,Parent=pFarm})
    corner(recRow,6) stroke(recRow,T.Border2)
    inst("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,Text="Your Level",
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=recRow})
    local recLbl=inst("TextLabel",{Size=UDim2.new(0.5,-10,1,0),
        Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,
        Text="Scanning...",Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=T.Gold,TextXAlignment=Enum.TextXAlignment.Right,Parent=recRow})

    task.spawn(function()
        while task.wait(4) do
            if not recLbl.Parent then break end
            local lv=getPlayerLevel()
            local rec=getMobForLevel(lv)
            recLbl.Text=tostring(lv).."  ->  "..rec
        end
    end)

    toggle(pFarm,"Auto Level Farm  (picks best mob for your level)","AutoLevelFarm",3,function(on)
        if on then
            S.AutoFarm=true
            local lv=getPlayerLevel()
            local mob=getMobForLevel(lv)
            S.TargetMob=mob
            notify("Auto Level Farm","Lv "..lv.." — Farming: "..mob,4,T.Gold)
            setStatus("Auto-Farm: "..mob)
        else
            S.AutoFarm=false
            setStatus("Idle")
            notify("Auto Level Farm","Stopped.")
        end
    end)

    section(pFarm,"Manual Farm",4)

    -- Sea and mob dropdowns — properly synced
    local _, seaSelLbl, setSeaOpts_unused = dropdown(pFarm,"Sea",
        {"Sea 1","Sea 2","Sea 3"}, nil, 5,
        function(seaName)
            -- Update mob dropdown options when sea changes
        end)
    -- We rebuild mob dropdown after sea changes via callback
    local mobDrop, mobSelLbl, setMobOptions = dropdown(pFarm,"Mob",SEA1_MOBS,"TargetMob",6)
    -- Now wire up the sea dropdown callback to update mob dropdown
    -- Use the dropdown's internal mechanism: find the option buttons and reconnect
    do
        local seaFrame = inst("Frame",{Size=UDim2.new(0,0,0,0),BackgroundTransparency=1,Parent=pFarm})
        -- Simpler approach: overlay a per-sea handler
    end
    -- Actually the cleanest fix: rebuild the sea dropdown with an inline cb
    -- Destroy the one we just made and make a fresh one
    seaSelLbl.Parent.Parent:Destroy()  -- destroy old sea dropdown frame from pFarm

    local _seaDrop = dropdown(pFarm,"Sea",{"Sea 1","Sea 2","Sea 3"},nil,5,function(seaName)
        local mobs = SEA_MOBS[seaName] or SEA1_MOBS
        setMobOptions(mobs,"TargetMob")
        S.TargetMob = mobs[1] or "Bandit"
        notify("Farm","Sea: "..seaName.." — mob list updated.")
    end)

    dropdown(pFarm,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",7)

    section(pFarm,"Toggles",8)
    toggle(pFarm,"Auto Farm","AutoFarm",9,function(on)
        if on then
            setStatus("Farm: "..(S.TargetMob or "?"))
            notify("Farm","Started — "..S.TargetMob,3.5,T.Blue)
        else
            setStatus("Idle")
            notify("Farm","Stopped.")
        end
    end)
    toggle(pFarm,"Auto Respawn","AutoRespawn",10)
    toggle(pFarm,"Safe Mode  (slower, anti-kick)","SafeMode",11,function(on)
        S.FarmDelay=on and 0.3 or 0.12
        notify("Safe Mode",on and "ON — slower but safer" or "OFF — max speed")
    end)
    toggle(pFarm,"Auto Quest","AutoQuest",12,function(on)
        notify("Auto Quest",on and "ON" or "OFF")
    end)
    toggle(pFarm,"Auto Collect Chest","AutoChest",13)
    toggle(pFarm,"Auto Eat Fruit","AutoEatFruit",14,function(on)
        notify("Auto Eat Fruit",on and "ON" or "OFF")
    end)

    section(pFarm,"Sea 1 — Quick Farm",15)
    for i,name in ipairs(SEA1_MOBS) do
        local info=nil
        for _,m in ipairs(MOBS) do if m.name==name and m.sea==1 then info=m break end end
        local tag=info and "  [Lv "..info.minLv.."-"..info.maxLv.."]" or ""
        button(pFarm,name..tag,T.Panel2,15+i,function()
            S.TargetMob=name S.AutoFarm=true S.AutoLevelFarm=false
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            setStatus("Farm: "..name)
            notify("Farm",name..tag,3,T.Blue)
        end)
    end

    section(pFarm,"Sea 2 — Quick Farm",40)
    for i,name in ipairs(SEA2_MOBS) do
        local info=nil
        for _,m in ipairs(MOBS) do if m.name==name and m.sea==2 then info=m break end end
        local tag=info and "  [Lv "..info.minLv.."-"..info.maxLv.."]" or ""
        button(pFarm,name..tag,T.Panel2,40+i,function()
            S.TargetMob=name S.AutoFarm=true S.AutoLevelFarm=false
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            setStatus("Farm: "..name)
            notify("Farm",name..tag,3,T.Blue)
        end)
    end

    section(pFarm,"Sea 3 — Quick Farm",80)
    for i,name in ipairs(SEA3_MOBS) do
        local info=nil
        for _,m in ipairs(MOBS) do if m.name==name and m.sea==3 then info=m break end end
        local tag=info and "  [Lv "..info.minLv.."-"..info.maxLv.."]" or ""
        button(pFarm,name..tag,T.Panel2,80+i,function()
            S.TargetMob=name S.AutoFarm=true S.AutoLevelFarm=false
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            setStatus("Farm: "..name)
            notify("Farm",name..tag,3,T.Blue)
        end)
    end

    button(pFarm,"STOP FARMING",Color3.fromRGB(38,18,18),140,function()
        S.AutoFarm=false S.AutoLevelFarm=false
        setStatus("Idle")
        notify("Farm","Stopped.",2.5,T.Red)
    end)

    -- ════════════════════════════════════════
    --  TAB: COMBAT
    -- ════════════════════════════════════════
    local pCbt=makePage("Combat")
    makeTab("Combat","  Combat",2)

    section(pCbt,"Kill Aura",1)
    toggle(pCbt,"Kill Aura","KillAura",2,function(on)
        notify("Kill Aura",on and "ON" or "OFF",2.5,on and T.Red or T.Sub)
    end)
    dropdown(pCbt,"Range (studs)",{"10","15","20","25","30","40","50","75","100"},nil,3,function(v)
        S.KillAuraRange=tonumber(v)
        notify("Kill Aura","Range: "..v.." studs")
    end)

    section(pCbt,"Movement",4)
    toggle(pCbt,"Fly  (WASD + Space / Ctrl)","FlyEnabled",5,function(on)
        notify("Fly",on and "ON  —  WASD, Space=up, Ctrl=down" or "OFF",3)
    end)
    dropdown(pCbt,"Fly Speed",{"20","40","60","80","100","150","200","250"},nil,6,function(v)
        S.FlySpeed=tonumber(v) notify("Fly","Speed: "..v)
    end)
    toggle(pCbt,"No Clip","NoClip",7,function(on) notify("No Clip",on and "ON" or "OFF",2.5) end)

    section(pCbt,"Defence",8)
    toggle(pCbt,"God Mode","GodMode",9,function(on)
        notify("God Mode",on and "ON — health locked at max" or "OFF",3,on and T.Gold or T.Sub)
    end)
    toggle(pCbt,"Infinite Jump","InfJump",10,function(on)
        notify("Infinite Jump",on and "ON" or "OFF",2.5)
    end)

    section(pCbt,"Walk Speed",11)
    for i,sp in ipairs({16,24,32,50,80,100,150,200}) do
        button(pCbt,"WalkSpeed "..sp,T.Panel2,11+i,function()
            S.WalkSpeed=sp
            local h=getHum() if h then h.WalkSpeed=sp end
            notify("Speed","-> "..sp)
        end)
    end

    section(pCbt,"Jump Power",22)
    for i,jp in ipairs({50,100,150,200,250,500}) do
        button(pCbt,"JumpPower "..jp,T.Panel2,22+i,function()
            S.JumpPower=jp
            local h=getHum() if h then h.JumpPower=jp end
            notify("Jump","-> "..jp)
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: TELEPORT
    -- ════════════════════════════════════════
    local pTP=makePage("TP")
    makeTab("Teleport","  Teleport",3)

    section(pTP,"Fruit Tracker",1)
    toggle(pTP,"Auto TP to Fruits","TPFruit",2)
    button(pTP,"Scan & TP Nearest Fruit",T.Panel2,3,function()
        local fruits=scanFruits()
        local root=getRoot()
        if not root then notify("Fruit","No character.",2.5,T.Red) return end
        if #fruits==0 then notify("Fruit","No fruits found in world.",2.5,T.Red) return end
        table.sort(fruits,function(a,b)
            return (a.pos-root.Position).Magnitude < (b.pos-root.Position).Magnitude
        end)
        tp(fruits[1].pos)
        STATS.fruitsTP=STATS.fruitsTP+1
        notify("Fruit","Teleported to: "..fruits[1].name,3.5,T.Green)
    end)

    section(pTP,"Sea 1 — Islands",4)
    for i,d in ipairs(SEA1_ISLANDS) do
        button(pTP,d[1],T.Panel2,4+i,function()
            tp(d[2]) notify("TP",">> "..d[1],2.5)
        end)
    end

    section(pTP,"Sea 2 — Islands",20)
    for i,d in ipairs(SEA2_ISLANDS) do
        button(pTP,d[1],T.Panel2,20+i,function()
            tp(d[2]) notify("TP",">> "..d[1],2.5)
        end)
    end

    section(pTP,"Sea 3 — Islands",38)
    for i,d in ipairs(SEA3_ISLANDS) do
        button(pTP,d[1],T.Panel2,38+i,function()
            tp(d[2]) notify("TP",">> "..d[1],2.5)
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: BOSS
    -- ════════════════════════════════════════
    local pBoss=makePage("Boss")
    makeTab("Boss","  Boss",4)

    local bossNames={}
    for k in pairs(BOSS_POS) do table.insert(bossNames,k) end
    table.sort(bossNames)

    section(pBoss,"Config",1)
    dropdown(pBoss,"Boss",bossNames,"SelectedBoss",2)

    section(pBoss,"Toggles",3)
    toggle(pBoss,"Auto Boss Farm","AutoBoss",4,function(on)
        if on then setStatus("Boss: "..S.SelectedBoss)
        else      setStatus("Idle") end
        notify("Boss Farm",on and "Started: "..S.SelectedBoss or "Stopped.",3,on and T.Gold or T.Sub)
    end)
    toggle(pBoss,"Auto Respawn","AutoRespawn",5)

    section(pBoss,"Actions",6)
    button(pBoss,"Start Auto Boss",T.Panel2,7,function()
        S.AutoBoss=true
        setStatus("Boss: "..S.SelectedBoss)
        notify("Boss","Auto Boss: "..S.SelectedBoss,3.5,T.Gold)
    end)
    button(pBoss,"Stop Boss Farm",Color3.fromRGB(38,18,18),8,function()
        S.AutoBoss=false setStatus("Idle")
        notify("Boss","Stopped.",2.5,T.Red)
    end)
    button(pBoss,"TP to Boss Now",T.Panel2,9,function()
        local pos=BOSS_POS[S.SelectedBoss]
        if pos then tp(pos) notify("Boss",">> "..S.SelectedBoss,2.5,T.Gold)
        else
            local m=findMob(S.SelectedBoss,99999)
            if m then
                local h=m:FindFirstChild("HumanoidRootPart")
                if h then tp(h.Position) notify("Boss",">> "..m.Name,2.5,T.Gold) end
            else notify("Boss","Boss not spawned yet.",2.5,T.Red) end
        end
    end)

    section(pBoss,"Quick Boss TP",10)
    for i,name in ipairs(bossNames) do
        button(pBoss,name,T.Panel2,10+i,function()
            S.SelectedBoss=name
            local pos=BOSS_POS[name]
            if pos then tp(pos) notify("Boss",">> "..name,2.5,T.Gold) end
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: RAID
    -- ════════════════════════════════════════
    local pRaid=makePage("Raid")
    makeTab("Raid","  Raid",5)

    local raidNames={}
    for k in pairs(RAID_POS) do table.insert(raidNames,k) end
    table.sort(raidNames)

    section(pRaid,"Config",1)
    dropdown(pRaid,"Raid Type",raidNames,"SelectedRaid",2)

    section(pRaid,"Toggles",3)
    toggle(pRaid,"Auto Raid","AutoRaid",4,function(on)
        if on then setStatus("Raid: "..S.SelectedRaid)
        else      setStatus("Idle") end
        notify("Auto Raid",on and "Started: "..S.SelectedRaid or "Stopped.",3,on and T.Purple or T.Sub)
    end)
    toggle(pRaid,"Auto Respawn","AutoRespawn",5)

    section(pRaid,"Actions",6)
    button(pRaid,"Start Auto Raid",T.Panel2,7,function()
        S.AutoRaid=true setStatus("Raid: "..S.SelectedRaid)
        notify("Raid","Auto Raid: "..S.SelectedRaid,3.5,T.Purple)
    end)
    button(pRaid,"Stop Raid",Color3.fromRGB(38,18,18),8,function()
        S.AutoRaid=false setStatus("Idle")
        notify("Raid","Stopped.",2.5,T.Red)
    end)
    button(pRaid,"TP to Raid Island",T.Panel2,9,function()
        local pos=RAID_POS[S.SelectedRaid]
        if pos then tp(pos) notify("Raid",">> "..S.SelectedRaid,2.5,T.Purple) end
    end)

    section(pRaid,"All Raids",10)
    for i,name in ipairs(raidNames) do
        button(pRaid,name,T.Panel2,10+i,function()
            S.SelectedRaid=name
            tp(RAID_POS[name])
            notify("Raid",">> "..name,2.5,T.Purple)
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: VISUAL
    -- ════════════════════════════════════════
    local pVis=makePage("Visual")
    makeTab("Visual","  Visual",6)

    section(pVis,"ESP",1)
    infoRow(pVis,"Engine",HAS_DRAW and "Drawing (high perf)" or "BillboardGui fallback",2)
    toggle(pVis,"Player ESP","PlayerESP",3,function(on)
        notify("Player ESP",on and "ON" or "OFF",2.5)
    end)
    toggle(pVis,"Mob ESP","MobESP",4,function(on)
        notify("Mob ESP",on and "ON" or "OFF",2.5)
    end)
    toggle(pVis,"Fruit ESP","FruitESP",5,function(on)
        notify("Fruit ESP",on and "ON" or "OFF",2.5)
    end)

    section(pVis,"World",6)
    toggle(pVis,"Fullbright","Fullbright",7,function(on)
        Lighting.Brightness=on and 8 or 1
        Lighting.GlobalShadows=not on
        notify("Fullbright",on and "ON" or "OFF",2.5)
    end)
    toggle(pVis,"No Fog","NoFog",8,function(on)
        Lighting.FogEnd=on and 1e8 or 100000
        notify("Fog",on and "Removed" or "Restored",2.5)
    end)

    section(pVis,"Field of View",9)
    for i,fov in ipairs({60,70,90,100,110,120,130}) do
        button(pVis,"FOV "..fov,T.Panel2,9+i,function()
            S.FOV=fov Camera.FieldOfView=fov
            notify("FOV","Set to "..fov,2)
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: STATS
    -- ════════════════════════════════════════
    local pStats=makePage("Stats")
    makeTab("Stats","  Stats",7)

    section(pStats,"Session",1)
    local killsLbl  = infoRow(pStats,"Kills",   "0",2)
    local deathsLbl = infoRow(pStats,"Deaths",  "0",3)
    local fruitLbl  = infoRow(pStats,"Fruit TPs","0",4)
    local chestLbl  = infoRow(pStats,"Chests",  "0",5)
    local questLbl  = infoRow(pStats,"Quests",  "0",6)
    local timeLbl   = infoRow(pStats,"Time",    "0m 00s",7)
    local kpmLbl    = infoRow(pStats,"Kills/min","0.0",8)

    RunService.Heartbeat:Connect(wrap(function()
        if not killsLbl.Parent then return end
        killsLbl.Text  = tostring(STATS.kills)
        deathsLbl.Text = tostring(STATS.deaths)
        fruitLbl.Text  = tostring(STATS.fruitsTP)
        chestLbl.Text  = tostring(STATS.chestsTP)
        questLbl.Text  = tostring(STATS.quests)
        local e  = os.time()-STATS.startTime
        timeLbl.Text = string.format("%dm %02ds",math.floor(e/60),e%60)
        local mins=math.max(e/60,0.017)
        kpmLbl.Text=string.format("%.1f",STATS.kills/mins)
    end))

    section(pStats,"Player",9)
    infoRow(pStats,"Name",        LP.Name,10)
    infoRow(pStats,"DisplayName", LP.DisplayName,11)
    infoRow(pStats,"UserId",      tostring(LP.UserId),12)
    infoRow(pStats,"Executor",    IS_DELTA and "Delta (optimized)" or EXEC_NAME,13)
    local lvLbl=infoRow(pStats,"Level","...",14)
    task.spawn(function()
        while task.wait(5) do
            if not lvLbl.Parent then break end
            lvLbl.Text=tostring(getPlayerLevel())
        end
    end)

    button(pStats,"Reset Stats",T.Panel2,15,function()
        STATS.kills=0 STATS.deaths=0 STATS.fruitsTP=0
        STATS.chestsTP=0 STATS.quests=0 STATS.startTime=os.time()
        notify("Stats","Reset.",2,T.Sub)
    end)

    -- ════════════════════════════════════════
    --  TAB: SETTINGS
    -- ════════════════════════════════════════
    local pSet=makePage("Settings")
    makeTab("Settings","  Settings",8)

    section(pSet,"Info",1)
    infoRow(pSet,"Version",   "v1.0.0",2)
    infoRow(pSet,"Executor",  IS_DELTA and "Delta (optimized)" or EXEC_NAME,3)
    infoRow(pSet,"Drawing",   HAS_DRAW and "Active" or "Fallback",4)
    infoRow(pSet,"Toggle Key","RightShift — hide/show",5)

    section(pSet,"Performance",6)
    toggle(pSet,"FPS Counter","ShowFPS",7)
    toggle(pSet,"Anti AFK",   "AntiAFK",8)
    toggle(pSet,"Watermark",  "ShowWatermark",9)

    section(pSet,"Config",10)
    if HAS_WRITEFILE then
        button(pSet,"Save Config",T.Panel2,11,function()
            saveConfig(S)
            notify("Config","Saved to "..CFG_PATH,3,T.Green)
        end)
        button(pSet,"Load Config",T.Panel2,12,function()
            local d=loadConfig()
            for k,v in pairs(d) do S[k]=v end
            notify("Config","Loaded!",3,T.Green)
        end)
        button(pSet,"Reset to Defaults",T.Panel2,13,function()
            local d=cfgDefault()
            for k,v in pairs(d) do S[k]=v end
            notify("Config","Reset to defaults.",2.5)
        end)
    else
        infoRow(pSet,"Config","writefile not available",11)
    end

    section(pSet,"Server",14)
    button(pSet,"Rejoin Server",T.Panel2,15,function()
        pcall(function() TeleportService:Teleport(game.PlaceId,LP) end)
    end)
    button(pSet,"Server Hop",T.Panel2,16,function()
        local found=false
        pcall(function()
            local hs=game:GetService("HttpService")
            local data=hs:JSONDecode(hs:GetAsync(
                "https://games.roproxy.com/v1/games/"..game.PlaceId..
                "/servers/Public?sortOrder=Asc&limit=10"))
            if data and data.data then
                for _,srv in pairs(data.data) do
                    if srv.id~=game.JobId and srv.playing<srv.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,LP)
                        found=true break
                    end
                end
            end
        end)
        if not found then notify("Server Hop","No different server found.",3,T.Red) end
    end)

    section(pSet,"Discord",17)
    infoRow(pSet,"Server","discord.gg/EmsMsHZCVH",18)
    button(pSet,"Copy Discord Link",T.Panel2,19,function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        notify("Discord","Link copied to clipboard!",2.5,T.Blue)
    end)

    section(pSet,"Misc",20)
    button(pSet,"Reload GUI",T.Panel2,21,function()
        sg:Destroy() task.wait(0.1) buildGUI()
    end)

    goFarm()
    return sg
end

-- ════════════════════════════════════════
--  FPS COUNTER
-- ════════════════════════════════════════
local function startFPS()
    pcall(function() PG:FindFirstChild("_EHF"):Destroy() end)
    local sg=inst("ScreenGui",{Name="_EHF",ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    local f=inst("Frame",{Size=UDim2.new(0,82,0,22),
        Position=UDim2.new(1,-88,0,7),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg})
    corner(f,5) stroke(f,T.Border2)
    local dot=inst("Frame",{Size=UDim2.new(0,6,0,6),
        Position=UDim2.new(0,7,0.5,-3),
        BackgroundColor3=T.Green,BorderSizePixel=0,Parent=f})
    corner(dot,3)
    local lbl=inst("TextLabel",{Size=UDim2.new(1,-18,1,0),
        Position=UDim2.new(0,17,0,0),BackgroundTransparency=1,
        Text="FPS --",Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local fr,lt=0,tick()
    RunService.RenderStepped:Connect(wrap(function()
        sg.Enabled=S.ShowFPS
        fr=fr+1
        local n=tick()
        if n-lt>=0.5 then
            local fps=math.floor(fr/(n-lt))
            lbl.Text="FPS "..fps
            dot.BackgroundColor3=fps>=55 and T.Green or fps>=30 and T.Gold or T.Red
            fr,lt=0,n
        end
    end))
end

-- ════════════════════════════════════════
--  ANTI AFK
-- ════════════════════════════════════════
local function startAntiAFK()
    task.spawn(function()
        while task.wait(48) do
            if not S.AntiAFK then continue end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            local h=getHum()
            if h then
                h:Move(Vector3.new(0.1,0,0),true)
                task.wait(0.05)
                h:Move(Vector3.new(0,0,0),true)
            end
        end
    end)
end

-- ════════════════════════════════════════
--  INFINITE JUMP
-- ════════════════════════════════════════
UserInputService.JumpRequest:Connect(function()
    if S.InfJump then
        local h=getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ════════════════════════════════════════
--  FLY  (BodyVelocity / BodyAngularVelocity)
-- ════════════════════════════════════════
local flyBV, flyBA
task.spawn(function()
    while task.wait(0) do
        local root=getRoot()
        if S.FlyEnabled and root then
            if not flyBV or not flyBV.Parent then
                -- Clean up any stale instances
                if flyBV then pcall(function() flyBV:Destroy() end) flyBV=nil end
                if flyBA then pcall(function() flyBA:Destroy() end) flyBA=nil end

                flyBV=Instance.new("BodyVelocity")
                flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
                flyBV.Velocity=Vector3.zero
                flyBV.Parent=root

                flyBA=Instance.new("BodyAngularVelocity")
                flyBA.MaxTorque=Vector3.new(1e5,1e5,1e5)
                flyBA.AngularVelocity=Vector3.zero
                flyBA.Parent=root

                local h=getHum()
                if h then h.PlatformStand=true end
            end

            local dir=Vector3.zero
            local spd=S.FlySpeed or 60
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir=dir+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or UserInputService:IsKeyDown(Enum.KeyCode.C) then dir=dir-Vector3.new(0,1,0) end

            flyBV.Velocity = dir.Magnitude>0 and dir.Unit*spd or Vector3.zero
        else
            if flyBV and flyBV.Parent then
                pcall(function() flyBV:Destroy() end) flyBV=nil
                pcall(function() flyBA:Destroy() end) flyBA=nil
                local h=getHum()
                if h then h.PlatformStand=false end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  NO CLIP
-- ════════════════════════════════════════
RunService.Stepped:Connect(wrap(function()
    if not S.NoClip then return end
    local char=getChar() if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
    end
end))

-- ════════════════════════════════════════
--  GOD MODE
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(0.07) do
        if not S.GodMode then continue end
        local h=getHum()
        if h and h.Health>0 then pcall(function() h.Health=h.MaxHealth end) end
    end
end)

-- ════════════════════════════════════════
--  AUTO RESPAWN  +  apply stats after spawn
-- (FIX: first CharacterAdded NOT counted as death)
-- ════════════════════════════════════════
if LP.Character then STATS.charLoaded=true end
LP.CharacterAdded:Connect(function()
    if not STATS.charLoaded then
        STATS.charLoaded=true
        -- first spawn — apply config settings then exit
        task.wait(1)
        local h=getHum()
        if h then h.WalkSpeed=S.WalkSpeed or 16 h.JumpPower=S.JumpPower or 50 end
        return
    end
    -- real death/respawn
    STATS.deaths=STATS.deaths+1
    if S.AutoRespawn then
        task.wait(1.5)
        notify("Respawned","Back — resuming...",2.5,T.Green)
    end
    task.wait(1)
    local h=getHum()
    if h then h.WalkSpeed=S.WalkSpeed or 16 h.JumpPower=S.JumpPower or 50 end
end)

-- ════════════════════════════════════════
--  AUTO FARM LOOP
-- (FIX: kills counted only on confirmed death;
--       proper respawn wait; level auto-progress)
-- ════════════════════════════════════════
task.spawn(function()
    local notifiedWait=false
    while true do
        task.wait(S.FarmDelay or 0.12)
        if not S.AutoFarm then notifiedWait=false continue end
        if not isAlive() then
            if S.AutoRespawn then task.wait(3) end
            continue
        end

        -- Auto level progression
        if S.AutoLevelFarm then
            local lv=getPlayerLevel()
            local best=getMobForLevel(lv)
            if S.TargetMob~=best then
                S.TargetMob=best
                setStatus("Auto-Farm: "..best)
                notify("Level Up!","Lv "..lv.." — now farming: "..best,4,T.Gold)
                local sp=MOB_SPAWN[best]
                if sp then tp(sp) task.wait(2) end
                notifiedWait=false
            end
        end

        local mob=findMob(S.TargetMob, 9999)
        if mob then
            notifiedWait=false
            local killed=attack(mob)
            if killed then STATS.kills=STATS.kills+1 end
        else
            local sp=MOB_SPAWN[S.TargetMob]
            if sp then
                local root=getRoot()
                if root and (root.Position-sp).Magnitude>100 then tp(sp) end
            end
            if not notifiedWait then
                notifiedWait=true
                notify("Farm","Waiting for "..S.TargetMob.." to spawn...",3,T.Gold)
            end
            task.wait(S.SafeMode and 2.5 or 1.5)
        end
    end
end)

-- ════════════════════════════════════════
--  KILL AURA LOOP
-- (FIX: kill only counted on confirmed death)
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(0.08) do
        if not S.KillAura then continue end
        if not isAlive() then continue end
        local root=getRoot() if not root then continue end
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.KillAura then break end
            if obj:IsA("Model") and obj~=getChar()
            and not Players:GetPlayerFromCharacter(obj) then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health>0 then
                    if (hrp.Position-root.Position).Magnitude<=(S.KillAuraRange or 25) then
                        if HAS_FTI then
                            pcall(firetouchinterest,hrp,root,0)
                            task.wait(0.02)
                            pcall(firetouchinterest,hrp,root,1)
                        end
                        pcall(function() hum:TakeDamage(9999) end)
                        task.wait(0.04)
                        if isDead(obj) then STATS.kills=STATS.kills+1 end
                    end
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  AUTO BOSS LOOP
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoBoss then continue end
        if not isAlive() then if S.AutoRespawn then task.wait(3) end continue end
        local boss=findMob(S.SelectedBoss, 9999)
        if boss then
            local killed=attack(boss)
            if killed then STATS.kills=STATS.kills+1 end
        else
            local pos=BOSS_POS[S.SelectedBoss]
            if pos then
                local root=getRoot()
                if root and (root.Position-pos).Magnitude>200 then tp(pos) task.wait(2) end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  AUTO RAID LOOP
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(0.18) do
        if not S.AutoRaid then continue end
        if not isAlive() then if S.AutoRespawn then task.wait(3) end continue end
        local rp=RAID_POS[S.SelectedRaid]
        local root=getRoot()
        if root and rp and (root.Position-rp).Magnitude>200 then
            tp(rp) task.wait(1.5)
        end
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.AutoRaid then break end
            if obj:IsA("Model") and obj~=getChar()
            and not Players:GetPlayerFromCharacter(obj) then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                local r2=getRoot()
                if hum and hrp and r2 and hum.Health>0
                and (hrp.Position-r2.Position).Magnitude<350 then
                    local killed=attack(obj)
                    if killed then STATS.kills=STATS.kills+1 end
                    task.wait(0.07)
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  FRUIT TP LOOP  +  Auto Eat
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(4) do
        if not S.TPFruit then continue end
        if not isAlive() then continue end
        local fruits=scanFruits()
        local root=getRoot()
        if root and #fruits>0 then
            table.sort(fruits,function(a,b)
                return (a.pos-root.Position).Magnitude < (b.pos-root.Position).Magnitude
            end)
            local f=fruits[1]
            tp(f.pos)
            STATS.fruitsTP=STATS.fruitsTP+1
            notify("Fruit TP","Found: "..f.name,3,T.Green)
            if S.AutoEatFruit and HAS_FTI and f.part then
                task.wait(0.3)
                local r2=getRoot()
                if r2 then
                    pcall(firetouchinterest,f.part,r2,0)
                    task.wait(0.1)
                    pcall(firetouchinterest,f.part,r2,1)
                end
            end
        end
    end
end)

-- Auto Eat nearby fruits independently
task.spawn(function()
    while task.wait(2) do
        if not S.AutoEatFruit then continue end
        if not isAlive() then continue end
        local fruits=scanFruits()
        local root=getRoot()
        if root and #fruits>0 then
            table.sort(fruits,function(a,b)
                return (a.pos-root.Position).Magnitude < (b.pos-root.Position).Magnitude
            end)
            local f=fruits[1]
            if (f.pos-root.Position).Magnitude<30 and HAS_FTI and f.part then
                local r2=getRoot()
                if r2 then
                    pcall(firetouchinterest,f.part,r2,0)
                    task.wait(0.1)
                    pcall(firetouchinterest,f.part,r2,1)
                    notify("Auto Eat","Ate: "..f.name,2,T.Green)
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  AUTO COLLECT CHEST LOOP
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(3) do
        if not S.AutoChest then continue end
        if not isAlive() then continue end
        local chests=scanChests()
        local root=getRoot()
        if root and #chests>0 then
            table.sort(chests,function(a,b)
                return (a.pos-root.Position).Magnitude < (b.pos-root.Position).Magnitude
            end)
            local c=chests[1]
            tp(c.pos)
            if HAS_FTI and c.part then
                local r2=getRoot()
                if r2 then
                    pcall(firetouchinterest,c.part,r2,0)
                    task.wait(0.1)
                    pcall(firetouchinterest,c.part,r2,1)
                    STATS.chestsTP=STATS.chestsTP+1
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  AUTO QUEST LOOP
-- (FIX: was completely missing, now implemented)
-- ════════════════════════════════════════
task.spawn(function()
    while task.wait(6) do
        if not S.AutoQuest then continue end
        if not isAlive() then continue end
        -- Search for quest-related NPCs / boards
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.AutoQuest then break end
            local n=obj.Name:lower()
            if n:find("quest",1,true) or n:find("board",1,true) then
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                    or (obj:IsA("BasePart") and obj)
                    or obj:FindFirstChildWhichIsA("BasePart")
                if hrp then
                    local root=getRoot()
                    if root then
                        local pos=(hrp:IsA("BasePart") and hrp.Position or hrp.Position)
                        if (pos-root.Position).Magnitude>20 then
                            tp(pos) task.wait(1)
                        end
                        -- Touch
                        if HAS_FTI then
                            local r2=getRoot()
                            local part=hrp:IsA("BasePart") and hrp or hrp:FindFirstChildWhichIsA("BasePart")
                            if r2 and part then
                                pcall(firetouchinterest,part,r2,0)
                                task.wait(0.1)
                                pcall(firetouchinterest,part,r2,1)
                            end
                        end
                        -- Fire any RemoteEvent
                        for _,v in pairs(obj:GetDescendants()) do
                            if v:IsA("RemoteEvent") then
                                pcall(function() v:FireServer() end)
                            end
                        end
                        STATS.quests=STATS.quests+1
                        notify("Quest","Accepted quest!",2.5,T.Gold)
                        break
                    end
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  TOGGLE KEY  (RightShift = show/hide)
-- ════════════════════════════════════════
local _guiRef
UserInputService.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        if _guiRef and _guiRef.Parent then
            local w=_guiRef:FindFirstChildWhichIsA("Frame")
            if w then w.Visible=not w.Visible end
        end
    end
end)

-- ════════════════════════════════════════
--  DISCORD POPUP
-- ════════════════════════════════════════
local function discordPopup()
    task.wait(4.5)
    local sg=inst("ScreenGui",{Name="_EHD",ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    local f=inst("Frame",{
        Size=UDim2.new(0,308,0,136),
        Position=UDim2.new(0.5,-154,1,10),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg
    })
    corner(f,10)
    stroke(f,T.Blue,1.5)
    -- Top blue accent
    inst("Frame",{Size=UDim2.new(1,0,0,2),
        BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=f})

    local icon=inst("Frame",{Size=UDim2.new(0,38,0,38),
        Position=UDim2.new(0,14,0,16),
        BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=f})
    corner(icon,19)
    inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        Text="D",Font=Enum.Font.GothamBlack,TextSize=20,
        TextColor3=Color3.new(1,1,1),Parent=icon})

    inst("TextLabel",{Size=UDim2.new(1,-70,0,20),
        Position=UDim2.new(0,62,0,14),BackgroundTransparency=1,
        Text="Join Elite Hub Discord",
        Font=Enum.Font.GothamBlack,TextSize=13,TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    inst("TextLabel",{Size=UDim2.new(1,-70,0,22),
        Position=UDim2.new(0,62,0,36),BackgroundTransparency=1,
        Text="Updates, support & new features",
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=f})

    local lf=inst("Frame",{Size=UDim2.new(1,-22,0,26),
        Position=UDim2.new(0,11,0,74),
        BackgroundColor3=Color3.fromRGB(10,10,10),BorderSizePixel=0,Parent=f})
    corner(lf,5) stroke(lf,T.Border2)
    inst("TextLabel",{Size=UDim2.new(1,-12,1,0),
        Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,
        Text="discord.gg/EmsMsHZCVH",
        Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Blue,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=lf})

    local cp=inst("TextButton",{Size=UDim2.new(0,78,0,26),
        Position=UDim2.new(0,11,1,-36),
        BackgroundColor3=T.Blue,Text="Copy Link",
        Font=Enum.Font.GothamBold,TextSize=11,
        TextColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=f})
    corner(cp)
    cp.MouseButton1Click:Connect(function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        cp.Text="Copied!" task.wait(1.5) cp.Text="Copy Link"
    end)

    local xb=inst("TextButton",{Size=UDim2.new(0,22,0,22),
        Position=UDim2.new(1,-28,0,8),
        BackgroundColor3=T.Dim,Text="x",
        Font=Enum.Font.GothamBold,TextSize=12,
        TextColor3=T.Sub,BorderSizePixel=0,Parent=f})
    corner(xb,11)
    xb.MouseButton1Click:Connect(function()
        tw(f,{Position=UDim2.new(0.5,-154,1,10)},0.25)
        task.wait(0.3) sg:Destroy()
    end)

    tw(f,{Position=UDim2.new(0.5,-154,1,-148)},0.38,Enum.EasingStyle.Back)
    task.delay(16,function()
        if sg.Parent then
            tw(f,{Position=UDim2.new(0.5,-154,1,10)},0.25)
            task.wait(0.3) pcall(function() sg:Destroy() end)
        end
    end)
end

-- ════════════════════════════════════════
--  WATERMARK
-- ════════════════════════════════════════
local function buildWatermark()
    pcall(function() PG:FindFirstChild("_EHW"):Destroy() end)
    local sg=inst("ScreenGui",{Name="_EHW",ResetOnSpawn=false,Parent=PG})
    local f=inst("Frame",{
        Size=UDim2.new(0,248,0,22),
        Position=UDim2.new(0,6,0,6),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg
    })
    corner(f,4) stroke(f,T.Border2)
    inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        Text="Elite Hub v1.0.0  |  discord.gg/EmsMsHZCVH",
        Font=Enum.Font.GothamBold,TextSize=8.5,TextColor3=T.Sub,Parent=f})
    RunService.Heartbeat:Connect(wrap(function()
        if sg.Parent then sg.Enabled=S.ShowWatermark end
    end))
end

-- ════════════════════════════════════════
--  BOOT SEQUENCE
-- ════════════════════════════════════════
task.spawn(function()
    showLoader()
    task.wait(0.1)
    _guiRef = buildGUI()
    startFPS()
    startAntiAFK()
    buildWatermark()
    if HAS_DRAW then startDrawESP() end
    task.wait(0.3)
    local tag = IS_DELTA and "  [Delta]" or ""
    notify("Elite Hub v1.0.0",
        "Loaded"..tag.."  —  RShift to toggle",3.5,T.Accent)
    task.defer(discordPopup)
end)

print("╔═════════════════════════════════════════╗")
print("║  Elite Hub v1.0.0  |  Blox Fruits      ║")
print("║  All Seas  |  Lv 1 - 2800              ║")
print("║  Delta-Optimized                        ║")
print("║  discord.gg/EmsMsHZCVH                 ║")
print("╚═════════════════════════════════════════╝")
if IS_DELTA then
    print("[EliteHub] Delta — Drawing ESP + firetouchinterest + writefile active.")
end
