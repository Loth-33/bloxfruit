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
end)    if plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Role") then
        local role = plr.Data.Role.Value
        if role == "Murderer" then return "Katil" end
        if role == "Sheriff" then return "Sherif" end
        return "Masum"
    end
    -- Deneme 3: Player içindeki Role (direkt)
    if plr:FindFirstChild("Role") then
        local role = plr.Role.Value
        if role == "Murderer" then return "Katil" end
        if role == "Sheriff" then return "Sherif" end
        return "Masum"
    end
    -- Deneme 4: Oyuncunun adına göre (fallback)
    if plr.Name:lower():find("murder") or plr.Name:lower():find("katil") then
        return "Katil"
    end
    return "Masum"
end

-- Değişkenler
local espEnabled = false
local espHighlights = {}
local espBillboards = {}

local function clearESP()
    for _, v in pairs(espHighlights) do v:Destroy() end
    espHighlights = {}
    for _, v in pairs(espBillboards) do v:Destroy() end
    espBillboards = {}
end

local function updateESP()
    clearESP()
    if not espEnabled then return end
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local char = v.Character
            local role = getPlayerRole(v)
            local color = Color3.new(0, 1, 0) -- yeşil masum
            
            if role == "Katil" then
                color = Color3.new(1, 0, 0) -- kırmızı
            elseif role == "Sherif" then
                color = Color3.new(0, 0.4, 1) -- mavi
            end
            
            -- Highlight
            local hl = Instance.new("Highlight", char)
            hl.FillColor = color
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.4
            table.insert(espHighlights, hl)
            
            -- Billboard (isim + rol)
            local bill = Instance.new("BillboardGui", char.Head)
            bill.Size = UDim2.new(0, 120, 0, 30)
            bill.Adornee = char.Head
            bill.AlwaysOnTop = true
            local label = Instance.new("TextLabel", bill)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = v.Name .. " [" .. role .. "]"
            label.TextColor3 = color
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            table.insert(espBillboards, bill)
        end
    end
end

-- Tab içerikleri
local function loadTab(tabIndex)
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    if tabIndex == 1 then -- ESP
        make_toggle("ESP AÇ (Renkli)", false, function(s)
            espEnabled = s
            if s then
                updateESP()
                runservice.RenderStepped:Connect(function()
                    if espEnabled then
                        updateESP()
                    end
                end)
            else
                clearESP()
            end
        end)
        
        make_button("ESP'yi Yenile", Color3.new(0.2, 0.5, 0.2), function()
            if espEnabled then updateESP() end
        end)
        
        make_button("Silaha Işınlan", Color3.new(0.2, 0.4, 0.6), function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    player.Character.HumanoidRootPart.CFrame = v.Handle.CFrame * CFrame.new(0, 2, 0)
                    break
                end
            end
        end)
        
        make_button("Oyuncu Rollerini Göster (Debug)", Color3.new(0.4, 0.2, 0.6), function()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player then
                    print(v.Name .. " -> " .. getPlayerRole(v))
                end
            end
        end)
        
    elseif tabIndex == 2 then -- TP
        local tps = {
            {"Spawn", 0, 20, 0},
            {"Harita Merkezi", 100, 30, 100},
            {"Bina İçi", -50, 10, 50},
            {"Çatı", 0, 50, 0},
            {"Köşe 1", 200, 15, 200},
            {"Köşe 2", -200, 15, -200}
        }
        for _, loc in ipairs(tps) do
            make_button(loc[1], Color3.new(0.1, 0.3, 0.5), function()
                player.Character.HumanoidRootPart.CFrame = CFrame.new(loc[2], loc[3], loc[4])
            end)
        end
        
        make_button("Sherif'e TP", Color3.new(0.1, 0.3, 0.8), function()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and getPlayerRole(v) == "Sherif" and v.Character then
                    player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    break
                end
            end
        end)
        
        make_button("Katile TP", Color3.new(0.8, 0.1, 0.1), function()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and getPlayerRole(v) == "Katil" and v.Character then
                    player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    break
                end
            end
        end)
        
    elseif tabIndex == 3 then -- FARM
        make_toggle("Coin Farm (Otomatik Topla)", false, function(s)
            if s then
                runservice.RenderStepped:Connect(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and v.Name == "Coin" then
                            player.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                        end
                    end
                end)
            end
        end)
        
        make_button("Coin Farm (Manuel)", Color3.new(0.2, 0.5, 0.2), function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name == "Coin" then
                    player.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                    wait(0.1)
                end
            end
        end)
        
        make_button("HERKESİ ÖLDÜR (Katil isen)", Color3.new(0.8, 0, 0), function()
            if getPlayerRole(player) ~= "Katil" then
                print("Katil değilsin!") 
                return 
            end
            local char = player.Character
            if not char then return end
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                    local head = v.Character.Head
                    local knife = char:FindFirstChildOfClass("Tool")
                    if knife then
                        knife:Activate()
                        knife.Handle.CFrame = head.CFrame
                        wait(0.1)
                        knife:Deactivate()
                    end
                end
            end
        end)
        
        make_button("KATİLE SIK (Sherif isen)", Color3.new(0.2, 0.4, 0.9), function()
            if getPlayerRole(player) ~= "Sherif" then
                print("Sherif değilsin!")
                return
            end
            local char = player.Character
            if not char then return end
            local gun = char:FindFirstChildOfClass("Tool")
            if not gun then return end
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and getPlayerRole(v) == "Katil" and v.Character then
                    local head = v.Character.Head
                    gun:Activate()
                    gun.Handle.CFrame = head.CFrame
                    wait(0.1)
                    gun:Deactivate()
                    break
                end
            end
        end)
        
    elseif tabIndex == 4 then -- MOVEMENT
        make_toggle("Speed x2", false, function(s)
            if s then player.Character.Humanoid.WalkSpeed = 50
            else player.Character.Humanoid.WalkSpeed = 16 end
        end)
        
        make_toggle("Jump x2", false, function(s)
            if s then player.Character.Humanoid.JumpPower = 100
            else player.Character.Humanoid.JumpPower = 50 end
        end)
        
        make_toggle("Fly (Space ile yukarı)", false, function(s)
            if s then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(10000, 10000, 10000)
                bv.Parent = player.Character.HumanoidRootPart
                runservice.RenderStepped:Connect(function()
                    if not s then
                        if player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                            player.Character.HumanoidRootPart.BodyVelocity:Destroy()
                        end
                        return
                    end
                    local root = player.Character.HumanoidRootPart
                    local vel = Vector3.new(0, 0, 0)
                    if userInput:IsKeyDown(Enum.KeyCode.Space) then vel = Vector3.new(0, 50, 0) end
                    if userInput:IsKeyDown(Enum.KeyCode.W) then vel = vel + root.CFrame.LookVector * 50 end
                    if userInput:IsKeyDown(Enum.KeyCode.S) then vel = vel - root.CFrame.LookVector * 50 end
                    if userInput:IsKeyDown(Enum.KeyCode.A) then vel = vel - root.CFrame.RightVector * 50 end
                    if userInput:IsKeyDown(Enum.KeyCode.D) then vel = vel + root.CFrame.RightVector * 50 end
                    root.BodyVelocity.Velocity = vel
                end)
            else
                if player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    player.Character.HumanoidRootPart.BodyVelocity:Destroy()
                end
            end
        end)
        
        make_toggle("No Clip (Duvardan Geç)", false, function(s)
            player.Character.HumanoidRootPart.CanCollide = not s
        end)
        
    elseif tabIndex == 5 then -- MISC
        make_toggle("Aimbot (Sherif isen)", false, function(s)
            if s then
                runservice.RenderStepped:Connect(function()
                    if not s then return end
                    if getPlayerRole(player) ~= "Sherif" then return end
                    local char = player.Character
                    if not char then return end
                    local gun = char:FindFirstChildOfClass("Tool")
                    if not gun then return end
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and getPlayerRole(v) == "Katil" and v.Character then
                            local head = v.Character.Head
                            char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, head.Position)
                            break
                        end
                    end
                end)
            end
        end)
        
        make_button("KARAKTERİ SIFIRLA", Color3.new(0.6, 0, 0), function()
            player.Character:BreakJoints()
        end)
        
        make_button("KAPAT", Color3.new(0.3, 0.3, 0.3), function()
            screen:Destroy()
        end)
    end
end

-- Tab geçişleri
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabButtons) do
            b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
        end
        btn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
        loadTab(i)
    end)
end

-- İlk yükleme
tabButtons[1].BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
loadTab(1)

frame.Visible = true
