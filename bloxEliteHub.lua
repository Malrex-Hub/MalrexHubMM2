-- ╔═══════════════════════════════════════════╗
-- ║  ELITE HUB  v1.0.0                       ║
-- ║  Blox Fruits  |  All Seas                ║
-- ║  Optimized for Delta Executor            ║
-- ║  discord.gg/EmsMsHZCVH                   ║
-- ╚═══════════════════════════════════════════╝

-- ════════════════════════════
--  DELTA DETECTION & COMPAT
-- ════════════════════════════
local IS_DELTA       = false
local HAS_DRAW       = typeof(Drawing) == "table"
local HAS_WRITEFILE  = typeof(writefile) == "function"
local HAS_READFILE   = typeof(readfile)  == "function"
local HAS_FTI        = typeof(firetouchinterest) == "function"
local HAS_NCC        = typeof(newcclosure) == "function"
local HAS_CLONEREF   = typeof(cloneref)  == "function"

pcall(function()
    local exec = identifyexecutor and identifyexecutor() or ""
    IS_DELTA = exec:lower():find("delta") ~= nil
end)

local function wrap(f) return (HAS_NCC and newcclosure or function(x) return x end)(f) end
local function ref(s)  return (HAS_CLONEREF and cloneref or function(x) return x end)(s) end

-- ════════════════════════════
--  SERVICES  (cloneref on Delta)
-- ════════════════════════════
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

-- ════════════════════════════
--  CONFIG FILE  (Delta: writefile/readfile)
-- ════════════════════════════
local CFG_PATH = "EliteHub_config.json"

local function cfgDefault()
    return {
        AutoFarm=false, TargetMob="Bandit", FarmMethod="Melee", SafeMode=false, FarmDelay=0.12,
        AutoBoss=false, SelectedBoss="Gorilla King",
        AutoRaid=false, SelectedRaid="Flame",
        TPFruit=false, AutoChest=false, AutoQuest=false, AutoEatFruit=false,
        KillAura=false, KillAuraRange=25,
        FlyEnabled=false, FlySpeed=60,
        NoClip=false, GodMode=false,
        AntiAFK=true, AutoRespawn=true, InfJump=false,
        ShowFPS=true, ShowWatermark=true,
        PlayerESP=false, MobESP=false, FruitESP=false, ESPMode="Drawing",
        Fullbright=false, NoFog=false, FOV=70,
        WalkSpeed=16, JumpPower=50,
    }
end

local function saveConfig(data)
    if not HAS_WRITEFILE then return end
    pcall(function()
        local t={}
        for k,v in pairs(data) do t[k]=v end
        local s="" for k,v in pairs(t) do
            local val = type(v)=="boolean" and (v and "true" or "false") or
                        type(v)=="number"  and tostring(v) or
                        '"'..tostring(v)..'"'
            s = s .. '"'..k..'":'..val..","
        end
        writefile(CFG_PATH, "{"..s:sub(1,-2).."}")
    end)
end

local function loadConfig()
    if not HAS_READFILE then return cfgDefault() end
    local ok,raw = pcall(readfile, CFG_PATH)
    if not ok or not raw then return cfgDefault() end
    local d = cfgDefault()
    pcall(function()
        for k in pairs(d) do
            local pat = '"'..k..'":(.-)[,}]'
            local v = raw:match(pat)
            if v then
                if v=="true"  then d[k]=true
                elseif v=="false" then d[k]=false
                elseif tonumber(v) then d[k]=tonumber(v)
                else d[k]=v:gsub('"','') end
            end
        end
    end)
    return d
end

local S = loadConfig()

-- ════════════════════════════
--  MOB DATABASE  (all 3 seas, expanded)
-- ════════════════════════════
local MOBS = {
    -- ── SEA 1 ──────────────────────────────────────────────────────────────
    { sea=1, name="Bandit",            pos=Vector3.new(  979, 125,  1570) },
    { sea=1, name="Monkey",            pos=Vector3.new(-1500, 125,  -200) },
    { sea=1, name="Gorilla",           pos=Vector3.new(-1700, 125,  -310) },
    { sea=1, name="Pirate",            pos=Vector3.new(-1200, 125,  4350) },
    { sea=1, name="Brute",             pos=Vector3.new(-1100, 125,  4500) },
    { sea=1, name="Desert Bandit",     pos=Vector3.new(  870, 125,  4000) },
    { sea=1, name="Desert Officer",    pos=Vector3.new( 1050, 125,  4200) },
    { sea=1, name="Snow Bandit",       pos=Vector3.new( 1200, 125, -2700) },
    { sea=1, name="Snowman",           pos=Vector3.new( 1300, 125, -2850) },
    { sea=1, name="Marine",            pos=Vector3.new( -900, 125,  -350) },
    { sea=1, name="Sky Bandit",        pos=Vector3.new(-4700, 875,  -700) },
    { sea=1, name="Dark Master",       pos=Vector3.new(-4950,1410,  -700) },
    { sea=1, name="Carpenter",         pos=Vector3.new(-1190, 125,  4380) },
    { sea=1, name="Toga Warrior",      pos=Vector3.new( 3324, 127, -2640) },
    { sea=1, name="Npc",               pos=Vector3.new(  100, 125,   100) },
    -- ── SEA 2 ──────────────────────────────────────────────────────────────
    { sea=2, name="Hoodlum",               pos=Vector3.new(  -750, 266,    550) },
    { sea=2, name="Trader",                pos=Vector3.new(  -900, 266,    650) },
    { sea=2, name="Assassin",              pos=Vector3.new( -9500, 125,  -1700) },
    { sea=2, name="Swan Pirate",           pos=Vector3.new(   880, 125,  29250) },
    { sea=2, name="Forest Pirate",         pos=Vector3.new( -3550, 125,   1850) },
    { sea=2, name="Snow Demon",            pos=Vector3.new( -4500,1010,  -1050) },
    { sea=2, name="Zombie",                pos=Vector3.new( -5800, 125,   -620) },
    { sea=2, name="Vampire",               pos=Vector3.new( -5900, 125,   -700) },
    { sea=2, name="Living Zombie",         pos=Vector3.new( -5950, 125,   -750) },
    { sea=2, name="Demonic Soul",          pos=Vector3.new( -5200, 125,  -1720) },
    { sea=2, name="Poseidon Soldier",      pos=Vector3.new( 61350, 125,   1780) },
    { sea=2, name="Poseidon Knight",       pos=Vector3.new( 61450, 125,   1850) },
    { sea=2, name="Dragon Crew Warrior",   pos=Vector3.new(  3600, 125,  29450) },
    { sea=2, name="Dragon Crew Archer",    pos=Vector3.new(  3700, 125,  29550) },
    { sea=2, name="Factory Staff",         pos=Vector3.new( -3300, 125,   2000) },
    { sea=2, name="Military Soldier",      pos=Vector3.new(-10000, 125,  -2000) },
    { sea=2, name="Military Spy",          pos=Vector3.new( -9800, 125,  -1900) },
    { sea=2, name="Arctic Warrior",        pos=Vector3.new( -4300,1000,  -1000) },
    { sea=2, name="Snow Lurker",           pos=Vector3.new( -4600,1020,  -1100) },
    { sea=2, name="Ship Crew",             pos=Vector3.new( -5200, 125,  -1780) },
    { sea=2, name="Cursed Pirate",         pos=Vector3.new( -5300, 125,  -1800) },
    -- ── SEA 3 ──────────────────────────────────────────────────────────────
    { sea=3, name="Galley Pirate",         pos=Vector3.new( -2000,  50,  -4200) },
    { sea=3, name="Pirate Millionaire",    pos=Vector3.new( -2100,  50,  -4300) },
    { sea=3, name="Jungle Bug",            pos=Vector3.new( -3200, 125,  -3800) },
    { sea=3, name="Laboon",                pos=Vector3.new( -3350, 125,  -3950) },
    { sea=3, name="Forest Dragon",         pos=Vector3.new( -9000, 400,  -2500) },
    { sea=3, name="Tree Spider",           pos=Vector3.new( -9100, 400,  -2600) },
    { sea=3, name="Demonic Soul",          pos=Vector3.new( -6600, 125,  -2750) },
    { sea=3, name="Reborn Skeleton",       pos=Vector3.new(-11400, 400,  -1000) },
    { sea=3, name="Soul Reaper",           pos=Vector3.new(-11600, 400,  -1080) },
    { sea=3, name="Cursed Skeleton",       pos=Vector3.new(-11500, 400,  -1040) },
    { sea=3, name="Chocolate Bar Battler", pos=Vector3.new(-13950, 125,   3800) },
    { sea=3, name="Cake Guard",            pos=Vector3.new(-14000, 125,   3850) },
    { sea=3, name="Baking Staff",          pos=Vector3.new(-14100, 125,   3900) },
    { sea=3, name="Candy Rebel",           pos=Vector3.new(-11650, 125,   5450) },
    { sea=3, name="Cocoa Warrior",         pos=Vector3.new(-12300, 125,   4950) },
    { sea=3, name="Snow Lurker",           pos=Vector3.new(-14250, 125,  -2050) },
    { sea=3, name="Ice Cream Staff",       pos=Vector3.new(-14050, 125,   3780) },
    { sea=3, name="Brawler Crab",          pos=Vector3.new(-14500, 243,  -1000) },
    { sea=3, name="Terrorshark",           pos=Vector3.new(-14600, 243,  -1050) },
    { sea=3, name="Mythological Pirate",   pos=Vector3.new(-15100, 125,  -1750) },
    { sea=3, name="Leviathan",             pos=Vector3.new(-13050, 125,  -4650) },
    { sea=3, name="Sea Soldier",           pos=Vector3.new( -2050,  50,  -4180) },
    { sea=3, name="Marine Lieutenant",     pos=Vector3.new( -2150,  50,  -4260) },
    { sea=3, name="Diablo",               pos=Vector3.new( -8300, 125,   1600) },
    { sea=3, name="Beautiful Pirate",      pos=Vector3.new( -8350, 125,   1650) },
    { sea=3, name="Tiki Outpost Raider",   pos=Vector3.new( -8280, 125,  -1000) },
    { sea=3, name="Longma",               pos=Vector3.new(  3640, 125,  29500) },
}

local MOB_SPAWN = {}
for _, m in ipairs(MOBS) do MOB_SPAWN[m.name] = m.pos end

local SEA1_MOBS, SEA2_MOBS, SEA3_MOBS = {}, {}, {}
for _, m in ipairs(MOBS) do
    if     m.sea==1 then table.insert(SEA1_MOBS, m.name)
    elseif m.sea==2 then table.insert(SEA2_MOBS, m.name)
    else                 table.insert(SEA3_MOBS, m.name) end
end

-- ════════════════════════════
--  ISLAND TP DATA
-- ════════════════════════════
local SEA1_ISLANDS = {
    {"Starter Island",   Vector3.new(  1260, 125,  1612)},
    {"Marine Starter",   Vector3.new( -1180, 125, -1174)},
    {"Middle Town",      Vector3.new(  -192, 125,  -559)},
    {"Jungle",           Vector3.new( -1646, 125,  -261)},
    {"Pirate Village",   Vector3.new( -1189, 125,  4403)},
    {"Desert",           Vector3.new(   924, 125,  4089)},
    {"Frozen Village",   Vector3.new(  1175, 125, -1818)},
    {"Snowy Village",    Vector3.new(  1326, 125, -2882)},
    {"Marine Fortress",  Vector3.new(  -965, 125,  -380)},
    {"Skylands",         Vector3.new( -4755, 872,  -718)},
    {"Upper Skylands",   Vector3.new( -5004,1400,  -718)},
    {"Fountain City",    Vector3.new(  3324, 127, -2610)},
}
local SEA2_ISLANDS = {
    {"Kingdom of Rose",  Vector3.new(  -804, 266,    604)},
    {"Dark Arena",       Vector3.new( -9564, 125,  -1754)},
    {"Usoapp Island",    Vector3.new( -2581, 125,   1500)},
    {"Green Zone",       Vector3.new( -3626, 125,   1900)},
    {"Graveyard",        Vector3.new( -5878, 125,   -670)},
    {"Snow Mountain",    Vector3.new( -4550,1000,  -1100)},
    {"Hot and Cold",     Vector3.new( -3620, 125,  -2945)},
    {"Cursed Ship",      Vector3.new( -5237, 125,  -1765)},
    {"Ice Castle",       Vector3.new( -3966, 125,  -1120)},
    {"Forgotten Island", Vector3.new( -6000, 125,  -1700)},
    {"Colosseum",        Vector3.new(   926, 125,  29310)},
    {"Magma Village",    Vector3.new(   500, 125,  29650)},
    {"Underwater City",  Vector3.new( 61421, 125,   1819)},
    {"Wano",             Vector3.new(  3640, 125,  29500)},
}
local SEA3_ISLANDS = {
    {"Port Town",        Vector3.new( -2076,  49,  -4246)},
    {"Hydra Island",     Vector3.new( -3281, 125,  -3900)},
    {"Great Tree",       Vector3.new( -9084, 400,  -2573)},
    {"Mansion",          Vector3.new( -6640, 125,  -2800)},
    {"Tiki Outpost",     Vector3.new( -8279, 125,  -1024)},
    {"Buggy Island",     Vector3.new( -8420, 125,   1630)},
    {"Floating Turtle",  Vector3.new(-14553, 243,  -1014)},
    {"Haunted Castle",   Vector3.new(-11540, 400,  -1044)},
    {"Distant Island",   Vector3.new(-13000, 125,  -4700)},
    {"Sea of Treats",    Vector3.new(-14055, 125,   3829)},
    {"Peanut Island",    Vector3.new(-13350, 125,   4100)},
    {"Cake Land",        Vector3.new(-12350, 125,   5000)},
    {"Candy Island",     Vector3.new(-11700, 125,   5500)},
    {"Ice Berg",         Vector3.new(-14300, 125,  -2100)},
    {"Labyrinth",        Vector3.new(-15200, 125,  -1800)},
}

-- ════════════════════════════
--  RAID DATA
-- ════════════════════════════
local RAID_POS = {
    ["Flame"]   = Vector3.new(  3066,  28,  2760),
    ["Ice"]     = Vector3.new(  1227,  28, -2204),
    ["Rumble"]  = Vector3.new( -4755, 872,  -718),
    ["Quake"]   = Vector3.new( -1180,  28, -1174),
    ["Light"]   = Vector3.new(  3324,  28, -2610),
    ["Dark"]    = Vector3.new( -9084,  28, -2573),
    ["Buddha"]  = Vector3.new(  -804,  28,   604),
    ["Venom"]   = Vector3.new( -5237,  28, -1765),
    ["Phoenix"] = Vector3.new( -3966,  28, -1120),
    ["Dough"]   = Vector3.new(-12350,  28,  5000),
    ["Shadow"]  = Vector3.new(-11540,  28, -1044),
    ["Portal"]  = Vector3.new(-14553,  28, -1014),
    ["Control"] = Vector3.new(-15200,  28, -1800),
    ["Dragon"]  = Vector3.new( -9564,  28, -1754),
    ["Leopard"] = Vector3.new(-14300,  28, -2100),
    ["T-Rex"]   = Vector3.new(-13000,  28, -4700),
}

-- ════════════════════════════
--  BOSS DATA
-- ════════════════════════════
local BOSS_POS = {
    ["Gorilla King"]   = Vector3.new( -1700, 125,  -310),
    ["Bobby"]          = Vector3.new( -1189, 125,  4403),
    ["Yeti"]           = Vector3.new(  1300, 125, -2880),
    ["Darkbeard"]      = Vector3.new( -9564, 125, -1754),
    ["Rip_Indra"]      = Vector3.new( -9084, 400, -2573),
    ["Thunder God"]    = Vector3.new( -4755, 872,  -718),
    ["Tide Keeper"]    = Vector3.new( 61421, 125,  1819),
    ["Stone"]          = Vector3.new( -5237, 125, -1765),
    ["Island Empress"] = Vector3.new( -3966, 125, -1120),
    ["Longma"]         = Vector3.new(  3640, 125, 29500),
    ["Cake Prince"]    = Vector3.new(-12350, 125,  5000),
    ["Kilo Admiral"]   = Vector3.new(   924, 125,  4089),
    ["Vice Admiral"]   = Vector3.new(  -965, 125,  -380),
    ["Magma Admiral"]  = Vector3.new(   500, 125, 29650),
    ["Order"]          = Vector3.new(-14553, 243, -1014),
    ["Cursed Captain"] = Vector3.new(-14300, 125, -2100),
    ["Bartolomeo"]     = Vector3.new(   926, 125, 29310),
    ["Greybeard"]      = Vector3.new(  -965, 125,  -380),
    ["Don Swan"]       = Vector3.new( -9564, 125, -1754),
}

-- ════════════════════════════
--  THEME  (black & white)
-- ════════════════════════════
local T = {
    BG    = Color3.fromRGB(  8,  8,  8),
    Panel = Color3.fromRGB( 18, 18, 18),
    Panel2= Color3.fromRGB( 26, 26, 26),
    Border= Color3.fromRGB( 55, 55, 55),
    Accent= Color3.fromRGB(255,255,255),
    Text  = Color3.fromRGB(240,240,240),
    Sub   = Color3.fromRGB(130,130,130),
    Dim   = Color3.fromRGB( 60, 60, 60),
    Green = Color3.fromRGB(100,220,100),
    Red   = Color3.fromRGB(220, 80, 80),
    Gold  = Color3.fromRGB(220,180, 60),
    Blue  = Color3.fromRGB(100,140,255),
    TabOn = Color3.fromRGB(255,255,255),
    TabOff= Color3.fromRGB( 22, 22, 22),
}

-- ════════════════════════════
--  CORE UTILS
-- ════════════════════════════
local function tw(obj, props, t, sty)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, sty or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function new(cls, p)
    local o = Instance.new(cls)
    for k,v in pairs(p) do if k~="Parent" then o[k]=v end end
    if p.Parent then o.Parent=p.Parent end
    return o
end

local function corner(o, r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 6) c.Parent=o end
local function pad(o, t, l, r, b)
    local p=Instance.new("UIPadding")
    p.PaddingTop=UDim.new(0,t or 0) p.PaddingLeft=UDim.new(0,l or 0)
    p.PaddingRight=UDim.new(0,r or 0) p.PaddingBottom=UDim.new(0,b or 0)
    p.Parent=o
end
local function list(o, dir, pad_)
    local l=Instance.new("UIListLayout")
    l.FillDirection=dir or Enum.FillDirection.Vertical
    l.SortOrder=Enum.SortOrder.LayoutOrder
    if pad_ then l.Padding=UDim.new(0,pad_) end
    l.Parent=o return l
end

local function getChar()  return LP.Character end
local function getHum()   local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()  local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function alive()    local h=getHum() return h and h.Health>0 end

-- Step-based lerp TP (5 steps) — avoids kick detection
local function tp(pos)
    local root=getRoot() if not root then return end
    local goal = pos + Vector3.new(0, 3, 0)
    local from = root.CFrame.Position
    for i=1,5 do
        root.CFrame = CFrame.new(from:Lerp(goal, i/5))
        task.wait(0.03)
    end
end

-- Instant TP (Delta: used internally for kill aura & safe scenarios)
local function tpInstant(pos)
    local root=getRoot() if not root then return end
    root.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
end

local function findMobInWorld(name, radius)
    local root=getRoot() if not root then return nil end
    local best, bestD = nil, radius or 500
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local n=obj.Name
            if n==name or n:lower():find(name:lower(),1,true) then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health>0 and obj~=getChar() then
                    local d=(hrp.Position-root.Position).Magnitude
                    if d<bestD then best,bestD=obj,d end
                end
            end
        end
    end
    return best
end

-- Delta: use firetouchinterest for reliable hit, fallback to RemoteEvent + TakeDamage
local function attack(mob)
    if not mob then return end
    local hrp=mob:FindFirstChild("HumanoidRootPart") if not hrp then return end
    tp(hrp.Position + Vector3.new(0,0,2))
    -- firetouchinterest (Delta-native)
    if HAS_FTI then
        local root=getRoot()
        if root then
            pcall(firetouchinterest, hrp, root, 0)
            task.wait(0.05)
            pcall(firetouchinterest, hrp, root, 1)
        end
    end
    -- RemoteEvent fire on equipped tools
    local char=getChar() if not char then return end
    for _,tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _,v in pairs(tool:GetDescendants()) do
                if v:IsA("RemoteEvent") then pcall(function() v:FireServer() end) end
                if v:IsA("RemoteFunction") then pcall(function() v:InvokeServer() end) end
            end
        end
    end
    -- TakeDamage fallback
    pcall(function()
        local hum=mob:FindFirstChildOfClass("Humanoid")
        if hum then hum:TakeDamage(9999) end
    end)
end

local FRUIT_KW = {"fruit","devil","df_","logia","paramecia","zoan","ancient","mythical","awaken"}
local function scanFruits()
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        for _,kw in ipairs(FRUIT_KW) do
            if n:find(kw,1,true) then
                local ref=obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if ref then table.insert(found,{name=obj.Name,pos=ref.Position,obj=obj,part=ref}) end
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

-- ════════════════════════════
--  STAT TRACKER
-- ════════════════════════════
local STATS = {
    kills     = 0,
    deaths    = 0,
    fruitsTP  = 0,
    startTime = os.time(),
    execName  = (pcall(identifyexecutor) and identifyexecutor() or "Unknown"),
}

-- ════════════════════════════
--  NOTIFICATIONS
-- ════════════════════════════
local nGui
local function notify(title, body, dur)
    dur = dur or 3.5
    if not nGui or not nGui.Parent then
        nGui=new("ScreenGui",{Name="_EHN",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    end
    for _,f in pairs(nGui:GetChildren()) do
        if f:IsA("Frame") then tw(f,{Position=UDim2.new(1,-292,1,f.Position.Y.Offset-78)},0.15) end
    end
    local card=new("Frame",{Size=UDim2.new(0,280,0,64),Position=UDim2.new(1,8,1,-76),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=nGui})
    corner(card,8)
    new("UIStroke",{Color=T.Border,Thickness=1,Parent=card})
    new("Frame",{Size=UDim2.new(0,2,1,0),BackgroundColor3=T.Accent,BorderSizePixel=0,Parent=card})
    new("TextLabel",{Size=UDim2.new(1,-12,0,18),Position=UDim2.new(0,10,0,6),BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=card})
    new("TextLabel",{Size=UDim2.new(1,-12,0,28),Position=UDim2.new(0,10,0,26),BackgroundTransparency=1,Text=body,Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=card})
    tw(card,{Position=UDim2.new(1,-292,1,-76)},0.25,Enum.EasingStyle.Back)
    task.delay(dur,function()
        tw(card,{Position=UDim2.new(1,8,1,-76)},0.2)
        task.wait(0.25) pcall(function() card:Destroy() end)
    end)
end

-- ════════════════════════════
--  LOADING SCREEN
-- ════════════════════════════
local function showLoader()
    local sg=new("ScreenGui",{Name="_EHL",ResetOnSpawn=false,IgnoreGuiInset=true,Parent=PG})
    local bg=new("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(4,4,4),BorderSizePixel=0,Parent=sg})

    -- Grid lines
    for i=1,10 do
        new("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,(i-1)/10,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.96,BorderSizePixel=0,Parent=bg})
        new("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new((i-1)/10,0,0,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.96,BorderSizePixel=0,Parent=bg})
    end

    -- Center card
    local box=new("Frame",{Size=UDim2.new(0,300,0,190),Position=UDim2.new(0.5,-150,0.5,-95),BackgroundColor3=Color3.fromRGB(10,10,10),BorderSizePixel=0,Parent=bg})
    corner(box,6)
    new("UIStroke",{Color=Color3.fromRGB(60,60,60),Thickness=1,Parent=box})

    new("TextLabel",{Size=UDim2.new(1,0,0,50),Position=UDim2.new(0,0,0,24),BackgroundTransparency=1,Text="ELITE HUB",Font=Enum.Font.GothamBlack,TextSize=28,TextColor3=Color3.new(1,1,1),Parent=box})
    new("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,64),BackgroundTransparency=1,Text="BLOX FRUITS  v1.0.0",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(90,90,90),Parent=box})

    local execLbl=new("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,80),BackgroundTransparency=1,Text="",Font=Enum.Font.Gotham,TextSize=9,TextColor3=Color3.fromRGB(60,60,60),Parent=box})
    pcall(function() execLbl.Text = "Executor: "..(identifyexecutor and identifyexecutor() or "Unknown") end)

    new("Frame",{Size=UDim2.new(0,220,0,1),Position=UDim2.new(0.5,-110,0,100),BackgroundColor3=Color3.fromRGB(50,50,50),BorderSizePixel=0,Parent=box})

    local statLbl=new("TextLabel",{Size=UDim2.new(1,-24,0,16),Position=UDim2.new(0,12,0,110),BackgroundTransparency=1,Text="Initializing...",Font=Enum.Font.Gotham,TextSize=10,TextColor3=Color3.fromRGB(80,80,80),TextXAlignment=Enum.TextXAlignment.Left,Parent=box})
    local barBg=new("Frame",{Size=UDim2.new(1,-24,0,3),Position=UDim2.new(0,12,0,135),BackgroundColor3=Color3.fromRGB(28,28,28),BorderSizePixel=0,Parent=box})
    corner(barBg,2)
    local bar=new("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=barBg})
    corner(bar,2)

    new("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-28),BackgroundTransparency=1,Text="discord.gg/EmsMsHZCVH",Font=Enum.Font.Gotham,TextSize=9,TextColor3=Color3.fromRGB(55,55,55),Parent=box})

    -- Live clock — top-right of screen
    local clockLbl=new("TextLabel",{
        Size=UDim2.new(0,190,0,50),Position=UDim2.new(1,-200,0,12),BackgroundTransparency=1,
        Text="",Font=Enum.Font.GothamBlack,TextSize=36,TextColor3=Color3.fromRGB(255,255,255),
        TextXAlignment=Enum.TextXAlignment.Right,Parent=bg
    })
    local dateLbl=new("TextLabel",{
        Size=UDim2.new(0,190,0,18),Position=UDim2.new(1,-200,0,58),BackgroundTransparency=1,
        Text="",Font=Enum.Font.Gotham,TextSize=11,TextColor3=Color3.fromRGB(70,70,70),
        TextXAlignment=Enum.TextXAlignment.Right,Parent=bg
    })

    local DAYS   = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
    local MONTHS = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}

    local clockConn
    clockConn = RunService.Heartbeat:Connect(wrap(function()
        if not clockLbl.Parent then clockConn:Disconnect() return end
        local d=os.date("*t",os.time())
        local h,m,s=d.hour,d.min,d.sec
        local ap=h>=12 and "PM" or "AM"
        h=h%12==0 and 12 or h%12
        clockLbl.Text=string.format("%02d:%02d:%02d %s",h,m,s,ap)
        dateLbl.Text =string.format("%s, %s %d %d",DAYS[d.wday],MONTHS[d.month],d.day,d.year)
    end))

    local steps={
        {0.15,"Detecting executor..."},
        {0.30,"Loading GUI framework..."},
        {0.45,"Injecting mob database..."},
        {0.60,"Mapping all three seas..."},
        {0.75,"Preparing Drawing ESP..."},
        {0.88,"Starting farm engine..."},
        {1.0, "Ready."},
    }
    for _,s in ipairs(steps) do
        task.wait(0.28)
        statLbl.Text=s[2]
        tw(bar,{Size=UDim2.new(s[1],0,1,0)},0.26)
    end
    task.wait(0.4)
    tw(bg,{BackgroundTransparency=1},0.5)
    for _,d in pairs(bg:GetDescendants()) do
        if d:IsA("GuiObject") then pcall(tw,d,{BackgroundTransparency=1,TextTransparency=1},0.5) end
    end
    task.wait(0.6)
    sg:Destroy()
end

-- ════════════════════════════
--  DRAWING ESP  (Delta-native — far faster than BillboardGui)
-- ════════════════════════════
local drawObjects = {}

local function clearDrawings()
    for _,o in pairs(drawObjects) do pcall(function() o:Remove() end) end
    drawObjects = {}
end

local function newDraw(class, props)
    if not HAS_DRAW then return nil end
    local ok, o = pcall(Drawing.new, class)
    if not ok then return nil end
    for k,v in pairs(props) do pcall(function() o[k]=v end) end
    table.insert(drawObjects, o)
    return o
end

local function worldToScreen(pos)
    local vp, vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), vis, vp.Z
end

local espLoop_conn
local function startDrawingESP()
    if espLoop_conn then espLoop_conn:Disconnect() end
    clearDrawings()

    local boxes, labels = {}, {}

    espLoop_conn = RunService.RenderStepped:Connect(wrap(function()
        -- clear per-frame cached drawings
        for k,v in pairs(boxes)  do pcall(function() v:Remove() end) end
        for k,v in pairs(labels) do pcall(function() v:Remove() end) end
        boxes, labels = {}, {}

        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local sc, vis, depth = worldToScreen(hrp.Position)
                        if vis and depth > 0 then
                            local sz = math.clamp(1600/depth, 20, 160)
                            local box = newDraw("Square",{
                                Size=Vector2.new(sz, sz*1.6),
                                Position=Vector2.new(sc.X-sz/2, sc.Y-sz*0.8),
                                Color=Color3.fromRGB(255,255,255),
                                Thickness=1.2,Filled=false,Visible=true,ZIndex=5
                            })
                            local lbl = newDraw("Text",{
                                Text=p.Name,
                                Position=Vector2.new(sc.X, sc.Y-sz*0.8-14),
                                Size=13,Color=Color3.fromRGB(255,255,255),
                                Center=true,Outline=true,Visible=true,ZIndex=5
                            })
                            if box  then table.insert(boxes,  box)  end
                            if lbl  then table.insert(labels, lbl)   end
                        end
                    end
                end
            end
        end

        if S.MobESP then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj~=getChar() then
                    local hum=obj:FindFirstChildOfClass("Humanoid")
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                        local sc, vis, depth = worldToScreen(hrp.Position)
                        if vis and depth > 0 and depth < 600 then
                            local sz = math.clamp(1400/depth, 14, 100)
                            local box = newDraw("Square",{
                                Size=Vector2.new(sz, sz*1.6),
                                Position=Vector2.new(sc.X-sz/2, sc.Y-sz*0.8),
                                Color=Color3.fromRGB(255,160,60),
                                Thickness=1,Filled=false,Visible=true,ZIndex=4
                            })
                            local lbl = newDraw("Text",{
                                Text=obj.Name.." ["..math.floor(hum.Health).."]",
                                Position=Vector2.new(sc.X, sc.Y-sz*0.8-12),
                                Size=12,Color=Color3.fromRGB(255,180,80),
                                Center=true,Outline=true,Visible=true,ZIndex=4
                            })
                            if box then table.insert(boxes,  box) end
                            if lbl then table.insert(labels, lbl) end
                        end
                    end
                end
            end
        end

        if S.FruitESP then
            for _,f in ipairs(scanFruits()) do
                if f.part and f.part.Parent then
                    local sc, vis, depth = worldToScreen(f.pos)
                    if vis and depth > 0 then
                        local lbl = newDraw("Text",{
                            Text="[FRUIT] "..f.name,
                            Position=sc, Size=13,
                            Color=Color3.fromRGB(100,220,100),
                            Center=true, Outline=true, Visible=true, ZIndex=6
                        })
                        if lbl then table.insert(labels, lbl) end
                    end
                end
            end
        end
    end))
end

-- Fallback BillboardGui ESP (non-Delta executors)
local espBills={}
local function clearBillESP()
    for _,b in pairs(espBills) do pcall(function() b:Destroy() end) end espBills={}
end
task.spawn(function()
    while task.wait(1) do
        if HAS_DRAW then continue end -- Drawing ESP handles it
        clearBillESP()
        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bb=new("BillboardGui",{Size=UDim2.new(0,80,0,24),StudsOffset=Vector3.new(0,3,0),AlwaysOnTop=true,Parent=hrp})
                        new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=p.Name,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Color3.new(1,1,1),TextStrokeTransparency=0,Parent=bb})
                        table.insert(espBills,bb)
                    end
                end
            end
        end
        if S.MobESP then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bb=new("BillboardGui",{Size=UDim2.new(0,90,0,24),StudsOffset=Vector3.new(0,2.5,0),AlwaysOnTop=true,Parent=hrp})
                        new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=obj.Name,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(255,180,80),TextStrokeTransparency=0,Parent=bb})
                        table.insert(espBills,bb)
                    end
                end
            end
        end
        if S.FruitESP then
            for _,f in ipairs(scanFruits()) do
                if f.obj and f.obj.Parent then
                    local base=f.part
                    if base then
                        local bb=new("BillboardGui",{Size=UDim2.new(0,90,0,24),StudsOffset=Vector3.new(0,2,0),AlwaysOnTop=true,Parent=base})
                        new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="[FRUIT] "..f.name,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=T.Green,TextStrokeTransparency=0,Parent=bb})
                        table.insert(espBills,bb)
                    end
                end
            end
        end
    end
end)

-- ════════════════════════════
--  MAIN GUI
-- ════════════════════════════
local function buildGUI()
    pcall(function() PG.EliteHub:Destroy() end)

    local sg=new("ScreenGui",{Name="EliteHub",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,Parent=PG})

    local win=new("Frame",{Size=UDim2.new(0,590,0,440),Position=UDim2.new(0.5,-295,0.5,-220),BackgroundColor3=T.BG,BorderSizePixel=0,Active=true,Parent=sg})
    corner(win,8)
    new("UIStroke",{Color=T.Border,Thickness=1,Parent=win})

    -- Drag
    local drag,offX,offY=false,0,0
    RunService.RenderStepped:Connect(wrap(function()
        if drag then win.Position=UDim2.new(0,Mouse.X-offX,0,Mouse.Y-offY) end
    end))

    -- ── Titlebar ──
    local tb=new("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=win})
    corner(tb,8)
    new("Frame",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=tb})
    new("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=T.Dim,BorderSizePixel=0,Parent=tb})
    new("TextLabel",{Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,Text="ELITE HUB",Font=Enum.Font.GothamBlack,TextSize=14,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})
    new("TextLabel",{Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,Text="              Blox Fruits · v1.0.0",Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})

    -- Delta badge
    if IS_DELTA then
        local badge=new("Frame",{Size=UDim2.new(0,56,0,18),Position=UDim2.new(0,170,0.5,-9),BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0,Parent=tb})
        corner(badge,4)
        new("UIStroke",{Color=T.Blue,Thickness=1,Parent=badge})
        new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="DELTA",Font=Enum.Font.GothamBlack,TextSize=9,TextColor3=T.Blue,Parent=badge})
    end

    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true offX=Mouse.X-win.AbsolutePosition.X offY=Mouse.Y-win.AbsolutePosition.Y
        end
    end)
    tb.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)

    -- Window controls
    local function ctrlBtn(xOff, col, lbl, cb)
        local b=new("TextButton",{Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,xOff,0.5,-11),BackgroundColor3=col,Text=lbl,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=tb})
        corner(b,11) b.MouseButton1Click:Connect(cb) return b
    end
    ctrlBtn(-30, Color3.fromRGB(200,60,60), "×", function()
        tw(win,{Size=UDim2.new(0,590,0,0),BackgroundTransparency=1},0.2) task.wait(0.25) sg:Destroy()
    end)
    local mini=false
    ctrlBtn(-58, T.Dim, "–", function()
        mini=not mini tw(win,{Size=mini and UDim2.new(0,590,0,38) or UDim2.new(0,590,0,440)},0.2,Enum.EasingStyle.Back)
    end)

    -- ── Sidebar ──
    local sb=new("Frame",{Size=UDim2.new(0,118,1,-38),Position=UDim2.new(0,0,0,38),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=win})
    new("Frame",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sb})
    new("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=T.Dim,BorderSizePixel=0,Parent=sb})
    pad(sb,8,6,6,6) list(sb,nil,3)

    -- ── Content area ──
    local ca=new("Frame",{Size=UDim2.new(1,-125,1,-44),Position=UDim2.new(0,124,0,41),BackgroundTransparency=1,Parent=win})
    local pages,tabs,cur={},{},nil

    local function makePage(id)
        local sc=new("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=T.Dim,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=ca})
        list(sc,nil,5) pad(sc,4,2,6,8)
        pages[id]=sc return sc
    end

    local function makeTab(id, lbl, icon)
        local btn_=new("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=T.TabOff,Text="",BorderSizePixel=0,LayoutOrder=#tabs+1,Parent=sb})
        corner(btn_,5)
        new("TextLabel",{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text=icon.."  "..lbl,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=btn_})
        tabs[id]=btn_
        local function activate()
            if cur then
                pages[cur].Visible=false
                local pb=tabs[cur]
                if pb then tw(pb,{BackgroundColor3=T.TabOff}) local l=pb:FindFirstChildOfClass("TextLabel") if l then tw(l,{TextColor3=T.Sub}) end end
            end
            cur=id pages[id].Visible=true
            tw(btn_,{BackgroundColor3=Color3.fromRGB(32,32,32)})
            local l=btn_:FindFirstChildOfClass("TextLabel") if l then tw(l,{TextColor3=T.Text}) end
        end
        btn_.MouseButton1Click:Connect(activate)
        return activate
    end

    -- ── Widgets ──
    local function sec(p,title,order)
        local f=new("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,LayoutOrder=order,Parent=p})
        new("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=title:upper(),Font=Enum.Font.GothamBold,TextSize=8,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
        new("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,0),BackgroundColor3=T.Dim,BorderSizePixel=0,Parent=f})
    end

    local function tog(p,lbl,key,order,cb)
        local row=new("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=T.Panel2,BorderSizePixel=0,LayoutOrder=order,Parent=p})
        corner(row)
        new("TextLabel",{Size=UDim2.new(1,-48,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=lbl,Font=Enum.Font.Gotham,TextSize=11,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
        local on=key and S[key] or false
        local track=new("Frame",{Size=UDim2.new(0,34,0,18),Position=UDim2.new(1,-40,0.5,-9),BackgroundColor3=on and T.Green or T.Dim,BorderSizePixel=0,Parent=row})
        corner(track,9)
        local thumb=new("Frame",{Size=UDim2.new(0,14,0,14),Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=track})
        corner(thumb,7)
        new("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=row}).MouseButton1Click:Connect(function()
            if key then S[key]=not S[key] on=S[key] else on=not on end
            tw(track,{BackgroundColor3=on and T.Green or T.Dim})
            tw(thumb,{Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)})
            if cb then cb(on) end
        end)
        return function(v)
            on=v if key then S[key]=v end
            tw(track,{BackgroundColor3=on and T.Green or T.Dim})
            tw(thumb,{Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)})
        end
    end

    local function btn(p,lbl,col,order,cb)
        col=col or T.Panel2
        local b=new("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=col,Text=lbl,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Text,BorderSizePixel=0,LayoutOrder=order,Parent=p})
        corner(b) new("UIStroke",{Color=T.Border,Thickness=1,Parent=b})
        b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=Color3.fromRGB(38,38,38)}) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=col}) end)
        b.MouseButton1Click:Connect(function()
            tw(b,{Size=UDim2.new(0.97,0,0,26)},0.07) task.wait(0.08) tw(b,{Size=UDim2.new(1,0,0,30)},0.07)
            if cb then task.spawn(cb) end
        end)
        return b
    end

    local function drop(p,lbl,opts,key,order,cb)
        local open=false
        local c=new("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=T.Panel2,BorderSizePixel=0,LayoutOrder=order,ClipsDescendants=true,Parent=p})
        corner(c) new("UIStroke",{Color=T.Border,Thickness=1,Parent=c})
        new("TextLabel",{Size=UDim2.new(0.5,0,0,32),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=lbl,Font=Enum.Font.Gotham,TextSize=11,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=c})
        local sel=new("TextLabel",{Size=UDim2.new(0.5,-14,0,32),Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,Text=(key and S[key]) or opts[1],Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Right,Parent=c})
        new("TextLabel",{Size=UDim2.new(0,14,0,32),Position=UDim2.new(1,-14,0,0),BackgroundTransparency=1,Text="▾",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=T.Sub,Parent=c})
        local df=new("Frame",{Size=UDim2.new(1,0,0,#opts*24),Position=UDim2.new(0,0,0,32),BackgroundColor3=Color3.fromRGB(14,14,14),BorderSizePixel=0,Parent=c})
        list(df,nil,0) new("UIStroke",{Color=T.Dim,Thickness=1,Parent=df})
        for i,opt in ipairs(opts) do
            local ob=new("TextButton",{Size=UDim2.new(1,0,0,24),BackgroundColor3=Color3.fromRGB(14,14,14),Text=opt,Font=Enum.Font.Gotham,TextSize=11,TextColor3=T.Sub,BorderSizePixel=0,LayoutOrder=i,Parent=df})
            ob.MouseButton1Click:Connect(function()
                if key then S[key]=opt end sel.Text=opt open=false tw(c,{Size=UDim2.new(1,0,0,32)},0.15)
                if cb then cb(opt) end
            end)
            ob.MouseEnter:Connect(function() tw(ob,{TextColor3=T.Text,BackgroundColor3=Color3.fromRGB(22,22,22)}) end)
            ob.MouseLeave:Connect(function() tw(ob,{TextColor3=T.Sub,BackgroundColor3=Color3.fromRGB(14,14,14)}) end)
        end
        new("TextButton",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,Text="",Parent=c}).MouseButton1Click:Connect(function()
            open=not open tw(c,{Size=UDim2.new(1,0,0,open and 32+#opts*24 or 32)},0.18,Enum.EasingStyle.Back)
        end)
        return c, sel
    end

    local function infoRow(p,lbl,val,order)
        local row=new("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=T.Panel2,BorderSizePixel=0,LayoutOrder=order,Parent=p})
        corner(row)
        new("TextLabel",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,Text=lbl,Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
        local vl=new("TextLabel",{Size=UDim2.new(0.5,-10,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,Text=val,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
        return vl
    end

    -- ══════════════════════════════════
    --  PAGE: AUTO FARM
    -- ══════════════════════════════════
    local pFarm=makePage("Farm")
    local goFarm=makeTab("Farm","⚔","Farm")

    sec(pFarm,"Configuration",1)
    drop(pFarm,"Sea",{"Sea 1","Sea 2","Sea 3"},nil,2,function(v)
        S.TargetMob=(v=="Sea 1" and SEA1_MOBS or v=="Sea 2" and SEA2_MOBS or SEA3_MOBS)[1]
        notify("Farm","Sea changed — select a mob below.")
    end)
    drop(pFarm,"Mob",SEA1_MOBS,"TargetMob",3)
    drop(pFarm,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",4)

    sec(pFarm,"Toggles",5)
    tog(pFarm,"Auto Farm","AutoFarm",6)
    tog(pFarm,"Auto Respawn","AutoRespawn",7)
    tog(pFarm,"Safe Mode (anti-kick delays)","SafeMode",8,function(on)
        S.FarmDelay = on and 0.3 or 0.12
        notify("Safe Mode", on and "ON  — slower but safer" or "OFF — max speed")
    end)
    tog(pFarm,"Auto Collect Chest","AutoChest",9)
    tog(pFarm,"Auto Eat Fruit","AutoEatFruit",10)
    tog(pFarm,"Auto Quest","AutoQuest",11)

    sec(pFarm,"Sea 1 Quick Farm",12)
    for i,name in ipairs(SEA1_MOBS) do
        btn(pFarm,name,T.Panel2,12+i,function()
            S.TargetMob=name S.AutoFarm=true
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            notify("Farm","Farming  →  "..name)
        end)
    end
    sec(pFarm,"Sea 2 Quick Farm",35)
    for i,name in ipairs(SEA2_MOBS) do
        btn(pFarm,name,T.Panel2,35+i,function()
            S.TargetMob=name S.AutoFarm=true
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            notify("Farm","Farming  →  "..name)
        end)
    end
    sec(pFarm,"Sea 3 Quick Farm",60)
    for i,name in ipairs(SEA3_MOBS) do
        btn(pFarm,name,T.Panel2,60+i,function()
            S.TargetMob=name S.AutoFarm=true
            local sp=MOB_SPAWN[name] if sp then tp(sp) end
            notify("Farm","Farming  →  "..name)
        end)
    end
    btn(pFarm,"■  Stop Farm",Color3.fromRGB(35,35,35),100,function()
        S.AutoFarm=false notify("Farm","Stopped.")
    end)

    -- ══════════════════════════════════
    --  PAGE: COMBAT
    -- ══════════════════════════════════
    local pCbt=makePage("Combat")
    makeTab("Combat","◎","Combat")

    sec(pCbt,"Kill Aura",1)
    tog(pCbt,"Kill Aura","KillAura",2,function(on) notify("Kill Aura",on and "ON" or "OFF") end)
    drop(pCbt,"Kill Aura Range",{"10","15","20","25","30","40","50"},nil,3,function(v)
        S.KillAuraRange=tonumber(v) notify("Kill Aura","Range: "..v)
    end)

    sec(pCbt,"Movement",4)
    tog(pCbt,"Fly","FlyEnabled",5,function(on) notify("Fly",on and "ON — WASD to move" or "OFF") end)
    drop(pCbt,"Fly Speed",{"20","40","60","80","100","150","200"},nil,6,function(v)
        S.FlySpeed=tonumber(v) notify("Fly","Speed: "..v)
    end)
    tog(pCbt,"No Clip","NoClip",7,function(on) notify("No Clip",on and "ON" or "OFF") end)

    sec(pCbt,"Defence",8)
    tog(pCbt,"God Mode (keep health full)","GodMode",9,function(on) notify("God Mode",on and "ON" or "OFF") end)
    tog(pCbt,"Infinite Jump","InfJump",10,function(on) notify("Infinite Jump",on and "ON" or "OFF") end)

    sec(pCbt,"Walk Speed",11)
    for i,sp in ipairs({16,24,32,50,80,100,150}) do
        btn(pCbt,"WalkSpeed "..sp,T.Panel2,11+i,function()
            S.WalkSpeed=sp
            local h=getHum() if h then h.WalkSpeed=sp end
            notify("Speed","→ "..sp)
        end)
    end

    sec(pCbt,"Jump Power",20)
    for i,jp in ipairs({50,100,150,200,250}) do
        btn(pCbt,"JumpPower "..jp,T.Panel2,20+i,function()
            S.JumpPower=jp
            local h=getHum() if h then h.JumpPower=jp end
            notify("Jump","→ "..jp)
        end)
    end

    -- ══════════════════════════════════
    --  PAGE: TELEPORT
    -- ══════════════════════════════════
    local pTP=makePage("TP")
    makeTab("Teleport","⬡","TP")

    sec(pTP,"Fruit Tracker",1)
    tog(pTP,"Auto TP to Fruit","TPFruit",2)
    btn(pTP,"Scan & TP to Nearest Fruit",T.Panel2,3,function()
        local fruits=scanFruits()
        local root=getRoot()
        if not root then notify("Fruit","No character") return end
        if #fruits==0 then notify("Fruit","No fruits nearby") return end
        table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        tp(fruits[1].pos) STATS.fruitsTP=STATS.fruitsTP+1
        notify("Fruit","→ "..fruits[1].name)
    end)

    sec(pTP,"⚓ Sea 1",4)
    for i,d in ipairs(SEA1_ISLANDS) do
        btn(pTP,d[1],T.Panel2,4+i,function() tp(d[2]) notify("TP","→ "..d[1]) end)
    end
    sec(pTP,"⚓ Sea 2",20)
    for i,d in ipairs(SEA2_ISLANDS) do
        btn(pTP,d[1],T.Panel2,20+i,function() tp(d[2]) notify("TP","→ "..d[1]) end)
    end
    sec(pTP,"⚓ Sea 3",38)
    for i,d in ipairs(SEA3_ISLANDS) do
        btn(pTP,d[1],T.Panel2,38+i,function() tp(d[2]) notify("TP","→ "..d[1]) end)
    end

    -- ══════════════════════════════════
    --  PAGE: BOSS
    -- ══════════════════════════════════
    local pBoss=makePage("Boss")
    makeTab("Boss","💀","Boss")

    sec(pBoss,"Select",1)
    local bossNames={}
    for k in pairs(BOSS_POS) do table.insert(bossNames,k) end table.sort(bossNames)
    drop(pBoss,"Boss",bossNames,"SelectedBoss",2)

    sec(pBoss,"Toggles",3)
    tog(pBoss,"Auto Boss Farm","AutoBoss",4)
    tog(pBoss,"Auto Respawn","AutoRespawn",5)

    sec(pBoss,"Actions",6)
    btn(pBoss,"Start Auto Boss",T.Panel2,7,function() S.AutoBoss=true notify("Boss","Auto Boss: "..S.SelectedBoss) end)
    btn(pBoss,"■  Stop Boss Farm",T.Panel2,8,function() S.AutoBoss=false notify("Boss","Stopped.") end)
    btn(pBoss,"TP to Boss",T.Panel2,9,function()
        local pos=BOSS_POS[S.SelectedBoss]
        if pos then tp(pos) notify("Boss","→ "..S.SelectedBoss)
        else
            local m=findMobInWorld(S.SelectedBoss,99999)
            if m then local h=m:FindFirstChild("HumanoidRootPart") if h then tp(h.Position) notify("Boss","→ "..m.Name) end
            else notify("Boss","Boss not found in world") end
        end
    end)

    sec(pBoss,"Quick Boss TP",10)
    for i,name in ipairs(bossNames) do
        btn(pBoss,name,T.Panel2,10+i,function()
            S.SelectedBoss=name
            local pos=BOSS_POS[name] if pos then tp(pos) notify("Boss","→ "..name) end
        end)
    end

    -- ══════════════════════════════════
    --  PAGE: RAID
    -- ══════════════════════════════════
    local pRaid=makePage("Raid")
    makeTab("Raid","◈","Raid")

    local raidNames={}
    for k in pairs(RAID_POS) do table.insert(raidNames,k) end table.sort(raidNames)

    sec(pRaid,"Config",1)
    drop(pRaid,"Raid Type",raidNames,"SelectedRaid",2)

    sec(pRaid,"Toggles",3)
    tog(pRaid,"Auto Raid","AutoRaid",4)
    tog(pRaid,"Auto Respawn","AutoRespawn",5)

    sec(pRaid,"Actions",6)
    btn(pRaid,"Start Auto Raid",T.Panel2,7,function() S.AutoRaid=true notify("Raid","Auto Raid: "..S.SelectedRaid) end)
    btn(pRaid,"■  Stop Raid",T.Panel2,8,function() S.AutoRaid=false notify("Raid","Stopped.") end)
    btn(pRaid,"TP to Raid Island",T.Panel2,9,function()
        local pos=RAID_POS[S.SelectedRaid]
        if pos then tp(pos) notify("Raid","→ "..S.SelectedRaid) end
    end)

    sec(pRaid,"All Raids",10)
    for i,name in ipairs(raidNames) do
        btn(pRaid,name,T.Panel2,10+i,function()
            S.SelectedRaid=name tp(RAID_POS[name]) notify("Raid","→ "..name)
        end)
    end

    -- ══════════════════════════════════
    --  PAGE: VISUAL
    -- ══════════════════════════════════
    local pVis=makePage("Visual")
    makeTab("Visual","◻","Visual")

    sec(pVis,"ESP",1)
    local espNote = HAS_DRAW and "(Delta Drawing — high perf)" or "(BillboardGui fallback)"
    infoRow(pVis,"ESP Mode", espNote, 2)
    tog(pVis,"Player ESP","PlayerESP",3,function(on) notify("ESP","Player ESP "..(on and "ON" or "OFF")) end)
    tog(pVis,"Mob ESP","MobESP",4,function(on) notify("ESP","Mob ESP "..(on and "ON" or "OFF")) end)
    tog(pVis,"Fruit ESP","FruitESP",5,function(on) notify("ESP","Fruit ESP "..(on and "ON" or "OFF")) end)

    sec(pVis,"World",6)
    tog(pVis,"Fullbright","Fullbright",7,function(on)
        S.Fullbright=on
        Lighting.Brightness=on and 8 or 1 Lighting.GlobalShadows=not on
        notify("Fullbright",on and "ON" or "OFF")
    end)
    tog(pVis,"No Fog","NoFog",8,function(on)
        S.NoFog=on Lighting.FogEnd=on and 1e8 or 100000
        notify("Fog",on and "Removed" or "Restored")
    end)

    sec(pVis,"Camera",9)
    for i,fov in ipairs({70,90,110,120}) do
        btn(pVis,"FOV "..fov,T.Panel2,9+i,function() S.FOV=fov Camera.FieldOfView=fov end)
    end

    -- ══════════════════════════════════
    --  PAGE: STATS
    -- ══════════════════════════════════
    local pStats=makePage("Stats")
    makeTab("Stats","▤","Stats")

    sec(pStats,"Session Stats",1)
    local killsLbl  = infoRow(pStats,"Kills",   "0", 2)
    local deathsLbl = infoRow(pStats,"Deaths",  "0", 3)
    local fruitLbl  = infoRow(pStats,"Fruit TPs","0", 4)
    local timeLbl   = infoRow(pStats,"Time",    "0m", 5)

    -- Live stat update
    RunService.Heartbeat:Connect(wrap(function()
        if not killsLbl.Parent then return end
        killsLbl.Text  = tostring(STATS.kills)
        deathsLbl.Text = tostring(STATS.deaths)
        fruitLbl.Text  = tostring(STATS.fruitsTP)
        local elapsed  = os.time()-STATS.startTime
        local mins     = math.floor(elapsed/60)
        local secs     = elapsed%60
        timeLbl.Text   = string.format("%dm %02ds", mins, secs)
    end))

    sec(pStats,"Player Info",6)
    local nameLbl  = infoRow(pStats,"Name",     LP.Name, 7)
    local dispLbl  = infoRow(pStats,"DisplayName", LP.DisplayName, 8)
    local userLbl  = infoRow(pStats,"UserId",   tostring(LP.UserId), 9)
    local execLbl2 = infoRow(pStats,"Executor", IS_DELTA and "Delta ✓" or (pcall(identifyexecutor) and identifyexecutor() or "Unknown"), 10)

    btn(pStats,"Reset Stats",T.Panel2,11,function()
        STATS.kills=0 STATS.deaths=0 STATS.fruitsTP=0 STATS.startTime=os.time()
        notify("Stats","Reset.")
    end)

    -- ══════════════════════════════════
    --  PAGE: SETTINGS
    -- ══════════════════════════════════
    local pSet=makePage("Set")
    makeTab("Settings","≡","Set")

    sec(pSet,"Script",1)
    infoRow(pSet,"Version","v1.0.0",2)
    infoRow(pSet,"Executor",IS_DELTA and "Delta (optimized)" or "Compatible",3)
    infoRow(pSet,"Drawing ESP",HAS_DRAW and "Active" or "Fallback",4)
    infoRow(pSet,"Toggle Key","RightShift",5)

    sec(pSet,"Performance",6)
    tog(pSet,"FPS Counter","ShowFPS",7)
    tog(pSet,"Anti AFK","AntiAFK",8)
    tog(pSet,"Show Watermark","ShowWatermark",9)

    if HAS_WRITEFILE then
        sec(pSet,"Config",10)
        btn(pSet,"Save Config",T.Panel2,11,function()
            saveConfig(S) notify("Config","Saved to "..CFG_PATH)
        end)
        btn(pSet,"Load Config",T.Panel2,12,function()
            local d=loadConfig() for k,v in pairs(d) do S[k]=v end
            notify("Config","Loaded!")
        end)
        btn(pSet,"Reset Config",T.Panel2,13,function()
            local d=cfgDefault() for k,v in pairs(d) do S[k]=v end
            notify("Config","Reset to defaults.")
        end)
    end

    sec(pSet,"Discord",14)
    infoRow(pSet,"Server","discord.gg/EmsMsHZCVH",15)
    btn(pSet,"Copy Discord Link",T.Panel2,16,function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        notify("Discord","Copied!")
    end)

    sec(pSet,"Server",17)
    btn(pSet,"Rejoin Server",T.Panel2,18,function()
        pcall(function() TeleportService:Teleport(game.PlaceId,LP) end)
    end)
    btn(pSet,"Server Hop",T.Panel2,19,function()
        local servers={}
        pcall(function()
            local pages_=game:GetService("HttpService"):JSONDecode(
                game:GetService("HttpService"):GetAsync("https://games.roproxy.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=10")
            )
            if pages_ and pages_.data then servers=pages_.data end
        end)
        local current=game.JobId
        for _,srv in pairs(servers) do
            if srv.id~=current and srv.playing<srv.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,LP)
                return
            end
        end
        notify("Server Hop","No different server found.")
    end)

    sec(pSet,"Misc",20)
    btn(pSet,"Reload GUI",T.Panel2,21,function()
        sg:Destroy() task.wait(0.1) buildGUI()
    end)

    goFarm()
    return sg
end

-- ════════════════════════════
--  FPS COUNTER
-- ════════════════════════════
local function startFPS()
    pcall(function() PG._EHF:Destroy() end)
    local sg=new("ScreenGui",{Name="_EHF",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    local f=new("Frame",{Size=UDim2.new(0,80,0,22),Position=UDim2.new(1,-86,0,6),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg})
    corner(f,5) new("UIStroke",{Color=T.Border,Thickness=1,Parent=f})
    local dot=new("Frame",{Size=UDim2.new(0,6,0,6),Position=UDim2.new(0,7,0.5,-3),BackgroundColor3=T.Green,BorderSizePixel=0,Parent=f})
    corner(dot,3)
    local lbl=new("TextLabel",{Size=UDim2.new(1,-18,1,0),Position=UDim2.new(0,16,0,0),BackgroundTransparency=1,Text="FPS: --",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local fr,lt=0,tick()
    RunService.RenderStepped:Connect(wrap(function()
        sg.Enabled=S.ShowFPS fr=fr+1
        local n=tick()
        if n-lt>=0.5 then
            local fps=math.floor(fr/(n-lt))
            lbl.Text="FPS: "..fps
            dot.BackgroundColor3=fps>=55 and T.Green or fps>=30 and T.Gold or T.Red
            fr,lt=0,n
        end
    end))
end

-- ════════════════════════════
--  ANTI AFK
-- ════════════════════════════
local function startAntiAFK()
    task.spawn(function()
        while task.wait(50) do
            if S.AntiAFK then
                pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
                local h=getHum()
                if h then h:Move(Vector3.new(0.1,0,0),true) task.wait(0.05) h:Move(Vector3.new(0,0,0),true) end
            end
        end
    end)
end

-- ════════════════════════════
--  INFINITE JUMP
-- ════════════════════════════
UserInputService.JumpRequest:Connect(function()
    if S.InfJump then local h=getHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

-- ════════════════════════════
--  FLY  (Delta-compatible BodyVelocity)
-- ════════════════════════════
local flyBV, flyBA
task.spawn(function()
    while task.wait(0) do
        local root=getRoot()
        if S.FlyEnabled and root then
            if not flyBV or not flyBV.Parent then
                pcall(function() if flyBV then flyBV:Destroy() end if flyBA then flyBA:Destroy() end end)
                flyBV=Instance.new("BodyVelocity") flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
                flyBV.Velocity=Vector3.zero flyBV.Parent=root
                flyBA=Instance.new("BodyAngularVelocity") flyBA.MaxTorque=Vector3.new(1e5,1e5,1e5)
                flyBA.AngularVelocity=Vector3.zero flyBA.Parent=root
                local h=getHum() if h then h.PlatformStand=true end
            end
            local dir=Vector3.zero
            local spd=S.FlySpeed
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
            flyBV.Velocity = dir.Magnitude > 0 and dir.Unit*spd or Vector3.zero
        else
            if flyBV and flyBV.Parent then
                pcall(function() flyBV:Destroy() flyBA:Destroy() end)
                local h=getHum() if h then h.PlatformStand=false end
            end
        end
    end
end)

-- ════════════════════════════
--  NO CLIP
-- ════════════════════════════
RunService.Stepped:Connect(wrap(function()
    if not S.NoClip then return end
    local char=getChar() if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
    end
end))

-- ════════════════════════════
--  GOD MODE
-- ════════════════════════════
task.spawn(function()
    while task.wait(0.1) do
        if S.GodMode then
            local h=getHum()
            if h and h.Health>0 then h.Health=h.MaxHealth end
        end
    end
end)

-- ════════════════════════════
--  AUTO RESPAWN
-- ════════════════════════════
LP.CharacterAdded:Connect(function()
    if S.AutoRespawn then task.wait(2) notify("Respawned","Resuming...") end
    STATS.deaths = STATS.deaths + 1
end)

-- ════════════════════════════
--  AUTO FARM LOOP
-- ════════════════════════════
task.spawn(function()
    while task.wait(S.FarmDelay or 0.12) do
        if not S.AutoFarm then continue end
        if not alive() then if S.AutoRespawn then task.wait(4) end continue end

        local mob=findMobInWorld(S.TargetMob, 9999)
        if mob then
            attack(mob)
            STATS.kills = STATS.kills + 1
        else
            local spawnPos=MOB_SPAWN[S.TargetMob]
            if spawnPos then
                local root=getRoot()
                if root and (root.Position-spawnPos).Magnitude > 100 then
                    tp(spawnPos)
                    task.wait(S.SafeMode and 2 or 1.5)
                end
            end
        end
    end
end)

-- ════════════════════════════
--  KILL AURA LOOP  (Delta: firetouchinterest)
-- ════════════════════════════
task.spawn(function()
    while task.wait(0.1) do
        if not S.KillAura then continue end
        if not alive() then continue end
        local root=getRoot() if not root then continue end
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.KillAura then break end
            if obj:IsA("Model") and obj~=getChar() then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                    if (hrp.Position-root.Position).Magnitude <= (S.KillAuraRange or 25) then
                        if HAS_FTI then
                            pcall(firetouchinterest, hrp, root, 0)
                            task.wait(0.02)
                            pcall(firetouchinterest, hrp, root, 1)
                        end
                        pcall(function() hum:TakeDamage(9999) end)
                        STATS.kills = STATS.kills + 1
                    end
                end
            end
        end
    end
end)

-- ════════════════════════════
--  AUTO BOSS LOOP
-- ════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoBoss then continue end
        if not alive() then if S.AutoRespawn then task.wait(4) end continue end
        local boss=findMobInWorld(S.SelectedBoss, 9999)
        if boss then
            attack(boss)
        else
            local pos=BOSS_POS[S.SelectedBoss]
            if pos then
                local root=getRoot()
                if root and (root.Position-pos).Magnitude>200 then tp(pos) task.wait(2) end
            end
        end
    end
end)

-- ════════════════════════════
--  AUTO RAID LOOP
-- ════════════════════════════
task.spawn(function()
    while task.wait(0.18) do
        if not S.AutoRaid then continue end
        if not alive() then if S.AutoRespawn then task.wait(4) end continue end
        local raidPos=RAID_POS[S.SelectedRaid]
        local root=getRoot()
        if root and raidPos and (root.Position-raidPos).Magnitude>150 then
            tp(raidPos) task.wait(1.5)
        end
        for _,obj in pairs(workspace:GetDescendants()) do
            if not S.AutoRaid then break end
            if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                local hum=obj:FindFirstChildOfClass("Humanoid")
                local hrp=obj:FindFirstChild("HumanoidRootPart")
                local rt=getRoot()
                if hum and hrp and rt and hum.Health>0 and (hrp.Position-rt.Position).Magnitude<350 then
                    attack(obj) task.wait(0.1)
                end
            end
        end
    end
end)

-- ════════════════════════════
--  FRUIT TP LOOP
-- ════════════════════════════
task.spawn(function()
    while task.wait(4) do
        if not S.TPFruit then continue end
        if not alive() then continue end
        local fruits=scanFruits()
        local root=getRoot()
        if root and #fruits>0 then
            table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
            tp(fruits[1].pos) STATS.fruitsTP=STATS.fruitsTP+1
        end
    end
end)

-- ════════════════════════════
--  AUTO COLLECT CHEST LOOP
-- ════════════════════════════
task.spawn(function()
    while task.wait(3) do
        if not S.AutoChest then continue end
        if not alive() then continue end
        local chests=scanChests()
        local root=getRoot()
        if root and #chests>0 then
            table.sort(chests,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
            local c=chests[1]
            tp(c.pos)
            if HAS_FTI and root and c.part then
                pcall(firetouchinterest,c.part,root,0)
                task.wait(0.1)
                pcall(firetouchinterest,c.part,root,1)
            end
        end
    end
end)

-- ════════════════════════════
--  TOGGLE KEY  (RightShift)
-- ════════════════════════════
local guiRef=nil
UserInputService.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        if guiRef and guiRef.Parent then
            local w=guiRef:FindFirstChildWhichIsA("Frame")
            if w then w.Visible=not w.Visible end
        end
    end
end)

-- ════════════════════════════
--  DISCORD POPUP
-- ════════════════════════════
local function discordPopup()
    task.wait(3)
    local sg=new("ScreenGui",{Name="_EHD",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=PG})
    local f=new("Frame",{Size=UDim2.new(0,300,0,130),Position=UDim2.new(0.5,-150,1,8),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg})
    corner(f,8) new("UIStroke",{Color=T.Blue,Thickness=1,Parent=f})
    new("Frame",{Size=UDim2.new(1,0,0,3),BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=f})
    local ic=new("Frame",{Size=UDim2.new(0,36,0,36),Position=UDim2.new(0,14,0,14),BackgroundColor3=T.Blue,BorderSizePixel=0,Parent=f})
    corner(ic,18)
    new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="D",Font=Enum.Font.GothamBlack,TextSize=18,TextColor3=Color3.new(1,1,1),Parent=ic})
    new("TextLabel",{Size=UDim2.new(1,-66,0,18),Position=UDim2.new(0,58,0,12),BackgroundTransparency=1,Text="Join Elite Hub Discord",Font=Enum.Font.GothamBlack,TextSize=13,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    new("TextLabel",{Size=UDim2.new(1,-66,0,24),Position=UDim2.new(0,58,0,32),BackgroundTransparency=1,Text="Updates, support & new features.",Font=Enum.Font.Gotham,TextSize=10,TextColor3=T.Sub,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=f})
    local lf=new("Frame",{Size=UDim2.new(1,-20,0,24),Position=UDim2.new(0,10,0,72),BackgroundColor3=Color3.fromRGB(10,10,10),BorderSizePixel=0,Parent=f})
    corner(lf,5) new("UIStroke",{Color=T.Dim,Thickness=1,Parent=lf})
    new("TextLabel",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text="discord.gg/EmsMsHZCVH",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=T.Blue,TextXAlignment=Enum.TextXAlignment.Left,Parent=lf})
    local cp=new("TextButton",{Size=UDim2.new(0,72,0,24),Position=UDim2.new(0,10,1,-34),BackgroundColor3=T.Blue,Text="Copy",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=f})
    corner(cp)
    cp.MouseButton1Click:Connect(function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        cp.Text="Copied!" task.wait(1.5) cp.Text="Copy"
    end)
    local xb=new("TextButton",{Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-28,0,7),BackgroundColor3=T.Dim,Text="×",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=T.Sub,BorderSizePixel=0,Parent=f})
    corner(xb,11)
    xb.MouseButton1Click:Connect(function()
        tw(f,{Position=UDim2.new(0.5,-150,1,8)},0.25) task.wait(0.3) sg:Destroy()
    end)
    tw(f,{Position=UDim2.new(0.5,-150,1,-140)},0.38,Enum.EasingStyle.Back)
    task.delay(15,function()
        if sg.Parent then tw(f,{Position=UDim2.new(0.5,-150,1,8)},0.25) task.wait(0.3) pcall(function() sg:Destroy() end) end
    end)
end

-- ════════════════════════════
--  WATERMARK
-- ════════════════════════════
local function watermark()
    pcall(function() PG._EHW:Destroy() end)
    local sg=new("ScreenGui",{Name="_EHW",ResetOnSpawn=false,Parent=PG})
    local f=new("Frame",{Size=UDim2.new(0,220,0,20),Position=UDim2.new(0,6,0,6),BackgroundColor3=T.Panel,BorderSizePixel=0,Parent=sg})
    corner(f,4) new("UIStroke",{Color=T.Border,Thickness=1,Parent=f})
    new("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="Elite Hub v1.0.0  |  discord.gg/EmsMsHZCVH",Font=Enum.Font.GothamBold,TextSize=8,TextColor3=T.Sub,Parent=f})
    RunService.Heartbeat:Connect(wrap(function()
        if sg.Parent then sg.Enabled=S.ShowWatermark end
    end))
end

-- ════════════════════════════
--  BOOT
-- ════════════════════════════
task.spawn(function()
    showLoader()
    task.wait(0.1)
    guiRef = buildGUI()
    startFPS()
    startAntiAFK()
    watermark()
    if HAS_DRAW then startDrawingESP() end
    task.wait(0.3)
    local execStr = ""
    pcall(function() execStr = IS_DELTA and "  [Delta ✓]" or "" end)
    notify("Elite Hub v1.0.0","Loaded"..execStr.."  |  RShift = toggle")
    task.defer(discordPopup)
end)

print("╔══════════════════════════════════╗")
print("║  Elite Hub v1.0.0  |  All Seas  ║")
print("║  Delta-Optimized               ║")
print("║  discord.gg/EmsMsHZCVH         ║")
print("╚══════════════════════════════════╝")
if IS_DELTA then print("[EliteHub] Delta detected — Drawing ESP, firetouchinterest & writefile active.") end
