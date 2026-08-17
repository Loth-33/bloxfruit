-- made by tost
-- Murder Mystery 2 Hack GUI (Orinlo/Palo) - DÜZELTİLMİŞ ROL TESPİTİ

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local workspace = game:GetService("Workspace")
local runservice = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local virtualInput = game:GetService("VirtualInputManager")

-- GUI
local screen = Instance.new("ScreenGui", player.PlayerGui)
screen.Name = "OrinloHub"
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 450, 0, 550)
frame.Position = UDim2.new(0.5, -225, 0.5, -275)
frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.new(0.15, 0.0, 0.0)
title.Text = "MM2 CHEAT | orinlo"
title.TextColor3 = Color3.new(1, 0.2, 0.2)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextScaled = true

-- Tabs
local tabFrame = Instance.new("Frame", frame)
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 35)
tabFrame.BackgroundTransparency = 1

local tabs = {"ESP", "TP", "FARM", "MOVEMENT", "MISC"}
local tabButtons = {}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0.2, 0, 1, 0)
    btn.Position = UDim2.new(0.2 * (i-1), 0, 0, 0)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    tabButtons[i] = btn
end

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -10, 1, -75)
scrollFrame.Position = UDim2.new(0, 5, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scrollFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function make_button(text, color, callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(0.95, 0, 0, 34)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = color or Color3.new(0.2, 0.2, 0.3)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function make_toggle(text, default, callback)
    local state = default or false
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(0.95, 0, 0, 34)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = state and Color3.new(0, 0.5, 0.2) or Color3.new(0.25, 0.15, 0.15)
    btn.Text = text .. (state and " ✅" or " ❌")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0, 0.5, 0.2) or Color3.new(0.25, 0.15, 0.15)
        btn.Text = text .. (state and " ✅" or " ❌")
        callback(state)
    end)
    return btn, function() return state end
end

-- DOĞRU ROL TESPİTİ (Murder Mystery 2 için)
local function getPlayerRole(plr)
    if not plr then return "Masum" end
    -- Deneme 1: Character içindeki Role
    if plr.Character and plr.Character:FindFirstChild("Role") then
        local role = plr.Character.Role.Value
        if role == "Murderer" then return "Katil" end
        if role == "Sheriff" then return "Sherif" end
        return "Masum"
    end
    -- Deneme 2: Player içindeki Data
    if plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Role") then
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
