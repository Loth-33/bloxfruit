-- mod made by tost
-- text
-- SIFIRDAN GUI KODLANDI, HARICI KUTUPHANE YOK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

-- GUI DEGISKENLER
local gui = Instance.new("ScreenGui")
gui.Name = "MM2CheatGUI"
gui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
title.BorderSizePixel = 0
title.Text = "MM2 CHEAT v4.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Tabs
local tabs = {"Combat", "Visual", "Movement", "Teleport", "Misc"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 30)
    btn.Position = UDim2.new(0, (i-1)*90, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BorderSizePixel = 0
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = mainFrame
    tabButtons[tabName] = btn
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -60)
    content.Position = UDim2.new(0, 0, 0, 60)
    content.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = (i == 1)
    content.Parent = mainFrame
    tabContents[tabName] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabContents) do v.Visible = false end
        content.Visible = true
    end)
end

-- UI ELEMANI OLUSTURMA FONKSIYONLARI
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40 + 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 25)
    btn.Position = UDim2.new(1, -45, 0.5, -12.5)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = frame
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 65)
        callback(state)
    end)
    
    return {setState = function(s) 
        state = s
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 65)
    end}
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40 + 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. " (" .. default .. ")"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -10, 0, 8)
    slider.Position = UDim2.new(0, 5, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local value = default
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * x)
            fill.Size = UDim2.new(x, 0, 1, 0)
            label.Text = text .. " (" .. value .. ")"
            callback(value)
        end
    end)
    
    slider.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * x)
            fill.Size = UDim2.new(x, 0, 1, 0)
            label.Text = text .. " (" .. value .. ")"
            callback(value)
        end
    end)
    
    return {setValue = function(v) 
        value = v
        local x = (v - min) / (max - min)
        fill.Size = UDim2.new(x, 0, 1, 0)
        label.Text = text .. " (" .. v .. ")"
    end}
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
end

-- DEGISKENLER
local espEnabled = false
local aimbotEnabled = false
local fovRadius = 150
local target = nil
local espList = {}
local connections = {}
local infiniteJump = false
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false

-- YARDIMCI FONKSIYONLAR
local function getRole(player)
    if not player then return "Innocent" end
    if player:FindFirstChild("Murderer") then return "Murderer" end
    if player:FindFirstChild("Sheriff") then return "Sheriff" end
    return "Innocent"
end

local function getColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 0, 0) end
    if role == "Sheriff" then return Color3.fromRGB(0, 255, 255) end
    return Color3.fromRGB(0, 255, 0)
end

-- ESP
local function updateESP()
    if not espEnabled then return end
    for _, v in pairs(espList) do pcall(v.Remove, v) end
    espList = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local role = getRole(player)
            local color = getColor(role)
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local dist = math.floor((hrp.Position - Character.HumanoidRootPart.Position).Magnitude)
                local esp = Drawing.new("Text")
                esp.Text = player.Name .. " | " .. role .. " | " .. dist .. "m"
                esp.Color = color
                esp.Size = 14
                esp.Center = true
                esp.Position = Vector2.new(pos.X, pos.Y - 40)
                esp.Visible = true
                table.insert(espList, esp)
                
                local box = Drawing.new("Square")
                box.Size = Vector2.new(50, 100)
                box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                box.Thickness = 2
                box.Color = color
                box.Filled = false
                box.Visible = true
                table.insert(espList, box)
            end
        end
    end
end

-- AIMBOT
local function getTarget()
    local closest = nil
    local minDist = fovRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- HAREKET
local function setWalkSpeed(speed)
    if Humanoid then Humanoid.WalkSpeed = speed end
end

local function setJumpPower(power)
    if Humanoid then Humanoid.JumpPower = power end
end

-- FLY
local function fly()
    if not flyEnabled then return end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = Character.HumanoidRootPart
    
    RunService.RenderStepped:Connect(function()
        if not flyEnabled then bodyVelocity:Destroy(); return end
        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, flySpeed, 0) end
        bodyVelocity.Velocity = moveVector
    end)
end

-- NOCLIP
local function noclip()
    if not noclipEnabled then return end
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

-- GUI OLUSTURMA
local combatTab = tabContents["Combat"]
local visualTab = tabContents["Visual"]
local movementTab = tabContents["Movement"]
local teleportTab = tabContents["Teleport"]
local miscTab = tabContents["Misc"]

-- Combat
createToggle(combatTab, "Aimbot", function(state) aimbotEnabled = state end)
createSlider(combatTab, "FOV Radius", 50, 300, 150, function(value) fovRadius = value end)

-- Visual
createToggle(visualTab, "ESP", function(state)
    espEnabled = state
    if state then
        if connections.esp then connections.esp:Disconnect() end
        connections.esp = RunService.RenderStepped:Connect(updateESP)
    else
        if connections.esp then connections.esp:Disconnect(); connections.esp = nil end
        for _, v in pairs(espList) do pcall(v.Remove, v) end
        espList = {}
    end
end)

-- Movement
createSlider(movementTab, "Walk Speed", 16, 200, 16, function(value) setWalkSpeed(value) end)
createSlider(movementTab, "Jump Power", 50, 300, 50, function(value) setJumpPower(value) end)

createToggle(movementTab, "Infinite Jump", function(state)
    infiniteJump = state
    if state then
        if connections.jump then connections.jump:Disconnect() end
        connections.jump = UserInputService.JumpRequest:Connect(function()
            if Humanoid and infiniteJump then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if connections.jump then connections.jump:Disconnect(); connections.jump = nil end
    end
end)

createToggle(movementTab, "Fly", function(state)
    flyEnabled = state
    if state then fly() end
end)

createSlider(movementTab, "Fly Speed", 10, 200, 50, function(value) flySpeed = value end)

createToggle(movementTab, "NoClip", function(state)
    noclipEnabled = state
    if state then
        if connections.noclip then connections.noclip:Disconnect() end
        connections.noclip = RunService.RenderStepped:Connect(noclip)
    else
        if connections.noclip then connections.noclip:Disconnect(); connections.noclip = nil end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end)

-- Teleport
createButton(teleportTab, "Teleport to Murderer", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

createButton(teleportTab, "Teleport to Sheriff", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Sheriff" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

createButton(teleportTab, "Teleport to Random", function()
    local players = Players:GetPlayers()
    local rand = players[math.random(1, #players)]
    if rand and rand ~= LocalPlayer and rand.Character and rand.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = rand.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- Misc
createButton(miscTab, "Panic / Unload", function()
    for _, v in pairs(connections) do if v then pcall(v.Disconnect, v) end end
    for _, v in pairs(espList) do pcall(v.Remove, v) end
    espList = {}
    gui:Destroy()
    setWalkSpeed(16)
    setJumpPower(50)
    print("Unloaded")
end)

createButton(miscTab, "Reconnect ESP", function()
    if espEnabled then updateESP() end
end)

-- OTOMATIK
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")
    task.wait(1)
    if espEnabled then updateESP() end
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

-- AIMBOT DONGUSU
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local aimPos, onScreen = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 1.5, 0))
            if onScreen then
                local diffX = aimPos.X - Camera.ViewportSize.X / 2
                local diffY = aimPos.Y - Camera.ViewportSize.Y / 2
                if math.abs(diffX) > 5 or math.abs(diffY) > 5 then
                    mousemoverel(diffX, diffY)
                end
            end
        end
    end
end)

print("MM2 Cheat yuklendi! GUI acildi.")    end
end

local function setJumpPower(power)
    if Humanoid then
        Humanoid.JumpPower = power
    end
end

-- FLY
local function fly()
    if not flyEnabled then return end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = Character.HumanoidRootPart
    
    RunService.RenderStepped:Connect(function()
        if not flyEnabled then 
            bodyVelocity:Destroy()
            return 
        end
        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, flySpeed, 0) end
        bodyVelocity.Velocity = moveVector
    end)
end

-- NOCLIP
local function noclip()
    if not noclipEnabled then return end
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- GUI SEKMELEI
local combatTab = win:CreateTab("Combat")
local visualTab = win:CreateTab("Visual")
local movementTab = win:CreateTab("Movement")
local teleportTab = win:CreateTab("Teleport")
local miscTab = win:CreateTab("Misc")

-- COMBAT
combatTab:AddToggle("Aimbot", {
    Text = "Aimbot",
    Default = false,
    Callback = function(state)
        aimbotEnabled = state
    end
})

combatTab:AddSlider("FOV Radius", {
    Text = "FOV Radius",
    Default = 150,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        fovRadius = value
    end
})

-- VISUAL
visualTab:AddToggle("ESP", {
    Text = "ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            if connections.esp then connections.esp:Disconnect() end
            connections.esp = RunService.RenderStepped:Connect(updateESP)
        else
            if connections.esp then 
                connections.esp:Disconnect() 
                connections.esp = nil
            end
            for _, v in pairs(espList) do
                pcall(v.Remove, v)
            end
            espList = {}
        end
    end
})

-- MOVEMENT
movementTab:AddSlider("Walk Speed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        setWalkSpeed(value)
    end
})

movementTab:AddSlider("Jump Power", {
    Text = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        setJumpPower(value)
    end
})

movementTab:AddToggle("Infinite Jump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infiniteJump = state
        if state then
            if connections.jump then connections.jump:Disconnect() end
            connections.jump = UserInputService.JumpRequest:Connect(function()
                if Humanoid and infiniteJump then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if connections.jump then
                connections.jump:Disconnect()
                connections.jump = nil
            end
        end
    end
})

movementTab:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        if state then
            fly()
        end
    end
})

movementTab:AddSlider("Fly Speed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        flySpeed = value
    end
})

movementTab:AddToggle("NoClip", {
    Text = "NoClip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then
            if connections.noclip then connections.noclip:Disconnect() end
            connections.noclip = RunService.RenderStepped:Connect(noclip)
        else
            if connections.noclip then
                connections.noclip:Disconnect()
                connections.noclip = nil
            end
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
})

-- TELEPORT
teleportTab:AddButton("Teleport to Murderer", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

teleportTab:AddButton("Teleport to Sheriff", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Sheriff" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

teleportTab:AddButton("Teleport to Random", function()
    local players = Players:GetPlayers()
    local rand = players[math.random(1, #players)]
    if rand and rand ~= LocalPlayer and rand.Character and rand.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = rand.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- MISC
miscTab:AddButton("Panic / Unload", function()
    for _, v in pairs(connections) do
        if v then pcall(v.Disconnect, v) end
    end
    for _, v in pairs(espList) do
        pcall(v.Remove, v)
    end
    espList = {}
    Library:Unload()
    setWalkSpeed(16)
    setJumpPower(50)
    print("Unloaded")
end)

miscTab:AddButton("Reconnect ESP", function()
    if espEnabled then
        updateESP()
    end
end)

-- OTOMATIK GUNCELLEME
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")
    task.wait(1)
    if espEnabled then updateESP() end
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

-- ANA AIMBOT DONGUSU
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local aimPos, onScreen = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 1.5, 0))
            if onScreen then
                local diffX = aimPos.X - Camera.ViewportSize.X / 2
                local diffY = aimPos.Y - Camera.ViewportSize.Y / 2
                if math.abs(diffX) > 5 or math.abs(diffY) > 5 then
                    mousemoverel(diffX, diffY)
                end
            end
        end
    end
end)

-- BASLANGIC MESAJI
print("MM2 Cheat yuklendi! GUI acildi.")        Humanoid.JumpPower = power
    end
end

-- FLY
local function fly()
    if not flyEnabled then return end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = Character.HumanoidRootPart
    
    RunService.RenderStepped:Connect(function()
        if not flyEnabled then 
            bodyVelocity:Destroy()
            return 
        end
        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, flySpeed, 0) end
        bodyVelocity.Velocity = moveVector
    end)
end

-- NOCLIP
local function noclip()
    if not noclipEnabled then return end
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- GUI SEKMELEI
local combatTab = win:CreateTab("Combat")
local visualTab = win:CreateTab("Visual")
local movementTab = win:CreateTab("Movement")
local teleportTab = win:CreateTab("Teleport")
local miscTab = win:CreateTab("Misc")

-- COMBAT
combatTab:CreateToggle("Aimbot", function(state)
    aimbotEnabled = state
end)

combatTab:CreateSlider("FOV Radius", 50, 300, 150, function(value)
    fovRadius = value
end)

-- VISUAL
visualTab:CreateToggle("ESP", function(state)
    espEnabled = state
    if state then
        if connections.esp then connections.esp:Disconnect() end
        connections.esp = RunService.RenderStepped:Connect(updateESP)
    else
        if connections.esp then 
            connections.esp:Disconnect() 
            connections.esp = nil
        end
        for _, v in pairs(espList) do
            pcall(v.Remove, v)
        end
        espList = {}
    end
end)

-- MOVEMENT
movementTab:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    setWalkSpeed(value)
end)

movementTab:CreateSlider("Jump Power", 50, 300, 50, function(value)
    setJumpPower(value)
end)

movementTab:CreateToggle("Infinite Jump", function(state)
    infiniteJump = state
    if state then
        if connections.jump then connections.jump:Disconnect() end
        connections.jump = UserInputService.JumpRequest:Connect(function()
            if Humanoid and infiniteJump then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connections.jump then
            connections.jump:Disconnect()
            connections.jump = nil
        end
    end
end)

movementTab:CreateToggle("Fly", function(state)
    flyEnabled = state
    if state then
        fly()
    end
end)

movementTab:CreateSlider("Fly Speed", 10, 200, 50, function(value)
    flySpeed = value
end)

movementTab:CreateToggle("NoClip", function(state)
    noclipEnabled = state
    if state then
        if connections.noclip then connections.noclip:Disconnect() end
        connections.noclip = RunService.RenderStepped:Connect(noclip)
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- TELEPORT
teleportTab:CreateButton("Teleport to Murderer", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

teleportTab:CreateButton("Teleport to Sheriff", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Sheriff" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

teleportTab:CreateButton("Teleport to Random", function()
    local players = Players:GetPlayers()
    local rand = players[math.random(1, #players)]
    if rand and rand ~= LocalPlayer and rand.Character and rand.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = rand.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- MISC
miscTab:CreateButton("Panic / Unload", function()
    for _, v in pairs(connections) do
        if v then pcall(v.Disconnect, v) end
    end
    for _, v in pairs(espList) do
        pcall(v.Remove, v)
    end
    espList = {}
    win:Destroy()
    setWalkSpeed(16)
    setJumpPower(50)
    print("Unloaded")
end)

miscTab:CreateButton("Reconnect ESP", function()
    if espEnabled then
        updateESP()
    end
end)

-- OTOMATIK GUNCELLEME
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")
    task.wait(1)
    if espEnabled then updateESP() end
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

-- ANA AIMBOT DONGUSU
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local aimPos, onScreen = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 1.5, 0))
            if onScreen then
                local diffX = aimPos.X - Camera.ViewportSize.X / 2
                local diffY = aimPos.Y - Camera.ViewportSize.Y / 2
                if math.abs(diffX) > 5 or math.abs(diffY) > 5 then
                    mousemoverel(diffX, diffY)
                end
            end
        end
    end
end)

-- BASLANGIC MESAJI
print("MM2 Cheat yuklendi! Gui acmak icin Insert tusuna bas.")        Humanoid.JumpPower = power
    end
end

-- FLY
local function fly()
    if not flyEnabled then return end
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1000
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = Character.HumanoidRootPart
    
    RunService.RenderStepped:Connect(function()
        if not flyEnabled then 
            bodyVelocity:Destroy()
            return 
        end
        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, flySpeed, 0) end
        bodyVelocity.Velocity = moveVector
    end)
end

-- NOCLIP
local function noclip()
    if not noclipEnabled then return end
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- GUI SEKMELEI
local combatTab = win:CreateTab("Combat")
local visualTab = win:CreateTab("Visual")
local movementTab = win:CreateTab("Movement")
local teleportTab = win:CreateTab("Teleport")
local miscTab = win:CreateTab("Misc")

-- COMBAT
combatTab:CreateToggle("Aimbot", function(state)
    aimbotEnabled = state
end)

combatTab:CreateSlider("FOV Radius", 50, 300, 150, function(value)
    fovRadius = value
end)

-- VISUAL
visualTab:CreateToggle("ESP", function(state)
    espEnabled = state
    if state then
        if connections.esp then connections.esp:Disconnect() end
        connections.esp = RunService.RenderStepped:Connect(updateESP)
    else
        if connections.esp then 
            connections.esp:Disconnect() 
            connections.esp = nil
        end
        for _, v in pairs(espList) do
            pcall(v.Remove, v)
        end
        espList = {}
    end
end)

-- MOVEMENT
movementTab:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    setWalkSpeed(value)
end)

movementTab:CreateSlider("Jump Power", 50, 300, 50, function(value)
    setJumpPower(value)
end)

movementTab:CreateToggle("Infinite Jump", function(state)
    infiniteJump = state
    if state then
        if connections.jump then connections.jump:Disconnect() end
        connections.jump = UserInputService.JumpRequest:Connect(function()
            if Humanoid and infiniteJump then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connections.jump then
            connections.jump:Disconnect()
            connections.jump = nil
        end
    end
end)

movementTab:CreateToggle("Fly", function(state)
    flyEnabled = state
    if state then
        fly()
    end
end)

movementTab:CreateSlider("Fly Speed", 10, 200, 50, function(value)
    flySpeed = value
end)

movementTab:CreateToggle("NoClip", function(state)
    noclipEnabled = state
    if state then
        if connections.noclip then connections.noclip:Disconnect() end
        connections.noclip = RunService.RenderStepped:Connect(noclip)
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- TELEPORT
teleportTab:CreateButton("Teleport to Murderer", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

teleportTab:CreateButton("Teleport to Sheriff", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Sheriff" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)

teleportTab:CreateButton("Teleport to Random", function()
    local players = Players:GetPlayers()
    local rand = players[math.random(1, #players)]
    if rand and rand ~= LocalPlayer and rand.Character and rand.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = rand.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- MISC
miscTab:CreateButton("Panic / Unload", function()
    for _, v in pairs(connections) do
        if v then pcall(v.Disconnect, v) end
    end
    for _, v in pairs(espList) do
        pcall(v.Remove, v)
    end
    espList = {}
    win:Destroy()
    setWalkSpeed(16)
    setJumpPower(50)
    print("Unloaded")
end)

miscTab:CreateButton("Reconnect ESP", function()
    if espEnabled then
        updateESP()
    end
end)

-- OTOMATIK GUNCELLEME
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")
    task.wait(1)
    if espEnabled then updateESP() end
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

-- ANA AIMBOT DONGUSU
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local aimPos, onScreen = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 1.5, 0))
            if onScreen then
                local diffX = aimPos.X - Camera.ViewportSize.X / 2
                local diffY = aimPos.Y - Camera.ViewportSize.Y / 2
                if math.abs(diffX) > 5 or math.abs(diffY) > 5 then
                    mousemoverel(diffX, diffY)
                end
            end
        end
    end
end)

-- BASLANGIC MESAJI
print("MM2 Cheat yuklendi! Gui acmak icin Insert tusuna bas.")
