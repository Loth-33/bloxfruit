-- KAT MODERN GUI v1.0
-- Made by tostreis

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- === UI ===
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KAT MODERN"
Title.TextColor3 = Color3.fromRGB(255, 70, 70)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TabAimbot = Instance.new("TextButton")
TabAimbot.Size = UDim2.new(0.5, 0, 0, 30)
TabAimbot.Position = UDim2.new(0, 0, 0, 45)
TabAimbot.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
TabAimbot.Text = "Aimbot"
TabAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
TabAimbot.Parent = MainFrame

local TabESP = Instance.new("TextButton")
TabESP.Size = UDim2.new(0.5, 0, 0, 30)
TabESP.Position = UDim2.new(0.5, 0, 0, 45)
TabESP.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
TabESP.Text = "ESP"
TabESP.TextColor3 = Color3.fromRGB(255, 255, 255)
TabESP.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -80)
Content.Position = UDim2.new(0, 0, 0, 80)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Toggle Buttons
local function CreateToggle(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Parent = parent
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(70, 70, 80) or Color3.fromRGB(40, 40, 45)
        callback(state)
    end)
    return btn
end

local AimbotToggle = CreateToggle(Content, "Silent Aim", 10, function(v) getgenv().AimbotEnabled = v end)
local FovToggle = CreateToggle(Content, "FOV Circle", 50, function(v) getgenv().FovEnabled = v end)
local EspToggle = CreateToggle(Content, "ESP Boxes", 90, function(v) getgenv().EspEnabled = v end)
local TracersToggle = CreateToggle(Content, "Tracers", 130, function(v) getgenv().TracersEnabled = v end)

-- === Aimbot ===
getgenv().AimbotEnabled = false
getgenv().FovEnabled = false
getgenv().FovRadius = 150

local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1
FovCircle.Color = Color3.fromRGB(255, 255, 255)
FovCircle.Radius = getgenv().FovRadius
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
        FovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    else
        FovCircle.Visible = false
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

local function CreateESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(0, 200, 255)
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
        local footPos = torso and Camera:WorldToScreenPoint(torso.Position - Vector3.new(0, 3, 0)) or pos

        if onScreen and getgenv().EspEnabled then
            local height = (pos.Y - footPos.Y) * 1.5
            local width = height * 0.5
            box.Size = Vector2.new(width, height)
            box.Position = Vector2.new(pos.X - width/2, pos.Y - height)
            box.Visible = true

            nameTag.Text = player.Name .. " | " .. math.floor((pos - Camera.CFrame.Position).Magnitude) .. "m"
            nameTag.Position = Vector2.new(pos.X, pos.Y - height - 20)
            nameTag.Visible = true
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
