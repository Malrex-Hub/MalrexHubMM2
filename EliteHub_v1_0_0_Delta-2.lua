-- Elite Hub v1.0.0 | Blox Fruits | Delta/Fluxus/Arceus X/Wave
-- discord.gg/EmsMsHZCVH
-- All features from reference script | No key system

repeat task.wait() until game:GetService("Players").LocalPlayer

-- -- CAPABILITY FLAGS --------------------------------------------------
local HAS_DRAW    = typeof(Drawing)             == "table"
local HAS_WF      = typeof(writefile)           == "function"
local HAS_RF      = typeof(readfile)            == "function"
local HAS_FTI     = typeof(firetouchinterest)   == "function"
local HAS_FCD     = typeof(fireclickdetector)   == "function"
local HAS_FPP     = typeof(fireproximityprompt) == "function"
local HAS_NCC     = typeof(newcclosure)         == "function"
local HAS_CLR     = typeof(cloneref)            == "function"
local HAS_SETSCR  = typeof(setscriptable)       == "function"
local HAS_HIDDEN  = typeof(sethiddenproperty)   == "function"
local HAS_GRM     = typeof(getrawmetatable)     == "function"
local HAS_SRO     = typeof(setreadonly)         == "function"
local HAS_SFF     = typeof(setfflag)            == "function"

local EXEC_NAME = "Unknown"
pcall(function()
    if identifyexecutor then EXEC_NAME = identifyexecutor()
    elseif getexecutorname then EXEC_NAME = getexecutorname() end
end)

-- -- SERVICES ----------------------------------------------------------
local function ref(s)  return (HAS_CLR and cloneref or function(x) return x end)(s) end
local function wrap(f) return (HAS_NCC and newcclosure or function(x) return x end)(f) end

local Players  = ref(game:GetService("Players"))
local RS       = ref(game:GetService("RunService"))
local UIS      = ref(game:GetService("UserInputService"))
local TS       = ref(game:GetService("TweenService"))
local VU       = ref(game:GetService("VirtualUser"))
local Lighting = ref(game:GetService("Lighting"))
local RepStor  = ref(game:GetService("ReplicatedStorage"))
local TeleS    = ref(game:GetService("TeleportService"))
local LP       = Players.LocalPlayer
local Mouse    = LP:GetMouse()
local PG       = LP:WaitForChild("PlayerGui", 10)
local Camera   = workspace.CurrentCamera
local USER_ID  = LP.UserId
local AVATAR   = "rbxthumb://type=AvatarHeadShot&id="..USER_ID.."&w=150&h=150"

print("[Elite Hub] discord.gg/EmsMsHZCVH | v1.0.0")
pcall(function() if setclipboard then setclipboard("https://discord.gg/EmsMsHZCVH") end end)

-- -- SAFE REQUIRE -----------------------------------------------------
local _tbl
_tbl = function(t)
    return setmetatable(t or {},{
        __index = function() return _tbl() end,
        __call  = function() return _tbl() end
    })
end
local _require = require
local require = function(...)
    local ok, r = pcall(_require, ...)
    return ok and r or _tbl()
end

-- -- COMBATFRAMEWORK HOOKS ---------------------------------------------
pcall(function()
    getgenv().A = require(RepStor.CombatFramework.RigLib).wrapAttackAnimationAsync
end)
pcall(function()
    getgenv().B = require(LP.PlayerScripts.CombatFramework.Particle).play
end)

-- -- ANTI-BAN HOOK -----------------------------------------------------
_G.AntiKick = true
pcall(function()
    if HAS_GRM and HAS_SRO and HAS_NCC then
        local grm = getrawmetatable(game)
        setreadonly(grm, false)
        local old = grm.__namecall
        grm.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local a1 = tostring(args[1])
            if _G.AntiKick then
                if a1=="TeleportDetect" or a1=="CHECKER_1" or a1=="CHECKER" or
                   a1=="GUI_CHECK" or a1=="OneMoreTime" or a1=="checkingSPEED" or
                   a1=="BANREMOTE" or a1=="PERMAIDBAN" or a1=="KICKREMOTE" or
                   a1=="BR_KICKPC" or a1=="BR_KICKMOBILE" then
                    return
                end
            end
            return old(self, ...)
        end)
    end
end)

-- -- SETFFLAG (disable abuse screenshots) -----------------------------
_G.setfflag = true
task.spawn(function()
    while task.wait(1) do
        if _G.setfflag and HAS_SFF then
            pcall(function()
                setfflag("AbuseReportScreenshot","False")
                setfflag("AbuseReportScreenshotPercentage","0")
            end)
        end
    end
end)

-- -- SAFE FARM (destroy anti-cheat scripts) ----------------------------
_G.SafeFarm = true
task.spawn(function()
    while task.wait(1) do
        if _G.SafeFarm then
            pcall(function()
                for _,v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        if v.Name=="General" or v.Name=="Shiftlock" or v.Name=="FallDamage"
                        or v.Name=="4444" or v.Name=="CamBob" or v.Name=="JumpCD"
                        or v.Name=="Looking" or v.Name=="Run" then
                            v:Destroy()
                        end
                    end
                end
                for _,v in pairs(LP.PlayerScripts:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        if v.Name=="RobloxMotor6DBugFix" or v.Name=="Clans" or v.Name=="Codes"
                        or v.Name=="CustomForceField" or v.Name=="MenuBloodSp"
                        or v.Name=="PlayerList" then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

-- -- REMOVE DEATH / RESPAWN EFFECTS -----------------------------------
pcall(function()
    local ec = RepStor:FindFirstChild("Effect")
    if ec and ec:FindFirstChild("Container") then
        for _, n in ipairs({"Death","Respawn"}) do
            local c = ec.Container:FindFirstChild(n)
            if c then c:Destroy() end
        end
    end
end)

-- -- WORLD DETECTION ---------------------------------------------------
local World1, World2, World3
local PlaceId = game.PlaceId
if PlaceId == 2753915549 then World1 = true
elseif PlaceId == 4442272183 then World2 = true
elseif PlaceId == 7449423635 then World3 = true
end

-- -- CONFIG ------------------------------------------------------------
local CFG = "EliteHub_v1_config.json"

local function cfgDefault() return {
    SelectWeapon="Melee", BringMode=100, BypassTP=false,
    AutoFarm=false, AutoFarmNearest=false, Farmfast=false,
    BringMonster=true, InvisibleMon=false,
    AutoDoughtBoss=false, CakeFMode="No Quest", Kill_At=50,
    Auto_Bone=false, BoneFMode="No Quest",
    AutoFarmFruitMastery=false, AutoFarmGunMastery=false, AutoSwordMastery=false,
    AutoFarmBoss=false, SelectBoss="Gorilla King",
    AutoAllBoss=false,
    AutoFactory=false, RaidPirate=false,
    Namfon=false, AutoDarkDagger=false,
    AutoDarkDagger_Hop=false, AutodoughkingHop=false,
    AutoArenaTrainerHop=false, Autogay=false,
    AutoRengoku=false, AutoMusketeerHat=false,
    Auto_Rainbow_Haki=false, AutoBartilo=false,
    Auto_EvoRace=false, Auto_Cursed_Dual_Katana=false,
    AutoDeathStep=false, AutoSharkman=false, AutoElectricClaw=false,
    Auto_God_Human=false,
    Open_Color_Haki=false, AutoEctoplasm=false,
    ESPPlayer=false, ESPMob=false, ESPSeaBeast=false,
    ESPChest=false, ESPFruit=false,
    FlyEnabled=false, FlySpeed=60,
    InfEnergy=false, NoDodgeCooldown=false,
    WalkWater=false, FastAttack=false,
    AutoHakiEnabled=true, AutoRespawn=true,
    AntiAFK=true, AntiKick=true,
    UseSkillZ=false, UseSkillX=false, UseSkillC=false, UseSkillV=false,
    AutoStatEnabled=false, StatPriority="Melee",
    AutoSpawnPoint=false, ServerHop=false,
    BlackScreen=false, WhiteScreen=false,
    FruitNotify=true, FruitNotifyRange=500,
    AccentPreset="Cyan", ToggleKey="RightShift",
    SavedPosX=0, SavedPosY=0, SavedPosZ=0,
} end

local function encodeJSON(d)
    local t = {}
    for k,v in pairs(d) do
        local s
        if type(v)=="boolean" then s=tostring(v)
        elseif type(v)=="number" then s=tostring(v)
        else s='"'..tostring(v):gsub('\\','\\\\'):gsub('"','\\"')..'"' end
        t[#t+1] = '"'..k..'":'..s
    end
    return "{"..table.concat(t,",").."}"
end

local function decodeJSON(raw, def)
    local d = {}
    for k,v in pairs(def) do d[k]=v end
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

local cfg = cfgDefault()
pcall(function()
    if HAS_RF then
        local raw = readfile(CFG)
        if raw and #raw > 2 then
            cfg = decodeJSON(raw, cfgDefault())
        end
    end
end)

local function saveConfig()
    pcall(function()
        if HAS_WF then writefile(CFG, encodeJSON(cfg)) end
    end)
end

-- -- GLOBAL STATE -----------------------------------------------------
_G.AutoFarm         = cfg.AutoFarm
_G.AutoFarmNearest  = cfg.AutoFarmNearest
_G.Farmfast         = cfg.Farmfast
_G.BringMonster     = cfg.BringMonster
_G.BringMode        = cfg.BringMode or 100
_G.AutoDoughtBoss   = cfg.AutoDoughtBoss
_G.Auto_Bone        = cfg.Auto_Bone
_G.AutoFarmFruitMastery = cfg.AutoFarmFruitMastery
_G.AutoFarmGunMastery   = cfg.AutoFarmGunMastery
_G.AutoSwordMastery     = cfg.AutoSwordMastery
_G.AutoFarmBoss     = cfg.AutoFarmBoss
_G.AutoAllBoss      = cfg.AutoAllBoss
_G.SelectBoss       = cfg.SelectBoss or "Gorilla King"
_G.SelectWeapon     = cfg.SelectWeapon or "Melee"
_G.Kill_At          = cfg.Kill_At or 50
_G.AntiKick         = cfg.AntiKick
_G.AutoHakiEnabled  = cfg.AutoHakiEnabled
_G.StopTween        = false

local BypassTP       = cfg.BypassTP
local Mon            = "Bandit"
local NameMon        = "Bandit"
local NameQuest      = "BanditQuest1"
local LevelQuest     = 1
local CFrameQuest    = CFrame.new(0,0,0)
local CFrameMon      = CFrame.new(0,0,0)
local MyLevel        = 1
local Pos            = CFrame.new(0, 2, -2)
local PosMon         = CFrame.new(0,0,0)
local StartMagnet    = false
local StartMagnetBoneMon = false
local StartMasteryFruitMagnet = false
local StartMasteryGunMagnet   = false
local AutoSwordMasteryMag     = false
local MagnetDought   = false
local CakeFMode      = cfg.CakeFMode or "No Quest"
local BoneFMode      = cfg.BoneFMode or "No Quest"
local PosMonBone     = CFrame.new(0,0,0)
local PosMonMasteryFruit = CFrame.new(0,0,0)
local PosMonMasteryGun   = CFrame.new(0,0,0)
local ESPPlayer      = cfg.ESPPlayer
local ESPMob         = cfg.ESPMob
local ESPChest       = cfg.ESPChest
local ESPFruit       = cfg.ESPFruit
local ESPSeaBeast    = cfg.ESPSeaBeast
local Fastattack     = cfg.FastAttack
local BoneQuestPos   = CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
local CakeQuestPos   = CFrame.new(-709.3132934570312,381.6005859375,-11011.396484375)
local Ms             = ""
local OldCFrameBartlio = CFrame.new(0,0,0)
local OldCFrameElephant = CFrame.new(0,0,0)
local OldCFrameRainbow  = CFrame.new(0,0,0)
local OldCFrameShark    = CFrame.new(0,0,0)
local PosMonBarto    = CFrame.new(0,0,0)
local AutoBartiloBring = false
local PosMonDoughtOpenDoor = CFrame.new(0,0,0)
local StartRengokuMagnet   = false
local RengokuMon           = CFrame.new(0,0,0)
local MusketeerHatMon      = CFrame.new(0,0,0)
local StartMagnetMusketeerhat = false
local EctoplasmMon         = CFrame.new(0,0,0)
local StartEctoplasmMagnet = false
local FastMon              = CFrame.new(0,0,0)
local StardMag             = false
local Sword                = _G.SelectWeapon
local Auto_Cursed_Dual_Katana = false
local Auto_Quest_Yama_1    = false
local Auto_Quest_Yama_2    = false
local Auto_Quest_Yama_3    = false
local Auto_Quest_Tushita_1 = false
local Auto_Quest_Tushita_2 = false
local Auto_Quest_Tushita_3 = false
local UseSkill             = false
local InMyNetWorkFn

-- -- UTILITY FUNCTIONS -------------------------------------------------
local function GetChar()
    return LP.Character
end

local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function topos(cf)
    pcall(function()
        local hrp = GetHRP()
        if hrp then hrp.CFrame = cf end
    end)
end

local function TP1(cf)
    topos(cf)
end

local function BTP(cf)
    pcall(function()
        local hrp = GetHRP()
        if not hrp then return end
        local dist = (hrp.Position - cf.Position).Magnitude
        if dist > 1500 then
            local steps = math.ceil(dist/1400)
            for i = 1, steps do
                hrp.CFrame = hrp.CFrame:Lerp(cf, i/steps)
                task.wait(0.05)
            end
        else
            hrp.CFrame = cf
        end
    end)
end

local function EquipWeapon(name)
    pcall(function()
        if not name or name == "" then return end
        local bp = LP.Backpack:FindFirstChild(name)
        if bp then
            LP.Character.Humanoid:EquipTool(bp)
        end
    end)
end

local function UnEquipWeapon(name)
    pcall(function()
        if not name or name == "" then return end
        local tool = LP.Character and LP.Character:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            LP.Humanoid:UnequipTools()
        end
    end)
end

local function AutoHaki()
    pcall(function()
        if _G.AutoHakiEnabled then
            RepStor.Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

local function Click()
    pcall(function()
        VU:CaptureController()
        VU:Button1Down(Vector2.new(1280,672))
    end)
end

local function StopTween(v)
    if not v then
        _G.StopTween = true
        task.wait(0.1)
        _G.StopTween = false
    end
end

InMyNetWorkFn = function(part)
    local ok = pcall(function()
        if typeof(isnetworkowner) == "function" then
            return isnetworkowner(part)
        end
    end)
    return ok
end

local function round(n) return math.floor(n + 0.5) end

local function GetMaterial(name)
    local data = LP:FindFirstChild("Data")
    if data then
        local mat = data:FindFirstChild(name)
        if mat then return mat.Value end
    end
    return 0
end

-- -- SERVER HOP --------------------------------------------------------
local function Hop()
    pcall(function()
        local PID = game.PlaceId
        local ok, data = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..PID.."/servers/Public?sortOrder=Desc&limit=100")
        end)
        if ok then
            local decoded = game:GetService("HttpService"):JSONDecode(data)
            if decoded and decoded.data then
                for _,v in pairs(decoded.data) do
                    if tonumber(v.maxPlayers) > tonumber(v.playing) and v.id ~= game.JobId then
                        TeleS:TeleportToPlaceInstance(PID, v.id, LP)
                        return
                    end
                end
            end
        end
        TeleS:Teleport(PID, LP)
    end)
end

local function hop() Hop() end

-- -- SIMULATION RADIUS LOOP --------------------------------------------
task.spawn(function()
    while true do
        task.wait()
        pcall(function()
            if HAS_SETSCR then setscriptable(LP,"SimulationRadius",true) end
            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
        end)
    end
end)

-- -- CHECK QUEST (full CFrame data, all 3 seas) ------------------------
local function CheckQuest()
    pcall(function()
        MyLevel = LP.Data.Level.Value
        if World1 then
            if MyLevel <= 9 then
                Mon="Bandit" LevelQuest=1 NameQuest="BanditQuest1" NameMon="Bandit"
                CFrameQuest=CFrame.new(1059.37195,15.4495068,1550.4231,0.939700544,-0,-0.341998369,0,1,-0,0.341998369,0,0.939700544)
                CFrameMon=CFrame.new(1045.962646,27.002508,1560.820312)
            elseif MyLevel <= 14 then
                Mon="Monkey" LevelQuest=1 NameQuest="JungleQuest" NameMon="Monkey"
                CFrameQuest=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,-0,-1,0,0)
                CFrameMon=CFrame.new(-1448.518066,67.853012,11.465796)
            elseif MyLevel <= 29 then
                Mon="Gorilla" LevelQuest=2 NameQuest="JungleQuest" NameMon="Gorilla"
                CFrameQuest=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,-0,-1,0,0)
                CFrameMon=CFrame.new(-1129.883667,40.463547,-525.423706)
            elseif MyLevel <= 39 then
                Mon="Pirate" LevelQuest=1 NameQuest="BuggyQuest1" NameMon="Pirate"
                CFrameQuest=CFrame.new(-1141.07483,4.10001802,3831.5498,0.965929627,-0,-0.258804798,0,1,-0,0.258804798,0,0.965929627)
                CFrameMon=CFrame.new(-1103.513427,13.752052,3896.091064)
            elseif MyLevel <= 59 then
                Mon="Brute" LevelQuest=2 NameQuest="BuggyQuest1" NameMon="Brute"
                CFrameQuest=CFrame.new(-1141.07483,4.10001802,3831.5498,0.965929627,-0,-0.258804798,0,1,-0,0.258804798,0,0.965929627)
                CFrameMon=CFrame.new(-1140.083740,14.809885,4322.921386)
            elseif MyLevel <= 74 then
                Mon="Desert Bandit" LevelQuest=1 NameQuest="DesertQuest" NameMon="Desert Bandit"
                CFrameQuest=CFrame.new(894.488647,5.14000702,4392.43359,0.819155693,-0,-0.573571265,0,1,-0,0.573571265,0,0.819155693)
                CFrameMon=CFrame.new(924.799804,6.448674,4481.585937)
            elseif MyLevel <= 89 then
                Mon="Desert Officer" LevelQuest=2 NameQuest="DesertQuest" NameMon="Desert Officer"
                CFrameQuest=CFrame.new(894.488647,5.14000702,4392.43359,0.819155693,-0,-0.573571265,0,1,-0,0.573571265,0,0.819155693)
                CFrameMon=CFrame.new(1608.282226,8.614224,4371.007324)
            elseif MyLevel <= 99 then
                Mon="Snow Bandit" LevelQuest=1 NameQuest="SnowQuest" NameMon="Snow Bandit"
                CFrameQuest=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,0.939684391,0,1,0,-0.939684391,0,-0.342042685)
                CFrameMon=CFrame.new(1354.347900,87.272773,-1393.946533)
            elseif MyLevel <= 119 then
                Mon="Snowman" LevelQuest=2 NameQuest="SnowQuest" NameMon="Snowman"
                CFrameQuest=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,0.939684391,0,1,0,-0.939684391,0,-0.342042685)
                CFrameMon=CFrame.new(1201.641235,144.579589,-1550.067016)
            elseif MyLevel <= 149 then
                Mon="Chief Petty Officer" LevelQuest=1 NameQuest="MarineQuest2" NameMon="Chief Petty Officer"
                CFrameQuest=CFrame.new(-5039.58643,27.3500385,4324.68018,0,0,-1,0,1,0,1,0,0)
                CFrameMon=CFrame.new(-4881.230957,22.652044,4273.752441)
            elseif MyLevel <= 174 then
                Mon="Sky Bandit" LevelQuest=1 NameQuest="SkyQuest" NameMon="Sky Bandit"
                CFrameQuest=CFrame.new(-4839.53027,716.368591,-2619.44165,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)
                CFrameMon=CFrame.new(-4953.207031,295.744201,-2899.229003)
            elseif MyLevel <= 189 then
                Mon="Dark Master" LevelQuest=2 NameQuest="SkyQuest" NameMon="Dark Master"
                CFrameQuest=CFrame.new(-4839.53027,716.368591,-2619.44165,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)
                CFrameMon=CFrame.new(-5259.844726,391.397674,-2229.035400)
            elseif MyLevel <= 209 then
                Mon="Prisoner" LevelQuest=1 NameQuest="PrisonerQuest" NameMon="Prisoner"
                CFrameQuest=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,0.995993316,-2.06384709e-09,-0.0894274712)
                CFrameMon=CFrame.new(5098.973632,-0.320405,474.237335)
            elseif MyLevel <= 249 then
                Mon="Dangerous Prisoner" LevelQuest=2 NameQuest="PrisonerQuest" NameMon="Dangerous Prisoner"
                CFrameQuest=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,0.995993316,-2.06384709e-09,-0.0894274712)
                CFrameMon=CFrame.new(5654.563476,15.633401,866.299194)
            elseif MyLevel <= 274 then
                Mon="Toga Warrior" LevelQuest=1 NameQuest="ColosseumQuest" NameMon="Toga Warrior"
                CFrameQuest=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,0.857167721,0,-0.515037298)
                CFrameMon=CFrame.new(-1820.214843,51.683856,-2740.665039)
            elseif MyLevel <= 299 then
                Mon="Gladiator" LevelQuest=2 NameQuest="ColosseumQuest" NameMon="Gladiator"
                CFrameQuest=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,0.857167721,0,-0.515037298)
                CFrameMon=CFrame.new(-1292.838134,56.380882,-3339.031494)
            elseif MyLevel <= 324 then
                Mon="Military Soldier" LevelQuest=1 NameQuest="MagmaQuest" NameMon="Military Soldier"
                CFrameQuest=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,0.866048813,0,1,0,-0.866048813,0,-0.499959469)
                CFrameMon=CFrame.new(-5411.164550,11.081554,8454.292968)
            elseif MyLevel <= 374 then
                Mon="Military Spy" LevelQuest=2 NameQuest="MagmaQuest" NameMon="Military Spy"
                CFrameQuest=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,0.866048813,0,1,0,-0.866048813,0,-0.499959469)
                CFrameMon=CFrame.new(-5802.868164,86.262413,8828.859375)
            elseif MyLevel <= 399 then
                Mon="Fishman Warrior" LevelQuest=1 NameQuest="FishmanQuest" NameMon="Fishman Warrior"
                CFrameQuest=CFrame.new(61122.65234375,18.497442,1569.3997802734)
                CFrameMon=CFrame.new(60878.300781,18.482830,1543.757446)
                if _G.AutoFarm and (CFrameQuest.Position - GetHRP().Position).Magnitude > 10000 then
                    pcall(function() RepStor.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
                end
            elseif MyLevel <= 449 then
                Mon="Fishman Raider" LevelQuest=2 NameQuest="FishmanQuest" NameMon="Fishman Raider"
                CFrameQuest=CFrame.new(61122.65234375,18.497442,1569.3997802734)
                CFrameMon=CFrame.new(61000.210937,17.978466,1449.506713)
                if _G.AutoFarm and (CFrameQuest.Position - GetHRP().Position).Magnitude > 10000 then
                    pcall(function() RepStor.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
                end
            elseif MyLevel <= 474 then
                Mon="Undead Pirate" LevelQuest=1 NameQuest="ZombieQuest" NameMon="Undead Pirate"
                CFrameQuest=CFrame.new(-5071.27783,2.14999557,-3131.86182,0.694670916,0,0.71934664,0,1,0,-0.71934664,0,0.694670916)
                CFrameMon=CFrame.new(-5079.720214,3.800252,-3200.618164)
            elseif MyLevel <= 524 then
                Mon="Zombie" LevelQuest=2 NameQuest="ZombieQuest" NameMon="Zombie"
                CFrameQuest=CFrame.new(-5071.27783,2.14999557,-3131.86182,0.694670916,0,0.71934664,0,1,0,-0.71934664,0,0.694670916)
                CFrameMon=CFrame.new(-5685.923339,48.480125,-853.237243)
            elseif MyLevel <= 549 then
                Mon="Galley Pirate" LevelQuest=1 NameQuest="GalleyQuest" NameMon="Galley Pirate"
                CFrameQuest=CFrame.new(-3438.81372,2.07350254,1551.21265,-0.731332898,0,0.682017028,0,1,0,-0.682017028,0,-0.731332898)
                CFrameMon=CFrame.new(-3457.282226,2.655472,1636.217285)
            elseif MyLevel <= 624 then
                Mon="Galley Captain" LevelQuest=2 NameQuest="GalleyQuest" NameMon="Galley Captain"
                CFrameQuest=CFrame.new(-3438.81372,2.07350254,1551.21265,-0.731332898,0,0.682017028,0,1,0,-0.682017028,0,-0.731332898)
                CFrameMon=CFrame.new(-3476.044189,2.814064,1742.256103)
            elseif MyLevel <= 699 then
                Mon="Marine Recruit" LevelQuest=1 NameQuest="MarineQuest3" NameMon="Marine Recruit"
                CFrameQuest=CFrame.new(438.741394,74.3400116,578.720093,-0.438370198,0,0.898756504,0,1,0,-0.898756504,0,-0.438370198)
                CFrameMon=CFrame.new(413.376464,74.612396,596.393249)
            elseif MyLevel <= 774 then
                Mon="Marine Sergeant" LevelQuest=2 NameQuest="MarineQuest3" NameMon="Marine Sergeant"
                CFrameQuest=CFrame.new(438.741394,74.3400116,578.720093,-0.438370198,0,0.898756504,0,1,0,-0.898756504,0,-0.438370198)
                CFrameMon=CFrame.new(461.484680,76.049995,561.700195)
            elseif MyLevel <= 849 then
                Mon="Swan Pirate" LevelQuest=1 NameQuest="BearQuest" NameMon="Swan Pirate"
                CFrameQuest=CFrame.new(932.624451,156.106079,1180.27466,-0.973085582,4.55137119e-08,-0.230443969,2.67024713e-08,1,8.47491108e-08,0.230443969,7.63147128e-08,-0.973085582)
                CFrameMon=CFrame.new(920.063476,158.212188,1121.406127)
            elseif MyLevel <= 924 then
                Mon="Pirate Officer" LevelQuest=2 NameQuest="BearQuest" NameMon="Pirate Officer"
                CFrameQuest=CFrame.new(932.624451,156.106079,1180.27466,-0.973085582,4.55137119e-08,-0.230443969,2.67024713e-08,1,8.47491108e-08,0.230443969,7.63147128e-08,-0.973085582)
                CFrameMon=CFrame.new(1003.073913,157.380706,1088.044677)
            elseif MyLevel <= 999 then
                Mon="Raider" LevelQuest=1 NameQuest="RaiderQuest" NameMon="Raider"
                CFrameQuest=CFrame.new(-2509.91699,2.04999256,-3205.21948,0.374606609,0,0.927183628,0,1,0,-0.927183628,0,0.374606609)
                CFrameMon=CFrame.new(-2550.421875,5.050495,-3318.543701)
            elseif MyLevel <= 1049 then
                Mon="Mercenary" LevelQuest=2 NameQuest="RaiderQuest" NameMon="Mercenary"
                CFrameQuest=CFrame.new(-2509.91699,2.04999256,-3205.21948,0.374606609,0,0.927183628,0,1,0,-0.927183628,0,0.374606609)
                CFrameMon=CFrame.new(-2439.468750,3.050000,-3413.890625)
            elseif MyLevel <= 1099 then
                Mon="Ship Engineer" LevelQuest=1 NameQuest="LaboratoryQuest" NameMon="Ship Engineer"
                CFrameQuest=CFrame.new(-738.143005,9.46000957,3994.67188,0.707106829,-1.81499623e-10,-0.70710665,-1.81499623e-10,1,2.56368258e-10,0.70710665,2.56368258e-10,0.707106829)
                CFrameMon=CFrame.new(-778.802490,9.050000,4002.302978)
            elseif MyLevel <= 1174 then
                Mon="Horned Warrior" LevelQuest=2 NameQuest="LaboratoryQuest" NameMon="Horned Warrior"
                CFrameQuest=CFrame.new(-738.143005,9.46000957,3994.67188,0.707106829,-1.81499623e-10,-0.70710665,-1.81499623e-10,1,2.56368258e-10,0.70710665,2.56368258e-10,0.707106829)
                CFrameMon=CFrame.new(-743.082458,12.050000,4012.985107)
            elseif MyLevel <= 1249 then
                Mon="Jungle Pirate" LevelQuest=1 NameQuest="JunglePirateQuest" NameMon="Jungle Pirate"
                CFrameQuest=CFrame.new(-1861.95312,9.14001083,-484.547607,-0.999390841,0,0.0349317193,0,1,0,-0.0349317193,0,-0.999390841)
                CFrameMon=CFrame.new(-1941.174072,7.050000,-486.042297)
            elseif MyLevel <= 1324 then
                Mon="Diablo" LevelQuest=2 NameQuest="JunglePirateQuest" NameMon="Diablo"
                CFrameQuest=CFrame.new(-1861.95312,9.14001083,-484.547607,-0.999390841,0,0.0349317193,0,1,0,-0.0349317193,0,-0.999390841)
                CFrameMon=CFrame.new(-1927.765502,8.050000,-478.697265)
            elseif MyLevel <= 1399 then
                Mon="Spinosaurus" LevelQuest=1 NameQuest="DresstroQuest" NameMon="Spinosaurus"
                CFrameQuest=CFrame.new(-4823.18164,7.12000132,3267.94629,0.62932533,0,0.777145624,0,1,0,-0.777145624,0,0.62932533)
                CFrameMon=CFrame.new(-4886.978027,4.050000,3290.067138)
            elseif MyLevel <= 1474 then
                Mon="Dragon Crew Warrior" LevelQuest=2 NameQuest="DresstroQuest" NameMon="Dragon Crew Warrior"
                CFrameQuest=CFrame.new(-4823.18164,7.12000132,3267.94629,0.62932533,0,0.777145624,0,1,0,-0.777145624,0,0.62932533)
                CFrameMon=CFrame.new(-4948.697265,4.050000,3367.614013)
            elseif MyLevel <= 1524 then
                Mon="Dragon Crew Archer" LevelQuest=1 NameQuest="DresstroQuest2" NameMon="Dragon Crew Archer"
                CFrameQuest=CFrame.new(-4823.18164,7.12000132,3267.94629,0.62932533,0,0.777145624,0,1,0,-0.777145624,0,0.62932533)
                CFrameMon=CFrame.new(-5023.988769,4.050000,3329.228515)
            elseif MyLevel <= 1574 then
                Mon="Ship Deckhand" LevelQuest=2 NameQuest="DresstroQuest2" NameMon="Ship Deckhand"
                CFrameQuest=CFrame.new(-4823.18164,7.12000132,3267.94629,0.62932533,0,0.777145624,0,1,0,-0.777145624,0,0.62932533)
                CFrameMon=CFrame.new(-5014.083984,4.050000,3262.895996)
            elseif MyLevel <= 1624 then
                Mon="Brontosaurus" LevelQuest=1 NameQuest="DresstroQuest3" NameMon="Brontosaurus"
                CFrameQuest=CFrame.new(-4823.18164,7.12000132,3267.94629,0.62932533,0,0.777145624,0,1,0,-0.777145624,0,0.62932533)
                CFrameMon=CFrame.new(-4796.455566,4.050000,3164.614013)
            elseif MyLevel <= 1699 then
                Mon="Laboratory Researcher" LevelQuest=2 NameQuest="DresstroQuest3" NameMon="Laboratory Researcher"
                CFrameQuest=CFrame.new(-4823.18164,7.12000132,3267.94629,0.62932533,0,0.777145624,0,1,0,-0.777145624,0,0.62932533)
                CFrameMon=CFrame.new(-4737.052734,4.050000,3192.281494)
            end

        elseif World2 then
            if MyLevel <= 749 then
                Mon="Magma Ninja" LevelQuest=1 NameQuest="FloatingIslandQuest" NameMon="Magma Ninja"
                CFrameQuest=CFrame.new(-2006.31226,60.3500023,928.714905,-0.258812189,0,-0.965922773,0,1,0,0.965922773,0,-0.258812189)
                CFrameMon=CFrame.new(-2064.875976,59.050000,965.394531)
            elseif MyLevel <= 824 then
                Mon="Thunder God" LevelQuest=2 NameQuest="FloatingIslandQuest" NameMon="Thunder God"
                CFrameQuest=CFrame.new(-2006.31226,60.3500023,928.714905,-0.258812189,0,-0.965922773,0,1,0,0.965922773,0,-0.258812189)
                CFrameMon=CFrame.new(-2056.199218,59.050000,893.826416)
            elseif MyLevel <= 924 then
                Mon="Fishman Pirate" LevelQuest=1 NameQuest="FishmanIslandQuest" NameMon="Fishman Pirate"
                CFrameQuest=CFrame.new(60882.765625,18.4974422,1577.3997802)
                CFrameMon=CFrame.new(60878.300781,18.482830,1543.757446)
                if _G.AutoFarm and (CFrameQuest.Position - GetHRP().Position).Magnitude > 10000 then
                    pcall(function() RepStor.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
                end
            end

        elseif World3 then
            if MyLevel <= 1524 then
                Mon="Demonic Soul" LevelQuest=1 NameQuest="HauntedQuest1" NameMon="Demonic Soul"
                CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
                CFrameMon=CFrame.new(-9507.234375,172.130615,6107.077148)
            elseif MyLevel <= 1574 then
                Mon="Posessed Mummy" LevelQuest=2 NameQuest="HauntedQuest1" NameMon="Posessed Mummy"
                CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
                CFrameMon=CFrame.new(-9540.234375,172.130615,6050.077148)
            elseif MyLevel <= 1674 then
                Mon="Ice Cream Chef" LevelQuest=1 NameQuest="IceCreamQuest" NameMon="Ice Cream Chef"
                CFrameQuest=CFrame.new(-709.3132934,381.600585,-11011.396484)
                CFrameMon=CFrame.new(-702.0,381.6,-11030.0)
            elseif MyLevel <= 1774 then
                Mon="Ice Cream Commander" LevelQuest=2 NameQuest="IceCreamQuest" NameMon="Ice Cream Commander"
                CFrameQuest=CFrame.new(-709.3132934,381.600585,-11011.396484)
                CFrameMon=CFrame.new(-740.0,381.6,-11020.0)
            elseif MyLevel <= 1874 then
                Mon="Cookie Crafter" LevelQuest=1 NameQuest="CakeQuest1" NameMon="Cookie Crafter"
                CFrameQuest=CFrame.new(-709.3132934,381.600585,-11011.396484)
                CFrameMon=CFrame.new(-730.0,381.6,-11040.0)
            elseif MyLevel <= 1974 then
                Mon="Cake Guard" LevelQuest=2 NameQuest="CakeQuest1" NameMon="Cake Guard"
                CFrameQuest=CFrame.new(-709.3132934,381.600585,-11011.396484)
                CFrameMon=CFrame.new(-720.0,381.6,-11050.0)
            elseif MyLevel <= 2074 then
                Mon="Baking Staff" LevelQuest=1 NameQuest="CakeQuest2" NameMon="Baking Staff"
                CFrameQuest=CFrame.new(-709.3132934,381.600585,-11011.396484)
                CFrameMon=CFrame.new(-700.0,381.6,-11060.0)
            elseif MyLevel <= 2174 then
                Mon="Head Baker" LevelQuest=2 NameQuest="CakeQuest2" NameMon="Head Baker"
                CFrameQuest=CFrame.new(-709.3132934,381.600585,-11011.396484)
                CFrameMon=CFrame.new(-710.0,381.6,-11070.0)
            elseif MyLevel <= 2274 then
                Mon="Reborn Skeleton" LevelQuest=1 NameQuest="HauntedQuest2" NameMon="Reborn Skeleton"
                CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
                CFrameMon=CFrame.new(-9506.234375,172.130615,6117.077148)
            elseif MyLevel <= 2374 then
                Mon="Living Zombie" LevelQuest=2 NameQuest="HauntedQuest2" NameMon="Living Zombie"
                CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
                CFrameMon=CFrame.new(-9520.234375,172.130615,6090.077148)
            else
                Mon="Cursed Skeleton" LevelQuest=1 NameQuest="HauntedQuest3" NameMon="Cursed Skeleton"
                CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
                CFrameMon=CFrame.new(-9500.234375,172.130615,6100.077148)
            end
        end
    end)
end

-- -- BRING MONSTER / MAGNET LOOP ---------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if not _G.BringMonster then return end
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local hrp = v.HumanoidRootPart
                    local inRange = (hrp.Position - GetHRP().Position).Magnitude <= _G.BringMode
                    if _G.AutoFarm and StartMagnet and v.Name == Mon and inRange then
                        hrp.Size = Vector3.new(50,50,50)
                        hrp.CFrame = PosMon
                        hrp.CanCollide = false
                        v.Humanoid:ChangeState(14)
                        if v.Head then v.Head.CanCollide = false end
                        if v.Humanoid:FindFirstChild("Animator") then v.Humanoid.Animator:Destroy() end
                        if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                    end
                    if _G.Auto_Bone and StartMagnetBoneMon and inRange and
                    (v.Name=="Reborn Skeleton" or v.Name=="Living Zombie" or v.Name=="Demonic Soul" or v.Name=="Posessed Mummy") then
                        hrp.Size = Vector3.new(50,50,50)
                        hrp.CFrame = PosMonBone
                        hrp.CanCollide = false
                        v.Humanoid:ChangeState(14)
                    end
                    if _G.AutoFarmFruitMastery and StartMasteryFruitMagnet and inRange then
                        hrp.Size = Vector3.new(50,50,50)
                        hrp.CFrame = PosMonMasteryFruit
                        hrp.CanCollide = false
                        v.Humanoid:ChangeState(14)
                    end
                    if _G.AutoFarmGunMastery and StartMasteryGunMagnet and inRange then
                        hrp.Size = Vector3.new(50,50,50)
                        hrp.CFrame = PosMonMasteryGun
                        hrp.CanCollide = false
                        v.Humanoid:ChangeState(14)
                    end
                    if _G.AutoSwordMastery and AutoSwordMasteryMag and inRange then
                        hrp.CFrame = PosMon
                        hrp.Size = Vector3.new(60,60,60)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                        v.Humanoid.JumpPower = 0
                        v.Humanoid.WalkSpeed = 0
                        v.Humanoid:ChangeState(14)
                    end
                    if _G.AutoDoughtBoss and MagnetDought and inRange and
                    (v.Name=="Cookie Crafter" or v.Name=="Cake Guard" or v.Name=="Baking Staff" or v.Name=="Head Baker") then
                        hrp.Size = Vector3.new(50,50,50)
                        hrp.CFrame = PosMonDoughtOpenDoor
                        hrp.CanCollide = false
                        v.Humanoid:ChangeState(14)
                    end
                end
            end
        end)
    end
end)

-- -- INVISIBLE MONSTER -------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.InvisibleMon then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        for _,p in pairs(v:GetDescendants()) do
                            if p:IsA("BasePart") then p.Transparency = 1 end
                        end
                    end
                end
            end
        end)
    end
end)

-- -- AUTO RESPAWN ------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if cfg.AutoRespawn then
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then
                    task.wait(1)
                    if LP.Character:FindFirstChildOfClass("Humanoid") then
                        LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
                    end
                end
            end
        end)
    end
end)

-- -- ANTI-AFK ---------------------------------------------------------
task.spawn(function()
    while task.wait(20) do
        if cfg.AntiAFK then
            VU:CaptureController()
            VU:ClickButton2(Vector2.new(0,0))
        end
    end
end)

-- -- AUTO HAKI BACKGROUND ---------------------------------------------
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            if _G.AutoHakiEnabled then
                RepStor.Remotes.CommF_:InvokeServer("Buso")
            end
        end)
    end
end)

-- -- INFINITE ENERGY ---------------------------------------------------
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if cfg.InfEnergy then
                RepStor.Remotes.CommF_:InvokeServer("UpdateStamina",99999)
            end
        end)
    end
end)

-- -- NO DODGE COOLDOWN -------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.NoDodgeCooldown and LP.Character then
                for _,v in pairs(LP.Character:GetDescendants()) do
                    if (v.Name=="DodgeCooldown") and v:IsA("NumberValue") then
                        v.Value = 0
                    end
                end
            end
        end)
    end
end)

-- -- WALK WATER --------------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.WalkWater then
                for _,v in pairs(workspace:GetDescendants()) do
                    if (v.Name=="Ocean" or v.Name=="Water" or v.Name=="Sea") and v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end)
    end
end)

-- -- FLY ---------------------------------------------------------------
local FlyBV, FlyBG

local function startFly()
    pcall(function()
        local hrp = GetHRP()
        if not hrp then return end
        FlyBV = Instance.new("BodyVelocity",hrp)
        FlyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        FlyBV.Velocity = Vector3.new(0,0,0)
        FlyBG = Instance.new("BodyGyro",hrp)
        FlyBG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
        FlyBG.D = 100
    end)
end

local function stopFly()
    pcall(function()
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
    end)
end

task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.FlyEnabled then
                if not FlyBV or not FlyBV.Parent then startFly() end
                if FlyBV and FlyBV.Parent then
                    local spd = cfg.FlySpeed or 60
                    local cf = Camera.CFrame
                    local dir = Vector3.new(0,0,0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
                    FlyBV.Velocity = dir.Magnitude > 0 and (dir.Unit * spd) or Vector3.new(0,0,0)
                    if FlyBG then FlyBG.CFrame = cf end
                end
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false) end
            else
                if FlyBV then stopFly() end
            end
        end)
    end
end)

-- -- AUTO SKILL USE ----------------------------------------------------
task.spawn(function()
    local VIM = game:GetService("VirtualInputManager")
    while task.wait(0.1) do
        pcall(function()
            if cfg.UseSkillZ or UseSkill then
                VIM:SendKeyEvent(true,Enum.KeyCode.Z,false,game)
                task.wait(0.05)
                VIM:SendKeyEvent(false,Enum.KeyCode.Z,false,game)
            end
            if cfg.UseSkillX then
                VIM:SendKeyEvent(true,Enum.KeyCode.X,false,game)
                task.wait(0.05)
                VIM:SendKeyEvent(false,Enum.KeyCode.X,false,game)
            end
            if cfg.UseSkillC then
                VIM:SendKeyEvent(true,Enum.KeyCode.C,false,game)
                task.wait(0.05)
                VIM:SendKeyEvent(false,Enum.KeyCode.C,false,game)
            end
            if cfg.UseSkillV then
                VIM:SendKeyEvent(true,Enum.KeyCode.V,false,game)
                task.wait(0.05)
                VIM:SendKeyEvent(false,Enum.KeyCode.V,false,game)
            end
        end)
    end
end)

-- -- AUTO STAT ---------------------------------------------------------
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if cfg.AutoStatEnabled then
                local statMap = {
                    Melee="AddMelee", Defense="AddDefense",
                    Sword="AddSword", Gun="AddGun", Fruit="AddBlox"
                }
                local remoteName = statMap[cfg.StatPriority or "Melee"] or "AddMelee"
                local pts = LP.Data and LP.Data:FindFirstChild("StatPoints")
                if pts and pts.Value > 0 then
                    RepStor.Remotes.CommF_:InvokeServer(remoteName, pts.Value)
                end
            end
        end)
    end
end)

-- -- AUTO SPAWN POINT -------------------------------------------------
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if cfg.AutoSpawnPoint then
                RepStor.Remotes.CommF_:InvokeServer("SetSpawnPoint")
            end
        end)
    end
end)

-- -- ESP SYSTEM --------------------------------------------------------
local espTag = "EliteHubESP"

local function makeEspLabel(parent, color)
    local bg = Instance.new("BillboardGui")
    bg.Name = espTag
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0,200,0,50)
    bg.StudsOffset = Vector3.new(0,3,0)
    bg.MaxDistance = 5000
    local lbl = Instance.new("TextLabel",bg)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextStrokeTransparency = 0
    lbl.TextColor3 = color or Color3.fromRGB(255,255,255)
    lbl.TextScaled = true
    lbl.Text = ""
    bg.Parent = parent
    return lbl
end

local function getDistance(pos)
    local hrp = GetHRP()
    if not hrp then return 0 end
    return math.floor((hrp.Position - pos).Magnitude)
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        local existing = head:FindFirstChild(espTag)
                        if ESPPlayer then
                            if not existing then
                                makeEspLabel(head, Color3.fromRGB(255,50,50))
                                existing = head:FindFirstChild(espTag)
                            end
                            if existing then
                                local lbl = existing:FindFirstChildOfClass("TextLabel")
                                if lbl then
                                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                                    local hp = hum and round(hum.Health) or 0
                                    lbl.Text = plr.Name.."\n"..getDistance(head.Position).."m | "..hp.."HP"
                                end
                            end
                        else
                            if existing then existing:Destroy() end
                        end
                    end
                end
            end
        end)
        pcall(function()
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") then
                    local part = v.HumanoidRootPart
                    local existing = part:FindFirstChild(espTag)
                    if ESPMob then
                        if not existing then
                            makeEspLabel(part,Color3.fromRGB(255,100,100))
                            existing = part:FindFirstChild(espTag)
                        end
                        if existing then
                            local lbl = existing:FindFirstChildOfClass("TextLabel")
                            if lbl then
                                local hum = v:FindFirstChildOfClass("Humanoid")
                                lbl.Text = v.Name.."\n"..getDistance(part.Position).."m"..(hum and " | "..round(hum.Health).."HP" or "")
                            end
                        end
                    else
                        if existing then existing:Destroy() end
                    end
                end
            end
        end)
        pcall(function()
            for _,v in pairs(workspace:GetDescendants()) do
                if ESPFruit and v.Name=="Fruit" and v:IsA("Model") then
                    local h = v:FindFirstChildOfClass("BasePart")
                    if h and not h:FindFirstChild(espTag) then
                        local lbl = makeEspLabel(h,Color3.fromRGB(255,220,0))
                        if lbl then lbl.Text = (v:GetAttribute("Type") or "Fruit").."\n"..getDistance(h.Position).."m" end
                    end
                end
                if ESPChest and (v.Name=="Chest" or v.Name=="Luxury Chest") then
                    local h = v:IsA("BasePart") and v or v:FindFirstChildOfClass("BasePart")
                    if h and not h:FindFirstChild(espTag) then
                        local lbl = makeEspLabel(h,Color3.fromRGB(255,215,0))
                        if lbl then lbl.Text = v.Name.."\n"..getDistance(h.Position).."m" end
                    end
                end
                if ESPSeaBeast and (string.find(v.Name,"Sea Beast") or string.find(v.Name,"Sea Dragon")) then
                    if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                        local part = v.HumanoidRootPart
                        if not part:FindFirstChild(espTag) then
                            local lbl = makeEspLabel(part,Color3.fromRGB(0,150,255))
                            if lbl then lbl.Text = v.Name.."\n"..getDistance(part.Position).."m" end
                        end
                    end
                end
            end
        end)
    end
end)

-- -- FRUIT NOTIFICATION ------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if cfg.FruitNotify then
                for _,v in pairs(workspace:GetDescendants()) do
                    if v.Name=="Fruit" and v:IsA("Model") then
                        local h = v:FindFirstChildOfClass("BasePart")
                        if h then
                            local dist = getDistance(h.Position)
                            if dist <= (cfg.FruitNotifyRange or 500) then
                                game:GetService("StarterGui"):SetCore("SendNotification",{
                                    Title="Fruit Nearby!",
                                    Text=(v:GetAttribute("Type") or "Devil Fruit").." | "..dist.."m away",
                                    Duration=3
                                })
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- -- BLACK/WHITE SCREEN LOOP -------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            local blk = LP.PlayerGui:FindFirstChild("EliteBlackScreen")
            local wht = LP.PlayerGui:FindFirstChild("EliteWhiteScreen")
            if cfg.BlackScreen then
                if not blk then
                    local sg = Instance.new("ScreenGui",LP.PlayerGui)
                    sg.Name = "EliteBlackScreen" sg.ResetOnSpawn = false
                    local fr = Instance.new("Frame",sg)
                    fr.Size = UDim2.new(1,0,1,0)
                    fr.BackgroundColor3 = Color3.fromRGB(0,0,0)
                    fr.BorderSizePixel = 0 fr.ZIndex = 999
                end
            else if blk then blk:Destroy() end end
            if cfg.WhiteScreen then
                if not wht then
                    local sg = Instance.new("ScreenGui",LP.PlayerGui)
                    sg.Name = "EliteWhiteScreen" sg.ResetOnSpawn = false
                    local fr = Instance.new("Frame",sg)
                    fr.Size = UDim2.new(1,0,1,0)
                    fr.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    fr.BorderSizePixel = 0 fr.ZIndex = 999
                end
            else if wht then wht:Destroy() end end
        end)
    end
end)

-- ---------------------------------------------------------------------
-- -- AUTO FARM: QUEST MODE ---------------------------------------------
-- ---------------------------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm and not _G.AutoFarmNearest and not _G.Farmfast then
                CheckQuest()
                local questGui = LP.PlayerGui:FindFirstChild("Main")
                local qVisible = questGui and questGui.Quest and questGui.Quest.Visible
                if qVisible then
                    local qt = questGui.Quest.Container.QuestTitle.Title.Text
                    if string.find(qt,NameMon) or string.find(qt,Mon) then
                        local found = false
                        for _,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name==Mon and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                found = true
                                StartMagnet = true
                                PosMon = v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    topos(v.HumanoidRootPart.CFrame * Pos)
                                    PosMon = v.HumanoidRootPart.CFrame
                                    if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                                    Click()
                                until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or not questGui.Quest.Visible
                                StartMagnet = false
                                break
                            end
                        end
                        if not found then
                            StartMagnet = false
                            if BypassTP then
                                if (GetHRP().Position-CFrameMon.Position).Magnitude > 1500 then BTP(CFrameMon) else topos(CFrameMon) end
                            else topos(CFrameMon) end
                        end
                    else
                        StartMagnet = false
                        RepStor.Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                else
                    StartMagnet = false
                    if BypassTP then
                        if (GetHRP().Position-CFrameQuest.Position).Magnitude > 1500 then BTP(CFrameQuest) else topos(CFrameQuest) end
                    else topos(CFrameQuest) end
                    if (CFrameQuest.Position-GetHRP().Position).Magnitude <= 5 then
                        RepStor.Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                    end
                end
            end
        end)
    end
end)

-- -- AUTO FARM: NEAREST ------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarmNearest then
                local closest,closestDist = nil,math.huge
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position-GetHRP().Position).Magnitude
                        if d < closestDist then closest=v closestDist=d end
                    end
                end
                if closest then
                    repeat
                        task.wait()
                        AutoHaki()
                        EquipWeapon(_G.SelectWeapon)
                        closest.HumanoidRootPart.CanCollide = false
                        closest.Humanoid.WalkSpeed = 0
                        closest.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        topos(closest.HumanoidRootPart.CFrame * Pos)
                        if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                        Click()
                    until not _G.AutoFarmNearest or closest.Humanoid.Health <= 0 or not closest.Parent
                end
            end
        end)
    end
end)

-- -- AUTO FARM: FAST (Shanda/Zombie) ----------------------------------
local FastMagPos = CFrame.new(-5685.9233398438,48.480125427246,-853.23724365234)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.Farmfast then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.Name=="Shanda" or v.Name=="Zombie") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        StardMag = true
                        FastMon = v.HumanoidRootPart.CFrame
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            FastMon = v.HumanoidRootPart.CFrame
                            Click()
                        until not _G.Farmfast or v.Humanoid.Health <= 0 or not v.Parent
                        StardMag = false
                        break
                    end
                end
                if not workspace.Enemies:FindFirstChild("Shanda") and not workspace.Enemies:FindFirstChild("Zombie") then
                    StardMag = false
                    if BypassTP then
                        if (GetHRP().Position-FastMagPos.Position).Magnitude > 1500 then BTP(FastMagPos) else topos(FastMagPos) end
                    else topos(FastMagPos) end
                end
            end
        end)
    end
end)

-- -- FRUIT / GUN / SWORD MASTERY ---------------------------------------
local MasteryPos = CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,-0,-1,0,0)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarmFruitMastery then
                local found = false
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        found = true
                        StartMasteryFruitMagnet = true
                        PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                        repeat
                            task.wait()
                            AutoHaki()
                            local fruit = LP.Data and LP.Data.DevilFruit and LP.Data.DevilFruit.Value or _G.SelectWeapon
                            EquipWeapon(fruit)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not _G.AutoFarmFruitMastery or v.Humanoid.Health <= 0 or not v.Parent
                        StartMasteryFruitMagnet = false
                        break
                    end
                end
                if not found then
                    StartMasteryFruitMagnet = false
                    if BypassTP then
                        if (GetHRP().Position-MasteryPos.Position).Magnitude > 1500 then BTP(MasteryPos) else topos(MasteryPos) end
                    else topos(MasteryPos) end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarmGunMastery then
                local found = false
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        found = true
                        StartMasteryGunMagnet = true
                        PosMonMasteryGun = v.HumanoidRootPart.CFrame
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            PosMonMasteryGun = v.HumanoidRootPart.CFrame
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not _G.AutoFarmGunMastery or v.Humanoid.Health <= 0 or not v.Parent
                        StartMasteryGunMagnet = false
                        break
                    end
                end
                if not found then
                    StartMasteryGunMagnet = false
                    if BypassTP then
                        if (GetHRP().Position-MasteryPos.Position).Magnitude > 1500 then BTP(MasteryPos) else topos(MasteryPos) end
                    else topos(MasteryPos) end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoSwordMastery then
                local found = false
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if not string.find(v.Name,"Boss") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0
                    and (v.HumanoidRootPart.Position-GetHRP().Position).Magnitude <= _G.BringMode then
                        found = true
                        AutoSwordMasteryMag = true
                        PosMon = v.HumanoidRootPart.CFrame
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(Sword or _G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            PosMon = v.HumanoidRootPart.CFrame
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not _G.AutoSwordMastery or v.Humanoid.Health <= 0 or not v.Parent
                        AutoSwordMasteryMag = false
                        break
                    end
                end
                if not found then
                    AutoSwordMasteryMag = false
                    if BypassTP then
                        if (GetHRP().Position-MasteryPos.Position).Magnitude > 1500 then BTP(MasteryPos) else topos(MasteryPos) end
                    else topos(MasteryPos) end
                end
            end
        end)
    end
end)

-- -- BOSS FARMS --------------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarmBoss then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if string.find(v.Name,_G.SelectBoss) and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not _G.AutoFarmBoss or v.Humanoid.Health <= 0 or not v.Parent
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoAllBoss then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if (string.find(v.Name,"Boss") or string.find(v.Name,"Admiral") or string.find(v.Name,"King"))
                    and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not _G.AutoAllBoss or v.Humanoid.Health <= 0 or not v.Parent
                    end
                end
            end
        end)
    end
end)

-- -- CAKE PRINCE FARM --------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoDoughtBoss and World3 then
                local cakeMobs = {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}
                local found = false
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    local isCake = false
                    for _,n in pairs(cakeMobs) do if v.Name==n then isCake=true end end
                    if (isCake or string.find(v.Name,"Cake Prince") or string.find(v.Name,"Dough King"))
                    and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        found = true
                        MagnetDought = true
                        PosMonDoughtOpenDoor = v.HumanoidRootPart.CFrame
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            PosMonDoughtOpenDoor = v.HumanoidRootPart.CFrame
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not _G.AutoDoughtBoss or v.Humanoid.Health <= 0 or not v.Parent
                        MagnetDought = false
                        break
                    end
                end
                if not found then
                    MagnetDought = false
                    if CakeFMode == "Quest" then
                        local questGui = LP.PlayerGui:FindFirstChild("Main")
                        if questGui and not questGui.Quest.Visible then
                            if BypassTP then
                                if (GetHRP().Position-CakeQuestPos.Position).Magnitude > 1500 then BTP(CakeQuestPos) else topos(CakeQuestPos) end
                            else topos(CakeQuestPos) end
                            if (CakeQuestPos.Position-GetHRP().Position).Magnitude <= 5 then
                                RepStor.Remotes.CommF_:InvokeServer("StartQuest","CakeQuest1",1)
                            end
                        end
                    else
                        local mob = RepStor:FindFirstChild("Cookie Crafter")
                        if mob and mob:FindFirstChild("HumanoidRootPart") then
                            topos(mob.HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if BypassTP then
                                if (GetHRP().Position-CakeQuestPos.Position).Magnitude > 1500 then BTP(CakeQuestPos) else topos(CakeQuestPos) end
                            else topos(CakeQuestPos) end
                        end
                    end
                end
            end
        end)
    end
end)

-- -- BONE FARM ---------------------------------------------------------
local BonePos = CFrame.new(-9506.234375,172.130615234375,6117.0771484375)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.Auto_Bone and World3 then
                local boneMobs = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}
                local found = false
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    local isBone = false
                    for _,n in pairs(boneMobs) do if v.Name==n then isBone=true end end
                    if isBone and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        found = true
                        StartMagnetBoneMon = true
                        PosMonBone = v.HumanoidRootPart.CFrame
                        if BoneFMode ~= "Quest" or (function()
                            local qg = LP.PlayerGui:FindFirstChild("Main")
                            return qg and qg.Quest and qg.Quest.Visible and string.find(qg.Quest.Container.QuestTitle.Title.Text,"Demonic Soul")
                        end)() then
                            repeat
                                task.wait()
                                AutoHaki() EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                PosMonBone = v.HumanoidRootPart.CFrame
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                Click()
                            until not _G.Auto_Bone or v.Humanoid.Health <= 0 or not v.Parent
                        end
                        StartMagnetBoneMon = false
                        break
                    end
                end
                if not found then
                    StartMagnetBoneMon = false
                    if BoneFMode == "Quest" then
                        local questGui = LP.PlayerGui:FindFirstChild("Main")
                        if questGui and not questGui.Quest.Visible then
                            if BypassTP then
                                if (GetHRP().Position-BoneQuestPos.Position).Magnitude > 1500 then BTP(BoneQuestPos) else topos(BoneQuestPos) end
                            else topos(BoneQuestPos) end
                            if (BoneQuestPos.Position-GetHRP().Position).Magnitude <= 5 then
                                RepStor.Remotes.CommF_:InvokeServer("StartQuest","HauntedQuest2",1)
                            end
                        elseif questGui and questGui.Quest.Visible then
                            local qt = questGui.Quest.Container.QuestTitle.Title.Text
                            if not string.find(qt,"Demonic Soul") then
                                RepStor.Remotes.CommF_:InvokeServer("AbandonQuest")
                            end
                            local mob = RepStor:FindFirstChild("Demonic Soul [Lv. 2025]")
                            if mob and mob:FindFirstChild("HumanoidRootPart") then
                                topos(mob.HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                            end
                        end
                    else
                        if BypassTP then
                            if (GetHRP().Position-BonePos.Position).Magnitude > 1500 then BTP(BonePos) else topos(BonePos) end
                        else topos(BonePos) end
                        for _,v in pairs(RepStor:GetChildren()) do
                            if (v.Name=="Reborn Skeleton" or v.Name=="Living Zombie" or v.Name=="Demonic Soul" or v.Name=="Posessed Mummy")
                            and v:FindFirstChild("HumanoidRootPart") then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- -- AUTO EVO RACE V2 --------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if cfg.Auto_EvoRace and not LP.Data.Race:FindFirstChild("Evolved") then
                local stage = RepStor.Remotes.CommF_:InvokeServer("Alchemist","1")
                if stage == 0 then
                    topos(CFrame.new(-2779.83521,72.9661407,-3574.02002,-0.730484903,6.39014104e-08,-0.68292886,3.59963224e-08,1,5.50667032e-08,0.68292886,1.56424669e-08,-0.730484903))
                    if (Vector3.new(-2779.83521,72.9661407,-3574.02002)-GetHRP().Position).Magnitude <= 4 then
                        task.wait(1.3)
                        RepStor.Remotes.CommF_:InvokeServer("Alchemist","2")
                    end
                elseif stage == 1 then
                    if not LP.Backpack:FindFirstChild("Flower 1") and not LP.Character:FindFirstChild("Flower 1") then
                        pcall(function() topos(workspace.Flower1.CFrame) end)
                    elseif not LP.Backpack:FindFirstChild("Flower 2") and not LP.Character:FindFirstChild("Flower 2") then
                        pcall(function() topos(workspace.Flower2.CFrame) end)
                    elseif not LP.Backpack:FindFirstChild("Flower 3") and not LP.Character:FindFirstChild("Flower 3") then
                        for _,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name=="Zombie" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki() EquipWeapon(_G.SelectWeapon)
                                    topos(v.HumanoidRootPart.CFrame * Pos)
                                    v.HumanoidRootPart.CanCollide = false
                                    Click()
                                until LP.Backpack:FindFirstChild("Flower 3") or v.Humanoid.Health <= 0 or not v.Parent or not cfg.Auto_EvoRace
                            end
                        end
                    end
                elseif stage == 2 then
                    RepStor.Remotes.CommF_:InvokeServer("Alchemist","3")
                end
            end
        end)
    end
end)

-- -- AUTO BARTILO ------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if cfg.AutoBartilo and LP.Data.Level.Value >= 800 then
                local prog = RepStor.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo")
                if prog == 0 then
                    local questGui = LP.PlayerGui:FindFirstChild("Main")
                    local qt = questGui and questGui.Quest and questGui.Quest.Visible and questGui.Quest.Container.QuestTitle.Title.Text or ""
                    if string.find(qt,"Swan Pirates") then
                        for _,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name=="Swan Pirate" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                                AutoBartiloBring = true
                                PosMonBarto = v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait()
                                    AutoHaki() EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.Transparency = 1
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    topos(v.HumanoidRootPart.CFrame * Pos)
                                    PosMonBarto = v.HumanoidRootPart.CFrame
                                    if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                                    Click()
                                until not v.Parent or v.Humanoid.Health <= 0 or not cfg.AutoBartilo
                                AutoBartiloBring = false
                            end
                        end
                    else
                        repeat topos(CFrame.new(-456.28952,73.0200958,299.895966)) task.wait()
                        until not cfg.AutoBartilo or (GetHRP().Position-Vector3.new(-456.28952,73.0200958,299.895966)).Magnitude <= 10
                        task.wait(1.1)
                        RepStor.Remotes.CommF_:InvokeServer("StartQuest","BartiloQuest",1)
                    end
                elseif prog == 1 then
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name=="Jeremy" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            OldCFrameBartlio = v.HumanoidRootPart.CFrame
                            repeat
                                task.wait()
                                AutoHaki() EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.Transparency = 1
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.HumanoidRootPart.CFrame = OldCFrameBartlio
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                Click()
                            until not v.Parent or v.Humanoid.Health <= 0 or not cfg.AutoBartilo
                        end
                    end
                    if not workspace.Enemies:FindFirstChild("Jeremy") then
                        topos(CFrame.new(2099.88159,448.931,648.997375))
                    end
                end
            end
        end)
    end
end)

-- -- AUTO RAINBOW HAKI -------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if cfg.Auto_Rainbow_Haki then
                local questGui = LP.PlayerGui:FindFirstChild("Main")
                if questGui and questGui.Quest and questGui.Quest.Visible then
                    local qt = questGui.Quest.Container.QuestTitle.Title.Text
                    local bossMap = {
                        Stone = CFrame.new(-1086.11621,38.8425903,6768.71436,0.0231462717,-0.592676699,0.805107772,2.03251839e-05,0.805323839,0.592835128,-0.999732077,-0.0137055516,0.0186523199),
                        ["Island Empress"] = CFrame.new(5713.98877,601.922974,202.751251,-0.101080291,-0,-0.994878292,-0,1,-0,0.994878292,0,-0.101080291),
                        ["Kilo Admiral"] = CFrame.new(2877.61743,423.558685,-7207.31006,-0.989591599,-0,-0.143904909,-0,1.00000012,-0,0.143904924,0,-0.989591479),
                        ["Captain Elephant"] = CFrame.new(-13485.0283,331.709259,-8012.4873,0.714521289,7.98849911e-08,0.69961375,-1.02065748e-07,1,-9.94383065e-09,-0.69961375,-6.43015241e-08,0.714521289),
                        ["Beautiful Pirate"] = CFrame.new(5312.3598632813,20.141201019287,-10.158538818359),
                    }
                    for bossName,bossCF in pairs(bossMap) do
                        if string.find(qt,bossName) then
                            for _,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name==bossName and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                                    OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        Click()
                                    until not cfg.Auto_Rainbow_Haki or v.Humanoid.Health <= 0 or not v.Parent or not questGui.Quest.Visible
                                end
                            end
                            if not workspace.Enemies:FindFirstChild(bossName) then topos(bossCF) end
                        end
                    end
                else
                    topos(CFrame.new(-11892.0703125,930.57672119141,-8760.1591796875))
                    if (Vector3.new(-11892.0703125,930.57672119141,-8760.1591796875)-GetHRP().Position).Magnitude <= 30 then
                        task.wait(1.5)
                        RepStor.Remotes.CommF_:InvokeServer("HornedMan","Bet")
                    end
                end
            end
        end)
    end
end)

-- -- AUTO RENGOKU ------------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoRengoku then
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.Name=="Snow Lurker" or v.Name=="Arctic Warrior") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                        StartRengokuMagnet = true
                        RengokuMon = v.HumanoidRootPart.CFrame
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(1500,1500,1500)
                            v.Humanoid:ChangeState(14)
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            RengokuMon = v.HumanoidRootPart.CFrame
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not cfg.AutoRengoku or v.Humanoid.Health <= 0 or not v.Parent
                        StartRengokuMagnet = false
                    end
                end
            end
        end)
    end
end)

-- -- AUTO MUSKETEER HAT ------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoMusketeerHat and LP.Data.Level.Value >= 1800 then
                local prog = RepStor.Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")
                if prog == 1 then
                    local questGui = LP.PlayerGui:FindFirstChild("Main")
                    if questGui and questGui.Quest and questGui.Quest.Visible then
                        for _,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name=="Forest Pirate" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                                StartMagnetMusketeerhat = true
                                MusketeerHatMon = v.HumanoidRootPart.CFrame
                                OldCFrameElephant = v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait()
                                    AutoHaki() EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    v.HumanoidRootPart.CFrame = OldCFrameElephant
                                    topos(v.HumanoidRootPart.CFrame * Pos)
                                    MusketeerHatMon = v.HumanoidRootPart.CFrame
                                    if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                                    Click()
                                until not cfg.AutoMusketeerHat or v.Humanoid.Health <= 0 or not v.Parent or not questGui.Quest.Visible
                                StartMagnetMusketeerhat = false
                            end
                        end
                    else
                        topos(CFrame.new(-13374.889648438,421.27752685547,-8225.208984375))
                    end
                elseif prog == 2 then
                    topos(CFrame.new(-12512.138671875,340.39279174805,-9872.8203125))
                end
            end
        end)
    end
end)

-- -- AUTO ECTOPLASM ----------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoEctoplasm and World3 then
                local found = false
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if (string.find(v.Name,"Ship") or string.find(v.Name,"Ghost")) and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                        found = true
                        EctoplasmMon = v.HumanoidRootPart.CFrame
                        StartEctoplasmMagnet = true
                        repeat
                            task.wait()
                            AutoHaki() EquipWeapon(_G.SelectWeapon)
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.CFrame = EctoplasmMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            topos(v.HumanoidRootPart.CFrame * Pos)
                            if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                            Click()
                        until not cfg.AutoEctoplasm or v.Humanoid.Health <= 0 or not v.Parent
                        StartEctoplasmMagnet = false
                        break
                    end
                end
                if not found then
                    topos(CFrame.new(-9500.0,172.0,6100.0))
                end
            end
        end)
    end
end)

-- -- AUTO FACTORY ------------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoFactory then
                if workspace.Enemies:FindFirstChild("Core") then
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name=="Core" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki() EquipWeapon(_G.SelectWeapon)
                                topos(CFrame.new(448.46756,199.356781,-441.389252))
                                Click()
                            until v.Humanoid.Health <= 0 or not cfg.AutoFactory
                        end
                    end
                else
                    topos(CFrame.new(448.46756,199.356781,-441.389252))
                end
            end
        end)
    end
end)

-- -- AUTO PIRATE RAID --------------------------------------------------
local RaidBossPos = CFrame.new(-5496.17432,313.768921,-2841.53027,0.924894512,7.37058015e-09,0.380223751,3.5881019e-08,1,-1.06665446e-07,-0.380223751,1.12297109e-07,0.924894512)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.RaidPirate then
                local raidCentre = Vector3.new(-5539.3115234375,313.800537109375,-2972.372314453125)
                if (raidCentre - GetHRP().Position).Magnitude <= 1000 then
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0
                        and (v.HumanoidRootPart.Position-GetHRP().Position).Magnitude < 2000 then
                            repeat
                                task.wait()
                                AutoHaki() EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                Click()
                            until v.Humanoid.Health <= 0 or not v.Parent or not cfg.RaidPirate
                        end
                    end
                else
                    UnEquipWeapon(_G.SelectWeapon)
                    if BypassTP then
                        if (GetHRP().Position-RaidBossPos.Position).Magnitude > 1500 then BTP(RaidBossPos) else topos(RaidBossPos) end
                    else topos(RaidBossPos) end
                end
            end
        end)
    end
end)

-- -- AUTO ARENA TRAINER ------------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.Namfon and World3 then
                local questGui = LP.PlayerGui:FindFirstChild("Main")
                if questGui and questGui.Quest and questGui.Quest.Visible then
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name=="Training Dummy" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki() EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                Click()
                            until not cfg.Namfon or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                else
                    if cfg.AutoArenaTrainerHop then
                        local res = RepStor.Remotes.CommF_:InvokeServer("ArenaTrainer")
                        if type(res)=="string" and string.find(res,"later") then hop() end
                    else
                        RepStor.Remotes.CommF_:InvokeServer("ArenaTrainer")
                    end
                end
            end
        end)
    end
end)

-- -- AUTO KILL RIP_INDRA -----------------------------------------------
local AdminPos2 = CFrame.new(-5344.822265625,423.98541259766,-2725.0930175781)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoDarkDagger then
                local indra = workspace.Enemies:FindFirstChild("rip_indra True Form") or workspace.Enemies:FindFirstChild("rip_indra")
                if indra and indra:FindFirstChildOfClass("Humanoid") and indra.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        AutoHaki() EquipWeapon(_G.SelectWeapon)
                        indra.HumanoidRootPart.CanCollide = false
                        indra.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        topos(indra.HumanoidRootPart.CFrame * Pos)
                        Click()
                    until not cfg.AutoDarkDagger or indra.Humanoid.Health <= 0
                else
                    if BypassTP then
                        if (GetHRP().Position-AdminPos2.Position).Magnitude > 1500 then BTP(AdminPos2) else topos(AdminPos2) end
                    else topos(AdminPos2) end
                    UnEquipWeapon(_G.SelectWeapon)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoDarkDagger_Hop and cfg.AutoDarkDagger and World3
            and not RepStor:FindFirstChild("rip_indra True Form [Lv. 5000] [Raid Boss]")
            and not workspace.Enemies:FindFirstChild("rip_indra True Form") then
                Hop()
            end
        end)
    end
end)

-- -- AUTO GREYBEARD ----------------------------------------------------
local GayMakPos = CFrame.new(-5023.38330078125,28.65203285217285,4332.3818359375)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.Autogay and World1 then
                local gb = workspace.Enemies:FindFirstChild("Greybeard")
                if gb and gb:FindFirstChildOfClass("Humanoid") and gb.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        AutoHaki() EquipWeapon(_G.SelectWeapon)
                        gb.HumanoidRootPart.CanCollide = false
                        gb.Humanoid.WalkSpeed = 0
                        gb.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        topos(gb.HumanoidRootPart.CFrame * Pos)
                        if HAS_HIDDEN then sethiddenproperty(LP,"SimulationRadius",math.huge) end
                        Click()
                    until not cfg.Autogay or not gb.Parent or gb.Humanoid.Health <= 0
                else
                    if BypassTP then
                        if (GetHRP().Position-GayMakPos.Position).Magnitude > 1500 then BTP(GayMakPos) else topos(GayMakPos) end
                    else topos(GayMakPos) end
                end
            end
        end)
    end
end)

-- -- WEAPON UNLOCK FARMS -----------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if cfg.AutoDeathStep then
                if (LP.Backpack:FindFirstChild("Black Leg") and LP.Backpack["Black Leg"].Level.Value >= 450)
                or (LP.Character:FindFirstChild("Black Leg") and LP.Character["Black Leg"].Level.Value >= 450) then
                    RepStor.Remotes.CommF_:InvokeServer("BuyDeathStep")
                    _G.SelectWeapon = "Death Step"
                elseif not LP.Backpack:FindFirstChild("Black Leg") and not LP.Character:FindFirstChild("Black Leg") then
                    RepStor.Remotes.CommF_:InvokeServer("BuyBlackLeg")
                end
            end
            if cfg.AutoElectricClaw then
                if (LP.Backpack:FindFirstChild("Electro") and LP.Backpack["Electro"].Level.Value >= 400)
                or (LP.Character:FindFirstChild("Electro") and LP.Character["Electro"].Level.Value >= 400) then
                    RepStor.Remotes.CommF_:InvokeServer("BuyElectricClaw")
                    _G.SelectWeapon = "Electric Claw"
                elseif not LP.Backpack:FindFirstChild("Electro") and not LP.Character:FindFirstChild("Electro") then
                    RepStor.Remotes.CommF_:InvokeServer("BuyElectro")
                end
            end
            if cfg.AutoSharkman then
                RepStor.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
                local res = RepStor.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                if type(res)=="string" and string.find(res,"keys") then
                    if LP.Character:FindFirstChild("Water Key") or LP.Backpack:FindFirstChild("Water Key") then
                        topos(CFrame.new(-2604.6958,239.432526,-10315.1982))
                        RepStor.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                    else
                        for _,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name=="Tide Keeper" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                                OldCFrameShark = v.HumanoidRootPart.CFrame
                                repeat
                                    task.wait()
                                    AutoHaki() EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    v.HumanoidRootPart.CFrame = OldCFrameShark
                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                    Click()
                                until not v.Parent or v.Humanoid.Health <= 0 or not cfg.AutoSharkman
                            end
                        end
                        if not workspace.Enemies:FindFirstChild("Tide Keeper") then
                            topos(CFrame.new(-3570.18652,123.328949,-11555.9072))
                            task.wait(3)
                        end
                    end
                else
                    RepStor.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                end
            end
            if cfg.Auto_God_Human then
                local upgrades = {
                    {check="Superhuman",buy="BuyDeathStep",level=400},
                    {check="Death Step",buy="BuySharkmanKarate",level=400},
                    {check="Sharkman Karate",buy="BuyElectricClaw",level=400},
                    {check="Electric Claw",buy="BuyDragonTalon",level=400},
                    {check="Dragon Talon",buy="BuyGodhuman",level=400},
                }
                for _,u in pairs(upgrades) do
                    local bp = LP.Backpack:FindFirstChild(u.check)
                    local ch = LP.Character:FindFirstChild(u.check)
                    if (bp and bp.Level.Value >= u.level) or (ch and ch.Level.Value >= u.level) then
                        RepStor.Remotes.CommF_:InvokeServer(u.buy)
                        if u.buy == "BuyGodhuman" then _G.SelectWeapon = "Godhuman" end
                    end
                end
            end
        end)
    end
end)

-- -- AUTO CURSED DUAL KATANA --------------------------------------------
task.spawn(function()
    while task.wait() do
        pcall(function()
            if Auto_Cursed_Dual_Katana then
                local frags = GetMaterial("Alucard Fragment")
                Auto_Quest_Yama_1 = frags == 0
                Auto_Quest_Yama_2 = frags == 1
                Auto_Quest_Yama_3 = frags == 2
                Auto_Quest_Tushita_1 = frags == 3
                Auto_Quest_Tushita_2 = frags == 4
                Auto_Quest_Tushita_3 = frags == 5
                if frags < 3 then
                    RepStor.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
                    RepStor.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
                elseif frags < 6 then
                    RepStor.Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
                    RepStor.Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if Auto_Quest_Yama_1 then
                if workspace.Enemies:FindFirstChild("Mythological Pirate") then
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name=="Mythological Pirate" and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
                                Click()
                            until not Auto_Quest_Yama_1 or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                else
                    topos(CFrame.new(-13451.46484375,543.712890625,-6961.0029296875))
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if Auto_Quest_Tushita_2 then
                local raidCentre = Vector3.new(-5539.3115234375,313.800537109375,-2972.372314453125)
                if (raidCentre - GetHRP().Position).Magnitude <= 500 then
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0
                        and (v.HumanoidRootPart.Position-GetHRP().Position).Magnitude < 2000 then
                            repeat
                                task.wait()
                                EquipWeapon(Sword or _G.SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                Click()
                            until v.Humanoid.Health <= 0 or not v.Parent or not Auto_Quest_Tushita_2
                        end
                    end
                else
                    topos(CFrame.new(-5545.1240234375,313.800537109375,-2976.616455078125))
                end
            end
        end)
    end
end)

-- ----------------------------------------------------------------------
-- -- UI FRAMEWORK (Kavo lib) -------------------------------------------
-- ----------------------------------------------------------------------
local UI_URL = "https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"
local Window
local TabSet = {}

pcall(function()
    local lib = loadstring(game:HttpGet(UI_URL, true))()
    Window = lib:Window("Elite Hub", cfg.AccentPreset or "Cyan", Enum.KeyCode[cfg.ToggleKey or "RightShift"])
    TabSet.Settings  = Window:Tab("[Settings] Settings")
    TabSet.AutoFarm  = Window:Tab("[Farm] Auto Farm")
    TabSet.ItemQuest = Window:Tab("[Target] Item Quest")
    TabSet.SeaEvent  = Window:Tab("[Sea] Sea Event")
    TabSet.AutoStats = Window:Tab("[Stats] Auto Stats")
    TabSet.WorldTele = Window:Tab("[Map] World Tele")
    TabSet.PlayerPvp = Window:Tab("[PvP] Player PvP")
    TabSet.RaceV4    = Window:Tab("[Start] Race V4")
    TabSet.DungRaid  = Window:Tab("[Castle] Dungeon Raid")
    TabSet.ESP       = Window:Tab("[ESP] ESP")
    TabSet.Misc      = Window:Tab("[Tools] Misc")
end)

if not Window then
    local _stub = setmetatable({},{
        __index = function()
            return function() end
        end
    })
    local _tabStub = setmetatable({},{
        __index = function()
            return function() return _stub end
        end
    })
    for _,n in pairs({"Settings","AutoFarm","ItemQuest","SeaEvent","AutoStats","WorldTele","PlayerPvp","RaceV4","DungRaid","ESP","Misc"}) do
        TabSet[n] = _tabStub
    end
end

local S  = TabSet.Settings
local MN = TabSet.AutoFarm
local FQ = TabSet.ItemQuest
local EV = TabSet.SeaEvent
local ST = TabSet.AutoStats
local TL = TabSet.WorldTele
local PV = TabSet.PlayerPvp
local RC = TabSet.RaceV4
local RD = TabSet.DungRaid
local EP = TabSet.ESP
local MS = TabSet.Misc

-- -- SETTINGS TAB ------------------------------------------------------
S:Toggle("Anti-Kick (Block Ban Remotes)", cfg.AntiKick, function(v)
    cfg.AntiKick = v _G.AntiKick = v saveConfig()
end)
S:Toggle("SetFFFlag (Disable Screenshots)", _G.setfflag, function(v)
    _G.setfflag = v saveConfig()
end)
S:Toggle("Safe Farm (Destroy Anti-Cheat)", _G.SafeFarm, function(v)
    _G.SafeFarm = v saveConfig()
end)
S:Toggle("Bypass TP (Long-range teleport)", cfg.BypassTP, function(v)
    BypassTP = v cfg.BypassTP = v saveConfig()
end)
S:Toggle("Auto Haki", cfg.AutoHakiEnabled, function(v)
    _G.AutoHakiEnabled = v cfg.AutoHakiEnabled = v saveConfig()
end)
S:Toggle("Auto Respawn", cfg.AutoRespawn, function(v)
    cfg.AutoRespawn = v saveConfig()
end)
S:Toggle("Anti-AFK", cfg.AntiAFK, function(v)
    cfg.AntiAFK = v saveConfig()
end)
S:Seperator("Weapon & Combat")
S:Dropdown("Select Weapon", {"Melee","Sword","Fruit","Gun"}, function(v)
    _G.SelectWeapon = v cfg.SelectWeapon = v Sword = v saveConfig()
end)
S:Slider("Magnet Range", 20, 2000, cfg.BringMode or 100, function(v)
    _G.BringMode = v cfg.BringMode = v saveConfig()
end)
S:Toggle("Bring Monster (Magnet)", cfg.BringMonster, function(v)
    _G.BringMonster = v cfg.BringMonster = v saveConfig()
end)
S:Toggle("Invisible Monster", cfg.InvisibleMon, function(v)
    _G.InvisibleMon = v cfg.InvisibleMon = v saveConfig()
end)
S:Toggle("Fast Attack", cfg.FastAttack, function(v)
    cfg.FastAttack = v Fastattack = v saveConfig()
end)
S:Toggle("Use Skill Z", cfg.UseSkillZ, function(v) cfg.UseSkillZ = v saveConfig() end)
S:Toggle("Use Skill X", cfg.UseSkillX, function(v) cfg.UseSkillX = v saveConfig() end)
S:Toggle("Use Skill C", cfg.UseSkillC, function(v) cfg.UseSkillC = v saveConfig() end)
S:Toggle("Use Skill V", cfg.UseSkillV, function(v) cfg.UseSkillV = v saveConfig() end)
S:Slider("Kill At % HP", 1, 100, cfg.Kill_At or 50, function(v)
    _G.Kill_At = v cfg.Kill_At = v saveConfig()
end)

-- -- AUTO FARM TAB -----------------------------------------------------
MN:Toggle("Auto Farm (Quest Level)", cfg.AutoFarm, function(v)
    _G.AutoFarm = v cfg.AutoFarm = v
    if v then _G.AutoFarmNearest = false _G.Farmfast = false end
    StopTween(v) saveConfig()
end)
MN:Toggle("Auto Farm Nearest Enemy", cfg.AutoFarmNearest, function(v)
    _G.AutoFarmNearest = v cfg.AutoFarmNearest = v
    if v then _G.AutoFarm = false _G.Farmfast = false end
    StopTween(v) saveConfig()
end)
MN:Toggle("Auto Farm Fast (Shanda/Zombie)", cfg.Farmfast, function(v)
    _G.Farmfast = v cfg.Farmfast = v
    if v then _G.AutoFarm = false _G.AutoFarmNearest = false end
    StopTween(v) saveConfig()
end)

MN:Seperator("Cake Prince")
MN:Dropdown("Cake Farm Mode", {"No Quest","Quest","Mastery"}, function(v)
    CakeFMode = v cfg.CakeFMode = v saveConfig()
end)
MN:Toggle("Auto Kill Cake Prince / Dough King", cfg.AutoDoughtBoss, function(v)
    _G.AutoDoughtBoss = v cfg.AutoDoughtBoss = v StopTween(v) saveConfig()
end)
MN:Toggle("Auto Spawn Cake Prince", false, function(v)
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("CakePrinceSpawner",v) end)
end)
MN:Toggle("Server Hop (No Dough King)", cfg.AutodoughkingHop, function(v)
    cfg.AutodoughkingHop = v saveConfig()
end)

MN:Seperator("Bone Farm")
local boneLabel = MN:Label("Bones: ...")
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local cnt = RepStor.Remotes.CommF_:InvokeServer("Bones","Check")
            if boneLabel and boneLabel.Set then boneLabel:Set("Bones: "..tostring(cnt)) end
        end)
    end
end)
MN:Dropdown("Bone Farm Mode", {"No Quest","Quest","Mastery"}, function(v)
    BoneFMode = v cfg.BoneFMode = v saveConfig()
end)
MN:Toggle("Auto Farm Bone", cfg.Auto_Bone, function(v)
    _G.Auto_Bone = v cfg.Auto_Bone = v StopTween(v) saveConfig()
end)
MN:Button("Pray (Buy Bone x1)", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) end)
end)
MN:Button("Try Luck (Use Bone)", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("Bones","Use") end)
end)

MN:Seperator("Mastery")
MN:Toggle("Auto Fruit Mastery", cfg.AutoFarmFruitMastery, function(v)
    _G.AutoFarmFruitMastery = v cfg.AutoFarmFruitMastery = v StopTween(v) saveConfig()
end)
MN:Toggle("Auto Gun Mastery", cfg.AutoFarmGunMastery, function(v)
    _G.AutoFarmGunMastery = v cfg.AutoFarmGunMastery = v StopTween(v) saveConfig()
end)
MN:Toggle("Auto Sword Mastery", cfg.AutoSwordMastery, function(v)
    _G.AutoSwordMastery = v cfg.AutoSwordMastery = v StopTween(v) saveConfig()
end)

MN:Seperator("Boss Farm")
MN:Dropdown("Select Boss", {
    "Gorilla King","Pirate Leader","Bobby","Yeti","Mob Leader","Saber Expert",
    "Greybeard","Wysper","Thunder God","Smoke Admiral","Magma Admiral",
    "Don Swan","rip_indra","Order","Dough King","Cake Prince",
    "Tide Keeper","Sea Beast","Island Empress","Kilo Admiral",
    "Captain Elephant","Beautiful Pirate","Stone","Cursed Skeleton Boss",
    "Soul Reaper","Blackbeard","Dragon of the East","Core"
}, function(v)
    _G.SelectBoss = v cfg.SelectBoss = v saveConfig()
end)
MN:Toggle("Auto Kill Selected Boss", cfg.AutoFarmBoss, function(v)
    _G.AutoFarmBoss = v cfg.AutoFarmBoss = v StopTween(v) saveConfig()
end)
MN:Toggle("Auto Kill All Bosses", cfg.AutoAllBoss, function(v)
    _G.AutoAllBoss = v cfg.AutoAllBoss = v StopTween(v) saveConfig()
end)

-- -- ITEM QUEST TAB ----------------------------------------------------
FQ:Toggle("Auto Evo Race V2", false, function(v)
    cfg.Auto_EvoRace = v saveConfig()
end)
FQ:Toggle("Auto Bartilo Quest", false, function(v)
    cfg.AutoBartilo = v saveConfig()
end)
FQ:Toggle("Auto Rainbow Haki", false, function(v)
    cfg.Auto_Rainbow_Haki = v saveConfig()
end)
FQ:Toggle("Auto Rengoku Sword", false, function(v)
    cfg.AutoRengoku = v saveConfig()
end)
FQ:Toggle("Auto Musketeer Hat", false, function(v)
    cfg.AutoMusketeerHat = v saveConfig()
end)
FQ:Toggle("Auto Ectoplasm Farm", false, function(v)
    cfg.AutoEctoplasm = v saveConfig()
end)
FQ:Seperator("Fighting Style Unlocks")
FQ:Toggle("Auto Death Step", false, function(v)
    cfg.AutoDeathStep = v saveConfig()
end)
FQ:Toggle("Auto Electric Claw", false, function(v)
    cfg.AutoElectricClaw = v saveConfig()
end)
FQ:Toggle("Auto Sharkman Karate", false, function(v)
    cfg.AutoSharkman = v saveConfig()
end)
FQ:Toggle("Auto Godhuman", false, function(v)
    cfg.Auto_God_Human = v saveConfig()
end)
FQ:Toggle("Auto Cursed Dual Katana (CDK)", false, function(v)
    Auto_Cursed_Dual_Katana = v cfg.Auto_Cursed_Dual_Katana = v saveConfig()
end)

-- -- SEA EVENT TAB -----------------------------------------------------
EV:Toggle("Auto Factory", false, function(v)
    cfg.AutoFactory = v saveConfig()
end)
EV:Toggle("Auto Pirate Raid", false, function(v)
    cfg.RaidPirate = v saveConfig()
end)
EV:Toggle("Auto Arena Trainer", false, function(v)
    cfg.Namfon = v saveConfig()
end)
EV:Toggle("Auto Hop (No Arena Trainer)", false, function(v)
    cfg.AutoArenaTrainerHop = v saveConfig()
end)
EV:Toggle("Auto Kill rip_indra", false, function(v)
    cfg.AutoDarkDagger = v saveConfig()
end)
EV:Toggle("Auto Hop (rip_indra)", false, function(v)
    cfg.AutoDarkDagger_Hop = v saveConfig()
end)
EV:Toggle("Auto Kill Greybeard", false, function(v)
    cfg.Autogay = v saveConfig()
end)
EV:Toggle("Auto Open Color Haki", false, function(v)
    cfg.Open_Color_Haki = v saveConfig()
end)
EV:Button("Abandon Quest", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("AbandonQuest") end)
end)

-- -- AUTO STATS TAB ----------------------------------------------------
ST:Toggle("Auto Stat", cfg.AutoStatEnabled, function(v)
    cfg.AutoStatEnabled = v saveConfig()
end)
ST:Dropdown("Stat Priority", {"Melee","Defense","Sword","Gun","Fruit"}, function(v)
    cfg.StatPriority = v saveConfig()
end)

-- -- WORLD TELE TAB ----------------------------------------------------
TL:Button("Go to Sea 1", function()
    pcall(function() TeleS:Teleport(2753915549,LP) end)
end)
TL:Button("Go to Sea 2", function()
    pcall(function() TeleS:Teleport(4442272183,LP) end)
end)
TL:Button("Go to Sea 3", function()
    pcall(function() TeleS:Teleport(7449423635,LP) end)
end)
TL:Seperator("Quick Teleports")
TL:Button("Marine Starter (Sea 1)", function()
    topos(CFrame.new(979.3,5.4,1561.5))
end)
TL:Button("Skylands (Sea 1)", function()
    topos(CFrame.new(-4839.53027,716.368591,-2619.44165))
end)
TL:Button("Prison (Sea 1)", function()
    topos(CFrame.new(5308.93115,1.65517521,475.120514))
end)
TL:Button("Magma (Sea 1)", function()
    topos(CFrame.new(-5313.37012,10.9500084,8515.29395))
end)
TL:Button("Haunted Castle (Sea 3)", function()
    topos(CFrame.new(-9506.234375,172.130615234375,6117.0771484375))
end)
TL:Button("Cake Island (Sea 3)", function()
    topos(CFrame.new(-709.3132934570312,381.6005859375,-11011.396484375))
end)
TL:Button("Floating Turtle (Sea 3)", function()
    topos(CFrame.new(6216.0,136.0,-1197.0))
end)
TL:Button("Mirage Island (Sea 3)", function()
    topos(CFrame.new(-9999.0,172.0,-9999.0))
end)
TL:Seperator("Saved Position")
TL:Button("Save Current Position", function()
    local hrp = GetHRP()
    if hrp then
        cfg.SavedPosX = hrp.Position.X
        cfg.SavedPosY = hrp.Position.Y
        cfg.SavedPosZ = hrp.Position.Z
        saveConfig()
    end
end)
TL:Button("Go to Saved Position", function()
    topos(CFrame.new(cfg.SavedPosX or 0, cfg.SavedPosY or 0, cfg.SavedPosZ or 0))
end)
TL:Toggle("Server Hop (Now)", false, function(v)
    cfg.ServerHop = v saveConfig()
    if v then task.spawn(Hop) end
end)

-- -- PLAYER PVP TAB ----------------------------------------------------
PV:Toggle("Fly", cfg.FlyEnabled, function(v)
    cfg.FlyEnabled = v saveConfig()
    if not v then stopFly() end
end)
PV:Slider("Fly Speed", 10, 250, cfg.FlySpeed or 60, function(v)
    cfg.FlySpeed = v saveConfig()
end)
PV:Toggle("Infinite Energy", cfg.InfEnergy, function(v)
    cfg.InfEnergy = v saveConfig()
end)
PV:Toggle("No Dodge Cooldown", cfg.NoDodgeCooldown, function(v)
    cfg.NoDodgeCooldown = v saveConfig()
end)
PV:Toggle("Walk On Water", cfg.WalkWater, function(v)
    cfg.WalkWater = v saveConfig()
end)
PV:Toggle("Black Screen", cfg.BlackScreen, function(v)
    cfg.BlackScreen = v saveConfig()
end)
PV:Toggle("White Screen", cfg.WhiteScreen, function(v)
    cfg.WhiteScreen = v saveConfig()
end)
PV:Button("Abandon Quest", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("AbandonQuest") end)
end)
PV:Button("Set Spawn Point", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("SetSpawnPoint") end)
end)
PV:Toggle("Auto Spawn Point", cfg.AutoSpawnPoint, function(v)
    cfg.AutoSpawnPoint = v saveConfig()
end)
PV:Button("Remove Damage Text", function()
    pcall(function()
        for _,v in pairs(workspace:GetDescendants()) do
            if string.find(tostring(v.Name),"Damage") or string.find(tostring(v.Name),"Float") then
                pcall(function() v:Destroy() end)
            end
        end
    end)
end)
PV:Button("Remove Notifications", function()
    pcall(function()
        for _,v in pairs(LP.PlayerGui:GetDescendants()) do
            if v.Name == "Notification" then v:Destroy() end
        end
    end)
end)

-- -- RACE V4 TAB -------------------------------------------------------
RC:Toggle("Auto Evo Race V2", false, function(v)
    cfg.Auto_EvoRace = v saveConfig()
end)
RC:Toggle("Auto Bartilo Quest (Race prereq)", false, function(v)
    cfg.AutoBartilo = v saveConfig()
end)
RC:Seperator("Claim Race V4")
RC:Button("Human", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("RaceV4","Human") end)
end)
RC:Button("Shark", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("RaceV4","Shark") end)
end)
RC:Button("Sky", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("RaceV4","Sky") end)
end)
RC:Button("Angel", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("RaceV4","Angel") end)
end)
RC:Button("Cyborg", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("RaceV4","Cyborg") end)
end)
RC:Button("Ghoul", function()
    pcall(function() RepStor.Remotes.CommF_:InvokeServer("RaceV4","Ghoul") end)
end)

-- -- DUNGEON RAID TAB -------------------------------------------------
RD:Toggle("Auto Pirate Raid", false, function(v)
    cfg.RaidPirate = v saveConfig()
end)
local raidTypes = {"Flame","Ice","Sand","Dark","Light","Magma","Quake","Spider","Gravity"}
for _,r in pairs(raidTypes) do
    RD:Button("Start Raid: "..r, function()
        pcall(function() RepStor.Remotes.CommF_:InvokeServer("StartRaid",r) end)
    end)
end

-- -- ESP TAB -----------------------------------------------------------
EP:Toggle("Player ESP", cfg.ESPPlayer, function(v)
    ESPPlayer = v cfg.ESPPlayer = v saveConfig()
    if not v then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local h = plr.Character:FindFirstChild("Head")
                if h then local b = h:FindFirstChild(espTag) if b then b:Destroy() end end
            end
        end
    end
end)
EP:Toggle("Mob ESP", cfg.ESPMob, function(v)
    ESPMob = v cfg.ESPMob = v saveConfig()
end)
EP:Toggle("Fruit ESP", cfg.ESPFruit, function(v)
    ESPFruit = v cfg.ESPFruit = v saveConfig()
end)
EP:Toggle("Chest ESP", cfg.ESPChest, function(v)
    ESPChest = v cfg.ESPChest = v saveConfig()
end)
EP:Toggle("Sea Beast ESP", cfg.ESPSeaBeast, function(v)
    ESPSeaBeast = v cfg.ESPSeaBeast = v saveConfig()
end)
EP:Toggle("Fruit Notify", cfg.FruitNotify, function(v)
    cfg.FruitNotify = v saveConfig()
end)
EP:Slider("Fruit Notify Range", 100, 5000, cfg.FruitNotifyRange or 500, function(v)
    cfg.FruitNotifyRange = v saveConfig()
end)

-- -- MISC TAB ---------------------------------------------------------
MS:Button("Server Hop (Switch Server)", function()
    task.spawn(Hop)
end)
MS:Button("Rejoin Game", function()
    pcall(function() TeleS:Teleport(game.PlaceId,LP) end)
end)
MS:Button("Copy Discord Link", function()
    pcall(function() if setclipboard then setclipboard("https://discord.gg/EmsMsHZCVH") end end)
end)
MS:Seperator("Display")
MS:Toggle("Fullbright", false, function(v)
    pcall(function()
        Lighting.Brightness = v and 2 or 1
        Lighting.GlobalShadows = not v
        Lighting.FogEnd = v and 1e9 or 100000
    end)
end)
MS:Toggle("No Fog", false, function(v)
    pcall(function()
        if v then Lighting.FogEnd = 1e9 Lighting.FogStart = 0
        else Lighting.FogEnd = 100000 end
    end)
end)
MS:Button("Clear Damage Text", function()
    pcall(function()
        for _,v in pairs(workspace:GetDescendants()) do
            if string.find(tostring(v.Name),"Damage") or string.find(tostring(v.Name),"Float") then
                pcall(function() v:Destroy() end)
            end
        end
    end)
end)
MS:Button("Remove All Notifications", function()
    pcall(function()
        for _,v in pairs(LP.PlayerGui:GetDescendants()) do
            if v.Name == "Notification" then v:Destroy() end
        end
    end)
end)

-- -- COLOR HAKI AUTO (background walk loop) ---------------------------
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if cfg.Open_Color_Haki then
                local waypoints = {
                    CFrame.new(-5420.16602,1084.9657,-2666.8208),
                    CFrame.new(-5414.41357,309.865753,-2212.45776),
                    CFrame.new(-4971.47559,331.565765,-3720.02954),
                }
                for _,wp in pairs(waypoints) do
                    if not cfg.Open_Color_Haki then break end
                    if BypassTP then
                        if (GetHRP().Position-wp.Position).Magnitude > 1500 then BTP(wp) else topos(wp) end
                    else topos(wp) end
                    task.wait(0.5)
                    Click()
                    task.wait(1)
                end
            end
        end)
    end
end)

-- -- CHARACTER ADDED (re-apply effects on respawn) ---------------------
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if FlyBV then stopFly() end
        if _G.SafeFarm then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("LocalScript") then
                    if v.Name=="General" or v.Name=="Shiftlock" or v.Name=="FallDamage"
                    or v.Name=="4444" or v.Name=="CamBob" or v.Name=="JumpCD"
                    or v.Name=="Looking" or v.Name=="Run" then
                        v:Destroy()
                    end
                end
            end
        end
        if cfg.FlyEnabled then task.wait(0.5) startFly() end
    end)
end)

print("[Elite Hub v1.0.2] All features active. discord.gg/EmsMsHZCVH")
