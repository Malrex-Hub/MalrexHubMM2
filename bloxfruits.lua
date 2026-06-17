-- ╔══════════════════════════════════════════════════════════╗
-- ║          BLOX FRUITS SCRIPT | KEYLESS | DELTA            ║
-- ║        Mobile Support | Anti-Rat | v1.0                  ║
-- ╚══════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════
--  ANTI-EXECUTOR (Xeno & Solara = Rats)
-- ══════════════════════════════════════════
local function GetExecutorName()
    if identifyexecutor then return identifyexecutor()
    elseif getexecutorname then return getexecutorname()
    elseif EXECUTOR_NAME then return EXECUTOR_NAME
    else return "" end
end

local execName = string.lower(GetExecutorName())
local RATS = {"xeno", "solara"}

for _, rat in ipairs(RATS) do
    if string.find(execName, rat) then
        game:GetService("Players").LocalPlayer:Kick(
            "\n⛔ BANNED EXECUTOR DETECTED ⛔\n" ..
            "'" .. GetExecutorName() .. "' is a rat executor.\n" ..
            "Please use Delta, Hydrogen, or Fluxus."
        )
        return
    end
end

-- ══════════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════════
local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local TweenService        = game:GetService("TweenService")
local UserInputService    = game:GetService("UserInputService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local HttpService         = game:GetService("HttpService")
local CoreGui             = game:GetService("CoreGui")
local Workspace           = game:GetService("Workspace")

-- ══════════════════════════════════════════
--  PLAYER & CHARACTER
-- ══════════════════════════════════════════
local LocalPlayer   = Players.LocalPlayer
local Character     = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid      = Character:WaitForChild("Humanoid")
local HumanoidRP    = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character   = char
    Humanoid    = char:WaitForChild("Humanoid")
    HumanoidRP  = char:WaitForChild("HumanoidRootPart")
end)

-- ══════════════════════════════════════════
--  BLOX FRUITS REMOTES
-- ══════════════════════════════════════════
local function SafeWaitForChild(parent, name, timeout)
    timeout = timeout or 10
    return parent:WaitForChild(name, timeout)
end

local RS = SafeWaitForChild(ReplicatedStorage, "Remotes", 15)

local Remotes = {
    Fruit_Hit   = RS and RS:FindFirstChild("Fruit_Hit"),
    Sword_Hit   = RS and RS:FindFirstChild("Sword_Hit"),
    Gun_Hit     = RS and RS:FindFirstChild("Gun_Hit"),
    UpdateStat  = RS and RS:FindFirstChild("UpdateStat"),
    BuyFruit    = RS and RS:FindFirstChild("BuyFruit"),
    EatFruit    = RS and RS:FindFirstChild("EatFruit"),
    Teleport    = RS and RS:FindFirstChild("Teleport"),
    SelectQuest = RS and RS:FindFirstChild("SelectQuest"),
    StartRaid   = RS and RS:FindFirstChild("StartRaid"),
}

-- ══════════════════════════════════════════
--  UTILITY FUNCTIONS
-- ══════════════════════════════════════════
local function Tween(obj, props, time, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(time or 0.3, style, direction), props):Play()
end

local function CreateInstance(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    inst.Parent = parent
    return inst
end

local function RoundedFrame(props, parent)
    local frame = CreateInstance("Frame", props, parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, props.CornerRadius or 10)
    corner.Parent = frame
    return frame
end

local function MakeLabel(props, parent)
    local lbl = CreateInstance("TextLabel", props, parent)
    lbl.BackgroundTransparency = 1
    lbl.Font = props.Font or Enum.Font.GothamBold
    lbl.TextWrapped = true
    return lbl
end

local function MakeButton(props, parent)
    local btn = CreateInstance("TextButton", props, parent)
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)
    btn.AutoButtonColor = false
    btn.Font = props.Font or Enum.Font.GothamBold
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = props.HoverColor or Color3.fromRGB(90,90,210)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = props.BackgroundColor3}, 0.15)
    end)
    btn.MouseButton1Down:Connect(function()
        Tween(btn, {Size = UDim2.new(
            props.Size.X.Scale, props.Size.X.Offset - 4,
            props.Size.Y.Scale, props.Size.Y.Offset - 4)}, 0.1)
    end)
    btn.MouseButton1Up:Connect(function()
        Tween(btn, {Size = props.Size}, 0.1)
    end)
    return btn
end

local function MakeToggle(parent, labelText, defaultState, callback)
    local frame = RoundedFrame({
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(30, 30, 50),
        CornerRadius = 8,
    }, parent)
    MakeLabel({
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = labelText,
        TextColor3 = Color3.fromRGB(220, 220, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)
    local togBg = RoundedFrame({
        Size = UDim2.new(0, 44, 0, 24),
        Position = UDim2.new(1, -54, 0.5, -12),
        BackgroundColor3 = defaultState and Color3.fromRGB(100,80,255) or Color3.fromRGB(60,60,80),
        CornerRadius = 12,
    }, frame)
    local knob = RoundedFrame({
        Size = UDim2.new(0, 18, 0, 18),
        Position = defaultState and UDim2.new(0,22,0,3) or UDim2.new(0,3,0,3),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        CornerRadius = 9,
    }, togBg)
    local state = defaultState
    togBg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            state = not state
            Tween(togBg, {BackgroundColor3 = state and Color3.fromRGB(100,80,255) or Color3.fromRGB(60,60,80)}, 0.2)
            Tween(knob, {Position = state and UDim2.new(0,22,0,3) or UDim2.new(0,3,0,3)}, 0.2)
            if callback then callback(state) end
        end
    end)
    return frame, function() return state end
end

local function MakeSlider(parent, labelText, min, max, default, callback)
    local frame = RoundedFrame({
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Color3.fromRGB(30, 30, 50),
        CornerRadius = 8,
    }, parent)
    MakeLabel({
        Size = UDim2.new(0.75, 0, 0, 20), Position = UDim2.new(0, 10, 0, 4),
        Text = labelText, TextColor3 = Color3.fromRGB(220, 220, 255),
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)
    local valLbl = MakeLabel({
        Size = UDim2.new(0.25, -10, 0, 20), Position = UDim2.new(0.75, 0, 0, 4),
        Text = tostring(default), TextColor3 = Color3.fromRGB(140, 120, 255),
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right,
    }, frame)
    local track = RoundedFrame({
        Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 34),
        BackgroundColor3 = Color3.fromRGB(50, 50, 75), CornerRadius = 3,
    }, frame)
    local fill = RoundedFrame({
        Size = UDim2.new((default-min)/(max-min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(100, 80, 255), CornerRadius = 3,
    }, track)
    local knob = RoundedFrame({
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), CornerRadius = 7,
    }, track)
    local dragging = false
    local function UpdateSlider(x)
        local ratio = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min) * ratio)
        valLbl.Text = tostring(val)
        Tween(fill,  {Size = UDim2.new(ratio, 0, 1, 0)}, 0.05)
        Tween(knob, {Position = UDim2.new(ratio, -7, 0.5, -7)}, 0.05)
        if callback then callback(val) end
    end
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; UpdateSlider(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return frame
end

-- ══════════════════════════════════════════
--  SCREEN GUI (Delta Compatible)
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BFScript_v1"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

if gethui then ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui); ScreenGui.Parent = CoreGui
elseif not RunService:IsStudio() then ScreenGui.Parent = CoreGui
else ScreenGui.Parent = LocalPlayer.PlayerGui end

-- ══════════════════════════════════════════
--  LOADING SCREEN
-- ══════════════════════════════════════════
local LoadBG = RoundedFrame({
    Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.fromRGB(5,5,15), ZIndex = 100, CornerRadius = 0,
}, ScreenGui)

local LoadCard = RoundedFrame({
    Size = UDim2.new(0,300,0,220), Position = UDim2.new(0.5,-150,0.5,-110),
    BackgroundColor3 = Color3.fromRGB(15,15,30), ZIndex = 101, CornerRadius = 16,
}, LoadBG)
CreateInstance("UIStroke", {Color=Color3.fromRGB(80,60,200),Thickness=1.5}, LoadCard)

MakeLabel({Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,18),
    Text="BLOX FRUITS",TextColor3=Color3.fromRGB(255,255,255),TextSize=26,
    Font=Enum.Font.GothamBlack,ZIndex=102}, LoadCard)

MakeLabel({Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,54),
    Text="Script Hub  •  Keyless",TextColor3=Color3.fromRGB(140,120,255),
    TextSize=14,Font=Enum.Font.Gotham,ZIndex=102}, LoadCard)

local LoadBar = RoundedFrame({
    Size=UDim2.new(0,240,0,8),Position=UDim2.new(0,30,0,110),
    BackgroundColor3=Color3.fromRGB(30,30,55),ZIndex=102,CornerRadius=4}, LoadCard)
local LoadFill = RoundedFrame({
    Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.fromRGB(100,80,255),ZIndex=103,CornerRadius=4}, LoadBar)
local LoadStatus = MakeLabel({
    Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,130),Text="Initializing...",
    TextColor3=Color3.fromRGB(160,155,200),TextSize=12,Font=Enum.Font.Gotham,ZIndex=102}, LoadCard)
MakeLabel({Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,-28),
    Text="v1.0  •  Delta Supported  •  Keyless",
    TextColor3=Color3.fromRGB(80,75,120),TextSize=11,Font=Enum.Font.Gotham,ZIndex=102}, LoadCard)

for _, step in ipairs({
    {0.15,"Checking executor..."},{0.30,"Loading services..."},
    {0.50,"Fetching player data..."},{0.70,"Loading remotes..."},
    {0.85,"Building UI..."},{1.00,"Done!"}}) do
    task.wait(0.35)
    LoadStatus.Text = step[2]
    Tween(LoadFill, {Size=UDim2.new(step[1],0,1,0)}, 0.3)
end
task.wait(0.4)
Tween(LoadBG, {BackgroundTransparency=1}, 0.5)
Tween(LoadCard, {BackgroundTransparency=1}, 0.5)
task.wait(0.5)
LoadBG:Destroy()

-- ══════════════════════════════════════════
--  MAIN UI (360 x 460)
-- ══════════════════════════════════════════
local C = {
    BG=Color3.fromRGB(10,10,22), Panel=Color3.fromRGB(16,16,34),
    Card=Color3.fromRGB(22,22,44), Accent=Color3.fromRGB(100,80,255),
    AccentH=Color3.fromRGB(120,100,255), Text=Color3.fromRGB(230,228,255),
    Sub=Color3.fromRGB(140,135,200), Border=Color3.fromRGB(45,40,90),
    Red=Color3.fromRGB(220,60,80), Green=Color3.fromRGB(60,200,100),
}

local MainFrame = RoundedFrame({
    Name="MainFrame",Size=UDim2.new(0,360,0,460),
    Position=UDim2.new(0.5,-180,0.5,-230),
    BackgroundColor3=C.BG,CornerRadius=14}, ScreenGui)
CreateInstance("UIStroke",{Color=C.Border,Thickness=1.5},MainFrame)

-- Dragging
local dragging2,dragStart2,startPos2
local function onDragStart(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then
        dragging2=true; dragStart2=inp.Position; startPos2=MainFrame.Position
    end
end
UserInputService.InputChanged:Connect(function(inp)
    if dragging2 and (inp.UserInputType==Enum.UserInputType.MouseMovement
    or inp.UserInputType==Enum.UserInputType.Touch) then
        local d=inp.Position-dragStart2
        MainFrame.Position=UDim2.new(startPos2.X.Scale,startPos2.X.Offset+d.X,
                                     startPos2.Y.Scale,startPos2.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then dragging2=false end
end)

-- Title Bar
local TBar=RoundedFrame({Size=UDim2.new(1,0,0,46),BackgroundColor3=C.Panel,CornerRadius=14},MainFrame)
RoundedFrame({Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.Panel,CornerRadius=0},TBar)
MakeLabel({Size=UDim2.new(1,-90,1,0),Position=UDim2.new(0,14,0,0),
    Text="🍍 Blox Fruits Hub",TextColor3=C.Text,TextSize=15,
    Font=Enum.Font.GothamBlack,TextXAlignment=Enum.TextXAlignment.Left},TBar)
TBar.InputBegan:Connect(onDragStart)

local CloseBtn=MakeButton({Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,-34,0.5,-13),
    BackgroundColor3=C.Red,HoverColor=Color3.fromRGB(255,80,100),
    Text="✕",TextColor3=Color3.fromRGB(255,255,255),TextSize=13,Font=Enum.Font.GothamBold},TBar)
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In)
    task.wait(0.3); ScreenGui:Destroy()
end)

local MinBtn=MakeButton({Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,-66,0.5,-13),
    BackgroundColor3=Color3.fromRGB(230,160,30),HoverColor=Color3.fromRGB(255,190,50),
    Text="–",TextColor3=Color3.fromRGB(255,255,255),TextSize=15,Font=Enum.Font.GothamBold},TBar)
local minimized=false
MinBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    Tween(MainFrame,{Size=minimized and UDim2.new(0,360,0,46) or UDim2.new(0,360,0,460)},0.25)
end)

-- Profile Card
local PCard=RoundedFrame({Size=UDim2.new(1,-20,0,78),Position=UDim2.new(0,10,0,54),
    BackgroundColor3=C.Card,CornerRadius=12},MainFrame)
CreateInstance("UIStroke",{Color=C.Border,Thickness=1},PCard)

local AvatarImg=CreateInstance("ImageLabel",{
    Size=UDim2.new(0,54,0,54),Position=UDim2.new(0,12,0.5,-27),
    BackgroundColor3=C.Accent,
    Image="https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png",
    ScaleType=Enum.ScaleType.Fit},PCard)
CreateInstance("UICorner",{CornerRadius=UDim.new(0.5,0)},AvatarImg)
CreateInstance("UIStroke",{Color=C.Accent,Thickness=2},AvatarImg)

MakeLabel({Size=UDim2.new(1,-82,0,22),Position=UDim2.new(0,76,0,12),
    Text=LocalPlayer.DisplayName,TextColor3=C.Text,TextSize=15,
    Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},PCard)
MakeLabel({Size=UDim2.new(1,-82,0,18),Position=UDim2.new(0,76,0,34),
    Text="@"..LocalPlayer.Name,TextColor3=C.Sub,TextSize=12,
    Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},PCard)
MakeLabel({Size=UDim2.new(1,-82,0,18),Position=UDim2.new(0,76,0,52),
    Text="ID: "..LocalPlayer.UserId,TextColor3=Color3.fromRGB(100,95,160),TextSize=11,
    Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},PCard)

-- Tabs
local tabs={"Player","Combat","Teleport","Fruit","Settings"}
local tabColors={Player=C.Accent,Combat=Color3.fromRGB(220,60,80),
    Teleport=Color3.fromRGB(50,190,230),Fruit=Color3.fromRGB(230,160,30),
    Settings=Color3.fromRGB(80,200,130)}
local TabBar2=RoundedFrame({Size=UDim2.new(1,-20,0,34),Position=UDim2.new(0,10,0,140),BackgroundColor3=C.Panel,CornerRadius=10},MainFrame)
local TL=Instance.new("UIListLayout")
TL.FillDirection=Enum.FillDirection.Horizontal
TL.HorizontalAlignment=Enum.HorizontalAlignment.Center
TL.VerticalAlignment=Enum.VerticalAlignment.Center
TL.Padding=UDim.new(0,2); TL.Parent=TabBar2

local ContentArea2=RoundedFrame({Size=UDim2.new(1,-20,0,258),Position=UDim2.new(0,10,0,182),BackgroundColor3=C.Panel,CornerRadius=10},MainFrame)
local CS=Instance.new("ScrollingFrame")
CS.Size=UDim2.new(1,0,1,0); CS.BackgroundTransparency=1
CS.ScrollBarThickness=3; CS.ScrollBarImageColor3=C.Accent
CS.CanvasSize=UDim2.new(0,0,0,0); CS.AutomaticCanvasSize=Enum.AutomaticSize.Y
CS.Parent=ContentArea2
local LL=Instance.new("UIListLayout")
LL.Padding=UDim.new(0,6); LL.FillDirection=Enum.FillDirection.Vertical
LL.SortOrder=Enum.SortOrder.LayoutOrder; LL.Parent=CS
local CP=Instance.new("UIPadding")
CP.PaddingLeft=UDim.new(0,8); CP.PaddingRight=UDim.new(0,8)
CP.PaddingTop=UDim.new(0,8); CP.PaddingBottom=UDim.new(0,8); CP.Parent=CS

local Features2={InfJump=false,NoClip=false,SpeedHack=false,AutoFarm=false,
    ESPEnabled=false,AimLock=false,WalkSpeed=16,JumpPower=50}

local function ClearContent2()
    for _,c in ipairs(CS:GetChildren()) do
        if c:IsA("Frame") and c.Name=="FP" then c:Destroy() end
    end
end

local function FP(props, parent)
    local f=RoundedFrame(props, parent or CS)
    f.Name="FP"; return f
end

local function BuildPlayerPage2()
    ClearContent2()
    for i,t in ipairs({{"Infinite Jump","InfJump"},{"No Clip","NoClip"},{"Speed Hack","SpeedHack"}}) do
        local f=MakeToggle(CS,t[1],Features2[t[2]],function(v) Features2[t[2]]=v end)
        f.Name="FP"; f.LayoutOrder=i
    end
    local sf=MakeSlider(CS,"Walk Speed",16,500,Features2.WalkSpeed,function(v)
        Features2.WalkSpeed=v; if Humanoid then Humanoid.WalkSpeed=v end
    end); sf.Name="FP"; sf.LayoutOrder=10
    local jf=MakeSlider(CS,"Jump Power",50,500,Features2.JumpPower,function(v)
        Features2.JumpPower=v; if Humanoid then Humanoid.JumpPower=v end
    end); jf.Name="FP"; jf.LayoutOrder=11
    local bb=MakeButton({Name="FP",LayoutOrder=12,Size=UDim2.new(1,0,0,38),
        BackgroundColor3=C.Accent,HoverColor=C.AccentH,Text="Bring All Mobs",
        TextColor3=Color3.fromRGB(255,255,255),TextSize=13},CS)
    bb.MouseButton1Click:Connect(function()
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v~=Character then
                local root=v:FindFirstChild("HumanoidRootPart")
                if root and HumanoidRP then
                    root.CFrame=HumanoidRP.CFrame+Vector3.new(math.random(-5,5),0,math.random(-5,5))
                end
            end
        end
    end)
end

local function BuildCombatPage2()
    ClearContent2()
    for i,t in ipairs({{"Aim Lock","AimLock"},{"Auto Combo","AutoFarm"}}) do
        local f=MakeToggle(CS,t[1],Features2[t[2]],function(v) Features2[t[2]]=v end)
        f.Name="FP"; f.LayoutOrder=i
    end
    local hb=MakeButton({Name="FP",LayoutOrder=5,Size=UDim2.new(1,0,0,38),
        BackgroundColor3=C.Red,HoverColor=Color3.fromRGB(255,90,110),
        Text="Kill Aura (Nearest NPC)",TextColor3=Color3.fromRGB(255,255,255),TextSize=13},CS)
    hb.MouseButton1Click:Connect(function()
        local nearest,nearDist=nil,math.huge
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Humanoid") and v.Health>0 and v.Parent~=Character then
                local root=v.Parent:FindFirstChild("HumanoidRootPart")
                if root and HumanoidRP then
                    local dist=(root.Position-HumanoidRP.Position).Magnitude
                    if dist<nearDist then nearDist=dist; nearest=v.Parent end
                end
            end
        end
        if nearest and Remotes.Fruit_Hit then Remotes.Fruit_Hit:FireServer(nearest) end
    end)
end

local TpLocs={
    {n="Starter Island",p=Vector3.new(977.8,15.4,1570.1)},
    {n="Marine Ford",p=Vector3.new(-1171.5,5.5,-338.1)},
    {n="Jungle Island",p=Vector3.new(-1600,5,200)},
    {n="Pirate Village",p=Vector3.new(-1329.7,12,237)},
    {n="Middle Town",p=Vector3.new(371.9,75.9,-2887.6)},
    {n="Flower Hill",p=Vector3.new(-1799,154,-3359)},
    {n="Skylands",p=Vector3.new(-4681,872,-595)},
    {n="Hot & Cold",p=Vector3.new(1161.4,45.5,-3220)},
    {n="Sea of Treats",p=Vector3.new(-1745.8,18,-5296.7)},
}

local function BuildTeleportPage2()
    ClearContent2()
    for i,loc in ipairs(TpLocs) do
        local btn=MakeButton({Name="FP",LayoutOrder=i,Size=UDim2.new(1,0,0,36),
            BackgroundColor3=Color3.fromRGB(28,28,55),HoverColor=Color3.fromRGB(50,50,90),
            Text="✈  "..loc.n,TextColor3=Color3.fromRGB(180,175,255),TextSize=12},CS)
        btn.MouseButton1Click:Connect(function()
            if HumanoidRP then HumanoidRP.CFrame=CFrame.new(loc.p) end
        end)
    end
end

local function BuildFruitPage2()
    ClearContent2()
    local f=MakeToggle(CS,"Auto Eat Fruit",Features2.AutoFarm,function(v) Features2.AutoFarm=v end)
    f.Name="FP"; f.LayoutOrder=1
    local fruits={"Flame","Ice","Quake","Light","Magma","Rumble","Gravity","Dough","Shadow","Control"}
    for i,fruit in ipairs(fruits) do
        local btn=MakeButton({Name="FP",LayoutOrder=i+1,Size=UDim2.new(1,0,0,34),
            BackgroundColor3=Color3.fromRGB(28,28,55),HoverColor=Color3.fromRGB(50,50,90),
            Text="🍊  "..fruit,TextColor3=Color3.fromRGB(230,160,30),TextSize=12},CS)
        btn.MouseButton1Click:Connect(function()
            if Remotes.BuyFruit then Remotes.BuyFruit:FireServer(fruit) end
        end)
    end
end

local function BuildSettingsPage2()
    ClearContent2()
    local ef=MakeToggle(CS,"ESP (Enemies)",Features2.ESPEnabled,function(v) Features2.ESPEnabled=v end)
    ef.Name="FP"; ef.LayoutOrder=1
    local db=MakeButton({Name="FP",LayoutOrder=2,Size=UDim2.new(1,0,0,38),
        BackgroundColor3=C.Red,HoverColor=Color3.fromRGB(255,80,100),
        Text="Destroy Script",TextColor3=Color3.fromRGB(255,255,255),TextSize=13},CS)
    db.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

local PageBuilders2={Player=BuildPlayerPage2,Combat=BuildCombatPage2,
    Teleport=BuildTeleportPage2,Fruit=BuildFruitPage2,Settings=BuildSettingsPage2}

local tabBtns2={}
for i,tabName in ipairs(tabs) do
    local btn=CreateInstance("TextButton",{
        Size=UDim2.new(0,60,0,28),
        BackgroundColor3=i==1 and tabColors[tabName] or Color3.fromRGB(28,28,50),
        Text=tabName,TextColor3=Color3.fromRGB(255,255,255),TextSize=10,
        Font=Enum.Font.GothamBold,AutoButtonColor=false},TabBar2)
    CreateInstance("UICorner",{CornerRadius=UDim.new(0,7)},btn)
    tabBtns2[tabName]=btn
    btn.MouseButton1Click:Connect(function()
        for name,b in pairs(tabBtns2) do
            Tween(b,{BackgroundColor3=name==tabName and tabColors[tabName] or Color3.fromRGB(28,28,50)},0.15)
        end
        if PageBuilders2[tabName] then PageBuilders2[tabName]() end
    end)
end

BuildPlayerPage2()

-- Game Loops
UserInputService.JumpRequest:Connect(function()
    if Features2.InfJump and Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
RunService.Stepped:Connect(function()
    if Features2.NoClip and Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
end)
RunService.Heartbeat:Connect(function()
    if Features2.SpeedHack and Humanoid then Humanoid.WalkSpeed=Features2.WalkSpeed end
    if Features2.AimLock then
        local nearest,nearDist=nil,math.huge
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character then
                local root=plr.Character:FindFirstChild("HumanoidRootPart")
                local hum=plr.Character:FindFirstChild("Humanoid")
                if root and hum and hum.Health>0 and HumanoidRP then
                    local dist=(root.Position-HumanoidRP.Position).Magnitude
                    if dist<nearDist then nearDist=dist; nearest=root end
                end
            end
        end
        if nearest then
            Workspace.CurrentCamera.CFrame=CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position,nearest.Position)
        end
    end
end)

-- Entrance animation
MainFrame.Size=UDim2.new(0,0,0,0)
MainFrame.Position=UDim2.new(0.5,0,0.5,0)
Tween(MainFrame,{Size=UDim2.new(0,360,0,460),Position=UDim2.new(0.5,-180,0.5,-230)},0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

-- Notification
task.spawn(function()
    task.wait(0.5)
    local notif=RoundedFrame({
        Size=UDim2.new(0,240,0,50),Position=UDim2.new(0.5,-120,0,-60),
        BackgroundColor3=C.Accent,CornerRadius=10},ScreenGui)
    MakeLabel({Size=UDim2.new(1,0,1,0),Text="✅ Script Loaded! Keyless & Ready.",
        TextColor3=Color3.fromRGB(255,255,255),TextSize=12,Font=Enum.Font.GothamBold},notif)
    Tween(notif,{Position=UDim2.new(0.5,-120,0,10)},0.4,Enum.EasingStyle.Back)
    task.wait(2.5)
    Tween(notif,{Position=UDim2.new(0.5,-120,0,-60)},0.3)
    task.wait(0.4); notif:Destroy()
end)

print("[BF Script] Loaded successfully for "..LocalPlayer.Name)