-- mod made by tost
-- text
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/6lue/misc/main/UI"))()
local win = Library:CreateWindow("MM2 CHEAT v3.0", Vector2.new(500, 500))

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

-- Core Variables
local espEnabled = false
local aimbotEnabled = false
local fovRadius = 150
local target = nil
local espList = {}
local connections = {}

-- Utility Functions
local function getRole(player)
    local role = "Innocent"
    if player:FindFirstChild("Murderer") then role = "Murderer"
    elseif player:FindFirstChild("Sheriff") then role = "Sheriff" end
    return role
end

local function getColor(role)
    local colors = {Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,255,255), Innocent = Color3.fromRGB(0,255,0)}
    return colors[role] or Color3.fromRGB(255,255,255)
end

-- ESP System
local function updateESP()
    if not espEnabled then return end
    for _, v in pairs(espList) do v:Remove() end
    espList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local role = getRole(player)
            local color = getColor(role)
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local esp = Drawing.new("Text")
                esp.Text = player.Name .. " | " .. role .. " | " .. math.floor((hrp.Position - Character.HumanoidRootPart.Position).Magnitude) .. "m"
                esp.Color = color
                esp.Size = 14
                esp.Center = true
                esp.Position = Vector2.new(pos.X, pos.Y - 30)
                table.insert(espList, esp)
                
                local box = Drawing.new("Square")
                box.Size = Vector2.new(50, 100)
                box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                box.Thickness = 1
                box.Color = color
                box.Filled = false
                table.insert(espList, box)
                
                local tracer = Drawing.new("Line")
                tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)
                tracer.Color = color
                tracer.Thickness = 1
                table.insert(espList, tracer)
            end
        end
    end
end

-- Aimbot System
local function getTarget()
    local closest = nil
    local minDist = fovRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
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

-- Movement Mods
local function setWalkSpeed(speed)
    if Humanoid then Humanoid.WalkSpeed = speed end
end

local function setJumpPower(power)
    if Humanoid then Humanoid.JumpPower = power end
end

-- GUI Tabs
local combatTab = win:CreateTab("Combat")
local visualTab = win:CreateTab("Visual")
local movementTab = win:CreateTab("Movement")
local teleportTab = win:CreateTab("Teleport")
local miscTab = win:CreateTab("Misc")

-- Combat Tab
combatTab:CreateToggle("Aimbot", function(state)
    aimbotEnabled = state
end)

combatTab:CreateSlider("FOV Radius", 50, 300, 150, function(value)
    fovRadius = value
end)

-- Visual Tab
visualTab:CreateToggle("ESP", function(state)
    espEnabled = state
    if state then
        connections.esp = RunService.RenderStepped:Connect(updateESP)
    else
        if connections.esp then connections.esp:Disconnect() end
        for _, v in pairs(espList) do v:Remove() end
        espList = {}
    end
end)

-- Movement Tab
movementTab:CreateSlider("Walk Speed", 16, 100, 16, function(value)
    setWalkSpeed(value)
end)

movementTab:CreateSlider("Jump Power", 50, 200, 50, function(value)
    setJumpPower(value)
end)

movementTab:CreateToggle("Infinite Jump", function(state)
    if state then
        connections.jump = UserInputService.JumpRequest:Connect(function()
            if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if connections.jump then connections.jump:Disconnect() end
    end
end)

-- Teleport Tab
teleportTab:CreateButton("Teleport to Murderer", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Murderer" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            break
        end
    end
end)

teleportTab:CreateButton("Teleport to Sheriff", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Sheriff" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            break
        end
    end
end)

-- Misc Tab
miscTab:CreateButton("Panic / Unload", function()
    for _, v in pairs(connections) do
        if v then pcall(v.Disconnect, v) end
    end
    for _, v in pairs(espList) do v:Remove() end
    espList = {}
    win:Destroy()
    print("Unloaded")
end)

-- Cleanup
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    if espEnabled then updateESP() end
end)

-- Main Loop for Aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local aimPos = Camera:WorldToScreenPoint(hrp.Position + Vector3.new(0, 1.5, 0))
            if aimPos then
                mousemoverel(aimPos.X - Camera.ViewportSize.X/2, aimPos.Y - Camera.ViewportSize.Y/2)
            end
        end
    end
end)
