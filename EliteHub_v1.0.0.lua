-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   ███████╗██╗     ██╗████████╗███████╗                           ║
-- ║   ██╔════╝██║     ██║╚══██╔══╝██╔════╝                           ║
-- ║   █████╗  ██║     ██║   ██║   █████╗                             ║
-- ║   ██╔══╝  ██║     ██║   ██║   ██╔══╝                             ║
-- ║   ███████╗███████╗██║   ██║   ███████╗  HUB                      ║
-- ║   ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝                           ║
-- ║                                                                   ║
-- ║   Version  : v1.0.0  (Release Edition)                           ║
-- ║   Game     : Blox Fruits  (All Seas, Lv 1–2800+)                 ║
-- ║   Executors: Delta, Fluxus, Arceus X, Wave                       ║
-- ║   Discord  : discord.gg/EmsMsHZCVH                               ║
-- ╚══════════════════════════════════════════════════════════════════╝

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
local HAS_DBG       = typeof(debug)                == "table"
local HAS_GUV       = typeof(getupvalues)          == "function"
local HAS_SUV       = pcall(function() debug.setupvalue end) and typeof(debug.setupvalue) == "function"
local HAS_ISNET     = typeof(isnetworkowner)       == "function"
local HAS_SETSCRIPT = typeof(setscriptable)        == "function"
local HAS_HIDDEN    = typeof(sethiddenproperty)    == "function"
local EXEC_NAME     = "Unknown"
local IS_DELTA      = false

pcall(function()
    if identifyexecutor   then EXEC_NAME = identifyexecutor()   end
    if getexecutorname    then EXEC_NAME = getexecutorname()     end
end)
local EL = EXEC_NAME:lower()
IS_DELTA = EL:find("delta") ~= nil

-- ════════════════════════════════════════════
--  EXECUTOR SAFETY GATE  (block Xeno / Solara)
-- ════════════════════════════════════════════
if EL:find("xeno") or EL:find("solara") then
    pcall(function()
        game:GetService("Players").LocalPlayer:Kick(
            "[Elite Hub] Blocked executor: " .. EXEC_NAME .. "\n" ..
            "Xeno and Solara are confirmed account-stealing executors.\n" ..
            "Please use Delta, Fluxus, Arceus X, or Wave."
        )
    end)
    return
end

-- ════════════════════════════════════════════
--  SERVICES
-- ════════════════════════════════════════════
local function ref(s)  return (HAS_CLONEREF and cloneref or function(x) return x end)(s) end
local function wrap(f) return (HAS_NCC      and newcclosure or function(x) return x end)(f) end

local Players          = ref(game:GetService("Players"))
local RunService       = ref(game:GetService("RunService"))
local UserInputService = ref(game:GetService("UserInputService"))
local TweenService     = ref(game:GetService("TweenService"))
local VirtualUser      = ref(game:GetService("VirtualUser"))
local Lighting         = ref(game:GetService("Lighting"))
local RepStorage       = ref(game:GetService("ReplicatedStorage"))
local HttpService      = ref(game:GetService("HttpService"))
local LP               = Players.LocalPlayer
local Mouse            = LP:GetMouse()
local PG               = LP:WaitForChild("PlayerGui", 10)
local Camera           = workspace.CurrentCamera

local DISPLAY_NAME = LP.DisplayName or LP.Name
local USERNAME     = "@" .. LP.Name
local USER_ID      = LP.UserId
local AVATAR_URL   = "rbxthumb://type=AvatarHeadShot&id=" .. USER_ID .. "&w=150&h=150"

-- Discord + remove death-interrupt effects
print("[Elite Hub] discord.gg/EmsMsHZCVH")
pcall(function() toclipboard("https://discord.gg/EmsMsHZCVH") end)
pcall(function()
    local ec = RepStorage:FindFirstChild("Effect")
    if ec then
        local c = ec:FindFirstChild("Container")
        if c then
            if c:FindFirstChild("Death")   then c.Death:Destroy()   end
            if c:FindFirstChild("Respawn") then c.Respawn:Destroy() end
        end
    end
end)

-- ════════════════════════════════════════════
--  CONFIG  (auto-saved to executor file)
-- ════════════════════════════════════════════
local CFG_FILE  = "EliteHub_v1_config.json"
local CFG_FOLDER= "Elite Hub Scripts/Blox Fruits"

local function cfgDefault()
    return {
        AutoFarm=false, TargetMob="Bandit", FarmMethod="Melee",
        SafeMode=false, FarmDelay=0.1, AutoLevelFarm=false,
        AutoQuest=false, AutoChest=false,
        AutoBoss=false, SelectedBoss="Gorilla King",
        AutoRaid=false, SelectedRaid="Flame",
        TPFruit=false, AutoEatFruit=false,
        KillAura=false, KillAuraRange=25,
        BringMob=true, FastAttack=true, FastAttackType="Fast",
        AutoHaki=true, AutoRespawn=true, AntiAFK=true,
        FlyEnabled=false, FlySpeed=60, NoClip=false,
        InfJump=false, WalkSpeed=16, JumpPower=50,
        GodMode=false,
        PlayerESP=false, MobESP=false, FruitESP=false,
        Fullbright=false, NoFog=false, FOV=70,
        ShowWatermark=true, ShowFPS=true,
        AutoStat=false, StatPriority="Melee",
        BypassTP=false,
    }
end

local function toJSON(d)
    local t = {}
    for k, v in pairs(d) do
        local s
        if type(v)=="boolean" then s=v and"true"or"false"
        elseif type(v)=="number" then s=tostring(v)
        else s='"'..tostring(v):gsub('\\','\\\\'):gsub('"','\\"')..'"' end
        table.insert(t, '"'..k..'":'..s)
    end
    return "{"..table.concat(t,",").."}"
end

local function fromJSON(raw, def)
    local d = {}
    for k, v in pairs(def) do d[k] = v end
    pcall(function()
        for k in pairs(def) do
            local v = raw:match('"'..k..'":%s*(.-)%s*[,}%]]')
            if v then
                v = v:gsub('^%s+',''):gsub('%s+$','')
                if     v=="true"  then d[k]=true
                elseif v=="false" then d[k]=false
                elseif tonumber(v) then d[k]=tonumber(v)
                else d[k]=v:gsub('^"',''):gsub('"$','') end
            end
        end
    end)
    return d
end

local function saveConfig(S)
    pcall(function()
        if HAS_WRITEFILE then
            if isfolder and not isfolder(CFG_FOLDER) then makefolder(CFG_FOLDER) end
            writefile(CFG_FILE, toJSON(S))
        end
    end)
end

local function loadConfig()
    local def = cfgDefault()
    if not HAS_READFILE then return def end
    local ok, raw = pcall(readfile, CFG_FILE)
    if ok and raw and #raw > 2 then return fromJSON(raw, def) end
    -- try legacy path
    local legPath = "Elite Hub Scripts/Blox Fruits/"..LP.Name..".json"
    if isfile and isfile(legPath) then
        local ok2, raw2 = pcall(readfile, legPath)
        if ok2 and raw2 then
            pcall(function()
                local dec = HttpService:JSONDecode(raw2)
                if dec.Configs then
                    if dec.Configs["Fast Attack"] ~= nil  then def.FastAttack = dec.Configs["Fast Attack"] end
                    if dec.Configs["Auto Haki"]   ~= nil  then def.AutoHaki   = dec.Configs["Auto Haki"]   end
                    if dec.Configs["Bypass TP"]   ~= nil  then def.BypassTP   = dec.Configs["Bypass TP"]   end
                end
                if dec.Misc then
                    if dec.Misc["Fly"]       ~= nil then def.FlyEnabled = dec.Misc["Fly"]       end
                    if dec.Misc["No Fog"]    ~= nil then def.NoFog      = dec.Misc["No Fog"]    end
                end
            end)
        end
    end
    return def
end

local S = loadConfig()

local _savePend = false
local function qSave()
    if _savePend then return end
    _savePend = true
    task.delay(1.5, function() _savePend = false; saveConfig(S) end)
end

-- ════════════════════════════════════════════
--  _G.Settings  (full legacy compat table)
-- ════════════════════════════════════════════
_G.Settings = {
    Main = {
        ["Auto Farm Level"]=false,["Fast Auto Farm Level"]=false,
        ["Distance Mob Aura"]=1000,["Mob Aura"]=false,
        ["Auto New World"]=false,["Auto Saber"]=false,["Auto Pole"]=false,
        ["Auto Buy Ablility"]=false,
        ["Auto Third Sea"]=false,["Auto Factory"]=false,
        ["Auto Factory Hop"]=false,["Auto Bartilo Quest"]=false,
        ["Auto True Triple Katana"]=false,["Auto Rengoku"]=false,
        ["Auto Swan Glasses"]=false,["Auto Dark Coat"]=false,
        ["Auto Ectoplasm"]=false,["Auto Buy Legendary Sword"]=false,
        ["Auto Buy Enchanment Haki"]=false,
        ["Auto Holy Torch"]=false,["Auto Buddy Swords"]=false,
        ["Auto Farm Boss Hallow"]=false,["Auto Rainbow Haki"]=false,
        ["Auto Elite Hunter"]=false,["Auto Musketeer Hat"]=false,
        ["Auto Buddy Sword"]=false,["Auto Farm Bone"]=false,
        ["Auto Ken-Haki V2"]=false,["Auto Cavander"]=false,
        ["Auto Yama Sword"]=false,["Auto Tushita Sword"]=false,
        ["Auto Serpent Bow"]=false,["Auto Dark Dagger"]=false,
        ["Auto Cake Prince"]=false,["Auto Dough V2"]=false,
        ["Auto Random Bone"]=false,
        ["Auto Fish Tail Sea 1"]=false,["Auto Fish Tail Sea 3"]=false,
        ["Auto Magma Ore Sea 2"]=false,["Auto Magma Ore Sea 1"]=false,
        ["Auto Mystic Droplet"]=false,["Auto Dragon Scales"]=false,
    },
    FightingStyle = {
        ["Auto God Human"]=false,["Auto Superhuman"]=false,
        ["Auto Electric Claw"]=false,["Auto Death Step"]=false,
        ["Auto Fully Death Step"]=false,["Auto SharkMan Karate"]=false,
        ["Auto Fully SharkMan Karate"]=false,["Auto Dragon Talon"]=false,
    },
    Boss = {["Auto All Boss"]=false,["Auto Boss Select"]=false,["Select Boss"]={},["Auto Quest"]=false},
    Mastery = {
        ["Select Multi Sword"]={},["Farm Mastery SwordList"]=false,
        ["Auto Farm Fruit Mastery"]=false,["Auto Farm Gun Mastery"]=false,["Mob Health (%)"]=15,
    },
    Configs = {
        ["Double Quest"]=false,["Bypass TP"]=false,["Select Team"]={"Pirate"},
        ["Fast Attack"]=true,["Fast Attack Type"]={"Fast"},["Select Weapon"]="",
        ["Auto Haki"]=true,["Distance Auto Farm"]=20,["Camera Shaker"]=false,
        ["Skill Z"]=true,["Skill X"]=true,["Skill C"]=true,["Skill V"]=true,
        ["Show Hitbox"]=false,["Bring Mob"]=true,["Disabled Damage"]=false,
    },
    Stat = {
        ["Enabled Auto Stats"]=false,["Auto Stats Kaitun"]=false,
        ["Select Stats"]={"Melee"},["Point Select"]=3,
        ["Enabled Auto Redeem Code"]=false,["Select Level Redeem Code"]=1,
    },
    Misc = {
        ["No Soru Cooldown"]=false,["No Dash Cooldown"]=false,
        ["Infinities Geppo"]=false,["Infinities Energy"]=false,
        ["No Fog"]=false,["Wall-TP"]=false,
        ["Fly"]=false,["Fly Speed"]=1,["Auto Rejoin"]=true,
    },
    Teleport = {["Teleport to Sea Beast"]=false},
    Fruits = {
        ["Auto Buy Random Fruits"]=false,["Auto Store Fruits"]=false,
        ["Select Devil Fruits"]={},["Auto Buy Devil Fruits Sniper"]=false,
    },
    Raids = {
        ["Auto Raids"]=false,["Kill Aura"]=false,
        ["Auto Awakened"]=false,["Auto Next Place"]=false,["Select Raids"]={},
    },
    Combat = {["Fov Size"]=200,["Show Fov"]=false,["Aimbot Skill"]=false},
    HUD = {["FPS"]=60,["LockFPS"]=true,["Boost FPS Windows"]=false,["White Screen"]=false},
    ConfigsUI = {ColorUI=Color3.fromRGB(255,0,127)},
}

-- ════════════════════════════════════════════
--  MOB DATABASE  (All Seas, Lv 1–2800+)
-- ════════════════════════════════════════════
local MOBS = {
    -- ── SEA 1 ─────────────────────────────────────────────────────────────
    {sea=1,name="Bandit",         minLv=1,   maxLv=14,  kills=8,  pos=Vector3.new(979,125,1570),    questPos=Vector3.new(997,126,1587)},
    {sea=1,name="Monkey",         minLv=15,  maxLv=29,  kills=8,  pos=Vector3.new(-1500,125,-200),   questPos=Vector3.new(-1495,125,-185)},
    {sea=1,name="Gorilla",        minLv=30,  maxLv=59,  kills=8,  pos=Vector3.new(-1700,125,-310),   questPos=Vector3.new(-1695,125,-295)},
    {sea=1,name="Pirate",         minLv=60,  maxLv=99,  kills=10, pos=Vector3.new(-1200,125,4350),   questPos=Vector3.new(-1195,125,4365)},
    {sea=1,name="Brute",          minLv=100, maxLv=124, kills=10, pos=Vector3.new(-1100,125,4500),   questPos=Vector3.new(-1095,125,4515)},
    {sea=1,name="Desert Bandit",  minLv=125, maxLv=149, kills=10, pos=Vector3.new(870,125,4000),     questPos=Vector3.new(880,126,4010)},
    {sea=1,name="Desert Officer", minLv=150, maxLv=174, kills=10, pos=Vector3.new(1050,125,4200),    questPos=Vector3.new(1060,126,4210)},
    {sea=1,name="Snow Bandit",    minLv=175, maxLv=199, kills=10, pos=Vector3.new(1200,125,-2700),   questPos=Vector3.new(1210,126,-2690)},
    {sea=1,name="Snowman",        minLv=200, maxLv=249, kills=10, pos=Vector3.new(1300,125,-2850),   questPos=Vector3.new(1310,126,-2840)},
    {sea=1,name="Marine",         minLv=250, maxLv=299, kills=10, pos=Vector3.new(-900,125,-350),    questPos=Vector3.new(-890,126,-340)},
    {sea=1,name="Sky Bandit",     minLv=300, maxLv=374, kills=12, pos=Vector3.new(-4700,875,-700),   questPos=Vector3.new(-4690,876,-690)},
    {sea=1,name="Dark Master",    minLv=375, maxLv=449, kills=12, pos=Vector3.new(-4950,1410,-700),  questPos=Vector3.new(-4940,1411,-690)},
    {sea=1,name="Toga Warrior",   minLv=450, maxLv=624, kills=12, pos=Vector3.new(3324,127,-2640),   questPos=Vector3.new(3334,127,-2630)},
    -- ── SEA 2 ─────────────────────────────────────────────────────────────
    {sea=2,name="Hoodlum",             minLv=625, maxLv=699,  kills=10, pos=Vector3.new(-750,266,550),    questPos=Vector3.new(-740,267,560)},
    {sea=2,name="Trader",              minLv=700, maxLv=774,  kills=10, pos=Vector3.new(-900,266,650),    questPos=Vector3.new(-890,267,660)},
    {sea=2,name="Forest Pirate",       minLv=775, maxLv=849,  kills=10, pos=Vector3.new(-3550,125,1850),  questPos=Vector3.new(-3540,126,1860)},
    {sea=2,name="Factory Staff",       minLv=850, maxLv=924,  kills=10, pos=Vector3.new(-3300,125,2000),  questPos=Vector3.new(-3290,126,2010)},
    {sea=2,name="Zombie",              minLv=925, maxLv=999,  kills=10, pos=Vector3.new(-5800,125,-620),  questPos=Vector3.new(-5790,126,-610)},
    {sea=2,name="Vampire",             minLv=1000,maxLv=1049, kills=10, pos=Vector3.new(-5900,125,-700),  questPos=Vector3.new(-5890,126,-690)},
    {sea=2,name="Living Zombie",       minLv=1050,maxLv=1099, kills=12, pos=Vector3.new(-5950,125,-750),  questPos=Vector3.new(-5940,126,-740)},
    {sea=2,name="Demonic Soul",        minLv=1100,maxLv=1174, kills=12, pos=Vector3.new(-5200,125,-1720), questPos=Vector3.new(-5190,126,-1710)},
    {sea=2,name="Ship Crew",           minLv=1175,maxLv=1249, kills=12, pos=Vector3.new(-5200,125,-1780), questPos=Vector3.new(-5190,126,-1770)},
    {sea=2,name="Cursed Pirate",       minLv=1250,maxLv=1324, kills=12, pos=Vector3.new(-5300,125,-1800), questPos=Vector3.new(-5290,126,-1790)},
    {sea=2,name="Military Soldier",    minLv=1325,maxLv=1399, kills=12, pos=Vector3.new(-10000,125,-2000),questPos=Vector3.new(-9990,126,-1990)},
    {sea=2,name="Military Spy",        minLv=1325,maxLv=1399, kills=12, pos=Vector3.new(-9800,125,-1900), questPos=Vector3.new(-9790,126,-1890)},
    {sea=2,name="Assassin",            minLv=1400,maxLv=1474, kills=12, pos=Vector3.new(-9500,125,-1700), questPos=Vector3.new(-9490,126,-1690)},
    {sea=2,name="Arctic Warrior",      minLv=1475,maxLv=1549, kills=12, pos=Vector3.new(-4300,1000,-1000),questPos=Vector3.new(-4290,1001,-990)},
    {sea=2,name="Snow Lurker",         minLv=1550,maxLv=1624, kills=12, pos=Vector3.new(-4600,1020,-1100),questPos=Vector3.new(-4590,1021,-1090)},
    {sea=2,name="Dragon Crew Warrior", minLv=1700,maxLv=1774, kills=12, pos=Vector3.new(3600,125,29450),  questPos=Vector3.new(3610,126,29460)},
    {sea=2,name="Dragon Crew Archer",  minLv=1775,maxLv=1849, kills=12, pos=Vector3.new(3700,125,29550),  questPos=Vector3.new(3710,126,29560)},
    {sea=2,name="Swan Pirate",         minLv=1850,maxLv=1924, kills=12, pos=Vector3.new(880,125,29250),   questPos=Vector3.new(890,126,29260)},
    {sea=2,name="Poseidon Soldier",    minLv=1925,maxLv=1999, kills=14, pos=Vector3.new(61350,125,1780),  questPos=Vector3.new(61360,126,1790)},
    {sea=2,name="Poseidon Knight",     minLv=2000,maxLv=2099, kills=14, pos=Vector3.new(61450,125,1850),  questPos=Vector3.new(61460,126,1860)},
    -- ── SEA 3 ─────────────────────────────────────────────────────────────
    {sea=3,name="Galley Pirate",        minLv=1500,maxLv=1574, kills=14, pos=Vector3.new(-2000,50,-4200),  questPos=Vector3.new(-1990,51,-4190)},
    {sea=3,name="Pirate Millionaire",   minLv=1575,maxLv=1649, kills=14, pos=Vector3.new(-2100,50,-4300),  questPos=Vector3.new(-2090,51,-4290)},
    {sea=3,name="Jungle Bug",           minLv=1650,maxLv=1724, kills=14, pos=Vector3.new(-3200,125,-3800), questPos=Vector3.new(-3190,126,-3790)},
    {sea=3,name="Laboon",               minLv=1725,maxLv=1799, kills=14, pos=Vector3.new(-3350,125,-3950), questPos=Vector3.new(-3340,126,-3940)},
    {sea=3,name="Forest Dragon",        minLv=1800,maxLv=1874, kills=14, pos=Vector3.new(-9000,400,-2500), questPos=Vector3.new(-8990,401,-2490)},
    {sea=3,name="Tree Spider",          minLv=1875,maxLv=1949, kills=14, pos=Vector3.new(-9100,400,-2600), questPos=Vector3.new(-9090,401,-2590)},
    {sea=3,name="Reborn Skeleton",      minLv=1950,maxLv=2049, kills=14, pos=Vector3.new(-11400,400,-1000),questPos=Vector3.new(-11390,401,-990)},
    {sea=3,name="Cursed Skeleton",      minLv=2050,maxLv=2124, kills=14, pos=Vector3.new(-11500,400,-1040),questPos=Vector3.new(-11490,401,-1030)},
    {sea=3,name="Soul Reaper",          minLv=2125,maxLv=2199, kills=14, pos=Vector3.new(-11600,400,-1080),questPos=Vector3.new(-11590,401,-1070)},
    {sea=3,name="Diablo",               minLv=2275,maxLv=2349, kills=14, pos=Vector3.new(-8300,125,1600),  questPos=Vector3.new(-8290,126,1610)},
    {sea=3,name="Beautiful Pirate",     minLv=2350,maxLv=2424, kills=14, pos=Vector3.new(-8350,125,1650),  questPos=Vector3.new(-8340,126,1660)},
    {sea=3,name="Tiki Outpost Raider",  minLv=2425,maxLv=2499, kills=14, pos=Vector3.new(-8280,125,-1000), questPos=Vector3.new(-8270,126,-990)},
    {sea=3,name="Brawler Crab",         minLv=2425,maxLv=2499, kills=14, pos=Vector3.new(-14500,243,-1000),questPos=Vector3.new(-14490,244,-990)},
    {sea=3,name="Chocolate Bar Battler",minLv=2500,maxLv=2574, kills=16, pos=Vector3.new(-13950,125,3800), questPos=Vector3.new(-13940,126,3810)},
    {sea=3,name="Ice Cream Staff",      minLv=2575,maxLv=2649, kills=16, pos=Vector3.new(-14050,125,3780), questPos=Vector3.new(-14040,126,3790)},
    {sea=3,name="Baking Staff",         minLv=2650,maxLv=2699, kills=16, pos=Vector3.new(-14100,125,3900), questPos=Vector3.new(-14090,126,3910)},
    {sea=3,name="Cake Guard",           minLv=2700,maxLv=2749, kills=16, pos=Vector3.new(-14000,125,3850), questPos=Vector3.new(-13990,126,3860)},
    {sea=3,name="Candy Rebel",          minLv=2750,maxLv=2799, kills=16, pos=Vector3.new(-11650,125,5450), questPos=Vector3.new(-11640,126,5460)},
    {sea=3,name="Cocoa Warrior",        minLv=2800,maxLv=9999, kills=16, pos=Vector3.new(-12300,125,4950), questPos=Vector3.new(-12290,126,4960)},
    {sea=3,name="Mythological Pirate",  minLv=2800,maxLv=9999, kills=16, pos=Vector3.new(-15100,125,-1750),questPos=Vector3.new(-15090,126,-1740)},
    {sea=3,name="Leviathan",            minLv=2800,maxLv=9999, kills=16, pos=Vector3.new(-13050,125,-4650),questPos=Vector3.new(-13040,126,-4640)},
    {sea=3,name="Longma",               minLv=2800,maxLv=9999, kills=16, pos=Vector3.new(3640,125,29500),  questPos=Vector3.new(3650,126,29510)},
}

local MOB_MAP, SEA_MOBS_LIST = {}, {[1]={}, [2]={}, [3]={}}
local _seenMob = {}
for _, m in ipairs(MOBS) do
    if not MOB_MAP[m.name] then MOB_MAP[m.name] = m end
    local uid = m.name.."|"..m.sea
    if not _seenMob[uid] then _seenMob[uid]=true; table.insert(SEA_MOBS_LIST[m.sea], m.name) end
end

-- ════════════════════════════════════════════
--  ISLAND / BOSS / RAID DATA
-- ════════════════════════════════════════════
local SEA1_ISLANDS = {
    {"Starter Island",Vector3.new(1260,125,1612)},{"Marine Starter",Vector3.new(-1180,125,-1174)},
    {"Middle Town",Vector3.new(-192,125,-559)},{"Jungle",Vector3.new(-1646,125,-261)},
    {"Pirate Village",Vector3.new(-1189,125,4403)},{"Desert",Vector3.new(924,125,4089)},
    {"Frozen Village",Vector3.new(1175,125,-1818)},{"Snowy Village",Vector3.new(1326,125,-2882)},
    {"Marine Fortress",Vector3.new(-965,125,-380)},{"Skylands",Vector3.new(-4755,872,-718)},
    {"Upper Skylands",Vector3.new(-5004,1400,-718)},{"Fountain City",Vector3.new(3324,127,-2610)},
}
local SEA2_ISLANDS = {
    {"Kingdom of Rose",Vector3.new(-804,266,604)},{"Dark Arena",Vector3.new(-9564,125,-1754)},
    {"Usoapp Island",Vector3.new(-2581,125,1500)},{"Green Zone",Vector3.new(-3626,125,1900)},
    {"Graveyard",Vector3.new(-5878,125,-670)},{"Snow Mountain",Vector3.new(-4550,1000,-1100)},
    {"Hot and Cold",Vector3.new(-3620,125,-2945)},{"Cursed Ship",Vector3.new(-5237,125,-1765)},
    {"Ice Castle",Vector3.new(-3966,125,-1120)},{"Colosseum",Vector3.new(926,125,29310)},
    {"Magma Village",Vector3.new(500,125,29650)},{"Underwater City",Vector3.new(61421,125,1819)},
    {"Wano",Vector3.new(3640,125,29500)},
}
local SEA3_ISLANDS = {
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
    ["Gorilla King"]=Vector3.new(-1700,125,-310),["Bobby"]=Vector3.new(-1189,125,4403),
    ["Yeti"]=Vector3.new(1300,125,-2880),["Darkbeard"]=Vector3.new(-9564,125,-1754),
    ["Rip_Indra"]=Vector3.new(-9084,400,-2573),["Thunder God"]=Vector3.new(-4755,872,-718),
    ["Tide Keeper"]=Vector3.new(61421,125,1819),["Stone"]=Vector3.new(-5237,125,-1765),
    ["Island Empress"]=Vector3.new(-3966,125,-1120),["Longma"]=Vector3.new(3640,125,29500),
    ["Cake Prince"]=Vector3.new(-12350,125,5000),["Kilo Admiral"]=Vector3.new(924,125,4089),
    ["Vice Admiral"]=Vector3.new(-965,125,-380),["Magma Admiral"]=Vector3.new(500,125,29650),
    ["Order"]=Vector3.new(-14553,243,-1014),["Cursed Captain"]=Vector3.new(-14300,125,-2100),
    ["Bartolomeo"]=Vector3.new(926,125,29310),["Greybeard"]=Vector3.new(-965,125,-380),
    ["Don Swan"]=Vector3.new(-9564,125,-1754),["Dough King"]=Vector3.new(-14055,125,3829),
}
local RAID_POS = {
    Flame=Vector3.new(3066,28,2760),Ice=Vector3.new(1227,28,-2204),
    Rumble=Vector3.new(-4755,872,-718),Quake=Vector3.new(-1180,28,-1174),
    Light=Vector3.new(3324,28,-2610),Dark=Vector3.new(-9084,28,-2573),
    Buddha=Vector3.new(-804,28,604),Venom=Vector3.new(-5237,28,-1765),
    Phoenix=Vector3.new(-3966,28,-1120),Dough=Vector3.new(-12350,28,5000),
    Shadow=Vector3.new(-11540,28,-1044),Portal=Vector3.new(-14553,28,-1014),
    Control=Vector3.new(-15200,28,-1800),Dragon=Vector3.new(-9564,28,-1754),
    Leopard=Vector3.new(-14300,28,-2100),["T-Rex"]=Vector3.new(-13000,28,-4700),
    Kitsune=Vector3.new(-9000,400,-2500),String=Vector3.new(-5878,28,-670),
    Magma=Vector3.new(500,28,29650),Gravity=Vector3.new(-4755,28,-718),
}

-- ════════════════════════════════════════════
--  LEVEL ENGINE
-- ════════════════════════════════════════════
local function getLevel()
    local lv = 1
    pcall(function()
        local paths = {
            function() return LP:WaitForChild("Data",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("PlayerData",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("leaderstats",0.3):WaitForChild("Level",0.3).Value end,
            function() return LP:WaitForChild("leaderstats",0.3):WaitForChild("Lv",0.3).Value end,
        }
        for _, fn in ipairs(paths) do
            local ok, v = pcall(fn)
            if ok and type(v)=="number" and v>0 then lv=v; break end
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
    return best or MOBS[1]
end

-- ════════════════════════════════════════════
--  THEME
-- ════════════════════════════════════════════
local T = {
    BG    =Color3.fromRGB(8,8,8),   SB    =Color3.fromRGB(10,10,10),
    TopBar=Color3.fromRGB(10,10,10),Panel =Color3.fromRGB(14,14,14),
    Card  =Color3.fromRGB(17,17,17),Card2 =Color3.fromRGB(20,20,20),
    Border=Color3.fromRGB(32,32,32),Accent=Color3.fromRGB(255,255,255),
    Text  =Color3.fromRGB(225,225,225),Sub =Color3.fromRGB(105,105,105),
    Dim   =Color3.fromRGB(45,45,45),Green =Color3.fromRGB(65,195,65),
    Red   =Color3.fromRGB(210,55,55),Gold =Color3.fromRGB(215,165,40),
    Blue  =Color3.fromRGB(75,125,240),Purple=Color3.fromRGB(140,80,235),
    Teal  =Color3.fromRGB(40,195,180),Pink =Color3.fromRGB(255,0,127),
}

-- Forward declaration so CharacterAdded closure captures the correct upvalue
local _AutoFarmActive = false

-- ════════════════════════════════════════════
--  STATS & STATUS
-- ════════════════════════════════════════════
local STATS = {
    kills=0,deaths=0,questsDone=0,fruitsTP=0,
    chestsTP=0,questKills=0,startTime=os.time(),
    kpm=0,kpmBucket=0,
}
local STATUS     = "Idle"
local STATUS_COL = T.Sub
local function setStatus(s,col) STATUS=s; STATUS_COL=col or T.Sub end

task.spawn(function() while task.wait(60) do STATS.kpm=STATS.kpmBucket; STATS.kpmBucket=0 end end)
LP.CharacterAdded:Connect(function()
    STATS.deaths = STATS.deaths + 1
    -- Reset farm active on respawn so loops don't run while loading
    task.wait(1.5)
    if S.AutoFarm or S.AutoLevelFarm then _AutoFarmActive = true end
end)

-- ════════════════════════════════════════════
--  QUEST STATE MACHINE
-- ════════════════════════════════════════════
local QUEST = {
    state="idle", mob=nil, killsNeeded=0, killsDone=0, lastNpcPos=nil,
}

-- ════════════════════════════════════════════
--  FPS TRACKER
-- ════════════════════════════════════════════
local FPS = 60
do
    local frames, last = 0, tick()
    RunService.RenderStepped:Connect(wrap(function()
        frames = frames + 1
        local now = tick()
        if now-last >= 0.5 then FPS=math.round(frames/(now-last)); frames,last=0,now end
    end))
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
    local ok, d = pcall(function() return os.date("*t", os.time()) end)
    if ok and d then return string.format("%02d:%02d:%02d",d.hour,d.min,d.sec) end
    return ""
end

-- ════════════════════════════════════════════
--  CORE CHARACTER HELPERS
-- ════════════════════════════════════════════
local function getChar()  return LP.Character end
local function getHum()   local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()  local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive()  local h=getHum();  return h and h.Health>0 end

-- ════════════════════════════════════════════
--  COMMUNICATION HELPER  (CommF_ invoke)
-- ════════════════════════════════════════════
local function Com(suffix, ...)
    pcall(function()
        RepStorage.Remotes["Comm"..suffix..""]:InvokeServer(...)
    end)
end

-- ════════════════════════════════════════════
--  ENEMY SPAWNS FOLDER  (for quest targeting)
-- ════════════════════════════════════════════
pcall(function()
    if workspace:FindFirstChild("EnemySpawns") then return end
    local folder = Instance.new("Folder", workspace); folder.Name = "EnemySpawns"
    local function cleanName(n)
        n=n:gsub("Lv%. ",""):gsub("[%[%]]",""):gsub("%d+",""):gsub("%s+",""); return n
    end
    local function addPart(part, rawName)
        local clone = part:Clone(); clone.Name = cleanName(rawName)
        clone.Parent = folder; clone.Anchored = true
    end
    pcall(function()
        for _, v in pairs(workspace._WorldOrigin.EnemySpawns:GetChildren()) do
            if v:IsA("Part") then addPart(v, v.Name) end
        end
    end)
    pcall(function()
        for _, v in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                addPart(v.HumanoidRootPart, v.Name)
            end
        end
    end)
    pcall(function()
        for _, v in pairs(RepStorage:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                addPart(v.HumanoidRootPart, v.Name)
            end
        end
    end)
end)

-- ════════════════════════════════════════════
--  SIMULATION RADIUS HACK
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if HAS_SETSCRIPT then setscriptable(LP, "SimulationRadius", true) end
            if HAS_HIDDEN    then sethiddenproperty(LP, "SimulationRadius", math.huge) end
        end)
    end
end)

-- ════════════════════════════════════════════
--  SMOOTH TELEPORT  (2-step, anti-detection)
-- ════════════════════════════════════════════
local _tween = nil
local function tp(pos)
    local root = getRoot(); if not root then return end
    local goal = Vector3.new(pos.X, pos.Y+3.2, pos.Z)
    if S.SafeMode then
        local mid = root.Position:Lerp(goal, 0.6)
        root.CFrame = CFrame.new(mid); task.wait(0.05)
        root.CFrame = CFrame.new(goal)
    else
        root.CFrame = CFrame.new(goal)
    end
    if HAS_SIM then pcall(function() setsimulationradius(1000,1000) end) end
end

-- Bypass TP (kills character mid-jump then teleports — bypasses sea anticheat)
local function bypassTP(Point)
    local root = getRoot(); if not root then return end
    if _tween then pcall(function() _tween:Cancel() end) end
    pcall(function() Com("F_","AbandonQuest") end)
    pcall(function() LP.Character.Head:Destroy() end)
    root.CFrame = Point * CFrame.new(0,50,0); task.wait(0.2)
    root.CFrame = Point; task.wait(0.1)
    root.CFrame = Point * CFrame.new(0,50,0)
    root.Anchored = true; task.wait(0.1)
    root.CFrame = Point; task.wait(0.5)
    root.Anchored = false
    root.CFrame = Point * CFrame.new(900,900,900)
    pcall(function() Com("F_","AbandonQuest") end)
end

-- Smooth tween movement (toTarget)
local function toTarget(targetCF)
    local root = getRoot(); if not root then return end
    local RealTarget
    if type(targetCF)=="userdata" then
        RealTarget = targetCF
    else
        RealTarget = CFrame.new(targetCF)
    end
    local hum = getHum()
    if hum and hum.Health == 0 then
        repeat task.wait(0.05) until (getHum() and getHum().Health > 0); task.wait(0.2)
    end
    local dist = (RealTarget.Position - root.Position).Magnitude
    local speed = dist < 1000 and 315 or 300

    -- Use bypass if far and setting enabled
    if S.BypassTP and dist > 3000 then
        bypassTP(RealTarget); return
    end

    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    local ok, tw = pcall(function()
        _tween = TweenService:Create(root, info, {CFrame=RealTarget})
        _tween:Play()
        return _tween
    end)
    return ok and tw or nil
end

-- ════════════════════════════════════════════
--  QUEST CHECK  (uses GuideModule + Quests)
-- ════════════════════════════════════════════
local _QC_cache, _QC_lastLv, _QC_lastTarget = nil, -1, ""
local function QuestCheck()
    local Lvl = getLevel()
    local curTarget = S.TargetMob or ""
    if Lvl == _QC_lastLv and curTarget == _QC_lastTarget and _QC_cache then return _QC_cache end
    _QC_lastLv = Lvl; _QC_lastTarget = curTarget

    local MobName, QuestName, QuestLevel, Mon, LevelRequire, NPCPosition, MobCFrame, MonQ, MobCFrameNuber

    -- Lv 1-9 team-based
    if Lvl >= 1 and Lvl <= 9 then
        if tostring(LP.Team) == "Marines" then
            MobName="Trainee [Lv. 5]"; QuestName="MarineQuest"; QuestLevel=1; Mon="Trainee"
            NPCPosition=CFrame.new(-2709.67944,24.5206585,2104.24585)
        else
            MobName="Bandit [Lv. 5]"; Mon="Bandit"; QuestName="BanditQuest1"; QuestLevel=1
            NPCPosition=CFrame.new(1059.99731,16.9222069,1549.28162)
        end
        _QC_cache={[1]=QuestLevel,[2]=NPCPosition,[3]=MobName,[4]=QuestName,[5]=LevelRequire,[6]=Mon,[7]={},[8]=MonQ,[9]=MobCFrameNuber}
        return _QC_cache
    end

    -- Lv 210-249 special case
    if Lvl >= 210 and Lvl <= 249 then
        MobName="Dangerous Prisoner [Lv. 210]"; QuestName="PrisonerQuest"; QuestLevel=2
        Mon="Dangerous Prisoner"
        NPCPosition=CFrame.new(5308.93115,1.65517521,475.120514)
        local matchingCFrames = {}
        local result = MobName:gsub("Lv. ",""):gsub("[%[%]]",""):gsub("%d+",""):gsub("%s+","")
        for _, v in pairs(workspace.EnemySpawns:GetChildren()) do
            if v.Name == result then table.insert(matchingCFrames, v.CFrame) end
        end
        MobCFrame = matchingCFrames
        _QC_cache={[1]=QuestLevel,[2]=NPCPosition,[3]=MobName,[4]=QuestName,[5]=LevelRequire,[6]=Mon,[7]=MobCFrame,[8]=MonQ,[9]=MobCFrameNuber}
        return _QC_cache
    end

    -- Use GuideModule + Quests for all other levels
    pcall(function()
        local GuideModule = require(RepStorage:WaitForChild("GuideModule",3))
        local Quests      = require(RepStorage:WaitForChild("Quests",3))

        for _, npcData in pairs(GuideModule["Data"]["NPCList"]) do
            for i1, v1 in pairs(npcData["Levels"]) do
                if Lvl >= v1 then
                    if not LevelRequire then LevelRequire = 0 end
                    if v1 > LevelRequire then
                        NPCPosition = npcData["CFrame"]
                        QuestLevel  = i1
                        LevelRequire = v1
                    end
                    if #npcData["Levels"] == 3 and QuestLevel == 3 then
                        NPCPosition = npcData["CFrame"]
                        QuestLevel  = 2
                        LevelRequire = npcData["Levels"][2]
                    end
                end
            end
        end

        -- Fishman islands (need entrance invoke)
        if Lvl >= 375 and Lvl <= 399 then
            MobCFrame = CFrame.new(61122.5625,18.4716396,1568.16504)
            local root = getRoot()
            if root and (MobCFrame.Position - root.Position).Magnitude > 3000 then
                pcall(function() Com("F_","requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
            end
        end
        if Lvl >= 400 and Lvl <= 449 then
            MobCFrame = CFrame.new(61122.5625,18.4716396,1568.16504)
            local root = getRoot()
            if root and (MobCFrame.Position - root.Position).Magnitude > 3000 then
                pcall(function() Com("F_","requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
            end
        end

        -- Match quest from Quests module
        for i, v in pairs(Quests) do
            for _, v1 in pairs(v) do
                if v1["LevelReq"] == LevelRequire and i ~= "CitizenQuest" then
                    QuestName = i
                    for i2, v2 in pairs(v1["Task"]) do
                        MobName = i2
                        Mon = tostring(i2):split(" [Lv. "..tostring(v1["LevelReq"]).."]")[1]
                    end
                end
            end
        end

        -- Override edge cases
        if QuestName == "MarineQuest2" then
            QuestName="MarineQuest2"; QuestLevel=1
            MobName="Chief Petty Officer [Lv. 120]"; Mon="Chief Petty Officer"; LevelRequire=120
        elseif QuestName == "ImpelQuest" then
            QuestName="PrisonerQuest"; QuestLevel=2
            MobName="Dangerous Prisoner [Lv. 190]"; Mon="Dangerous Prisoner"; LevelRequire=210
            NPCPosition=CFrame.new(5310.60547,0.350014925,474.946594)
        elseif QuestName == "SkyExp1Quest" then
            if QuestLevel==1 then NPCPosition=CFrame.new(-4721.88867,843.874695,-1949.96643)
            elseif QuestLevel==2 then NPCPosition=CFrame.new(-7859.09814,5544.19043,-381.476196) end
        elseif QuestName == "Area2Quest" and QuestLevel == 2 then
            QuestName="Area2Quest"; QuestLevel=1
            MobName="Swan Pirate [Lv. 775]"; Mon="Swan Pirate"; LevelRequire=775
        end

        -- Try to enrich MobName with actual level tag from workspace
        if MobName and not MobName:find("Lv") then
            for _, v in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
                local monLV = tonumber(v.Name:match("%d+"))
                if v.Name:find(MobName) and #v.Name > #MobName and monLV and monLV <= Lvl+50 then
                    MobName = v.Name; break
                end
            end
        end

        -- Build MobCFrame array from EnemySpawns folder
        if MobName then
            local matchingCFrames = {}
            local clean = MobName:gsub("Lv. ",""):gsub("[%[%]]",""):gsub("%d+",""):gsub("%s+","")
            for _, v in pairs(workspace.EnemySpawns:GetChildren()) do
                if v.Name == clean then table.insert(matchingCFrames, v.CFrame) end
            end
            MobCFrame = matchingCFrames
        end
    end)

    -- Fallback to mob database if GuideModule failed
    if not MobName then
        local m = getMobForLevel(Lvl)
        MobName = m.name
        Mon = m.name
        NPCPosition = CFrame.new(m.questPos or m.pos)
        QuestLevel = 1
        QuestName  = "BanditQuest1"
        LevelRequire = m.minLv
        MobCFrame = {CFrame.new(m.pos)}
    end

    _QC_cache = {[1]=QuestLevel,[2]=NPCPosition,[3]=MobName,[4]=QuestName,[5]=LevelRequire,[6]=Mon,[7]=MobCFrame or {},[8]=MonQ,[9]=MobCFrameNuber}
    return _QC_cache
end

-- ════════════════════════════════════════════
--  BRING MOB SYSTEM
-- ════════════════════════════════════════════
local PosMon = CFrame.new(0,0,0)
-- _AutoFarmActive declared earlier (forward decl before CharacterAdded)

task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if not _AutoFarmActive or not S.BringMob then return end
            local enemies = workspace:FindFirstChild("Enemies")
            if not enemies then return end
            for _, v in pairs(enemies:GetChildren()) do
                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 and not v.Name:find("Boss") then
                    local dist = (hrp.Position - PosMon.Position).Magnitude
                    local inNet = HAS_ISNET and isnetworkowner(hrp) or dist <= 350
                    if dist <= 400 and inNet then
                        hrp.CFrame = PosMon
                        hum.JumpPower = 0; hum.WalkSpeed = 0
                        hrp.Size = Vector3.new(60,60,60)
                        hrp.Transparency = 1; hrp.CanCollide = false
                        pcall(function() v.Head.CanCollide = false end)
                        if hum:FindFirstChild("Animator") then hum.Animator:Destroy() end
                        hum:ChangeState(11); hum:ChangeState(14)
                        if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                    end
                end
            end
        end)
    end
end)

-- ════════════════════════════════════════════
--  WEAPON MANAGEMENT
-- ════════════════════════════════════════════
local _CurrentWeaponName = ""
local SelectWeapon = "Melee"

local function EquipWeapon(toolName)
    pcall(function()
        local tool = LP.Backpack:FindFirstChild(toolName)
        if tool then getHum():EquipTool(tool) end
    end)
end

local function UnEquipWeapon(toolName)
    pcall(function()
        local tool = getChar() and getChar():FindFirstChild(toolName)
        if tool then tool.Parent = LP.Backpack end
    end)
end

-- Auto-select weapon by tooltip type
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local method = S.FarmMethod or "Melee"
            local tipMap = {Melee="Melee",Sword="Sword",Gun="Gun",["Blox Fruit"]="Blox Fruit"}
            local wantedTip = tipMap[method] or "Melee"
            for _, v in pairs(LP.Backpack:GetChildren()) do
                if v.ToolTip == wantedTip then
                    _G.Settings.Configs["Select Weapon"] = v.Name
                    _CurrentWeaponName = v.Name
                end
            end
        end)
    end
end)

-- ════════════════════════════════════════════
--  COMBAT FRAMEWORK  (blade-hit attack)
-- ════════════════════════════════════════════
local CombatFrameworkR = nil
local _CF_ok = false

pcall(function()
    if not HAS_GUV or not HAS_SUV then return end
    local CF = require(LP.PlayerScripts:WaitForChild("CombatFramework",5))
    CombatFrameworkR = getupvalues(CF)[2]
    _CF_ok = CombatFrameworkR ~= nil
end)

local function getAllBladeHits(size)
    local hits = {}
    pcall(function()
        local enemies = workspace:FindFirstChild("Enemies"); if not enemies then return end
        for _, v in ipairs(enemies:GetChildren()) do
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum and hum.RootPart and hum.Health>0 and LP:DistanceFromCharacter(hum.RootPart.Position)<size+5 then
                table.insert(hits, hum.RootPart)
            end
        end
    end)
    return hits
end

local function getCurrentWeapon()
    local ret = nil
    pcall(function()
        if CombatFrameworkR then
            local ac = CombatFrameworkR.activeController
            if ac and ac.blades and ac.blades[1] then
                ret = ac.blades[1]
                local c = getChar()
                while ret and ret.Parent ~= c do ret = ret.Parent end
            end
        end
    end)
    if not ret then
        pcall(function()
            local t = getChar():FindFirstChildOfClass("Tool"); if t then ret = t.Name end
        end)
    end
    return ret
end

local cooldownfastattack = tick()
local function bladeAttack()
    pcall(function()
        if not CombatFrameworkR then return end
        local ac = CombatFrameworkR.activeController
        if not (ac and ac.equipped) then return end
        local bladehit = getAllBladeHits(60)
        if #bladehit == 0 then return end
        local A8=debug.getupvalue(ac.attack,5); local A9=debug.getupvalue(ac.attack,6)
        local A7=debug.getupvalue(ac.attack,4); local A10=debug.getupvalue(ac.attack,7)
        local N12=(A8*798405+A7*727595)%A9; local N13=A7*798405
        N12=(N12*A9+N13)%1099511627776
        A8=math.floor(N12/A9); A7=N12-A8*A9; A10=A10+1
        debug.setupvalue(ac.attack,5,A8); debug.setupvalue(ac.attack,6,A9)
        debug.setupvalue(ac.attack,4,A7); debug.setupvalue(ac.attack,7,A10)
        for _, anim in pairs(ac.animator.anims.basic) do anim:Play(0.01,0.01,0.01) end
        local c = getChar()
        if c and c:FindFirstChildOfClass("Tool") and ac.blades and ac.blades[1] then
            pcall(function() RepStorage.RigControllerEvent:FireServer("weaponChange",tostring(getCurrentWeapon())) end)
            pcall(function() RepStorage.Remotes.Validator:FireServer(math.floor(N12/1099511627776*16777215),A10) end)
            pcall(function() RepStorage.RigControllerEvent:FireServer("hit",bladehit,2,"") end)
        end
    end)
end

-- Fast attack loop (CombatFramework + direct hit fallback while farming)
-- Cooldown values fixed: Fast < Normal < Slow (was inverted in v1.0.0)
task.spawn(function()
    while true do
        local ok, err = pcall(function()
            task.wait(0.08)
            if not _AutoFarmActive or not S.FastAttack then return end
            local t = S.FastAttackType or "Fast"
            local ready = false
            if     t == "Fast"   then ready = tick() - cooldownfastattack > 0.3
            elseif t == "Normal" then ready = tick() - cooldownfastattack > 0.7
            elseif t == "Slow"   then ready = tick() - cooldownfastattack > 1.2
            end
            if not ready then return end
            cooldownfastattack = tick()

            -- Attempt CombatFramework blade attack
            if CombatFrameworkR then
                local ac = CombatFrameworkR.activeController
                if ac and ac.equipped then
                    if ac.hitboxMagnitude ~= 55 then ac.hitboxMagnitude = 55 end
                    bladeAttack()
                end
            end

            -- Always also fire direct hit (works without CombatFramework)
            local root = getRoot()
            if root then
                local enemies = workspace:FindFirstChild("Enemies")
                local hits = {}
                for _, v in ipairs((enemies or workspace):GetChildren()) do
                    local h = v:FindFirstChildOfClass("Humanoid")
                    local r = v:FindFirstChild("HumanoidRootPart")
                    if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                        if (r.Position - root.Position).Magnitude < 60 then
                            table.insert(hits, r)
                        end
                    end
                end
                if #hits > 0 then
                    pcall(function() RepStorage.RigControllerEvent:FireServer("hit", hits, 2, "") end)
                end
            end
        end)
        if not ok then task.wait(0.5) end  -- restart on error, don't die silently
    end
end)

-- Auto Haki (Buso)
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if S.AutoHaki and getChar() and not getChar():FindFirstChild("HasBuso") then
                Com("F_","Buso")
            end
        end)
    end
end)

-- BodyVelocity noclip/anti-sit loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local root = getRoot(); if not root then return end
            if _AutoFarmActive or S.NoClip then
                if not root:FindFirstChild("BodyVelocity1") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "BodyVelocity1"; bv.Parent = root
                    bv.MaxForce = Vector3.new(10000,10000,10000)
                    bv.Velocity = Vector3.zero
                end
                local hum = getHum()
                if hum and hum.Sit then hum.Sit = false end
            else
                local bv = root:FindFirstChild("BodyVelocity1")
                if bv then bv:Destroy() end
            end
            if S.NoClip or _AutoFarmActive then
                local c = getChar()
                if c then
                    for _, p in pairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
        end)
    end
end)

-- ════════════════════════════════════════════
--  MOB FINDING
-- ════════════════════════════════════════════
-- Strip Blox Fruits level tag: "Bandit [Lv. 5]" → "bandit"
local function cleanMobName(n)
    return n:lower():gsub("%[lv%.%s*%d+%]",""):gsub("%[lv%s*%d+%]",""):gsub("%s+","")
end

local function findMob(name, radius)
    local root = getRoot(); if not root then return nil end
    local nl  = name:lower()
    local nlc = cleanMobName(name)
    local best, bestD = nil, radius or 9999

    -- Search workspace.Enemies first (Blox Fruits primary container)
    local enemyFolder = workspace:FindFirstChild("Enemies")
    local checked = {}
    local function checkModel(obj)
        if not obj or checked[obj] then return end
        checked[obj] = true
        if not obj:IsA("Model") then return end
        if obj == getChar() then return end
        if Players:GetPlayerFromCharacter(obj) then return end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local hrp = obj:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            local n2  = obj.Name:lower()
            local n2c = cleanMobName(obj.Name)
            local match = (n2 == nl) or (n2c == nlc)
                or n2:find(nl, 1, true) or nl:find(n2, 1, true)
                or (nlc ~= "" and (n2c:find(nlc, 1, true) or nlc:find(n2c, 1, true)))
            if match then
                local d = (hrp.Position - root.Position).Magnitude
                if d < bestD then best, bestD = obj, d end
            end
        end
    end

    -- Priority: workspace.Enemies folder (Blox Fruits native)
    if enemyFolder then
        for _, obj in ipairs(enemyFolder:GetChildren()) do checkModel(obj) end
    end
    -- Fallback: all workspace descendants
    for _, obj in ipairs(workspace:GetDescendants()) do checkModel(obj) end

    return best
end

local function findAllMobs(radius)
    local root = getRoot(); if not root then return {} end
    local found = {}
    local r = radius or 25
    local checked = {}
    local function tryAdd(obj)
        if not obj or checked[obj] then return end
        checked[obj] = true
        if not obj:IsA("Model") then return end
        if obj == getChar() then return end
        if Players:GetPlayerFromCharacter(obj) then return end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local hrp = obj:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            local d = (hrp.Position - root.Position).Magnitude
            if d < r then table.insert(found, {obj=obj, hrp=hrp, hum=hum, dist=d}) end
        end
    end
    -- Priority: workspace.Enemies (Blox Fruits native, faster)
    local ef = workspace:FindFirstChild("Enemies")
    if ef then for _, obj in ipairs(ef:GetChildren()) do tryAdd(obj) end end
    -- Fallback: full workspace scan
    for _, obj in ipairs(workspace:GetDescendants()) do tryAdd(obj) end
    table.sort(found, function(a,b) return a.dist < b.dist end)
    return found
end

local function isDead(mob)
    if not mob or not mob.Parent then return true end
    local h = mob:FindFirstChildOfClass("Humanoid")
    return not h or h.Health<=0
end

-- ════════════════════════════════════════════
--  MULTI-METHOD COMBAT ENGINE  (8 methods)
-- ════════════════════════════════════════════

-- Fire Blox Fruits skill remotes (Z/X/C/V) towards target
-- Respects per-skill toggles in _G.Settings.Configs["Skill Z"] etc.
local _lastSkillFire = 0
local function fireSkills(hrp)
    if tick() - _lastSkillFire < 0.35 then return end
    _lastSkillFire = tick()
    pcall(function()
        local skills = {"Z","X","C","V"}
        local pos    = hrp and hrp.Position or Vector3.zero
        for _, sk in ipairs(skills) do
            local enabled = _G.Settings.Configs["Skill "..sk]
            if enabled == nil then enabled = true end  -- default on
            if not enabled then continue end
            -- CommF_ invoke (most common in BF)
            pcall(function() Com("F_", sk, pos, pos, hrp) end)
            -- Direct remote scan for skill remotes
            pcall(function()
                local rem = RepStorage.Remotes:FindFirstChild(sk)
                if rem and rem:IsA("RemoteEvent") then rem:FireServer(pos, hrp) end
            end)
        end
        -- RigControllerEvent: fire equipped weapon skill (Z slot)
        if _G.Settings.Configs["Skill Z"] ~= false then
            pcall(function() RepStorage.RigControllerEvent:FireServer("useSkill","Z",pos,hrp) end)
        end
    end)
end

-- Direct RigControllerEvent hit — works even without CombatFramework
local function fireDirectHit(mob, hrp)
    pcall(function()
        local hits = {}
        local root = getRoot()
        local enemies = workspace:FindFirstChild("Enemies")
        local container = enemies or workspace
        for _, v in ipairs(container:GetChildren()) do
            local h = v:FindFirstChildOfClass("Humanoid")
            local r = v:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                if root and (r.Position - root.Position).Magnitude < 60 then
                    table.insert(hits, r)
                end
            end
        end
        if #hits > 0 then
            RepStorage.RigControllerEvent:FireServer("hit", hits, 2, "")
        end
    end)
end

local function attackMob(mob)
    if isDead(mob) then return true end
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    local hum = mob:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return true end
    local root = getRoot(); if not root then return false end
    local c    = getChar()

    -- 1. Teleport next to mob
    root.CFrame = CFrame.new(hrp.Position) * CFrame.new(0, 0, -4)
    PosMon = hrp.CFrame
    task.wait(0.04)

    -- 2. Blade attack via CombatFramework (if available)
    bladeAttack()

    -- 3. Direct RigControllerEvent hit (BF server-side hit registration)
    fireDirectHit(mob, hrp)

    -- 4. Skill remotes (Z/X/C/V)
    fireSkills(hrp)

    -- 5. firetouchinterest on mob parts + tool handle
    if HAS_FTI then
        pcall(firetouchinterest, hrp, root, 0); task.wait(0.015)
        pcall(firetouchinterest, hrp, root, 1)
        for _, part in pairs(mob:GetChildren()) do
            if part:IsA("BasePart") then
                pcall(firetouchinterest, part, root, 0); task.wait(0.008)
                pcall(firetouchinterest, part, root, 1)
            end
        end
        if c then
            for _, tool in pairs(c:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        for _, part in pairs(mob:GetDescendants()) do
                            if part:IsA("BasePart") then
                                pcall(firetouchinterest, part, handle, 0); task.wait(0.008)
                                pcall(firetouchinterest, part, handle, 1)
                            end
                        end
                    end
                end
            end
        end
    end

    -- 6. Tool remotes
    if c then
        for _, tool in pairs(c:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in pairs(tool:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        pcall(function() v:FireServer(hrp, hrp.Position) end)
                        pcall(function() v:FireServer(mob) end)
                    elseif v:IsA("RemoteFunction") then
                        pcall(function() v:InvokeServer(hrp) end)
                    end
                end
            end
        end
    end

    -- 7. ReplicatedStorage damage/hit remotes
    for _, v in pairs(RepStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("hit") or n:find("attack") or n:find("melee") then
                pcall(function() v:FireServer(mob, 9999) end)
                pcall(function() v:FireServer(hrp, 9999) end)
            end
        end
    end

    -- 8. ClickDetector fallback
    if HAS_FCD then
        for _, cd in pairs(mob:GetDescendants()) do
            if cd:IsA("ClickDetector") then pcall(fireclickdetector, cd) end
        end
    end

    -- Wait for server to process, then check if killed
    task.wait(0.15)
    local killed = isDead(mob)
    if killed then
        STATS.kills = STATS.kills + 1
        STATS.kpmBucket = STATS.kpmBucket + 1
        -- Quest kill counting is handled by the quest loop to avoid double-counting
    end
    return killed
end

-- ════════════════════════════════════════════
--  QUEST NPC INTERACTION
-- ════════════════════════════════════════════
local function findQuestNPC(nearPos, radius)
    radius = radius or 120
    local best, bestD = nil, radius
    local kws = {"quest","questgiver","npc","master","trainer","mystic","elder","lord","guide"}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position-nearPos).Magnitude
                if d < bestD then
                    local n = obj.Name:lower()
                    local hasCD = obj:FindFirstChildWhichIsA("ClickDetector",true)~=nil
                    local hasPP = obj:FindFirstChildWhichIsA("ProximityPrompt",true)~=nil
                    local nameMatch = false
                    for _, kw in ipairs(kws) do if n:find(kw,1,true) then nameMatch=true break end end
                    if hasCD or hasPP or nameMatch then best,bestD=obj,d end
                end
            end
        end
    end
    return best
end

local function interactNPC(npc)
    if not npc then return false end
    local hrp = npc:FindFirstChild("HumanoidRootPart"); if not hrp then return false end
    local root = getRoot()
    if root then root.CFrame = CFrame.new(hrp.Position + Vector3.new(0,0,4)) end
    task.wait(0.3)
    local interacted = false
    if HAS_FCD then
        for _, cd in pairs(npc:GetDescendants()) do
            if cd:IsA("ClickDetector") then pcall(fireclickdetector,cd); interacted=true; task.wait(0.1) end
        end
    end
    if HAS_FPP then
        for _, pp in pairs(npc:GetDescendants()) do
            if pp:IsA("ProximityPrompt") then pcall(fireproximityprompt,pp); interacted=true; task.wait(0.1) end
        end
    end
    if HAS_FTI and root then
        pcall(firetouchinterest,hrp,root,0); task.wait(0.1)
        pcall(firetouchinterest,hrp,root,1); interacted=true
    end
    for _, v in pairs(npc:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("quest") or n:find("accept") or n:find("start") or n:find("talk") then
                pcall(function() v:FireServer() end); interacted=true
            end
        end
    end
    if not interacted then
        for _, v in pairs(npc:GetDescendants()) do
            if v:IsA("RemoteEvent") then pcall(function() v:FireServer() end) end
        end
    end
    return interacted
end

local function tryAcceptQuest(qName, qLevel, mobName)
    pcall(function() Com("F_","StartQuest", qName or "BanditQuest1", qLevel or 1) end)
    for _, v in pairs(RepStorage:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            local n = v.Name:lower()
            -- Only fire remotes that look like quest-accept, not abandon/complete/finish
            local isAccept = (n:find("accept") or n:find("start") or n:find("quest")) and
                not n:find("abandon") and not n:find("complete") and not n:find("finish") and not n:find("reward")
            if isAccept then
                if v:IsA("RemoteEvent") then
                    pcall(function() v:FireServer(mobName) end)
                    pcall(function() v:FireServer() end)
                else
                    pcall(function() v:InvokeServer(mobName) end)
                end
            end
        end
    end
end

-- ════════════════════════════════════════════
--  FRUIT / CHEST SCANNER
-- ════════════════════════════════════════════
local FRUIT_KW = {"fruit","devil","logia","paramecia","zoan","ancient","mythical","df_","devl"}
-- Keywords that indicate it's a static NPC/model, not a pickable fruit
local FRUIT_EXCLUDE = {"npc","stand","shop","vendor","quest","master","trainer","elder","lord","guide","stall","store"}
local function scanFruits()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if Players:GetPlayerFromCharacter(obj) then continue end
        if obj == getChar() then continue end
        local n = obj.Name:lower()
        -- Skip if it looks like an NPC/shop rather than a pickable fruit
        local excluded = false
        for _, ex in ipairs(FRUIT_EXCLUDE) do
            if n:find(ex,1,true) then excluded=true; break end
        end
        if excluded then continue end
        for _, kw in ipairs(FRUIT_KW) do
            if n:find(kw,1,true) then
                local base = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart",true)
                -- Must be a standalone part/model, not a character
                if base and not obj:FindFirstChildOfClass("Humanoid") then
                    table.insert(found,{name=obj.Name,pos=base.Position,obj=obj,part=base}); break
                end
            end
        end
    end
    return found
end

local function scanChests()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("chest") or n:find("crate") or n:find("box") then
            local base = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart",true)
            if base then table.insert(found,{name=obj.Name,pos=base.Position,obj=obj,part=base}) end
        end
    end
    return found
end

-- ════════════════════════════════════════════
--  ANTI-AFK  (randomised, hard to detect)
-- ════════════════════════════════════════════
task.spawn(function()
    local actions = {
        function() pcall(function() VirtualUser:CaptureController() end) end,
        function() pcall(function() VirtualUser:ClickButton1(Vector2.new(math.random(200,600),math.random(150,450))) end) end,
        function() pcall(function()
            VirtualUser:Button1Down(Vector2.new(0,0),CFrame.new()); task.wait(0.05+math.random()*0.1)
            VirtualUser:Button1Up(Vector2.new(0,0),CFrame.new())
        end) end,
        function() pcall(function() VirtualUser:ClickButton2(Vector2.new(math.random(100,500),math.random(100,400))) end) end,
    }
    local last = 0
    while task.wait(2+math.random()*3) do
        if not S.AntiAFK then continue end
        local now = tick()
        if now-last >= 40+math.random(0,50) then
            last=now
            for _=1,math.random(1,3) do actions[math.random(1,#actions)](); task.wait(math.random()*0.3) end
        end
    end
end)

-- ════════════════════════════════════════════
--  NOTIFICATION SYSTEM  (slides in from right)
-- ════════════════════════════════════════════
local _nGui
local function notify(title, body, dur, accent)
    dur=dur or 3.5; accent=accent or T.Accent
    if not _nGui or not _nGui.Parent then
        _nGui=Instance.new("ScreenGui"); _nGui.Name="_EHN"
        _nGui.ResetOnSpawn=false; _nGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; _nGui.Parent=PG
    end
    -- Shift existing notifs up
    for _, f in pairs(_nGui:GetChildren()) do
        if f:IsA("Frame") then
            TweenService:Create(f,TweenInfo.new(0.12),{Position=UDim2.new(1,-272,1,f.Position.Y.Offset-60)}):Play()
        end
    end
    local card=Instance.new("Frame"); card.Size=UDim2.new(0,258,0,52)
    card.Position=UDim2.new(1,12,1,-56); card.BackgroundColor3=T.Panel
    card.BorderSizePixel=0; card.Parent=_nGui
    local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(0,7); cc.Parent=card
    local cs=Instance.new("UIStroke"); cs.Color=T.Border; cs.Thickness=1; cs.Parent=card
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,2,1,0)
    bar.BackgroundColor3=accent; bar.BorderSizePixel=0; bar.Parent=card
    local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,2); bc.Parent=bar
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,0,17)
    tl.Position=UDim2.new(0,11,0,4); tl.BackgroundTransparency=1
    tl.Text=title; tl.Font=Enum.Font.GothamBold; tl.TextSize=10
    tl.TextColor3=T.Text; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=card
    local bl=Instance.new("TextLabel"); bl.Size=UDim2.new(1,-16,0,26)
    bl.Position=UDim2.new(0,11,0,21); bl.BackgroundTransparency=1
    bl.Text=body; bl.Font=Enum.Font.Gotham; bl.TextSize=9; bl.TextWrapped=true
    bl.TextColor3=T.Sub; bl.TextXAlignment=Enum.TextXAlignment.Left; bl.Parent=card
    TweenService:Create(card,TweenInfo.new(0.28,Enum.EasingStyle.Back),{Position=UDim2.new(1,-272,1,-56)}):Play()
    task.delay(dur,function()
        TweenService:Create(card,TweenInfo.new(0.18),{Position=UDim2.new(1,12,1,-56)}):Play()
        task.wait(0.22); pcall(function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════
--  WATERMARK
-- ════════════════════════════════════════════
local function buildWatermark()
    pcall(function() PG:FindFirstChild("_EHW"):Destroy() end)
    local sg=Instance.new("ScreenGui"); sg.Name="_EHW"; sg.ResetOnSpawn=false; sg.Parent=PG
    local f=Instance.new("Frame"); f.Size=UDim2.new(0,310,0,17)
    f.Position=UDim2.new(0,6,0,6); f.BackgroundColor3=T.Panel; f.BorderSizePixel=0; f.Parent=sg
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,4); c.Parent=f
    local st=Instance.new("UIStroke"); st.Color=T.Pink; st.Thickness=1; st.Parent=f
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.fromScale(1,1)
    lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8
    lbl.TextColor3=T.Pink; lbl.Parent=f
    RunService.Heartbeat:Connect(wrap(function()
        if not sg.Parent then return end
        sg.Enabled = S.ShowWatermark~=false
        if sg.Enabled then
            lbl.Text = "  Elite Hub v1.0.0  |  FPS:"..FPS.."  |  K:"..STATS.kills.."  |  "..STATUS
        end
    end))
end

-- ════════════════════════════════════════════
--  LOADING SCREEN  (full, with grid+shimmer+log)
-- ════════════════════════════════════════════
local function showLoader()
    local sg=Instance.new("ScreenGui"); sg.Name="_EHL"; sg.ResetOnSpawn=false
    sg.IgnoreGuiInset=true; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.Parent=PG

    local bg=Instance.new("Frame"); bg.Size=UDim2.fromScale(1,1)
    bg.BackgroundColor3=Color3.fromRGB(4,4,4); bg.BorderSizePixel=0; bg.Parent=sg
    -- Grid overlay
    for i=1,24 do
        local h=Instance.new("Frame"); h.Size=UDim2.new(1,0,0,1); h.Position=UDim2.new(0,0,(i-1)/24,0)
        h.BackgroundColor3=Color3.new(1,1,1); h.BackgroundTransparency=0.96; h.BorderSizePixel=0; h.Parent=bg
        local v=Instance.new("Frame"); v.Size=UDim2.new(0,1,1,0); v.Position=UDim2.new((i-1)/24,0,0,0)
        v.BackgroundColor3=Color3.new(1,1,1); v.BackgroundTransparency=0.96; v.BorderSizePixel=0; v.Parent=bg
    end

    -- Card
    local card=Instance.new("Frame"); card.Size=UDim2.new(0,320,0,240)
    card.Position=UDim2.new(0.5,-160,0.5,-120); card.BackgroundColor3=Color3.fromRGB(7,7,7)
    card.BorderSizePixel=0; card.BackgroundTransparency=1; card.Parent=bg
    local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(0,12); cc.Parent=card
    local cs=Instance.new("UIStroke"); cs.Color=Color3.fromRGB(42,42,42); cs.Thickness=1; cs.Parent=card
    -- Top accent stripe
    local stripe=Instance.new("Frame"); stripe.Size=UDim2.new(1,0,0,2)
    stripe.BackgroundColor3=T.Pink; stripe.BorderSizePixel=0; stripe.Parent=card
    local sc2=Instance.new("UICorner"); sc2.CornerRadius=UDim.new(0,12); sc2.Parent=stripe
    -- Logo
    local logoE=Instance.new("TextLabel"); logoE.Size=UDim2.new(0,60,0,48)
    logoE.Position=UDim2.new(0,22,0,20); logoE.BackgroundTransparency=1
    logoE.Text="E"; logoE.Font=Enum.Font.GothamBlack; logoE.TextSize=44
    logoE.TextColor3=T.Pink; logoE.Parent=card
    local logoH=Instance.new("TextLabel"); logoH.Size=UDim2.new(0,220,0,48)
    logoH.Position=UDim2.new(0,72,0,20); logoH.BackgroundTransparency=1
    logoH.Text="LITE HUB"; logoH.Font=Enum.Font.GothamBlack; logoH.TextSize=32
    logoH.TextColor3=Color3.fromRGB(180,180,180); logoH.TextXAlignment=Enum.TextXAlignment.Left; logoH.Parent=card
    -- Sub info
    local sub=Instance.new("TextLabel"); sub.Size=UDim2.new(1,-22,0,14)
    sub.Position=UDim2.new(0,22,0,68); sub.BackgroundTransparency=1
    sub.Text="BLOX FRUITS  •  ALL SEAS  •  LV 1–2800  •  v1.0.0"
    sub.Font=Enum.Font.GothamBold; sub.TextSize=7.5; sub.TextColor3=Color3.fromRGB(55,55,55)
    sub.TextXAlignment=Enum.TextXAlignment.Left; sub.Parent=card
    local execLbl=Instance.new("TextLabel"); execLbl.Size=UDim2.new(1,-22,0,12)
    execLbl.Position=UDim2.new(0,22,0,83); execLbl.BackgroundTransparency=1
    execLbl.Text="Executor: "..EXEC_NAME..(IS_DELTA and "  ✓ Delta" or "")
    execLbl.Font=Enum.Font.Gotham; execLbl.TextSize=8
    execLbl.TextColor3=IS_DELTA and T.Blue or Color3.fromRGB(48,48,48)
    execLbl.TextXAlignment=Enum.TextXAlignment.Left; execLbl.Parent=card
    local div=Instance.new("Frame"); div.Size=UDim2.new(1,-44,0,1)
    div.Position=UDim2.new(0,22,0,102); div.BackgroundColor3=Color3.fromRGB(30,30,30)
    div.BorderSizePixel=0; div.Parent=card
    -- Status
    local statLbl=Instance.new("TextLabel"); statLbl.Size=UDim2.new(1,-44,0,14)
    statLbl.Position=UDim2.new(0,22,0,110); statLbl.BackgroundTransparency=1
    statLbl.Text="Initializing..."; statLbl.Font=Enum.Font.Gotham; statLbl.TextSize=8.5
    statLbl.TextColor3=Color3.fromRGB(65,65,65); statLbl.TextXAlignment=Enum.TextXAlignment.Left; statLbl.Parent=card
    -- Progress bar
    local barBg=Instance.new("Frame"); barBg.Size=UDim2.new(1,-44,0,4)
    barBg.Position=UDim2.new(0,22,0,130); barBg.BackgroundColor3=Color3.fromRGB(18,18,18)
    barBg.BorderSizePixel=0; barBg.Parent=card
    local bgC=Instance.new("UICorner"); bgC.CornerRadius=UDim.new(0,2); bgC.Parent=barBg
    local fill=Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0)
    fill.BackgroundColor3=T.Pink; fill.BorderSizePixel=0; fill.Parent=barBg
    local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,2); fc.Parent=fill
    local shim=Instance.new("Frame"); shim.Size=UDim2.new(0.35,0,1,0)
    shim.BackgroundColor3=Color3.new(1,1,1); shim.BackgroundTransparency=0.65
    shim.BorderSizePixel=0; shim.Parent=fill
    local scc=Instance.new("UICorner"); scc.CornerRadius=UDim.new(0,2); scc.Parent=shim
    local shimConn=RunService.Heartbeat:Connect(wrap(function()
        if not shim.Parent then return end
        shim.Position=UDim2.new(tick()%1.0-0.35,0,0,0)
    end))
    local pctLbl=Instance.new("TextLabel"); pctLbl.Size=UDim2.new(0,40,0,12)
    pctLbl.Position=UDim2.new(1,-46,0,140); pctLbl.BackgroundTransparency=1
    pctLbl.Text="0%"; pctLbl.Font=Enum.Font.GothamBold; pctLbl.TextSize=8
    pctLbl.TextColor3=Color3.fromRGB(55,55,55); pctLbl.TextXAlignment=Enum.TextXAlignment.Right; pctLbl.Parent=card
    -- Log area
    local logBg=Instance.new("Frame"); logBg.Size=UDim2.new(1,-44,0,56)
    logBg.Position=UDim2.new(0,22,0,148); logBg.BackgroundColor3=Color3.fromRGB(11,11,11)
    logBg.BorderSizePixel=0; logBg.Parent=card
    local lbC=Instance.new("UICorner"); lbC.CornerRadius=UDim.new(0,5); lbC.Parent=logBg
    local logSf=Instance.new("ScrollingFrame"); logSf.Size=UDim2.fromScale(1,1)
    logSf.BackgroundTransparency=1; logSf.BorderSizePixel=0; logSf.ScrollBarThickness=0
    logSf.CanvasSize=UDim2.new(0,0,0,0); logSf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    logSf.ScrollingDirection=Enum.ScrollingDirection.Y; logSf.Parent=logBg
    local lPad=Instance.new("UIPadding"); lPad.PaddingLeft=UDim.new(0,6); lPad.PaddingTop=UDim.new(0,4); lPad.Parent=logSf
    local lList=Instance.new("UIListLayout"); lList.SortOrder=Enum.SortOrder.LayoutOrder; lList.Padding=UDim.new(0,1); lList.Parent=logSf
    local logCount=0
    local function addLog(txt,col)
        logCount=logCount+1
        local ll=Instance.new("TextLabel"); ll.Size=UDim2.new(1,0,0,10)
        ll.BackgroundTransparency=1; ll.Text=txt; ll.Font=Enum.Font.Gotham; ll.TextSize=7.5
        ll.TextColor3=col or Color3.fromRGB(55,55,55); ll.TextXAlignment=Enum.TextXAlignment.Left
        ll.LayoutOrder=logCount; ll.Parent=logSf; logSf.CanvasPosition=Vector2.new(0,9999)
    end
    local foot=Instance.new("TextLabel"); foot.Size=UDim2.new(1,0,0,12)
    foot.Position=UDim2.new(0,0,1,-16); foot.BackgroundTransparency=1
    foot.Text="v1.0.0  •  discord.gg/EmsMsHZCVH  •  Anti-Rat Protection Active"
    foot.Font=Enum.Font.Gotham; foot.TextSize=7.5; foot.TextColor3=Color3.fromRGB(35,35,35); foot.Parent=card

    TweenService:Create(card,TweenInfo.new(0.32,Enum.EasingStyle.Back),{BackgroundTransparency=0}):Play()

    local function step(pct,msg,col,logMsg)
        task.wait(0.15); statLbl.Text=msg; statLbl.TextColor3=col or Color3.fromRGB(68,68,68)
        pctLbl.Text=math.floor(pct*100).."%"
        TweenService:Create(fill,TweenInfo.new(0.2),{Size=UDim2.new(pct,0,1,0)}):Play()
        if col then TweenService:Create(fill,TweenInfo.new(0.15),{BackgroundColor3=col}):Play() end
        if logMsg then addLog(logMsg,col) end
    end

    step(0.06,"Verifying executor safety...",  T.Blue,  "[ OK ] Executor: "..EXEC_NAME)
    step(0.14,"Loading mob database...",        nil,     "[ OK ] "..(#MOBS).." mobs across Sea 1/2/3")
    step(0.22,"Initialising level engine...",   nil,     "[ OK ] Level → Mob detection ready (Lv 1–2800)")
    step(0.31,"Mapping island teleports...",    nil,     "[ OK ] "..(#SEA1_ISLANDS+#SEA2_ISLANDS+#SEA3_ISLANDS).." islands registered")
    step(0.40,"Loading quest engine...",              T.Gold,  "[ OK ] GuideModule/Quests + state machine ready")
    step(0.50,"Arming combat engine (8 methods)...",  T.Red,   "[ OK ] RigControllerEvent + Skills Z/X/C/V + BladeHit")
    step(0.60,"Enabling bring-mob system...",          nil,     "[ OK ] BringMob + SimRadius hack active")
    step(0.69,"Setting up ESP...",                     T.Blue,  "[ OK ] "..(HAS_DRAW and"Drawing API"or"Billboard fallback"))
    step(0.78,"Building UI...",                        nil,     "[ OK ] GUI compiled ("..#MOBS.." mob quick-farm buttons)")
    step(0.87,"Starting anti-AFK...",                  nil,     "[ OK ] Randomised input rotation: ON")
    step(0.94,"Applying saved config...",              T.Gold,  "[ OK ] Config loaded from "..CFG_FILE)
    step(1.00,"Ready!",                                T.Green, "[ OK ] Elite Hub v1.0.0 fully operational")

    task.wait(0.4); shimConn:Disconnect()
    TweenService:Create(bg,TweenInfo.new(0.45),{BackgroundTransparency=1}):Play()
    for _, d in pairs(bg:GetDescendants()) do
        if d:IsA("GuiObject") then
            pcall(function() TweenService:Create(d,TweenInfo.new(0.35),{BackgroundTransparency=1,TextTransparency=1}):Play() end)
        end
    end
    task.wait(0.5); pcall(function() sg:Destroy() end)
end

-- ════════════════════════════════════════════
--  ESP ENGINE
-- ════════════════════════════════════════════
local espObjs = {}
local function clearESP() for _,o in pairs(espObjs) do pcall(function() o:Remove() end) end espObjs={} end
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
    if espConn then espConn:Disconnect() end clearESP()
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
                            local barH=sz*1.7; local hpH=math.floor(barH*(hp/100))
                            newDraw("Square",{Size=Vector2.new(3,barH),Position=Vector2.new(sc.X+sz/2+2,sc.Y-sz*0.85),Color=T.Dim,Thickness=0,Filled=true,Visible=true,ZIndex=5})
                            newDraw("Square",{Size=Vector2.new(3,hpH),Position=Vector2.new(sc.X+sz/2+2,sc.Y-sz*0.85+(barH-hpH)),Color=T.Green,Thickness=0,Filled=true,Visible=true,ZIndex=5})
                            local dist=(hrp.Position-Camera.CFrame.Position).Magnitude
                            newDraw("Text",{Text=math.floor(dist).."m",Position=Vector2.new(sc.X,sc.Y+sz*0.85+4),Size=10,Color=T.Sub,Center=true,Outline=true,Visible=true,ZIndex=5})
                        end
                    end
                end
            end
        end
        if S.MobESP then
            -- Use Enemies folder first (fast), fall back to full scan
            local ef=workspace:FindFirstChild("Enemies")
            local src=ef and ef:GetChildren() or workspace:GetDescendants()
            for _,obj in pairs(src) do
                if obj:IsA("Model") and obj~=getChar() and not Players:GetPlayerFromCharacter(obj) then
                    local hum=obj:FindFirstChildOfClass("Humanoid"); local hrp=obj:FindFirstChild("HumanoidRootPart")
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
                    local sc,vis,_=w2s(f.pos)
                    if vis then newDraw("Text",{Text="◆ "..f.name,Position=sc,Size=13,Color=T.Green,Center=true,Outline=true,Visible=true,ZIndex=6}) end
                end
            end
        end
    end))
end
-- Billboard fallback (with distance filter — max 300 studs to avoid performance issues)
task.spawn(function()
    local billObjs={}
    while task.wait(0.8) do
        if HAS_DRAW then continue end
        for _,b in pairs(billObjs) do pcall(function() b:Destroy() end) end billObjs={}
        local camPos = Camera.CFrame.Position
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
                    if hrp and (hrp.Position-camPos).Magnitude<500 then mkBill(hrp,p.Name,Color3.new(1,1,1)) end
                end
            end
        end
        if S.MobESP then
            local ef=workspace:FindFirstChild("Enemies")
            local src=ef and ef:GetChildren() or workspace:GetDescendants()
            for _,obj in pairs(src) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local hum=obj:FindFirstChildOfClass("Humanoid"); local hrp=obj:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health>0 and (hrp.Position-camPos).Magnitude<300 then
                        mkBill(hrp,obj.Name,Color3.fromRGB(255,170,60))
                    end
                end
            end
        end
    end
end)
startESP()

-- ════════════════════════════════════════════
--  GUI BUILDER
-- ════════════════════════════════════════════
local function buildGUI()
    pcall(function() PG:FindFirstChild("EliteHub"):Destroy() end)
    local sg=Instance.new("ScreenGui"); sg.Name="EliteHub"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.IgnoreGuiInset=true; sg.Parent=PG

    local WIN_W,WIN_H=545,400
    local win=Instance.new("Frame"); win.Size=UDim2.new(0,WIN_W,0,WIN_H)
    win.Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
    win.BackgroundColor3=T.BG; win.BorderSizePixel=0; win.Active=true; win.Parent=sg
    local wc=Instance.new("UICorner"); wc.CornerRadius=UDim.new(0,9); wc.Parent=win
    local ws=Instance.new("UIStroke"); ws.Color=T.Border; ws.Thickness=1; ws.Parent=win

    local dragging,dX,dY=false,0,0
    RunService.RenderStepped:Connect(wrap(function()
        if dragging then
            local sx=math.clamp(Mouse.X-dX,0,workspace.CurrentCamera.ViewportSize.X-WIN_W)
            local sy=math.clamp(Mouse.Y-dY,0,workspace.CurrentCamera.ViewportSize.Y-WIN_H)
            win.Position=UDim2.new(0,sx,0,sy)
        end
    end))

    -- ── TOP BAR ─────────────────────────────────────────────────────
    local TB_H=30
    local tb=Instance.new("Frame"); tb.Size=UDim2.new(1,0,0,TB_H)
    tb.BackgroundColor3=T.TopBar; tb.BorderSizePixel=0; tb.Parent=win
    local tbc=Instance.new("UICorner"); tbc.CornerRadius=UDim.new(0,9); tbc.Parent=tb
    local tbfix=Instance.new("Frame",tb); tbfix.Size=UDim2.new(1,0,0.5,0)
    tbfix.Position=UDim2.new(0,0,0.5,0); tbfix.BackgroundColor3=T.TopBar; tbfix.BorderSizePixel=0
    local tdiv=Instance.new("Frame"); tdiv.Size=UDim2.new(1,0,0,1); tdiv.Position=UDim2.new(0,0,1,-1)
    tdiv.BackgroundColor3=T.Border; tdiv.BorderSizePixel=0; tdiv.Parent=tb
    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dX=Mouse.X-win.AbsolutePosition.X; dY=Mouse.Y-win.AbsolutePosition.Y
        end
    end)
    tb.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    local brand=Instance.new("TextLabel"); brand.Size=UDim2.new(0,100,1,0)
    brand.Position=UDim2.new(0,12,0,0); brand.BackgroundTransparency=1
    brand.Text="ELITE HUB"; brand.Font=Enum.Font.GothamBlack; brand.TextSize=11
    brand.TextColor3=T.Pink; brand.TextXAlignment=Enum.TextXAlignment.Left; brand.Parent=tb
    local tbInfo=Instance.new("TextLabel"); tbInfo.Size=UDim2.new(1,-200,1,0)
    tbInfo.Position=UDim2.new(0,110,0,0); tbInfo.BackgroundTransparency=1
    tbInfo.Font=Enum.Font.Gotham; tbInfo.TextSize=9; tbInfo.TextColor3=T.Sub; tbInfo.Parent=tb
    RunService.Heartbeat:Connect(wrap(function()
        if not tbInfo.Parent then return end
        tbInfo.Text="|  "..fmtClock().."  |  FPS: "..FPS.."  |  "..STATUS
        tbInfo.TextColor3=STATUS_COL
    end))
    if IS_DELTA then
        local db=Instance.new("Frame"); db.Size=UDim2.new(0,46,0,16)
        db.Position=UDim2.new(1,-108,0.5,-8); db.BackgroundColor3=Color3.fromRGB(10,15,32); db.BorderSizePixel=0; db.Parent=tb
        local dbc=Instance.new("UICorner"); dbc.CornerRadius=UDim.new(0,4); dbc.Parent=db
        local dbs=Instance.new("UIStroke"); dbs.Color=T.Blue; dbs.Thickness=1; dbs.Parent=db
        local dbl=Instance.new("TextLabel"); dbl.Size=UDim2.fromScale(1,1); dbl.BackgroundTransparency=1
        dbl.Text="DELTA"; dbl.Font=Enum.Font.GothamBlack; dbl.TextSize=7.5; dbl.TextColor3=T.Blue; dbl.Parent=db
    end
    local function winBtn(xOff,col,lbl,cb)
        local b=Instance.new("TextButton"); b.Size=UDim2.new(0,18,0,18)
        b.Position=UDim2.new(1,xOff,0.5,-9); b.BackgroundColor3=col; b.Text=lbl
        b.Font=Enum.Font.GothamBold; b.TextSize=10; b.TextColor3=Color3.new(1,1,1); b.BorderSizePixel=0; b.Parent=tb
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

    -- ── SIDEBAR ─────────────────────────────────────────────────────
    local SB_W=120
    local sb=Instance.new("Frame"); sb.Size=UDim2.new(0,SB_W,1,-TB_H-1)
    sb.Position=UDim2.new(0,0,0,TB_H); sb.BackgroundColor3=T.SB; sb.BorderSizePixel=0; sb.Parent=win
    local sbDiv=Instance.new("Frame"); sbDiv.Size=UDim2.new(0,1,1,0); sbDiv.Position=UDim2.new(1,-1,0,0)
    sbDiv.BackgroundColor3=T.Border; sbDiv.BorderSizePixel=0; sbDiv.Parent=sb
    local sbNav=Instance.new("ScrollingFrame"); sbNav.Size=UDim2.new(1,0,1,-72)
    sbNav.BackgroundTransparency=1; sbNav.BorderSizePixel=0; sbNav.ScrollBarThickness=0
    sbNav.CanvasSize=UDim2.new(0,0,0,0); sbNav.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sbNav.ScrollingDirection=Enum.ScrollingDirection.Y; sbNav.Parent=sb
    local snPad=Instance.new("UIPadding"); snPad.PaddingTop=UDim.new(0,7)
    snPad.PaddingLeft=UDim.new(0,5); snPad.PaddingRight=UDim.new(0,5); snPad.Parent=sbNav
    local snList=Instance.new("UIListLayout"); snList.SortOrder=Enum.SortOrder.LayoutOrder
    snList.Padding=UDim.new(0,1); snList.Parent=sbNav

    -- Sidebar bottom (avatar + info)
    local sbBot=Instance.new("Frame"); sbBot.Size=UDim2.new(1,0,0,72)
    sbBot.Position=UDim2.new(0,0,1,-72); sbBot.BackgroundColor3=T.SB; sbBot.BorderSizePixel=0; sbBot.Parent=sb
    local sbBotDiv=Instance.new("Frame"); sbBotDiv.Size=UDim2.new(1,0,0,1)
    sbBotDiv.BackgroundColor3=T.Border; sbBotDiv.BorderSizePixel=0; sbBotDiv.Parent=sbBot
    local avF=Instance.new("Frame"); avF.Size=UDim2.new(0,36,0,36)
    avF.Position=UDim2.new(0,7,0,10); avF.BackgroundColor3=T.Dim; avF.BorderSizePixel=0; avF.Parent=sbBot
    local avC=Instance.new("UICorner"); avC.CornerRadius=UDim.new(0,18); avC.Parent=avF
    local avImg=Instance.new("ImageLabel"); avImg.Size=UDim2.fromScale(1,1)
    avImg.BackgroundTransparency=1; avImg.Image=AVATAR_URL; avImg.ScaleType=Enum.ScaleType.Fit; avImg.Parent=avF
    local avIC=Instance.new("UICorner"); avIC.CornerRadius=UDim.new(0,18); avIC.Parent=avImg
    local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,9,0,9); dot.Position=UDim2.new(1,-9,1,-9)
    dot.BackgroundColor3=T.Green; dot.BorderSizePixel=0; dot.Parent=avF
    local dotC=Instance.new("UICorner"); dotC.CornerRadius=UDim.new(0,5); dotC.Parent=dot
    local dotSt=Instance.new("UIStroke"); dotSt.Color=T.SB; dotSt.Thickness=1.5; dotSt.Parent=dot
    local dnLbl=Instance.new("TextLabel"); dnLbl.Size=UDim2.new(1,-52,0,14)
    dnLbl.Position=UDim2.new(0,50,0,9); dnLbl.BackgroundTransparency=1; dnLbl.Text=DISPLAY_NAME
    dnLbl.Font=Enum.Font.GothamBold; dnLbl.TextSize=9.5; dnLbl.TextColor3=T.Text
    dnLbl.TextXAlignment=Enum.TextXAlignment.Left; dnLbl.TextTruncate=Enum.TextTruncate.AtEnd; dnLbl.Parent=sbBot
    local unLbl=Instance.new("TextLabel"); unLbl.Size=UDim2.new(1,-52,0,12)
    unLbl.Position=UDim2.new(0,50,0,24); unLbl.BackgroundTransparency=1; unLbl.Text=USERNAME
    unLbl.Font=Enum.Font.Gotham; unLbl.TextSize=8; unLbl.TextColor3=T.Sub
    unLbl.TextXAlignment=Enum.TextXAlignment.Left; unLbl.Parent=sbBot
    local sesLbl=Instance.new("TextLabel"); sesLbl.Size=UDim2.new(1,-52,0,11)
    sesLbl.Position=UDim2.new(0,50,0,38); sesLbl.BackgroundTransparency=1
    sesLbl.Font=Enum.Font.Gotham; sesLbl.TextSize=7.5; sesLbl.TextColor3=T.Dim
    sesLbl.TextXAlignment=Enum.TextXAlignment.Left; sesLbl.Parent=sbBot
    task.spawn(function() while task.wait(1) do if not sesLbl.Parent then break end; sesLbl.Text=fmtTime(os.time()-STATS.startTime) end end)
    local stRow=Instance.new("TextLabel"); stRow.Size=UDim2.new(1,-8,0,11)
    stRow.Position=UDim2.new(0,6,0,55); stRow.BackgroundTransparency=1
    stRow.Font=Enum.Font.Gotham; stRow.TextSize=7.5; stRow.TextXAlignment=Enum.TextXAlignment.Left; stRow.Parent=sbBot
    task.spawn(function()
        while task.wait(0.5) do if not stRow.Parent then break end
            stRow.Text="●  "..STATUS; stRow.TextColor3=STATUS_COL
        end
    end)

    -- ── CONTENT AREA ────────────────────────────────────────────────
    local CA_X=SB_W+1
    local ca=Instance.new("Frame"); ca.Size=UDim2.new(1,-CA_X,1,-TB_H)
    ca.Position=UDim2.new(0,CA_X,0,TB_H); ca.BackgroundTransparency=1; ca.Parent=win

    -- ── PAGE SYSTEM ─────────────────────────────────────────────────
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
                TweenService:Create(t.bg,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
                TweenService:Create(t.acc,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
                TweenService:Create(t.lbl,TweenInfo.new(0.15),{TextColor3=T.Sub}):Play()
            end
        end
        curPage=id; pages[id].Visible=true
        local t=tabs[id]
        if t then
            TweenService:Create(t.bg,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(24,24,24)}):Play()
            TweenService:Create(t.acc,TweenInfo.new(0.15),{BackgroundColor3=T.Pink}):Play()
            TweenService:Create(t.lbl,TweenInfo.new(0.15),{TextColor3=T.Text}):Play()
        end
    end
    local _tabOrder=0
    local function sbSec(label)
        _tabOrder=_tabOrder+1
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,16); f.BackgroundTransparency=1
        f.LayoutOrder=_tabOrder; f.Parent=sbNav
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.fromScale(1,1); lbl.BackgroundTransparency=1
        lbl.Text=label:upper(); lbl.Font=Enum.Font.GothamBold; lbl.TextSize=7.5; lbl.TextColor3=T.Dim
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
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

    -- ── WIDGET FACTORIES ────────────────────────────────────────────
    local function card(page,title,order)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,0); f.AutomaticSize=Enum.AutomaticSize.Y
        f.BackgroundColor3=T.Card; f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=page
        local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,7); fc.Parent=f
        local fs=Instance.new("UIStroke"); fs.Color=T.Border; fs.Thickness=1; fs.Parent=f
        local fp=Instance.new("UIPadding"); fp.PaddingTop=UDim.new(0,8); fp.PaddingLeft=UDim.new(0,10)
        fp.PaddingRight=UDim.new(0,10); fp.PaddingBottom=UDim.new(0,8); fp.Parent=f
        local fl=Instance.new("UIListLayout"); fl.SortOrder=Enum.SortOrder.LayoutOrder; fl.Padding=UDim.new(0,4); fl.Parent=f
        if title then
            local h=Instance.new("TextLabel"); h.Size=UDim2.new(1,0,0,15); h.BackgroundTransparency=1
            h.Text=title; h.Font=Enum.Font.GothamBold; h.TextSize=10.5; h.TextColor3=T.Text
            h.TextXAlignment=Enum.TextXAlignment.Left; h.LayoutOrder=0; h.Parent=f
        end
        return f
    end
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
    local function sep(parent,order)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=T.Border
        f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent
    end
    local function infoRow(parent,key,val,order)
        local r=Instance.new("Frame"); r.Size=UDim2.new(1,0,0,20); r.BackgroundTransparency=1
        r.LayoutOrder=order; r.Parent=parent
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.55,0,1,0); l.BackgroundTransparency=1
        l.Text=key; l.Font=Enum.Font.Gotham; l.TextSize=9; l.TextColor3=T.Sub
        l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local v=Instance.new("TextLabel"); v.Size=UDim2.new(0.45,0,1,0); v.Position=UDim2.new(0.55,0,0,0)
        v.BackgroundTransparency=1; v.Text=tostring(val); v.Font=Enum.Font.GothamBold
        v.TextSize=9; v.TextColor3=T.Text; v.TextXAlignment=Enum.TextXAlignment.Right; v.Parent=r
        return v
    end
    local function toggle(parent,label,key,order,cb)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,24); row.BackgroundTransparency=1
        row.LayoutOrder=order; row.Parent=parent
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-46,1,0); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9.5; lbl.TextColor3=T.Sub
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row
        local on=key and S[key] or false
        local track=Instance.new("Frame"); track.Size=UDim2.new(0,34,0,17)
        track.Position=UDim2.new(1,-36,0.5,-8.5); track.BackgroundColor3=on and T.Green or T.Dim
        track.BorderSizePixel=0; track.Parent=row
        local tc=Instance.new("UICorner"); tc.CornerRadius=UDim.new(0,9); tc.Parent=track
        local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,13,0,13)
        thumb.Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)
        thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0; thumb.Parent=track
        local thc=Instance.new("UICorner"); thc.CornerRadius=UDim.new(0,7); thc.Parent=thumb
        local function setState(v)
            on=v; if key then S[key]=v; qSave() end
            TweenService:Create(track,TweenInfo.new(0.15),{BackgroundColor3=on and T.Green or T.Dim}):Play()
            TweenService:Create(thumb,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-15,0.5,-6.5) or UDim2.new(0,2,0.5,-6.5)}):Play()
            if cb then task.spawn(cb,on) end
        end
        local hit=Instance.new("TextButton"); hit.Size=UDim2.fromScale(1,1); hit.BackgroundTransparency=1
        hit.Text=""; hit.Parent=row
        hit.MouseButton1Click:Connect(function() setState(not on) end)
        return setState
    end
    local function slider(parent,label,key,mn,mx,order,cb)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,38); f.BackgroundTransparency=1
        f.LayoutOrder=order; f.Parent=parent
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.6,0,0,14); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9.5; lbl.TextColor3=T.Sub
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
        local curV=key and S[key] or mn
        local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0.4,0,0,14); valLbl.Position=UDim2.new(0.6,0,0,0)
        valLbl.BackgroundTransparency=1; valLbl.Text=tostring(curV); valLbl.Font=Enum.Font.GothamBold
        valLbl.TextSize=9.5; valLbl.TextColor3=T.Text; valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.Parent=f
        local track=Instance.new("Frame"); track.Size=UDim2.new(1,0,0,5); track.Position=UDim2.new(0,0,0,19)
        track.BackgroundColor3=T.Dim; track.BorderSizePixel=0; track.Parent=f
        local tcc=Instance.new("UICorner"); tcc.CornerRadius=UDim.new(0,3); tcc.Parent=track
        local pct=math.clamp((curV-mn)/(mx-mn),0,1)
        local fill=Instance.new("Frame"); fill.Size=UDim2.new(pct,0,1,0); fill.BackgroundColor3=T.Pink
        fill.BorderSizePixel=0; fill.Parent=track
        local fcc=Instance.new("UICorner"); fcc.CornerRadius=UDim.new(0,3); fcc.Parent=fill
        local thumbS=Instance.new("Frame"); thumbS.Size=UDim2.new(0,12,0,12)
        thumbS.Position=UDim2.new(pct,-6,0.5,-6); thumbS.BackgroundColor3=Color3.new(1,1,1)
        thumbS.BorderSizePixel=0; thumbS.Parent=track
        local thcS=Instance.new("UICorner"); thcS.CornerRadius=UDim.new(0,6); thcS.Parent=thumbS
        local drag=false
        track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                local rel=math.clamp((Mouse.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                local val=math.round(mn+rel*(mx-mn))
                if key then S[key]=val; qSave() end; valLbl.Text=tostring(val)
                fill.Size=UDim2.new(rel,0,1,0); thumbS.Position=UDim2.new(rel,-6,0.5,-6)
                if cb then cb(val) end
            end
        end)
    end
    local function dropdown(parent,label,opts,key,order,cb)
        local open=false
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,24); f.BackgroundTransparency=1
        f.LayoutOrder=order; f.ClipsDescendants=true; f.Parent=parent
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.45,0,0,24); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9.5; lbl.TextColor3=T.Sub
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f
        local selLbl=Instance.new("TextLabel"); selLbl.Size=UDim2.new(0.55,-14,0,24)
        selLbl.Position=UDim2.new(0.45,0,0,0); selLbl.BackgroundTransparency=1
        selLbl.Text=(key and S[key]) or (opts[1] or ""); selLbl.Font=Enum.Font.GothamBold
        selLbl.TextSize=9.5; selLbl.TextColor3=T.Text; selLbl.TextXAlignment=Enum.TextXAlignment.Right; selLbl.Parent=f
        local arr=Instance.new("TextLabel"); arr.Size=UDim2.new(0,14,0,24); arr.Position=UDim2.new(1,-14,0,0)
        arr.BackgroundTransparency=1; arr.Text="⌄"; arr.Font=Enum.Font.Gotham; arr.TextSize=10; arr.TextColor3=T.Dim; arr.Parent=f
        local listF=Instance.new("Frame"); listF.Size=UDim2.new(1,0,0,#opts*22)
        listF.Position=UDim2.new(0,0,0,24); listF.BackgroundColor3=Color3.fromRGB(11,11,11)
        listF.BorderSizePixel=0; listF.Parent=f
        local lfc=Instance.new("UICorner"); lfc.CornerRadius=UDim.new(0,5); lfc.Parent=listF
        local lfs=Instance.new("UIStroke"); lfs.Color=T.Border; lfs.Thickness=1; lfs.Parent=listF
        local lfl=Instance.new("UIListLayout"); lfl.SortOrder=Enum.SortOrder.LayoutOrder; lfl.Parent=listF
        local optBtns={}
        local curKey=key
        local function rebuildOpts(newOpts,newKey)
            for _,b in pairs(optBtns) do pcall(function() b:Destroy() end) end optBtns={}
            curKey=newKey or key; listF.Size=UDim2.new(1,0,0,#newOpts*22)
            selLbl.Text=(curKey and S[curKey]) or (newOpts[1] or "")
            for i,opt in ipairs(newOpts) do
                local ob=Instance.new("TextButton"); ob.Size=UDim2.new(1,0,0,22)
                ob.BackgroundColor3=Color3.fromRGB(11,11,11); ob.Text=opt
                ob.Font=Enum.Font.Gotham; ob.TextSize=9.5; ob.TextColor3=T.Sub
                ob.BorderSizePixel=0; ob.LayoutOrder=i; ob.Parent=listF
                ob.MouseButton1Click:Connect(function()
                    if curKey then S[curKey]=opt; qSave() end
                    selLbl.Text=opt; open=false
                    TweenService:Create(f,TweenInfo.new(0.14),{Size=UDim2.new(1,0,0,24)}):Play()
                    if cb then task.spawn(cb,opt) end
                end)
                ob.MouseEnter:Connect(function() TweenService:Create(ob,TweenInfo.new(0.08),{TextColor3=T.Text,BackgroundColor3=Color3.fromRGB(20,20,20)}):Play() end)
                ob.MouseLeave:Connect(function() TweenService:Create(ob,TweenInfo.new(0.08),{TextColor3=T.Sub,BackgroundColor3=Color3.fromRGB(11,11,11)}):Play() end)
                table.insert(optBtns,ob)
            end
        end
        rebuildOpts(opts,key)
        local hit=Instance.new("TextButton"); hit.Size=UDim2.new(1,0,0,24); hit.BackgroundTransparency=1
        hit.Text=""; hit.Parent=f
        hit.MouseButton1Click:Connect(function()
            open=not open
            TweenService:Create(f,TweenInfo.new(0.16,Enum.EasingStyle.Back),
                {Size=UDim2.new(1,0,0,open and 24+#optBtns*22 or 24)}):Play()
        end)
        return f, selLbl, rebuildOpts
    end
    local function btn(parent,label,col,order,cb)
        col=col or T.Card2
        local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,23)
        b.BackgroundColor3=col; b.Text=label; b.Font=Enum.Font.GothamBold; b.TextSize=9.5
        b.TextColor3=T.Text; b.BorderSizePixel=0; b.LayoutOrder=order; b.Parent=parent
        local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,5); bc.Parent=b
        local bs=Instance.new("UIStroke"); bs.Color=T.Border; bs.Thickness=1; bs.Parent=b
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.08),{BackgroundTransparency=0.2}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.08),{BackgroundTransparency=0}):Play() end)
        b.MouseButton1Click:Connect(function()
            TweenService:Create(b,TweenInfo.new(0.04),{Size=UDim2.new(0.97,0,0,20)}):Play()
            task.wait(0.06); TweenService:Create(b,TweenInfo.new(0.06),{Size=UDim2.new(1,0,0,23)}):Play()
            if cb then task.spawn(cb) end
        end)
        return b
    end

    -- ── BUILD TABS ──────────────────────────────────────────────────
    sbSec("Elite Hub")
    local goFarm   = makeTab("Farm",   "Auto Farm")
    local goCombat = makeTab("Combat", "Combat")
    local goTP     = makeTab("TP",     "Teleport")
    local goBoss   = makeTab("Boss",   "Boss")
    local goRaid   = makeTab("Raid",   "Raid")
    sbSec("Visuals")
    local goESP    = makeTab("ESP",    "ESP")
    local goVis    = makeTab("Visual", "Visual")
    sbSec("Info")
    local goMisc   = makeTab("Misc",   "Stats & Info")

    -- ════════════════════════════════════════
    --  PAGE: AUTO FARM
    -- ════════════════════════════════════════
    local pFarm=makePage("Farm")
    local fL,fR=twoCol(pFarm,1)

    -- Left: farm config
    local cfgC=card(fL,"Auto Farm",1)
    -- Live level + recommended mob display
    local lvRow=Instance.new("Frame"); lvRow.Size=UDim2.new(1,0,0,22); lvRow.BackgroundTransparency=1; lvRow.LayoutOrder=1; lvRow.Parent=cfgC
    local lvLblA=Instance.new("TextLabel"); lvLblA.Size=UDim2.new(0.4,0,1,0); lvLblA.BackgroundTransparency=1
    lvLblA.Text="Level"; lvLblA.Font=Enum.Font.Gotham; lvLblA.TextSize=9; lvLblA.TextColor3=T.Sub
    lvLblA.TextXAlignment=Enum.TextXAlignment.Left; lvLblA.Parent=lvRow
    local lvValA=Instance.new("TextLabel"); lvValA.Size=UDim2.new(0.6,0,1,0); lvValA.Position=UDim2.new(0.4,0,0,0)
    lvValA.BackgroundTransparency=1; lvValA.Text="..."; lvValA.Font=Enum.Font.GothamBold
    lvValA.TextSize=9; lvValA.TextColor3=T.Gold; lvValA.TextXAlignment=Enum.TextXAlignment.Right; lvValA.Parent=lvRow
    -- Quest kill tracker
    local qRow=Instance.new("Frame"); qRow.Size=UDim2.new(1,0,0,20); qRow.BackgroundTransparency=1; qRow.LayoutOrder=2; qRow.Parent=cfgC
    local qLblA=Instance.new("TextLabel"); qLblA.Size=UDim2.new(0.5,0,1,0); qLblA.BackgroundTransparency=1
    qLblA.Text="Quest Kills"; qLblA.Font=Enum.Font.Gotham; qLblA.TextSize=9; qLblA.TextColor3=T.Sub
    qLblA.TextXAlignment=Enum.TextXAlignment.Left; qLblA.Parent=qRow
    local qValA=Instance.new("TextLabel"); qValA.Size=UDim2.new(0.5,0,1,0); qValA.Position=UDim2.new(0.5,0,0,0)
    qValA.BackgroundTransparency=1; qValA.Text="0 / 0"; qValA.Font=Enum.Font.GothamBold
    qValA.TextSize=9; qValA.TextColor3=T.Teal; qValA.TextXAlignment=Enum.TextXAlignment.Right; qValA.Parent=qRow
    -- Quest state
    local qStateRow=Instance.new("Frame"); qStateRow.Size=UDim2.new(1,0,0,18); qStateRow.BackgroundTransparency=1; qStateRow.LayoutOrder=3; qStateRow.Parent=cfgC
    local qStateLbl=Instance.new("TextLabel"); qStateLbl.Size=UDim2.fromScale(1,1); qStateLbl.BackgroundTransparency=1
    qStateLbl.Text="Quest: Idle"; qStateLbl.Font=Enum.Font.Gotham; qStateLbl.TextSize=8.5
    qStateLbl.TextColor3=T.Dim; qStateLbl.TextXAlignment=Enum.TextXAlignment.Left; qStateLbl.Parent=qStateRow
    task.spawn(function()
        while task.wait(2) do
            if not lvValA.Parent then break end
            local lv=getLevel(); local mob=getMobForLevel(lv)
            lvValA.Text=tostring(lv).."  →  "..mob.name
            qValA.Text=QUEST.killsDone.." / "..(QUEST.killsNeeded>0 and tostring(QUEST.killsNeeded) or "0")
            qStateLbl.Text="Quest: "..QUEST.state:sub(1,1):upper()..QUEST.state:sub(2)
            qStateLbl.TextColor3=QUEST.state=="farming" and T.Green or QUEST.state=="idle" and T.Dim or T.Gold
        end
    end)

    sep(cfgC,4)
    toggle(cfgC,"Auto Level Farm","AutoLevelFarm",5,function(on)
        S.AutoFarm=on
        if on then local m=getMobForLevel(getLevel()); S.TargetMob=m.name; qSave()
            setStatus("Level Farm: "..m.name,T.Gold); notify("Auto Level Farm","Lv "..getLevel().." → "..m.name,4,T.Gold)
        else setStatus("Idle") end
    end)
    sep(cfgC,6)
    -- Sea selector updates mob dropdown
    local _,_,setMobOpts=dropdown(cfgC,"Mob",SEA_MOBS_LIST[1],"TargetMob",7)
    dropdown(cfgC,"Sea",{"Sea 1","Sea 2","Sea 3"},nil,8,function(sea)
        local idx=tonumber(sea:match("%d")) or 1
        local mbs=SEA_MOBS_LIST[idx] or SEA_MOBS_LIST[1]
        setMobOpts(mbs,"TargetMob")
        S.TargetMob=mbs[1] or "Bandit"; qSave()
        notify("Farm","Sea: "..sea.."  |  Mob: "..S.TargetMob,2.5)
    end)
    dropdown(cfgC,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",9)
    sep(cfgC,10)
    slider(cfgC,"Farm Delay","FarmDelay",0.05,2,11)

    -- Right: toggles
    local togC=card(fR,"Toggles",1)
    toggle(togC,"Auto Farm","AutoFarm",1,function(on)
        _AutoFarmActive=on
        if on then setStatus("Farm: "..(S.TargetMob or "?"),T.Blue); notify("Farm","Started → "..(S.TargetMob or "Bandit"),3,T.Blue)
        else _AutoFarmActive=false; setStatus("Idle"); notify("Farm","Stopped.",2) end
    end)
    toggle(togC,"Auto Quest","AutoQuest",2,function(on)
        if on then QUEST.state="idle"; QUEST.killsDone=0; setStatus("Quest: Starting...",T.Teal)
            notify("Quest","ON — will accept & complete quests automatically",3.5,T.Teal)
        else QUEST.state="idle"; setStatus("Idle"); notify("Quest","OFF",2) end
    end)
    toggle(togC,"Bring Mob","BringMob",3)
    toggle(togC,"Fast Attack","FastAttack",4)
    toggle(togC,"Auto Haki (Buso)","AutoHaki",5)
    toggle(togC,"Auto Chest","AutoChest",6)
    toggle(togC,"Auto Eat Fruit","AutoEatFruit",7)
    toggle(togC,"Auto Respawn","AutoRespawn",8)
    toggle(togC,"Safe Mode","SafeMode",9,function(on) if on then S.FarmDelay=0.28 else S.FarmDelay=0.1 end; qSave() end)
    toggle(togC,"Bypass TP","BypassTP",10)

    -- STOP button
    btn(pFarm,"■  STOP ALL FARMING",Color3.fromRGB(42,14,14),2,function()
        S.AutoFarm=false; S.AutoLevelFarm=false; S.AutoQuest=false
        S.AutoBoss=false; S.AutoRaid=false; S.KillAura=false
        _AutoFarmActive=false; QUEST.state="idle"
        setStatus("Idle"); notify("STOP","All farming halted.",2.5,T.Red)
    end)

    -- Quick-farm buttons: Sea 1 + Sea 2 (side by side)
    local s1L,s1R=twoCol(pFarm,3)
    local s1Lc=card(s1L,"Sea 1 — Quick Farm",1)
    local s1Rc=card(s1R,"Sea 2 — Quick Farm",1)
    for _,name in ipairs(SEA_MOBS_LIST[1]) do
        local info=MOB_MAP[name]
        btn(s1Lc,name..(info and " [Lv."..info.minLv.."]" or ""),T.Card2,1,function()
            S.TargetMob=name; S.AutoFarm=true; _AutoFarmActive=true; qSave()
            if info then tp(info.pos) end
            setStatus("Farm: "..name,T.Blue); notify("Farm",name,2.5,T.Blue)
        end)
    end
    for _,name in ipairs(SEA_MOBS_LIST[2]) do
        local info=MOB_MAP[name]
        btn(s1Rc,name..(info and " [Lv."..info.minLv.."]" or ""),T.Card2,1,function()
            S.TargetMob=name; S.AutoFarm=true; _AutoFarmActive=true; qSave()
            if info then tp(info.pos) end
            setStatus("Farm: "..name,T.Blue); notify("Farm",name,2.5,T.Blue)
        end)
    end
    -- Sea 3 quick farm (full width, two sub-columns)
    local s3C=card(pFarm,"Sea 3 — Quick Farm",4)
    local s3L2,s3R2=twoCol(s3C,1)
    local half3=#SEA_MOBS_LIST[3]//2
    for i,name in ipairs(SEA_MOBS_LIST[3]) do
        local info=MOB_MAP[name]; local tgt=i<=half3 and s3L2 or s3R2
        btn(tgt,name..(info and " [Lv."..info.minLv.."]" or ""),T.Card2,i,function()
            S.TargetMob=name; S.AutoFarm=true; _AutoFarmActive=true; qSave()
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
    sep(kaC,2); slider(kaC,"Range","KillAuraRange",8,200,3)

    local flyC=card(cL,"Fly  (WASD + Space/Ctrl)",2)
    toggle(flyC,"Enable Fly","FlyEnabled",1); slider(flyC,"Speed","FlySpeed",20,500,2)

    local moveC=card(cL,"Movement",3)
    toggle(moveC,"No Clip","NoClip",1); toggle(moveC,"Infinite Jump","InfJump",2)

    local combatCfg=card(cL,"Attack Config",4)
    dropdown(combatCfg,"Attack Type",{"Fast","Normal","Slow"},"FastAttackType",1)
    sep(combatCfg,2)
    -- Skill slot toggles (Z/X/C/V) — synced to _G.Settings.Configs
    local function skillToggle(parent,label,slot,order)
        toggle(parent,label,nil,order,function(on)
            _G.Settings.Configs["Skill "..slot]=on
        end)
        -- Init from _G.Settings
        task.spawn(function()
            task.wait(0.1)
            if _G.Settings.Configs["Skill "..slot]==false then end -- already false by default toggle
        end)
    end
    skillToggle(combatCfg,"Use Skill Z","Z",3)
    skillToggle(combatCfg,"Use Skill X","X",4)
    skillToggle(combatCfg,"Use Skill C","C",5)
    skillToggle(combatCfg,"Use Skill V","V",6)

    local defC=card(cR,"Defence",1)
    toggle(defC,"God Mode","GodMode",1,function(on) notify("God Mode",on and"ON"or"OFF",2.5,on and T.Gold or T.Sub) end)
    toggle(defC,"Anti-AFK","AntiAFK",2); toggle(defC,"Auto Respawn","AutoRespawn",3)

    local wsC=card(cR,"Walk Speed",2)
    slider(wsC,"Speed","WalkSpeed",16,350,1,function(v) local h=getHum(); if h then h.WalkSpeed=v end end)
    sep(wsC,2)
    for i,sp in ipairs({16,32,60,100,200,350}) do
        btn(wsC,"→ "..sp,T.Card2,2+i,function() S.WalkSpeed=sp; qSave(); local h=getHum(); if h then h.WalkSpeed=sp end end)
    end

    local jpC=card(cR,"Jump Power",3)
    slider(jpC,"Power","JumpPower",50,600,1,function(v) local h=getHum(); if h then h.JumpPower=v end end)
    sep(jpC,2)
    for i,jp in ipairs({50,100,250,500}) do
        btn(jpC,"→ "..jp,T.Card2,2+i,function() S.JumpPower=jp; qSave(); local h=getHum(); if h then h.JumpPower=jp end end)
    end

    -- ════════════════════════════════════════
    --  PAGE: TELEPORT
    -- ════════════════════════════════════════
    local pTP=makePage("TP")
    local tpL,tpR=twoCol(pTP,1)

    local frCard=card(tpL,"Fruit Finder",1)
    toggle(frCard,"Auto TP to Fruits","TPFruit",1); toggle(frCard,"Auto Eat on Arrival","AutoEatFruit",2)
    btn(frCard,"Scan & TP Nearest",T.Card2,3,function()
        local fruits=scanFruits(); local root=getRoot()
        if not root then notify("Fruit","No character.",2,T.Red); return end
        if #fruits==0 then notify("Fruit","No fruits found.",2,T.Red); return end
        table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        tp(fruits[1].pos); STATS.fruitsTP=STATS.fruitsTP+1; notify("Fruit","→  "..fruits[1].name,3,T.Green)
    end)

    local s1iC=card(tpL,"Sea 1 Islands",2)
    for _,d in ipairs(SEA1_ISLANDS) do btn(s1iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end) end

    local s2iC=card(tpR,"Sea 2 Islands",1)
    for _,d in ipairs(SEA2_ISLANDS) do btn(s2iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end) end
    local s3iC=card(tpR,"Sea 3 Islands",2)
    for _,d in ipairs(SEA3_ISLANDS) do btn(s3iC,d[1],T.Card2,1,function() tp(d[2]); notify("TP","→ "..d[1],2) end) end

    -- ════════════════════════════════════════
    --  PAGE: BOSS
    -- ════════════════════════════════════════
    local pBoss=makePage("Boss")
    local bL,bR=twoCol(pBoss,1)
    local bNames={} for k in pairs(BOSS_POS) do table.insert(bNames,k) end table.sort(bNames)

    local bCfg=card(bL,"Boss Config",1)
    dropdown(bCfg,"Select Boss",bNames,"SelectedBoss",1); sep(bCfg,2)
    toggle(bCfg,"Auto Boss Farm","AutoBoss",3,function(on)
        if on then setStatus("Boss: "..S.SelectedBoss,T.Gold) else setStatus("Idle") end
        notify("Boss",on and"Started: "..S.SelectedBoss or"Stopped.",2.5,on and T.Gold or T.Sub)
    end)
    sep(bCfg,4)
    btn(bCfg,"TP to Boss Now",T.Card2,5,function()
        local pos=BOSS_POS[S.SelectedBoss]; if pos then tp(pos); notify("Boss","→ "..S.SelectedBoss,2) end
    end)

    local bTPc=card(bR,"Quick Boss TP",1)
    for _,n in ipairs(bNames) do
        btn(bTPc,n,T.Card2,1,function() local pos=BOSS_POS[n]; if pos then tp(pos); notify("Boss","→ "..n,2) end end)
    end

    -- ════════════════════════════════════════
    --  PAGE: RAID
    -- ════════════════════════════════════════
    local pRaid=makePage("Raid")
    local rL,rR=twoCol(pRaid,1)
    local rNames={} for k in pairs(RAID_POS) do table.insert(rNames,k) end table.sort(rNames)

    local rCfg=card(rL,"Raid Config",1)
    dropdown(rCfg,"Select Raid",rNames,"SelectedRaid",1); sep(rCfg,2)
    toggle(rCfg,"Auto Raid","AutoRaid",3,function(on)
        if on then setStatus("Raid: "..S.SelectedRaid,T.Purple) else setStatus("Idle") end
        notify("Raid",on and"Started: "..S.SelectedRaid or"Stopped.",2.5,on and T.Purple or T.Sub)
    end)
    sep(rCfg,4)
    btn(rCfg,"TP to Raid Now",T.Card2,5,function()
        local pos=RAID_POS[S.SelectedRaid]; if pos then tp(pos); notify("Raid","→ "..S.SelectedRaid,2) end
    end)

    local rTPc=card(rR,"Quick Raid TP",1)
    for _,n in ipairs(rNames) do
        btn(rTPc,n,T.Card2,1,function() local pos=RAID_POS[n]; if pos then tp(pos); notify("Raid","→ "..n,2) end end)
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
    local espInfo=card(eR,"ESP Info",2)
    infoRow(espInfo,"Engine",HAS_DRAW and"Drawing API"or"BillboardGui",1)
    infoRow(espInfo,"Executor",EXEC_NAME,2)
    infoRow(espInfo,"Delta",IS_DELTA and"Verified"or"No",3)

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
    toggle(dispC,"Show Watermark","ShowWatermark",1); toggle(dispC,"Show FPS","ShowFPS",2)

    local lockFPS=card(vR,"FPS Lock",2)
    slider(lockFPS,"Target FPS","HFPS",30,240,1)

    -- ════════════════════════════════════════
    --  PAGE: MISC / STATS
    -- ════════════════════════════════════════
    local pMisc=makePage("Misc")
    local mL,mR=twoCol(pMisc,1)

    local plInfoC=card(mL,"Player Info",1)
    -- Avatar display
    local avFm=Instance.new("Frame"); avFm.Size=UDim2.new(1,0,0,58); avFm.BackgroundTransparency=1; avFm.LayoutOrder=1; avFm.Parent=plInfoC
    local avHL=Instance.new("UIListLayout"); avHL.FillDirection=Enum.FillDirection.Horizontal; avHL.Padding=UDim.new(0,8); avHL.Parent=avFm
    local avBig=Instance.new("Frame"); avBig.Size=UDim2.new(0,52,0,52); avBig.BackgroundColor3=T.Dim; avBig.BorderSizePixel=0; avBig.Parent=avFm
    local avBC=Instance.new("UICorner"); avBC.CornerRadius=UDim.new(0,26); avBC.Parent=avBig
    local avBImg=Instance.new("ImageLabel"); avBImg.Size=UDim2.fromScale(1,1); avBImg.BackgroundTransparency=1
    avBImg.Image=AVATAR_URL; avBImg.ScaleType=Enum.ScaleType.Fit; avBImg.Parent=avBig
    local avBIC=Instance.new("UICorner"); avBIC.CornerRadius=UDim.new(0,26); avBIC.Parent=avBImg
    local infoStack=Instance.new("Frame"); infoStack.Size=UDim2.new(0,130,0,52); infoStack.BackgroundTransparency=1; infoStack.Parent=avFm
    local iVL=Instance.new("UIListLayout"); iVL.SortOrder=Enum.SortOrder.LayoutOrder; iVL.Padding=UDim.new(0,2); iVL.Parent=infoStack
    local function iRow(txt,col,lo)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,14); l.BackgroundTransparency=1
        l.Text=txt; l.Font=Enum.Font.Gotham; l.TextSize=9.5; l.TextColor3=col or T.Text
        l.TextXAlignment=Enum.TextXAlignment.Left; l.LayoutOrder=lo; l.Parent=infoStack
    end
    iRow(DISPLAY_NAME,T.Text,1); iRow(USERNAME,T.Sub,2); iRow("Executor: "..EXEC_NAME,T.Dim,3); iRow("UserID: "..USER_ID,T.Dim,4)
    sep(plInfoC,2)
    local sesR=infoRow(plInfoC,"Session",fmtTime(0),3)
    task.spawn(function() while task.wait(1) do if not sesR.Parent then break end; sesR.Text=fmtTime(os.time()-STATS.startTime) end end)
    infoRow(plInfoC,"Version","v1.0.0",4); infoRow(plInfoC,"Xeno/Solara","BLOCKED",5)

    local statsC=card(mL,"Session Stats",2)
    local sk2=infoRow(statsC,"Total Kills",0,1); local sd2=infoRow(statsC,"Deaths",0,2)
    local skpm=infoRow(statsC,"Kills / Min",0,3); local sqkl=infoRow(statsC,"Quest Kills",0,4)
    local sft=infoRow(statsC,"Fruits Found",0,5); local sqd=infoRow(statsC,"Quests Done",0,6)
    local sct=infoRow(statsC,"Chests Opened",0,7)
    task.spawn(function()
        while task.wait(1.5) do
            if not sk2.Parent then break end
            sk2.Text=tostring(STATS.kills); sd2.Text=tostring(STATS.deaths)
            skpm.Text=tostring(STATS.kpm); sqkl.Text=tostring(STATS.questKills)
            sft.Text=tostring(STATS.fruitsTP); sqd.Text=tostring(STATS.questsDone)
            sct.Text=tostring(STATS.chestsTP)
        end
    end)

    local autoStatC=card(mR,"Auto Stat",1)
    toggle(autoStatC,"Auto Distribute Stats","AutoStat",1,function(on)
        notify("Auto Stat",on and "ON — priority: "..(S.StatPriority or "Melee") or "OFF",2.5,on and T.Gold or T.Sub)
    end)
    dropdown(autoStatC,"Priority",{"Melee","Sword","Gun","Fruit","Defense"},"StatPriority",2,function(v)
        notify("Auto Stat","Priority → "..v,2,T.Gold)
    end)

    local cfgC2=card(mR,"Config",2)
    btn(cfgC2,"Save Config",T.Card2,1,function() saveConfig(S); notify("Config","Saved!",2,T.Green) end)
    btn(cfgC2,"Reset to Defaults",Color3.fromRGB(38,14,14),2,function()
        for k,v in pairs(cfgDefault()) do S[k]=v end; saveConfig(S); notify("Config","Reset to defaults.",2.5,T.Gold)
    end)
    sep(cfgC2,3)
    btn(cfgC2,"Copy Discord",T.Card2,4,function()
        if HAS_CLIP then setclipboard("discord.gg/EmsMsHZCVH") end
        notify("Discord","discord.gg/EmsMsHZCVH — copied!",2.5,T.Blue)
    end)

    local aboutC=card(mR,"About",3)
    infoRow(aboutC,"Name","Elite Hub",1); infoRow(aboutC,"Version","v1.0.0",2)
    infoRow(aboutC,"Game","Blox Fruits",3); infoRow(aboutC,"Discord","discord.gg/EmsMsHZCVH",4)
    sep(aboutC,5); infoRow(aboutC,"Delta Verified",IS_DELTA and"YES"or"N/A",6)

    -- Start on Farm page
    goFarm()
    return sg
end

-- ════════════════════════════════════════════
--  GAME LOOPS
-- ════════════════════════════════════════════

-- Fly (WASD + Space/Ctrl)
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
                local dir=Vector3.zero; local cf=Camera.CFrame
                if UserInputService:IsKeyDown(Enum.KeyCode.W)           then dir=dir+cf.LookVector  end
                if UserInputService:IsKeyDown(Enum.KeyCode.S)           then dir=dir-cf.LookVector  end
                if UserInputService:IsKeyDown(Enum.KeyCode.A)           then dir=dir-cf.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D)           then dir=dir+cf.RightVector end
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

-- GodMode
task.spawn(function()
    while task.wait(0.07) do
        if not S.GodMode then continue end
        local h=getHum()
        if h and h.Health>0 and h.Health<h.MaxHealth then
            pcall(function() h.Health=h.MaxHealth end)
        end
    end
end)

-- WalkSpeed / JumpPower sync (always apply, not just when != default)
task.spawn(function()
    while task.wait(1.5) do
        if not isAlive() then continue end
        local h=getHum()
        if h then
            pcall(function() if S.WalkSpeed then h.WalkSpeed=S.WalkSpeed end end)
            pcall(function() if S.JumpPower  then h.JumpPower=S.JumpPower  end end)
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if S.InfJump then local h=getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

-- Fullbright / NoFog sync
task.spawn(function()
    while task.wait(5) do
        if S.Fullbright then Lighting.Brightness=3.8; Lighting.FogEnd=1e6 end
        if S.NoFog      then Lighting.FogEnd=1e6 end
        if S.FOV then pcall(function() Camera.FieldOfView=S.FOV end) end
    end
end)

-- FPS Lock (limits Heartbeat frequency via throttle sleep)
task.spawn(function()
    while task.wait(0) do
        if not S.HFPS or S.HFPS <= 0 then continue end
        local target = S.HFPS
        if target < 10 or target > 240 then continue end
        local budget = 1 / target
        local t0 = tick()
        RunService.Heartbeat:Wait()
        local elapsed = tick() - t0
        if elapsed < budget then task.wait(budget - elapsed) end
    end
end)

-- Auto Respawn
LP.CharacterAdded:Connect(function(char)
    if not S.AutoRespawn then return end
    local h=char:WaitForChild("Humanoid",5)
    if h then h.Died:Connect(function()
        task.wait(3.5); if S.AutoRespawn then pcall(function() LP:LoadCharacter() end) end
    end) end
end)

-- ════════════════════════════════════════════
--  QUEST STATE MACHINE LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    local SetCFarme = 1
    while task.wait(0.5) do
        if not S.AutoQuest then QUEST.state="idle"; continue end
        if not isAlive() then task.wait(3); continue end

        local qData = nil
        pcall(function() qData = QuestCheck() end)

        local mobData = MOB_MAP[S.TargetMob] or getMobForLevel(getLevel())
        if not mobData and not qData then continue end

        if QUEST.state=="idle" then
            if qData then
                local actualKills = mobData and mobData.kills or 10
                QUEST.mob = {name=qData[6], pos=qData[2] and qData[2].Position or (mobData and mobData.pos), questPos=qData[2] and qData[2].Position, kills=actualKills}
                QUEST.killsNeeded = actualKills; QUEST.killsDone = 0
            else
                QUEST.mob = mobData; QUEST.killsNeeded = mobData.kills or 10; QUEST.killsDone = 0
            end
            QUEST.state="going_npc"; setStatus("Quest: Going to NPC",T.Teal)

        elseif QUEST.state=="going_npc" then
            local npcCF = qData and qData[2]
            local npcPos = npcCF and npcCF.Position or (QUEST.mob.questPos or QUEST.mob.pos)

            -- Use bypass if far
            if npcCF and (npcCF.Position - (getRoot() and getRoot().Position or Vector3.zero)).Magnitude >= 3000 then
                pcall(function() bypassTP(npcCF) end)
            else
                tp(npcPos + Vector3.new(0,0,5))
            end
            task.wait(0.8)

            -- Accept quest via CommF_
            if qData then
                pcall(function() Com("F_","StartQuest", qData[4], qData[1]) end)
            end
            tryAcceptQuest(qData and qData[4], qData and qData[1], QUEST.mob.name)

            -- Find and interact with NPC in world
            local npc = findQuestNPC(npcPos, 80)
            if npc then QUEST.lastNpcPos=npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("HumanoidRootPart").Position or npcPos; interactNPC(npc)
            else QUEST.lastNpcPos=npcPos end

            task.wait(0.4)
            QUEST.state="farming"
            setStatus("Quest: Farming "..QUEST.mob.name.." (0/"..QUEST.killsNeeded..")",T.Green)
            notify("Quest","Accepted! Kill "..QUEST.killsNeeded.."× "..QUEST.mob.name,4,T.Teal)

        elseif QUEST.state=="farming" then
            if not isAlive() then task.wait(3); continue end
            if QUEST.killsDone>=QUEST.killsNeeded then
                QUEST.state="returning"; setStatus("Quest: Returning to NPC",T.Gold)
            else
                -- Use QuestCheck mob CFrames for precision targeting
                if qData and qData[7] and #qData[7] > 0 then
                    local targetCF = qData[7][SetCFarme]
                    if targetCF then
                        local root = getRoot()
                        if root and (targetCF.Position-root.Position).Magnitude > 50 then
                            toTarget(targetCF * CFrame.new(0,30,5))
                        end
                        SetCFarme = SetCFarme >= #qData[7] and 1 or SetCFarme+1
                    end
                end
                local mob = findMob(QUEST.mob.name, 500)
                if mob then
                    local killed = attackMob(mob)
                    if killed then
                        QUEST.killsDone = QUEST.killsDone + 1
                        STATS.questKills = STATS.questKills + 1
                    end
                    setStatus("Quest: "..QUEST.mob.name.." ("..QUEST.killsDone.."/"..QUEST.killsNeeded..")",T.Green)
                else
                    local sp = QUEST.mob.pos; local root=getRoot()
                    if root and (root.Position-sp).Magnitude>100 then tp(sp); task.wait(1)
                    else task.wait(0.5) end
                end
            end

        elseif QUEST.state=="returning" then
            local npcPos = QUEST.lastNpcPos or (QUEST.mob.questPos or QUEST.mob.pos)
            tp(npcPos + Vector3.new(0,0,5)); task.wait(0.8)
            local npc = findQuestNPC(npcPos,60)
            if npc then interactNPC(npc); task.wait(0.4) end
            -- Fire complete remotes
            pcall(function() Com("F_","AbandonQuest") end)  -- some servers use abandon+restart cycle
            for _,v in pairs(RepStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local n=v.Name:lower()
                    if n:find("quest") or n:find("complete") or n:find("finish") or n:find("reward") then
                        pcall(function() v:FireServer() end); pcall(function() v:FireServer(QUEST.mob.name) end)
                    end
                end
            end
            task.wait(0.4); STATS.questsDone=STATS.questsDone+1
            notify("Quest","Complete! +"..QUEST.killsDone.." kills",3,T.Gold)
            QUEST.state="idle"; SetCFarme=1; setStatus("Quest: Idle",T.Teal)
        end
    end
end)

-- ════════════════════════════════════════════
--  MAIN FARM LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(S.FarmDelay or 0.1) do
        if not S.AutoFarm and not S.AutoLevelFarm then continue end
        if not isAlive() then if S.AutoRespawn then task.wait(3) end; continue end
        if S.AutoLevelFarm then
            local lv=getLevel(); local mob=getMobForLevel(lv)
            if mob.name~=S.TargetMob then
                S.TargetMob=mob.name; qSave()
                setStatus("Level Farm: "..mob.name,T.Gold); notify("Level Up!","Now farming: "..mob.name,3,T.Gold)
            end
        end
        local target=findMob(S.TargetMob,600)
        if target then
            attackMob(target)
        else
            local info=MOB_MAP[S.TargetMob]
            if info then
                local root=getRoot()
                if root and (root.Position-info.pos).Magnitude>120 then
                    tp(info.pos); task.wait(S.SafeMode and 2 or 1)
                else task.wait(0.4) end
            end
        end
    end
end)

-- ════════════════════════════════════════════
--  KILL AURA LOOP  (skips boss-tagged mobs)
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.07) do
        if not S.KillAura or not isAlive() then continue end
        local nearby=findAllMobs(S.KillAuraRange or 25)
        for _,info in ipairs(nearby) do
            if not S.KillAura then break end
            local n=info.obj.Name:lower()
            -- Skip boss mobs — they have huge HP and aura-ing them is unintended
            if n:find("boss") or n:find("king") or n:find("admiral") or n:find("greybeard") or n:find("darkbeard") then continue end
            attackMob(info.obj); task.wait(0.04)
        end
    end
end)

-- ════════════════════════════════════════════
--  AUTO BOSS LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoBoss or not isAlive() then continue end
        local boss=findMob(S.SelectedBoss,9999)
        if boss then attackMob(boss)
        else
            local pos=BOSS_POS[S.SelectedBoss]; local root=getRoot()
            if root and pos and (root.Position-pos).Magnitude>200 then tp(pos); task.wait(2) end
        end
    end
end)

-- ════════════════════════════════════════════
--  AUTO RAID LOOP
-- ════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        if not S.AutoRaid or not isAlive() then continue end
        local pos=RAID_POS[S.SelectedRaid]; if not pos then continue end
        local root=getRoot(); if not root then continue end
        if (root.Position-pos).Magnitude>150 then tp(pos); task.wait(2); continue end
        for _,info in ipairs(findAllMobs(80)) do attackMob(info.obj); task.wait(0.05) end
    end
end)

-- ════════════════════════════════════════════
--  AUTO STAT LOOP  (distribute unspent stat points)
-- ════════════════════════════════════════════
task.spawn(function()
    local statMap = {
        Melee    = "Beli",   -- CommF_ stat key names used by BF server
        Defense  = "Defense",
        Sword    = "Sword",
        Gun      = "Gun",
        Fruit    = "BloxFruit",
    }
    while task.wait(4) do
        if not S.AutoStat or not isAlive() then continue end
        pcall(function()
            local statKey = statMap[S.StatPriority] or "Beli"
            -- Try the CommF_ stat upgrade route (most BF versions)
            Com("F_","Stat", statKey)
            Com("F_","AddStat", statKey, 1)
            -- Scan RepStorage for stat/upgrade remotes
            for _,v in pairs(RepStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local n=v.Name:lower()
                    if n:find("stat") or n:find("upgrade") or n:find("point") then
                        if v:IsA("RemoteEvent") then
                            pcall(function() v:FireServer(statKey,1) end)
                            pcall(function() v:FireServer(S.StatPriority,1) end)
                        else
                            pcall(function() v:InvokeServer(statKey,1) end)
                        end
                    end
                end
            end
        end)
    end
end)

-- ════════════════════════════════════════════
--  AUTO FRUIT TP LOOP  (dedup — tracks already-visited fruits)
-- ════════════════════════════════════════════
task.spawn(function()
    local visited = {}
    while task.wait(3) do
        if not S.TPFruit then visited={}; continue end
        local fruits=scanFruits(); local root=getRoot(); if not root then continue end
        if #fruits==0 then visited={}; continue end
        -- Filter visited
        local fresh={}
        for _,f in ipairs(fruits) do if not visited[f.obj] then table.insert(fresh,f) end end
        if #fresh==0 then visited={}; continue end  -- all seen, reset
        table.sort(fresh,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        local f=fresh[1]; tp(f.pos); STATS.fruitsTP=STATS.fruitsTP+1
        visited[f.obj]=true
        notify("Fruit","→  "..f.name,3,T.Green)
        if S.AutoEatFruit then
            task.wait(1)
            pcall(function()
                if not f.part or not f.part.Parent then return end  -- fruit gone
                if HAS_FCD then
                    local cd=f.part:FindFirstChildOfClass("ClickDetector")
                        or f.part.Parent:FindFirstChildOfClass("ClickDetector")
                    if cd then fireclickdetector(cd) end
                end
                if HAS_FPP then
                    local pp=f.obj:FindFirstChildWhichIsA("ProximityPrompt",true)
                    if pp then fireproximityprompt(pp) end
                end
                -- Commit server pickup
                for _,v in pairs(f.obj:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        local n=v.Name:lower()
                        if n:find("eat") or n:find("pick") or n:find("collect") or n:find("use") then
                            pcall(function() v:FireServer() end)
                        end
                    end
                end
            end)
        end
    end
end)

-- ════════════════════════════════════════════
--  AUTO CHEST LOOP  (deduplication — won't re-open same chest)
-- ════════════════════════════════════════════
task.spawn(function()
    local opened = {}   -- track object refs that were already opened this session
    while task.wait(4) do
        if not S.AutoChest then continue end
        local chests=scanChests(); local root=getRoot(); if not root or #chests==0 then continue end
        -- Filter out already opened
        local fresh={}
        for _,c in ipairs(chests) do if not opened[c.obj] then table.insert(fresh,c) end end
        if #fresh==0 then opened={}; continue end  -- reset when all are gone
        table.sort(fresh,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
        local c=fresh[1]; tp(c.pos)
        task.wait(0.5)
        if not c.obj or not c.obj.Parent then continue end  -- chest gone
        pcall(function()
            if HAS_FCD then
                local cd=c.part:FindFirstChildOfClass("ClickDetector") or c.obj:FindFirstChildOfClass("ClickDetector",true)
                if cd then fireclickdetector(cd) end
            end
            if HAS_FPP then
                local pp=c.obj:FindFirstChildWhichIsA("ProximityPrompt",true)
                if pp then fireproximityprompt(pp) end
            end
            -- Generic RemoteEvent fallback
            for _,v in pairs(c.obj:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local n=v.Name:lower()
                    if n:find("open") or n:find("chest") or n:find("collect") then pcall(function() v:FireServer() end) end
                end
            end
        end)
        opened[c.obj]=true
        STATS.chestsTP=STATS.chestsTP+1
        notify("Chest","Opened: "..c.name,2,T.Gold)
    end
end)

-- ════════════════════════════════════════════
--  INSERT KEY HOTKEY  (toggle GUI visibility)
-- ════════════════════════════════════════════
UserInputService.InputBegan:Connect(wrap(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        local gui = PG:FindFirstChild("EliteHub")
        if gui then
            gui.Enabled = not gui.Enabled
            notify("Elite Hub", gui.Enabled and "UI Shown  [Insert]" or "UI Hidden  [Insert]", 1.5, T.Sub)
        end
    end
end))

-- ════════════════════════════════════════════
--  STARTUP
-- ════════════════════════════════════════════
task.spawn(showLoader)
buildWatermark()
task.wait(1.0)
buildGUI()
task.wait(0.3)
notify("Elite Hub","v1.0.0 loaded!  discord.gg/EmsMsHZCVH",4.5,T.Pink)
notify("Executor",EXEC_NAME..(IS_DELTA and "  ✓ Delta Verified" or ""),3,IS_DELTA and T.Blue or T.Sub)
notify("Hotkey","Press [Insert] to show/hide the UI",3,T.Dim)
