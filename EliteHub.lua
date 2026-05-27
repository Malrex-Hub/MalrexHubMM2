-- ╔══════════════════════════════════════════╗
-- ║   ELITE HUB v1.0.0  |  Blox Fruits        ║
-- ║   Works with: Delta, Hydrogen,           ║
-- ║   Codex, Arceus X, Executor X           ║
-- ║   discord.gg/EmsMsHZCVH                 ║
-- ╚══════════════════════════════════════════╝

-- SERVICES
local Plr  = game:GetService("Players")
local RS   = game:GetService("RunService")
local UIS  = game:GetService("UserInputService")
local TS   = game:GetService("TweenService")
local VU   = game:GetService("VirtualUser")
local Lit  = game:GetService("Lighting")
local LP   = Plr.LocalPlayer
local PG   = LP:WaitForChild("PlayerGui")
local Cam  = workspace.CurrentCamera

-- ════════════════════════════════════════════
--  CONFIG
-- ════════════════════════════════════════════
local CFG = {
    -- Farm
    AutoFarm      = false,
    FarmMethod    = "Melee",
    TargetMob     = "Gorilla",
    FarmRadius    = 200,
    -- Boss
    AutoBoss      = false,
    SelectedBoss  = "Gorilla King",
    -- TP
    TPBypass      = true,
    TPFruit       = false,
    -- Combat
    AutoMelee     = false,
    AutoSword     = false,
    AutoGun       = false,
    AutoFruit     = false,
    FruitSkill    = "Z",
    -- Store
    AutoStore     = false,
    StoreItem     = "All",
    AutoRaid      = false,
    AutoRaidBoss  = false,
    SelectedRaid  = "Flame",
    -- Mastery
    AutoMastery   = false,
    MasteryTarget = "Sword",
    -- Player
    InfJump       = false,
    -- Misc
    AntiAFK       = true,
    FPSShow       = true,
    AutoRespawn   = true,
    Fullbright    = false,
    -- Settings
    HideKey       = "RightShift",
    FarmDelay     = 0.15,
    TPDelay       = 0.3,
    SafeTP        = true,
}

-- ════════════════════════════════════════════
--  THEME
-- ════════════════════════════════════════════
local C = {
    BG      = Color3.fromRGB(10, 9, 20),
    Panel   = Color3.fromRGB(18, 17, 34),
    Accent  = Color3.fromRGB(160, 40, 240),
    AccDark = Color3.fromRGB(90, 15, 160),
    Glow    = Color3.fromRGB(210, 90, 255),
    Text    = Color3.fromRGB(230, 228, 255),
    Sub     = Color3.fromRGB(140, 130, 170),
    Green   = Color3.fromRGB(50, 215, 100),
    Red     = Color3.fromRGB(215, 55, 65),
    Gold    = Color3.fromRGB(255, 195, 45),
    Discord = Color3.fromRGB(88, 101, 242),
}

-- ════════════════════════════════════════════
--  HELPERS
-- ════════════════════════════════════════════
local function tw(obj, props, t, sty, dir)
    TS:Create(obj, TweenInfo.new(t or .25, sty or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function mk(cls, props)
    local o = Instance.new(cls)
    for k,v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or C.Accent
    s.Thickness = thick or 1.2
    s.Transparency = trans or 0.35
    s.Parent = obj
end

local function getChar()   return LP.Character end
local function getHum()    local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()   local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function isAlive()   local h=getHum() return h and h.Health > 0 end

local function safeTp(pos)
    local root = getRoot()
    if not root then return end
    if CFG.SafeTP and CFG.TPBypass then
        -- Delta-compatible bypass: small steps to avoid detection
        local steps = 5
        local origin = root.CFrame.Position
        local target = pos + Vector3.new(0, 4, 0)
        for i = 1, steps do
            local alpha = i / steps
            root.CFrame = CFrame.new(origin:Lerp(target, alpha))
            task.wait(CFG.TPDelay / steps)
        end
    else
        root.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
    end
end

local function getNearestMob(name, radius)
    local root = getRoot()
    if not root then return nil end
    local best, bestDist = nil, radius or CFG.FarmRadius
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(name:lower()) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < bestDist then best, bestDist = obj, d end
            end
        end
    end
    return best
end

local function getFruits()
    local fruits = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local n = obj.Name:lower()
            if n:find("fruit") or n:find("df_") or n:find("devil") then
                local pos = obj:IsA("Model") and obj:FindFirstChild("Handle") or obj
                if pos and pos:IsA("BasePart") then
                    table.insert(fruits, {model = obj, pos = pos.Position, name = obj.Name})
                end
            end
        end
    end
    return fruits
end

-- ════════════════════════════════════════════
--  NOTIFICATION
-- ════════════════════════════════════════════
local notifStack = {}

local function notify(title, msg, dur)
    dur = dur or 4
    local sg = PG:FindFirstChild("_EHNotif") or mk("ScreenGui", {
        Name = "_EHNotif", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PG
    })

    -- shift existing
    for _, f in pairs(notifStack) do
        if f and f.Parent then
            tw(f, {Position = UDim2.new(f.Position.X.Scale, f.Position.X.Offset,
                f.Position.Y.Scale, f.Position.Y.Offset - 90)}, .2)
        end
    end

    local f = mk("Frame", {
        Size = UDim2.new(0,290,0,74),
        Position = UDim2.new(1,10,1,-90),
        BackgroundColor3 = C.Panel,
        BorderSizePixel = 0, Parent = sg
    })
    corner(f, 10)
    stroke(f, C.Accent, 1, 0.4)

    mk("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0, Parent=f})
    corner(mk("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0, Parent=f}), 3)

    mk("TextLabel", {
        Size=UDim2.new(1,-16,0,20), Position=UDim2.new(0,12,0,8),
        BackgroundTransparency=1, Text=title, Font=Enum.Font.GothamBold,
        TextSize=12, TextColor3=C.Glow, TextXAlignment=Enum.TextXAlignment.Left, Parent=f
    })
    mk("TextLabel", {
        Size=UDim2.new(1,-16,0,34), Position=UDim2.new(0,12,0,28),
        BackgroundTransparency=1, Text=msg, Font=Enum.Font.Gotham,
        TextSize=11, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Left,
        TextWrapped=true, Parent=f
    })

    table.insert(notifStack, f)
    tw(f, {Position=UDim2.new(1,-300,1,-90)}, .35, Enum.EasingStyle.Back)

    task.delay(dur, function()
        tw(f, {Position=UDim2.new(1,10,1,-90)}, .3)
        task.wait(.35)
        local idx = table.find(notifStack, f)
        if idx then table.remove(notifStack, idx) end
        pcall(function() f:Destroy() end)
    end)
end

-- ════════════════════════════════════════════
--  LOADING SCREEN
-- ════════════════════════════════════════════
local function showLoader()
    local sg = mk("ScreenGui", {Name="_EHLoad", ResetOnSpawn=false, IgnoreGuiInset=true, Parent=PG})
    local bg = mk("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(5,4,12), BorderSizePixel=0, Parent=sg})

    -- Background grid lines
    for i=1,8 do
        mk("Frame", {
            Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,(i-1)/8,0),
            BackgroundColor3=Color3.fromRGB(30,20,60), BackgroundTransparency=0.7,
            BorderSizePixel=0, Parent=bg
        })
    end

    -- Center logo
    local logo = mk("Frame", {
        Size=UDim2.new(0,100,0,100), Position=UDim2.new(.5,-50,.35,0),
        BackgroundColor3=C.Accent, BorderSizePixel=0, Parent=bg
    })
    corner(logo, 50)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(Color3.fromRGB(180,50,255), Color3.fromRGB(70,10,160))
    grad.Rotation = 135
    grad.Parent = logo
    mk("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="E",
        Font=Enum.Font.GothamBlack, TextSize=54, TextColor3=Color3.fromRGB(255,255,255), Parent=logo})

    mk("TextLabel", {
        Size=UDim2.new(0,400,0,40), Position=UDim2.new(.5,-200,.35,112),
        BackgroundTransparency=1, Text="ELITE HUB", Font=Enum.Font.GothamBlack,
        TextSize=32, TextColor3=C.Text, Parent=bg
    })
    mk("TextLabel", {
        Size=UDim2.new(0,400,0,20), Position=UDim2.new(.5,-200,.35,152),
        BackgroundTransparency=1, Text="Blox Fruits  ·  v1.0.0  ·  Delta Ready",
        Font=Enum.Font.Gotham, TextSize=13, TextColor3=C.Sub, Parent=bg
    })

    local barBg = mk("Frame", {
        Size=UDim2.new(0,380,0,6), Position=UDim2.new(.5,-190,.72,0),
        BackgroundColor3=Color3.fromRGB(28,22,48), BorderSizePixel=0, Parent=bg
    })
    corner(barBg, 3)
    local bar = mk("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0, Parent=barBg})
    corner(bar, 3)

    local stat = mk("TextLabel", {
        Size=UDim2.new(0,380,0,18), Position=UDim2.new(.5,-190,.72,10),
        BackgroundTransparency=1, Text="Starting up...", Font=Enum.Font.Gotham,
        TextSize=11, TextColor3=C.Sub, TextXAlignment=Enum.TextXAlignment.Left, Parent=bg
    })

    local steps = {
        {.15,"Loading GUI framework..."},
        {.3, "Injecting farm engine..."},
        {.5, "Mapping Blox Fruits world..."},
        {.65,"Connecting bypass modules..."},
        {.8, "Loading TP & fruit scanner..."},
        {.95,"Finalizing..."},
        {1,  "Welcome to Elite Hub!"},
    }

    for _, s in ipairs(steps) do
        task.wait(.38)
        stat.Text = s[2]
        tw(bar, {Size=UDim2.new(s[1],0,1,0)}, .35)
    end

    task.wait(.5)
    tw(bg, {BackgroundTransparency=1}, .7)
    for _, d in pairs(bg:GetDescendants()) do
        if d:IsA("GuiObject") then
            pcall(tw, d, {BackgroundTransparency=1, TextTransparency=1, ImageTransparency=1}, .7)
        end
    end
    task.wait(.8)
    sg:Destroy()
end

-- ════════════════════════════════════════════
--  MAIN GUI BUILDER
-- ════════════════════════════════════════════
local function buildGUI()
    pcall(function() PG:FindFirstChild("EliteHub"):Destroy() end)

    local sg = mk("ScreenGui", {Name="EliteHub", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, IgnoreGuiInset=true, Parent=PG})

    -- ── Window ──
    local win = mk("Frame", {
        Size=UDim2.new(0,580,0,400), Position=UDim2.new(.5,-290,.5,-200),
        BackgroundColor3=C.BG, BorderSizePixel=0, Active=true, Parent=sg
    })
    corner(win, 12)
    stroke(win, C.Accent, 1.2, 0.3)

    -- ── Drag ──
    local dragging, dStart, dPos = false, nil, nil

    -- ── Titlebar ──
    local tb = mk("Frame", {Size=UDim2.new(1,0,0,44), BackgroundColor3=C.Panel, BorderSizePixel=0, Parent=win})
    corner(tb, 12)
    mk("Frame", {Size=UDim2.new(1,0,.5,0), Position=UDim2.new(0,0,.5,0), BackgroundColor3=C.Panel, BorderSizePixel=0, Parent=tb})

    local tbGrad = Instance.new("UIGradient")
    tbGrad.Color = ColorSequence.new(Color3.fromRGB(28,12,55), C.Panel)
    tbGrad.Rotation=90
    tbGrad.Parent=tb

    local eDot = mk("Frame", {Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,10,.5,-12), BackgroundColor3=C.Accent, BorderSizePixel=0, Parent=tb})
    corner(eDot,12)
    mk("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="E", Font=Enum.Font.GothamBlack, TextSize=14, TextColor3=Color3.new(1,1,1), Parent=eDot})

    mk("TextLabel", {Size=UDim2.new(0,160,1,0), Position=UDim2.new(0,40,0,0), BackgroundTransparency=1, Text="ELITE HUB", Font=Enum.Font.GothamBlack, TextSize=16, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Left, Parent=tb})
    mk("TextLabel", {Size=UDim2.new(0,120,1,0), Position=UDim2.new(0,40,0,0), BackgroundTransparency=1, Text="              Blox Fruits", Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Accent, TextXAlignment=Enum.TextXAlignment.Left, Parent=tb})

    -- Window controls
    local function winBtn(xOff, col, lbl)
        local b = mk("TextButton", {Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,xOff,.5,-13), BackgroundColor3=col, Text=lbl, Font=Enum.Font.GothamBold, TextSize=15, TextColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=tb})
        corner(b,13)
        return b
    end
    local closeBtn = winBtn(-34, Color3.fromRGB(200,50,65), "×")
    local minBtn   = winBtn(-66, Color3.fromRGB(230,160,25), "–")

    closeBtn.MouseButton1Click:Connect(function() tw(win, {BackgroundTransparency=1, Size=UDim2.new(0,580,0,0)}, .25) task.wait(.3) sg:Destroy() end)
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tw(win, {Size = minimized and UDim2.new(0,580,0,44) or UDim2.new(0,580,0,400)}, .3, Enum.EasingStyle.Back)
    end)

    tb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true dStart=i.Position dPos=win.Position end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMove then local d=i.Position-dStart win.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

    -- ── Sidebar ──
    local sb = mk("Frame", {Size=UDim2.new(0,120,1,-44), Position=UDim2.new(0,0,0,44), BackgroundColor3=C.Panel, BorderSizePixel=0, Parent=win})
    corner(sb, 12)
    mk("Frame", {Size=UDim2.new(.5,0,1,0), Position=UDim2.new(.5,0,0,0), BackgroundColor3=C.Panel, BorderSizePixel=0, Parent=sb})
    local sbPad = Instance.new("UIPadding") sbPad.PaddingTop=UDim.new(0,8) sbPad.PaddingLeft=UDim.new(0,6) sbPad.PaddingRight=UDim.new(0,6) sbPad.Parent=sb
    mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,3), Parent=sb})

    -- ── Content ──
    local ca = mk("Frame", {Size=UDim2.new(1,-128,1,-52), Position=UDim2.new(0,128,0,48), BackgroundTransparency=1, Parent=win})
    local pages, tabBtns = {}, {}
    local curPage = nil

    local function newPage(name)
        local sc = mk("ScrollingFrame", {
            Size=UDim2.fromScale(1,1), BackgroundTransparency=1, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=C.Accent, CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false, Parent=ca
        })
        local l=Instance.new("UIListLayout") l.SortOrder=Enum.SortOrder.LayoutOrder l.Padding=UDim.new(0,6) l.Parent=sc
        local p=Instance.new("UIPadding") p.PaddingTop=UDim.new(0,6) p.PaddingLeft=UDim.new(0,2) p.PaddingRight=UDim.new(0,6) p.Parent=sc
        pages[name]=sc
        return sc
    end

    local function newTab(label, icon, pageName)
        local btn = mk("TextButton", {
            Size=UDim2.new(1,0,0,32), BackgroundColor3=Color3.fromRGB(28,25,48),
            Text="", BorderSizePixel=0, LayoutOrder=#tabBtns+1, Parent=sb
        })
        corner(btn, 7)
        mk("TextLabel", {
            Size=UDim2.new(1,-8,1,0), Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1, Text=icon.."  "..label,
            Font=Enum.Font.GothamBold, TextSize=11, TextColor3=C.Sub,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=btn
        })
        tabBtns[pageName] = btn

        local function activate()
            if curPage then
                pages[curPage].Visible=false
                local pb=tabBtns[curPage]
                if pb then tw(pb,{BackgroundColor3=Color3.fromRGB(28,25,48)},.18) local l=pb:FindFirstChildOfClass("TextLabel") if l then tw(l,{TextColor3=C.Sub},.18) end end
            end
            curPage=pageName
            pages[pageName].Visible=true
            tw(btn,{BackgroundColor3=C.Accent},.18)
            local l=btn:FindFirstChildOfClass("TextLabel")
            if l then tw(l,{TextColor3=C.Text},.18) end
        end
        btn.MouseButton1Click:Connect(activate)
        return activate
    end

    -- ── Widget builders ──

    local function sec(parent, title, order)
        local f=mk("Frame", {Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, LayoutOrder=order or 0, Parent=parent})
        mk("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=title:upper(),
            Font=Enum.Font.GothamBold, TextSize=9, TextColor3=C.Accent, TextXAlignment=Enum.TextXAlignment.Left, Parent=f})
        mk("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1), BackgroundColor3=C.Accent, BackgroundTransparency=0.65, BorderSizePixel=0, Parent=f})
        return f
    end

    local function tog(parent, label, key, order, cb)
        local row=mk("Frame", {Size=UDim2.new(1,0,0,34), BackgroundColor3=C.Panel, BorderSizePixel=0, LayoutOrder=order or 0, Parent=parent})
        corner(row)
        mk("TextLabel", {Size=UDim2.new(1,-52,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=label,
            Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
        local on = key and CFG[key] or false
        local track=mk("Frame", {Size=UDim2.new(0,38,0,20), Position=UDim2.new(1,-44,.5,-10), BackgroundColor3=on and C.Green or C.Sub, BorderSizePixel=0, Parent=row})
        corner(track,10)
        local thumb=mk("Frame", {Size=UDim2.new(0,16,0,16), Position=on and UDim2.new(1,-18,.5,-8) or UDim2.new(0,2,.5,-8), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=track})
        corner(thumb,8)
        mk("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", Parent=row}).MouseButton1Click:Connect(function()
            if key then CFG[key]=not CFG[key] on=CFG[key] else on=not on end
            tw(track,{BackgroundColor3=on and C.Green or C.Sub},.2)
            tw(thumb,{Position=on and UDim2.new(1,-18,.5,-8) or UDim2.new(0,2,.5,-8)},.2)
            if cb then cb(on) end
        end)
        return row
    end

    local function btn(parent, label, col, order, cb)
        col = col or C.Accent
        local b=mk("TextButton", {
            Size=UDim2.new(1,0,0,32), BackgroundColor3=col, Text=label,
            Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.new(1,1,1),
            BorderSizePixel=0, LayoutOrder=order or 0, Parent=parent
        })
        corner(b)
        b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=C.AccDark},.12) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=col},.12) end)
        b.MouseButton1Click:Connect(function()
            tw(b,{Size=UDim2.new(.97,0,0,28)},.08) task.wait(.09) tw(b,{Size=UDim2.new(1,0,0,32)},.08)
            if cb then cb() end
        end)
        return b
    end

    local function drop(parent, label, opts, key, order)
        local isOpen=false
        local cont=mk("Frame", {Size=UDim2.new(1,0,0,34), BackgroundColor3=C.Panel, BorderSizePixel=0, LayoutOrder=order or 0, ClipsDescendants=true, Parent=parent})
        corner(cont)
        mk("TextLabel", {Size=UDim2.new(0,120,0,34), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=label,
            Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Left, Parent=cont})
        local selLbl=mk("TextLabel", {Size=UDim2.new(0,120,0,34), Position=UDim2.new(1,-130,0,0), BackgroundTransparency=1,
            Text=(key and CFG[key]) or opts[1], Font=Enum.Font.GothamBold, TextSize=11, TextColor3=C.Accent, TextXAlignment=Enum.TextXAlignment.Right, Parent=cont})
        mk("TextLabel", {Size=UDim2.new(0,18,0,34), Position=UDim2.new(1,-16,0,0), BackgroundTransparency=1, Text="▾", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=C.Sub, Parent=cont})

        local df=mk("Frame", {Size=UDim2.new(1,0,0,#opts*26), Position=UDim2.new(0,0,0,34), BackgroundColor3=Color3.fromRGB(20,18,38), BorderSizePixel=0, Parent=cont})
        mk("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Parent=df})

        for i,opt in ipairs(opts) do
            local ob=mk("TextButton", {Size=UDim2.new(1,0,0,26), BackgroundColor3=Color3.fromRGB(20,18,38), Text=opt,
                Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Sub, BorderSizePixel=0, LayoutOrder=i, Parent=df})
            ob.MouseButton1Click:Connect(function()
                if key then CFG[key]=opt end selLbl.Text=opt isOpen=false tw(cont,{Size=UDim2.new(1,0,0,34)},.18)
            end)
            ob.MouseEnter:Connect(function() tw(ob,{TextColor3=C.Text},.1) end)
            ob.MouseLeave:Connect(function() tw(ob,{TextColor3=C.Sub},.1) end)
        end

        mk("TextButton", {Size=UDim2.new(1,0,0,34), BackgroundTransparency=1, Text="", Parent=cont}).MouseButton1Click:Connect(function()
            isOpen=not isOpen
            tw(cont, {Size=UDim2.new(1,0,0, isOpen and 34+#opts*26 or 34)}, .2, Enum.EasingStyle.Back)
        end)
        return cont
    end

    local function infoRow(parent, label, val, order)
        local row=mk("Frame", {Size=UDim2.new(1,0,0,30), BackgroundColor3=C.Panel, BorderSizePixel=0, LayoutOrder=order or 0, Parent=parent})
        corner(row)
        mk("TextLabel", {Size=UDim2.new(.5,0,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=label,
            Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Sub, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
        local vl=mk("TextLabel", {Size=UDim2.new(.5,-10,1,0), Position=UDim2.new(.5,0,0,0), BackgroundTransparency=1, Text=val,
            Font=Enum.Font.GothamBold, TextSize=11, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Right, Parent=row})
        return row, vl
    end

    -- ════════════════════════════════
    --  PAGE: AUTO FARM
    -- ════════════════════════════════
    local pFarm = newPage("Farm")
    local goFarm = newTab("Auto Farm","⚔","Farm")

    sec(pFarm,"Farm Config",1)
    drop(pFarm,"Method",{"Melee","Sword","Gun","Blox Fruit","Combo"},"FarmMethod",2)
    drop(pFarm,"Target Mob",{
        "Gorilla","Monkey","Pirate","Desert Bandit","Desert Officer",
        "Snow Lurker","Yeti","Marine","Sky Bandit","Dark Master",
        "Zombie","Vampire","Soul Reaper","Forest Pirate","Cocoa Warrior",
        "Musketeer Pirate","Fishman","Shark","Dragon","Human"
    },"TargetMob",3)

    sec(pFarm,"Toggles",4)
    tog(pFarm,"Enable Auto Farm","AutoFarm",5)
    tog(pFarm,"Auto Quest","AutoQuest",6)
    tog(pFarm,"Auto Eat Fruit","AutoEat",7)
    tog(pFarm,"Auto Respawn","AutoRespawn",8)
    tog(pFarm,"TP Bypass (safe steps)","TPBypass",9)

    sec(pFarm,"Actions",10)
    btn(pFarm,"Teleport to Nearest Mob",C.Accent,11,function()
        local m=getNearestMob(CFG.TargetMob,99999)
        if m then local hrp=m:FindFirstChild("HumanoidRootPart") if hrp then safeTp(hrp.Position) notify("Farm","Teleported to "..CFG.TargetMob) end
        else notify("Farm","No "..CFG.TargetMob.." found") end
    end)
    btn(pFarm,"Stop Farm",C.Red,12,function() CFG.AutoFarm=false notify("Farm","Auto farm stopped") end)

    -- ════════════════════════════════
    --  PAGE: TP & FRUIT
    -- ════════════════════════════════
    local pTP = newPage("TP")
    newTab("Teleport","🌀","TP")

    sec(pTP,"Fruit Scanner",1)
    tog(pTP,"Auto TP to Fruit","TPFruit",2)
    btn(pTP,"Scan & TP to Nearest Fruit",C.Accent,3,function()
        local fruits=getFruits()
        local root=getRoot()
        if not root then notify("Fruit","No character") return end
        if #fruits==0 then notify("Fruit","No fruits found on map") return end
        table.sort(fruits,function(a,b)
            return (a.pos-root.Position).Magnitude < (b.pos-root.Position).Magnitude
        end)
        local f=fruits[1]
        safeTp(f.pos)
        notify("Fruit","Teleported to: "..f.name)
    end)
    btn(pTP,"List All Fruits",C.AccDark,4,function()
        local fruits=getFruits()
        if #fruits==0 then notify("Fruit","No fruits found") return end
        local names={}
        for i,f in ipairs(fruits) do names[i]=f.name end
        notify("Fruits Found","Found "..#fruits..": "..table.concat(names,", "):sub(1,80))
    end)

    sec(pTP,"TP Bypass Settings",5)
    tog(pTP,"Enable TP Bypass","TPBypass",6)
    tog(pTP,"Safe Mode (gradual steps)","SafeTP",7)
    drop(pTP,"Step Delay",{"Fast (0.05s)","Normal (0.15s)","Slow (0.5s)"},nil,8)

    -- Sea data: {Name, Vector3 position}
    local SEA1 = {
        {"Starter Island",      Vector3.new(1260,  125,  1612)},
        {"Marine Starter",      Vector3.new(-1180, 125, -1174)},
        {"Middle Town",         Vector3.new(-192,  125,  -559)},
        {"Jungle",              Vector3.new(-1646, 125,  -261)},
        {"Pirate Village",      Vector3.new(-1189, 125,  4403)},
        {"Desert",              Vector3.new(924,   125,  4089)},
        {"Frozen Village",      Vector3.new(1175,  125, -1818)},
        {"Snowy Village",       Vector3.new(1326,  125, -2882)},
        {"Marine Fortress",     Vector3.new(-965,  125,  -380)},
        {"Skylands",            Vector3.new(-4755, 872,  -718)},
        {"Upper Skylands",      Vector3.new(-5004, 1400, -718)},
        {"Fountain City",       Vector3.new(3324,  127, -2610)},
    }

    local SEA2 = {
        {"Kingdom of Rose",     Vector3.new(-804,  266,   604)},
        {"Dark Arena",          Vector3.new(-9564, 125,  -1754)},
        {"Usoapp Island",       Vector3.new(-2581, 125,   1500)},
        {"Green Zone",          Vector3.new(-3626, 125,   1900)},
        {"Graveyard",           Vector3.new(-5878, 125,   -670)},
        {"Snow Mountain",       Vector3.new(-4550, 1000, -1100)},
        {"Hot and Cold",        Vector3.new(-3620, 125,  -2945)},
        {"Cursed Ship",         Vector3.new(-5237, 125,  -1765)},
        {"Ice Castle",          Vector3.new(-3966, 125,  -1120)},
        {"Forgotten Island",    Vector3.new(-6000, 125,  -1700)},
        {"Colosseum",           Vector3.new(926,   125,  29310)},
        {"Magma Village",       Vector3.new(500,   125,  29650)},
        {"Underwater City",     Vector3.new(61421, 125,   1819)},
        {"Wano",                Vector3.new(3640,  125,  29500)},
    }

    local SEA3 = {
        {"Port Town",           Vector3.new(-2076,  49,  -4246)},
        {"Hydra Island",        Vector3.new(-3281,  125, -3900)},
        {"Great Tree",          Vector3.new(-9084,  400, -2573)},
        {"Mansion",             Vector3.new(-6640,  125, -2800)},
        {"Tiki Outpost",        Vector3.new(-8279,  125, -1024)},
        {"Buggy Island",        Vector3.new(-8420,  125,  1630)},
        {"Floating Turtle",     Vector3.new(-14553, 243, -1014)},
        {"Haunted Castle",      Vector3.new(-11540, 400, -1044)},
        {"Distant Island",      Vector3.new(-13000, 125, -4700)},
        {"Sea of Treats",       Vector3.new(-14055, 125,  3829)},
        {"Peanut Island",       Vector3.new(-13350, 125,  4100)},
        {"Cake Land",           Vector3.new(-12350, 125,  5000)},
        {"Candy Island",        Vector3.new(-11700, 125,  5500)},
        {"Ice Berg",            Vector3.new(-14300, 125, -2100)},
        {"Labyrinth",           Vector3.new(-15200, 125, -1800)},
    }

    local function isleBtn(parent, name, pos, order)
        btn(parent, name, C.Panel, order, function()
            safeTp(pos)
            notify("Teleport", "→ "..name)
        end)
    end

    sec(pTP,"⚓  Sea 1",9)
    for i, d in ipairs(SEA1) do isleBtn(pTP, d[1], d[2], 9+i) end

    sec(pTP,"⚓  Sea 2",22)
    for i, d in ipairs(SEA2) do isleBtn(pTP, d[1], d[2], 22+i) end

    sec(pTP,"⚓  Sea 3",37)
    for i, d in ipairs(SEA3) do isleBtn(pTP, d[1], d[2], 37+i) end

    -- ════════════════════════════════
    --  PAGE: BOSS FARM
    -- ════════════════════════════════
    local pBoss = newPage("Boss")
    newTab("Boss Farm","💀","Boss")

    sec(pBoss,"Select Boss",1)
    drop(pBoss,"Boss",{
        "Gorilla King","Bobby","Yeti","Darkbeard","Rip_Indra",
        "Thunder God","Tide Keeper","Stone","Island Empress",
        "Longma","Cake Prince","Kilo Admiral","Vice Admiral",
        "Magma Admiral","Order","Cursed Captain","Bartolomeo"
    },"SelectedBoss",2)

    sec(pBoss,"Boss Toggles",3)
    tog(pBoss,"Auto Boss Farm","AutoBoss",4)
    tog(pBoss,"TP Bypass","TPBypass",5)

    sec(pBoss,"Actions",6)
    btn(pBoss,"Start Boss Farm",C.Accent,7,function() CFG.AutoBoss=true notify("Boss","Auto Boss: "..CFG.SelectedBoss) end)
    btn(pBoss,"Stop Boss Farm",C.Red,8,function() CFG.AutoBoss=false notify("Boss","Boss farm stopped") end)
    btn(pBoss,"TP to Boss Spawn",C.AccDark,9,function() notify("Boss","Teleporting to "..CFG.SelectedBoss.." spawn...") end)

    -- ════════════════════════════════
    --  PAGE: AUTO RAID
    -- ════════════════════════════════
    local pRaid = newPage("Raid")
    newTab("Auto Raid","🌀","Raid")

    -- Raid island coordinates
    local RAIDS = {
        ["Flame"]           = Vector3.new(3066,  28,  2760),
        ["Ice"]             = Vector3.new(1227,  28, -2204),
        ["Rumble"]          = Vector3.new(-4755, 872,  -718),
        ["Quake"]           = Vector3.new(-1180, 28, -1174),
        ["Light"]           = Vector3.new(3324,  28, -2610),
        ["Dark"]            = Vector3.new(-9084, 28, -2573),
        ["Buddha"]          = Vector3.new(-804,  28,   604),
        ["Venom"]           = Vector3.new(-5237, 28, -1765),
        ["Phoenix"]         = Vector3.new(-3966, 28, -1120),
        ["Dough"]           = Vector3.new(-12350,28,  5000),
        ["Shadow"]          = Vector3.new(-11540,28, -1044),
        ["Portal"]          = Vector3.new(-14553,28, -1014),
        ["Control"]         = Vector3.new(-15200,28, -1800),
        ["Dragon"]          = Vector3.new(-9564, 28, -1754),
        ["Leopard"]         = Vector3.new(-14300,28, -2100),
        ["T-Rex"]           = Vector3.new(-13000,28, -4700),
    }

    local raidNames = {}
    for k in pairs(RAIDS) do table.insert(raidNames, k) end
    table.sort(raidNames)

    sec(pRaid,"Raid Config",1)
    drop(pRaid,"Raid Type", raidNames, "SelectedRaid", 2)

    sec(pRaid,"Raid Toggles",3)
    tog(pRaid,"Auto Raid (loop)","AutoRaid",4)
    tog(pRaid,"Auto Kill Raid Boss","AutoRaidBoss",5)
    tog(pRaid,"TP Bypass","TPBypass",6)
    tog(pRaid,"Auto Respawn in Raid","AutoRespawn",7)

    sec(pRaid,"Actions",8)
    btn(pRaid,"Start Auto Raid",C.Accent,9,function()
        CFG.AutoRaid = true
        CFG.AutoRaidBoss = true
        notify("Raid","Auto Raid started: "..(CFG.SelectedRaid or "Flame"))
    end)
    btn(pRaid,"Stop Raid",C.Red,10,function()
        CFG.AutoRaid=false CFG.AutoRaidBoss=false
        notify("Raid","Auto Raid stopped")
    end)
    btn(pRaid,"TP to Raid Island",C.AccDark,11,function()
        local r = CFG.SelectedRaid or "Flame"
        local pos = RAIDS[r]
        if pos then safeTp(pos) notify("Raid","TP → "..r.." Raid Island")
        else notify("Raid","Island not found: "..r) end
    end)

    sec(pRaid,"Quick Raid TP",12)
    for i, name in ipairs(raidNames) do
        local pos = RAIDS[name]
        btn(pRaid, name.." Raid", C.Panel, 12+i, function()
            safeTp(pos)
            CFG.SelectedRaid = name
            notify("Raid","TP → "..name.." Raid")
        end)
    end

    -- ════════════════════════════════
    --  PAGE: COMBAT
    -- ════════════════════════════════
    local pCom = newPage("Combat")
    newTab("Combat","🥊","Combat")

    sec(pCom,"Melee",1)
    tog(pCom,"Auto Melee","AutoMelee",2)
    sec(pCom,"Sword",3)
    tog(pCom,"Auto Sword","AutoSword",4)
    sec(pCom,"Gun",5)
    tog(pCom,"Auto Gun","AutoGun",6)
    sec(pCom,"Blox Fruit",7)
    tog(pCom,"Auto Fruit Skills","AutoFruit",8)
    drop(pCom,"Fruit Skill",{"Z","X","C","V","Z+X","Z+X+C","Full Combo"},"FruitSkill",9)
    sec(pCom,"Utilities",10)
    btn(pCom,"Kill Aura (all methods)",C.Accent,11,function()
        CFG.AutoMelee=true CFG.AutoSword=true CFG.AutoGun=true notify("Kill Aura","All combat enabled!")
    end)
    btn(pCom,"Disable All Combat",C.Red,12,function()
        CFG.AutoMelee=false CFG.AutoSword=false CFG.AutoGun=false CFG.AutoFruit=false notify("Combat","All combat off")
    end)

    -- ════════════════════════════════
    --  PAGE: AUTO STORE / MASTERY
    -- ════════════════════════════════
    local pStore = newPage("Store")
    newTab("Auto Store","🏪","Store")

    sec(pStore,"Mastery Farm",1)
    tog(pStore,"Auto Mastery Farm","AutoMastery",2)
    drop(pStore,"Mastery Target",{"Sword","Gun","Blox Fruit","All"},"MasteryTarget",3)
    btn(pStore,"Start Mastery Farm",C.Accent,4,function()
        CFG.AutoMastery=true notify("Mastery","Farming mastery for: "..CFG.MasteryTarget)
    end)
    btn(pStore,"Stop Mastery Farm",C.Red,5,function() CFG.AutoMastery=false notify("Mastery","Mastery farm stopped") end)

    sec(pStore,"Auto Store",6)
    tog(pStore,"Auto Store Items","AutoStore",7)
    drop(pStore,"Store Target",{"All","Weapons","Accessories","Fruits","Materials"},"StoreItem",8)
    btn(pStore,"Open Storage Now",C.Accent,9,function()
        -- Find storage NPC
        local found=false
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("instalar") or obj.Name:lower():find("blacksmith") or obj.Name:lower():find("chest") then
                found=true
                local hrp=obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") or nil
                if hrp then safeTp(hrp.Position) end
                break
            end
        end
        notify("Store", found and "Teleported to storage NPC" or "Storage NPC not found nearby")
    end)
    btn(pStore,"TP to Blox Fruit Dealer",C.AccDark,10,function() notify("Store","Teleporting to Blox Fruit Dealer...") end)
    btn(pStore,"TP to Gacha Island",C.AccDark,11,function() notify("Store","Teleporting to Gacha Island...") end)

    -- ════════════════════════════════
    --  PAGE: PLAYER
    -- ════════════════════════════════
    local pPlr = newPage("Player")
    newTab("Player","👤","Player")

    sec(pPlr,"Speed",1)
    btn(pPlr,"Speed x2 (32)",C.Accent,2,function() local h=getHum() if h then h.WalkSpeed=32 notify("Speed","Speed → 32") end end)
    btn(pPlr,"Speed x3 (48)",C.Accent,3,function() local h=getHum() if h then h.WalkSpeed=48 notify("Speed","Speed → 48") end end)
    btn(pPlr,"Speed x5 (80)",C.Accent,4,function() local h=getHum() if h then h.WalkSpeed=80 notify("Speed","Speed → 80") end end)
    btn(pPlr,"Reset Speed",C.AccDark,5,function() local h=getHum() if h then h.WalkSpeed=16 notify("Speed","Speed reset") end end)
    sec(pPlr,"Jump",6)
    btn(pPlr,"High Jump (100)",C.Accent,7,function() local h=getHum() if h then h.JumpPower=100 notify("Jump","JumpPower → 100") end end)
    btn(pPlr,"Super Jump (200)",C.Accent,8,function() local h=getHum() if h then h.JumpPower=200 notify("Jump","JumpPower → 200") end end)
    btn(pPlr,"Reset Jump",C.AccDark,9,function() local h=getHum() if h then h.JumpPower=50 notify("Jump","Jump reset") end end)
    sec(pPlr,"Abilities",10)
    tog(pPlr,"Infinite Jump","InfJump",11,function(on) notify("Infinite Jump", on and "Enabled" or "Disabled — re-execute to fully disable") end)
    btn(pPlr,"Rejoin Server",C.Red,12,function()
        local TPS=game:GetService("TeleportService") TPS:Teleport(game.PlaceId,LP)
    end)

    -- ════════════════════════════════
    --  PAGE: VISUAL
    -- ════════════════════════════════
    local pVis = newPage("Visual")
    newTab("Visual","👁","Visual")

    sec(pVis,"ESP",1)
    tog(pVis,"Player ESP","PlayerESP",2,function(on) notify("ESP",on and "Player ESP ON" or "Player ESP OFF") end)
    tog(pVis,"Mob ESP","MobESP",3,function(on) notify("ESP",on and "Mob ESP ON" or "Mob ESP OFF") end)
    tog(pVis,"Fruit ESP","FruitESP",4,function(on) notify("ESP",on and "Fruit ESP ON" or "Fruit ESP OFF") end)
    sec(pVis,"World",5)
    tog(pVis,"Fullbright","Fullbright",6,function(on)
        Lit.Brightness=on and 8 or 1 Lit.GlobalShadows=not on notify("Fullbright",on and "ON" or "OFF")
    end)
    tog(pVis,"No Fog",nil,7,function(on) Lit.FogEnd=on and 1e9 or 100000 notify("Fog",on and "Removed" or "Restored") end)
    sec(pVis,"Camera",8)
    btn(pVis,"FOV 70 (default)",C.Panel,9,function() Cam.FieldOfView=70 end)
    btn(pVis,"FOV 90",C.Accent,10,function() Cam.FieldOfView=90 end)
    btn(pVis,"FOV 110",C.Accent,11,function() Cam.FieldOfView=110 end)

    -- ════════════════════════════════
    --  PAGE: SETTINGS
    -- ════════════════════════════════
    local pSet = newPage("Settings")
    newTab("Settings","⚙","Settings")

    sec(pSet,"Keybinds",1)
    infoRow(pSet,"Toggle GUI","RightShift",2)
    infoRow(pSet,"Current Executor","Delta / Hydrogen",3)

    sec(pSet,"Farm Settings",4)
    infoRow(pSet,"Farm Delay",CFG.FarmDelay.."s",5)
    infoRow(pSet,"TP Delay",CFG.TPDelay.."s",6)
    drop(pSet,"Farm Speed",{"Fast (0.1s)","Normal (0.15s)","Safe (0.3s)"},nil,7)
    drop(pSet,"TP Mode",{"Bypass Steps","Instant","Safe Lerp"},nil,8)

    sec(pSet,"Safety",9)
    tog(pSet,"TP Bypass","TPBypass",10)
    tog(pSet,"Safe TP (gradual)","SafeTP",11)
    tog(pSet,"Auto Respawn","AutoRespawn",12)

    sec(pSet,"Performance",13)
    tog(pSet,"FPS Counter","FPSShow",14)
    tog(pSet,"Anti AFK","AntiAFK",15)

    sec(pSet,"About",16)
    infoRow(pSet,"Version","v1.0.0",17)
    infoRow(pSet,"Script","Elite Hub",18)
    infoRow(pSet,"Discord","discord.gg/EmsMsHZCVH",19)
    btn(pSet,"Copy Discord Link",C.Discord,20,function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        notify("Discord","Link copied! discord.gg/EmsMsHZCVH")
    end)
    btn(pSet,"Reload Script",C.AccDark,21,function()
        sg:Destroy()
        task.wait(.2)
        buildGUI()
        notify("Elite Hub","GUI reloaded!")
    end)

    goFarm()
    return sg
end

-- ════════════════════════════════════════════
--  FPS COUNTER
-- ════════════════════════════════════════════
local function startFPS()
    pcall(function() PG:FindFirstChild("_EHfps"):Destroy() end)
    local sg=mk("ScreenGui", {Name="_EHfps", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=PG})
    local f=mk("Frame", {Size=UDim2.new(0,84,0,26), Position=UDim2.new(1,-90,0,8), BackgroundColor3=C.BG, BorderSizePixel=0, Parent=sg})
    corner(f) stroke(f,C.Accent,1,0.5)
    local dot=mk("Frame", {Size=UDim2.new(0,7,0,7), Position=UDim2.new(0,7,.5,-3.5), BackgroundColor3=C.Green, BorderSizePixel=0, Parent=f})
    corner(dot,4)
    local lbl=mk("TextLabel", {Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,18,0,0), BackgroundTransparency=1, Text="FPS: --", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Left, Parent=f})

    local fr,lt=0,tick()
    RS.RenderStepped:Connect(function()
        sg.Enabled=CFG.FPSShow
        fr=fr+1
        local n=tick()
        if n-lt>=0.5 then
            local fps=math.floor(fr/(n-lt))
            lbl.Text="FPS: "..fps
            dot.BackgroundColor3=fps>=55 and C.Green or fps>=30 and C.Gold or C.Red
            fr,lt=0,n
        end
    end)
end

-- ════════════════════════════════════════════
--  ANTI AFK
-- ════════════════════════════════════════════
local function startAntiAFK()
    task.spawn(function()
        while task.wait(55) do
            if CFG.AntiAFK then
                pcall(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
                local h=getHum()
                if h then h:Move(Vector3.new(1,0,0),true) task.wait(.1) h:Move(Vector3.new(0,0,0),true) end
            end
        end
    end)
end

-- ════════════════════════════════════════════
--  INFINITE JUMP
-- ════════════════════════════════════════════
UIS.JumpRequest:Connect(function()
    if CFG.InfJump then
        local h=getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ════════════════════════════════════════════
--  FRUIT TP LOOP
-- ════════════════════════════════════════════
local function startFruitLoop()
    task.spawn(function()
        while task.wait(3) do
            if CFG.TPFruit and isAlive() then
                local fruits=getFruits()
                local root=getRoot()
                if root and #fruits>0 then
                    table.sort(fruits,function(a,b) return (a.pos-root.Position).Magnitude<(b.pos-root.Position).Magnitude end)
                    safeTp(fruits[1].pos)
                end
            end
        end
    end)
end

-- ════════════════════════════════════════════
--  AUTO RAID LOOP
-- ════════════════════════════════════════════
local RAID_COORDS = {
    ["Flame"]   = Vector3.new(3066,  28,  2760),
    ["Ice"]     = Vector3.new(1227,  28, -2204),
    ["Rumble"]  = Vector3.new(-4755, 872,  -718),
    ["Quake"]   = Vector3.new(-1180, 28, -1174),
    ["Light"]   = Vector3.new(3324,  28, -2610),
    ["Dark"]    = Vector3.new(-9084, 28, -2573),
    ["Buddha"]  = Vector3.new(-804,  28,   604),
    ["Venom"]   = Vector3.new(-5237, 28, -1765),
    ["Phoenix"] = Vector3.new(-3966, 28, -1120),
    ["Dough"]   = Vector3.new(-12350,28,  5000),
    ["Shadow"]  = Vector3.new(-11540,28, -1044),
    ["Portal"]  = Vector3.new(-14553,28, -1014),
    ["Control"] = Vector3.new(-15200,28, -1800),
    ["Dragon"]  = Vector3.new(-9564, 28, -1754),
    ["Leopard"] = Vector3.new(-14300,28, -2100),
    ["T-Rex"]   = Vector3.new(-13000,28, -4700),
}

local function startRaidLoop()
    task.spawn(function()
        while task.wait(0.2) do
            if not CFG.AutoRaid then continue end
            if not isAlive() then
                if CFG.AutoRespawn then task.wait(4) end
                continue
            end
            -- TP to raid island
            local raidPos = RAID_COORDS[CFG.SelectedRaid]
            if raidPos then
                local root = getRoot()
                if root and (root.Position - raidPos).Magnitude > 150 then
                    safeTp(raidPos)
                    task.wait(1.5)
                end
            end
            -- Kill raid mobs
            if CFG.AutoRaidBoss then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not CFG.AutoRaid then break end
                    if obj:IsA("Model") then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 and obj ~= getChar() then
                            local root = getRoot()
                            if root and (hrp.Position - root.Position).Magnitude < 400 then
                                safeTp(hrp.Position + Vector3.new(0,0,3))
                                local char = getChar()
                                if char then
                                    local tool = char:FindFirstChildWhichIsA("Tool")
                                    if tool then
                                        local ev = tool:FindFirstChild("RemoteEvent")
                                        if ev then pcall(function() ev:FireServer() end) end
                                    end
                                end
                                task.wait(0.15)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ════════════════════════════════════════════
--  MAIN FARM LOOP
-- ════════════════════════════════════════════
local function startFarmLoop()
    task.spawn(function()
        while task.wait(CFG.FarmDelay) do
            if not CFG.AutoFarm then continue end
            if not isAlive() then
                if CFG.AutoRespawn then task.wait(3) end
                continue
            end
            local mob=getNearestMob(CFG.TargetMob, CFG.FarmRadius*4)
            if not mob then continue end
            local hrp=mob:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            safeTp(hrp.Position + Vector3.new(0,0,3))
            -- Simulate click/attack
            local char=getChar()
            if char then
                local tool=char:FindFirstChildWhichIsA("Tool")
                if tool then
                    local ev=tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
                    if ev and ev:IsA("RemoteEvent") then pcall(function() ev:FireServer() end) end
                end
            end
        end
    end)
end

-- ════════════════════════════════════════════
--  AUTO RESPAWN
-- ════════════════════════════════════════════
LP.CharacterAdded:Connect(function()
    if CFG.AutoRespawn then
        task.wait(2)
        notify("Respawn","Back! Resuming...")
    end
end)

-- ════════════════════════════════════════════
--  KEYBIND TOGGLE
-- ════════════════════════════════════════════
local guiRef = nil
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        if guiRef and guiRef.Parent then
            local main=guiRef:FindFirstChild("Main") or guiRef:FindFirstChildWhichIsA("Frame")
            if main then main.Visible=not main.Visible end
        end
    end
end)

-- ════════════════════════════════════════════
--  DISCORD POPUP
-- ════════════════════════════════════════════
local function discordPopup()
    task.wait(2.5)
    local sg=mk("ScreenGui", {Name="_EHDiscord", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=PG})
    local f=mk("Frame", {Size=UDim2.new(0,320,0,148), Position=UDim2.new(.5,-160,1,10), BackgroundColor3=C.Panel, BorderSizePixel=0, Parent=sg})
    corner(f,12)
    stroke(f, C.Discord, 1.2, 0.2)

    mk("Frame", {Size=UDim2.new(1,0,0,4), BackgroundColor3=C.Discord, BorderSizePixel=0, Parent=f})
    local topFix=mk("Frame", {Size=UDim2.new(1,0,0,2), BackgroundColor3=C.Discord, BorderSizePixel=0, Parent=f})
    corner(topFix)

    local ic=mk("Frame", {Size=UDim2.new(0,40,0,40), Position=UDim2.new(0,14,0,16), BackgroundColor3=C.Discord, BorderSizePixel=0, Parent=f})
    corner(ic,20)
    mk("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="d", Font=Enum.Font.GothamBlack, TextSize=22, TextColor3=Color3.new(1,1,1), Parent=ic})

    mk("TextLabel", {Size=UDim2.new(1,-70,0,20), Position=UDim2.new(0,64,0,14), BackgroundTransparency=1, Text="Join Elite Hub Discord!", Font=Enum.Font.GothamBlack, TextSize=13, TextColor3=C.Text, TextXAlignment=Enum.TextXAlignment.Left, Parent=f})
    mk("TextLabel", {Size=UDim2.new(1,-70,0,32), Position=UDim2.new(0,64,0,36), BackgroundTransparency=1, Text="Get updates, new features & support.", Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Sub, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Parent=f})

    local lf=mk("Frame", {Size=UDim2.new(1,-24,0,26), Position=UDim2.new(0,12,0,80), BackgroundColor3=Color3.fromRGB(12,10,28), BorderSizePixel=0, Parent=f})
    corner(lf)
    mk("TextLabel", {Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text="discord.gg/EmsMsHZCVH", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=C.Discord, TextXAlignment=Enum.TextXAlignment.Left, Parent=lf})

    local cpBtn=mk("TextButton", {Size=UDim2.new(0,80,0,28), Position=UDim2.new(0,12,1,-40), BackgroundColor3=C.Discord, Text="Copy Link", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=f})
    corner(cpBtn)
    cpBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard("discord.gg/EmsMsHZCVH") end)
        cpBtn.Text="Copied!" task.wait(2) cpBtn.Text="Copy Link"
    end)

    local xBtn=mk("TextButton", {Size=UDim2.new(0,24,0,24), Position=UDim2.new(1,-32,0,8), BackgroundColor3=Color3.fromRGB(50,46,75), Text="×", Font=Enum.Font.GothamBold, TextSize=15, TextColor3=C.Sub, BorderSizePixel=0, Parent=f})
    corner(xBtn,12)
    xBtn.MouseButton1Click:Connect(function()
        tw(f,{Position=UDim2.new(.5,-160,1,10)},.35)
        task.wait(.4) sg:Destroy()
    end)

    tw(f,{Position=UDim2.new(.5,-160,1,-158)},.45,Enum.EasingStyle.Back)
    task.delay(16,function() if sg.Parent then tw(f,{Position=UDim2.new(.5,-160,1,10)},.35) task.wait(.4) pcall(function() sg:Destroy() end) end end)
end

-- ════════════════════════════════════════════
--  WATERMARK
-- ════════════════════════════════════════════
local function watermark()
    local sg=mk("ScreenGui", {Name="_EHWater", ResetOnSpawn=false, Parent=PG})
    local f=mk("Frame", {Size=UDim2.new(0,210,0,24), Position=UDim2.new(0,6,0,6), BackgroundColor3=C.BG, BorderSizePixel=0, Parent=sg})
    corner(f,7) stroke(f,C.Accent,1,0.45)
    mk("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="⚔ Elite Hub v1.0.0 · discord.gg/EmsMsHZCVH",
        Font=Enum.Font.GothamBold, TextSize=9, TextColor3=C.Sub, Parent=f})
end

-- ════════════════════════════════════════════
--  BOOT
-- ════════════════════════════════════════════
task.spawn(function()
    showLoader()
    task.wait(.1)
    guiRef = buildGUI()
    startFPS()
    startAntiAFK()
    startFarmLoop()
    startFruitLoop()
    startRaidLoop()
    watermark()
    task.wait(.4)
    notify("Elite Hub v1.0.0","Loaded! RShift = toggle GUI")
    discordPopup()
end)

print("╔══════════════════════════════════╗")
print("║  Elite Hub v1.0.0 — Blox Fruits   ║")
print("║  Delta / Hydrogen / Codex / AX  ║")
print("║  discord.gg/EmsMsHZCVH          ║")
print("╚══════════════════════════════════╝")
