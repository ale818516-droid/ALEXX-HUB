local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Alexx hub",
    Theme = "Dark",
    Author = "Yisuhub",
    Folder = "Alexx",
    Acrylic = false,
    Transparent = false,
    NewElements = true,
    HideSearchBar = false,
    OpenButton = { Enabled = true, Draggable = true, Title = "YisusHub", CornerRadius = UDim.new(1), Scale = 0.8 },
    Topbar = { Height = 44, ButtonsType = "Default" }
})
WindUI:SetTheme("Dark")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local ClientGlobals = require(ReplicatedStorage.Client.Modules.ClientGlobals)

local UIElements = {}
local hitboxEnabled = false
local hitboxInvisible = false
local hitboxSize = 10
local hitboxColor = Color3.fromRGB(255, 255, 255)
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)

local function isEnemy(target)
    if target == player then return false end
    local myTeam = player:GetAttribute("Team") or player.Team
    local targetTeam = target:GetAttribute("Team") or target.Team
    return myTeam ~= targetTeam
end

local function estaEnLobby()
    return false
end

local Tabs = {
    Aim = Window:Tab({ Title = "Hitbox & Esp", Icon = "crosshair" })
}

Tabs.Aim:Section({Title = "Hitbox Expander"})

UIElements.TogHitbox = Tabs.Aim:Toggle({
    Title = "Aumentar Hitbox",
    Desc = "Expande la caja de colisión de los enemigos solo cuando están visibles (fuera de paredes).",
    Callback = function(s) 
        hitboxEnabled = s 
        if not s then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = v.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                    hrp.CanCollide = true
                    local box = hrp:FindFirstChild("AstraHitboxBox")
                    if box then box:Destroy() end
                end
            end
        end
    end
})

UIElements.TogHbInv = Tabs.Aim:Toggle({
    Title = "Hitbox Invisible", 
    Desc = "Oculta las cajas gigantes de los enemigos.",
    Callback = function(s) hitboxInvisible = s end
})

UIElements.SliHitbox = Tabs.Aim:Slider({
    Title = "Tamaño de Hitbox (Slider)", 
    Step = 1,
    Value = {Min = 2, Max = 50, Default = 10}, 
    Callback = function(v) hitboxSize = v end
})

Tabs.Aim:Input({
    Title = "Escribir Tamaño Exacto",
    Placeholder = "Ej: 2, 12, 25...",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            hitboxSize = num
            pcall(function() if num >= 2 and num <= 50 then UIElements.SliHitbox:Set(num) end end)
        end
    end,
})

UIElements.ColHitbox = Tabs.Aim:Colorpicker({
    Title = "Color de Hitbox", 
    Default = Color3.fromRGB(255,255,255), 
    Callback = function(c) hitboxColor = c end
})

Tabs.Aim:Section({Title = "Visuales de Enemigos"})

UIElements.TogEsp = Tabs.Aim:Toggle({
    Title = "Activar ESP",
    Desc = "No te robes el sour",
    Callback = function(s) 
        espEnabled = s 
    end
})

UIElements.ColEsp = Tabs.Aim:Colorpicker({
    Title = "Color del ESP", 
    Default = Color3.fromRGB(255, 0, 0), 
    Callback = function(c) espColor = c end
})

task.spawn(function()
    if getgenv().AstraLoopRunning then getgenv().AstraLoopRunning = false task.wait(0.2) end
    getgenv().AstraLoopRunning = true

    local function limpiarHitbox(v)
        if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            hrp.Size = Vector3.new(2, 2, 1) 
            hrp.Transparency = 1 
            hrp.Material = Enum.Material.Plastic 
            hrp.CanCollide = true
            local box = hrp:FindFirstChild("AstraHitboxBox") 
            if box then box:Destroy() end
        end
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while getgenv().AstraLoopRunning and task.wait(0.16) do
        if not hitboxEnabled and not espEnabled then continue end

        local enLobby = estaEnLobby()
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player then
                local char = v.Character
                local esEnemigoValido = isEnemy(v) and char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0

                if espEnabled and esEnemigoValido and not enLobby then
                    local hl = char:FindFirstChild("OnyxESP")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "OnyxESP"
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = char
                    end
                    hl.OutlineColor = espColor
                else
                    if char and char:FindFirstChild("OnyxESP") then
                        char.OnyxESP:Destroy()
                    end
                end

                if hitboxEnabled and esEnemigoValido and not enLobby and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart 
                    
                    local aLaVista = false
                    if player.Character and player.Character:FindFirstChild("Head") then
                        local origin = camera.CFrame.Position 
                        params.FilterDescendantsInstances = {player.Character, char}
                        local result = Workspace:Raycast(origin, hrp.Position - origin, params) 
                        aLaVista = not result 
                    end
                    
                    local targetSize = aLaVista and Vector3.new(hitboxSize, hitboxSize, hitboxSize) or Vector3.new(2, 2, 1)
                    
                    if hrp.Size ~= targetSize then hrp.Size = targetSize end
                    if hrp.CanCollide ~= false then hrp.CanCollide = false end
                    
                    local targetColor = aLaVista and hitboxColor or Color3.fromRGB(255, 50, 50)
                    local targetTrans = (hitboxInvisible or not aLaVista) and 1 or 0.4
                    
                    if hrp.Transparency ~= targetTrans then hrp.Transparency = targetTrans end
                    if hrp.Material ~= Enum.Material.ForceField then hrp.Material = Enum.Material.ForceField end
                    if hrp.Color ~= targetColor then hrp.Color = targetColor end
                    
                    local box = hrp:FindFirstChild("AstraHitboxBox")
                    if not aLaVista then
                        if box then box:Destroy() end
                    else
                        if not box then 
                            box = Instance.new("BoxHandleAdornment") 
                            box.Name = "AstraHitboxBox" 
                            box.Adornee = hrp 
                            box.AlwaysOnTop = true 
                            box.ZIndex = 5 
                            box.Parent = hrp 
                        end
                        
                        if box.Size ~= hrp.Size then box.Size = hrp.Size end
                        if box.Color3 ~= targetColor then box.Color3 = targetColor end
                        
                        local targetBoxTrans = hitboxInvisible and 1 or 0.2
                        if box.Transparency ~= targetBoxTrans then box.Transparency = targetBoxTrans end
                        if box.Visible ~= not hitboxInvisible then box.Visible = not hitboxInvisible end
                    end
                else 
                    limpiarHitbox(v) 
                end
            end
        end
    end
end)

local screenGui = player:FindFirstChild("PlayerGui"):FindFirstChild("AstraScreenGui")
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AstraScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

local function makeDraggableSafe(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local deadZoneFrame = Instance.new("Frame")
deadZoneFrame.Size = UDim2.new(0, 150, 0, 150)
deadZoneFrame.Position = UDim2.new(0.8, -75, 0.8, -75) 
deadZoneFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50) 
deadZoneFrame.BackgroundTransparency = 0.5
deadZoneFrame.Visible = false
deadZoneFrame.ZIndex = 100
deadZoneFrame.Parent = screenGui 
Instance.new("UICorner", deadZoneFrame).CornerRadius = UDim.new(0, 16)

local dzStroke = Instance.new("UIStroke", deadZoneFrame)
dzStroke.Color = Color3.fromRGB(255, 255, 255)
dzStroke.Thickness = 2
dzStroke.LineJoinMode = Enum.LineJoinMode.Round

local dzLabel = Instance.new("TextLabel", deadZoneFrame)
dzLabel.Size = UDim2.new(1, 0, 1, 0)
dzLabel.BackgroundTransparency = 1
dzLabel.Text = "ZONA MUERTA\n(Arrastrar)"
dzLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dzLabel.Font = Enum.Font.GothamBold
dzLabel.TextSize = 14
dzLabel.TextWrapped = true

makeDraggableSafe(deadZoneFrame, deadZoneFrame)

getgenv().AutoEquipEnabled = false
local startPosVector = Vector2.new(0, 0)
local startTime = 0 
local CLICK_THRESHOLD = 20 

local function buscarArma()
    local backpack = player:FindFirstChild("Backpack")
    local char = player.Character
    local arma = nil
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("fire") then
                arma = item
                break
            end
        end
    end
    
    if not arma and char then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("fire") then
                arma = item
                break
            end
        end
    end
    
    if arma and char then
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and (currentTool:FindFirstChild("Kill") or currentTool:FindFirstChild("ActivateThrowing")) then
            return nil 
        end
    end
    
    return arma
end

local function verificarEnemigosMacro()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and isEnemy(p) then
            local pChar = p.Character
            if pChar and pChar:FindFirstChild("Humanoid") and pChar.Humanoid.Health > 0 then
                return true
            end
        end
    end
    return false
end

local function ejecutarAccionMacro()
    if not verificarEnemigosMacro() then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return end
    local backpack = player:FindFirstChild("Backpack")
    local arma = buscarArma()
    
    if arma then
        task.spawn(function()
            char.Humanoid:EquipTool(arma)
            task.wait(0.04)
            arma:Activate()
            task.wait(0.1)
            if arma.Parent == char and backpack then
                arma.Parent = backpack
            end
        end)
    end
end

local silentAimManualEnabled = false
local silentAimTargetPart = "Cabeza"
getgenv().AstraTargetPart = nil
getgenv().AstraAutoShootTarget = nil

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local activeTarget = getgenv().AstraTargetPart or getgenv().AstraAutoShootTarget

    if not checkcaller() and activeTarget and activeTarget.Parent then
        if method == "Raycast" and self == Workspace then
            local origin, direction, p3 = ...
            if typeof(direction) == "Vector3" and direction.Magnitude > 15 then
                local newDir = (activeTarget.Position - origin).Unit * 8000 
                return oldNamecall(self, origin, newDir, p3)
            end
        elseif string.find(method, "FindPartOnRay") and self == Workspace then
            local ray, p2, p3, p4 = ...
            if typeof(ray) == "Ray" and ray.Direction.Magnitude > 15 then
                local newRay = Ray.new(ray.Origin, (activeTarget.Position - ray.Origin).Unit * 8000)
                return oldNamecall(self, newRay, p2, p3, p4)
            end
        end
    end
    return oldNamecall(self, ...)
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.12) do
        if not silentAimManualEnabled then
            if not getgenv().AstraAutoShootTarget then
                getgenv().AstraTargetPart = nil
            end
            continue
        end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        local closestTargetPart = nil
        local shortestDistance = math.huge
        local myPos = char.HumanoidRootPart.Position
        local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and isEnemy(p) and p.Character then
                local enemyHum = p.Character:FindFirstChild("Humanoid")
                if enemyHum and enemyHum.Health > 0 then
                    local partesAEscanear = {}
                    if silentAimTargetPart == "Cabeza" then
                        local head = p.Character:FindFirstChild("Head")
                        if head then table.insert(partesAEscanear, head) end
                    elseif silentAimTargetPart == "Torso" then
                        for _, partName in ipairs({"UpperTorso", "Torso", "HumanoidRootPart"}) do
                            local part = p.Character:FindFirstChild(partName)
                            if part and part:IsA("BasePart") then 
                                table.insert(partesAEscanear, part) 
                            end
                        end
                    else 
                        for _, part in ipairs(p.Character:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                                table.insert(partesAEscanear, part) 
                            end
                        end
                    end

                    params.FilterDescendantsInstances = {char, p.Character}
                    
                    for _, part in ipairs(partesAEscanear) do
                        local distFisica = (part.Position - myPos).Magnitude
                        if distFisica < shortestDistance then
                            local raycastResult = Workspace:Raycast(headPos, part.Position - headPos, params)
                            if not raycastResult then
                                shortestDistance = distFisica
                                closestTargetPart = part
                            end
                        end
                    end
                end
            end
        end
        getgenv().AstraTargetPart = closestTargetPart
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not getgenv().AutoEquipEnabled or gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ejecutarAccionMacro()
    elseif input.UserInputType == Enum.UserInputType.Touch then
        startPosVector = input.Position
        startTime = tick() 
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not getgenv().AutoEquipEnabled or gameProcessed or input.UserInputType ~= Enum.UserInputType.Touch then return end
    local pos = input.Position
    local dzPos = deadZoneFrame.AbsolutePosition
    local dzSize = deadZoneFrame.AbsoluteSize
    local tocoZonaMuerta = (pos.X >= dzPos.X) and (pos.X <= dzPos.X + dzSize.X) and (pos.Y >= dzPos.Y) and (pos.Y <= dzPos.Y + dzSize.Y)
    if tocoZonaMuerta then return end
    if (input.Position - startPosVector).Magnitude < CLICK_THRESHOLD and (tick() - startTime) < 0.25 then
        ejecutarAccionMacro()
    end
end)

local AimTab = Window:Tab({ Title = "Combat", Icon = "target" })
AimTab:Section({Title = "Macro"})

AimTab:Toggle({
    Title = "Macro",
    Desc = "Dirige las balas al enemigo",
    Value = false,
    Callback = function(Value)
        silentAimManualEnabled = Value
        getgenv().AutoEquipEnabled = Value
        if not Value then getgenv().AstraTargetPart = nil end
    end,
})

AimTab:Dropdown({
    Title = "Target: Parte del cuerpo",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        silentAimTargetPart = Value
    end
})

local Mouse = player:GetMouse() 
getgenv().SilentAim = {
    Enabled = false, 
    FOV = 200,
    Prediction = 100, 
    Part = "Head",
    HideFOV = false,
    InternalFOV = 1200
}

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.Color = Color3.fromRGB(220, 20, 20)
fovCircle.Filled = false
fovCircle.Visible = false

local function getClosest()
    local currentFOV = getgenv().SilentAim.HideFOV and getgenv().SilentAim.InternalFOV or getgenv().SilentAim.FOV
    local targetPart, targetPlayer, closest = nil, nil, currentFOV
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and isEnemy(p) then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local part = char:FindFirstChild(getgenv().SilentAim.Part)
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if part and hrp and hum and hum.Health > 0 then
                local ray = Ray.new(camera.CFrame.Position, (part.Position - camera.CFrame.Position).Unit * 600)
                local hit, pos = Workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
                local isVisible = hit and hit:IsDescendantOf(char)
                
                if isVisible then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                        if mouseDist < closest then
                            closest = mouseDist 
                            targetPart = part 
                            targetPlayer = p 
                        end
                    end
                end
            end
        end
    end
    return targetPart, targetPlayer
end

if hookmetamethod and checkcaller then
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, index)
        if not getgenv().SilentAim.Enabled or self ~= Mouse or index ~= "Hit" or checkcaller() or getgenv().AstraAutoShootTarget then
            return oldIndex(self, index)
        end

        local targetPart, targetPlayer = getClosest()
        if targetPart and targetPlayer then
            getgenv().AstraTargetPart = targetPart
            local predFactor = getgenv().MacroFiring and 0.02 or (getgenv().SilentAim.Prediction / 100)
            local velocity = targetPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity
            return CFrame.new(targetPart.Position + velocity * 0.09 * predFactor)
        else
            getgenv().AstraTargetPart = nil
        end

        return oldIndex(self, index)
    end)
end

RunService.RenderStepped:Connect(function()
    local shouldShowCircle = getgenv().SilentAim.Enabled and not getgenv().SilentAim.HideFOV
    fovCircle.Visible = shouldShowCircle
    fovCircle.Radius = getgenv().SilentAim.FOV
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)

AimTab:Section({Title = "Silent Aim"})
AimTab:Toggle({
    Title = "Activar Silent Aim",
    Value = false,
    Callback = function(v) 
        getgenv().SilentAim.Enabled = v 
        if not v then getgenv().AstraTargetPart = nil end
    end
})

AimTab:Dropdown({
    Title = "Target: Parte del cuerpo",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        if Value == "Cabeza" then
            getgenv().SilentAim.Part = "Head"
        elseif Value == "Torso" then
            getgenv().SilentAim.Part = "HumanoidRootPart"
        else
            getgenv().SilentAim.Part = "Head"
        end
    end
})

AimTab:Slider({
    Title = "Radio FOV",
    Value = { Min = 30, Max = 1200, Default = 200 },
    Callback = function(v) getgenv().SilentAim.FOV = v end
})

AimTab:Slider({
    Title = "Predicción",
    Value = { Min = 0, Max = 100, Default = 100 },
    Callback = function(v) getgenv().SilentAim.Prediction = v end
})

local autoShootNormalEnabled = false
local autoShootAgresivoEnabled = false

local backpack = player:WaitForChild("Backpack")

local function buscarArmaAutoShoot()
    local char = player.Character

    local tool = backpack:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("fire") then
        return tool
    end

    if char then
        tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("fire") then
            return tool
        end
    end

    return nil
end

local partesNormales = {
    "Head",
    "HumanoidRootPart",
    "UpperTorso",
    "Torso"
}
task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.12) do
        if autoShootNormalEnabled or autoShootAgresivoEnabled then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local arma = buscarArmaAutoShoot()
            if not arma then 
                getgenv().AstraAutoShootTarget = nil
                continue 
            end

            local closestTargetPart = nil
            local shortestDistance = math.huge
            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        params.FilterDescendantsInstances = {char, p.Character}
                        
                        local function ProcesarParteAuto(part)
                            local dist = (part.Position - myPos).Magnitude
                            if dist < shortestDistance then
                                if not Workspace:Raycast(headPos, part.Position - headPos, params) then
                                    shortestDistance = dist
                                    closestTargetPart = part
                                end
                            end
                        end

                        local enemyChar = p.Character

if autoShootAgresivoEnabled then
    for _, part in ipairs(enemyChar:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            ProcesarParteAuto(part)
        end
    end
else
    for _, partName in ipairs(partesNormales) do
        local part = enemyChar:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            ProcesarParteAuto(part)
            end
         end
      end
    end 
  end 
end 
            
            if closestTargetPart then
                getgenv().AstraAutoShootTarget = closestTargetPart
                pcall(function() 
                    arma:Activate() 
                    task.delay(0.04, function() 
                        if arma.Parent == char then
                            arma:Deactivate() 
                        end
                    end)
                end)
                task.wait(0.15) 
            else
                getgenv().AstraAutoShootTarget = nil
            end
        else
            getgenv().AstraAutoShootTarget = nil
        end
    end
end)

AimTab:Section({Title = "Auto Shoot"})
AimTab:Toggle({
    Title = "Auto Shoot",
    Desc = "Dispara automáticamente.",
    Value = false,
    Callback = function(Value)
        autoShootNormalEnabled = Value
        if not Value then getgenv().AstraAutoShootTarget = nil end
    end,
})

AimTab:Toggle({
    Title = "Auto Shoot Agresivo",
    Desc = "Más agresivo.",
    Value = false,
    Callback = function(Value)
        autoShootAgresivoEnabled = Value
        if not Value then getgenv().AstraAutoShootTarget = nil end
    end,
})

local AutoFarmTab = Window:Tab({ Title = "Auto Farm 💰", Icon = "coins" })
AutoFarmTab:Section({Title = "Funciones Automáticas"})

local AutoFarmActivo = false
AutoFarmTab:Toggle({
    Title = "Auto Farm 💰",
    Value = false,
    Callback = function(state)
        AutoFarmActivo = state
        if AutoFarmActivo then
            task.spawn(function()
                local container = Workspace:WaitForChild("SpawnablesClient")
                while AutoFarmActivo do
                    for _, obj in pairs(container:GetChildren()) do
                        if AutoFarmActivo then
                            local touchPart = obj:FindFirstChild("Touch")
                            if touchPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                pcall(function()
                                    firetouchinterest(player.Character.HumanoidRootPart, touchPart, 0)
                                    firetouchinterest(player.Character.HumanoidRootPart, touchPart, 1)
                                end)
                            end
                        end
                    end
                    task.wait(0.45)
                end
            end)
        end
    end
})

AutoFarmTab:Section({Title = "Player"})
_G.SpeedEnabled = false
_G.SpeedMultiplier = 0

AutoFarmTab:Toggle({
    Title = "Activar Speed",
    Value = false,
    Callback = function(state)
        _G.SpeedEnabled = state
    end
})

AutoFarmTab:Slider({
    Title = "Speed Slider",
    Value = { Min = 0, Max = 100, Default = 0 },
    Callback = function(v) 
        _G.SpeedMultiplier = v / 100 
    end
})

RunService.RenderStepped:Connect(function()
    if _G.SpeedEnabled and _G.SpeedMultiplier > 0 then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * _G.SpeedMultiplier)
        end
    end
end)

_G.InfiniteJump = false
AutoFarmTab:Toggle({
    Title = "Salto Infinito",
    Value = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState("Jumping")
            end
        end
    end
end)

_G.FOVEnabled = false
local DefaultFOV = 70 

AutoFarmTab:Toggle({
    Title = "Activar FOV",
    Value = false,
    Callback = function(state)
        _G.FOVEnabled = state
        if not state then
            camera.FieldOfView = DefaultFOV 
        end
    end
})

AutoFarmTab:Slider({
    Title = "Valor FOV",
    Value = { Min = 70, Max = 120, Default = 70 },
    Callback = function(v)
        if _G.FOVEnabled then
            camera.FieldOfView = v
        end
    end
})

_G.WallClimb = false
AutoFarmTab:Toggle({
    Title = "Wall Climb",
    Value = false,
    Callback = function(state)
        _G.WallClimb = state
    end
})

RunService.RenderStepped:Connect(function()
    if _G.WallClimb then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 25, hrp.Velocity.Z)
        end
    end
end)

local SelectedTargetName = nil 
local LastTeleportedCharacter = nil
_G.AutoTeleport = false

local MoveTab = Window:Tab({ Title = "Movimiento", Icon = "move" })
MoveTab:Section({Title = "Teletransporte a Jugadores"})

local function GetPlayerList()
    local list = {}
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= player then 
            table.insert(list, v.Name) 
        end
    end
    return #list > 0 and list or {"Esperando jugadores..."}
end

local PlayerDropdown = MoveTab:Dropdown({
    Title = "Seleccionar Jugador",
    List = GetPlayerList(),
    Callback = function(Option)
        SelectedTargetName = Option 
    end
})

MoveTab:Button({
    Title = "🔄 Refrescar Lista",
    Callback = function() 
        PlayerDropdown:Refresh(GetPlayerList()) 
    end
})

task.spawn(function()
    while true do
        task.wait(0.45)
        if _G.AutoTeleport and SelectedTargetName then
            local targetPlayer = Players:FindFirstChild(SelectedTargetName)
            local targetChar = targetPlayer and targetPlayer.Character
            local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            local myChar = player.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            
            if targetChar and targetHRP and myHRP and targetChar ~= LastTeleportedCharacter then
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                LastTeleportedCharacter = targetChar
            end
        end
    end
end)

MoveTab:Toggle({
    Title = "Teletransport Player",
    Value = false,
    Callback = function(state)
        _G.AutoTeleport = state
    end
})

MoveTab:Section({Title = "Anti-Contador"})
MoveTab:Toggle({
    Title = "Anti Contador",
    Value = false,
    Callback = function(state)
        _G.SuperBypass = state
        if state then
            task.spawn(function()
                while _G.SuperBypass do
                    pcall(function()
                        local char = player.Character
                        if char then
                            for _, v in ipairs(char:GetDescendants()) do
                                if v:IsA("BasePart") then 
                                    v.Anchored = false 
                                end
                            end
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum and hum.WalkSpeed < 10 then 
                                hum.WalkSpeed = 16 
                            end
                        end
                    end)
                    task.wait(0.12)
                end
            end)
        end
    end
})

AimTab:Section({Title = "Knife"})
local CONFIG = {
    Distancia = 9,
    VelocidadGiro = 6,
    Hitbox = 15,
    HitboxDelay = 0.25,
    DistanciaAtaque = 12,
}

local killAuraActivo = false
local objetivoActual = nil
local mapReady = false
local rondaIniciada = false
local ultimaActualizacionHitbox = 0

ClientGlobals.RunningGames:ListenRaw(function(data)
    mapReady = false
    for _, gameData in pairs(data) do
        if gameData.Phase == "InGame" and gameData.RoundStarted == false and gameData.Protection == nil and not gameData.RoundEnded and not gameData.CurrentRoundEnded then
            mapReady = true
            break
        end
    end
end)

player:GetAttributeChangedSignal("Map"):Connect(function()
    if estaEnLobby() then
        mapReady = false
        rondaIniciada = false
        objetivoActual = nil
    end
end)

player.CharacterAdded:Connect(function()
    objetivoActual = nil
end)

AimTab:Toggle({
    Title = "KillAura",
    Desc = "Aviso pueden banearte",
    Value = false,
    Callback = function(Value)
        killAuraActivo = Value
        if not Value then
            objetivoActual = nil
        end
    end
})

local function aplicarHitboxExtendida()
    if estaEnLobby() then return end
    if tick() - ultimaActualizacionHitbox < 0.25 then return end
    ultimaActualizacionHitbox = tick()

    local mapa = player:GetAttribute("Map")
    local partida = player:GetAttribute("Game")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and isEnemy(p) then
            local character = p.Character

            if character then
                local mapaEnemigo = p:GetAttribute("Map")
                local partidaEnemigo = p:GetAttribute("Game")

                if mapaEnemigo == mapa and partidaEnemigo == partida then
                    local enemyRoot = character:FindFirstChild("HumanoidRootPart")
                    local enemyHumanoid = character:FindFirstChildOfClass("Humanoid")

                    if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                        pcall(function()
                            enemyRoot.Size = Vector3.new(CONFIG.Hitbox, CONFIG.Hitbox, CONFIG.Hitbox)
                            enemyRoot.Transparency = 1
                            enemyRoot.CanCollide = false
                        end)
                    end
                end
            end
        end
    end
end

local function obtenerEnemigoPorMapa()
    if estaEnLobby() then return nil end

    local mapa = player:GetAttribute("Map")
    local partida = player:GetAttribute("Game")

    local miCharacter = player.Character
    if not miCharacter then return nil end

    local miRoot = miCharacter:FindFirstChild("HumanoidRootPart")
    if not miRoot then return nil end

    local enemigoMasCercano = nil
    local menorDistancia = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and isEnemy(p) then
            if p:GetAttribute("Map") == mapa and p:GetAttribute("Game") == partida then

                local character = p.Character
                if character then
                    local enemyRoot = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if enemyRoot and humanoid and humanoid.Health > 0 then
                        local distancia = (enemyRoot.Position - miRoot.Position).Magnitude

                        if distancia < menorDistancia then
                            menorDistancia = distancia
                            enemigoMasCercano = enemyRoot
                        end
                    end
                end
            end
        end
    end

    return enemigoMasCercano
end
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
local function hayPared(origen, destino)
    raycastParams.FilterDescendantsInstances = {player.Character}

    local direccion = destino - origen
    local resultado = workspace:Raycast(origen, direccion, raycastParams)

    return resultado ~= nil
end

local function actualizarObjetivo()
    local objetivoRoot = nil
    if objetivoActual and objetivoActual.Parent then
        local humActual = objetivoActual.Parent:FindFirstChildOfClass("Humanoid")
        local pActual = Players:GetPlayerFromCharacter(objetivoActual.Parent)
        local mapaActual = player:GetAttribute("Map")
        local partidaActual = player:GetAttribute("Game")

        if humActual and humActual.Health > 0 and pActual and pActual:GetAttribute("Map") == mapaActual and pActual:GetAttribute("Game") == partidaActual then
            objetivoRoot = objetivoActual
        end
    end

    if not objetivoRoot then
        objetivoRoot = obtenerEnemigoPorMapa()
        objetivoActual = objetivoRoot
    end
    return objetivoRoot
end
local backpack = player:WaitForChild("Backpack")
task.spawn(function()
    while player:GetAttribute("Map") == nil do
        player:GetAttributeChangedSignal("Map"):Wait()
    end
    while true do
        task.wait(0.05)
        if killAuraActivo and mapReady and not estaEnLobby() then
            aplicarHitboxExtendida()
            local objetivoRoot = actualizarObjetivo()

               if objetivoRoot and objetivoRoot.Parent then
                
               
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = character.HumanoidRootPart
                     local toolEquipada = character:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")
                    if toolEquipada then
                        if toolEquipada.Parent ~= character then
                            toolEquipada.Parent = character
                            task.wait()
                        end
                        local handle = toolEquipada:FindFirstChild("Handle")
                        local killEvent = toolEquipada:FindFirstChild("Kill") or (handle and handle:FindFirstChild("Kill")) or toolEquipada:FindFirstChild("ThrowKill") or (handle and handle:FindFirstChild("ThrowKill"))
                        local enemyHumanoid = objetivoRoot.Parent and objetivoRoot.Parent:FindFirstChildOfClass("Humanoid")

                        if not enemyHumanoid or enemyHumanoid.Health <= 0 then
                            objetivoActual = obtenerEnemigoPorMapa()
                            if not objetivoActual then continue end
                            enemyHumanoid = objetivoActual.Parent:FindFirstChildOfClass("Humanoid")
                            if not enemyHumanoid or enemyHumanoid.Health <= 0 then continue end
                        end

                        pcall(function()
                            local distanciaEnemigo = (rootPart.Position - objetivoRoot.Position).Magnitude
                            local distancia = math.clamp(distanciaEnemigo * 0.6, 6, 10)
                            local direccion = (rootPart.Position - objetivoRoot.Position).Unit
                            local lateral = Vector3.new(-direccion.Z, 0, direccion.X)
                            local offset = (direccion * distancia * 0.4 + lateral * math.sin(tick() * CONFIG.VelocidadGiro) * distancia)
                            local velocidad = objetivoRoot.AssemblyLinearVelocity
                            local prediccion = velocidad * 0.18
                            local destino = objetivoRoot.Position + prediccion + offset

                            if hayPared(rootPart.Position, destino) then
                                local nuevoOffset = lateral * CONFIG.Distancia
                                destino = objetivoRoot.Position + nuevoOffset
                                if hayPared(rootPart.Position, destino) then
                                    nuevoOffset = -lateral * CONFIG.Distancia
                                    destino = objetivoRoot.Position + nuevoOffset
                                end
                            end

                            if (rootPart.Position - destino).Magnitude > 1 then
                                rootPart.CFrame = CFrame.new(destino, objetivoRoot.Position)
                            end

                            if killEvent and killEvent:IsA("RemoteEvent") then
                                killEvent:FireServer(enemyHumanoid)
                            end
                            toolEquipada:Activate()
                        end)
                    end
                end
            else
                objetivoActual = nil
            end
        else
            objetivoActual = nil
            task.wait(0.3)
        end
    end
end)


local autoShootCuchilloEnabled = false
local autoShootTargetPart = "Cabeza"
local enemyCache = {}
local isAttackingWithKnife = false
local KNIFE_HITBOX = 18

local predictionPart = Instance.new("Part")
predictionPart.Name = "YisusPredictionPart"
predictionPart.Size = Vector3.new(0.2, 0.2, 0.2)
predictionPart.Transparency = 1
predictionPart.Anchored = true
predictionPart.CanCollide = false
predictionPart.CanQuery = false
predictionPart.CanTouch = false
predictionPart.Parent = Workspace

pcall(function() getgenv().YisusTargetPart = nil end)

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

local function aplicarHitboxEnemigo(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        hrp.Size = Vector3.new(KNIFE_HITBOX, KNIFE_HITBOX, KNIFE_HITBOX)
        hrp.Transparency = 1
        hrp.CanCollide = false
    end)
end

local function limpiarHitboxEnemigo(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        hrp.Size = Vector3.new(2, 2, 1)
        hrp.Transparency = 1
        hrp.CanCollide = true
    end)
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()

    if not checkcaller() and getgenv().YisusTargetPart and isAttackingWithKnife then
        local target = getgenv().YisusTargetPart

        if target and target.Parent then
            if method == "Raycast" and self == Workspace then
                local origin, direction, p3 = ...
                if typeof(direction) == "Vector3" then
                    local newDir = (target.Position - origin).Unit * 8000
                    return oldNamecall(self, origin, newDir, p3)
                end
            elseif string.find(method, "FindPartOnRay") and self == Workspace then
                local ray, p2, p3, p4 = ...
                if typeof(ray) == "Ray" then
                    local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 8000)
                    return oldNamecall(self, newRay, p2, p3, p4)
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(t, k)
    if not checkcaller() and t == mouse and getgenv().YisusTargetPart and isAttackingWithKnife then
        if k == "Hit" or k == "hit" then
            return getgenv().YisusTargetPart.CFrame
        elseif k == "Target" or k == "target" then
            return getgenv().YisusTargetPart
        end
    end
    return oldIndex(t, k)
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local lastHitboxChars = {}

    while true do
        if autoShootCuchilloEnabled then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                getgenv().YisusTargetPart = nil
                isAttackingWithKnife = false
                task.wait(0.02)
                continue
            end

            local arma = char:FindFirstChildOfClass("Tool")
            if not arma or not arma:FindFirstChild("Handle") or esLaPistola(arma) then
                getgenv().YisusTargetPart = nil
                isAttackingWithKnife = false
                task.wait(0.02)
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
            local currentHitboxChars = {}

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        aplicarHitboxEnemigo(p.Character)
                        currentHitboxChars[p.Character] = true

                        local partesAEscanear = {}
                        if autoShootTargetPart == "Cabeza" then
                            partesAEscanear = {"HumanoidRootPart", "Head", "UpperTorso", "Torso"}
                        elseif autoShootTargetPart == "Torso" then
                            partesAEscanear = {"HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso"}
                        else
                            partesAEscanear = {
                                "HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso",
                                "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg",
                                "LeftArm", "RightArm", "LeftLeg", "RightLeg"
                            }
                        end

                        for _, partName in ipairs(partesAEscanear) do
                            local part = p.Character:FindFirstChild(partName)
                            if part and part:IsA("BasePart") then
                                local priority = (partName == "HumanoidRootPart") and 0 or 1
                                table.insert(objetivosPotenciales, {
                                    Part = part,
                                    Dist = (part.Position - myPos).Magnitude,
                                    Char = p.Character,
                                    Priority = priority
                                })
                            end
                        end
                    end
                end
            end

            for oldChar, _ in pairs(lastHitboxChars) do
                if not currentHitboxChars[oldChar] then
                    limpiarHitboxEnemigo(oldChar)
                end
            end
            lastHitboxChars = currentHitboxChars

            table.sort(objetivosPotenciales, function(a, b)
                if a.Priority ~= b.Priority then
                    return a.Priority < b.Priority
                end
                return a.Dist < b.Dist
            end)

            local closestTargetPart = nil
            local closestEnemyChar = nil

            for _, obj in ipairs(objetivosPotenciales) do
                local part = obj.Part
                params.FilterDescendantsInstances = {char, obj.Char}

                local sizeX, sizeY = part.Size.X / 2.05, part.Size.Y / 2.05
                local cf = part.CFrame

                local visible = not Workspace:Raycast(origin, cf.Position - origin, params)
                if not visible then
                    visible = not Workspace:Raycast(origin, (cf * CFrame.new(sizeX, 0, 0)).Position - origin, params)
                end
                if not visible then
                    visible = not Workspace:Raycast(origin, (cf * CFrame.new(-sizeX, 0, 0)).Position - origin, params)
                end
                if not visible then
                    visible = not Workspace:Raycast(origin, (cf * CFrame.new(0, sizeY, 0)).Position - origin, params)
                end
                if not visible then
                    visible = not Workspace:Raycast(origin, (cf * CFrame.new(0, -sizeY, 0)).Position - origin, params)
                end

                if visible then
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
                        predictionTime = 0.18
                    end

                    if speed > 0.5 then
                        local futurePosition = enemyHRP.Position + (velocity * predictionTime)
                        predictionPart.CFrame = CFrame.new(futurePosition)
                        finalTarget = predictionPart
                    else
                        finalTarget = enemyHRP
                    end
                end

                getgenv().YisusTargetPart = finalTarget

                isAttackingWithKnife = true
                pcall(function()
                    arma:Activate()
                    task.delay(0.004, function()
                        if arma.Parent == char then
                            arma:Deactivate()
                        end
                        isAttackingWithKnife = false
                    end)
                end)

                task.wait(0.008)
            else
                getgenv().YisusTargetPart = nil
                isAttackingWithKnife = false
                task.wait(0.03)
            end
        else
            for oldChar, _ in pairs(lastHitboxChars) do
                limpiarHitboxEnemigo(oldChar)
            end
            lastHitboxChars = {}
            if getgenv().YisusTargetPart then
                getgenv().YisusTargetPart = nil
            end
            isAttackingWithKnife = false
            task.wait(0.08)
        end
    end
end)

AimTab:Toggle({
    Title = "Auto Shoot (Cuchillo)",
    Value = false,
    Callback = function(Value)
        autoShootCuchilloEnabled = Value
        if not Value then
            getgenv().YisusTargetPart = nil
            isAttackingWithKnife = false
        end
    end,
})

AimTab:Dropdown({
    Title = "Target: Parte del cuerpo",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        autoShootTargetPart = Value
    end,
})
local AnimsTab = Window:Tab({ Title = "Animaciones", Icon = "user" })
AnimsTab:Section({Title = "Packs de Animaciones"})

local dropdownRef
local packActualActivo = nil

local function aplicarPackAnimaciones(idsPack)
    task.spawn(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local animateScript = character:WaitForChild("Animate", 5)
        if not animateScript then return end

        animateScript.Disabled = true

        for nombre, id in pairs(idsPack) do
            local carpeta = animateScript:FindFirstChild(nombre)
                or animateScript:FindFirstChild(nombre:gsub("^%l", string.upper) .. "Anim")
                or animateScript:FindFirstChild(nombre:upper())

            if carpeta then
                local nombreAnim = "Animation1"
                if nombre == "idle2" then nombreAnim = "Animation2"
                elseif nombre == "idle3" then nombreAnim = "Animation3"
                elseif nombre == "swimidle" then nombreAnim = "SwimIdle"
                elseif nombre == "walk" then nombreAnim = "WalkAnim"
                elseif nombre == "run" then nombreAnim = "RunAnim"
                elseif nombre == "jump" then nombreAnim = "JumpAnim"
                elseif nombre == "fall" then nombreAnim = "FallAnim"
                elseif nombre == "climb" then nombreAnim = "ClimbAnim"
                elseif nombre == "toolnone" then nombreAnim = "ToolNoneAnim"
                elseif nombre == "toolslash" then nombreAnim = "ToolSlashAnim"
                elseif nombre == "toollunge" then nombreAnim = "ToolLungeAnim"
                elseif nombre == "sit" then nombreAnim = "SitAnim"
                elseif nombre == "wave" then nombreAnim = "WaveAnim"
                elseif nombre == "point" then nombreAnim = "PointAnim"
                elseif nombre == "cheer" then nombreAnim = "CheerAnim"
                elseif nombre == "laugh" then nombreAnim = "LaughAnim"
                elseif nombre == "stylishpose" then nombreAnim = "StylishPose"
                elseif nombre == "ninjapose" then nombreAnim = "NinjaPose"
                elseif nombre == "elderpose" then nombreAnim = "ElderPose" end

                local anim = carpeta:FindFirstChild(nombreAnim)
                if anim and anim:IsA("Animation") then
                    anim.AnimationId = id
                end
            end
        end

        
       
        local function limpiarPose(nombreCarpeta, nombreAnim)
            local carpeta = animateScript:FindFirstChild(nombreCarpeta)
            if carpeta then
                local anim = carpeta:FindFirstChild(nombreAnim)
                if anim and anim:IsA("Animation") then anim.AnimationId = "" end
            end
        end

        limpiarPose("stylishpose", "StylishPose")
        limpiarPose("ninjapose", "NinjaPose")
        limpiarPose("elderpose", "ElderPose")
         task.wait()
        animateScript.Disabled = false
    end)
end

player.CharacterAdded:Connect(function(newChar)
    if packActualActivo then
        aplicarPackAnimaciones(packActualActivo)
    end
end)
local packsAnimaciones = {
    Ninja = { walk = "rbxassetid://10921162768", run = "rbxassetid://10921157929", jump = "rbxassetid://10921160088", fall = "rbxassetid://10921159222", climb = "rbxassetid://10921154678", idle = "rbxassetid://10921155160", ninjapose = "rbxassetid://10921156883", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", swim = "rbxassetid://10922757002", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Zombie = { walk = "rbxassetid://10921355261", run = "rbxassetid://616163682", jump = "rbxassetid://10921351278", fall = "rbxassetid://10921350320", climb = "rbxassetid://10921343576", toolnone = "rbxassetid://507768375", idle = "rbxassetid://10921347258" },
    Stylish = { walk = "rbxassetid://109168724482748", run = "rbxassetid://81024476153754", jump = "rbxassetid://116936326516985", fall = "rbxassetid://92294537340807", climb = "rbxassetid://119377220967554", idle = "rbxassetid://133806214992291", stylishpose = "rbxassetid://87105332133518", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", swim = "rbxassetid://134591743181628", swimidle = "rbxassetid://98854111361360", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Ghost = { walk = "rbxassetid://122150855457006", run = "rbxassetid://82598234841035", jump = "rbxassetid://75290611992385", fall = "rbxassetid://98600215928904", climb = "rbxassetid://88763136693023", idle = "rbxassetid://122257458498464", stylishpose = "rbxassetid://89262795687364", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Mage = { walk = "rbxassetid://84782014405060", run = "rbxassetid://85232146719894", jump = "rbxassetid://140300561900880", fall = "rbxassetid://129591520941189", climb = "rbxassetid://94364927317793", idle = "rbxassetid://133226513780673", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", swim = "rbxassetid://117741052845105", swimidle = "rbxassetid://133871172755161", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Levitation = { walk = "rbxassetid://83842218823011", run = "rbxassetid://118320322718866", jump = "rbxassetid://109996626521204", fall = "rbxassetid://95603166884636", climb = "rbxassetid://97824616490448", idle = "rbxassetid://110211186840347", stylishpose = "rbxassetid://99129837931148", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", swim = "rbxassetid://134530128383903", swimidle = "rbxassetid://94922130551805", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Elder = { walk = "rbxassetid://10921111375", run = "rbxassetid://10921104374", jump = "rbxassetid://10921107367", fall = "rbxassetid://10921105765", climb = "rbxassetid://10921100400", idle = "rbxassetid://10921101664", elderpose = "rbxassetid://10921103538", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", swim = "rbxassetid://10921108971", swimidle = "rbxassetid://1092110146", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Bicicleta = { walk = "rbxassetid://98707881660541", run = "rbxassetid://102775737211919", jump = "rbxassetid://129144847881258", fall = "rbxassetid://110684787086498", climb = "rbxassetid://88267082364595", idle = "rbxassetid://126390120399173", idle2 = "rbxassetid://136791517336633", idle3 = "rbxassetid://14366558676", swim = "rbxassetid://116700888013068", swimidle = "rbxassetid://87621024705272", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" },
    Bubbly = { walk = "rbxassetid://90478085024465", run = "rbxassetid://134824450619865", jump = "rbxassetid://121454505477205", fall = "rbxassetid://94788218468396", climb = "rbxassetid://12114583950231", idle = "rbxassetid://98281136301627", swim = "rbxassetid://105962919001086", swimidle = "rbxassetid://129126268464847", stylishpose = "rbxassetid://133117300343405", toolnone = "rbxassetid://507768375", toollunge = "rbxassetid://522638767", toolslash = "rbxassetid://522635514", sit = "rbxassetid://2506281703", cheer = "rbxassetid://507770677", laugh = "rbxassetid://507770818", wave = "rbxassetid://507770239", point = "rbxassetid://507770453" }
}

dropdownRef = AnimsTab:Dropdown({
    Title = "Seleccionar Pack",
    Values = {"Ninguno", "Ninja", "Zombie", "Stylish", "Ghost", "Mage", "Levitation", "Elder", "Bicicleta", "Bubbly"},
    Value = "Ninguno",
    Callback = function(Value)
        if Value == "Ninguno" then
            packActualActivo = nil
            return
        end
        local pack = packsAnimaciones[Value]
        if pack then
            packActualActivo = pack
            aplicarPackAnimaciones(pack)
            task.delay(0.2, function()
                if dropdownRef and dropdownRef.Set then
                    dropdownRef:Set("Ninguno")
                end
            end)
        end
    end
})

AnimsTab:Section({
    Title = "Emotes"
})

local EmoteTrack

local Emotes = {
    ["YB Jump"] = "15609995579",
    ["Dance"] = "10714340543",
    ["Bubly"] = "93120341268524",
    ["Baile"] = "114774556469581",
    ["Baile2"] = "88050523705839",
    ["mediohueva"] = "92747295139963",
    ["Baile3"] = "104748118296461",
    ["Tusa"] = "18526288497",
}

local function StopEmote()
    if EmoteTrack then
        EmoteTrack:Stop()
        EmoteTrack:Destroy()
        EmoteTrack = nil
    end
end

local function PlayEmote(AnimationId)
    StopEmote()

    local Character = player.Character or player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")

    local Animator = Humanoid:FindFirstChildOfClass("Animator")
    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    local function Reproducir()
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://" .. AnimationId

        EmoteTrack = Animator:LoadAnimation(Animation)
        EmoteTrack.Priority = Enum.AnimationPriority.Action
        EmoteTrack:Play()

        EmoteTrack.Stopped:Connect(function()
            if EmoteTrack then
                task.wait(0.05)
                Reproducir()
            end
        end)
    end

    Reproducir()
end
local function ConectarHumanoid(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.Running:Connect(function(speed)
        if speed > 0 then
            StopEmote()
        end
    end)
end

if player.Character then
    ConectarHumanoid(player.Character)
end

player.CharacterAdded:Connect(ConectarHumanoid)

if player.Character then
    ConectarHumanoid(player.Character)
end

player.CharacterAdded:Connect(ConectarHumanoid)

AnimsTab:Dropdown({
    Title = "Seleccionar Emote",
    Values = {"Ninguno", "YB Jump", "Dance", "Bubly", "Baile", "Baile2", "mediohueva", "Baile3", "Tusa"},
    Value = "Ninguno",

    Callback = function(Value)
        if Value == "Ninguno" then
            StopEmote()
            return
        end

        local Id = Emotes[Value]
        if Id then
            PlayEmote(Id)
        end
    end
})


local PerformanceTab = Window:Tab({
    Title = "⚡ Performance",
    Icon = "gauge"
})

local PerformanceSection = PerformanceTab:Section({
    Title = "🚀 Turbo FPS"
})

PerformanceSection:Toggle({
    Title = "🚀 Turbo FPS",
    Desc = "Optimiza los gráficos para mejorar el rendimiento.",
    Value = false,
    Callback = function(Value)
        if Value then
            local Lighting = game:GetService("Lighting")
            local Terrain = workspace:FindFirstChildOfClass("Terrain")

            Lighting.GlobalShadows = false
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.FogEnd = math.huge
            Lighting.ClockTime = 14

            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)

            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
            end

            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BloomEffect")
                or v:IsA("BlurEffect")
                or v:IsA("ColorCorrectionEffect")
                or v:IsA("SunRaysEffect")
                or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end

            local function optimizar(obj)
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                    obj.Reflectance = 0
                elseif obj:IsA("ParticleEmitter")
                    or obj:IsA("Trail")
                    or obj:IsA("Fire")
                    or obj:IsA("Smoke")
                    or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("Explosion") then
                    obj.BlastPressure = 0
                    obj.BlastRadius = 0
                end
            end

            for _, v in ipairs(workspace:GetDescendants()) do
                optimizar(v)
            end

            workspace.DescendantAdded:Connect(optimizar)
        end
    end
})