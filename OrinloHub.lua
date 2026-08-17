-- KAT MODERN GUI v2.0 (DRAG, RESIZE, TAB, WORKING FOV)
-- Made by tostreis

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KatHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- DRAG
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- RESIZE (sağ alt köşe)
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Parent = MainFrame
local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 4)
ResizeCorner.Parent = ResizeHandle

local resizing, resizeStart, startSize
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = MainFrame.Size
    end
end)
ResizeHandle.InputEnded:Connect(function()
    resizing = false
end)
UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local newX = math.max(250, startSize.X.Offset + delta.X)
        local newY = math.max(300, startSize.Y.Offset + delta.Y)
        MainFrame.Size = UDim2.new(0, newX, 0, newY)
    end
end)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KAT MODERN v2"
Title.TextColor3 = Color3.fromRGB(255, 70, 70)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TABS
local Tabs = {"Aimbot", "ESP", "Settings"}
local TabButtons = {}
local ContentFrames = {}

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 30)
    btn.Position = UDim2.new((i-1)/3, 5, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = MainFrame
    TabButtons[name] = btn

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 1, -85)
    frame.Position = UDim2.new(0, 5, 0, 80)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.Parent = MainFrame
    ContentFrames[name] = frame
end

local function SwitchTab(name)
    for k, f in pairs(ContentFrames) do
        f.Visible = (k == name)
    end
end

TabButtons["Aimbot"].MouseButton1Click:Connect(function() SwitchTab("Aimbot") end)
TabButtons["ESP"].MouseButton1Click:Connect(function() SwitchTab("ESP") end)
TabButtons["Settings"].MouseButton1Click:Connect(function() SwitchTab("Settings") end)

-- TOGGLES
local function CreateToggle(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,45)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Parent = parent
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(70,70,80) or Color3.fromRGB(40,40,45)
        callback(state)
    end)
    return btn
end

-- SLIDER
local function CreateSlider(parent, text, y, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 25)
    label.Position = UDim2.new(0.05, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.4, 0, 0, 8)
    slider.Position = UDim2.new(0.55, 0, 0, y + 8)
    slider.BackgroundColor3 = Color3.fromRGB(60,60,70)
    slider.Parent = parent

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255,70,70)
    fill.Parent = slider

    local val = default
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            val = math.floor(min + x * (max - min))
            val = math.clamp(val, min, max)
            fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputState == Enum.UserInputState.Change then
            -- basit tut
        end
    end)
end

-- AIMBOT TAB
local AimbotFrame = ContentFrames["Aimbot"]
CreateToggle(AimbotFrame, "Silent Aim", 10, function(v) getgenv().AimbotEnabled = v end)
CreateToggle(AimbotFrame, "FOV Circle", 50, function(v) getgenv().FovEnabled = v end)
CreateSlider(AimbotFrame, "FOV Radius", 90, 50, 300, 150, function(v) getgenv().FovRadius = v end)
CreateToggle(AimbotFrame, "Auto Aim (hold RMB)", 130, function(v) getgenv().AutoAim = v end)

-- ESP TAB
local EspFrame = ContentFrames["ESP"]
CreateToggle(EspFrame, "ESP Boxes", 10, function(v) getgenv().EspEnabled = v end)
CreateToggle(EspFrame, "Tracers", 50, function(v) getgenv().TracersEnabled = v end)
CreateToggle(EspFrame, "Name Tags", 90, function(v) getgenv().NameTags = v end)

-- SETTINGS TAB
local SettingsFrame = ContentFrames["Settings"]
CreateSlider(SettingsFrame, "Transparency", 10, 0, 100, 10, function(v)
    MainFrame.BackgroundTransparency = v / 100
end)

-- === AIMBOT ===
getgenv().AimbotEnabled = false
getgenv().FovEnabled = false
getgenv().FovRadius = 150
getgenv().AutoAim = false

local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1
FovCircle.Color = Color3.fromRGB(255,255,255)
FovCircle.Visible = false

local function GetClosestPlayer()
    local closest, dist = nil, getgenv().FovRadius
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToScreenPoint(p.Character.Head.Position)
            local screenDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if onScreen and screenDist < dist then
                dist = screenDist
                closest = p
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if getgenv().FovEnabled then
        FovCircle.Visible = true
        FovCircle.Radius = getgenv().FovRadius
        FovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    else
        FovCircle.Visible = false
    end

    if getgenv().AutoAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- === ESP ===
getgenv().EspEnabled = false
getgenv().TracersEnabled = false
getgenv().NameTags = false

local function CreateESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(0,255,0)
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Color = Color3.fromRGB(255,255,255)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(0,200,255)
    tracer.Visible = false

    RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("Head") then
            box.Visible = false
            nameTag.Visible = false
            tracer.Visible = false
            return
        end

        local head = player.Character.Head
        local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
        local torso = player.Character:FindFirstChild("HumanoidRootPart")
        local footPos = torso and Camera:WorldToScreenPoint(torso.Position - Vector3.new(0,3,0)) or pos

        if onScreen and getgenv().EspEnabled then
            local height = (pos.Y - footPos.Y) * 1.5
            local width = height * 0.5
            box.Size = Vector2.new(width, height)
            box.Position = Vector2.new(pos.X - width/2, pos.Y - height)
            box.Visible = true

            if getgenv().NameTags then
                nameTag.Text = player.Name .. " | " .. math.floor((pos - Camera.CFrame.Position).Magnitude) .. "m"
                nameTag.Position = Vector2.new(pos.X, pos.Y - height - 20)
                nameTag.Visible = true
            else
                nameTag.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
        end

        if getgenv().TracersEnabled and onScreen then
            tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(pos.X, pos.Y)
            tracer.Visible = true
        else
            tracer.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(CreateESP)
