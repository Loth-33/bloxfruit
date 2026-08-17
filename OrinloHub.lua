-- Blox Fruits Orinlo Full GUI v3
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local teleportService = game:GetService("TeleportService")
local tweenService = game:GetService("TweenService")
local virtualInput = game:GetService("VirtualInputManager")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
title.Text = "ORINLO HUB - BLOX FRUITS [FULL]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
scroll.ScrollBarThickness = 8
scroll.Parent = mainFrame

local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.new(0.2, 0.2, 0.3)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 15
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, yPos, default)
    local state = default or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = state and Color3.new(0, 0.6, 0) or Color3.new(0.3, 0.1, 0.1)
    btn.Text = text .. (state and " [ON]" or " [OFF]")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 15
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0, 0.6, 0) or Color3.new(0.3, 0.1, 0.1)
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
    return btn
end

-- Variables
local autoFarmEnabled = false
local autoSeaEnabled = false
local espEnabled = false
local aimbotEnabled = false
local flyEnabled = false
local autoGun = false
local autoStats = false
local teleportToIsland = false
local autoRaid = false
local autoBoss = false
local autoChest = false
local autoFruit = false
local autoDungeon = false
local autoPvp = false
local speedValue = 16
local jumpValue = 50
local flySpeed = 50

-- Combat
local function equipBestWeapon()
    local inventory = player.Backpack
    local weapons = {"Sword", "Blade", "Katana", "Saber", "Trident", "Pole"}
    for _, name in pairs(weapons) do
        for _, item in pairs(inventory:GetChildren()) do
            if item.Name:find(name) then
                player.Character:FindFirstChild("Humanoid"):EquipTool(item)
                return
            end
        end
    end
end

-- Auto Farm
createToggle("Auto Farm Level", 10, false, function(state)
    autoFarmEnabled = state
    if state then
        spawn(function()
            while autoFarmEnabled do
                wait(0.05)
                local target = nil
                local dist = math.huge
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (rootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if d < dist then
                            dist = d
                            target = v
                        end
                    end
                end
                if target then
                    rootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    virtualInput:SendKeyEvent(true, "Q", false, nil)
                    wait(0.1)
                    virtualInput:SendKeyEvent(false, "Q", false, nil)
                    virtualInput:SendKeyEvent(true, "R", false, nil)
                    wait(0.1)
                    virtualInput:SendKeyEvent(false, "R", false, nil)
                    if target.Humanoid.Health <= 0 then
                        wait(0.5)
                    end
                end
            end
        end)
    end
end)

-- Auto Sea Beast
createToggle("Auto Sea Beast", 50, false, function(state)
    autoSeaEnabled = state
    if state then
        spawn(function()
            while autoSeaEnabled do
                wait(0.1)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("SeaBeast") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, -20)
                        equipBestWeapon()
                        virtualInput:SendKeyEvent(true, "Q", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "Q", false, nil)
                    end
                end
            end
        end)
    end
end)

-- ESP
createToggle("ESP Players/Fruits/Chests", 90, false, function(state)
    espEnabled = state
    if state then
        spawn(function()
            while espEnabled do
                wait(0.5)
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
            end
        end)
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") then v:Destroy() end
        end
    end
end)

-- Aimbot
createToggle("Aimbot (Auto Aim)", 130, false, function(state)
    aimbotEnabled = state
    if state then
        spawn(function()
            while aimbotEnabled do
                wait(0.05)
                local target = nil
                local dist = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (rootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist and d < 150 then
                            dist = d
                            target = v.Character.HumanoidRootPart
                        end
                    end
                end
                if target then
                    rootPart.CFrame = CFrame.new(rootPart.Position, target.Position)
                    virtualInput:SendKeyEvent(true, "Q", false, nil)
                    wait(0.05)
                    virtualInput:SendKeyEvent(false, "Q", false, nil)
                end
            end
        end)
    end
end)

-- Fly
createToggle("Fly (Space to ascend)", 170, false, function(state)
    flyEnabled = state
    if state then
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
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    bv.Velocity = Vector3.new(0, flySpeed, 0)
                end
                local move = Vector3.new(0, 0, 0)
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    move = move + rootPart.CFrame.LookVector * flySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    move = move - rootPart.CFrame.LookVector * flySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    move = move - rootPart.CFrame.RightVector * flySpeed
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    move = move + rootPart.CFrame.RightVector * flySpeed
                end
                bv.Velocity = bv.Velocity + move * 2
            end
        end)
    else
        if rootPart:FindFirstChild("BodyVelocity") then rootPart.BodyVelocity:Destroy() end
        if rootPart:FindFirstChild("BodyGyro") then rootPart.BodyGyro:Destroy() end
    end
end)

-- Speed
createButton("Speed x2 (Walkspeed)", 210, Color3.new(0.2, 0.4, 0.2), function()
    humanoid.WalkSpeed = 32
end)
createButton("Speed x5", 248, Color3.new(0.2, 0.4, 0.2), function()
    humanoid.WalkSpeed = 80
end)
createButton("Speed x10", 286, Color3.new(0.2, 0.4, 0.2), function()
    humanoid.WalkSpeed = 160
end)
createButton("Reset Speed", 324, Color3.new(0.4, 0.2, 0.2), function()
    humanoid.WalkSpeed = 16
end)

-- Jump
createButton("Jump x2", 362, Color3.new(0.2, 0.4, 0.2), function()
    humanoid.JumpPower = 100
end)
createButton("Jump x5", 400, Color3.new(0.2, 0.4, 0.2), function()
    humanoid.JumpPower = 250
end)
createButton("Jump x10", 438, Color3.new(0.2, 0.4, 0.2), function()
    humanoid.JumpPower = 500
end)
createButton("Reset Jump", 476, Color3.new(0.4, 0.2, 0.2), function()
    humanoid.JumpPower = 50
end)

-- Teleports
createButton("Teleport to Jungle", 514, Color3.new(0.1, 0.3, 0.5), function()
    rootPart.CFrame = CFrame.new(-1464, 35, 2116)
end)
createButton("Teleport to Ice Island", 552, Color3.new(0.1, 0.3, 0.5), function()
    rootPart.CFrame = CFrame.new(3660, 20, -1520)
end)
createButton("Teleport to Sky Island", 590, Color3.new(0.1, 0.3, 0.5), function()
    rootPart.CFrame = CFrame.new(-4840, 800, -1540)
end)
createButton("Teleport to Sea of Treats", 628, Color3.new(0.1, 0.3, 0.5), function()
    rootPart.CFrame = CFrame.new(2400, 30, 3600)
end)
createButton("Teleport to Raid Island", 666, Color3.new(0.1, 0.3, 0.5), function()
    rootPart.CFrame = CFrame.new(-5320, 100, -1120)
end)
createButton("Teleport to Ship (Factory)", 704, Color3.new(0.1, 0.3, 0.5), function()
    rootPart.CFrame = CFrame.new(2840, 15, -240)
end)

-- Auto Boss
createToggle("Auto Farm Bosses", 742, false, function(state)
    autoBoss = state
    if state then
        spawn(function()
            while autoBoss do
                wait(0.1)
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name:find("Boss") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        equipBestWeapon()
                        virtualInput:SendKeyEvent(true, "Q", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "Q", false, nil)
                        virtualInput:SendKeyEvent(true, "R", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "R", false, nil)
                    end
                end
            end
        end)
    end
end)

-- Auto Chest
createToggle("Auto Collect Chests", 780, false, function(state)
    autoChest = state
    if state then
        spawn(function()
            while autoChest do
                wait(0.3)
                for _, v in pairs(workspace:GetChildren()) do
                    if (v.Name:find("Chest") or v.Name:find("Barrel")) then
                        rootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                        wait(0.2)
                    end
                end
            end
        end)
    end
end)

-- Auto Fruit (spawn)
createToggle("Auto Find Fruit", 818, false, function(state)
    autoFruit = state
    if state then
        spawn(function()
            while autoFruit do
                wait(0.5)
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:find("Fruit") then
                        rootPart.CFrame = v.Handle.CFrame * CFrame.new(0, 2, 0)
                        wait(0.3)
                        virtualInput:SendKeyEvent(true, "E", false, nil)
                        wait(0.2)
                        virtualInput:SendKeyEvent(false, "E", false, nil)
                    end
                end
            end
        end)
    end
end)

-- Auto Raid
createToggle("Auto Raid (Enter & Kill)", 856, false, function(state)
    autoRaid = state
    if state then
        spawn(function()
            while autoRaid do
                wait(0.1)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Raid") and v:FindFirstChild("Humanoid") then
                        rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        equipBestWeapon()
                        virtualInput:SendKeyEvent(true, "Q", false, nil)
                        wait(0.1)
                        virtualInput:SendKeyEvent(false, "Q", false, nil)
                    end
                end
                -- Auto enter portal
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Portal") or v.Name:find("Gate") then
                        rootPart.CFrame = v.CFrame * CFrame.new(0, 0, -2)
                        wait(0.2)
                    end
                end
            end
        end)
    end
end)

-- Auto Dungeon
createToggle("Auto Dungeon", 894, false, function(state)
    autoDungeon = state
    if state then
        spawn(function()
            while autoDungeon do
                wait(0.1)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Dungeon") and v:FindFirstChild("Humanoid") then
                        rootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        equipBestWeapon()
                        virtualInput:SendKeyEvent(true, "Q", false, nil)
                        wait(0.1)
                        virtualInput:SendKeyEvent(false, "Q", false, nil)
                    end
                end
            end
        end)
    end
end)

-- Auto PvP (target nearest)
createToggle("Auto PvP (Nearest)", 932, false, function(state)
    autoPvp = state
    if state then
        spawn(function()
            while autoPvp do
                wait(0.05)
                local target = nil
                local dist = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (rootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist and d < 200 then
                            dist = d
                            target = v.Character
                        end
                    end
                end
                if target then
                    rootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                    equipBestWeapon()
                    virtualInput:SendKeyEvent(true, "Q", false, nil)
                    wait(0.1)
                    virtualInput:SendKeyEvent(false, "Q", false, nil)
                end
            end
        end)
    end
end)

-- Auto Stats (put in melee/defense)
createToggle("Auto Stat Allocation", 970, false, function(state)
    autoStats = state
    if state then
        spawn(function()
            while autoStats do
                wait(1)
                local args = {[1] = "Melee", [2] = 1}
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                args = {[1] = "Defense", [2] = 1}
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end)
    end
end)

-- Godmode (fake - anti stun)
createButton("Anti Stun / No Knockback", 1008, Color3.new(0.5, 0, 0.5), function()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    player.Character.HumanoidRootPart.Anchored = false
end)

-- Reset Character
createButton("RESET CHARACTER", 1046, Color3.new(0.6, 0, 0), function()
    player.Character:BreakJoints()
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
