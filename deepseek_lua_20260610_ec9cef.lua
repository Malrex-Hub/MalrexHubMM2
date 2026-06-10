-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // FUCK THIS SHIT I'M REMAKING IT EXACTLY LIKE THE PIC 🥀

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

print("███████╗██╗░░░░░██╗████████╗███████╗  ██╗░░██╗██╗░░░██╗██████╗░")
print("██╔════╝██║░░░░░██║╚══██╔══╝██╔════╝  ██║░░██║██║░░░██║██╔══██╗")
print("█████╗░░██║░░░░░██║░░░██║░░░█████╗░░  ███████║██║░░░██║██████╦╝")
print("██╔══╝░░██║░░░░░██║░░░██║░░░██╔══╝░░  ██╔══██║██║░░░██║██╔══██╗")
print("███████╗███████╗██║░░░██║░░░███████╗  ██║░░██║╚██████╔╝██████╦╝")
print("╚══════╝╚══════╝╚═╝░░░╚═╝░░░╚══════╝  ╚═╝░░╚═╝░╚═════╝░╚═════╝░")
print("ELITE HUB v1.0.0 - LOADED YOU BITCH - JOIN DISCORD BITCH ASS 🥀")

-- // COLORS
local Green = Color3.fromRGB(46, 204, 113)
local DarkBg = Color3.fromRGB(8, 8, 12)
local CardBg = Color3.fromRGB(15, 15, 22)

-- // FPS AND MS COUNTER (REAL SHIT)
local fps = 60
local ping = 0
local lastTime = tick()
local frameCount = 0
local titleLabel = nil

-- Get ping from Stats
local function GetPing()
    local stats = Stats:FindFirstChild("Network")
    if stats then
        local pingStat = stats:FindFirstChild("Ping")
        if pingStat then
            return math.floor(pingStat:GetValue())
        end
    end
    return 0
end

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
        ping = GetPing()
        if titleLabel then
            titleLabel.Text = "ELITE HUB v1.0.0 | " .. fps .. " FPS | " .. ping .. " MS"
        end
    end
end)

-- // ANTI AFK
LP.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(0.3)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

-- // CREATE UI - EXACT SIZE AND LAYOUT LIKE PIC
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME - SMALL AND CLEAN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 400)
Main.Position = UDim2.new(0.5, -140, 0.5, -200)
Main.BackgroundColor3 = DarkBg
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundColor3 = CardBg
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ELITE HUB v1.0.0 | 60 FPS | 0 MS"
titleLabel.TextColor3 = Green
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 10
titleLabel.Parent = TopBar

-- CLOSE BUTTON
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -25, 0.5, -10)
Close.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 12
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- SCROLLING FRAME
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -38)
Scroll.Position = UDim2.new(0, 5, 0, 33)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- // FUNCTION TO CREATE SECTIONS (EXACT MATCH TO PIC)
local function MakeSection(title, subtitle)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 42)
    section.BackgroundColor3 = CardBg
    section.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -12, 0, 18)
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Green
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -12, 0, 14)
    subLabel.Position = UDim2.new(0, 8, 0, 22)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = subtitle
    subLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 9
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = section
    
    return section
end

-- // FUNCTION TO MAKE ROWS (TRAITS, RACE, CLAN ETC)
local function MakeRow(parent, y, label, value)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 24)
    row.Position = UDim2.new(0, 5, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 110, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local val = Instance.new("TextButton")
    val.Size = UDim2.new(0, 80, 1, 0)
    val.Position = UDim2.new(0, 115, 0, 0)
    val.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    val.Text = value
    val.TextColor3 = Green
    val.Font = Enum.Font.GothamBold
    val.TextSize = 10
    val.Parent = row
    
    local valCorner = Instance.new("UICorner")
    valCorner.CornerRadius = UDim.new(0, 4)
    valCorner.Parent = val
    
    return val
end

-- // FUNCTION TO MAKE TOGGLE BUTTONS
local function MakeToggle(parent, y, text, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -60, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 80, 80)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        Settings[setting] = state
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = state and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        btn.BackgroundColor3 = state and Color3.fromRGB(46, 204, 113, 30) or Color3.fromRGB(35, 35, 45)
    end)
    
    return frame
end

-- // BUILD UI - EXACTLY LIKE THE SCREENSHOT

-- AUTOMATION SECTION
local AutoSection = MakeSection("⚡ AUTOMATION", "Auto rolls, enchants, merchant, and skill tree.")

-- AUTO ROLLS SUBSECTION
local RollsFrame = Instance.new("Frame")
RollsFrame.Size = UDim2.new(1, 0, 0, 160)
RollsFrame.BackgroundColor3 = CardBg
RollsFrame.Parent = Scroll

local RollsCorner = Instance.new("UICorner")
RollsCorner.CornerRadius = UDim.new(0, 6)
RollsCorner.Parent = RollsFrame

local RollsTitle = Instance.new("TextLabel")
RollsTitle.Size = UDim2.new(1, -12, 0, 18)
RollsTitle.Position = UDim2.new(0, 8, 0, 4)
RollsTitle.BackgroundTransparency = 1
RollsTitle.Text = "🎲 AUTO ROLLS"
RollsTitle.TextColor3 = Green
RollsTitle.Font = Enum.Font.GothamBold
RollsTitle.TextSize = 11
RollsTitle.TextXAlignment = Enum.TextXAlignment.Left
RollsTitle.Parent = RollsFrame

local RollsSub = Instance.new("TextLabel")
RollsSub.Size = UDim2.new(1, -12, 0, 14)
RollsSub.Position = UDim2.new(0, 8, 0, 20)
RollsSub.BackgroundTransparency = 1
RollsSub.Text = "Auto roll for desired traits, races, clans, and bloodlines."
RollsSub.TextColor3 = Color3.fromRGB(120, 120, 140)
RollsSub.Font = Enum.Font.Gotham
RollsSub.TextSize = 9
RollsSub.TextXAlignment = Enum.TextXAlignment.Left
RollsSub.Parent = RollsFrame

-- Rows inside Auto Rolls
local targetTraits = MakeRow(RollsFrame, 42, "Target Traits:", "None")
local autoTraits = MakeRow(RollsFrame, 66, "Auto Roll Traits:", "None")
local targetRace = MakeRow(RollsFrame, 90, "Target Race:", "None")
local autoRace = MakeRow(RollsFrame, 114, "Auto Roll Race:", "None")
local targetClan = MakeRow(RollsFrame, 138, "Target Clan:", "None")
local autoClan = MakeRow(RollsFrame, 162, "Auto Roll Clan:", "None")

-- Roll Cooldown row
local cooldownRow = Instance.new("Frame")
cooldownRow.Size = UDim2.new(1, -10, 0, 24)
cooldownRow.Position = UDim2.new(0, 5, 0, 186)
cooldownRow.BackgroundTransparency = 1
cooldownRow.Parent = RollsFrame

local cooldownLabel = Instance.new("TextLabel")
cooldownLabel.Size = UDim2.new(0, 110, 1, 0)
cooldownLabel.BackgroundTransparency = 1
cooldownLabel.Text = "Roll Cooldown (sec):"
cooldownLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
cooldownLabel.Font = Enum.Font.Gotham
cooldownLabel.TextSize = 9
cooldownLabel.TextXAlignment = Enum.TextXAlignment.Left
cooldownLabel.Parent = cooldownRow

local cooldownValue = Instance.new("TextButton")
cooldownValue.Size = UDim2.new(0, 50, 1, 0)
cooldownValue.Position = UDim2.new(0, 115, 0, 0)
cooldownValue.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
cooldownValue.Text = "0.1"
cooldownValue.TextColor3 = Green
cooldownValue.Font = Enum.Font.GothamBold
cooldownValue.TextSize = 9
cooldownValue.Parent = cooldownRow

local cooldownCorner = Instance.new("UICorner")
cooldownCorner.CornerRadius = UDim.new(0, 4)
cooldownCorner.Parent = cooldownValue

-- SKILL TREE SECTION
local SkillFrame = Instance.new("Frame")
SkillFrame.Size = UDim2.new(1, 0, 0, 130)
SkillFrame.BackgroundColor3 = CardBg
SkillFrame.Parent = Scroll

local SkillCorner = Instance.new("UICorner")
SkillCorner.CornerRadius = UDim.new(0, 6)
SkillCorner.Parent = SkillFrame

local SkillTitle = Instance.new("TextLabel")
SkillTitle.Size = UDim2.new(1, -12, 0, 18)
SkillTitle.Position = UDim2.new(0, 8, 0, 4)
SkillTitle.BackgroundTransparency = 1
SkillTitle.Text = "🌳 SKILL TREE"
SkillTitle.TextColor3 = Green
SkillTitle.Font = Enum.Font.GothamBold
SkillTitle.TextSize = 11
SkillTitle.TextXAlignment = Enum.TextXAlignment.Left
SkillTitle.Parent = SkillFrame

local SkillSub = Instance.new("TextLabel")
SkillSub.Size = UDim2.new(1, -12, 0, 14)
SkillSub.Position = UDim2.new(0, 8, 0, 20)
SkillSub.BackgroundTransparency = 1
SkillSub.Text = "Upgrade skill tree nodes. Requires skill points."
SkillSub.TextColor3 = Color3.fromRGB(120, 120, 140)
SkillSub.Font = Enum.Font.Gotham
SkillSub.TextSize = 9
SkillSub.TextXAlignment = Enum.TextXAlignment.Left
SkillSub.Parent = SkillFrame

-- Node Index row
local nodeRow = Instance.new("Frame")
nodeRow.Size = UDim2.new(1, -10, 0, 24)
nodeRow.Position = UDim2.new(0, 5, 0, 42)
nodeRow.BackgroundTransparency = 1
nodeRow.Parent = SkillFrame

local nodeLabel = Instance.new("TextLabel")
nodeLabel.Size = UDim2.new(0, 80, 1, 0)
nodeLabel.BackgroundTransparency = 1
nodeLabel.Text = "Node Index:"
nodeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
nodeLabel.Font = Enum.Font.Gotham
nodeLabel.TextSize = 9
nodeLabel.TextXAlignment = Enum.TextXAlignment.Left
nodeLabel.Parent = nodeRow

local nodeValue = Instance.new("TextButton")
nodeValue.Size = UDim2.new(0, 40, 1, 0)
nodeValue.Position = UDim2.new(0, 85, 0, 0)
nodeValue.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
nodeValue.Text = "1"
nodeValue.TextColor3 = Green
nodeValue.Font = Enum.Font.GothamBold
nodeValue.TextSize = 9
nodeValue.Parent = nodeRow

local nodeCorner = Instance.new("UICorner")
nodeCorner.CornerRadius = UDim.new(0, 4)
nodeCorner.Parent = nodeValue

-- Upgrade Node row
local upgradeRow = Instance.new("Frame")
upgradeRow.Size = UDim2.new(1, -10, 0, 24)
upgradeRow.Position = UDim2.new(0, 5, 0, 66)
upgradeRow.BackgroundTransparency = 1
upgradeRow.Parent = SkillFrame

local upgradeLabel = Instance.new("TextLabel")
upgradeLabel.Size = UDim2.new(0, 80, 1, 0)
upgradeLabel.BackgroundTransparency = 1
upgradeLabel.Text = "Upgrade Node:"
upgradeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
upgradeLabel.Font = Enum.Font.Gotham
upgradeLabel.TextSize = 9
upgradeLabel.TextXAlignment = Enum.TextXAlignment.Left
upgradeLabel.Parent = upgradeRow

local upgradeValue = Instance.new("TextLabel")
upgradeValue.Size = UDim2.new(1, -90, 1, 0)
upgradeValue.Position = UDim2.new(0, 90, 0, 0)
upgradeValue.BackgroundTransparency = 1
upgradeValue.Text = "None"
upgradeValue.TextColor3 = Color3.fromRGB(150, 150, 170)
upgradeValue.Font = Enum.Font.Gotham
upgradeValue.TextSize = 9
upgradeValue.TextXAlignment = Enum.TextXAlignment.Left
upgradeValue.Parent = upgradeRow

-- Auto Upgrade button
local autoUpgradeBtn = Instance.new("TextButton")
autoUpgradeBtn.Size = UDim2.new(1, -10, 0, 28)
autoUpgradeBtn.Position = UDim2.new(0, 5, 0, 94)
autoUpgradeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
autoUpgradeBtn.Text = "Auto Upgrade Nodes"
autoUpgradeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
autoUpgradeBtn.Font = Enum.Font.GothamBold
autoUpgradeBtn.TextSize = 10
autoUpgradeBtn.Parent = SkillFrame

local autoUpgradeCorner = Instance.new("UICorner")
autoUpgradeCorner.CornerRadius = UDim.new(0, 4)
autoUpgradeCorner.Parent = autoUpgradeBtn

-- MERCHANT SECTION
local MerchantFrame = Instance.new("Frame")
MerchantFrame.Size = UDim2.new(1, 0, 0, 100)
MerchantFrame.BackgroundColor3 = CardBg
MerchantFrame.Parent = Scroll

local MerchantCorner = Instance.new("UICorner")
MerchantCorner.CornerRadius = UDim.new(0, 6)
MerchantCorner.Parent = MerchantFrame

local MerchantTitle = Instance.new("TextLabel")
MerchantTitle.Size = UDim2.new(1, -12, 0, 18)
MerchantTitle.Position = UDim2.new(0, 8, 0, 4)
MerchantTitle.BackgroundTransparency = 1
MerchantTitle.Text = "💰 MERCHANT"
MerchantTitle.TextColor3 = Green
MerchantTitle.Font = Enum.Font.GothamBold
MerchantTitle.TextSize = 11
MerchantTitle.TextXAlignment = Enum.TextXAlignment.Left
MerchantTitle.Parent = MerchantFrame

local MerchantSub = Instance.new("TextLabel")
MerchantSub.Size = UDim2.new(1, -12, 0, 14)
MerchantSub.Position = UDim2.new(0, 8, 0, 20)
MerchantSub.BackgroundTransparency = 1
MerchantSub.Text = "Automatically visits the Merchant NPC and buys items."
MerchantSub.TextColor3 = Color3.fromRGB(120, 120, 140)
MerchantSub.Font = Enum.Font.Gotham
MerchantSub.TextSize = 9
MerchantSub.TextXAlignment = Enum.TextXAlignment.Left
MerchantSub.Parent = MerchantFrame

-- Auto Buy button
local autoBuyBtn = Instance.new("TextButton")
autoBuyBtn.Size = UDim2.new(1, -10, 0, 28)
autoBuyBtn.Position = UDim2.new(0, 5, 0, 42)
autoBuyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
autoBuyBtn.Text = "Auto Buy from Merchant:"
autoBuyBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
autoBuyBtn.Font = Enum.Font.GothamBold
autoBuyBtn.TextSize = 10
autoBuyBtn.Parent = MerchantFrame

local autoBuyCorner = Instance.new("UICorner")
autoBuyCorner.CornerRadius = UDim.new(0, 4)
autoBuyCorner.Parent = autoBuyBtn

local teleportText = Instance.new("TextLabel")
teleportText.Size = UDim2.new(1, -10, 0, 18)
teleportText.Position = UDim2.new(0, 5, 0, 74)
teleportText.BackgroundTransparency = 1
teleportText.Text = "Teleports to merchant each cycle"
teleportText.TextColor3 = Color3.fromRGB(120, 120, 140)
teleportText.Font = Enum.Font.Gotham
teleportText.TextSize = 9
teleportText.TextXAlignment = Enum.TextXAlignment.Left
teleportText.Parent = MerchantFrame

-- COMBAT SECTION
local CombatFrame = MakeSection("⚔️ COMBAT", "Kill those motherfuckers")
MakeToggle(CombatFrame, 42, "💀 KILL AURA", "KillAura")
MakeToggle(CombatFrame, 78, "👮 AUTO FARM COPS", "AutoFarmCops")
MakeToggle(CombatFrame, 114, "🔒 AUTO FARM PRISONERS", "AutoFarmPrisoners")
MakeToggle(CombatFrame, 150, "⚡ AUTO ATTACK", "AutoAttack")

-- ROBBERY SECTION
local RobFrame = MakeSection("💰 ROBBERY", "Steal that fucking shit")
MakeToggle(RobFrame, 42, "🏦 AUTO BANK", "AutoBank")
MakeToggle(RobFrame, 78, "💎 AUTO JEWELRY", "AutoJewelry")
MakeToggle(RobFrame, 114, "🏛️ AUTO MUSEUM", "AutoMuseum")

-- MOVEMENT SECTION
local MoveFrame = MakeSection("🌀 MOVEMENT", "Go fast as fuck")
MakeToggle(MoveFrame, 42, "🕊️ FLY MODE", "Fly")
MakeToggle(MoveFrame, 78, "🌀 NOCLIP", "Noclip")
MakeToggle(MoveFrame, 114, "🏃 AUTO SPRINT", "AutoSprint")

-- VISUALS SECTION
local VisFrame = MakeSection("👁️ VISUALS", "See their bitch ass")
MakeToggle(VisFrame, 42, "👻 ESP WALLHACK", "ESP")
MakeToggle(VisFrame, 78, "☀️ FULLBRIGHT", "FullBright")
MakeToggle(VisFrame, 114, "🎨 TEAM COLORS", "TeamColors")

-- UTILITY SECTION
local UtilFrame = MakeSection("🛠️ UTILITY", "Quality of life shit")
MakeToggle(UtilFrame, 42, "🍩 AUTO DONUT", "AutoDonut")
MakeToggle(UtilFrame, 78, "💳 AUTO KEYCARD", "AutoKeycard")
MakeToggle(UtilFrame, 114, "🚔 AUTO TEAM", "AutoTeam")
MakeToggle(UtilFrame, 150, "🛡️ ANTI RAGDOLL", "AntiRagdoll")

-- DISCORD SECTION
local DiscordFrame = Instance.new("Frame")
DiscordFrame.Size = UDim2.new(1, 0, 0, 40)
DiscordFrame.BackgroundColor3 = CardBg
DiscordFrame.Parent = Scroll

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 6)
DiscordCorner.Parent = DiscordFrame

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -10, 0, 28)
DiscordBtn.Position = UDim2.new(0, 5, 0, 6)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "💬 JOIN DISCORD (COPY LINK)"
DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 10
DiscordBtn.Parent = DiscordFrame

local DiscordBtnCorner = Instance.new("UICorner")
DiscordBtnCorner.CornerRadius = UDim.new(0, 4)
DiscordBtnCorner.Parent = DiscordBtn

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "DISCORD LINK COPIED YOU BITCH 🥀",
        Duration = 2
    })
end)

-- UPDATE CANVAS SIZE
local function UpdateCanvas()
    local total = 0
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("Frame") and v ~= Layout then
            total = total + v.Size.Y.Offset + 6
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, total + 20)
end

task.wait(0.1)
UpdateCanvas()

-- // BUTTON FUNCTIONALITY FOR SPECIAL TOGGLES
for _, btn in pairs(Scroll:GetDescendants()) do
    if btn:IsA("TextButton") and btn.Parent and btn.Parent:IsA("Frame") then
        local label = btn.Parent:FindFirstChildWhichIsA("TextLabel")
        if label and label.Text == "🕊️ FLY MODE" then
            local orig = btn.MouseButton1Click
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                ToggleFly()
            end)
        end
        if label and label.Text == "🌀 NOCLIP" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                ToggleNoclip()
            end)
        end
        if label and label.Text == "☀️ FULLBRIGHT" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                if Settings.FullBright then
                    Lighting.Brightness = 1
                    Lighting.ClockTime = 8
                    Lighting.GlobalShadows = true
                else
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 14
                    Lighting.GlobalShadows = false
                end
            end)
        end
        if label and label.Text == "👻 ESP WALLHACK" then
            btn.MouseButton1Click:Connect(function()
                task.wait(0.05)
                if Settings.ESP then
                    for _, obj in pairs(espObjects) do
                        pcall(function() obj:Destroy() end)
                    end
                    espObjects = {}
                else
                    UpdateESP()
                end
            end)
        end
    end
end

-- // NOCLIP FUNCTION
local noclipConn = nil
local function ToggleNoclip()
    Settings.Noclip = not Settings.Noclip
    if Settings.Noclip then
        noclipConn = RunService.RenderStepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end

-- // ESP OBJECTS
local espObjects = {}
local function UpdateESP()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and not espObjects[player] then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Settings.TeamColors and (player.Team and player.Team.Name == "Police" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)) or Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.6
                highlight.Parent = player.Character
                espObjects[player] = highlight
            elseif (not player.Character or not Settings.ESP) and espObjects[player] then
                pcall(function() espObjects[player]:Destroy() end)
                espObjects[player] = nil
            end
        end
    else
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end

Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(p) 
    if espObjects[p] then pcall(function() espObjects[p]:Destroy() end) end
    espObjects[p] = nil
end)

-- // AUTO FARM LOOPS
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarmCops and LP.Character then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character and player.Team and player.Team.Name == "Police" then
                        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                        local target = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and target then
                            local dist = (hrp.Position - target.Position).Magnitude
                            if dist < 20 then
                                hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 0, 3), target.Position)
                                task.wait(0.05)
                                local punch = ReplicatedStorage:FindFirstChild("Punch")
                                if punch then punch:FireServer(target.Position) end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if Settings.AutoDonut and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum and hum.Health < 80 then
                    local donutShop = CFrame.new(267, 18, -1763)
                    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = donutShop})
                        tween:Play()
                        tween.Completed:Wait()
                        task.wait(1)
                    end
                end
            end
        end)
    end
end)

-- // MOVEMENT LOOP
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                local hum = LP.Character.Humanoid
                if hum.WalkSpeed ~= Settings.WalkSpeed then
                    hum.WalkSpeed = Settings.WalkSpeed
                end
                if Settings.AutoSprint then
                    hum.AutoRotate = true
                end
            end
        end)
    end
end)

-- // FLY FUNCTION
local function ToggleFly()
    Settings.Flying = not Settings.Flying
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if Settings.Flying then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = true end
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
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
                
                if control.Magnitude > 0 then control = control.Unit end
                bg.cframe = CFrame.new(hrp.Position, hrp.Position + control)
                bv.velocity = control * Settings.FlySpeed
            end
            pcall(function() bg:Destroy() end)
            pcall(function() bv:Destroy() end)
            if hum then hum.PlatformStand = false end
        end)
    else
        pcall(function() hrp:FindFirstChild("BodyGyro"):Destroy() end)
        pcall(function() hrp:FindFirstChild("BodyVelocity"):Destroy() end)
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- // STARTUP NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "Loaded you fucking bitch! Join Discord or get fucked! 🥀",
    Duration = 3
})

print("ELITE HUB v1.0.0 FULLY LOADED - GO FUCK SHIT UP 🥀")