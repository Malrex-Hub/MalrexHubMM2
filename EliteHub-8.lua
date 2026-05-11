-- ================================================
-- ELITE HUB | Blox Fruits | by Marcus
-- discord.gg/Pq2dsdfHhE | Keyless
-- ================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local WS               = game:GetService("Workspace")
local RS               = game:GetService("ReplicatedStorage")
local CoreGui          = game:GetService("CoreGui")
local LP               = Players.LocalPlayer

-- ================================================
-- SAFE PARENT
-- ================================================
local function safeParent(g)
    local ok = pcall(function() g.Parent = CoreGui end)
    if not ok then g.Parent = LP:WaitForChild("PlayerGui") end
end

-- ================================================
-- SAFE REMOTE INVOKE
-- ================================================
local function invokeRemote(...)
    local rem
    pcall(function()
        rem = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CommF_")
    end)
    if not rem then return nil end
    local ok, result = pcall(function(...) return rem:InvokeServer(...) end, ...)
    if ok then return result end
    return nil
end

local function fireRemote(name, ...)
    local rem
    pcall(function()
        rem = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild(name)
    end)
    if not rem then return end
    pcall(function(...) rem:FireServer(...) end, ...)
end

-- ================================================
-- LOADING SCREEN
-- ================================================
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "EliteLoad"
loadGui.ResetOnSpawn = false
loadGui.DisplayOrder = 999
loadGui.IgnoreGuiInset = true
safeParent(loadGui)

local loadBG = Instance.new("Frame")
loadBG.Size = UDim2.new(1,0,1,0)
loadBG.BackgroundColor3 = Color3.fromRGB(8,8,14)
loadBG.BorderSizePixel = 0
loadBG.ZIndex = 100
loadBG.Parent = loadGui

local function qLbl(p, txt, sz, pos, col, fnt, ts)
    local l = Instance.new("TextLabel")
    l.Size = sz l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = txt l.TextColor3 = col
    l.TextSize = ts or 13
    l.Font = fnt or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.ZIndex = 101 l.Parent = p
    return l
end

qLbl(loadBG,"ELITE HUB",UDim2.new(0,320,0,50),UDim2.new(0.5,-160,0.33,0),Color3.fromRGB(245,245,245),Enum.Font.GothamBold,38)
qLbl(loadBG,"by Marcus",UDim2.new(0,320,0,22),UDim2.new(0.5,-160,0.46,0),Color3.fromRGB(125,65,250),Enum.Font.GothamMedium,15)

local lBarBG = Instance.new("Frame")
lBarBG.Size = UDim2.new(0,280,0,5)
lBarBG.Position = UDim2.new(0.5,-140,0.56,0)
lBarBG.BackgroundColor3 = Color3.fromRGB(25,25,38)
lBarBG.BorderSizePixel = 0 lBarBG.ZIndex = 101 lBarBG.Parent = loadBG
Instance.new("UICorner").Parent = lBarBG

local lBarF = Instance.new("Frame")
lBarF.Size = UDim2.new(0,0,1,0)
lBarF.BackgroundColor3 = Color3.fromRGB(125,65,250)
lBarF.BorderSizePixel = 0 lBarF.ZIndex = 102 lBarF.Parent = lBarBG
Instance.new("UICorner").Parent = lBarF

local lStat = qLbl(loadBG,"Loading...",UDim2.new(0,280,0,16),UDim2.new(0.5,-140,0.60,0),Color3.fromRGB(140,140,160),Enum.Font.Gotham,11)
lStat.TextXAlignment = Enum.TextXAlignment.Left

task.wait(0.2)
for _, s in ipairs({{t="Initializing...",p=0.25},{t="Loading mob data...",p=0.5},{t="Building UI...",p=0.8},{t="Done!",p=1}}) do
    lStat.Text = s.t
    TweenService:Create(lBarF, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size=UDim2.new(s.p,0,1,0)}):Play()
    task.wait(0.4)
end
task.wait(0.25)
TweenService:Create(loadBG, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play()
for _, v in ipairs(loadBG:GetDescendants()) do
    if v:IsA("TextLabel") then
        TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency=1}):Play()
    elseif v:IsA("Frame") then
        TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
    end
end
task.wait(0.45)
loadGui:Destroy()

-- ================================================
-- SEA DETECTION
-- ================================================
local PlaceId = game.PlaceId
local Sea = 1
if PlaceId == 4442272183 then Sea = 2
elseif PlaceId == 7449423635 then Sea = 3 end

-- ================================================
-- STATE
-- ================================================
local S = {
    AutoFarm=false, AutoQuest=false, FarmMob="",
    UseSkills=true, AutoEat=true, HealthPct=35,
    DoubleQuest=false, AutoHaki=false, AutoKen=false,
    AutoStats=false, StatChoice="Melee",
    AutoBoss=false, AutoAllBoss=false, SelectBoss="",
    AutoMelee=false, SelectMelee="",
    AutoMastery=false, MasteryTarget="Blox Fruit", MasteryMaxLevel=false,
    AutoUnlockSword=false, OnlyLegendary=false,
    FruitSniper=false, AutoFindFruit=false, AutoStoreFruit=false,
    AutoDealer=false, SelectFruit="",
    PlayerESP=false, FruitESP=false, FlowerESP=false,
    RemoveLava=false, BoostFPS=false, FloatAnim=true,
    AutoRejoin=false, HopDelay=10, HopIfNearPlayer=false,
    AutoSea2=false, AutoSea3=false,
    AutoBaritlo=false, AutoFactory=false,
    AutoPirateRaid=false, AutoElite=false,
}

local Accent = Color3.fromRGB(120,60,230)
local ESPObj = {} local FruitESPObj = {} local FlowerESPObj = {}
local accentRefs = {} -- {object, property} pairs to recolor

-- ================================================
-- CHARACTER HELPERS
-- ================================================
local function getChar()
    return LP.Character
end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ================================================
-- TELEPORT — FIXED: AbsolutePosition drag, zero velocity
-- ================================================
local tpConn
local function tpTo(cf, hold)
    if tpConn then pcall(function() tpConn:Disconnect() end) tpConn = nil end
    local root = getRoot()
    if not root then return end
    -- Set multiple times to beat server correction
    for _ = 1, 4 do
        pcall(function() root.CFrame = cf end)
        task.wait()
    end
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    if hold and hold > 0 then
        local elapsed = 0
        tpConn = RunService.Heartbeat:Connect(function(dt)
            elapsed = elapsed + dt
            local r = getRoot()
            if r then
                pcall(function() r.CFrame = cf end)
                pcall(function() r.AssemblyLinearVelocity = Vector3.zero end)
                pcall(function() r.AssemblyAngularVelocity = Vector3.zero end)
            end
            if elapsed >= hold then
                pcall(function() tpConn:Disconnect() end)
                tpConn = nil
            end
        end)
    end
end

-- ================================================
-- DATA
-- ================================================
local MobData = {
    [1]={
        {Name="Bandit",         Quest="BanditQuest",    Level=1,   QCF=CFrame.new(-1254,5,-1989),  MCF=CFrame.new(-1228,6,-1920)},
        {Name="Monkey",         Quest="MonkeyQuest",    Level=10,  QCF=CFrame.new(-1376,4,-795),   MCF=CFrame.new(-1357,5,-841)},
        {Name="Pirate",         Quest="PirateQuest",    Level=30,  QCF=CFrame.new(944,5,4417),     MCF=CFrame.new(974,6,4379)},
        {Name="Brute",          Quest="BruteQuest",     Level=50,  QCF=CFrame.new(944,5,4417),     MCF=CFrame.new(998,6,4355)},
        {Name="Desert Bandit",  Quest="DesertQuest",    Level=75,  QCF=CFrame.new(893,6,4393),     MCF=CFrame.new(897,6,4360)},
        {Name="Desert Officer", Quest="DesertQuest",    Level=90,  QCF=CFrame.new(893,6,4393),     MCF=CFrame.new(1547,14,4381)},
        {Name="Snow Bandit",    Quest="SnowQuest",      Level=100, QCF=CFrame.new(1387,87,-1298),  MCF=CFrame.new(1356,105,-1328)},
        {Name="Snowman",        Quest="SnowQuest",      Level=120, QCF=CFrame.new(1387,87,-1298),  MCF=CFrame.new(1424,126,-1308)},
        {Name="Warrior",        Quest="WarriorQuest",   Level=150, QCF=CFrame.new(-3157,10,1098),  MCF=CFrame.new(-3100,7,1090)},
        {Name="Gladiator",      Quest="GladiatorQuest", Level=175, QCF=CFrame.new(-3157,10,1098),  MCF=CFrame.new(-3200,10,1080)},
        {Name="Fishman",        Quest="FishmanQuest",   Level=200, QCF=CFrame.new(-3047,-19,3812), MCF=CFrame.new(-2980,-30,3900)},
        {Name="Fishman Warrior",Quest="FishmanQuest",   Level=225, QCF=CFrame.new(-3047,-19,3812), MCF=CFrame.new(-3060,-35,3830)},
        {Name="Mushroom",       Quest="MushroomQuest",  Level=300, QCF=CFrame.new(-4640,5,280),    MCF=CFrame.new(-4620,5,350)},
        {Name="Gorilla",        Quest="GorillaQuest",   Level=350, QCF=CFrame.new(-4680,5,220),    MCF=CFrame.new(-4700,5,180)},
        {Name="LumberJack",     Quest="LumberQuest",    Level=375, QCF=CFrame.new(4880,5,555),     MCF=CFrame.new(4900,6,600)},
    },
    [2]={
        {Name="Raider",              Quest="RaiderQuest", Level=700,  QCF=CFrame.new(-2076,74,1836), MCF=CFrame.new(-2100,75,1900)},
        {Name="Mercenary",           Quest="MercQuest",   Level=750,  QCF=CFrame.new(-2076,74,1836), MCF=CFrame.new(-2050,75,1860)},
        {Name="Marine S2",           Quest="MarineQuest", Level=800,  QCF=CFrame.new(-2900,11,1314), MCF=CFrame.new(-2920,11,1380)},
        {Name="Zombie",              Quest="ZombieQuest", Level=850,  QCF=CFrame.new(-2390,30,1500), MCF=CFrame.new(-2400,30,1560)},
        {Name="Vampire",             Quest="VampireQuest",Level=875,  QCF=CFrame.new(-2390,30,1500), MCF=CFrame.new(-2380,35,1480)},
        {Name="Snow Trooper",        Quest="SnowTrooper", Level=900,  QCF=CFrame.new(-2600,145,700), MCF=CFrame.new(-2580,145,760)},
        {Name="Yeti",                Quest="YetiQuest",   Level=950,  QCF=CFrame.new(-2600,145,700), MCF=CFrame.new(-2620,145,680)},
        {Name="Dragon Crew Soldier", Quest="DragonQuest", Level=1100, QCF=CFrame.new(-5500,15,3000), MCF=CFrame.new(-5520,15,3060)},
        {Name="Wano Samurai",        Quest="WanoQuest",   Level=1250, QCF=CFrame.new(-5100,30,3600), MCF=CFrame.new(-5080,35,3580)},
    },
    [3]={
        {Name="Pirate Millionaire",  Quest="PMQuest",  Level=1500, QCF=CFrame.new(-14360,120,1640),MCF=CFrame.new(-14380,120,1700)},
        {Name="Forest Pirate",       Quest="FPQuest",  Level=1575, QCF=CFrame.new(-14360,120,1640),MCF=CFrame.new(-14340,120,1620)},
        {Name="Royal Soldier",       Quest="RSQuest",  Level=1675, QCF=CFrame.new(-12800,115,840), MCF=CFrame.new(-12780,115,820)},
        {Name="Gamma Zombie",        Quest="GZQuest",  Level=1700, QCF=CFrame.new(-12200,100,2600),MCF=CFrame.new(-12220,100,2660)},
        {Name="Haunted Pirate",      Quest="HPQuest",  Level=1875, QCF=CFrame.new(-9800,95,1700),  MCF=CFrame.new(-9780,95,1680)},
        {Name="Reborn Skeleton",     Quest="RBQuest",  Level=1925, QCF=CFrame.new(-9200,90,2400),  MCF=CFrame.new(-9220,90,2460)},
        {Name="Ice Cream Chef",      Quest="ICQuest",  Level=2275, QCF=CFrame.new(-7200,70,4800),  MCF=CFrame.new(-7220,70,4860)},
        {Name="Ice Cream Commander", Quest="ICCQuest", Level=2325, QCF=CFrame.new(-7200,70,4800),  MCF=CFrame.new(-7180,70,4780)},
    },
}

local TpData = {
    [1]={
        {Name="Starter Island",  CF=CFrame.new(-1254,5,-1989)},
        {Name="Marine Starter",  CF=CFrame.new(-1376,4,-795)},
        {Name="Jungle",          CF=CFrame.new(-1660,12,236)},
        {Name="Pirate Village",  CF=CFrame.new(944,5,4350)},
        {Name="Desert",          CF=CFrame.new(893,6,4390)},
        {Name="Snow Island",     CF=CFrame.new(1390,88,-1298)},
        {Name="Marine Fortress", CF=CFrame.new(-3160,10,1100)},
        {Name="Skylands",        CF=CFrame.new(-4640,450,280)},
        {Name="Fishman Island",  CF=CFrame.new(-3050,-10,3800)},
        {Name="Fountain City",   CF=CFrame.new(-4670,5,250)},
    },
    [2]={
        {Name="Kingdom of Rose", CF=CFrame.new(-2076,74,1836)},
        {Name="Graveyard",       CF=CFrame.new(-2390,30,1500)},
        {Name="Snow Mountain",   CF=CFrame.new(-2600,145,700)},
        {Name="Magma Village",   CF=CFrame.new(-4180,24,3100)},
        {Name="Wano",            CF=CFrame.new(-5100,30,3600)},
        {Name="Hydra Island",    CF=CFrame.new(-5500,15,3000)},
    },
    [3]={
        {Name="Port Town",       CF=CFrame.new(-14360,120,1640)},
        {Name="Floating Turtle", CF=CFrame.new(-12800,115,840)},
        {Name="Haunted Castle",  CF=CFrame.new(-9800,95,1700)},
        {Name="Sea of Treats",   CF=CFrame.new(-7200,70,4800)},
        {Name="Mirage Island",   CF=CFrame.new(-8000,80,3500)},
    },
}

local BossData = {
    [1]={
        {Name="Gorilla King",  CF=CFrame.new(-4700,5,180)},
        {Name="Bobby",         CF=CFrame.new(-1228,6,-1920)},
        {Name="Saber Expert",  CF=CFrame.new(1040,19,-2950)},
        {Name="Cursed Captain",CF=CFrame.new(985,5,4379)},
        {Name="Greybeard",     CF=CFrame.new(-2920,11,1380)},
    },
    [2]={
        {Name="Don Swan",CF=CFrame.new(-2076,74,1836)},
        {Name="Diamond",  CF=CFrame.new(-5100,30,3600)},
        {Name="Jeremy",   CF=CFrame.new(-5520,15,3060)},
        {Name="Fajita",   CF=CFrame.new(-4180,24,3100)},
    },
    [3]={
        {Name="Stone",             CF=CFrame.new(-14380,120,1700)},
        {Name="Island Empress",    CF=CFrame.new(-12780,115,820)},
        {Name="Kilo Admiral",      CF=CFrame.new(-9780,95,1680)},
        {Name="Captain Elephant",  CF=CFrame.new(-7220,70,4860)},
        {Name="Beautiful Pirate",  CF=CFrame.new(-9220,90,2460)},
    },
}

local Codes = {
    "Sub2UncleKizaru","fudd10","Sub2Fer999","Axiore","TantaiGaming",
    "StrawHatMaine","Sub2Daigrock","Bluxxy","Sub2OfficialNoobie",
    "Enyu_is_Pro","JCWK","Sub2GamerRobot","TheGreatAce","Sub2Yoshi","Sub2Notzoil",
}

local FruitNames = {
    "Bomb","Spike","Chop","Spring","Kilo","Smoke","Spin","Flame",
    "Ice","Sand","Dark","Light","Rubber","Barrier","Magma","Quake",
    "Buddha","Love","Spider","Sound","Phoenix","Rumble","Pain",
    "Gravity","Dough","Shadow","Venom","Control","Spirit","Dragon",
    "Leopard","Mammoth","T-Rex","Kitsune",
}

local LegendaryFruits = {
    "Dragon","Leopard","Kitsune","Mammoth","T-Rex","Dough","Venom","Control","Shadow","Spirit",
}

-- ================================================
-- COMBAT
-- ================================================
local function getMobs()
    local list = {}
    local function scan(folder)
        if not folder then return end
        for _, v in ipairs(folder:GetChildren()) do
            pcall(function()
                local h = v:FindFirstChildOfClass("Humanoid")
                local r = v:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    table.insert(list, v)
                end
            end)
        end
    end
    pcall(function() scan(WS:FindFirstChild("Enemies")) end)
    pcall(function()
        for _, v in ipairs(WS:GetChildren()) do
            local h = v:FindFirstChildOfClass("Humanoid")
            local r = v:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0
                and not Players:GetPlayerFromCharacter(v)
                and v ~= LP.Character then
                local dup = false
                for _, e in ipairs(list) do if e == v then dup = true break end end
                if not dup then table.insert(list, v) end
            end
        end
    end)
    return list
end

local function getNearestMob(name)
    local root = getRoot()
    if not root then return nil end
    local best, dist = nil, math.huge
    for _, mob in ipairs(getMobs()) do
        pcall(function()
            local match = (name == "") or (mob.Name:lower():find(name:lower(), 1, true) ~= nil)
            if match then
                local mr = mob:FindFirstChild("HumanoidRootPart")
                if mr then
                    local d = (mr.Position - root.Position).Magnitude
                    if d < dist then dist = d best = mob end
                end
            end
        end)
    end
    return best
end

local function useSkills()
    for _, k in ipairs({"z","x","c","v","f"}) do
        pcall(function() keypress(string.byte(k)) end)
        task.wait(0.08)
        pcall(function() keyrelease(string.byte(k)) end)
        task.wait(0.06)
    end
end

local function attackMob(mob)
    if not mob or not mob.Parent then return end
    pcall(function()
        local mr = mob:FindFirstChild("HumanoidRootPart")
        if not mr then return end
        local root = getRoot()
        if root then root.CFrame = CFrame.lookAt(root.Position, mr.Position) end
        pcall(function() mouse1press() end) task.wait(0.07)
        pcall(function() mouse1release() end)
        local char = getChar()
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local re = tool:FindFirstChildOfClass("RemoteEvent")
                if re then pcall(function() re:FireServer() end) end
            end
        end
        invokeRemote("attackEnemy", mob)
    end)
end

-- ================================================
-- QUEST
-- ================================================
local lastQuest, lastQuestT = "", 0
local function acceptQuest(md)
    if not md then return end
    if lastQuest == md.Quest and tick() - lastQuestT < 88 then return end
    tpTo(md.QCF, 2)
    task.wait(2.2)
    invokeRemote("startQuest", md.Quest, md.Level)
    if S.DoubleQuest then
        task.wait(0.3)
        invokeRemote("startQuest", md.Quest, md.Level)
    end
    lastQuest = md.Quest
    lastQuestT = tick()
    task.wait(0.3)
end

-- ================================================
-- FARM LOOP
-- ================================================
local farmThread
local function startFarmLoop()
    if farmThread then task.cancel(farmThread) end
    farmThread = task.spawn(function()
        while S.AutoFarm do
            pcall(function()
                local hum = getHum()
                local root = getRoot()
                if not hum or not root then task.wait(1) return end
                if hum.Health <= 0 then task.wait(2) return end
                -- Auto eat
                if S.AutoEat then
                    local pct = (hum.Health / math.max(hum.MaxHealth, 1)) * 100
                    if pct < S.HealthPct then
                        invokeRemote("eatFruit")
                        task.wait(0.5)
                    end
                end
                -- Find target data
                local targetData = nil
                for _, m in ipairs(MobData[Sea] or {}) do
                    if S.FarmMob == "" or m.Name:lower():find(S.FarmMob:lower(), 1, true) then
                        targetData = m break
                    end
                end
                if S.AutoQuest and targetData then acceptQuest(targetData) end
                local mob = getNearestMob(S.FarmMob)
                if mob then
                    local mr = mob:FindFirstChild("HumanoidRootPart")
                    if mr then
                        local mp = mr.Position
                        local dir = (root.Position - mp)
                        local unit = dir.Magnitude > 0 and dir.Unit or Vector3.new(1,0,0)
                        local dest = CFrame.new(mp + Vector3.new(unit.X*4, 3, unit.Z*4))
                        tpTo(dest, 0)
                        task.wait(0.15)
                        if S.UseSkills then useSkills() end
                        attackMob(mob)
                        task.wait(0.18)
                    end
                else
                    if targetData then
                        tpTo(targetData.MCF, 0.6)
                        task.wait(0.7)
                    else
                        task.wait(0.4)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- ================================================
-- BOSS LOOP
-- ================================================
local bossThread
local function startBossLoop(doAll)
    if bossThread then task.cancel(bossThread) end
    bossThread = task.spawn(function()
        while (doAll and S.AutoAllBoss) or (not doAll and S.AutoBoss) do
            pcall(function()
                local list = {}
                if doAll then
                    list = BossData[Sea] or {}
                else
                    for _, b in ipairs(BossData[Sea] or {}) do
                        if S.SelectBoss == "" or b.Name:lower():find(S.SelectBoss:lower(), 1, true) then
                            table.insert(list, b)
                            break
                        end
                    end
                end
                for _, boss in ipairs(list) do
                    if not ((doAll and S.AutoAllBoss) or (not doAll and S.AutoBoss)) then break end
                    tpTo(boss.CF, 3)
                    task.wait(3.2)
                    for _ = 1, 25 do
                        if not ((doAll and S.AutoAllBoss) or (not doAll and S.AutoBoss)) then break end
                        local mob = getNearestMob("")
                        if mob then
                            if S.UseSkills then useSkills() end
                            attackMob(mob)
                        end
                        task.wait(0.22)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- ================================================
-- MELEE LOOP
-- ================================================
local meleeThread
local function startMeleeLoop()
    if meleeThread then task.cancel(meleeThread) end
    meleeThread = task.spawn(function()
        while S.AutoMelee do
            pcall(function()
                local mob = getNearestMob(S.SelectMelee)
                if mob then
                    local mr = mob:FindFirstChild("HumanoidRootPart")
                    if mr then
                        tpTo(CFrame.new(mr.Position + Vector3.new(0,3,0)), 0)
                        task.wait(0.1)
                        useSkills()
                        attackMob(mob)
                        task.wait(0.15)
                    end
                else
                    task.wait(0.5)
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- ================================================
-- MASTERY LOOP
-- ================================================
local mastThread
local function startMasteryLoop()
    if mastThread then task.cancel(mastThread) end
    mastThread = task.spawn(function()
        while S.AutoMastery do
            pcall(function()
                local mob = getNearestMob("")
                if mob then
                    local mr = mob:FindFirstChild("HumanoidRootPart")
                    if mr then
                        tpTo(CFrame.new(mr.Position + Vector3.new(3,3,3)), 0)
                        task.wait(0.12)
                        useSkills()
                        attackMob(mob)
                        task.wait(0.15)
                    end
                else
                    task.wait(0.5)
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- ================================================
-- STATS LOOP
-- ================================================
local statsThread
local function startStatsLoop()
    if statsThread then task.cancel(statsThread) end
    statsThread = task.spawn(function()
        local sm = {Melee=4, Defense=3, Sword=2, Gun=1, ["Blox Fruit"]=5}
        while S.AutoStats do
            invokeRemote("Allocate", sm[S.StatChoice] or 4)
            task.wait(0.12)
        end
    end)
end

-- ================================================
-- HAKI LOOP
-- ================================================
local hakiThread
local function startHakiLoop()
    if hakiThread then task.cancel(hakiThread) end
    hakiThread = task.spawn(function()
        while S.AutoHaki do
            invokeRemote("Haki")
            pcall(function() keypress(string.byte("j")) end)
            task.wait(0.06)
            pcall(function() keyrelease(string.byte("j")) end)
            task.wait(28)
        end
    end)
end

-- ================================================
-- FRUIT HELPERS
-- ================================================
local function getFruits()
    local found = {}
    local containers = {}
    pcall(function()
        table.insert(containers, WS)
        local f1 = WS:FindFirstChild("Fruits")
        local f2 = WS:FindFirstChild("droppedFruits")
        if f1 then table.insert(containers, f1) end
        if f2 then table.insert(containers, f2) end
    end)
    for _, container in ipairs(containers) do
        pcall(function()
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Model") and obj.Name:lower():find("fruit", 1, true) then
                    local h = obj:FindFirstChild("Handle")
                        or obj.PrimaryPart
                        or obj:FindFirstChildOfClass("BasePart")
                    if h then
                        table.insert(found, {obj=obj, part=h})
                    end
                end
            end
        end)
    end
    return found
end

local fruitThread
local function startFruitLoop()
    if fruitThread then task.cancel(fruitThread) end
    fruitThread = task.spawn(function()
        while S.FruitSniper or S.AutoFindFruit do
            pcall(function()
                local fruits = getFruits()
                local target = nil
                for _, f in ipairs(fruits) do
                    if S.OnlyLegendary then
                        for _, lf in ipairs(LegendaryFruits) do
                            if f.obj.Name:lower():find(lf:lower(), 1, true) then
                                target = f break
                            end
                        end
                    else
                        -- Filter by selected fruit if set
                        if S.SelectFruit == "" then
                            target = f
                        else
                            if f.obj.Name:lower():find(S.SelectFruit:lower(), 1, true) then
                                target = f
                            end
                        end
                    end
                    if target then break end
                end
                if target then
                    local cf = target.part.CFrame + Vector3.new(0,3,0)
                    tpTo(cf, 3.5)
                    task.wait(3.6)
                    invokeRemote("Eat", target.obj)
                    invokeRemote("PickFruit", target.obj)
                    if S.AutoStoreFruit then
                        task.wait(0.5)
                        invokeRemote("StoreFruit")
                    end
                end
            end)
            task.wait(2.5)
        end
    end)
end

-- ================================================
-- DEALER LOOP
-- ================================================
local dealerThread
local function startDealerLoop()
    if dealerThread then task.cancel(dealerThread) end
    dealerThread = task.spawn(function()
        local dealerCF = {
            [1]=CFrame.new(-1388,4,-792),
            [2]=CFrame.new(-2100,75,1900),
            [3]=CFrame.new(-14360,120,1640),
        }
        while S.AutoDealer do
            pcall(function()
                local cf = dealerCF[Sea] or dealerCF[1]
                tpTo(cf, 2)
                task.wait(2.2)
                invokeRemote("BuyFruit", S.SelectFruit)
            end)
            task.wait(10)
        end
    end)
end

-- ================================================
-- REDEEM CODES
-- ================================================
local function redeemCodes()
    task.spawn(function()
        for _, code in ipairs(Codes) do
            invokeRemote("Code", code)
            task.wait(0.5)
        end
    end)
end

-- ================================================
-- SERVER HOP (no HTTP — uses TeleportService only)
-- ================================================
local function hopServer()
    pcall(function()
        local TS = game:GetService("TeleportService")
        TS:Teleport(game.PlaceId, LP)
    end)
end

local function hopLowServer()
    pcall(function()
        local TS = game:GetService("TeleportService")
        TS:Teleport(game.PlaceId, LP)
    end)
end

local hopConn
local function startHopIfNearLoop()
    if hopConn then task.cancel(hopConn) end
    hopConn = task.spawn(function()
        while S.HopIfNearPlayer do
            task.wait(S.HopDelay)
            pcall(function()
                local root = getRoot()
                if not root then return end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local pr = p.Character:FindFirstChild("HumanoidRootPart")
                        if pr and (pr.Position - root.Position).Magnitude < 60 then
                            hopServer()
                            return
                        end
                    end
                end
            end)
        end
    end)
end

-- ================================================
-- REMOVE LAVA
-- ================================================
local lavaConn
local function toggleLava(on)
    if lavaConn then pcall(function() lavaConn:Disconnect() end) lavaConn = nil end
    if not on then return end
    local function disablePart(v)
        pcall(function()
            local n = v.Name:lower()
            if v:IsA("BasePart") and (n:find("lava") or n:find("magma")) then
                v.CanTouch = false
            end
        end)
    end
    for _, v in ipairs(WS:GetDescendants()) do disablePart(v) end
    lavaConn = WS.DescendantAdded:Connect(disablePart)
end

-- ================================================
-- BOOST FPS
-- ================================================
local function boostFPS()
    for _, v in ipairs(WS:GetDescendants()) do
        pcall(function()
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end)
    end
    pcall(function()
        WS.Terrain.WaterWaveSize = 0
        WS.Terrain.WaterWaveSpeed = 0
    end)
end

-- ================================================
-- ESP
-- ================================================
local function clearTbl(tbl)
    for k, v in pairs(tbl) do
        pcall(function() v:Destroy() end)
        tbl[k] = nil
    end
end

local function makeESPBB(adornee, label, col)
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0,120,0,34)
    bb.StudsOffset = Vector3.new(0,4,0)
    bb.AlwaysOnTop = true
    bb.Adornee = adornee
    safeParent(bb)
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1,0,0.6,0)
    nl.BackgroundTransparency = 1
    nl.Text = label
    nl.TextColor3 = col or Color3.fromRGB(255,70,70)
    nl.TextStrokeTransparency = 0
    nl.Font = Enum.Font.GothamBold
    nl.TextSize = 12 nl.Parent = bb
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1,0,0.4,0)
    dl.Position = UDim2.new(0,0,0.6,0)
    dl.BackgroundTransparency = 1
    dl.TextColor3 = Color3.fromRGB(210,210,210)
    dl.TextStrokeTransparency = 0
    dl.Font = Enum.Font.Gotham
    dl.TextSize = 10 dl.Parent = bb
    return bb, dl
end

local function addPlayerESP(player)
    if player == LP then return end
    local function make()
        pcall(function()
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local key = player.Name
            if ESPObj[key] then pcall(function() ESPObj[key]:Destroy() end) end
            local bb, dl = makeESPBB(root, player.Name, Color3.fromRGB(255,70,70))
            ESPObj[key] = bb
            local c c = RunService.Heartbeat:Connect(function()
                if not S.PlayerESP or not player.Character
                    or not player.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function() bb:Destroy() end)
                    ESPObj[key] = nil
                    pcall(function() c:Disconnect() end)
                    return
                end
                local mr = getRoot()
                if mr and player.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (player.Character.HumanoidRootPart.Position - mr.Position).Magnitude
                    dl.Text = math.floor(d).."m"
                end
            end)
        end)
    end
    if player.Character then make() end
    player.CharacterAdded:Connect(function() task.wait(1) make() end)
end

local function refreshPlayerESP()
    clearTbl(ESPObj)
    if not S.PlayerESP then return end
    for _, p in ipairs(Players:GetPlayers()) do addPlayerESP(p) end
end

local fruitESPConn
local function runFruitESP()
    if fruitESPConn then pcall(function() fruitESPConn:Disconnect() end) fruitESPConn = nil end
    clearTbl(FruitESPObj)
    if not S.FruitESP then return end
    fruitESPConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            for k, v in pairs(FruitESPObj) do
                if not v or not v.Parent then FruitESPObj[k] = nil end
            end
            local root = getRoot()
            for _, f in ipairs(getFruits()) do
                local key = tostring(f.obj)
                if not FruitESPObj[key] then
                    local bb, dl = makeESPBB(f.part, f.obj.Name, Color3.fromRGB(80,205,120))
                    FruitESPObj[key] = bb
                    if root then
                        dl.Text = math.floor((f.part.Position - root.Position).Magnitude).."m"
                    end
                end
            end
        end)
    end)
end

local flowerESPConn
local function runFlowerESP()
    if flowerESPConn then pcall(function() flowerESPConn:Disconnect() end) flowerESPConn = nil end
    clearTbl(FlowerESPObj)
    if not S.FlowerESP then return end
    flowerESPConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, v in ipairs(WS:GetDescendants()) do
                local key = tostring(v)
                if not FlowerESPObj[key] and v:IsA("BasePart") then
                    local n = v.Name:lower()
                    if n:find("flower",1,true) or n:find("musketeer",1,true) then
                        local bb, _ = makeESPBB(v, "Flower", Color3.fromRGB(255,180,220))
                        FlowerESPObj[key] = bb
                    end
                end
            end
        end)
    end)
end

Players.PlayerAdded:Connect(function(p)
    if S.PlayerESP then addPlayerESP(p) end
end)

-- ================================================
-- UI HELPERS
-- ================================================
local T = {
    BG    = Color3.fromRGB(11,11,17),
    BG2   = Color3.fromRGB(17,17,25),
    BG3   = Color3.fromRGB(24,24,36),
    Side  = Color3.fromRGB(13,13,21),
    Text  = Color3.fromRGB(232,232,232),
    TextD = Color3.fromRGB(138,138,155),
    Border= Color3.fromRGB(33,33,48),
    Hover = Color3.fromRGB(26,18,44),
}

local function tw(o, p, t, s)
    TweenService:Create(o, TweenInfo.new(t or 0.16, s or Enum.EasingStyle.Quad), p):Play()
end
local function cr(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 7)
    c.Parent = p
end
local function sk(p, c, th)
    local s = Instance.new("UIStroke")
    s.Color = c or T.Border
    s.Thickness = th or 1
    s.Parent = p
    return s
end
local function mkF(parent, size, pos, color)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1,0,0,26)
    f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or T.BG2
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end
local function mkL(parent, text, size, pos, color, font, xa)
    local l = Instance.new("TextLabel")
    l.Size = size or UDim2.new(1,0,1,0)
    l.Position = pos or UDim2.new(0,0,0,0)
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or T.Text
    l.TextSize = 11
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end
local function mkB(parent, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(1,0,0,26)
    b.Position = pos or UDim2.new(0,0,0,0)
    b.BackgroundTransparency = 1
    b.Text = "" b.AutoButtonColor = false
    b.BorderSizePixel = 0 b.Parent = parent
    return b
end

-- ================================================
-- NOTIFY
-- ================================================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "EliteNotify"
notifGui.ResetOnSpawn = false
safeParent(notifGui)

local nHolder = mkF(notifGui, UDim2.new(0,238,1,0), UDim2.new(1,-244,0,0), Color3.new(0,0,0))
nHolder.BackgroundTransparency = 1
local nLL = Instance.new("UIListLayout")
nLL.VerticalAlignment = Enum.VerticalAlignment.Bottom
nLL.Padding = UDim.new(0,4)
nLL.Parent = nHolder
local nPP = Instance.new("UIPadding")
nPP.PaddingBottom = UDim.new(0,10)
nPP.Parent = nHolder

local function Notify(title, msg, dur)
    dur = dur or 4
    task.spawn(function()
        local card = mkF(nHolder, UDim2.new(1,0,0,50), nil, T.BG2)
        card.BackgroundTransparency = 1
        cr(card, 8)
        local stroke = sk(card, Accent)
        local bar = mkF(card, UDim2.new(0,3,1,-10), UDim2.new(0,5,0,5), Accent) cr(bar,3)
        local tl = mkL(card, title, UDim2.new(1,-12,0,15), UDim2.new(0,11,0,5), Color3.fromRGB(165,115,255), Enum.Font.GothamBold) tl.TextSize=11
        local cl = mkL(card, msg,   UDim2.new(1,-12,0,13), UDim2.new(0,11,0,22), T.TextD, Enum.Font.Gotham) cl.TextSize=10
        tw(card, {BackgroundTransparency=0}, 0.22)
        task.wait(dur)
        tw(card, {BackgroundTransparency=1}, 0.22)
        task.wait(0.25)
        pcall(function() card:Destroy() end)
    end)
end

-- ================================================
-- DISCORD PROMPT
-- ================================================
local function showDiscordPrompt()
    local dGui = Instance.new("ScreenGui")
    dGui.Name = "EliteDisc"
    dGui.ResetOnSpawn = false
    safeParent(dGui)
    local dCard = mkF(dGui, UDim2.new(0,238,0,76), UDim2.new(1,-244,1,-96), T.BG2)
    dCard.BackgroundTransparency = 1
    cr(dCard, 8) sk(dCard, Accent)
    mkF(dCard, UDim2.new(0,3,1,-12), UDim2.new(0,5,0,6), Accent)
    local dt = mkL(dCard,"Join Elite Hub?",UDim2.new(1,-12,0,14),UDim2.new(0,11,0,7),Color3.fromRGB(165,115,255),Enum.Font.GothamBold) dt.TextSize=11
    local ds = mkL(dCard,"discord.gg/Pq2dsdfHhE",UDim2.new(1,-12,0,12),UDim2.new(0,11,0,23),T.TextD,Enum.Font.Gotham) ds.TextSize=10
    local yB = Instance.new("TextButton")
    yB.Size=UDim2.new(0,85,0,19) yB.Position=UDim2.new(0,11,0,48)
    yB.BackgroundColor3=Accent yB.BorderSizePixel=0
    yB.Text="Yes, Join!" yB.TextColor3=Color3.new(1,1,1)
    yB.Font=Enum.Font.GothamBold yB.TextSize=10 yB.AutoButtonColor=false yB.Parent=dCard cr(yB,5)
    local nB = Instance.new("TextButton")
    nB.Size=UDim2.new(0,70,0,19) nB.Position=UDim2.new(0,103,0,48)
    nB.BackgroundColor3=T.BG3 nB.BorderSizePixel=0
    nB.Text="No thanks" nB.TextColor3=T.TextD
    nB.Font=Enum.Font.Gotham nB.TextSize=10 nB.AutoButtonColor=false nB.Parent=dCard cr(nB,5) sk(nB,T.Border)
    tw(dCard, {BackgroundTransparency=0}, 0.22)
    local function close()
        tw(dCard, {BackgroundTransparency=1}, 0.22)
        task.wait(0.28)
        pcall(function() dGui:Destroy() end)
    end
    yB.MouseButton1Click:Connect(function()
        pcall(setclipboard, "https://discord.gg/Pq2dsdfHhE")
        close()
        Notify("Elite Hub","Discord link copied!",4)
    end)
    nB.MouseButton1Click:Connect(close)
    task.delay(12, function()
        if dGui and dGui.Parent then close() end
    end)
end

-- ================================================
-- MAIN WINDOW
-- ================================================
local gui = Instance.new("ScreenGui")
gui.Name = "EliteHub"
gui.ResetOnSpawn = false
safeParent(gui)

local WIN = UDim2.fromOffset(470,310)
local win = mkF(gui, WIN, UDim2.new(0.5,-235,0.5,-155), T.BG)
cr(win, 10) sk(win, T.Border)

-- Float
local floatT = 0
local isDragging = false
local floatBaseY = -155

RunService.Heartbeat:Connect(function(dt)
    if not S.FloatAnim or isDragging then return end
    floatT = floatT + dt * 1.1
    win.Position = UDim2.new(
        win.Position.X.Scale,
        win.Position.X.Offset,
        0.5,
        floatBaseY + math.sin(floatT) * 2.5
    )
end)

-- DRAG — fixed using AbsolutePosition
local dragStart, winStartAbs
local dragHandle = mkB(win, UDim2.new(1,-116,0,38))
dragHandle.ZIndex = 20

dragHandle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = Vector2.new(i.Position.X, i.Position.Y)
        winStartAbs = Vector2.new(win.AbsolutePosition.X, win.AbsolutePosition.Y)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if not isDragging then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement
    or i.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(i.Position.X, i.Position.Y) - dragStart
        local nx = winStartAbs.X + delta.X
        local ny = winStartAbs.Y + delta.Y
        win.Position = UDim2.fromOffset(nx, ny)
        floatBaseY = ny + 155
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        floatBaseY = win.AbsolutePosition.Y + 155
        floatT = 0
    end
end)

-- Sidebar
local sidebar = mkF(win, UDim2.new(0,114,1,0), UDim2.new(1,-114,0,0), T.Side)
cr(sidebar, 10)
mkF(sidebar, UDim2.new(0,12,1,0), UDim2.new(0,0,0,0), T.Side)

local logoA = mkF(sidebar, UDim2.new(1,0,0,50), nil, T.Side)
local logoTxt = mkL(logoA,"ELITE HUB",UDim2.new(1,-4,0,17),UDim2.new(0,2,0,6),T.Text,Enum.Font.GothamBold,Enum.TextXAlignment.Center) logoTxt.TextSize=12
local ulineF = mkF(logoA, UDim2.new(0,34,0,2), UDim2.new(0.5,-17,0,27), Accent) cr(ulineF,2)
local subTxt = mkL(logoA,"by Marcus",UDim2.new(1,-4,0,10),UDim2.new(0,2,0,33),T.TextD,Enum.Font.Gotham,Enum.TextXAlignment.Center) subTxt.TextSize=9

local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1,0,1,-52)
tabScroll.Position = UDim2.new(0,0,0,52)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 0
tabScroll.CanvasSize = UDim2.new(0,0,0,0)
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabScroll.Parent = sidebar
local tLL = Instance.new("UIListLayout") tLL.Padding = UDim.new(0,2) tLL.Parent = tabScroll
local tPP = Instance.new("UIPadding")
tPP.PaddingTop = UDim.new(0,3)
tPP.PaddingLeft = UDim.new(0,3)
tPP.PaddingRight = UDim.new(0,3)
tPP.Parent = tabScroll

local contentArea = mkF(win, UDim2.new(1,-118,1,-6), UDim2.new(0,3,0,3), T.BG2)
cr(contentArea, 8)

-- accent objects to recolor
local accentFrames = {ulineF}
local accentLabels = {}
local accentStrokes = {}

-- ================================================
-- TAB SYSTEM
-- ================================================
local tabs = {} local activeTab = nil

local function createTab(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,-4,1,-4)
    page.Position = UDim2.new(0,2,0,2)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Accent
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentArea
    local pL = Instance.new("UIListLayout") pL.Padding = UDim.new(0,3) pL.Parent = page
    local pP = Instance.new("UIPadding")
    pP.PaddingTop = UDim.new(0,4)
    pP.PaddingLeft = UDim.new(0,3)
    pP.PaddingRight = UDim.new(0,3)
    pP.PaddingBottom = UDim.new(0,4)
    pP.Parent = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,25)
    btn.BackgroundColor3 = T.Side
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = "" btn.AutoButtonColor = false
    btn.Parent = tabScroll cr(btn,5)
    local ind = mkF(btn, UDim2.new(0,3,0,11), UDim2.new(0,0,0.5,-5.5), Accent) cr(ind,3) ind.Visible=false
    table.insert(accentFrames, ind)
    local bL = mkL(btn, name, UDim2.new(1,-7,1,0), UDim2.new(0,7,0,0), T.TextD, Enum.Font.GothamMedium) bL.TextSize=10

    local function activate()
        if activeTab == name then return end
        if activeTab and tabs[activeTab] then
            tabs[activeTab].page.Visible = false
            tw(tabs[activeTab].btn, {BackgroundTransparency=1}, 0.1)
            tw(tabs[activeTab].label, {TextColor3=T.TextD}, 0.1)
            tabs[activeTab].ind.Visible = false
        end
        activeTab = name
        page.Visible = true
        ind.Visible = true
        tw(btn, {BackgroundTransparency=0, BackgroundColor3=Color3.fromRGB(20,11,38)}, 0.1)
        tw(bL, {TextColor3=T.Text}, 0.1)
    end
    btn.MouseButton1Click:Connect(activate)
    btn.MouseEnter:Connect(function() if activeTab~=name then tw(btn,{BackgroundTransparency=0.75},0.08) end end)
    btn.MouseLeave:Connect(function() if activeTab~=name then tw(btn,{BackgroundTransparency=1},0.08) end end)
    tabs[name] = {page=page, btn=btn, label=bL, ind=ind, activate=activate}
    if not activeTab then activate() end

    local Tab = {}
    local order = 0
    local function no() order=order+1 return order end

    function Tab:Section(title)
        local w = mkF(page, UDim2.new(1,0,0,18), nil, Color3.new(0,0,0))
        w.BackgroundTransparency=1 w.LayoutOrder=no()
        mkF(w, UDim2.new(1,-4,0,1), UDim2.new(0,2,0.5,0), T.Border)
        local sl = mkL(w,"  "..title.."  ",UDim2.new(0,0,1,0),UDim2.new(0,5,0,0),Accent,Enum.Font.GothamBold)
        sl.TextSize=9 sl.AutomaticSize=Enum.AutomaticSize.X
        sl.BackgroundColor3=T.BG2 sl.BackgroundTransparency=0
        table.insert(accentLabels, sl)
    end

    function Tab:Button(title, desc, cb)
        local hasDesc = desc and desc~=""
        local h = hasDesc and 38 or 27
        local w = mkF(page, UDim2.new(1,0,0,h), nil, T.BG3) w.LayoutOrder=no() cr(w,6) sk(w,T.Border)
        local ab = mkF(w, UDim2.new(0,3,0,h-8), UDim2.new(0,0,0,4), Accent) cr(ab,3) ab.ZIndex=2
        table.insert(accentFrames, ab)
        local tl = mkL(w, title, UDim2.new(1,-26,0,13), UDim2.new(0,8,0,hasDesc and 3 or 7), T.Text, Enum.Font.GothamMedium) tl.TextSize=10 tl.ZIndex=2
        if hasDesc then
            local dl = mkL(w, desc, UDim2.new(1,-26,0,11), UDim2.new(0,8,0,18), T.TextD, Enum.Font.Gotham) dl.TextSize=9 dl.ZIndex=2
        end
        local cb2 = mkB(w, UDim2.new(1,0,1,0)) cb2.ZIndex=6
        cb2.MouseEnter:Connect(function() tw(w,{BackgroundColor3=T.Hover},0.08) end)
        cb2.MouseLeave:Connect(function() tw(w,{BackgroundColor3=T.BG3},0.08) end)
        cb2.MouseButton1Click:Connect(function()
            tw(w,{BackgroundColor3=Color3.fromRGB(35,12,72)},0.05)
            task.wait(0.06)
            tw(w,{BackgroundColor3=T.Hover},0.08)
            pcall(cb)
        end)
    end

    function Tab:Toggle(title, default, cb)
        local state = default or false
        local w = mkF(page, UDim2.new(1,0,0,27), nil, T.BG3) w.LayoutOrder=no() cr(w,6) sk(w,T.Border)
        local ab = mkF(w, UDim2.new(0,3,0,14), UDim2.new(0,0,0,6.5), state and Accent or T.Border) cr(ab,3) ab.ZIndex=2
        local tl = mkL(w, title, UDim2.new(1,-46,1,0), UDim2.new(0,8,0,0), T.Text, Enum.Font.GothamMedium) tl.TextSize=10 tl.ZIndex=2
        local pBG = mkF(w, UDim2.new(0,27,0,13), UDim2.new(1,-33,0.5,-6.5), state and Accent or T.Border) cr(pBG,10) pBG.ZIndex=3
        local pill = mkF(pBG, UDim2.new(0,9,0,9), UDim2.new(0,state and 15 or 2,0.5,-4.5), Color3.new(1,1,1)) cr(pill,6) pill.ZIndex=4
        local function set(v)
            state = v
            tw(pBG, {BackgroundColor3=v and Accent or T.Border}, 0.14)
            tw(pill, {Position=UDim2.new(0,v and 15 or 2,0.5,-4.5)}, 0.14, Enum.EasingStyle.Back)
            tw(ab, {BackgroundColor3=v and Accent or T.Border}, 0.14)
            pcall(cb, v)
        end
        local cb2 = mkB(w, UDim2.new(1,0,1,0)) cb2.ZIndex=6
        cb2.MouseEnter:Connect(function() tw(w,{BackgroundColor3=T.Hover},0.08) end)
        cb2.MouseLeave:Connect(function() tw(w,{BackgroundColor3=T.BG3},0.08) end)
        cb2.MouseButton1Click:Connect(function() set(not state) end)
        return {Set=function(_,v) set(v) end, Get=function() return state end}
    end

    function Tab:Dropdown(title, options, cb)
        local selected = options[1] or ""
        local open = false
        local w = mkF(page, UDim2.new(1,0,0,35), nil, T.BG3) w.LayoutOrder=no() w.ClipsDescendants=false cr(w,6) sk(w,T.Border)
        local ab = mkF(w, UDim2.new(0,3,0,19), UDim2.new(0,0,0,8), Accent) cr(ab,3) ab.ZIndex=2 table.insert(accentFrames,ab)
        local tl = mkL(w, title, UDim2.new(0.55,0,0,11), UDim2.new(0,8,0,4), T.TextD, Enum.Font.Gotham) tl.TextSize=9 tl.ZIndex=2
        local sBtn = Instance.new("TextButton")
        sBtn.Size=UDim2.new(1,-11,0,14) sBtn.Position=UDim2.new(0,6,0,18)
        sBtn.BackgroundColor3=T.BG sBtn.BorderSizePixel=0 sBtn.Text="" sBtn.AutoButtonColor=false sBtn.ZIndex=3 sBtn.Parent=w
        cr(sBtn,4) sk(sBtn,T.Border)
        local sL = mkL(sBtn, selected, UDim2.new(1,-15,1,0), UDim2.new(0,4,0,0), T.Text, Enum.Font.Gotham) sL.TextSize=9 sL.ZIndex=4
        local chev = mkL(sBtn, "▾", UDim2.new(0,12,1,0), UDim2.new(1,-13,0,0), Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center) chev.TextSize=9 chev.ZIndex=4
        local panel = mkF(gui, UDim2.new(0,0,0,0), nil, T.BG2) panel.Visible=false panel.ZIndex=30 panel.ClipsDescendants=true cr(panel,6) sk(panel,Accent)
        Instance.new("UIListLayout").Parent = panel
        local function closeP()
            open=false
            tw(chev,{Rotation=0},0.1)
            tw(panel,{Size=UDim2.new(0,panel.AbsoluteSize.X,0,0)},0.11)
            task.wait(0.13) panel.Visible=false
        end
        local function buildItems()
            for _, c in ipairs(panel:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Size=UDim2.new(1,0,0,19)
                item.BackgroundColor3= opt==selected and Color3.fromRGB(20,8,44) or T.BG2
                item.BorderSizePixel=0 item.Text="" item.AutoButtonColor=false item.ZIndex=31 item.Parent=panel
                local il = mkL(item, opt, UDim2.new(1,-4,1,0), UDim2.new(0,4,0,0), opt==selected and Color3.fromRGB(158,98,255) or T.Text, Enum.Font.Gotham)
                il.TextSize=9 il.ZIndex=32
                item.MouseButton1Click:Connect(function()
                    selected=opt sL.Text=opt closeP() buildItems() pcall(cb,opt)
                end)
            end
        end
        buildItems()
        sBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                panel.Visible=true
                local abs=sBtn.AbsolutePosition
                local pw=math.max(w.AbsoluteSize.X-11,60)
                panel.Size=UDim2.new(0,pw,0,0)
                panel.Position=UDim2.new(0,abs.X,0,abs.Y+17)
                tw(chev,{Rotation=180},0.1)
                tw(panel,{Size=UDim2.new(0,pw,0,math.min(#options*19,100))},0.14,Enum.EasingStyle.Back)
            else closeP() end
        end)
        return {
            Set=function(_, v) selected=v sL.Text=v buildItems() end,
            Get=function() return selected end
        }
    end

    function Tab:Slider(title, min, max, default, cb)
        local value = default or min
        local w = mkF(page, UDim2.new(1,0,0,42), nil, T.BG3) w.LayoutOrder=no() cr(w,6) sk(w,T.Border)
        mkF(w, UDim2.new(0,3,0,26), UDim2.new(0,0,0,8), Accent)
        local tl = mkL(w, title, UDim2.new(1,-48,0,11), UDim2.new(0,8,0,6), T.Text, Enum.Font.GothamMedium) tl.TextSize=10
        local vL = mkL(w, tostring(value), UDim2.new(0,36,0,11), UDim2.new(1,-40,0,6), Color3.fromRGB(158,98,255), Enum.Font.GothamBold, Enum.TextXAlignment.Right) vL.TextSize=10
        local track = mkF(w, UDim2.new(1,-14,0,4), UDim2.new(0,7,0,27), T.Border) cr(track,3)
        local fill = mkF(track, UDim2.new((value-min)/math.max(max-min,1),0,1,0), nil, Accent) cr(fill,3)
        local knob = mkF(fill, UDim2.new(0,8,0,8), UDim2.new(1,-4,0.5,-4), Color3.new(1,1,1))
        cr(knob,6)
        local ds = false
        local function upd(x)
            pcall(function()
                local pct = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X,1), 0, 1)
                value = math.round(min + (max-min)*pct)
                vL.Text = tostring(value)
                tw(fill, {Size=UDim2.new(pct,0,1,0)}, 0.03)
                pcall(cb, value)
            end)
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                ds=true upd(i.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if ds and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                upd(i.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                ds=false
            end
        end)
    end

    return Tab
end

-- ================================================
-- UPDATE ACCENT COLOR — WORKS ON ALL ELEMENTS
-- ================================================
local function updateAccent(col)
    Accent = col
    ulineF.BackgroundColor3 = col
    for _, f in ipairs(accentFrames) do pcall(function() f.BackgroundColor3 = col end) end
    for _, l in ipairs(accentLabels) do pcall(function() l.TextColor3 = col end) end
    for _, t in pairs(tabs) do
        pcall(function() t.page.ScrollBarImageColor3 = col end)
    end
end

-- ================================================
-- BUILD TABS
-- ================================================

-- MAIN
local mainTab = createTab("Main")
mainTab:Section("Server")
mainTab:Button("Hop Server","Rejoin a different server",function()
    hopServer() Notify("Server","Hopping...",3)
end)
mainTab:Button("Hop Low Server","Server with fewest players",function()
    hopLowServer() Notify("Server","Hopping to low pop...",3)
end)
mainTab:Toggle("Auto Rejoin on Kick",false,function(v) S.AutoRejoin=v end)
mainTab:Toggle("Hop If Near Player",false,function(v)
    S.HopIfNearPlayer=v
    if v then startHopIfNearLoop() end
end)
mainTab:Slider("Hop Delay (sec)",3,60,10,function(v) S.HopDelay=v end)
mainTab:Section("Codes")
mainTab:Button("Redeem All Codes",#Codes.." codes queued",function()
    redeemCodes()
    Notify("Codes","Redeeming "..#Codes.." codes...",5)
end)
mainTab:Section("Info")
mainTab:Button("Sea "..Sea.." | PlaceId "..PlaceId,"",function() end)
mainTab:Button("Copy Discord","discord.gg/Pq2dsdfHhE",function()
    pcall(setclipboard,"https://discord.gg/Pq2dsdfHhE")
    Notify("Elite Hub","Discord copied!",3)
end)

-- FARM
local farmTab = createTab("Farm")
farmTab:Section("Select Mob")
local seaMobNames = {"Nearest Mob"}
for _, m in ipairs(MobData[Sea] or {}) do
    table.insert(seaMobNames, m.Name.." (Lv "..m.Level..")")
end
farmTab:Dropdown("Mob",seaMobNames,function(v)
    S.FarmMob = v=="Nearest Mob" and "" or (v:match("^(.+) %(Lv") or "")
end)
farmTab:Section("Options")
farmTab:Toggle("Auto Quest",false,function(v) S.AutoQuest=v end)
farmTab:Toggle("Use Skills (Z X C V F)",true,function(v) S.UseSkills=v end)
farmTab:Toggle("Auto Eat (Low HP)",true,function(v) S.AutoEat=v end)
farmTab:Slider("Eat HP%",10,80,35,function(v) S.HealthPct=v end)
farmTab:Toggle("Double Quest",false,function(v) S.DoubleQuest=v end)
farmTab:Section("Farm")
farmTab:Toggle("Auto Farm",false,function(v)
    S.AutoFarm=v
    if v then startFarmLoop() Notify("Farm","Auto Farm ON",3)
    else Notify("Farm","Auto Farm OFF",3) end
end)
farmTab:Section("Sea Progress")
farmTab:Toggle("Auto Sea 2 (700+)",false,function(v)
    S.AutoSea2=v
    if v then
        task.spawn(function()
            while S.AutoSea2 do
                pcall(function() tpTo(CFrame.new(-2076,74,1836),3) end)
                invokeRemote("SeaProgress","Sea2")
                task.wait(5)
            end
        end)
    end
end)
farmTab:Toggle("Auto Sea 3 (1500+)",false,function(v)
    S.AutoSea3=v
    if v then
        task.spawn(function()
            while S.AutoSea3 do
                pcall(function() tpTo(CFrame.new(-14360,120,1640),3) end)
                invokeRemote("SeaProgress","Sea3")
                task.wait(5)
            end
        end)
    end
end)
farmTab:Section("Special")
farmTab:Toggle("Auto Baritlo Quest",false,function(v)
    S.AutoBaritlo=v
    if v then
        task.spawn(function()
            while S.AutoBaritlo do
                tpTo(CFrame.new(-5100,30,3600),2)
                task.wait(2.2)
                invokeRemote("startQuest","BaritloQuest",1250)
                task.wait(5)
            end
        end)
    end
end)
farmTab:Toggle("Auto Factory",false,function(v)
    S.AutoFactory=v
    if v then
        task.spawn(function()
            while S.AutoFactory do
                tpTo(CFrame.new(-5520,15,3060),2)
                task.wait(2.2)
                invokeRemote("Factory")
                task.wait(8)
            end
        end)
    end
end)
farmTab:Toggle("Auto Pirate Raid",false,function(v)
    S.AutoPirateRaid=v
    if v then
        task.spawn(function()
            while S.AutoPirateRaid do
                invokeRemote("PirateRaid")
                task.wait(5)
            end
        end)
    end
end)
farmTab:Toggle("Auto Elite Hunter",false,function(v)
    S.AutoElite=v
    if v then
        task.spawn(function()
            while S.AutoElite do
                invokeRemote("EliteHunter")
                task.wait(5)
            end
        end)
    end
end)

-- BOSS
local bossTab = createTab("Boss")
bossTab:Section("Boss Farm")
local bossNames = {"All Bosses"}
for _, b in ipairs(BossData[Sea] or {}) do table.insert(bossNames, b.Name) end
bossTab:Dropdown("Select Boss",bossNames,function(v) S.SelectBoss=v end)
bossTab:Toggle("Auto Farm Boss",false,function(v)
    S.AutoBoss=v
    if v then startBossLoop(false) Notify("Boss","ON",3)
    else Notify("Boss","OFF",3) end
end)
bossTab:Toggle("Auto Farm All Bosses",false,function(v)
    S.AutoAllBoss=v
    if v then startBossLoop(true) Notify("Boss","All Bosses ON",3)
    else Notify("Boss","All Bosses OFF",3) end
end)

-- MELEE / STATS
local meleeTab = createTab("Melee")
meleeTab:Section("Melee")
local mNames = {"Nearest"}
for _, m in ipairs(MobData[Sea] or {}) do table.insert(mNames, m.Name) end
meleeTab:Dropdown("Target",mNames,function(v) S.SelectMelee=v=="Nearest" and "" or v end)
meleeTab:Toggle("Auto Melee Farm",false,function(v)
    S.AutoMelee=v
    if v then startMeleeLoop() Notify("Melee","ON",3)
    else Notify("Melee","OFF",3) end
end)
meleeTab:Section("Stats")
meleeTab:Dropdown("Stat",{"Melee","Defense","Sword","Gun","Blox Fruit"},function(v) S.StatChoice=v end)
meleeTab:Toggle("Auto Stats",false,function(v) S.AutoStats=v if v then startStatsLoop() end end)
meleeTab:Section("Haki")
meleeTab:Toggle("Auto Haki",false,function(v) S.AutoHaki=v if v then startHakiLoop() end end)

-- MASTERY
local mastTab = createTab("Mastery")
mastTab:Section("Mastery Farm")
mastTab:Dropdown("Target",{"Blox Fruit","Sword","Gun","Melee"},function(v) S.MasteryTarget=v end)
mastTab:Toggle("Auto Mastery Farm",false,function(v)
    S.AutoMastery=v
    if v then startMasteryLoop() Notify("Mastery","ON",3)
    else Notify("Mastery","OFF",3) end
end)
mastTab:Toggle("Stop at Max Level",false,function(v) S.MasteryMaxLevel=v end)
mastTab:Toggle("Auto Unlock Sword Skill",false,function(v)
    S.AutoUnlockSword=v
    if v then
        task.spawn(function()
            while S.AutoUnlockSword do
                invokeRemote("UnlockSwordSkill")
                task.wait(1)
            end
        end)
    end
end)
mastTab:Toggle("Only Legendary/Mythical",false,function(v) S.OnlyLegendary=v end)

-- FRUIT
local fruitTab = createTab("Fruit")
fruitTab:Section("Sniper")
local fNames = {"Any"}
for _, f in ipairs(FruitNames) do table.insert(fNames, f) end
fruitTab:Dropdown("Select Fruit",fNames,function(v) S.SelectFruit=v=="Any" and "" or v end)
fruitTab:Toggle("Fruit Sniper",false,function(v)
    S.FruitSniper=v
    if v then startFruitLoop() Notify("Fruit","Sniper ON",3)
    else Notify("Fruit","Sniper OFF",3) end
end)
fruitTab:Toggle("Auto Find Fruit",false,function(v)
    S.AutoFindFruit=v
    if v and not S.FruitSniper then startFruitLoop() end
end)
fruitTab:Toggle("Auto Store Fruit",false,function(v) S.AutoStoreFruit=v end)
fruitTab:Toggle("Only Legendary",false,function(v) S.OnlyLegendary=v end)
fruitTab:Section("Dealer")
fruitTab:Toggle("Auto Dealer Cousin",false,function(v)
    S.AutoDealer=v
    if v then startDealerLoop() Notify("Fruit","Dealer ON",3)
    else Notify("Fruit","Dealer OFF",3) end
end)
fruitTab:Button("Scan Now","TP to nearest fruit",function()
    local fruits = getFruits()
    if #fruits > 0 then
        local f = fruits[1]
        tpTo(f.part.CFrame + Vector3.new(0,3,0), 3)
        Notify("Fruit","→ "..f.obj.Name,4)
    else
        Notify("Fruit","None found",3)
    end
end)

-- ESP
local espTab = createTab("ESP")
espTab:Section("Player")
espTab:Toggle("Player ESP",false,function(v)
    S.PlayerESP=v refreshPlayerESP()
    Notify("ESP","Player "..(v and "ON" or "OFF"),3)
end)
espTab:Button("Refresh","",function() refreshPlayerESP() Notify("ESP","Refreshed",2) end)
espTab:Section("World")
espTab:Toggle("Devil Fruit ESP",false,function(v)
    S.FruitESP=v runFruitESP()
    Notify("ESP","Fruit "..(v and "ON" or "OFF"),3)
end)
espTab:Toggle("Flower ESP",false,function(v)
    S.FlowerESP=v runFlowerESP()
    Notify("ESP","Flower "..(v and "ON" or "OFF"),3)
end)

-- TELEPORT
local tpTab = createTab("TP")
tpTab:Section("Sea "..Sea)
for _, tp in ipairs(TpData[Sea] or TpData[1]) do
    local cf = tp.CF
    local n = tp.Name
    tpTab:Button(n,"",function()
        tpTo(cf, 3.5)
        Notify("TP","→ "..n,3)
    end)
end

-- PERFORMANCE
local perfTab = createTab("Perf")
perfTab:Section("Performance")
perfTab:Toggle("Boost FPS",false,function(v)
    S.BoostFPS=v
    if v then boostFPS() end
    Notify("Perf",v and "FPS Boost ON" or "FPS Boost OFF",3)
end)
perfTab:Toggle("Remove Lava Damage",false,function(v)
    S.RemoveLava=v toggleLava(v)
    Notify("Perf",v and "Lava OFF" or "Lava ON",3)
end)

-- SETTINGS
local settTab = createTab("Settings")
settTab:Section("Accent Color")
local colMap = {
    Purple = Color3.fromRGB(120,60,230),
    Blue   = Color3.fromRGB(50,110,240),
    Cyan   = Color3.fromRGB(30,190,215),
    Green  = Color3.fromRGB(40,190,100),
    Red    = Color3.fromRGB(215,50,60),
    Pink   = Color3.fromRGB(220,60,170),
    Orange = Color3.fromRGB(230,110,40),
    Gold   = Color3.fromRGB(210,170,40),
}
local colList = {"Purple","Blue","Cyan","Green","Red","Pink","Orange","Gold"}
settTab:Dropdown("Color",colList,function(v)
    if colMap[v] then
        updateAccent(colMap[v])
        Notify("Settings","Color → "..v,3)
    end
end)
settTab:Section("UI")
settTab:Toggle("Floating Animation",true,function(v) S.FloatAnim=v end)
settTab:Section("Hub")
settTab:Button("Close Hub","",function()
    pcall(function()
        for _, g in ipairs(CoreGui:GetChildren()) do
            if g.Name:sub(1,5)=="Elite" then g:Destroy() end
        end
        LP.PlayerGui.EliteHub:Destroy()
        LP.PlayerGui.EliteNotify:Destroy()
    end)
end)

-- ================================================
-- MINIMIZE (END KEY)
-- ================================================
local minimized = false
UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.End then
        minimized = not minimized
        contentArea.Visible = not minimized
        tw(win, {Size=minimized and UDim2.fromOffset(120,50) or WIN}, 0.2, Enum.EasingStyle.Quint)
    end
end)

-- ================================================
-- RESPAWN RECONNECT
-- ================================================
LP.CharacterAdded:Connect(function()
    task.wait(2.5)
    if S.AutoFarm then startFarmLoop() end
    if S.AutoStats then startStatsLoop() end
    if S.FruitSniper or S.AutoFindFruit then startFruitLoop() end
    if S.PlayerESP then refreshPlayerESP() end
    if S.FruitESP then runFruitESP() end
    if S.FlowerESP then runFlowerESP() end
    if S.AutoBoss then startBossLoop(false) end
    if S.AutoAllBoss then startBossLoop(true) end
    if S.AutoMelee then startMeleeLoop() end
    if S.AutoMastery then startMasteryLoop() end
    if S.RemoveLava then toggleLava(true) end
    if S.AutoHaki then startHakiLoop() end
    if S.AutoDealer then startDealerLoop() end
end)

-- ================================================
-- STARTUP
-- ================================================
task.wait(0.4)
showDiscordPrompt()
task.wait(0.3)
Notify("Elite Hub","Sea "..Sea.." | Loaded | by Marcus",5)
