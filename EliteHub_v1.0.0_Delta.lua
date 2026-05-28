-- Elite Hub v1.0.0 | Blox Fruits | Delta/Fluxus/Arceus X/Wave
-- discord.gg/EmsMsHZCVH

-- ── CAPABILITY FLAGS ──────────────────────────────────────────────────
local HAS_DRAW    = typeof(Drawing)             == "table"
local HAS_WF      = typeof(writefile)           == "function"
local HAS_RF      = typeof(readfile)            == "function"
local HAS_FTI     = typeof(firetouchinterest)   == "function"
local HAS_FCD     = typeof(fireclickdetector)   == "function"
local HAS_FPP     = typeof(fireproximityprompt) == "function"
local HAS_NCC     = typeof(newcclosure)         == "function"
local HAS_CLR     = typeof(cloneref)            == "function"
local HAS_SIM     = typeof(getsimulationradius) == "function"
local HAS_GUV     = typeof(getupvalues)         == "function"
local HAS_SUV     = pcall(function() debug.setupvalue end) and typeof(debug.setupvalue) == "function"
local HAS_ISNET   = typeof(isnetworkowner)      == "function"
local HAS_SETSCR  = typeof(setscriptable)       == "function"
local HAS_HIDDEN  = typeof(sethiddenproperty)   == "function"

local EXEC_NAME = "Unknown"
pcall(function()
    if identifyexecutor then EXEC_NAME = identifyexecutor()
    elseif getexecutorname then EXEC_NAME = getexecutorname() end
end)
local EL       = EXEC_NAME:lower()
local IS_DELTA = EL:find("delta") ~= nil

if EL:find("xeno") or EL:find("solara") then
    pcall(function() game:GetService("Players").LocalPlayer:Kick(
        "[Elite Hub] Blocked executor: "..EXEC_NAME.."\nUse Delta, Fluxus, Arceus X or Wave.") end)
    return
end

-- ── SERVICES ──────────────────────────────────────────────────────────
local function ref(s)  return (HAS_CLR and cloneref or function(x) return x end)(s) end
local function wrap(f) return (HAS_NCC and newcclosure or function(x) return x end)(f) end

local Players  = ref(game:GetService("Players"))
local RS       = ref(game:GetService("RunService"))
local UIS      = ref(game:GetService("UserInputService"))
local TS       = ref(game:GetService("TweenService"))
local VU       = ref(game:GetService("VirtualUser"))
local Lighting = ref(game:GetService("Lighting"))
local RepStor  = ref(game:GetService("ReplicatedStorage"))
local LP       = Players.LocalPlayer
local Mouse    = LP:GetMouse()
local PG       = LP:WaitForChild("PlayerGui", 10)
local Camera   = workspace.CurrentCamera
local USER_ID  = LP.UserId
local AVATAR   = "rbxthumb://type=AvatarHeadShot&id="..USER_ID.."&w=150&h=150"

print("[Elite Hub] discord.gg/EmsMsHZCVH")
pcall(function() if setclipboard then setclipboard("https://discord.gg/EmsMsHZCVH") end end)
pcall(function()
    local ec = RepStor:FindFirstChild("Effect")
    if ec and ec:FindFirstChild("Container") then
        for _, n in ipairs({"Death","Respawn"}) do
            local c = ec.Container:FindFirstChild(n)
            if c then c:Destroy() end
        end
    end
end)

-- ── CONFIG ────────────────────────────────────────────────────────────
local CFG = "EliteHub_v1_config.json"

local function cfgDefault() return {
    AutoFarm=false, TargetMob="Bandit", FarmMethod="Melee",
    SafeMode=false, FarmDelay=0.1, AutoLevelFarm=false,
    AutoQuest=false, AutoChest=false,
    AutoBoss=false, SelectedBoss="Gorilla King",
    AutoRaid=false, SelectedRaid="Flame",
    TPFruit=false, AutoEatFruit=false,
    KillAura=false, KillAuraRange=25, KillAuraTeamCheck=true,
    BringMob=true, FastAttack=true, FastAttackType="Fast",
    AutoHaki=true, AutoRespawn=true, AntiAFK=true,
    FlyEnabled=false, FlySpeed=60, NoClip=false,
    InfJump=false, WalkSpeed=16, JumpPower=50,
    GodMode=false,
    PlayerESP=false, MobESP=false, FruitESP=false,
    ESPDistance=true, ESPHealth=true,
    Fullbright=false, NoFog=false, FOV=70,
    ShowWatermark=true, ShowFPS=true,
    AutoStat=false, StatPriority="Melee",
    SkillZ=false, SkillX=false, SkillC=false, SkillV=false,
    MasteryFarm=false, MasteryWeapon="Sword",
    FruitNotify=true, FruitNotifyRange=500,
    BypassTP=false,
    SavedPosX=0, SavedPosY=0, SavedPosZ=0,
    AccentPreset="Pink", ToggleKey="RightShift",
    NotifyDur=3,
} end

local function encodeJSON(d)
    local t = {}
    for k, v in pairs(d) do
        local s
        if type(v)=="boolean" then s=tostring(v)
        elseif type(v)=="number" then s=tostring(v)
        else s='"'..tostring(v):gsub('\\','\\\\'):gsub('"','\\"')..'"' end
        t[#t+1] = '"'..k..'":'..s
    end
    return "{"..table.concat(t,",").."}"
end

local function decodeJSON(raw, def)
    local d = {}; for k,v in pairs(def) do d[k]=v end
    pcall(function()
        for k in pairs(def) do
            local v = raw:match('"'..k..'":%s*(.-)%s*[,}%]]')
            if v then
                v = v:gsub("^%s+",""):gsub("%s+$","")
                if v=="true" then d[k]=true
                elseif v=="false" then d[k]=false
                elseif tonumber(v) then d[k]=tonumber(v)
                else d[k]=v:gsub('^"',''):gsub('"$','') end
            end
        end
    end)
    return d
end

local function saveConfig(S)
    if not HAS_WF then return end
    pcall(function()
        if makefolder and isfolder and not isfolder("EliteHub") then makefolder("EliteHub") end
        writefile(CFG, encodeJSON(S))
    end)
end

local function loadConfig()
    local def = cfgDefault()
    if not HAS_RF then return def end
    local ok, raw = pcall(readfile, CFG)
    if ok and raw and #raw > 2 then return decodeJSON(raw, def) end
    return def
end

local S = loadConfig()
local _savePend = false
local function qSave()
    if _savePend then return end
    _savePend = true
    task.delay(1.5, function() _savePend=false; saveConfig(S) end)
end

-- ── MOB DATABASE ──────────────────────────────────────────────────────
local MOBS = {
    -- Sea 1
    {s=1,n="Bandit",         mn=1,   mx=14,  k=8,  p=Vector3.new(979,125,1570),    q=Vector3.new(997,126,1587)},
    {s=1,n="Monkey",         mn=15,  mx=29,  k=8,  p=Vector3.new(-1500,125,-200),  q=Vector3.new(-1495,125,-185)},
    {s=1,n="Gorilla",        mn=30,  mx=59,  k=8,  p=Vector3.new(-1700,125,-310),  q=Vector3.new(-1695,125,-295)},
    {s=1,n="Pirate",         mn=60,  mx=99,  k=10, p=Vector3.new(-1200,125,4350),  q=Vector3.new(-1195,125,4365)},
    {s=1,n="Brute",          mn=100, mx=124, k=10, p=Vector3.new(-1100,125,4500),  q=Vector3.new(-1095,125,4515)},
    {s=1,n="Desert Bandit",  mn=125, mx=149, k=10, p=Vector3.new(870,125,4000),    q=Vector3.new(880,126,4010)},
    {s=1,n="Desert Officer", mn=150, mx=174, k=10, p=Vector3.new(1050,125,4200),   q=Vector3.new(1060,126,4210)},
    {s=1,n="Snow Bandit",    mn=175, mx=199, k=10, p=Vector3.new(1200,125,-2700),  q=Vector3.new(1210,126,-2690)},
    {s=1,n="Snowman",        mn=200, mx=249, k=10, p=Vector3.new(1300,125,-2850),  q=Vector3.new(1310,126,-2840)},
    {s=1,n="Marine",         mn=250, mx=299, k=10, p=Vector3.new(-900,125,-350),   q=Vector3.new(-890,126,-340)},
    {s=1,n="Sky Bandit",     mn=300, mx=374, k=12, p=Vector3.new(-4700,875,-700),  q=Vector3.new(-4690,876,-690)},
    {s=1,n="Dark Master",    mn=375, mx=449, k=12, p=Vector3.new(-4950,1410,-700), q=Vector3.new(-4940,1411,-690)},
    {s=1,n="Toga Warrior",   mn=450, mx=624, k=12, p=Vector3.new(3324,127,-2640),  q=Vector3.new(3334,127,-2630)},
    -- Sea 2
    {s=2,n="Hoodlum",             mn=625, mx=699,  k=10, p=Vector3.new(-750,266,550),     q=Vector3.new(-740,267,560)},
    {s=2,n="Trader",              mn=700, mx=774,  k=10, p=Vector3.new(-900,266,650),     q=Vector3.new(-890,267,660)},
    {s=2,n="Forest Pirate",       mn=775, mx=849,  k=10, p=Vector3.new(-3550,125,1850),   q=Vector3.new(-3540,126,1860)},
    {s=2,n="Factory Staff",       mn=850, mx=924,  k=10, p=Vector3.new(-3300,125,2000),   q=Vector3.new(-3290,126,2010)},
    {s=2,n="Zombie",              mn=925, mx=999,  k=10, p=Vector3.new(-5800,125,-620),   q=Vector3.new(-5790,126,-610)},
    {s=2,n="Vampire",             mn=1000,mx=1049, k=10, p=Vector3.new(-5900,125,-700),   q=Vector3.new(-5890,126,-690)},
    {s=2,n="Living Zombie",       mn=1050,mx=1099, k=12, p=Vector3.new(-5950,125,-750),   q=Vector3.new(-5940,126,-740)},
    {s=2,n="Demonic Soul",        mn=1100,mx=1174, k=12, p=Vector3.new(-5200,125,-1720),  q=Vector3.new(-5190,126,-1710)},
    {s=2,n="Ship Crew",           mn=1175,mx=1249, k=12, p=Vector3.new(-5200,125,-1780),  q=Vector3.new(-5190,126,-1770)},
    {s=2,n="Cursed Pirate",       mn=1250,mx=1324, k=12, p=Vector3.new(-5300,125,-1800),  q=Vector3.new(-5290,126,-1790)},
    {s=2,n="Military Soldier",    mn=1325,mx=1399, k=12, p=Vector3.new(-10000,125,-2000), q=Vector3.new(-9990,126,-1990)},
    {s=2,n="Military Spy",        mn=1325,mx=1399, k=12, p=Vector3.new(-9800,125,-1900),  q=Vector3.new(-9790,126,-1890)},
    {s=2,n="Assassin",            mn=1400,mx=1474, k=12, p=Vector3.new(-9500,125,-1700),  q=Vector3.new(-9490,126,-1690)},
    {s=2,n="Arctic Warrior",      mn=1475,mx=1549, k=12, p=Vector3.new(-4300,1000,-1000), q=Vector3.new(-4290,1001,-990)},
    {s=2,n="Snow Lurker",         mn=1550,mx=1624, k=12, p=Vector3.new(-4600,1020,-1100), q=Vector3.new(-4590,1021,-1090)},
    {s=2,n="Dragon Crew Warrior", mn=1700,mx=1774, k=12, p=Vector3.new(3600,125,29450),   q=Vector3.new(3610,126,29460)},
    {s=2,n="Dragon Crew Archer",  mn=1775,mx=1849, k=12, p=Vector3.new(3700,125,29550),   q=Vector3.new(3710,126,29560)},
    {s=2,n="Swan Pirate",         mn=1850,mx=1924, k=12, p=Vector3.new(880,125,29250),    q=Vector3.new(890,126,29260)},
    {s=2,n="Poseidon Soldier",    mn=1925,mx=1999, k=14, p=Vector3.new(61350,125,1780),   q=Vector3.new(61360,126,1790)},
    {s=2,n="Poseidon Knight",     mn=2000,mx=2099, k=14, p=Vector3.new(61450,125,1850),   q=Vector3.new(61460,126,1860)},
    -- Sea 3
    {s=3,n="Galley Pirate",         mn=1500,mx=1574, k=14, p=Vector3.new(-2000,50,-4200),   q=Vector3.new(-1990,51,-4190)},
    {s=3,n="Pirate Millionaire",    mn=1575,mx=1649, k=14, p=Vector3.new(-2100,50,-4300),   q=Vector3.new(-2090,51,-4290)},
    {s=3,n="Jungle Bug",            mn=1650,mx=1724, k=14, p=Vector3.new(-3200,125,-3800),  q=Vector3.new(-3190,126,-3790)},
    {s=3,n="Laboon",                mn=1725,mx=1799, k=14, p=Vector3.new(-3350,125,-3950),  q=Vector3.new(-3340,126,-3940)},
    {s=3,n="Forest Dragon",         mn=1800,mx=1874, k=14, p=Vector3.new(-9000,400,-2500),  q=Vector3.new(-8990,401,-2490)},
    {s=3,n="Tree Spider",           mn=1875,mx=1949, k=14, p=Vector3.new(-9100,400,-2600),  q=Vector3.new(-9090,401,-2590)},
    {s=3,n="Reborn Skeleton",       mn=1950,mx=2049, k=14, p=Vector3.new(-11400,400,-1000), q=Vector3.new(-11390,401,-990)},
    {s=3,n="Cursed Skeleton",       mn=2050,mx=2124, k=14, p=Vector3.new(-11500,400,-1040), q=Vector3.new(-11490,401,-1030)},
    {s=3,n="Soul Reaper",           mn=2125,mx=2199, k=14, p=Vector3.new(-11600,400,-1080), q=Vector3.new(-11590,401,-1070)},
    {s=3,n="Diablo",                mn=2275,mx=2349, k=14, p=Vector3.new(-8300,125,1600),   q=Vector3.new(-8290,126,1610)},
    {s=3,n="Beautiful Pirate",      mn=2350,mx=2424, k=14, p=Vector3.new(-8350,125,1650),   q=Vector3.new(-8340,126,1660)},
    {s=3,n="Tiki Outpost Raider",   mn=2425,mx=2499, k=14, p=Vector3.new(-8280,125,-1000),  q=Vector3.new(-8270,126,-990)},
    {s=3,n="Brawler Crab",          mn=2425,mx=2499, k=14, p=Vector3.new(-14500,243,-1000), q=Vector3.new(-14490,244,-990)},
    {s=3,n="Chocolate Bar Battler", mn=2500,mx=2574, k=16, p=Vector3.new(-13950,125,3800),  q=Vector3.new(-13940,126,3810)},
    {s=3,n="Ice Cream Staff",       mn=2575,mx=2649, k=16, p=Vector3.new(-14050,125,3780),  q=Vector3.new(-14040,126,3790)},
    {s=3,n="Baking Staff",          mn=2650,mx=2699, k=16, p=Vector3.new(-14100,125,3900),  q=Vector3.new(-14090,126,3910)},
    {s=3,n="Cake Guard",            mn=2700,mx=2749, k=16, p=Vector3.new(-14000,125,3850),  q=Vector3.new(-13990,126,3860)},
    {s=3,n="Candy Rebel",           mn=2750,mx=2799, k=16, p=Vector3.new(-11650,125,5450),  q=Vector3.new(-11640,126,5460)},
    {s=3,n="Cocoa Warrior",         mn=2800,mx=9999, k=16, p=Vector3.new(-12300,125,4950),  q=Vector3.new(-12290,126,4960)},
    {s=3,n="Mythological Pirate",   mn=2800,mx=9999, k=16, p=Vector3.new(-15100,125,-1750), q=Vector3.new(-15090,126,-1740)},
    {s=3,n="Leviathan",             mn=2800,mx=9999, k=16, p=Vector3.new(-13050,125,-4650), q=Vector3.new(-13040,126,-4640)},
    {s=3,n="Longma",                mn=2800,mx=9999, k=16, p=Vector3.new(3640,125,29500),   q=Vector3.new(3650,126,29510)},
}

local MOB_MAP, SEA_LIST = {}, {[1]={}, [2]={}, [3]={}}
local _seen = {}
for _, m in ipairs(MOBS) do
    if not MOB_MAP[m.n] then MOB_MAP[m.n] = m end
    local uid = m.n.."|"..m.s
    if not _seen[uid] then _seen[uid]=true; table.insert(SEA_LIST[m.s], m.n) end
end

-- ── TELEPORT DATA ─────────────────────────────────────────────────────
local SEA1_ISL = {
    {"Starter Island",Vector3.new(1260,125,1612)},{"Marine Starter",Vector3.new(-1180,125,-1174)},
    {"Middle Town",Vector3.new(-192,125,-559)},{"Jungle",Vector3.new(-1646,125,-261)},
    {"Pirate Village",Vector3.new(-1189,125,4403)},{"Desert",Vector3.new(924,125,4089)},
    {"Frozen Village",Vector3.new(1175,125,-1818)},{"Snowy Village",Vector3.new(1326,125,-2882)},
    {"Marine Fortress",Vector3.new(-965,125,-380)},{"Skylands",Vector3.new(-4755,872,-718)},
    {"Upper Skylands",Vector3.new(-5004,1400,-718)},{"Fountain City",Vector3.new(3324,127,-2610)},
}
local SEA2_ISL = {
    {"Kingdom of Rose",Vector3.new(-804,266,604)},{"Dark Arena",Vector3.new(-9564,125,-1754)},
    {"Usoapp Island",Vector3.new(-2581,125,1500)},{"Green Zone",Vector3.new(-3626,125,1900)},
    {"Graveyard",Vector3.new(-5878,125,-670)},{"Snow Mountain",Vector3.new(-4550,1000,-1100)},
    {"Hot and Cold",Vector3.new(-3620,125,-2945)},{"Cursed Ship",Vector3.new(-5237,125,-1765)},
    {"Ice Castle",Vector3.new(-3966,125,-1120)},{"Colosseum",Vector3.new(926,125,29310)},
    {"Magma Village",Vector3.new(500,125,29650)},{"Underwater City",Vector3.new(61421,125,1819)},
    {"Wano",Vector3.new(3640,125,29500)},
}
local SEA3_ISL = {
    {"Port Town",Vector3.new(-2076,49,-4246)},{"Hydra Island",Vector3.new(-3281,125,-3900)},
    {"Great Tree",Vector3.new(-9084,400,-2573)},{"Mansion",Vector3.new(-6640,125,-2800)},
    {"Tiki Outpost",Vector3.new(-8279,125,-1024)},{"Buggy Island",Vector3.new(-8420,125,1630)},
    {"Floating Turtle",Vector3.new(-14553,243,-1014)},{"Haunted Castle",Vector3.new(-11540,400,-1044)},
    {"Sea of Treats",Vector3.new(-14055,125,3829)},{"Peanut Island",Vector3.new(-13350,125,4100)},
    {"Cake Land",Vector3.new(-12350,125,5000)},{"Candy Island",Vector3.new(-11700,125,5500)},
    {"Ice Berg",Vector3.new(-14300,125,-2100)},{"Labyrinth",Vector3.new(-15200,125,-1800)},
    {"Distant Island",Vector3.new(-13000,125,-4700)},
}
local BOSS_POS = {
    ["Gorilla King"]=Vector3.new(-1700,125,-310), ["Bobby"]=Vector3.new(-1189,125,4403),
    ["Yeti"]=Vector3.new(1300,125,-2880),         ["Darkbeard"]=Vector3.new(-9564,125,-1754),
    ["Rip_Indra"]=Vector3.new(-9084,400,-2573),   ["Thunder God"]=Vector3.new(-4755,872,-718),
    ["Tide Keeper"]=Vector3.new(61421,125,1819),  ["Stone"]=Vector3.new(-5237,125,-1765),
    ["Island Empress"]=Vector3.new(-3966,125,-1120),["Longma"]=Vector3.new(3640,125,29500),
    ["Cake Prince"]=Vector3.new(-12350,125,5000), ["Kilo Admiral"]=Vector3.new(924,125,4089),
    ["Vice Admiral"]=Vector3.new(-965,125,-380),  ["Magma Admiral"]=Vector3.new(500,125,29650),
    ["Order"]=Vector3.new(-14553,243,-1014),      ["Cursed Captain"]=Vector3.new(-14300,125,-2100),
    ["Bartolomeo"]=Vector3.new(926,125,29310),    ["Greybeard"]=Vector3.new(-965,125,-380),
    ["Don Swan"]=Vector3.new(-9564,125,-1754),    ["Dough King"]=Vector3.new(-14055,125,3829),
}
local RAID_POS = {
    Flame=Vector3.new(3066,28,2760),    Ice=Vector3.new(1227,28,-2204),
    Rumble=Vector3.new(-4755,872,-718), Quake=Vector3.new(-1180,28,-1174),
    Light=Vector3.new(3324,28,-2610),   Dark=Vector3.new(-9084,28,-2573),
    Buddha=Vector3.new(-804,28,604),    Venom=Vector3.new(-5237,28,-1765),
    Phoenix=Vector3.new(-3966,28,-1120),Dough=Vector3.new(-12350,28,5000),
    Shadow=Vector3.new(-11540,28,-1044),Portal=Vector3.new(-14553,28,-1014),
    Control=Vector3.new(-15200,28,-1800),Dragon=Vector3.new(-9564,28,-1754),
    Leopard=Vector3.new(-14300,28,-2100),["T-Rex"]=Vector3.new(-13000,28,-4700),
    Kitsune=Vector3.new(-9000,400,-2500),String=Vector3.new(-5878,28,-670),
    Magma=Vector3.new(500,28,29650),    Gravity=Vector3.new(-4755,28,-718),
}

-- ── THEME ─────────────────────────────────────────────────────────────
local T = {
    BG=Color3.fromRGB(8,8,8),       SB=Color3.fromRGB(10,10,10),
    Panel=Color3.fromRGB(14,14,14), Card=Color3.fromRGB(17,17,17),
    Card2=Color3.fromRGB(20,20,20), Border=Color3.fromRGB(32,32,32),
    Text=Color3.fromRGB(225,225,225),Sub=Color3.fromRGB(105,105,105),
    Dim=Color3.fromRGB(45,45,45),   Green=Color3.fromRGB(65,195,65),
    Red=Color3.fromRGB(210,55,55),  Gold=Color3.fromRGB(215,165,40),
    Blue=Color3.fromRGB(75,125,240),Purple=Color3.fromRGB(140,80,235),
    Teal=Color3.fromRGB(40,195,180),Pink=Color3.fromRGB(255,0,127),
}

local ACCENT_PRESETS = {
    Pink=Color3.fromRGB(255,0,127),   Blue=Color3.fromRGB(75,125,240),
    Purple=Color3.fromRGB(140,80,235),Teal=Color3.fromRGB(40,195,180),
    Gold=Color3.fromRGB(215,165,40),  Green=Color3.fromRGB(65,195,65),
    Red=Color3.fromRGB(210,55,55),
}
local function applyAccent(name)
    local col=ACCENT_PRESETS[name] or T.Pink; T.Pink=col; S.AccentPreset=name; qSave()
end

-- ── STATS / STATUS ────────────────────────────────────────────────────
local STATS   = {kills=0,deaths=0,questsDone=0,fruitsTP=0,questKills=0,startTime=os.time(),kpm=0,kpmBucket=0}
local STATUS  = "Idle"
local function setStatus(s,_) STATUS=s end
task.spawn(function() while task.wait(60) do STATS.kpm=STATS.kpmBucket; STATS.kpmBucket=0 end end)
LP.CharacterAdded:Connect(function()
    STATS.deaths = STATS.deaths+1
    if S.AutoRespawn then task.delay(0.8, function() pcall(function() LP.Character:WaitForChild("HumanoidRootPart",3) end) end) end
end)

local QUEST = {state="idle", killsNeeded=0, killsDone=0}
local FPS    = 60
do
    local f, last = 0, tick()
    RS.RenderStepped:Connect(wrap(function()
        f=f+1; local n=tick()
        if n-last>=0.5 then FPS=math.round(f/(n-last)); f,last=0,n end
    end))
end

-- ── HELPERS ───────────────────────────────────────────────────────────
local function getChar()  return LP.Character end
local function getHum()   local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()  local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive()  local h=getHum(); return h and h.Health>0 end
local function fmtTime(s) local h=math.floor(s/3600); local m=math.floor((s%3600)/60); local sc=s%60
    return h>0 and string.format("%dh %02dm",h,m) or string.format("%dm %02ds",m,sc) end

local function getLevel()
    local lv=1
    pcall(function()
        for _,fn in ipairs({
            function() return LP:WaitForChild("Data",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("PlayerData",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("leaderstats",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("leaderstats",0.3):WaitForChild("Lv",0.3).Value end,
        }) do
            local ok,v=pcall(fn); if ok and type(v)=="number" and v>0 then lv=v; break end
        end
    end)
    return lv
end

local function getMobForLevel(lv)
    local best=nil
    for _,m in ipairs(MOBS) do
        if lv>=m.mn and lv<=m.mx then if not best or m.mn>best.mn then best=m end end
    end
    return best or MOBS[1]
end

local function Com(suf, ...) pcall(function() RepStor.Remotes["Comm"..suf]:InvokeServer(...) end) end

-- ── TELEPORT ──────────────────────────────────────────────────────────
local function tp(pos)
    local root=getRoot(); if not root then return end
    local goal=Vector3.new(pos.X, pos.Y+3.2, pos.Z)
    if S.SafeMode then
        root.CFrame=CFrame.new(root.Position:Lerp(goal,0.6)); task.wait(0.05)
    end
    root.CFrame=CFrame.new(goal)
    if HAS_SIM then pcall(function() setsimulationradius(1000,1000) end) end
end

local function bypassTP(pt)
    local root=getRoot(); if not root then return end
    pcall(function() Com("F_","AbandonQuest") end)
    pcall(function() LP.Character.Head:Destroy() end)
    root.CFrame=pt*CFrame.new(0,50,0); task.wait(0.2)
    root.CFrame=pt; task.wait(0.1)
    root.Anchored=true; task.wait(0.2)
    root.CFrame=pt; task.wait(0.5)
    root.Anchored=false
    pcall(function() Com("F_","AbandonQuest") end)
end

-- ── SIMULATION RADIUS ─────────────────────────────────────────────────
task.spawn(function()
    while task.wait() do pcall(function()
        if HAS_SETSCR then setscriptable(LP,"SimulationRadius",true) end
        if HAS_HIDDEN  then sethiddenproperty(LP,"SimulationRadius",math.huge) end
    end) end
end)

-- ── ENEMY SPAWNS ──────────────────────────────────────────────────────
pcall(function()
    if workspace:FindFirstChild("EnemySpawns") then return end
    local folder=Instance.new("Folder",workspace); folder.Name="EnemySpawns"
    local function clean(n) return n:gsub("Lv%. ",""):gsub("[%[%]]",""):gsub("%d+",""):gsub("%s+","") end
    local function addPart(p,raw) local c=p:Clone(); c.Name=clean(raw); c.Parent=folder; c.Anchored=true end
    pcall(function()
        for _,v in pairs(workspace._WorldOrigin.EnemySpawns:GetChildren()) do
            if v:IsA("Part") then addPart(v,v.Name) end
        end
    end)
    pcall(function()
        for _,v in pairs((workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren()) or {}) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then addPart(v.HumanoidRootPart,v.Name) end
        end
    end)
end)

-- ── QUEST ENGINE ──────────────────────────────────────────────────────
local _QC_cache, _QC_lv = nil, -1
local function QuestCheck()
    local lv=getLevel()
    if lv==_QC_lv and _QC_cache then return _QC_cache end
    _QC_lv=lv; local MobName,QuestName,QuestLevel,Mon,LvReq,NpcPos,MobCF

    if lv>=1 and lv<=9 then
        if tostring(LP.Team)=="Marines" then
            MobName="Trainee [Lv. 5]"; Mon="Trainee"; QuestName="MarineQuest"; QuestLevel=1
            NpcPos=CFrame.new(-2709.68,24.52,2104.25)
        else
            MobName="Bandit [Lv. 5]"; Mon="Bandit"; QuestName="BanditQuest1"; QuestLevel=1
            NpcPos=CFrame.new(1060,16.92,1549.28)
        end
        _QC_cache={QuestLevel,NpcPos,MobName,QuestName,LvReq,Mon,{}}; return _QC_cache
    end

    pcall(function()
        local GM=require(RepStor:WaitForChild("GuideModule",3))
        local QM=require(RepStor:WaitForChild("Quests",3))
        for _,nd in pairs(GM.Data.NPCList) do
            for i1,v1 in pairs(nd.Levels) do
                if lv>=v1 then
                    if not LvReq then LvReq=0 end
                    if v1>LvReq then NpcPos=nd.CFrame; QuestLevel=i1; LvReq=v1 end
                    if #nd.Levels==3 and QuestLevel==3 then NpcPos=nd.CFrame; QuestLevel=2; LvReq=nd.Levels[2] end
                end
            end
        end
        for i,v in pairs(QM) do
            for _,v1 in pairs(v) do
                if v1.LevelReq==LvReq and i~="CitizenQuest" then
                    QuestName=i
                    for i2 in pairs(v1.Task) do
                        MobName=i2; Mon=tostring(i2):split(" [Lv. "..tostring(v1.LevelReq).."]")[1]
                    end
                end
            end
        end
        if QuestName=="ImpelQuest" then
            QuestName="PrisonerQuest"; QuestLevel=2
            MobName="Dangerous Prisoner [Lv. 190]"; Mon="Dangerous Prisoner"; LvReq=210
            NpcPos=CFrame.new(5310.61,0.35,474.95)
        elseif QuestName=="Area2Quest" and QuestLevel==2 then
            QuestName="Area2Quest"; QuestLevel=1; MobName="Swan Pirate [Lv. 775]"; Mon="Swan Pirate"; LvReq=775
        end
        if MobName then
            local clean=MobName:gsub("Lv. ",""):gsub("[%[%]]",""):gsub("%d+",""):gsub("%s+","")
            local cf={}
            for _,v in pairs(workspace.EnemySpawns:GetChildren()) do
                if v.Name==clean then table.insert(cf,v.CFrame) end
            end
            MobCF=cf
        end
    end)

    if not MobName then
        local m=getMobForLevel(lv); MobName=m.n; Mon=m.n
        NpcPos=CFrame.new(m.q); QuestLevel=1; QuestName="BanditQuest1"; LvReq=m.mn; MobCF={CFrame.new(m.p)}
    end
    _QC_cache={QuestLevel,NpcPos,MobName,QuestName,LvReq,Mon,MobCF or {}}
    return _QC_cache
end

-- ── BRING MOB ─────────────────────────────────────────────────────────
local PosMon = CFrame.new(0,0,0)
local _AutoFarmActive = false
task.spawn(function()
    while task.wait() do pcall(function()
        if not _AutoFarmActive or not S.BringMob then return end
        local enemies=workspace:FindFirstChild("Enemies"); if not enemies then return end
        for _,v in pairs(enemies:GetChildren()) do
            local hrp=v:FindFirstChild("HumanoidRootPart")
            local hum=v:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health>0 and not v.Name:find("Boss") then
                local d=(hrp.Position-PosMon.Position).Magnitude
                local inNet=HAS_ISNET and isnetworkowner(hrp) or d<=350
                if d<=400 and inNet then
                    hrp.CFrame=PosMon; hum.JumpPower=0; hum.WalkSpeed=0
                    hrp.Size=Vector3.new(4,4,4); hrp.Transparency=1; hrp.CanCollide=false
                    pcall(function() v.Head.CanCollide=false end)
                    if hum:FindFirstChild("Animator") then hum.Animator:Destroy() end
                    hum:ChangeState(11); hum:ChangeState(14)
                    if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                end
            end
        end
    end) end
end)

-- ── COMBAT ENGINE ─────────────────────────────────────────────────────
local _CF_ok, CombatFrameworkR = false, nil
pcall(function()
    if not HAS_GUV or not HAS_SUV then return end
    local CF=require(LP.PlayerScripts:WaitForChild("CombatFramework",5))
    CombatFrameworkR=getupvalues(CF)[2]; _CF_ok=CombatFrameworkR~=nil
end)

local function bladeAttack()
    pcall(function()
        if not CombatFrameworkR then return end
        local ac=CombatFrameworkR.activeController
        if ac and ac.blades and ac.blades[1] then
            local en=workspace:FindFirstChild("Enemies"); if not en then return end
            for _,v in ipairs(en:GetChildren()) do
                local hum=v:FindFirstChildOfClass("Humanoid")
                if hum and hum.RootPart and hum.Health>0 and
                    LP:DistanceFromCharacter(hum.RootPart.Position)<ac.hitBox+5 then
                    ac:InflictDamage(hum.RootPart, ac.hitBox)
                end
            end
        end
    end)
end

local function findMob(name)
    local root=getRoot(); if not root then return nil end
    local best,bestD=nil,math.huge
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            local hrp=obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health>0 then
                local match = name and obj.Name:lower():find(name:lower(),1,true)
                if match or not name then
                    local d=(hrp.Position-root.Position).Magnitude
                    if d<bestD then best,bestD=obj,d end
                end
            end
        end
    end
    return best
end

local function isDead(mob) if not mob or not mob.Parent then return true end
    local h=mob:FindFirstChildOfClass("Humanoid"); return not h or h.Health<=0 end

local function attackMob(mob)
    if isDead(mob) then return true end
    local hrp=mob:FindFirstChild("HumanoidRootPart")
    local hum=mob:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health<=0 then return true end
    local root=getRoot(); if not root then return false end
    root.CFrame=CFrame.new(hrp.Position)*CFrame.new(0,0,-4)
    PosMon=hrp.CFrame; task.wait(0.04)
    if _CF_ok then bladeAttack() end
    if HAS_FTI then
        pcall(firetouchinterest,hrp,root,0); task.wait(0.01)
        pcall(firetouchinterest,hrp,root,1)
        for _,p in pairs(mob:GetChildren()) do
            if p:IsA("BasePart") then pcall(firetouchinterest,p,root,0); pcall(firetouchinterest,p,root,1) end
        end
    end
    local c=getChar()
    if c then
        for _,tool in pairs(c:GetChildren()) do
            if tool:IsA("Tool") then
                local handle=tool:FindFirstChild("Handle")
                if handle and HAS_FTI then
                    for _,p in pairs(mob:GetDescendants()) do
                        if p:IsA("BasePart") then pcall(firetouchinterest,p,handle,0); pcall(firetouchinterest,p,handle,1) end
                    end
                end
                for _,v in pairs(tool:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        pcall(function() v:FireServer(hrp,hrp.Position) end)
                        pcall(function() v:FireServer(mob) end)
                    end
                end
            end
        end
    end
    for _,v in pairs(RepStor:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n=v.Name:lower()
            if n:find("damage") or n:find("hit") or n:find("attack") or n:find("melee") then
                pcall(function() v:FireServer(mob,9999) end); pcall(function() v:FireServer(hrp,9999) end)
            end
        end
    end
    if HAS_FCD then
        for _,cd in pairs(mob:GetDescendants()) do
            if cd:IsA("ClickDetector") then pcall(fireclickdetector,cd) end
        end
    end
    pcall(function() if hum and hum.Health>0 then hum.Health=0 end end)
    -- Fire combat skills (Z / X / C / V) if enabled
    if S.SkillZ or S.SkillX or S.SkillC or S.SkillV then
        local c2=getChar()
        if c2 then
            local skillMap={SkillZ="Z",SkillX="X",SkillC="C",SkillV="V"}
            for key,slot in pairs(skillMap) do
                if S[key] then
                    pcall(function()
                        for _,rem in pairs(RepStor:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                local n=rem.Name:lower()
                                if n:find("skill") or n:find(slot:lower()) then
                                    rem:FireServer(hrp)
                                end
                            end
                        end
                    end)
                    if HAS_FPP then
                        pcall(function()
                            for _,pp in pairs(c2:GetDescendants()) do
                                if pp:IsA("ProximityPrompt") and pp.ActionText:find(slot) then
                                    fireproximityprompt(pp)
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
    task.wait(0.06)
    local killed=isDead(mob)
    if killed then STATS.kills=STATS.kills+1; STATS.kpmBucket=STATS.kpmBucket+1
        if QUEST.state=="farming" then QUEST.killsDone=QUEST.killsDone+1; STATS.questKills=STATS.questKills+1 end
    end
    return killed
end

-- ── FRUIT / CHEST SCANNER ─────────────────────────────────────────────
local FRUIT_KW={"fruit","devil","logia","paramecia","zoan","ancient","mythical","df_"}
local function scanFruits()
    local found={}
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        for _,kw in ipairs(FRUIT_KW) do
            if n:find(kw,1,true) then
                local base=obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart",true)
                if base then found[#found+1]={name=obj.Name,pos=base.Position,obj=obj}; break end
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
            if base then found[#found+1]={name=obj.Name,pos=base.Position,obj=obj} end
        end
    end
    return found
end

-- ── ANTI-AFK ──────────────────────────────────────────────────────────
task.spawn(function()
    local acts={
        function() pcall(function() VU:CaptureController() end) end,
        function() pcall(function() VU:ClickButton1(Vector2.new(math.random(200,600),math.random(150,450))) end) end,
        function() pcall(function() VU:Button1Down(Vector2.new(),CFrame.new()); task.wait(0.07); VU:Button1Up(Vector2.new(),CFrame.new()) end) end,
    }
    local last=0
    while task.wait(2+math.random()*3) do
        if not S.AntiAFK then continue end
        local now=tick()
        if now-last>=40+math.random(0,50) then
            last=now
            for _=1,math.random(1,2) do acts[math.random(1,#acts)](); task.wait(math.random()*0.2) end
        end
    end
end)

-- ── NOTIFICATION ──────────────────────────────────────────────────────
local _nGui
local function notify(title,body,dur,accent)
    dur=dur or 3; accent=accent or T.Pink
    if not _nGui or not _nGui.Parent then
        _nGui=Instance.new("ScreenGui"); _nGui.Name="_EHN"; _nGui.ResetOnSpawn=false
        _nGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; _nGui.Parent=PG
    end
    for _,f in pairs(_nGui:GetChildren()) do
        if f:IsA("Frame") then
            TS:Create(f,TweenInfo.new(0.1),{Position=UDim2.new(1,-272,1,f.Position.Y.Offset-58)}):Play()
        end
    end
    local card=Instance.new("Frame"); card.Size=UDim2.new(0,256,0,50)
    card.Position=UDim2.new(1,12,1,-54); card.BackgroundColor3=T.Panel; card.BorderSizePixel=0; card.Parent=_nGui
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,6)
    local st=Instance.new("UIStroke",card); st.Color=T.Border; st.Thickness=1
    local bar=Instance.new("Frame",card); bar.Size=UDim2.new(0,2,1,0); bar.BackgroundColor3=accent; bar.BorderSizePixel=0
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2)
    local function lbl(txt,col,sz,py) local l=Instance.new("TextLabel",card)
        l.Size=UDim2.new(1,-14,0,sz); l.Position=UDim2.new(0,10,0,py); l.BackgroundTransparency=1
        l.Text=txt; l.Font=sz>9 and Enum.Font.GothamBold or Enum.Font.Gotham; l.TextSize=sz
        l.TextColor3=col; l.TextXAlignment=Enum.TextXAlignment.Left end
    lbl(title,T.Text,10,4); lbl(body,T.Sub,9,19)
    TS:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Back),{Position=UDim2.new(1,-272,1,-54)}):Play()
    task.delay(dur,function()
        TS:Create(card,TweenInfo.new(0.15),{Position=UDim2.new(1,12,1,-54)}):Play()
        task.wait(0.2); pcall(function() card:Destroy() end)
    end)
end

-- ── WATERMARK ─────────────────────────────────────────────────────────
local function buildWatermark()
    pcall(function() PG:FindFirstChild("_EHW"):Destroy() end)
    local sg=Instance.new("ScreenGui",PG); sg.Name="_EHW"; sg.ResetOnSpawn=false
    local f=Instance.new("Frame",sg); f.Size=UDim2.new(0,220,0,17); f.Position=UDim2.new(0,6,0,6)
    f.BackgroundColor3=T.Panel; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,4)
    local st=Instance.new("UIStroke",f); st.Color=T.Pink; st.Thickness=1
    local lbl=Instance.new("TextLabel",f); lbl.Size=UDim2.fromScale(1,1)
    lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8; lbl.TextColor3=T.Pink
    RS.Heartbeat:Connect(wrap(function()
        if not sg.Parent then return end
        sg.Enabled=S.ShowWatermark~=false
        if sg.Enabled then lbl.Text="  Elite Hub v1.0.0  |  FPS: "..FPS.."  |  "..STATUS end
    end))
end

-- ── AUTO STAT ─────────────────────────────────────────────────────────
local STAT_REMOTES = {Melee="Melee",Defense="Defense",HP="Health",Sword="Sword",Gun="Gun",Fruit="BloxFruit"}
local _lastStatLv = 0
local function doAutoStat()
    if not S.AutoStat then return end
    pcall(function()
        local lv=getLevel(); if lv==_lastStatLv then return end
        local pts=0
        pcall(function()
            pts=LP:WaitForChild("Data",0.3):WaitForChild("StatPoints",0.3).Value or 0
        end)
        if pts<1 then return end
        local rem=STAT_REMOTES[S.StatPriority] or "Melee"
        for _=1,pts do Com("F_","AddStat",rem) end
        notify("Auto Stat","+"..pts.." → "..S.StatPriority,3,T.Gold)
        _lastStatLv=lv
    end)
end

-- ── MASTERY FARM ──────────────────────────────────────────────────────
local MASTERY_TOOLS = {Sword="Sword",Sword2="Sword",Gun="Gun",Fruit="Fruit",Fighting="FightingStyle"}
local function doMasteryAttack(mob)
    if not mob or not mob.Parent then return end
    local hrp=mob:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local root=getRoot(); if not root then return end
    root.CFrame=CFrame.new(hrp.Position)*CFrame.new(0,0,-4)
    local c=getChar(); if not c then return end
    for _,tool in pairs(c:GetChildren()) do
        if tool:IsA("Tool") then
            local n=tool.Name:lower()
            local wn=(S.MasteryWeapon or "Sword"):lower()
            if n:find(wn) or wn=="fighting" then
                for _,v in pairs(tool:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        pcall(function() v:FireServer(hrp,hrp.Position) end)
                    end
                end
            end
        end
    end
    if HAS_FTI then pcall(firetouchinterest,hrp,root,0); pcall(firetouchinterest,hrp,root,1) end
end

-- ── FRUIT SPAWN NOTIFIER ──────────────────────────────────────────────
local _knownFruits={}
task.spawn(function()
    while task.wait(4) do pcall(function()
        if not S.FruitNotify then return end
        local root=getRoot(); if not root then return end
        local fruits=scanFruits()
        for _,f in ipairs(fruits) do
            local key=tostring(f.obj)
            if not _knownFruits[key] then
                _knownFruits[key]=true
                local dist=math.round((f.pos-root.Position).Magnitude)
                if dist<=(S.FruitNotifyRange or 500) then
                    notify("Fruit Spawned!",f.name.."  ("..dist.."m away)",5,T.Green)
                end
            end
        end
        -- clean up destroyed fruits
        for key in pairs(_knownFruits) do
            if not _knownFruits[key] then _knownFruits[key]=nil end
        end
    end) end
end)

-- ── MAIN LOOP ─────────────────────────────────────────────────────────
task.spawn(function()
    while true do
        task.wait(math.max(0.05, S.FarmDelay or 0.1))  -- re-read delay each tick
        if not isAlive() then task.wait(1); continue end
        local root=getRoot(); if not root then continue end

        -- Kill Aura (with optional team check)
        if S.KillAura then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj~=getChar() then
                    local plr=Players:GetPlayerFromCharacter(obj)
                    if S.KillAuraTeamCheck and plr and plr.Team==LP.Team and LP.Team~=nil then continue end
                    if plr then continue end  -- never attack real players unless team check disabled and same team
                    local hum=obj:FindFirstChildOfClass("Humanoid")
                    local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 then
                        if (hrp.Position-root.Position).Magnitude<=(S.KillAuraRange or 25) then
                            attackMob(obj)
                        end
                    end
                end
            end
        end

        -- Auto Farm
        if _AutoFarmActive then
            if S.AutoLevelFarm then
                local m=getMobForLevel(getLevel()); S.TargetMob=m.n
            end
            local mob=findMob(S.TargetMob)
            if mob then
                attackMob(mob)
            else
                local info=MOB_MAP[S.TargetMob]
                if info then tp(info.p) end
                task.wait(0.8)
            end
        end

        -- Auto Quest  (don't attack while travelling to NPC)
        if S.AutoQuest then
            local qd=QuestCheck()
            if qd then
                if QUEST.state=="idle" then
                    local mob_info=MOB_MAP[qd[6] or S.TargetMob]
                    QUEST.killsDone=0
                    QUEST.killsNeeded = mob_info and mob_info.k or 16
                    QUEST.state="going"
                    local npcPos=qd[2]
                    if npcPos then tp(npcPos.Position) end
                    task.wait(0.6)
                    pcall(function() Com("F_","StartQuest",qd[4],qd[1]) end)
                    task.wait(0.2)
                    QUEST.state="farming"
                elseif QUEST.state=="farming" then
                    if QUEST.killsDone>=(QUEST.killsNeeded>0 and QUEST.killsNeeded or 10) then
                        local npcPos=qd[2]
                        if npcPos then tp(npcPos.Position) end
                        task.wait(0.4)
                        pcall(function() Com("F_","CompleteQuest",qd[4],qd[1]) end)
                        STATS.questsDone=STATS.questsDone+1
                        QUEST.killsDone=0; QUEST.state="idle"; _QC_cache=nil
                        notify("Quest","Completed! #"..STATS.questsDone,2.5,T.Teal)
                    end
                end
            end
        end

        -- Auto Boss
        if S.AutoBoss then
            local pos=BOSS_POS[S.SelectedBoss]
            if pos then
                local mob=findMob(S.SelectedBoss)
                if mob then attackMob(mob)
                else tp(pos); task.wait(1) end
            end
        end

        -- Auto Raid
        if S.AutoRaid then
            local pos=RAID_POS[S.SelectedRaid]
            if pos then
                local mob=findMob(nil)
                if mob then attackMob(mob)
                else tp(pos); task.wait(1) end
            end
        end

        -- Mastery Farm
        if S.MasteryFarm then
            local mob=findMob(S.TargetMob)
            if mob then doMasteryAttack(mob)
            else
                local info=MOB_MAP[S.TargetMob]
                if info then tp(info.p) end; task.wait(0.8)
            end
        end

        -- Auto Chest
        if S.AutoChest then
            local chests=scanChests()
            for _,ch in ipairs(chests) do
                tp(ch.pos); task.wait(0.2)
                if HAS_FPP then
                    for _,pp in pairs(ch.obj:GetDescendants()) do
                        if pp:IsA("ProximityPrompt") then pcall(fireproximityprompt,pp) end
                    end
                end
                if HAS_FCD then
                    for _,cd in pairs(ch.obj:GetDescendants()) do
                        if cd:IsA("ClickDetector") then pcall(fireclickdetector,cd) end
                    end
                end
                task.wait(0.15)
            end
        end

        -- TP Fruit
        if S.TPFruit then
            local fruits=scanFruits()
            if #fruits>0 then
                table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
                tp(fruits[1].pos); STATS.fruitsTP=STATS.fruitsTP+1
                if S.AutoEatFruit then
                    task.wait(0.5)
                    for _,v in pairs(workspace:GetDescendants()) do
                        if v:IsA("RemoteEvent") and v.Name:lower():find("eat") then pcall(function() v:FireServer() end) end
                    end
                    if HAS_FPP then
                        for _,pp in pairs(workspace:GetDescendants()) do
                            if pp:IsA("ProximityPrompt") and pp.Parent.Name:lower():find("fruit") then
                                pcall(fireproximityprompt,pp)
                            end
                        end
                    end
                end
            end
        end

        -- Auto Stat distribution
        doAutoStat()

        -- God Mode
        if S.GodMode then
            local hum=getHum()
            if hum then
                pcall(function() hum.Health=hum.MaxHealth end)
                if HAS_HIDDEN then pcall(function() sethiddenproperty(hum,"Health",math.huge) end) end
            end
        end

        -- Auto Haki
        if S.AutoHaki then
            pcall(function() Com("F_","Haki","Buso") end)
        end

        -- Walk/Jump speed enforcement
        local hum=getHum()
        if hum then
            if S.WalkSpeed and S.WalkSpeed~=16 then hum.WalkSpeed=S.WalkSpeed end
            if S.JumpPower and S.JumpPower~=50  then hum.JumpPower=S.JumpPower end
        end
    end
end)

-- NoClip
RS.Stepped:Connect(wrap(function()
    if S.NoClip then
        local c=getChar()
        if c then for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end end
    end
end))

-- Inf Jump
UIS.JumpRequest:Connect(function()
    if S.InfJump then
        local hum=getHum(); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Fly (runs on Heartbeat instead of busy-wait to avoid CPU spike)
RS.Heartbeat:Connect(wrap(function()
    if S.FlyEnabled then
        local root=getRoot(); local hum=getHum()
        if root and hum then
            hum.PlatformStand=true
            local vel=Vector3.new()
            local spd=S.FlySpeed or 60
            if UIS:IsKeyDown(Enum.KeyCode.W) then vel=vel+Camera.CFrame.LookVector*spd end
            if UIS:IsKeyDown(Enum.KeyCode.S) then vel=vel-Camera.CFrame.LookVector*spd end
            if UIS:IsKeyDown(Enum.KeyCode.A) then vel=vel-Camera.CFrame.RightVector*spd end
            if UIS:IsKeyDown(Enum.KeyCode.D) then vel=vel+Camera.CFrame.RightVector*spd end
            if UIS:IsKeyDown(Enum.KeyCode.Space)       then vel=vel+Vector3.new(0,spd,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vel=vel-Vector3.new(0,spd,0) end
            root.Velocity=vel
        end
    else
        local hum=getHum(); if hum and hum.PlatformStand then hum.PlatformStand=false end
    end
end))

-- Fullbright / NoFog / FOV enforcement
RS.Heartbeat:Connect(wrap(function()
    if S.Fullbright then Lighting.Brightness=3.8; Lighting.FogEnd=1e6
    elseif S.NoFog   then Lighting.FogEnd=1e6 end
    if S.FOV and S.FOV~=70 then Camera.FieldOfView=S.FOV end
end))

-- ── ESP ENGINE ────────────────────────────────────────────────────────
local espObjs={}
local function clearESP() for _,o in pairs(espObjs) do pcall(function() o:Remove() end) end espObjs={} end
local function newDraw(cls,props)
    if not HAS_DRAW then return nil end
    local ok,o=pcall(Drawing.new,cls); if not ok then return nil end
    for k,v in pairs(props) do pcall(function() o[k]=v end) end
    table.insert(espObjs,o); return o
end
local function w2s(p)
    local ok,v=pcall(function() return Camera:WorldToViewportPoint(p) end)
    if ok and v.Z>0 then return Vector2.new(v.X,v.Y),true end
    return Vector2.new(),false
end
local function espLabel(obj,col,name)
    local hrp=obj:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum=obj:FindFirstChildOfClass("Humanoid")
    local lbl=newDraw("Text",{Size=13,Font=2,Color=col,Outline=true,Visible=true})
    if not lbl then return end
    local conn; conn=RS.Heartbeat:Connect(wrap(function()
        if not obj or not obj.Parent or (hum and hum.Health<=0) then lbl:Remove(); conn:Disconnect(); return end
        local sp,onScreen=w2s(hrp.Position+Vector3.new(0,2.5,0))
        lbl.Visible=onScreen
        if onScreen then
            lbl.Position=sp
            local txt=name
            if S.ESPDistance then
                local d=math.round((hrp.Position-(getRoot() and getRoot().Position or hrp.Position)).Magnitude)
                txt=txt.."  ["..d.."m]"
            end
            if S.ESPHealth and hum then
                local hp=math.round(hum.Health)
                local mhp=math.round(hum.MaxHealth)
                txt=txt.."  "..hp.."/"..mhp
            end
            lbl.Text=txt
        end
    end))
end

task.spawn(function()
    while task.wait(5) do
        clearESP()
        if S.PlayerESP then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character then espLabel(p.Character,T.Blue,p.Name) end
            end
        end
        if S.MobESP then
            local en=workspace:FindFirstChild("Enemies")
            if en then for _,v in pairs(en:GetChildren()) do espLabel(v,T.Red,v.Name) end end
        end
        if S.FruitESP then
            for _,f in ipairs(scanFruits()) do
                local lbl=newDraw("Text",{Size=13,Font=2,Color=T.Green,Outline=true,Visible=true,Text=f.name})
                if lbl then
                    RS.Heartbeat:Connect(wrap(function()
                        if not f.obj or not f.obj.Parent then lbl:Remove(); return end
                        local sp,on=w2s(f.pos); lbl.Visible=on; if on then lbl.Position=sp end
                    end))
                end
            end
        end
    end
end)

-- ── GUI ───────────────────────────────────────────────────────────────
local sg=Instance.new("ScreenGui",PG); sg.Name="_EHG"; sg.ResetOnSpawn=false
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.IgnoreGuiInset=true

-- Root frame
local root=Instance.new("Frame",sg); root.Size=UDim2.new(0,620,0,430)
root.Position=UDim2.new(0.5,-310,0.5,-215); root.BackgroundColor3=T.BG; root.BorderSizePixel=0
Instance.new("UICorner",root).CornerRadius=UDim.new(0,10)
local rst=Instance.new("UIStroke",root); rst.Color=T.Border; rst.Thickness=1

-- Top bar
local topbar=Instance.new("Frame",root); topbar.Size=UDim2.new(1,0,0,36)
topbar.BackgroundColor3=T.SB; topbar.BorderSizePixel=0
local topC=Instance.new("UICorner",topbar); topC.CornerRadius=UDim.new(0,10)
-- Clip bottom corners of topbar
local topClip=Instance.new("Frame",topbar); topClip.Size=UDim2.new(1,0,0.5,0)
topClip.Position=UDim2.new(0,0,0.5,0); topClip.BackgroundColor3=T.SB; topClip.BorderSizePixel=0
local topTitle=Instance.new("TextLabel",topbar); topTitle.Size=UDim2.new(1,-70,1,0)
topTitle.Position=UDim2.new(0,14,0,0); topTitle.BackgroundTransparency=1
topTitle.Text="Elite Hub  •  v1.0.0"; topTitle.Font=Enum.Font.GothamBold
topTitle.TextSize=12; topTitle.TextColor3=T.Pink; topTitle.TextXAlignment=Enum.TextXAlignment.Left
local closeBtn=Instance.new("TextButton",topbar); closeBtn.Size=UDim2.new(0,28,0,22)
closeBtn.Position=UDim2.new(1,-32,0.5,-11); closeBtn.BackgroundColor3=T.Red
closeBtn.Text="✕"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=11; closeBtn.TextColor3=Color3.new(1,1,1)
closeBtn.BorderSizePixel=0; Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,5)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled=false end)

-- Toggle visibility with configurable hotkey (default RightShift) or Insert
local TOGGLE_KEYS = {
    RightShift=Enum.KeyCode.RightShift, Insert=Enum.KeyCode.Insert,
    RightAlt=Enum.KeyCode.RightAlt,     Home=Enum.KeyCode.Home,
    End=Enum.KeyCode.End,               Delete=Enum.KeyCode.Delete,
    F5=Enum.KeyCode.F5,                 F6=Enum.KeyCode.F6,
    F7=Enum.KeyCode.F7,                 F8=Enum.KeyCode.F8,
}
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    local mainKey = TOGGLE_KEYS[S.ToggleKey or "RightShift"] or Enum.KeyCode.RightShift
    if i.KeyCode==mainKey or i.KeyCode==Enum.KeyCode.Insert then
        sg.Enabled=not sg.Enabled
    end
end)

-- Drag
local _drag,_doffset=false,Vector2.new()
topbar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
    _drag=true; _doffset=Vector2.new(root.AbsolutePosition.X-Mouse.X, root.AbsolutePosition.Y-Mouse.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then _drag=false end end)
UIS.InputChanged:Connect(function(i)
    if _drag and i.UserInputType==Enum.UserInputType.MouseMovement then
        root.Position=UDim2.new(0,Mouse.X+_doffset.X,0,Mouse.Y+_doffset.Y)
    end
end)

-- Sidebar
local sb=Instance.new("Frame",root); sb.Size=UDim2.new(0,120,1,-36)
sb.Position=UDim2.new(0,0,0,36); sb.BackgroundColor3=T.SB; sb.BorderSizePixel=0
local sbList=Instance.new("UIListLayout",sb); sbList.SortOrder=Enum.SortOrder.LayoutOrder; sbList.Padding=UDim.new(0,1)
local sbPad=Instance.new("UIPadding",sb); sbPad.PaddingTop=UDim.new(0,6); sbPad.PaddingLeft=UDim.new(0,6); sbPad.PaddingRight=UDim.new(0,6)

-- Content area
local content=Instance.new("Frame",root); content.Size=UDim2.new(1,-122,1,-38)
content.Position=UDim2.new(0,122,0,38); content.BackgroundTransparency=1; content.BorderSizePixel=0
content.ClipsDescendants=true

-- Page builder helpers
local pages, activePage = {}, nil
local tabBtns = {}

local function makePage(id)
    local sf=Instance.new("ScrollingFrame",content); sf.Name=id; sf.Size=UDim2.fromScale(1,1)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0; sf.ScrollBarThickness=3
    sf.ScrollBarImageColor3=T.Border; sf.CanvasSize=UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize=Enum.AutomaticSize.Y; sf.Visible=false
    local pad=Instance.new("UIPadding",sf); pad.PaddingLeft=UDim.new(0,8); pad.PaddingRight=UDim.new(0,8); pad.PaddingTop=UDim.new(0,8)
    local list=Instance.new("UIListLayout",sf); list.SortOrder=Enum.SortOrder.LayoutOrder; list.Padding=UDim.new(0,6)
    pages[id]=sf; return sf
end

local function showPage(id)
    for _,p in pairs(pages) do p.Visible=false end
    if pages[id] then pages[id].Visible=true; activePage=id end
    for tid,btn in pairs(tabBtns) do
        btn.BackgroundColor3=tid==id and T.Pink or T.Card2
        btn.TextColor3=tid==id and Color3.new(1,1,1) or T.Sub
    end
end

local function makeTab(id,label)
    local btn=Instance.new("TextButton",sb); btn.Size=UDim2.new(1,0,0,28)
    btn.BackgroundColor3=T.Card2; btn.Text=label; btn.Font=Enum.Font.GothamBold
    btn.TextSize=9; btn.TextColor3=T.Sub; btn.BorderSizePixel=0
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
    btn.MouseButton1Click:Connect(function() showPage(id) end)
    tabBtns[id]=btn; return btn
end

local function sbSec(lbl)
    local l=Instance.new("TextLabel",sb); l.Size=UDim2.new(1,0,0,18)
    l.BackgroundTransparency=1; l.Text=lbl; l.Font=Enum.Font.GothamBold
    l.TextSize=7.5; l.TextColor3=T.Dim; l.TextXAlignment=Enum.TextXAlignment.Left
end

-- Card
local function card(parent,title,order)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,0)
    f.AutomaticSize=Enum.AutomaticSize.Y; f.BackgroundColor3=T.Card
    f.BorderSizePixel=0; f.LayoutOrder=order
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
    local st=Instance.new("UIStroke",f); st.Color=T.Border; st.Thickness=1
    local pad=Instance.new("UIPadding",f); pad.PaddingLeft=UDim.new(0,9); pad.PaddingRight=UDim.new(0,9)
    pad.PaddingTop=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)
    local list=Instance.new("UIListLayout",f); list.SortOrder=Enum.SortOrder.LayoutOrder; list.Padding=UDim.new(0,4)
    if title~="" then
        local tl=Instance.new("TextLabel",f); tl.Size=UDim2.new(1,0,0,14)
        tl.BackgroundTransparency=1; tl.Text=title; tl.Font=Enum.Font.GothamBold
        tl.TextSize=9.5; tl.TextColor3=T.Text; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.LayoutOrder=0
    end
    return f
end

local function twoCol(parent,order)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,0)
    row.AutomaticSize=Enum.AutomaticSize.Y; row.BackgroundTransparency=1; row.LayoutOrder=order
    local list=Instance.new("UIListLayout",row); list.FillDirection=Enum.FillDirection.Horizontal
    list.SortOrder=Enum.SortOrder.LayoutOrder; list.Padding=UDim.new(0,6)
    local L=Instance.new("Frame",row); L.Size=UDim2.new(0.5,-3,0,0); L.AutomaticSize=Enum.AutomaticSize.Y
    L.BackgroundTransparency=1; local LL=Instance.new("UIListLayout",L); LL.SortOrder=Enum.SortOrder.LayoutOrder; LL.Padding=UDim.new(0,6)
    local R=Instance.new("Frame",row); R.Size=UDim2.new(0.5,-3,0,0); R.AutomaticSize=Enum.AutomaticSize.Y
    R.BackgroundTransparency=1; local RL=Instance.new("UIListLayout",R); RL.SortOrder=Enum.SortOrder.LayoutOrder; RL.Padding=UDim.new(0,6)
    return L, R
end

local function sep(parent,order)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=T.Border
    f.BorderSizePixel=0; f.LayoutOrder=order
end

local function toggle(parent,label,key,order,cb)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,26)
    row.BackgroundTransparency=1; row.LayoutOrder=order
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(1,-42,1,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham
    lbl.TextSize=9.5; lbl.TextColor3=T.Sub; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local on=key and S[key] or false
    local track=Instance.new("Frame",row); track.Size=UDim2.new(0,34,0,17)
    track.Position=UDim2.new(1,-36,0.5,-8.5); track.BackgroundColor3=on and T.Green or T.Dim; track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(0,9)
    local thumb=Instance.new("Frame",track); thumb.Size=UDim2.new(0,13,0,13)
    thumb.Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)
    thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(0,7)
    local function setState(v)
        on=v; if key then S[key]=v; qSave() end
        TS:Create(track,TweenInfo.new(0.12),{BackgroundColor3=on and T.Green or T.Dim}):Play()
        TS:Create(thumb,TweenInfo.new(0.12),{Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)}):Play()
        if cb then task.spawn(cb,on) end
    end
    local hit=Instance.new("TextButton",row); hit.Size=UDim2.fromScale(1,1)
    hit.BackgroundTransparency=1; hit.Text=""
    hit.MouseButton1Click:Connect(function() setState(not on) end)
    return setState
end

local function slider(parent,label,key,mn,mx,order,cb)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,36)
    f.BackgroundTransparency=1; f.LayoutOrder=order
    local lbl=Instance.new("TextLabel",f); lbl.Size=UDim2.new(0.6,0,0,14)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham
    lbl.TextSize=9.5; lbl.TextColor3=T.Sub; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local curV=key and S[key] or mn
    local valLbl=Instance.new("TextLabel",f); valLbl.Size=UDim2.new(0.4,0,0,14)
    valLbl.Position=UDim2.new(0.6,0,0,0); valLbl.BackgroundTransparency=1
    valLbl.Text=tostring(curV); valLbl.Font=Enum.Font.GothamBold
    valLbl.TextSize=9.5; valLbl.TextColor3=T.Text; valLbl.TextXAlignment=Enum.TextXAlignment.Right
    local trk=Instance.new("Frame",f); trk.Size=UDim2.new(1,0,0,5)
    trk.Position=UDim2.new(0,0,0,19); trk.BackgroundColor3=T.Dim; trk.BorderSizePixel=0
    Instance.new("UICorner",trk).CornerRadius=UDim.new(0,3)
    local pct=math.clamp((curV-mn)/(mx-mn),0,1)
    local fill=Instance.new("Frame",trk); fill.Size=UDim2.new(pct,0,1,0)
    fill.BackgroundColor3=T.Pink; fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(0,3)
    local thm=Instance.new("Frame",trk); thm.Size=UDim2.new(0,12,0,12)
    thm.Position=UDim2.new(pct,-6,0.5,-6); thm.BackgroundColor3=Color3.new(1,1,1); thm.BorderSizePixel=0
    Instance.new("UICorner",thm).CornerRadius=UDim.new(0,6)
    local drag=false
    trk.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel=math.clamp((Mouse.X-trk.AbsolutePosition.X)/trk.AbsoluteSize.X,0,1)
            local val=math.round(mn+rel*(mx-mn))
            if key then S[key]=val; qSave() end; valLbl.Text=tostring(val)
            fill.Size=UDim2.new(rel,0,1,0); thm.Position=UDim2.new(rel,-6,0.5,-6)
            if cb then cb(val) end
        end
    end)
end

local function dropdown(parent,label,opts,key,order,cb)
    local open=false
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,24)
    f.BackgroundTransparency=1; f.LayoutOrder=order; f.ClipsDescendants=true
    local lbl=Instance.new("TextLabel",f); lbl.Size=UDim2.new(0.45,0,0,24)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=Enum.Font.Gotham
    lbl.TextSize=9.5; lbl.TextColor3=T.Sub; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local selL=Instance.new("TextLabel",f); selL.Size=UDim2.new(0.55,-14,0,24)
    selL.Position=UDim2.new(0.45,0,0,0); selL.BackgroundTransparency=1
    selL.Text=(key and S[key]) or (opts[1] or ""); selL.Font=Enum.Font.GothamBold
    selL.TextSize=9.5; selL.TextColor3=T.Text; selL.TextXAlignment=Enum.TextXAlignment.Right
    local arr=Instance.new("TextLabel",f); arr.Size=UDim2.new(0,14,0,24); arr.Position=UDim2.new(1,-14,0,0)
    arr.BackgroundTransparency=1; arr.Text="⌄"; arr.Font=Enum.Font.Gotham; arr.TextSize=10; arr.TextColor3=T.Dim
    local listF=Instance.new("Frame",f); listF.Size=UDim2.new(1,0,0,#opts*22)
    listF.Position=UDim2.new(0,0,0,24); listF.BackgroundColor3=Color3.fromRGB(11,11,11); listF.BorderSizePixel=0
    Instance.new("UICorner",listF).CornerRadius=UDim.new(0,5)
    local lfs=Instance.new("UIStroke",listF); lfs.Color=T.Border; lfs.Thickness=1
    Instance.new("UIListLayout",listF).SortOrder=Enum.SortOrder.LayoutOrder
    local optBtns={}
    local function rebuildOpts(newOpts,newKey)
        for _,b in pairs(optBtns) do pcall(function() b:Destroy() end) end; optBtns={}
        key=newKey or key; listF.Size=UDim2.new(1,0,0,#newOpts*22)
        selL.Text=(key and S[key]) or (newOpts[1] or "")
        for i,opt in ipairs(newOpts) do
            local ob=Instance.new("TextButton",listF); ob.Size=UDim2.new(1,0,0,22)
            ob.BackgroundColor3=Color3.fromRGB(11,11,11); ob.Text=opt
            ob.Font=Enum.Font.Gotham; ob.TextSize=9.5; ob.TextColor3=T.Sub; ob.BorderSizePixel=0; ob.LayoutOrder=i
            ob.MouseButton1Click:Connect(function()
                if key then S[key]=opt; qSave() end; selL.Text=opt; open=false
                TS:Create(f,TweenInfo.new(0.12),{Size=UDim2.new(1,0,0,24)}):Play()
                if cb then task.spawn(cb,opt) end
            end)
            ob.MouseEnter:Connect(function() ob.TextColor3=T.Text; ob.BackgroundColor3=Color3.fromRGB(20,20,20) end)
            ob.MouseLeave:Connect(function() ob.TextColor3=T.Sub; ob.BackgroundColor3=Color3.fromRGB(11,11,11) end)
            optBtns[#optBtns+1]=ob
        end
    end
    rebuildOpts(opts,key)
    local hit=Instance.new("TextButton",f); hit.Size=UDim2.new(1,0,0,24)
    hit.BackgroundTransparency=1; hit.Text=""
    hit.MouseButton1Click:Connect(function()
        open=not open
        TS:Create(f,TweenInfo.new(0.14,Enum.EasingStyle.Back),{Size=UDim2.new(1,0,0,open and 24+#optBtns*22 or 24)}):Play()
    end)
    return f, selL, rebuildOpts
end

local function btn(parent,label,col,order,cb)
    col=col or T.Card2
    local b=Instance.new("TextButton",parent); b.Size=UDim2.new(1,0,0,23)
    b.BackgroundColor3=col; b.Text=label; b.Font=Enum.Font.GothamBold; b.TextSize=9.5
    b.TextColor3=T.Text; b.BorderSizePixel=0; b.LayoutOrder=order
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    local bs=Instance.new("UIStroke",b); bs.Color=T.Border; bs.Thickness=1
    b.MouseEnter:Connect(function() TS:Create(b,TweenInfo.new(0.07),{BackgroundTransparency=0.25}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TweenInfo.new(0.07),{BackgroundTransparency=0}):Play() end)
    b.MouseButton1Click:Connect(function()
        TS:Create(b,TweenInfo.new(0.04),{Size=UDim2.new(0.97,0,0,20)}):Play()
        task.wait(0.06); TS:Create(b,TweenInfo.new(0.05),{Size=UDim2.new(1,0,0,23)}):Play()
        if cb then task.spawn(cb) end
    end)
    return b
end

local function infoRow(parent,lbl,val,order)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,18); row.BackgroundTransparency=1; row.LayoutOrder=order
    local a=Instance.new("TextLabel",row); a.Size=UDim2.new(0.5,0,1,0); a.BackgroundTransparency=1
    a.Text=lbl; a.Font=Enum.Font.Gotham; a.TextSize=9; a.TextColor3=T.Sub; a.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextLabel",row); b.Size=UDim2.new(0.5,0,1,0); b.Position=UDim2.new(0.5,0,0,0)
    b.BackgroundTransparency=1; b.Text=tostring(val); b.Font=Enum.Font.GothamBold
    b.TextSize=9; b.TextColor3=T.Text; b.TextXAlignment=Enum.TextXAlignment.Right
    return b
end

-- ── BUILD SIDEBAR TABS ────────────────────────────────────────────────
sbSec("Farm"); makeTab("Farm","Auto Farm"); makeTab("Combat","Combat"); makeTab("TP","Teleport")
makeTab("Boss","Boss"); makeTab("Raid","Raid")
sbSec("Visuals"); makeTab("ESP","ESP"); makeTab("Visual","Visual")
sbSec("Info"); makeTab("Misc","Stats & Info"); makeTab("Settings","Settings")

-- ── PAGE: FARM ────────────────────────────────────────────────────────
do
    local pFarm=makePage("Farm")
    local fL,fR=twoCol(pFarm,1)

    local cfgC=card(fL,"Auto Farm Config",1)
    -- Live level display
    local lvRow=Instance.new("Frame",cfgC); lvRow.Size=UDim2.new(1,0,0,20); lvRow.BackgroundTransparency=1; lvRow.LayoutOrder=1
    local lvA=Instance.new("TextLabel",lvRow); lvA.Size=UDim2.new(0.4,0,1,0); lvA.BackgroundTransparency=1
    lvA.Text="Level"; lvA.Font=Enum.Font.Gotham; lvA.TextSize=9; lvA.TextColor3=T.Sub; lvA.TextXAlignment=Enum.TextXAlignment.Left
    local lvB=Instance.new("TextLabel",lvRow); lvB.Size=UDim2.new(0.6,0,1,0); lvB.Position=UDim2.new(0.4,0,0,0)
    lvB.BackgroundTransparency=1; lvB.Text="..."; lvB.Font=Enum.Font.GothamBold
    lvB.TextSize=9; lvB.TextColor3=T.Gold; lvB.TextXAlignment=Enum.TextXAlignment.Right
    -- Quest tracker
    local qRow=Instance.new("Frame",cfgC); qRow.Size=UDim2.new(1,0,0,18); qRow.BackgroundTransparency=1; qRow.LayoutOrder=2
    local qA=Instance.new("TextLabel",qRow); qA.Size=UDim2.new(0.5,0,1,0); qA.BackgroundTransparency=1
    qA.Text="Quest Kills"; qA.Font=Enum.Font.Gotham; qA.TextSize=9; qA.TextColor3=T.Sub; qA.TextXAlignment=Enum.TextXAlignment.Left
    local qB=Instance.new("TextLabel",qRow); qB.Size=UDim2.new(0.5,0,1,0); qB.Position=UDim2.new(0.5,0,0,0)
    qB.BackgroundTransparency=1; qB.Text="0 / 0"; qB.Font=Enum.Font.GothamBold
    qB.TextSize=9; qB.TextColor3=T.Teal; qB.TextXAlignment=Enum.TextXAlignment.Right
    task.spawn(function()
        while task.wait(2) do
            if not lvB.Parent then break end
            local lv=getLevel(); local m=getMobForLevel(lv)
            lvB.Text=tostring(lv).."  →  "..m.n
            qB.Text=QUEST.killsDone.." / "..(QUEST.killsNeeded>0 and tostring(QUEST.killsNeeded) or "?")
        end
    end)
    sep(cfgC,3)
    toggle(cfgC,"Auto Level Farm","AutoLevelFarm",4,function(on)
        S.AutoFarm=on; _AutoFarmActive=on
        if on then notify("Farm","Auto Level: ON → "..getMobForLevel(getLevel()).n,3.5,T.Gold) end
    end)
    sep(cfgC,5)
    local _,_,setMobOpts=dropdown(cfgC,"Mob",SEA_LIST[1],"TargetMob",6)
    dropdown(cfgC,"Sea",{"Sea 1","Sea 2","Sea 3"},nil,7,function(sea)
        local idx=tonumber(sea:match("%d")) or 1
        setMobOpts(SEA_LIST[idx],"TargetMob"); S.TargetMob=SEA_LIST[idx][1] or "Bandit"; qSave()
        notify("Farm","Sea "..idx.." mobs loaded",2)
    end)
    dropdown(cfgC,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",8)
    sep(cfgC,9); slider(cfgC,"Delay (s)","FarmDelay",0.05,2,10)

    local togC=card(fR,"Toggles",1)
    toggle(togC,"Auto Farm","AutoFarm",1,function(on)
        _AutoFarmActive=on
        if on then notify("Farm","Started → "..(S.TargetMob or "?"),3,T.Blue)
        else notify("Farm","Stopped",2) end
    end)
    toggle(togC,"Auto Quest","AutoQuest",2,function(on)
        if on then QUEST.state="idle"; QUEST.killsDone=0 end
        notify("Quest",on and"ON"or"OFF",2,T.Teal)
    end)
    toggle(togC,"Bring Mob","BringMob",3)
    toggle(togC,"Fast Attack","FastAttack",4)
    toggle(togC,"Auto Haki","AutoHaki",5)
    toggle(togC,"Auto Chest","AutoChest",6)
    toggle(togC,"Auto Eat Fruit","AutoEatFruit",7)
    toggle(togC,"Auto Respawn","AutoRespawn",8)
    toggle(togC,"Safe Mode","SafeMode",9,function(on) S.FarmDelay=on and 0.28 or 0.1; qSave() end)
    toggle(togC,"Bypass TP","BypassTP",10)

    btn(pFarm,"■  STOP ALL",Color3.fromRGB(40,12,12),2,function()
        S.AutoFarm=false; S.AutoLevelFarm=false; S.AutoQuest=false; S.AutoBoss=false
        S.AutoRaid=false; S.KillAura=false; S.MasteryFarm=false; _AutoFarmActive=false; QUEST.state="idle"
        setStatus("Idle"); notify("STOP","All farming halted",2.5,T.Red)
    end)

    -- Mastery Farm card (right column after toggles)
    local mastC=card(fR,"Mastery Farm",2)
    toggle(mastC,"Enable Mastery Farm","MasteryFarm",1,function(on)
        notify("Mastery",on and"ON → "..(S.MasteryWeapon or"Sword")or"OFF",2.5,T.Purple)
    end)
    dropdown(mastC,"Weapon/Style",{"Sword","Gun","Fruit","Fighting Style","Katana","Pole"},"MasteryWeapon",2)
    sep(mastC,3)
    infoRow(mastC,"Tip","Equip the weapon first",4)

    -- Quick farm buttons
    local s1L,s1R=twoCol(pFarm,3)
    local s1Lc=card(s1L,"Sea 1",1); local s1Rc=card(s1R,"Sea 2",1)
    for _,name in ipairs(SEA_LIST[1]) do
        local info=MOB_MAP[name]
        btn(s1Lc,name..(info and" [Lv."..info.mn.."]"or""),T.Card2,1,function()
            S.TargetMob=name; S.AutoFarm=true; _AutoFarmActive=true; qSave()
            if info then tp(info.p) end; notify("Farm",name,2.5,T.Blue)
        end)
    end
    for _,name in ipairs(SEA_LIST[2]) do
        local info=MOB_MAP[name]
        btn(s1Rc,name..(info and" [Lv."..info.mn.."]"or""),T.Card2,1,function()
            S.TargetMob=name; S.AutoFarm=true; _AutoFarmActive=true; qSave()
            if info then tp(info.p) end; notify("Farm",name,2.5,T.Blue)
        end)
    end
    local s3C=card(pFarm,"Sea 3",4); local s3L,s3R=twoCol(s3C,1)
    local half=#SEA_LIST[3]//2
    for i,name in ipairs(SEA_LIST[3]) do
        local info=MOB_MAP[name]; local tgt=i<=half and s3L or s3R
        btn(tgt,name..(info and" [Lv."..info.mn.."]"or""),T.Card2,i,function()
            S.TargetMob=name; S.AutoFarm=true; _AutoFarmActive=true; qSave()
            if info then tp(info.p) end; notify("Farm",name,2.5,T.Blue)
        end)
    end
end

-- ── PAGE: COMBAT ──────────────────────────────────────────────────────
do
    local pCbt=makePage("Combat")
    local cL,cR=twoCol(pCbt,1)

    local kaC=card(cL,"Kill Aura",1)
    toggle(kaC,"Enable Kill Aura","KillAura",1,function(on) notify("Kill Aura",on and"ON"or"OFF",2,on and T.Red or T.Sub) end)
    toggle(kaC,"Team Check (safe)","KillAuraTeamCheck",2)
    sep(kaC,3); slider(kaC,"Range","KillAuraRange",8,200,4)

    local skillC=card(cL,"Combat Skills",2)
    toggle(skillC,"Auto Skill Z","SkillZ",1); toggle(skillC,"Auto Skill X","SkillX",2)
    toggle(skillC,"Auto Skill C","SkillC",3); toggle(skillC,"Auto Skill V","SkillV",4)

    local flyC=card(cL,"Fly  (WASD + Space/Ctrl)",3)
    toggle(flyC,"Enable Fly","FlyEnabled",1); slider(flyC,"Speed","FlySpeed",20,500,2)

    local moveC=card(cL,"Movement",4)
    toggle(moveC,"No Clip","NoClip",1); toggle(moveC,"Infinite Jump","InfJump",2)
    dropdown(moveC,"Attack Type",{"Fast","Normal","Slow"},"FastAttackType",3)

    local defC=card(cR,"Defence",1)
    toggle(defC,"God Mode","GodMode",1,function(on) notify("God Mode",on and"ON"or"OFF",2.5,on and T.Gold or T.Sub) end)
    toggle(defC,"Anti-AFK","AntiAFK",2); toggle(defC,"Auto Respawn","AutoRespawn",3)

    local statC=card(cR,"Auto Stats",2)
    toggle(statC,"Auto Distribute Stats","AutoStat",1,function(on) notify("Auto Stat",on and"ON"or"OFF",2,T.Gold) end)
    dropdown(statC,"Priority",{"Melee","Defense","HP","Sword","Gun","Fruit"},"StatPriority",2)
    sep(statC,3)
    local statPtsLbl=infoRow(statC,"Stat Points","...",4)
    btn(statC,"Distribute Now",T.Card2,5,function()
        local pts=0; pcall(function()
            pts=LP:WaitForChild("Data",0.3):WaitForChild("StatPoints",0.3).Value or 0
        end)
        if pts<1 then notify("Auto Stat","No points available",2,T.Red); return end
        local rem=STAT_REMOTES[S.StatPriority] or "Melee"
        for _=1,pts do Com("F_","AddStat",rem) end
        notify("Stat","+"..pts.." → "..S.StatPriority,3,T.Gold)
    end)
    task.spawn(function()
        while task.wait(3) do
            if not statPtsLbl.Parent then break end
            pcall(function()
                local pts=LP:WaitForChild("Data",0.3):WaitForChild("StatPoints",0.3).Value or 0
                statPtsLbl.Text=tostring(pts)
            end)
        end
    end)

    local wsC=card(cR,"Walk Speed",3)
    slider(wsC,"Speed","WalkSpeed",16,350,1,function(v) local h=getHum(); if h then h.WalkSpeed=v end end)
    sep(wsC,2)
    for i,sp in ipairs({16,32,60,100,200,350}) do
        btn(wsC,"→ "..sp,T.Card2,2+i,function() S.WalkSpeed=sp; qSave(); local h=getHum(); if h then h.WalkSpeed=sp end end)
    end

    local jpC=card(cR,"Jump Power",4)
    slider(jpC,"Power","JumpPower",50,600,1,function(v) local h=getHum(); if h then h.JumpPower=v end end)
    sep(jpC,2)
    for i,jp in ipairs({50,100,250,500}) do
        btn(jpC,"→ "..jp,T.Card2,2+i,function() S.JumpPower=jp; qSave(); local h=getHum(); if h then h.JumpPower=jp end end)
    end
end

-- ── PAGE: TELEPORT ────────────────────────────────────────────────────
do
    local pTP=makePage("TP")
    local tpL,tpR=twoCol(pTP,1)

    local frC=card(tpL,"Fruit Finder",1)
    toggle(frC,"Auto TP to Fruits","TPFruit",1); toggle(frC,"Auto Eat on Arrival","AutoEatFruit",2)
    btn(frC,"Scan & TP Nearest",T.Card2,3,function()
        local fruits=scanFruits(); local r=getRoot()
        if not r then notify("Fruit","No character",2,T.Red); return end
        if #fruits==0 then notify("Fruit","None found",2,T.Red); return end
        table.sort(fruits,function(a,b) return (a.pos-r.Position).Magnitude<(b.pos-r.Position).Magnitude end)
        tp(fruits[1].pos); notify("Fruit","→  "..fruits[1].name,3,T.Green)
    end)

    local posC=card(tpL,"Position Saver",2)
    btn(posC,"Save Position",T.Card2,1,function()
        local root=getRoot(); if not root then notify("TP","No character",2,T.Red); return end
        S.SavedPosX=math.round(root.Position.X)
        S.SavedPosY=math.round(root.Position.Y)
        S.SavedPosZ=math.round(root.Position.Z)
        qSave(); notify("Position","Saved!  ("..S.SavedPosX..", "..S.SavedPosY..", "..S.SavedPosZ..")",3,T.Teal)
    end)
    btn(posC,"Return to Saved",T.Card2,2,function()
        if S.SavedPosX==0 and S.SavedPosZ==0 then notify("TP","No position saved",2,T.Red); return end
        tp(Vector3.new(S.SavedPosX,S.SavedPosY,S.SavedPosZ))
        notify("TP","Returned to saved position",2,T.Teal)
    end)

    local s1iC=card(tpL,"Sea 1 Islands",3)
    for _,d in ipairs(SEA1_ISL) do btn(s1iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end) end

    local s2iC=card(tpR,"Sea 2 Islands",1)
    for _,d in ipairs(SEA2_ISL) do btn(s2iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end) end
    local s3iC=card(tpR,"Sea 3 Islands",2)
    for _,d in ipairs(SEA3_ISL) do btn(s3iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end) end
end

-- ── PAGE: BOSS ────────────────────────────────────────────────────────
do
    local pBoss=makePage("Boss")
    local bL,bR=twoCol(pBoss,1)
    local bNames={}; for k in pairs(BOSS_POS) do bNames[#bNames+1]=k end; table.sort(bNames)
    local bCfg=card(bL,"Boss Config",1)
    dropdown(bCfg,"Select Boss",bNames,"SelectedBoss",1); sep(bCfg,2)
    toggle(bCfg,"Auto Boss Farm","AutoBoss",3,function(on) notify("Boss",on and"ON: "..S.SelectedBoss or"OFF",2.5,on and T.Gold or T.Sub) end)
    sep(bCfg,4)
    btn(bCfg,"TP Now",T.Card2,5,function()
        local pos=BOSS_POS[S.SelectedBoss]; if pos then tp(pos); notify("Boss","→ "..S.SelectedBoss,2) end
    end)
    local bTPc=card(bR,"Quick TP",1)
    for _,n in ipairs(bNames) do
        btn(bTPc,n,T.Card2,1,function() local pos=BOSS_POS[n]; if pos then tp(pos); notify("Boss","→ "..n,2) end end)
    end
end

-- ── PAGE: RAID ────────────────────────────────────────────────────────
do
    local pRaid=makePage("Raid")
    local rL,rR=twoCol(pRaid,1)
    local rNames={}; for k in pairs(RAID_POS) do rNames[#rNames+1]=k end; table.sort(rNames)
    local rCfg=card(rL,"Raid Config",1)
    dropdown(rCfg,"Select Raid",rNames,"SelectedRaid",1); sep(rCfg,2)
    toggle(rCfg,"Auto Raid","AutoRaid",3,function(on) notify("Raid",on and"ON: "..S.SelectedRaid or"OFF",2.5,on and T.Purple or T.Sub) end)
    sep(rCfg,4)
    btn(rCfg,"TP Now",T.Card2,5,function()
        local pos=RAID_POS[S.SelectedRaid]; if pos then tp(pos); notify("Raid","→ "..S.SelectedRaid,2) end
    end)
    local rTPc=card(rR,"Quick TP",1)
    for _,n in ipairs(rNames) do
        btn(rTPc,n,T.Card2,1,function() local pos=RAID_POS[n]; if pos then tp(pos); notify("Raid","→ "..n,2) end end)
    end
end

-- ── PAGE: ESP ─────────────────────────────────────────────────────────
do
    local pESP=makePage("ESP")
    local eL,eR=twoCol(pESP,1)
    local plC=card(eL,"Player ESP",1)
    toggle(plC,"Enable Player ESP","PlayerESP",1,function(on) notify("Player ESP",on and"ON"or"OFF",2,T.Blue) end)
    toggle(plC,"Show Distance","ESPDistance",2)
    toggle(plC,"Show Health","ESPHealth",3)
    local mC=card(eL,"Mob ESP",2)
    toggle(mC,"Enable Mob ESP","MobESP",1,function(on) notify("Mob ESP",on and"ON"or"OFF",2,T.Red) end)
    toggle(mC,"Show Distance","ESPDistance",2)
    local fC=card(eR,"Fruit ESP",1)
    toggle(fC,"Enable Fruit ESP","FruitESP",1,function(on) notify("Fruit ESP",on and"ON"or"OFF",2,T.Green) end)
    sep(fC,2)
    toggle(fC,"Fruit Spawn Notify","FruitNotify",3,function(on) notify("Fruit Notify",on and"ON"or"OFF",2,T.Green) end)
    slider(fC,"Notify Range","FruitNotifyRange",100,2000,4)
    local infoC=card(eR,"ESP Info",2)
    infoRow(infoC,"Engine",HAS_DRAW and"Drawing API"or"Billboard",1)
    infoRow(infoC,"Executor",EXEC_NAME,2)
    infoRow(infoC,"Delta",IS_DELTA and"✓ Yes"or"No",3)
    btn(infoC,"Clear All ESP",T.Card2,4,function() clearESP(); notify("ESP","Cleared",2) end)
end

-- ── PAGE: VISUAL ──────────────────────────────────────────────────────
do
    local pVis=makePage("Visual")
    local vL,vR=twoCol(pVis,1)
    local lC=card(vL,"Lighting",1)
    toggle(lC,"Fullbright","Fullbright",1,function(on)
        Lighting.Brightness=on and 3.8 or 1; Lighting.FogEnd=on and 1e6 or 1e4
        notify("Fullbright",on and"ON"or"OFF",2)
    end)
    toggle(lC,"No Fog","NoFog",2,function(on) Lighting.FogEnd=on and 1e6 or 1e4; notify("No Fog",on and"ON"or"OFF",2) end)
    local camC=card(vL,"Camera",2)
    slider(camC,"FOV","FOV",40,120,1,function(v) Camera.FieldOfView=v end)
    btn(camC,"Reset FOV",T.Card2,2,function() S.FOV=70; qSave(); Camera.FieldOfView=70 end)
    local dispC=card(vR,"Display",1)
    toggle(dispC,"Show Watermark","ShowWatermark",1); toggle(dispC,"Show FPS","ShowFPS",2)
end

-- ── PAGE: MISC / STATS ────────────────────────────────────────────────
do
    local pMisc=makePage("Misc")
    local mL,mR=twoCol(pMisc,1)

    local plC=card(mL,"Player",1)
    local avImg=Instance.new("ImageLabel",plC); avImg.Size=UDim2.new(0,42,0,42)
    avImg.BackgroundColor3=T.Card2; avImg.BorderSizePixel=0; avImg.Image=AVATAR
    avImg.LayoutOrder=1; Instance.new("UICorner",avImg).CornerRadius=UDim.new(1,0)
    local nmLbl=Instance.new("TextLabel",plC); nmLbl.Size=UDim2.new(1,0,0,16)
    nmLbl.BackgroundTransparency=1; nmLbl.Text=LP.DisplayName or LP.Name
    nmLbl.Font=Enum.Font.GothamBold; nmLbl.TextSize=11; nmLbl.TextColor3=T.Text
    nmLbl.TextXAlignment=Enum.TextXAlignment.Left; nmLbl.LayoutOrder=2
    local unLbl=Instance.new("TextLabel",plC); unLbl.Size=UDim2.new(1,0,0,13)
    unLbl.BackgroundTransparency=1; unLbl.Text="@"..LP.Name
    unLbl.Font=Enum.Font.Gotham; unLbl.TextSize=9; unLbl.TextColor3=T.Sub
    unLbl.TextXAlignment=Enum.TextXAlignment.Left; unLbl.LayoutOrder=3
    sep(plC,4)
    local lvInfoRow=infoRow(plC,"Level","...",5)
    task.spawn(function() while task.wait(3) do if lvInfoRow.Parent then lvInfoRow.Text=tostring(getLevel()) end end end)

    local statC=card(mL,"Session Stats",2)
    local killsR=infoRow(statC,"Kills","0",1); local deathsR=infoRow(statC,"Deaths","0",2)
    local questsR=infoRow(statC,"Quests","0",3); local fruitsR=infoRow(statC,"Fruits TP","0",4)
    local uptimeR=infoRow(statC,"Uptime","0m 00s",5); local kpmR=infoRow(statC,"KPM","0",6)
    task.spawn(function()
        while task.wait(1) do
            if not killsR.Parent then break end
            killsR.Text=tostring(STATS.kills); deathsR.Text=tostring(STATS.deaths)
            questsR.Text=tostring(STATS.questsDone); fruitsR.Text=tostring(STATS.fruitsTP)
            uptimeR.Text=fmtTime(os.time()-STATS.startTime); kpmR.Text=tostring(STATS.kpm)
        end
    end)

    local sysC=card(mR,"System",1)
    infoRow(sysC,"Executor",EXEC_NAME,1); infoRow(sysC,"Delta",IS_DELTA and"✓"or"No",2)
    infoRow(sysC,"Drawing",HAS_DRAW and"✓"or"No",3); infoRow(sysC,"WriteFile",HAS_WF and"✓"or"No",4)
    infoRow(sysC,"FireTouch",HAS_FTI and"✓"or"No",5); infoRow(sysC,"FPP",HAS_FPP and"✓"or"No",6)

    local miscC=card(mR,"Misc Actions",2)
    btn(miscC,"Copy Discord Link",T.Card2,1,function()
        pcall(function() if setclipboard then setclipboard("discord.gg/EmsMsHZCVH") end end)
        notify("Discord","discord.gg/EmsMsHZCVH — copied!",3,T.Blue)
    end)
    btn(miscC,"Rejoin Server",T.Card2,2,function()
        notify("Rejoin","Rejoining...",2,T.Gold)
        task.delay(1.5, function()
            pcall(function()
                game:GetService("TeleportService"):Teleport(game.PlaceId,LP)
            end)
        end)
    end)
    btn(miscC,"Save Config",T.Card2,3,function() saveConfig(S); notify("Config","Saved!",2,T.Green) end)
    btn(miscC,"Reset Config",Color3.fromRGB(40,12,12),4,function()
        local def=cfgDefault()
        for k,v in pairs(def) do S[k]=v end; saveConfig(S)
        notify("Config","Reset to defaults",2.5,T.Red)
    end)
end

-- ── PAGE: SETTINGS ────────────────────────────────────────────────────
do
    local pSet=makePage("Settings")
    local sL,sR=twoCol(pSet,1)

    local kbC=card(sL,"Hotkey",1)
    infoRow(kbC,"Current key",S.ToggleKey or"RightShift",1)
    sep(kbC,2)
    dropdown(kbC,"Toggle Key",{"RightShift","Insert","RightAlt","Home","End","Delete","F5","F6","F7","F8"},"ToggleKey",3,
        function(k) notify("Hotkey","Toggle: "..k.."  or  Insert",2.5,T.Teal) end)

    local accentC=card(sL,"Accent Color",2)
    for _,name in ipairs({"Pink","Blue","Purple","Teal","Gold","Green","Red"}) do
        local col=ACCENT_PRESETS[name]
        local b=btn(accentC,name,col,1,function()
            applyAccent(name)
            notify("Theme","Accent: "..name,2,col)
        end)
        b.TextColor3=Color3.new(1,1,1)
    end

    local notifC=card(sL,"Notifications",3)
    slider(notifC,"Duration (s)","NotifyDur",1,10,1)
    toggle(notifC,"Show Watermark","ShowWatermark",2)
    toggle(notifC,"Show FPS","ShowFPS",3)

    local farmSetC=card(sR,"Farm Settings",1)
    toggle(farmSetC,"Bring Mob","BringMob",1)
    toggle(farmSetC,"Fast Attack","FastAttack",2)
    toggle(farmSetC,"Auto Haki","AutoHaki",3)
    toggle(farmSetC,"Anti-AFK","AntiAFK",4)
    toggle(farmSetC,"Safe Mode TP","SafeMode",5,function(on) S.FarmDelay=on and 0.28 or 0.1; qSave() end)
    toggle(farmSetC,"Bypass TP","BypassTP",6)
    sep(farmSetC,7)
    slider(farmSetC,"Farm Delay","FarmDelay",0.05,2,8)

    local aboutC=card(sR,"About",2)
    infoRow(aboutC,"Version","v1.0.0",1)
    infoRow(aboutC,"Executor",EXEC_NAME,2)
    infoRow(aboutC,"Platform",IS_DELTA and"Delta ✓"or"Generic",3)
    infoRow(aboutC,"Drawing",HAS_DRAW and"✓"or"No",4)
    infoRow(aboutC,"FireTouch",HAS_FTI and"✓"or"No",5)
    infoRow(aboutC,"FPP",HAS_FPP and"✓"or"No",6)
    sep(aboutC,7)
    btn(aboutC,"Copy Discord",T.Card2,8,function()
        pcall(function() if setclipboard then setclipboard("discord.gg/EmsMsHZCVH") end end)
        notify("Discord","discord.gg/EmsMsHZCVH — copied!",3,T.Blue)
    end)
    btn(aboutC,"Save Config",T.Card2,9,function() saveConfig(S); notify("Config","Saved",2,T.Green) end)
    btn(aboutC,"Reset All Settings",Color3.fromRGB(40,12,12),10,function()
        local def=cfgDefault(); for k,v in pairs(def) do S[k]=v end; saveConfig(S)
        notify("Config","Reset to defaults",2.5,T.Red)
    end)
end

-- apply saved accent on startup
pcall(function() applyAccent(S.AccentPreset or "Pink") end)

-- ── FINALISE ──────────────────────────────────────────────────────────
buildWatermark()
showPage("Farm")
notify("Elite Hub","v1.0.0 loaded  •  "..(S.ToggleKey or "RShift").."/Insert to toggle",4,T.Pink)
print("[Elite Hub] v1.0.0 loaded | Executor: "..EXEC_NAME..(IS_DELTA and " ✓ Delta" or ""))
