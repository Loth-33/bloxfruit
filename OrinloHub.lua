-- mod made by tost
-- text
-- HATA AYIKLAMA EKLENDI, GUI KONTROL EDILDI, FONKSIYONLAR TAMIR EDILDI

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/6lue/misc/main/UI"))()
local win = Library:CreateWindow("MM2 CHEAT v3.0", Vector2.new(500, 500))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

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

-- ESP GUNCELLEME
local function updateESP()
    if not espEnabled then return end
    for _, v in pairs(espList) do
        pcall(v.Remove, v)
    end
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

-- AIMBOT HEDEF BULMA
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
    if Humanoid then
        Humanoid.WalkSpeed = speed
    end
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
