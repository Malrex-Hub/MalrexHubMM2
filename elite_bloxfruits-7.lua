-- Elite Hub - discord.gg/Pq2dsdfHhE

-- // Loading Screen
local TweenService = game:GetService('TweenService')
local function safeParent(gui)
    local ok = pcall(function() gui.Parent = game:GetService('CoreGui') end)
    if not ok or not gui.Parent then
        gui.Parent = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
    end
end

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = 'EliteLoading'
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParent(ScreenGui)

-- Background
local Background = Instance.new('Frame')
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Background.BorderSizePixel = 0
Background.ZIndex = 10
Background.Parent = ScreenGui

-- Gradient overlay
local Gradient = Instance.new('UIGradient')
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 30)),
})
Gradient.Rotation = 135
Gradient.Parent = Background

-- Hub title
local Title = Instance.new('TextLabel')
Title.Size = UDim2.new(0, 400, 0, 60)
Title.Position = UDim2.new(0.5, -200, 0.32, 0)
Title.BackgroundTransparency = 1
Title.Text = 'ELITE HUB'
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 42
Title.Font = Enum.Font.GothamBold
Title.TextTransparency = 1
Title.ZIndex = 11
Title.Parent = Background

-- Subtitle
local Subtitle = Instance.new('TextLabel')
Subtitle.Size = UDim2.new(0, 400, 0, 30)
Subtitle.Position = UDim2.new(0.5, -200, 0.44, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = 'Blox Fruits Script'
Subtitle.TextColor3 = Color3.fromRGB(160, 100, 255)
Subtitle.TextSize = 18
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextTransparency = 1
Subtitle.ZIndex = 11
Subtitle.Parent = Background

-- Bar background
local BarBG = Instance.new('Frame')
BarBG.Size = UDim2.new(0, 340, 0, 6)
BarBG.Position = UDim2.new(0.5, -170, 0.58, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
BarBG.BorderSizePixel = 0
BarBG.ZIndex = 11
BarBG.Parent = Background
Instance.new('UICorner', BarBG).CornerRadius = UDim.new(1, 0)

-- Bar fill
local BarFill = Instance.new('Frame')
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 70, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 12
BarFill.Parent = BarBG
Instance.new('UICorner', BarFill).CornerRadius = UDim.new(1, 0)

-- Bar gradient
local BarGrad = Instance.new('UIGradient')
BarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255)),
})
BarGrad.Parent = BarFill

-- Status label
local StatusLabel = Instance.new('TextLabel')
StatusLabel.Size = UDim2.new(0, 340, 0, 24)
StatusLabel.Position = UDim2.new(0.5, -170, 0.62, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = 'Loading...'
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 11
StatusLabel.Parent = Background

-- Credits label
local Credits = Instance.new('TextLabel')
Credits.Size = UDim2.new(0, 400, 0, 24)
Credits.Position = UDim2.new(0.5, -200, 0.82, 0)
Credits.BackgroundTransparency = 1
Credits.Text = 'Created by Marcus  •  discord.gg/Pq2dsdfHhE'
Credits.TextColor3 = Color3.fromRGB(100, 100, 120)
Credits.TextSize = 13
Credits.Font = Enum.Font.Gotham
Credits.TextTransparency = 1
Credits.ZIndex = 11
Credits.Parent = Background

-- Fade in title & subtitle
TweenService:Create(Title, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
TweenService:Create(Subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
TweenService:Create(Credits, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
wait(0.5)

local steps = {
    {text = 'Initializing...', pct = 0.15},
    {text = 'Loading Fluent UI...', pct = 0.35},
    {text = 'Fetching modules...', pct = 0.55},
    {text = 'Setting up features...', pct = 0.75},
    {text = 'Almost ready...', pct = 0.92},
    {text = 'Done!', pct = 1.0},
}

for _, step in ipairs(steps) do
    StatusLabel.Text = step.text
    TweenService:Create(BarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(step.pct, 0, 1, 0)
    }):Play()
    wait(0.45)
end

wait(0.3)

-- Fade out
TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(Subtitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(Credits, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(StatusLabel, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(BarBG, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(BarFill, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
wait(0.7)
ScreenGui:Destroy()
-- // End Loading Screen

-- // Elite Hub Custom UI Library
local _EliteLib
do
-- Elite Hub UI Library
-- Custom built, no external dependencies

local EliteLib = {}
EliteLib.Options = {}

local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')

-- // Theme
local THEME = {
    BG          = Color3.fromRGB(12, 12, 18),
    BG2         = Color3.fromRGB(18, 18, 26),
    BG3         = Color3.fromRGB(24, 24, 34),
    Sidebar     = Color3.fromRGB(15, 15, 22),
    Accent      = Color3.fromRGB(110, 60, 220),
    AccentLight = Color3.fromRGB(150, 90, 255),
    AccentDark  = Color3.fromRGB(80, 40, 180),
    Text        = Color3.fromRGB(240, 240, 240),
    TextDim     = Color3.fromRGB(150, 150, 170),
    TextMuted   = Color3.fromRGB(90, 90, 110),
    Border      = Color3.fromRGB(35, 35, 50),
    Toggle_ON   = Color3.fromRGB(110, 60, 220),
    Toggle_OFF  = Color3.fromRGB(40, 40, 58),
    Slider      = Color3.fromRGB(110, 60, 220),
    SliderBG    = Color3.fromRGB(30, 30, 44),
    Hover       = Color3.fromRGB(28, 28, 40),
    Section     = Color3.fromRGB(110, 60, 220),
}

-- // Utilities
local function tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style, dir), props):Play()
end

local function corner(parent, r)
    local c = Instance.new('UICorner')
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new('UIStroke')
    s.Color = color or THEME.Border
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function newFrame(parent, size, pos, color, name)
    local f = Instance.new('Frame')
    f.Size = size or UDim2.new(1,0,0,30)
    f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or THEME.BG2
    f.BorderSizePixel = 0
    f.Name = name or 'Frame'
    f.Parent = parent
    return f
end

local function newLabel(parent, text, size, color, font, xalign)
    local l = Instance.new('TextLabel')
    l.Size = size or UDim2.new(1,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = text or ''
    l.TextColor3 = color or THEME.Text
    l.TextSize = 13
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function newButton(parent, size, pos, color)
    local b = Instance.new('TextButton')
    b.Size = size or UDim2.new(1,0,0,30)
    b.Position = pos or UDim2.new(0,0,0,0)
    b.BackgroundColor3 = color or THEME.BG3
    b.BorderSizePixel = 0
    b.Text = ''
    b.AutoButtonColor = false
    b.Parent = parent
    return b
end

-- // Floating animation
local function startFloat(obj, amplitude, speed)
    amplitude = amplitude or 3
    speed = speed or 2
    local base = obj.Position
    local t = math.random(0, 628) / 100
    RunService.Heartbeat:Connect(function(dt)
        t = t + dt * speed
        local offset = math.sin(t) * amplitude
        obj.Position = UDim2.new(base.X.Scale, base.X.Offset, base.Y.Scale, base.Y.Offset + offset)
    end)
end

-- // Dragging
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- // Notification system
local notifGui, notifList

local function setupNotify(gui)
    notifGui = Instance.new('ScreenGui')
    notifGui.Name = 'EliteNotify'
    notifGui.ResetOnSpawn = false
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    safeParent(notifGui)

    notifList = Instance.new('Frame')
    notifList.Size = UDim2.new(0, 280, 1, 0)
    notifList.Position = UDim2.new(1, -290, 0, 0)
    notifList.BackgroundTransparency = 1
    notifList.Parent = notifGui

    local layout = Instance.new('UIListLayout')
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 6)
    layout.Parent = notifList

    local pad = Instance.new('UIPadding')
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = notifList
end

function EliteLib:Notify(opts)
    if not notifList then return end
    local title   = opts.Title or 'Elite Hub'
    local content = opts.Content or ''
    local sub     = opts.SubContent or ''
    local dur     = opts.Duration or 4

    local card = newFrame(notifList, UDim2.new(1, 0, 0, 70), nil, THEME.BG2)
    card.BackgroundTransparency = 1
    corner(card, 10)
    stroke(card, THEME.Accent, 1)

    -- accent bar
    local bar = newFrame(card, UDim2.new(0, 3, 1, -16), UDim2.new(0, 8, 0, 8), THEME.Accent)
    corner(bar, 4)

    local titleL = newLabel(card, title, UDim2.new(1, -30, 0, 18), THEME.AccentLight, Enum.Font.GothamBold)
    titleL.Position = UDim2.new(0, 18, 0, 8)
    titleL.TextSize = 13

    local contentL = newLabel(card, content, UDim2.new(1, -30, 0, 16), THEME.Text, Enum.Font.Gotham)
    contentL.Position = UDim2.new(0, 18, 0, 26)
    contentL.TextSize = 12

    if sub ~= '' then
        local subL = newLabel(card, sub, UDim2.new(1, -30, 0, 14), THEME.TextDim, Enum.Font.Gotham)
        subL.Position = UDim2.new(0, 18, 0, 44)
        subL.TextSize = 11
    end

    -- slide in
    card.Position = UDim2.new(1, 20, 0, 0)
    tween(card, {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}, 0.35, Enum.EasingStyle.Back)

    task.delay(dur, function()
        tween(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, 0)}, 0.3)
        task.wait(0.35)
        card:Destroy()
    end)
end

-- // CreateWindow
function EliteLib:CreateWindow(opts)
    local title    = opts.Title or 'Elite Hub'
    local subtitle = opts.SubTitle or ''
    local size     = opts.Size or UDim2.fromOffset(560, 380)
    local minKey   = opts.MinimizeKey or Enum.KeyCode.End

    setupNotify()

    -- Root GUI
    local gui = Instance.new('ScreenGui')
    gui.Name = 'EliteHub'
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    safeParent(gui)

    -- Main window frame
    local win = newFrame(gui, size, UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), THEME.BG, 'Window')
    win.BackgroundTransparency = 1
    corner(win, 14)
    stroke(win, THEME.Border, 1)

    -- Fade+scale in
    win.BackgroundTransparency = 1
    tween(win, {BackgroundTransparency = 0}, 0.4)
    startFloat(win, 2.5, 1.2)

    -- subtle glow behind window
    local glow = newFrame(gui, UDim2.new(0, size.X.Offset + 60, 0, size.Y.Offset + 60),
        UDim2.new(0.5, -(size.X.Offset+60)/2, 0.5, -(size.Y.Offset+60)/2), Color3.fromRGB(80,30,180), 'Glow')
    glow.BackgroundTransparency = 0.92
    glow.ZIndex = 0
    corner(glow, 30)
    glow.Parent = gui

    -- Sidebar
    local sidebar = newFrame(win, UDim2.new(0, 148, 1, 0), UDim2.new(0,0,0,0), THEME.Sidebar, 'Sidebar')
    corner(sidebar, 14)
    -- right side of sidebar is flat
    local sideSquare = newFrame(sidebar, UDim2.new(0, 20, 1, 0), UDim2.new(1,-20,0,0), THEME.Sidebar)

    -- Sidebar logo area
    local logoArea = newFrame(sidebar, UDim2.new(1, 0, 0, 70), UDim2.new(0,0,0,0), THEME.Sidebar, 'LogoArea')

    local logoText = newLabel(logoArea, title, UDim2.new(1, -12, 0, 28), THEME.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    logoText.Position = UDim2.new(0, 6, 0, 12)
    logoText.TextSize = 16

    -- accent underline
    local underline = newFrame(logoArea, UDim2.new(0, 60, 0, 2), UDim2.new(0.5,-30,0,44), THEME.Accent)
    corner(underline, 2)
    local ugrad = Instance.new('UIGradient')
    ugrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.AccentDark),
        ColorSequenceKeypoint.new(1, THEME.AccentLight),
    })
    ugrad.Parent = underline

    local subText = newLabel(logoArea, subtitle, UDim2.new(1,-12,0,14), THEME.TextMuted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    subText.Position = UDim2.new(0, 6, 0, 50)
    subText.TextSize = 11

    -- Tab button list
    local tabList = Instance.new('ScrollingFrame')
    tabList.Size = UDim2.new(1, 0, 1, -78)
    tabList.Position = UDim2.new(0, 0, 0, 70)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0,0,0,0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = sidebar

    local tabListLayout = Instance.new('UIListLayout')
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabList

    local tabListPad = Instance.new('UIPadding')
    tabListPad.PaddingTop = UDim.new(0, 6)
    tabListPad.PaddingLeft = UDim.new(0, 8)
    tabListPad.PaddingRight = UDim.new(0, 8)
    tabListPad.Parent = tabList

    -- Content area
    local contentArea = newFrame(win,
        UDim2.new(1, -152, 1, -8),
        UDim2.new(0, 150, 0, 4),
        THEME.BG2, 'ContentArea')
    corner(contentArea, 10)

    -- Drag handle
    makeDraggable(win, logoArea)

    -- Minimize
    local minimized = false
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == minKey then
            minimized = not minimized
            tween(win, {Size = minimized and UDim2.new(0, 148, 0, 70) or size}, 0.3, Enum.EasingStyle.Quint)
            contentArea.Visible = not minimized
        end
    end)

    -- Window object
    local Window = {}
    local tabPages = {}
    local activeTab = nil

    local function setActiveTab(tabName, btn, page)
        if activeTab then
            local prev = tabPages[activeTab]
            if prev then prev.page.Visible = false end
            if prev then tween(prev.btn, {BackgroundTransparency = 1, BackgroundColor3 = THEME.Sidebar}, 0.15) end
            if prev then prev.indicator.Visible = false end
        end
        activeTab = tabName
        page.Visible = true
        tween(btn, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(30,20,50)}, 0.15)
    end

    function Window:AddTab(opts)
        local tabTitle = opts.Title or 'Tab'
        local order = #tabPages + 1

        -- Sidebar button
        local btn = newButton(tabList, UDim2.new(1, 0, 0, 34), nil, Color3.fromRGB(30,20,50))
        btn.BackgroundTransparency = 1
        btn.LayoutOrder = order
        corner(btn, 8)

        -- Active indicator bar
        local indicator = newFrame(btn, UDim2.new(0, 3, 0, 18), UDim2.new(0, 0, 0.5, -9), THEME.Accent)
        corner(indicator, 3)
        indicator.Visible = false

        local btnLabel = newLabel(btn, tabTitle, UDim2.new(1,-14,1,0), THEME.TextDim, Enum.Font.GothamMedium)
        btnLabel.Position = UDim2.new(0, 12, 0, 0)
        btnLabel.TextSize = 13

        btn.MouseEnter:Connect(function()
            if activeTab ~= tabTitle then
                tween(btn, {BackgroundTransparency = 0.6}, 0.15)
                tween(btnLabel, {TextColor3 = THEME.Text}, 0.15)
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= tabTitle then
                tween(btn, {BackgroundTransparency = 1}, 0.15)
                tween(btnLabel, {TextColor3 = THEME.TextDim}, 0.15)
            end
        end)

        -- Content page (scrolling)
        local page = Instance.new('ScrollingFrame')
        page.Size = UDim2.new(1, -8, 1, -8)
        page.Position = UDim2.new(0, 4, 0, 4)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = THEME.Accent
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.Parent = contentArea

        local pageLayout = Instance.new('UIListLayout')
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 4)
        pageLayout.Parent = page

        local pagePad = Instance.new('UIPadding')
        pagePad.PaddingTop = UDim.new(0, 6)
        pagePad.PaddingBottom = UDim.new(0, 6)
        pagePad.PaddingLeft = UDim.new(0, 4)
        pagePad.PaddingRight = UDim.new(0, 6)
        pagePad.Parent = page

        tabPages[tabTitle] = {btn = btn, page = page, indicator = indicator, label = btnLabel}

        btn.MouseButton1Click:Connect(function()
            if activeTab == tabTitle then return end
            -- deselect prev
            if activeTab and tabPages[activeTab] then
                local prev = tabPages[activeTab]
                prev.page.Visible = false
                tween(prev.btn, {BackgroundTransparency = 1}, 0.15)
                tween(prev.label, {TextColor3 = THEME.TextDim}, 0.15)
                prev.indicator.Visible = false
            end
            activeTab = tabTitle
            page.Visible = true
            indicator.Visible = true
            tween(btn, {BackgroundTransparency = 0}, 0.15)
            tween(btnLabel, {TextColor3 = THEME.Text}, 0.15)
        end)

        -- First tab auto-selected
        if order == 1 then
            activeTab = tabTitle
            page.Visible = true
            indicator.Visible = true
            btn.BackgroundTransparency = 0
            btnLabel.TextColor3 = THEME.Text
        end

        -- Tab element builder
        local Tab = {}
        local elemOrder = 0

        local function nextOrder()
            elemOrder = elemOrder + 1
            return elemOrder
        end

        -- // Section
        function Tab:AddSection(title)
            local wrap = newFrame(page, UDim2.new(1,0,0,28), nil, Color3.fromRGB(0,0,0,0), 'Section')
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder = nextOrder()

            local line = newFrame(wrap, UDim2.new(1,-8,0,1), UDim2.new(0,4,0.5,0), THEME.Border)
            local sLabel = newLabel(wrap, '  ' .. title .. '  ', UDim2.new(0,0,1,0), THEME.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
            sLabel.Position = UDim2.new(0,8,0,0)
            sLabel.TextSize = 12
            sLabel.AutomaticSize = Enum.AutomaticSize.X
            sLabel.BackgroundColor3 = THEME.BG2
            sLabel.BackgroundTransparency = 0
        end

        -- // Button
        function Tab:AddButton(opts)
            local btnTitle = opts.Title or 'Button'
            local btnDesc  = opts.Description or ''
            local cb       = opts.Callback or function() end
            local hasDesc  = btnDesc ~= ''
            local h        = hasDesc and 52 or 36

            local wrap = newFrame(page, UDim2.new(1,0,0,h), nil, THEME.BG3, 'Button')
            wrap.LayoutOrder = nextOrder()
            corner(wrap, 8)
            stroke(wrap, THEME.Border, 1)

            local clickBtn = newButton(wrap, UDim2.new(1,0,1,0), nil, THEME.BG3)
            clickBtn.BackgroundTransparency = 1
            corner(clickBtn, 8)

            local accentBar = newFrame(wrap, UDim2.new(0,3,0,h-16), UDim2.new(0,0,0,8), THEME.Accent)
            corner(accentBar, 3)

            local titleL = newLabel(wrap, btnTitle, UDim2.new(1,-60,0,20), THEME.Text, Enum.Font.GothamMedium)
            titleL.Position = UDim2.new(0,12,0, hasDesc and 8 or 8)
            titleL.TextSize = 13

            if hasDesc then
                local descL = newLabel(wrap, btnDesc, UDim2.new(1,-60,0,16), THEME.TextDim, Enum.Font.Gotham)
                descL.Position = UDim2.new(0,12,0,28)
                descL.TextSize = 11
            end

            -- arrow icon
            local arrow = newLabel(wrap, '›', UDim2.new(0,20,1,0), THEME.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            arrow.Position = UDim2.new(1,-24,0,0)
            arrow.TextSize = 18

            clickBtn.MouseEnter:Connect(function()
                tween(wrap, {BackgroundColor3 = THEME.Hover}, 0.15)
                tween(accentBar, {BackgroundColor3 = THEME.AccentLight}, 0.15)
            end)
            clickBtn.MouseLeave:Connect(function()
                tween(wrap, {BackgroundColor3 = THEME.BG3}, 0.15)
                tween(accentBar, {BackgroundColor3 = THEME.Accent}, 0.15)
            end)
            clickBtn.MouseButton1Click:Connect(function()
                tween(wrap, {BackgroundColor3 = Color3.fromRGB(50,25,100)}, 0.08)
                task.wait(0.08)
                tween(wrap, {BackgroundColor3 = THEME.Hover}, 0.1)
                pcall(cb)
            end)
        end

        -- // Toggle
        function Tab:AddToggle(id, opts)
            local togTitle = opts.Title or 'Toggle'
            local default  = opts.Default or false
            local cb       = opts.Callback or function() end

            local state = default

            local wrap = newFrame(page, UDim2.new(1,0,0,38), nil, THEME.BG3, 'Toggle')
            wrap.LayoutOrder = nextOrder()
            corner(wrap, 8)
            stroke(wrap, THEME.Border, 1)

            local clickBtn = newButton(wrap, UDim2.new(1,0,1,0), nil, THEME.BG3)
            clickBtn.BackgroundTransparency = 1

            local accentBar = newFrame(wrap, UDim2.new(0,3,0,22), UDim2.new(0,0,0,8), state and THEME.Accent or THEME.TextMuted)
            corner(accentBar, 3)

            local titleL = newLabel(wrap, togTitle, UDim2.new(1,-64,1,0), THEME.Text, Enum.Font.GothamMedium)
            titleL.Position = UDim2.new(0,12,0,0)
            titleL.TextSize = 13

            -- Toggle pill
            local pillBG = newFrame(wrap, UDim2.new(0,38,0,20), UDim2.new(1,-46,0.5,-10), state and THEME.Toggle_ON or THEME.Toggle_OFF)
            corner(pillBG, 10)

            local pill = newFrame(pillBG, UDim2.new(0,14,0,14), UDim2.new(0, state and 21 or 3, 0.5,-7), Color3.fromRGB(255,255,255))
            corner(pill, 8)

            local obj = {}
            local changedCallbacks = {}

            local function setState(val)
                state = val
                tween(pillBG, {BackgroundColor3 = val and THEME.Toggle_ON or THEME.Toggle_OFF}, 0.2)
                tween(pill, {Position = UDim2.new(0, val and 21 or 3, 0.5,-7)}, 0.2, Enum.EasingStyle.Back)
                tween(accentBar, {BackgroundColor3 = val and THEME.Accent or THEME.TextMuted}, 0.2)
                for _, fn in ipairs(changedCallbacks) do pcall(fn, val) end
                pcall(cb, val)
            end

            clickBtn.MouseEnter:Connect(function() tween(wrap, {BackgroundColor3 = THEME.Hover}, 0.15) end)
            clickBtn.MouseLeave:Connect(function() tween(wrap, {BackgroundColor3 = THEME.BG3}, 0.15) end)
            clickBtn.MouseButton1Click:Connect(function() setState(not state) end)

            function obj:SetValue(val) setState(val) end
            function obj:GetValue() return state end
            function obj:OnChanged(fn)
                table.insert(changedCallbacks, fn)
                return self
            end

            EliteLib.Options[id] = obj
            return obj
        end

        -- // Slider
        function Tab:AddSlider(id, opts)
            local slTitle = opts.Title or 'Slider'
            local min     = opts.Min or 0
            local max     = opts.Max or 100
            local default = opts.Default or min
            local round   = opts.Rounding or 1
            local cb      = opts.Callback or function() end

            local value = default

            local wrap = newFrame(page, UDim2.new(1,0,0,54), nil, THEME.BG3, 'Slider')
            wrap.LayoutOrder = nextOrder()
            corner(wrap, 8)
            stroke(wrap, THEME.Border, 1)

            local accentBar = newFrame(wrap, UDim2.new(0,3,0,38), UDim2.new(0,0,0,8), THEME.Accent)
            corner(accentBar, 3)

            local titleL = newLabel(wrap, slTitle, UDim2.new(1,-70,0,18), THEME.Text, Enum.Font.GothamMedium)
            titleL.Position = UDim2.new(0,12,0,8)
            titleL.TextSize = 13

            local valLabel = newLabel(wrap, tostring(value), UDim2.new(0,50,0,18), THEME.AccentLight, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            valLabel.Position = UDim2.new(1,-56,0,8)
            valLabel.TextSize = 13

            local track = newFrame(wrap, UDim2.new(1,-24,0,6), UDim2.new(0,12,0,36), THEME.SliderBG)
            corner(track, 4)

            local fill = newFrame(track, UDim2.new((value-min)/(max-min),0,1,0), nil, THEME.Slider)
            corner(fill, 4)
            local fillGrad = Instance.new('UIGradient')
            fillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, THEME.AccentDark),
                ColorSequenceKeypoint.new(1, THEME.AccentLight),
            })
            fillGrad.Parent = fill

            -- Knob
            local knob = newFrame(fill, UDim2.new(0,14,0,14), UDim2.new(1,-7,0.5,-7), Color3.fromRGB(255,255,255))
            corner(knob, 8)
            local knobGlow = newFrame(knob, UDim2.new(0,22,0,22), UDim2.new(0.5,-11,0.5,-11), THEME.Accent)
            corner(knobGlow, 12)
            knobGlow.BackgroundTransparency = 0.7
            knobGlow.ZIndex = 0

            local dragging = false
            local obj = {}
            local changedCBs = {}

            local function updateValue(x)
                local abs = track.AbsolutePosition.X
                local siz = track.AbsoluteSize.X
                local pct = math.clamp((x - abs) / siz, 0, 1)
                local raw = min + (max - min) * pct
                local rounded = math.round(raw / round) * round
                value = rounded
                valLabel.Text = tostring(value)
                tween(fill, {Size = UDim2.new(pct,0,1,0)}, 0.05)
                for _, fn in ipairs(changedCBs) do pcall(fn, value) end
                pcall(cb, value)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateValue(input.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            function obj:SetValue(val)
                val = math.clamp(val, min, max)
                value = val
                valLabel.Text = tostring(val)
                local pct = (val - min) / (max - min)
                tween(fill, {Size = UDim2.new(pct,0,1,0)}, 0.15)
            end
            function obj:GetValue() return value end
            function obj:OnChanged(fn) table.insert(changedCBs, fn) return self end

            EliteLib.Options[id] = obj
            return obj
        end

        -- // Dropdown
        function Tab:AddDropdown(id, opts)
            local ddTitle  = opts.Title or 'Dropdown'
            local values   = opts.Values or {}
            local default  = opts.Default or 1
            local multi    = opts.Multi or false
            local cb       = opts.Callback or function() end

            local selected = values[default] or values[1] or ''
            local open = false

            local wrap = newFrame(page, UDim2.new(1,0,0,44), nil, THEME.BG3, 'Dropdown')
            wrap.LayoutOrder = nextOrder()
            corner(wrap, 8)
            stroke(wrap, THEME.Border, 1)
            wrap.ClipsDescendants = false

            local accentBar = newFrame(wrap, UDim2.new(0,3,0,28), UDim2.new(0,0,0,8), THEME.Accent)
            corner(accentBar, 3)

            local titleL = newLabel(wrap, ddTitle, UDim2.new(0.5,0,0,18), THEME.Text, Enum.Font.GothamMedium)
            titleL.Position = UDim2.new(0,12,0,6)
            titleL.TextSize = 12

            local selBtn = newButton(wrap, UDim2.new(1,-20,0,22), UDim2.new(0,10,0,20), THEME.BG)
            corner(selBtn, 6)
            stroke(selBtn, THEME.Border, 1)

            local selLabel = newLabel(selBtn, selected, UDim2.new(1,-24,1,0), THEME.Text, Enum.Font.Gotham)
            selLabel.Position = UDim2.new(0,8,0,0)
            selLabel.TextSize = 12

            local chevron = newLabel(selBtn, '▾', UDim2.new(0,18,1,0), THEME.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            chevron.Position = UDim2.new(1,-20,0,0)
            chevron.TextSize = 13

            -- Dropdown panel
            local panel = newFrame(gui, UDim2.new(0, wrap.AbsoluteSize.X - 20, 0, 0), UDim2.new(0,0,0,0), THEME.BG2, 'DDPanel')
            panel.Visible = false
            panel.ZIndex = 20
            corner(panel, 8)
            stroke(panel, THEME.Accent, 1)
            panel.ClipsDescendants = true

            local panelLayout = Instance.new('UIListLayout')
            panelLayout.SortOrder = Enum.SortOrder.LayoutOrder
            panelLayout.Parent = panel

            local obj = {}
            local changedCBs = {}

            local function closeDD()
                open = false
                tween(chevron, {Rotation = 0}, 0.15)
                tween(panel, {Size = UDim2.new(0, wrap.AbsoluteSize.X - 20, 0, 0)}, 0.2)
                task.wait(0.22)
                panel.Visible = false
            end

            local function buildItems()
                for _, child in ipairs(panel:GetChildren()) do
                    if child:IsA('TextButton') then child:Destroy() end
                end
                local itemH = 28
                for i, v in ipairs(values) do
                    local item = newButton(panel, UDim2.new(1,0,0,itemH), nil, v == selected and Color3.fromRGB(30,15,60) or THEME.BG2)
                    item.ZIndex = 21
                    local iLabel = newLabel(item, v, UDim2.new(1,-16,1,0), v == selected and THEME.AccentLight or THEME.Text, Enum.Font.Gotham)
                    iLabel.Position = UDim2.new(0,10,0,0)
                    iLabel.TextSize = 12
                    iLabel.ZIndex = 22
                    item.MouseEnter:Connect(function()
                        if v ~= selected then tween(item, {BackgroundColor3 = THEME.Hover}, 0.1) end
                    end)
                    item.MouseLeave:Connect(function()
                        if v ~= selected then tween(item, {BackgroundColor3 = THEME.BG2}, 0.1) end
                    end)
                    item.MouseButton1Click:Connect(function()
                        selected = v
                        selLabel.Text = v
                        closeDD()
                        for _, fn in ipairs(changedCBs) do pcall(fn, v) end
                        pcall(cb, v)
                        buildItems()
                    end)
                end
            end
            buildItems()

            selBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    panel.Visible = true
                    local abs = selBtn.AbsolutePosition
                    panel.Position = UDim2.new(0, abs.X, 0, abs.Y + 26)
                    tween(chevron, {Rotation = 180}, 0.15)
                    local targetH = math.min(#values * 28, 150)
                    tween(panel, {Size = UDim2.new(0, wrap.AbsoluteSize.X - 20, 0, targetH)}, 0.2, Enum.EasingStyle.Back)
                else
                    closeDD()
                end
            end)

            function obj:SetValue(val)
                selected = val
                selLabel.Text = val
                buildItems()
            end
            function obj:GetValue() return selected end
            function obj:OnChanged(fn) table.insert(changedCBs, fn) return self end

            EliteLib.Options[id] = obj
            return obj
        end

        return Tab
    end

    return Window
end

_EliteLib = EliteLib
end
local u1 = _EliteLib

local v2 = u1:CreateWindow({
    Title = 'Elite Hub',
    SubTitle = 'Version 1029387',
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 350),
    Acrylic = false,
    Theme = 'Aqua',
    MinimizeKey = Enum.KeyCode.End,
})
local v3 = {
    Info = v2:AddTab({
        Title = 'Info',
        Icon = '',
    }),
    Main = v2:AddTab({
        Title = 'Main',
        Icon = '',
    }),
    Stats = v2:AddTab({
        Title = 'Stats',
        Icon = '',
    }),
    Teleport = v2:AddTab({
        Title = 'Island',
        Icon = '',
    }),
    Raid = v2:AddTab({
        Title = 'Raid',
        Icon = '',
    }),
    Race = v2:AddTab({
        Title = 'Race V4',
        Icon = '',
    }),
    Fruit = v2:AddTab({
        Title = 'Fruit',
        Icon = '',
    }),
    Shop = v2:AddTab({
        Title = 'Shop',
        Icon = '',
    }),
    Player = v2:AddTab({
        Title = 'Player',
        Icon = '',
    }),
    Setting = v2:AddTab({
        Title = 'Setting',
        Icon = '',
    }),
    Misc = v2:AddTab({
        Title = 'Misc',
        Icon = '',
    }),
    Hop = v2:AddTab({
        Title = 'Hop',
        Icon = '',
    }),
}
local _Options = EliteLib.Options
local _PlaceId = game.PlaceId

if _PlaceId == 2753915549 then
    First_Sea = true
elseif _PlaceId == 4442272183 then
    Second_Sea = true
elseif _PlaceId == 7449423635 then
    Third_Sea = true
else
    game:Shutdown()
end

function AntiBan()
    local v6, v7, v8 = pairs(game:GetService('Players').LocalPlayer.Character:GetDescendants())

    while true do
        local v9

        v8, v9 = v6(v7, v8)

        if v8 == nil then
            break
        end
        if v9:IsA('LocalScript') and (v9.Name == 'General' or (v9.Name == 'Shiftlock' or (v9.Name == 'FallDamage' or (v9.Name == '4444' or (v9.Name == 'CamBob' or (v9.Name == 'JumpCD' or (v9.Name == 'Looking' or v9.Name == 'Run'))))))) then
            v9:Destroy()
        end
    end

    local v10, v11, v12 = pairs(game:GetService('Players').LocalPlayer.PlayerScripts:GetDescendants())

    while true do
        local v13

        v12, v13 = v10(v11, v12)

        if v12 == nil then
            break
        end
        if v13:IsA('LocalScript') and (v13.Name == 'RobloxMotor6DBugFix' or (v13.Name == 'Clans' or (v13.Name == 'Codes' or (v13.Name == 'CustomForceField' or (v13.Name == 'MenuBloodSp' or v13.Name == 'PlayerList'))))) then
            v13:Destroy()
        end
    end
end

AntiBan()
game:GetService('Players').LocalPlayer.Idled:connect(function()
    game:GetService('VirtualUser'):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService('VirtualUser'):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

First_Sea = false
Second_Sea = false
Third_Sea = false

local _PlaceId2 = game.PlaceId

if _PlaceId2 == 2753915549 then
    First_Sea = true
elseif _PlaceId2 == 4442272183 then
    Second_Sea = true
elseif _PlaceId2 == 7449423635 then
    Third_Sea = true
end

function CheckLevel()
    local _Value = game:GetService('Players').LocalPlayer.Data.Level.Value

    if First_Sea then
        if _Value == 1 or (_Value <= 9 or (SelectMonster == 'Bandit' or SelectArea == '')) then
            Ms = 'Bandit'
            NameQuest = 'BanditQuest1'
            QuestLv = 1
            NameMon = 'Bandit'
            CFrameQ = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875)
            CFrameMon = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
        elseif _Value == 10 or (_Value <= 14 or (SelectMonster == 'Monkey' or SelectArea == 'Jungle')) then
            Ms = 'Monkey'
            NameQuest = 'JungleQuest'
            QuestLv = 1
            NameMon = 'Monkey'
            CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
        elseif _Value == 15 or (_Value <= 29 or (SelectMonster == 'Gorilla' or SelectArea == 'Jungle')) then
            Ms = 'Gorilla'
            NameQuest = 'JungleQuest'
            QuestLv = 2
            NameMon = 'Gorilla'
            CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(-1142.6488037109, 40.462348937988, -515.39227294922)
        elseif _Value == 30 or (_Value <= 39 or (SelectMonster == 'Pirate' or SelectArea == 'Buggy')) then
            Ms = 'Pirate'
            NameQuest = 'BuggyQuest1'
            QuestLv = 1
            NameMon = 'Pirate'
            CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
        elseif _Value == 40 or (_Value <= 59 or (SelectMonster == 'Brute' or SelectArea == 'Buggy')) then
            Ms = 'Brute'
            NameQuest = 'BuggyQuest1'
            QuestLv = 2
            NameMon = 'Brute'
            CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(-1387.5324707031, 24.592035293579, 4100.9575195313)
        elseif _Value == 60 or (_Value <= 74 or (SelectMonster == 'Desert Bandit' or SelectArea == 'Desert')) then
            Ms = 'Desert Bandit'
            NameQuest = 'DesertQuest'
            QuestLv = 1
            NameMon = 'Desert Bandit'
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
            CFrameMon = CFrame.new(984.99896240234, 16.109552383423, 4417.91015625)
        elseif _Value == 75 or (_Value <= 89 or (SelectMonster == 'Desert Officer' or SelectArea == 'Desert')) then
            Ms = 'Desert Officer'
            NameQuest = 'DesertQuest'
            QuestLv = 2
            NameMon = 'Desert Officer'
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
            CFrameMon = CFrame.new(1547.1510009766, 14.452038764954, 4381.8002929688)
        elseif _Value == 90 or (_Value <= 99 or (SelectMonster == 'Snow Bandit' or SelectArea == 'Snow')) then
            Ms = 'Snow Bandit'
            NameQuest = 'SnowQuest'
            QuestLv = 1
            NameMon = 'Snow Bandit'
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
            CFrameMon = CFrame.new(1356.3028564453, 105.76865386963, -1328.2418212891)
        elseif _Value == 100 or (_Value <= 119 or (SelectMonster == 'Snowman' or SelectArea == 'Snow')) then
            Ms = 'Snowman'
            NameQuest = 'SnowQuest'
            QuestLv = 2
            NameMon = 'Snowman'
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
            CFrameMon = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
        elseif _Value == 120 or (_Value <= 149 or (SelectMonster == 'Chief Petty Officer' or SelectArea == 'Marine')) then
            Ms = 'Chief Petty Officer'
            NameQuest = 'MarineQuest2'
            QuestLv = 1
            NameMon = 'Chief Petty Officer'
            CFrameQ = CFrame.new(-5035.49609375, 28.677835464478, 4324.1840820313)
            CFrameMon = CFrame.new(-4931.1552734375, 65.793113708496, 4121.8393554688)
        elseif _Value == 150 or (_Value <= 174 or (SelectMonster == 'Sky Bandit' or SelectArea == 'Sky')) then
            Ms = 'Sky Bandit'
            NameQuest = 'SkyQuest'
            QuestLv = 1
            NameMon = 'Sky Bandit'
            CFrameQ = CFrame.new(-4842.1372070313, 717.69543457031, -2623.0483398438)
            CFrameMon = CFrame.new(-4955.6411132813, 365.46365356445, -2908.1865234375)
        elseif _Value == 175 or (_Value <= 189 or (SelectMonster == 'Dark Master' or SelectArea == 'Sky')) then
            Ms = 'Dark Master'
            NameQuest = 'SkyQuest'
            QuestLv = 2
            NameMon = 'Dark Master'
            CFrameQ = CFrame.new(-4842.1372070313, 717.69543457031, -2623.0483398438)
            CFrameMon = CFrame.new(-5148.1650390625, 439.04571533203, -2332.9611816406)
        elseif _Value == 190 or (_Value <= 209 or (SelectMonster == 'Prisoner' or SelectArea == 'Prison')) then
            Ms = 'Prisoner'
            NameQuest = 'PrisonerQuest'
            QuestLv = 1
            NameMon = 'Prisoner'
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, -0.999846935, 0, 0.0175017118)
            CFrameMon = CFrame.new(4937.31885, 0.332031399, 649.574524, 0.694649816, 0, -0.719348073, 0, 1, 0, 0.719348073, 0, 0.694649816)
        elseif _Value == 210 or (_Value <= 249 or (SelectMonster == 'Dangerous Prisoner' or SelectArea == 'Prison')) then
            Ms = 'Dangerous Prisoner'
            NameQuest = 'PrisonerQuest'
            QuestLv = 2
            NameMon = 'Dangerous Prisoner'
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, -0.999846935, 0, 0.0175017118)
            CFrameMon = CFrame.new(5099.6626, 0.351562679, 1055.7583, 0.898906827, 0, -0.438139856, 0, 1, 0, 0.438139856, 0, 0.898906827)
        elseif _Value == 250 or (_Value <= 274 or (SelectMonster == 'Toga Warrior' or SelectArea == 'Colosseum')) then
            Ms = 'Toga Warrior'
            NameQuest = 'ColosseumQuest'
            QuestLv = 1
            NameMon = 'Toga Warrior'
            CFrameQ = CFrame.new(-1577.7890625, 7.4151420593262, -2984.4838867188)
            CFrameMon = CFrame.new(-1872.5166015625, 49.080215454102, -2913.810546875)
        elseif _Value == 275 or (_Value <= 299 or (SelectMonster == 'Gladiator' or SelectArea == 'Colosseum')) then
            Ms = 'Gladiator'
            NameQuest = 'ColosseumQuest'
            QuestLv = 2
            NameMon = 'Gladiator'
            CFrameQ = CFrame.new(-1577.7890625, 7.4151420593262, -2984.4838867188)
            CFrameMon = CFrame.new(-1521.3740234375, 81.203170776367, -3066.3139648438)
        elseif _Value == 300 or (_Value <= 324 or (SelectMonster == 'Military Soldier' or SelectArea == 'Magma')) then
            Ms = 'Military Soldier'
            NameQuest = 'MagmaQuest'
            QuestLv = 1
            NameMon = 'Military Soldier'
            CFrameQ = CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
            CFrameMon = CFrame.new(-5369.0004882813, 61.24352645874, 8556.4921875)
        elseif _Value == 325 or (_Value <= 374 or (SelectMonster == 'Military Spy' or SelectArea == 'Magma')) then
            Ms = 'Military Spy'
            NameQuest = 'MagmaQuest'
            QuestLv = 2
            NameMon = 'Military Spy'
            CFrameQ = CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
            CFrameMon = CFrame.new(-5787.00293, 75.8262634, 8651.69922, 0.838590562, 0, -0.544762194, 0, 1, 0, 0.544762194, 0, 0.838590562)
        elseif _Value == 375 or (_Value <= 399 or (SelectMonster == 'Fishman Warrior' or SelectArea == 'Fishman')) then
            Ms = 'Fishman Warrior'
            NameQuest = 'FishmanQuest'
            QuestLv = 1
            NameMon = 'Fishman Warrior'
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(60844.10546875, 98.462875366211, 1298.3985595703)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif _Value == 400 or (_Value <= 449 or (SelectMonster == 'Fishman Commando' or SelectArea == 'Fishman')) then
            Ms = 'Fishman Commando'
            NameQuest = 'FishmanQuest'
            QuestLv = 2
            NameMon = 'Fishman Commando'
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(61738.3984375, 64.207321166992, 1433.8375244141)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif _Value == 10 or (_Value <= 474 or (SelectMonster == "God's Guard" or SelectArea == 'Sky Island')) then
            Ms = "God's Guard"
            NameQuest = 'SkyExp1Quest'
            QuestLv = 1
            NameMon = "God's Guard"
            CFrameQ = CFrame.new(-4721.8603515625, 845.30297851563, -1953.8489990234)
            CFrameMon = CFrame.new(-4628.0498046875, 866.92877197266, -1931.2352294922)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif _Value == 475 or (_Value <= 524 or (SelectMonster == 'Shanda' or SelectArea == 'Sky Island')) then
            Ms = 'Shanda'
            NameQuest = 'SkyExp1Quest'
            QuestLv = 2
            NameMon = 'Shanda'
            CFrameQ = CFrame.new(-7863.1596679688, 5545.5190429688, -378.42266845703)
            CFrameMon = CFrame.new(-7685.1474609375, 5601.0751953125, -441.38876342773)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif _Value == 525 or (_Value <= 549 or (SelectMonster == 'Royal Squad' or SelectArea == 'Sky Island')) then
            Ms = 'Royal Squad'
            NameQuest = 'SkyExp2Quest'
            QuestLv = 1
            NameMon = 'Royal Squad'
            CFrameQ = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
            CFrameMon = CFrame.new(-7654.2514648438, 5637.1079101563, -1407.7550048828)
        elseif _Value == 550 or (_Value <= 624 or (SelectMonster == 'Royal Soldier' or SelectArea == 'Sky Island')) then
            Ms = 'Royal Soldier'
            NameQuest = 'SkyExp2Quest'
            QuestLv = 2
            NameMon = 'Royal Soldier'
            CFrameQ = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
            CFrameMon = CFrame.new(-7760.4106445313, 5679.9077148438, -1884.8112792969)
        elseif _Value == 625 or (_Value <= 649 or (SelectMonster == 'Galley Pirate' or SelectArea == 'Fountain')) then
            Ms = 'Galley Pirate'
            NameQuest = 'FountainQuest'
            QuestLv = 1
            NameMon = 'Galley Pirate'
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            CFrameMon = CFrame.new(5557.1684570313, 152.32717895508, 3998.7758789063)
        elseif _Value >= 650 or (SelectMonster == 'Galley Captain' or SelectArea == 'Fountain') then
            Ms = 'Galley Captain'
            NameQuest = 'FountainQuest'
            QuestLv = 2
            NameMon = 'Galley Captain'
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            CFrameMon = CFrame.new(5677.6772460938, 92.786109924316, 4966.6323242188)
        end
    end
    if Second_Sea then
        if _Value == 700 or (_Value <= 724 or (SelectMonster == 'Raider' or SelectArea == 'Area 1')) then
            Ms = 'Raider'
            NameQuest = 'Area1Quest'
            QuestLv = 1
            NameMon = 'Raider'
            CFrameQ = CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
            CFrameMon = CFrame.new(68.874565124512, 93.635643005371, 2429.6752929688)
        elseif _Value == 725 or (_Value <= 774 or (SelectMonster == 'Mercenary' or SelectArea == 'Area 1')) then
            Ms = 'Mercenary'
            NameQuest = 'Area1Quest'
            QuestLv = 2
            NameMon = 'Mercenary'
            CFrameQ = CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
            CFrameMon = CFrame.new(-864.85009765625, 122.47104644775, 1453.1505126953)
        elseif _Value == 775 or (_Value <= 799 or (SelectMonster == 'Swan Pirate' or SelectArea == 'Area 2')) then
            Ms = 'Swan Pirate'
            NameQuest = 'Area2Quest'
            QuestLv = 1
            NameMon = 'Swan Pirate'
            CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
            CFrameMon = CFrame.new(1065.3669433594, 137.64012145996, 1324.3798828125)
        elseif _Value == 800 or (_Value <= 874 or (SelectMonster == 'Factory Staff' or SelectArea == 'Area 2')) then
            Ms = 'Factory Staff'
            NameQuest = 'Area2Quest'
            QuestLv = 2
            NameMon = 'Factory Staff'
            CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
            CFrameMon = CFrame.new(533.22045898438, 128.46876525879, 355.62615966797)
        elseif _Value == 875 or (_Value <= 899 or (SelectMonster == 'Marine Lieutenan' or SelectArea == 'Marine')) then
            Ms = 'Marine Lieutenant'
            NameQuest = 'MarineQuest3'
            QuestLv = 1
            NameMon = 'Marine Lieutenant'
            CFrameQ = CFrame.new(-2440.9934082031, 73.04190826416, -3217.7082519531)
            CFrameMon = CFrame.new(-2489.2622070313, 84.613594055176, -3151.8830566406)
        elseif _Value == 900 or (_Value <= 949 or (SelectMonster == 'Marine Captain' or SelectArea == 'Marine')) then
            Ms = 'Marine Captain'
            NameQuest = 'MarineQuest3'
            QuestLv = 2
            NameMon = 'Marine Captain'
            CFrameQ = CFrame.new(-2440.9934082031, 73.04190826416, -3217.7082519531)
            CFrameMon = CFrame.new(-2335.2026367188, 79.786659240723, -3245.8674316406)
        elseif _Value == 950 or (_Value <= 974 or (SelectMonster == 'Zombie' or SelectArea == 'Zombie')) then
            Ms = 'Zombie'
            NameQuest = 'ZombieQuest'
            QuestLv = 1
            NameMon = 'Zombie'
            CFrameQ = CFrame.new(-5494.3413085938, 48.505931854248, -794.59094238281)
            CFrameMon = CFrame.new(-5536.4970703125, 101.08577728271, -835.59075927734)
        elseif _Value == 975 or (_Value <= 999 or (SelectMonster == 'Vampire' or SelectArea == 'Zombie')) then
            Ms = 'Vampire'
            NameQuest = 'ZombieQuest'
            QuestLv = 2
            NameMon = 'Vampire'
            CFrameQ = CFrame.new(-5494.3413085938, 48.505931854248, -794.59094238281)
            CFrameMon = CFrame.new(-5806.1098632813, 16.722528457642, -1164.4384765625)
        elseif _Value == 1000 or (_Value <= 1049 or (SelectMonster == 'Snow Trooper' or SelectArea == 'Snow Mountain')) then
            Ms = 'Snow Trooper'
            NameQuest = 'SnowMountainQuest'
            QuestLv = 1
            NameMon = 'Snow Trooper'
            CFrameQ = CFrame.new(607.05963134766, 401.44781494141, -5370.5546875)
            CFrameMon = CFrame.new(535.21051025391, 432.74209594727, -5484.9165039063)
        elseif _Value == 1050 or (_Value <= 1099 or (SelectMonster == 'Winter Warrior' or SelectArea == 'Snow Mountain')) then
            Ms = 'Winter Warrior'
            NameQuest = 'SnowMountainQuest'
            QuestLv = 2
            NameMon = 'Winter Warrior'
            CFrameQ = CFrame.new(607.05963134766, 401.44781494141, -5370.5546875)
            CFrameMon = CFrame.new(1234.4449462891, 456.95419311523, -5174.130859375)
        elseif _Value == 1100 or (_Value <= 1124 or (SelectMonster == 'Lab Subordinate' or SelectArea == 'Ice Fire')) then
            Ms = 'Lab Subordinate'
            NameQuest = 'IceSideQuest'
            QuestLv = 1
            NameMon = 'Lab Subordinate'
            CFrameQ = CFrame.new(-6061.841796875, 15.926671981812, -4902.0385742188)
            CFrameMon = CFrame.new(-5720.5576171875, 63.309471130371, -4784.6103515625)
        elseif _Value == 1125 or (_Value <= 1174 or (SelectMonster == 'Horned Warrior' or SelectArea == 'Ice Fire')) then
            Ms = 'Horned Warrior'
            NameQuest = 'IceSideQuest'
            QuestLv = 2
            NameMon = 'Horned Warrior'
            CFrameQ = CFrame.new(-6061.841796875, 15.926671981812, -4902.0385742188)
            CFrameMon = CFrame.new(-6292.751953125, 91.181983947754, -5502.6499023438)
        elseif _Value == 1175 or (_Value <= 1199 or (SelectMonster == 'Magma Ninja' or SelectArea == 'Ice Fire')) then
            Ms = 'Magma Ninja'
            NameQuest = 'FireSideQuest'
            QuestLv = 1
            NameMon = 'Magma Ninja'
            CFrameQ = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
            CFrameMon = CFrame.new(-5461.8388671875, 130.36347961426, -5836.4702148438)
        elseif _Value == 1200 or (_Value <= 1249 or (SelectMonster == 'Lava Pirate' or SelectArea == 'Ice Fire')) then
            Ms = 'Lava Pirate'
            NameQuest = 'FireSideQuest'
            QuestLv = 2
            NameMon = 'Lava Pirate'
            CFrameQ = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
            CFrameMon = CFrame.new(-5251.1889648438, 55.164535522461, -4774.4096679688)
        elseif _Value == 1250 or (_Value <= 1274 or (SelectMonster == 'Ship Deckhand' or SelectArea == 'Ship')) then
            Ms = 'Ship Deckhand'
            NameQuest = 'ShipQuest1'
            QuestLv = 1
            NameMon = 'Ship Deckhand'
            CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
            CFrameMon = CFrame.new(921.12365722656, 125.9839553833, 33088.328125)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif _Value == 1275 or (_Value <= 1299 or (SelectMonster == 'Ship Engineer' or SelectArea == 'Ship')) then
            Ms = 'Ship Engineer'
            NameQuest = 'ShipQuest1'
            QuestLv = 2
            NameMon = 'Ship Engineer'
            CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
            CFrameMon = CFrame.new(886.28179931641, 40.47790145874, 32800.83203125)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif _Value == 1300 or (_Value <= 1324 or (SelectMonster == 'Ship Steward' or SelectArea == 'Ship')) then
            Ms = 'Ship Steward'
            NameQuest = 'ShipQuest2'
            QuestLv = 1
            NameMon = 'Ship Steward'
            CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
            CFrameMon = CFrame.new(943.85504150391, 129.58183288574, 33444.3671875)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif _Value == 1325 or (_Value <= 1349 or (SelectMonster == 'Ship Officer' or SelectArea == 'Ship')) then
            Ms = 'Ship Officer'
            NameQuest = 'ShipQuest2'
            QuestLv = 2
            NameMon = 'Ship Officer'
            CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
            CFrameMon = CFrame.new(955.38458251953, 181.08335876465, 33331.890625)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif _Value == 1350 or (_Value <= 1374 or (SelectMonster == 'Arctic Warrior' or SelectArea == 'Frost')) then
            Ms = 'Arctic Warrior'
            NameQuest = 'FrostQuest'
            QuestLv = 1
            NameMon = 'Arctic Warrior'
            CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
            CFrameMon = CFrame.new(5935.4541015625, 77.26016998291, -6472.7568359375)

            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422))
            end
        elseif _Value == 1375 or (_Value <= 1424 or (SelectMonster == 'Snow Lurker' or SelectArea == 'Frost')) then
            Ms = 'Snow Lurker'
            NameQuest = 'FrostQuest'
            QuestLv = 2
            NameMon = 'Snow Lurker'
            CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
            CFrameMon = CFrame.new(5628.482421875, 57.574996948242, -6618.3481445313)
        elseif _Value == 1425 or (_Value <= 1449 or (SelectMonster == 'Sea Soldier' or SelectArea == 'Forgotten')) then
            Ms = 'Sea Soldier'
            NameQuest = 'ForgottenQuest'
            QuestLv = 1
            NameMon = 'Sea Soldier'
            CFrameQ = CFrame.new(-3054.5827636719, 236.87213134766, -10147.790039063)
            CFrameMon = CFrame.new(-3185.0153808594, 58.789089202881, -9663.6064453125)
        elseif _Value >= 1450 or (SelectMonster == 'Water Fighter' or SelectArea == 'Forgotten') then
            Ms = 'Water Fighter'
            NameQuest = 'ForgottenQuest'
            QuestLv = 2
            NameMon = 'Water Fighter'
            CFrameQ = CFrame.new(-3054.5827636719, 236.87213134766, -10147.790039063)
            CFrameMon = CFrame.new(-3262.9301757813, 298.69036865234, -10552.529296875)
        end
    end
    if Third_Sea then
        if _Value == 1500 or (_Value <= 1524 or (SelectMonster == 'Pirate Millionaire' or SelectArea == 'Pirate Port')) then
            Ms = 'Pirate Millionaire'
            NameQuest = 'PiratePortQuest'
            QuestLv = 1
            NameMon = 'Pirate Millionaire'
            CFrameQ = CFrame.new(-289.61752319336, 43.819011688232, 5580.0903320313)
            CFrameMon = CFrame.new(-435.68109130859, 189.69866943359, 5551.0756835938)
        elseif _Value == 1525 or (_Value <= 1574 or (SelectMonster == 'Pistol Billionaire' or SelectArea == 'Pirate Port')) then
            Ms = 'Pistol Billionaire'
            NameQuest = 'PiratePortQuest'
            QuestLv = 2
            NameMon = 'Pistol Billionaire'
            CFrameQ = CFrame.new(-289.61752319336, 43.819011688232, 5580.0903320313)
            CFrameMon = CFrame.new(-236.53652954102, 217.46676635742, 6006.0883789063)
        elseif _Value == 1575 or (_Value <= 1599 or (SelectMonster == 'Dragon Crew Warrior' or SelectArea == 'Amazon')) then
            Ms = 'Dragon Crew Warrior'
            NameQuest = 'AmazonQuest'
            QuestLv = 1
            NameMon = 'Dragon Crew Warrior'
            CFrameQ = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
            CFrameMon = CFrame.new(6301.9975585938, 104.77153015137, -1082.6075439453)
        elseif _Value == 1600 or (_Value <= 1624 or (SelectMonster == 'Dragon Crew Archer' or SelectArea == 'Amazon')) then
            Ms = 'Dragon Crew Archer'
            NameQuest = 'AmazonQuest'
            QuestLv = 2
            NameMon = 'Dragon Crew Archer'
            CFrameQ = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
            CFrameMon = CFrame.new(6831.1171875, 441.76708984375, 446.58615112305)
        elseif _Value == 1625 or (_Value <= 1649 or (SelectMonster == 'Female Islander' or SelectArea == 'Amazon')) then
            Ms = 'Female Islander'
            NameQuest = 'AmazonQuest2'
            QuestLv = 1
            NameMon = 'Female Islander'
            CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
            CFrameMon = CFrame.new(5792.5166015625, 848.14392089844, 1084.1818847656)
        elseif _Value == 1650 or (_Value <= 1699 or (SelectMonster == 'Giant Islander' or SelectArea == 'Amazon')) then
            Ms = 'Giant Islander'
            NameQuest = 'AmazonQuest2'
            QuestLv = 2
            NameMon = 'Giant Islander'
            CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
            CFrameMon = CFrame.new(5009.5068359375, 664.11071777344, -40.960144042969)
        elseif _Value == 1700 or (_Value <= 1724 or (SelectMonster == 'Marine Commodore' or SelectArea == 'Marine Tree')) then
            Ms = 'Marine Commodore'
            NameQuest = 'MarineTreeIsland'
            QuestLv = 1
            NameMon = 'Marine Commodore'
            CFrameQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
            CFrameMon = CFrame.new(2198.0063476563, 128.71075439453, -7109.5043945313)
        elseif _Value == 1725 or (_Value <= 1774 or (SelectMonster == 'Marine Rear Admiral' or SelectArea == 'Marine Tree')) then
            Ms = 'Marine Rear Admiral'
            NameQuest = 'MarineTreeIsland'
            QuestLv = 2
            NameMon = 'Marine Rear Admiral'
            CFrameQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
            CFrameMon = CFrame.new(3294.3142089844, 385.41125488281, -7048.6342773438)
        elseif _Value == 1775 or (_Value <= 1799 or (SelectMonster == 'Fishman Raider' or SelectArea == 'Deep Forest')) then
            Ms = 'Fishman Raider'
            NameQuest = 'DeepForestIsland3'
            QuestLv = 1
            NameMon = 'Fishman Raider'
            CFrameQ = CFrame.new(-10582.759765625, 331.78845214844, -8757.666015625)
            CFrameMon = CFrame.new(-10553.268554688, 521.38439941406, -8176.9458007813)
        elseif _Value == 1800 or (_Value <= 1824 or (SelectMonster == 'Fishman Captain' or SelectArea == 'Deep Forest')) then
            Ms = 'Fishman Captain'
            NameQuest = 'DeepForestIsland3'
            QuestLv = 2
            NameMon = 'Fishman Captain'
            CFrameQ = CFrame.new(-10583.099609375, 331.78845214844, -8759.4638671875)
            CFrameMon = CFrame.new(-10789.401367188, 427.18637084961, -9131.4423828125)
        elseif _Value == 1825 or (_Value <= 1849 or (SelectMonster == 'Forest Pirate' or SelectArea == 'Deep Forest')) then
            Ms = 'Forest Pirate'
            NameQuest = 'DeepForestIsland'
            QuestLv = 1
            NameMon = 'Forest Pirate'
            CFrameQ = CFrame.new(-13232.662109375, 332.40396118164, -7626.4819335938)
            CFrameMon = CFrame.new(-13489.397460938, 400.30349731445, -7770.251953125)
        elseif _Value == 1850 or (_Value <= 1899 or (SelectMonster == 'Mythological Pirate' or SelectArea == 'Deep Forest')) then
            Ms = 'Mythological Pirate'
            NameQuest = 'DeepForestIsland'
            QuestLv = 2
            NameMon = 'Mythological Pirate'
            CFrameQ = CFrame.new(-13232.662109375, 332.40396118164, -7626.4819335938)
            CFrameMon = CFrame.new(-13508.616210938, 582.46228027344, -6985.3037109375)
        elseif _Value == 1900 or (_Value <= 1924 or (SelectMonster == 'Jungle Pirate' or SelectArea == 'Deep Forest')) then
            Ms = 'Jungle Pirate'
            NameQuest = 'DeepForestIsland2'
            QuestLv = 1
            NameMon = 'Jungle Pirate'
            CFrameQ = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
            CFrameMon = CFrame.new(-12267.103515625, 459.75262451172, -10277.200195313)
        elseif _Value == 1925 or (_Value <= 1974 or (SelectMonster == 'Musketeer Pirate' or SelectArea == 'Deep Forest')) then
            Ms = 'Musketeer Pirate'
            NameQuest = 'DeepForestIsland2'
            QuestLv = 2
            NameMon = 'Musketeer Pirate'
            CFrameQ = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
            CFrameMon = CFrame.new(-13291.5078125, 520.47338867188, -9904.638671875)
        elseif _Value == 1975 or (_Value <= 1999 or (SelectMonster == 'Reborn Skeleton' or SelectArea == 'Haunted Castle')) then
            Ms = 'Reborn Skeleton'
            NameQuest = 'HauntedQuest1'
            QuestLv = 1
            NameMon = 'Reborn Skeleton'
            CFrameQ = CFrame.new(-9480.80762, 142.130661, 5566.37305, -0.00655503059, 4.52954225e-8, -0.999978542, 2.04920472e-8, 1, 4.51620679e-8, 0.999978542, -2.01955679e-8, -0.00655503059)
            CFrameMon = CFrame.new(-8761.77148, 183.431747, 6168.33301, 0.978073597, -0.000013950732, -0.208259016, -1.08073925e-6, 1, -0.0000720630269, 0.208259016, 0.0000707080399, 0.978073597)
        elseif _Value == 2000 or (_Value <= 2024 or (SelectMonster == 'Living Zombie' or SelectArea == 'Haunted Castle')) then
            Ms = 'Living Zombie'
            NameQuest = 'HauntedQuest1'
            QuestLv = 2
            NameMon = 'Living Zombie'
            CFrameQ = CFrame.new(-9480.80762, 142.130661, 5566.37305, -0.00655503059, 4.52954225e-8, -0.999978542, 2.04920472e-8, 1, 4.51620679e-8, 0.999978542, -2.01955679e-8, -0.00655503059)
            CFrameMon = CFrame.new(-10103.7529, 238.565979, 6179.75977, 0.999474227, 2.7754714099999998e-8, 0.0324240364, -2.58006327e-8, 1, -6.06848474e-8, -0.0324240364, 5.98163865e-8, 0.999474227)
        elseif _Value == 2025 or (_Value <= 2049 or (SelectMonster == 'Demonic Soul' or SelectArea == 'Haunted Castle')) then
            Ms = 'Demonic Soul'
            NameQuest = 'HauntedQuest2'
            QuestLv = 1
            NameMon = 'Demonic Soul'
            CFrameQ = CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
            CFrameMon = CFrame.new(-9712.03125, 204.69589233398, 6193.322265625)
        elseif _Value == 2050 or (_Value <= 2074 or (SelectMonster == 'Posessed Mummy' or SelectArea == 'Haunted Castle')) then
            Ms = 'Posessed Mummy'
            NameQuest = 'HauntedQuest2'
            QuestLv = 2
            NameMon = 'Posessed Mummy'
            CFrameQ = CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
            CFrameMon = CFrame.new(-9545.7763671875, 69.619895935059, 6339.5615234375)
        elseif _Value == 2075 or (_Value <= 2099 or (SelectMonster == 'Peanut Scout' or SelectArea == 'Nut Island')) then
            Ms = 'Peanut Scout'
            NameQuest = 'NutsIslandQuest'
            QuestLv = 1
            NameMon = 'Peanut Scout'
            CFrameQ = CFrame.new(-2105.53198, 37.2495995, -10195.5088, -0.766061664, 0, -0.642767608, 0, 1, 0, 0.642767608, 0, -0.766061664)
            CFrameMon = CFrame.new(-2150.587890625, 122.49767303467, -10358.994140625)
        elseif _Value == 2100 or (_Value <= 2124 or (SelectMonster == 'Peanut President' or SelectArea == 'Nut Island')) then
            Ms = 'Peanut President'
            NameQuest = 'NutsIslandQuest'
            QuestLv = 2
            NameMon = 'Peanut President'
            CFrameQ = CFrame.new(-2105.53198, 37.2495995, -10195.5088, -0.766061664, 0, -0.642767608, 0, 1, 0, 0.642767608, 0, -0.766061664)
            CFrameMon = CFrame.new(-2150.587890625, 122.49767303467, -10358.994140625)
        elseif _Value == 2125 or (_Value <= 2149 or (SelectMonster == 'Ice Cream Chef' or SelectArea == 'Ice Cream Island')) then
            Ms = 'Ice Cream Chef'
            NameQuest = 'IceCreamIslandQuest'
            QuestLv = 1
            NameMon = 'Ice Cream Chef'
            CFrameQ = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
            CFrameMon = CFrame.new(-789.941528, 209.382889, -11009.9805, -0.0703101531, 0, -0.997525156, 0, 1.00000012, 0, 0.997525275, 0, -0.0703101456)
        elseif _Value == 2150 or (_Value <= 2199 or (SelectMonster == 'Ice Cream Commander' or SelectArea == 'Ice Cream Island')) then
            Ms = 'Ice Cream Commander'
            NameQuest = 'IceCreamIslandQuest'
            QuestLv = 2
            NameMon = 'Ice Cream Commander'
            CFrameQ = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
            CFrameMon = CFrame.new(-789.941528, 209.382889, -11009.9805, -0.0703101531, 0, -0.997525156, 0, 1.00000012, 0, 0.997525275, 0, -0.0703101456)
        elseif _Value == 2200 or (_Value <= 2224 or (SelectMonster == 'Cookie Crafter' or SelectArea == 'Cake Island')) then
            Ms = 'Cookie Crafter'
            NameQuest = 'CakeQuest1'
            QuestLv = 1
            NameMon = 'Cookie Crafter'
            CFrameQ = CFrame.new(-2022.29858, 36.9275894, -12030.9766, -0.961273909, 0, -0.275594592, 0, 1, 0, 0.275594592, 0, -0.961273909)
            CFrameMon = CFrame.new(-2321.71216, 36.699482, -12216.7871, -0.780074954, 0, 0.625686109, 0, 1, 0, -0.625686109, 0, -0.780074954)
        elseif _Value == 2225 or (_Value <= 2249 or (SelectMonster == 'Cake Guard' or SelectArea == 'Cake Island')) then
            Ms = 'Cake Guard'
            NameQuest = 'CakeQuest1'
            QuestLv = 2
            NameMon = 'Cake Guard'
            CFrameQ = CFrame.new(-2022.29858, 36.9275894, -12030.9766, -0.961273909, 0, -0.275594592, 0, 1, 0, 0.275594592, 0, -0.961273909)
            CFrameMon = CFrame.new(-1418.11011, 36.6718941, -12255.7324, 0.0677844882, 0, 0.997700036, 0, 1, 0, -0.997700036, 0, 0.0677844882)
        elseif _Value == 2250 or (_Value <= 2274 or (SelectMonster == 'Baking Staff' or SelectArea == 'Cake Island')) then
            Ms = 'Baking Staff'
            NameQuest = 'CakeQuest2'
            QuestLv = 1
            NameMon = 'Baking Staff'
            CFrameQ = CFrame.new(-1928.31763, 37.7296638, -12840.626, 0.951068401, 0, -0.308980465, 0, 1, 0, 0.308980465, 0, 0.951068401)
            CFrameMon = CFrame.new(-1980.43848, 36.6716766, -12983.8418, -0.254443765, 0, -0.967087567, 0, 1, 0, 0.967087567, 0, -0.254443765)
        elseif _Value == 2275 or (_Value <= 2299 or (SelectMonster == 'Head Baker' or SelectArea == 'Cake Island')) then
            Ms = 'Head Baker'
            NameQuest = 'CakeQuest2'
            QuestLv = 2
            NameMon = 'Head Baker'
            CFrameQ = CFrame.new(-1928.31763, 37.7296638, -12840.626, 0.951068401, 0, -0.308980465, 0, 1, 0, 0.308980465, 0, 0.951068401)
            CFrameMon = CFrame.new(-2251.5791, 52.2714615, -13033.3965, -0.991971016, 0, -0.126466095, 0, 1, 0, 0.126466095, 0, -0.991971016)
        elseif _Value == 2300 or (_Value <= 2324 or (SelectMonster == 'Cocoa Warrior' or SelectArea == 'Choco Island')) then
            Ms = 'Cocoa Warrior'
            NameQuest = 'ChocQuest1'
            QuestLv = 1
            NameMon = 'Cocoa Warrior'
            CFrameQ = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
            CFrameMon = CFrame.new(167.978516, 26.2254658, -12238.874, -0.939700961, 0, 0.341998369, 0, 1, 0, -0.341998369, 0, -0.939700961)
        elseif _Value == 2325 or (_Value <= 2349 or (SelectMonster == 'Chocolate Bar Battler' or SelectArea == 'Choco Island')) then
            Ms = 'Chocolate Bar Battler'
            NameQuest = 'ChocQuest1'
            QuestLv = 2
            NameMon = 'Chocolate Bar Battler'
            CFrameQ = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
            CFrameMon = CFrame.new(701.312073, 25.5824986, -12708.2148, -0.342042685, 0, -0.939684391, 0, 1, 0, 0.939684391, 0, -0.342042685)
        elseif _Value == 2350 or (_Value <= 2374 or (SelectMonster == 'Sweet Thief' or SelectArea == 'Choco Island')) then
            Ms = 'Sweet Thief'
            NameQuest = 'ChocQuest2'
            QuestLv = 1
            NameMon = 'Sweet Thief'
            CFrameQ = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
            CFrameMon = CFrame.new(-140.258301, 25.5824986, -12652.3115, 0.173624337, 0, -0.984811902, 0, 1, 0, 0.984811902, 0, 0.173624337)
        elseif _Value == 2375 or (_Value <= 2400 or (SelectMonster == 'Candy Rebel' or SelectArea == 'Choco Island')) then
            Ms = 'Candy Rebel'
            NameQuest = 'ChocQuest2'
            QuestLv = 2
            NameMon = 'Candy Rebel'
            CFrameQ = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
            CFrameMon = CFrame.new(47.9231453, 25.5824986, -13029.2402, -0.819156051, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, -0.819156051)
        elseif _Value == 2400 or (_Value <= 2424 or (SelectMonster == 'Candy Pirate' or SelectArea == 'Candy Island')) then
            Ms = 'Candy Pirate'
            NameQuest = 'CandyQuest1'
            QuestLv = 1
            NameMon = 'Candy Pirate'
            CFrameQ = CFrame.new(-1149.328, 13.5759039, -14445.6143, -0.156446099, 0, -0.987686574, 0, 1, 0, 0.987686574, 0, -0.156446099)
            CFrameMon = CFrame.new(-1437.56348, 17.1481285, -14385.6934, 0.173624337, 0, -0.984811902, 0, 1, 0, 0.984811902, 0, 0.173624337)
        elseif _Value == 2425 or (_Value <= 2449 or (SelectMonster == 'Snow Demon' or SelectArea == 'Candy Island')) then
            Ms = 'Snow Demon'
            NameQuest = 'CandyQuest1'
            QuestLv = 2
            NameMon = 'Snow Demon'
            CFrameQ = CFrame.new(-1149.328, 13.5759039, -14445.6143, -0.156446099, 0, -0.987686574, 0, 1, 0, 0.987686574, 0, -0.156446099)
            CFrameMon = CFrame.new(-916.222656, 17.1481285, -14638.8125, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
        elseif _Value == 2450 or (_Value <= 2474 or (SelectMonster == 'Isle Outlaw' or SelectArea == 'Tiki Outpost')) then
            Ms = 'Isle Outlaw'
            NameQuest = 'TikiQuest1'
            QuestLv = 1
            NameMon = 'Isle Outlaw'
            CFrameQ = CFrame.new(-16549.890625, 55.68635559082031, -179.91360473632813)
            CFrameMon = CFrame.new(-16162.8193359375, 11.6863374710083, -96.45481872558594)
        elseif _Value == 2475 or (_Value <= 2524 or (SelectMonster == 'Island Boy' or SelectArea == 'Tiki Outpost')) then
            Ms = 'Island Boy'
            NameQuest = 'TikiQuest1'
            QuestLv = 2
            NameMon = 'Island Boy'
            CFrameQ = CFrame.new(-16549.890625, 55.68635559082031, -179.91360473632813)
            CFrameMon = CFrame.new(-16912.130859375, 11.787443161010742, -133.0850830078125)
        elseif _Value >= 2525 or (SelectMonster == 'Isle Champion' or SelectArea == 'Tiki Outpost') then
            Ms = 'Isle Champion'
            NameQuest = 'TikiQuest2'
            QuestLv = 2
            NameMon = 'Isle Champion'
            CFrameQ = CFrame.new(-16542.447265625, 55.68632888793945, 1044.41650390625)
            CFrameMon = CFrame.new(-16848.94140625, 21.68633460998535, 1041.4490966796875)
        end
    end
end

if First_Sea then
    tableMon = {
        'Bandit',
        'Monkey',
        'Gorilla',
        'Pirate',
        'Brute',
        'Desert Bandit',
        'Desert Officer',
        'Snow Bandit',
        'Snowman',
        'Chief Petty Officer',
        'Sky Bandit',
        'Dark Master',
        'Prisoner',
        'Dangerous Prisoner',
        'Toga Warrior',
        'Gladiator',
        'Military Soldier',
        'Military Spy',
        'Fishman Warrior',
        'Fishman Commando',
        "God's Guard",
        'Shanda',
        'Royal Squad',
        'Royal Soldier',
        'Galley Pirate',
        'Galley Captain',
    }
elseif Second_Sea then
    tableMon = {
        'Raider',
        'Mercenary',
        'Swan Pirate',
        'Factory Staff',
        'Marine Lieutenant',
        'Marine Captain',
        'Zombie',
        'Vampire',
        'Snow Trooper',
        'Winter Warrior',
        'Lab Subordinate',
        'Horned Warrior',
        'Magma Ninja',
        'Lava Pirate',
        'Ship Deckhand',
        'Ship Engineer',
        'Ship Steward',
        'Ship Officer',
        'Arctic Warrior',
        'Snow Lurker',
        'Sea Soldier',
        'Water Fighter',
    }
elseif Third_Sea then
    tableMon = {
        'Pirate Millionaire',
        'Dragon Crew Warrior',
        'Dragon Crew Archer',
        'Female Islander',
        'Giant Islander',
        'Marine Commodore',
        'Marine Rear Admiral',
        'Fishman Raider',
        'Fishman Captain',
        'Forest Pirate',
        'Mythological Pirate',
        'Jungle Pirate',
        'Musketeer Pirate',
        'Reborn Skeleton',
        'Living Zombie',
        'Demonic Soul',
        'Posessed Mummy',
        'Peanut Scout',
        'Peanut President',
        'Ice Cream Chef',
        'Ice Cream Commander',
        'Cookie Crafter',
        'Cake Guard',
        'Baking Staff',
        'Head Baker',
        'Cocoa Warrior',
        'Chocolate Bar Battler',
        'Sweet Thief',
        'Candy Rebel',
        'Candy Pirate',
        'Snow Demon',
        'Isle Outlaw',
        'Island Boy',
        'Isle Champion',
    }
end
if First_Sea then
    AreaList = {
        'Jungle',
        'Buggy',
        'Desert',
        'Snow',
        'Marine',
        'Sky',
        'Prison',
        'Colosseum',
        'Magma',
        'Fishman',
        'Sky Island',
        'Fountain',
    }
elseif Second_Sea then
    AreaList = {
        'Area 1',
        'Area 2',
        'Zombie',
        'Marine',
        'Snow Mountain',
        'Ice fire',
        'Ship',
        'Frost',
        'Forgotten',
    }
elseif Third_Sea then
    AreaList = {
        'Pirate Port',
        'Amazon',
        'Marine Tree',
        'Deep Forest',
        'Haunted Castle',
        'Nut Island',
        'Ice Cream Island',
        'Cake Island',
        'Choco Island',
        'Candy Island',
        'Tiki Outpost',
    }
end

function CheckBossQuest()
    if First_Sea then
        if SelectBoss ~= 'The Gorilla King' then
            if SelectBoss ~= 'Bobby' then
                if SelectBoss ~= 'The Saw' then
                    if SelectBoss ~= 'Yeti' then
                        if SelectBoss ~= 'Mob Leader' then
                            if SelectBoss ~= 'Vice Admiral' then
                                if SelectBoss ~= 'Saber Expert' then
                                    if SelectBoss ~= 'Warden' then
                                        if SelectBoss ~= 'Chief Warden' then
                                            if SelectBoss ~= 'Swan' then
                                                if SelectBoss ~= 'Magma Admiral' then
                                                    if SelectBoss ~= 'Fishman Lord' then
                                                        if SelectBoss ~= 'Wysper' then
                                                            if SelectBoss ~= 'Thunder God' then
                                                                if SelectBoss ~= 'Cyborg' then
                                                                    if SelectBoss ~= 'Ice Admiral' then
                                                                        if SelectBoss == 'Greybeard' then
                                                                            BossMon = 'Greybeard'
                                                                            NameBoss = 'Greybeard'
                                                                            CFrameBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
                                                                        end
                                                                    else
                                                                        BossMon = 'Ice Admiral'
                                                                        NameBoss = 'Ice Admiral'
                                                                        CFrameBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
                                                                    end
                                                                else
                                                                    BossMon = 'Cyborg'
                                                                    NameBoss = 'Cyborg'
                                                                    NameQuestBoss = 'FountainQuest'
                                                                    QuestLvBoss = 3
                                                                    RewardBoss = 'Reward:\n$20,000\n7,500,000 Exp.'
                                                                    CFrameQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
                                                                    CFrameBoss = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
                                                                end
                                                            else
                                                                BossMon = 'Thunder God'
                                                                NameBoss = 'Thunder God'
                                                                NameQuestBoss = 'SkyExp2Quest'
                                                                QuestLvBoss = 3
                                                                RewardBoss = 'Reward:\n$20,000\n5,800,000 Exp.'
                                                                CFrameQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
                                                                CFrameBoss = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
                                                            end
                                                        else
                                                            BossMon = 'Wysper'
                                                            NameBoss = 'Wysper'
                                                            NameQuestBoss = 'SkyExp1Quest'
                                                            QuestLvBoss = 3
                                                            RewardBoss = 'Reward:\n$15,000\n4,800,000 Exp.'
                                                            CFrameQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094)
                                                            CFrameBoss = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
                                                        end
                                                    else
                                                        BossMon = 'Fishman Lord'
                                                        NameBoss = 'Fishman Lord'
                                                        NameQuestBoss = 'FishmanQuest'
                                                        QuestLvBoss = 3
                                                        RewardBoss = 'Reward:\n$15,000\n4,000,000 Exp.'
                                                        CFrameQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                                                        CFrameBoss = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
                                                    end
                                                else
                                                    BossMon = 'Magma Admiral'
                                                    NameBoss = 'Magma Admiral'
                                                    NameQuestBoss = 'MagmaQuest'
                                                    QuestLvBoss = 3
                                                    RewardBoss = 'Reward:\n$15,000\n2,800,000 Exp.'
                                                    CFrameQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
                                                    CFrameBoss = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
                                                end
                                            else
                                                BossMon = 'Swan'
                                                NameBoss = 'Swan'
                                                NameQuestBoss = 'ImpelQuest'
                                                QuestLvBoss = 3
                                                RewardBoss = 'Reward:\n$15,000\n1,600,000 Exp.'
                                                CFrameBoss = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812)
                                                CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
                                            end
                                        else
                                            BossMon = 'Chief Warden'
                                            NameBoss = 'Chief Warden'
                                            NameQuestBoss = 'ImpelQuest'
                                            QuestLvBoss = 2
                                            RewardBoss = 'Reward:\n$10,000\n1,000,000 Exp.'
                                            CFrameBoss = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -0.0000280422337, -0.939682961, 0.00181045406, 0.342041939)
                                            CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
                                        end
                                    else
                                        BossMon = 'Warden'
                                        NameBoss = 'Warden'
                                        NameQuestBoss = 'ImpelQuest'
                                        QuestLvBoss = 1
                                        RewardBoss = 'Reward:\n$6,000\n850,000 Exp.'
                                        CFrameBoss = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.4994640100000005e-6, 0.975376427, -0.0000195412576, 1, 9.031620720000001e-6, -0.975376427, -0.0000210519756, 0.220546961)
                                        CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
                                    end
                                else
                                    NameBoss = 'Saber Expert'
                                    BossMon = 'Saber Expert'
                                    CFrameBoss = CFrame.new(-1458.89502, 29.8870335, -50.633564)
                                end
                            else
                                BossMon = 'Vice Admiral'
                                NameBoss = 'Vice Admiral'
                                NameQuestBoss = 'MarineQuest2'
                                QuestLvBoss = 2
                                RewardBoss = 'Reward:\n$10,000\n180,000 Exp.'
                                CFrameQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
                                CFrameBoss = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
                            end
                        else
                            BossMon = 'Mob Leader'
                            NameBoss = 'Mob Leader'
                            CFrameBoss = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
                        end
                    else
                        BossMon = 'Yeti'
                        NameBoss = 'Yeti'
                        NameQuestBoss = 'SnowQuest'
                        QuestLvBoss = 3
                        RewardBoss = 'Reward:\n$10,000\n180,000 Exp.'
                        CFrameQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
                        CFrameBoss = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
                    end
                else
                    BossMon = 'The Saw'
                    NameBoss = 'The Saw'
                    CFrameBoss = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
                end
            else
                BossMon = 'Bobby'
                NameBoss = 'Bobby'
                NameQuestBoss = 'BuggyQuest1'
                QuestLvBoss = 3
                RewardBoss = 'Reward:\n$8,000\n35,000 Exp.'
                CFrameQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
                CFrameBoss = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
            end
        else
            BossMon = 'The Gorilla King'
            NameBoss = 'The Gorrila King'
            NameQuestBoss = 'JungleQuest'
            QuestLvBoss = 3
            RewardBoss = 'Reward:\n$2,000\n7,000 Exp.'
            CFrameQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameBoss = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
        end
    end
    if Second_Sea then
        if SelectBoss ~= 'Diamond' then
            if SelectBoss ~= 'Jeremy' then
                if SelectBoss ~= 'Fajita' then
                    if SelectBoss ~= 'Don Swan' then
                        if SelectBoss ~= 'Smoke Admiral' then
                            if SelectBoss ~= 'Awakened Ice Admiral' then
                                if SelectBoss ~= 'Tide Keeper' then
                                    if SelectBoss ~= 'Darkbeard' then
                                        if SelectBoss ~= 'Cursed Captain' then
                                            if SelectBoss == 'Order' then
                                                BossMon = 'Order'
                                                NameBoss = 'Order'
                                                CFrameBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
                                            end
                                        else
                                            BossMon = 'Cursed Captain'
                                            NameBoss = 'Cursed Captain'
                                            CFrameBoss = CFrame.new(916.928589, 181.092773, 33422)
                                        end
                                    else
                                        BossMon = 'Darkbeard'
                                        NameBoss = 'Darkbeard'
                                        CFrameMon = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
                                    end
                                else
                                    BossMon = 'Tide Keeper'
                                    NameBoss = 'Tide Keeper'
                                    NameQuestBoss = 'ForgottenQuest'
                                    QuestLvBoss = 3
                                    RewardBoss = 'Reward:\n$12,500\n38,000,000 Exp.'
                                    CFrameQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)
                                    CFrameBoss = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
                                end
                            else
                                BossMon = 'Awakened Ice Admiral'
                                NameBoss = 'Awakened Ice Admiral'
                                NameQuestBoss = 'FrostQuest'
                                QuestLvBoss = 3
                                RewardBoss = 'Reward:\n$20,000\n36,000,000 Exp.'
                                CFrameQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)
                                CFrameBoss = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
                            end
                        else
                            BossMon = 'Smoke Admiral'
                            NameBoss = 'Smoke Admiral'
                            NameQuestBoss = 'IceSideQuest'
                            QuestLvBoss = 3
                            RewardBoss = 'Reward:\n$20,000\n25,000,000 Exp.'
                            CFrameQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
                            CFrameBoss = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
                        end
                    else
                        BossMon = 'Don Swan'
                        NameBoss = 'Don Swan'
                        CFrameBoss = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
                    end
                else
                    BossMon = 'Fajita'
                    NameBoss = 'Fajita'
                    NameQuestBoss = 'MarineQuest3'
                    QuestLvBoss = 3
                    RewardBoss = 'Reward:\n$25,000\n15,000,000 Exp.'
                    CFrameQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031)
                    CFrameBoss = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
                end
            else
                BossMon = 'Jeremy'
                NameBoss = 'Jeremy'
                NameQuestBoss = 'Area2Quest'
                QuestLvBoss = 3
                RewardBoss = 'Reward:\n$25,000\n11,500,000 Exp.'
                CFrameQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
                CFrameBoss = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
            end
        else
            BossMon = 'Diamond'
            NameBoss = 'Diamond'
            NameQuestBoss = 'Area1Quest'
            QuestLvBoss = 3
            RewardBoss = 'Reward:\n$25,000\n9,000,000 Exp.'
            CFrameQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
            CFrameBoss = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
        end
    end
    if Third_Sea then
        if SelectBoss ~= 'Stone' then
            if SelectBoss ~= 'Island Empress' then
                if SelectBoss ~= 'Kilo Admiral' then
                    if SelectBoss ~= 'Captain Elephant' then
                        if SelectBoss ~= 'Beautiful Pirate' then
                            if SelectBoss ~= 'Cake Queen' then
                                if SelectBoss ~= 'Longma' then
                                    if SelectBoss ~= 'Soul Reaper' then
                                        if SelectBoss == 'rip_indra True Form' then
                                            BossMon = 'rip_indra True Form'
                                            NameBoss = 'rip_indra True Form'
                                            CFrameBoss = CFrame.new(-5415.3920898438, 505.74133300781, -2814.0166015625)
                                        end
                                    else
                                        BossMon = 'Soul Reaper'
                                        NameBoss = 'Soul Reaper'
                                        CFrameBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
                                    end
                                else
                                    BossMon = 'Longma'
                                    NameBoss = 'Longma'
                                    CFrameBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
                                end
                            else
                                BossMon = 'Cake Queen'
                                NameBoss = 'Cake Queen'
                                NameQuestBoss = 'IceCreamIslandQuest'
                                QuestLvBoss = 3
                                RewardBoss = 'Reward:\n$30,000\n112,500,000 Exp.'
                                CFrameQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
                                CFrameBoss = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
                            end
                        else
                            BossMon = 'Beautiful Pirate'
                            NameBoss = 'Beautiful Pirate'
                            NameQuestBoss = 'DeepForestIsland2'
                            QuestLvBoss = 3
                            RewardBoss = 'Reward:\n$50,000\n70,000,000 Exp.'
                            CFrameQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
                            CFrameBoss = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
                        end
                    else
                        BossMon = 'Captain Elephant'
                        NameBoss = 'Captain Elephant'
                        NameQuestBoss = 'DeepForestIsland'
                        QuestLvBoss = 3
                        RewardBoss = 'Reward:\n$40,000\n67,000,000 Exp.'
                        CFrameQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875)
                        CFrameBoss = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
                    end
                else
                    BossMon = 'Kilo Admiral'
                    NameBoss = 'Kilo Admiral'
                    NameQuestBoss = 'MarineTreeIsland'
                    QuestLvBoss = 3
                    RewardBoss = 'Reward:\n$35,000\n56,000,000 Exp.'
                    CFrameQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938)
                    CFrameBoss = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
                end
            else
                BossMon = 'Island Empress'
                NameBoss = 'Island Empress'
                NameQuestBoss = 'AmazonQuest2'
                QuestLvBoss = 3
                RewardBoss = 'Reward:\n$30,000\n52,000,000 Exp.'
                CFrameQBoss = CFrame.new(5445.9541015625, 601.62945556641, 751.43792724609)
                CFrameBoss = CFrame.new(5543.86328125, 668.97399902344, 199.0341796875)
            end
        else
            BossMon = 'Stone'
            NameBoss = 'Stone'
            NameQuestBoss = 'PiratePortQuest'
            QuestLvBoss = 3
            RewardBoss = 'Reward:\n$25,000\n40,000,000 Exp.'
            CFrameQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
            CFrameBoss = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
        end
    end
end
function MaterialMon()
    if SelectMaterial ~= 'Radioactive Material' then
        if SelectMaterial ~= 'Mystic Droplet' then
            if SelectMaterial ~= 'Magma Ore' then
                if SelectMaterial ~= 'Angel Wings' then
                    if SelectMaterial ~= 'Leather' then
                        if SelectMaterial ~= 'Scrap Metal' then
                            if SelectMaterial ~= 'Fish Tail' then
                                if SelectMaterial ~= 'Demonic Wisp' then
                                    if SelectMaterial ~= 'Vampire Fang' then
                                        if SelectMaterial ~= 'Conjured Cocoa' then
                                            if SelectMaterial ~= 'Dragon Scale' then
                                                if SelectMaterial ~= 'Gunpowder' then
                                                    if SelectMaterial == 'Mini Tusk' then
                                                        MMon = 'Mythological Pirate'
                                                        MPos = CFrame.new(-13545, 470, -6917)
                                                        SP = 'Default'
                                                    end
                                                else
                                                    MMon = 'Pistol Billionaire'
                                                    MPos = CFrame.new(-469, 74, 5904)
                                                    SP = 'Default'
                                                end
                                            else
                                                MMon = 'Dragon Crew Archer'
                                                MPos = CFrame.new(6594, 383, 139)
                                                SP = 'Default'
                                            end
                                        else
                                            MMon = 'Chocolate Bar Battler'
                                            MPos = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)
                                            SP = 'Default'
                                        end
                                    else
                                        MMon = 'Vampire'
                                        MPos = CFrame.new(-6033, 7, -1317)
                                        SP = 'Default'
                                    end
                                else
                                    MMon = 'Demonic Soul'
                                    MPos = CFrame.new(-9507, 172, 6158)
                                    SP = 'Default'
                                end
                            elseif Third_Sea then
                                MMon = 'Fishman Raider'
                                MPos = CFrame.new(-10993, 332, -8940)
                                SP = 'Default'
                            elseif First_Sea then
                                MMon = 'Fishman Warrior'
                                MPos = CFrame.new(61123, 19, 1569)
                                SP = 'Default'

                                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875)).Magnitude >= 17000 then
                                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875))
                                end
                            end
                        elseif First_Sea then
                            MMon = 'Brute'
                            MPos = CFrame.new(-1145, 15, 4350)
                            SP = 'Default'
                        elseif Second_Sea then
                            MMon = 'Swan Pirate'
                            MPos = CFrame.new(878, 122, 1235)
                            SP = 'Default'
                        elseif Third_Sea then
                            MMon = 'Jungle Pirate'
                            MPos = CFrame.new(-12107, 332, -10549)
                            SP = 'Default'
                        end
                    elseif First_Sea then
                        MMon = 'Brute'
                        MPos = CFrame.new(-1145, 15, 4350)
                        SP = 'Default'
                    elseif Second_Sea then
                        MMon = 'Marine Captain'
                        MPos = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375)
                        SP = 'Default'
                    elseif Third_Sea then
                        MMon = 'Jungle Pirate'
                        MPos = CFrame.new(-11975.78515625, 331.7734069824219, -10620.0302734375)
                        SP = 'Default'
                    end
                else
                    MMon = "God's Guard"
                    MPos = CFrame.new(-4698, 845, -1912)
                    SP = 'Default'

                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-7859.09814, 5544.19043, -381.476196)).Magnitude >= 5000 then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-7859.09814, 5544.19043, -381.476196))
                    end
                end
            elseif First_Sea then
                MMon = 'Military Spy'
                MPos = CFrame.new(-5815, 84, 8820)
                SP = 'Default'
            elseif Second_Sea then
                MMon = 'Magma Ninja'
                MPos = CFrame.new(-5428, 78, -5959)
                SP = 'Default'
            end
        else
            MMon = 'Water Fighter'
            MPos = CFrame.new(-3385, 239, -10542)
            SP = 'Default'
        end
    else
        MMon = 'Factory Staff'
        MPos = CFrame.new(295, 73, -56)
        SP = 'Default'
    end
end
function UpdateIslandESP()
    local v16, v17, v18 = pairs(game:GetService('Workspace')._WorldOrigin.Locations:GetChildren())

    while true do
        local u19

        v18, u19 = v16(v17, v18)

        if v18 == nil then
            break
        end

        pcall(function()
            if IslandESP then
                if u19.Name ~= 'Sea' then
                    if u19:FindFirstChild('NameEsp') then
                        u19.NameEsp.TextLabel.Text = u19.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - u19.Position).Magnitude / 3) .. ' Distance'
                    else
                        local _BillboardGui = Instance.new('BillboardGui', u19)

                        _BillboardGui.Name = 'NameEsp'
                        _BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui.Adornee = u19
                        _BillboardGui.AlwaysOnTop = true

                        local _TextLabel = Instance.new('TextLabel', _BillboardGui)

                        _TextLabel.Font = 'GothamBold'
                        _TextLabel.FontSize = 'Size14'
                        _TextLabel.TextWrapped = true
                        _TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel.TextYAlignment = 'Top'
                        _TextLabel.BackgroundTransparency = 1
                        _TextLabel.TextStrokeTransparency = 0.5
                        _TextLabel.TextColor3 = Color3.fromRGB(8, 0, 0)
                    end
                end
            elseif u19:FindFirstChild('NameEsp') then
                u19:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function isnil(p22)
    return p22 == nil
end

local function u24(p23)
    return math.floor(tonumber(p23) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
    local v25, v26, v27 = pairs(game:GetService('Players'):GetChildren())

    while true do
        local u28

        v27, u28 = v25(v26, v27)

        if v27 == nil then
            break
        end

        pcall(function()
            if not isnil(u28.Character) then
                if ESPPlayer then
                    if isnil(u28.Character.Head) or u28.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        u28.Character.Head['NameEsp' .. Number].TextLabel.Text = u28.Name .. ' | ' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u28.Character.Head.Position).Magnitude / 3) .. ' Distance\nHealth : ' .. u24(u28.Character.Humanoid.Health * 100 / u28.Character.Humanoid.MaxHealth) .. '%'
                    else
                        local _BillboardGui2 = Instance.new('BillboardGui', u28.Character.Head)

                        _BillboardGui2.Name = 'NameEsp' .. Number
                        _BillboardGui2.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui2.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui2.Adornee = u28.Character.Head
                        _BillboardGui2.AlwaysOnTop = true

                        local _TextLabel2 = Instance.new('TextLabel', _BillboardGui2)

                        _TextLabel2.Font = Enum.Font.GothamSemibold
                        _TextLabel2.FontSize = 'Size10'
                        _TextLabel2.TextWrapped = true
                        _TextLabel2.Text = u28.Name .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u28.Character.Head.Position).Magnitude / 3) .. ' Distance'
                        _TextLabel2.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel2.TextYAlignment = 'Top'
                        _TextLabel2.BackgroundTransparency = 1
                        _TextLabel2.TextStrokeTransparency = 0.5

                        if u28.Team ~= game.Players.LocalPlayer.Team then
                            _TextLabel2.TextColor3 = Color3.new(255, 0, 0)
                        else
                            _TextLabel2.TextColor3 = Color3.new(0, 0, 254)
                        end
                    end
                elseif u28.Character.Head:FindFirstChild('NameEsp' .. Number) then
                    u28.Character.Head:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateChestChams()
    local v31, v32, v33 = pairs(game.Workspace:GetChildren())

    while true do
        local u34

        v33, u34 = v31(v32, v33)

        if v33 == nil then
            break
        end

        pcall(function()
            if string.find(u34.Name, 'Chest') then
                if ChestESP then
                    if string.find(u34.Name, 'Chest') then
                        if u34:FindFirstChild('NameEsp' .. Number) then
                            u34['NameEsp' .. Number].TextLabel.Text = u34.Name .. '   \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u34.Position).Magnitude / 3) .. ' Distance'
                        else
                            local _BillboardGui3 = Instance.new('BillboardGui', u34)

                            _BillboardGui3.Name = 'NameEsp' .. Number
                            _BillboardGui3.ExtentsOffset = Vector3.new(0, 1, 0)
                            _BillboardGui3.Size = UDim2.new(1, 200, 1, 30)
                            _BillboardGui3.Adornee = u34
                            _BillboardGui3.AlwaysOnTop = true

                            local _TextLabel3 = Instance.new('TextLabel', _BillboardGui3)

                            _TextLabel3.Font = Enum.Font.GothamSemibold
                            _TextLabel3.FontSize = 'Size14'
                            _TextLabel3.TextWrapped = true
                            _TextLabel3.Size = UDim2.new(1, 0, 1, 0)
                            _TextLabel3.TextYAlignment = 'Top'
                            _TextLabel3.BackgroundTransparency = 1
                            _TextLabel3.TextStrokeTransparency = 0.5

                            if u34.Name == 'Chest1' then
                                _TextLabel3.TextColor3 = Color3.fromRGB(109, 109, 109)
                                _TextLabel3.Text = 'Chest 1' .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u34.Position).Magnitude / 3) .. ' Distance'
                            end
                            if u34.Name == 'Chest2' then
                                _TextLabel3.TextColor3 = Color3.fromRGB(173, 158, 21)
                                _TextLabel3.Text = 'Chest 2' .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u34.Position).Magnitude / 3) .. ' Distance'
                            end
                            if u34.Name == 'Chest3' then
                                _TextLabel3.TextColor3 = Color3.fromRGB(85, 255, 255)
                                _TextLabel3.Text = 'Chest 3' .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u34.Position).Magnitude / 3) .. ' Distance'
                            end
                        end
                    end
                elseif u34:FindFirstChild('NameEsp' .. Number) then
                    u34:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateDevilChams()
    local v37, v38, v39 = pairs(game.Workspace:GetChildren())

    while true do
        local u40

        v39, u40 = v37(v38, v39)

        if v39 == nil then
            break
        end

        pcall(function()
            if DevilFruitESP then
                if string.find(u40.Name, 'Fruit') then
                    if u40.Handle:FindFirstChild('NameEsp' .. Number) then
                        u40.Handle['NameEsp' .. Number].TextLabel.Text = u40.Name .. '   \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u40.Handle.Position).Magnitude / 3) .. ' Distance'
                    else
                        local _BillboardGui4 = Instance.new('BillboardGui', u40.Handle)

                        _BillboardGui4.Name = 'NameEsp' .. Number
                        _BillboardGui4.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui4.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui4.Adornee = u40.Handle
                        _BillboardGui4.AlwaysOnTop = true

                        local _TextLabel4 = Instance.new('TextLabel', _BillboardGui4)

                        _TextLabel4.Font = Enum.Font.GothamSemibold
                        _TextLabel4.FontSize = 'Size14'
                        _TextLabel4.TextWrapped = true
                        _TextLabel4.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel4.TextYAlignment = 'Top'
                        _TextLabel4.BackgroundTransparency = 1
                        _TextLabel4.TextStrokeTransparency = 0.5
                        _TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
                        _TextLabel4.Text = u40.Name .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u40.Handle.Position).Magnitude / 3) .. ' Distance'
                    end
                end
            elseif u40.Handle:FindFirstChild('NameEsp' .. Number) then
                u40.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end)
    end
end
function UpdateFlowerChams()
    local v43, v44, v45 = pairs(game.Workspace:GetChildren())

    while true do
        local u46

        v45, u46 = v43(v44, v45)

        if v45 == nil then
            break
        end

        pcall(function()
            if u46.Name == 'Flower2' or u46.Name == 'Flower1' then
                if FlowerESP then
                    if u46:FindFirstChild('NameEsp' .. Number) then
                        u46['NameEsp' .. Number].TextLabel.Text = u46.Name .. '   \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u46.Position).Magnitude / 3) .. ' Distance'
                    else
                        local _BillboardGui5 = Instance.new('BillboardGui', u46)

                        _BillboardGui5.Name = 'NameEsp' .. Number
                        _BillboardGui5.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui5.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui5.Adornee = u46
                        _BillboardGui5.AlwaysOnTop = true

                        local _TextLabel5 = Instance.new('TextLabel', _BillboardGui5)

                        _TextLabel5.Font = Enum.Font.GothamSemibold
                        _TextLabel5.FontSize = 'Size14'
                        _TextLabel5.TextWrapped = true
                        _TextLabel5.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel5.TextYAlignment = 'Top'
                        _TextLabel5.BackgroundTransparency = 1
                        _TextLabel5.TextStrokeTransparency = 0.5
                        _TextLabel5.TextColor3 = Color3.fromRGB(255, 0, 0)

                        if u46.Name == 'Flower1' then
                            _TextLabel5.Text = 'Blue Flower' .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u46.Position).Magnitude / 3) .. ' Distance'
                            _TextLabel5.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if u46.Name == 'Flower2' then
                            _TextLabel5.Text = 'Red Flower' .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u46.Position).Magnitude / 3) .. ' Distance'
                            _TextLabel5.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                elseif u46:FindFirstChild('NameEsp' .. Number) then
                    u46:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateRealFruitChams()
    local v49, v50, v51 = pairs(game.Workspace.AppleSpawner:GetChildren())

    while true do
        local v52

        v51, v52 = v49(v50, v51)

        if v51 == nil then
            break
        end
        if v52:IsA('Tool') then
            if RealFruitESP then
                if v52.Handle:FindFirstChild('NameEsp' .. Number) then
                    v52.Handle['NameEsp' .. Number].TextLabel.Text = v52.Name .. ' ' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - v52.Handle.Position).Magnitude / 3) .. ' Distance'
                else
                    local _BillboardGui6 = Instance.new('BillboardGui', v52.Handle)

                    _BillboardGui6.Name = 'NameEsp' .. Number
                    _BillboardGui6.ExtentsOffset = Vector3.new(0, 1, 0)
                    _BillboardGui6.Size = UDim2.new(1, 200, 1, 30)
                    _BillboardGui6.Adornee = v52.Handle
                    _BillboardGui6.AlwaysOnTop = true

                    local _TextLabel6 = Instance.new('TextLabel', _BillboardGui6)

                    _TextLabel6.Font = Enum.Font.GothamSemibold
                    _TextLabel6.FontSize = 'Size14'
                    _TextLabel6.TextWrapped = true
                    _TextLabel6.Size = UDim2.new(1, 0, 1, 0)
                    _TextLabel6.TextYAlignment = 'Top'
                    _TextLabel6.BackgroundTransparency = 1
                    _TextLabel6.TextStrokeTransparency = 0.5
                    _TextLabel6.TextColor3 = Color3.fromRGB(255, 0, 0)
                    _TextLabel6.Text = v52.Name .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - v52.Handle.Position).Magnitude / 3) .. ' Distance'
                end
            elseif v52.Handle:FindFirstChild('NameEsp' .. Number) then
                v52.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end
    end

    local v55, v56, v57 = pairs(game.Workspace.PineappleSpawner:GetChildren())

    while true do
        local v58

        v57, v58 = v55(v56, v57)

        if v57 == nil then
            break
        end
        if v58:IsA('Tool') then
            if RealFruitESP then
                if v58.Handle:FindFirstChild('NameEsp' .. Number) then
                    v58.Handle['NameEsp' .. Number].TextLabel.Text = v58.Name .. ' ' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - v58.Handle.Position).Magnitude / 3) .. ' Distance'
                else
                    local _BillboardGui7 = Instance.new('BillboardGui', v58.Handle)

                    _BillboardGui7.Name = 'NameEsp' .. Number
                    _BillboardGui7.ExtentsOffset = Vector3.new(0, 1, 0)
                    _BillboardGui7.Size = UDim2.new(1, 200, 1, 30)
                    _BillboardGui7.Adornee = v58.Handle
                    _BillboardGui7.AlwaysOnTop = true

                    local _TextLabel7 = Instance.new('TextLabel', _BillboardGui7)

                    _TextLabel7.Font = Enum.Font.GothamSemibold
                    _TextLabel7.FontSize = 'Size14'
                    _TextLabel7.TextWrapped = true
                    _TextLabel7.Size = UDim2.new(1, 0, 1, 0)
                    _TextLabel7.TextYAlignment = 'Top'
                    _TextLabel7.BackgroundTransparency = 1
                    _TextLabel7.TextStrokeTransparency = 0.5
                    _TextLabel7.TextColor3 = Color3.fromRGB(255, 174, 0)
                    _TextLabel7.Text = v58.Name .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - v58.Handle.Position).Magnitude / 3) .. ' Distance'
                end
            elseif v58.Handle:FindFirstChild('NameEsp' .. Number) then
                v58.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end
    end

    local v61, v62, v63 = pairs(game.Workspace.BananaSpawner:GetChildren())

    while true do
        local v64

        v63, v64 = v61(v62, v63)

        if v63 == nil then
            break
        end
        if v64:IsA('Tool') then
            if RealFruitESP then
                if v64.Handle:FindFirstChild('NameEsp' .. Number) then
                    v64.Handle['NameEsp' .. Number].TextLabel.Text = v64.Name .. ' ' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - v64.Handle.Position).Magnitude / 3) .. ' Distance'
                else
                    local _BillboardGui8 = Instance.new('BillboardGui', v64.Handle)

                    _BillboardGui8.Name = 'NameEsp' .. Number
                    _BillboardGui8.ExtentsOffset = Vector3.new(0, 1, 0)
                    _BillboardGui8.Size = UDim2.new(1, 200, 1, 30)
                    _BillboardGui8.Adornee = v64.Handle
                    _BillboardGui8.AlwaysOnTop = true

                    local _TextLabel8 = Instance.new('TextLabel', _BillboardGui8)

                    _TextLabel8.Font = Enum.Font.GothamSemibold
                    _TextLabel8.FontSize = 'Size14'
                    _TextLabel8.TextWrapped = true
                    _TextLabel8.Size = UDim2.new(1, 0, 1, 0)
                    _TextLabel8.TextYAlignment = 'Top'
                    _TextLabel8.BackgroundTransparency = 1
                    _TextLabel8.TextStrokeTransparency = 0.5
                    _TextLabel8.TextColor3 = Color3.fromRGB(251, 255, 0)
                    _TextLabel8.Text = v64.Name .. ' \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - v64.Handle.Position).Magnitude / 3) .. ' Distance'
                end
            elseif v64.Handle:FindFirstChild('NameEsp' .. Number) then
                v64.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end
    end
end
function UpdateIslandESP()
    local v67, v68, v69 = pairs(game:GetService('Workspace')._WorldOrigin.Locations:GetChildren())

    while true do
        local u70

        v69, u70 = v67(v68, v69)

        if v69 == nil then
            break
        end

        pcall(function()
            if IslandESP then
                if u70.Name ~= 'Sea' then
                    if u70:FindFirstChild('NameEsp') then
                        u70.NameEsp.TextLabel.Text = u70.Name .. '   \n' .. u24((game:GetService('Players').LocalPlayer.Character.Head.Position - u70.Position).Magnitude / 3) .. ' Distance'
                    else
                        local _BillboardGui9 = Instance.new('BillboardGui', u70)

                        _BillboardGui9.Name = 'NameEsp'
                        _BillboardGui9.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui9.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui9.Adornee = u70
                        _BillboardGui9.AlwaysOnTop = true

                        local _TextLabel9 = Instance.new('TextLabel', _BillboardGui9)

                        _TextLabel9.Font = 'GothamBold'
                        _TextLabel9.FontSize = 'Size14'
                        _TextLabel9.TextWrapped = true
                        _TextLabel9.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel9.TextYAlignment = 'Top'
                        _TextLabel9.BackgroundTransparency = 1
                        _TextLabel9.TextStrokeTransparency = 0.5
                        _TextLabel9.TextColor3 = Color3.fromRGB(7, 236, 240)
                    end
                end
            elseif u70:FindFirstChild('NameEsp') then
                u70:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function isnil(p73)
    return p73 == nil
end

local function u75(p74)
    return math.floor(tonumber(p74) + 0.5)
end

Number = math.random(1, 1000000)

function UpdatePlayerChams()
    local v76, v77, v78 = pairs(game:GetService('Players'):GetChildren())

    while true do
        local u79

        v78, u79 = v76(v77, v78)

        if v78 == nil then
            break
        end

        pcall(function()
            if not isnil(u79.Character) then
                if ESPPlayer then
                    if isnil(u79.Character.Head) or u79.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        u79.Character.Head['NameEsp' .. Number].TextLabel.Text = u79.Name .. ' | ' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u79.Character.Head.Position).Magnitude / 3) .. ' Distance\nHealth : ' .. u75(u79.Character.Humanoid.Health * 100 / u79.Character.Humanoid.MaxHealth) .. '%'
                    else
                        local _BillboardGui10 = Instance.new('BillboardGui', u79.Character.Head)

                        _BillboardGui10.Name = 'NameEsp' .. Number
                        _BillboardGui10.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui10.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui10.Adornee = u79.Character.Head
                        _BillboardGui10.AlwaysOnTop = true

                        local _TextLabel10 = Instance.new('TextLabel', _BillboardGui10)

                        _TextLabel10.Font = Enum.Font.GothamSemibold
                        _TextLabel10.FontSize = 'Size14'
                        _TextLabel10.TextWrapped = true
                        _TextLabel10.Text = u79.Name .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u79.Character.Head.Position).Magnitude / 3) .. ' Distance'
                        _TextLabel10.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel10.TextYAlignment = 'Top'
                        _TextLabel10.BackgroundTransparency = 1
                        _TextLabel10.TextStrokeTransparency = 0.5

                        if u79.Team ~= game.Players.LocalPlayer.Team then
                            _TextLabel10.TextColor3 = Color3.new(255, 0, 0)
                        else
                            _TextLabel10.TextColor3 = Color3.new(0, 255, 0)
                        end
                    end
                elseif u79.Character.Head:FindFirstChild('NameEsp' .. Number) then
                    u79.Character.Head:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateChestChams()
    local v82, v83, v84 = pairs(game.Workspace:GetChildren())

    while true do
        local u85

        v84, u85 = v82(v83, v84)

        if v84 == nil then
            break
        end

        pcall(function()
            if string.find(u85.Name, 'Chest') then
                if ChestESP then
                    if string.find(u85.Name, 'Chest') then
                        if u85:FindFirstChild('NameEsp' .. Number) then
                            u85['NameEsp' .. Number].TextLabel.Text = u85.Name .. '   \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u85.Position).Magnitude / 3) .. ' Distance'
                        else
                            local _BillboardGui11 = Instance.new('BillboardGui', u85)

                            _BillboardGui11.Name = 'NameEsp' .. Number
                            _BillboardGui11.ExtentsOffset = Vector3.new(0, 1, 0)
                            _BillboardGui11.Size = UDim2.new(1, 200, 1, 30)
                            _BillboardGui11.Adornee = u85
                            _BillboardGui11.AlwaysOnTop = true

                            local _TextLabel11 = Instance.new('TextLabel', _BillboardGui11)

                            _TextLabel11.Font = Enum.Font.GothamSemibold
                            _TextLabel11.FontSize = 'Size14'
                            _TextLabel11.TextWrapped = true
                            _TextLabel11.Size = UDim2.new(1, 0, 1, 0)
                            _TextLabel11.TextYAlignment = 'Top'
                            _TextLabel11.BackgroundTransparency = 1
                            _TextLabel11.TextStrokeTransparency = 0.5

                            if u85.Name == 'Chest1' then
                                _TextLabel11.TextColor3 = Color3.fromRGB(109, 109, 109)
                                _TextLabel11.Text = 'Chest 1' .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u85.Position).Magnitude / 3) .. ' Distance'
                            end
                            if u85.Name == 'Chest2' then
                                _TextLabel11.TextColor3 = Color3.fromRGB(173, 158, 21)
                                _TextLabel11.Text = 'Chest 2' .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u85.Position).Magnitude / 3) .. ' Distance'
                            end
                            if u85.Name == 'Chest3' then
                                _TextLabel11.TextColor3 = Color3.fromRGB(85, 255, 255)
                                _TextLabel11.Text = 'Chest 3' .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u85.Position).Magnitude / 3) .. ' Distance'
                            end
                        end
                    end
                elseif u85:FindFirstChild('NameEsp' .. Number) then
                    u85:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateDevilChams()
    local v88, v89, v90 = pairs(game.Workspace:GetChildren())

    while true do
        local u91

        v90, u91 = v88(v89, v90)

        if v90 == nil then
            break
        end

        pcall(function()
            if DevilFruitESP then
                if string.find(u91.Name, 'Fruit') then
                    if u91.Handle:FindFirstChild('NameEsp' .. Number) then
                        u91.Handle['NameEsp' .. Number].TextLabel.Text = u91.Name .. '   \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u91.Handle.Position).Magnitude / 3) .. ' Distance'
                    else
                        local _BillboardGui12 = Instance.new('BillboardGui', u91.Handle)

                        _BillboardGui12.Name = 'NameEsp' .. Number
                        _BillboardGui12.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui12.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui12.Adornee = u91.Handle
                        _BillboardGui12.AlwaysOnTop = true

                        local _TextLabel12 = Instance.new('TextLabel', _BillboardGui12)

                        _TextLabel12.Font = Enum.Font.GothamSemibold
                        _TextLabel12.FontSize = 'Size14'
                        _TextLabel12.TextWrapped = true
                        _TextLabel12.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel12.TextYAlignment = 'Top'
                        _TextLabel12.BackgroundTransparency = 1
                        _TextLabel12.TextStrokeTransparency = 0.5
                        _TextLabel12.TextColor3 = Color3.fromRGB(255, 255, 255)
                        _TextLabel12.Text = u91.Name .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u91.Handle.Position).Magnitude / 3) .. ' Distance'
                    end
                end
            elseif u91.Handle:FindFirstChild('NameEsp' .. Number) then
                u91.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end)
    end
end
function UpdateFlowerChams()
    local v94, v95, v96 = pairs(game.Workspace:GetChildren())

    while true do
        local u97

        v96, u97 = v94(v95, v96)

        if v96 == nil then
            break
        end

        pcall(function()
            if u97.Name == 'Flower2' or u97.Name == 'Flower1' then
                if FlowerESP then
                    if u97:FindFirstChild('NameEsp' .. Number) then
                        u97['NameEsp' .. Number].TextLabel.Text = u97.Name .. '   \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u97.Position).Magnitude / 3) .. ' Distance'
                    else
                        local _BillboardGui13 = Instance.new('BillboardGui', u97)

                        _BillboardGui13.Name = 'NameEsp' .. Number
                        _BillboardGui13.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui13.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui13.Adornee = u97
                        _BillboardGui13.AlwaysOnTop = true

                        local _TextLabel13 = Instance.new('TextLabel', _BillboardGui13)

                        _TextLabel13.Font = Enum.Font.GothamSemibold
                        _TextLabel13.FontSize = 'Size14'
                        _TextLabel13.TextWrapped = true
                        _TextLabel13.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel13.TextYAlignment = 'Top'
                        _TextLabel13.BackgroundTransparency = 1
                        _TextLabel13.TextStrokeTransparency = 0.5
                        _TextLabel13.TextColor3 = Color3.fromRGB(255, 0, 0)

                        if u97.Name == 'Flower1' then
                            _TextLabel13.Text = 'Blue Flower' .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u97.Position).Magnitude / 3) .. ' Distance'
                            _TextLabel13.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if u97.Name == 'Flower2' then
                            _TextLabel13.Text = 'Red Flower' .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - u97.Position).Magnitude / 3) .. ' Distance'
                            _TextLabel13.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                elseif u97:FindFirstChild('NameEsp' .. Number) then
                    u97:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateRealFruitChams()
    local v100, v101, v102 = pairs(game.Workspace.AppleSpawner:GetChildren())

    while true do
        local v103

        v102, v103 = v100(v101, v102)

        if v102 == nil then
            break
        end
        if v103:IsA('Tool') then
            if RealFruitESP then
                if v103.Handle:FindFirstChild('NameEsp' .. Number) then
                    v103.Handle['NameEsp' .. Number].TextLabel.Text = v103.Name .. ' ' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - v103.Handle.Position).Magnitude / 3) .. ' Distance'
                else
                    local _BillboardGui14 = Instance.new('BillboardGui', v103.Handle)

                    _BillboardGui14.Name = 'NameEsp' .. Number
                    _BillboardGui14.ExtentsOffset = Vector3.new(0, 1, 0)
                    _BillboardGui14.Size = UDim2.new(1, 200, 1, 30)
                    _BillboardGui14.Adornee = v103.Handle
                    _BillboardGui14.AlwaysOnTop = true

                    local _TextLabel14 = Instance.new('TextLabel', _BillboardGui14)

                    _TextLabel14.Font = Enum.Font.GothamSemibold
                    _TextLabel14.FontSize = 'Size14'
                    _TextLabel14.TextWrapped = true
                    _TextLabel14.Size = UDim2.new(1, 0, 1, 0)
                    _TextLabel14.TextYAlignment = 'Top'
                    _TextLabel14.BackgroundTransparency = 1
                    _TextLabel14.TextStrokeTransparency = 0.5
                    _TextLabel14.TextColor3 = Color3.fromRGB(255, 0, 0)
                    _TextLabel14.Text = v103.Name .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - v103.Handle.Position).Magnitude / 3) .. ' Distance'
                end
            elseif v103.Handle:FindFirstChild('NameEsp' .. Number) then
                v103.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end
    end

    local v106, v107, v108 = pairs(game.Workspace.PineappleSpawner:GetChildren())

    while true do
        local v109

        v108, v109 = v106(v107, v108)

        if v108 == nil then
            break
        end
        if v109:IsA('Tool') then
            if RealFruitESP then
                if v109.Handle:FindFirstChild('NameEsp' .. Number) then
                    v109.Handle['NameEsp' .. Number].TextLabel.Text = v109.Name .. ' ' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - v109.Handle.Position).Magnitude / 3) .. ' Distance'
                else
                    local _BillboardGui15 = Instance.new('BillboardGui', v109.Handle)

                    _BillboardGui15.Name = 'NameEsp' .. Number
                    _BillboardGui15.ExtentsOffset = Vector3.new(0, 1, 0)
                    _BillboardGui15.Size = UDim2.new(1, 200, 1, 30)
                    _BillboardGui15.Adornee = v109.Handle
                    _BillboardGui15.AlwaysOnTop = true

                    local _TextLabel15 = Instance.new('TextLabel', _BillboardGui15)

                    _TextLabel15.Font = Enum.Font.GothamSemibold
                    _TextLabel15.FontSize = 'Size14'
                    _TextLabel15.TextWrapped = true
                    _TextLabel15.Size = UDim2.new(1, 0, 1, 0)
                    _TextLabel15.TextYAlignment = 'Top'
                    _TextLabel15.BackgroundTransparency = 1
                    _TextLabel15.TextStrokeTransparency = 0.5
                    _TextLabel15.TextColor3 = Color3.fromRGB(255, 174, 0)
                    _TextLabel15.Text = v109.Name .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - v109.Handle.Position).Magnitude / 3) .. ' Distance'
                end
            elseif v109.Handle:FindFirstChild('NameEsp' .. Number) then
                v109.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end
    end

    local v112, v113, v114 = pairs(game.Workspace.BananaSpawner:GetChildren())

    while true do
        local v115

        v114, v115 = v112(v113, v114)

        if v114 == nil then
            break
        end
        if v115:IsA('Tool') then
            if RealFruitESP then
                if v115.Handle:FindFirstChild('NameEsp' .. Number) then
                    v115.Handle['NameEsp' .. Number].TextLabel.Text = v115.Name .. ' ' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - v115.Handle.Position).Magnitude / 3) .. ' Distance'
                else
                    local _BillboardGui16 = Instance.new('BillboardGui', v115.Handle)

                    _BillboardGui16.Name = 'NameEsp' .. Number
                    _BillboardGui16.ExtentsOffset = Vector3.new(0, 1, 0)
                    _BillboardGui16.Size = UDim2.new(1, 200, 1, 30)
                    _BillboardGui16.Adornee = v115.Handle
                    _BillboardGui16.AlwaysOnTop = true

                    local _TextLabel16 = Instance.new('TextLabel', _BillboardGui16)

                    _TextLabel16.Font = Enum.Font.GothamSemibold
                    _TextLabel16.FontSize = 'Size14'
                    _TextLabel16.TextWrapped = true
                    _TextLabel16.Size = UDim2.new(1, 0, 1, 0)
                    _TextLabel16.TextYAlignment = 'Top'
                    _TextLabel16.BackgroundTransparency = 1
                    _TextLabel16.TextStrokeTransparency = 0.5
                    _TextLabel16.TextColor3 = Color3.fromRGB(251, 255, 0)
                    _TextLabel16.Text = v115.Name .. ' \n' .. u75((game:GetService('Players').LocalPlayer.Character.Head.Position - v115.Handle.Position).Magnitude / 3) .. ' Distance'
                end
            elseif v115.Handle:FindFirstChild('NameEsp' .. Number) then
                v115.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
            end
        end
    end
end

spawn(function()
    while wait() do
        pcall(function()
            if MobESP then
                local v118, v119, v120 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                while true do
                    local v121

                    v120, v121 = v118(v119, v120)

                    if v120 == nil then
                        break
                    end
                    if v121:FindFirstChild('HumanoidRootPart') then
                        if not v121:FindFirstChild('MobEap') then
                            local _BillboardGui17 = Instance.new('BillboardGui')
                            local _TextLabel17 = Instance.new('TextLabel')

                            _BillboardGui17.Parent = v121
                            _BillboardGui17.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            _BillboardGui17.Active = true
                            _BillboardGui17.Name = 'MobEap'
                            _BillboardGui17.AlwaysOnTop = true
                            _BillboardGui17.LightInfluence = 1
                            _BillboardGui17.Size = UDim2.new(0, 200, 0, 50)
                            _BillboardGui17.StudsOffset = Vector3.new(0, 2.5, 0)
                            _TextLabel17.Parent = _BillboardGui17
                            _TextLabel17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            _TextLabel17.BackgroundTransparency = 1
                            _TextLabel17.Size = UDim2.new(0, 200, 0, 50)
                            _TextLabel17.Font = Enum.Font.GothamBold
                            _TextLabel17.TextColor3 = Color3.fromRGB(7, 236, 240)
                            _TextLabel17.Text.Size = 35
                        end

                        local v124 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v121.HumanoidRootPart.Position).Magnitude)

                        v121.MobEap.TextLabel.Text = v121.Name .. ' - ' .. v124 .. ' Distance'
                    end
                end
            else
                local v125, v126, v127 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                while true do
                    local v128

                    v127, v128 = v125(v126, v127)

                    if v127 == nil then
                        break
                    end
                    if v128:FindFirstChild('MobEap') then
                        v128.MobEap:Destroy()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if SeaESP then
                local v129, v130, v131 = pairs(game:GetService('Workspace').SeaBeasts:GetChildren())

                while true do
                    local v132

                    v131, v132 = v129(v130, v131)

                    if v131 == nil then
                        break
                    end
                    if v132:FindFirstChild('HumanoidRootPart') then
                        if not v132:FindFirstChild('Seaesps') then
                            local _BillboardGui18 = Instance.new('BillboardGui')
                            local _TextLabel18 = Instance.new('TextLabel')

                            _BillboardGui18.Parent = v132
                            _BillboardGui18.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            _BillboardGui18.Active = true
                            _BillboardGui18.Name = 'Seaesps'
                            _BillboardGui18.AlwaysOnTop = true
                            _BillboardGui18.LightInfluence = 1
                            _BillboardGui18.Size = UDim2.new(0, 200, 0, 50)
                            _BillboardGui18.StudsOffset = Vector3.new(0, 2.5, 0)
                            _TextLabel18.Parent = _BillboardGui18
                            _TextLabel18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            _TextLabel18.BackgroundTransparency = 1
                            _TextLabel18.Size = UDim2.new(0, 200, 0, 50)
                            _TextLabel18.Font = Enum.Font.GothamBold
                            _TextLabel18.TextColor3 = Color3.fromRGB(7, 236, 240)
                            _TextLabel18.Text.Size = 35
                        end

                        local v135 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v132.HumanoidRootPart.Position).Magnitude)

                        v132.Seaesps.TextLabel.Text = v132.Name .. ' - ' .. v135 .. ' Distance'
                    end
                end
            else
                local v136, v137, v138 = pairs(game:GetService('Workspace').SeaBeasts:GetChildren())

                while true do
                    local v139

                    v138, v139 = v136(v137, v138)

                    if v138 == nil then
                        break
                    end
                    if v139:FindFirstChild('Seaesps') then
                        v139.Seaesps:Destroy()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if NpcESP then
                local v140, v141, v142 = pairs(game:GetService('Workspace').NPCs:GetChildren())

                while true do
                    local v143

                    v142, v143 = v140(v141, v142)

                    if v142 == nil then
                        break
                    end
                    if v143:FindFirstChild('HumanoidRootPart') then
                        if not v143:FindFirstChild('NpcEspes') then
                            local _BillboardGui19 = Instance.new('BillboardGui')
                            local _TextLabel19 = Instance.new('TextLabel')

                            _BillboardGui19.Parent = v143
                            _BillboardGui19.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            _BillboardGui19.Active = true
                            _BillboardGui19.Name = 'NpcEspes'
                            _BillboardGui19.AlwaysOnTop = true
                            _BillboardGui19.LightInfluence = 1
                            _BillboardGui19.Size = UDim2.new(0, 200, 0, 50)
                            _BillboardGui19.StudsOffset = Vector3.new(0, 2.5, 0)
                            _TextLabel19.Parent = _BillboardGui19
                            _TextLabel19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            _TextLabel19.BackgroundTransparency = 1
                            _TextLabel19.Size = UDim2.new(0, 200, 0, 50)
                            _TextLabel19.Font = Enum.Font.GothamBold
                            _TextLabel19.TextColor3 = Color3.fromRGB(7, 236, 240)
                            _TextLabel19.Text.Size = 35
                        end

                        local v146 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v143.HumanoidRootPart.Position).Magnitude)

                        v143.NpcEspes.TextLabel.Text = v143.Name .. ' - ' .. v146 .. ' Distance'
                    end
                end
            else
                local v147, v148, v149 = pairs(game:GetService('Workspace').NPCs:GetChildren())

                while true do
                    local v150

                    v149, v150 = v147(v148, v149)

                    if v149 == nil then
                        break
                    end
                    if v150:FindFirstChild('NpcEspes') then
                        v150.NpcEspes:Destroy()
                    end
                end
            end
        end)
    end
end)

function isnil(p151)
    return p151 == nil
end

local function u153(p152)
    return math.floor(tonumber(p152) + 0.5)
end

Number = math.random(1, 1000000)

function UpdateIslandMirageESP()
    local v154, v155, v156 = pairs(game:GetService('Workspace')._WorldOrigin.Locations:GetChildren())

    while true do
        local u157

        v156, u157 = v154(v155, v156)

        if v156 == nil then
            break
        end

        pcall(function()
            if MirageIslandESP then
                if u157.Name == 'Mirage Island' then
                    if u157:FindFirstChild('NameEsp') then
                        u157.NameEsp.TextLabel.Text = u157.Name .. '   \n' .. u153((game:GetService('Players').LocalPlayer.Character.Head.Position - u157.Position).Magnitude / 3) .. ' M'
                    else
                        local _BillboardGui20 = Instance.new('BillboardGui', u157)

                        _BillboardGui20.Name = 'NameEsp'
                        _BillboardGui20.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui20.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui20.Adornee = u157
                        _BillboardGui20.AlwaysOnTop = true

                        local _TextLabel20 = Instance.new('TextLabel', _BillboardGui20)

                        _TextLabel20.Font = 'Code'
                        _TextLabel20.FontSize = 'Size14'
                        _TextLabel20.TextWrapped = true
                        _TextLabel20.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel20.TextYAlignment = 'Top'
                        _TextLabel20.BackgroundTransparency = 1
                        _TextLabel20.TextStrokeTransparency = 0.5
                        _TextLabel20.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif u157:FindFirstChild('NameEsp') then
                u157:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function isnil(p160)
    return p160 == nil
end

local function u162(p161)
    return math.floor(tonumber(p161) + 0.5)
end

Number = math.random(1, 1000000)

function UpdateAfdESP()
    local v163, v164, v165 = pairs(game:GetService('Workspace').NPCs:GetChildren())

    while true do
        local u166

        v165, u166 = v163(v164, v165)

        if v165 == nil then
            break
        end

        pcall(function()
            if AfdESP then
                if u166.Name == 'Advanced Fruit Dealer' then
                    if u166:FindFirstChild('NameEsp') then
                        u166.NameEsp.TextLabel.Text = u166.Name .. '   \n' .. u162((game:GetService('Players').LocalPlayer.Character.Head.Position - u166.Position).Magnitude / 3) .. ' M'
                    else
                        local _BillboardGui21 = Instance.new('BillboardGui', u166)

                        _BillboardGui21.Name = 'NameEsp'
                        _BillboardGui21.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui21.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui21.Adornee = u166
                        _BillboardGui21.AlwaysOnTop = true

                        local _TextLabel21 = Instance.new('TextLabel', _BillboardGui21)

                        _TextLabel21.Font = 'Code'
                        _TextLabel21.FontSize = 'Size14'
                        _TextLabel21.TextWrapped = true
                        _TextLabel21.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel21.TextYAlignment = 'Top'
                        _TextLabel21.BackgroundTransparency = 1
                        _TextLabel21.TextStrokeTransparency = 0.5
                        _TextLabel21.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif u166:FindFirstChild('NameEsp') then
                u166:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function UpdateAuraESP()
    local v169, v170, v171 = pairs(game:GetService('Workspace').NPCs:GetChildren())

    while true do
        local u172

        v171, u172 = v169(v170, v171)

        if v171 == nil then
            break
        end

        pcall(function()
            if AuraESP then
                if u172.Name == 'Master of Enhancement' then
                    if u172:FindFirstChild('NameEsp') then
                        u172.NameEsp.TextLabel.Text = u172.Name .. '   \n' .. u162((game:GetService('Players').LocalPlayer.Character.Head.Position - u172.Position).Magnitude / 3) .. ' M'
                    else
                        local _BillboardGui22 = Instance.new('BillboardGui', u172)

                        _BillboardGui22.Name = 'NameEsp'
                        _BillboardGui22.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui22.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui22.Adornee = u172
                        _BillboardGui22.AlwaysOnTop = true

                        local _TextLabel22 = Instance.new('TextLabel', _BillboardGui22)

                        _TextLabel22.Font = 'Code'
                        _TextLabel22.FontSize = 'Size14'
                        _TextLabel22.TextWrapped = true
                        _TextLabel22.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel22.TextYAlignment = 'Top'
                        _TextLabel22.BackgroundTransparency = 1
                        _TextLabel22.TextStrokeTransparency = 0.5
                        _TextLabel22.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif u172:FindFirstChild('NameEsp') then
                u172:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function UpdateLSDESP()
    local v175, v176, v177 = pairs(game:GetService('Workspace').NPCs:GetChildren())

    while true do
        local u178

        v177, u178 = v175(v176, v177)

        if v177 == nil then
            break
        end

        pcall(function()
            if LADESP then
                if u178.Name == 'Legendary Sword Dealer' then
                    if u178:FindFirstChild('NameEsp') then
                        u178.NameEsp.TextLabel.Text = u178.Name .. '   \n' .. u162((game:GetService('Players').LocalPlayer.Character.Head.Position - u178.Position).Magnitude / 3) .. ' M'
                    else
                        local _BillboardGui23 = Instance.new('BillboardGui', u178)

                        _BillboardGui23.Name = 'NameEsp'
                        _BillboardGui23.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui23.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui23.Adornee = u178
                        _BillboardGui23.AlwaysOnTop = true

                        local _TextLabel23 = Instance.new('TextLabel', _BillboardGui23)

                        _TextLabel23.Font = 'Code'
                        _TextLabel23.FontSize = 'Size14'
                        _TextLabel23.TextWrapped = true
                        _TextLabel23.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel23.TextYAlignment = 'Top'
                        _TextLabel23.BackgroundTransparency = 1
                        _TextLabel23.TextStrokeTransparency = 0.5
                        _TextLabel23.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif u178:FindFirstChild('NameEsp') then
                u178:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function UpdateGeaESP()
    local v181, v182, v183 = pairs(game:GetService('Workspace').Map.MysticIsland:GetChildren())

    while true do
        local u184

        v183, u184 = v181(v182, v183)

        if v183 == nil then
            break
        end

        pcall(function()
            if GearESP then
                if u184.Name == 'MeshPart' then
                    if u184:FindFirstChild('NameEsp') then
                        u184.NameEsp.TextLabel.Text = u184.Name .. '   \n' .. u162((game:GetService('Players').LocalPlayer.Character.Head.Position - u184.Position).Magnitude / 3) .. ' M'
                    else
                        local _BillboardGui24 = Instance.new('BillboardGui', u184)

                        _BillboardGui24.Name = 'NameEsp'
                        _BillboardGui24.ExtentsOffset = Vector3.new(0, 1, 0)
                        _BillboardGui24.Size = UDim2.new(1, 200, 1, 30)
                        _BillboardGui24.Adornee = u184
                        _BillboardGui24.AlwaysOnTop = true

                        local _TextLabel24 = Instance.new('TextLabel', _BillboardGui24)

                        _TextLabel24.Font = 'Code'
                        _TextLabel24.FontSize = 'Size14'
                        _TextLabel24.TextWrapped = true
                        _TextLabel24.Size = UDim2.new(1, 0, 1, 0)
                        _TextLabel24.TextYAlignment = 'Top'
                        _TextLabel24.BackgroundTransparency = 1
                        _TextLabel24.TextStrokeTransparency = 0.5
                        _TextLabel24.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif u184:FindFirstChild('NameEsp') then
                u184:FindFirstChild('NameEsp'):Destroy()
            end
        end)
    end
end
function Tween2(p187)
    local _Magnitude = (p187.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

    if _Magnitude >= 1 then
        Speed = 300
    end

    game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(_Magnitude / Speed, Enum.EasingStyle.Linear), {CFrame = p187}):Play()

    if _G.CancelTween2 then
        game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(_Magnitude / Speed, Enum.EasingStyle.Linear), {CFrame = p187}):Cancel()
    end

    _G.Clip2 = true

    wait(_Magnitude / Speed)

    _G.Clip2 = false
end
function BTP(p189)
    game.Players.LocalPlayer.Character.Head:Destroy()

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p189

    wait(0.5)

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p189

    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('SetSpawnPoint')
end
function BTPZ(p190)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p190

    task.wait()

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p190
end
function GetIsLand(...)
    local v191 = {...}
    local v192 = v191[1]
    local v193 = nil

    if type(v192) ~= 'vector' then
        if type(v192) ~= 'userdata' then
            if type(v192) == 'number' then
                v193 = CFrame.new(unpack(v191)).p
            end
        else
            v193 = v192.Position
        end
    else
        v193 = v192
    end

    local v194 = nil
    local _huge = math.huge

    if game.Players.LocalPlayer.Team then
        local v196, v197, v198 = pairs(game.Workspace._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(game.Players.LocalPlayer.Team)):GetChildren())

        while true do
            local v199

            v198, v199 = v196(v197, v198)

            if v198 == nil then
                break
            end

            local _Magnitude2 = (v193 - v199:GetModelCFrame().p).Magnitude

            if _Magnitude2 < _huge then
                v194 = v199.Name
                _huge = _Magnitude2
            end
        end

        if v194 then
            return v194
        end
    end
end
function toTarget(...)
    local v201 = {...}
    local v202 = v201[1]
    local u203 = nil

    if type(v202) ~= 'vector' then
        if type(v202) ~= 'userdata' then
            if type(v202) == 'number' then
                u203 = CFrame.new(unpack(v201))
            end
        else
            u203 = v202
        end
    else
        u203 = CFrame.new(v202)
    end
    if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health == 0 then
        if tween then
            tween:Cancel()
        end

        repeat
            wait()
        until game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health > 0

        wait(0.2)
    end

    local v204 = {}
    local _Magnitude3 = (u203.Position - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude

    if _Magnitude3 < 1000 then
        Speed = 315
    elseif _Magnitude3 >= 1000 then
        Speed = 300
    end
    if BypassTP and (3000 < _Magnitude3 and not AutoNextIsland) and (not game.Players.LocalPlayer.Backpack:FindFirstChild('Special Microchip') and (not game.Players.LocalPlayer.Character:FindFirstChild('Special Microchip') and (not game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") and (not game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice") and (not game.Players.LocalPlayer.Backpack:FindFirstChild('Hallow Essence') and (not game.Players.LocalPlayer.Character:FindFirstChild('Hallow Essence') and (not game.Players.LocalPlayer.Character:FindFirstChild('Sweet Chalice') and (not game.Players.LocalPlayer.Backpack:FindFirstChild('Sweet Chalice') and (Name ~= 'Fishman Commando' and Name ~= 'Fishman Warrior'))))))))) then
        pcall(function()
            tween:Cancel()

            fkwarp = false

            if game:GetService('Players').LocalPlayer.Data:FindFirstChild('SpawnPoint').Value == tostring(GetIsLand(u203)) then
                wait(0.1)
                Com('F_', 'TeleportToSpawn')
            end
            if game:GetService('Players').LocalPlayer.Data:FindFirstChild('LastSpawnPoint').Value == tostring(GetIsLand(u203)) then
                game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)
                wait(0.1)
                wait()

                if game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid').Health > 0 then
                end
            end
            if game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid').Health > 0 then
                if fkwarp == false then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = u203
                end

                fkwarp = true
            end

            wait(0.08)
            game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

            repeat
                wait()
            until game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid').Health > 0

            wait(0.1)
            Com('F_', 'SetSpawnPoint')
            wait(0.2)
        end)
    end

    local _TweenService = game:service('TweenService')
    local u207 = TweenInfo.new((u203.Position - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude / Speed, Enum.EasingStyle.Linear)
    local _, _ = pcall(function()
        local v208 = {CFrame = u203}

        tween = _TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, u207, v208)

        tween:Play()
    end)

    function v204.Stop(_)
        tween:Cancel()
    end
    function v204.Wait(_)
        tween.Completed:Wait()
    end

    return v204
end
function Tween(p209)
    Distance = (p209.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
        game.Players.LocalPlayer.Character.Humanoid.Sit = false
    end

    pcall(function()
        local v210 = {CFrame = p209}

        tween = game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear), v210)
    end)
    tween:Play()

    if Distance <= 300 then
        tween:Cancel()

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p209
    end
    if _G.StopTween == true then
        tween:Cancel()

        _G.Clip = false
    end
end
function toTargetP(p211)
    if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health > 0 and game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid') then
        if (game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position - p211.Position).Magnitude <= 150 then
            pcall(function()
                tween:Cancel()

                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = p211
            end)
        end

        local _TweenService2 = game:service('TweenService')
        local v213 = TweenInfo.new((game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position - p211.Position).Magnitude / 325, Enum.EasingStyle.Linear)

        tween = _TweenService2:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v213, {CFrame = p211})

        tween:Play()

        return {
            Stop = function(_)
                tween:Cancel()
            end,
        }
    end

    tween:Cancel()

    repeat
        wait()
    until game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid') and game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid').Health > 0

    wait(7)
end
function TweenShip(p214)
    local _TweenService3 = game:service('TweenService')
    local v216 = TweenInfo.new((game:GetService('Workspace').Boats.MarineBrigade.VehicleSeat.CFrame.Position - p214.Position).Magnitude / 300, Enum.EasingStyle.Linear)

    tween = _TweenService3:Create(game:GetService('Workspace').Boats.MarineBrigade.VehicleSeat, v216, {CFrame = p214})

    tween:Play()

    return {
        Stop = function(_)
            tween:Cancel()
        end,
    }
end
function TweenBoat(p217)
    if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health > 0 and game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid') then
        local _TweenService4 = game:service('TweenService')
        local v219 = TweenInfo.new((game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position - p217.Position).Magnitude / 325, Enum.EasingStyle.Linear)

        tween = _TweenService4:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v219, {CFrame = p217})

        tween:Play()

        return {
            Stop = function(_)
                tween:Cancel()
            end,
        }
    end

    tween:Cancel()

    repeat
        wait()
    until game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid') and game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid').Health > 0

    wait(7)
end
function EquipTool(p220)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(p220) then
        local v221 = game.Players.LocalPlayer.Backpack:FindFirstChild(p220)

        wait(0.5)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v221)
    end
end

spawn(function()
    local v222 = getrawmetatable(game)
    local ___namecall = v222.__namecall

    setreadonly(v222, false)

    v222.__namecall = newcclosure(function(...)
        local v224 = getnamecallmethod()
        local v225 = {...}

        if tostring(v224) ~= 'FireServer' or (tostring(v225[1]) ~= 'RemoteEvent' or (tostring(v225[2]) == 'true' or (tostring(v225[2]) == 'false' or not _G.UseSkill))) then
            return ___namecall(...)
        end
        if type(v225[2]) ~= 'vector' then
            v225[2] = CFrame.new(PositionSkillMasteryDevilFruit)
        else
            v225[2] = PositionSkillMasteryDevilFruit
        end

        return ___namecall(unpack(v225))
    end)
end)
spawn(function()
    pcall(function()
        while task.wait() do
            local v226, v227, v228 = pairs(game:GetService('Players').LocalPlayer.Backpack:GetChildren())

            while true do
                local v229

                v228, v229 = v226(v227, v228)

                if v228 == nil then
                    break
                end
                if v229:IsA('Tool') and v229:FindFirstChild('RemoteFunctionShoot') then
                    CurrentEquipGun = v229.Name
                end
            end
        end
    end)
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.TeleportIsland or (AutoFarmChest or (_G.chestsea2 or (_G.chestsea3 or (_G.CastleRaid or (_G.CollectAzure or (_G.TweenToKitsune or (_G.AutoCandy or (_G.GhostShip or (_G.Ship or (_G.SailBoat or (_G.Auto_Holy_Torch or (_G.FindMirageIsland or (_G.TeleportPly or (_G.Tweenfruit or (_G.AutoFishCrew or (_G.AutoShark or (_G.AutoCakeV2 or (_G.AutoMysticIsland or (_G.AutoQuestRace or (_G.AutoBuyBoat or (_G.dao or (_G.AutoMirage or (AutoFarmAcient or (_G.AutoQuestRace or (Auto_Law or (_G.AutoAllBoss or (AutoTushita or (_G.AutoHolyTorch or (_G.AutoTerrorshark or (_G.farmpiranya or (_G.DriveMytic or (_G.AutoCakeV2V2 or (PirateShip or (_G.AutoSeaBeast or (_G.AutoNear or (_G.BossRaid or (_G.GrabChest or (AutoCitizen or (_G.Ectoplasm or (AutoEvoRace or (AutoBartilo or (AutoFactory or (BringChestz or (BringFruitz or (_G.AutoLevel or (_G.Clip2 or (AutoFarmNoQuest or (_G.AutoBone or (AutoFarmSelectMonsterQuest or (AutoFarmSelectMonsterNoQuest or (_G.AutoBoss or (AutoFarmBossQuest or (AutoFarmMasGun or (AutoFarmMasDevilFruit or (AutoFarmSelectArea or (AutoSecondSea or (AutoThirdSea or (AutoDeathStep or (AutoSuperhuman or (AutoSharkman or (AutoElectricClaw or (AutoDragonTalon or (AutoGodhuman or (AutoRengoku or (AutoBuddySword or (AutoPole or (AutoHallowSycthe or (AutoCavander or (AutoTushita or (AutoDarkDagger or (_G.CakePrince or (_G.AutoElite or (AutoRainbowHaki or (AutoSaber or (AutoFarmKen or (AutoKenHop or (AutoKenV2 or (_G.AutoKillPlayerMelee or (_G.AutoKillPlayerGun or (_G.AutoKillPlayerFruit or (AutoDungeon or (AutoNextIsland or (AutoAdvanceDungeon or (Musketeer or (RipIndra or (Auto_Serpent_Bow or (AutoTorch or (AutoSoulGuitar or (Auto_Cursed_Dual_Katana or (_G.AutoMaterial or (Auto_Quest_Yama_1 or (Auto_Quest_Yama_2 or (Auto_Quest_Yama_3 or (Auto_Quest_Tushita_1 or (Auto_Quest_Tushita_2 or (Auto_Quest_Tushita_3 or (_G.Factory or (_G.SwanGlasses or (AutoBartilo or (AutoEvoRace or _G.Ectoplasm)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) then
                if not game:GetService('Players').LocalPlayer.Character.HumanoidRootPart:FindFirstChild('BodyClip') then
                    local _BodyVelocity = Instance.new('BodyVelocity')

                    _BodyVelocity.Name = 'BodyClip'
                    _BodyVelocity.Parent = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart
                    _BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    _BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            else
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart:FindFirstChild('BodyClip'):Destroy()
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        game:GetService('RunService').Stepped:Connect(function()
            if _G.TeleportIsland or (_G.CastleRaid or (AutoFarmChest or (_G.CollectAzure or (_G.TweenToKitsune or (_G.AutoCandy or (_G.GhostShip or (_G.Ship or (_G.SailBoat or (_G.Auto_Holy_Torch or (_G.Tweenfruit or (_G.FindMirageIsland or (_G.TeleportPly or (_G.AutoFishCrew or (_G.AutoShark or (_G.AutoMysticIsland or (_G.AutoCakeV2 or (_G.AutoQuestRace or (_G.AutoBuyBoat or (_G.dao or (AutoFarmAcient or (_G.AutoMirage or (Auto_Law or (_G.AutoQuestRace or (_G.AutoAllBoss or (_G.AutoHolyTorch or (AutoTushita or (_G.farmpiranya or (_G.AutoTerrorshark or (_G.AutoNear or (_G.AutoCakeV2V2 or (PirateShip or (_G.AutoSeaBeast or (_G.DriveMytic or (_G.BossRaid or (_G.GrabChest or (AutoCitizen or (_G.Ectoplasm or (AutoEvoRace or (AutoBartilo or (AutoFactory or (BringChestz or (BringFruitz or (_G.AutoLevel or (_G.Clip2 or (AutoFarmNoQuest or (_G.AutoBone or (AutoFarmSelectMonsterQuest or (AutoFarmSelectMonsterNoQuest or (_G.AutoBoss or (AutoFarmBossQuest or (AutoFarmMasGun or (AutoFarmMasDevilFruit or (AutoFarmSelectArea or (AutoSecondSea or (AutoThirdSea or (AutoDeathStep or (AutoSuperhuman or (AutoSharkman or (AutoElectricClaw or (AutoDragonTalon or (AutoGodhuman or (AutoRengoku or (AutoBuddySword or (AutoPole or (AutoHallowSycthe or (AutoCavander or (AutoTushita or (AutoDarkDagger or (_G.CakePrince or (_G.AutoElite or (AutoRainbowHaki or (AutoSaber or (AutoFarmKen or (AutoKenHop or (AutoKenV2 or (_G.AutoKillPlayerMelee or (_G.AutoKillPlayerGun or (_G.AutoKillPlayerFruit or (AutoDungeon or (AutoNextIsland or (AutoAdvanceDungeon or (Musketeer or (RipIndra or (Auto_Serpent_Bow or (AutoTorch or (AutoSoulGuitar or (Auto_Cursed_Dual_Katana or (_G.AutoMaterial or (Auto_Quest_Yama_1 or (Auto_Quest_Yama_2 or (Auto_Quest_Yama_3 or (Auto_Quest_Tushita_1 or (Auto_Quest_Tushita_2 or (Auto_Quest_Tushita_3 or (_G.Factory or (_G.SwanGlasses or (AutoBartilo or (AutoEvoRace or _G.Ectoplasm)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) then
                local v231, v232, v233 = pairs(game:GetService('Players').LocalPlayer.Character:GetDescendants())

                while true do
                    local v234

                    v233, v234 = v231(v232, v233)

                    if v233 == nil then
                        break
                    end
                    if v234:IsA('BasePart') then
                        v234.CanCollide = false
                    end
                end
            end
        end)
    end)
end)

function CheckMaterial(p235)
    local v236, v237, v238 = pairs(game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('getInventory'))

    while true do
        local v239

        v238, v239 = v236(v237, v238)

        if v238 == nil then
            break
        end
        if type(v239) == 'table' and (v239.Type == 'Material' and v239.Name == p235) then
            return v239.Count
        end
    end

    return 0
end

local _LocalPlayer = game.Players.LocalPlayer
local u241 = getupvalues(require(_LocalPlayer.PlayerScripts.CombatFramework))[2]

function GetCurrentBlade()
    local v242 = u241.activeController.blades[1]

    if v242 then
        while v242.Parent ~= game.Players.LocalPlayer.Character do
            v242 = v242.Parent
        end

        return v242
    end
end
function AttackNoCD()
    if (not AutoFarmMasDevilFruit or AutoFarmMasGun) and not Auto_Raid then
        local _activeController = u241.activeController

        for v244 = 1, 1 do
            local v245 = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(_LocalPlayer.Character, {
                _LocalPlayer.Character.HumanoidRootPart,
            }, 60)
            local v246, v247, v248 = pairs(v245)
            local u249 = v244
            local v250 = {}
            local u251 = {}

            while true do
                local v252, v253 = v246(v247, v248)

                if v252 == nil then
                    break
                end

                v248 = v252

                if v253.Parent:FindFirstChild('HumanoidRootPart') and not v250[v253.Parent] then
                    table.insert(u251, v253.Parent.HumanoidRootPart)

                    v250[v253.Parent] = true
                end
            end

            if #u251 > 0 then
                local u254 = debug.getupvalue(_activeController.attack, 5)
                local u255 = debug.getupvalue(_activeController.attack, 6)
                local u256 = debug.getupvalue(_activeController.attack, 4)
                local v257 = debug.getupvalue(_activeController.attack, 7)
                local u258 = (u254 * 798405 + u256 * 727595) % u255
                local u259 = u256 * 798405

                (function()
                    u258 = (u258 * u255 + u259) % 1099511627776
                    u254 = math.floor(u258 / u255)
                    u256 = u258 - u254 * u255
                end)()

                local u260 = v257 + 1

                debug.setupvalue(_activeController.attack, 5, u254)
                debug.setupvalue(_activeController.attack, 6, u255)
                debug.setupvalue(_activeController.attack, 4, u256)
                debug.setupvalue(_activeController.attack, 7, u260)
                pcall(function()
                    if _LocalPlayer.Character:FindFirstChildOfClass('Tool') and (_activeController.blades and _activeController.blades[1]) then
                        _activeController.animator.anims.basic[1]:Play(0.01, 0.01, 0.01)
                        game:GetService('ReplicatedStorage').RigControllerEvent:FireServer('weaponChange', tostring(GetCurrentBlade()))
                        game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u258 / 1099511627776 * 16777215), u260)
                        game:GetService('ReplicatedStorage').RigControllerEvent:FireServer('hit', u251, u249, '')
                    end
                end)
            end
        end
    end
end
function NormalAttack()
    if not _G.NormalAttack then
        local v261 = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework)
        local v262 = debug.getupvalues(v261)[2]

        require(game.ReplicatedStorage.Util.CameraShaker):Stop()

        v262.activeController.attacking = false
        v262.activeController.timeToNextAttack = 0
        v262.activeController.hitboxMagnitude = 180

        game:GetService('VirtualUser'):CaptureController()
        game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
    end
end
function GetWeaponInventory(p263)
    local v264, v265, v266 = pairs(game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('getInventory'))

    while true do
        local v267

        v266, v267 = v264(v265, v266)

        if v266 == nil then
            break
        end
        if type(v267) == 'table' and (v267.Type == 'Sword' and v267.Name == p263) then
            return true
        end
    end

    return false
end

Type1 = 1

spawn(function()
    while wait(0.1) do
        if Type ~= 1 then
            if Type ~= 2 then
                if Type ~= 3 then
                    if Type == 4 then
                        Pos = CFrame.new(-40, 10, 10)
                    end
                else
                    Pos = CFrame.new(10, 10, -40)
                end
            else
                Pos = CFrame.new(-30, 10, -30)
            end
        else
            Pos = CFrame.new(10, 40, 10)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        Type = 1

        wait(1)

        Type = 2

        wait(1)

        Type = 3

        wait(1)

        Type = 4

        wait(1)
    end
end)

function AutoHaki()
    if not game:GetService('Players').LocalPlayer.Character:FindFirstChild('HasBuso') then
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('Buso')
    end
end
function BTP(p268)
    repeat
        wait(0.5)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p268

        task.wait()

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p268
    until (p268.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2000
end
function BTP(p269)
    pcall(function()
        if (p269.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 2000 and (not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health > 0) then
            if NameMon ~= 'FishmanQuest' then
                if Mon ~= "God's Guard" then
                    if NameMon ~= 'SkyExp1Quest' then
                        if NameMon ~= 'ShipQuest1' then
                            if NameMon ~= 'ShipQuest2' then
                                if NameMon ~= 'FrostQuest' then
                                    repeat
                                        wait(0.5)

                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p269

                                        wait(0.05)
                                        game.Players.LocalPlayer.Character.Head:Destroy()

                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p269
                                    until (p269.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2500 and game.Players.LocalPlayer.Character.Humanoid.Health > 0

                                    wait()
                                else
                                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                                    wait()
                                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422))
                                end
                            else
                                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                                wait()
                                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                            end
                        else
                            Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                            wait()
                            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                        end
                    else
                        Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                        wait()
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
                    end
                else
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-4607.82275, 872.54248, -1667.55688))
                end
            else
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                wait()
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        end
    end)
end

local _ScreenGui = Instance.new('ScreenGui')
local _ImageButton = Instance.new('ImageButton')
local _UICorner = Instance.new('UICorner')

_ScreenGui.Name = 'ToggleUI'
pcall(function() _ScreenGui.Parent = game:GetService("CoreGui") end)
if not _ScreenGui.Parent then _ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui end
_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_ImageButton.Name = 'ToggleButton'
_ImageButton.Parent = _ScreenGui
_ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_ImageButton.BorderSizePixel = 0
_ImageButton.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
_ImageButton.Size = UDim2.new(0, 50, 0, 50)
_ImageButton.Image = 'rbxassetid://15943857180'

_ImageButton.MouseButton1Click:Connect(function()
    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)

_UICorner.CornerRadius = UDim.new(0, 10)
_UICorner.Parent = _ImageButton

if game:GetService('ReplicatedStorage').Effect.Container:FindFirstChild('Death') then
    game:GetService('ReplicatedStorage').Effect.Container.Death:Destroy()
end
if game:GetService('ReplicatedStorage').Effect.Container:FindFirstChild('Respawn') then
    game:GetService('ReplicatedStorage').Effect.Container.Respawn:Destroy()
end

v3.Main:AddSection('Farming')

local _DropdownDelayAttack = v3.Main:AddDropdown('DropdownDelayAttack', {
    Title = 'Select Fast Attack',
    Values = {
        'Normal Attack',
        'Fast Attack',
        'Super Fast Attack',
    },
    Multi = false,
    Default = 1,
})

_DropdownDelayAttack:SetValue('Fast Attack')
_DropdownDelayAttack:OnChanged(function(p274)
    _G.FastAttackFaiFao_Mode = p274

    if _G.FastAttackFaiFao_Mode ~= 'Fast Attack' then
        if _G.FastAttackFaiFao_Mode ~= 'Normal Attack' then
            if _G.FastAttackFaiFao_Mode == 'Super Fast Attack' then
                _G.Fast_Delay = 0.05
            end
        else
            _G.Fast_Delay = 0.25
        end
    else
        _G.Fast_Delay = 0.17
    end
end)

local _DropdownSelectWeapon = v3.Main:AddDropdown('DropdownSelectWeapon', {
    Title = 'Weapon',
    Values = {
        'Melee',
        'Sword',
        'Blox Fruit',
    },
    Multi = false,
    Default = 1,
})

_DropdownSelectWeapon:SetValue('Melee')
_DropdownSelectWeapon:OnChanged(function(p276)
    ChooseWeapon = p276
end)
task.spawn(function()
    while wait() do
        pcall(function()
            if ChooseWeapon ~= 'Melee' then
                if ChooseWeapon ~= 'Sword' then
                    if ChooseWeapon ~= ' Blox Fruit' then
                        local v277, v278, v279 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v280

                            v279, v280 = v277(v278, v279)

                            if v279 == nil then
                                break
                            end
                            if v280.ToolTip == 'Melee' and game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v280.Name)) then
                                SelectWeapon = v280.Name
                            end
                        end
                    else
                        local v281, v282, v283 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v284

                            v283, v284 = v281(v282, v283)

                            if v283 == nil then
                                break
                            end
                            if v284.ToolTip == 'Blox Fruit' and game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v284.Name)) then
                                SelectWeapon = v284.Name
                            end
                        end
                    end
                else
                    local v285, v286, v287 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                    while true do
                        local v288

                        v287, v288 = v285(v286, v287)

                        if v287 == nil then
                            break
                        end
                        if v288.ToolTip == 'Sword' and game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v288.Name)) then
                            SelectWeapon = v288.Name
                        end
                    end
                end
            else
                local v289, v290, v291 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                while true do
                    local v292

                    v291, v292 = v289(v290, v291)

                    if v291 == nil then
                        break
                    end
                    if v292.ToolTip == 'Melee' and game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v292.Name)) then
                        SelectWeapon = v292.Name
                    end
                end
            end
        end)
    end
end)
v3.Main:AddToggle('ToggleLevel', {
    Title = 'Auto Level',
    Default = false,
}):OnChanged(function(p293)
    _G.AutoLevel = p293
end)
_Options.ToggleLevel:SetValue(false)
spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()
                CheckLevel()

                if string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) and game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
                    if string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        local v294, v295, v296 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v297

                            v296, v297 = v294(v295, v296)

                            if v296 == nil then
                                break
                            end
                            if v297:FindFirstChild('Humanoid') and (v297:FindFirstChild('HumanoidRootPart') and (v297.Humanoid.Health > 0 and v297.Name == Ms)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()

                                    bringmob = true

                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    Tween(v297.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    v297.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v297.HumanoidRootPart.Transparency = 1
                                    v297.Humanoid.JumpPower = 0
                                    v297.Humanoid.WalkSpeed = 0
                                    v297.HumanoidRootPart.CanCollide = false
                                    FarmPos = v297.HumanoidRootPart.CFrame
                                    MonFarm = v297.Name
                                until not _G.AutoLevel or (not v297.Parent or v297.Humanoid.Health <= 0) or (not game:GetService('Workspace').Enemies:FindFirstChild(v297.Name) or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false)

                                bringmob = false
                            end
                        end

                        local v298, v299, v300 = pairs(game:GetService('Workspace')._WorldOrigin.EnemySpawns:GetChildren())

                        while true do
                            local v301

                            v300, v301 = v298(v299, v300)

                            if v300 == nil then
                                break
                            end
                            if string.find(v301.Name, NameMon) and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v301.Position).Magnitude >= 10 then
                                Tween(v301.CFrame * CFrame.new(posX, posY, posZ))
                            end
                        end
                    end
                else
                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('AbandonQuest')

                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude <= 2500 then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude < 2500 then
                                Tween(CFrameQ)
                            end
                        else
                            BTP(CFrameQ)
                        end
                    else
                        Tween(CFrameQ)
                    end
                    if (CFrameQ.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StartQuest', NameQuest, QuestLv)
                    end
                end
            end)
        end
    end
end)
v3.Main:AddToggle('ToggleCandy', {
    Title = 'Auto Farm Candy ( Only Max Level )',
    Default = false,
}):OnChanged(function(p302)
    _G.AutoCandy = p302
end)
_Options.ToggleCandy:SetValue(false)

local u303 = CFrame.new(-16603.197265625, 130.3873748779297, 1087.16455078125)

spawn(function()
    while wait() do
        if _G.AutoCandy then
            pcall(function()
                toTargetP(u303)

                if game:GetService('Workspace').Enemies:FindFirstChild('Isle Outlaw') or (game:GetService('Workspace').Enemies:FindFirstChild('Island Boy') or (game:GetService('Workspace').Enemies:FindFirstChild('Sun-kissed Warrior') or game:GetService('Workspace').Enemies:FindFirstChild('Isle Champion'))) then
                    local v304, v305, v306 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                    while true do
                        local v307

                        v306, v307 = v304(v305, v306)

                        if v306 == nil then
                            break
                        end
                        if (v307.Name == 'Isle Outlaw' or (v307.Name == 'Island Boy' or (v307.Name == 'Sun-kissed Warrior' or v307.Name == 'Isle Champion'))) and (v307:FindFirstChild('Humanoid') and (v307:FindFirstChild('HumanoidRootPart') and v307.Humanoid.Health > 0)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()

                                bringmob = true

                                AutoHaki()
                                EquipTool(SelectWeapon)
                                toTarget(v307.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                v307.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                v307.HumanoidRootPart.Transparency = 1
                                v307.Humanoid.JumpPower = 0
                                v307.Humanoid.WalkSpeed = 0
                                v307.HumanoidRootPart.CanCollide = false
                                FarmPos = v307.HumanoidRootPart.CFrame
                                MonFarm = v307.Name
                            until not _G.AutoCandy or (not v307.Parent or v307.Humanoid.Health <= 0)

                            bringmob = false
                        end
                    end

                    toTarget(CFrame.new(-16599.1484375, 154.2681121826172, -166.32186889648438))
                end
            end)
        end
    end
end)
v3.Main:AddToggle('ToggleMobAura', {
    Title = 'Kill Near | Mob Aura',
    Default = false,
}):OnChanged(function(p308)
    _G.AutoNear = p308
end)
_Options.ToggleMobAura:SetValue(false)
spawn(function()
    while wait(0.1) do
        if _G.AutoNear then
            pcall(function()
                local v309, v310, v311 = pairs(game.Workspace.Enemies:GetChildren())

                while true do
                    local v312

                    v311, v312 = v309(v310, v311)

                    if v311 == nil then
                        break
                    end
                    if v312:FindFirstChild('Humanoid') and (v312:FindFirstChild('HumanoidRootPart') and (v312.Humanoid.Health > 0 and (v312.Name and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v312:FindFirstChild('HumanoidRootPart').Position).Magnitude <= 5000))) then
                        repeat
                            wait(_G.Fast_Delay)
                            AttackNoCD()

                            bringmob = true

                            AutoHaki()
                            EquipTool(SelectWeapon)
                            Tween(v312.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                            v312.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                            v312.HumanoidRootPart.Transparency = 1
                            v312.Humanoid.JumpPower = 0
                            v312.Humanoid.WalkSpeed = 0
                            v312.HumanoidRootPart.CanCollide = false
                            FarmPos = v312.HumanoidRootPart.CFrame
                            MonFarm = v312.Name
                        until not _G.AutoNear or (not v312.Parent or v312.Humanoid.Health <= 0) or not game.Workspace.Enemies:FindFirstChild(v312.Name)

                        bringmob = false
                    end
                end
            end)
        end
    end
end)
v3.Main:AddToggle('ToggleCastleRaid', {
    Title = 'Auto Castle Raid | Pirates Castle',
    Default = false,
}):OnChanged(function(p313)
    _G.CastleRaid = p313
end)
_Options.ToggleCastleRaid:SetValue(false)
spawn(function()
    while wait() do
        if _G.CastleRaid then
            pcall(function()
                local v314 = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-9, 0.380223751, 3.5881019e-8, 1, -1.06665446e-7, -0.380223751, 1.12297109e-7, 0.924894512)

                if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v314.Position).Magnitude <= 2500 then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v314.Position).Magnitude < 2500 then
                                Tween(v314)
                            end
                        else
                            BTP(v314)
                        end
                    end
                else
                    local v315, v316, v317 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                    while true do
                        local v318

                        v317, v318 = v315(v316, v317)

                        if v317 == nil then
                            break
                        end
                        if _G.CastleRaid and (v318:FindFirstChild('HumanoidRootPart') and (v318:FindFirstChild('Humanoid') and (v318.Humanoid.Health > 0 and (v318.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000))) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()

                                bringmob = true

                                AutoHaki()
                                EquipTool(SelectWeapon)

                                v318.HumanoidRootPart.CanCollide = false
                                v318.HumanoidRootPart.Size = Vector3.new(60, 60, 60)

                                Tween(v318.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                            until v318.Humanoid.Health <= 0 or not (v318.Parent and _G.CastleRaid)

                            bringmob = false
                        end
                    end
                end
            end)
        end
    end
end)
game:GetService('RunService').RenderStepped:connect(function()
    if _G.chestsea3 then
        if game:GetService('Players').LocalPlayer.Backpack:FindFirstChild("God's Chalice") then
            _G.chestsea3 = false
        elseif not game:GetService('Players').LocalPlayer.Backpack:FindFirstChild("God's Chalice") then
            if game:GetService('Workspace'):FindFirstChild('Chest1') then
                TPchest(game:GetService('Workspace'):FindFirstChild('Chest1').CFrame)
            end
            if game:GetService('Workspace'):FindFirstChild('Chest2') then
                TPchest(game:GetService('Workspace'):FindFirstChild('Chest2').CFrame)
            end
            if game:GetService('Workspace'):FindFirstChild('Chest3') then
                TPchest(game:GetService('Workspace'):FindFirstChild('Chest3').CFrame)
            end
        end
    end
end)

if game.PlaceId == 7449423635 then
    spawn(function()
        while task.wait(3.5) do
            pcall(function()
                if not game:GetService('Players').LocalPlayer.Backpack:FindFirstChild("God's Chalice") then
                    if _G.chestsea3 then
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 'Q', false, game)

                        game.Players.LocalPlayer.Character.Humanoid.Health = 0
                    end

                    wait(5)
                end
            end)
        end
    end)
end

game:GetService('RunService').RenderStepped:connect(function()
    if _G.chestsea2 then
        if game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Fist of Darkness') then
            game:GetService('VirtualInputManager'):SendKeyEvent(true, 'Q', false, game)

            _G.chestsea2 = false
        elseif not game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Fist of Darkness') then
            if game:GetService('Workspace'):FindFirstChild('Chest1') then
                TPchest(game:GetService('Workspace'):FindFirstChild('Chest1').CFrame)
            end
            if game:GetService('Workspace'):FindFirstChild('Chest2') then
                TPchest(game:GetService('Workspace'):FindFirstChild('Chest2').CFrame)
            end
            if game:GetService('Workspace'):FindFirstChild('Chest3') then
                TPchest(game:GetService('Workspace'):FindFirstChild('Chest3').CFrame)
            end
        end
    end
end)

if game.PlaceId == 4442272183 then
    spawn(function()
        while task.wait(3.5) do
            pcall(function()
                if not game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Fist of Darkness') then
                    if _G.chestsea2 then
                        game.Players.LocalPlayer.Character.Humanoid.Health = 0
                    end

                    wait(5)
                end
            end)
        end
    end)
end

function TPchest(p319)
    local _Magnitude4 = (p319.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

    if _Magnitude4 >= 0 then
        Speed = 1200000
    end

    game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(_Magnitude4 / Speed), {CFrame = p319}):Play()
end

if Third_Sea then
    v3.Main:AddToggle('ToggleChest', {
        Title = 'Auto Chest Stop If Has Items [Tp]',
        Default = false,
    }):OnChanged(function(p321)
        _G.chestsea3 = p321
    end)
    _Options.ToggleChest:SetValue(false)
end
if Second_Sea then
    v3.Main:AddToggle('ToggleChest', {
        Title = 'Auto Chest Stop If Has Items [Tp]',
        Default = false,
    }):OnChanged(function(p322)
        _G.chestsea2 = p322
    end)
    _Options.ToggleChest:SetValue(false)
end

v3.Main:AddToggle('ToggleChestTween', {
    Title = 'Auto Chest [Tween]',
    Default = false,
}):OnChanged(function(p323)
    AutoFarmChest = p323
end)
_Options.ToggleChestTween:SetValue(false)

_G.MagnitudeAdd = 0

spawn(function()
    while true do
        if not wait() then
            return
        end
        if AutoFarmChest then
            local v324, v325, v326 = pairs(game:GetService('Workspace'):GetChildren())

            while true do
                local v327

                v326, v327 = v324(v325, v326)

                if v326 == nil then
                    break
                end
                if v327.Name:find('Chest') and (game:GetService('Workspace'):FindFirstChild(v327.Name) and (v327.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5000 + _G.MagnitudeAdd) then
                    while true do
                        wait()

                        if game:GetService('Workspace'):FindFirstChild(v327.Name) then
                            Tween(v327.CFrame)
                        end
                        if AutoFarmChest == false or not v327.Parent then
                            Tween(game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame)

                            _G.MagnitudeAdd = _G.MagnitudeAdd + 1500

                            break
                        end
                    end
                end
            end
        end
    end
end)
v3.Main:AddButton({
    Title = 'Redeem All Code',
    Description = 'Redeem all code x2 exp',
    Callback = function()
        UseCode()
    end,
})

function UseCode(p328)
    game:GetService('ReplicatedStorage').Remotes.Redeem:InvokeServer(p328)
end

UseCode('Sub2Fer999')
UseCode('Enyu_is_Pro')
UseCode('Magicbus')
UseCode('JCWK')
UseCode('Starcodeheo')
UseCode('Bluxxy')
UseCode('THEGREATACE')
UseCode('SUB2GAMERROBOT_EXP1')
UseCode('StrawHatMaine')
UseCode('Sub2OfficialNoobie')
UseCode('SUB2NOOBMASTER123')
UseCode('Sub2Daigrock')
UseCode('Axiore')
UseCode('TantaiGaming')
UseCode('STRAWHATMAINE')
v3.Main:AddButton({
    Title = 'Fps Booster',
    Description = 'Boost your fps',
    Callback = function()
        FPSBooster()
    end,
})

function FPSBooster()
    local v329 = game
    local _Workspace = v329.Workspace
    local _Lighting = v329.Lighting
    local _Terrain = _Workspace.Terrain

    sethiddenproperty(_Lighting, 'Technology', 2)
    sethiddenproperty(_Terrain, 'Decoration', false)

    _Terrain.WaterWaveSize = 0
    _Terrain.WaterWaveSpeed = 0
    _Terrain.WaterReflectance = 0
    _Terrain.WaterTransparency = 0
    _Lighting.GlobalShadows = false
    _Lighting.FogEnd = 9000000000
    _Lighting.Brightness = 0
    settings().Rendering.QualityLevel = 'Level01'

    local v333, v334, v335 = pairs(v329:GetDescendants())
    local v336 = true

    while true do
        local v337

        v335, v337 = v333(v334, v335)

        if v335 == nil then
            break
        end
        if v337:IsA('Part') or (v337:IsA('Union') or (v337:IsA('CornerWedgePart') or v337:IsA('TrussPart'))) then
            v337.Material = 'Plastic'
            v337.Reflectance = 0
        elseif v337:IsA('Decal') or v337:IsA('Texture') and v336 then
            v337.Transparency = 1
        elseif v337:IsA('ParticleEmitter') or v337:IsA('Trail') then
            v337.Lifetime = NumberRange.new(0)
        elseif v337:IsA('Explosion') then
            v337.BlastPressure = 1
            v337.BlastRadius = 1
        elseif v337:IsA('Fire') or (v337:IsA('SpotLight') or (v337:IsA('Smoke') or v337:IsA('Sparkles'))) then
            v337.Enabled = false
        elseif v337:IsA('MeshPart') then
            v337.Material = 'Plastic'
            v337.Reflectance = 0
            v337.TextureID = 1.0385902758728955e16
        end
    end

    local v338, v339, v340 = pairs(_Lighting:GetChildren())

    while true do
        local v341

        v340, v341 = v338(v339, v340)

        if v340 == nil then
            break
        end
        if v341:IsA('BlurEffect') or (v341:IsA('SunRaysEffect') or (v341:IsA('ColorCorrectionEffect') or (v341:IsA('BloomEffect') or v341:IsA('DepthOfFieldEffect')))) then
            v341.Enabled = false
        end
    end
end

v3.Main:AddSection('Mastery Farm')

local _DropdownMastery = v3.Main:AddDropdown('DropdownMastery', {
    Title = 'Mastery Mode',
    Values = {
        'Level',
        'Near Mobs',
    },
    Multi = false,
    Default = 1,
})

_DropdownMastery:SetValue('Level')
_DropdownMastery:OnChanged(function(p343)
    TypeMastery = p343
end)
v3.Main:AddToggle('ToggleMasteryFruit', {
    Title = 'Auto BF Mastery',
    Default = false,
}):OnChanged(function(p344)
    AutoFarmMasDevilFruit = p344
end)
_Options.ToggleMasteryFruit:SetValue(false)

local _SliderHealt = v3.Main:AddSlider('SliderHealt', {
    Title = 'Health (%) Mob',
    Description = '',
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(p345)
        KillPercent = p345
    end,
})

_SliderHealt:OnChanged(function(p347)
    KillPercent = p347
end)
_SliderHealt:SetValue(25)
spawn(function()
    while task.wait(1) do
        if _G.UseSkill then
            pcall(function()
                if not _G.UseSkill then
                    return
                end

                local v348, v349, v350 = pairs(game:GetService('Workspace').Enemies:GetChildren())
                local v351

                v350, v351 = v348(v349, v350)

                if v350 == nil then
                end
                if v351.Name ~= MonFarm or (not v351:FindFirstChild('Humanoid') or (not v351:FindFirstChild('HumanoidRootPart') or v351.Humanoid.Health > v351.Humanoid.MaxHealth * KillPercent / 100)) then
                end

                game:GetService('RunService').Heartbeat:wait()
                EquipTool(game.Players.LocalPlayer.Data.DevilFruit.Value)
                Tween(v351.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                PositionSkillMasteryDevilFruit = v351.HumanoidRootPart.Position

                if game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
                    game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = PositionSkillMasteryDevilFruit

                    local _Value2 = game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).Level.Value

                    if SkillZ and 1 <= _Value2 then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                        wait(0.1)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                    end
                    if SkillX and 2 <= _Value2 then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'X', false, game)
                        wait(0.2)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'X', false, game)
                    end
                    if SkillC and 3 <= _Value2 then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'C', false, game)
                        wait(0.3)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'C', false, game)
                    end
                    if SkillV and 4 <= _Value2 then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                        wait(0.4)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                    end
                    if SkillF and 5 <= _Value2 then
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 'F', false, game)
                        wait(0.5)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 'F', false, game)
                    end
                end
                if AutoFarmMasDevilFruit and (_G.UseSkill and v351.Humanoid.Health ~= 0) then
                else
                end
            end)
        end
    end
end)
spawn(function()
    while task.wait(0.1) do
        if AutoFarmMasDevilFruit and TypeMastery == 'Level' then
            pcall(function()
                CheckLevel(SelectMonster)

                if not string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('AbandonQuest')

                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude <= 2500 then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude < 2500 then
                                Tween(CFrameQ)
                            end
                        else
                            BTP(CFrameQ)
                            wait(0.2)
                        end
                    else
                        Tween(CFrameQ)
                    end
                    if (CFrameQ.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StartQuest', NameQuest, QuestLv)
                    end
                end
                if not string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) and game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
                    return
                end

                local v353, v354, v355 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                while true do
                    local v356

                    v355, v356 = v353(v354, v355)

                    if v355 == nil then
                    end
                    if v356:FindFirstChild('Humanoid') and (v356:FindFirstChild('HumanoidRootPart') and v356.Name == Ms) then
                        if true then
                            game:GetService('RunService').Heartbeat:wait()

                            if v356.Humanoid.Health > v356.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = false

                                AutoHaki()

                                bringmob = true

                                EquipTool(SelectWeapon)
                                Tween(v356.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                v356.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                v356.HumanoidRootPart.Transparency = 1
                                v356.Humanoid.JumpPower = 0
                                v356.Humanoid.WalkSpeed = 0
                                v356.HumanoidRootPart.CanCollide = false
                                FarmPos = v356.HumanoidRootPart.CFrame
                                MonFarm = v356.Name

                                NormalAttack()
                            else
                                _G.UseSkill = true
                            end
                        end
                        if AutoFarmMasDevilFruit and (v356.Parent and v356.Humanoid.Health ~= 0) and (game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible ~= false and (game:GetService('Workspace').Enemies:FindFirstChild(v356.Name) and not TypeMastery ~= 'Level')) then
                        end

                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end)
        elseif AutoFarmMasDevilFruit and TypeMastery == 'Near Mobs' then
            pcall(function()
                local v357, v358, v359 = pairs(game.Workspace.Enemies:GetChildren())

                while true do
                    local v360

                    v359, v360 = v357(v358, v359)

                    if v359 == nil then
                        return
                    end
                    if v360.Name and (v360:FindFirstChild('Humanoid') and (v360:FindFirstChild('HumanoidRootPart') and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v360:FindFirstChild('HumanoidRootPart').Position).Magnitude <= 5000)) then
                        repeat
                            if true then
                                game:GetService('RunService').Heartbeat:wait()

                                if v360.Humanoid.Health > v360.Humanoid.MaxHealth * KillPercent / 100 then
                                    _G.UseSkill = false

                                    AutoHaki()

                                    bringmob = true

                                    EquipTool(SelectWeapon)
                                    Tween(v360.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    v360.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                    v360.HumanoidRootPart.Transparency = 1
                                    v360.Humanoid.JumpPower = 0
                                    v360.Humanoid.WalkSpeed = 0
                                    v360.HumanoidRootPart.CanCollide = false
                                    FarmPos = v360.HumanoidRootPart.CFrame
                                    MonFarm = v360.Name

                                    NormalAttack()
                                else
                                    _G.UseSkill = true
                                end
                            end
                        until not AutoFarmMasDevilFruit or (not MasteryType == 'Near Mobs' or (not v360.Parent or (v360.Humanoid.Health == 0 or not TypeMastery == 'Near Mobs')))

                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end)
        end
    end
end)
v3.Main:AddSection('Misc Farm')

if Third_Sea then
    v3.Main:AddToggle('ToggleBone', {
        Title = 'Auto Bone',
        Default = false,
    }):OnChanged(function(p361)
        _G.AutoBone = p361
    end)
    _Options.ToggleBone:SetValue(false)

    local u362 = CFrame.new(-9515.75, 174.8521728515625, 6079.40625)
    local u363 = CFrame.new(-9359.453125, 141.32679748535156, 5446.81982421875)

    spawn(function()
        while wait() do
            if _G.AutoBone then
                pcall(function()
                    local _Text = game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

                    if not string.find(_Text, 'Demonic Soul') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('AbandonQuest')
                    end
                    if game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        if BypassTP then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - u363.Position).Magnitude <= 2500 then
                                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - u362.Position).Magnitude < 2500 then
                                    Tween(u362)
                                end
                            else
                                BTP(u363)
                            end
                        else
                            Tween(u362)
                        end
                        if (u362.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StartQuest', 'HauntedQuest2', 1)
                        end
                    end
                    if game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible == true and (game:GetService('Workspace').Enemies:FindFirstChild('Reborn Skeleton') or (game:GetService('Workspace').Enemies:FindFirstChild('Living Zombie') or (game:GetService('Workspace').Enemies:FindFirstChild('Demonic Soul') or game:GetService('Workspace').Enemies:FindFirstChild('Posessed Mummy')))) then
                        local v365, v366, v367 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v368

                            v367, v368 = v365(v366, v367)

                            if v367 == nil then
                                break
                            end
                            if v368:FindFirstChild('HumanoidRootPart') and (v368:FindFirstChild('Humanoid') and (v368.Humanoid.Health > 0 and (v368.Name == 'Reborn Skeleton' or (v368.Name == 'Living Zombie' or (v368.Name == 'Demonic Soul' or v368.Name == 'Posessed Mummy'))))) then
                                if string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Demonic Soul') then
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()

                                    bringmob = true

                                    EquipTool(SelectWeapon)
                                    Tween(v368.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    v368.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                    v368.HumanoidRootPart.Transparency = 1
                                    v368.Humanoid.JumpPower = 0
                                    v368.Humanoid.WalkSpeed = 0
                                    v368.HumanoidRootPart.CanCollide = false
                                    FarmPos = v368.HumanoidRootPart.CFrame
                                    MonFarm = v368.Name

                                    if _G.AutoBone and (v368.Humanoid.Health > 0 and v368.Parent) and game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
                                    end
                                else
                                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('AbandonQuest')

                                    bringmob = false
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('ToggleCake', {
        Title = 'Auto Cake Prince',
        Default = false,
    }):OnChanged(function(p369)
        _G.CakePrince = p369
    end)
    _Options.ToggleCake:SetValue(false)
    spawn(function()
        while wait() do
            if _G.CakePrince then
                pcall(function()
                    local v370 = CFrame.new(-2142.66821, 71.2588654, -12327.4619, 0.996939838, -4.33107843e-8, 0.078172572, 4.20252917e-8, 1, 1.8089425099999998e-8, -0.078172572, -1.47488439e-8, 0.996939838)

                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v370.Position).Magnitude <= 2000 then
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v370.Position).Magnitude < 2000 then
                                Tween(v370)
                            end
                        else
                            BTP(v370)
                            wait(3)
                        end
                    end
                    if game.ReplicatedStorage:FindFirstChild('Cake Prince') or game:GetService('Workspace').Enemies:FindFirstChild('Cake Prince') then
                        if game:GetService('Workspace').Enemies:FindFirstChild('Cake Prince') then
                            local v371, v372, v373 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                            while true do
                                local v374

                                v373, v374 = v371(v372, v373)

                                if v373 == nil then
                                    break
                                end
                                if v374.Name == 'Cake Prince' then
                                    repeat
                                        wait(_G.Fast_Delay)
                                        AttackNoCD()
                                        AutoHaki()
                                        EquipTool(SelectWeapon)

                                        v374.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                        v374.HumanoidRootPart.CanCollide = false

                                        Tween(v374.HumanoidRootPart.CFrame * Pos)
                                    until _G.CakePrince == false or (not v374.Parent or v374.Humanoid.Health <= 0)

                                    bringmob = false
                                end
                            end
                        else
                            Tween(CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875))
                        end
                    elseif game.Workspace.Enemies:FindFirstChild('Baking Staff') or (game.Workspace.Enemies:FindFirstChild('Head Baker') or (game.Workspace.Enemies:FindFirstChild('Cake Guard') or game.Workspace.Enemies:FindFirstChild('Cookie Crafter'))) then
                        local v375, v376, v377 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v378

                            v377, v378 = v375(v376, v377)

                            if v377 == nil then
                                break
                            end
                            if (v378.Name == 'Baking Staff' or (v378.Name == 'Head Baker' or (v378.Name == 'Cake Guard' or v378.Name == 'Cookie Crafter'))) and v378.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()

                                    bringmob = true

                                    EquipTool(SelectWeapon)

                                    v378.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                    FarmPos = v378.HumanoidRootPart.CFrame
                                    MonFarm = v378.Name

                                    Tween(v378.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                                until _G.CakePrince == false or (game:GetService('ReplicatedStorage'):FindFirstChild('Cake Prince') or (not v378.Parent or v378.Humanoid.Health <= 0))

                                bringmob = false
                            end
                        end
                    else
                        Tween(v370)
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('ToggleSpawnCake', {
        Title = 'Auto Spawn Cake Prince',
        Default = true,
    }):OnChanged(function(p379)
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('CakePrinceSpawner', p379)
    end)
    _Options.ToggleSpawnCake:SetValue(true)
end
if Second_Sea then
    v3.Main:AddToggle('ToggleVatChatKiDi', {
        Title = 'Auto Ectoplasm',
        Default = false,
    }):OnChanged(function(p380)
        _G.Ectoplasm = p380
    end)
    _Options.ToggleVatChatKiDi:SetValue(false)
    spawn(function()
        while wait(0.1) do
            pcall(function()
                if _G.Ectoplasm then
                    if game:GetService('Workspace').Enemies:FindFirstChild('Ship Deckhand') or (game:GetService('Workspace').Enemies:FindFirstChild('Ship Engineer') or (game:GetService('Workspace').Enemies:FindFirstChild('Ship Steward') or game:GetService('Workspace').Enemies:FindFirstChild('Ship Officer'))) then
                        local v381, v382, v383 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v384

                            v383, v384 = v381(v382, v383)

                            if v383 == nil then
                                break
                            end
                            if (v384.Name == 'Ship Steward' or (v384.Name == 'Ship Engineer' or (v384.Name == 'Ship Deckhand' or v384.Name == 'Ship Officer' and v384:FindFirstChild('Humanoid')))) and v384.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()

                                    bringmob = true

                                    EquipTool(SelectWeapon)
                                    Tween(v384.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    v384.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v384.HumanoidRootPart.Transparency = 1
                                    v384.Humanoid.JumpPower = 0
                                    v384.Humanoid.WalkSpeed = 0
                                    v384.HumanoidRootPart.CanCollide = false
                                    FarmPos = v384.HumanoidRootPart.CFrame
                                    MonFarm = v384.Name
                                until _G.Ectoplasm == false or (not v384.Parent or v384.Humanoid.Health == 0) or not game:GetService('Workspace').Enemies:FindFirstChild(v384.Name)

                                bringmob = false
                            end
                        end
                    else
                        if (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                        end

                        Tween(CFrame.new(904.4072265625, 181.05767822266, 33341.38671875))
                    end
                end
            end)
        end
    end)
end

v3.Main:AddSection('Boss Farm')

if First_Sea then
    tableBoss = {
        'DauCoGhe Raid Boss [Lv. 7000]',
        'The Gorilla King',
        'Bobby',
        'Yeti',
        'Mob Leader',
        'Vice Admiral',
        'Warden',
        'Chief Warden',
        'Swan',
        'Magma Admiral',
        'Fishman Lord',
        'Wysper',
        'Thunder God',
        'Cyborg',
        'Saber Expert',
    }
elseif Second_Sea then
    tableBoss = {
        'DauCoGhe Raid Boss [Lv. 8000]',
        'Diamond',
        'Jeremy',
        'Fajita',
        'Don Swan',
        'Smoke Admiral',
        'Cursed Captain',
        'Darkbeard',
        'Order',
        'Awakened Ice Admiral',
        'Tide Keeper',
    }
elseif Third_Sea then
    tableBoss = {
        'DauCoGhe Raid Boss [Lv. 9000]',
        'Stone',
        'Island Empress',
        'Kilo Admiral',
        'Captain Elephant',
        'Beautiful Pirate',
        'rip_indra True Form',
        'Longma',
        'Soul Reaper',
        'Cake Queen',
    }
end

local _DropdownBoss = v3.Main:AddDropdown('DropdownBoss', {
    Title = 'Dropdown',
    Values = tableBoss,
    Multi = false,
    Default = 1,
})

_DropdownBoss:SetValue('')
_DropdownBoss:OnChanged(function(p386)
    _G.SelectBoss = p386
end)
v3.Main:AddToggle('ToggleAutoFarmBoss', {
    Title = 'Kill Boss',
    Default = false,
}):OnChanged(function(p387)
    _G.AutoBoss = p387
end)
_Options.ToggleAutoFarmBoss:SetValue(false)
spawn(function()
    while wait() do
        if _G.AutoBoss and BypassTP then
            pcall(function()
                if game:GetService('Workspace').Enemies:FindFirstChild(_G.SelectBoss) then
                    local v388, v389, v390 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                    while true do
                        local v391

                        v390, v391 = v388(v389, v390)

                        if v390 == nil then
                            break
                        end
                        if v391.Name == _G.SelectBoss and (v391:FindFirstChild('Humanoid') and (v391:FindFirstChild('HumanoidRootPart') and v391.Humanoid.Health > 0)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()
                                AutoHaki()

                                bringmob = true

                                EquipTool(SelectWeapon)

                                v391.HumanoidRootPart.CanCollide = false
                                v391.Humanoid.WalkSpeed = 0
                                v391.HumanoidRootPart.Size = Vector3.new(80, 80, 80)

                                Tween(v391.HumanoidRootPart.CFrame * Pos)
                                sethiddenproperty(game:GetService('Players').LocalPlayer, 'SimulationRadius', math.huge)
                            until not _G.AutoBoss or (not v391.Parent or v391.Humanoid.Health <= 0)

                            bringmob = false
                        end
                    end
                elseif game.ReplicatedStorage:FindFirstChild(_G.SelectBoss) then
                    if (game.ReplicatedStorage:FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 1500 then
                        BTP(game.ReplicatedStorage:FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame)
                    else
                        Tween(game.ReplicatedStorage:FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame)
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoBoss and not BypassTP then
            pcall(function()
                if game:GetService('Workspace').Enemies:FindFirstChild(_G.SelectBoss) then
                    local v392, v393, v394 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                    while true do
                        local v395

                        v394, v395 = v392(v393, v394)

                        if v394 == nil then
                            break
                        end
                        if v395.Name == _G.SelectBoss and (v395:FindFirstChild('Humanoid') and (v395:FindFirstChild('HumanoidRootPart') and v395.Humanoid.Health > 0)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()
                                AutoHaki()

                                bringmob = true

                                EquipTool(SelectWeapon)

                                v395.HumanoidRootPart.CanCollide = false
                                v395.Humanoid.WalkSpeed = 0
                                v395.HumanoidRootPart.Size = Vector3.new(80, 80, 80)

                                Tween(v395.HumanoidRootPart.CFrame * Pos)
                                sethiddenproperty(game:GetService('Players').LocalPlayer, 'SimulationRadius', math.huge)
                            until not _G.AutoBoss or (not v395.Parent or v395.Humanoid.Health <= 0)

                            bringmob = false
                        end
                    end
                elseif game:GetService('ReplicatedStorage'):FindFirstChild(_G.SelectBoss) then
                    Tween(game:GetService('ReplicatedStorage'):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                end
            end)
        end
    end
end)
v3.Main:AddSection('Material Farm')

if First_Sea then
    MaterialList = {
        'Scrap Metal',
        'Leather',
        'Angel Wings',
        'Magma Ore',
        'Fish Tail',
    }
elseif Second_Sea then
    MaterialList = {
        'Scrap Metal',
        'Leather',
        'Radioactive Material',
        'Mystic Droplet',
        'Magma Ore',
        'Vampire Fang',
    }
elseif Third_Sea then
    MaterialList = {
        'Scrap Metal',
        'Leather',
        'Demonic Wisp',
        'Conjured Cocoa',
        'Dragon Scale',
        'Gunpowder',
        'Fish Tail',
        'Mini Tusk',
    }
end

local _DropdownMaterial = v3.Main:AddDropdown('DropdownMaterial', {
    Title = 'Dropdown',
    Values = MaterialList,
    Multi = false,
    Default = 1,
})

_DropdownMaterial:SetValue('Conjured Cocoa')
_DropdownMaterial:OnChanged(function(p397)
    SelectMaterial = p397
end)
v3.Main:AddToggle('ToggleMaterial', {
    Title = 'Auto Material',
    Default = false,
}):OnChanged(function(p398)
    _G.AutoMaterial = p398
end)
_Options.ToggleMaterial:SetValue(false)
spawn(function()
    while task.wait() do
        if _G.AutoMaterial then
            pcall(function()
                MaterialMon(SelectMaterial)

                if BypassTP then
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MPos.Position).Magnitude <= 3500 then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MPos.Position).Magnitude < 3500 then
                            Tween(MPos)
                        end
                    else
                        BTP(MPos)
                    end
                else
                    Tween(MPos)
                end
                if game:GetService('Workspace').Enemies:FindFirstChild(MMon) then
                    local v399, v400, v401 = pairs(game.Workspace.Enemies:GetChildren())

                    while true do
                        local v402

                        v401, v402 = v399(v400, v401)

                        if v401 == nil then
                            break
                        end
                        if v402:FindFirstChild('Humanoid') and (v402:FindFirstChild('HumanoidRootPart') and (v402.Humanoid.Health > 0 and v402.Name == MMon)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()
                                AutoHaki()

                                bringmob = true

                                EquipTool(SelectWeapon)
                                Tween(v402.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                v402.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v402.HumanoidRootPart.Transparency = 1
                                v402.Humanoid.JumpPower = 0
                                v402.Humanoid.WalkSpeed = 0
                                v402.HumanoidRootPart.CanCollide = false
                                FarmPos = v402.HumanoidRootPart.CFrame
                                MonFarm = v402.Name
                            until not _G.AutoMaterial or (not v402.Parent or v402.Humanoid.Health <= 0)

                            bringmob = false
                        end
                    end
                else
                    local v403, v404, v405 = pairs(game:GetService('Workspace')._WorldOrigin.EnemySpawns:GetChildren())

                    while true do
                        local v406

                        v405, v406 = v403(v404, v405)

                        if v405 == nil then
                            break
                        end
                        if string.find(v406.Name, Mon) and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v406.Position).Magnitude >= 10 then
                            Tween(v406.CFrame * CFrame.new(posX, posY, posZ))
                        end
                    end
                end
            end)
        end
    end
end)

if Third_Sea then
    v3.Main:AddSection('\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd} Kitsune \u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}\u{fffd}')
    v3.Main:AddToggle('ToggleEspKitsune', {
        Title = 'Esp Kitsune Island',
        Default = false,
    }):OnChanged(function(p407)
        KitsuneEsp = p407

        while IslandESP do
            wait()
            UpdateKitsune()
        end
    end)
    _Options.ToggleEspKitsune:SetValue(false)

    function UpdateKitsune()
        local v408, v409, v410 = pairs(game:GetService('Workspace').Map.KitsuneIsalnd.ShrineActive:GetChildren())

        while true do
            local u411

            v410, u411 = v408(v409, v410)

            if v410 == nil then
                break
            end

            pcall(function()
                if KitsuneEsp then
                    if u411.Name ~= 'NeonShrinePart' then
                        if u411:FindFirstChild('IslandESP') then
                            u411.IslandESP.TextLabel.Text = 'Kitsune Island'
                        else
                            local _BillboardGui25 = Instance.new('BillboardGui', u411)

                            _BillboardGui25.Name = 'IslandESP'
                            _BillboardGui25.ExtentsOffset = Vector3.new(0, 1, 0)
                            _BillboardGui25.Size = UDim2.new(1, 200, 1, 30)
                            _BillboardGui25.Adornee = u411
                            _BillboardGui25.AlwaysOnTop = true

                            local _TextLabel25 = Instance.new('TextLabel', _BillboardGui25)

                            _TextLabel25.Font = 'Code'
                            _TextLabel25.FontSize = 'Size14'
                            _TextLabel25.TextWrapped = true
                            _TextLabel25.Size = UDim2.new(1, 0, 1, 0)
                            _TextLabel25.TextYAlignment = 'Top'
                            _TextLabel25.BackgroundTransparency = 1
                            _TextLabel25.TextStrokeTransparency = 0.5
                            _TextLabel25.TextColor3 = Color3.fromRGB(80, 245, 245)
                            _TextLabel25.Text = 'Kitsune Island'
                        end
                    end
                elseif u411:FindFirstChild('IslandESP') then
                    u411:FindFirstChild('IslandESP'):Destroy()
                end
            end)
        end
    end

    v3.Main:AddToggle('ToggleTPKitsune', {
        Title = 'Tween To Kitsune Island',
        Default = false,
    }):OnChanged(function(p414)
        _G.TweenToKitsune = p414
    end)
    _Options.ToggleTPKitsune:SetValue(false)
    spawn(function()
        local v415 = nil

        while not v415 do
            v415 = game:GetService('Workspace').Map:FindFirstChild('KitsuneIsland')

            wait(1)
        end
        while wait() do
            if _G.TweenToKitsune then
                local _ShrineActive = v415:FindFirstChild('ShrineActive')

                if _ShrineActive then
                    local v417, v418, v419 = pairs(_ShrineActive:GetDescendants())

                    while true do
                        local v420

                        v419, v420 = v417(v418, v419)

                        if v419 == nil then
                            break
                        end
                        if v420:IsA('BasePart') and v420.Name:find('NeonShrinePart') then
                            Tween(v420.CFrame)
                        end
                    end
                end
            end
        end
    end)
    v3.Main:AddToggle('ToggleCollectAzure', {
        Title = 'Collect Azure Ambers',
        Default = false,
    }):OnChanged(function(p421)
        _G.CollectAzure = p421
    end)
    _Options.ToggleCollectAzure:SetValue(false)
    spawn(function()
        while wait() do
            if _G.CollectAzure then
                pcall(function()
                    if game:GetService('Workspace'):FindFirstChild('AttachedAzureEmber') then
                        Tween(game:GetService('Workspace'):WaitForChild('EmberTemplate'):FindFirstChild('Part').CFrame)
                        print('Azure')
                    end
                end)
            end
        end
    end)
end
if Third_Sea then
    v3.Main:AddSection('Rough Sea')
    v3.Main:AddToggle('ToggleSailBoat', {
        Title = 'Auto Buy Ship',
        Default = false,
    }):OnChanged(function(p422)
        _G.SailBoat = p422
    end)
    _Options.ToggleSailBoat:SetValue(false)
    spawn(function()
        while wait() do
            pcall(function()
                if not _G.SailBoat or game:GetService('Workspace').Enemies:FindFirstChild('Shark') and (game:GetService('Workspace').Enemies:FindFirstChild('Terrorshark') and (game:GetService('Workspace').Enemies:FindFirstChild('Piranha') and game:GetService('Workspace').Enemies:FindFirstChild('Fish Crew Member'))) then
                    return
                end
                if not game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                    buyb = TweenBoat(CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781))

                    if (CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                        if buyb then
                            buyb:Stop()
                        end

                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                            'BuyBoat',
                            'PirateGrandBrigade',
                        }))
                    end
                end
                if not game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                end
                if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit == false then
                    TweenBoat(game:GetService('Workspace').Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                end

                local v423, v424, v425 = pairs(game:GetService('Workspace').Boats:GetChildren())
                local v426

                v425, v426 = v423(v424, v425)

                if v425 == nil then
                end
                if v426.Name ~= 'PirateGrandBrigade' then
                end
                if true then
                    wait()

                    if (CFrame.new(-17013.80078125, 10.962434768676758, 438.0169982910156).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
                        if (CFrame.new(-33163.1875, 10.964323997497559, -324.4842224121094).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
                            if (CFrame.new(-37952.49609375, 10.96342945098877, -1324.12109375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                TweenShip(CFrame.new(-33163.1875, 10.964323997497559, -324.4842224121094))
                            end
                        else
                            TweenShip(CFrame.new(-37952.49609375, 10.96342945098877, -1324.12109375))
                        end
                    else
                        TweenShip(CFrame.new(-33163.1875, 10.964323997497559, -324.4842224121094))
                    end
                end
                if game:GetService('Workspace').Enemies:FindFirstChild('Shark') or (game:GetService('Workspace').Enemies:FindFirstChild('Terrorshark') or (game:GetService('Workspace').Enemies:FindFirstChild('Piranha') or (game:GetService('Workspace').Enemies:FindFirstChild('Fish Crew Member') or _G.SailBoat == false))) then
                else
                end
            end)
        end
    end)
    spawn(function()
        pcall(function()
            while wait() do
                if _G.SailBoat and (game:GetService('Workspace').Enemies:FindFirstChild('Shark') or (game:GetService('Workspace').Enemies:FindFirstChild('Terrorshark') or (game:GetService('Workspace').Enemies:FindFirstChild('Piranha') or game:GetService('Workspace').Enemies:FindFirstChild('Fish Crew Member')))) then
                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
            end
        end)
    end)
    v3.Main:AddToggle('ToggleTerrorshark', {
        Title = ' Kill Terrorshark',
        Default = false,
    }):OnChanged(function(p427)
        _G.AutoTerrorshark = p427
    end)
    _Options.ToggleTerrorshark:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoTerrorshark then
                pcall(function()
                    if game:GetService('Workspace').Enemies:FindFirstChild('Terrorshark') then
                        local v428, v429, v430 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v431

                            v430, v431 = v428(v429, v430)

                            if v430 == nil then
                                break
                            end
                            if v431.Name == 'Terrorshark' and (v431:FindFirstChild('Humanoid') and (v431:FindFirstChild('HumanoidRootPart') and v431.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v431.HumanoidRootPart.CanCollide = false
                                    v431.Humanoid.WalkSpeed = 0
                                    v431.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

                                    Tween(v431.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                                until not _G.AutoTerrorshark or (not v431.Parent or v431.Humanoid.Health <= 0)
                            end
                        end
                    elseif game:GetService('ReplicatedStorage'):FindFirstChild('Terrorshark') then
                        Tween(game:GetService('ReplicatedStorage'):FindFirstChild('Terrorshark').HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('TogglePiranha', {
        Title = ' Kill Piranha',
        Default = false,
    }):OnChanged(function(p432)
        _G.farmpiranya = p432
    end)
    _Options.TogglePiranha:SetValue(false)
    spawn(function()
        while wait() do
            if _G.farmpiranya then
                pcall(function()
                    if game:GetService('Workspace').Enemies:FindFirstChild('Piranha') then
                        local v433, v434, v435 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v436

                            v435, v436 = v433(v434, v435)

                            if v435 == nil then
                                break
                            end
                            if v436.Name == 'Piranha' and (v436:FindFirstChild('Humanoid') and (v436:FindFirstChild('HumanoidRootPart') and v436.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v436.HumanoidRootPart.CanCollide = false
                                    v436.Humanoid.WalkSpeed = 0
                                    v436.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

                                    Tween(v436.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                                until not _G.farmpiranya or (not v436.Parent or v436.Humanoid.Health <= 0)
                            end
                        end
                    elseif game:GetService('ReplicatedStorage'):FindFirstChild('Piranha') then
                        Tween(game:GetService('ReplicatedStorage'):FindFirstChild('Piranha').HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('ToggleShark', {
        Title = ' Kill Shark',
        Default = false,
    }):OnChanged(function(p437)
        _G.AutoShark = p437
    end)
    _Options.ToggleShark:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoShark then
                pcall(function()
                    if game:GetService('Workspace').Enemies:FindFirstChild('Shark') then
                        local v438, v439, v440 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v441

                            v440, v441 = v438(v439, v440)

                            if v440 == nil then
                                break
                            end
                            if v441.Name == 'Shark' and (v441:FindFirstChild('Humanoid') and (v441:FindFirstChild('HumanoidRootPart') and v441.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v441.HumanoidRootPart.CanCollide = false
                                    v441.Humanoid.WalkSpeed = 0
                                    v441.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

                                    Tween(v441.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                until not _G.AutoShark or (not v441.Parent or v441.Humanoid.Health <= 0)
                            end
                        end
                    else
                        Tween(game:GetService('Workspace').Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

                        if game:GetService('ReplicatedStorage'):FindFirstChild('Terrorshark') then
                            Tween(game:GetService('ReplicatedStorage'):FindFirstChild('Terrorshark').HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('ToggleFishCrew', {
        Title = ' Kill Fish Crew',
        Default = false,
    }):OnChanged(function(p442)
        _G.AutoFishCrew = p442
    end)
    _Options.ToggleFishCrew:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoFishCrew then
                pcall(function()
                    if game:GetService('Workspace').Enemies:FindFirstChild('Fish Crew Member') then
                        local v443, v444, v445 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v446

                            v445, v446 = v443(v444, v445)

                            if v445 == nil then
                                break
                            end
                            if v446.Name == 'Fish Crew Member' and (v446:FindFirstChild('Humanoid') and (v446:FindFirstChild('HumanoidRootPart') and v446.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v446.HumanoidRootPart.CanCollide = false
                                    v446.Humanoid.WalkSpeed = 0
                                    v446.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

                                    Tween(v446.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                until not _G.AutoFishCrew or (not v446.Parent or v446.Humanoid.Health <= 0)
                            end
                        end
                    else
                        Tween(game:GetService('Workspace').Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

                        if game:GetService('ReplicatedStorage'):FindFirstChild('Fish Crew Member') then
                            Tween(game:GetService('ReplicatedStorage'):FindFirstChild('Fish Crew Member').HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('ToggleShip', {
        Title = 'Kill Ship',
        Default = false,
    }):OnChanged(function(p447)
        _G.Ship = p447
    end)
    _Options.ToggleShip:SetValue(false)

    function CheckPirateBoat()
        local v448 = next
        local v449, v450 = game:GetService('Workspace').Enemies:GetChildren()
        local v451 = {
            'PirateGrandBrigade',
            'PirateBrigade',
        }

        while true do
            local v452

            v450, v452 = v448(v449, v450)

            if v450 == nil then
                break
            end
            if table.find(v451, v452.Name) and (v452:FindFirstChild('Health') and v452.Health.Value > 0) then
                return v452
            end
        end
    end

    spawn(function()
        while wait() do
            if _G.Ship then
                pcall(function()
                    if CheckPirateBoat() then
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 32, false, game)
                        wait(0.5)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 32, false, game)

                        local v453 = CheckPirateBoat()

                        repeat
                            wait()
                            spawn(Tween(v453.Engine.CFrame * CFrame.new(0, -20, 0)), 1)

                            AimBotSkillPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                            Skillaimbot = true
                            AutoSkill = false
                        until not v453 or (not v453.Parent or (v453.Health.Value <= 0 or not CheckPirateBoat()))

                        Skillaimbot = true
                        AutoSkill = false
                    end
                end)
            end
        end
    end)
    v3.Main:AddToggle('ToggleGhostShip', {
        Title = 'Kill Ghost Ship',
        Default = false,
    }):OnChanged(function(p454)
        _G.GhostShip = p454
    end)
    _Options.ToggleGhostShip:SetValue(false)

    function CheckPirateBoat()
        local v455 = next
        local v456, v457 = game:GetService('Workspace').Enemies:GetChildren()
        local v458 = {
            'FishBoat',
        }

        while true do
            local v459

            v457, v459 = v455(v456, v457)

            if v457 == nil then
                break
            end
            if table.find(v458, v459.Name) and (v459:FindFirstChild('Health') and v459.Health.Value > 0) then
                return v459
            end
        end
    end

    spawn(function()
        while wait() do
            pcall(function()
                if _G.bjirFishBoat and CheckPirateBoat() then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 32, false, game)
                    wait(0.5)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 32, false, game)

                    local v460 = CheckPirateBoat()

                    repeat
                        wait()
                        spawn(Tween(v460.Engine.CFrame * CFrame.new(0, -20, 0), 1))

                        AutoSkill = true
                        Skillaimbot = true
                        AimBotSkillPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                    until v460.Parent or (v460.Health.Value <= 0 or not CheckPirateBoat())

                    AutoSkill = false
                    Skillaimbot = false
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            if _G.bjirFishBoat then
                pcall(function()
                    if CheckPirateBoat() then
                        AutoHaki()
                        game:GetService('VirtualUser'):CaptureController()
                        game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))

                        local v461, v462, v463 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v464

                            v463, v464 = v461(v462, v463)

                            if v463 == nil then
                                break
                            end
                            if v464:IsA('Tool') and v464.ToolTip == 'Melee' then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v464)
                            end
                        end

                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 'C', false, game.Players.LocalPlayer.Character.HumanoidRootPart)

                        local v465, v466, v467 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v468

                            v467, v468 = v465(v466, v467)

                            if v467 == nil then
                                break
                            end
                            if v468:IsA('Tool') and v468.ToolTip == 'Blox Fruit' then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v468)
                            end
                        end

                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 'V', false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 'V', false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.6)

                        local v469, v470, v471 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v472

                            v471, v472 = v469(v470, v471)

                            if v471 == nil then
                                break
                            end
                            if v472:IsA('Tool') and v472.ToolTip == 'Sword' then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v472)
                            end
                        end

                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.5)

                        local v473, v474, v475 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v476

                            v475, v476 = v473(v474, v475)

                            if v475 == nil then
                                break
                            end
                            if v476:IsA('Tool') and v476.ToolTip == 'Gun' then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v476)
                            end
                        end

                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    end
                end)
            end
        end
    end)
    v3.Main:AddSection('Elite Hunter Farm')
    v3.Main:AddToggle('ToggleElite', {
        Title = 'Auto Elite Hunter',
        Default = false,
    }):OnChanged(function(p477)
        _G.AutoElite = p477
    end)
    _Options.ToggleElite:SetValue(false)
    spawn(function()
        while task.wait() do
            if _G.AutoElite then
                pcall(function()
                    if game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('EliteHunter')
                    elseif string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Diablo') or (string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Deandre') or string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Urban')) then
                        if game:GetService('Workspace').Enemies:FindFirstChild('Diablo') or (game:GetService('Workspace').Enemies:FindFirstChild('Deandre') or game:GetService('Workspace').Enemies:FindFirstChild('Urban')) then
                            local v478, v479, v480 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                            while true do
                                local v481

                                v480, v481 = v478(v479, v480)

                                if v480 == nil then
                                    break
                                end
                                if v481:FindFirstChild('Humanoid') and (v481:FindFirstChild('HumanoidRootPart') and (v481.Humanoid.Health > 0 and (v481.Name == 'Diablo' or (v481.Name == 'Deandre' or v481.Name == 'Urban')))) then
                                    repeat
                                        wait(_G.Fast_Delay)
                                        AttackNoCD()
                                        EquipTool(SelectWeapon)
                                        AutoHaki()
                                        toTarget(v481.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                        MonsterPosition = v481.HumanoidRootPart.CFrame
                                        v481.HumanoidRootPart.CFrame = v481.HumanoidRootPart.CFrame
                                        v481.Humanoid.JumpPower = 0
                                        v481.Humanoid.WalkSpeed = 0
                                        v481.HumanoidRootPart.CanCollide = false
                                        v481.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                                    until _G.AutoElite == false or (v481.Humanoid.Health <= 0 or not v481.Parent)
                                end
                            end
                        elseif game:GetService('ReplicatedStorage'):FindFirstChild('Diablo') then
                            toTarget(game:GetService('ReplicatedStorage'):FindFirstChild('Diablo').HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                        elseif game:GetService('ReplicatedStorage'):FindFirstChild('Deandre') then
                            toTarget(game:GetService('ReplicatedStorage'):FindFirstChild('Deandre').HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                        elseif game:GetService('ReplicatedStorage'):FindFirstChild('Urban') then
                            toTarget(game:GetService('ReplicatedStorage'):FindFirstChild('Urban').HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                        end
                    end
                end)
            end
        end
    end)
end
if Third_Sea then
    v3.Main:AddSection('Sea Beast')
    v3.Main:AddToggle('ToggleSeaBeAst', {
        Title = 'Auto Sea Beast',
        Default = false,
    }):OnChanged(function(p482)
        _G.AutoSeaBeast = p482
    end)
    _Options.ToggleSeaBeAst:SetValue(false)

    Skillz = true
    Skillx = true
    Skillc = true
    Skillv = true

    spawn(function()
        while wait() do
            pcall(function()
                if AutoSkill then
                    if Skillz then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                        wait(0.1)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                    end
                    if Skillx then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'X', false, game)
                        wait(0.1)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'X', false, game)
                    end
                    if Skillc then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'C', false, game)
                        wait(0.1)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'C', false, game)
                    end
                    if Skillv then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                        wait(0.1)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                    end
                end
            end)
        end
    end)
    task.spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoSeaBeast then
                    if game:GetService('Workspace').SeaBeasts:FindFirstChild('SeaBeast1') then
                        if game:GetService('Workspace').SeaBeasts:FindFirstChild('SeaBeast1') then
                            local v483, v484, v485 = pairs(game:GetService('Workspace').SeaBeasts:GetChildren())

                            while true do
                                local v486

                                v485, v486 = v483(v484, v485)

                                if v485 == nil then
                                    break
                                end
                                if v486:FindFirstChild('HumanoidRootPart') then
                                    repeat
                                        wait()

                                        game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit = false

                                        TweenBoat(v486.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
                                        EquipAllWeapon()

                                        AutoSkill = true
                                        AimBotSkillPosition = v486.HumanoidRootPart
                                        Skillaimbot = true
                                    until not v486:FindFirstChild('HumanoidRootPart') or _G.AutoSeaBeast == false

                                    AutoSkill = false
                                    Skillaimbot = false
                                end
                            end
                        end
                    elseif game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                        if game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                            local v487, v488, v489 = pairs(game:GetService('Workspace').Boats:GetChildren())

                            while true do
                                local v490

                                v489, v490 = v487(v488, v489)

                                if v489 == nil then
                                    break
                                end
                                if v490.Name == 'PirateGrandBrigade' and v490:FindFirstChild('VehicleSeat') then
                                    repeat
                                        wait()

                                        game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit = false

                                        TweenBoat(v490.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                                    until not game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') or _G.AutoSeaBeast == false
                                end
                            end
                        end
                    else
                        if not game:GetService('Workspace').Boats:FindFirstChild('PirateBasic') then
                            if not game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                                buyb = TweenBoat(CFrame.new(-4513.90087890625, 16.76398277282715, -2658.820556640625))

                                if (CFrame.new(-4513.90087890625, 16.76398277282715, -2658.820556640625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                    if buyb then
                                        buyb:Stop()
                                    end

                                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                                        'BuyBoat',
                                        'PirateGrandBrigade',
                                    }))
                                end
                            end
                            if not game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                            end
                            if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit == false then
                                TweenBoat(game:GetService('Workspace').Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                            end
                            if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit ~= true then
                            end

                            while true do
                                wait()

                                if (game:GetService('Workspace').Boats.PirateGrandBrigade.VehicleSeat.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                    TweenShip(CFrame.new(35.04552459716797, 17.750778198242188, 4819.267578125))
                                end
                                if game:GetService('Workspace').SeaBeasts:FindFirstChild('SeaBeast1') or _G.AutoSeaBeast == false then
                                end
                            end
                        end
                        if game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') then
                            local v491, v492, v493 = pairs(game:GetService('Workspace').Boats:GetChildren())

                            while true do
                                local v494

                                v493, v494 = v491(v492, v493)

                                if v493 == nil then
                                    break
                                end
                                if v494.Name == 'PirateGrandBrigade' and v494:FindFirstChild('VehicleSeat') then
                                    repeat
                                        wait()

                                        game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit = false

                                        TweenBoat(v494.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                                    until not game:GetService('Workspace').Boats:FindFirstChild('PirateGrandBrigade') or _G.AutoSeaBeast == false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    v3.Main:AddToggle('ToggleAutoW', {
        Title = 'Auto Press W',
        Default = false,
    }):OnChanged(function(p495)
        _G.AutoW = p495
    end)
    _Options.ToggleAutoW:SetValue(false)
    spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoW then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 'W', false, game)
                end
            end)
        end
    end)
    v3.Main:AddSection('Mirage Island')
    v3.Main:AddToggle('ToggleTweenMirageIsland', {
        Title = 'Tween To Mirage Island',
        Default = false,
    }):OnChanged(function(p496)
        _G.AutoMysticIsland = p496
    end)
    _Options.ToggleTweenMirageIsland:SetValue(false)
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoMysticIsland and game:GetService('Workspace').Map:FindFirstChild('MysticIsland') then
                    Tween(CFrame.new(game:GetService('Workspace').Map.MysticIsland.Center.Position.X, 500, game:GetService('Workspace').Map.MysticIsland.Center.Position.Z))
                end
            end
        end)
    end)
    v3.Main:AddToggle('ToggleTweenGear', {
        Title = 'Tween To Gear',
        Default = false,
    }):OnChanged(function(p497)
        _G.TweenToGear = p497
    end)
    _Options.ToggleTweenGear:SetValue(false)
    spawn(function()
        pcall(function()
            while wait() do
                if _G.TweenToGear and game:GetService('Workspace').Map:FindFirstChild('MysticIsland') then
                    local v498, v499, v500 = pairs(game:GetService('Workspace').Map.MysticIsland:GetChildren())

                    while true do
                        local v501

                        v500, v501 = v498(v499, v500)

                        if v500 == nil then
                            break
                        end
                        if v501:IsA('MeshPart') and v501.Material == Enum.Material.Neon then
                            Tween(v501.CFrame)
                        end
                    end
                end
            end
        end)
    end)
    v3.Main:AddToggle('Togglelockmoon', {
        Title = 'Lock Moon and Use Race Skill',
        Default = false,
    }):OnChanged(function(p502)
        _G.AutoLockMoon = p502
    end)
    _Options.Togglelockmoon:SetValue(false)
    spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoLockMoon then
                    local v503 = game.Lighting:GetMoonDirection()
                    local v504 = game.Workspace.CurrentCamera.CFrame.p + v503 * 100

                    game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.p, v504)
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoLockMoon then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 'T', false, game)
                    wait(0.1)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 'T', false, game)
                end
            end)
        end
    end)
    v3.Main:AddToggle('ToggleMirage', {
        Title = 'Auto Mirage Island',
        Default = false,
    }):OnChanged(function(p505)
        _G.AutoSeaBeast = p505
    end)
    _Options.ToggleMirage:SetValue(false)
    v3.Main:AddToggle('AutoW', {
        Title = 'Auto Press W',
        Default = false,
    }):OnChanged(function(p506)
        _G.AutoW = p506
    end)
    _Options.AutoW:SetValue(false)
    spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoW then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 'W', false, game)
                end
            end)
        end
    end)
end

v3.Main:AddSection('Items Farm')

if Third_Sea then
    v3.Main:AddToggle('ToggleHallow', {
        Title = 'Auto Hallow Scythe [Fully]',
        Default = false,
    }):OnChanged(function(p507)
        AutoHallowSycthe = p507
    end)
    _Options.ToggleHallow:SetValue(false)
    spawn(function()
        while wait() do
            if AutoHallowSycthe then
                pcall(function()
                    if game:GetService('Workspace').Enemies:FindFirstChild('Soul Reaper') then
                        local v508, v509, v510 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v511

                            v510, v511 = v508(v509, v510)

                            if v510 == nil then
                                break
                            end
                            if string.find(v511.Name, 'Soul Reaper') then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)

                                    v511.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

                                    Tween(v511.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    v511.HumanoidRootPart.Transparency = 1

                                    sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                                until v511.Humanoid.Health <= 0 or AutoHallowSycthe == false
                            end
                        end
                    elseif game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Hallow Essence') or game:GetService('Players').LocalPlayer.Character:FindFirstChild('Hallow Essence') then
                        repeat
                            Tween(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
                            wait()
                        until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8

                        EquipTool('Hallow Essence')
                    elseif game:GetService('ReplicatedStorage'):FindFirstChild('Soul Reaper') then
                        Tween(game:GetService('ReplicatedStorage'):FindFirstChild('Soul Reaper').HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait(0.001) do
            if AutoHallowSycthe then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'Bones',
                    'Buy',
                    1,
                    1,
                }))
            end
        end
    end)
    v3.Main:AddToggle('ToggleYama', {
        Title = 'Auto Get Yama',
        Default = false,
    }):OnChanged(function(p512)
        _G.AutoYama = p512
    end)
    _Options.ToggleYama:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoYama and game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('EliteHunter', 'Progress') >= 30 then
                repeat
                    wait(0.1)
                    fireclickdetector(game:GetService('Workspace').Map.Waterfall.SealedKatana.Handle.ClickDetector)
                until game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Yama') or not _G.AutoYama
            end
        end
    end)
    v3.Main:AddToggle('ToggleTushita', {
        Title = 'Auto Tushita',
        Default = false,
    }):OnChanged(function(p513)
        AutoTushita = p513
    end)
    _Options.ToggleTushita:SetValue(false)
    spawn(function()
        while true do
            repeat
                if not wait() then
                    return
                end
            until AutoTushita

            if game:GetService('Workspace').Enemies:FindFirstChild('Longma') then
                break
            end

            Tween(CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125))
        end

        local v514, v515, v516 = pairs(game:GetService('Workspace').Enemies:GetChildren())
        local v517

        v516, v517 = v514(v515, v516)

        if v516 ~= nil then
        end
        if v517.Name == ('Longma' or v517.Name == 'Longma') and (v517.Humanoid.Health > 0 and (v517:IsA('Model') and (v517:FindFirstChild('Humanoid') and v517:FindFirstChild('HumanoidRootPart')))) then
        else
        end

        wait(_G.Fast_Delay)
        AttackNoCD()
        AutoHaki()

        if not game.Players.LocalPlayer.Character:FindFirstChild(SelectWeapon) then
            wait()
            EquipTool(SelectWeapon)
        end

        FarmPos = v517.HumanoidRootPart.CFrame
        v517.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        v517.Humanoid.JumpPower = 0
        v517.Humanoid.WalkSpeed = 0
        v517.HumanoidRootPart.CanCollide = false

        v517.Humanoid:ChangeState(11)
        Tween(v517.HumanoidRootPart.CFrame * Pos)

        if AutoTushita and (v517.Parent and v517.Humanoid.Health > 0) then
        else
        end
    end)
    v3.Main:AddToggle('ToggleHoly', {
        Title = 'Auto Holy Torch',
        Default = false,
    }):OnChanged(function(p518)
        _G.Auto_Holy_Torch = p518
    end)
    _Options.ToggleHoly:SetValue(false)
    spawn(function()
        while wait() do
            if _G.Auto_Holy_Torch then
                pcall(function()
                    wait(1)

                    repeat
                        Tween(CFrame.new(-10752, 417, -9366))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-10752, 417, -9366)).Magnitude <= 10

                    wait(1)

                    repeat
                        Tween(CFrame.new(-11672, 334, -9474))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-11672, 334, -9474)).Magnitude <= 10

                    wait(1)

                    repeat
                        Tween(CFrame.new(-12132, 521, -10655))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-12132, 521, -10655)).Magnitude <= 10

                    wait(1)

                    repeat
                        Tween(CFrame.new(-13336, 486, -6985))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-13336, 486, -6985)).Magnitude <= 10

                    wait(1)

                    repeat
                        Tween(CFrame.new(-13489, 332, -7925))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-13489, 332, -7925)).Magnitude <= 10
                end)
            end
        end
    end)
end
if Second_Sea then
    v3.Main:AddToggle('ToggleFactory', {
        Title = 'Auto Farm Factory',
        Default = false,
    }):OnChanged(function(p519)
        _G.Factory = p519
    end)
    _Options.ToggleFactory:SetValue(false)
    spawn(function()
        while true do
            repeat
                if not wait() then
                    return
                end
            until _G.Factory

            if game.Workspace.Enemies:FindFirstChild('Core') then
                break
            end
            if game.ReplicatedStorage:FindFirstChild('Core') then
                repeat
                    Tween(CFrame.new(448.46756, 199.356781, -441.389252))
                    wait()
                until not _G.Factory or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(448.46756, 199.356781, -441.389252)).Magnitude <= 10
            end
        end

        local v520, v521, v522 = pairs(game.Workspace.Enemies:GetChildren())

        if v523.Name == 'Core' and v523.Humanoid.Health > 0 then
        end

        local v523

        v522, v523 = v520(v521, v522)

        if v522 ~= nil then
        end

        wait(_G.Fast_Delay)
        AttackNoCD()

        repeat
            Tween(CFrame.new(448.46756, 199.356781, -441.389252))
            wait()
        until not _G.Factory or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(448.46756, 199.356781, -441.389252)).Magnitude <= 10

        EquipTool(SelectWeapon)
        AutoHaki()
        Tween(v523.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

        v523.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        v523.HumanoidRootPart.Transparency = 1
        v523.Humanoid.JumpPower = 0
        v523.Humanoid.WalkSpeed = 0
        v523.HumanoidRootPart.CanCollide = false
        FarmPos = v523.HumanoidRootPart.CFrame
        MonFarm = v523.Name

        if v523.Parent and (v523.Humanoid.Health > 0 and _G.Factory ~= false) then
        end
    end)
end
if Third_Sea then
    v3.Main:AddToggle('ToggleCakeV2', {
        Title = 'Kill Dought King [Need Spawn]',
        Default = false,
    }):OnChanged(function(p524)
        _G.AutoCakeV2 = p524
    end)
    _Options.ToggleCakeV2:SetValue(false)
end

spawn(function()
    while wait() do
        if _G.AutoCakeV2 then
            pcall(function()
                if game:GetService('Workspace').Enemies:FindFirstChild('Dough King') then
                    local v525, v526, v527 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                    while true do
                        local v528

                        v527, v528 = v525(v526, v527)

                        if v527 == nil then
                            break
                        end
                        if v528.Name == 'Dough King' and (v528:FindFirstChild('Humanoid') and (v528:FindFirstChild('HumanoidRootPart') and v528.Humanoid.Health > 0)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()
                                AutoHaki()
                                EquipTool(SelectWeapon)

                                v528.HumanoidRootPart.CanCollide = false
                                v528.Humanoid.WalkSpeed = 0
                                v528.HumanoidRootPart.Size = Vector3.new(50, 50, 50)

                                Tween(v528.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                            until not _G.AutoCakeV2 or (not v528.Parent or v528.Humanoid.Health <= 0)
                        end
                    end
                elseif game:GetService('ReplicatedStorage'):FindFirstChild('Dough King') then
                    Tween(game:GetService('ReplicatedStorage'):FindFirstChild('Dough King').HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                end
            end)
        end
    end
end)

if Second_Sea or Third_Sea then
    v3.Main:AddToggle('ToggleHakiColor', {
        Title = 'Buy Haki Color',
        Default = false,
    }):OnChanged(function(p529)
        _G.Auto_Buy_Enchancement = p529
    end)
    _Options.ToggleHakiColor:SetValue(false)
    spawn(function()
        while wait() do
            if _G.Auto_Buy_Enchancement then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'ColorsDealer',
                    '2',
                }))
            end
        end
    end)
end
if Second_Sea then
    v3.Main:AddToggle('ToggleSwordLengend', {
        Title = 'Buy Sword Lengendary',
        Default = false,
    }):OnChanged(function(p530)
        _G.BuyLengendSword = p530
    end)
    _Options.ToggleSwordLengend:SetValue(false)
    spawn(function()
        while wait(0.1) do
            pcall(function()
                if _G.BuyLengendSword or Triple_A then
                    game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                        'LegendarySwordDealer',
                        '2',
                    }))
                else
                    wait(2)
                end
            end)
        end
    end)
end

v3.Setting:AddSection('Setting Farming')
v3.Setting:AddToggle('ToggleFastAttack', {
    Title = ' Enable Fast Attack',
    Default = true,
}):OnChanged(function(p531)
    _G.FastAttackFaiFao = p531
end)
_Options.ToggleFastAttack:SetValue(true)
spawn(function()
    while wait(0.4) do
        pcall(function()
            if _G.FastAttackFaiFao then
                repeat
                    wait(_G.Fast_Delay)
                    AttackNoCD()
                until not _G.FastAttackFaiFao
            end
        end)
    end
end)
require(game.ReplicatedStorage.Util.CameraShaker):Stop()
v3.Setting:AddToggle('ToggleBringMob', {
    Title = ' Enable Bring Mob / Magnet',
    Default = true,
}):OnChanged(function(p532)
    _G.BringMob = p532
end)
_Options.ToggleBringMob:SetValue(true)
spawn(function()
    while wait() do
        pcall(function()
            local v533, v534, v535 = pairs(game:GetService('Workspace').Enemies:GetChildren())

            while true do
                local v536

                v535, v536 = v533(v534, v535)

                if v535 == nil then
                    break
                end
                if _G.BringMob and (bringmob and (v536.Name == MonFarm and (v536:FindFirstChild('Humanoid') and v536.Humanoid.Health > 0))) then
                    if v536.Name ~= 'Factory Staff' then
                        if v536.Name == MonFarm and (v536.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 450 then
                            v536.Head.CanCollide = false
                            v536.HumanoidRootPart.CanCollide = false
                            v536.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                            v536.HumanoidRootPart.CFrame = FarmPos

                            if v536.Humanoid:FindFirstChild('Animator') then
                                v536.Humanoid.Animator:Destroy()
                            end

                            sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                        end
                    elseif (v536.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 500 then
                        v536.Head.CanCollide = false
                        v536.HumanoidRootPart.CanCollide = false
                        v536.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
                        v536.HumanoidRootPart.CFrame = FarmPos

                        if v536.Humanoid:FindFirstChild('Animator') then
                            v536.Humanoid.Animator:Destroy()
                        end

                        sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                    end
                end
            end
        end)
    end
end)
v3.Setting:AddToggle('ToggleBypassTP', {
    Title = 'Enable Bypass Tp',
    Default = false,
}):OnChanged(function(p537)
    BypassTP = p537
end)
_Options.ToggleBypassTP:SetValue(false)
v3.Setting:AddToggle('ToggleRemove', {
    Title = ' Enable Remove Dame Text',
    Default = true,
}):OnChanged(function(p538)
    _G.RemoveDameText = p538
end)
_Options.ToggleRemove:SetValue(true)
spawn(function()
    while wait() do
        if _G.RemoveDameText then
            game:GetService('ReplicatedStorage').Assets.GUI.DamageCounter.Enabled = false
        else
            game:GetService('ReplicatedStorage').Assets.GUI.DamageCounter.Enabled = true
        end
    end
end)
v3.Setting:AddToggle('ToggleRemoveNotify', {
    Title = ' Enable Remove All Notify',
    Default = false,
}):OnChanged(function(p539)
    RemoveNotify = p539
end)
_Options.ToggleRemoveNotify:SetValue(false)
spawn(function()
    while wait() do
        if RemoveNotify then
            game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = false
        else
            game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = true
        end
    end
end)
v3.Setting:AddToggle('ToggleWhite', {
    Title = ' Enable White Screen',
    Default = false,
}):OnChanged(function(p540)
    _G.WhiteScreen = p540

    if _G.WhiteScreen ~= true then
        if _G.WhiteScreen == false then
            game:GetService('RunService'):Set3dRenderingEnabled(true)
        end
    else
        game:GetService('RunService'):Set3dRenderingEnabled(false)
    end
end)
_Options.ToggleWhite:SetValue(false)
v3.Setting:AddSection('Skill Mastery')
v3.Setting:AddToggle('ToggleZ', {
    Title = 'Skill Z',
    Default = true,
}):OnChanged(function(p541)
    SkillZ = p541
end)
_Options.ToggleZ:SetValue(true)
v3.Setting:AddToggle('ToggleX', {
    Title = 'Skill X',
    Default = true,
}):OnChanged(function(p542)
    SkillX = p542
end)
_Options.ToggleX:SetValue(true)
v3.Setting:AddToggle('ToggleC', {
    Title = 'Skill C',
    Default = true,
}):OnChanged(function(p543)
    SkillC = p543
end)
_Options.ToggleC:SetValue(true)
v3.Setting:AddToggle('ToggleV', {
    Title = 'Skill V',
    Default = true,
}):OnChanged(function(p544)
    SkillV = p544
end)
_Options.ToggleV:SetValue(true)
v3.Setting:AddToggle('ToggleF', {
    Title = 'Skill F',
    Default = false,
}):OnChanged(function(p545)
    SkillF = p545
end)
_Options.ToggleF:SetValue(false)

local _DistanceFarm = v3.Setting:AddSection('Distance Farm')
local _SliderPosX = v3.Setting:AddSlider('SliderPosX', {
    Title = 'Pos X',
    Description = '',
    Default = 10,
    Min = -60,
    Max = 60,
    Rounding = 1,
    Callback = function(p547)
        posX = p547
    end,
})

_SliderPosX:OnChanged(function(p549)
    posX = p549
end)
_SliderPosX:SetValue(10)

local _SliderPosY = v3.Setting:AddSlider('SliderPosY', {
    Title = 'Pos Y',
    Description = '',
    Default = 30,
    Min = -60,
    Max = 60,
    Rounding = 1,
    Callback = function(p550)
        posY = p550
    end,
})

_SliderPosY:OnChanged(function(p552)
    posY = p552
end)
_SliderPosY:SetValue(30)

local _SliderPosZ = v3.Setting:AddSlider('SliderPosZ', {
    Title = 'Pos Z',
    Description = '',
    Default = 10,
    Min = -60,
    Max = 60,
    Rounding = 1,
    Callback = function(p553)
        posZ = p553
    end,
})

_SliderPosZ:OnChanged(function(p555)
    posZ = p555
end)
_SliderPosZ:SetValue(10)

-- // Hub UI Settings
v3.Setting:AddSection('Hub Settings')

local _AccentColors = {
    Purple = {Color3.fromRGB(110,60,220), Color3.fromRGB(150,90,255), Color3.fromRGB(80,40,180)},
    Blue   = {Color3.fromRGB(50,100,230), Color3.fromRGB(80,140,255), Color3.fromRGB(30,70,200)},
    Cyan   = {Color3.fromRGB(30,180,200), Color3.fromRGB(60,220,240), Color3.fromRGB(20,140,160)},
    Green  = {Color3.fromRGB(40,180,100), Color3.fromRGB(70,220,130), Color3.fromRGB(20,140,70)},
    Red    = {Color3.fromRGB(200,50,60),  Color3.fromRGB(240,80,90),  Color3.fromRGB(160,30,40)},
    Orange = {Color3.fromRGB(220,130,30), Color3.fromRGB(255,170,60), Color3.fromRGB(180,100,20)},
    Pink   = {Color3.fromRGB(210,60,160), Color3.fromRGB(255,100,200),Color3.fromRGB(170,40,130)},
}

local _DropdownAccent = v3.Setting:AddDropdown('DropdownAccentColor', {
    Title = 'Accent Color',
    Values = {'Purple','Blue','Cyan','Green','Red','Orange','Pink'},
    Multi = false,
    Default = 1,
})
_DropdownAccent:OnChanged(function(val)
    local cols = _AccentColors[val]
    if not cols then return end
    THEME.Accent      = cols[1]
    THEME.AccentLight = cols[2]
    THEME.AccentDark  = cols[3]
    THEME.Toggle_ON   = cols[1]
    THEME.Slider      = cols[1]
    u1:Notify({ Title = 'Elite Hub', Content = 'Accent: ' .. val, Duration = 3 })
end)

local _SliderOpacity = v3.Setting:AddSlider('SliderUIOpacity', {
    Title = 'UI Opacity',
    Default = 100,
    Min = 40,
    Max = 100,
    Rounding = 1,
    Callback = function(val)
        pcall(function()
            for _, g in ipairs(pcall(function() return game:GetService("CoreGui"):GetChildren() end) and game:GetService("CoreGui"):GetChildren() or {}) do
                if g.Name == 'EliteHub' then
                    for _, obj in ipairs(g:GetDescendants()) do
                        if obj:IsA('Frame') and obj.BackgroundTransparency < 1 then
                            obj.BackgroundTransparency = 1 - (val / 100)
                        end
                    end
                end
            end
        end)
    end,
})
_SliderOpacity:SetValue(100)

local _SliderScale = v3.Setting:AddSlider('SliderUIScale', {
    Title = 'UI Scale',
    Default = 100,
    Min = 70,
    Max = 130,
    Rounding = 5,
    Callback = function(val)
        pcall(function()
            for _, g in ipairs(pcall(function() return game:GetService("CoreGui"):GetChildren() end) and game:GetService("CoreGui"):GetChildren() or {}) do
                if g.Name == 'EliteHub' then
                    local s = g:FindFirstChildOfClass('UIScale') or Instance.new('UIScale', g)
                    s.Scale = val / 100
                end
            end
        end)
    end,
})
_SliderScale:SetValue(100)

v3.Setting:AddButton({
    Title = 'Minimize Key: [END]',
    Description = 'Press END to toggle the hub',
    Callback = function()
        u1:Notify({ Title = 'Elite Hub', Content = 'Press END to minimize/show the hub', Duration = 3 })
    end,
})

v3.Setting:AddButton({
    Title = 'Close Hub',
    Description = 'Destroys the UI entirely',
    Callback = function()
        for _, g in ipairs(pcall(function() return game:GetService("CoreGui"):GetChildren() end) and game:GetService("CoreGui"):GetChildren() or {}) do
            if g.Name == 'EliteHub' or g.Name == 'EliteNotify' or g.Name == 'EliteLoading' then
                g:Destroy()
            end
        end
    end,
})

v3.Stats:AddToggle('ToggleMelee', {
    Title = 'Auto Melee',
    Default = false,
}):OnChanged(function(p556)
    _G.Auto_Stats_Melee = p556
end)
_Options.ToggleMelee:SetValue(false)
v3.Stats:AddToggle('ToggleDe', {
    Title = 'Auto Defense',
    Default = false,
}):OnChanged(function(p557)
    _G.Auto_Stats_Defense = p557
end)
_Options.ToggleDe:SetValue(false)
v3.Stats:AddToggle('ToggleSword', {
    Title = 'Auto Sword',
    Default = false,
}):OnChanged(function(p558)
    _G.Auto_Stats_Sword = p558
end)
_Options.ToggleSword:SetValue(false)
v3.Stats:AddToggle('ToggleGun', {
    Title = 'Auto Gun',
    Default = false,
}):OnChanged(function(p559)
    _G.Auto_Stats_Gun = p559
end)
_Options.ToggleGun:SetValue(false)
v3.Stats:AddToggle('ToggleFruit', {
    Title = 'Auto Demon Fruit',
    Default = false,
}):OnChanged(function(p560)
    _G.Auto_Stats_Devil_Fruit = p560
end)
_Options.ToggleFruit:SetValue(false)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Devil_Fruit then
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                'AddPoint',
                'Demon Fruit',
                3,
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Gun then
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                'AddPoint',
                'Gun',
                3,
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Sword then
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                'AddPoint',
                'Sword',
                3,
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Defense then
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                'AddPoint',
                'Defense',
                3,
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Melee then
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                'AddPoint',
                'Melee',
                3,
            }))
        end
    end
end)

local v561, v562, v563 = pairs(game:GetService('Players'):GetChildren())
local v564 = {}

while true do
    local v565

    v563, v565 = v561(v562, v563)

    if v563 == nil then
        break
    end

    table.insert(v564, v565.Name)
end

local _SelectedPly = v3.Player:AddDropdown('SelectedPly', {
    Title = 'Dropdown',
    Values = v564,
    Multi = false,
    Default = 1,
})

_SelectedPly:SetValue('nil')
_SelectedPly:OnChanged(function(p567)
    _G.SelectPly = p567
end)
v3.Player:AddToggle('ToggleTeleport', {
    Title = 'Teleport To Player',
    Default = false,
}):OnChanged(function(p568)
    _G.TeleportPly = p568

    pcall(function()
        if _G.TeleportPly then
            repeat
                toTarget(game:GetService('Players')[_G.SelectPly].Character.HumanoidRootPart.CFrame)
                wait()
            until _G.TeleportPly == false
        end
    end)
end)
_Options.ToggleTeleport:SetValue(false)
v3.Player:AddToggle('ToggleQuanSat', {
    Title = 'Spectate Player',
    Default = false,
}):OnChanged(function(p569)
    SpectatePlys = p569

    local _ = game:GetService('Players').LocalPlayer.Character.Humanoid

    game:GetService('Players'):FindFirstChild(_G.SelectPly)

    repeat
        wait(0.1)

        game:GetService('Workspace').Camera.CameraSubject = game:GetService('Players'):FindFirstChild(_G.SelectPly).Character.Humanoid
    until SpectatePlys == false

    game:GetService('Workspace').Camera.CameraSubject = game:GetService('Players').LocalPlayer.Character.Humanoid
end)
_Options.ToggleQuanSat:SetValue(false)
v3.Player:AddSection('Combat')
v3.Player:AddToggle('ToggleAimBotSkill', {
    Title = 'Aimbot Skill ( Bug Wait Fix )',
    Default = false,
}):OnChanged(function(p570)
    Skillaimbot = p570
end)
_Options.ToggleAimBotSkill:SetValue(false)
v3.Player:AddToggle('ToggleAimbotGun', {
    Title = 'Aimbot Gun ( Bug Wait Fix )',
    Default = false,
}):OnChanged(function(p571)
    Aimbot = p571
end)
_Options.ToggleAimbotGun:SetValue(false)

local v572 = getrawmetatable(game)
local ___namecall2 = v572.__namecall

setreadonly(v572, false)

v572.__namecall = newcclosure(function(...)
    local v574 = getnamecallmethod()
    local v575 = {...}

    if tostring(v574) ~= 'FireServer' or (tostring(v575[1]) ~= 'RemoteEvent' or (tostring(v575[2]) == 'true' or (tostring(v575[2]) == 'false' or not Skillaimbot))) then
        return ___namecall2(...)
    end

    v575[2] = AimBotSkillPosition

    return ___namecall2(unpack(v575))
end)

spawn(function()
    while wait() do
        local v576, v577, v578 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

        while true do
            local v579

            v578, v579 = v576(v577, v578)

            if v578 == nil then
                break
            end
            if v579:IsA('Tool') and v579:FindFirstChild('RemoteFunctionShoot') then
                SelectToolWeaponGun = v579.Name
            end
        end

        local v580, v581, v582 = pairs(game.Players.LocalPlayer.Character:GetChildren())

        while true do
            local v583

            v582, v583 = v580(v581, v582)

            if v582 == nil then
                break
            end
            if v583:IsA('Tool') and v583:FindFirstChild('RemoteFunctionShoot') then
                SelectToolWeaponGun = v583.Name
            end
        end
    end
end)
task.spawn(function()
    while wait() do
        if Skillaimbot and (game.Players:FindFirstChild(SelectPlayer) and (game.Players:FindFirstChild(SelectPlayer).Character:FindFirstChild('HumanoidRootPart') and (game.Players:FindFirstChild(SelectPlayer).Character:FindFirstChild('Humanoid') and game.Players:FindFirstChild(SelectPlayer).Character.Humanoid.Health > 0))) then
            AimBotSkillPosition = game.Players:FindFirstChild(SelectPlayer).Character:FindFirstChild('HumanoidRootPart').Position
        end
    end
end)
game:GetService('Players').LocalPlayer:GetMouse().Button1Down:Connect(function()
    if Aimbot and (game.Players.LocalPlayer.Character:FindFirstChild(SelectToolWeaponGun) and game:GetService('Players'):FindFirstChild(SelectPlayer)) then
        tool = game:GetService('Players').LocalPlayer.Character[SelectToolWeaponGun]
        v17 = workspace:FindPartOnRayWithIgnoreList(Ray.new(tool.Handle.CFrame.p, (game:GetService('Players'):FindFirstChild(SelectPlayer).Character.HumanoidRootPart.Position - tool.Handle.CFrame.p).unit * 100), {
            game.Players.LocalPlayer.Character,
            workspace._WorldOrigin,
        })

        game:GetService('Players').LocalPlayer.Character[SelectToolWeaponGun].RemoteFunctionShoot:InvokeServer(game:GetService('Players'):FindFirstChild(SelectPlayer).Character.HumanoidRootPart.Position, (require(game.ReplicatedStorage.Util).Other.hrpFromPart(v17)))
    end
end)

local _TeleportWorld = v3.Teleport:AddSection('Teleport World')

v3.Teleport:AddButton({
    Title = 'First Sea',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('TravelMain')
    end,
})
v3.Teleport:AddButton({
    Title = 'Second Sea',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('TravelDressrosa')
    end,
})
v3.Teleport:AddButton({
    Title = 'Third Sea',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('TravelZou')
    end,
})
v3.Teleport:AddSection('Teleport Island')

if First_Sea then
    IslandList = {
        'WindMill',
        'Marine',
        'Middle Town',
        'Jungle',
        'Pirate Village',
        'Desert',
        'Snow Island',
        'MarineFord',
        'Colosseum',
        'Sky Island 1',
        'Sky Island 2',
        'Sky Island 3',
        'Prison',
        'Magma Village',
        'Under Water Island',
        'Fountain City',
        'Shank Room',
        'Mob Island',
    }
elseif Second_Sea then
    IslandList = {
        'The Cafe',
        'Frist Spot',
        'Dark Area',
        'Flamingo Mansion',
        'Flamingo Room',
        'Green Zone',
        'Factory',
        'Colossuim',
        'Zombie Island',
        'Two Snow Mountain',
        'Punk Hazard',
        'Cursed Ship',
        'Ice Castle',
        'Forgotten Island',
        'Ussop Island',
        'Mini Sky Island',
    }
elseif Third_Sea then
    IslandList = {
        'Mansion',
        'Port Town',
        'Great Tree',
        'Castle On The Sea',
        'MiniSky',
        'Hydra Island',
        'Floating Turtle',
        'Haunted Castle',
        'Ice Cream Island',
        'Peanut Island',
        'Cake Island',
        'Cocoa Island',
        'Candy Island',
        'Isle Outpost',
    }
end

local _DropdownIsland = v3.Teleport:AddDropdown('DropdownIsland', {
    Title = 'Dropdown',
    Values = IslandList,
    Multi = false,
    Default = 1,
})

_DropdownIsland:SetValue('...')
_DropdownIsland:OnChanged(function(p586)
    _G.SelectIsland = p586
end)
v3.Teleport:AddToggle('ToggleIsland', {
    Title = 'Teleport',
    Default = false,
}):OnChanged(function(p587)
    _G.TeleportIsland = p587

    if _G.TeleportIsland ~= true then
        return
    else
        while true do
            if true then
                wait()

                if _G.SelectIsland ~= 'WindMill' then
                    if _G.SelectIsland ~= 'Marine' then
                        if _G.SelectIsland ~= 'Middle Town' then
                            if _G.SelectIsland ~= 'Jungle' then
                                if _G.SelectIsland ~= 'Pirate Village' then
                                    if _G.SelectIsland ~= 'Desert' then
                                        if _G.SelectIsland ~= 'Snow Island' then
                                            if _G.SelectIsland ~= 'MarineFord' then
                                                if _G.SelectIsland ~= 'Colosseum' then
                                                    if _G.SelectIsland ~= 'Sky Island 1' then
                                                        if _G.SelectIsland ~= 'Sky Island 2' then
                                                            if _G.SelectIsland ~= 'Sky Island 3' then
                                                                if _G.SelectIsland ~= 'Prison' then
                                                                    if _G.SelectIsland ~= 'Magma Village' then
                                                                        if _G.SelectIsland ~= 'Under Water Island' then
                                                                            if _G.SelectIsland ~= 'Fountain City' then
                                                                                if _G.SelectIsland ~= 'Shank Room' then
                                                                                    if _G.SelectIsland ~= 'Mob Island' then
                                                                                        if _G.SelectIsland ~= 'The Cafe' then
                                                                                            if _G.SelectIsland ~= 'Frist Spot' then
                                                                                                if _G.SelectIsland ~= 'Dark Area' then
                                                                                                    if _G.SelectIsland ~= 'Flamingo Mansion' then
                                                                                                        if _G.SelectIsland ~= 'Flamingo Room' then
                                                                                                            if _G.SelectIsland ~= 'Green Zone' then
                                                                                                                if _G.SelectIsland ~= 'Factory' then
                                                                                                                    if _G.SelectIsland ~= 'Colossuim' then
                                                                                                                        if _G.SelectIsland ~= 'Zombie Island' then
                                                                                                                            if _G.SelectIsland ~= 'Two Snow Mountain' then
                                                                                                                                if _G.SelectIsland ~= 'Punk Hazard' then
                                                                                                                                    if _G.SelectIsland ~= 'Cursed Ship' then
                                                                                                                                        if _G.SelectIsland ~= 'Ice Castle' then
                                                                                                                                            if _G.SelectIsland ~= 'Forgotten Island' then
                                                                                                                                                if _G.SelectIsland ~= 'Ussop Island' then
                                                                                                                                                    if _G.SelectIsland ~= 'Mini Sky Island' then
                                                                                                                                                        if _G.SelectIsland ~= 'Great Tree' then
                                                                                                                                                            if _G.SelectIsland ~= 'Castle On The Sea' then
                                                                                                                                                                if _G.SelectIsland ~= 'MiniSky' then
                                                                                                                                                                    if _G.SelectIsland ~= 'Port Town' then
                                                                                                                                                                        if _G.SelectIsland ~= 'Hydra Island' then
                                                                                                                                                                            if _G.SelectIsland ~= 'Floating Turtle' then
                                                                                                                                                                                if _G.SelectIsland ~= 'Mansion' then
                                                                                                                                                                                    if _G.SelectIsland ~= 'Haunted Castle' then
                                                                                                                                                                                        if _G.SelectIsland ~= 'Ice Cream Island' then
                                                                                                                                                                                            if _G.SelectIsland ~= 'Peanut Island' then
                                                                                                                                                                                                if _G.SelectIsland ~= 'Cake Island' then
                                                                                                                                                                                                    if _G.SelectIsland ~= 'Cocoa Island' then
                                                                                                                                                                                                        if _G.SelectIsland ~= 'Candy Island' then
                                                                                                                                                                                                            if _G.SelectIsland == 'Isle Outpost' then
                                                                                                                                                                                                                toTarget(CFrame.new(-16542.447265625, 55.68632888793945, 1044.41650390625))
                                                                                                                                                                                                            end
                                                                                                                                                                                                        else
                                                                                                                                                                                                            toTarget(CFrame.new(-1014.4241943359375, 149.11068725585938, -14555.962890625))
                                                                                                                                                                                                        end
                                                                                                                                                                                                    else
                                                                                                                                                                                                        toTarget(CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375))
                                                                                                                                                                                                    end
                                                                                                                                                                                                else
                                                                                                                                                                                                    toTarget(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375))
                                                                                                                                                                                                end
                                                                                                                                                                                            else
                                                                                                                                                                                                toTarget(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375))
                                                                                                                                                                                            end
                                                                                                                                                                                        else
                                                                                                                                                                                            toTarget(CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625))
                                                                                                                                                                                        end
                                                                                                                                                                                    else
                                                                                                                                                                                        toTarget(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562))
                                                                                                                                                                                    end
                                                                                                                                                                                else
                                                                                                                                                                                    BTPZ(CFrame.new(-12468.5380859375, 375.0094299316406, -7554.62548828125))
                                                                                                                                                                                end
                                                                                                                                                                            else
                                                                                                                                                                                toTarget(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625))
                                                                                                                                                                            end
                                                                                                                                                                        else
                                                                                                                                                                            BTPZ(CFrame.new(5753.5478515625, 610.7880859375, -282.33172607421875))
                                                                                                                                                                        end
                                                                                                                                                                    else
                                                                                                                                                                        toTarget(CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375))
                                                                                                                                                                    end
                                                                                                                                                                else
                                                                                                                                                                    toTarget(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125))
                                                                                                                                                                end
                                                                                                                                                            else
                                                                                                                                                                BTPZ(CFrame.new(-5075.50927734375, 314.5155029296875, -3150.0224609375))
                                                                                                                                                            end
                                                                                                                                                        else
                                                                                                                                                            toTarget(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625))
                                                                                                                                                        end
                                                                                                                                                    else
                                                                                                                                                        toTarget(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375))
                                                                                                                                                    end
                                                                                                                                                else
                                                                                                                                                    toTarget(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
                                                                                                                                                end
                                                                                                                                            else
                                                                                                                                                toTarget(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875))
                                                                                                                                            end
                                                                                                                                        else
                                                                                                                                            toTarget(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188))
                                                                                                                                        end
                                                                                                                                    else
                                                                                                                                        toTarget(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
                                                                                                                                    end
                                                                                                                                else
                                                                                                                                    toTarget(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125))
                                                                                                                                end
                                                                                                                            else
                                                                                                                                toTarget(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938))
                                                                                                                            end
                                                                                                                        else
                                                                                                                            toTarget(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094))
                                                                                                                        end
                                                                                                                    else
                                                                                                                        toTarget(CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
                                                                                                                    end
                                                                                                                else
                                                                                                                    toTarget(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617))
                                                                                                                end
                                                                                                            else
                                                                                                                toTarget(CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344))
                                                                                                            end
                                                                                                        else
                                                                                                            toTarget(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688))
                                                                                                        end
                                                                                                    else
                                                                                                        BTPZ(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234))
                                                                                                    end
                                                                                                else
                                                                                                    toTarget(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375))
                                                                                                end
                                                                                            else
                                                                                                toTarget(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
                                                                                            end
                                                                                        else
                                                                                            toTarget(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
                                                                                        end
                                                                                    else
                                                                                        toTarget(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
                                                                                    end
                                                                                else
                                                                                    toTarget(CFrame.new(-1442.16553, 29.8788261, -28.3547478))
                                                                                end
                                                                            else
                                                                                toTarget(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
                                                                            end
                                                                        else
                                                                            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                                                                        end
                                                                    else
                                                                        toTarget(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
                                                                    end
                                                                else
                                                                    toTarget(CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
                                                                end
                                                            else
                                                                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
                                                            end
                                                        else
                                                            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('requestEntrance', Vector3.new(-4607.82275, 872.54248, -1667.55688))
                                                        end
                                                    else
                                                        toTarget(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063))
                                                    end
                                                else
                                                    toTarget(CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969))
                                                end
                                            else
                                                toTarget(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
                                            end
                                        else
                                            toTarget(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469))
                                        end
                                    else
                                        toTarget(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
                                    end
                                else
                                    toTarget(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
                                end
                            else
                                toTarget(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
                            end
                        else
                            toTarget(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                        end
                    else
                        toTarget(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
                    end
                else
                    toTarget(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
                end
            end
            if not _G.TeleportIsland then
            end
        end
    end
end)
_Options.ToggleIsland:SetValue(false)

local _GetFruits = game.ReplicatedStorage:FindFirstChild('Remotes').CommF_:InvokeServer('GetFruits')

Table_DevilFruitSniper = {}
ShopDevilSell = {}

local v589 = next
local v590 = nil

while true do
    local v591

    v590, v591 = v589(_GetFruits, v590)

    if v590 == nil then
        break
    end

    table.insert(Table_DevilFruitSniper, v591.Name)

    if v591.OnSale then
        table.insert(ShopDevilSell, v591.Name)
    end
end

_G.SelectFruit = 'Leopard'

local _DropdownFruit = v3.Fruit:AddDropdown('DropdownFruit', {
    Title = 'Dropdown',
    Values = Table_DevilFruitSniper,
    Multi = false,
    Default = 1,
})

_DropdownFruit:SetValue('...')
_DropdownFruit:OnChanged(function(p593)
    _G.SelectFruit = p593
end)
v3.Fruit:AddToggle('ToggleFruit', {
    Title = 'Buy Fruit Sniper',
    Default = false,
}):OnChanged(function(p594)
    _G.AutoBuyFruitSniper = p594
end)
_Options.ToggleFruit:SetValue(false)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.AutoBuyFruitSniper then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('GetFruits')
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('PurchaseRawFruit', '_G.SelectFruit', false)
            end
        end
    end)
end)
v3.Fruit:AddToggle('ToggleStore', {
    Title = 'Store Fruit',
    Default = false,
}):OnChanged(function(p595)
    _G.AutoStoreFruit = p595
end)
_Options.ToggleStore:SetValue(false)
spawn(function()
    while task.wait() do
        if _G.AutoStoreFruit then
            pcall(function()
                if _G.AutoStoreFruit then
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Bomb Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Bomb Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Bomb-Bomb', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Bomb Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Spike Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spike Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Spike-Spike', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spike Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Chop Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Chop Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Chop-Chop', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Chop Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Spring Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spring Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Spring-Spring', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spring Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Rocket Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Kilo Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Rocket-Rocket', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Kilo Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Smoke Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Smoke Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Smoke-Smoke', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Smoke Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Spin Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spin Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Spin-Spin', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spin Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Flame Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Flame Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Flame-Flame', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Flame Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Bird: Falcon Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Bird: Falcon Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Bird-Bird: Falcon', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Bird: Falcon Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Ice Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Ice Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Ice-Ice', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Ice Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Sand Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Sand Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Sand-Sand', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Sand Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Dark Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Dark Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Dark-Dark', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Dark Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Ghost Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Revive Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Ghost-Ghost', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Revive Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Diamond Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Diamond Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Diamond-Diamond', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Diamond Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Light Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Light Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Light-Light', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Light Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Love Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Love Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Love-Love', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Love Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Rubber Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Rubber Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Rubber-Rubber', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Rubber Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Barrier Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Barrier Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Barrier-Barrier', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Barrier Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Magma Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Magma Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Magma-Magma', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Magma Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Portal Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Door Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Door-Door', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Portal Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Quake Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Quake Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Quake-Quake', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Quake Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Human-Human: Buddha Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Human-Human: Buddha Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Human-Human: Buddha', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Human-Human: Buddha Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Spider Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spider Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Spider-Spider', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spider Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Bird: Phoenix Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Bird: Phoenix Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Bird-Bird: Phoenix', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Bird: Phoenix Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Rumble Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Rumble Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Rumble-Rumble', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Rumble Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Pain Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Paw Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Pain-Pain', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Paw Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Gravity Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Gravity Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Gravity-Gravity', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Gravity Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Dough Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Dough Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Dough-Dough', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Dough Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Shadow Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Shadow Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Shadow-Shadow', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Shadow Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Venom Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Venom Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Venom-Venom', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Venom Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Control Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Control Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Control-Control', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Control Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Spirit Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Soul Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Soul-Soul', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Spirit Fruit'))
                    end
                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Dragon Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Dragon Fruit') then
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Dragon-Dragon', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Dragon Fruit'))

                        if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Leopard Fruit') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Leopard Fruit') then
                            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('StoreFruit', 'Leopard-Leopard', game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Leopard Fruit'))
                        end
                    end
                end
            end)
        end

        wait(0.3)
    end
end)
v3.Fruit:AddToggle('ToggleRandomFruit', {
    Title = 'Random Fruit',
    Default = false,
}):OnChanged(function(p596)
    _G.Random_Auto = p596
end)
_Options.ToggleRandomFruit:SetValue(false)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Random_Auto then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('Cousin', 'Buy')
            end
        end
    end)
end)
v3.Fruit:AddToggle('ToggleCollect', {
    Title = 'Collect Devil Fruit',
    Default = false,
}):OnChanged(function(p597)
    _G.Tweenfruit = p597
end)
_Options.ToggleCollect:SetValue(false)
spawn(function()
    while wait(0.1) do
        if _G.Tweenfruit then
            local v598, v599, v600 = pairs(game.Workspace:GetChildren())

            while true do
                local v601

                v600, v601 = v598(v599, v600)

                if v600 == nil then
                    break
                end
                if string.find(v601.Name, 'Fruit') then
                    Tween(v601.Handle.CFrame)
                end
            end
        end
    end
end)
v3.Fruit:AddSection('Esp')
v3.Fruit:AddToggle('ToggleEspPlayer', {
    Title = 'Esp Player',
    Default = false,
}):OnChanged(function(p602)
    ESPPlayer = p602

    UpdatePlayerChams()
end)
_Options.ToggleEspPlayer:SetValue(false)
v3.Fruit:AddToggle('ToggleEspFruit', {
    Title = 'Esp Devil Fruit',
    Default = false,
}):OnChanged(function(p603)
    DevilFruitESP = p603

    while DevilFruitESP do
        wait()
        UpdateDevilChams()
    end
end)
_Options.ToggleEspFruit:SetValue(false)
v3.Fruit:AddToggle('ToggleEspIsland', {
    Title = 'Esp Island',
    Default = false,
}):OnChanged(function(p604)
    IslandESP = p604

    while IslandESP do
        wait()
        UpdateIslandESP()
    end
end)
_Options.ToggleEspIsland:SetValue(false)
v3.Fruit:AddToggle('ToggleEspFlower', {
    Title = 'Esp Flower',
    Default = false,
}):OnChanged(function(p605)
    FlowerESP = p605

    UpdateFlowerChams()
end)
_Options.ToggleEspFlower:SetValue(false)
spawn(function()
    while wait(2) do
        if FlowerESP then
            UpdateFlowerChams()
        end
        if DevilFruitESP then
            UpdateDevilChams()
        end
        if ChestESP then
            UpdateChestChams()
        end
        if ESPPlayer then
            UpdatePlayerChams()
        end
        if RealFruitESP then
            UpdateRealFruitChams()
        end
    end
end)

local _DropdownRaid = v3.Raid:AddDropdown('DropdownRaid', {
    Title = 'Dropdown',
    Values = {
        'Flame',
        'Ice',
        'Quake',
        'Light',
        'Dark',
        'Spider',
        'Rumble',
        'Magma',
        'Buddha',
        'Sand',
        'Phoenix',
        'Dough',
    },
    Multi = false,
    Default = 1,
})

_DropdownRaid:SetValue('...')
_DropdownRaid:OnChanged(function(p607)
    SelectChip = p607
end)
v3.Raid:AddToggle('ToggleBuy', {
    Title = 'Buy Chip',
    Default = false,
}):OnChanged(function(p608)
    _G.Auto_Buy_Chips_Dungeon = p608
end)
_Options.ToggleBuy:SetValue(false)
spawn(function()
    while wait() do
        if _G.Auto_Buy_Chips_Dungeon then
            pcall(function()
                local v609 = {
                    'RaidsNpc',
                    'Select',
                    SelectChip,
                }

                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack(v609))
            end)
        end
    end
end)
v3.Raid:AddToggle('ToggleStart', {
    Title = 'Start Raid',
    Default = false,
}):OnChanged(function(p610)
    _G.Auto_StartRaid = p610
end)
_Options.ToggleStart:SetValue(false)
spawn(function()
    while wait(0.1) do
        pcall(function()
            if _G.Auto_StartRaid and game:GetService('Players').LocalPlayer.PlayerGui.Main.Timer.Visible == false and (not game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1') and game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Special Microchip') or game:GetService('Players').LocalPlayer.Character:FindFirstChild('Special Microchip')) then
                if Second_Sea then
                    fireclickdetector(game:GetService('Workspace').Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                elseif Third_Sea then
                    fireclickdetector(game:GetService('Workspace').Map['Boat Castle'].RaidSummon2.Button.Main.ClickDetector)
                end
            end
        end)
    end
end)
v3.Raid:AddToggle('ToggleKillAura', {
    Title = 'Kill Aura',
    Default = false,
}):OnChanged(function(p611)
    KillAura = p611
end)
_Options.ToggleKillAura:SetValue(false)
spawn(function()
    while wait() do
        if KillAura then
            pcall(function()
                local v612, v613, v614 = pairs(game.Workspace.Enemies:GetDescendants())

                while true do
                    local v615

                    v614, v615 = v612(v613, v614)

                    if v614 == nil then
                        break
                    end
                    if v615:FindFirstChild('Humanoid') and (v615:FindFirstChild('HumanoidRootPart') and v615.Humanoid.Health > 0) then
                        repeat
                            task.wait()
                            sethiddenproperty(game:GetService('Players').LocalPlayer, 'SimulationRadius', math.huge)

                            v615.Humanoid.Health = 0
                            v615.HumanoidRootPart.CanCollide = false
                        until not KillAura or (not v615.Parent or v615.Humanoid.Health <= 0)
                    end
                end
            end)
        end
    end
end)
v3.Raid:AddToggle('ToggleNextIsland', {
    Title = 'Next Island',
    Default = false,
}):OnChanged(function(p616)
    AutoNextIsland = p616
end)
_Options.ToggleNextIsland:SetValue(false)
spawn(function()
    while task.wait() do
        if AutoNextIsland then
            pcall(function()
                if game:GetService('Players').LocalPlayer.PlayerGui.Main.Timer.Visible == true then
                    if game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 5') then
                        Tween(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 5').CFrame * CFrame.new(0, 70, 100))
                    elseif game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 4') then
                        Tween(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 4').CFrame * CFrame.new(0, 70, 100))
                    elseif game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 3') then
                        Tween(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 3').CFrame * CFrame.new(0, 70, 100))
                    elseif game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 2') then
                        Tween(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 2').CFrame * CFrame.new(0, 70, 100))
                    elseif game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1') then
                        Tween(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1').CFrame * CFrame.new(0, 70, 100))
                    end
                end
            end)
        end
    end
end)
v3.Raid:AddToggle('ToggleAwake', {
    Title = 'Auto Awake',
    Default = false,
}):OnChanged(function(p617)
    AutoAwakenAbilities = p617
end)
_Options.ToggleAwake:SetValue(false)
spawn(function()
    while task.wait() do
        if AutoAwakenAbilities then
            pcall(function()
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('Awakener', 'Awaken')
            end)
        end
    end
end)
v3.Raid:AddToggle('ToggleGetFruit', {
    Title = 'Get Fruit Low Bely',
    Default = false,
}):OnChanged(function(p618)
    _G.Autofruit = p618
end)
spawn(function()
    while wait(0.1) do
        pcall(function()
            if _G.Autofruit then
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Rocket-Rocket',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Spin-Spin',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Chop-Chop',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Spring-Spring',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Bomb-Bomb',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Smoke-Smoke',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Spike-Spike',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Flame-Flame',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Falcon-Falcon',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Ice-Ice',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Sand-Sand',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Dark-Dark',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Ghost-Ghost',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Diamond-Diamond',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Light-Light',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Rubber-Rubber',
                }))
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                    'LoadFruit',
                    'Barrier-Barrier',
                }))
            end
        end)
    end
end)

if Second_Sea then
    v3.Raid:AddButton({
        Title = 'Raid Lab',
        Description = '',
        Callback = function()
            Tween2(CFrame.new(-6438.73535, 250.645355, -4501.50684))
        end,
    })
elseif Third_Sea then
    v3.Raid:AddButton({
        Title = 'Raid Lab',
        Description = '',
        Callback = function()
            Tween2(CFrame.new(-5017.40869, 314.844055, -2823.0127, -0.925743818, 4.48217499e-8, -0.378151238, 4.55503146e-9, 1, 1.07377559e-7, 0.378151238, 9.7681621e-8, -0.925743818))
        end,
    })
end

v3.Raid:AddSection('Law Raid')
v3.Raid:AddToggle('ToggleLaw', {
    Title = 'Auto Law',
    Default = false,
}):OnChanged(function(p619)
    Auto_Law = p619
end)
_Options.ToggleLaw:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if Auto_Law and not (game:GetService('Players').LocalPlayer.Character:FindFirstChild('Microchip') or (game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Microchip') or (game:GetService('Workspace').Enemies:FindFirstChild('Order') or game:GetService('ReplicatedStorage'):FindFirstChild('Order')))) then
                wait(0.3)
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'Microchip', '1')
                game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'Microchip', '2')
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait(0.4) do
            if Auto_Law then
                if not game:GetService('Workspace').Enemies:FindFirstChild('Order') and (not game:GetService('ReplicatedStorage'):FindFirstChild('Order') and (game:GetService('Players').LocalPlayer.Character:FindFirstChild('Microchip') or game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Microchip'))) then
                    fireclickdetector(game:GetService('Workspace').Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
                end
                if game:GetService('ReplicatedStorage'):FindFirstChild('Order') or game:GetService('Workspace').Enemies:FindFirstChild('Order') then
                    if game:GetService('Workspace').Enemies:FindFirstChild('Order') then
                        local v620, v621, v622 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                        while true do
                            local v623

                            v622, v623 = v620(v621, v622)

                            if v622 == nil then
                                break
                            end
                            if v623.Name == 'Order' then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCD()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    Tween(v623.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))

                                    v623.HumanoidRootPart.CanCollide = false
                                    v623.HumanoidRootPart.Size = Vector3.new(120, 120, 120)
                                until not v623.Parent or (v623.Humanoid.Health <= 0 or Auto_Law == false)
                            end
                        end
                    elseif game:GetService('ReplicatedStorage'):FindFirstChild('Order') then
                        Tween(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875))
                    end
                end
            end
        end
    end)
end)
v3.Race:AddButton({
    Title = 'Timple Of Time',
    Description = '',
    Callback = function()
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
    end,
})
v3.Race:AddButton({
    Title = 'Lever Pull',
    Description = '',
    Callback = function()
        Tween2(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
    end,
})
v3.Race:AddButton({
    Title = 'Acient One',
    Description = '',
    Callback = function()
        Tween2(CFrame.new(28981.552734375, 14888.4267578125, -120.245849609375))
    end,
})
v3.Race:AddSection('Auto Race')
v3.Race:AddButton({
    Title = 'Race Door',
    Description = '',
    Callback = function()
        Game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        wait(0.1)

        Game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        wait(0.1)

        Game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        wait(0.1)

        Game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        wait(0.5)

        if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Human' then
            if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Skypiea' then
                if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Fishman' then
                    if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Cyborg' then
                        if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Ghoul' then
                            if game:GetService('Players').LocalPlayer.Data.Race.Value == 'Mink' then
                                Tween2(CFrame.new(29012.341796875, 14890.9755859375, -380.1492614746094))
                            end
                        else
                            Tween2(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
                        end
                    else
                        Tween2(CFrame.new(28502.681640625, 14895.9755859375, -423.7279357910156))
                    end
                else
                    Tween2(CFrame.new(28231.17578125, 14890.9755859375, -211.64173889160156))
                end
            else
                Tween2(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
            end
        else
            Tween2(CFrame.new(29221.822265625, 14890.9755859375, -205.99114990234375))
        end
    end,
})
v3.Race:AddToggle('ToggleHumanandghoul', {
    Title = 'Auto [ Human / Ghoul ] Trial',
    Default = false,
}):OnChanged(function(p624)
    KillAura = p624
end)
_Options.ToggleHumanandghoul:SetValue(false)
v3.Race:AddToggle('ToggleAutotrial', {
    Title = 'Auto Trial',
    Default = false,
}):OnChanged(function(p625)
    _G.AutoQuestRace = p625
end)
_Options.ToggleAutotrial:SetValue(false)
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoQuestRace then
                if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Human' then
                    if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Skypiea' then
                        if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Fishman' then
                            if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Cyborg' then
                                if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Ghoul' then
                                    if game:GetService('Players').LocalPlayer.Data.Race.Value == 'Mink' then
                                        local v626, v627, v628 = pairs(game:GetService('Workspace'):GetDescendants())

                                        while true do
                                            local v629

                                            v628, v629 = v626(v627, v628)

                                            if v628 == nil then
                                                break
                                            end
                                            if v629.Name == 'StartPoint' then
                                                Tween(v629.CFrame * CFrame.new(0, 10, 0))
                                            end
                                        end
                                    end
                                else
                                    local v630, v631, v632 = pairs(game.Workspace.Enemies:GetDescendants())

                                    while true do
                                        local u633

                                        v632, u633 = v630(v631, v632)

                                        if v632 == nil then
                                            break
                                        end
                                        if u633:FindFirstChild('Humanoid') and (u633:FindFirstChild('HumanoidRootPart') and u633.Humanoid.Health > 0) then
                                            pcall(function()
                                                repeat
                                                    wait(0.1)

                                                    u633.Humanoid.Health = 0
                                                    u633.HumanoidRootPart.CanCollide = false

                                                    sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                                                until not _G.AutoQuestRace or (not u633.Parent or u633.Humanoid.Health <= 0)
                                            end)
                                        end
                                    end
                                end
                            else
                                Tween(CFrame.new(28654, 14898.7832, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                            end
                        else
                            local v634, v635, v636 = pairs(game:GetService('Workspace').SeaBeasts.SeaBeast1:GetDescendants())

                            while true do
                                local v637

                                v636, v637 = v634(v635, v636)

                                if v636 == nil then
                                    break
                                end
                                if v637.Name == 'HumanoidRootPart' then
                                    Tween(v637.CFrame * _DistanceFarm)

                                    local v638, v639, v640 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                                    while true do
                                        local v641

                                        v640, v641 = v638(v639, v640)

                                        if v640 == nil then
                                            break
                                        end
                                        if v641:IsA('Tool') and v641.ToolTip == 'Melee' then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v641)
                                        end
                                    end

                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)

                                    local v642, v643, v644 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                                    while true do
                                        local v645

                                        v644, v645 = v642(v643, v644)

                                        if v644 == nil then
                                            break
                                        end
                                        if v645:IsA('Tool') and v645.ToolTip == 'Blox Fruit' then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v645)
                                        end
                                    end

                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.5)

                                    local v646, v647, v648 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                                    while true do
                                        local v649

                                        v648, v649 = v646(v647, v648)

                                        if v648 == nil then
                                            break
                                        end
                                        if v649:IsA('Tool') and v649.ToolTip == 'Sword' then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v649)
                                        end
                                    end

                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.5)

                                    local v650, v651, v652 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                                    while true do
                                        local v653

                                        v652, v653 = v650(v651, v652)

                                        if v652 == nil then
                                            break
                                        end
                                        if v653:IsA('Tool') and v653.ToolTip == 'Gun' then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v653)
                                        end
                                    end

                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                end
                            end
                        end
                    else
                        local v654, v655, v656 = pairs(game:GetService('Workspace').Map.SkyTrial.Model:GetDescendants())

                        while true do
                            local v657

                            v656, v657 = v654(v655, v656)

                            if v656 == nil then
                                break
                            end
                            if v657.Name == 'snowisland_Cylinder.081' then
                                BTPZ(v657.CFrame * CFrame.new(0, 0, 0))
                            end
                        end
                    end
                else
                    local v658, v659, v660 = pairs(game.Workspace.Enemies:GetDescendants())

                    while true do
                        local u661

                        v660, u661 = v658(v659, v660)

                        if v660 == nil then
                            break
                        end
                        if u661:FindFirstChild('Humanoid') and (u661:FindFirstChild('HumanoidRootPart') and u661.Humanoid.Health > 0) then
                            pcall(function()
                                repeat
                                    wait(0.1)

                                    u661.Humanoid.Health = 0
                                    u661.HumanoidRootPart.CanCollide = false

                                    sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                                until not _G.AutoQuestRace or (not u661.Parent or u661.Humanoid.Health <= 0)
                            end)
                        end
                    end
                end
            end
        end
    end)
end)
v3.Race:AddSection('Auto Train')
v3.Race:AddToggle('ToggleAutoAcientQuest', {
    Title = 'Auto Train',
    Default = false,
}):OnChanged(function(p662)
    AutoFarmAcient = p662
end)
_Options.ToggleAutoAcientQuest:SetValue(false)

local u663 = CFrame.new(216.211181640625, 126.9352035522461, -12599.0732421875)

spawn(function()
    pcall(function()
        while wait() do
            if AutoFarmAcient and game.Players.LocalPlayer.Character.RaceTransformed.Value == true then
                AutoFarmAcient = false

                toTarget(CFrame.new(216.211181640625, 126.9352035522461, -12599.0732421875))
            end
        end
    end)
end)
spawn(function()
    while wait() do
        if AutoFarmAcient then
            pcall(function()
                if game:GetService('Workspace').Enemies:FindFirstChild('Cocoa Warrior') or (game:GetService('Workspace').Enemies:FindFirstChild('Chocolate Bar Battler') or (game:GetService('Workspace').Enemies:FindFirstChild('Sweet Thief') or game:GetService('Workspace').Enemies:FindFirstChild('Candy Rebel'))) then
                    local v664, v665, v666 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                    while true do
                        local v667

                        v666, v667 = v664(v665, v666)

                        if v666 == nil then
                            break
                        end
                        if (v667.Name == 'Cocoa Warrior' or (v667.Name == 'Chocolate Bar Battler' or (v667.Name == 'Sweet Thief' or v667.Name == 'Candy Rebel'))) and (v667:FindFirstChild('Humanoid') and (v667:FindFirstChild('HumanoidRootPart') and v667.Humanoid.Health > 0)) then
                            bringmob = true

                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCD()
                                AutoHaki()
                                EquipTool(SelectWeapon)

                                v667.HumanoidRootPart.CanCollide = false
                                v667.Humanoid.WalkSpeed = 0
                                v667.Head.CanCollide = false
                                FarmPos = v667.HumanoidRootPart.CFrame
                                MonFarm = v667.Name

                                Tween(v667.HumanoidRootPart.CFrame * CFrame.new(posX, posY, posZ))
                            until not AutoFarmAcient or (not v667.Parent or v667.Humanoid.Health <= 0)

                            bringmob = false
                        end
                    end
                else
                    toTarget(u663)
                end
            end)
        end
    end
end)
spawn(function()
    pcall(function()
        while wait() do
            if AutoFarmAcient and game.Players.LocalPlayer.Character.RaceTransformed.Value == false then
                AutoFarmAcient = true
            end
        end
    end)
end)
spawn(function()
    while wait() do
        pcall(function()
            if AutoFarmAcient then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, 'Y', false, game)
                wait(0.1)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, 'Y', false, game)
            end
        end)
    end
end)
v3.Shop:AddToggle('ToggleRandomBone', {
    Title = 'Random Bone',
    Default = false,
}):OnChanged(function(p668)
    _G.AutoRandomBone = p668
end)
_Options.ToggleRandomBone:SetValue(false)
spawn(function()
    while wait(1e-52) do
        if _G.AutoRandomBone then
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
                'Bones',
                'Buy',
                1,
                1,
            }))
        end
    end
end)
v3.Shop:AddButton({
    Title = 'Geppo',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyHaki', 'Geppo')
    end,
})
v3.Shop:AddButton({
    Title = 'Buso Haki',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyHaki', 'Buso')
    end,
})
v3.Shop:AddButton({
    Title = 'Soru',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyHaki', 'Soru')
    end,
})
v3.Shop:AddButton({
    Title = 'Ken Haki',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('KenTalk', 'Buy')
    end,
})
v3.Shop:AddSection('Fighting Styles')
v3.Shop:AddButton({
    Title = 'Black Leg',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyBlackLeg')
    end,
})
v3.Shop:AddButton({
    Title = 'Electro',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyElectro')
    end,
})
v3.Shop:AddButton({
    Title = 'Fishman Karate',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyFishmanKarate')
    end,
})
v3.Shop:AddButton({
    Title = 'Dragon Claw',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1')
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '2')
    end,
})
v3.Shop:AddButton({
    Title = 'Superhuman',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuySuperhuman')
    end,
})
v3.Shop:AddButton({
    Title = 'Death Step',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyDeathStep')
    end,
})
v3.Shop:AddButton({
    Title = 'Sharkman Karate',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuySharkmanKarate', true)
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuySharkmanKarate')
    end,
})
v3.Shop:AddButton({
    Title = 'Electric Claw',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyElectricClaw')
    end,
})
v3.Shop:AddButton({
    Title = 'Dragon Talon',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyDragonTalon')
    end,
})
v3.Shop:AddButton({
    Title = 'Godhuman',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BuyGodhuman')
    end,
})
v3.Shop:AddSection('Misc Items')
v3.Shop:AddButton({
    Title = 'Refund Stats',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'Refund', '1')
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'Refund', '2')
    end,
})
v3.Shop:AddButton({
    Title = 'Reroll Race',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'Reroll', '1')
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('BlackbeardReward', 'Reroll', '2')
    end,
})
v3.Misc:AddButton({
    Title = 'Rejoin Server',
    Description = '',
    Callback = function()
        game:GetService('TeleportService'):Teleport(game.PlaceId, game:GetService('Players').LocalPlayer)
    end,
})
v3.Misc:AddButton({
    Title = 'Hop Server',
    Description = '',
    Callback = function()
        Hop()
    end,
})

function Hop()
    local _PlaceId3 = game.PlaceId
    local u670 = {}
    local u671 = ''
    local _hour = os.date('!*t').hour

    function TPReturner()
        local v673

        if u671 ~= '' then
            v673 = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. _PlaceId3 .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. u671))
        else
            v673 = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. _PlaceId3 .. '/servers/Public?sortOrder=Asc&limit=100'))
        end
        if v673.nextPageCursor and (v673.nextPageCursor ~= 'null' and v673.nextPageCursor ~= nil) then
            u671 = v673.nextPageCursor
        end

        local v674, v675, v676 = pairs(v673.data)
        local v677 = 0

        while true do
            local v678

            v676, v678 = v674(v675, v676)

            if v676 == nil then
                break
            end

            local v679 = true
            local u680 = tostring(v678.id)

            if tonumber(v678.maxPlayers) > tonumber(v678.playing) then
                local v681, v682, v683 = pairs(u670)

                while true do
                    local v684

                    v683, v684 = v681(v682, v683)

                    if v683 == nil then
                        break
                    end
                    if v677 == 0 then
                        if tonumber(_hour) ~= tonumber(v684) then
                            pcall(function()
                                u670 = {}

                                table.insert(u670, _hour)
                            end)
                        end
                    elseif u680 == tostring(v684) then
                        v679 = false
                    end

                    v677 = v677 + 1
                end

                if v679 == true then
                    table.insert(u670, u680)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService('TeleportService'):TeleportToPlaceInstance(_PlaceId3, u680, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end

    _TeleportWorld = function()
        while wait() do
            pcall(function()
                TPReturner()

                if u671 ~= '' then
                    TPReturner()
                end
            end)
        end
    end

    _TeleportWorld()
end

v3.Misc:AddSection('Team')
v3.Misc:AddButton({
    Title = 'Join Pirates Team',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('SetTeam', 'Pirates')
    end,
})
v3.Misc:AddButton({
    Title = 'Join Marines Team',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('SetTeam', 'Marines')
    end,
})
v3.Misc:AddSection('Open Ui')
v3.Misc:AddButton({
    Title = 'Devil Shop Menu',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('GetFruits')

        game:GetService('Players').LocalPlayer.PlayerGui.Main.FruitShop.Visible = true
    end,
})
v3.Misc:AddButton({
    Title = 'Color Haki Menu',
    Description = '',
    Callback = function()
        game.Players.localPlayer.PlayerGui.Main.Colors.Visible = true
    end,
})
v3.Misc:AddButton({
    Title = 'Title Name Menu',
    Description = '',
    Callback = function()
        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
            'getTitles',
        }))

        game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
    end,
})
v3.Misc:AddButton({
    Title = 'Awakening Menu',
    Description = '',
    Callback = function()
        game:GetService('Players').LocalPlayer.PlayerGui.Main.AwakeningToggler.Visible = true
    end,
})
v3.Misc:AddSection('Troll')
v3.Misc:AddButton({
    Title = 'Rain Fruit',
    Description = 'Rain fruit (Fake)',
    Callback = function()
        local v685, v686, v687 = pairs(game:GetObjects('rbxassetid://14759368201')[1]:GetChildren())

        while true do
            local u688

            v687, u688 = v685(v686, v687)

            if v687 == nil then
                break
            end

            u688.Parent = game.Workspace.Map

            u688:MoveTo(game.Players.LocalPlayer.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))

            if u688.Fruit:FindFirstChild('AnimationController') then
                u688.Fruit:FindFirstChild('AnimationController'):LoadAnimation(u688.Fruit:FindFirstChild('Idle')):Play()
            end

            u688.Handle.Touched:Connect(function(p689)
                if p689.Parent == game.Players.LocalPlayer.Character then
                    u688.Parent = game.Players.LocalPlayer.Backpack

                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(u688)
                end
            end)
        end
    end,
})
v3.Misc:AddSection('Misc')
v3.Misc:AddToggle('ToggleRejoin', {
    Title = 'Auto Rejoin',
    Default = true,
}):OnChanged(function(p690)
    _G.AutoRejoin = p690
end)
_Options.ToggleRejoin:SetValue(true)
spawn(function()
    while wait() do
        if _G.AutoRejoin then
            getgenv().rejoin = game:GetService('CoreGui').RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(p691)
                if p691.Name == 'ErrorPrompt' and p691:FindFirstChild('MessageArea') and p691.MessageArea:FindFirstChild('ErrorFrame') then
                    game:GetService('TeleportService'):Teleport(game.PlaceId)
                end
            end)
        end
    end
end)
v3.Misc:AddSection('Kaitun Cap')
v3.Misc:AddButton({
    Title = 'Show Items',
    Description = '',
    Callback = function()
        local _UILibrary = game:GetService('CoreGui').RobloxGui.Modules.Profile:FindFirstChild('UILibrary')

        if _UILibrary then
            _UILibrary:Destroy()
        end

        game:GetService('UserInputService')

        local _TweenService5 = game:GetService('TweenService')

        game:GetService('RunService')
        game:GetService('Players').LocalPlayer:GetMouse()

        local _Blur = game:GetService('Lighting'):FindFirstChild('Blur')

        if _Blur then
            _Blur:Destroy()
        end

        local _BlurEffect = Instance.new('BlurEffect')

        _TweenService5:Create(_BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Size = 50}):Play()

        _BlurEffect.Parent = game.Lighting

        Instance.new('UIStroke')
        Instance.new('UICorner')

        local _ScreenGui2 = Instance.new('ScreenGui')

        Instance.new('ImageButton')

        local _ = Enum.ButtonStyle.RobloxButton

        pcall(function() _ScreenGui2.Parent = game:GetService("CoreGui") end)
if not _ScreenGui2.Parent then _ScreenGui2.Parent = game.Players.LocalPlayer.PlayerGui end
        _ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local v697 = require(game:GetService('Players').LocalPlayer.PlayerGui.Main.UIController.Inventory)
        local _getInventory = game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('getInventory')
        local v699 = {}
        local v700 = {
            'Mythical',
            'Legendary',
            'Rare',
            'Uncommon',
            'Common',
        }
        local u701 = {
            Common = Color3.fromRGB(179, 179, 179),
            Uncommon = Color3.fromRGB(92, 140, 211),
            Rare = Color3.fromRGB(140, 82, 255),
            Legendary = Color3.fromRGB(213, 43, 228),
            Mythical = Color3.fromRGB(238, 47, 50),
        }

        function GetRaity(p702)
            local v703, v704, v705 = pairs(u701)

            while true do
                local v706

                v705, v706 = v703(v704, v705)

                if v705 == nil then
                    break
                end
                if v706 == p702 then
                    return v705
                end
            end
        end

        local v707, v708, v709 = pairs(_getInventory)

        while true do
            local v710

            v709, v710 = v707(v708, v709)

            if v709 == nil then
                break
            end

            v699[v710.Name] = v710
        end

        local v711 = #getupvalue(v697.UpdateRender, 4)
        local v712 = 0
        local v713 = {}
        local v714 = {}

        while v712 < v711 do
            local v715 = 0

            while v715 < 25000 and v712 < v711 do
                game:GetService('Players').LocalPlayer.PlayerGui.Main.InventoryContainer.Right.Content.ScrollingFrame.CanvasPosition = Vector2.new(0, v715)

                local v716, v717, v718 = pairs(game:GetService('Players').LocalPlayer.PlayerGui.Main.InventoryContainer.Right.Content.ScrollingFrame.Frame:GetChildren())

                while true do
                    local v719

                    v718, v719 = v716(v717, v718)

                    if v718 == nil then
                        break
                    end
                    if v719:IsA('Frame') and (not v714[v719.ItemName.Text] and v719.ItemName.Visible == true) then
                        local v720 = GetRaity(v719.Background.BackgroundColor3)

                        if v720 then
                            if not v713[v720] then
                                v713[v720] = {}
                            end

                            table.insert(v713[v720], v719:Clone())
                        end

                        v712 = v712 + 1
                        v714[v719.ItemName.Text] = true
                    end
                end

                v715 = v715 + 20
            end

            wait()
        end

        function GetXY(p721)
            return p721 * 100
        end

        local _UIListLayout = Instance.new('UIListLayout')

        _UIListLayout.FillDirection = Enum.FillDirection.Vertical
        _UIListLayout.SortOrder = 2
        _UIListLayout.Padding = UDim.new(0, 10)

        local _Frame = Instance.new('Frame', game.Players.LocalPlayer.PlayerGui.BubbleChat)

        _Frame.BackgroundTransparency = 1
        _Frame.Size = UDim2.new(0.5, 0, 1, 0)
        _UIListLayout.Parent = _Frame

        local _Frame2 = Instance.new('Frame', game.Players.LocalPlayer.PlayerGui.BubbleChat)

        _Frame2.BackgroundTransparency = 1
        _Frame2.Size = UDim2.new(0.5, 0, 1, 0)
        _Frame2.Position = UDim2.new(0.6, 0, 0, 0)
        _UIListLayout:Clone().Parent = _Frame2

        local v725, v726, v727 = pairs(v713)

        while true do
            local v728

            v727, v728 = v725(v726, v727)

            if v727 == nil then
                break
            end

            local _Frame3 = Instance.new('Frame', _Frame)

            _Frame3.BackgroundTransparency = 1
            _Frame3.Size = UDim2.new(1, 0, 0, 0)
            _Frame3.LayoutOrder = table.find(v700, v727)

            local _Frame4 = Instance.new('Frame', _Frame2)

            _Frame4.BackgroundTransparency = 1
            _Frame4.Size = UDim2.new(1, 0, 0, 0)
            _Frame4.LayoutOrder = table.find(v700, v727)

            local _UIGridLayout = Instance.new('UIGridLayout', _Frame3)

            _UIGridLayout.CellPadding = UDim2.new(0.005, 0, 0.005, 0)
            _UIGridLayout.CellSize = UDim2.new(0, 70, 0, 70)
            _UIGridLayout.FillDirectionMaxCells = 100
            _UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
            _UIGridLayout:Clone().Parent = _Frame4

            local v732, v733, v734 = pairs(v728)

            while true do
                local v735

                v734, v735 = v732(v733, v734)

                if v734 == nil then
                    break
                end
                if v699[v735.ItemName.Text] and v699[v735.ItemName.Text].Mastery then
                    if v735.ItemLine2.Text ~= 'Accessory' then
                        local v736 = v735.ItemName:Clone()

                        v736.BackgroundTransparency = 1
                        v736.TextSize = 10
                        v736.TextXAlignment = 2
                        v736.TextYAlignment = 2
                        v736.ZIndex = 5
                        v736.Text = v699[v735.ItemName.Text].Mastery
                        v736.Size = UDim2.new(0.5, 0, 0.5, 0)
                        v736.Position = UDim2.new(0.5, 0, 0.5, 0)
                        v736.Parent = v735
                    end

                    v735.Parent = _Frame3
                elseif v735.ItemLine2.Text == 'Blox Fruit' then
                    v735.Parent = _Frame4
                end
            end

            _Frame3.AutomaticSize = 2
            _Frame4.AutomaticSize = 2
        end

        local v737 = {
            Superhuman = Vector2.new(3, 2),
            DeathStep = Vector2.new(4, 3),
            ElectricClaw = Vector2.new(2, 0),
            SharkmanKarate = Vector2.new(0, 0),
            DragonTalon = Vector2.new(1, 5),
        }
        local _Frame5 = Instance.new('Frame', _Frame)

        _Frame5.BackgroundTransparency = 1
        _Frame5.Size = UDim2.new(1, 0, 0, 0)
        _Frame5.LayoutOrder = table.find(v700, k)
        _Frame5.AutomaticSize = 2
        _Frame5.LayoutOrder = 100

        local _UIGridLayout2 = Instance.new('UIGridLayout', _Frame5)

        _UIGridLayout2.CellPadding = UDim2.new(0.005, 0, 0.005, 0)
        _UIGridLayout2.CellSize = UDim2.new(0, 70, 0, 70)
        _UIGridLayout2.FillDirectionMaxCells = 100
        _UIGridLayout2.FillDirection = Enum.FillDirection.Horizontal

        local v740, v741, v742 = pairs({
            'Superhuman',
            'ElectricClaw',
            'DragonTalon',
            'SharkmanKarate',
            'DeathStep',
            'GodHuman',
        })

        while true do
            local v743

            v742, v743 = v740(v741, v742)

            if v742 == nil then
                break
            end
            if v737[v743] and game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('Buy' .. v743, true) == 1 then
                local _ImageLabel = Instance.new('ImageLabel', _Frame5)

                _ImageLabel.Image = 'rbxassetid://15924414834'
                _ImageLabel.ImageRectSize = Vector2.new(100, 100)
                _ImageLabel.ImageRectOffset = v737[v743] * 100
            end
        end

        function formatNumber(p745)
            return tostring(p745):reverse():gsub('%d%d%d', '%1,'):reverse():gsub('^,', '')
        end

        game:GetService('Players').LocalPlayer.PlayerGui.Main.Beli.AnchorPoint = Vector2.new(0.5, 0.5)
        game:GetService('Players').LocalPlayer.PlayerGui.Main.Beli.Position = UDim2.new(0, 1120, 0, 700)
        game:GetService('Players').LocalPlayer.PlayerGui.Main.Level.AnchorPoint = Vector2.new(0.5, 0.5)
        game:GetService('Players').LocalPlayer.PlayerGui.Main.Level.Position = UDim2.new(0, 1150, 0, 750)

        local v746 = game:GetService('Players').LocalPlayer.PlayerGui.Main.Fragments:Clone()

        v746.Name = 'Name'
        v746.Parent = game:GetService('Players').LocalPlayer.PlayerGui.Main.Beli
        v746.Position = UDim2.new(0, 0, -1.5, 0)
        v746.Size = UDim2.new(1, 0, 1, 0)
        v746.TextColor3 = Color3.fromRGB(255, 255, 255)
        v746.Text = game.Players.LocalPlayer.Name

        local v747 = game:GetService('Players').LocalPlayer.PlayerGui.Main.Fragments:Clone()

        v747.Name = 'FragmentsCheck'
        v747.Parent = game:GetService('Players').LocalPlayer.PlayerGui.Main.Beli
        v747.Position = UDim2.new(0, 0, -0.75, 0)
        v747.Size = UDim2.new(1, 0, 1, 0)
        v747.Text = '\u{192}' .. formatNumber(game:GetService('Players').LocalPlayer.Data.Fragments.Value)

        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer(unpack({
            'getAwakenedAbilities',
        }))

        game.Players.LocalPlayer.PlayerGui.Main.AwakeningToggler.Visible = true
        game:GetService('Players').LocalPlayer.PlayerGui.Main.AwakeningToggler.Position = UDim2.new(0.48, 10, 0.908, 2)
        game:GetService('Players').LocalPlayer.PlayerGui.Main.AwakeningToggler.Size = UDim2.new(1, 0, 0.22, 0)

        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Main.MenuButton.Visible = false
        end)
        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Main.RaceEnergy.Visible = false
        end)
        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Main.SafeZone.Visible = false
        end)
        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Main.HP.Visible = false
        end)
        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Backpack.Enabled.Visible = false
        end)
        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Main.Energy.Visible = false
        end)

        local v748, v749, v750 = pairs(game:GetService('Players').LocalPlayer.PlayerGui.Main:GetChildren())

        while true do
            local v751

            v750, v751 = v748(v749, v750)

            if v750 == nil then
                break
            end
            if v751:IsA('ImageButton') then
                v751:Destroy()
            end
        end

        pcall(function()
            game:GetService('Players').LocalPlayer.PlayerGui.Main.Compass.Visible = false
        end)
    end,
})
v3.Misc:AddSection('Day')
v3.Misc:AddButton({
    Title = 'Remove Fog',
    Description = '',
    Callback = function()
        game:GetService('Lighting').LightingLayers:Destroy()
        game:GetService('Lighting').Sky:Destroy()
    end,
})
v3.Misc:AddButton({
    Title = 'Always Day',
    Description = '',
    Callback = function()
        game:GetService('RunService').Heartbeat:wait()

        game:GetService('Lighting').ClockTime = 12
    end,
})

if First_Sea or Second_Sea then
    v3.Hop:AddSection('Thid Sea Please !!!')
end
if Third_Sea then
    v3.Hop:AddToggle('ToggleFindMoon', {
        Title = 'Find Full Moon',
        Default = false,
    }):OnChanged(function(p752)
        _G.AutoFindMoon = p752
    end)
    _Options.ToggleFindMoon:SetValue(false)
    spawn(function()
        while wait() do
            if _G.AutoFindMoon then
                if game:GetService('Lighting').Sky.MoonTextureId == 'http://www.roblox.com/asset/?id=9709149052' or game:GetService('Lighting').Sky.MoonTextureId == 'http://www.roblox.com/asset/?id=9709149431' then
                    wait(2)
                elseif game:GetService('Lighting').Sky.MoonTextureId ~= 'http://www.roblox.com/asset/?id=9709143733' then
                    if game:GetService('Lighting').Sky.MoonTextureId ~= 'http://www.roblox.com/asset/?id=9709150401' then
                        if game:GetService('Lighting').Sky.MoonTextureId ~= 'http://www.roblox.com/asset/?id=9709149680' then
                            Hop()
                        else
                            Hop()
                            u1:Notify({
                                Title = 'Elite Hub',
                                Content = 'Hop...',
                                SubContent = '',
                                Duration = 5,
                            })
                        end
                    else
                        Hop()
                        u1:Notify({
                            Title = 'Elite Hub',
                            Content = 'Hop...',
                            SubContent = '',
                            Duration = 5,
                        })
                    end
                else
                    Hop()
                    u1:Notify({
                        Title = 'Elite Hub',
                        Content = 'Turn Off Find Full Moon...',
                        SubContent = '',
                        Duration = 5,
                    })
                end
            end
        end
    end)
    v3.Hop:AddToggle('ToggleMirageIsland', {
        Title = 'Find Mirage Island',
        Default = false,
    }):OnChanged(function(p753)
        _G.FindMirageIsland = p753
    end)
    _Options.ToggleMirageIsland:SetValue(false)
    spawn(function()
        while wait() do
            if _G.FindMirageIsland then
                if game:GetService('Workspace').Map:FindFirstChild('MysticIsland') or game:GetService('Workspace').Map:FindFirstChild('MysticIsland') then
                    if HighestPointRealCFrame and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - HighestPointRealCFrame.Position).Magnitude > 10 then
                        Tween(getHighestPoint().CFrame * CFrame.new(0, 211.88, 0))
                    end
                elseif not (game:GetService('Workspace').Map:FindFirstChild('MysticIsland') and game:GetService('Workspace').Map:FindFirstChild('MysticIsland')) then
                    Hop()
                end
            end
        end
    end)
end

v3.Info:AddButton({
    Title = 'Thank you for using Elite Hub',
    Description = 'dev by Elite Hub',
    Callback = function()
        setclipboard('dev by Elite Hub')
        u1:Notify({
            Title = 'Elite Hub',
            Content = 'dev by Elite Hub',
            SubContent = '',
            Duration = 5,
        })
    end,
})
v3.Info:AddButton({
    Title = 'Copy Discord Elite Hub',
    Description = 'https://discord.gg/Pq2dsdfHhE',
    Callback = function()
        setclipboard('https://discord.gg/Pq2dsdfHhE')
        u1:Notify({
            Title = 'Elite Hub',
            Content = 'Copied!',
            SubContent = '',
            Duration = 5,
        })
    end,
})
