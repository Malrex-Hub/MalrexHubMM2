-- Elite Hub | Blox Fruits | by Marcus
-- discord.gg/Pq2dsdfHhE

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
local function safeParent(gui)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok or not gui.Parent then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end
end

-- ================================================
-- LOADING SCREEN (fixed: actually renders now)
-- ================================================
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "EliteLoad"
loadGui.ResetOnSpawn = false
loadGui.DisplayOrder = 999
loadGui.IgnoreGuiInset = true
safeParent(loadGui)

local loadBG = Instance.new("Frame")
loadBG.Size = UDim2.new(1,0,1,0)
loadBG.BackgroundColor3 = Color3.fromRGB(10,10,16)
loadBG.BorderSizePixel = 0
loadBG.ZIndex = 100
loadBG.Parent = loadGui

local function mkLbl(parent,text,size,pos,color,font,xa,ts)
    local l = Instance.new("TextLabel")
    l.Size=size l.Position=pos
    l.BackgroundTransparency=1
    l.Text=text l.TextColor3=color
    l.TextSize=ts or 13
    l.Font=font or Enum.Font.Gotham
    l.TextXAlignment=xa or Enum.TextXAlignment.Center
    l.TextTransparency=0
    l.ZIndex=101
    l.Parent=parent
    return l
end

local loadTitle=mkLbl(loadBG,"ELITE HUB",UDim2.new(0,300,0,48),UDim2.new(0.5,-150,0.35,0),Color3.fromRGB(240,240,240),Enum.Font.GothamBold,Enum.TextXAlignment.Center,36)
local loadSub=mkLbl(loadBG,"by Marcus",UDim2.new(0,300,0,22),UDim2.new(0.5,-150,0.47,0),Color3.fromRGB(130,70,255),Enum.Font.Gotham,Enum.TextXAlignment.Center,14)
local loadDisc=mkLbl(loadBG,"discord.gg/Pq2dsdfHhE",UDim2.new(0,300,0,16),UDim2.new(0.5,-150,0.8,0),Color3.fromRGB(80,80,100),Enum.Font.Gotham,Enum.TextXAlignment.Center,11)

local barBG=Instance.new("Frame")
barBG.Size=UDim2.new(0,300,0,5)
barBG.Position=UDim2.new(0.5,-150,0.57,0)
barBG.BackgroundColor3=Color3.fromRGB(28,28,42)
barBG.BorderSizePixel=0 barBG.ZIndex=101 barBG.Parent=loadBG
local _c=Instance.new("UICorner") _c.CornerRadius=UDim.new(1,0) _c.Parent=barBG

local barFill=Instance.new("Frame")
barFill.Size=UDim2.new(0,0,1,0)
barFill.BackgroundColor3=Color3.fromRGB(130,70,255)
barFill.BorderSizePixel=0 barFill.ZIndex=102 barFill.Parent=barBG
local _c2=Instance.new("UICorner") _c2.CornerRadius=UDim.new(1,0) _c2.Parent=barFill

local loadStat=Instance.new("TextLabel")
loadStat.Size=UDim2.new(0,300,0,18) loadStat.Position=UDim2.new(0.5,-150,0.61,0)
loadStat.BackgroundTransparency=1 loadStat.Text="Initializing..."
loadStat.TextColor3=Color3.fromRGB(150,150,170) loadStat.TextSize=11
loadStat.Font=Enum.Font.Gotham loadStat.TextXAlignment=Enum.TextXAlignment.Left
loadStat.ZIndex=101 loadStat.Parent=loadBG

task.wait(0.3)
for _,s in ipairs({
    {t="Initializing...",p=0.2},
    {t="Loading features...",p=0.5},
    {t="Building UI...",p=0.75},
    {t="Done!",p=1.0},
}) do
    loadStat.Text=s.t
    TweenService:Create(barFill,TweenInfo.new(0.4,Enum.EasingStyle.Quad),{Size=UDim2.new(s.p,0,1,0)}):Play()
    task.wait(0.45)
end
task.wait(0.2)
TweenService:Create(loadBG,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
for _,v in ipairs(loadBG:GetDescendants()) do
    if v:IsA("TextLabel") then TweenService:Create(v,TweenInfo.new(0.35),{TextTransparency=1}):Play()
    elseif v:IsA("Frame") then TweenService:Create(v,TweenInfo.new(0.35),{BackgroundTransparency=1}):Play() end
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
local State = {
    AutoFarm=false, AutoQuest=false, AutoStats=false,
    FruitSniper=false, ESP=false,
    FarmMob="", UseSkills=true, AutoEat=true, HealthPct=30,
    StatChoice="Melee", FloatAnim=true,
}
local ESPObjects = {}

-- ================================================
-- CHARACTER
-- ================================================
local function getChar() return LP.Character end
local function getRoot() local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end

-- ================================================
-- TELEPORT — FIXED: strong multi-set position lock
-- ================================================
local tpConn
local function tpTo(cf, hold)
    local root = getRoot()
    if not root then return end
    -- Set multiple times immediately to fight network correction
    for i = 1, 3 do
        root.CFrame = cf
        task.wait()
    end
    if tpConn then tpConn:Disconnect() tpConn = nil end
    if hold and hold > 0 then
        local elapsed = 0
        tpConn = RunService.Heartbeat:Connect(function(dt)
            elapsed = elapsed + dt
            local r = getRoot()
            if r then
                r.CFrame = cf
                -- Also zero out velocity so physics doesn't fight us
                local vel = r:FindFirstChildOfClass("LinearVelocity") or r:FindFirstChild("RootJoint")
                pcall(function() r.AssemblyLinearVelocity = Vector3.zero end)
                pcall(function() r.AssemblyAngularVelocity = Vector3.zero end)
            end
            if elapsed >= hold then tpConn:Disconnect() tpConn = nil end
        end)
    end
end

-- ================================================
-- MOB DATA
-- ================================================
local MobData = {
    [1]={
        {Name="Bandit",          Quest="BanditQuest",    Level=1,   QCF=CFrame.new(-1254,5,-1989),  MCF=CFrame.new(-1228,6,-1920)},
        {Name="Monkey",          Quest="MonkeyQuest",    Level=10,  QCF=CFrame.new(-1376,4,-795),   MCF=CFrame.new(-1357,5,-841)},
        {Name="Pirate",          Quest="PirateQuest",    Level=30,  QCF=CFrame.new(944,5,4417),     MCF=CFrame.new(974,6,4379)},
        {Name="Brute",           Quest="BruteQuest",     Level=50,  QCF=CFrame.new(944,5,4417),     MCF=CFrame.new(998,6,4355)},
        {Name="Desert Bandit",   Quest="DesertQuest",    Level=75,  QCF=CFrame.new(893,6,4393),     MCF=CFrame.new(897,6,4360)},
        {Name="Desert Officer",  Quest="DesertQuest",    Level=90,  QCF=CFrame.new(893,6,4393),     MCF=CFrame.new(1547,14,4381)},
        {Name="Snow Bandit",     Quest="SnowQuest",      Level=100, QCF=CFrame.new(1387,87,-1298),  MCF=CFrame.new(1356,105,-1328)},
        {Name="Snowman",         Quest="SnowQuest",      Level=120, QCF=CFrame.new(1387,87,-1298),  MCF=CFrame.new(1424,126,-1308)},
        {Name="Warrior",         Quest="WarriorQuest",   Level=150, QCF=CFrame.new(-3157,10,1098),  MCF=CFrame.new(-3100,7,1090)},
        {Name="Gladiator",       Quest="GladiatorQuest", Level=175, QCF=CFrame.new(-3157,10,1098),  MCF=CFrame.new(-3200,10,1080)},
        {Name="Fishman",         Quest="FishmanQuest",   Level=200, QCF=CFrame.new(-3047,-19,3812), MCF=CFrame.new(-2980,-30,3900)},
        {Name="Fishman Warrior", Quest="FishmanQuest",   Level=225, QCF=CFrame.new(-3047,-19,3812), MCF=CFrame.new(-3060,-35,3830)},
        {Name="Mushroom",        Quest="MushroomQuest",  Level=300, QCF=CFrame.new(-4640,5,280),    MCF=CFrame.new(-4620,5,350)},
        {Name="Gorilla",         Quest="GorillaQuest",   Level=350, QCF=CFrame.new(-4680,5,220),    MCF=CFrame.new(-4700,5,180)},
        {Name="LumberJack",      Quest="LumberQuest",    Level=375, QCF=CFrame.new(4880,5,555),     MCF=CFrame.new(4900,6,600)},
    },
    [2]={
        {Name="Raider",              Quest="RaiderQuest",  Level=700,  QCF=CFrame.new(-2076,74,1836),  MCF=CFrame.new(-2100,75,1900)},
        {Name="Mercenary",           Quest="MercQuest",    Level=750,  QCF=CFrame.new(-2076,74,1836),  MCF=CFrame.new(-2050,75,1860)},
        {Name="Marine (S2)",         Quest="MarineQuest",  Level=800,  QCF=CFrame.new(-2900,11,1314),  MCF=CFrame.new(-2920,11,1380)},
        {Name="Zombie",              Quest="ZombieQuest",  Level=850,  QCF=CFrame.new(-2390,30,1500),  MCF=CFrame.new(-2400,30,1560)},
        {Name="Vampire",             Quest="VampireQuest", Level=875,  QCF=CFrame.new(-2390,30,1500),  MCF=CFrame.new(-2380,35,1480)},
        {Name="Snow Trooper",        Quest="SnowTrooper",  Level=900,  QCF=CFrame.new(-2600,145,700),  MCF=CFrame.new(-2580,145,760)},
        {Name="Yeti",                Quest="YetiQuest",    Level=950,  QCF=CFrame.new(-2600,145,700),  MCF=CFrame.new(-2620,145,680)},
        {Name="Dragon Crew Soldier", Quest="DragonQuest",  Level=1100, QCF=CFrame.new(-5500,15,3000),  MCF=CFrame.new(-5520,15,3060)},
        {Name="Wano Samurai",        Quest="WanoQuest",    Level=1250, QCF=CFrame.new(-5100,30,3600),  MCF=CFrame.new(-5080,35,3580)},
    },
    [3]={
        {Name="Pirate Millionaire",  Quest="PMQuest",  Level=1500, QCF=CFrame.new(-14360,120,1640), MCF=CFrame.new(-14380,120,1700)},
        {Name="Forest Pirate",       Quest="FPQuest",  Level=1575, QCF=CFrame.new(-14360,120,1640), MCF=CFrame.new(-14340,120,1620)},
        {Name="Royal Soldier",       Quest="RSQuest",  Level=1675, QCF=CFrame.new(-12800,115,840),  MCF=CFrame.new(-12780,115,820)},
        {Name="Gamma Zombie",        Quest="GZQuest",  Level=1700, QCF=CFrame.new(-12200,100,2600), MCF=CFrame.new(-12220,100,2660)},
        {Name="Haunted Pirate",      Quest="HPQuest",  Level=1875, QCF=CFrame.new(-9800,95,1700),   MCF=CFrame.new(-9780,95,1680)},
        {Name="Reborn Skeleton",     Quest="RBQuest",  Level=1925, QCF=CFrame.new(-9200,90,2400),   MCF=CFrame.new(-9220,90,2460)},
        {Name="Ice Cream Chef",      Quest="ICQuest",  Level=2275, QCF=CFrame.new(-7200,70,4800),   MCF=CFrame.new(-7220,70,4860)},
        {Name="Ice Cream Commander", Quest="ICCQuest", Level=2325, QCF=CFrame.new(-7200,70,4800),   MCF=CFrame.new(-7180,70,4780)},
    },
}

local TeleportData = {
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

-- ================================================
-- ATTACK / SKILLS — FIXED: proper melee + remote attack
-- ================================================
local function getMobs()
    local list = {}
    -- Search both "Enemies" folder and direct workspace children
    local function scanFolder(folder)
        if not folder then return end
        for _,v in ipairs(folder:GetChildren()) do
            local h = v:FindFirstChildOfClass("Humanoid")
            local r = v:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
                table.insert(list, v)
            end
        end
    end
    scanFolder(WS:FindFirstChild("Enemies"))
    -- Also scan workspace directly in case mobs aren't in Enemies folder
    for _,v in ipairs(WS:GetChildren()) do
        local h = v:FindFirstChildOfClass("Humanoid")
        local r = v:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(v) and v ~= LP.Character then
            -- Avoid duplicates
            local found = false
            for _,existing in ipairs(list) do if existing == v then found=true break end end
            if not found then table.insert(list, v) end
        end
    end
    return list
end

local function getNearestMob(name)
    local root = getRoot()
    if not root then return nil end
    local nearest, dist = nil, math.huge
    for _,mob in ipairs(getMobs()) do
        local match = name == "" or mob.Name:lower():find(name:lower(), 1, true)
        if match then
            local mobRoot = mob:FindFirstChild("HumanoidRootPart")
            if mobRoot then
                local d = (mobRoot.Position - root.Position).Magnitude
                if d < dist then dist=d nearest=mob end
            end
        end
    end
    return nearest
end

local function useSkills()
    for _,key in ipairs({"z","x","c","v","f"}) do
        pcall(function()
            keypress(string.byte(key))
            task.wait(0.1)
            keyrelease(string.byte(key))
        end)
        task.wait(0.08)
    end
end

-- FIXED: attack now uses click + remote + tool activation for proper melee
local function attackMob(mob)
    if not mob or not mob.Parent then return end
    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
    if not mobRoot then return end
    -- Face the mob
    local root = getRoot()
    if root then
        root.CFrame = CFrame.lookAt(root.Position, mobRoot.Position)
    end
    -- Simulate mouse click for melee tools
    pcall(function() mouse1press() end)
    task.wait(0.08)
    pcall(function() mouse1release() end)
    -- Try activating equipped tool
    pcall(function()
        local char = getChar()
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("RemoteEvent") then
                tool.RemoteEvent:FireServer()
            end
        end
    end)
    -- Network remote fallback
    pcall(function()
        local remote = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CommF_")
        if remote then remote:InvokeServer("attackEnemy", mob) end
    end)
end

-- ================================================
-- QUEST
-- ================================================
local lastQuest, lastQuestTime = "", 0
local function acceptQuest(mobData)
    if not mobData then return end
    if lastQuest == mobData.Quest and tick() - lastQuestTime < 90 then return end
    tpTo(mobData.QCF, 2)
    task.wait(2.1)
    pcall(function() RS.Remotes.CommF_:InvokeServer("startQuest", mobData.Quest, mobData.Level) end)
    lastQuest = mobData.Quest
    lastQuestTime = tick()
    task.wait(0.3)
end

-- ================================================
-- FARM LOOP — FIXED: finds mobs properly, attacks correctly
-- ================================================
local farmThread
local function startFarmLoop()
    if farmThread then task.cancel(farmThread) end
    farmThread = task.spawn(function()
        while State.AutoFarm do
            pcall(function()
                local hum = getHum()
                local root = getRoot()
                if not hum or not root then task.wait(1) return end
                if hum.Health <= 0 then task.wait(2) return end

                -- Auto eat
                if State.AutoEat and (hum.Health / hum.MaxHealth * 100) < State.HealthPct then
                    pcall(function() RS.Remotes.CommF_:InvokeServer("eatFruit") end)
                    task.wait(0.5)
                end

                -- Find target data for quest/fallback tp
                local targetData = nil
                for _,m in ipairs(MobData[Sea] or {}) do
                    if State.FarmMob == "" or m.Name:lower():find(State.FarmMob:lower(), 1, true) then
                        targetData = m break
                    end
                end

                if State.AutoQuest and targetData then acceptQuest(targetData) end

                local mob = getNearestMob(State.FarmMob)
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    local mobPos = mob.HumanoidRootPart.Position
                    -- TP right next to mob (3 studs away, not on top)
                    local offset = (root.Position - mobPos).Unit * 3
                    if offset ~= offset then offset = Vector3.new(3,0,0) end -- nan check
                    tpTo(CFrame.new(mobPos + Vector3.new(offset.X, 3, offset.Z)), 0)
                    task.wait(0.15)
                    if State.UseSkills then useSkills() end
                    attackMob(mob)
                    task.wait(0.2)
                else
                    -- No mob found, tp to spawn point for the target
                    if targetData then
                        tpTo(targetData.MCF, 0.5)
                        task.wait(0.6)
                    else
                        task.wait(0.5)
                    end
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
        local statMap = {Melee=4, Defense=3, Sword=2, Gun=1, ["Blox Fruit"]=5}
        while State.AutoStats do
            pcall(function()
                RS.Remotes.CommF_:InvokeServer("Allocate", statMap[State.StatChoice] or 4)
            end)
            task.wait(0.1)
        end
    end)
end

-- ================================================
-- FRUIT SNIPER — FIXED: proper tp lock so it doesn't snap back
-- ================================================
local fruitThread
local function startFruitLoop()
    if fruitThread then task.cancel(fruitThread) end
    fruitThread = task.spawn(function()
        while State.FruitSniper do
            pcall(function()
                local containers = {WS, WS:FindFirstChild("Fruits"), WS:FindFirstChild("droppedFruits")}
                for _,container in ipairs(containers) do
                    if not container then continue end
                    for _,obj in ipairs(container:GetChildren()) do
                        if obj:IsA("Model") and obj.Name:lower():find("fruit") then
                            local h = obj:FindFirstChild("Handle") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                            if h then
                                local targetCF = h.CFrame + Vector3.new(0,3,0)
                                -- Hold position firmly so we don't snap back
                                tpTo(targetCF, 3)
                                task.wait(3.1)
                                pcall(function() RS.Remotes.CommF_:InvokeServer("Eat", obj) end)
                                pcall(function() RS.Remotes.CommF_:InvokeServer("PickFruit", obj) end)
                                task.wait(0.5)
                                break
                            end
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
end

-- ================================================
-- ESP
-- ================================================
local function clearESP()
    for _,v in pairs(ESPObjects) do pcall(function() v:Destroy() end) end
    ESPObjects = {}
end
local function addESP(player)
    if player == LP then return end
    local function make()
        local char = player.Character if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart") if not root then return end
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0,120,0,40) bb.StudsOffset = Vector3.new(0,4,0)
        bb.AlwaysOnTop = true bb.Adornee = root safeParent(bb)
        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1,0,0.6,0) nl.BackgroundTransparency = 1
        nl.Text = player.Name nl.TextColor3 = Color3.fromRGB(255,70,70)
        nl.TextStrokeTransparency = 0 nl.Font = Enum.Font.GothamBold nl.TextSize = 14 nl.Parent = bb
        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1,0,0.4,0) dl.Position = UDim2.new(0,0,0.6,0)
        dl.BackgroundTransparency = 1 dl.TextColor3 = Color3.fromRGB(255,255,255)
        dl.TextStrokeTransparency = 0 dl.Font = Enum.Font.Gotham dl.TextSize = 11 dl.Parent = bb
        ESPObjects[player.Name] = bb
        local c c = RunService.Heartbeat:Connect(function()
            if not State.ESP or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                bb:Destroy() ESPObjects[player.Name] = nil c:Disconnect() return
            end
            local mr = getRoot()
            if mr then dl.Text = math.floor((player.Character.HumanoidRootPart.Position - mr.Position).Magnitude).."m" end
        end)
    end
    if player.Character then make() end
    player.CharacterAdded:Connect(function() task.wait(1) make() end)
end
local function refreshESP()
    clearESP()
    if not State.ESP then return end
    for _,p in ipairs(Players:GetPlayers()) do addESP(p) end
end
Players.PlayerAdded:Connect(function(p) if State.ESP then addESP(p) end end)

-- ================================================
-- UI
-- ================================================
local T = {
    BG=Color3.fromRGB(13,13,20), BG2=Color3.fromRGB(20,20,30), BG3=Color3.fromRGB(28,28,42),
    Side=Color3.fromRGB(16,16,25), Accent=Color3.fromRGB(120,60,230), AccentL=Color3.fromRGB(160,100,255),
    Text=Color3.fromRGB(235,235,235), TextD=Color3.fromRGB(150,150,170),
    Border=Color3.fromRGB(38,38,55), Hover=Color3.fromRGB(30,22,50),
    ON=Color3.fromRGB(120,60,230), OFF=Color3.fromRGB(38,38,55),
}
local function tw(o,p,t,s) TweenService:Create(o,TweenInfo.new(t or 0.2,s or Enum.EasingStyle.Quad),p):Play() end
local function cr(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p end
local function sk(p,c,t) local s=Instance.new("UIStroke") s.Color=c or T.Border s.Thickness=t or 1 s.Parent=p end
local function mkF(parent,size,pos,color)
    local f=Instance.new("Frame") f.Size=size or UDim2.new(1,0,0,30)
    f.Position=pos or UDim2.new(0,0,0,0) f.BackgroundColor3=color or T.BG2
    f.BorderSizePixel=0 f.Parent=parent return f
end
local function mkL(parent,text,size,pos,color,font,xa)
    local l=Instance.new("TextLabel") l.Size=size or UDim2.new(1,0,1,0)
    l.Position=pos or UDim2.new(0,0,0,0) l.BackgroundTransparency=1
    l.Text=text or "" l.TextColor3=color or T.Text l.TextSize=13
    l.Font=font or Enum.Font.GothamMedium l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.Parent=parent return l
end
local function mkB(parent,size,pos)
    local b=Instance.new("TextButton") b.Size=size or UDim2.new(1,0,0,30)
    b.Position=pos or UDim2.new(0,0,0,0) b.BackgroundTransparency=1
    b.Text="" b.AutoButtonColor=false b.BorderSizePixel=0 b.Parent=parent return b
end

-- Notify system
local notifGui=Instance.new("ScreenGui") notifGui.Name="EliteNotify" notifGui.ResetOnSpawn=false safeParent(notifGui)
local nHolder=mkF(notifGui,UDim2.new(0,260,1,0),UDim2.new(1,-266,0,0),Color3.new(0,0,0))
nHolder.BackgroundTransparency=1
local nL=Instance.new("UIListLayout") nL.VerticalAlignment=Enum.VerticalAlignment.Bottom nL.Padding=UDim.new(0,5) nL.Parent=nHolder
local nP=Instance.new("UIPadding") nP.PaddingBottom=UDim.new(0,10) nP.Parent=nHolder

local function Notify(title,content,duration)
    duration=duration or 4
    local card=mkF(nHolder,UDim2.new(1,0,0,56),nil,T.BG2)
    card.BackgroundTransparency=1 cr(card,10) sk(card,T.Accent)
    local bar=mkF(card,UDim2.new(0,3,1,-10),UDim2.new(0,6,0,5),T.Accent) cr(bar,3)
    local tl=mkL(card,title,UDim2.new(1,-16,0,17),UDim2.new(0,14,0,6),T.AccentL,Enum.Font.GothamBold) tl.TextSize=12
    local cl=mkL(card,content,UDim2.new(1,-16,0,15),UDim2.new(0,14,0,25),T.TextD,Enum.Font.Gotham) cl.TextSize=11
    tw(card,{BackgroundTransparency=0},0.3)
    task.delay(duration,function() tw(card,{BackgroundTransparency=1},0.3) task.wait(0.35) pcall(function() card:Destroy() end) end)
end

-- ================================================
-- DISCORD NOTIFICATION-STYLE PROMPT (replaced popup)
-- ================================================
local function showDiscordPrompt()
    -- Card container in notify area but bigger and with buttons
    local dGui=Instance.new("ScreenGui") dGui.Name="EliteDiscPop" dGui.ResetOnSpawn=false safeParent(dGui)
    local dCard=mkF(dGui,UDim2.new(0,260,0,80),UDim2.new(1,-266,1,-105),T.BG2)
    dCard.BackgroundTransparency=1 cr(dCard,10) sk(dCard,T.Accent)
    local dBar=mkF(dCard,UDim2.new(0,3,1,-16),UDim2.new(0,6,0,8),T.Accent) cr(dBar,3)
    local dTitle=mkL(dCard,"Join Elite Hub?",UDim2.new(1,-16,0,15),UDim2.new(0,14,0,7),T.AccentL,Enum.Font.GothamBold) dTitle.TextSize=12
    local dSub=mkL(dCard,"discord.gg/Pq2dsdfHhE",UDim2.new(1,-16,0,12),UDim2.new(0,14,0,24),T.TextD,Enum.Font.Gotham) dSub.TextSize=10

    local yB=Instance.new("TextButton")
    yB.Size=UDim2.new(0,90,0,22) yB.Position=UDim2.new(0,14,0,50)
    yB.BackgroundColor3=T.Accent yB.BorderSizePixel=0
    yB.Text="Yes, Join!" yB.TextColor3=Color3.new(1,1,1)
    yB.Font=Enum.Font.GothamBold yB.TextSize=11 yB.AutoButtonColor=false yB.Parent=dCard cr(yB,6)

    local nB=Instance.new("TextButton")
    nB.Size=UDim2.new(0,70,0,22) nB.Position=UDim2.new(0,112,0,50)
    nB.BackgroundColor3=T.BG3 nB.BorderSizePixel=0
    nB.Text="No thanks" nB.TextColor3=T.TextD
    nB.Font=Enum.Font.Gotham nB.TextSize=11 nB.AutoButtonColor=false nB.Parent=dCard cr(nB,6) sk(nB,T.Border)

    tw(dCard,{BackgroundTransparency=0},0.3)

    local function closeDisc()
        tw(dCard,{BackgroundTransparency=1},0.3)
        task.wait(0.35) pcall(function() dGui:Destroy() end)
    end
    yB.MouseButton1Click:Connect(function()
        pcall(setclipboard,"https://discord.gg/Pq2dsdfHhE")
        closeDisc()
        Notify("Elite Hub","Discord copied! Paste in browser 🔗",5)
    end)
    nB.MouseButton1Click:Connect(closeDisc)

    -- Auto-dismiss after 12s
    task.delay(12, function() pcall(function() if dGui and dGui.Parent then closeDisc() end end) end)
end

-- Main window
local gui=Instance.new("ScreenGui") gui.Name="EliteHub" gui.ResetOnSpawn=false safeParent(gui)
local WIN=UDim2.fromOffset(540,360)
local win=mkF(gui,WIN,UDim2.new(0.5,-270,0.5,-180),T.BG)
cr(win,12) sk(win,T.Border)

-- Floating animation
local floatT,floatBase=0,Vector2.new(0,win.Position.Y.Offset)
local dragging=false
RunService.Heartbeat:Connect(function(dt)
    if not State.FloatAnim or dragging then return end
    floatT=floatT+dt*1.2
    win.Position=UDim2.new(win.Position.X.Scale,win.Position.X.Offset,0.5,floatBase.Y+math.sin(floatT)*3)
end)

-- DRAG — FIXED: use GuiObject drag properly
local dragStart,winStartPos
local dHandle=mkB(win,UDim2.new(1,-142,0,44)) dHandle.ZIndex=20

dHandle.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=i.Position
        winStartPos=win.Position
        floatBase=Vector2.new(win.Position.X.Offset,win.Position.Y.Offset)
        floatT=0
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if not dragging then return end
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        local delta=i.Position-dragStart
        win.Position=UDim2.new(
            winStartPos.X.Scale, winStartPos.X.Offset+delta.X,
            winStartPos.Y.Scale, winStartPos.Y.Offset+delta.Y
        )
        floatBase=Vector2.new(win.Position.X.Offset,win.Position.Y.Offset)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
        floatBase=Vector2.new(win.Position.X.Offset,win.Position.Y.Offset)
        floatT=0
    end
end)

-- Sidebar RIGHT
local sidebar=mkF(win,UDim2.new(0,138,1,0),UDim2.new(1,-138,0,0),T.Side)
cr(sidebar,12) mkF(sidebar,UDim2.new(0,16,1,0),UDim2.new(0,0,0,0),T.Side)
local logoArea=mkF(sidebar,UDim2.new(1,0,0,60),nil,T.Side)
local logoL=mkL(logoArea,"ELITE HUB",UDim2.new(1,-4,0,20),UDim2.new(0,2,0,8),T.Text,Enum.Font.GothamBold,Enum.TextXAlignment.Center) logoL.TextSize=13
local uline=mkF(logoArea,UDim2.new(0,42,0,2),UDim2.new(0.5,-21,0,32),T.Accent) cr(uline,2)
local subL=mkL(logoArea,"by Marcus",UDim2.new(1,-4,0,12),UDim2.new(0,2,0,38),T.TextD,Enum.Font.Gotham,Enum.TextXAlignment.Center) subL.TextSize=10

local tabScroll=Instance.new("ScrollingFrame")
tabScroll.Size=UDim2.new(1,0,1,-62) tabScroll.Position=UDim2.new(0,0,0,62)
tabScroll.BackgroundTransparency=1 tabScroll.BorderSizePixel=0 tabScroll.ScrollBarThickness=0
tabScroll.CanvasSize=UDim2.new(0,0,0,0) tabScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y tabScroll.Parent=sidebar
local tLL=Instance.new("UIListLayout") tLL.Padding=UDim.new(0,2) tLL.Parent=tabScroll
local tPP=Instance.new("UIPadding") tPP.PaddingTop=UDim.new(0,4) tPP.PaddingLeft=UDim.new(0,4) tPP.PaddingRight=UDim.new(0,4) tPP.Parent=tabScroll

local contentArea=mkF(win,UDim2.new(1,-142,1,-8),UDim2.new(0,4,0,4),T.BG2) cr(contentArea,10)

-- Tab system
local tabs={} local activeTab=nil
local function createTab(name)
    local page=Instance.new("ScrollingFrame")
    page.Size=UDim2.new(1,-6,1,-6) page.Position=UDim2.new(0,3,0,3)
    page.BackgroundTransparency=1 page.BorderSizePixel=0
    page.ScrollBarThickness=3 page.ScrollBarImageColor3=T.Accent
    page.CanvasSize=UDim2.new(0,0,0,0) page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    page.Visible=false page.Parent=contentArea
    local pL=Instance.new("UIListLayout") pL.Padding=UDim.new(0,4) pL.Parent=page
    local pP=Instance.new("UIPadding")
    pP.PaddingTop=UDim.new(0,5) pP.PaddingLeft=UDim.new(0,3) pP.PaddingRight=UDim.new(0,4) pP.PaddingBottom=UDim.new(0,5) pP.Parent=page

    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1,0,0,29) btn.BackgroundColor3=T.Side btn.BackgroundTransparency=1
    btn.BorderSizePixel=0 btn.Text="" btn.AutoButtonColor=false btn.Parent=tabScroll cr(btn,6)
    local ind=mkF(btn,UDim2.new(0,3,0,13),UDim2.new(0,0,0.5,-6.5),T.Accent) cr(ind,3) ind.Visible=false
    local bL=mkL(btn,name,UDim2.new(1,-10,1,0),UDim2.new(0,8,0,0),T.TextD,Enum.Font.GothamMedium) bL.TextSize=11

    local function activate()
        if activeTab==name then return end
        if activeTab and tabs[activeTab] then
            tabs[activeTab].page.Visible=false
            tw(tabs[activeTab].btn,{BackgroundTransparency=1},0.12)
            tw(tabs[activeTab].label,{TextColor3=T.TextD},0.12)
            tabs[activeTab].ind.Visible=false
        end
        activeTab=name page.Visible=true ind.Visible=true
        tw(btn,{BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(24,14,44)},0.12)
        tw(bL,{TextColor3=T.Text},0.12)
    end
    btn.MouseButton1Click:Connect(activate)
    btn.MouseEnter:Connect(function() if activeTab~=name then tw(btn,{BackgroundTransparency=0.7},0.1) end end)
    btn.MouseLeave:Connect(function() if activeTab~=name then tw(btn,{BackgroundTransparency=1},0.1) end end)
    tabs[name]={page=page,btn=btn,label=bL,ind=ind,activate=activate}
    if not activeTab then activate() end

    local Tab={} local order=0 local function no() order=order+1 return order end

    function Tab:Section(title)
        local w=mkF(page,UDim2.new(1,0,0,21),nil,Color3.new(0,0,0)) w.BackgroundTransparency=1 w.LayoutOrder=no()
        mkF(w,UDim2.new(1,-6,0,1),UDim2.new(0,3,0.5,0),T.Border)
        local sl=mkL(w,"  "..title.."  ",UDim2.new(0,0,1,0),UDim2.new(0,6,0,0),T.Accent,Enum.Font.GothamBold)
        sl.TextSize=10 sl.AutomaticSize=Enum.AutomaticSize.X sl.BackgroundColor3=T.BG2 sl.BackgroundTransparency=0
    end

    function Tab:Button(title,desc,cb)
        local h=desc~="" and 44 or 31
        local w=mkF(page,UDim2.new(1,0,0,h),nil,T.BG3) w.LayoutOrder=no() cr(w,7) sk(w,T.Border)
        local ab=mkF(w,UDim2.new(0,3,0,h-9),UDim2.new(0,0,0,4.5),T.Accent) cr(ab,3) ab.ZIndex=2
        local tl=mkL(w,title,UDim2.new(1,-32,0,15),UDim2.new(0,8,0,desc~="" and 5 or 8),T.Text,Enum.Font.GothamMedium) tl.TextSize=12 tl.ZIndex=2
        if desc~="" then local dl=mkL(w,desc,UDim2.new(1,-32,0,12),UDim2.new(0,8,0,21),T.TextD,Enum.Font.Gotham) dl.TextSize=10 dl.ZIndex=2 end
        local cb2=mkB(w,UDim2.new(1,0,1,0)) cb2.ZIndex=6
        cb2.MouseEnter:Connect(function() tw(w,{BackgroundColor3=T.Hover},0.1) end)
        cb2.MouseLeave:Connect(function() tw(w,{BackgroundColor3=T.BG3},0.1) end)
        cb2.MouseButton1Click:Connect(function()
            tw(w,{BackgroundColor3=Color3.fromRGB(42,16,88)},0.06) task.wait(0.07) tw(w,{BackgroundColor3=T.Hover},0.1) pcall(cb)
        end)
    end

    function Tab:Toggle(title,default,cb)
        local state=default or false
        local w=mkF(page,UDim2.new(1,0,0,32),nil,T.BG3) w.LayoutOrder=no() cr(w,7) sk(w,T.Border)
        local ab=mkF(w,UDim2.new(0,3,0,17),UDim2.new(0,0,0,7.5),state and T.ON or T.OFF) cr(ab,3) ab.ZIndex=2
        local tl=mkL(w,title,UDim2.new(1,-54,1,0),UDim2.new(0,8,0,0),T.Text,Enum.Font.GothamMedium) tl.TextSize=11 tl.ZIndex=2
        local pBG=mkF(w,UDim2.new(0,32,0,15),UDim2.new(1,-40,0.5,-7.5),state and T.ON or T.OFF) cr(pBG,10) pBG.ZIndex=3
        local pill=mkF(pBG,UDim2.new(0,10,0,10),UDim2.new(0,state and 19 or 3,0.5,-5),Color3.new(1,1,1)) cr(pill,6) pill.ZIndex=4
        local function set(v)
            state=v tw(pBG,{BackgroundColor3=v and T.ON or T.OFF},0.17)
            tw(pill,{Position=UDim2.new(0,v and 19 or 3,0.5,-5)},0.17,Enum.EasingStyle.Back)
            tw(ab,{BackgroundColor3=v and T.ON or T.OFF},0.17) pcall(cb,v)
        end
        local cb2=mkB(w,UDim2.new(1,0,1,0)) cb2.ZIndex=6
        cb2.MouseEnter:Connect(function() tw(w,{BackgroundColor3=T.Hover},0.1) end)
        cb2.MouseLeave:Connect(function() tw(w,{BackgroundColor3=T.BG3},0.1) end)
        cb2.MouseButton1Click:Connect(function() set(not state) end)
        return {SetValue=function(_,v) set(v) end,GetValue=function() return state end}
    end

    function Tab:Dropdown(title,options,cb)
        local selected=options[1] or "" local open=false
        local w=mkF(page,UDim2.new(1,0,0,39),nil,T.BG3) w.LayoutOrder=no() w.ClipsDescendants=false cr(w,7) sk(w,T.Border)
        local ab=mkF(w,UDim2.new(0,3,0,23),UDim2.new(0,0,0,8),T.Accent) cr(ab,3) ab.ZIndex=2
        local tl=mkL(w,title,UDim2.new(0.6,0,0,13),UDim2.new(0,8,0,4),T.TextD,Enum.Font.Gotham) tl.TextSize=10 tl.ZIndex=2
        local sBtn=Instance.new("TextButton")
        sBtn.Size=UDim2.new(1,-14,0,17) sBtn.Position=UDim2.new(0,7,0,19)
        sBtn.BackgroundColor3=T.BG sBtn.BorderSizePixel=0 sBtn.Text="" sBtn.AutoButtonColor=false sBtn.ZIndex=3 sBtn.Parent=w
        cr(sBtn,5) sk(sBtn,T.Border)
        local sL=mkL(sBtn,selected,UDim2.new(1,-18,1,0),UDim2.new(0,5,0,0),T.Text,Enum.Font.Gotham) sL.TextSize=10 sL.ZIndex=4
        local chev=mkL(sBtn,"▾",UDim2.new(0,14,1,0),UDim2.new(1,-15,0,0),T.Accent,Enum.Font.GothamBold,Enum.TextXAlignment.Center) chev.TextSize=10 chev.ZIndex=4
        local panel=mkF(gui,UDim2.new(0,0,0,0),nil,T.BG2) panel.Visible=false panel.ZIndex=30 panel.ClipsDescendants=true cr(panel,7) sk(panel,T.Accent)
        local panL=Instance.new("UIListLayout") panL.Parent=panel
        local function closeP()
            open=false tw(chev,{Rotation=0},0.12)
            tw(panel,{Size=UDim2.new(0,panel.AbsoluteSize.X,0,0)},0.14) task.wait(0.16) panel.Visible=false
        end
        local function buildItems()
            for _,c in ipairs(panel:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            for _,opt in ipairs(options) do
                local item=Instance.new("TextButton")
                item.Size=UDim2.new(1,0,0,22) item.BackgroundColor3=opt==selected and Color3.fromRGB(24,10,50) or T.BG2
                item.BorderSizePixel=0 item.Text="" item.AutoButtonColor=false item.ZIndex=31 item.Parent=panel
                local il=mkL(item,opt,UDim2.new(1,-6,1,0),UDim2.new(0,5,0,0),opt==selected and T.AccentL or T.Text,Enum.Font.Gotham)
                il.TextSize=10 il.ZIndex=32
                item.MouseButton1Click:Connect(function() selected=opt sL.Text=opt closeP() buildItems() pcall(cb,opt) end)
            end
        end
        buildItems()
        sBtn.MouseButton1Click:Connect(function()
            open=not open
            if open then
                panel.Visible=true
                local abs=sBtn.AbsolutePosition local pw=w.AbsoluteSize.X-14
                panel.Size=UDim2.new(0,pw,0,0) panel.Position=UDim2.new(0,abs.X,0,abs.Y+21)
                tw(chev,{Rotation=180},0.12) tw(panel,{Size=UDim2.new(0,pw,0,math.min(#options*22,110))},0.17,Enum.EasingStyle.Back)
            else closeP() end
        end)
        return {SetValue=function(_,v) selected=v sL.Text=v buildItems() end,GetValue=function() return selected end}
    end

    function Tab:Slider(title,min,max,default,cb)
        local value=default or min
        local w=mkF(page,UDim2.new(1,0,0,48),nil,T.BG3) w.LayoutOrder=no() cr(w,7) sk(w,T.Border)
        mkF(w,UDim2.new(0,3,0,32),UDim2.new(0,0,0,8),T.Accent)
        local tl=mkL(w,title,UDim2.new(1,-58,0,14),UDim2.new(0,8,0,6),T.Text,Enum.Font.GothamMedium) tl.TextSize=11
        local vL=mkL(w,tostring(value),UDim2.new(0,42,0,14),UDim2.new(1,-46,0,6),T.AccentL,Enum.Font.GothamBold,Enum.TextXAlignment.Right) vL.TextSize=11
        local track=mkF(w,UDim2.new(1,-18,0,5),UDim2.new(0,9,0,30),T.OFF) cr(track,4)
        local fill=mkF(track,UDim2.new((value-min)/(max-min),0,1,0),nil,T.Accent) cr(fill,4)
        local knob=mkF(fill,UDim2.new(0,10,0,10),UDim2.new(1,-5,0.5,-5),Color3.new(1,1,1)) cr(knob,6)
        local ds=false
        local function upd(x)
            local pct=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            value=math.round(min+(max-min)*pct) vL.Text=tostring(value)
            tw(fill,{Size=UDim2.new(pct,0,1,0)},0.04) pcall(cb,value)
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ds=true upd(i.Position.X) end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if ds and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ds=false end
        end)
    end

    return Tab
end

-- ================================================
-- BUILD TABS
-- ================================================
local infoTab=createTab("Info")
infoTab:Section("Elite Hub")
infoTab:Button("Copy Discord","discord.gg/Pq2dsdfHhE",function()
    pcall(setclipboard,"https://discord.gg/Pq2dsdfHhE")
    Notify("Elite Hub","Discord copied!",3)
end)
infoTab:Button("Credits","Script by Marcus",function() Notify("Credits","Elite Hub — by Marcus",4) end)
infoTab:Section("Status")
infoTab:Button("Sea "..Sea.." Detected","PlaceId: "..PlaceId,function() end)

local farmTab=createTab("Farm")
farmTab:Section("Auto Farm")
local seaMobNames={"Nearest Mob"}
for _,m in ipairs(MobData[Sea] or {}) do table.insert(seaMobNames,m.Name.." (Lv "..m.Level..")") end
farmTab:Dropdown("Select Mob",seaMobNames,function(v)
    State.FarmMob=v=="Nearest Mob" and "" or (v:match("^(.+) %(Lv") or "")
end)
farmTab:Toggle("Auto Farm",false,function(v)
    State.AutoFarm=v
    if v then startFarmLoop() Notify("Elite Hub","Auto Farm ON",3)
    else Notify("Elite Hub","Auto Farm OFF",3) end
end)
farmTab:Toggle("Auto Quest",false,function(v) State.AutoQuest=v end)
farmTab:Toggle("Use Skills (Z X C V F)",true,function(v) State.UseSkills=v end)
farmTab:Toggle("Auto Eat (low HP)",true,function(v) State.AutoEat=v end)
farmTab:Slider("Eat below HP%",0,100,30,function(v) State.HealthPct=v end)

local statsTab=createTab("Stats")
statsTab:Section("Auto Stats")
statsTab:Dropdown("Stat Type",{"Melee","Defense","Sword","Gun","Blox Fruit"},function(v) State.StatChoice=v end)
statsTab:Toggle("Auto Stats",false,function(v) State.AutoStats=v if v then startStatsLoop() end end)

local tpTab=createTab("Teleport")
tpTab:Section("Sea "..Sea.." Islands")
for _,tp in ipairs(TeleportData[Sea] or TeleportData[1]) do
    local cf=tp.CF
    tpTab:Button(tp.Name,"",function()
        tpTo(cf,3)
        Notify("Teleport","Going to "..tp.Name,3)
    end)
end

local fruitTab=createTab("Fruit")
fruitTab:Section("Fruit Sniper")
fruitTab:Toggle("Fruit Sniper",false,function(v)
    State.FruitSniper=v
    if v then startFruitLoop() Notify("Elite Hub","Fruit Sniper ON",3)
    else Notify("Elite Hub","Fruit Sniper OFF",3) end
end)
fruitTab:Button("Scan Now","TP to nearest fruit on map",function()
    local found=false
    for _,container in ipairs({WS,WS:FindFirstChild("Fruits"),WS:FindFirstChild("droppedFruits")}) do
        if not container then continue end
        for _,obj in ipairs(container:GetChildren()) do
            if obj:IsA("Model") and obj.Name:lower():find("fruit") then
                local h=obj:FindFirstChild("Handle") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if h then
                    tpTo(h.CFrame+Vector3.new(0,3,0),3)
                    Notify("Fruit","Teleporting to "..obj.Name,4)
                    found=true break
                end
            end
        end
        if found then break end
    end
    if not found then Notify("Fruit Sniper","No fruits found",3) end
end)

local espTab=createTab("ESP")
espTab:Section("Player ESP")
espTab:Toggle("Player ESP",false,function(v) State.ESP=v refreshESP() Notify("ESP",v and "ON" or "OFF",3) end)
espTab:Button("Refresh","",function() refreshESP() Notify("ESP","Refreshed",2) end)

local settTab=createTab("Settings")
settTab:Section("Hub")
settTab:Toggle("Floating Animation",true,function(v) State.FloatAnim=v end)
settTab:Dropdown("Accent Color",{"Purple","Blue","Cyan","Green","Red","Pink"},function(v)
    local cols={Purple=Color3.fromRGB(120,60,230),Blue=Color3.fromRGB(50,110,240),Cyan=Color3.fromRGB(30,185,210),
        Green=Color3.fromRGB(40,185,100),Red=Color3.fromRGB(210,50,60),Pink=Color3.fromRGB(215,60,165)}
    if cols[v] then T.Accent=cols[v] T.ON=cols[v] uline.BackgroundColor3=cols[v] end
    Notify("Settings","Accent: "..v,3)
end)
settTab:Button("Close Hub","Destroy the UI",function()
    for _,g in ipairs(CoreGui:GetChildren()) do
        if g.Name=="EliteHub" or g.Name=="EliteNotify" or g.Name=="EliteDiscPop" then g:Destroy() end
    end
    pcall(function() LP.PlayerGui.EliteHub:Destroy() end)
    pcall(function() LP.PlayerGui.EliteNotify:Destroy() end)
end)

-- Minimize (END key)
local minimized=false
UserInputService.InputBegan:Connect(function(i,p)
    if not p and i.KeyCode==Enum.KeyCode.End then
        minimized=not minimized
        contentArea.Visible=not minimized
        tw(win,{Size=minimized and UDim2.fromOffset(140,60) or WIN},0.25,Enum.EasingStyle.Quint)
    end
end)

-- Respawn reconnect
LP.CharacterAdded:Connect(function()
    task.wait(2)
    if State.AutoFarm then startFarmLoop() end
    if State.AutoStats then startStatsLoop() end
    if State.FruitSniper then startFruitLoop() end
    if State.ESP then refreshESP() end
end)

-- ================================================
-- STARTUP
-- ================================================
task.wait(0.5)
showDiscordPrompt()
task.wait(0.3)
Notify("Elite Hub","Loaded! Sea "..Sea.." | by Marcus",5)
