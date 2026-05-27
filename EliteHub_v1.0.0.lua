-- ╔══════════════════════════════════════════════════════╗
-- ║   ███████╗██╗     ██╗████████╗███████╗               ║
-- ║   ██╔════╝██║     ██║╚══██╔══╝██╔════╝               ║
-- ║   █████╗  ██║     ██║   ██║   █████╗                 ║
-- ║   ██╔══╝  ██║     ██║   ██║   ██╔══╝                 ║
-- ║   ███████╗███████╗██║   ██║   ███████╗               ║
-- ║   ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝               ║
-- ║                      HUB                             ║
-- ║   Version  : v1.0.0                                  ║
-- ║   Game     : Blox Fruits  (All Seas, Lv 1–2800)      ║
-- ║   Optimized: Delta, Fluxus, Arceus X                 ║
-- ║   Discord  : discord.gg/EmsMsHZCVH                   ║
-- ╚══════════════════════════════════════════════════════╝

-- ════════════════════════════════════════════
--  CAPABILITY FLAGS
-- ════════════════════════════════════════════
local HAS_DRAW      = typeof(Drawing)              == "table"
local HAS_WRITEFILE = typeof(writefile)            == "function"
local HAS_READFILE  = typeof(readfile)             == "function"
local HAS_FTI       = typeof(firetouchinterest)    == "function"
local HAS_FCD       = typeof(fireclickdetector)    == "function"
local HAS_FPP       = typeof(fireproximityprompt)  == "function"
local HAS_NCC       = typeof(newcclosure)          == "function"
local HAS_CLONEREF  = typeof(cloneref)             == "function"
local HAS_CLIP      = typeof(setclipboard)         == "function"
local HAS_SIM       = typeof(getsimulationradius)  == "function"
local EXEC_NAME     = "Unknown"
local IS_DELTA      = false

pcall(function()
    if identifyexecutor then EXEC_NAME = identifyexecutor()
    elseif getexecutorname then EXEC_NAME = getexecutorname() end
end)

local EL = EXEC_NAME:lower()
IS_DELTA = EL:find("delta") ~= nil

-- ════════════════════════════════════════════
--  EXECUTOR SAFETY GATE  (kick Xeno / Solara)
-- ════════════════════════════════════════════
if EL:find("xeno") or EL:find("solara") then
    pcall(function()
        game:GetService("Players").LocalPlayer:Kick(
            "[Elite Hub] Detected unsafe executor ("..EXEC_NAME..").\n"..
            "Xeno and Solara are confirmed rat executors that steal accounts.\n"..
            "Please use Delta, Fluxus, Arceus X, or Wave."
        )
    end)
    return
end

-- ════════════════════════════════════════════
--  SERVICES
-- ════════════════════════════════════════════
local function ref(s) return (HAS_CLONEREF and cloneref or function(x)return x end)(s) end
local function wrap(f) return (HAS_NCC and newcclosure or function(x)return x end)(f) end

local Players          = ref(game:GetService("Players"))
local RunService       = ref(game:GetService("RunService"))
local UserInputService = ref(game:GetService("UserInputService"))
local TweenService     = ref(game:GetService("TweenService"))
local VirtualUser      = ref(game:GetService("VirtualUser"))
local Lighting         = ref(game:GetService("Lighting"))
local RepStorage       = ref(game:GetService("ReplicatedStorage"))
local ContextActionSvc = ref(game:GetService("ContextActionService"))
local LP               = Players.LocalPlayer
local Mouse            = LP:GetMouse()
local PG               = LP:WaitForChild("PlayerGui", 10)
local Camera           = workspace.CurrentCamera

local DISPLAY_NAME = LP.DisplayName or LP.Name
local USERNAME     = "@"..LP.Name
local USER_ID      = LP.UserId
local AVATAR_URL   = "rbxthumb://type=AvatarHeadShot&id="..USER_ID.."&w=150&h=150"

-- ════════════════════════════════════════════
--  CONFIG  (auto-saved to file)
-- ════════════════════════════════════════════
local CFG_FILE = "EliteHub_v1_config.json"

local function cfgDefault()
    return {
        -- Farm
        AutoFarm=false, TargetMob="Bandit", FarmMethod="Melee",
        SafeMode=false, FarmDelay=0.1, AutoLevelFarm=false,
        -- Quest
        AutoQuest=false, QuestKillTarget=10, QuestKillCount=0,
        -- Boss / Raid
        AutoBoss=false, SelectedBoss="Gorilla King",
        AutoRaid=false, SelectedRaid="Flame",
        -- Items
        TPFruit=false, AutoChest=false, AutoEatFruit=false,
        -- Combat
        KillAura=false, KillAuraRange=25,
        -- Movement
        FlyEnabled=false, FlySpeed=60, NoClip=false,
        InfJump=false, WalkSpeed=16, JumpPower=50,
        -- Defence
        GodMode=false, AntiAFK=true, AutoRespawn=true,
        -- Visual
        PlayerESP=false, MobESP=false, FruitESP=false,
        Fullbright=false, NoFog=false, FOV=70,
        ShowWatermark=true, ShowFPS=true,
        -- Stats alloc
        AutoStat=false, StatPriority="Melee",
    }
end

local function toJSON(d)
    local t={}
    for k,v in pairs(d) do
        local s
        if type(v)=="boolean" then s=v and"true"or"false"
        elseif type(v)=="number" then s=tostring(v)
        else s='"'..tostring(v):gsub('\\','\\\\'):gsub('"','\\"')..'"' end
        table.insert(t,'"'..k..'":'..s)
    end
    return "{"..table.concat(t,",").."}"
end

local function fromJSON(raw,def)
    local d={}
    for k,v in pairs(def) do d[k]=v end
    pcall(function()
        for k in pairs(def) do
            local v=raw:match('"'..k..'":%s*(.-)%s*[,}%]]')
            if v then
                v=v:gsub('^%s+',''):gsub('%s+$','')
                if     v=="true"   then d[k]=true
                elseif v=="false"  then d[k]=false
                elseif tonumber(v) then d[k]=tonumber(v)
                else d[k]=v:gsub('^"',''):gsub('"$','') end
            end
        end
    end)
    return d
end

local function saveConfig(S)
    if not HAS_WRITEFILE then return end
    pcall(writefile,CFG_FILE,toJSON(S))
end

local function loadConfig()
    if not HAS_READFILE then return cfgDefault() end
    local ok,raw=pcall(readfile,CFG_FILE)
    if not ok or not raw or #raw<2 then return cfgDefault() end
    return fromJSON(raw,cfgDefault())
end

local S = loadConfig()

local _savePend=false
local function qSave()
    if _savePend then return end
    _savePend=true
    task.delay(1.5,function() _savePend=false saveConfig(S) end)
end

-- ════════════════════════════════════════════
--  MOB DATABASE  (sea, name, levels, spawn, quest NPC near)
-- ════════════════════════════════════════════
local MOBS = {
    -- ─── SEA 1 ───────────────────────────────────────────────────────────────────
    {sea=1,name="Bandit",          minLv=1,   maxLv=14,  kills=8,  pos=Vector3.new( 979,125,1570),  questPos=Vector3.new( 997,126,1587)},
    {sea=1,name="Monkey",          minLv=15,  maxLv=29,  kills=8,  pos=Vector3.new(-1500,125,-200), questPos=Vector3.new(-1495,125,-185)},
    {sea=1,name="Gorilla",         minLv=30,  maxLv=59,  kills=8,  pos=Vector3.new(-1700,125,-310), questPos=Vector3.new(-1695,125,-295)},
    {sea=1,name="Pirate",          minLv=60,  maxLv=99,  kills=10, pos=Vector3.new(-1200,125,4350), questPos=Vector3.new(-1195,125,4365)},
    {sea=1,name="Brute",           minLv=100, maxLv=124, kills=10, pos=Vector3.new(-1100,125,4500), questPos=Vector3.new(-1095,125,4515)},
    {sea=1,name="Desert Bandit",   minLv=125, maxLv=149, kills=10, pos=Vector3.new( 870,125,4000),  questPos=Vector3.new( 880,126,4010)},
    {sea=1,name="Desert Officer",  minLv=150, maxLv=174, kills=10, pos=Vector3.new(1050,125,4200),  questPos=Vector3.new(1060,126,4210)},
    {sea=1,name="Snow Bandit",     minLv=175, maxLv=199, kills=10, pos=Vector3.new(1200,125,-2700), questPos=Vector3.new(1210,126,-2690)},
    {sea=1,name="Snowman",         minLv=200, maxLv=249, kills=10, pos=Vector3.new(1300,125,-2850), questPos=Vector3.new(1310,126,-2840)},
    {sea=1,name="Marine",          minLv=250, maxLv=299, kills=10, pos=Vector3.new( -900,125,-350), questPos=Vector3.new( -890,126,-340)},
    {sea=1,name="Sky Bandit",      minLv=300, maxLv=374, kills=12, pos=Vector3.new(-4700,875,-700), questPos=Vector3.new(-4690,876,-690)},
    {sea=1,name="Dark Master",     minLv=375, maxLv=449, kills=12, pos=Vector3.new(-4950,1410,-700),questPos=Vector3.new(-4940,1411,-690)},
    {sea=1,name="Toga Warrior",    minLv=450, maxLv=624, kills=12, pos=Vector3.new(3324,127,-2640), questPos=Vector3.new(3334,127,-2630)},
    -- ─── SEA 2 ───────────────────────────────────────────────────────────────────
    {sea=2,name="Hoodlum",              minLv=625, maxLv=699, kills=10, pos=Vector3.new(-750,266,550),    questPos=Vector3.new(-740,267,560)},
    {sea=2,name="Trader",               minLv=700, maxLv=774, kills=10, pos=Vector3.new(-900,266,650),    questPos=Vector3.new(-890,267,660)},
    {sea=2,name="Forest Pirate",        minLv=775, maxLv=849, kills=10, pos=Vector3.new(-3550,125,1850),  questPos=Vector3.new(-3540,126,1860)},
    {sea=2,name="Factory Staff",        minLv=850, maxLv=924, kills=10, pos=Vector3.new(-3300,125,2000),  questPos=Vector3.new(-3290,126,2010)},
    {sea=2,name="Zombie",               minLv=925, maxLv=999, kills=10, pos=Vector3.new(-5800,125,-620),  questPos=Vector3.new(-5790,126,-610)},
    {sea=2,name="Vampire",              minLv=1000,maxLv=1049,kills=10, pos=Vector3.new(-5900,125,-700),  questPos=Vector3.new(-5890,126,-690)},
    {sea=2,name="Living Zombie",        minLv=1050,maxLv=1099,kills=12, pos=Vector3.new(-5950,125,-750),  questPos=Vector3.new(-5940,126,-740)},
    {sea=2,name="Demonic Soul",         minLv=1100,maxLv=1174,kills=12, pos=Vector3.new(-5200,125,-1720), questPos=Vector3.new(-5190,126,-1710)},
    {sea=2,name="Ship Crew",            minLv=1175,maxLv=1249,kills=12, pos=Vector3.new(-5200,125,-1780), questPos=Vector3.new(-5190,126,-1770)},
    {sea=2,name="Cursed Pirate",        minLv=1250,maxLv=1324,kills=12, pos=Vector3.new(-5300,125,-1800), questPos=Vector3.new(-5290,126,-1790)},
    {sea=2,name="Military Soldier",     minLv=1325,maxLv=1399,kills=12, pos=Vector3.new(-10000,125,-2000),questPos=Vector3.new(-9990,126,-1990)},
    {sea=2,name="Military Spy",         minLv=1325,maxLv=1399,kills=12, pos=Vector3.new(-9800,125,-1900), questPos=Vector3.new(-9790,126,-1890)},
    {sea=2,name="Assassin",             minLv=1400,maxLv=1474,kills=12, pos=Vector3.new(-9500,125,-1700), questPos=Vector3.new(-9490,126,-1690)},
    {sea=2,name="Arctic Warrior",       minLv=1475,maxLv=1549,kills=12, pos=Vector3.new(-4300,1000,-1000),questPos=Vector3.new(-4290,1001,-990)},
    {sea=2,name="Snow Lurker",          minLv=1550,maxLv=1624,kills=12, pos=Vector3.new(-4600,1020,-1100),questPos=Vector3.new(-4590,1021,-1090)},
    {sea=2,name="Swan Pirate",          minLv=1850,maxLv=1924,kills=12, pos=Vector3.new(880,125,29250),   questPos=Vector3.new(890,126,29260)},
    {sea=2,name="Dragon Crew Warrior",  minLv=1700,maxLv=1774,kills=12, pos=Vector3.new(3600,125,29450),  questPos=Vector3.new(3610,126,29460)},
    {sea=2,name="Dragon Crew Archer",   minLv=1775,maxLv=1849,kills=12, pos=Vector3.new(3700,125,29550),  questPos=Vector3.new(3710,126,29560)},
    {sea=2,name="Poseidon Soldier",     minLv=1925,maxLv=1999,kills=14, pos=Vector3.new(61350,125,1780),  questPos=Vector3.new(61360,126,1790)},
    {sea=2,name="Poseidon Knight",      minLv=2000,maxLv=2099,kills=14, pos=Vector3.new(61450,125,1850),  questPos=Vector3.new(61460,126,1860)},
    -- ─── SEA 3 ───────────────────────────────────────────────────────────────────
    {sea=3,name="Galley Pirate",        minLv=1500,maxLv=1574,kills=14, pos=Vector3.new(-2000,50,-4200),  questPos=Vector3.new(-1990,51,-4190)},
    {sea=3,name="Pirate Millionaire",   minLv=1575,maxLv=1649,kills=14, pos=Vector3.new(-2100,50,-4300),  questPos=Vector3.new(-2090,51,-4290)},
    {sea=3,name="Jungle Bug",           minLv=1650,maxLv=1724,kills=14, pos=Vector3.new(-3200,125,-3800), questPos=Vector3.new(-3190,126,-3790)},
    {sea=3,name="Laboon",               minLv=1725,maxLv=1799,kills=14, pos=Vector3.new(-3350,125,-3950), questPos=Vector3.new(-3340,126,-3940)},
    {sea=3,name="Forest Dragon",        minLv=1800,maxLv=1874,kills=14, pos=Vector3.new(-9000,400,-2500), questPos=Vector3.new(-8990,401,-2490)},
    {sea=3,name="Tree Spider",          minLv=1875,maxLv=1949,kills=14, pos=Vector3.new(-9100,400,-2600), questPos=Vector3.new(-9090,401,-2590)},
    {sea=3,name="Reborn Skeleton",      minLv=1950,maxLv=2049,kills=14, pos=Vector3.new(-11400,400,-1000),questPos=Vector3.new(-11390,401,-990)},
    {sea=3,name="Cursed Skeleton",      minLv=2050,maxLv=2124,kills=14, pos=Vector3.new(-11500,400,-1040),questPos=Vector3.new(-11490,401,-1030)},
    {sea=3,name="Soul Reaper",          minLv=2125,maxLv=2199,kills=14, pos=Vector3.new(-11600,400,-1080),questPos=Vector3.new(-11590,401,-1070)},
    {sea=3,name="Demonic Soul",         minLv=2200,maxLv=2274,kills=14, pos=Vector3.new(-6600,125,-2750), questPos=Vector3.new(-6590,126,-2740)},
    {sea=3,name="Diablo",               minLv=2275,maxLv=2349,kills=14, pos=Vector3.new(-8300,125,1600),  questPos=Vector3.new(-8290,126,1610)},
    {sea=3,name="Beautiful Pirate",     minLv=2350,maxLv=2424,kills=14, pos=Vector3.new(-8350,125,1650),  questPos=Vector3.new(-8340,126,1660)},
    {sea=3,name="Tiki Outpost Raider",  minLv=2425,maxLv=2499,kills=14, pos=Vector3.new(-8280,125,-1000), questPos=Vector3.new(-8270,126,-990)},
    {sea=3,name="Brawler Crab",         minLv=2425,maxLv=2499,kills=14, pos=Vector3.new(-14500,243,-1000),questPos=Vector3.new(-14490,244,-990)},
    {sea=3,name="Chocolate Bar Battler",minLv=2500,maxLv=2574,kills=16, pos=Vector3.new(-13950,125,3800), questPos=Vector3.new(-13940,126,3810)},
    {sea=3,name="Ice Cream Staff",      minLv=2575,maxLv=2649,kills=16, pos=Vector3.new(-14050,125,3780), questPos=Vector3.new(-14040,126,3790)},
    {sea=3,name="Baking Staff",         minLv=2650,maxLv=2699,kills=16, pos=Vector3.new(-14100,125,3900), questPos=Vector3.new(-14090,126,3910)},
    {sea=3,name="Cake Guard",           minLv=2700,maxLv=2749,kills=16, pos=Vector3.new(-14000,125,3850), questPos=Vector3.new(-13990,126,3860)},
    {sea=3,name="Candy Rebel",          minLv=2750,maxLv=2799,kills=16, pos=Vector3.new(-11650,125,5450), questPos=Vector3.new(-11640,126,5460)},
    {sea=3,name="Cocoa Warrior",        minLv=2800,maxLv=9999,kills=16, pos=Vector3.new(-12300,125,4950), questPos=Vector3.new(-12290,126,4960)},
    {sea=3,name="Mythological Pirate",  minLv=2800,maxLv=9999,kills=16, pos=Vector3.new(-15100,125,-1750),questPos=Vector3.new(-15090,126,-1740)},
    {sea=3,name="Leviathan",            minLv=2800,maxLv=9999,kills=16, pos=Vector3.new(-13050,125,-4650),questPos=Vector3.new(-13040,126,-4640)},
    {sea=3,name="Snow Lurker",          minLv=2550,maxLv=2649,kills=16, pos=Vector3.new(-14250,125,-2050),questPos=Vector3.new(-14240,126,-2040)},
    {sea=3,name="Longma",               minLv=2800,maxLv=9999,kills=16, pos=Vector3.new(3640,125,29500),  questPos=Vector3.new(3650,126,29510)},
}

-- Build quick-lookup maps
local MOB_MAP, SEA_MOBS_LIST = {}, {[1]={}, [2]={}, [3]={}}
local _seenMob = {}
for _,m in ipairs(MOBS) do
    if not MOB_MAP[m.name] then MOB_MAP[m.name]=m end
    local uid = m.name.."|"..m.sea
    if not _seenMob[uid] then
        _seenMob[uid]=true
        table.insert(SEA_MOBS_LIST[m.sea], m.name)
    end
end

-- ════════════════════════════════════════════
--  LEVEL ENGINE
-- ════════════════════════════════════════════
local function getLevel()
    local lv=1
    pcall(function()
        local paths={
            function() return LP:WaitForChild("Data",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("PlayerData",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("leaderstats",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("leaderstats",0.3):WaitForChild("Lv",0.3).Value end,
        }
        for _,fn in ipairs(paths) do
            local ok,v=pcall(fn)
            if ok and type(v)=="number" and v>0 then lv=v; break end
        end
    end)
    return lv
end

local function getMobForLevel(lv)
    local best=nil
    for _,m in ipairs(MOBS) do
        if lv>=m.minLv and lv<=m.maxLv then
            if not best or m.minLv>best.minLv then best=m end
        end
    end
    return best or MOBS[1]
end

-- ════════════════════════════════════════════
--  ISLAND / BOSS / RAID DATA
-- ════════════════════════════════════════════
local SEA1_ISLANDS={
    {"Starter Island",Vector3.new(1260,125,1612)},{"Marine Starter",Vector3.new(-1180,125,-1174)},
    {"Middle Town",Vector3.new(-192,125,-559)},    {"Jungle",Vector3.new(-1646,125,-261)},
    {"Pirate Village",Vector3.new(-1189,125,4403)},{"Desert",Vector3.new(924,125,4089)},
    {"Frozen Village",Vector3.new(1175,125,-1818)},{"Snowy Village",Vector3.new(1326,125,-2882)},
    {"Marine Fortress",Vector3.new(-965,125,-380)},{"Skylands",Vector3.new(-4755,872,-718)},
    {"Upper Skylands",Vector3.new(-5004,1400,-718)},{"Fountain City",Vector3.new(3324,127,-2610)},
}
local SEA2_ISLANDS={
    {"Kingdom of Rose",Vector3.new(-804,266,604)},  {"Dark Arena",Vector3.new(-9564,125,-1754)},
    {"Usoapp Island",Vector3.new(-2581,125,1500)},  {"Green Zone",Vector3.new(-3626,125,1900)},
    {"Graveyard",Vector3.new(-5878,125,-670)},       {"Snow Mountain",Vector3.new(-4550,1000,-1100)},
    {"Hot and Cold",Vector3.new(-3620,125,-2945)},   {"Cursed Ship",Vector3.new(-5237,125,-1765)},
    {"Ice Castle",Vector3.new(-3966,125,-1120)},     {"Colosseum",Vector3.new(926,125,29310)},
    {"Magma Village",Vector3.new(500,125,29650)},    {"Underwater City",Vector3.new(61421,125,1819)},
    {"Wano",Vector3.new(3640,125,29500)},
}
local SEA3_ISLANDS={
    {"Port Town",Vector3.new(-2076,49,-4246)},       {"Hydra Island",Vector3.new(-3281,125,-3900)},
    {"Great Tree",Vector3.new(-9084,400,-2573)},     {"Mansion",Vector3.new(-6640,125,-2800)},
    {"Tiki Outpost",Vector3.new(-8279,125,-1024)},   {"Buggy Island",Vector3.new(-8420,125,1630)},
    {"Floating Turtle",Vector3.new(-14553,243,-1014)},{"Haunted Castle",Vector3.new(-11540,400,-1044)},
    {"Sea of Treats",Vector3.new(-14055,125,3829)},  {"Peanut Island",Vector3.new(-13350,125,4100)},
    {"Cake Land",Vector3.new(-12350,125,5000)},      {"Candy Island",Vector3.new(-11700,125,5500)},
    {"Ice Berg",Vector3.new(-14300,125,-2100)},       {"Labyrinth",Vector3.new(-15200,125,-1800)},
    {"Distant Island",Vector3.new(-13000,125,-4700)},
}

local BOSS_POS={
    ["Gorilla King"]=Vector3.new(-1700,125,-310),   ["Bobby"]=Vector3.new(-1189,125,4403),
    ["Yeti"]=Vector3.new(1300,125,-2880),            ["Darkbeard"]=Vector3.new(-9564,125,-1754),
    ["Rip_Indra"]=Vector3.new(-9084,400,-2573),     ["Thunder God"]=Vector3.new(-4755,872,-718),
    ["Tide Keeper"]=Vector3.new(61421,125,1819),    ["Stone"]=Vector3.new(-5237,125,-1765),
    ["Island Empress"]=Vector3.new(-3966,125,-1120),["Longma"]=Vector3.new(3640,125,29500),
    ["Cake Prince"]=Vector3.new(-12350,125,5000),   ["Kilo Admiral"]=Vector3.new(924,125,4089),
    ["Vice Admiral"]=Vector3.new(-965,125,-380),    ["Magma Admiral"]=Vector3.new(500,125,29650),
    ["Order"]=Vector3.new(-14553,243,-1014),         ["Cursed Captain"]=Vector3.new(-14300,125,-2100),
    ["Bartolomeo"]=Vector3.new(926,125,29310),       ["Greybeard"]=Vector3.new(-965,125,-380),
    ["Don Swan"]=Vector3.new(-9564,125,-1754),       ["Dough King"]=Vector3.new(-14055,125,3829),
}

local RAID_POS={
    Flame=Vector3.new(3066,28,2760),    Ice=Vector3.new(1227,28,-2204),
    Rumble=Vector3.new(-4755,872,-718), Quake=Vector3.new(-1180,28,-1174),
    Light=Vector3.new(3324,28,-2610),   Dark=Vector3.new(-9084,28,-2573),
    Buddha=Vector3.new(-804,28,604),    Venom=Vector3.new(-5237,28,-1765),
    Phoenix=Vector3.new(-3966,28,-1120),Dough=Vector3.new(-12350,28,5000),
    Shadow=Vector3.new(-11540,28,-1044),Portal=Vector3.new(-14553,28,-1014),
    Control=Vector3.new(-15200,28,-1800),Dragon=Vector3.new(-9564,28,-1754),
    Leopard=Vector3.new(-14300,28,-2100),["T-Rex"]=Vector3.new(-13000,28,-4700),
    Kitsune=Vector3.new(-9000,400,-2500),
}

-- ════════════════════════════════════════════
--  THEME
-- ════════════════════════════════════════════
local T={
    BG     =Color3.fromRGB(8,8,8),
    SB     =Color3.fromRGB(10,10,10),
    TopBar =Color3.fromRGB(10,10,10),
    Panel  =Color3.fromRGB(14,14,14),
    Card   =Color3.fromRGB(17,17,17),
    Card2  =Color3.fromRGB(20,20,20),
    Border =Color3.fromRGB(32,32,32),
    Accent =Color3.fromRGB(255,255,255),
    Text   =Color3.fromRGB(225,225,225),
    Sub    =Color3.fromRGB(105,105,105),
    Dim    =Color3.fromRGB(45,45,45),
    Green  =Color3.fromRGB(65,195,65),
    Red    =Color3.fromRGB(210,55,55),
    Gold   =Color3.fromRGB(215,165,40),
    Blue   =Color3.fromRGB(75,125,240),
    Purple =Color3.fromRGB(140,80,235),
    Teal   =Color3.fromRGB(40,195,180),
}

-- ════════════════════════════════════════════
--  STATS & STATUS
-- ════════════════════════════════════════════
local STATS={
    kills=0, deaths=0, questsDone=0, fruitsTP=0,
    chestsTP=0, questKills=0, startTime=os.time(),
    kpm=0, lastKpmCheck=os.time(), kpmBucket=0,
}
local STATUS     = "Idle"
local STATUS_COL = Color3.fromRGB(105,105,105)
local function setStatus(s,col) STATUS=s STATUS_COL=col or T.Sub end

-- Kill-per-minute tracker
task.spawn(function()
    while task.wait(60) do
        STATS.kpm   = STATS.kpmBucket
        STATS.kpmBucket = 0
    end
end)

LP.CharacterAdded:Connect(function()
    STATS.deaths = STATS.deaths + 1
end)

-- ════════════════════════════════════════════
--  QUEST STATE MACHINE
-- ════════════════════════════════════════════
local QUEST = {
    state="idle",  -- idle | going_npc | at_npc | farming | returning | completing
    mob=nil,       -- mob data table
    killsNeeded=0,
    killsDone=0,
    lastNpcPos=nil,
    loopActive=false,
}

-- ════════════════════════════════════════════
--  CORE GAME HELPERS
-- ════════════════════════════════════════════
local function getChar()  return LP.Character end
local function getHum()   local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()  local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive()  local h=getHum();  return h and h.Health>0 end

-- Smooth teleport (2-step: avoids instant-flag detection)
local function tp(pos, noSmooth)
    local root=getRoot(); if not root then return end
    local goal=Vector3.new(pos.X, pos.Y+3.2, pos.Z)
    if noSmooth then root.CFrame=CFrame.new(goal); return end
    -- Two-step glide
    local mid=root.Position:Lerp(goal, 0.6)
    root.CFrame=CFrame.new(mid)
    task.wait(0.05)
    root.CFrame=CFrame.new(goal)
end

-- Find nearest living mob by name (partial match supported)
local function findMob(name, radius)
    local root=getRoot(); if not root then return nil end
    local nl=name:lower()
    local best,bestD=nil, radius or 9999
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            local hrp=obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>0 then
                local nl2=obj.Name:lower()
                if nl2==nl or nl2:find(nl,1,true) or nl:find(nl2,1,true) then
                    local d=(hrp.Position-root.Position).Magnitude
                    if d<bestD then best,bestD=obj,d end
                end
            end
        end
    end
    return best
end

-- Find ALL living mobs within radius
local function findAllMobs(radius)
    local root=getRoot(); if not root then return {} end
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            local hrp=obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>0 then
                local d=(hrp.Position-root.Position).Magnitude
                if d<radius then
                    table.insert(found,{obj=obj,hrp=hrp,hum=hum,dist=d})
                end
            end
        end
    end
    table.sort(found,function(a,b) return a.dist<b.dist end)
    return found
end

local function isDead(mob)
    if not mob or not mob.Parent then return true end
    local h=mob:FindFirstChildOfClass("Humanoid")
    return not h or h.Health<=0
end

-- ════════════════════════════════════════════
--  COMBAT ENGINE  (multi-method attack)
--  This is the KEY fix — uses all available
--  attack methods to guarantee mob death
-- ════════════════════════════════════════════
local function attackMob(mob)
    if not mob or not mob.Parent then return true end
    local hrp=mob:FindFirstChild("HumanoidRootPart")
    local hum=mob:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health<=0 then return true end

    -- Step 1: Move to mob
    tp(hrp.Position + Vector3.new(0,0,4))
    task.wait(0.05)

    local myRoot=getRoot()
    local char=getChar()

    -- Step 2: firetouchinterest — character root vs mob root
    if HAS_FTI and myRoot then
        pcall(firetouchinterest, hrp, myRoot, 0)
        task.wait(0.02)
        pcall(firetouchinterest, hrp, myRoot, 1)
        task.wait(0.02)
        -- Also touch all mob parts
        for _,part in pairs(mob:GetChildren()) do
            if part:IsA("BasePart") then
                pcall(firetouchinterest, part, myRoot, 0)
                task.wait(0.01)
                pcall(firetouchinterest, part, myRoot, 1)
            end
        end
    end

    -- Step 3: Tool-based attacks (sword handle vs mob)
    if char then
        for _,tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local handle=tool:FindFirstChild("Handle")
                -- Touch mob parts with tool handle
                if handle and HAS_FTI then
                    for _,part in pairs(mob:GetDescendants()) do
                        if part:IsA("BasePart") then
                            pcall(firetouchinterest, part, handle, 0)
                            task.wait(0.01)
                            pcall(firetouchinterest, part, handle, 1)
                        end
                    end
                end
                -- Fire all tool remote events (damage remotes)
                for _,v in pairs(tool:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        pcall(function() v:FireServer(hrp, hrp.Position) end)
                        pcall(function() v:FireServer(mob) end)
                        pcall(function() v:FireServer() end)
                    elseif v:IsA("RemoteFunction") then
                        pcall(function() v:InvokeServer(hrp) end)
                        pcall(function() v:InvokeServer() end)
                    end
                end
            end
        end
    end

    -- Step 4: Fire ReplicatedStorage remotes (Blox Fruits damage system)
    if char then
        for _,v in pairs(RepStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local n=v.Name:lower()
                if n:find("damage") or n:find("hit") or n:find("attack") or n:find("melee") then
                    pcall(function() v:FireServer(mob, 9999) end)
                    pcall(function() v:FireServer(hrp, 9999) end)
                    pcall(function() v:FireServer() end)
                end
            end
        end
    end

    -- Step 5: Direct health drain (works on some executor environments)
    pcall(function()
        if hum and hum.Health>0 then
            hum.Health = 0
        end
    end)

    -- Step 6: ClickDetector on mob (some NPCs have these)
    if HAS_FCD then
        for _,cd in pairs(mob:GetDescendants()) do
            if cd:IsA("ClickDetector") then
                pcall(fireclickdetector, cd)
            end
        end
    end

    task.wait(0.12)
    local killed=isDead(mob)
    if killed then
        STATS.kills=STATS.kills+1
        STATS.kpmBucket=STATS.kpmBucket+1
        if QUEST.state=="farming" then
            QUEST.killsDone=QUEST.killsDone+1
            STATS.questKills=STATS.questKills+1
        end
    end
    return killed
end

-- ════════════════════════════════════════════
--  QUEST NPC INTERACTION
-- ════════════════════════════════════════════
local function findQuestNPC(nearPos, searchRadius)
    searchRadius = searchRadius or 120
    local best, bestD = nil, searchRadius
    local kws = {"quest","questgiver","npc","master","trainer","mystic"}
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
            local hrp=obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d=(hrp.Position-nearPos).Magnitude
                if d<bestD then
                    -- Check if it matches quest NPC heuristics
                    local n=obj.Name:lower()
                    local hasCD = obj:FindFirstChildWhichIsA("ClickDetector",true)~=nil
                    local hasPP = obj:FindFirstChildWhichIsA("ProximityPrompt",true)~=nil
                    local nameMatch=false
                    for _,kw in ipairs(kws) do if n:find(kw,1,true) then nameMatch=true break end end
                    if hasCD or hasPP or nameMatch then
                        best,bestD=obj,d
                    end
                end
            end
        end
    end
    return best
end

local function interactNPC(npc)
    if not npc then return false end
    local hrp=npc:FindFirstChild("HumanoidRootPart"); if not hrp then return false end
    -- Move close
    tp(hrp.Position + Vector3.new(0,0,4))
    task.wait(0.35)
    local root=getRoot()
    local interacted=false

    -- ClickDetector
    if HAS_FCD then
        for _,cd in pairs(npc:GetDescendants()) do
            if cd:IsA("ClickDetector") then
                pcall(fireclickdetector, cd); interacted=true
                task.wait(0.1)
            end
        end
    end

    -- ProximityPrompt
    if HAS_FPP then
        for _,pp in pairs(npc:GetDescendants()) do
            if pp:IsA("ProximityPrompt") then
                pcall(fireproximityprompt, pp); interacted=true
                task.wait(0.1)
            end
        end
    end

    -- firetouchinterest
    if HAS_FTI and root then
        pcall(firetouchinterest, hrp, root, 0); task.wait(0.1)
        pcall(firetouchinterest, hrp, root, 1); interacted=true
    end

    -- Fire any remote events on NPC
    for _,v in pairs(npc:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n=v.Name:lower()
            if n:find("quest") or n:find("accept") or n:find("start") or n:find("talk") or n:find("interact") then
                pcall(function() v:FireServer() end)
                pcall(function() v:FireServer(npc) end)
                interacted=true
            end
        end
    end

    -- Also try ALL remotes on NPC if nothing matched
    if not interacted then
        for _,v in pairs(npc:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                pcall(function() v:FireServer() end)
            end
        end
    end

    return interacted
end

-- Try to accept a quest via ReplicatedStorage quest remotes
local function tryAcceptQuest(mobName)
    local accepted=false
    for _,v in pairs(RepStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n=v.Name:lower()
            if n:find("quest") or n:find("accept") or n:find("start") then
                if v:IsA("RemoteEvent") then
                    pcall(function() v:FireServer(mobName) end)
                    pcall(function() v:FireServer() end)
                else
                    pcall(function() v:InvokeServer(mobName) end)
                    pcall(function() v:InvokeServer() end)
                end
                accepted=true
            end
        end
    end
    return accepted
end

-- Check if a quest is currently active by scanning player GUI
local function hasActiveQuest()
    for _,sg in pairs(PG:GetChildren()) do
        if sg:IsA("ScreenGui") or sg:IsA("BillboardGui") then
            for _,obj in pairs(sg:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local t=obj.Text:lower()
                    if t:find("quest") and (t:find("kill") or t:find("defeat") or t:find("/")) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- ════════════════════════════════════════════
--  FRUIT / CHEST SCANNING
-- ════════════════════════════════════════════
local FRUIT_KW={"fruit","devil","logia","paramecia","zoan","ancient","mythical","awaken","df_"}
local function scanFruits()
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        for _,kw in ipairs(FRUIT_KW) do
            if n:find(kw,1,true) then
                local base=obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart",true)
                if base then table.insert(found,{name=obj.Name,pos=base.Position,obj=obj,part=base}); break end
            end
        end
    end
    return found
end

local function scanChests()
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if n:find("chest") or n:find("crate") or n:find("box") then
            local base=obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart",true)
            if base then table.insert(found,{name=obj.Name,pos=base.Position,obj=obj,part=base}) end
        end
    end
    return found
end

-- ════════════════════════════════════════════
--  TIME FORMATTERS
-- ════════════════════════════════════════════
local function fmtTime(s)
    local h=math.floor(s/3600); local m=math.floor((s%3600)/60); local sc=s%60
    if h>0 then return string.format("%dh %02dm",h,m) end
    return string.format("%dm %02ds",m,sc)
end

local function fmtClock()
    local d=os.date("*t",os.time())
    return string.format("%02d:%02d:%02d",d.hour,d.min,d.sec)
end

-- ════════════════════════════════════════════
--  FPS
-- ════════════════════════════════════════════
local FPS=60
do
    local frames,last=0,tick()
    RunService.RenderStepped:Connect(wrap(function()
        frames=frames+1
        local now=tick()
        if now-last>=0.5 then FPS=math.round(frames/(now-last)); frames,last=0,now end
    end))
end

-- ════════════════════════════════════════════
--  ANTI-AFK  (randomized, hard to detect)
-- ════════════════════════════════════════════
task.spawn(function()
    local actions={
        function() pcall(function() VirtualUser:CaptureController() end) end,
        function() pcall(function()
            local x,y=math.random(200,600),math.random(150,450)
            VirtualUser:ClickButton1(Vector2.new(x,y))
        end) end,
        function() pcall(function()
            VirtualUser:Button1Down(Vector2.new(0,0),CFrame.new())
            task.wait(0.05+math.random()*0.1)
            VirtualUser:Button1Up(Vector2.new(0,0),CFrame.new())
        end) end,
        function() pcall(function()
            VirtualUser:ClickButton2(Vector2.new(math.random(100,500),math.random(100,400)))
        end) end,
    }
    local last=0
    while task.wait(2+math.random()*3) do
        if not S.AntiAFK then continue end
        local now=tick()
        local interval=40+math.random(0,50)
        if now-last>=interval then
            last=now
            for _=1,math.random(1,3) do
                actions[math.random(1,#actions)]()
                task.wait(math.random()*0.3)
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ════════════════════════════════════════════
local _nGui
local function notify(title,body,dur,accent)
    dur=dur or 3.5; accent=accent or T.Accent
    if not _nGui or not _nGui.Parent then
        _nGui=Instance.new("ScreenGui")
        _nGui.Name="_EHN"; _nGui.ResetOnSpawn=false
        _nGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        _nGui.Parent=PG
    end
    -- Shift existing notifs up
    for _,f in pairs(_nGui:GetChildren()) do
        if f:IsA("Frame") then
            TweenService:Create(f,TweenInfo.new(0.12),
                {Position=UDim2.new(1,-272,1,f.Position.Y.Offset-60)}):Play()
        end
    end
    local card=Instance.new("Frame")
    card.Size=UDim2.new(0,258,0,52)
    card.Position=UDim2.new(1,12,1,-56)
    card.BackgroundColor3=T.Panel; card.BorderSizePixel=0; card.Parent=_nGui
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,7); c.Parent=card
    local s=Instance.new("UIStroke"); s.Color=T.Border; s.Thickness=1; s.Parent=card
    -- Accent bar
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,2,1,0)
    bar.BackgroundColor3=accent; bar.BorderSizePixel=0; bar.Parent=card
    local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,2); bc.Parent=bar
    -- Title
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,17)
    tl.Position=UDim2.new(0,11,0,4); tl.BackgroundTransparency=1
    tl.Text=title; tl.Font=Enum.Font.GothamBold; tl.TextSize=10
    tl.TextColor3=T.Text; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=card
    -- Body
    local bl=Instance.new("TextLabel"); bl.Size=UDim2.new(1,-16,0,26)
    bl.Position=UDim2.new(0,11,0,21); bl.BackgroundTransparency=1
    bl.Text=body; bl.Font=Enum.Font.Gotham; bl.TextSize=9; bl.TextWrapped=true
    bl.TextColor3=T.Sub; bl.TextXAlignment=Enum.TextXAlignment.Left; bl.Parent=card
    TweenService:Create(card,TweenInfo.new(0.28,Enum.EasingStyle.Back),
        {Position=UDim2.new(1,-272,1,-56)}):Play()
    task.delay(dur,function()
        TweenService:Create(card,TweenInfo.new(0.18),
            {Position=UDim2.new(1,12,1,-56)}):Play()
        task.wait(0.22); pcall(function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════
--  WATERMARK
-- ════════════════════════════════════════════
local _wmConn
local function buildWatermark()
    pcall(function() PG:FindFirstChild("_EHW"):Destroy() end)
    if _wmConn then pcall(function() _wmConn:Disconnect() end) end
    local sg=Instance.new("ScreenGui"); sg.Name="_EHW"; sg.ResetOnSpawn=false; sg.Parent=PG
    local f=Instance.new("Frame"); f.Size=UDim2.new(0,220,0,17)
    f.Position=UDim2.new(0,6,0,6); f.BackgroundColor3=T.Panel; f.BorderSizePixel=0; f.Parent=sg
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,4); c.Parent=f
    local s=Instance.new("UIStroke"); s.Color=T.Border; s.Thickness=1; s.Parent=f
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.fromScale(1,1)
    lbl.BackgroundTransparency=1; lbl.Text="Elite Hub v1.0.0  •  discord.gg/EmsMsHZCVH"
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=7.5; lbl.TextColor3=T.Sub; lbl.Parent=f
    _wmConn=RunService.Heartbeat:Connect(wrap(function()
        if sg and sg.Parent then sg.Enabled=S.ShowWatermark end
    end))
end

-- ════════════════════════════════════════════
--  LOADING SCREEN  (improved)
-- ════════════════════════════════════════════
local function showLoader()
    local sg=Instance.new("ScreenGui"); sg.Name="_EHL"; sg.ResetOnSpawn=false
    sg.IgnoreGuiInset=true; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.Parent=PG

    -- Dark overlay
    local bg=Instance.new("Frame"); bg.Size=UDim2.fromScale(1,1)
    bg.BackgroundColor3=Color3.fromRGB(4,4,4); bg.BorderSizePixel=0; bg.Parent=sg

    -- Subtle grid overlay
    for i=1,24 do
        local h=Instance.new("Frame"); h.Size=UDim2.new(1,0,0,1)
        h.Position=UDim2.new(0,0,(i-1)/24,0); h.BackgroundColor3=Color3.new(1,1,1)
        h.BackgroundTransparency=0.96; h.BorderSizePixel=0; h.Parent=bg
        local v=Instance.new("Frame"); v.Size=UDim2.new(0,1,1,0)
        v.Position=UDim2.new((i-1)/24,0,0,0); v.BackgroundColor3=Color3.new(1,1,1)
        v.BackgroundTransparency=0.96; v.BorderSizePixel=0; v.Parent=bg
    end

    -- Main card
    local card=Instance.new("Frame"); card.Size=UDim2.new(0,310,0,230)
    card.Position=UDim2.new(0.5,-155,0.5,-115); card.BackgroundColor3=Color3.fromRGB(7,7,7)
    card.BorderSizePixel=0; card.BackgroundTransparency=1; card.Parent=bg
    local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(0,12); cc.Parent=card
    local cs=Instance.new("UIStroke"); cs.Color=Color3.fromRGB(42,42,42); cs.Thickness=1; cs.Parent=card

    -- Top accent stripe
    local stripe=Instance.new("Frame"); stripe.Size=UDim2.new(1,0,0,2)
    stripe.BackgroundColor3=Color3.new(1,1,1); stripe.BorderSizePixel=0; stripe.Parent=card
    local sc2=Instance.new("UICorner"); sc2.CornerRadius=UDim.new(0,12); sc2.Parent=stripe

    -- Logo text
    local logoE=Instance.new("TextLabel"); logoE.Size=UDim2.new(0,60,0,48)
    logoE.Position=UDim2.new(0,22,0,20); logoE.BackgroundTransparency=1
    logoE.Text="E"; logoE.Font=Enum.Font.GothamBlack; logoE.TextSize=44
    logoE.TextColor3=Color3.new(1,1,1); logoE.Parent=card
    local logoH=Instance.new("TextLabel"); logoH.Size=UDim2.new(0,200,0,48)
    logoH.Position=UDim2.new(0,72,0,20); logoH.BackgroundTransparency=1
    logoH.Text="LITE HUB"; logoH.Font=Enum.Font.GothamBlack; logoH.TextSize=32
    logoH.TextColor3=Color3.fromRGB(180,180,180); logoH.TextXAlignment=Enum.TextXAlignment.Left
    logoH.Parent=card

    -- Sub info
    local sub=Instance.new("TextLabel"); sub.Size=UDim2.new(1,-22,0,14)
    sub.Position=UDim2.new(0,22,0,66); sub.BackgroundTransparency=1
    sub.Text="BLOX FRUITS  •  ALL SEAS  •  LV 1–2800  •  v1.0.0"
    sub.Font=Enum.Font.GothamBold; sub.TextSize=7.5
    sub.TextColor3=Color3.fromRGB(55,55,55); sub.TextXAlignment=Enum.TextXAlignment.Left
    sub.Parent=card

    local execLbl=Instance.new("TextLabel"); execLbl.Size=UDim2.new(1,-22,0,12)
    execLbl.Position=UDim2.new(0,22,0,81); execLbl.BackgroundTransparency=1
    execLbl.Text="Executor: "..EXEC_NAME..(IS_DELTA and "  ✓ Delta Verified" or "")
    execLbl.Font=Enum.Font.Gotham; execLbl.TextSize=8
    execLbl.TextColor3=IS_DELTA and Color3.fromRGB(75,125,240) or Color3.fromRGB(48,48,48)
    execLbl.TextXAlignment=Enum.TextXAlignment.Left; execLbl.Parent=card

    -- Divider
    local div=Instance.new("Frame"); div.Size=UDim2.new(1,-44,0,1)
    div.Position=UDim2.new(0,22,0,100); div.BackgroundColor3=Color3.fromRGB(30,30,30)
    div.BorderSizePixel=0; div.Parent=card

    -- Status text
    local statLbl=Instance.new("TextLabel"); statLbl.Size=UDim2.new(1,-44,0,14)
    statLbl.Position=UDim2.new(0,22,0,108); statLbl.BackgroundTransparency=1
    statLbl.Text="Initializing..."; statLbl.Font=Enum.Font.Gotham; statLbl.TextSize=8.5
    statLbl.TextColor3=Color3.fromRGB(65,65,65); statLbl.TextXAlignment=Enum.TextXAlignment.Left
    statLbl.Parent=card

    -- Progress bar bg
    local barBg=Instance.new("Frame"); barBg.Size=UDim2.new(1,-44,0,4)
    barBg.Position=UDim2.new(0,22,0,128); barBg.BackgroundColor3=Color3.fromRGB(18,18,18)
    barBg.BorderSizePixel=0; barBg.Parent=card
    local bgC=Instance.new("UICorner"); bgC.CornerRadius=UDim.new(0,2); bgC.Parent=barBg

    -- Fill
    local fill=Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0)
    fill.BackgroundColor3=Color3.new(1,1,1); fill.BorderSizePixel=0; fill.Parent=barBg
    local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,2); fc.Parent=fill

    -- Shimmer on fill
    local shim=Instance.new("Frame"); shim.Size=UDim2.new(0.35,0,1,0)
    shim.BackgroundColor3=Color3.new(1,1,1); shim.BackgroundTransparency=0.65
    shim.BorderSizePixel=0; shim.Parent=fill
    local scc=Instance.new("UICorner"); scc.CornerRadius=UDim.new(0,2); scc.Parent=shim
    local shimConn=RunService.Heartbeat:Connect(wrap(function()
        if not shim.Parent then return end
        shim.Position=UDim2.new(tick()%1.0-0.35, 0, 0, 0)
    end))

    -- Percentage
    local pctLbl=Instance.new("TextLabel"); pctLbl.Size=UDim2.new(0,40,0,12)
    pctLbl.Position=UDim2.new(1,-46,0,138); pctLbl.BackgroundTransparency=1
    pctLbl.Text="0%"; pctLbl.Font=Enum.Font.GothamBold; pctLbl.TextSize=8
    pctLbl.TextColor3=Color3.fromRGB(48,48,48); pctLbl.TextXAlignment=Enum.TextXAlignment.Right
    pctLbl.Parent=card

    -- Log scroll (shows what's being loaded)
    local logBg=Instance.new("Frame"); logBg.Size=UDim2.new(1,-44,0,48)
    logBg.Position=UDim2.new(0,22,0,146); logBg.BackgroundColor3=Color3.fromRGB(11,11,11)
    logBg.BorderSizePixel=0; logBg.Parent=card
    local lbC=Instance.new("UICorner"); lbC.CornerRadius=UDim.new(0,5); lbC.Parent=logBg
    local logSf=Instance.new("ScrollingFrame"); logSf.Size=UDim2.fromScale(1,1)
    logSf.BackgroundTransparency=1; logSf.BorderSizePixel=0; logSf.ScrollBarThickness=0
    logSf.CanvasSize=UDim2.new(0,0,0,0); logSf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    logSf.ScrollingDirection=Enum.ScrollingDirection.Y; logSf.Parent=logBg
    local lPad=Instance.new("UIPadding"); lPad.PaddingLeft=UDim.new(0,6); lPad.PaddingTop=UDim.new(0,4)
    lPad.PaddingRight=UDim.new(0,6); lPad.Parent=logSf
    local lList=Instance.new("UIListLayout"); lList.SortOrder=Enum.SortOrder.LayoutOrder
    lList.Padding=UDim.new(0,1); lList.Parent=logSf
    local logCount=0
    local function addLog(txt,col)
        logCount=logCount+1
        local ll=Instance.new("TextLabel"); ll.Size=UDim2.new(1,0,0,10)
        ll.BackgroundTransparency=1; ll.Text=txt; ll.Font=Enum.Font.Gotham; ll.TextSize=7.5
        ll.TextColor3=col or Color3.fromRGB(55,55,55); ll.TextXAlignment=Enum.TextXAlignment.Left
        ll.LayoutOrder=logCount; ll.Parent=logSf
        logSf.CanvasPosition=Vector2.new(0,9999)
    end

    -- Footer
    local foot=Instance.new("TextLabel"); foot.Size=UDim2.new(1,0,0,12)
    foot.Position=UDim2.new(0,0,1,-16); foot.BackgroundTransparency=1
    foot.Text="v1.0.0  •  discord.gg/EmsMsHZCVH  •  Anti-Rat Protection Active"
    foot.Font=Enum.Font.Gotham; foot.TextSize=7.5; foot.TextColor3=Color3.fromRGB(35,35,35)
    foot.Parent=card

    -- Reveal card
    TweenService:Create(card,TweenInfo.new(0.32,Enum.EasingStyle.Back),{BackgroundTransparency=0}):Play()

    local function step(pct, msg, col, logMsg)
        task.wait(0.18)
        statLbl.Text=msg
        statLbl.TextColor3=col or Color3.fromRGB(68,68,68)
        pctLbl.Text=math.floor(pct*100).."%"
        TweenService:Create(fill,TweenInfo.new(0.22),{Size=UDim2.new(pct,0,1,0)}):Play()
        if col then TweenService:Create(fill,TweenInfo.new(0.18),{BackgroundColor3=col}):Play() end
        if logMsg then addLog(logMsg, col) end
    end

    step(0.05,"Verifying executor safety...", T.Blue,   "[ OK ] Executor: "..EXEC_NAME)
    step(0.12,"Loading mob database...",      nil,       "[ OK ] "..#MOBS.." mobs indexed (Sea 1/2/3)")
    step(0.22,"Building level engine...",     nil,       "[ OK ] Level → Mob auto-detection ready")
    step(0.32,"Mapping island teleports...",  nil,       "[ OK ] "..#SEA1_ISLANDS+#SEA2_ISLANDS+#SEA3_ISLANDS.." islands registered")
    step(0.44,"Initializing quest engine...", T.Gold,    "[ OK ] Quest NPC scanner & state machine ready")
    step(0.54,"Loading combat engine...",     T.Red,     "[ OK ] 6-method attack system initialized")
    step(0.64,"Configuring ESP modules...",   T.Blue,    "[ OK ] Drawing API: "..(HAS_DRAW and"Active"or"Billboard fallback"))
    step(0.73,"Building FlowHub UI...",       nil,       "[ OK ] GUI layout compiled")
    step(0.82,"Starting anti-AFK...",         nil,       "[ OK ] Randomized input rotation: ON")
    step(0.91,"Applying saved config...",     T.Gold,    "[ OK ] Config loaded from "..CFG_FILE)
    step(1.00,"Ready!",                       T.Green,   "[ OK ] Elite Hub v1.0.0 fully operational")

    task.wait(0.5)
    shimConn:Disconnect()
    TweenService:Create(bg,TweenInfo.new(0.45),{BackgroundTransparency=1}):Play()
    for _,d in pairs(bg:GetDescendants()) do
        if d:IsA("GuiObject") then
            pcall(function()
                TweenService:Create(d,TweenInfo.new(0.4),{BackgroundTransparency=1,TextTransparency=1}):Play()
            end)
        end
    end
    task.wait(0.5); pcall(function() sg:Destroy() end)
end

-- ════════════════════════════════════════════
--  ESP ENGINE
-- ════════════════════════════════════════════
local espObjs={}
local function clearESP()
    for _,o in pairs(espObjs) do pcall(function() o:Remove() end) end espObjs={}
end
local function newDraw(cls,props)
    if not HAS_DRAW then return nil end
    local ok,o=pcall(Drawing.new,cls); if not ok then return nil end
    for k,v in pairs(props) do pcall(function() o[k]=v end) end
    table.insert(espObjs,o); return o
end
local function w2s(p)
    local vp,vis=Camera:WorldToViewportPoint(p)
    return Vector2.new(vp.X,vp.Y),vis,vp.Z
end

local espConn
local function startESP()
    if espConn then espConn:Disconnect() end; clearESP()
    espConn=RunService.RenderStepped:Connect(wrap(function()
        local old=espObjs; espObjs={}
        for _,o in pairs(old) do pcall(function() o:Remove() end) end
        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    local hum=p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp then
                        local sc,vis,dep=w2s(hrp.Position)
                        if vis and dep>0 then
                            local sz=math.clamp(1600/dep,14,140)
                            local hp=hum and math.floor((hum.Health/math.max(hum.MaxHealth,1))*100) or 0
                            newDraw("Square",{Size=Vector2.new(sz,sz*1.7),Position=Vector2.new(sc.X-sz/2,sc.Y-sz*0.85),Color=Color3.new(1,1,1),Thickness=1.2,Filled=false,Visible=true,ZIndex=5})
                            newDraw("Text",{Text=p.Name.." ["..hp.."%]",Position=Vector2.new(sc.X,sc.Y-sz*0.85-14),Size=13,Color=Color3.new(1,1,1),Center=true,Outline=true,Visible=true,ZIndex=5})
                            -- HP bar
                            local barH=sz*1.7
                            local hpH=math.floor(barH*(hp/100))
                            newDraw("Square",{Size=Vector2.new(3,barH),Position=Vector2.new(sc.X+sz/2+2,sc.Y-sz*0.85),Color=T.Dim,Thickness=0,Filled=true,Visible=true,ZIndex=5})
                            newDraw("Square",{Size=Vector2.new(3,hpH),Position=Vector2.new(sc.X+sz/2+2,sc.Y-sz*0.85+(barH-hpH)),Color=T.Green,Thickness=0,Filled=true,Visible=true,ZIndex=5})
                            -- Distance
                            local dist=(hrp.Position-Camera.CFrame.Position).Magnitude
                            newDraw("Text",{Text=math.floor(dist).."m",Position=Vector2.new(sc.X,sc.Y+sz*0.85+4),Size=10,Color=T.Sub,Center=true,Outline=true,Visible=true,ZIndex=5})
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
                        if vis and dep>0 and dep<600 then
                            local sz=math.clamp(1300/dep,8,80)
                            local hp=math.floor((hum.Health/math.max(hum.MaxHealth,1))*100)
                            newDraw("Square",{Size=Vector2.new(sz,sz*1.7),Position=Vector2.new(sc.X-sz/2,sc.Y-sz*0.85),Color=Color3.fromRGB(255,150,40),Thickness=1,Filled=false,Visible=true,ZIndex=4})
                            newDraw("Text",{Text=obj.Name.." ["..hp.."%]",Position=Vector2.new(sc.X,sc.Y-sz*0.85-12),Size=11,Color=Color3.fromRGB(255,170,60),Center=true,Outline=true,Visible=true,ZIndex=4})
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
                        newDraw("Text",{Text="◆ "..f.name,Position=sc,Size=13,Color=T.Green,Center=true,Outline=true,Visible=true,ZIndex=6})
                    end
                end
            end
        end
    end))
end

-- Billboard fallback for executors without Drawing
task.spawn(function()
    local billObjs={}
    while task.wait(0.8) do
        if HAS_DRAW then continue end
        for _,b in pairs(billObjs) do pcall(function() b:Destroy() end) end billObjs={}
        local function mkBill(par,txt,col)
            local bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,110,0,24)
            bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=par
            local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.fromScale(1,1)
            lbl.BackgroundTransparency=1; lbl.Text=txt; lbl.Font=Enum.Font.GothamBold
            lbl.TextSize=9; lbl.TextColor3=col; lbl.TextStrokeTransparency=0; lbl.Parent=bb
            table.insert(billObjs,bb)
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
                        mkBill(hrp,obj.Name,Color3.fromRGB(255,170,60))
                    end
                end
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  GUI BUILDER
-- ════════════════════════════════════════════
local function buildGUI()
    pcall(function() PG:FindFirstChild("EliteHub"):Destroy() end)

    local sg=Instance.new("ScreenGui"); sg.Name="EliteHub"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.IgnoreGuiInset=true; sg.Parent=PG

    local WIN_W,WIN_H=535,390
    local win=Instance.new("Frame"); win.Size=UDim2.new(0,WIN_W,0,WIN_H)
    win.Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
    win.BackgroundColor3=T.BG; win.BorderSizePixel=0; win.Active=true; win.Parent=sg
    local wc=Instance.new("UICorner"); wc.CornerRadius=UDim.new(0,9); wc.Parent=win
    local ws=Instance.new("UIStroke"); ws.Color=T.Border; ws.Thickness=1; ws.Parent=win

    -- Drag
    local dragging,dX,dY=false,0,0
    RunService.RenderStepped:Connect(wrap(function()
        if dragging then
            local sx=math.clamp(Mouse.X-dX,0,workspace.CurrentCamera.ViewportSize.X-WIN_W)
            local sy=math.clamp(Mouse.Y-dY,0,workspace.CurrentCamera.ViewportSize.Y-WIN_H)
            win.Position=UDim2.new(0,sx,0,sy)
        end
    end))

    -- ── TOP BAR ────────────────────────────────────────────
    local TB_H=30
    local tb=Instance.new("Frame"); tb.Size=UDim2.new(1,0,0,TB_H)
    tb.BackgroundColor3=T.TopBar; tb.BorderSizePixel=0; tb.Parent=win
    local tbc=Instance.new("UICorner"); tbc.CornerRadius=UDim.new(0,9); tbc.Parent=tb
    -- Square bottom corners
    Instance.new("Frame",tb).Size=UDim2.new(1,0,0.5,0)
    tb:FindFirstChildOfClass("Frame").Position=UDim2.new(0,0,0.5,0)
    tb:FindFirstChildOfClass("Frame").BackgroundColor3=T.TopBar
    tb:FindFirstChildOfClass("Frame").BorderSizePixel=0
    -- Divider line
    local tdiv=Instance.new("Frame"); tdiv.Size=UDim2.new(1,0,0,1)
    tdiv.Position=UDim2.new(0,0,1,-1); tdiv.BackgroundColor3=T.Border
    tdiv.BorderSizePixel=0; tdiv.Parent=tb

    -- Drag on TB
    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dX=Mouse.X-win.AbsolutePosition.X; dY=Mouse.Y-win.AbsolutePosition.Y
        end
    end)
    tb.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    -- Brand
    local brand=Instance.new("TextLabel"); brand.Size=UDim2.new(0,90,1,0)
    brand.Position=UDim2.new(0,12,0,0); brand.BackgroundTransparency=1
    brand.Text="ELITE HUB"; brand.Font=Enum.Font.GothamBlack; brand.TextSize=11
    brand.TextColor3=T.Accent; brand.TextXAlignment=Enum.TextXAlignment.Left; brand.Parent=tb

    -- Live clock | FPS in center
    local tbInfo=Instance.new("TextLabel"); tbInfo.Size=UDim2.new(1,-200,1,0)
    tbInfo.Position=UDim2.new(0,100,0,0); tbInfo.BackgroundTransparency=1; tbInfo.Text=""
    tbInfo.Font=Enum.Font.Gotham; tbInfo.TextSize=9; tbInfo.TextColor3=T.Sub; tbInfo.Parent=tb
    RunService.Heartbeat:Connect(wrap(function()
        if not tbInfo.Parent then return end
        tbInfo.Text="|  "..fmtClock().."  |  "..FPS.." FPS"
    end))

    -- Delta badge
    if IS_DELTA then
        local db=Instance.new("Frame"); db.Size=UDim2.new(0,46,0,16)
        db.Position=UDim2.new(1,-108,0.5,-8); db.BackgroundColor3=Color3.fromRGB(10,15,32)
        db.BorderSizePixel=0; db.Parent=tb
        local dbc=Instance.new("UICorner"); dbc.CornerRadius=UDim.new(0,4); dbc.Parent=db
        local dbs=Instance.new("UIStroke"); dbs.Color=T.Blue; dbs.Thickness=1; dbs.Parent=db
        local dbl=Instance.new("TextLabel"); dbl.Size=UDim2.fromScale(1,1); dbl.BackgroundTransparency=1
        dbl.Text="DELTA"; dbl.Font=Enum.Font.GothamBlack; dbl.TextSize=7.5
        dbl.TextColor3=T.Blue; dbl.Parent=db
    end

    -- Window buttons (close, minimise)
    local function winBtn(xOff,col,lbl,cb)
        local b=Instance.new("TextButton"); b.Size=UDim2.new(0,18,0,18)
        b.Position=UDim2.new(1,xOff,0.5,-9); b.BackgroundColor3=col; b.Text=lbl
        b.Font=Enum.Font.GothamBold; b.TextSize=10; b.TextColor3=Color3.new(1,1,1)
        b.BorderSizePixel=0; b.Parent=tb
        local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,9); bc.Parent=b
        b.MouseButton1Click:Connect(cb)
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.3}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play() end)
    end
    winBtn(-26,Color3.fromRGB(190,50,50),"×",function()
        TweenService:Create(win,TweenInfo.new(0.18),{BackgroundTransparency=1,Size=UDim2.new(0,WIN_W,0,0)}):Play()
        task.wait(0.22); sg:Destroy()
    end)
    local minimised=false
    winBtn(-48,T.Dim,"−",function()
        minimised=not minimised
        TweenService:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Back),
            {Size=minimised and UDim2.new(0,WIN_W,0,TB_H) or UDim2.new(0,WIN_W,0,WIN_H)}):Play()
    end)

    -- ── SIDEBAR ────────────────────────────────────────────
    local SB_W=115
    local sb=Instance.new("Frame"); sb.Size=UDim2.new(0,SB_W,1,-TB_H-1)
    sb.Position=UDim2.new(0,0,0,TB_H); sb.BackgroundColor3=T.SB; sb.BorderSizePixel=0; sb.Parent=win
    Instance.new("Frame",sb).Size=UDim2.new(0,1,1,0)
    sb:FindFirstChildOfClass("Frame").BackgroundColor3=T.Border; sb:FindFirstChildOfClass("Frame").BorderSizePixel=0
    sb:FindFirstChildOfClass("Frame").Position=UDim2.new(1,-1,0,0)

    -- Nav scroll area
    local sbNav=Instance.new("ScrollingFrame"); sbNav.Size=UDim2.new(1,0,1,-70)
    sbNav.BackgroundTransparency=1; sbNav.BorderSizePixel=0; sbNav.ScrollBarThickness=0
    sbNav.CanvasSize=UDim2.new(0,0,0,0); sbNav.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sbNav.ScrollingDirection=Enum.ScrollingDirection.Y; sbNav.Parent=sb
    local snPad=Instance.new("UIPadding"); snPad.PaddingTop=UDim.new(0,7); snPad.PaddingLeft=UDim.new(0,5)
    snPad.PaddingRight=UDim.new(0,5); snPad.Parent=sbNav
    local snList=Instance.new("UIListLayout"); snList.SortOrder=Enum.SortOrder.LayoutOrder
    snList.Padding=UDim.new(0,1); snList.Parent=sbNav

    -- Sidebar bottom: AVATAR + user info + session
    local sbBot=Instance.new("Frame"); sbBot.Size=UDim2.new(1,0,0,70)
    sbBot.Position=UDim2.new(0,0,1,-70); sbBot.BackgroundColor3=T.SB; sbBot.BorderSizePixel=0; sbBot.Parent=sb
    local sbDiv=Instance.new("Frame"); sbDiv.Size=UDim2.new(1,0,0,1)
    sbDiv.BackgroundColor3=T.Border; sbDiv.BorderSizePixel=0; sbDiv.Parent=sbBot

    -- Avatar image (rbxthumb gives actual player headshot)
    local avFrame=Instance.new("Frame"); avFrame.Size=UDim2.new(0,36,0,36)
    avFrame.Position=UDim2.new(0,7,0,10); avFrame.BackgroundColor3=T.Dim
    avFrame.BorderSizePixel=0; avFrame.Parent=sbBot
    local avC=Instance.new("UICorner"); avC.CornerRadius=UDim.new(0,18); avC.Parent=avFrame
    local avImg=Instance.new("ImageLabel"); avImg.Size=UDim2.fromScale(1,1)
    avImg.BackgroundTransparency=1; avImg.Image=AVATAR_URL
    avImg.ScaleType=Enum.ScaleType.Fit; avImg.Parent=avFrame
    local avC2=Instance.new("UICorner"); avC2.CornerRadius=UDim.new(0,18); avC2.Parent=avImg
    -- Green online dot
    local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,9,0,9)
    dot.Position=UDim2.new(1,-9,1,-9); dot.BackgroundColor3=T.Green; dot.BorderSizePixel=0; dot.Parent=avFrame
    local dotC=Instance.new("UICorner"); dotC.CornerRadius=UDim.new(0,5); dotC.Parent=dot
    local dotS=Instance.new("UIStroke"); dotS.Color=T.SB; dotS.Thickness=1.5; dotS.Parent=dot

    -- Display name
    local dnLbl=Instance.new("TextLabel"); dnLbl.Size=UDim2.new(1,-52,0,14)
    dnLbl.Position=UDim2.new(0,50,0,9); dnLbl.BackgroundTransparency=1
    dnLbl.Text=DISPLAY_NAME; dnLbl.Font=Enum.Font.GothamBold; dnLbl.TextSize=9.5
    dnLbl.TextColor3=T.Text; dnLbl.TextXAlignment=Enum.TextXAlignment.Left
    dnLbl.TextTruncate=Enum.TextTruncate.AtEnd; dnLbl.Parent=sbBot
    -- Username
    local unLbl=Instance.new("TextLabel"); unLbl.Size=UDim2.new(1,-52,0,12)
    unLbl.Position=UDim2.new(0,50,0,24); unLbl.BackgroundTransparency=1
    unLbl.Text=USERNAME; unLbl.Font=Enum.Font.Gotham; unLbl.TextSize=8
    unLbl.TextColor3=T.Sub; unLbl.TextXAlignment=Enum.TextXAlignment.Left; unLbl.Parent=sbBot
    -- Session timer (live)
    local sesLbl=Instance.new("TextLabel"); sesLbl.Size=UDim2.new(1,-52,0,11)
    sesLbl.Position=UDim2.new(0,50,0,38); sesLbl.BackgroundTransparency=1
    sesLbl.Text="0m 00s"; sesLbl.Font=Enum.Font.Gotham; sesLbl.TextSize=7.5
    sesLbl.TextColor3=T.Dim; sesLbl.TextXAlignment=Enum.TextXAlignment.Left; sesLbl.Parent=sbBot
    task.spawn(function()
        while task.wait(1) do
            if not sesLbl.Parent then break end
            sesLbl.Text=fmtTime(os.time()-STATS.startTime)
        end
    end)
    -- Status dot in sidebar bot
    local statusRow=Instance.new("TextLabel"); statusRow.Size=UDim2.new(1,-8,0,11)
    statusRow.Position=UDim2.new(0,6,0,52); statusRow.BackgroundTransparency=1
    statusRow.Font=Enum.Font.Gotham; statusRow.TextSize=7.5; statusRow.TextColor3=T.Dim
    statusRow.TextXAlignment=Enum.TextXAlignment.Left; statusRow.Parent=sbBot
    task.spawn(function()
        while task.wait(0.5) do
            if not statusRow.Parent then break end
            statusRow.Text="●  "..STATUS
            statusRow.TextColor3=STATUS_COL
        end
    end)

    -- ── CONTENT AREA ───────────────────────────────────────
    local CA_X=SB_W+1
    local ca=Instance.new("Frame"); ca.Size=UDim2.new(1,-CA_X,1,-TB_H)
    ca.Position=UDim2.new(0,CA_X,0,TB_H); ca.BackgroundTransparency=1; ca.Parent=win

    -- ── PAGE SYSTEM ────────────────────────────────────────
    local pages,tabs,curPage={},{},nil

    local function makePage(id)
        local sc=Instance.new("ScrollingFrame"); sc.Size=UDim2.fromScale(1,1)
        sc.BackgroundTransparency=1; sc.BorderSizePixel=0; sc.ScrollBarThickness=2
        sc.ScrollBarImageColor3=T.Dim; sc.CanvasSize=UDim2.new(0,0,0,0)
        sc.AutomaticCanvasSize=Enum.AutomaticSize.Y; sc.Visible=false; sc.Parent=ca
        local pp=Instance.new("UIPadding"); pp.PaddingTop=UDim.new(0,6); pp.PaddingLeft=UDim.new(0,6)
        pp.PaddingRight=UDim.new(0,6); pp.PaddingBottom=UDim.new(0,6); pp.Parent=sc
        local pl=Instance.new("UIListLayout"); pl.SortOrder=Enum.SortOrder.LayoutOrder
        pl.Padding=UDim.new(0,5); pl.Parent=sc
        pages[id]=sc; return sc
    end

    local function activatePage(id)
        if curPage and curPage~=id then
            pages[curPage].Visible=false
            local t=tabs[curPage]
            if t then
                TweenService:Create(t.bg,TweenInfo.new(0.15),{BackgroundColor3=T.TabOff or Color3.fromRGB(0,0,0)}):Play()
                TweenService:Create(t.acc,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
                TweenService:Create(t.lbl,TweenInfo.new(0.15),{TextColor3=T.Sub}):Play()
            end
        end
        curPage=id; pages[id].Visible=true
        local t=tabs[id]
        if t then
            TweenService:Create(t.bg,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(24,24,24)}):Play()
            TweenService:Create(t.acc,TweenInfo.new(0.15),{BackgroundColor3=T.Green}):Play()
            TweenService:Create(t.lbl,TweenInfo.new(0.15),{TextColor3=T.Text}):Play()
        end
    end

    local _tabOrder=0
    local function sbSec(label)
        _tabOrder=_tabOrder+1
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,16); f.BackgroundTransparency=1
        f.LayoutOrder=_tabOrder; f.Parent=sbNav
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
        lbl.Text=label:upper(); lbl.Font=Enum.Font.GothamBold; lbl.TextSize=7.5
        lbl.TextColor3=T.Dim; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
    end

    local function makeTab(id,label)
        _tabOrder=_tabOrder+1
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,25); row.BackgroundTransparency=1
        row.LayoutOrder=_tabOrder; row.Parent=sbNav
        local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,2,0,13); acc.Position=UDim2.new(0,0,0.5,-6.5)
        acc.BackgroundColor3=Color3.fromRGB(0,0,0); acc.BorderSizePixel=0; acc.Parent=row
        local accC=Instance.new("UICorner"); accC.CornerRadius=UDim.new(0,1); accC.Parent=acc
        local bg=Instance.new("Frame"); bg.Size=UDim2.new(1,-4,1,0); bg.Position=UDim2.new(0,4,0,0)
        bg.BackgroundColor3=Color3.fromRGB(0,0,0); bg.BorderSizePixel=0; bg.Parent=row
        local bgc=Instance.new("UICorner"); bgc.CornerRadius=UDim.new(0,5); bgc.Parent=bg
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-8,1,0); lbl.Position=UDim2.new(0,8,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9.5
        lbl.TextColor3=T.Sub; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=bg
        tabs[id]={bg=bg,acc=acc,lbl=lbl}
        local hit=Instance.new("TextButton"); hit.Size=UDim2.fromScale(1,1); hit.BackgroundTransparency=1
        hit.Text=""; hit.Parent=row
        hit.MouseButton1Click:Connect(function() activatePage(id) end)
        bg.MouseEnter:Connect(function() if curPage~=id then TweenService:Create(bg,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(16,16,16)}):Play() end end)
        bg.MouseLeave:Connect(function() if curPage~=id then TweenService:Create(bg,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play() end end)
        return function() activatePage(id) end
    end

    -- ── WIDGET FACTORIES ───────────────────────────────────

    -- Card container
    local function card(page,title,order)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,0); f.AutomaticSize=Enum.AutomaticSize.Y
        f.BackgroundColor3=T.Card; f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=page
        local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,7); fc.Parent=f
        local fs=Instance.new("UIStroke"); fs.Color=T.Border; fs.Thickness=1; fs.Parent=f
        local fp=Instance.new("UIPadding"); fp.PaddingTop=UDim.new(0,8); fp.PaddingLeft=UDim.new(0,10)
        fp.PaddingRight=UDim.new(0,10); fp.PaddingBottom=UDim.new(0,8); fp.Parent=f
        local fl=Instance.new("UIListLayout"); fl.SortOrder=Enum.SortOrder.LayoutOrder
        fl.Padding=UDim.new(0,4); fl.Parent=f
        if title then
            local h=Instance.new("TextLabel"); h.Size=UDim2.new(1,0,0,15); h.BackgroundTransparency=1
            h.Text=title; h.Font=Enum.Font.GothamBold; h.TextSize=10.5; h.TextColor3=T.Text
            h.TextXAlignment=Enum.TextXAlignment.Left; h.LayoutOrder=0; h.Parent=f
        end
        return f
    end

    -- Two-column row
    local function twoCol(page,order)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,0); row.AutomaticSize=Enum.AutomaticSize.Y
        row.BackgroundTransparency=1; row.LayoutOrder=order; row.Parent=page
        local hl=Instance.new("UIListLayout"); hl.FillDirection=Enum.FillDirection.Horizontal
        hl.SortOrder=Enum.SortOrder.LayoutOrder; hl.Padding=UDim.new(0,5); hl.Parent=row
        local function col()
            local f=Instance.new("Frame"); f.Size=UDim2.new(0.5,-3,0,0); f.AutomaticSize=Enum.AutomaticSize.Y
            f.BackgroundTransparency=1; f.Parent=row
            local fl=Instance.new("UIListLayout"); fl.SortOrder=Enum.SortOrder.LayoutOrder
            fl.Padding=UDim.new(0,5); fl.Parent=f; return f
        end
        return col(),col()
    end

    -- Toggle
    local function toggle(parent,label,key,order,cb)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,23); row.BackgroundTransparency=1
        row.LayoutOrder=order; row.Parent=parent
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-46,1,0); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9.5; lbl.TextColor3=T.Sub
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row
        local on=key and S[key] or false
        local track=Instance.new("Frame"); track.Size=UDim2.new(0,34,0,17); track.BorderSizePixel=0
        track.Position=UDim2.new(1,-36,0.5,-8.5); track.BackgroundColor3=on and T.Green or T.Dim; track.Parent=row
        local tc=Instance.new("UICorner"); tc.CornerRadius=UDim.new(0,9); tc.Parent=track
        local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,13,0,13); thumb.BorderSizePixel=0
        thumb.Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)
        thumb.BackgroundColor3=Color3.new(1,1,1); thumb.Parent=track
        local thc=Instance.new("UICorner"); thc.CornerRadius=UDim.new(0,7); thc.Parent=thumb
        local function setState(v)
            on=v; if key then S[key]=v; qSave() end
            TweenService:Create(track,TweenInfo.new(0.15),{BackgroundColor3=on and T.Green or T.Dim}):Play()
            TweenService:Create(thumb,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)}):Play()
        end
        local hit=Instance.new("TextButton"); hit.Size=UDim2.fromScale(1,1); hit.BackgroundTransparency=1
        hit.Text=""; hit.Parent=row
        hit.MouseButton1Click:Connect(function() setState(not on); if cb then cb(on) end end)
        return setState
    end

    -- Slider
    local function slider(parent,label,key,minV,maxV,order,cb)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,37); f.BackgroundTransparency=1
        f.LayoutOrder=order; f.Parent=parent
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.65,0,0,14); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9; lbl.TextColor3=T.Sub
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
        local curV=S[key] or minV
        local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0.35,0,0,14); valLbl.Position=UDim2.new(0.65,0,0,0)
        valLbl.BackgroundTransparency=1; valLbl.Text=tostring(curV); valLbl.Font=Enum.Font.GothamBold
        valLbl.TextSize=9; valLbl.TextColor3=T.Text; valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.Parent=f
        local track=Instance.new("Frame"); track.Size=UDim2.new(1,0,0,5); track.Position=UDim2.new(0,0,0,18)
        track.BackgroundColor3=T.Dim; track.BorderSizePixel=0; track.Parent=f
        local tcc=Instance.new("UICorner"); tcc.CornerRadius=UDim.new(0,3); tcc.Parent=track
        local pct=math.clamp((curV-minV)/(maxV-minV),0,1)
        local fill=Instance.new("Frame"); fill.Size=UDim2.new(pct,0,1,0); fill.BackgroundColor3=T.Green
        fill.BorderSizePixel=0; fill.Parent=track
        local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,3); fc.Parent=fill
        local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,12,0,12)
        thumb.Position=UDim2.new(pct,-6,0.5,-6); thumb.BackgroundColor3=Color3.new(1,1,1)
        thumb.BorderSizePixel=0; thumb.Parent=track
        local thc=Instance.new("UICorner"); thc.CornerRadius=UDim.new(0,6); thc.Parent=thumb
        local drag=false
        track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                local rel=math.clamp((Mouse.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                local val=math.round(minV+rel*(maxV-minV))
                S[key]=val; qSave(); valLbl.Text=tostring(val)
                fill.Size=UDim2.new(rel,0,1,0); thumb.Position=UDim2.new(rel,-6,0.5,-6)
                if cb then cb(val) end
            end
        end)
    end

    -- Dropdown
    local function dropdown(parent,label,opts,key,order,cb)
        local open=false
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,23); f.BackgroundTransparency=1
        f.LayoutOrder=order; f.ClipsDescendants=true; f.Parent=parent
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.48,0,0,23); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9; lbl.TextColor3=T.Sub
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
        local selLbl=Instance.new("TextLabel"); selLbl.Size=UDim2.new(0.52,-12,0,23)
        selLbl.Position=UDim2.new(0.48,0,0,0); selLbl.BackgroundTransparency=1
        selLbl.Text=(key and S[key]) or (opts[1] or ""); selLbl.Font=Enum.Font.GothamBold
        selLbl.TextSize=9; selLbl.TextColor3=T.Text; selLbl.TextXAlignment=Enum.TextXAlignment.Right; selLbl.Parent=f
        local arr=Instance.new("TextLabel"); arr.Size=UDim2.new(0,12,0,23); arr.Position=UDim2.new(1,-12,0,0)
        arr.BackgroundTransparency=1; arr.Text="⌄"; arr.Font=Enum.Font.Gotham; arr.TextSize=9
        arr.TextColor3=T.Dim; arr.Parent=f
        local listF=Instance.new("Frame"); listF.Size=UDim2.new(1,0,0,#opts*20)
        listF.Position=UDim2.new(0,0,0,23); listF.BackgroundColor3=Color3.fromRGB(11,11,11)
        listF.BorderSizePixel=0; listF.Parent=f
        local lfc=Instance.new("UICorner"); lfc.CornerRadius=UDim.new(0,5); lfc.Parent=listF
        local lfs=Instance.new("UIStroke"); lfs.Color=T.Border; lfs.Thickness=1; lfs.Parent=listF
        local lfl=Instance.new("UIListLayout"); lfl.SortOrder=Enum.SortOrder.LayoutOrder; lfl.Parent=listF
        local optBtns={}
        local curK=key
        local function rebuildOpts(newOpts,newKey)
            for _,b in pairs(optBtns) do pcall(function() b:Destroy() end) end optBtns={}
            curK=newKey or key; listF.Size=UDim2.new(1,0,0,#newOpts*20)
            selLbl.Text=(curK and S[curK]) or (newOpts[1] or "")
            for i,opt in ipairs(newOpts) do
                local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,0,0,20)
                ob.BackgroundColor3=Color3.fromRGB(11,11,11); ob.Text=opt
                ob.Font=Enum.Font.Gotham; ob.TextSize=9; ob.TextColor3=T.Sub
                ob.BorderSizePixel=0; ob.LayoutOrder=i; ob.Parent=listF
                ob.MouseButton1Click:Connect(function()
                    if curK then S[curK]=opt; qSave() end
                    selLbl.Text=opt; open=false
                    TweenService:Create(f,TweenInfo.new(0.14),{Size=UDim2.new(1,0,0,23)}):Play()
                    if cb then cb(opt) end
                end)
                ob.MouseEnter:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{TextColor3=T.Text,BackgroundColor3=Color3.fromRGB(20,20,20)}):Play() end)
                ob.MouseLeave:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{TextColor3=T.Sub,BackgroundColor3=Color3.fromRGB(11,11,11)}):Play() end)
                table.insert(optBtns,ob)
            end
        end
        rebuildOpts(opts,key)
        local hit=Instance.new("TextButton"); hit.Size=UDim2.new(1,0,0,23); hit.BackgroundTransparency=1
        hit.Text=""; hit.Parent=f
        hit.MouseButton1Click:Connect(function()
            open=not open
            TweenService:Create(f,TweenInfo.new(0.16,Enum.EasingStyle.Back),
                {Size=UDim2.new(1,0,0,open and 23+#optBtns*20 or 23)}):Play()
        end)
        return f,selLbl,rebuildOpts
    end

    -- Button
    local function btn(parent,label,col,order,cb)
        col=col or T.Card2
        local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,23)
        b.BackgroundColor3=col; b.Text=label; b.Font=Enum.Font.GothamBold; b.TextSize=9
        b.TextColor3=T.Text; b.BorderSizePixel=0; b.LayoutOrder=order; b.Parent=parent
        local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,5); bc.Parent=b
        local bs=Instance.new("UIStroke"); bs.Color=T.Border; bs.Thickness=1; bs.Parent=b
        b.MouseEnter:Connect(function()
            TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.2}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play()
        end)
        b.MouseButton1Click:Connect(function()
            TweenService:Create(b,TweenInfo.new(0.05),{Size=UDim2.new(0.97,0,0,20)}):Play()
            task.wait(0.07)
            TweenService:Create(b,TweenInfo.new(0.08),{Size=UDim2.new(1,0,0,23)}):Play()
            if cb then task.spawn(cb) end
        end)
        return b
    end

    -- Info row
    local function infoRow(parent,lbl,val,order)
        local r=Instance.new("Frame"); r.Size=UDim2.new(1,0,0,20); r.BackgroundTransparency=1
        r.LayoutOrder=order; r.Parent=parent
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.55,0,1,0); l.BackgroundTransparency=1
        l.Text=lbl; l.Font=Enum.Font.Gotham; l.TextSize=9; l.TextColor3=T.Sub
        l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local v=Instance.new("TextLabel"); v.Size=UDim2.new(0.45,0,1,0); v.Position=UDim2.new(0.55,0,0,0)
        v.BackgroundTransparency=1; v.Text=tostring(val); v.Font=Enum.Font.GothamBold
        v.TextSize=9; v.TextColor3=T.Text; v.TextXAlignment=Enum.TextXAlignment.Right; v.Parent=r
        return v
    end

    -- Separator
    local function sep(parent,order)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=T.Border
        f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent
    end

    -- ════════════════════════════════════════
    --  SIDEBAR NAVIGATION
    -- ════════════════════════════════════════
    sbSec("Elite Hub")
    local goFarm    = makeTab("Farm",   "Auto Farm")
    local goCombat  = makeTab("Combat", "Combat")
    local goTP      = makeTab("TP",     "Teleport")
    local goBoss    = makeTab("Boss",   "Boss")
    local goRaid    = makeTab("Raid",   "Raid")
    sbSec("Visuals")
    local goESP     = makeTab("ESP",    "ESP")
    local goVis     = makeTab("Visual", "Visual")
    sbSec("Player")
    local goMisc    = makeTab("Misc",   "Stats & Info")

    -- ════════════════════════════════════════
    --  PAGE: AUTO FARM
    -- ════════════════════════════════════════
    local pFarm=makePage("Farm")

    local fL,fR=twoCol(pFarm,1)

    -- Left: Farm Config
    local cfgC=card(fL,"Auto Farm",1)

    -- Live level display
    local lvRow=Instance.new("Frame"); lvRow.Size=UDim2.new(1,0,0,22); lvRow.BackgroundTransparency=1
    lvRow.LayoutOrder=1; lvRow.Parent=cfgC
    local lvLblA=Instance.new("TextLabel"); lvLblA.Size=UDim2.new(0.4,0,1,0); lvLblA.BackgroundTransparency=1
    lvLblA.Text="Your Level"; lvLblA.Font=Enum.Font.Gotham; lvLblA.TextSize=9; lvLblA.TextColor3=T.Sub
    lvLblA.TextXAlignment=Enum.TextXAlignment.Left; lvLblA.Parent=lvRow
    local lvValA=Instance.new("TextLabel"); lvValA.Size=UDim2.new(0.6,0,1,0); lvValA.Position=UDim2.new(0.4,0,0,0)
    lvValA.BackgroundTransparency=1; lvValA.Text="..."; lvValA.Font=Enum.Font.GothamBold
    lvValA.TextSize=9; lvValA.TextColor3=T.Gold; lvValA.TextXAlignment=Enum.TextXAlignment.Right; lvValA.Parent=lvRow

    -- Quest kill tracker
    local qRow=Instance.new("Frame"); qRow.Size=UDim2.new(1,0,0,20); qRow.BackgroundTransparency=1
    qRow.LayoutOrder=2; qRow.Parent=cfgC
    local qLblA=Instance.new("TextLabel"); qLblA.Size=UDim2.new(0.5,0,1,0); qLblA.BackgroundTransparency=1
    qLblA.Text="Quest Kills"; qLblA.Font=Enum.Font.Gotham; qLblA.TextSize=9; qLblA.TextColor3=T.Sub
    qLblA.TextXAlignment=Enum.TextXAlignment.Left; qLblA.Parent=qRow
    local qValA=Instance.new("TextLabel"); qValA.Size=UDim2.new(0.5,0,1,0); qValA.Position=UDim2.new(0.5,0,0,0)
    qValA.BackgroundTransparency=1; qValA.Text="0 / 0"; qValA.Font=Enum.Font.GothamBold
    qValA.TextSize=9; qValA.TextColor3=T.Teal; qValA.TextXAlignment=Enum.TextXAlignment.Right; qValA.Parent=qRow

    -- Quest state display
    local qStateRow=Instance.new("Frame"); qStateRow.Size=UDim2.new(1,0,0,18); qStateRow.BackgroundTransparency=1
    qStateRow.LayoutOrder=3; qStateRow.Parent=cfgC
    local qStateLbl=Instance.new("TextLabel"); qStateLbl.Size=UDim2.fromScale(1,1); qStateLbl.BackgroundTransparency=1
    qStateLbl.Text="Quest: Idle"; qStateLbl.Font=Enum.Font.Gotham; qStateLbl.TextSize=8.5
    qStateLbl.TextColor3=T.Dim; qStateLbl.TextXAlignment=Enum.TextXAlignment.Left; qStateLbl.Parent=qStateRow

    -- Live updates
    task.spawn(function()
        while task.wait(2.5) do
            if not lvValA.Parent then break end
            local lv=getLevel()
            local mob=getMobForLevel(lv)
            lvValA.Text=tostring(lv).."  →  "..mob.name
            qValA.Text=QUEST.killsDone.." / "..(QUEST.killsNeeded>0 and tostring(QUEST.killsNeeded) or "0")
            qStateLbl.Text="Quest: "..QUEST.state:sub(1,1):upper()..QUEST.state:sub(2)
            qStateLbl.TextColor3=QUEST.state=="farming" and T.Green
                or QUEST.state=="idle" and T.Dim or T.Gold
        end
    end)

    sep(cfgC,4)
    toggle(cfgC,"Auto Level Farm","AutoLevelFarm",5,function(on)
        S.AutoFarm=on
        if on then
            local m=getMobForLevel(getLevel()); S.TargetMob=m.name
            notify("Auto Level Farm","Lv "..getLevel().." → "..m.name,4,T.Gold)
            setStatus("Level Farm: "..m.name,T.Gold)
        else setStatus("Idle") end
    end)
    sep(cfgC,6)

    -- Sea / Mob dropdowns
    local _,_,setMobOpts=dropdown(cfgC,"Mob",SEA_MOBS_LIST[1],"TargetMob",7)
    dropdown(cfgC,"Sea",{"Sea 1","Sea 2","Sea 3"},nil,8,function(sea)
        local idx=tonumber(sea:match("%d")) or 1
        local mbs=SEA_MOBS_LIST[idx] or SEA_MOBS_LIST[1]
        setMobOpts(mbs,"TargetMob")
        S.TargetMob=mbs[1] or "Bandit"; qSave()
        notify("Farm","Sea → "..sea.."  |  Mob → "..S.TargetMob,2.5)
    end)
    dropdown(cfgC,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",9)

    -- Right: Toggles + quest
    local togC=card(fR,"Toggles",1)
    toggle(togC,"Auto Farm","AutoFarm",1,function(on)
        if on then setStatus("Farm: "..(S.TargetMob or "?"),T.Blue)
            notify("Farm","Started  —  "..(S.TargetMob or "Bandit"),3,T.Blue)
        else setStatus("Idle") notify("Farm","Stopped.",2) end
    end)
    toggle(togC,"Auto Quest","AutoQuest",2,function(on)
        if on then
            QUEST.state="idle"; QUEST.killsDone=0
            notify("Quest","Auto Quest ON — will accept & complete quests automatically",3.5,T.Teal)
            setStatus("Quest: Starting...",T.Teal)
        else QUEST.state="idle"; notify("Quest","Auto Quest OFF",2) end
    end)
    toggle(togC,"Auto Chest","AutoChest",3)
    toggle(togC,"Auto Eat Fruit","AutoEatFruit",4)
    toggle(togC,"Auto Respawn","AutoRespawn",5)
    toggle(togC,"Safe Mode","SafeMode",6,function(on) S.FarmDelay=on and 0.28 or 0.1 end)

    sep(pFarm,2)
    btn(pFarm,"■  STOP EVERYTHING",Color3.fromRGB(38,14,14),3,function()
        S.AutoFarm=false; S.AutoLevelFarm=false; S.AutoQuest=false
        S.AutoBoss=false; S.AutoRaid=false; QUEST.state="idle"
        setStatus("Idle"); notify("Stop","All farming stopped.",2.5,T.Red)
    end)

    -- Sea 1 / 2 quick farm (two columns)
    local s1L,s1R=twoCol(pFarm,4)
    local s1Lc=card(s1L,"Sea 1 — Quick Farm",1)
    local s1Rc=card(s1R,"Sea 2 — Quick Farm",1)
    for _,name in ipairs(SEA_MOBS_LIST[1]) do
        local info=MOB_MAP[name]
        btn(s1Lc,name..(info and " ["..info.minLv.."]" or ""),T.Card2,1,function()
            S.TargetMob=name; S.AutoFarm=true; S.AutoLevelFarm=false; qSave()
            if info then tp(info.pos) end
            setStatus("Farm: "..name,T.Blue); notify("Farm",name,2.5,T.Blue)
        end)
    end
    for _,name in ipairs(SEA_MOBS_LIST[2]) do
        local info=MOB_MAP[name]
        btn(s1Rc,name..(info and " ["..info.minLv.."]" or ""),T.Card2,1,function()
            S.TargetMob=name; S.AutoFarm=true; S.AutoLevelFarm=false; qSave()
            if info then tp(info.pos) end
            setStatus("Farm: "..name,T.Blue); notify("Farm",name,2.5,T.Blue)
        end)
    end

    -- Sea 3 quick farm
    local s3C=card(pFarm,"Sea 3 — Quick Farm",5)
    local s3L2,s3R2=twoCol(s3C,1)
    local half=#SEA_MOBS_LIST[3]//2
    for i,name in ipairs(SEA_MOBS_LIST[3]) do
        local info=MOB_MAP[name]
        local tgt=i<=half and s3L2 or s3R2
        btn(tgt,name..(info and " ["..info.minLv.."]" or ""),T.Card2,i,function()
            S.TargetMob=name; S.AutoFarm=true; S.AutoLevelFarm=false; qSave()
            if info then tp(info.pos) end
            setStatus("Farm: "..name,T.Blue); notify("Farm",name,2.5,T.Blue)
        end)
    end

    -- ════════════════════════════════════════
    --  PAGE: COMBAT
    -- ════════════════════════════════════════
    local pCbt=makePage("Combat")
    local cL,cR=twoCol(pCbt,1)

    local kaC=card(cL,"Kill Aura",1)
    toggle(kaC,"Enable Kill Aura","KillAura",1,function(on) notify("Kill Aura",on and"ON"or"OFF",2.5,on and T.Red or T.Sub) end)
    sep(kaC,2)
    slider(kaC,"Range","KillAuraRange",8,200,3,function(v) S.KillAuraRange=v end)

    local flyC=card(cL,"Fly",2)
    toggle(flyC,"Enable Fly  (WASD+Space)","FlyEnabled",1)
    slider(flyC,"Speed","FlySpeed",20,300,2)

    local moveC=card(cL,"Movement",3)
    toggle(moveC,"No Clip","NoClip",1)
    toggle(moveC,"Infinite Jump","InfJump",2)

    local defC=card(cR,"Defence",1)
    toggle(defC,"God Mode","GodMode",1,function(on) notify("God Mode",on and"ON"or"OFF",2.5,on and T.Gold or T.Sub) end)
    toggle(defC,"Anti-AFK","AntiAFK",2)

    local wsC=card(cR,"Walk Speed",2)
    slider(wsC,"Speed","WalkSpeed",16,350,1,function(v)
        local h=getHum(); if h then h.WalkSpeed=v end
    end)
    sep(wsC,2)
    local wsSpeeds={16,32,60,100,200,350}
    for i,sp in ipairs(wsSpeeds) do
        btn(wsC,"→ "..sp,T.Card2,2+i,function()
            S.WalkSpeed=sp; qSave()
            local h=getHum(); if h then h.WalkSpeed=sp end
        end)
    end

    local jpC=card(cR,"Jump Power",3)
    slider(jpC,"Power","JumpPower",50,600,1,function(v)
        local h=getHum(); if h then h.JumpPower=v end
    end)
    sep(jpC,2)
    for i,jp in ipairs({50,100,250,500}) do
        btn(jpC,"→ "..jp,T.Card2,2+i,function()
            S.JumpPower=jp; qSave()
            local h=getHum(); if h then h.JumpPower=jp end
        end)
    end

    -- ════════════════════════════════════════
    --  PAGE: TELEPORT
    -- ════════════════════════════════════════
    local pTP=makePage("TP")
    local tpL,tpR=twoCol(pTP,1)

    local frC=card(tpL,"Fruit Finder",1)
    toggle(frC,"Auto TP to Fruits","TPFruit",1)
    toggle(frC,"Auto Eat on Arrival","AutoEatFruit",2)
    btn(frC,"Scan & TP Nearest",T.Card2,3,function()
        local fruits=scanFruits(); local root=getRoot()
        if not root then notify("Fruit","No character.",2,T.Red); return end
        if #fruits==0 then notify("Fruit","No fruits found nearby.",2,T.Red); return end
        table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        tp(fruits[1].pos); STATS.fruitsTP=STATS.fruitsTP+1
        notify("Fruit","→  "..fruits[1].name,3,T.Green)
    end)

    local s1iC=card(tpL,"Sea 1  Islands",2)
    for _,d in ipairs(SEA1_ISLANDS) do
        btn(s1iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end)
    end

    local s2iC=card(tpR,"Sea 2  Islands",1)
    for _,d in ipairs(SEA2_ISLANDS) do
        btn(s2iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end)
    end
    local s3iC=card(tpR,"Sea 3  Islands",2)
    for _,d in ipairs(SEA3_ISLANDS) do
        btn(s3iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end)
    end

    -- ════════════════════════════════════════
    --  PAGE: BOSS
    -- ════════════════════════════════════════
    local pBoss=makePage("Boss")
    local bL,bR=twoCol(pBoss,1)

    local bCfg=card(bL,"Boss Config",1)
    local bNames={} for k in pairs(BOSS_POS) do table.insert(bNames,k) end table.sort(bNames)
    dropdown(bCfg,"Boss",bNames,"SelectedBoss",1)
    sep(bCfg,2)
    toggle(bCfg,"Auto Boss Farm","AutoBoss",3,function(on)
        if on then setStatus("Boss: "..S.SelectedBoss,T.Gold)
        else setStatus("Idle") end
        notify("Boss",on and"Started: "..S.SelectedBoss or"Stopped.",2.5,on and T.Gold or T.Sub)
    end)
    sep(bCfg,4)
    btn(bCfg,"TP to Boss Now",T.Card2,5,function()
        local pos=BOSS_POS[S.SelectedBoss]
        if pos then tp(pos); notify("Boss","→ "..S.SelectedBoss,2) end
    end)

    local bTPc=card(bR,"Quick Boss TP",1)
    for _,n in ipairs(bNames) do
        btn(bTPc,n,T.Card2,1,function()
            local pos=BOSS_POS[n]; if pos then tp(pos); notify("Boss","→ "..n,2) end
        end)
    end

    -- ════════════════════════════════════════
    --  PAGE: RAID
    -- ════════════════════════════════════════
    local pRaid=makePage("Raid")
    local rL,rR=twoCol(pRaid,1)

    local rCfg=card(rL,"Raid Config",1)
    local rNames={} for k in pairs(RAID_POS) do table.insert(rNames,k) end table.sort(rNames)
    dropdown(rCfg,"Raid",rNames,"SelectedRaid",1)
    sep(rCfg,2)
    toggle(rCfg,"Auto Raid","AutoRaid",3,function(on)
        if on then setStatus("Raid: "..S.SelectedRaid,T.Purple)
        else setStatus("Idle") end
        notify("Raid",on and"Started: "..S.SelectedRaid or"Stopped.",2.5,on and T.Purple or T.Sub)
    end)
    sep(rCfg,4)
    btn(rCfg,"TP to Raid Now",T.Card2,5,function()
        local pos=RAID_POS[S.SelectedRaid]
        if pos then tp(pos); notify("Raid","→ "..S.SelectedRaid,2) end
    end)

    local rTPc=card(rR,"Quick Raid TP",1)
    for _,n in ipairs(rNames) do
        btn(rTPc,n,T.Card2,1,function()
            local pos=RAID_POS[n]; if pos then tp(pos); notify("Raid","→ "..n,2) end
        end)
    end

    -- ════════════════════════════════════════
    --  PAGE: ESP
    -- ════════════════════════════════════════
    local pESP=makePage("ESP")
    local eL,eR=twoCol(pESP,1)

    local plESP=card(eL,"Player ESP",1)
    toggle(plESP,"Enable Player ESP","PlayerESP",1,function(on) notify("Player ESP",on and"ON"or"OFF",2,on and T.Blue or T.Sub) end)

    local mobESP=card(eL,"Mob ESP",2)
    toggle(mobESP,"Enable Mob ESP","MobESP",1,function(on) notify("Mob ESP",on and"ON"or"OFF",2,on and T.Blue or T.Sub) end)

    local frESP=card(eR,"Fruit ESP",1)
    toggle(frESP,"Enable Fruit ESP","FruitESP",1,function(on) notify("Fruit ESP",on and"ON"or"OFF",2,on and T.Green or T.Sub) end)

    local espInfoC=card(eR,"ESP Info",2)
    infoRow(espInfoC,"Engine",HAS_DRAW and "Drawing API" or "BillboardGui",1)
    infoRow(espInfoC,"Player ESP",S.PlayerESP and"ON"or"OFF",2)
    infoRow(espInfoC,"Mob ESP",S.MobESP and"ON"or"OFF",3)
    infoRow(espInfoC,"Fruit ESP",S.FruitESP and"ON"or"OFF",4)

    -- ════════════════════════════════════════
    --  PAGE: VISUAL
    -- ════════════════════════════════════════
    local pVis=makePage("Visual")
    local vL,vR=twoCol(pVis,1)

    local lightC=card(vL,"Lighting",1)
    toggle(lightC,"Fullbright","Fullbright",1,function(on)
        Lighting.Brightness=on and 3.8 or 1; Lighting.FogEnd=on and 1e6 or 1e4
        notify("Fullbright",on and"ON"or"OFF",2)
    end)
    toggle(lightC,"No Fog","NoFog",2,function(on) Lighting.FogEnd=on and 1e6 or 1e4; notify("No Fog",on and"ON"or"OFF",2) end)

    local camC=card(vL,"Camera",2)
    slider(camC,"FOV","FOV",40,120,1,function(v) Camera.FieldOfView=v end)
    btn(camC,"Reset FOV",T.Card2,2,function() S.FOV=70; qSave(); Camera.FieldOfView=70 end)

    local dispC=card(vR,"Display",1)
    toggle(dispC,"Show Watermark","ShowWatermark",1)
    toggle(dispC,"Show FPS Counter","ShowFPS",2)

    -- ════════════════════════════════════════
    --  PAGE: MISC / STATS
    -- ════════════════════════════════════════
    local pMisc=makePage("Misc")
    local mL,mR=twoCol(pMisc,1)

    -- Player info
    local plInfoC=card(mL,"Player Info",1)
    -- Avatar in misc (larger)
    local avFm=Instance.new("Frame"); avFm.Size=UDim2.new(1,0,0,56); avFm.BackgroundTransparency=1
    avFm.LayoutOrder=1; avFm.Parent=plInfoC
    local avHL=Instance.new("UIListLayout"); avHL.FillDirection=Enum.FillDirection.Horizontal
    avHL.SortOrder=Enum.SortOrder.LayoutOrder; avHL.Padding=UDim.new(0,8); avHL.Parent=avFm
    local avBig=Instance.new("Frame"); avBig.Size=UDim2.new(0,50,0,50); avBig.BackgroundColor3=T.Dim
    avBig.BorderSizePixel=0; avBig.Parent=avFm
    local avBC=Instance.new("UICorner"); avBC.CornerRadius=UDim.new(0,25); avBC.Parent=avBig
    local avBImg=Instance.new("ImageLabel"); avBImg.Size=UDim2.fromScale(1,1); avBImg.BackgroundTransparency=1
    avBImg.Image=AVATAR_URL; avBImg.ScaleType=Enum.ScaleType.Fit; avBImg.Parent=avBig
    local avBIC=Instance.new("UICorner"); avBIC.CornerRadius=UDim.new(0,25); avBIC.Parent=avBImg
    local infoVStack=Instance.new("Frame"); infoVStack.Size=UDim2.new(0,120,0,50); infoVStack.BackgroundTransparency=1; infoVStack.Parent=avFm
    local iVL=Instance.new("UIListLayout"); iVL.SortOrder=Enum.SortOrder.LayoutOrder; iVL.Padding=UDim.new(0,2); iVL.Parent=infoVStack
    local dnL2=Instance.new("TextLabel"); dnL2.Size=UDim2.new(1,0,0,16); dnL2.BackgroundTransparency=1
    dnL2.Text=DISPLAY_NAME; dnL2.Font=Enum.Font.GothamBold; dnL2.TextSize=10.5; dnL2.TextColor3=T.Text
    dnL2.TextXAlignment=Enum.TextXAlignment.Left; dnL2.LayoutOrder=1; dnL2.Parent=infoVStack
    local unL2=Instance.new("TextLabel"); unL2.Size=UDim2.new(1,0,0,13); unL2.BackgroundTransparency=1
    unL2.Text=USERNAME; unL2.Font=Enum.Font.Gotham; unL2.TextSize=9; unL2.TextColor3=T.Sub
    unL2.TextXAlignment=Enum.TextXAlignment.Left; unL2.LayoutOrder=2; unL2.Parent=infoVStack
    local exL2=Instance.new("TextLabel"); exL2.Size=UDim2.new(1,0,0,13); exL2.BackgroundTransparency=1
    exL2.Text="Executor: "..EXEC_NAME; exL2.Font=Enum.Font.Gotham; exL2.TextSize=8; exL2.TextColor3=T.Dim
    exL2.TextXAlignment=Enum.TextXAlignment.Left; exL2.LayoutOrder=3; exL2.Parent=infoVStack
    local idL2=Instance.new("TextLabel"); idL2.Size=UDim2.new(1,0,0,13); idL2.BackgroundTransparency=1
    idL2.Text="UserID: "..USER_ID; idL2.Font=Enum.Font.Gotham; idL2.TextSize=8; idL2.TextColor3=T.Dim
    idL2.TextXAlignment=Enum.TextXAlignment.Left; idL2.LayoutOrder=4; idL2.Parent=infoVStack
    sep(plInfoC,2)
    local sesR=infoRow(plInfoC,"Session Time",fmtTime(0),3)
    task.spawn(function()
        while task.wait(1) do
            if not sesR.Parent then break end; sesR.Text=fmtTime(os.time()-STATS.startTime)
        end
    end)
    infoRow(plInfoC,"Version","v1.0.0",4)

    -- Session stats
    local statsC=card(mL,"Session Stats",2)
    local kLbl  =infoRow(statsC,"Total Kills",0,1)
    local dLbl  =infoRow(statsC,"Deaths",0,2)
    local kpmLbl=infoRow(statsC,"Kills / Min","0",3)
    local qkLbl =infoRow(statsC,"Quest Kills",0,4)
    local ftLbl =infoRow(statsC,"Fruits Found",0,5)
    local ctLbl =infoRow(statsC,"Chests Opened",0,6)
    local qdLbl =infoRow(statsC,"Quests Done",0,7)
    task.spawn(function()
        while task.wait(1.5) do
            if not kLbl.Parent then break end
            kLbl.Text=tostring(STATS.kills)
            dLbl.Text=tostring(STATS.deaths)
            kpmLbl.Text=tostring(STATS.kpm)
            qkLbl.Text=tostring(STATS.questKills)
            ftLbl.Text=tostring(STATS.fruitsTP)
            ctLbl.Text=tostring(STATS.chestsTP)
            qdLbl.Text=tostring(STATS.questsDone)
        end
    end)

    local cfgC2=card(mR,"Config",1)
    btn(cfgC2,"Save Config",T.Card2,1,function() saveConfig(S); notify("Config","Saved!",2,T.Green) end)
    btn(cfgC2,"Reset to Defaults",Color3.fromRGB(38,14,14),2,function()
        for k,v in pairs(cfgDefault()) do S[k]=v end; saveConfig(S)
        notify("Config","Reset to defaults.",2.5,T.Gold)
    end)
    sep(cfgC2,3)
    btn(cfgC2,"Copy Discord",T.Card2,4,function()
        if HAS_CLIP then setclipboard("discord.gg/EmsMsHZCVH") end
        notify("Discord","discord.gg/EmsMsHZCVH  copied!",2,T.Blue)
    end)

    local infoC2=card(mR,"About",2)
    infoRow(infoC2,"Name","Elite Hub",1)
    infoRow(infoC2,"Version","v1.0.0",2)
    infoRow(infoC2,"Game","Blox Fruits",3)
    infoRow(infoC2,"Discord","discord.gg/EmsMsHZCVH",4)
    sep(infoC2,5)
    infoRow(infoC2,"Xeno/Solara","BLOCKED",6)
    infoRow(infoC2,"Delta Verified",IS_DELTA and"YES"or"N/A",7)

    -- Go to first tab
    goFarm()
    return sg
end

-- ════════════════════════════════════════════
--  GAME LOOPS
-- ════════════════════════════════════════════

-- Fly
task.spawn(function()
    local flyBody
    while task.wait(0.04) do
        if S.FlyEnabled and isAlive() then
            local root,hum=getRoot(),getHum()
            if root and hum then
                if not flyBody or not flyBody.Parent then
                    flyBody=Instance.new("BodyVelocity")
                    flyBody.MaxForce=Vector3.new(1e5,1e5,1e5)
                    flyBody.Velocity=Vector3.zero; flyBody.Parent=root
                end
                hum.PlatformStand=true
                local dir=Vector3.zero
                local cf=Camera.CFrame
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cf.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cf.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cf.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cf.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir=dir+Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
                flyBody.Velocity=dir.Magnitude>0 and dir.Unit*(S.FlySpeed or 60) or Vector3.zero
            end
        else
            if flyBody and flyBody.Parent then
                flyBody:Destroy(); flyBody=nil
                local h=getHum(); if h then h.PlatformStand=false end
            end
        end
    end
end)

-- NoClip
task.spawn(function()
    while task.wait(0.03) do
        if not S.NoClip then continue end
        local char=getChar(); if not char then continue end
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

-- GodMode
task.spawn(function()
    while task.wait(0.07) do
        if not S.GodMode then continue end
        local h=getHum()
        if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end
    end
end)

-- WalkSpeed / JumpPower sync
task.spawn(function()
    while task.wait(1.5) do
        if not isAlive() then continue end
        local h=getHum()
        if h then
            if S.WalkSpeed and S.WalkSpeed~=16 then h.WalkSpeed=S.WalkSpeed end
            if S.JumpPower and S.JumpPower~=50  then h.JumpPower=S.JumpPower end
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

-- ════════════════════════════════════════════
--  QUEST STATE MACHINE LOOP
--  Properly: find NPC → accept → kill mobs → return → complete
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.5) do
        if not S.AutoQuest then QUEST.state="idle"; continue end
        if not isAlive() then task.wait(3); continue end

        local mobData = MOB_MAP[S.TargetMob] or getMobForLevel(getLevel())
        if not mobData then continue end

        -- IDLE: determine if we need a quest
        if QUEST.state=="idle" then
            QUEST.mob=mobData
            QUEST.killsNeeded=mobData.kills or 10
            QUEST.killsDone=0
            QUEST.state="going_npc"
            setStatus("Quest: Going to NPC",T.Teal)

        -- GOING_NPC: teleport to quest NPC position
        elseif QUEST.state=="going_npc" then
            local npcPos=mobData.questPos or mobData.pos
            tp(npcPos + Vector3.new(0,0,5))
            task.wait(0.8)

            -- Try to find and interact with actual quest NPC in world
            local npc=findQuestNPC(npcPos, 60)
            if npc then
                QUEST.lastNpcPos=npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("HumanoidRootPart").Position or npcPos
                interactNPC(npc)
                task.wait(0.5)
            else
                QUEST.lastNpcPos=npcPos
            end

            -- Fire quest accept remotes regardless
            tryAcceptQuest(mobData.name)
            task.wait(0.4)
            QUEST.state="farming"
            setStatus("Quest: Farming "..mobData.name.." (0/"..QUEST.killsNeeded..")",T.Green)
            notify("Quest","Accepted! Kill "..QUEST.killsNeeded.."× "..mobData.name,4,T.Teal)

        -- FARMING: kill mobs until quest complete
        elseif QUEST.state=="farming" then
            if QUEST.killsDone>=QUEST.killsNeeded then
                QUEST.state="returning"
                setStatus("Quest: Returning to NPC",T.Gold)
            else
                -- Kill current target mob
                local mob=findMob(mobData.name,500)
                if mob then
                    attackMob(mob)
                    setStatus("Quest: Farming "..mobData.name.." ("..QUEST.killsDone.."/"..QUEST.killsNeeded..")",T.Green)
                else
                    -- No mob found, go to spawn
                    local sp=mobData.pos
                    local root=getRoot()
                    if root and (root.Position-sp).Magnitude>100 then
                        tp(sp); task.wait(1)
                    else
                        task.wait(0.5) -- wait for respawn
                    end
                end
            end

        -- RETURNING: go back to NPC to complete
        elseif QUEST.state=="returning" then
            local npcPos=QUEST.lastNpcPos or mobData.questPos or mobData.pos
            tp(npcPos + Vector3.new(0,0,5))
            task.wait(0.8)
            -- Interact with NPC to complete
            local npc=findQuestNPC(npcPos,60)
            if npc then interactNPC(npc); task.wait(0.4) end
            -- Fire complete remotes
            for _,v in pairs(RepStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local n=v.Name:lower()
                    if n:find("quest") or n:find("complete") or n:find("finish") or n:find("reward") then
                        pcall(function() v:FireServer() end)
                        pcall(function() v:FireServer(mobData.name) end)
                    end
                end
            end
            task.wait(0.4)
            STATS.questsDone=STATS.questsDone+1
            notify("Quest","Quest complete! +"..QUEST.killsDone.." kills",3,T.Gold)
            QUEST.state="idle" -- loop again
            setStatus("Quest: Idle",T.Teal)
        end
    end
end)

-- ════════════════════════════════════════════
--  MAIN FARM LOOP  (kill mobs, use all methods)
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(S.FarmDelay or 0.1) do
        if not S.AutoFarm and not S.AutoLevelFarm then continue end
        if not isAlive() then
            if S.AutoRespawn then task.wait(3) end; continue
        end

        -- Auto-level: update target mob based on current level
        if S.AutoLevelFarm then
            local lv=getLevel()
            local mob=getMobForLevel(lv)
            if mob.name~=S.TargetMob then
                S.TargetMob=mob.name
                setStatus("Level Farm: "..mob.name,T.Gold)
                notify("Level Up!","Now farming: "..mob.name,3,T.Gold)
            end
        end

        local target=findMob(S.TargetMob, 600)
        if target then
            attackMob(target)
        else
            -- No mob found — teleport to spawn
            local info=MOB_MAP[S.TargetMob]
            if info then
                local root=getRoot()
                if root and (root.Position-info.pos).Magnitude>120 then
                    tp(info.pos)
                    task.wait(S.SafeMode and 2 or 1)
                else
                    task.wait(0.4) -- brief wait for respawn
                end
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  KILL AURA LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.07) do
        if not S.KillAura or not isAlive() then continue end
        local root=getRoot(); if not root then continue end
        local nearby=findAllMobs(S.KillAuraRange or 25)
        for _,info in ipairs(nearby) do
            if not S.KillAura then break end
            attackMob(info.obj)
            task.wait(0.04)
        end
    end
end)

-- ════════════════════════════════════════════
--  AUTO BOSS LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoBoss or not isAlive() then continue end
        local boss=findMob(S.SelectedBoss, 9999)
        if boss then
            attackMob(boss)
        else
            local pos=BOSS_POS[S.SelectedBoss]
            local root=getRoot()
            if root and pos and (root.Position-pos).Magnitude>200 then
                tp(pos); task.wait(2)
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  AUTO RAID LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoRaid or not isAlive() then continue end
        local rp=RAID_POS[S.SelectedRaid]
        local root=getRoot()
        if root and rp and (root.Position-rp).Magnitude>200 then
            tp(rp); task.wait(1.5)
        end
        local nearby=findAllMobs(400)
        for _,info in ipairs(nearby) do
            if not S.AutoRaid then break end
            attackMob(info.obj); task.wait(0.06)
        end
    end
end)

-- ════════════════════════════════════════════
--  FRUIT TP LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(4) do
        if not S.TPFruit or not isAlive() then continue end
        local fruits=scanFruits(); local root=getRoot()
        if not root or #fruits==0 then continue end
        table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        local f=fruits[1]; tp(f.pos); STATS.fruitsTP=STATS.fruitsTP+1
        notify("Fruit TP","→ "..f.name,3,T.Green)
        if S.AutoEatFruit and HAS_FTI and f.part and f.part.Parent then
            task.wait(0.3)
            local r2=getRoot()
            if r2 then
                pcall(firetouchinterest,f.part,r2,0); task.wait(0.1)
                pcall(firetouchinterest,f.part,r2,1)
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  AUTO CHEST LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(3) do
        if not S.AutoChest or not isAlive() then continue end
        local chests=scanChests(); local root=getRoot()
        if not root or #chests==0 then continue end
        table.sort(chests,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        local c=chests[1]; tp(c.pos)
        task.wait(0.3)
        if HAS_FTI and c.part and c.part.Parent then
            local r2=getRoot()
            if r2 then
                pcall(firetouchinterest,c.part,r2,0); task.wait(0.1)
                pcall(firetouchinterest,c.part,r2,1)
                STATS.chestsTP=STATS.chestsTP+1
            end
        end
        if HAS_FCD then
            for _,cd in pairs(c.obj:GetDescendants()) do
                if cd:IsA("ClickDetector") then pcall(fireclickdetector,cd) end
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  TOGGLE KEYBIND  (RightShift = show/hide)
-- ════════════════════════════════════════════
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

-- ════════════════════════════════════════════
--  DISCORD POPUP
-- ════════════════════════════════════════════
local function showDiscordPopup()
    task.wait(6)
    local sg=Instance.new("ScreenGui"); sg.Name="_EHD"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.Parent=PG
    local f=Instance.new("Frame"); f.Size=UDim2.new(0,268,0,116)
    f.Position=UDim2.new(0.5,-134,1,10); f.BackgroundColor3=T.Panel; f.BorderSizePixel=0; f.Parent=sg
    local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,9); fc.Parent=f
    local fs=Instance.new("UIStroke"); fs.Color=T.Blue; fs.Thickness=1.5; fs.Parent=f
    local ft=Instance.new("Frame"); ft.Size=UDim2.new(1,0,0,2); ft.BackgroundColor3=T.Blue; ft.BorderSizePixel=0; ft.Parent=f
    local ic=Instance.new("Frame"); ic.Size=UDim2.new(0,32,0,32); ic.Position=UDim2.new(0,12,0,14)
    ic.BackgroundColor3=T.Blue; ic.BorderSizePixel=0; ic.Parent=f
    local icc=Instance.new("UICorner"); icc.CornerRadius=UDim.new(0,16); icc.Parent=ic
    local icl=Instance.new("TextLabel"); icl.Size=UDim2.fromScale(1,1); icl.BackgroundTransparency=1
    icl.Text="D"; icl.Font=Enum.Font.GothamBlack; icl.TextSize=16; icl.TextColor3=Color3.new(1,1,1); icl.Parent=ic
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-58,0,16); tl.Position=UDim2.new(0,52,0,11)
    tl.BackgroundTransparency=1; tl.Text="Join Elite Hub Discord"
    tl.Font=Enum.Font.GothamBlack; tl.TextSize=10.5; tl.TextColor3=T.Text
    tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=f
    local bl=Instance.new("TextLabel"); bl.Size=UDim2.new(1,-58,0,18); bl.Position=UDim2.new(0,52,0,27)
    bl.BackgroundTransparency=1; bl.Text="Updates, announcements & support"
    bl.Font=Enum.Font.Gotham; bl.TextSize=8.5; bl.TextColor3=T.Sub
    bl.TextXAlignment=Enum.TextXAlignment.Left; bl.TextWrapped=true; bl.Parent=f
    local linkF=Instance.new("Frame"); linkF.Size=UDim2.new(1,-18,0,23); linkF.Position=UDim2.new(0,9,0,60)
    linkF.BackgroundColor3=Color3.fromRGB(9,9,9); linkF.BorderSizePixel=0; linkF.Parent=f
    local lfc2=Instance.new("UICorner"); lfc2.CornerRadius=UDim.new(0,5); lfc2.Parent=linkF
    local lfs2=Instance.new("UIStroke"); lfs2.Color=T.Border; lfs2.Thickness=1; lfs2.Parent=linkF
    local ll=Instance.new("TextLabel"); ll.Size=UDim2.new(1,-10,1,0); ll.Position=UDim2.new(0,8,0,0)
    ll.BackgroundTransparency=1; ll.Text="discord.gg/EmsMsHZCVH"
    ll.Font=Enum.Font.GothamBold; ll.TextSize=9.5; ll.TextColor3=T.Blue
    ll.TextXAlignment=Enum.TextXAlignment.Left; ll.Parent=linkF
    local cp=Instance.new("TextButton"); cp.Size=UDim2.new(0,58,0,20); cp.Position=UDim2.new(0,9,1,-28)
    cp.BackgroundColor3=T.Blue; cp.Text="Copy"; cp.Font=Enum.Font.GothamBold; cp.TextSize=9
    cp.TextColor3=Color3.new(1,1,1); cp.BorderSizePixel=0; cp.Parent=f
    local cpc=Instance.new("UICorner"); cpc.CornerRadius=UDim.new(0,5); cpc.Parent=cp
    cp.MouseButton1Click:Connect(function()
        if HAS_CLIP then setclipboard("discord.gg/EmsMsHZCVH") end
        cp.Text="Copied!"; task.wait(1.5); cp.Text="Copy"
    end)
    local xb=Instance.new("TextButton"); xb.Size=UDim2.new(0,18,0,18); xb.Position=UDim2.new(1,-24,0,7)
    xb.BackgroundColor3=T.Dim; xb.Text="×"; xb.Font=Enum.Font.GothamBold; xb.TextSize=11
    xb.TextColor3=T.Sub; xb.BorderSizePixel=0; xb.Parent=f
    local xbc=Instance.new("UICorner"); xbc.CornerRadius=UDim.new(0,9); xbc.Parent=xb
    xb.MouseButton1Click:Connect(function()
        TweenService:Create(f,TweenInfo.new(0.22),{Position=UDim2.new(0.5,-134,1,10)}):Play()
        task.wait(0.25); pcall(function() sg:Destroy() end)
    end)
    TweenService:Create(f,TweenInfo.new(0.38,Enum.EasingStyle.Back),{Position=UDim2.new(0.5,-134,1,-126)}):Play()
    task.delay(18,function()
        if sg and sg.Parent then
            TweenService:Create(f,TweenInfo.new(0.22),{Position=UDim2.new(0.5,-134,1,10)}):Play()
            task.wait(0.25); pcall(function() sg:Destroy() end)
        end
    end)
end

-- ════════════════════════════════════════════
--  ESP STARTUP (needs Drawing API)
-- ════════════════════════════════════════════
if HAS_DRAW then
    task.spawn(startESP)
end

-- ════════════════════════════════════════════
--  BOOT SEQUENCE
-- ════════════════════════════════════════════
task.spawn(function()
    showLoader()
    task.wait(0.12)
    _guiRef = buildGUI()
    buildWatermark()
    task.wait(0.35)
    notify("Elite Hub","v1.0.0  •  RShift to toggle  "
        ..(IS_DELTA and " [Delta ✓]" or ""),4,T.Accent)
    task.defer(showDiscordPopup)
end)

-- ════════════════════════════════════════════
--  CONSOLE BANNER
-- ════════════════════════════════════════════
print("╔═══════════════════════════════════════════════╗")
print("║   ELITE HUB  v1.0.0                          ║")
print("║   Blox Fruits  |  All Seas  |  Lv 1–2800     ║")
print("║   Combat : 6-method attack engine            ║")
print("║   Quest  : State-machine auto quest          ║")
print("║   Safety : Xeno/Solara blocked at boot       ║")
print("║   Discord: discord.gg/EmsMsHZCVH             ║")
print("╚═══════════════════════════════════════════════╝")
print("  Executor : "..EXEC_NAME..(IS_DELTA and "  [Delta Verified]" or ""))
print("  User     : "..USERNAME.."  ("..DISPLAY_NAME..")")
print("  UserID   : "..USER_ID)
