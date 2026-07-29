--[[
    AutoShoot Knife + Silent Aim + Hitbox 10 (Rayfield Fix)
    - Arreglado el cargador de Rayfield para que el menú abra correctamente
    - Misma lógica rápida, verificación de pared y anti-temblor intactas
]]

-- ======================
-- CARGAR RAYFIELD
-- ======================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AutoShoot Knife",
    LoadingTitle = "Cargando AutoShoot Knife...",
    LoadingSubtitle = "Onyx Logic",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoShootKnife",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

local autoShootCuchilloEnabled = false
local autoShootTargetPart = "Cabeza"
local enemyCache = {}
local hitboxEnabled = true
local hitboxSize = 10

local isAttackingWithKnife = false

-- Parte invisible para predicción
local predictionPart = Instance.new("Part")
predictionPart.Name = "AstraPredictionPart"
predictionPart.Size = Vector3.new(0.2, 0.2, 0.2)
predictionPart.Transparency = 1
predictionPart.Anchored = true
predictionPart.CanCollide = false
predictionPart.CanQuery = false
predictionPart.CanTouch = false
predictionPart.Parent = Workspace

pcall(function() getgenv().AstraTargetPart = nil end)

-- ===== Funciones exactas del original =====

local function esLaPistola(item)
    if not item:IsA("Tool") then return false end
    if item:FindFirstChild("Throw", true) or item:FindFirstChild("KnifeClient", true) or item:FindFirstChild("KnifeServer", true) then return false end
    local nombre = string.lower(item.Name)
    local ignorar = {"combat", "fist", "wallet", "phone", "punch", "boombox", "radio", "knife", "blade", "cuchillo", "dagger", "kunai", "sword", "toy", "juguete", "pizza", "burger", "teddy", "balloon", "drink", "food"}
    for _, palabra in ipairs(ignorar) do 
        if string.find(nombre, palabra) then return false end 
    end
    return true
end

local function isEnemy(targetPlayer)
    if targetPlayer == player then return false end
    
    if enemyCache[targetPlayer] ~= nil then 
        return enemyCache[targetPlayer] 
    end

    local isDiff = true
    if player.Team ~= nil and targetPlayer.Team ~= nil then
        isDiff = (player.Team ~= targetPlayer.Team)
    else
        local pAttr = player:GetAttribute("Team") or player:GetAttribute("team")
        local tAttr = targetPlayer:GetAttribute("Team") or targetPlayer:GetAttribute("team")
        if pAttr ~= nil and tAttr ~= nil then
            isDiff = (pAttr ~= tAttr)
        elseif player.TeamColor.Name ~= "White" and player.TeamColor.Name ~= "Medium stone grey" then
            isDiff = (player.TeamColor ~= targetPlayer.TeamColor)
        end
    end
    
    enemyCache[targetPlayer] = isDiff
    return isDiff
end

do
    local function updateMyTeam() enemyCache = {} end
    local function updateEnemy(p) enemyCache[p] = nil end

    player:GetPropertyChangedSignal("Team"):Connect(updateMyTeam)
    player:GetPropertyChangedSignal("TeamColor"):Connect(updateMyTeam)
    player:GetAttributeChangedSignal("Team"):Connect(updateMyTeam)

    local function setupPlayerEvents(p)
        p:GetPropertyChangedSignal("Team"):Connect(function() updateEnemy(p) end)
        p:GetPropertyChangedSignal("TeamColor"):Connect(function() updateEnemy(p) end)
        p:GetAttributeChangedSignal("Team"):Connect(function() updateEnemy(p) end)
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then setupPlayerEvents(p) end
    end
    Players.PlayerAdded:Connect(function(p) setupPlayerEvents(p) end)
    Players.PlayerRemoving:Connect(function(p) updateEnemy(p) end)
end

-- ===== Silent Aim (Rápido y directo al blanco) =====
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()

    if not checkcaller() and getgenv().AstraTargetPart and isAttackingWithKnife then
        local target = getgenv().AstraTargetPart
        local cameraOrigin = Workspace.CurrentCamera.CFrame.Position
        
        if target and target.Parent then
            if method == "Raycast" and self == Workspace then
                local origin, direction, p3 = ...
                if typeof(direction) == "Vector3" then
                    local newDir = (target.Position - origin).Unit * 5000 
                    return oldNamecall(self, origin, newDir, p3)
                end
            elseif string.find(method, "FindPartOnRay") and self == Workspace then
                local ray, p2, p3, p4 = ...
                if typeof(ray) == "Ray" then
                    local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 5000)
                    return oldNamecall(self, newRay, p2, p3, p4)
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(t, k)
    if not checkcaller() and t == mouse and getgenv().AstraTargetPart and isAttackingWithKnife then
        if k == "Hit" or k == "hit" then
            return getgenv().AstraTargetPart.CFrame
        elseif k == "Target" or k == "target" then
            return getgenv().AstraTargetPart
        end
    end
    return oldIndex(t, k)
end)

-- ===== Hitbox (tamaño 10) =====
task.spawn(function()
    while task.wait(0.15) do
        if not hitboxEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = v.Character.HumanoidRootPart
                    if hrp.Size.X > 3 then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = true
                        hrp.Material = Enum.Material.Plastic
                    end
                end
            end
            continue
        end

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and isEnemy(v) and v.Character then
                local hum = v.Character:FindFirstChild("Humanoid")
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                
                if hum and hum.Health > 0 and hrp then
                    local targetSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    if hrp.Size ~= targetSize then
                        hrp.Size = targetSize
                    end
                    hrp.CanCollide = false
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.ForceField
                    hrp.Color = Color3.fromRGB(255, 80, 80)
                end
            end
        end
    end
end)

-- ===== Bucle principal (Con verificación de pared y anti-temblor) =====
task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while true do
        if autoShootCuchilloEnabled then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then 
                getgenv().AstraTargetPart = nil
                isAttackingWithKnife = false
                task.wait(0.05)
                continue 
            end

            local arma = char:FindFirstChildOfClass("Tool")
            if not arma or not arma:FindFirstChild("Handle") or esLaPistola(arma) then 
                getgenv().AstraTargetPart = nil
                isAttackingWithKnife = false
                task.wait(0.05)
                continue 
            end

            local hum = char:FindFirstChildOfClass("Humanoid")
            local myHRP = char.HumanoidRootPart
            local myPos = myHRP.Position

            local origin = myPos
            if char:FindFirstChild("Head") and hum and hum.FloorMaterial ~= Enum.Material.Air then
                origin = char.Head.Position
            end

            local objetivosPotenciales = {}
            
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        
                        local partesAEscanear = {}
                        if autoShootTargetPart == "Cabeza" then 
                            partesAEscanear = {"Head"}
                        elseif autoShootTargetPart == "Torso" then 
                            partesAEscanear = {"UpperTorso", "Torso", "HumanoidRootPart"}
                        else
                            partesAEscanear = {
                                "Head", "UpperTorso", "LowerTorso", "Torso", 
                                "LeftArm", "RightArm", "LeftLeg", "RightLeg"
                            } 
                        end

                        for _, partName in ipairs(partesAEscanear) do
                            local part = p.Character:FindFirstChild(partName)
                            if part and part:IsA("BasePart") then 
                                table.insert(objetivosPotenciales, {
                                    Part = part, 
                                    Dist = (part.Position - myPos).Magnitude,
                                    Char = p.Character
                                })
                            end
                        end
                    end 
                end 
            end 
            
            table.sort(objetivosPotenciales, function(a, b) 
                return a.Dist < b.Dist 
            end)

            local closestTargetPart = nil
            local closestEnemyChar = nil
            
            for _, obj in ipairs(objetivosPotenciales) do
                local part = obj.Part
                params.FilterDescendantsInstances = {char, obj.Char}
                
                local rayResult = Workspace:Raycast(origin, part.Position - origin, params)
                if not rayResult then
                    closestTargetPart = part
                    closestEnemyChar = obj.Char
                    break
                end
            end

            if closestTargetPart and closestEnemyChar then
                local enemyHRP = closestEnemyChar:FindFirstChild("HumanoidRootPart")
                local finalTarget = closestTargetPart

                if enemyHRP then
                    local velocity = enemyHRP.AssemblyLinearVelocity
                    local speed = velocity.Magnitude

                    local predictionTime = 0.12
                    if hum and hum.FloorMaterial == Enum.Material.Air then
                        predictionTime = 0.16
                    end

                    if speed > 1 then
                        local futurePosition = closestTargetPart.Position + (velocity * predictionTime)
                        predictionPart.CFrame = CFrame.new(futurePosition)
                        finalTarget = predictionPart
                    end
                end

                getgenv().AstraTargetPart = finalTarget
                
                isAttackingWithKnife = true
                pcall(function() 
                    arma:Activate() 
                    task.delay(0.01, function() 
                        if arma.Parent == char then 
                            arma:Deactivate() 
                        end
                        isAttackingWithKnife = false
                    end)
                end)

                task.wait(0.025)
            else
                getgenv().AstraTargetPart = nil
                isAttackingWithKnife = false
                task.wait(0.1)
            end
        else
            if getgenv().AstraTargetPart then
                getgenv().AstraTargetPart = nil
            end
            isAttackingWithKnife = false
            task.wait(0.1)
        end
    end
end)

-- ======================
-- UI RAYFIELD (Estructura corregida para despliegue)
-- ======================
local Tab = Window:CreateTab("AutoShoot Knife", 4483362458)

Tab:CreateSection("Auto Shoot Knife")

Tab:CreateToggle({
    Name = "Auto Shoot (Cuchillo)",
    CurrentValue = false,
    Flag = "AutoShootKnife",
    Callback = function(Value)
        autoShootCuchilloEnabled = Value
        if not Value then
            getgenv().AstraTargetPart = nil
            isAttackingWithKnife = false
        end
    end,
})

Tab:CreateDropdown({
    Name = "Target: Parte del cuerpo",
    Options = {"Cabeza", "Torso", "Cuerpo Completo"},
    CurrentOption = {"Cabeza"},
    Flag = "AutoShootKnifePart",
    Callback = function(Option)
        autoShootTargetPart = typeof(Option) == "table" and Option[1] or Option
    end,
})

Tab:CreateSection("Hitbox")

Tab:CreateToggle({
    Name = "Hitbox (Tamaño 10)",
    CurrentValue = true,
    Flag = "HitboxEnabled",
    Callback = function(Value)
        hitboxEnabled = Value
    end,
})

Tab:CreateParagraph({
    Title = "Información",
    Content = "• AutoShoot Knife Rápido y Directo\n• Verificación de pared (Anti-Wall)\n• Anti-temblor detrás de muros\n• Predicción + Hitbox 10 estable"
})

Rayfield:LoadConfiguration()

print("[AutoShoot Knife] Menú Rayfield abierto correctamente.")
