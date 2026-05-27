-- ╔══════════════════════════════════════════════╗
-- ║   ELITE HUB  v1.0.0                         ║
-- ║   Blox Fruits  |  All Seas  |  Lv 1 - 2800  ║
-- ║   Optimized for Delta Executor               ║
-- ║   discord.gg/EmsMsHZCVH                      ║
-- ╚══════════════════════════════════════════════╝

-- ════════════════════════════════════════
--  EXECUTOR DETECTION & SAFETY CHECK
--  (FIX: kicks self if running on Xeno or Solara)
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
    end
end)

local EXEC_LOWER = EXEC_NAME:lower()
IS_DELTA = EXEC_LOWER:find("delta") ~= nil

-- Rat executor check — auto-kick if on Xeno or Solara
if EXEC_LOWER:find("xeno") or EXEC_LOWER:find("solara") then
    pcall(function()
        local Players = game:GetService("Players")
        Players.LocalPlayer:Kick(
            "Elite Hub: Xeno and Solara are known rat executors. "..
            "Please use Delta, Fluxus, or another safe executor."
        )
    end)
    return  -- stop script execution entirely
end

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
local LP               = Players.LocalPlayer
local Mouse            = LP:GetMouse()
local PG               = LP:WaitForChild("PlayerGui")
local Camera           = workspace.CurrentCamera

-- Player identity
local DISPLAY_NAME = LP.DisplayName or LP.Name
local USERNAME     = "@"..LP.Name

-- ════════════════════════════════════════
--  CONFIG
-- ════════════════════════════════════════
local CFG_PATH = "EliteHub_v1_config.json"

local function cfgDefault()
    return {
        AutoFarm=false,    TargetMob="Bandit", FarmMethod="Melee",
        SafeMode=false,    FarmDelay=0.12,
        AutoLevelFarm=false,
        AutoBoss=false,    SelectedBoss="Gorilla King",
        AutoRaid=false,    SelectedRaid="Flame",
        TPFruit=false,     AutoChest=false,
        AutoQuest=false,   AutoEatFruit=false,
        KillAura=false,    KillAuraRange=25,
        FlyEnabled=false,  FlySpeed=60,
        NoClip=false,      GodMode=false,
        AntiAFK=true,      AutoRespawn=true, InfJump=false,
        ShowFPS=true,      ShowWatermark=true,
        PlayerESP=false,   MobESP=false, FruitESP=false,
        Fullbright=false,  NoFog=false,  FOV=70,
        WalkSpeed=16,      JumpPower=50,
    }
end

local function toJSON(data)
    local out = {}
    for k, v in pairs(data) do
        local val
        if     type(v)=="boolean" then val = v and "true" or "false"
        elseif type(v)=="number"  then val = tostring(v)
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
            local v = raw:match('"'..k..'":%s*(.-)%s*[,}%]]')
            if v then
                v = v:match("^%s*(.-)%s*$")
                if     v=="true"   then d[k]=true
                elseif v=="false"  then d[k]=false
                elseif tonumber(v) then d[k]=tonumber(v)
                else d[k]=v:gsub('^"',''):gsub('"$','') end
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

local _savePending = false
local function scheduleSave()
    if _savePending then return end
    _savePending = true
    task.delay(1.5, function() _savePending=false saveConfig(S) end)
end

-- ════════════════════════════════════════
--  MOB DATABASE
-- ════════════════════════════════════════
local MOBS = {
    {sea=1,name="Bandit",              minLv=1,   maxLv=14,  pos=Vector3.new(   979,125,  1570)},
    {sea=1,name="Monkey",              minLv=15,  maxLv=29,  pos=Vector3.new( -1500,125,  -200)},
    {sea=1,name="Gorilla",             minLv=30,  maxLv=59,  pos=Vector3.new( -1700,125,  -310)},
    {sea=1,name="Pirate",              minLv=60,  maxLv=99,  pos=Vector3.new( -1200,125,  4350)},
    {sea=1,name="Brute",               minLv=100, maxLv=124, pos=Vector3.new( -1100,125,  4500)},
    {sea=1,name="Desert Bandit",       minLv=125, maxLv=149, pos=Vector3.new(   870,125,  4000)},
    {sea=1,name="Desert Officer",      minLv=150, maxLv=174, pos=Vector3.new(  1050,125,  4200)},
    {sea=1,name="Snow Bandit",         minLv=175, maxLv=199, pos=Vector3.new(  1200,125, -2700)},
    {sea=1,name="Snowman",             minLv=200, maxLv=249, pos=Vector3.new(  1300,125, -2850)},
    {sea=1,name="Marine",              minLv=250, maxLv=299, pos=Vector3.new(  -900,125,  -350)},
    {sea=1,name="Sky Bandit",          minLv=300, maxLv=374, pos=Vector3.new( -4700,875,  -700)},
    {sea=1,name="Dark Master",         minLv=375, maxLv=449, pos=Vector3.new( -4950,1410, -700)},
    {sea=1,name="Toga Warrior",        minLv=450, maxLv=624, pos=Vector3.new(  3324,127, -2640)},
    {sea=1,name="Carpenter",           minLv=60,  maxLv=99,  pos=Vector3.new( -1190,125,  4380)},
    {sea=2,name="Hoodlum",             minLv=625, maxLv=699, pos=Vector3.new(  -750,266,   550)},
    {sea=2,name="Trader",              minLv=700, maxLv=774, pos=Vector3.new(  -900,266,   650)},
    {sea=2,name="Forest Pirate",       minLv=775, maxLv=849, pos=Vector3.new( -3550,125,  1850)},
    {sea=2,name="Factory Staff",       minLv=850, maxLv=924, pos=Vector3.new( -3300,125,  2000)},
    {sea=2,name="Zombie",              minLv=925, maxLv=999, pos=Vector3.new( -5800,125,  -620)},
    {sea=2,name="Vampire",             minLv=1000,maxLv=1049,pos=Vector3.new( -5900,125,  -700)},
    {sea=2,name="Living Zombie",       minLv=1050,maxLv=1099,pos=Vector3.new( -5950,125,  -750)},
    {sea=2,name="Demonic Soul",        minLv=1100,maxLv=1174,pos=Vector3.new( -5200,125, -1720)},
    {sea=2,name="Ship Crew",           minLv=1175,maxLv=1249,pos=Vector3.new( -5200,125, -1780)},
    {sea=2,name="Cursed Pirate",       minLv=1250,maxLv=1324,pos=Vector3.new( -5300,125, -1800)},
    {sea=2,name="Military Soldier",    minLv=1325,maxLv=1399,pos=Vector3.new(-10000,125, -2000)},
    {sea=2,name="Military Spy",        minLv=1325,maxLv=1399,pos=Vector3.new( -9800,125, -1900)},
    {sea=2,name="Assassin",            minLv=1400,maxLv=1474,pos=Vector3.new( -9500,125, -1700)},
    {sea=2,name="Arctic Warrior",      minLv=1475,maxLv=1549,pos=Vector3.new( -4300,1000,-1000)},
    {sea=2,name="Snow Lurker",         minLv=1550,maxLv=1624,pos=Vector3.new( -4600,1020,-1100)},
    {sea=2,name="Snow Demon",          minLv=1625,maxLv=1699,pos=Vector3.new( -4500,1010,-1050)},
    {sea=2,name="Dragon Crew Warrior", minLv=1700,maxLv=1774,pos=Vector3.new(  3600,125, 29450)},
    {sea=2,name="Dragon Crew Archer",  minLv=1775,maxLv=1849,pos=Vector3.new(  3700,125, 29550)},
    {sea=2,name="Swan Pirate",         minLv=1850,maxLv=1924,pos=Vector3.new(   880,125, 29250)},
    {sea=2,name="Poseidon Soldier",    minLv=1925,maxLv=1999,pos=Vector3.new( 61350,125,  1780)},
    {sea=2,name="Poseidon Knight",     minLv=2000,maxLv=2099,pos=Vector3.new( 61450,125,  1850)},
    {sea=3,name="Galley Pirate",       minLv=1500,maxLv=1574,pos=Vector3.new( -2000, 50, -4200)},
    {sea=3,name="Pirate Millionaire",  minLv=1575,maxLv=1649,pos=Vector3.new( -2100, 50, -4300)},
    {sea=3,name="Jungle Bug",          minLv=1650,maxLv=1724,pos=Vector3.new( -3200,125, -3800)},
    {sea=3,name="Laboon",              minLv=1725,maxLv=1799,pos=Vector3.new( -3350,125, -3950)},
    {sea=3,name="Forest Dragon",       minLv=1800,maxLv=1874,pos=Vector3.new( -9000,400, -2500)},
    {sea=3,name="Tree Spider",         minLv=1875,maxLv=1949,pos=Vector3.new( -9100,400, -2600)},
    {sea=3,name="Reborn Skeleton",     minLv=1950,maxLv=2049,pos=Vector3.new(-11400,400, -1000)},
    {sea=3,name="Cursed Skeleton",     minLv=2050,maxLv=2124,pos=Vector3.new(-11500,400, -1040)},
    {sea=3,name="Soul Reaper",         minLv=2125,maxLv=2199,pos=Vector3.new(-11600,400, -1080)},
    {sea=3,name="Demonic Soul",        minLv=2200,maxLv=2274,pos=Vector3.new( -6600,125, -2750)},
    {sea=3,name="Diablo",              minLv=2275,maxLv=2349,pos=Vector3.new( -8300,125,  1600)},
    {sea=3,name="Beautiful Pirate",    minLv=2350,maxLv=2424,pos=Vector3.new( -8350,125,  1650)},
    {sea=3,name="Tiki Outpost Raider", minLv=2425,maxLv=2499,pos=Vector3.new( -8280,125, -1000)},
    {sea=3,name="Chocolate Bar Battler",minLv=2500,maxLv=2574,pos=Vector3.new(-13950,125,  3800)},
    {sea=3,name="Ice Cream Staff",     minLv=2575,maxLv=2649,pos=Vector3.new(-14050,125,  3780)},
    {sea=3,name="Baking Staff",        minLv=2650,maxLv=2699,pos=Vector3.new(-14100,125,  3900)},
    {sea=3,name="Cake Guard",          minLv=2700,maxLv=2749,pos=Vector3.new(-14000,125,  3850)},
    {sea=3,name="Candy Rebel",         minLv=2750,maxLv=2799,pos=Vector3.new(-11650,125,  5450)},
    {sea=3,name="Cocoa Warrior",       minLv=2800,maxLv=9999,pos=Vector3.new(-12300,125,  4950)},
    {sea=3,name="Mythological Pirate", minLv=2800,maxLv=9999,pos=Vector3.new(-15100,125, -1750)},
    {sea=3,name="Brawler Crab",        minLv=2425,maxLv=2499,pos=Vector3.new(-14500,243, -1000)},
    {sea=3,name="Terrorshark",         minLv=2425,maxLv=2499,pos=Vector3.new(-14600,243, -1050)},
    {sea=3,name="Sea Soldier",         minLv=1500,maxLv=1574,pos=Vector3.new( -2050, 50, -4180)},
    {sea=3,name="Leviathan",           minLv=2800,maxLv=9999,pos=Vector3.new(-13050,125, -4650)},
    {sea=3,name="Snow Lurker",         minLv=2550,maxLv=2649,pos=Vector3.new(-14250,125, -2050)},
    {sea=3,name="Longma",              minLv=2800,maxLv=9999,pos=Vector3.new(  3640,125, 29500)},
}

local MOB_SPAWN = {}
local SEA1_MOBS, SEA2_MOBS, SEA3_MOBS = {}, {}, {}
local _seen = {}
for _, m in ipairs(MOBS) do
    if not MOB_SPAWN[m.name] then MOB_SPAWN[m.name]=m.pos end
    local uid = m.name.."|"..m.sea
    if not _seen[uid] then
        _seen[uid]=true
        if     m.sea==1 then table.insert(SEA1_MOBS,m.name)
        elseif m.sea==2 then table.insert(SEA2_MOBS,m.name)
        else                 table.insert(SEA3_MOBS,m.name) end
    end
end
local SEA_MOBS = {["Sea 1"]=SEA1_MOBS,["Sea 2"]=SEA2_MOBS,["Sea 3"]=SEA3_MOBS}

-- ════════════════════════════════════════
--  LEVEL ENGINE
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
            if ok and type(v)=="number" and v>0 then lv=v return end
        end
    end)
    return lv
end

local function getMobForLevel(lv)
    local best = nil
    for _, m in ipairs(MOBS) do
        if lv>=m.minLv and lv<=m.maxLv then
            if not best or m.minLv>best.minLv then best=m end
        end
    end
    return best and best.name or "Bandit"
end

-- ════════════════════════════════════════
--  ISLAND / RAID / BOSS DATA
-- ════════════════════════════════════════
local SEA1_ISLANDS = {
    {"Starter Island",Vector3.new(1260,125,1612)},{"Marine Starter",Vector3.new(-1180,125,-1174)},
    {"Middle Town",Vector3.new(-192,125,-559)},    {"Jungle",Vector3.new(-1646,125,-261)},
    {"Pirate Village",Vector3.new(-1189,125,4403)},{"Desert",Vector3.new(924,125,4089)},
    {"Frozen Village",Vector3.new(1175,125,-1818)},{"Snowy Village",Vector3.new(1326,125,-2882)},
    {"Marine Fortress",Vector3.new(-965,125,-380)},{"Skylands",Vector3.new(-4755,872,-718)},
    {"Upper Skylands",Vector3.new(-5004,1400,-718)},{"Fountain City",Vector3.new(3324,127,-2610)},
}
local SEA2_ISLANDS = {
    {"Kingdom of Rose",Vector3.new(-804,266,604)},{"Dark Arena",Vector3.new(-9564,125,-1754)},
    {"Usoapp Island",Vector3.new(-2581,125,1500)},{"Green Zone",Vector3.new(-3626,125,1900)},
    {"Graveyard",Vector3.new(-5878,125,-670)},     {"Snow Mountain",Vector3.new(-4550,1000,-1100)},
    {"Hot and Cold",Vector3.new(-3620,125,-2945)}, {"Cursed Ship",Vector3.new(-5237,125,-1765)},
    {"Ice Castle",Vector3.new(-3966,125,-1120)},   {"Forgotten Island",Vector3.new(-6000,125,-1700)},
    {"Colosseum",Vector3.new(926,125,29310)},       {"Magma Village",Vector3.new(500,125,29650)},
    {"Underwater City",Vector3.new(61421,125,1819)},{"Wano",Vector3.new(3640,125,29500)},
}
local SEA3_ISLANDS = {
    {"Port Town",Vector3.new(-2076,49,-4246)},     {"Hydra Island",Vector3.new(-3281,125,-3900)},
    {"Great Tree",Vector3.new(-9084,400,-2573)},   {"Mansion",Vector3.new(-6640,125,-2800)},
    {"Tiki Outpost",Vector3.new(-8279,125,-1024)}, {"Buggy Island",Vector3.new(-8420,125,1630)},
    {"Floating Turtle",Vector3.new(-14553,243,-1014)},{"Haunted Castle",Vector3.new(-11540,400,-1044)},
    {"Distant Island",Vector3.new(-13000,125,-4700)}, {"Sea of Treats",Vector3.new(-14055,125,3829)},
    {"Peanut Island",Vector3.new(-13350,125,4100)},   {"Cake Land",Vector3.new(-12350,125,5000)},
    {"Candy Island",Vector3.new(-11700,125,5500)},    {"Ice Berg",Vector3.new(-14300,125,-2100)},
    {"Labyrinth",Vector3.new(-15200,125,-1800)},
}

local RAID_POS = {
    Flame=Vector3.new(3066,28,2760),      Ice=Vector3.new(1227,28,-2204),
    Rumble=Vector3.new(-4755,872,-718),   Quake=Vector3.new(-1180,28,-1174),
    Light=Vector3.new(3324,28,-2610),     Dark=Vector3.new(-9084,28,-2573),
    Buddha=Vector3.new(-804,28,604),      Venom=Vector3.new(-5237,28,-1765),
    Phoenix=Vector3.new(-3966,28,-1120),  Dough=Vector3.new(-12350,28,5000),
    Shadow=Vector3.new(-11540,28,-1044),  Portal=Vector3.new(-14553,28,-1014),
    Control=Vector3.new(-15200,28,-1800), Dragon=Vector3.new(-9564,28,-1754),
    Leopard=Vector3.new(-14300,28,-2100), ["T-Rex"]=Vector3.new(-13000,28,-4700),
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
--  THEME  (matches screenshot: very dark)
-- ════════════════════════════════════════
local T = {
    BG      = Color3.fromRGB(  9,  9,  9),
    SB      = Color3.fromRGB( 11, 11, 11),
    Panel   = Color3.fromRGB( 16, 16, 16),
    Panel2  = Color3.fromRGB( 20, 20, 20),
    Card    = Color3.fromRGB( 18, 18, 18),
    Border  = Color3.fromRGB( 35, 35, 35),
    Accent  = Color3.fromRGB(255,255,255),
    Text    = Color3.fromRGB(230,230,230),
    Sub     = Color3.fromRGB(110,110,110),
    Dim     = Color3.fromRGB( 50, 50, 50),
    Green   = Color3.fromRGB( 75,200, 75),
    Red     = Color3.fromRGB(210, 60, 60),
    Gold    = Color3.fromRGB(210,165, 45),
    Blue    = Color3.fromRGB( 80,130,240),
    Purple  = Color3.fromRGB(145, 85,235),
    TabOn   = Color3.fromRGB( 26, 26, 26),
    TabOff  = Color3.fromRGB(  0,  0,  0),
    TopBar  = Color3.fromRGB( 11, 11, 11),
}

-- ════════════════════════════════════════
--  CORE UTILS
-- ════════════════════════════════════════
local function tw(obj, props, dur, sty, dir)
    TweenService:Create(obj,
        TweenInfo.new(dur or 0.18, sty or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function inst(cls, props)
    local o = Instance.new(cls)
    for k,v in pairs(props) do if k~="Parent" then o[k]=v end end
    if props.Parent then o.Parent=props.Parent end
    return o
end

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 7)
    c.Parent = o; return c
end

local function stroke(o, col, thk)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border
    s.Thickness = thk or 1
    s.Parent = o; return s
end

local function pad(o,t,l,r,b)
    local p = Instance.new("UIPadding")
    p.PaddingTop=UDim.new(0,t or 0); p.PaddingLeft=UDim.new(0,l or 0)
    p.PaddingRight=UDim.new(0,r or 0); p.PaddingBottom=UDim.new(0,b or 0)
    p.Parent = o
end

local function listLayout(o, dir, gap)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    if gap then l.Padding = UDim.new(0,gap) end
    l.Parent = o; return l
end

-- Game helpers
local function getChar()  return LP.Character end
local function getHum()   local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()  local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive()  local h=getHum()  return h and h.Health>0 end

local function tp(pos, instant)
    local root=getRoot() if not root then return end
    local goal=pos+Vector3.new(0,3.5,0)
    if instant then root.CFrame=CFrame.new(goal) return end
    local from=root.CFrame.Position
    for i=1,6 do root.CFrame=CFrame.new(from:Lerp(goal,i/6)) task.wait(0.025) end
end

local function findMob(name, radius)
    local root=getRoot() if not root then return nil end
    local best,bestD=nil,radius or 9999
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar()
        and (obj.Name==name or obj.Name:lower():find(name:lower(),1,true)) then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            local hrp=obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                local d=(hrp.Position-root.Position).Magnitude
                if d<bestD then best,bestD=obj,d end
            end
        end
    end
    return best
end

local function isDead(mob)
    if not mob or not mob.Parent then return true end
    local h=mob:FindFirstChildOfClass("Humanoid")
    return not h or h.Health<=0
end

local function attack(mob)
    if not mob or not mob.Parent then return false end
    local hrp=mob:FindFirstChild("HumanoidRootPart") if not hrp then return false end
    local hum=mob:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health<=0 then return true end
    tp(hrp.Position+Vector3.new(0,0,3))
    if HAS_FTI then
        local root=getRoot()
        if root then
            pcall(firetouchinterest,hrp,root,0) task.wait(0.05)
            pcall(firetouchinterest,hrp,root,1)
        end
    end
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
    pcall(function() if hum and hum.Health>0 then hum:TakeDamage(9999) end end)
    task.wait(0.2)
    return isDead(mob)
end

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
--  STATS
-- ════════════════════════════════════════
local STATS = {
    kills=0, deaths=0, fruitsTP=0, chestsTP=0, quests=0,
    startTime=os.time(), charLoaded=false,
}
LP.CharacterAdded:Connect(function()
    if STATS.charLoaded then STATS.deaths=STATS.deaths+1 else STATS.charLoaded=true end
end)
if LP.Character then STATS.charLoaded=true end

local STATUS = "Idle"
local function setStatus(s) STATUS=s end

-- ════════════════════════════════════════
--  SESSION TIMER HELPER
-- ════════════════════════════════════════
local function fmtTime(secs)
    local h = math.floor(secs/3600)
    local m = math.floor((secs%3600)/60)
    local s = secs%60
    if h>0 then return string.format("%dh %02dm",h,m) end
    return string.format("%dm %02ds",m,s)
end

-- ════════════════════════════════════════
--  NOTIFICATIONS
-- ════════════════════════════════════════
local _nGui
local function notify(title, body, dur, accent)
    dur=dur or 3.5; accent=accent or T.Accent
    if not _nGui or not _nGui.Parent then
        _nGui=inst("ScreenGui",{Name="_EHN",ResetOnSpawn=false,
            ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    end
    for _,f in pairs(_nGui:GetChildren()) do
        if f:IsA("Frame") then
            tw(f,{Position=UDim2.new(1,-270,1,f.Position.Y.Offset-62)},0.12)
        end
    end
    local card=inst("Frame",{Size=UDim2.new(0,256,0,50),
        Position=UDim2.new(1,10,1,-58),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=_nGui})
    corner(card,7) stroke(card,T.Border)
    inst("Frame",{Size=UDim2.new(0,2,1,0),BackgroundColor3=accent,BorderSizePixel=0,Parent=card})
    inst("TextLabel",{Size=UDim2.new(1,-14,0,16),Position=UDim2.new(0,11,0,4),
        BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
    inst("TextLabel",{Size=UDim2.new(1,-14,0,24),Position=UDim2.new(0,11,0,20),
        BackgroundTransparency=1,Text=body,Font=Enum.Font.Gotham,TextSize=9,
        TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=card})
    tw(card,{Position=UDim2.new(1,-270,1,-58)},0.26,Enum.EasingStyle.Back)
    task.delay(dur,function()
        tw(card,{Position=UDim2.new(1,10,1,-58)},0.18)
        task.wait(0.2) pcall(function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════
--  LOADING SCREEN
-- ════════════════════════════════════════
local function showLoader()
    local sg=inst("ScreenGui",{Name="_EHL",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=PG})
    local bg=inst("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(3,3,3),
        BorderSizePixel=0,Parent=sg})
    for i=1,20 do
        inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,(i-1)/20,0),
            BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.97,BorderSizePixel=0,Parent=bg})
        inst("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new((i-1)/20,0,0,0),
            BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.97,BorderSizePixel=0,Parent=bg})
    end
    local card=inst("Frame",{Size=UDim2.new(0,290,0,190),Position=UDim2.new(0.5,-145,0.5,-95),
        BackgroundColor3=Color3.fromRGB(8,8,8),BorderSizePixel=0,Parent=bg})
    corner(card,10) stroke(card,Color3.fromRGB(45,45,45))
    inst("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=card})
    inst("TextLabel",{Size=UDim2.new(1,0,0,44),Position=UDim2.new(0,0,0,16),
        BackgroundTransparency=1,Text="ELITE HUB",Font=Enum.Font.GothamBlack,TextSize=26,
        TextColor3=Color3.new(1,1,1),Parent=card})
    inst("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,57),
        BackgroundTransparency=1,Text="BLOX FRUITS  |  ALL SEAS  |  Lv 1 - 2800",
        Font=Enum.Font.GothamBold,TextSize=7.5,TextColor3=Color3.fromRGB(65,65,65),Parent=card})
    inst("TextLabel",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,72),
        BackgroundTransparency=1,Text="Executor: "..EXEC_NAME..(IS_DELTA and"  [DELTA]"or""),
        Font=Enum.Font.Gotham,TextSize=8,TextColor3=Color3.fromRGB(50,50,50),Parent=card})
    inst("Frame",{Size=UDim2.new(0,200,0,1),Position=UDim2.new(0.5,-100,0,90),
        BackgroundColor3=Color3.fromRGB(38,38,38),BorderSizePixel=0,Parent=card})
    local statLbl=inst("TextLabel",{Size=UDim2.new(1,-24,0,13),Position=UDim2.new(0,12,0,98),
        BackgroundTransparency=1,Text="Initializing...",Font=Enum.Font.Gotham,TextSize=8.5,
        TextColor3=Color3.fromRGB(70,70,70),TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
    local barBg=inst("Frame",{Size=UDim2.new(1,-24,0,3),Position=UDim2.new(0,12,0,118),
        BackgroundColor3=Color3.fromRGB(20,20,20),BorderSizePixel=0,Parent=card})
    corner(barBg,2)
    local bar=inst("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0,Parent=barBg})
    corner(bar,2)
    local shimmer=inst("Frame",{Size=UDim2.new(0.3,0,1,0),
        BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0.7,BorderSizePixel=0,Parent=bar})
    corner(shimmer,2)
    local pctLbl=inst("TextLabel",{Size=UDim2.new(0,36,0,11),Position=UDim2.new(1,-38,0,126),
        BackgroundTransparency=1,Text="0%",Font=Enum.Font.GothamBold,TextSize=8,
        TextColor3=Color3.fromRGB(50,50,50),TextXAlignment=Enum.TextXAlignment.Right,Parent=card})
    inst("TextLabel",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-16),
        BackgroundTransparency=1,Text="v1.0.0  —  discord.gg/EmsMsHZCVH",
        Font=Enum.Font.Gotham,TextSize=8,TextColor3=Color3.fromRGB(38,38,38),Parent=card})

    card.BackgroundTransparency=1
    tw(card,{BackgroundTransparency=0},0.3)

    local shimConn=RunService.Heartbeat:Connect(wrap(function()
        if not shimmer.Parent then return end
        shimmer.Position=UDim2.new(tick()%1-0.3,0,0,0)
    end))

    local steps={
        {0.12,"Detecting executor...",T.Blue},
        {0.26,"Loading GUI..."},
        {0.40,"Injecting mob database..."},
        {0.55,"Mapping seas 1, 2, 3..."},
        {0.68,"Configuring ESP..."},
        {0.80,"Building level engine..."},
        {0.92,"Starting automation...",T.Gold},
        {1.00,"Ready.",T.Green},
    }
    for _,step in ipairs(steps) do
        task.wait(0.2)
        statLbl.Text=step[2]
        statLbl.TextColor3=step[3] or Color3.fromRGB(70,70,70)
        pctLbl.Text=math.floor(step[1]*100).."%"
        tw(bar,{Size=UDim2.new(step[1],0,1,0)},0.2)
        if step[3] then tw(bar,{BackgroundColor3=step[3]},0.15) end
    end
    task.wait(0.4)
    shimConn:Disconnect()
    tw(bg,{BackgroundTransparency=1},0.4)
    for _,d in pairs(bg:GetDescendants()) do
        if d:IsA("GuiObject") then
            pcall(tw,d,{BackgroundTransparency=1,TextTransparency=1},0.4)
        end
    end
    task.wait(0.5) sg:Destroy()
end

-- ════════════════════════════════════════
--  DRAWING ESP
-- ════════════════════════════════════════
local espDrawings={}
local function clearESP()
    for _,o in pairs(espDrawings) do pcall(function() o:Remove() end) end
    espDrawings={}
end
local function newDraw(cls,props)
    if not HAS_DRAW then return nil end
    local ok,o=pcall(Drawing.new,cls)
    if not ok then return nil end
    for k,v in pairs(props) do pcall(function() o[k]=v end) end
    table.insert(espDrawings,o); return o
end
local function w2s(p)
    local vp,vis=Camera:WorldToViewportPoint(p)
    return Vector2.new(vp.X,vp.Y),vis,vp.Z
end

local espConn
local function startESP()
    if espConn then espConn:Disconnect() end
    clearESP()
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
                            newDraw("Text",{Text=p.Name..(hum and" ["..math.floor(hum.Health).."]"or""),
                                Position=Vector2.new(sc.X,sc.Y-sz*0.82-14),Size=13,
                                Color=Color3.new(1,1,1),Center=true,Outline=true,Visible=true,ZIndex=5})
                        end
                    end
                end
            end
        end
        if S.MobESP then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
                    local hum=obj:FindFirstChildOfClass("Humanoid")
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 then
                        local sc,vis,dep=w2s(hrp.Position)
                        if vis and dep>0 and dep<700 then
                            local sz=math.clamp(1400/dep,10,90)
                            newDraw("Square",{Size=Vector2.new(sz,sz*1.65),
                                Position=Vector2.new(sc.X-sz/2,sc.Y-sz*0.82),
                                Color=Color3.fromRGB(255,155,50),Thickness=1,Filled=false,Visible=true,ZIndex=4})
                            newDraw("Text",{Text=obj.Name.." ["..math.floor(hum.Health).."]",
                                Position=Vector2.new(sc.X,sc.Y-sz*0.82-12),Size=11,
                                Color=Color3.fromRGB(255,175,70),Center=true,Outline=true,Visible=true,ZIndex=4})
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
                        newDraw("Text",{Text="[FRUIT] "..f.name,Position=sc,Size=13,
                            Color=Color3.fromRGB(80,220,80),Center=true,Outline=true,Visible=true,ZIndex=6})
                    end
                end
            end
        end
    end))
end

-- Billboard fallback
local billESP={}
task.spawn(function()
    while task.wait(1) do
        if HAS_DRAW then continue end
        for _,b in pairs(billESP) do pcall(function() b:Destroy() end) end billESP={}
        local function mkBill(parent,text,col)
            local bb=inst("BillboardGui",{Size=UDim2.new(0,100,0,22),
                StudsOffset=Vector3.new(0,3,0),AlwaysOnTop=true,Parent=parent})
            inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
                Text=text,Font=Enum.Font.GothamBold,TextSize=9,
                TextColor3=col,TextStrokeTransparency=0,Parent=bb})
            table.insert(billESP,bb)
        end
        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then mkBill(hrp,p.Name,Color3.new(1,1,1)) end
                end
            end
        end
        if S.MobESP then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local hum=obj:FindFirstChildOfClass("Humanoid")
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 then
                        mkBill(hrp,obj.Name,Color3.fromRGB(255,175,70))
                    end
                end
            end
        end
        if S.FruitESP then
            for _,f in ipairs(scanFruits()) do
                if f.part and f.part.Parent then
                    mkBill(f.part,"[FRUIT] "..f.name,T.Green)
                end
            end
        end
    end
end)

-- ════════════════════════════════════════
--  FPS COUNTER
-- ════════════════════════════════════════
local CURRENT_FPS = 60  -- live value read by titlebar
local function startFPS()
    pcall(function() PG:FindFirstChild("_EHFPS"):Destroy() end)
    local frames,last=0,tick()
    RunService.RenderStepped:Connect(wrap(function()
        frames=frames+1
        local now=tick()
        if now-last>=0.5 then
            CURRENT_FPS=math.round(frames/(now-last))
            frames,last=0,now
        end
    end))
end

-- ════════════════════════════════════════
--  IMPROVED ANTI-AFK
--  (multiple random input types, smarter timing)
-- ════════════════════════════════════════
local function startAntiAFK()
    task.spawn(function()
        local actions = {
            function() pcall(function() VirtualUser:CaptureController() end) end,
            function() pcall(function() VirtualUser:ClickButton1(Vector2.new(math.random(100,700),math.random(100,500))) end) end,
            function() pcall(function() VirtualUser:ClickButton2(Vector2.new()) end) end,
            function()
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(0,0),CFrame.new())
                    task.wait(0.05)
                    VirtualUser:Button1Up(Vector2.new(0,0),CFrame.new())
                end)
            end,
        }
        local lastAction = 0
        while task.wait(1) do
            if not S.AntiAFK then continue end
            local now = tick()
            -- Random interval between 45-90 seconds to prevent pattern detection
            local interval = math.random(45, 90)
            if now - lastAction >= interval then
                lastAction = now
                -- Do 2-3 random actions
                for _ = 1, math.random(2,3) do
                    local fn = actions[math.random(1,#actions)]
                    fn()
                    task.wait(math.random()/5)
                end
            end
        end
    end)
end

-- ════════════════════════════════════════
--  WATERMARK
-- ════════════════════════════════════════
local _wmConn
local function buildWatermark()
    pcall(function() PG:FindFirstChild("_EHW"):Destroy() end)
    if _wmConn then pcall(function() _wmConn:Disconnect() end) end
    local sg=inst("ScreenGui",{Name="_EHW",ResetOnSpawn=false,Parent=PG})
    local f=inst("Frame",{Size=UDim2.new(0,210,0,16),Position=UDim2.new(0,6,0,6),
        BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg})
    corner(f,4) stroke(f,T.Border)
    inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        Text="Elite Hub v1.0.0  |  discord.gg/EmsMsHZCVH",
        Font=Enum.Font.GothamBold,TextSize=7.5,TextColor3=T.Sub,Parent=f})
    _wmConn=RunService.Heartbeat:Connect(wrap(function()
        if sg.Parent then sg.Enabled=S.ShowWatermark end
    end))
end

-- ════════════════════════════════════════
--  MAIN GUI  — FlowHub-style layout
-- ════════════════════════════════════════
local function buildGUI()
    pcall(function() PG:FindFirstChild("EliteHub"):Destroy() end)
    local sg=inst("ScreenGui",{Name="EliteHub",ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,Parent=PG})

    -- Window (moveable, smaller)
    local WIN_W,WIN_H = 530,385
    local win=inst("Frame",{
        Size=UDim2.new(0,WIN_W,0,WIN_H),
        Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2),
        BackgroundColor3=T.BG,BorderSizePixel=0,Active=true,Parent=sg
    })
    corner(win,8) stroke(win,T.Border)

    -- ── DRAG (title bar initiates drag) ──────────────────────────
    local dragging,dX,dY=false,0,0
    RunService.RenderStepped:Connect(wrap(function()
        if dragging then
            win.Position=UDim2.new(0,Mouse.X-dX,0,Mouse.Y-dY)
        end
    end))

    -- ── TOP BAR  (ELITE HUB | HH:MM:SS | FPS) ───────────────────
    local TB_H = 30
    local tb=inst("Frame",{Size=UDim2.new(1,0,0,TB_H),
        BackgroundColor3=T.TopBar,BorderSizePixel=0,Parent=win})
    corner(tb,8)
    inst("Frame",{Size=UDim2.new(1,0,0.6,0),Position=UDim2.new(0,0,0.4,0),
        BackgroundColor3=T.TopBar,BorderSizePixel=0,Parent=tb})
    inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=T.Border,BorderSizePixel=0,Parent=tb})

    -- Make titlebar draggable
    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dX=Mouse.X-win.AbsolutePosition.X; dY=Mouse.Y-win.AbsolutePosition.Y
        end
    end)
    tb.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    -- "ELITE HUB" brand on left
    inst("TextLabel",{Size=UDim2.new(0,90,1,0),Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1,Text="ELITE HUB",
        Font=Enum.Font.GothamBlack,TextSize=11,TextColor3=T.Accent,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})

    -- Live clock + FPS in center (like screenshot: "ELITE HUB | 23:01:35 | 60 FPS")
    local topInfo=inst("TextLabel",{Size=UDim2.new(1,-160,1,0),Position=UDim2.new(0,90,0,0),
        BackgroundTransparency=1,Text="",
        Font=Enum.Font.Gotham,TextSize=9,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Center,Parent=tb})

    -- Delta badge
    if IS_DELTA then
        local badge=inst("Frame",{Size=UDim2.new(0,44,0,15),
            Position=UDim2.new(1,-106,0.5,-7.5),
            BackgroundColor3=Color3.fromRGB(14,18,36),BorderSizePixel=0,Parent=tb})
        corner(badge,4) stroke(badge,T.Blue,1)
        inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            Text="DELTA",Font=Enum.Font.GothamBlack,TextSize=7.5,TextColor3=T.Blue,Parent=badge})
    end

    -- Window controls
    local function winBtn(xOff,col,lbl,cb)
        local b=inst("TextButton",{Size=UDim2.new(0,18,0,18),
            Position=UDim2.new(1,xOff,0.5,-9),
            BackgroundColor3=col,Text=lbl,Font=Enum.Font.GothamBold,TextSize=10,
            TextColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=tb})
        corner(b,9)
        b.MouseButton1Click:Connect(cb)
        b.MouseEnter:Connect(function() tw(b,{BackgroundTransparency=0.3}) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundTransparency=0}) end)
    end
    winBtn(-26,Color3.fromRGB(185,50,50),"×",function()
        tw(win,{BackgroundTransparency=1,Size=UDim2.new(0,WIN_W,0,0)},0.18)
        task.wait(0.2) sg:Destroy()
    end)
    local minimized=false
    winBtn(-48,T.Dim,"−",function()
        minimized=not minimized
        tw(win,{Size=minimized and UDim2.new(0,WIN_W,0,TB_H) or UDim2.new(0,WIN_W,0,WIN_H)},
            0.2,Enum.EasingStyle.Back)
    end)

    -- Live update top info
    RunService.Heartbeat:Connect(wrap(function()
        if not topInfo.Parent then return end
        local d=os.date("*t",os.time())
        topInfo.Text=string.format("| %02d:%02d:%02d | %d FPS",d.hour,d.min,d.sec,CURRENT_FPS)
    end))

    -- ── SIDEBAR  (115px, like screenshot) ────────────────────────
    local SB_W=115
    local sb=inst("Frame",{
        Size=UDim2.new(0,SB_W,1,-TB_H-1),
        Position=UDim2.new(0,0,0,TB_H),
        BackgroundColor3=T.SB,BorderSizePixel=0,Parent=win
    })
    -- Right edge divider
    inst("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=T.Border,BorderSizePixel=0,Parent=sb})
    -- Square bottom-right corner patch
    inst("Frame",{Size=UDim2.new(0,SB_W/2,0,10),Position=UDim2.new(0,SB_W/2,1,-10),
        BackgroundColor3=T.SB,BorderSizePixel=0,Parent=sb})

    -- Sidebar nav area (scrollable)
    local sbNav=inst("ScrollingFrame",{
        Size=UDim2.new(1,0,1,-58),Position=UDim2.new(0,0,0,0),
        BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Parent=sb
    })
    pad(sbNav,8,6,6,0)
    listLayout(sbNav,nil,1)

    -- Sidebar bottom: user info
    local sbBottom=inst("Frame",{Size=UDim2.new(1,0,0,56),
        Position=UDim2.new(0,0,1,-56),BackgroundColor3=T.SB,BorderSizePixel=0,Parent=sb})
    inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),
        BackgroundColor3=T.Border,BorderSizePixel=0,Parent=sbBottom})

    -- Avatar circle
    local av=inst("Frame",{Size=UDim2.new(0,26,0,26),Position=UDim2.new(0,8,0,8),
        BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=sbBottom})
    corner(av,13)
    inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        Text=string.upper(string.sub(LP.Name,1,1)),
        Font=Enum.Font.GothamBlack,TextSize=11,TextColor3=Color3.new(1,1,1),Parent=av})

    -- Display name
    inst("TextLabel",{Size=UDim2.new(1,-44,0,14),Position=UDim2.new(0,40,0,7),
        BackgroundTransparency=1,Text=DISPLAY_NAME,
        Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=sbBottom})
    -- Username
    inst("TextLabel",{Size=UDim2.new(1,-44,0,12),Position=UDim2.new(0,40,0,21),
        BackgroundTransparency=1,Text=USERNAME,
        Font=Enum.Font.Gotham,TextSize=8,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Parent=sbBottom})
    -- Session time (live)
    local sesLbl=inst("TextLabel",{Size=UDim2.new(1,-44,0,11),Position=UDim2.new(0,40,0,33),
        BackgroundTransparency=1,Text="0m 00s",
        Font=Enum.Font.Gotham,TextSize=7.5,TextColor3=T.Dim,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=sbBottom})
    task.spawn(function()
        while task.wait(1) do
            if not sesLbl.Parent then break end
            sesLbl.Text=fmtTime(os.time()-STATS.startTime)
        end
    end)

    -- ── CONTENT AREA ──────────────────────────────────────────────
    local CA_X = SB_W+1
    local ca=inst("Frame",{
        Size=UDim2.new(1,-CA_X,1,-TB_H),
        Position=UDim2.new(0,CA_X,0,TB_H),
        BackgroundTransparency=1,Parent=win
    })

    -- ── PAGE / TAB SYSTEM ─────────────────────────────────────────
    local pages,tabs,curPage={},{},nil

    local function makePage(id)
        local sc=inst("ScrollingFrame",{
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,
            ScrollBarThickness=2,ScrollBarImageColor3=T.Dim,
            CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
            Visible=false,Parent=ca
        })
        pad(sc,6,6,6,6)
        listLayout(sc,nil,5)
        pages[id]=sc
        return sc
    end

    local function activatePage(id)
        if curPage then
            pages[curPage].Visible=false
            local tb2=tabs[curPage]
            if tb2 then
                tw(tb2.bg,{BackgroundColor3=T.TabOff})
                tw(tb2.accent,{BackgroundColor3=T.TabOff})
                tw(tb2.lbl,{TextColor3=T.Sub})
            end
        end
        curPage=id
        pages[id].Visible=true
        local tb2=tabs[id]
        if tb2 then
            tw(tb2.bg,{BackgroundColor3=T.TabOn})
            tw(tb2.accent,{BackgroundColor3=T.Green})
            tw(tb2.lbl,{TextColor3=T.Text})
        end
    end

    -- Section header in sidebar (gray small text, like "SZA" in screenshot)
    local function sbSection(label, order)
        local f=inst("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,
            LayoutOrder=order,Parent=sbNav})
        pad(f,0,2,0,0)
        inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            Text=label:upper(),Font=Enum.Font.GothamBold,TextSize=7.5,TextColor3=T.Dim,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    end

    -- Sidebar tab item (with left green accent bar when active, like screenshot)
    local function makeTab(id,label,icon,order)
        local row=inst("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,
            LayoutOrder=order,Parent=sbNav})
        local acc=inst("Frame",{Size=UDim2.new(0,2,0,14),Position=UDim2.new(0,0,0.5,-7),
            BackgroundColor3=T.TabOff,BorderSizePixel=0,Parent=row})
        corner(acc,1)
        local bg=inst("Frame",{Size=UDim2.new(1,-4,1,0),Position=UDim2.new(0,4,0,0),
            BackgroundColor3=T.TabOff,BorderSizePixel=0,Parent=row})
        corner(bg,5)
        local lbl=inst("TextLabel",{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,Text=(icon and icon.."  " or"  ")..label,
            Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=bg})
        tabs[id]={bg=bg,accent=acc,lbl=lbl}
        inst("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=row}
        ).MouseButton1Click:Connect(function() activatePage(id) end)
        bg.MouseEnter:Connect(function()
            if curPage~=id then tw(bg,{BackgroundColor3=T.Panel}) end
        end)
        bg.MouseLeave:Connect(function()
            if curPage~=id then tw(bg,{BackgroundColor3=T.TabOff}) end
        end)
        return function() activatePage(id) end
    end

    -- ── WIDGET BUILDERS ───────────────────────────────────────────

    -- Card: a rounded container, returns its content frame
    local function card(page, title, order)
        local c=inst("Frame",{
            Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundColor3=T.Card,BorderSizePixel=0,LayoutOrder=order,Parent=page
        })
        corner(c,7) stroke(c,T.Border)
        pad(c,8,10,10,8)
        listLayout(c,nil,4)
        if title then
            inst("TextLabel",{Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,
                Text=title,Font=Enum.Font.GothamBold,TextSize=10.5,TextColor3=T.Text,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=c})
        end
        return c
    end

    -- Two-column card row (left card + right card side by side)
    local function twoCol(page, order)
        local row=inst("Frame",{
            Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1,LayoutOrder=order,Parent=page
        })
        local hl=Instance.new("UIListLayout")
        hl.FillDirection=Enum.FillDirection.Horizontal
        hl.Padding=UDim.new(0,5)
        hl.SortOrder=Enum.SortOrder.LayoutOrder
        hl.Parent=row

        local function col()
            local f=inst("Frame",{
                Size=UDim2.new(0.5,-3,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,Parent=row
            })
            listLayout(f,nil,5)
            return f
        end
        return col(),col()
    end

    -- Toggle row (like screenshot: label on left, pill toggle on right)
    local function toggle(parent, label, key, order, cb)
        local row=inst("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,
            LayoutOrder=order,Parent=parent})
        inst("TextLabel",{Size=UDim2.new(1,-46,1,0),Position=UDim2.new(0,0,0,0),
            BackgroundTransparency=1,Text=label,Font=Enum.Font.Gotham,TextSize=9.5,
            TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})

        local on=key and S[key] or false
        local track=inst("Frame",{Size=UDim2.new(0,34,0,17),
            Position=UDim2.new(1,-36,0.5,-8.5),
            BackgroundColor3=on and T.Green or T.Dim,BorderSizePixel=0,Parent=row})
        corner(track,9)
        local thumb=inst("Frame",{Size=UDim2.new(0,13,0,13),
            Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5),
            BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=track})
        corner(thumb,7)

        local function setState(v)
            on=v if key then S[key]=v scheduleSave() end
            tw(track,{BackgroundColor3=on and T.Green or T.Dim})
            tw(thumb,{Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)})
        end
        inst("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=row}
        ).MouseButton1Click:Connect(function() setState(not on) if cb then cb(on) end end)
        return setState
    end

    -- Slider row (like screenshot: label + value right-aligned, green track below)
    local function slider(parent, label, key, minV, maxV, order, cb)
        local h=38
        local c=inst("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,
            LayoutOrder=order,Parent=parent})
        -- Label + value
        inst("TextLabel",{Size=UDim2.new(0.6,0,0,14),Position=UDim2.new(0,0,0,0),
            BackgroundTransparency=1,Text=label,Font=Enum.Font.Gotham,TextSize=9,
            TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=c})
        local valLbl=inst("TextLabel",{Size=UDim2.new(0.4,0,0,14),Position=UDim2.new(0.6,0,0,0),
            BackgroundTransparency=1,Text=tostring(S[key] or minV),
            Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Text,
            TextXAlignment=Enum.TextXAlignment.Right,Parent=c})
        -- Track bg
        local track=inst("Frame",{Size=UDim2.new(1,0,0,5),Position=UDim2.new(0,0,0,17),
            BackgroundColor3=T.Dim,BorderSizePixel=0,Parent=c})
        corner(track,3)
        -- Fill
        local pct=math.clamp(((S[key] or minV)-minV)/(maxV-minV),0,1)
        local fill=inst("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=T.Green,
            BorderSizePixel=0,Parent=track})
        corner(fill,3)
        -- Thumb
        local thumb=inst("Frame",{Size=UDim2.new(0,12,0,12),
            Position=UDim2.new(pct,-6,0.5,-6),
            BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=track})
        corner(thumb,6)
        -- Drag logic
        local drag=false
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                local rel=math.clamp((Mouse.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                local val=math.round(minV+rel*(maxV-minV))
                S[key]=val scheduleSave()
                valLbl.Text=tostring(val)
                fill.Size=UDim2.new(rel,0,1,0)
                thumb.Position=UDim2.new(rel,-6,0.5,-6)
                if cb then cb(val) end
            end
        end)
    end

    -- Dropdown (compact, like FlowHub style)
    local function dropdown(parent, label, options, key, order, cb)
        local open=false
        local c=inst("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,
            LayoutOrder=order,ClipsDescendants=true,Parent=parent})
        inst("TextLabel",{Size=UDim2.new(0.5,0,0,24),BackgroundTransparency=1,
            Text=label,Font=Enum.Font.Gotham,TextSize=9,TextColor3=T.Sub,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=c})
        local selLbl=inst("TextLabel",{Size=UDim2.new(0.5,-14,0,24),Position=UDim2.new(0.5,0,0,0),
            BackgroundTransparency=1,Text=(key and S[key]) or (options[1] or ""),
            Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Text,
            TextXAlignment=Enum.TextXAlignment.Right,Parent=c})
        inst("TextLabel",{Size=UDim2.new(0,12,0,24),Position=UDim2.new(1,-12,0,0),
            BackgroundTransparency=1,Text="⌄",Font=Enum.Font.Gotham,TextSize=9,
            TextColor3=T.Dim,Parent=c})

        local listF=inst("Frame",{Size=UDim2.new(1,0,0,#options*20),Position=UDim2.new(0,0,0,24),
            BackgroundColor3=Color3.fromRGB(12,12,12),BorderSizePixel=0,Parent=c})
        stroke(listF,T.Border)
        corner(listF,5)
        listLayout(listF,nil,0)

        local optBtns={}
        local curKey=key

        local function build(opts,newKey)
            for _,b in pairs(optBtns) do pcall(function() b:Destroy() end) end
            optBtns={}
            curKey=newKey or key
            listF.Size=UDim2.new(1,0,0,#opts*20)
            selLbl.Text=(curKey and S[curKey]) or (opts[1] or "")
            for i,opt in ipairs(opts) do
                local ob=inst("TextButton",{Size=UDim2.new(1,0,0,20),
                    BackgroundColor3=Color3.fromRGB(12,12,12),
                    Text=opt,Font=Enum.Font.Gotham,TextSize=9,TextColor3=T.Sub,
                    BorderSizePixel=0,LayoutOrder=i,Parent=listF})
                ob.MouseButton1Click:Connect(function()
                    if curKey then S[curKey]=opt scheduleSave() end
                    selLbl.Text=opt; open=false
                    tw(c,{Size=UDim2.new(1,0,0,24)},0.14)
                    if cb then cb(opt) end
                end)
                ob.MouseEnter:Connect(function()
                    tw(ob,{TextColor3=T.Text,BackgroundColor3=Color3.fromRGB(20,20,20)})
                end)
                ob.MouseLeave:Connect(function()
                    tw(ob,{TextColor3=T.Sub,BackgroundColor3=Color3.fromRGB(12,12,12)})
                end)
                table.insert(optBtns,ob)
            end
        end
        build(options,key)

        inst("TextButton",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,Text="",Parent=c}
        ).MouseButton1Click:Connect(function()
            open=not open
            tw(c,{Size=UDim2.new(1,0,0,open and 24+#optBtns*20 or 24)},0.16,Enum.EasingStyle.Back)
        end)
        return c,selLbl,function(opts,nk) build(opts,nk) if open then open=false tw(c,{Size=UDim2.new(1,0,0,24)},0.12) end end
    end

    -- Small action button
    local function btn(parent, label, col, order, cb)
        col=col or T.Panel2
        local b=inst("TextButton",{Size=UDim2.new(1,0,0,23),BackgroundColor3=col,
            Text=label,Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Text,
            BorderSizePixel=0,LayoutOrder=order,Parent=parent})
        corner(b,5) stroke(b,T.Border)
        b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=Color3.fromRGB(
            math.min(col.R*255+12,255)/255,
            math.min(col.G*255+12,255)/255,
            math.min(col.B*255+12,255)/255
        )}) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=col}) end)
        b.MouseButton1Click:Connect(function()
            tw(b,{Size=UDim2.new(0.97,0,0,20)},0.05)
            task.wait(0.06) tw(b,{Size=UDim2.new(1,0,0,23)},0.05)
            if cb then task.spawn(cb) end
        end)
        return b
    end

    -- Info row (label : value)
    local function infoRow(parent, lbl, val, order)
        local r=inst("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
            LayoutOrder=order,Parent=parent})
        inst("TextLabel",{Size=UDim2.new(0.55,0,1,0),BackgroundTransparency=1,Text=lbl,
            Font=Enum.Font.Gotham,TextSize=9,TextColor3=T.Sub,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=r})
        local v=inst("TextLabel",{Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0.55,0,0,0),
            BackgroundTransparency=1,Text=tostring(val),
            Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Text,
            TextXAlignment=Enum.TextXAlignment.Right,Parent=r})
        return v
    end

    -- Separator
    local function sep(parent, order)
        inst("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=T.Border,BorderSizePixel=0,
            LayoutOrder=order,Parent=parent})
    end

    -- ════════════════════════════════════════
    --  SIDEBAR NAV
    -- ════════════════════════════════════════
    sbSection("ELITE HUB",1)
    local goFarm    = makeTab("Farm",   "Auto Farm",  "→",2)
    local goCombat  = makeTab("Combat", "Combat",     "→",3)
    local goTP      = makeTab("TP",     "Teleport",   "→",4)
    local goBoss    = makeTab("Boss",   "Boss",       "→",5)
    local goRaid    = makeTab("Raid",   "Raid",       "→",6)
    sbSection("VISUALS",7)
    local goESP     = makeTab("ESP",    "ESP",        "→",8)
    local goVisual  = makeTab("Visual", "Visual",     "→",9)
    sbSection("PLAYER",10)
    local goMisc    = makeTab("Misc",   "Stats & Misc","→",11)

    -- ════════════════════════════════════════
    --  TAB: AUTO FARM
    -- ════════════════════════════════════════
    local pFarm = makePage("Farm")

    -- Two columns: left=config, right=toggles
    local fL,fR = twoCol(pFarm,1)

    local cfgCard = card(fL,"Auto Farm",1)
    -- Live level display
    local lvRow=inst("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
        LayoutOrder=1,Parent=cfgCard})
    inst("TextLabel",{Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,Text="Level",
        Font=Enum.Font.Gotham,TextSize=9,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=lvRow})
    local lvLbl=inst("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0.5,0,0,0),
        BackgroundTransparency=1,Text="...",
        Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Gold,
        TextXAlignment=Enum.TextXAlignment.Right,Parent=lvRow})
    task.spawn(function()
        while task.wait(3) do
            if not lvLbl.Parent then break end
            local lv=getPlayerLevel()
            lvLbl.Text=tostring(lv).." → "..getMobForLevel(lv)
        end
    end)
    sep(cfgCard,2)
    toggle(cfgCard,"Auto Level Farm","AutoLevelFarm",3,function(on)
        S.AutoFarm=on
        if on then
            local lv=getPlayerLevel()
            local mob=getMobForLevel(lv)
            S.TargetMob=mob
            notify("Auto Level Farm","Lv "..lv.." → "..mob,4,T.Gold)
            setStatus("Auto-Farm: "..mob)
        else setStatus("Idle") end
    end)
    sep(cfgCard,4)

    -- Sea + Mob dropdowns (FIX: proper wiring, no double-destroy bug)
    local _,_,setMobOpts = dropdown(cfgCard,"Mob",SEA1_MOBS,"TargetMob",5)
    dropdown(cfgCard,"Sea",{"Sea 1","Sea 2","Sea 3"},nil,6,function(sea)
        local mobs=SEA_MOBS[sea] or SEA1_MOBS
        setMobOpts(mobs,"TargetMob")
        S.TargetMob=mobs[1] or "Bandit"
        notify("Farm","Sea changed: "..sea)
    end)
    dropdown(cfgCard,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",7)

    local togCard = card(fR,"Toggles",1)
    toggle(togCard,"Auto Farm","AutoFarm",1,function(on)
        if on then setStatus("Farm: "..(S.TargetMob or "?"))
            notify("Farm","Started — "..S.TargetMob,3,T.Blue)
        else setStatus("Idle") notify("Farm","Stopped.") end
    end)
    toggle(togCard,"Auto Quest","AutoQuest",2,function(on) notify("Quest",on and"ON"or"OFF") end)
    toggle(togCard,"Auto Chest","AutoChest",3)
    toggle(togCard,"Auto Eat Fruit","AutoEatFruit",4)
    toggle(togCard,"Auto Respawn","AutoRespawn",5)
    toggle(togCard,"Safe Mode","SafeMode",6,function(on) S.FarmDelay=on and 0.3 or 0.12 end)

    -- Stop button
    btn(pFarm,"■  STOP ALL FARMING",Color3.fromRGB(36,14,14),2,function()
        S.AutoFarm=false S.AutoLevelFarm=false
        setStatus("Idle")
        notify("Farm","Stopped.",2,T.Red)
    end)

    -- Quick farm sections
    local qL2,qR2=twoCol(pFarm,3)
    local sea1Card=card(qL2,"Sea 1 — Quick Farm",1)
    for _,name in ipairs(SEA1_MOBS) do
        local info=nil
        for _,m in ipairs(MOBS) do if m.name==name and m.sea==1 then info=m break end end
        btn(sea1Card,name..(info and" [Lv "..info.minLv.."]"or""),T.Panel2,1,function()
            S.TargetMob=name S.AutoFarm=true S.AutoLevelFarm=false
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            setStatus("Farm: "..name) notify("Farm",name,2.5,T.Blue)
        end)
    end

    local sea2Card=card(qR2,"Sea 2 — Quick Farm",1)
    for _,name in ipairs(SEA2_MOBS) do
        local info=nil
        for _,m in ipairs(MOBS) do if m.name==name and m.sea==2 then info=m break end end
        btn(sea2Card,name..(info and" [Lv "..info.minLv.."]"or""),T.Panel2,1,function()
            S.TargetMob=name S.AutoFarm=true S.AutoLevelFarm=false
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            setStatus("Farm: "..name) notify("Farm",name,2.5,T.Blue)
        end)
    end

    local sea3Card=card(pFarm,"Sea 3 — Quick Farm",4)
    local s3L,s3R=twoCol(sea3Card,1)
    local half=#SEA3_MOBS//2
    for i,name in ipairs(SEA3_MOBS) do
        local info=nil
        for _,m in ipairs(MOBS) do if m.name==name and m.sea==3 then info=m break end end
        local tgt=i<=half and s3L or s3R
        btn(tgt,name..(info and" [Lv "..info.minLv.."]"or""),T.Panel2,i,function()
            S.TargetMob=name S.AutoFarm=true S.AutoLevelFarm=false
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            setStatus("Farm: "..name) notify("Farm",name,2.5,T.Blue)
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: COMBAT
    -- ════════════════════════════════════════
    local pCbt = makePage("Combat")
    local cL,cR = twoCol(pCbt,1)

    local kaCard=card(cL,"Kill Aura",1)
    toggle(kaCard,"Enable Kill Aura","KillAura",1,function(on)
        notify("Kill Aura",on and"ON"or"OFF",2.5,on and T.Red or T.Sub)
    end)
    sep(kaCard,2)
    slider(kaCard,"Range",nil,10,150,3,function(v) S.KillAuraRange=v end)
    S.KillAuraRange=S.KillAuraRange or 25

    local moveCard=card(cL,"Movement",2)
    toggle(moveCard,"Fly  (WASD+Space)","FlyEnabled",1,function(on)
        notify("Fly",on and"ON"or"OFF",2.5)
    end)
    slider(moveCard,"Fly Speed","FlySpeed",20,300,2)
    sep(moveCard,3)
    toggle(moveCard,"No Clip","NoClip",4)
    toggle(moveCard,"Infinite Jump","InfJump",5)

    local defCard=card(cR,"Defence",1)
    toggle(defCard,"God Mode","GodMode",1,function(on)
        notify("God Mode",on and"ON"or"OFF",2.5,on and T.Gold or T.Sub)
    end)
    toggle(defCard,"Anti-AFK","AntiAFK",2)

    local spCard=card(cR,"Walk Speed",2)
    slider(spCard,"Speed","WalkSpeed",16,300,1,function(v)
        local h=getHum() if h then h.WalkSpeed=v end
    end)
    sep(spCard,2)
    for i,sp in ipairs({16,32,50,100,200}) do
        btn(spCard,"→ "..sp,T.Panel2,2+i,function()
            S.WalkSpeed=sp
            local h=getHum() if h then h.WalkSpeed=sp end
        end)
    end

    local jpCard=card(cR,"Jump Power",3)
    slider(jpCard,"Power","JumpPower",50,500,1,function(v)
        local h=getHum() if h then h.JumpPower=v end
    end)
    sep(jpCard,2)
    for i,jp in ipairs({50,100,200,500}) do
        btn(jpCard,"→ "..jp,T.Panel2,2+i,function()
            S.JumpPower=jp
            local h=getHum() if h then h.JumpPower=jp end
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: TELEPORT
    -- ════════════════════════════════════════
    local pTP = makePage("TP")
    local tL,tR = twoCol(pTP,1)

    local frCard=card(tL,"Fruit Tracker",1)
    toggle(frCard,"Auto TP to Fruits","TPFruit",1)
    toggle(frCard,"Auto Eat Fruit","AutoEatFruit",2)
    btn(frCard,"Scan & TP Nearest",T.Panel2,3,function()
        local fruits=scanFruits()
        local root=getRoot()
        if not root then notify("Fruit","No character.",2,T.Red) return end
        if #fruits==0 then notify("Fruit","None found.",2,T.Red) return end
        table.sort(fruits,function(a,b)
            return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude
        end)
        tp(fruits[1].pos) STATS.fruitsTP=STATS.fruitsTP+1
        notify("Fruit","TP → "..fruits[1].name,3,T.Green)
    end)

    local s1iCard=card(tL,"Sea 1 — Islands",2)
    for _,d in ipairs(SEA1_ISLANDS) do
        btn(s1iCard,d[1],T.Panel2,1,function() tp(d[2]) notify("TP","→ "..d[1],2) end)
    end

    local s2iCard=card(tR,"Sea 2 — Islands",1)
    for _,d in ipairs(SEA2_ISLANDS) do
        btn(s2iCard,d[1],T.Panel2,1,function() tp(d[2]) notify("TP","→ "..d[1],2) end)
    end
    local s3iCard=card(tR,"Sea 3 — Islands",2)
    for _,d in ipairs(SEA3_ISLANDS) do
        btn(s3iCard,d[1],T.Panel2,1,function() tp(d[2]) notify("TP","→ "..d[1],2) end)
    end

    -- ════════════════════════════════════════
    --  TAB: BOSS
    -- ════════════════════════════════════════
    local pBoss = makePage("Boss")
    local bL,bR = twoCol(pBoss,1)

    local bCfg=card(bL,"Boss Config",1)
    local bossNames={} for k in pairs(BOSS_POS) do table.insert(bossNames,k) end table.sort(bossNames)
    dropdown(bCfg,"Boss",bossNames,"SelectedBoss",1)
    sep(bCfg,2)
    toggle(bCfg,"Auto Boss Farm","AutoBoss",3,function(on)
        if on then setStatus("Boss: "..S.SelectedBoss)
        else      setStatus("Idle") end
        notify("Boss",on and"Started: "..S.SelectedBoss or"Stopped.",2.5,on and T.Gold or T.Sub)
    end)

    local bTP=card(bR,"Quick TP",1)
    for _,name in ipairs(bossNames) do
        btn(bTP,name,T.Panel2,1,function()
            local pos=BOSS_POS[name] if pos then tp(pos) notify("Boss","→ "..name,2) end
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: RAID
    -- ════════════════════════════════════════
    local pRaid = makePage("Raid")
    local rL,rR = twoCol(pRaid,1)

    local rCfg=card(rL,"Raid Config",1)
    local raidNames={} for k in pairs(RAID_POS) do table.insert(raidNames,k) end table.sort(raidNames)
    dropdown(rCfg,"Raid",raidNames,"SelectedRaid",1)
    sep(rCfg,2)
    toggle(rCfg,"Auto Raid","AutoRaid",3,function(on)
        if on then setStatus("Raid: "..S.SelectedRaid)
        else      setStatus("Idle") end
        notify("Raid",on and"Started: "..S.SelectedRaid or"Stopped.",2.5,on and T.Gold or T.Sub)
    end)

    local rTP=card(rR,"Quick TP",1)
    for _,name in ipairs(raidNames) do
        btn(rTP,name,T.Panel2,1,function()
            local pos=RAID_POS[name] if pos then tp(pos) notify("Raid","→ "..name,2) end
        end)
    end

    -- ════════════════════════════════════════
    --  TAB: ESP
    -- ════════════════════════════════════════
    local pESP = makePage("ESP")
    local eL,eR = twoCol(pESP,1)

    local peCard=card(eL,"Player ESP",1)
    toggle(peCard,"Enable Player ESP","PlayerESP",1,function(on)
        notify("Player ESP",on and"ON"or"OFF",2,on and T.Blue or T.Sub)
    end)
    toggle(peCard,"Show Health","PlayerESP",2) -- reuses toggle visually

    local meCard=card(eL,"Mob ESP",2)
    toggle(meCard,"Enable Mob ESP","MobESP",1,function(on)
        notify("Mob ESP",on and"ON"or"OFF",2,on and T.Blue or T.Sub)
    end)

    local feCard=card(eR,"Fruit ESP",1)
    toggle(feCard,"Enable Fruit ESP","FruitESP",1,function(on)
        notify("Fruit ESP",on and"ON"or"OFF",2,on and T.Green or T.Sub)
    end)

    local espInfo=card(eR,"ESP Info",2)
    if HAS_DRAW then
        infoRow(espInfo,"Engine","Drawing API",1)
    else
        infoRow(espInfo,"Engine","BillboardGui",1)
    end
    infoRow(espInfo,"Status","Active",2)

    -- ════════════════════════════════════════
    --  TAB: VISUAL
    -- ════════════════════════════════════════
    local pVis = makePage("Visual")
    local vL,vR = twoCol(pVis,1)

    local lightCard=card(vL,"Lighting",1)
    toggle(lightCard,"Fullbright","Fullbright",1,function(on)
        Lighting.Brightness=on and 3.5 or 1
        Lighting.FogEnd=on and 1e6 or 1e4
        notify("Fullbright",on and"ON"or"OFF",2)
    end)
    toggle(lightCard,"No Fog","NoFog",2,function(on)
        Lighting.FogEnd=on and 1e6 or 1e4
        notify("No Fog",on and"ON"or"OFF",2)
    end)

    local camCard=card(vL,"Camera",2)
    slider(camCard,"FOV","FOV",40,120,1,function(v)
        Camera.FieldOfView=v
    end)

    local dispCard=card(vR,"Display",1)
    toggle(dispCard,"Show FPS","ShowFPS",1)
    toggle(dispCard,"Show Watermark","ShowWatermark",2)

    -- ════════════════════════════════════════
    --  TAB: MISC / STATS
    -- ════════════════════════════════════════
    local pMisc = makePage("Misc")
    local mL,mR = twoCol(pMisc,1)

    -- Player info card
    local plCard=card(mL,"Player Info",1)
    infoRow(plCard,"Display Name",DISPLAY_NAME,1)
    infoRow(plCard,"Username",USERNAME,2)
    infoRow(plCard,"Executor",EXEC_NAME,3)
    sep(plCard,4)
    local sesInfoLbl=infoRow(plCard,"Session",fmtTime(0),5)
    task.spawn(function()
        while task.wait(1) do
            if not sesInfoLbl.Parent then break end
            sesInfoLbl.Text=fmtTime(os.time()-STATS.startTime)
        end
    end)

    local statsCard=card(mL,"Session Stats",2)
    local kLbl=infoRow(statsCard,"Kills",0,1)
    local dLbl=infoRow(statsCard,"Deaths",0,2)
    local fLbl=infoRow(statsCard,"Fruits TP",0,3)
    local cLbl=infoRow(statsCard,"Chests",0,4)
    local qLbl=infoRow(statsCard,"Quests",0,5)
    task.spawn(function()
        while task.wait(2) do
            if not kLbl.Parent then break end
            kLbl.Text=tostring(STATS.kills)
            dLbl.Text=tostring(STATS.deaths)
            fLbl.Text=tostring(STATS.fruitsTP)
            cLbl.Text=tostring(STATS.chestsTP)
            qLbl.Text=tostring(STATS.quests)
        end
    end)

    local cfgCard2=card(mR,"Config",1)
    btn(cfgCard2,"Save Config",T.Panel2,1,function()
        saveConfig(S) notify("Config","Saved!",2,T.Green)
    end)
    btn(cfgCard2,"Reset to Defaults",Color3.fromRGB(36,14,14),2,function()
        for k,v in pairs(cfgDefault()) do S[k]=v end
        saveConfig(S)
        notify("Config","Reset to defaults.",2.5,T.Gold)
    end)

    local infoCard=card(mR,"Info",2)
    infoRow(infoCard,"Version","v1.0.0",1)
    infoRow(infoCard,"Discord","discord.gg/EmsMsHZCVH",2)
    sep(infoCard,3)
    btn(infoCard,"Copy Discord Link",T.Panel2,4,function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        notify("Discord","Link copied!",2,T.Blue)
    end)

    -- Activate first tab
    goFarm()

    return sg
end

-- ════════════════════════════════════════
--  GAME LOOPS
-- ════════════════════════════════════════

-- Fly
task.spawn(function()
    local flyBody
    while task.wait(0.05) do
        if S.FlyEnabled and isAlive() then
            local root,hum=getRoot(),getHum()
            if root and hum then
                if not flyBody or not flyBody.Parent then
                    flyBody=Instance.new("BodyVelocity")
                    flyBody.MaxForce=Vector3.new(1e5,1e5,1e5)
                    flyBody.Velocity=Vector3.zero
                    flyBody.Parent=root
                end
                hum.PlatformStand=true
                local dir=Vector3.zero
                local cam=Camera.CFrame
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir=dir+Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
                flyBody.Velocity=dir.Magnitude>0 and dir.Unit*(S.FlySpeed or 60) or Vector3.zero
            end
        else
            if flyBody and flyBody.Parent then
                flyBody:Destroy() flyBody=nil
                local h=getHum() if h then h.PlatformStand=false end
            end
        end
    end
end)

-- NoClip
task.spawn(function()
    while task.wait(0.03) do
        if S.NoClip then
            local char=getChar()
            if char then
                for _,p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide=false end
                end
            end
        end
    end
end)

-- GodMode
task.spawn(function()
    while task.wait(0.08) do
        if S.GodMode then
            local h=getHum()
            if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end
        end
    end
end)

-- InfJump
UserInputService.JumpRequest:Connect(function()
    if S.InfJump then
        local h=getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- AutoRespawn
LP.CharacterAdded:Connect(function(char)
    if not S.AutoRespawn then return end
    local h=char:WaitForChild("Humanoid",5)
    if h then h.Died:Connect(function()
        task.wait(3.5)
        if S.AutoRespawn then pcall(function() LP:LoadCharacter() end) end
    end) end
end)

-- Main Farm loop
task.spawn(function()
    while task.wait(S.FarmDelay or 0.12) do
        if not (S.AutoFarm or S.AutoLevelFarm) then continue end
        if not isAlive() then if S.AutoRespawn then task.wait(3) end continue end
        if S.AutoLevelFarm then
            local lv=getPlayerLevel()
            local mob=getMobForLevel(lv)
            if mob~=S.TargetMob then
                S.TargetMob=mob
                setStatus("Auto-Farm: "..mob)
                notify("Level Up!","→ Farming: "..mob,3,T.Gold)
            end
        end
        local target=findMob(S.TargetMob,500)
        if target then
            local killed=attack(target)
            if killed then STATS.kills=STATS.kills+1 end
        else
            local sp=MOB_SPAWN[S.TargetMob]
            if sp then
                local root=getRoot()
                if root and (root.Position-sp).Magnitude>150 then
                    tp(sp) task.wait(S.SafeMode and 2.5 or 1.5)
                end
            end
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.08) do
        if not S.KillAura then continue end
        if not isAlive() then continue end
        local root=getRoot() if not root then continue end
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.KillAura then break end
            if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health>0 then
                    if (hrp.Position-root.Position).Magnitude<=(S.KillAuraRange or 25) then
                        if HAS_FTI then
                            pcall(firetouchinterest,hrp,root,0) task.wait(0.02)
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

-- Auto Boss
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoBoss then continue end
        if not isAlive() then if S.AutoRespawn then task.wait(3) end continue end
        local boss=findMob(S.SelectedBoss,9999)
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

-- Auto Raid
task.spawn(function()
    while task.wait(0.18) do
        if not S.AutoRaid then continue end
        if not isAlive() then if S.AutoRespawn then task.wait(3) end continue end
        local rp=RAID_POS[S.SelectedRaid]
        local root=getRoot()
        if root and rp and (root.Position-rp).Magnitude>200 then tp(rp) task.wait(1.5) end
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.AutoRaid then break end
            if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                local r2=getRoot()
                if hum and hrp and r2 and hum.Health>0 and (hrp.Position-r2.Position).Magnitude<350 then
                    local killed=attack(obj)
                    if killed then STATS.kills=STATS.kills+1 end
                    task.wait(0.07)
                end
            end
        end
    end
end)

-- Fruit TP loop
task.spawn(function()
    while task.wait(4) do
        if not S.TPFruit then continue end
        if not isAlive() then continue end
        local fruits=scanFruits()
        local root=getRoot()
        if root and #fruits>0 then
            table.sort(fruits,function(a,b)
                return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude
            end)
            local f=fruits[1]
            tp(f.pos) STATS.fruitsTP=STATS.fruitsTP+1
            notify("Fruit TP","→ "..f.name,3,T.Green)
            if S.AutoEatFruit and HAS_FTI and f.part then
                task.wait(0.3)
                local r2=getRoot()
                if r2 then
                    pcall(firetouchinterest,f.part,r2,0) task.wait(0.1)
                    pcall(firetouchinterest,f.part,r2,1)
                end
            end
        end
    end
end)

-- Auto Eat (nearby)
task.spawn(function()
    while task.wait(2) do
        if not S.AutoEatFruit then continue end
        if not isAlive() then continue end
        local fruits=scanFruits()
        local root=getRoot()
        if root and #fruits>0 then
            table.sort(fruits,function(a,b)
                return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude
            end)
            local f=fruits[1]
            if (f.pos-root.Position).Magnitude<30 and HAS_FTI and f.part then
                local r2=getRoot()
                if r2 then
                    pcall(firetouchinterest,f.part,r2,0) task.wait(0.1)
                    pcall(firetouchinterest,f.part,r2,1)
                    notify("Auto Eat","Ate: "..f.name,2,T.Green)
                end
            end
        end
    end
end)

-- Auto Chest
task.spawn(function()
    while task.wait(3) do
        if not S.AutoChest then continue end
        if not isAlive() then continue end
        local chests=scanChests()
        local root=getRoot()
        if root and #chests>0 then
            table.sort(chests,function(a,b)
                return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude
            end)
            local c=chests[1]
            tp(c.pos)
            if HAS_FTI and c.part then
                local r2=getRoot()
                if r2 then
                    pcall(firetouchinterest,c.part,r2,0) task.wait(0.1)
                    pcall(firetouchinterest,c.part,r2,1)
                    STATS.chestsTP=STATS.chestsTP+1
                end
            end
        end
    end
end)

-- Auto Quest
task.spawn(function()
    while task.wait(6) do
        if not S.AutoQuest then continue end
        if not isAlive() then continue end
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
                        local pos=(hrp:IsA("BasePart") and hrp or hrp).Position
                        if (pos-root.Position).Magnitude>20 then tp(pos) task.wait(1) end
                        if HAS_FTI then
                            local r2=getRoot()
                            local part=hrp:IsA("BasePart") and hrp or hrp:FindFirstChildWhichIsA("BasePart")
                            if r2 and part then
                                pcall(firetouchinterest,part,r2,0) task.wait(0.1)
                                pcall(firetouchinterest,part,r2,1)
                            end
                        end
                        for _,v in pairs(obj:GetDescendants()) do
                            if v:IsA("RemoteEvent") then pcall(function() v:FireServer() end) end
                        end
                        STATS.quests=STATS.quests+1
                        notify("Quest","Accepted!",2.5,T.Gold)
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
    task.wait(5)
    local sg=inst("ScreenGui",{Name="_EHD",ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    local f=inst("Frame",{Size=UDim2.new(0,264,0,110),
        Position=UDim2.new(0.5,-132,1,10),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg})
    corner(f,8) stroke(f,T.Blue,1.5)
    inst("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=f})
    local ic=inst("Frame",{Size=UDim2.new(0,30,0,30),Position=UDim2.new(0,12,0,14),
        BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=f})
    corner(ic,15)
    inst("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        Text="D",Font=Enum.Font.GothamBlack,TextSize=14,TextColor3=Color3.new(1,1,1),Parent=ic})
    inst("TextLabel",{Size=UDim2.new(1,-56,0,16),Position=UDim2.new(0,52,0,12),
        BackgroundTransparency=1,Text="Join Elite Hub Discord",
        Font=Enum.Font.GothamBlack,TextSize=10.5,TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    inst("TextLabel",{Size=UDim2.new(1,-56,0,18),Position=UDim2.new(0,52,0,28),
        BackgroundTransparency=1,Text="Updates, support & new features",
        Font=Enum.Font.Gotham,TextSize=8.5,TextColor3=T.Sub,
        TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=f})
    local lf=inst("Frame",{Size=UDim2.new(1,-18,0,22),Position=UDim2.new(0,9,0,60),
        BackgroundColor3=Color3.fromRGB(10,10,10),BorderSizePixel=0,Parent=f})
    corner(lf,5) stroke(lf,T.Border)
    inst("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,Text="discord.gg/EmsMsHZCVH",
        Font=Enum.Font.GothamBold,TextSize=9.5,TextColor3=T.Blue,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=lf})
    local cp=inst("TextButton",{Size=UDim2.new(0,64,0,20),Position=UDim2.new(0,9,1,-28),
        BackgroundColor3=T.Blue,Text="Copy",Font=Enum.Font.GothamBold,TextSize=9.5,
        TextColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=f})
    corner(cp)
    cp.MouseButton1Click:Connect(function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        cp.Text="Copied!" task.wait(1.5) cp.Text="Copy"
    end)
    local xb=inst("TextButton",{Size=UDim2.new(0,18,0,18),Position=UDim2.new(1,-24,0,6),
        BackgroundColor3=T.Dim,Text="×",Font=Enum.Font.GothamBold,TextSize=10,
        TextColor3=T.Sub,BorderSizePixel=0,Parent=f})
    corner(xb,9)
    xb.MouseButton1Click:Connect(function()
        tw(f,{Position=UDim2.new(0.5,-132,1,10)},0.22)
        task.wait(0.26) sg:Destroy()
    end)
    tw(f,{Position=UDim2.new(0.5,-132,1,-122)},0.36,Enum.EasingStyle.Back)
    task.delay(15,function()
        if sg.Parent then
            tw(f,{Position=UDim2.new(0.5,-132,1,10)},0.22)
            task.wait(0.26) pcall(function() sg:Destroy() end)
        end
    end)
end

-- ════════════════════════════════════════
--  BOOT
-- ════════════════════════════════════════
task.spawn(function()
    showLoader()
    task.wait(0.1)
    _guiRef = buildGUI()
    startFPS()
    startAntiAFK()
    buildWatermark()
    if HAS_DRAW then startESP() end
    task.wait(0.3)
    notify("Elite Hub v1.0.0",
        "Loaded — RShift to toggle"..(IS_DELTA and" [Delta]"or""),3.5,T.Accent)
    task.defer(discordPopup)
end)

print("╔═════════════════════════════════════════╗")
print("║  Elite Hub v1.0.0  |  Blox Fruits      ║")
print("║  All Seas  |  Lv 1 - 2800              ║")
print("║  Delta-Optimized  |  Xeno/Solara BLOCK  ║")
print("║  discord.gg/EmsMsHZCVH                 ║")
print("╚═════════════════════════════════════════╝")
if IS_DELTA then
    print("[EliteHub] Delta confirmed — full feature set active.")
end
