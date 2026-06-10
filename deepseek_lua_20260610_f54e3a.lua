-- // ELITE HUB v1.0.0 | JAILBREAK
-- // https://discord.gg/5RuMCxK3u6
-- // FUCK YOU IF YOU STEAL THIS SHIT 🥀

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = Workspace.CurrentCamera

-- // FUCKING SETTINGS //
local Settings = {
    Color = Color3.fromRGB(46, 204, 113),
    BgColor = Color3.fromRGB(15, 15, 20),
    
    -- Automation (shit you want auto)
    AutoFarm = false,
    AutoRoll = false,
    AutoEnchant = false,
    AutoMerchant = false,
    AutoSkill = false,
    AutoBank = false,
    AutoJewelry = false,
    AutoMuseum = false,
    AutoArrest = false,
    
    -- Auto Rolls (for traits/races/clans/bloodlines)
    TargetTrait = "None",
    TargetRace = "None", 
    TargetClan = "None",
    TargetBloodline = "None",
    RollCooldown = 0.1,
    
    -- Skill Tree (level up this bitch)
    SkillNodeIndex = 1,
    UpgradeNode = "None",
    AutoUpgradeNodes = false,
    SkillPriority = "Attack", -- Attack, Defense, Health
    
    -- Merchant (buy that shit)
    AutoBuyFromMerchant = false,
    BuyItems = {
        Keycard = true,
    },
    MerchantCycleTime = 60,
    
    -- Movement (go fast as fuck)
    Fly = false,
    FlySpeed = 85,
    Noclip = false,
    WalkSpeed = 24,
    JumpPower = 65,
    
    -- Visuals (see those bitches)
    ESP = false,
    FullBright = false,
    
    Flying = false,
}

-- // ANTI AFK (FUCK THE AFK KICK) //
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- // DISCORD POPUP - JOIN OR GET FUCKED //
local DiscordGui = Instance.new("ScreenGui")
DiscordGui.Name = "DiscordBitch"
DiscordGui.Parent = CoreGui

local Popup = Instance.new("Frame")
Popup.Size = UDim2.new(0, 350, 0, 160)
Popup.Position = UDim2.new(0.5, -175, 0.5, -80)
Popup.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Popup.BackgroundTransparency = 0
Popup.BorderSizePixel = 0
Popup.Parent = DiscordGui

local PopCorner = Instance.new("UICorner")
PopCorner.CornerRadius = UDim.new(0, 12)
PopCorner.Parent = Popup

local PopTitle = Instance.new("TextLabel")
PopTitle.Size = UDim2.new(1, 0, 0, 45)
PopTitle.Position = UDim2.new(0, 0, 0, 10)
PopTitle.BackgroundTransparency = 1
PopTitle.Text = "ELITE HUB 🔥"
PopTitle.TextColor3 = Settings.Color
PopTitle.Font = Enum.Font.GothamBold
PopTitle.TextSize = 28
PopTitle.Parent = Popup

local PopMsg = Instance.new("TextLabel")
PopMsg.Size = UDim2.new(1, -30, 0, 40)
PopMsg.Position = UDim2.new(0, 15, 0, 60)
PopMsg.BackgroundTransparency = 1
PopMsg.Text = "JOIN DISCORD YOU BITCH 🥀\ndiscord.gg/5RuMCxK3u6"
PopMsg.TextColor3 = Color3.fromRGB(180, 180, 200)
PopMsg.Font = Enum.Font.Gotham
PopMsg.TextSize = 12
PopMsg.TextWrapped = true
PopMsg.Parent = Popup

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0, 140, 0, 35)
JoinBtn.Position = UDim2.new(0.5, -150, 0, 115)
JoinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
JoinBtn.Text = "YES JOIN (COPY LINK)"
JoinBtn.TextColor3 = Color3.new(1, 1, 1)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 12
JoinBtn.Parent = Popup

local SkipBtn = Instance.new("TextButton")
SkipBtn.Size = UDim2.new(0, 140, 0, 35)
SkipBtn.Position = UDim2.new(0.5, 10, 0, 115)
SkipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SkipBtn.Text = "NO (FUCK OFF)"
SkipBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
SkipBtn.Font = Enum.Font.GothamBold
SkipBtn.TextSize = 12
SkipBtn.Parent = Popup

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = JoinBtn

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = SkipBtn

JoinBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    DiscordGui:Destroy()
    CreateUI()
end)

SkipBtn.MouseButton1Click:Connect(function()
    DiscordGui:Destroy()
    CreateUI()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "You're a dumbass for not joining but whatever 🥀",
        Duration = 3
    })
end)

-- // LOADING SCREEN (LOOKS CLEAN AS FUCK) //
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "LoadingBitch"
LoadGui.Parent = CoreGui

local LoadBg = Instance.new("Frame")
LoadBg.Size = UDim2.new(1, 0, 1, 0)
LoadBg.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
LoadBg.Parent = LoadGui

local LoadCenter = Instance.new("Frame")
LoadCenter.Size = UDim2.new(0, 400, 0, 250)
LoadCenter.Position = UDim2.new(0.5, -200, 0.5, -125)
LoadCenter.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
LoadCenter.BackgroundTransparency = 0.05
LoadCenter.Parent = LoadBg

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 16)
LoadCorner.Parent = LoadCenter

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 60)
LoadTitle.Position = UDim2.new(0, 0, 0, 20)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "ELITE HUB"
LoadTitle.TextColor3 = Settings.Color
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 40
LoadTitle.TextScaled = true
LoadTitle.Parent = LoadCenter

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, -40, 0, 30)
LoadStatus.Position = UDim2.new(0, 20, 0, 100)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "LOADING THIS SHIT..."
LoadStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
LoadStatus.Font = Enum.Font.Gotham
LoadStatus.TextSize = 14
LoadStatus.Parent = LoadCenter

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0.8, 0, 0, 8)
BarBg.Position = UDim2.new(0.1, 0, 0, 150)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBg.Parent = LoadCenter

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Settings.Color
BarFill.Parent = BarBg

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

local steps = {
    "INJECTING BITCH...",
    "BYPASSING JAILBREAK SHIT...",
    "LOADING ESP AND CHEATS...",
    "FUCKING READY 🥀"
}

for i, step in ipairs(steps) do
    LoadStatus.Text = step
    TweenService:Create(BarFill, TweenInfo.new(0.4), {Size = UDim2.new(i / #steps, 0, 1, 0)}):Play()
    task.wait(0.4)
end

task.wait(0.2)
LoadGui:Destroy()

-- // LOCATIONS //
local Locations = {
    Bank = { Vault = CFrame.new(20, 18, 790), Roof = CFrame.new(10, 85, 770), Escape = CFrame.new(-10, 18, 770) },
    Jewelry = { Boxes = CFrame.new(130, 18, 1315), Roof = CFrame.new(133, 100, 1315), TurnIn = CFrame.new(-235, 18, 1610) },
    Museum = { Mummy = CFrame.new(1060, 101, 1250), TurnIn = CFrame.new(1630, 50, -1760) },
    Merchant = CFrame.new(-25, 18, 250),
}

-- // TWEEN FUNCTION //
local function TweenTo(cf, speed)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - cf.Position).Magnitude / speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

-- // FLY SHIT //
local function ToggleFly()
    Settings.Flying = not Settings.Flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if Settings.Flying then
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "EliteGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "EliteVelocity"
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while Settings.Flying and char and char:FindFirstChild("HumanoidRootPart") do
                task.wait()
                local control = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then control = control + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then control = control - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then control = control - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then control = control + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then control = control + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then control = control - Vector3.new(0, 1, 0) end
                
                bg.cframe = CFrame.new(hrp.Position, hrp.Position + control)
                bv.velocity = control * Settings.FlySpeed
            end
            if hrp:FindFirstChild("EliteGyro") then hrp.EliteGyro:Destroy() end
            if hrp:FindFirstChild("EliteVelocity") then hrp.EliteVelocity:Destroy() end
        end)
    else
        if hrp:FindFirstChild("EliteGyro") then hrp.EliteGyro:Destroy() end
        if hrp:FindFirstChild("EliteVelocity") then hrp.EliteVelocity:Destroy() end
    end
end

-- // CREATE UI (EXACT LAYOUT FROM SCREENSHOT) //
function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EliteHub"
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    MainFrame.BackgroundColor3 = Settings.BgColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "ELITE HUB | JAILBREAK | 60 FPS"
    Title.TextColor3 = Settings.Color
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = TitleBar
    
    -- // SCROLLING FRAME FOR SECTIONS //
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -50)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.Parent = MainFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 12)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = ScrollFrame
    
    -- // SECTION 1: AUTOMATION (like screenshot) //
    local AutoSection = Instance.new("Frame")
    AutoSection.Size = UDim2.new(1, 0, 0, 45)
    AutoSection.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    AutoSection.Parent = ScrollFrame
    
    local AutoCorner = Instance.new("UICorner")
    AutoCorner.CornerRadius = UDim.new(0, 8)
    AutoCorner.Parent = AutoSection
    
    local AutoTitle = Instance.new("TextLabel")
    AutoTitle.Size = UDim2.new(1, -20, 0, 25)
    AutoTitle.Position = UDim2.new(0, 10, 0, 5)
    AutoTitle.BackgroundTransparency = 1
    AutoTitle.Text = "⚡ AUTOMATION"
    AutoTitle.TextColor3 = Settings.Color
    AutoTitle.Font = Enum.Font.GothamBold
    AutoTitle.TextSize = 14
    AutoTitle.TextXAlignment = Enum.TextXAlignment.Left
    AutoTitle.Parent = AutoSection
    
    local AutoSub = Instance.new("TextLabel")
    AutoSub.Size = UDim2.new(1, -20, 0, 15)
    AutoSub.Position = UDim2.new(0, 10, 0, 25)
    AutoSub.BackgroundTransparency = 1
    AutoSub.Text = "Auto rolls, enchants, merchant, and skill tree."
    AutoSub.TextColor3 = Color3.fromRGB(150, 150, 170)
    AutoSub.Font = Enum.Font.Gotham
    AutoSub.TextSize = 11
    AutoSub.TextXAlignment = Enum.TextXAlignment.Left
    AutoSub.Parent = AutoSection
    
    -- // AUTO ROLLS SECTION (exactly like screenshot) //
    local RollsSection = Instance.new("Frame")
    RollsSection.Size = UDim2.new(1, 0, 0, 200)
    RollsSection.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    RollsSection.Parent = ScrollFrame
    
    local RollsCorner = Instance.new("UICorner")
    RollsCorner.CornerRadius = UDim.new(0, 8)
    RollsCorner.Parent = RollsSection
    
    local RollsTitle = Instance.new("TextLabel")
    RollsTitle.Size = UDim2.new(1, -20, 0, 25)
    RollsTitle.Position = UDim2.new(0, 10, 0, 5)
    RollsTitle.BackgroundTransparency = 1
    RollsTitle.Text = "🎲 AUTO ROLLS"
    RollsTitle.TextColor3 = Settings.Color
    RollsTitle.Font = Enum.Font.GothamBold
    RollsTitle.TextSize = 14
    RollsTitle.TextXAlignment = Enum.TextXAlignment.Left
    RollsTitle.Parent = RollsSection
    
    local RollsSub = Instance.new("TextLabel")
    RollsSub.Size = UDim2.new(1, -20, 0, 15)
    RollsSub.Position = UDim2.new(0, 10, 0, 25)
    RollsSub.BackgroundTransparency = 1
    RollsSub.Text = "Auto roll for desired traits, races, clans, and bloodlines."
    RollsSub.TextColor3 = Color3.fromRGB(150, 150, 170)
    RollsSub.Font = Enum.Font.Gotham
    RollsSub.TextSize = 11
    RollsSub.TextXAlignment = Enum.TextXAlignment.Left
    RollsSub.Parent = RollsSection
    
    -- Target Traits row
    local TraitRow = Instance.new("Frame")
    TraitRow.Size = UDim2.new(1, -20, 0, 30)
    TraitRow.Position = UDim2.new(0, 10, 0, 50)
    TraitRow.BackgroundTransparency = 1
    TraitRow.Parent = RollsSection
    
    local TraitLabel = Instance.new("TextLabel")
    TraitLabel.Size = UDim2.new(0, 120, 1, 0)
    TraitLabel.BackgroundTransparency = 1
    TraitLabel.Text = "Target Traits:"
    TraitLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    TraitLabel.Font = Enum.Font.Gotham
    TraitLabel.TextSize = 12
    TraitLabel.TextXAlignment = Enum.TextXAlignment.Left
    TraitLabel.Parent = TraitRow
    
    local TraitValue = Instance.new("TextLabel")
    TraitValue.Size = UDim2.new(1, -130, 1, 0)
    TraitValue.Position = UDim2.new(0, 130, 0, 0)
    TraitValue.BackgroundTransparency = 1
    TraitValue.Text = "None"
    TraitValue.TextColor3 = Settings.Color
    TraitValue.Font = Enum.Font.GothamBold
    TraitValue.TextSize = 12
    TraitValue.TextXAlignment = Enum.TextXAlignment.Left
    TraitValue.Parent = TraitRow
    
    -- Target Race row
    local RaceRow = Instance.new("Frame")
    RaceRow.Size = UDim2.new(1, -20, 0, 30)
    RaceRow.Position = UDim2.new(0, 10, 0, 80)
    RaceRow.BackgroundTransparency = 1
    RaceRow.Parent = RollsSection
    
    local RaceLabel = Instance.new("TextLabel")
    RaceLabel.Size = UDim2.new(0, 120, 1, 0)
    RaceLabel.BackgroundTransparency = 1
    RaceLabel.Text = "Target Race:"
    RaceLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    RaceLabel.Font = Enum.Font.Gotham
    RaceLabel.TextSize = 12
    RaceLabel.TextXAlignment = Enum.TextXAlignment.Left
    RaceLabel.Parent = RaceRow
    
    local RaceValue = Instance.new("TextLabel")
    RaceValue.Size = UDim2.new(1, -130, 1, 0)
    RaceValue.Position = UDim2.new(0, 130, 0, 0)
    RaceValue.BackgroundTransparency = 1
    RaceValue.Text = "None"
    RaceValue.TextColor3 = Settings.Color
    RaceValue.Font = Enum.Font.GothamBold
    RaceValue.TextSize = 12
    RaceValue.TextXAlignment = Enum.TextXAlignment.Left
    RaceValue.Parent = RaceRow
    
    -- Target Clan row
    local ClanRow = Instance.new("Frame")
    ClanRow.Size = UDim2.new(1, -20, 0, 30)
    ClanRow.Position = UDim2.new(0, 10, 0, 110)
    ClanRow.BackgroundTransparency = 1
    ClanRow.Parent = RollsSection
    
    local ClanLabel = Instance.new("TextLabel")
    ClanLabel.Size = UDim2.new(0, 120, 1, 0)
    ClanLabel.BackgroundTransparency = 1
    ClanLabel.Text = "Target Clan:"
    ClanLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    ClanLabel.Font = Enum.Font.Gotham
    ClanLabel.TextSize = 12
    ClanLabel.TextXAlignment = Enum.TextXAlignment.Left
    ClanLabel.Parent = ClanRow
    
    local ClanValue = Instance.new("TextLabel")
    ClanValue.Size = UDim2.new(1, -130, 1, 0)
    ClanValue.Position = UDim2.new(0, 130, 0, 0)
    ClanValue.BackgroundTransparency = 1
    ClanValue.Text = "None"
    ClanValue.TextColor3 = Settings.Color
    ClanValue.Font = Enum.Font.GothamBold
    ClanValue.TextSize = 12
    ClanValue.TextXAlignment = Enum.TextXAlignment.Left
    ClanValue.Parent = ClanRow
    
    -- Roll Cooldown row
    local CooldownRow = Instance.new("Frame")
    CooldownRow.Size = UDim2.new(1, -20, 0, 30)
    CooldownRow.Position = UDim2.new(0, 10, 0, 140)
    CooldownRow.BackgroundTransparency = 1
    CooldownRow.Parent = RollsSection
    
    local CooldownLabel = Instance.new("TextLabel")
    CooldownLabel.Size = UDim2.new(0, 120, 1, 0)
    CooldownLabel.BackgroundTransparency = 1
    CooldownLabel.Text = "Roll Cooldown (sec):"
    CooldownLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    CooldownLabel.Font = Enum.Font.Gotham
    CooldownLabel.TextSize = 12
    CooldownLabel.TextXAlignment = Enum.TextXAlignment.Left
    CooldownLabel.Parent = CooldownRow
    
    local CooldownValue = Instance.new("TextLabel")
    CooldownValue.Size = UDim2.new(1, -130, 1, 0)
    CooldownValue.Position = UDim2.new(0, 130, 0, 0)
    CooldownValue.BackgroundTransparency = 1
    CooldownValue.Text = "0.1"
    CooldownValue.TextColor3 = Settings.Color
    CooldownValue.Font = Enum.Font.GothamBold
    CooldownValue.TextSize = 12
    CooldownValue.TextXAlignment = Enum.TextXAlignment.Left
    CooldownValue.Parent = CooldownRow
    
    -- Auto Roll button
    local AutoRollBtn = Instance.new("TextButton")
    AutoRollBtn.Size = UDim2.new(1, -20, 0, 35)
    AutoRollBtn.Position = UDim2.new(0, 10, 0, 175)
    AutoRollBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    AutoRollBtn.Text = "🔁 AUTO ROLL: OFF"
    AutoRollBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    AutoRollBtn.Font = Enum.Font.GothamBold
    AutoRollBtn.TextSize = 12
    AutoRollBtn.Parent = RollsSection
    
    local AutoRollCorner = Instance.new("UICorner")
    AutoRollCorner.CornerRadius = UDim.new(0, 6)
    AutoRollCorner.Parent = AutoRollBtn
    
    -- // SKILL TREE SECTION //
    local SkillSection = Instance.new("Frame")
    SkillSection.Size = UDim2.new(1, 0, 0, 180)
    SkillSection.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    SkillSection.Parent = ScrollFrame
    
    local SkillCorner = Instance.new("UICorner")
    SkillCorner.CornerRadius = UDim.new(0, 8)
    SkillCorner.Parent = SkillSection
    
    local SkillTitle = Instance.new("TextLabel")
    SkillTitle.Size = UDim2.new(1, -20, 0, 25)
    SkillTitle.Position = UDim2.new(0, 10, 0, 5)
    SkillTitle.BackgroundTransparency = 1
    SkillTitle.Text = "🌳 SKILL TREE"
    SkillTitle.TextColor3 = Settings.Color
    SkillTitle.Font = Enum.Font.GothamBold
    SkillTitle.TextSize = 14
    SkillTitle.TextXAlignment = Enum.TextXAlignment.Left
    SkillTitle.Parent = SkillSection
    
    local SkillSub = Instance.new("TextLabel")
    SkillSub.Size = UDim2.new(1, -20, 0, 15)
    SkillSub.Position = UDim2.new(0, 10, 0, 25)
    SkillSub.BackgroundTransparency = 1
    SkillSub.Text = "Upgrade skill tree nodes. Requires skill points."
    SkillSub.TextColor3 = Color3.fromRGB(150, 150, 170)
    SkillSub.Font = Enum.Font.Gotham
    SkillSub.TextSize = 11
    SkillSub.TextXAlignment = Enum.TextXAlignment.Left
    SkillSub.Parent = SkillSection
    
    -- Node Index row
    local NodeRow = Instance.new("Frame")
    NodeRow.Size = UDim2.new(1, -20, 0, 30)
    NodeRow.Position = UDim2.new(0, 10, 0, 50)
    NodeRow.BackgroundTransparency = 1
    NodeRow.Parent = SkillSection
    
    local NodeLabel = Instance.new("TextLabel")
    NodeLabel.Size = UDim2.new(0, 100, 1, 0)
    NodeLabel.BackgroundTransparency = 1
    NodeLabel.Text = "Node Index:"
    NodeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    NodeLabel.Font = Enum.Font.Gotham
    NodeLabel.TextSize = 12
    NodeLabel.TextXAlignment = Enum.TextXAlignment.Left
    NodeLabel.Parent = NodeRow
    
    local NodeValue = Instance.new("TextButton")
    NodeValue.Size = UDim2.new(0, 60, 1, 0)
    NodeValue.Position = UDim2.new(0, 110, 0, 0)
    NodeValue.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    NodeValue.Text = "1"
    NodeValue.TextColor3 = Settings.Color
    NodeValue.Font = Enum.Font.GothamBold
    NodeValue.TextSize = 12
    NodeValue.Parent = NodeRow
    
    local NodeCorner = Instance.new("UICorner")
    NodeCorner.CornerRadius = UDim.new(0, 4)
    NodeCorner.Parent = NodeValue
    
    -- Upgrade Node row
    local UpgradeRow = Instance.new("Frame")
    UpgradeRow.Size = UDim2.new(1, -20, 0, 30)
    UpgradeRow.Position = UDim2.new(0, 10, 0, 80)
    UpgradeRow.BackgroundTransparency = 1
    UpgradeRow.Parent = SkillSection
    
    local UpgradeLabel = Instance.new("TextLabel")
    UpgradeLabel.Size = UDim2.new(0, 100, 1, 0)
    UpgradeLabel.BackgroundTransparency = 1
    UpgradeLabel.Text = "Upgrade Node:"
    UpgradeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    UpgradeLabel.Font = Enum.Font.Gotham
    UpgradeLabel.TextSize = 12
    UpgradeLabel.TextXAlignment = Enum.TextXAlignment.Left
    UpgradeLabel.Parent = UpgradeRow
    
    local UpgradeValue = Instance.new("TextLabel")
    UpgradeValue.Size = UDim2.new(1, -110, 1, 0)
    UpgradeValue.Position = UDim2.new(0, 110, 0, 0)
    UpgradeValue.BackgroundTransparency = 1
    UpgradeValue.Text = "None"
    UpgradeValue.TextColor3 = Color3.fromRGB(150, 150, 170)
    UpgradeValue.Font = Enum.Font.Gotham
    UpgradeValue.TextSize = 12
    UpgradeValue.TextXAlignment = Enum.TextXAlignment.Left
    UpgradeValue.Parent = UpgradeRow
    
    -- Auto Upgrade button
    local AutoUpgradeBtn = Instance.new("TextButton")
    AutoUpgradeBtn.Size = UDim2.new(1, -20, 0, 35)
    AutoUpgradeBtn.Position = UDim2.new(0, 10, 0, 120)
    AutoUpgradeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    AutoUpgradeBtn.Text = "⚡ AUTO UPGRADE NODES: OFF"
    AutoUpgradeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    AutoUpgradeBtn.Font = Enum.Font.GothamBold
    AutoUpgradeBtn.TextSize = 12
    AutoUpgradeBtn.Parent = SkillSection
    
    local AutoUpgradeCorner = Instance.new("UICorner")
    AutoUpgradeCorner.CornerRadius = UDim.new(0, 6)
    AutoUpgradeCorner.Parent = AutoUpgradeBtn
    
    -- Branch Priority row
    local BranchRow = Instance.new("Frame")
    BranchRow.Size = UDim2.new(1, -20, 0, 30)
    BranchRow.Position = UDim2.new(0, 10, 0, 160)
    BranchRow.BackgroundTransparency = 1
    BranchRow.Parent = SkillSection
    
    local BranchLabel = Instance.new("TextLabel")
    BranchLabel.Size = UDim2.new(0, 100, 1, 0)
    BranchLabel.BackgroundTransparency = 1
    BranchLabel.Text = "Auto Skill Tree:"
    BranchLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    BranchLabel.Font = Enum.Font.Gotham
    BranchLabel.TextSize = 12
    BranchLabel.TextXAlignment = Enum.TextXAlignment.Left
    BranchLabel.Parent = BranchRow
    
    local BranchValue = Instance.new("TextButton")
    BranchValue.Size = UDim2.new(0, 100, 1, 0)
    BranchValue.Position = UDim2.new(0, 110, 0, 0)
    BranchValue.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    BranchValue.Text = "Attack"
    BranchValue.TextColor3 = Settings.Color
    BranchValue.Font = Enum.Font.GothamBold
    BranchValue.TextSize = 12
    BranchValue.Parent = BranchRow
    
    local BranchCorner = Instance.new("UICorner")
    BranchCorner.CornerRadius = UDim.new(0, 4)
    BranchCorner.Parent = BranchValue
    
    -- // MERCHANT SECTION //
    local MerchantSection = Instance.new("Frame")
    MerchantSection.Size = UDim2.new(1, 0, 0, 130)
    MerchantSection.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    MerchantSection.Parent = ScrollFrame
    
    local MerchantCorner = Instance.new("UICorner")
    MerchantCorner.CornerRadius = UDim.new(0, 8)
    MerchantCorner.Parent = MerchantSection
    
    local MerchantTitle = Instance.new("TextLabel")
    MerchantTitle.Size = UDim2.new(1, -20, 0, 25)
    MerchantTitle.Position = UDim2.new(0, 10, 0, 5)
    MerchantTitle.BackgroundTransparency = 1
    MerchantTitle.Text = "💰 MERCHANT"
    MerchantTitle.TextColor3 = Settings.Color
    MerchantTitle.Font = Enum.Font.GothamBold
    MerchantTitle.TextSize = 14
    MerchantTitle.TextXAlignment = Enum.TextXAlignment.Left
    MerchantTitle.Parent = MerchantSection
    
    local MerchantSub = Instance.new("TextLabel")
    MerchantSub.Size = UDim2.new(1, -20, 0, 15)
    MerchantSub.Position = UDim2.new(0, 10, 0, 25)
    MerchantSub.BackgroundTransparency = 1
    MerchantSub.Text = "Automatically visits the Merchant NPC and buys items."
    MerchantSub.TextColor3 = Color3.fromRGB(150, 150, 170)
    MerchantSub.Font = Enum.Font.Gotham
    MerchantSub.TextSize = 11
    MerchantSub.TextXAlignment = Enum.TextXAlignment.Left
    MerchantSub.Parent = MerchantSection
    
    -- Keycard toggle
    local KeycardRow = Instance.new("Frame")
    KeycardRow.Size = UDim2.new(1, -20, 0, 30)
    KeycardRow.Position = UDim2.new(0, 10, 0, 50)
    KeycardRow.BackgroundTransparency = 1
    KeycardRow.Parent = MerchantSection
    
    local KeycardLabel = Instance.new("TextLabel")
    KeycardLabel.Size = UDim2.new(0, 100, 1, 0)
    KeycardLabel.BackgroundTransparency = 1
    KeycardLabel.Text = "Auto Buy:"
    KeycardLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    KeycardLabel.Font = Enum.Font.Gotham
    KeycardLabel.TextSize = 12
    KeycardLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeycardLabel.Parent = KeycardRow
    
    local KeycardBtn = Instance.new("TextButton")
    KeycardBtn.Size = UDim2.new(0, 80, 1, 0)
    KeycardBtn.Position = UDim2.new(0, 110, 0, 0)
    KeycardBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    KeycardBtn.Text = "Keycard: ❌"
    KeycardBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    KeycardBtn.Font = Enum.Font.Gotham
    KeycardBtn.TextSize = 11
    KeycardBtn.Parent = KeycardRow
    
    local KeycardCorner = Instance.new("UICorner")
    KeycardCorner.CornerRadius = UDim.new(0, 4)
    KeycardCorner.Parent = KeycardBtn
    
    -- Auto Merchant button
    local AutoMerchantBtn = Instance.new("TextButton")
    AutoMerchantBtn.Size = UDim2.new(1, -20, 0, 35)
    AutoMerchantBtn.Position = UDim2.new(0, 10, 0, 85)
    AutoMerchantBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    AutoMerchantBtn.Text = "🏪 AUTO BUY FROM MERCHANT: OFF"
    AutoMerchantBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    AutoMerchantBtn.Font = Enum.Font.GothamBold
    AutoMerchantBtn.TextSize = 12
    AutoMerchantBtn.Parent = MerchantSection
    
    local AutoMerchantCorner = Instance.new("UICorner")
    AutoMerchantCorner.CornerRadius = UDim.new(0, 6)
    AutoMerchantCorner.Parent = AutoMerchantBtn
    
    -- // MOVEMENT SECTION //
    local MoveSection = Instance.new("Frame")
    MoveSection.Size = UDim2.new(1, 0, 0, 120)
    MoveSection.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    MoveSection.Parent = ScrollFrame
    
    local MoveCorner = Instance.new("UICorner")
    MoveCorner.CornerRadius = UDim.new(0, 8)
    MoveCorner.Parent = MoveSection
    
    local MoveTitle = Instance.new("TextLabel")
    MoveTitle.Size = UDim2.new(1, -20, 0, 25)
    MoveTitle.Position = UDim2.new(0, 10, 0, 5)
    MoveTitle.BackgroundTransparency = 1
    MoveTitle.Text = "🌀 MOVEMENT"
    MoveTitle.TextColor3 = Settings.Color
    MoveTitle.Font = Enum.Font.GothamBold
    MoveTitle.TextSize = 14
    MoveTitle.TextXAlignment = Enum.TextXAlignment.Left
    MoveTitle.Parent = MoveSection
    
    local FlyBtn = Instance.new("TextButton")
    FlyBtn.Size = UDim2.new(0.48, 0, 0, 35)
    FlyBtn.Position = UDim2.new(0, 10, 0, 40)
    FlyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    FlyBtn.Text = "🕊️ FLY: OFF"
    FlyBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    FlyBtn.Font = Enum.Font.GothamBold
    FlyBtn.TextSize = 12
    FlyBtn.Parent = MoveSection
    
    local FlyCorner = Instance.new("UICorner")
    FlyCorner.CornerRadius = UDim.new(0, 6)
    FlyCorner.Parent = FlyBtn
    
    local NoclipBtn = Instance.new("TextButton")
    NoclipBtn.Size = UDim2.new(0.48, 0, 0, 35)
    NoclipBtn.Position = UDim2.new(0.52, 0, 0, 40)
    NoclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    NoclipBtn.Text = "🌀 NOCLIP: OFF"
    NoclipBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    NoclipBtn.Font = Enum.Font.GothamBold
    NoclipBtn.TextSize = 12
    NoclipBtn.Parent = MoveSection
    
    local NoclipCorner = Instance.new("UICorner")
    NoclipCorner.CornerRadius = UDim.new(0, 6)
    NoclipCorner.Parent = NoclipBtn
    
    local WSSlider = Instance.new("TextButton")
    WSSlider.Size = UDim2.new(1, -20, 0, 30)
    WSSlider.Position = UDim2.new(0, 10, 0, 80)
    WSSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    WSSlider.Text = "⚡ WALK SPEED: 24"
    WSSlider.TextColor3 = Color3.fromRGB(200, 200, 220)
    WSSlider.Font = Enum.Font.Gotham
    WSSlider.TextSize = 12
    WSSlider.Parent = MoveSection
    
    local WSCorner = Instance.new("UICorner")
    WSCorner.CornerRadius = UDim.new(0, 6)
    WSCorner.Parent = WSSlider
    
    -- Update canvas size
    local function UpdateCanvas()
        local totalHeight = 0
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("Frame") and child ~= Layout then
                totalHeight = totalHeight + child.Size.Y.Offset + Layout.Padding.Offset
            end
        end
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
    end
    
    -- Wait for everything to load then update canvas
    task.wait(0.1)
    UpdateCanvas()
    
    -- // BUTTON FUNCTIONALITY //
    local autoRollState = false
    AutoRollBtn.MouseButton1Click:Connect(function()
        autoRollState = not autoRollState
        AutoRollBtn.Text = autoRollState and "🔁 AUTO ROLL: ON ✓" or "🔁 AUTO ROLL: OFF"
        AutoRollBtn.BackgroundColor3 = autoRollState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(30, 30, 40)
    end)
    
    local autoUpgradeState = false
    AutoUpgradeBtn.MouseButton1Click:Connect(function()
        autoUpgradeState = not autoUpgradeState
        AutoUpgradeBtn.Text = autoUpgradeState and "⚡ AUTO UPGRADE NODES: ON ✓" or "⚡ AUTO UPGRADE NODES: OFF"
        AutoUpgradeBtn.BackgroundColor3 = autoUpgradeState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(30, 30, 40)
    end)
    
    local autoMerchantState = false
    AutoMerchantBtn.MouseButton1Click:Connect(function()
        autoMerchantState = not autoMerchantState
        AutoMerchantBtn.Text = autoMerchantState and "🏪 AUTO BUY FROM MERCHANT: ON ✓" or "🏪 AUTO BUY FROM MERCHANT: OFF"
        AutoMerchantBtn.BackgroundColor3 = autoMerchantState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(30, 30, 40)
    end)
    
    local flyState = false
    FlyBtn.MouseButton1Click:Connect(function()
        flyState = not flyState
        Settings.Fly = flyState
        FlyBtn.Text = flyState and "🕊️ FLY: ON ✓" or "🕊️ FLY: OFF"
        FlyBtn.BackgroundColor3 = flyState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(30, 30, 40)
        ToggleFly()
    end)
    
    local noclipState = false
    NoclipBtn.MouseButton1Click:Connect(function()
        noclipState = not noclipState
        Settings.Noclip = noclipState
        NoclipBtn.Text = noclipState and "🌀 NOCLIP: ON ✓" or "🌀 NOCLIP: OFF"
        NoclipBtn.BackgroundColor3 = noclipState and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(30, 30, 40)
        
        if noclipState then
            RunService:BindToRenderStep("Noclip", 0, function()
                if LP.Character then
                    for _, part in pairs(LP.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            RunService:UnbindFromRenderStep("Noclip")
        end
    end)
    
    local wsValues = {24, 32, 40, 50, 65, 80, 100, 120, 150}
    local wsIndex = 1
    WSSlider.MouseButton1Click:Connect(function()
        wsIndex = wsIndex % #wsValues + 1
        Settings.WalkSpeed = wsValues[wsIndex]
        WSSlider.Text = "⚡ WALK SPEED: " .. Settings.WalkSpeed
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
        end
    end)
    
    local keycardBuy = false
    KeycardBtn.MouseButton1Click:Connect(function()
        keycardBuy = not keycardBuy
        KeycardBtn.Text = keycardBuy and "Keycard: ✅" or "Keycard: ❌"
        KeycardBtn.BackgroundColor3 = keycardBuy and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(35, 35, 45)
    end)
    
    local branchPriority = {"Attack", "Defense", "Health", "Fruit", "Sword"}
    local branchIndex = 1
    BranchValue.MouseButton1Click:Connect(function()
        branchIndex = branchIndex % #branchPriority + 1
        BranchValue.Text = branchPriority[branchIndex]
    end)
    
    local nodeNum = 1
    NodeValue.MouseButton1Click:Connect(function()
        nodeNum = nodeNum % 10 + 1
        NodeValue.Text = tostring(nodeNum)
    end)
    
    -- // AUTO FARM CORE LOOP //
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if not LP.Character then return end
                
                -- Auto Merchant
                if autoMerchantState and keycardBuy then
                    TweenTo(Locations.Merchant, 70)
                    task.wait(1)
                end
                
                -- Auto Bank
                local bank = Workspace:FindFirstChild("Banks")
                if bank and bank:GetAttribute("Open") then
                    TweenTo(Locations.Bank.Roof, 100)
                    task.wait(1)
                    TweenTo(Locations.Bank.Vault, 60)
                    task.wait(12)
                    TweenTo(Locations.Bank.Escape, 80)
                end
                
                -- Auto Jewelry
                local jewelry = Workspace:FindFirstChild("Jewelrys")
                if jewelry and jewelry:GetAttribute("Open") then
                    TweenTo(Locations.Jewelry.Roof, 100)
                    task.wait(1)
                    TweenTo(Locations.Jewelry.Boxes, 60)
                    task.wait(10)
                    TweenTo(Locations.Jewelry.TurnIn, 120)
                end
            end)
        end
    end)
    
    -- Keep walk speed set
    task.spawn(function()
        while task.wait(0.3) do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
            end
        end
    end)
end