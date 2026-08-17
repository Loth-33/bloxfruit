-- Blox Fruits Orinlo X GUI v4 (Full Working)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local virtualInput = game:GetService("VirtualInputManager")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Services
local lp = player
local rs = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")

-- GUI (Modern Dark Theme)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 650)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("UICorner")
shadow.CornerRadius = UDim.new(0, 12)
shadow.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
titleBar.BackgroundTransparency = 0.2
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ORINLO X - BLOX FRUITS"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.6, 0.1, 0.1)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
tabFrame.BackgroundTransparency = 0.3
tabFrame.Parent = mainFrame

local tabs = {}
local currentTab = nil

local function createTab(text, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundTransparency = 0.8
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = tabFrame
    return btn
end

local tab1 = createTab("Combat", "⚔️")
tab1.Position = UDim2.new(0, 5, 0, 0)
local tab2 = createTab("Movement", "🚀")
tab2.Position = UDim2.new(0, 110, 0, 0)
local tab3 = createTab("ESP/Teleport", "👁️")
tab3.Position = UDim2.new(0, 215, 0, 0)
local tab4 = createTab("Misc", "⚙️")
tab4.Position = UDim2.new(0, 320, 0, 0)

-- Content container
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -85)
contentFrame.Position = UDim2.new(0, 5, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.new(0.3, 0.3, 0.5)
scroll.Parent = contentFrame

local function createCategory(parent, titleText, yPos)
    local cat = Instance.new("Frame")
    cat.Size = UDim2.new(1, 0, 0, 30)
    cat.Position = UDim2.new(0, 0, 0, yPos)
    cat.BackgroundTransparency = 0.8
    cat.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = titleText
    lbl.TextColor3 = Color3.new(0.6, 0.8, 1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cat
    
    return cat
end

local function createButton(parent, text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.new(0.2, 0.2, 0.3)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local function createToggle(parent, text, yPos, default, callback)
    local state = default or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = state and Color3.new(0, 0.6, 0.3) or Color3.new(0.25, 0.15, 0.15)
    btn.Text = text .. (state and " ✅" or " ❌")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0, 0.6, 0.3) or Color3.new(0.25, 0.15, 0.15)
        btn.Text = text .. (state and " ✅" or " ❌")
        callback(state)
    end)
    return btn, function() return state end
end

-- Variables
local autoFarm = false
local autoSea = false
local autoBoss = false
local autoChest = false
local autoFruit = false
local autoRaid = false
local autoPvp = false
local espEnabled = false
local aimbotEnabled = false
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local noClipEnabled = false
local antiStun = false

-- Combat functions
local function getClosestEnemy()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (rootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist and d < 300 then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (rootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist and d < 200 then
                dist = d
                closest = v.Character
            end
        end
    end
    return closest
end

-- Tabs content
local yPos = 5

-- Tab 1: Combat
createCategory(scroll, "⚔️ AUTO FARM", yPos)
yPos = yPos + 35

local farmToggle, getFarm = createToggle(scroll, "Auto Farm Level", yPos, false, function(s)
    autoFarm = s
    if s then
        spawn(function()
            while autoFarm do
                local target = getClosestEnemy()
                if target then
                    rootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    virtualInput:SendKeyEvent(true, "Q", false, nil)
                    wait(0.1)
                    virtualInput:SendKeyEvent(false, "Q", false, nil)
                    virtualInput:SendKeyEvent(true, "R", false, nil)
                    wait(0.1)
                    virtualInput:SendKeyEvent(false, "R", false, nil)
                end
                wait(0.05)
            end
        end)
    end
end)
yPos = yPos + 40

local seaToggle = createToggle(scroll, "Auto Sea Beast", yPos, false, function(s)
    autoSea = s
    if s then
        spawn(function()
            while autoSea do
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("SeaBeast") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, -25)
                        virtualInput:SendKeyEvent(true, "Q", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "Q", false, nil)
                    end
                end
                wait(0.1)
            end
        end)
    end
end)
yPos = yPos + 40

local bossToggle = createToggle(scroll, "Auto Boss Farm", yPos, false, function(s)
    autoBoss = s
    if s then
        spawn(function()
            while autoBoss do
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name:find("Boss") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        virtualInput:SendKeyEvent(true, "Q", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "Q", false, nil)
                        virtualInput:SendKeyEvent(true, "R", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "R", false, nil)
                    end
                end
                wait(0.1)
            end
        end)
    end
end)
yPos = yPos + 40

createToggle(scroll, "Auto PvP (Nearest)", yPos, false, function(s)
    autoPvp = s
    if s then
        spawn(function()
            while autoPvp do
                local target = getClosestPlayer()
                if target then
                    rootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                    virtualInput:SendKeyEvent(true, "Q", false, nil)
                    wait(0.1)
                    virtualInput:SendKeyEvent(false, "Q", false, nil)
                end
                wait(0.05)
            end
        end)
    end
end)
yPos = yPos + 40

createToggle(scroll, "Aimbot (Auto Aim)", yPos, false, function(s)
    aimbotEnabled = s
    if s then
        spawn(function()
            while aimbotEnabled do
                local target = getClosestPlayer()
                if target then
                    rootPart.CFrame = CFrame.new(rootPart.Position, target.HumanoidRootPart.Position)
                end
                wait(0.05)
            end
        end)
    end
end)
yPos = yPos + 45

-- Tab 2: Movement (will be filled when tab switched)
-- We'll create all content but hide/show based on tab

-- Store all tab content in tables
local tabContents = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {}
}

-- We'll rebuild with proper tab switching
-- For simplicity, clear scroll and rebuild on tab click

local function switchTab(tabIndex)
    for _, child in pairs(scroll:GetChildren()) do
        child:Destroy()
    end
    yPos = 5
    
    if tabIndex == 1 then
        -- Combat
        createCategory(scroll, "⚔️ AUTO FARM", yPos)
        yPos = yPos + 35
        local t1, _ = createToggle(scroll, "Auto Farm Level", yPos, false, function(s) autoFarm = s end)
        yPos = yPos + 40
        createToggle(scroll, "Auto Sea Beast", yPos, false, function(s) autoSea = s end)
        yPos = yPos + 40
        createToggle(scroll, "Auto Boss Farm", yPos, false, function(s) autoBoss = s end)
        yPos = yPos + 40
        createToggle(scroll, "Auto PvP", yPos, false, function(s) autoPvp = s end)
        yPos = yPos + 40
        createToggle(scroll, "Aimbot", yPos, false, function(s) aimbotEnabled = s end)
        yPos = yPos + 45
        createButton(scroll, "Equip Best Weapon", yPos, Color3.new(0.2, 0.4, 0.6), function()
            local weapons = {"Sword", "Blade", "Katana", "Saber", "Trident", "Pole", "Dual", "Dragon"}
            for _, name in pairs(weapons) do
                for _, item in pairs(player.Backpack:GetChildren()) do
                    if item.Name:find(name) then
                        humanoid:EquipTool(item)
                        return
                    end
                end
            end
        end)
        
    elseif tabIndex == 2 then
        -- Movement
        createCategory(scroll, "🚀 MOVEMENT", yPos)
        yPos = yPos + 35
        createToggle(scroll, "Fly (Space Up)", yPos, false, function(s)
            flyEnabled = s
            if s then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(10000, 10000, 10000)
                bv.Parent = rootPart
                local bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(10000, 10000, 10000)
                bg.Parent = rootPart
                spawn(function()
                    while flyEnabled do
                        wait(0.05)
                        bv.Velocity = Vector3.new(0, 0, 0)
                        if userInput:IsKeyDown(Enum.KeyCode.Space) then
                            bv.Velocity = Vector3.new(0, 50, 0)
                        end
                        local move = Vector3.new(0, 0, 0)
                        if userInput:IsKeyDown(Enum.KeyCode.W) then
                            move = move + rootPart.CFrame.LookVector * 50
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.S) then
                            move = move - rootPart.CFrame.LookVector * 50
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.A) then
                            move = move - rootPart.CFrame.RightVector * 50
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.D) then
                            move = move + rootPart.CFrame.RightVector * 50
                        end
                        bv.Velocity = bv.Velocity + move * 2
                    end
                end)
            else
                if rootPart:FindFirstChild("BodyVelocity") then rootPart.BodyVelocity:Destroy() end
                if rootPart:FindFirstChild("BodyGyro") then rootPart.BodyGyro:Destroy() end
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "No Clip (Walk through walls)", yPos, false, function(s)
            noClipEnabled = s
            if s then
                rootPart.CanCollide = false
            else
                rootPart.CanCollide = true
            end
        end)
        yPos = yPos + 40
        createButton(scroll, "Speed x2", yPos, Color3.new(0.2, 0.5, 0.2), function() humanoid.WalkSpeed = 32 end)
        yPos = yPos + 40
        createButton(scroll, "Speed x5", yPos, Color3.new(0.2, 0.5, 0.2), function() humanoid.WalkSpeed = 80 end)
        yPos = yPos + 40
        createButton(scroll, "Speed x10", yPos, Color3.new(0.2, 0.5, 0.2), function() humanoid.WalkSpeed = 160 end)
        yPos = yPos + 40
        createButton(scroll, "Reset Speed", yPos, Color3.new(0.5, 0.2, 0.2), function() humanoid.WalkSpeed = 16 end)
        yPos = yPos + 40
        createButton(scroll, "Jump x2", yPos, Color3.new(0.2, 0.5, 0.2), function() humanoid.JumpPower = 100 end)
        yPos = yPos + 40
        createButton(scroll, "Jump x5", yPos, Color3.new(0.2, 0.5, 0.2), function() humanoid.JumpPower = 250 end)
        yPos = yPos + 40
        createButton(scroll, "Reset Jump", yPos, Color3.new(0.5, 0.2, 0.2), function() humanoid.JumpPower = 50 end)
        
    elseif tabIndex == 3 then
        -- ESP/Teleport
        createCategory(scroll, "👁️ ESP", yPos)
        yPos = yPos + 35
        createToggle(scroll, "ESP Players (Red)", yPos, false, function(s)
            espEnabled = s
            if s then
                spawn(function()
                    while espEnabled do
                        for _, v in pairs(game.Players:GetPlayers()) do
                            if v ~= player and v.Character then
                                local hl = v.Character:FindFirstChild("Highlight")
                                if not hl then
                                    hl = Instance.new("Highlight")
                                    hl.Parent = v.Character
                                    hl.FillColor = Color3.new(1, 0, 0)
                                    hl.OutlineColor = Color3.new(1, 1, 1)
                                end
                            end
                        end
                        wait(0.5)
                    end
                end)
            else
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Highlight") then v:Destroy() end
                end
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "ESP Fruits (Green)", yPos, false, function(s)
            if s then
                spawn(function()
                    while espEnabled do
                        for _, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:find("Fruit") then
                                local hl = v:FindFirstChild("Highlight")
                                if not hl then
                                    hl = Instance.new("Highlight")
                                    hl.Parent = v
                                    hl.FillColor = Color3.new(0, 1, 0)
                                    hl.OutlineColor = Color3.new(1, 1, 1)
                                end
                            end
                        end
                        wait(0.5)
                    end
                end)
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "ESP Chests (Yellow)", yPos, false, function(s)
            if s then
                spawn(function()
                    while espEnabled do
                        for _, v in pairs(workspace:GetChildren()) do
                            if v.Name:find("Chest") or v.Name:find("Barrel") then
                                local hl = v:FindFirstChild("Highlight")
                                if not hl then
                                    hl = Instance.new("Highlight")
                                    hl.Parent = v
                                    hl.FillColor = Color3.new(1, 1, 0)
                                    hl.OutlineColor = Color3.new(1, 1, 1)
                                end
                            end
                        end
                        wait(0.5)
                    end
                end)
            end
        end)
        yPos = yPos + 45
        
        createCategory(scroll, "📡 TELEPORTS", yPos)
        yPos = yPos + 35
        createButton(scroll, "Jungle", yPos, Color3.new(0.1, 0.3, 0.5), function() rootPart.CFrame = CFrame.new(-1464, 35, 2116) end)
        yPos = yPos + 40
        createButton(scroll, "Ice Island", yPos, Color3.new(0.1, 0.3, 0.5), function() rootPart.CFrame = CFrame.new(3660, 20, -1520) end)
        yPos = yPos + 40
        createButton(scroll, "Sky Island", yPos, Color3.new(0.1, 0.3, 0.5), function() rootPart.CFrame = CFrame.new(-4840, 800, -1540) end)
        yPos = yPos + 40
        createButton(scroll, "Sea of Treats", yPos, Color3.new(0.1, 0.3, 0.5), function() rootPart.CFrame = CFrame.new(2400, 30, 3600) end)
        yPos = yPos + 40
        createButton(scroll, "Raid Island", yPos, Color3.new(0.1, 0.3, 0.5), function() rootPart.CFrame = CFrame.new(-5320, 100, -1120) end)
        yPos = yPos + 40
        createButton(scroll, "Factory/Ship", yPos, Color3.new(0.1, 0.3, 0.5), function() rootPart.CFrame = CFrame.new(2840, 15, -240) end)
        
    elseif tabIndex == 4 then
        -- Misc
        createCategory(scroll, "⚙️ MISC", yPos)
        yPos = yPos + 35
        createToggle(scroll, "Auto Collect Chests", yPos, false, function(s)
            autoChest = s
            if s then
                spawn(function()
                    while autoChest do
                        for _, v in pairs(workspace:GetChildren()) do
                            if v.Name:find("Chest") or v.Name:find("Barrel") then
                                rootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                                wait(0.2)
                            end
                        end
                        wait(0.3)
                    end
                end)
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "Auto Find Fruit", yPos, false, function(s)
            autoFruit = s
            if s then
                spawn(function()
                    while autoFruit do
                        for _, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:find("Fruit") then
                                rootPart.CFrame = v.Handle.CFrame * CFrame.new(0, 2, 0)
                                wait(0.3)
                                virtualInput:SendKeyEvent(true, "E", false, nil)
                                wait(0.2)
                                virtualInput:SendKeyEvent(false, "E", false, nil)
                            end
                        end
                        wait(0.5)
                    end
                end)
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "Auto Raid (Enter & Kill)", yPos, false, function(s)
            autoRaid = s
            if s then
                spawn(function()
                    while autoRaid do
                        for _, v in pairs(workspace:GetChildren()) do
                            if v.Name:find("Raid") and v:FindFirstChild("Humanoid") then
                                rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                                virtualInput:SendKeyEvent(true, "Q", false, nil)
                                wait(0.1)
                                virtualInput:SendKeyEvent(false, "Q", false, nil)
                            end
                            if v.Name:find("Portal") or v.Name:find("Gate") then
                                rootPart.CFrame = v.CFrame * CFrame.new(0, 0, -2)
                                wait(0.2)
                            end
                        end
                        wait(0.1)
                    end
                end)
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "Auto Stat Allocation", yPos, false, function(s)
            if s then
                spawn(function()
                    while s do
                        wait(1)
                        local args = {[1] = "Melee", [2] = 1}
                        rs.Remotes.CommF_:InvokeServer(unpack(args))
                        args = {[1] = "Defense", [2] = 1}
                        rs.Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end)
            end
        end)
        yPos = yPos + 40
        createToggle(scroll, "Anti Stun / No Knockback", yPos, false, function(s)
            antiStun = s
            if s then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            else
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end)
        yPos = yPos + 45
        createButton(scroll, "RESET CHARACTER", yPos, Color3.new(0.6, 0, 0), function()
            player.Character:BreakJoints()
        end)
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
end

-- Tab click events
tab1.MouseButton1Click:Connect(function() switchTab(1) end)
tab2.MouseButton1Click:Connect(function() switchTab(2) end)
tab3.MouseButton1Click:Connect(function() switchTab(3) end)
tab4.MouseButton1Click:Connect(function() switchTab(4) end)

-- Load default tab
switchTab(1)

-- Auto-update ESP highlight removal when toggled off
game:GetService("RunService").Heartbeat:Connect(function()
    if not espEnabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Parent ~= player.Character then
                v:Destroy()
            end
        end
    end
end)
