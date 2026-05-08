-- ╔══════════════════════════════════════════════════╗
-- ║         ELITE HUB | BLOX FRUITS | by Marcus      ║
-- ║              discord.gg/Pq2dsdfHhE                ║
-- ║         Sea 1 · Sea 2 · Sea 3 | Keyless           ║
-- ╚══════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local StarterGui       = game:GetService("StarterGui")

local LP  = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- ================================================
-- SEA DETECTION
-- ================================================
local PlaceId = game.PlaceId
local Sea = 1
if PlaceId == 4442272183 then Sea = 2
elseif PlaceId == 7449423635 then Sea = 3
end
local SEA_PLACE_IDS = {2753915549, 4442272183, 7449423635}

-- ================================================
-- STATE (All 40+ features)
-- ================================================
local State = {
    -- Main
    AutoRejoin        = false,
    HopServer         = false,
    HopLowServer      = false,
    HopDelay          = 30,
    HopNearPlayer     = false,
    HopForFruit       = false,

    -- Farm Core
    AutoFarm          = false,
    AutoQuest         = false,
    UseSkills         = true,
    AutoEat           = true,
    HealthPct         = 30,
    FarmMob           = "",
    FarmMethod        = "Teleport", -- "Teleport" / "Walk"
    BringMob          = false,
    FastAttack        = false,
    DoubleQuest       = false,
    TeleportBypass    = false,
    AutoHaki          = false,
    AutoKen           = false,
    SelectWeapon      = "None",

    -- Sea Progression
    AutoSecondSea     = false,
    AutoThirdSea      = false,
    AutoBartilo       = false,
    AutoFactory       = false,
    AutoPirateRaid    = false,
    AutoElite         = false,

    -- Melee
    SelectMelee       = "None",
    AutoMelee         = false,

    -- Boss
    SelectBoss        = "None",
    AutoFarmBoss      = false,
    AutoFarmAllBoss   = false,

    -- Mastery
    AutoMastery       = false,
    MasteryType       = "Devil Fruit",
    StartAtMaxLevel   = false,
    AutoUnlockSword   = false,
    StartUnlockAtMax  = false,
    LegendaryOnly     = false,

    -- Devil Fruit
    SelectFruit       = "None",
    FruitSniper       = false,
    AutoFindFruit     = false,
    AutoStoreFruit    = false,
    AutoDealerCousin  = false,
    SnipeNotify       = true,

    -- ESP
    PlayerESP         = false,
    FruitESP          = false,
    FlowerESP         = false,
    ESPDistance       = 2000,

    -- Visual / Performance
    RemoveLavaDmg     = false,
    BoostFPS          = false,

    -- Items
    AutoCollectChest  = false,
    AutoCollectMat    = false,
    AutoEnhance       = false,
    AutoRefine        = false,

    -- UI
    AccentColor       = Color3.fromRGB(120,60,230),
    FloatAnim         = true,
}

local ESPObjects  = {}
local Connections = {}
local Threads     = {}

-- ================================================
-- MOB DATA (Sea 1, 2, 3)
-- ================================================
local MobData = {
    [1] = {
        {Name="Bandit",           Quest="BanditQuest",    Level=1,    QCF=CFrame.new(-1254,5,-1989),   MCF=CFrame.new(-1228,6,-1920)},
        {Name="Monkey",           Quest="MonkeyQuest",    Level=10,   QCF=CFrame.new(-1376,4,-795),    MCF=CFrame.new(-1357,5,-841)},
        {Name="Pirate",           Quest="PirateQuest",    Level=30,   QCF=CFrame.new(944,5,4417),      MCF=CFrame.new(974,6,4379)},
        {Name="Brute",            Quest="BruteQuest",     Level=50,   QCF=CFrame.new(944,5,4417),      MCF=CFrame.new(998,6,4355)},
        {Name="Desert Bandit",    Quest="DesertQuest",    Level=75,   QCF=CFrame.new(893,6,4393),      MCF=CFrame.new(897,6,4360)},
        {Name="Desert Officer",   Quest="DesertQuest",    Level=90,   QCF=CFrame.new(893,6,4393),      MCF=CFrame.new(1547,14,4381)},
        {Name="Snow Bandit",      Quest="SnowQuest",      Level=100,  QCF=CFrame.new(1387,87,-1298),   MCF=CFrame.new(1356,105,-1328)},
        {Name="Snowman",          Quest="SnowQuest",      Level=120,  QCF=CFrame.new(1387,87,-1298),   MCF=CFrame.new(1424,126,-1308)},
        {Name="Warrior",          Quest="WarriorQuest",   Level=150,  QCF=CFrame.new(-3157,10,1098),   MCF=CFrame.new(-3100,7,1090)},
        {Name="Gladiator",        Quest="GladiatorQuest", Level=175,  QCF=CFrame.new(-3157,10,1098),   MCF=CFrame.new(-3200,10,1080)},
        {Name="Fishman",          Quest="FishmanQuest",   Level=200,  QCF=CFrame.new(-3047,-19,3812),  MCF=CFrame.new(-2980,-30,3900)},
        {Name="Fishman Warrior",  Quest="FishmanQuest",   Level=225,  QCF=CFrame.new(-3047,-19,3812),  MCF=CFrame.new(-3060,-35,3830)},
        {Name="Mushroom",         Quest="MushroomQuest",  Level=300,  QCF=CFrame.new(-4640,5,280),     MCF=CFrame.new(-4620,5,350)},
        {Name="Gorilla",          Quest="GorillaQuest",   Level=350,  QCF=CFrame.new(-4680,5,220),     MCF=CFrame.new(-4700,5,180)},
        {Name="LumberJack",       Quest="LumberQuest",    Level=375,  QCF=CFrame.new(4880,5,555),      MCF=CFrame.new(4900,6,600)},
        {Name="Mob (Level 400)",  Quest="Quest",          Level=400,  QCF=CFrame.new(4880,5,555),      MCF=CFrame.new(4920,6,580)},
    },
    [2] = {
        {Name="Raider",              Quest="RaiderQuest",   Level=700,  QCF=CFrame.new(-2076,74,1836),  MCF=CFrame.new(-2100,75,1900)},
        {Name="Mercenary",           Quest="MercQuest",     Level=750,  QCF=CFrame.new(-2076,74,1836),  MCF=CFrame.new(-2050,75,1860)},
        {Name="Marine",              Quest="MarineQuest",   Level=800,  QCF=CFrame.new(-2900,11,1314),  MCF=CFrame.new(-2920,11,1380)},
        {Name="Zombie",              Quest="ZombieQuest",   Level=850,  QCF=CFrame.new(-2390,30,1500),  MCF=CFrame.new(-2400,30,1560)},
        {Name="Vampire",             Quest="VampireQuest",  Level=875,  QCF=CFrame.new(-2390,30,1500),  MCF=CFrame.new(-2380,35,1480)},
        {Name="Snow Trooper",        Quest="SnowTrooper",   Level=900,  QCF=CFrame.new(-2600,145,700),  MCF=CFrame.new(-2580,145,760)},
        {Name="Yeti",                Quest="YetiQuest",     Level=950,  QCF=CFrame.new(-2600,145,700),  MCF=CFrame.new(-2620,145,680)},
        {Name="Factory Staff",       Quest="FactoryQuest",  Level=975,  QCF=CFrame.new(-4180,24,3100),  MCF=CFrame.new(-4200,24,3160)},
        {Name="Ship Deckhand",       Quest="ShipQuest",     Level=1000, QCF=CFrame.new(-4900,10,2400),  MCF=CFrame.new(-4920,10,2460)},
        {Name="Ship Engineer",       Quest="ShipQuest",     Level=1050, QCF=CFrame.new(-4900,10,2400),  MCF=CFrame.new(-4880,10,2380)},
        {Name="Dragon Crew Soldier", Quest="DragonQuest",   Level=1100, QCF=CFrame.new(-5500,15,3000),  MCF=CFrame.new(-5520,15,3060)},
        {Name="Dragon Crew Archer",  Quest="DragonQuest",   Level=1150, QCF=CFrame.new(-5500,15,3000),  MCF=CFrame.new(-5480,15,2980)},
        {Name="Wano Prisoner",       Quest="WanoQuest",     Level=1200, QCF=CFrame.new(-5100,30,3600),  MCF=CFrame.new(-5120,30,3660)},
        {Name="Wano Samurai",        Quest="WanoQuest",     Level=1250, QCF=CFrame.new(-5100,30,3600),  MCF=CFrame.new(-5080,35,3580)},
        {Name="Headless",            Quest="HeadlessQuest", Level=1275, QCF=CFrame.new(-5100,30,3600),  MCF=CFrame.new(-5060,32,3600)},
    },
    [3] = {
        {Name="Pirate Millionaire",       Quest="PMQuest",  Level=1500, QCF=CFrame.new(-14360,120,1640), MCF=CFrame.new(-14380,120,1700)},
        {Name="Forest Pirate",            Quest="FPQuest",  Level=1575, QCF=CFrame.new(-14360,120,1640), MCF=CFrame.new(-14340,120,1620)},
        {Name="Mythological Pirate",      Quest="MPQuest",  Level=1625, QCF=CFrame.new(-12800,115,840),  MCF=CFrame.new(-12820,115,900)},
        {Name="Royal Soldier",            Quest="RSQuest",  Level=1675, QCF=CFrame.new(-12800,115,840),  MCF=CFrame.new(-12780,115,820)},
        {Name="Gamma Zombie",             Quest="GZQuest",  Level=1700, QCF=CFrame.new(-12200,100,2600), MCF=CFrame.new(-12220,100,2660)},
        {Name="Demonic Soul",             Quest="DSQuest",  Level=1750, QCF=CFrame.new(-12200,100,2600), MCF=CFrame.new(-12180,100,2580)},
        {Name="Cursed Dual Katana Fight", Quest="CDQuest",  Level=1800, QCF=CFrame.new(-9800,95,1700),   MCF=CFrame.new(-9820,95,1760)},
        {Name="Haunted Pirate",           Quest="HPQuest",  Level=1875, QCF=CFrame.new(-9800,95,1700),   MCF=CFrame.new(-9780,95,1680)},
        {Name="Reborn Skeleton",          Quest="RBQuest",  Level=1925, QCF=CFrame.new(-9200,90,2400),   MCF=CFrame.new(-9220,90,2460)},
        {Name="Living Zombie",            Quest="LZQuest",  Level=1975, QCF=CFrame.new(-9200,90,2400),   MCF=CFrame.new(-9180,90,2380)},
        {Name="Poseidon",                 Quest="POQuest",  Level=2025, QCF=CFrame.new(-8600,80,3200),   MCF=CFrame.new(-8620,80,3260)},
        {Name="Rider",                    Quest="RiderQ",   Level=2075, QCF=CFrame.new(-8600,80,3200),   MCF=CFrame.new(-8580,80,3180)},
        {Name="Enforcers",                Quest="EnfQuest", Level=2125, QCF=CFrame.new(-7800,75,4000),   MCF=CFrame.new(-7820,75,4060)},
        {Name="Peanut Scout",             Quest="PNQuest",  Level=2175, QCF=CFrame.new(-7800,75,4000),   MCF=CFrame.new(-7780,75,3980)},
        {Name="Peanut President",         Quest="PPQuest",  Level=2225, QCF=CFrame.new(-7800,75,4000),   MCF=CFrame.new(-7760,76,3960)},
        {Name="Ice Cream Chef",           Quest="ICQuest",  Level=2275, QCF=CFrame.new(-7200,70,4800),   MCF=CFrame.new(-7220,70,4860)},
        {Name="Ice Cream Commander",      Quest="ICCQuest", Level=2325, QCF=CFrame.new(-7200,70,4800),   MCF=CFrame.new(-7180,70,4780)},
    },
}

local BossData = {
    {Name="Gorilla King",    Sea=1, CF=CFrame.new(-4690,5,195)},
    {Name="Bobby",           Sea=1, CF=CFrame.new(-4810,5,410)},
    {Name="Yeti",            Sea=1, CF=CFrame.new(1390,88,-1298)},
    {Name="Mob Leader",      Sea=1, CF=CFrame.new(944,5,4360)},
    {Name="Wysper",          Sea=2, CF=CFrame.new(-4360,450,1340)},
    {Name="Thunder God",     Sea=2, CF=CFrame.new(-4360,450,1340)},
    {Name="Tide Keeper",     Sea=2, CF=CFrame.new(-4900,10,2400)},
    {Name="Cake Prince",     Sea=3, CF=CFrame.new(-7200,70,4800)},
    {Name="Island Empress",  Sea=3, CF=CFrame.new(-12800,115,840)},
    {Name="Kilo Admiral",    Sea=3, CF=CFrame.new(-14360,120,1640)},
    {Name="Captain Elephant",Sea=3, CF=CFrame.new(-9200,90,2400)},
    {Name="Beautiful Pirate",Sea=3, CF=CFrame.new(-9800,95,1700)},
}

local TeleportData = {
    [1] = {
        {Name="Starter Island",   CF=CFrame.new(-1254,5,-1989)},
        {Name="Marine Starter",   CF=CFrame.new(-1376,4,-795)},
        {Name="Jungle",           CF=CFrame.new(-1660,12,236)},
        {Name="Pirate Village",   CF=CFrame.new(944,5,4350)},
        {Name="Desert",           CF=CFrame.new(893,6,4390)},
        {Name="Snow Island",      CF=CFrame.new(1390,88,-1298)},
        {Name="Marine Fortress",  CF=CFrame.new(-3160,10,1100)},
        {Name="Skylands",         CF=CFrame.new(-4640,450,280)},
        {Name="Colosseum",        CF=CFrame.new(-3200,10,1400)},
        {Name="Fishman Island",   CF=CFrame.new(-3050,-10,3800)},
        {Name="Fountain City",    CF=CFrame.new(-4670,5,250)},
    },
    [2] = {
        {Name="Kingdom of Rose",  CF=CFrame.new(-2076,74,1836)},
        {Name="Dark Arena",       CF=CFrame.new(-2900,11,1314)},
        {Name="Graveyard",        CF=CFrame.new(-2390,30,1500)},
        {Name="Snow Mountain",    CF=CFrame.new(-2600,145,700)},
        {Name="Magma Village",    CF=CFrame.new(-4180,24,3100)},
        {Name="Underwater (S2)",  CF=CFrame.new(-4900,10,2400)},
        {Name="Wano",             CF=CFrame.new(-5100,30,3600)},
        {Name="Skylands (S2)",    CF=CFrame.new(-4360,450,1340)},
    },
    [3] = {
        {Name="Port Town",        CF=CFrame.new(-14360,120,1640)},
        {Name="Floating Turtle",  CF=CFrame.new(-12800,115,840)},
        {Name="Haunted Castle",   CF=CFrame.new(-9800,95,1700)},
        {Name="Sea of Treats",    CF=CFrame.new(-7200,70,4800)},
        {Name="Mirage Island",    CF=CFrame.new(-8000,80,3500)},
        {Name="Mansion",          CF=CFrame.new(-9200,90,2400)},
    },
}

local Codes = {
    "Sub2Fer999","Sub2UncleKizaru","Sub2OfficialNoobie","BIGNEWS",
    "Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy",
    "StrawHatMaine","TantaiGaming","Sub2Daigrock","Sub2CaptainMaui",
    "Sub2Mirze","Sub2OgVexx","TheGreatAce","Sub2Kepe","fudd10_v2",
    "Sub2Daigrock","kittgaming","Axiore","notsonoob","Kevingaming",
}

local FruitNames = {
    "None","Bomb","Spike","Chop","Spring","Kilo","Smoke","Flame",
    "Ice","Sand","Dark","Light","Rubber","Barrier","Magma","Quake",
    "Buddha","Love","Spider","Shadow","Venom","Control","Door","Pain",
    "Blizzard","Gravity","Dough","Sound","Leopard","Kitsune","Dragon",
    "T-Rex","Mammoth","Soul","Rumble","Phoenix","Revive","Paw",
    "String","Tremor","Human:Buddha","Giraffe","Ghoul","Yeti",
}

local MeleeNames = {"None","Superhuman","Electric Claw","Dark Step","Water Kung Fu","Dragon Talon","Sharkman Karate","Death Step","Godhuman"}
local WeaponNames = {"None","Katana","Dual Katana","Iron Mace","Triple Dark Blade","Saber","True Triple Katana","Dark Blade","Pole (1st Form)"}

local LegendarySwords = {"True Triple Katana","Dark Blade","Pole (2nd Form)","Yama","Tushita","Dragon Trident","Hallow Scythe","Saddi","Wando","Shisui","Rengoku","Buddy Sword","Gravity Cane","Soul Cane","Black Spade","Midnight Blade"}

-- ================================================
-- UTILITIES
-- ================================================
local function getChar()   return LP.Character end
local function getRoot()   local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()    local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end

local function safeTeleport(cf, bypass)
    local root = getRoot()
    if not root then return end
    if bypass or State.TeleportBypass then
        -- use multiple small hops to bypass anti-cheat detection
        local startPos = root.CFrame
        local targetPos = cf
        local steps = 3
        for i = 1, steps do
            local alpha = i / steps
            local lerpCF = startPos:Lerp(targetPos, alpha)
            root.CFrame = lerpCF
            task.wait(0.05)
        end
    else
        root.CFrame = cf
    end
end

local function remoteInvoke(...)
    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
    if remote then
        return pcall(function() remote:InvokeServer(...) end)
    end
end

local function remoteEvent(...)
    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")
    if remote then
        pcall(function() remote:FireServer(...) end)
    end
end

local function getMobs()
    local mobs = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, v in ipairs(enemies:GetChildren()) do
            local h = v:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                table.insert(mobs, v)
            end
        end
    end
    return mobs
end

local function getNearestMob(name)
    local root = getRoot()
    if not root then return nil end
    local nearest, dist = nil, math.huge
    for _, mob in ipairs(getMobs()) do
        if name == "" or mob.Name:lower():find(name:lower()) then
            local d = (mob.HumanoidRootPart.Position - root.Position).Magnitude
            if d < dist then dist = d nearest = mob end
        end
    end
    return nearest
end

local function cancelThread(key)
    if Threads[key] then
        task.cancel(Threads[key])
        Threads[key] = nil
    end
end

local function spawnThread(key, fn)
    cancelThread(key)
    Threads[key] = task.spawn(fn)
end

local function useSkills()
    for _, key in ipairs({"z","x","c","v","f"}) do
        pcall(function()
            if key == "f" then
                keypress(102) task.wait(0.05) keyrelease(102)
            else
                keypress(string.byte(key)) task.wait(0.08) keyrelease(string.byte(key))
            end
        end)
        task.wait(0.05)
    end
end

local function attackMob(mob)
    if not mob or not mob.Parent then return end
    remoteInvoke("attack", mob)
    if State.FastAttack then
        task.wait(0.05)
        remoteInvoke("attack", mob)
    end
end

local function bringMobToPlayer(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    local root = getRoot()
    if root then
        mob.HumanoidRootPart.CFrame = root.CFrame + root.CFrame.LookVector * 5
    end
end

-- ================================================
-- ANTI-DETECT HELPERS
-- ================================================
local function randomWait(base)
    task.wait(base + math.random() * base * 0.3)
end

local function humanizedTeleport(cf)
    -- Add tiny random offset so teleport coords aren't perfectly identical
    local offset = Vector3.new(
        (math.random() - 0.5) * 2,
        0,
        (math.random() - 0.5) * 2
    )
    safeTeleport(CFrame.new(cf.Position + offset) * cf.Rotation)
end

-- ================================================
-- FEATURE LOOPS
-- ================================================

-- AUTO FARM
local function doAutoQuest(mobData)
    if not mobData then return end
    humanizedTeleport(mobData.QCF)
    randomWait(0.7)
    remoteInvoke("startQuest", mobData.Quest, mobData.Level)
    if State.DoubleQuest then
        task.wait(0.2)
        remoteInvoke("startQuest", mobData.Quest, mobData.Level)
    end
    randomWait(0.3)
end

local function startFarmLoop()
    spawnThread("farm", function()
        while State.AutoFarm do
            local hum  = getHum()
            local root = getRoot()
            if not hum or not root or hum.Health <= 0 then
                task.wait(1); continue
            end

            -- Auto heal
            if State.AutoEat and hum.Health / hum.MaxHealth * 100 < State.HealthPct then
                remoteInvoke("eatFruit")
                task.wait(0.5)
            end

            -- Haki & Ken
            if State.AutoHaki then
                remoteInvoke("Buso"); task.wait(0.1)
            end
            if State.AutoKen then
                remoteInvoke("Ken"); task.wait(0.1)
            end

            local seaMobs = MobData[Sea] or MobData[1]
            local targetMobData
            for _, m in ipairs(seaMobs) do
                if State.FarmMob == "" or m.Name:lower():find(State.FarmMob:lower()) then
                    targetMobData = m; break
                end
            end

            if State.AutoQuest and targetMobData then
                doAutoQuest(targetMobData)
            end

            local mob = getNearestMob(State.FarmMob)
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                if State.BringMob then
                    bringMobToPlayer(mob)
                else
                    local offset = (root.CFrame.LookVector * -5)
                    local targetCF = CFrame.new(mob.HumanoidRootPart.Position + offset + Vector3.new(0,3,0))
                    humanizedTeleport(targetCF)
                end
                task.wait(0.1)
                if State.UseSkills then useSkills() end
                attackMob(mob)
            elseif targetMobData then
                humanizedTeleport(targetMobData.MCF)
            end
            randomWait(0.12)
        end
    end)
end

-- AUTO SECOND SEA
local function startSecondSeaFarm()
    spawnThread("sea2", function()
        while State.AutoSecondSea do
            -- Teleport to Kingdom of Rose quest giver
            humanizedTeleport(CFrame.new(-2076,74,1836))
            task.wait(1)
            remoteInvoke("startQuest","RaiderQuest",700)
            task.wait(0.5)
            -- Farm Raider
            humanizedTeleport(CFrame.new(-2100,75,1900))
            task.wait(0.3)
            local mob = getNearestMob("Raider")
            if mob then attackMob(mob) end
            randomWait(0.8)
        end
    end)
end

-- AUTO THIRD SEA
local function startThirdSeaFarm()
    spawnThread("sea3", function()
        while State.AutoThirdSea do
            humanizedTeleport(CFrame.new(-14360,120,1640))
            task.wait(1)
            remoteInvoke("startQuest","PMQuest",1500)
            task.wait(0.5)
            humanizedTeleport(CFrame.new(-14380,120,1700))
            task.wait(0.3)
            local mob = getNearestMob("Pirate Millionaire")
            if mob then attackMob(mob) end
            randomWait(0.8)
        end
    end)
end

-- BARTILO QUEST (Sea 2 - gives Saber Expert quest)
local function startBartiloFarm()
    spawnThread("bartilo", function()
        while State.AutoBartilo do
            humanizedTeleport(CFrame.new(-2076,74,1836))
            task.wait(0.8)
            remoteInvoke("TalkToBartilo")
            task.wait(0.5)
            humanizedTeleport(CFrame.new(-2076,74,1836))
            randomWait(1)
        end
    end)
end

-- FACTORY (Sea 2)
local function startFactoryFarm()
    spawnThread("factory", function()
        while State.AutoFactory do
            humanizedTeleport(CFrame.new(-4180,24,3100))
            task.wait(0.8)
            remoteInvoke("startQuest","FactoryQuest",975)
            task.wait(0.5)
            local mob = getNearestMob("Factory Staff")
            if mob then
                humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,3,0)))
                task.wait(0.1)
                if State.UseSkills then useSkills() end
                attackMob(mob)
            end
            randomWait(0.5)
        end
    end)
end

-- PIRATE RAID
local function startPirateRaid()
    spawnThread("pirateraid", function()
        while State.AutoPirateRaid do
            remoteInvoke("JoinRaid")
            task.wait(1)
            local mob = getNearestMob("")
            if mob then
                humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,3,0)))
                task.wait(0.1)
                if State.UseSkills then useSkills() end
                attackMob(mob)
            end
            randomWait(0.5)
        end
    end)
end

-- AUTO ELITE (Sea 3 Elite Hunter)
local function startEliteFarm()
    spawnThread("elite", function()
        while State.AutoElite do
            remoteInvoke("StartElite")
            task.wait(0.5)
            local mob = getNearestMob("Elite")
            if mob then
                humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,3,0)))
                task.wait(0.1)
                if State.UseSkills then useSkills() end
                attackMob(mob)
            end
            randomWait(0.8)
        end
    end)
end

-- AUTO MELEE
local function startMeleeFarm()
    spawnThread("melee", function()
        while State.AutoMelee do
            local mob = getNearestMob("")
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,3,0)))
                task.wait(0.1)
                remoteInvoke("attack", mob)
                -- Melee skills Z X C
                for _, key in ipairs({"z","x","c"}) do
                    pcall(function()
                        keypress(string.byte(key)) task.wait(0.05) keyrelease(string.byte(key))
                    end)
                    task.wait(0.04)
                end
            end
            randomWait(0.12)
        end
    end)
end

-- AUTO BOSS FARM
local function startBossFarm(bossName, allBosses)
    spawnThread("boss", function()
        while State.AutoFarmBoss or State.AutoFarmAllBoss do
            local bossList = allBosses and BossData or (function()
                local t={}
                for _, b in ipairs(BossData) do
                    if b.Name:lower():find((bossName or ""):lower()) then table.insert(t,b) end
                end
                return t
            end)()
            for _, boss in ipairs(bossList) do
                humanizedTeleport(boss.CF)
                task.wait(0.5)
                local mob = getNearestMob(boss.Name)
                if mob then
                    for i = 1, 20 do
                        if not (State.AutoFarmBoss or State.AutoFarmAllBoss) then break end
                        local root = getRoot()
                        if root and mob.Parent and mob:FindFirstChildOfClass("Humanoid") then
                            local h = mob:FindFirstChildOfClass("Humanoid")
                            if h.Health <= 0 then break end
                            humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,4,0)))
                            task.wait(0.08)
                            if State.UseSkills then useSkills() end
                            attackMob(mob)
                        end
                        task.wait(0.1)
                    end
                end
            end
            randomWait(0.5)
        end
    end)
end

-- AUTO MASTERY
local function startMasteryFarm()
    spawnThread("mastery", function()
        while State.AutoMastery do
            local hum = getHum()
            if State.StartAtMaxLevel and hum then
                -- only farm if near max
            end
            local mob = getNearestMob("")
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,3,0)))
                task.wait(0.08)
                if State.MasteryType == "Devil Fruit" then
                    for _, key in ipairs({"z","x","c","v"}) do
                        pcall(function() keypress(string.byte(key)) task.wait(0.05) keyrelease(string.byte(key)) end)
                        task.wait(0.04)
                    end
                else
                    for _, key in ipairs({"z","x","c"}) do
                        pcall(function() keypress(string.byte(key)) task.wait(0.05) keyrelease(string.byte(key)) end)
                        task.wait(0.04)
                    end
                end
                attackMob(mob)
            end
            randomWait(0.12)
        end
    end)
end

-- AUTO UNLOCK SWORD SKILL
local function startSwordUnlock()
    spawnThread("swordunlock", function()
        while State.AutoUnlockSword do
            local mob = getNearestMob("")
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                humanizedTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,3,0)))
                task.wait(0.08)
                -- Sword skill keys
                for _, key in ipairs({"z","x","c"}) do
                    pcall(function() keypress(string.byte(key)) task.wait(0.05) keyrelease(string.byte(key)) end)
                    task.wait(0.04)
                end
                attackMob(mob)
            end
            randomWait(0.12)
        end
    end)
end

-- FRUIT SNIPER
local function startSnipeLoop()
    spawnThread("snipe", function()
        while State.FruitSniper do
            pcall(function()
                -- Check fruit folders
                local folders = {
                    Workspace:FindFirstChild("Fruits"),
                    Workspace:FindFirstChild("droppedFruits"),
                    Workspace:FindFirstChild("ItemSpawner"),
                }
                for _, folder in ipairs(folders) do
                    if folder then
                        for _, fruit in ipairs(folder:GetChildren()) do
                            local h = fruit:FindFirstChild("Handle") or fruit:FindFirstChildOfClass("BasePart")
                            if h then
                                if State.SnipeNotify then
                                    -- notify handled below
                                end
                                humanizedTeleport(CFrame.new(h.Position + Vector3.new(0,3,0)))
                                task.wait(0.3)
                                remoteInvoke("Eat", fruit)
                                task.wait(0.2)
                            end
                        end
                    end
                end
                -- Also scan descendants
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v.Name == "Fruit" and v:IsA("Model") then
                        local h = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("BasePart")
                        if h then
                            humanizedTeleport(CFrame.new(h.Position + Vector3.new(0,3,0)))
                            task.wait(0.3)
                            remoteInvoke("Eat", v)
                            task.wait(0.2)
                        end
                    end
                end
            end)
            task.wait(0.8)
        end
    end)
end

-- AUTO FIND FRUIT (teleport around map scanning)
local function startAutoFindFruit()
    spawnThread("findfruit", function()
        while State.AutoFindFruit do
            local scanPoints = {
                CFrame.new(0, 100, 0),
                CFrame.new(1000, 100, 0),
                CFrame.new(-1000, 100, 0),
                CFrame.new(0, 100, 1000),
                CFrame.new(0, 100, -1000),
            }
            for _, pt in ipairs(scanPoints) do
                if not State.AutoFindFruit then break end
                humanizedTeleport(pt)
                task.wait(0.5)
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:find("Fruit") or v.Name:find("fruit")) then
                        local h = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("BasePart")
                        if h then
                            humanizedTeleport(CFrame.new(h.Position + Vector3.new(0,3,0)))
                            task.wait(0.3)
                            remoteInvoke("Eat", v)
                            break
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

-- AUTO STORE FRUIT
local function startAutoStoreFruit()
    spawnThread("storefruit", function()
        while State.AutoStoreFruit do
            remoteInvoke("StoreFruit")
            task.wait(2)
        end
    end)
end

-- AUTO DEALER COUSIN
local function startDealerCousin()
    spawnThread("dealercousin", function()
        while State.AutoDealerCousin do
            -- Teleport to Cousin NPC location (varies by sea)
            local cousinCF = {
                [1] = CFrame.new(-1600,8,200),
                [2] = CFrame.new(-1800,50,600),
                [3] = CFrame.new(-14000,120,1200),
            }
            humanizedTeleport(cousinCF[Sea] or cousinCF[1])
            task.wait(0.8)
            remoteInvoke("TalkToDealer")
            task.wait(1)
            remoteInvoke("BuyFruit", State.SelectFruit)
            task.wait(2)
        end
    end)
end

-- HOP SERVER
local function hopServer()
    local servers = {}
    pcall(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            )
        end)
        if ok and data and data.data then
            servers = data.data
        end
    end)
    if #servers > 0 then
        local targetServer = servers[math.random(#servers)]
        TeleportService:TeleportToPlaceInstance(PlaceId, targetServer.id, LP)
    else
        TeleportService:Teleport(PlaceId, LP)
    end
end

local function hopLowServer()
    pcall(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            )
        end)
        if ok and data and data.data then
            local lowest, lId = math.huge, nil
            for _, s in ipairs(data.data) do
                if s.playing and s.playing < lowest then
                    lowest = s.playing
                    lId = s.id
                end
            end
            if lId then
                TeleportService:TeleportToPlaceInstance(PlaceId, lId, LP)
            end
        end
    end)
end

local function startHopServerLoop()
    spawnThread("hoploop", function()
        while State.HopServer or State.HopNearPlayer or State.HopForFruit do
            task.wait(State.HopDelay)
            if State.HopNearPlayer then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local myRoot = getRoot()
                        if myRoot then
                            local d = (p.Character:FindFirstChild("HumanoidRootPart") and
                                (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude) or math.huge
                            if d < 80 then hopServer() return end
                        end
                    end
                end
            elseif State.HopForFruit then
                -- Check if any fruit worth 1M+ exists (Sea 3)
                local highValueFruits = {"Leopard","Dragon","Kitsune","Dough","Control","Venom","Shadow","Spirit","Mammoth","T-Rex","Sound"}
                for _, v in ipairs(Workspace:GetDescendants()) do
                    for _, hv in ipairs(highValueFruits) do
                        if v.Name:find(hv) then return end -- found! don't hop
                    end
                end
                hopServer()
            elseif State.HopServer then
                hopServer()
            end
        end
    end)
end

-- AUTO REJOIN ON KICK
local function setupAutoRejoin()
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            task.wait(3)
            TeleportService:Teleport(PlaceId, LP)
        end
    end)
    -- Also catch kick via network disconnect
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        -- auto click continue if game tries to kick for idle
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title="Elite Hub", Text="Anti-Idle triggered"})
        end)
    end)
end

-- REDEEM CODES
local function redeemAllCodes()
    for _, code in ipairs(Codes) do
        pcall(function()
            remoteInvoke("getPresentCode", code)
        end)
        task.wait(0.2)
    end
end

-- REMOVE LAVA DAMAGE
local function setupRemoveLava()
    spawnThread("lava", function()
        while State.RemoveLavaDmg do
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("lava") or part.Name:lower():find("magma")) then
                    part.CanTouch = false
                end
            end
            task.wait(1)
        end
    end)
end

-- BOOST FPS
local function applyFPSBoost(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end

-- AUTO COLLECT CHEST/MATERIAL
local function startAutoCollect()
    spawnThread("collect", function()
        while State.AutoCollectChest or State.AutoCollectMat do
            for _, v in ipairs(Workspace:GetDescendants()) do
                local isChest = State.AutoCollectChest and (v.Name:find("Chest") or v.Name:find("chest"))
                local isMat   = State.AutoCollectMat   and (v.Name:find("Material") or v.Name:find("Crystal") or v.Name:find("Flower"))
                if (isChest or isMat) and v:IsA("Model") then
                    local h = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("BasePart")
                    if h then
                        humanizedTeleport(CFrame.new(h.Position + Vector3.new(0,3,0)))
                        task.wait(0.3)
                        remoteInvoke("Collect", v)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(1)
        end
    end)
end

-- ================================================
-- ESP SYSTEM (Fixed - no mouse interference)
-- ================================================
local function clearESP()
    for _, v in pairs(ESPObjects) do
        pcall(function() v:Destroy() end)
    end
    ESPObjects = {}
end

local function createESPForTarget(target, label, color)
    local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildOfClass("BasePart")
    if not root then return end

    -- Use BillboardGui parented to CoreGui (no mouse impact)
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 90, 0, 38)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = root
    bb.MaxDistance = State.ESPDistance
    bb.ResetOnSpawn = false
    bb.ClipsDescendants = false
    bb.Active = false   -- CRITICAL: prevents mouse event capture
    bb.Parent = CoreGui

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1,0,0.55,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = label
    nameLbl.TextColor3 = color
    nameLbl.TextStrokeTransparency = 0.4
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.RichText = false
    nameLbl.Parent = bb

    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(1,0,0.45,0)
    distLbl.Position = UDim2.new(0,0,0.55,0)
    distLbl.BackgroundTransparency = 1
    distLbl.TextColor3 = Color3.fromRGB(230,230,230)
    distLbl.TextStrokeTransparency = 0.5
    distLbl.Font = Enum.Font.Gotham
    distLbl.TextSize = 11
    distLbl.Parent = bb

    local key = label .. tostring(target)
    ESPObjects[key] = bb

    -- Update distance label (Heartbeat is fine, low overhead)
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not bb.Parent or not root.Parent then
            conn:Disconnect()
            ESPObjects[key] = nil
            return
        end
        local myRoot = getRoot()
        if myRoot then
            local d = math.floor((root.Position - myRoot.Position).Magnitude)
            distLbl.Text = d .. "m"
        end
    end)
end

local function refreshESP()
    clearESP()
    if State.PlayerESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                createESPForTarget(p.Character, p.Name, Color3.fromRGB(255,75,75))
            end
        end
    end
    if State.FruitESP then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Fruit") then
                createESPForTarget(v, "🍎 "..v.Name, Color3.fromRGB(255,200,50))
            end
        end
    end
    if State.FlowerESP then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and (v.Name:find("Flower") or v.Name:find("flower")) then
                createESPForTarget(v, "🌸 "..v.Name, Color3.fromRGB(255,150,220))
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if State.PlayerESP then
            createESPForTarget(p.Character, p.Name, Color3.fromRGB(255,75,75))
        end
    end)
end)

-- ================================================
-- COLOR SYSTEM (Global, updates everything)
-- ================================================
local AccentElements = {} -- {object, property}

local function registerAccent(obj, prop)
    table.insert(AccentElements, {obj=obj, prop=prop})
end

local function applyAccentColor(col)
    State.AccentColor = col
    for _, e in ipairs(AccentElements) do
        pcall(function() e.obj[e.prop] = col end)
    end
end

-- ================================================
-- UI LIBRARY
-- ================================================
local function safeParent(gui)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then gui.Parent = LP:WaitForChild("PlayerGui") end
end

local T = {
    BG      = Color3.fromRGB(11,11,17),
    BG2     = Color3.fromRGB(17,17,26),
    BG3     = Color3.fromRGB(23,23,36),
    Side    = Color3.fromRGB(14,14,22),
    Hover   = Color3.fromRGB(28,22,50),
    Text    = Color3.fromRGB(235,235,235),
    Dim     = Color3.fromRGB(140,140,165),
    Border  = Color3.fromRGB(35,35,52),
}

local function corner(p,r)
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p return c
end
local function stroke(p,col,t)
    local s=Instance.new("UIStroke") s.Color=col or T.Border s.Thickness=t or 1 s.Parent=p return s
end
local function Frame(parent,size,pos,color)
    local f=Instance.new("Frame")
    f.Size=size or UDim2.new(1,0,0,30)
    f.Position=pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3=color or T.BG2
    f.BorderSizePixel=0 f.Parent=parent return f
end
local function Label(parent,text,size,pos,color,font,xa)
    local l=Instance.new("TextLabel")
    l.Size=size or UDim2.new(1,0,1,0)
    l.Position=pos or UDim2.new(0,0,0,0)
    l.BackgroundTransparency=1
    l.Text=text or "" l.TextColor3=color or T.Text
    l.TextSize=12 l.Font=font or Enum.Font.GothamMedium
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.Parent=parent return l
end
local function Btn(parent,size,pos)
    local b=Instance.new("TextButton")
    b.Size=size or UDim2.new(1,0,0,30)
    b.Position=pos or UDim2.new(0,0,0,0)
    b.BackgroundTransparency=1 b.Text="" b.AutoButtonColor=false
    b.BorderSizePixel=0 b.Parent=parent return b
end
local function tw(obj,props,t,s)
    TweenService:Create(obj,TweenInfo.new(t or 0.2,s or Enum.EasingStyle.Quad),props):Play()
end

-- ================================================
-- NOTIFICATION SYSTEM
-- ================================================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "EliteNotify"
notifGui.ResetOnSpawn = false
notifGui.DisplayOrder = 999
safeParent(notifGui)

local notifHolder = Frame(notifGui, UDim2.new(0,250,1,0), UDim2.new(1,-258,0,0), Color3.new(0,0,0))
notifHolder.BackgroundTransparency = 1
local nLayout = Instance.new("UIListLayout")
nLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
nLayout.Padding = UDim.new(0,5)
nLayout.Parent = notifHolder
local nPad = Instance.new("UIPadding")
nPad.PaddingBottom = UDim.new(0,10)
nPad.Parent = notifHolder

local function Notify(title, body, dur)
    dur = dur or 4
    local card = Frame(notifHolder, UDim2.new(1,0,0,56), nil, T.BG2)
    card.BackgroundTransparency = 1
    corner(card, 9)
    local cardStroke = stroke(card, State.AccentColor, 1)
    registerAccent(cardStroke, "Color")

    local bar = Frame(card, UDim2.new(0,3,1,-10), UDim2.new(0,5,0,5), State.AccentColor)
    corner(bar, 3)
    registerAccent(bar, "BackgroundColor3")

    local tl = Label(card, title, UDim2.new(1,-20,0,18), UDim2.new(0,14,0,5), State.AccentColor, Enum.Font.GothamBold)
    tl.TextSize = 12
    registerAccent(tl, "TextColor3")

    local bl = Label(card, body, UDim2.new(1,-20,0,15), UDim2.new(0,14,0,26), T.Dim, Enum.Font.Gotham)
    bl.TextSize = 10

    tw(card, {BackgroundTransparency=0}, 0.3)
    task.delay(dur, function()
        tw(card, {BackgroundTransparency=1}, 0.3)
        task.wait(0.35)
        pcall(function() card:Destroy() end)
    end)
end

-- ================================================
-- MAIN GUI
-- ================================================
-- Remove old instances
for _, g in ipairs(CoreGui:GetChildren()) do
    if g.Name == "EliteHub" or g.Name == "EliteNotify" then g:Destroy() end
end
if LP.PlayerGui:FindFirstChild("EliteHub") then LP.PlayerGui.EliteHub:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "EliteHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
safeParent(gui)

-- Compact size: 480 x 320
local WIN_W, WIN_H = 480, 320
local SIDE_W = 120
local win = Frame(gui, UDim2.fromOffset(WIN_W, WIN_H), UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2), T.BG)
corner(win, 10)
local winStroke = stroke(win, T.Border, 1)

-- Floating animation
local floatT = 0
local floatConn = RunService.Heartbeat:Connect(function(dt)
    if not State.FloatAnim then return end
    floatT = floatT + dt * 1.2
    win.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2 + math.sin(floatT)*2.5)
end)

-- DRAG (Fixed - only drag bar area, no mouse interference)
local dragging, dragStart, winStart
local DRAG_H = 36
local dragBar = Btn(win, UDim2.new(1,-SIDE_W-10,0,DRAG_H), UDim2.new(0,0,0,0))
dragBar.ZIndex = 10

dragBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        winStart = win.Position
        State.FloatAnim = false
    end
end)
dragBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        win.Position = UDim2.new(
            winStart.X.Scale, winStart.X.Offset + delta.X,
            winStart.Y.Scale, winStart.Y.Offset + delta.Y
        )
    end
end)

-- SIDEBAR (right)
local sidebar = Frame(win, UDim2.new(0,SIDE_W,1,0), UDim2.new(1,-SIDE_W,0,0), T.Side)
corner(sidebar, 10)
-- Square off left corners
local sideSquare = Frame(sidebar, UDim2.new(0,12,1,0), UDim2.new(0,0,0,0), T.Side)

-- Logo area
local logoArea = Frame(sidebar, UDim2.new(1,0,0,56), nil, T.Side)
local logoTxt = Label(logoArea, "ELITE HUB", UDim2.new(1,-6,0,18), UDim2.new(0,3,0,8), T.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
logoTxt.TextSize = 13
local underline = Frame(logoArea, UDim2.new(0,44,0,2), UDim2.new(0.5,-22,0,30), State.AccentColor)
corner(underline, 2)
registerAccent(underline, "BackgroundColor3")
local subTxt = Label(logoArea, "S"..Sea.." | by Marcus", UDim2.new(1,-4,0,10), UDim2.new(0,2,0,36), T.Dim, Enum.Font.Gotham, Enum.TextXAlignment.Center)
subTxt.TextSize = 9

-- Tab scroll (sidebar)
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1,0,1,-58)
tabScroll.Position = UDim2.new(0,0,0,58)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 0
tabScroll.CanvasSize = UDim2.new(0,0,0,0)
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabScroll.Parent = sidebar

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0,1)
tabLayout.Parent = tabScroll
local tabPad = Instance.new("UIPadding")
tabPad.PaddingTop = UDim.new(0,3)
tabPad.PaddingLeft = UDim.new(0,5)
tabPad.PaddingRight = UDim.new(0,5)
tabPad.Parent = tabScroll

-- Content area (left of sidebar)
local content = Frame(win, UDim2.new(1,-SIDE_W-8,1,-8), UDim2.new(0,4,0,4), T.BG2)
corner(content, 8)

-- ================================================
-- TAB SYSTEM
-- ================================================
local tabs = {}
local activeTab = nil

local function createTab(name, icon)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,-4,1,-4)
    page.Position = UDim2.new(0,2,0,2)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = State.AccentColor
    registerAccent(page, "ScrollBarImageColor3")
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = content

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0,3)
    pageLayout.Parent = page
    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0,4)
    pagePad.PaddingLeft = UDim.new(0,3)
    pagePad.PaddingRight = UDim.new(0,4)
    pagePad.Parent = page

    -- Tab button (sidebar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,28)
    btn.BackgroundColor3 = T.Side
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = tabScroll
    corner(btn, 6)

    local indicator = Frame(btn, UDim2.new(0,2,0,14), UDim2.new(0,0,0.5,-7), State.AccentColor)
    corner(indicator, 2)
    indicator.Visible = false
    registerAccent(indicator, "BackgroundColor3")

    local btnL = Label(btn, (icon and icon.." " or "")..name, UDim2.new(1,-10,1,0), UDim2.new(0,8,0,0), T.Dim, Enum.Font.GothamMedium)
    btnL.TextSize = 11

    local function activate()
        if activeTab == name then return end
        if activeTab and tabs[activeTab] then
            tabs[activeTab].page.Visible = false
            tw(tabs[activeTab].btn, {BackgroundTransparency=1}, 0.12)
            tw(tabs[activeTab].label, {TextColor3=T.Dim}, 0.12)
            tabs[activeTab].indicator.Visible = false
        end
        activeTab = name
        page.Visible = true
        indicator.Visible = true
        tw(btn, {BackgroundTransparency=0, BackgroundColor3=Color3.fromRGB(22,16,40)}, 0.12)
        tw(btnL, {TextColor3=T.Text}, 0.12)
    end

    btn.MouseButton1Click:Connect(activate)
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then tw(btn, {BackgroundTransparency=0.75}, 0.08) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then tw(btn, {BackgroundTransparency=1}, 0.08) end
    end)

    if not activeTab then
        tabs[name] = {page=page,btn=btn,label=btnL,indicator=indicator,activate=activate}
        activate()
    else
        tabs[name] = {page=page,btn=btn,label=btnL,indicator=indicator,activate=activate}
    end

    local Tab = {}
    local order = 0
    local function nextOrder() order=order+1 return order end

    function Tab:Section(title)
        local w = Frame(page, UDim2.new(1,0,0,20), nil, Color3.new(0,0,0))
        w.BackgroundTransparency = 1
        w.LayoutOrder = nextOrder()
        local sl = Label(w, title, UDim2.new(0,0,1,0), UDim2.new(0,4,0,0), State.AccentColor, Enum.Font.GothamBold)
        sl.TextSize = 10
        sl.AutomaticSize = Enum.AutomaticSize.X
        registerAccent(sl, "TextColor3")
        local line = Frame(w, UDim2.new(1,-8,0,1), UDim2.new(0,4,1,-1), T.Border)
    end

    function Tab:Toggle(title, default, cb)
        local state = default or false
        local w = Frame(page, UDim2.new(1,0,0,30), nil, T.BG3)
        w.LayoutOrder = nextOrder()
        corner(w, 6)
        stroke(w, T.Border)

        local ab = Frame(w, UDim2.new(0,2,0,18), UDim2.new(0,0,0,6), state and State.AccentColor or Color3.fromRGB(35,35,50))
        corner(ab, 2)
        ab.ZIndex = 2

        local tl = Label(w, title, UDim2.new(1,-56,1,0), UDim2.new(0,8,0,0), T.Text, Enum.Font.GothamMedium)
        tl.TextSize = 11
        tl.ZIndex = 2

        local pillBG = Frame(w, UDim2.new(0,32,0,16), UDim2.new(1,-38,0.5,-8), state and State.AccentColor or Color3.fromRGB(35,35,50))
        corner(pillBG, 9)
        pillBG.ZIndex = 3

        local pill = Frame(pillBG, UDim2.new(0,10,0,10), UDim2.new(0,state and 19 or 3,0.5,-5), Color3.new(1,1,1))
        corner(pill, 6)
        pill.ZIndex = 4

        local function setState(val)
            state = val
            local onCol = State.AccentColor
            tw(pillBG, {BackgroundColor3=val and onCol or Color3.fromRGB(35,35,50)}, 0.18)
            tw(pill, {Position=UDim2.new(0,val and 19 or 3,0.5,-5)}, 0.18, Enum.EasingStyle.Back)
            tw(ab, {BackgroundColor3=val and onCol or Color3.fromRGB(35,35,50)}, 0.18)
            pcall(cb, val)
        end

        local clickBtn = Btn(w, UDim2.new(1,0,1,0))
        clickBtn.ZIndex = 5
        clickBtn.MouseEnter:Connect(function() tw(w, {BackgroundColor3=T.Hover}, 0.08) end)
        clickBtn.MouseLeave:Connect(function() tw(w, {BackgroundColor3=T.BG3}, 0.08) end)
        clickBtn.MouseButton1Click:Connect(function() setState(not state) end)

        -- Update pill color when accent changes
        local origRegister = registerAccent
        table.insert(AccentElements, {obj=pillBG, prop="BackgroundColor3", conditional=function() return state end})
        table.insert(AccentElements, {obj=ab, prop="BackgroundColor3", conditional=function() return state end})

        return {SetValue=function(_,v) setState(v) end, GetValue=function() return state end}
    end

    function Tab:Button(title, desc, cb)
        local h = (desc and desc ~= "") and 42 or 28
        local w = Frame(page, UDim2.new(1,0,0,h), nil, T.BG3)
        w.LayoutOrder = nextOrder()
        corner(w, 6)
        stroke(w, T.Border)

        local ab = Frame(w, UDim2.new(0,2,0,h-10), UDim2.new(0,0,0,5), State.AccentColor)
        corner(ab, 2); ab.ZIndex = 2
        registerAccent(ab, "BackgroundColor3")

        local tl = Label(w, title, UDim2.new(1,-36,0,16), UDim2.new(0,8,(desc and desc ~= "") and 0 or 0, (desc and desc ~= "") and 4 or 7), T.Text, Enum.Font.GothamMedium)
        tl.TextSize = 11; tl.ZIndex = 2

        if desc and desc ~= "" then
            local dl = Label(w, desc, UDim2.new(1,-36,0,12), UDim2.new(0,8,0,22), T.Dim, Enum.Font.Gotham)
            dl.TextSize = 9; dl.ZIndex = 2
        end

        local arr = Label(w, "›", UDim2.new(0,16,1,0), UDim2.new(1,-20,0,0), State.AccentColor, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        arr.TextSize = 16; arr.ZIndex = 2
        registerAccent(arr, "TextColor3")

        local clickBtn = Btn(w, UDim2.new(1,0,1,0))
        clickBtn.ZIndex = 5
        clickBtn.MouseEnter:Connect(function() tw(w,{BackgroundColor3=T.Hover},0.08) end)
        clickBtn.MouseLeave:Connect(function() tw(w,{BackgroundColor3=T.BG3},0.08) end)
        clickBtn.MouseButton1Click:Connect(function()
            tw(ab,{BackgroundColor3=Color3.fromRGB(255,255,255)},0.06)
            task.wait(0.06)
            tw(ab,{BackgroundColor3=State.AccentColor},0.1)
            pcall(cb)
        end)
    end

    function Tab:Dropdown(title, options, cb)
        local selected = options[1] or ""
        local open = false

        local w = Frame(page, UDim2.new(1,0,0,38), nil, T.BG3)
        w.LayoutOrder = nextOrder()
        w.ClipsDescendants = false
        corner(w, 6)
        stroke(w, T.Border)

        local ab = Frame(w, UDim2.new(0,2,0,24), UDim2.new(0,0,0,7), State.AccentColor)
        corner(ab, 2); ab.ZIndex = 2
        registerAccent(ab, "BackgroundColor3")

        local tl = Label(w, title, UDim2.new(0.5,0,0,13), UDim2.new(0,8,0,2), T.Dim, Enum.Font.Gotham)
        tl.TextSize = 9; tl.ZIndex = 2

        local selBtn = Instance.new("TextButton")
        selBtn.Size = UDim2.new(1,-14,0,17)
        selBtn.Position = UDim2.new(0,7,0,18)
        selBtn.BackgroundColor3 = T.BG
        selBtn.BorderSizePixel = 0
        selBtn.Text = ""
        selBtn.AutoButtonColor = false
        selBtn.ZIndex = 3
        selBtn.Parent = w
        corner(selBtn, 4)
        stroke(selBtn, T.Border)

        local selL = Label(selBtn, selected, UDim2.new(1,-18,1,0), UDim2.new(0,5,0,0), T.Text, Enum.Font.Gotham)
        selL.TextSize = 10; selL.ZIndex = 4

        local chev = Label(selBtn, "▾", UDim2.new(0,14,1,0), UDim2.new(1,-16,0,0), State.AccentColor, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chev.TextSize = 11; chev.ZIndex = 4
        registerAccent(chev, "TextColor3")

        local panel = Frame(gui, UDim2.new(0,0,0,0), nil, T.BG2)
        panel.Visible = false
        panel.ZIndex = 50
        panel.ClipsDescendants = true
        corner(panel, 6)
        local panelStroke = stroke(panel, State.AccentColor)
        registerAccent(panelStroke, "Color")

        local pLayout = Instance.new("UIListLayout")
        pLayout.Parent = panel

        local function closePanel()
            open = false
            tw(chev, {Rotation=0}, 0.12)
            tw(panel, {Size=UDim2.new(0,panel.Size.X.Offset,0,0)}, 0.18)
            task.wait(0.2)
            panel.Visible = false
        end

        local function buildItems()
            for _, c in ipairs(panel:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Size = UDim2.new(1,0,0,22)
                item.BackgroundColor3 = opt==selected and Color3.fromRGB(25,12,50) or T.BG2
                item.BorderSizePixel = 0
                item.Text = ""
                item.AutoButtonColor = false
                item.ZIndex = 51
                item.Parent = panel
                local il = Label(item, opt, UDim2.new(1,-8,1,0), UDim2.new(0,6,0,0), opt==selected and State.AccentColor or T.Text, Enum.Font.Gotham)
                il.TextSize = 10; il.ZIndex = 52
                item.MouseButton1Click:Connect(function()
                    selected = opt; selL.Text = opt
                    closePanel(); buildItems(); pcall(cb, opt)
                end)
                item.MouseEnter:Connect(function() tw(item,{BackgroundColor3=T.Hover},0.06) end)
                item.MouseLeave:Connect(function() tw(item,{BackgroundColor3=opt==selected and Color3.fromRGB(25,12,50) or T.BG2},0.06) end)
            end
        end
        buildItems()

        selBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                panel.Visible = true
                local abs = selBtn.AbsolutePosition
                local panW = w.AbsoluteSize.X - 14
                panel.Size = UDim2.new(0,panW,0,0)
                panel.Position = UDim2.new(0,abs.X,0,abs.Y+20)
                tw(chev,{Rotation=180},0.12)
                tw(panel,{Size=UDim2.new(0,panW,0,math.min(#options*22,120))},0.18,Enum.EasingStyle.Back)
            else
                closePanel()
            end
        end)

        return {
            SetValue=function(_,v) selected=v selL.Text=v buildItems() end,
            GetValue=function() return selected end,
        }
    end

    function Tab:Slider(title, min, max, default, cb)
        local value = default or min
        local w = Frame(page, UDim2.new(1,0,0,46), nil, T.BG3)
        w.LayoutOrder = nextOrder()
        corner(w, 6)
        stroke(w, T.Border)

        local ab = Frame(w, UDim2.new(0,2,0,32), UDim2.new(0,0,0,7), State.AccentColor)
        corner(ab, 2)
        registerAccent(ab, "BackgroundColor3")

        local tl = Label(w, title, UDim2.new(1,-60,0,14), UDim2.new(0,8,0,4), T.Text, Enum.Font.GothamMedium)
        tl.TextSize = 11

        local valL = Label(w, tostring(value), UDim2.new(0,44,0,14), UDim2.new(1,-48,0,4), State.AccentColor, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        valL.TextSize = 11
        registerAccent(valL, "TextColor3")

        local track = Frame(w, UDim2.new(1,-18,0,5), UDim2.new(0,9,0,30), Color3.fromRGB(35,35,50))
        corner(track, 3)

        local fill = Frame(track, UDim2.new((value-min)/(max-min),0,1,0), nil, State.AccentColor)
        corner(fill, 3)
        registerAccent(fill, "BackgroundColor3")

        local knob = Frame(fill, UDim2.new(0,10,0,10), UDim2.new(1,-5,0.5,-5), Color3.new(1,1,1))
        corner(knob, 6)

        local draggingSlider = false
        local function updateVal(x)
            local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.round(min + (max-min)*pct)
            valL.Text = tostring(value)
            tw(fill, {Size=UDim2.new(pct,0,1,0)}, 0.04)
            pcall(cb, value)
        end

        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
                updateVal(i.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if draggingSlider and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                updateVal(i.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)
    end

    function Tab:TextBox(title, placeholder, cb)
        local w = Frame(page, UDim2.new(1,0,0,38), nil, T.BG3)
        w.LayoutOrder = nextOrder()
        corner(w, 6)
        stroke(w, T.Border)

        local ab = Frame(w, UDim2.new(0,2,0,24), UDim2.new(0,0,0,7), State.AccentColor)
        corner(ab, 2)
        registerAccent(ab, "BackgroundColor3")

        local tl = Label(w, title, UDim2.new(0.45,0,0,14), UDim2.new(0,8,0,2), T.Dim, Enum.Font.Gotham)
        tl.TextSize = 9

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1,-14,0,16)
        box.Position = UDim2.new(0,7,0,19)
        box.BackgroundColor3 = T.BG
        box.BorderSizePixel = 0
        box.PlaceholderText = placeholder or ""
        box.PlaceholderColor3 = T.Dim
        box.Text = ""
        box.TextColor3 = T.Text
        box.Font = Enum.Font.Gotham
        box.TextSize = 10
        box.ClearTextOnFocus = false
        box.ZIndex = 3
        box.Parent = w
        corner(box, 4)
        stroke(box, T.Border)

        box.FocusLost:Connect(function(enter)
            if enter then pcall(cb, box.Text) end
        end)
        box.Changed:Connect(function()
            if box.Text ~= "" then pcall(cb, box.Text) end
        end)
    end

    return Tab
end

-- ================================================
-- BUILD TABS
-- ================================================

-- [MAIN TAB]
local mainTab = createTab("Main", "⚡")

mainTab:Section("Server")
mainTab:Toggle("Auto Rejoin on Kick", false, function(v)
    State.AutoRejoin = v
    if v then setupAutoRejoin() end
    Notify("Auto Rejoin", v and "ON" or "OFF", 3)
end)
mainTab:Button("Redeem All Codes", "Auto redeem all codes", function()
    redeemAllCodes()
    Notify("Codes", "Redeemed all codes!", 3)
end)
mainTab:Button("Hop Server", "Join a random server", function()
    Notify("Hop Server", "Hopping...", 2)
    task.wait(0.5)
    hopServer()
end)
mainTab:Button("Hop Low Server", "Join lowest player server", function()
    Notify("Hop Server", "Finding low server...", 2)
    task.wait(0.5)
    hopLowServer()
end)

mainTab:Section("Info")
mainTab:Button("Current Sea: Sea "..Sea, "PlaceId: "..PlaceId, function()
    Notify("Sea Info", "You are in Sea "..Sea, 3)
end)
mainTab:Button("Discord", "discord.gg/Pq2dsdfHhE", function()
    pcall(function() setclipboard("https://discord.gg/Pq2dsdfHhE") end)
    Notify("Elite Hub", "Discord link copied!", 3)
end)

-- [FRUIT TAB]
local fruitTab = createTab("Fruit", "🍎")

fruitTab:Section("Devil Fruit")
local fruitDrop = fruitTab:Dropdown("Select Fruit", FruitNames, function(v)
    State.SelectFruit = v
end)
fruitTab:Toggle("Fruit Sniper", false, function(v)
    State.FruitSniper = v
    if v then startSnipeLoop() end
    Notify("Fruit Sniper", v and "ON" or "OFF", 3)
end)
fruitTab:Toggle("Auto Find Fruit", false, function(v)
    State.AutoFindFruit = v
    if v then startAutoFindFruit() end
end)
fruitTab:Toggle("Auto Store Fruit", false, function(v)
    State.AutoStoreFruit = v
    if v then startAutoStoreFruit() end
end)
fruitTab:Toggle("Auto Dealer Cousin", false, function(v)
    State.AutoDealerCousin = v
    if v then startDealerCousin() end
end)
fruitTab:Toggle("Notify on Snipe", true, function(v)
    State.SnipeNotify = v
end)
fruitTab:Button("Scan Fruits Now", "Teleport to nearest fruit", function()
    local found = false
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Fruit") then
            local h = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("BasePart")
            if h then
                humanizedTeleport(CFrame.new(h.Position + Vector3.new(0,3,0)))
                Notify("Fruit Found", "Teleported to "..v.Name, 4)
                found = true; break
            end
        end
    end
    if not found then Notify("Fruit Sniper", "No fruits found on map", 3) end
end)

-- [VISUAL TAB]
local visualTab = createTab("Visual", "👁")

visualTab:Section("ESP")
visualTab:Toggle("Player ESP", false, function(v)
    State.PlayerESP = v
    refreshESP()
    Notify("Player ESP", v and "ON" or "OFF", 3)
end)
visualTab:Toggle("Devil Fruit ESP", false, function(v)
    State.FruitESP = v
    refreshESP()
    Notify("Fruit ESP", v and "ON" or "OFF", 3)
end)
visualTab:Toggle("Flower ESP", false, function(v)
    State.FlowerESP = v
    refreshESP()
    Notify("Flower ESP", v and "ON" or "OFF", 3)
end)
visualTab:Slider("ESP Distance", 100, 5000, 2000, function(v)
    State.ESPDistance = v
    refreshESP()
end)
visualTab:Button("Refresh ESP", "Re-scan all ESP targets", function()
    refreshESP()
    Notify("ESP", "Refreshed", 2)
end)

visualTab:Section("Performance")
visualTab:Toggle("Remove Lava Damage", false, function(v)
    State.RemoveLavaDmg = v
    if v then setupRemoveLava()
    else cancelThread("lava") end
    Notify("Lava Damage", v and "Removed" or "Restored", 3)
end)
visualTab:Toggle("Boost FPS", false, function(v)
    State.BoostFPS = v
    applyFPSBoost(v)
    Notify("FPS Boost", v and "ON" or "OFF", 3)
end)

-- [FARM TAB]
local farmTab = createTab("Farm", "⚔")

farmTab:Section("Options")
farmTab:Dropdown("Select Weapon", WeaponNames, function(v)
    State.SelectWeapon = v
    remoteInvoke("EquipItem", v)
end)
farmTab:Toggle("Auto Haki", false, function(v)
    State.AutoHaki = v
end)
farmTab:Toggle("Auto Ken", false, function(v)
    State.AutoKen = v
end)
farmTab:Toggle("Fast Attack", false, function(v)
    State.FastAttack = v
end)
farmTab:Toggle("Bring Mob", false, function(v)
    State.BringMob = v
end)
farmTab:Toggle("Double Quest", false, function(v)
    State.DoubleQuest = v
end)
farmTab:Toggle("Teleport Bypass", false, function(v)
    State.TeleportBypass = v
end)
farmTab:Dropdown("Farm Method", {"Teleport","Walk"}, function(v)
    State.FarmMethod = v
end)

farmTab:Section("Auto Farm")
local seaMobNames = {"(Nearest Mob)"}
for _, m in ipairs(MobData[Sea] or MobData[1]) do
    table.insert(seaMobNames, m.Name.." (Lv "..m.Level..")")
end
farmTab:Dropdown("Select Mob", seaMobNames, function(v)
    if v == "(Nearest Mob)" then
        State.FarmMob = ""
    else
        State.FarmMob = v:match("^(.+) %(Lv") or ""
    end
end)
farmTab:Toggle("Auto Farm", false, function(v)
    State.AutoFarm = v
    if v then startFarmLoop() else cancelThread("farm") end
    Notify("Auto Farm", v and "ON" or "OFF", 3)
end)
farmTab:Toggle("Auto Quest", false, function(v)
    State.AutoQuest = v
end)
farmTab:Toggle("Use Skills", true, function(v)
    State.UseSkills = v
end)
farmTab:Toggle("Auto Eat Fruit", true, function(v)
    State.AutoEat = v
end)
farmTab:Slider("Eat at HP%", 0, 100, 30, function(v)
    State.HealthPct = v
end)

farmTab:Section("Sea Progression")
farmTab:Toggle("Auto Second Sea", false, function(v)
    State.AutoSecondSea = v
    if v then startSecondSeaFarm() else cancelThread("sea2") end
    Notify("Auto Second Sea", v and "ON" or "OFF", 3)
end)
farmTab:Toggle("Auto Third Sea", false, function(v)
    State.AutoThirdSea = v
    if v then startThirdSeaFarm() else cancelThread("sea3") end
    Notify("Auto Third Sea", v and "ON" or "OFF", 3)
end)
farmTab:Toggle("Auto Bartilo Quest", false, function(v)
    State.AutoBartilo = v
    if v then startBartiloFarm() else cancelThread("bartilo") end
end)
farmTab:Toggle("Auto Factory", false, function(v)
    State.AutoFactory = v
    if v then startFactoryFarm() else cancelThread("factory") end
end)
farmTab:Toggle("Auto Pirate Raid", false, function(v)
    State.AutoPirateRaid = v
    if v then startPirateRaid() else cancelThread("pirateraid") end
end)
farmTab:Toggle("Auto Elite", false, function(v)
    State.AutoElite = v
    if v then startEliteFarm() else cancelThread("elite") end
end)

-- [HOP TAB]
local hopTab = createTab("Hop", "🔀")

hopTab:Section("Hop Server")
hopTab:TextBox("Hop Delay (seconds)", "30", function(v)
    local n = tonumber(v)
    if n then State.HopDelay = math.max(5, n) end
end)
hopTab:Toggle("Auto Hop Server", false, function(v)
    State.HopServer = v
    if v then startHopServerLoop()
    else cancelThread("hoploop") end
    Notify("Hop Server", v and "ON" or "OFF", 3)
end)
hopTab:Toggle("Hop If Near Player", false, function(v)
    State.HopNearPlayer = v
    if v then startHopServerLoop()
    else if not State.HopServer and not State.HopForFruit then cancelThread("hoploop") end end
end)
hopTab:Toggle("Hop For Fruit 1M+ [S3]", false, function(v)
    State.HopForFruit = v
    if v then startHopServerLoop()
    else if not State.HopServer and not State.HopNearPlayer then cancelThread("hoploop") end end
end)
hopTab:Button("Hop Now", "Immediately hop server", function()
    Notify("Hop", "Hopping server...", 2)
    task.wait(0.5)
    hopServer()
end)
hopTab:Button("Hop Low Now", "Hop to lowest pop server", function()
    Notify("Hop", "Finding low server...", 2)
    task.wait(0.5)
    hopLowServer()
end)

-- [MELEE TAB]
local meleeTab = createTab("Melee", "👊")

meleeTab:Section("Melee")
meleeTab:Dropdown("Select Melee", MeleeNames, function(v)
    State.SelectMelee = v
    if v ~= "None" then remoteInvoke("EquipItem", v) end
end)
meleeTab:Toggle("Auto Melee Farm", false, function(v)
    State.AutoMelee = v
    if v then startMeleeFarm() else cancelThread("melee") end
    Notify("Auto Melee", v and "ON" or "OFF", 3)
end)

-- [BOSS TAB]
local bossTab = createTab("Boss", "💀")

bossTab:Section("Boss Farm")
local bossNames = {"None"}
for _, b in ipairs(BossData) do table.insert(bossNames, b.Name.." (S"..b.Sea..")") end
bossTab:Dropdown("Select Boss", bossNames, function(v)
    if v == "None" then State.SelectBoss = "None"
    else State.SelectBoss = v:match("^(.+) %(S") or "None" end
end)
bossTab:Toggle("Auto Farm Boss", false, function(v)
    State.AutoFarmBoss = v
    if v then startBossFarm(State.SelectBoss, false)
    else cancelThread("boss") end
    Notify("Boss Farm", v and "ON" or "OFF", 3)
end)
bossTab:Toggle("Auto Farm All Bosses", false, function(v)
    State.AutoFarmAllBoss = v
    if v then startBossFarm("", true)
    else cancelThread("boss") end
    Notify("All Boss Farm", v and "ON" or "OFF", 3)
end)
bossTab:Button("Teleport to Boss", "TP to selected boss spawn", function()
    for _, b in ipairs(BossData) do
        if b.Name:lower():find(State.SelectBoss:lower()) then
            humanizedTeleport(b.CF)
            Notify("Teleport", "→ "..b.Name, 3)
            return
        end
    end
    Notify("Boss", "Select a boss first", 3)
end)

-- [MASTERY TAB]
local masteryTab = createTab("Mastery", "📈")

masteryTab:Section("Mastery Farm")
masteryTab:Dropdown("Mastery Type", {"Devil Fruit","Sword","Melee","Gun"}, function(v)
    State.MasteryType = v
end)
masteryTab:Toggle("Auto Farm Mastery", false, function(v)
    State.AutoMastery = v
    if v then startMasteryFarm() else cancelThread("mastery") end
    Notify("Mastery Farm", v and "ON" or "OFF", 3)
end)
masteryTab:Toggle("Start at Max Level", false, function(v)
    State.StartAtMaxLevel = v
end)

masteryTab:Section("Sword Unlock")
masteryTab:Toggle("Auto Unlock Sword Skill", false, function(v)
    State.AutoUnlockSword = v
    if v then startSwordUnlock() else cancelThread("swordunlock") end
    Notify("Sword Unlock", v and "ON" or "OFF", 3)
end)
masteryTab:Toggle("Start at Max Level (Sword)", false, function(v)
    State.StartUnlockAtMax = v
end)
masteryTab:Toggle("Legendary/Mythical Only", false, function(v)
    State.LegendaryOnly = v
end)

-- [ITEM TAB]
local itemTab = createTab("Item", "🎒")

itemTab:Section("Auto Collect")
itemTab:Toggle("Auto Collect Chest", false, function(v)
    State.AutoCollectChest = v
    if v then startAutoCollect()
    elseif not State.AutoCollectMat then cancelThread("collect") end
end)
itemTab:Toggle("Auto Collect Material", false, function(v)
    State.AutoCollectMat = v
    if v then startAutoCollect()
    elseif not State.AutoCollectChest then cancelThread("collect") end
end)
itemTab:Toggle("Auto Enhance", false, function(v)
    State.AutoEnhance = v
    if v then
        spawnThread("enhance", function()
            while State.AutoEnhance do
                remoteInvoke("EnhanceItem"); task.wait(1)
            end
        end)
    else cancelThread("enhance") end
end)
itemTab:Toggle("Auto Refine", false, function(v)
    State.AutoRefine = v
    if v then
        spawnThread("refine", function()
            while State.AutoRefine do
                remoteInvoke("RefineItem"); task.wait(1)
            end
        end)
    else cancelThread("refine") end
end)

itemTab:Section("Teleport")
for _, tp in ipairs(TeleportData[Sea] or TeleportData[1]) do
    local tpData = tp
    itemTab:Button(tpData.Name, "", function()
        humanizedTeleport(tpData.CF)
        Notify("Teleport", "→ "..tpData.Name, 3)
    end)
end

-- [SETTINGS TAB]
local settingsTab = createTab("Settings", "⚙")

settingsTab:Section("Appearance")

local accentColors = {
    {"Purple", Color3.fromRGB(120,60,230)},
    {"Blue",   Color3.fromRGB(50,110,240)},
    {"Cyan",   Color3.fromRGB(30,185,210)},
    {"Green",  Color3.fromRGB(40,185,100)},
    {"Red",    Color3.fromRGB(210,50,60)},
    {"Pink",   Color3.fromRGB(215,60,165)},
    {"Orange", Color3.fromRGB(230,120,30)},
    {"Gold",   Color3.fromRGB(220,175,30)},
}
local colorNames = {}
for _, c in ipairs(accentColors) do table.insert(colorNames, c[1]) end

settingsTab:Dropdown("Accent Color", colorNames, function(v)
    for _, c in ipairs(accentColors) do
        if c[1] == v then
            applyAccentColor(c[2])
            Notify("Color", "Accent: "..v, 3)
            return
        end
    end
end)

settingsTab:Toggle("Floating Animation", true, function(v)
    State.FloatAnim = v
    if not v then
        win.Position = UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
    end
end)

settingsTab:Section("Keybinds")
settingsTab:Button("Minimize: [End]", "Press End to toggle UI", function() end)

settingsTab:Section("Danger")
settingsTab:Button("Close Hub", "Destroy Elite Hub", function()
    for _, g in ipairs(CoreGui:GetChildren()) do
        if g.Name == "EliteHub" or g.Name == "EliteNotify" then g:Destroy() end
    end
    if LP.PlayerGui:FindFirstChild("EliteHub") then LP.PlayerGui.EliteHub:Destroy() end
    if LP.PlayerGui:FindFirstChild("EliteNotify") then LP.PlayerGui.EliteNotify:Destroy() end
    for k, t in pairs(Threads) do task.cancel(t) end
end)

-- ================================================
-- MINIMIZE (End key)
-- ================================================
local minimized = false
UserInputService.InputBegan:Connect(function(i, proc)
    if not proc and i.KeyCode == Enum.KeyCode.End then
        minimized = not minimized
        content.Visible = not minimized
        sidebar.Visible = not minimized
        tw(win, {Size=minimized and UDim2.fromOffset(120,30) or UDim2.fromOffset(WIN_W,WIN_H)}, 0.25, Enum.EasingStyle.Quint)
    end
end)

-- ================================================
-- CHARACTER RESPAWN HANDLING
-- ================================================
LP.CharacterAdded:Connect(function()
    task.wait(2)
    if State.AutoFarm then startFarmLoop() end
    if State.AutoMelee then startMeleeFarm() end
    if State.FruitSniper then startSnipeLoop() end
    if State.PlayerESP or State.FruitESP or State.FlowerESP then refreshESP() end
    if State.RemoveLavaDmg then setupRemoveLava() end
end)

-- ================================================
-- STARTUP
-- ================================================
task.wait(0.8)
Notify("Elite Hub", "Loaded ✓ Sea "..Sea.." | Keyless | by Marcus", 5)
print("[EliteHub] Loaded | Sea "..Sea.." | PlaceId "..PlaceId)
