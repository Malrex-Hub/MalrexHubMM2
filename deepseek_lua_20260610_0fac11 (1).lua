-- // ELITE HUB v1.0.0 | JAILBREAK
-- // discord.gg/5RuMCxK3u6
-- // FUCK YOU IF YOU STEAL THIS SHIT - 9,338 MEMBERS 🥀
-- // LOADING SCREEN + DISCORD NOTIFICATION + CURSING

-- // LOADING SCREEN (FUCKING SEXY)
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EliteHubLoading"
loadingGui.Parent = game:GetService("CoreGui")
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local loadingBg = Instance.new("Frame")
loadingBg.Size = UDim2.new(1, 0, 1, 0)
loadingBg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
loadingBg.Parent = loadingGui

local loadingCenter = Instance.new("Frame")
loadingCenter.Size = UDim2.new(0, 350, 0, 250)
loadingCenter.Position = UDim2.new(0.5, -175, 0.5, -125)
loadingCenter.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
loadingCenter.BackgroundTransparency = 0.05
loadingCenter.Parent = loadingBg

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingCenter

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 0, 50)
logoText.Position = UDim2.new(0, 0, 0, 20)
logoText.BackgroundTransparency = 1
logoText.Text = "ELITE HUB"
logoText.TextColor3 = Color3.fromRGB(46, 204, 113)
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 36
logoText.TextScaled = true
logoText.Parent = loadingCenter

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 0, 20)
statusText.Position = UDim2.new(0, 20, 0, 85)
statusText.BackgroundTransparency = 1
statusText.Text = "FUCKING LOADING..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 200)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 12
statusText.Parent = loadingCenter

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 6)
barBg.Position = UDim2.new(0.1, 0, 0, 120)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
barBg.Parent = loadingCenter

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

local skipBtn = Instance.new("TextButton")
skipBtn.Size = UDim2.new(0, 100, 0, 30)
skipBtn.Position = UDim2.new(0.5, -50, 0, 160)
skipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
skipBtn.Text = "SKIP 🥀"
skipBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
skipBtn.Font = Enum.Font.GothamBold
skipBtn.TextSize = 12
skipBtn.Parent = loadingCenter

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 6)
skipCorner.Parent = skipBtn

local skipPressed = false
skipBtn.MouseButton1Click:Connect(function() skipPressed = true end)

local steps = {
    "INJECTING THIS SHIT...",
    "BYPASSING JAILBREAK...",
    "LOADING FUCKING FEATURES...",
    "FUCKING READY 🥀"
}

for i, step in ipairs(steps) do
    if skipPressed then break end
    statusText.Text = step
    TweenService = game:GetService("TweenService")
    TweenService:Create(barFill, TweenInfo.new(0.3), {Size = UDim2.new(i / #steps, 0, 1, 0)}):Play()
    task.wait(0.4)
end

task.wait(0.2)
loadingGui:Destroy()

-- // DISCORD NOTIFICATION (CURSING INTENSIFIES)
local discordGui = Instance.new("ScreenGui")
discordGui.Name = "EliteHubDiscord"
discordGui.Parent = game:GetService("CoreGui")

local discordFrame = Instance.new("Frame")
discordFrame.Size = UDim2.new(0, 360, 0, 160)
discordFrame.Position = UDim2.new(0.5, -180, 0.5, -80)
discordFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
discordFrame.BackgroundTransparency = 0
discordFrame.BorderSizePixel = 0
discordFrame.Parent = discordGui

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 12)
discordCorner.Parent = discordFrame

local discordTitle = Instance.new("TextLabel")
discordTitle.Size = UDim2.new(1, 0, 0, 45)
discordTitle.Position = UDim2.new(0, 0, 0, 10)
discordTitle.BackgroundTransparency = 1
discordTitle.Text = "🔞 ELITE HUB 🔞"
discordTitle.TextColor3 = Color3.fromRGB(255, 66, 105)
discordTitle.Font = Enum.Font.GothamBold
discordTitle.TextSize = 28
discordTitle.Parent = discordFrame

local discordMsg = Instance.new("TextLabel")
discordMsg.Size = UDim2.new(1, -30, 0, 40)
discordMsg.Position = UDim2.new(0, 15, 0, 60)
discordMsg.BackgroundTransparency = 1
discordMsg.Text = "JOIN DISCORD YOU BITCH 🥀\ndiscord.gg/5RuMCxK3u6"
discordMsg.TextColor3 = Color3.fromRGB(180, 180, 200)
discordMsg.Font = Enum.Font.Gotham
discordMsg.TextSize = 12
discordMsg.TextWrapped = true
discordMsg.Parent = discordFrame

local joinBtn = Instance.new("TextButton")
joinBtn.Size = UDim2.new(0, 140, 0, 35)
joinBtn.Position = UDim2.new(0.5, -150, 0, 115)
joinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
joinBtn.Text = "YES JOIN (COPY LINK)"
joinBtn.TextColor3 = Color3.new(1, 1, 1)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 12
joinBtn.Parent = discordFrame

local skipDiscordBtn = Instance.new("TextButton")
skipDiscordBtn.Size = UDim2.new(0, 140, 0, 35)
skipDiscordBtn.Position = UDim2.new(0.5, 10, 0, 115)
skipDiscordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
skipDiscordBtn.Text = "NO (FUCK OFF)"
skipDiscordBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
skipDiscordBtn.Font = Enum.Font.GothamBold
skipDiscordBtn.TextSize = 12
skipDiscordBtn.Parent = discordFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = joinBtn

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = skipDiscordBtn

joinBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5RuMCxK3u6")
    discordGui:Destroy()
end)

skipDiscordBtn.MouseButton1Click:Connect(function()
    discordGui:Destroy()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ELITE HUB",
        Text = "You're a dumbass for not joining but whatever 🥀",
        Duration = 3
    })
end)

-- // WAIT FOR USER TO CLOSE DISCORD NOTIFICATION (OR SKIP)
repeat task.wait() until not discordGui.Parent

-- // ========== ORIGINAL SCRIPT CONVERTED TO ELITE HUB ==========
local Fluent = loadstring(game:HttpGet('https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua'))()

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService('Workspace')

local Window = Fluent:CreateWindow({
    Title = 'ELITE HUB (Jailbreak) - FUCK JAILBREAK 🥀',
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = 'Dark',
    MinimizeKey = Enum.KeyCode.RightShift,
})

local Tabs = {
    Main = Window:AddTab({ Title = 'MAIN (FUCK SHIT UP)', Icon = '' }),
    ESP = Window:AddTab({ Title = 'ESP (SEE BITCHES)', Icon = '' }),
    Misc = Window:AddTab({ Title = 'MISC (EXTRA SHIT)', Icon = '' }),
    Robberies = Window:AddTab({ Title = 'ROBBERIES (STEAL THAT SHIT)', Icon = '' }),
}

-- // GIVE ITEMS BUTTON
Tabs.Main:AddButton({
    Title = 'GIVE ITEMS (PISTOL, BATON, SHOTGUN, SWAT)',
    Callback = function()
        if workspace:FindFirstChild('Givers') then
            local LocalPlayer = Players.LocalPlayer
            local Workspace = game:GetService('Workspace')
            local savedDetectors = nil
            if savedDetectors then
                for _, data in pairs(savedDetectors) do
                    data.ClickDetector.Parent = data.OriginalParent
                    data.Event:Disconnect()
                end
                getmetatable(savedDetectors):Destroy()
            end
            local detectors = {}
            local tempPart = Instance.new('Part', Workspace)
            tempPart.Anchored = true
            tempPart.CanCollide = false
            tempPart.CFrame = LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame
            setmetatable(detectors, { __metatable = tempPart })
            local children = Workspace.Givers:GetChildren()
            for _, giver in pairs(children) do
                local clickDetector = giver:FindFirstChildOfClass('ClickDetector')
                if clickDetector then
                    local data = { ClickDetector = clickDetector, OriginalParent = giver }
                    clickDetector.Parent = tempPart
                    data.Event = clickDetector.MouseClick:Connect(function()
                        clickDetector.Parent = giver
                    end)
                    table.insert(detectors, data)
                end
            end
            spawn(function()
                wait(10)
                if detectors then
                    for _, data in pairs(detectors) do
                        data.ClickDetector.Parent = data.OriginalParent
                        data.Event:Disconnect()
                    end
                    getmetatable(detectors):Destroy()
                end
            end)
        end
    end,
})
Tabs.Main:AddParagraph({ Title = 'Give Items', Content = 'Pistol, Baton, Shotgun and SWAT stuff (if you bought) - FUCK YEAH' })
Tabs.Main:AddButton({
    Title = 'GIVE GLIDER (FLY BITCH)',
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService('Workspace')
        local savedDetectors = nil
        if Workspace:FindFirstChild('Givers') then
            if savedDetectors then
                for _, data in pairs(savedDetectors) do
                    data.ClickDetector.Parent = data.OriginalParent
                    data.Event:Disconnect()
                end
                getmetatable(savedDetectors).__metatable = nil
            end
            local detectors = {}
            local tempPart = Instance.new('Part', Workspace)
            tempPart.Anchored = true
            tempPart.CanCollide = false
            tempPart.CFrame = LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame
            setmetatable(detectors, { __metatable = tempPart })
            local glider = Workspace.Givers:FindFirstChild('Glider')
            local clickDetector = glider and glider:FindFirstChildOfClass('ClickDetector')
            if clickDetector then
                local data = { ClickDetector = clickDetector, OriginalParent = glider }
                clickDetector.Parent = tempPart
                data.Event = clickDetector.MouseClick:Connect(function()
                    clickDetector.Parent = glider
                end)
                table.insert(detectors, data)
            end
            spawn(function()
                wait(10)
                if detectors then
                    for _, data in pairs(detectors) do
                        data.ClickDetector.Parent = data.OriginalParent
                        data.Event:Disconnect()
                    end
                    getmetatable(detectors).__metatable = nil
                end
            end)
        end
    end,
})

-- // ESP SECTION (RENAMED WITH CURSING)
local espEnabled = false
local tracersEnabled = false
local boxesEnabled = false
local namesEnabled = false
local distanceEnabled = false
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj.Line then obj.Line:Remove() end
        if obj.NameLabel then obj.NameLabel:Remove() end
        if obj.Box then obj.Box:Remove() end
        if obj.DistanceLabel then obj.DistanceLabel:Remove() end
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild('HumanoidRootPart')
    local rootPos = rootPart and rootPart.Position
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char and char:FindFirstChild('HumanoidRootPart') then
                local targetPos = char.HumanoidRootPart.Position
                local color = Color3.new(1,1,1)
                if player.TeamColor == BrickColor.new('Bright red') then
                    color = Color3.new(1,0,0)
                elseif player.TeamColor == BrickColor.new('Bright blue') then
                    color = Color3.new(0,0,1)
                elseif player.TeamColor == BrickColor.new('Bright orange') then
                    color = Color3.new(1,0.5,0)
                end
                local vector, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetPos)
                local rootVector = rootPos and Workspace.CurrentCamera:WorldToViewportPoint(rootPos)
                if onScreen and rootVector and rootVector.Z > 0 then
                    if tracersEnabled then
                        local line = Drawing.new('Line')
                        line.Visible = true
                        line.From = Vector2.new(rootVector.X, rootVector.Y)
                        line.To = Vector2.new(vector.X, vector.Y)
                        line.Color = color
                        line.Thickness = 2
                        table.insert(espObjects, { Line = line })
                    end
                    if namesEnabled then
                        local text = Drawing.new('Text')
                        text.Visible = true
                        text.Position = Vector2.new(vector.X, vector.Y)
                        text.Size = 18
                        text.Color = color
                        text.Center = true
                        text.Outline = true
                        text.Text = player.Name
                        table.insert(espObjects, { NameLabel = text })
                    end
                    if boxesEnabled then
                        local square = Drawing.new('Square')
                        square.Visible = true
                        square.Position = Vector2.new(vector.X - 15, vector.Y - 30)
                        square.Size = Vector2.new(30, 30)
                        square.Color = color
                        square.Thickness = 2
                        table.insert(espObjects, { Box = square })
                    end
                    if distanceEnabled and rootPos then
                        local dist = (targetPos - rootPos).Magnitude
                        local distText = Drawing.new('Text')
                        distText.Visible = true
                        distText.Position = Vector2.new(vector.X, vector.Y + 15)
                        distText.Size = 18
                        distText.Color = color
                        distText.Center = true
                        distText.Outline = true
                        distText.Text = string.format('%.1f m', dist)
                        table.insert(espObjects, { DistanceLabel = distText })
                    end
                end
            end
        end
    end
end

local espToggle = Tabs.ESP:AddToggle('ESP', { Title = 'ESP (WALLHACK BITCH)', Default = false })
local tracersToggle = Tabs.ESP:AddToggle('Tracers', { Title = 'Tracers', Default = false })
local boxesToggle = Tabs.ESP:AddToggle('Boxes', { Title = 'Boxes', Default = false })
local namesToggle = Tabs.ESP:AddToggle('Names', { Title = 'Names', Default = false })
local distanceToggle = Tabs.ESP:AddToggle('Distance', { Title = 'Distance', Default = false })

tracersToggle:OnChanged(function(v) tracersEnabled = v; if espEnabled then clearESP() end end)
boxesToggle:OnChanged(function(v) boxesEnabled = v; if espEnabled then clearESP() end end)
namesToggle:OnChanged(function(v) namesEnabled = v; if espEnabled then clearESP() end end)
distanceToggle:OnChanged(function(v) distanceEnabled = v; if espEnabled then clearESP() end end)
espToggle:OnChanged(function(v) espEnabled = v; if not v then clearESP() end end)

game:GetService('RunService').RenderStepped:Connect(function()
    if espEnabled then updateESP() end
end)

-- // ROBBERIES (ALL ORIGINAL SHIT, RENAMED)
local Robberies = Tabs.Robberies

Robberies:AddSection('Tomb (FUCK THOSE SPIKES)')
local spikeStorage = {}
Robberies:AddToggle('RemoveSpikes', { Title = 'Remove Spikes', Default = false, Callback = function(v)
    local spikeRoom = Workspace:FindFirstChild('RobberyTomb') and Workspace.RobberyTomb:FindFirstChild('SpikeRoom')
    local spikes = spikeRoom and spikeRoom:FindFirstChild('Spikes')
    if spikes then
        if v then
            spikeStorage = {}
            for _, model in pairs(spikes:GetChildren()) do
                if model:IsA('Model') then
                    for _, tile in pairs(model:GetChildren()) do
                        if tile:IsA('Model') and tile.Name == 'Tile' then
                            for _, spikeModel in pairs(tile:GetChildren()) do
                                if spikeModel:IsA('Model') and spikeModel.Name == 'Model' then
                                    table.insert(spikeStorage, { spikeModel:Clone(), tile })
                                    spikeModel:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        else
            for _, data in pairs(spikeStorage) do
                data[1].Parent = data[2]
            end
            spikeStorage = {}
        end
    end
end })

local dartStorage = {}
Robberies:AddToggle('DeleteDarts', { Title = 'Remove Darts', Default = false, Callback = function(v)
    local dartRoom = Workspace:FindFirstChild('RobberyTomb') and Workspace.RobberyTomb:FindFirstChild('DartRoom')
    local darts = dartRoom and dartRoom:FindFirstChild('Darts')
    if darts then
        if v then
            dartStorage = {}
            for _, dart in pairs(darts:GetChildren()) do
                if dart:IsA('BasePart') then
                    table.insert(dartStorage, dart:Clone())
                    dart:Destroy()
                end
            end
        else
            for _, dart in pairs(dartStorage) do
                dart.Parent = darts
            end
            dartStorage = {}
        end
    end
end })

local plankStorage = {}
local function savePlanks()
    local tomb = Workspace:FindFirstChild('RobberyTomb')
    local cart = tomb and tomb:FindFirstChild('Cart')
    local planks = cart and cart:FindFirstChild('Planks')
    if planks then
        table.insert(plankStorage, { model = planks:Clone(), parent = planks.Parent })
        planks:Destroy()
    end
end
local function restorePlanks()
    for _, data in pairs(plankStorage) do
        if data.model.Parent == nil then
            data.model.Parent = data.parent
        end
    end
    plankStorage = {}
end
Robberies:AddToggle('RemovePlanks', { Title = 'Remove Planks', Default = false, Callback = function(v)
    if v then savePlanks() else restorePlanks() end
end })

local killModelStorage = {}
local function saveKillModel()
    local tomb = Workspace:FindFirstChild('RobberyTomb')
    local kill = tomb and tomb:FindFirstChild('Kill')
    if kill then
        table.insert(killModelStorage, { model = kill:Clone(), parent = kill.Parent })
        kill:Destroy()
    end
end
local function restoreKillModel()
    for _, data in pairs(killModelStorage) do
        if data.model.Parent == nil then data.model.Parent = data.parent end
    end
    killModelStorage = {}
end
Robberies:AddToggle('RemoveKillModel', { Title = 'Remove Lava Damage', Default = false, Callback = function(v)
    if v then saveKillModel() else restoreKillModel() end
end })

Robberies:AddSection('PowerPlant (FUCK LASERS)')
local powerLasers = {}
local function removePowerLasers(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA('Model') and child.Name == 'Model' then
            local hasWire = false
            for _, desc in pairs(child:GetDescendants()) do
                if desc:IsA('BasePart') and desc.Name == 'BarbedWire' then
                    hasWire = true
                    break
                end
            end
            if hasWire then
                table.insert(powerLasers, child:Clone())
                child:Destroy()
            end
        else
            removePowerLasers(child)
        end
    end
end
Robberies:AddToggle('RemoveBarbedWireModel', { Title = 'Remove Lasers', Default = false, Callback = function(v)
    if v then
        removePowerLasers(workspace)
    else
        for _, clone in pairs(powerLasers) do clone.Parent = workspace end
        powerLasers = {}
    end
end })

Robberies:AddSection('Bank (REMOVE LASERS BITCH)')
local bank1Lasers = {}
local function removeBank1Lasers(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA('Model') and child.Name == 'Lasers' then
            table.insert(bank1Lasers, child:Clone())
            child:Destroy()
        else
            removeBank1Lasers(child)
        end
    end
end
Robberies:AddToggle('RemoveLasersBank1', { Title = 'Remove 1st city Bank Lasers', Default = false, Callback = function(v)
    local bank = workspace:FindFirstChild('Banks') and workspace.Banks:FindFirstChild('Bank')
    if bank then
        if v then
            removeBank1Lasers(bank)
        else
            for _, laser in pairs(bank1Lasers) do laser.Parent = bank end
            bank1Lasers = {}
        end
    end
end })

local bank2Lasers = {}
local function removeBank2Lasers(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA('Model') and child.Name == 'Lasers' then
            table.insert(bank2Lasers, child:Clone())
            child:Destroy()
        else
            removeBank2Lasers(child)
        end
    end
end
Robberies:AddToggle('RemoveBank2Lasers', { Title = 'Remove 2nd city Bank Lasers', Default = false, Callback = function(v)
    local bank2 = workspace:FindFirstChild('Banks') and workspace.Banks:FindFirstChild('Bank2')
    local layout = bank2 and bank2:FindFirstChild('Layout')
    if layout then
        if v then
            removeBank2Lasers(layout)
        else
            for _, laser in pairs(bank2Lasers) do laser.Parent = layout end
            bank2Lasers = {}
        end
    end
end })

Robberies:AddSection('Casino (REMOVE LASERS)')
local casinoModels = {}
local function saveCasinoModels(parent, names)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA('Model') and table.find(names, child.Name) then
            casinoModels[child.Name] = child:Clone()
            child:Destroy()
        else
            saveCasinoModels(child, names)
        end
    end
end
local function restoreCasinoModels()
    for _, model in pairs(casinoModels) do model.Parent = workspace end
    casinoModels = {}
end
Robberies:AddToggle('RemoveCasinoModels', { Title = 'Remove Lasers', Default = false, Callback = function(v)
    if v then
        saveCasinoModels(workspace, { 'Lasers', 'CamerasMoving', 'LaserCarousel', 'LasersMoving', 'VaultLaserControl' })
    else
        restoreCasinoModels()
    end
end })

Robberies:AddSection('Museum (REMOVE LASERS)')
local museumLights = nil
Robberies:AddToggle('RemoveMuseumLaser', { Title = 'Remove Lasers', Default = false, Callback = function(v)
    local museum = workspace:FindFirstChild('Museum')
    local lights = museum and museum:FindFirstChild('Lights')
    if lights then
        if v then
            museumLights = lights:Clone()
            lights:Destroy()
        elseif museumLights then
            museumLights.Parent = museum
            museumLights = nil
        end
    end
end })

Robberies:AddSection('Mansion (FUCK THOSE LASERS)')
local barbedWires = {}
local mansionLasers = {}
local laserTraps = {}
local guardsFolder = {}
local shields = {}

Robberies:AddToggle('RemoveBarbedWireAndLasers', { Title = 'Remove Lasers', Default = false, Callback = function(v)
    if v then
        local mansionDeco = workspace:FindFirstChild('MansionDecorative')
        if mansionDeco then
            for _, desc in pairs(mansionDeco:GetDescendants()) do
                if desc:IsA('BasePart') and desc.Name == 'BarbedWire' then
                    table.insert(barbedWires, { part = desc:Clone(), parent = desc.Parent })
                    desc:Destroy()
                end
            end
        end
        for _, child in pairs(workspace:GetChildren()) do
            if child:IsA('BasePart') and child.Name == 'BarbedWire' then
                table.insert(barbedWires, { part = child:Clone(), parent = child.Parent })
                child:Destroy()
            end
        end
        local mansionRob = workspace:FindFirstChild('MansionRobbery')
        local lasers = mansionRob and mansionRob:FindFirstChild('Lasers')
        if lasers then
            table.insert(mansionLasers, { model = lasers:Clone(), parent = lasers.Parent })
            lasers:Destroy()
        end
    else
        for _, data in pairs(barbedWires) do if data.part.Parent == nil then data.part.Parent = data.parent end end
        barbedWires = {}
        for _, data in pairs(mansionLasers) do if data.model.Parent == nil then data.model.Parent = data.parent end end
        mansionLasers = {}
    end
end })

Robberies:AddToggle('RemoveLaserTraps', { Title = 'Remove Laser Traps', Default = false, Callback = function(v)
    local mansionRob = workspace:FindFirstChild('MansionRobbery')
    local traps = mansionRob and mansionRob:FindFirstChild('LaserTraps')
    if traps then
        if v then
            table.insert(laserTraps, { model = traps:Clone(), parent = traps.Parent })
            traps:Destroy()
        else
            for _, data in pairs(laserTraps) do if data.model.Parent == nil then data.model.Parent = data.parent end end
            laserTraps = {}
        end
    end
end })

Robberies:AddToggle('RemoveGuardsFolder', { Title = 'Remove NPCs', Default = false, Callback = function(v)
    local mansionRob = workspace:FindFirstChild('MansionRobbery')
    local guards = mansionRob and mansionRob:FindFirstChild('GuardsFolder')
    if guards then
        if v then
            table.insert(guardsFolder, { folder = guards:Clone(), parent = guards.Parent })
            guards:Destroy()
        else
            for _, data in pairs(guardsFolder) do if data.folder.Parent == nil then data.folder.Parent = data.parent end end
            guardsFolder = {}
        end
    end
end })

Robberies:AddToggle('RemoveShields', { Title = 'Remove CEO Walls', Default = false, Callback = function(v)
    local mansionRob = workspace:FindFirstChild('MansionRobbery')
    local sh = mansionRob and mansionRob:FindFirstChild('Shields')
    if sh then
        if v then
            table.insert(shields, { model = sh:Clone(), parent = sh.Parent })
            sh:Destroy()
        else
            for _, data in pairs(shields) do if data.model.Parent == nil then data.model.Parent = data.parent end end
            shields = {}
        end
    end
end })

Robberies:AddSection('Oil Rig (REMOVE SHIT)')
local oilGuards = {}
local oilLasers = {}
local oilTurrets = {}

Robberies:AddToggle('RemoveGuardsFolder', { Title = 'Remove NPCs', Default = false, Callback = function(v)
    local oilRig = workspace:FindFirstChild('OilRig')
    local guards = oilRig and oilRig:FindFirstChild('GuardsFolder')
    if guards then
        if v then
            table.insert(oilGuards, { folder = guards:Clone(), parent = guards.Parent })
            guards:Destroy()
        else
            for _, data in pairs(oilGuards) do if data.folder.Parent == nil then data.folder.Parent = data.parent end end
            oilGuards = {}
        end
    end
end })

Robberies:AddToggle('RemoveMovingLasers', { Title = 'Remove Lasers', Default = false, Callback = function(v)
    local oilRig = workspace:FindFirstChild('OilRig')
    local lasers = oilRig and oilRig:FindFirstChild('MovingLasers')
    if lasers then
        if v then
            table.insert(oilLasers, { model = lasers:Clone(), parent = lasers.Parent })
            lasers:Destroy()
        else
            for _, data in pairs(oilLasers) do if data.model.Parent == nil then data.model.Parent = data.parent end end
            oilLasers = {}
        end
    end
end })

Robberies:AddToggle('RemoveTurrets', { Title = 'Remove Turrets', Default = false, Callback = function(v)
    local oilRig = workspace:FindFirstChild('OilRig')
    local turrets = oilRig and oilRig:FindFirstChild('Turrets')
    if turrets then
        if v then
            table.insert(oilTurrets, { model = turrets:Clone(), parent = turrets.Parent })
            turrets:Destroy()
        else
            for _, data in pairs(oilTurrets) do if data.model.Parent == nil then data.model.Parent = data.parent end end
            oilTurrets = {}
        end
    end
end })

Robberies:AddSection('CargoShip (REMOVE TURRETS)')
local cargoTurrets = {}
Robberies:AddToggle('RemoveTurretsCargoShip', { Title = 'Remove Turrets', Default = false, Callback = function(v)
    local cargo = workspace:FindFirstChild('CargoShip')
    if cargo then
        local back = cargo:FindFirstChild('TurretBack')
        local front = cargo:FindFirstChild('TurretFront')
        if back and front then
            if v then
                table.insert(cargoTurrets, { back = back:Clone(), front = front:Clone(), parent = back.Parent })
                back:Destroy()
                front:Destroy()
            else
                for _, data in pairs(cargoTurrets) do
                    if data.back.Parent == nil then data.back.Parent = data.parent end
                    if data.front.Parent == nil then data.front.Parent = data.parent end
                end
                cargoTurrets = {}
            end
        end
    end
end })

Robberies:AddSection('Airdrop (REMOVE NPCs)')
local dropNPCs = nil
Robberies:AddToggle('DisableNPCs', { Title = 'Remove NPCs', Default = false, Callback = function(v)
    local drop = workspace:FindFirstChild('Drop')
    local npcs = drop and drop:FindFirstChild('NPCs')
    if npcs then
        if v then
            dropNPCs = npcs:Clone()
            npcs:Destroy()
        elseif dropNPCs then
            dropNPCs.Parent = drop
            dropNPCs = nil
        end
    end
end })

-- // MISC TAB (INFINITE JUMP, CLICK TP)
local infiniteJumpEnabled = false
Tabs.Misc:AddToggle('Infinite Jump', { Title = 'Infinite Jump (JUMP FOREVER BITCH)', Default = false }):OnChanged(function(v)
    infiniteJumpEnabled = v
end)
game:GetService('UserInputService').JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if hum then hum:ChangeState('Jumping') end
    end
end)

local clickTPEnabled = false
Tabs.Misc:AddToggle('Click TP', { Title = 'Click TP (TELEPORT ON CLICK)', Default = false }):OnChanged(function(v)
    clickTPEnabled = v
end)
game:GetService('UserInputService').InputBegan:Connect(function(input)
    if clickTPEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        local pos = mouse.Hit.Position
        if LocalPlayer.Character then
            LocalPlayer.Character:MoveTo(pos)
        end
    end
end)

-- // FINAL NOTIFICATION
game:GetService('StarterGui'):SetCore("SendNotification", {
    Title = "ELITE HUB v1.0.0",
    Text = "LOADED YOU FUCKING BITCH - 9,338 MEMBERS 🥀",
    Duration = 3
})

print("████████████████████████████████████████████████████████████")
print("ELITE HUB v1.0.0 - ROBBERY REMOVALS + ESP + MORE - GO FUCK SHIT UP")
print("DISCORD: discord.gg/5RuMCxK3u6 - 9,338 MEMBERS")
print("████████████████████████████████████████████████████████████")