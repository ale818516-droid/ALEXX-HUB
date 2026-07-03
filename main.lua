local function SanitizeName(str)
    return tostring(str):gsub('%s+', '')
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera

local function ShowDiscordNotify()
    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "DiscordNotify"
    NotifyGui.Parent = game:GetService("CoreGui")
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 270, 0, 118)
    Frame.Position = UDim2.new(0.5, -135, 0, -130)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Frame.BackgroundTransparency = 0
    Frame.BorderSizePixel = 0
    Frame.Parent = NotifyGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 3)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 210)
    TopBar.BorderSizePixel = 0
    TopBar.ZIndex = 2
    TopBar.Parent = Frame
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = Color3.fromRGB(10, 10, 120)
    Stroke.Parent = Frame
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 32)
    Title.Position = UDim2.new(0, 0, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "ALEXX DISCORD"
    Title.TextColor3 = Color3.fromRGB(30, 30, 220)
    Title.TextSize = 15
    Title.Parent = Frame
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -20, 0, 26)
    Text.Position = UDim2.new(0, 10, 0, 38)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.Gotham
    Text.Text = "Únete a la comunidad de ALEXX"
    Text.TextColor3 = Color3.fromRGB(180, 180, 180)
    Text.TextSize = 12
    Text.Parent = Frame
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 108, 0, 30)
    CopyBtn.Position = UDim2.new(0, 10, 0, 76)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 180)
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.Text = "Copiar Link"
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.TextSize = 12
    CopyBtn.Parent = Frame
    Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0, 108, 0, 30)
    NoBtn.Position = UDim2.new(0, 152, 0, 76)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.Text = "X"
    NoBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    NoBtn.TextSize = 14
    NoBtn.Parent = Frame
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", NoBtn).Color = Color3.fromRGB(50, 50, 50)
    Frame:TweenPosition(UDim2.new(0.5, -135, 0.05, 0), "Out", "Back", 0.5, true)
    CopyBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/8SkRgatM")
        Frame:TweenPosition(UDim2.new(0.5, -135, 0, -130), "In", "Back", 0.4, true)
        task.wait(0.4)
        NotifyGui:Destroy()
    end)
    NoBtn.MouseButton1Click:Connect(function()
        Frame:TweenPosition(UDim2.new(0.5, -135, 0, -130), "In", "Back", 0.4, true)
        task.wait(0.4)
        NotifyGui:Destroy()
    end)
end
ShowDiscordNotify()

local ALEXX_GUI = Instance.new("ScreenGui")
ALEXX_GUI.Name = "ALEXX_FinalSystem"
ALEXX_GUI.Parent = game:GetService("CoreGui")
ALEXX_GUI.IgnoreGuiInset = true
local Launchpad = Instance.new("Frame")
Launchpad.Name = "Launchpad"
Launchpad.Parent = ALEXX_GUI
Launchpad.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Launchpad.BackgroundTransparency = 0.1
Launchpad.Position = UDim2.new(0.1, 0, 0.5, 0)
Launchpad.Size = UDim2.new(0, 47, 0, 47)
Launchpad.Active = true
Instance.new("UICorner", Launchpad).CornerRadius = UDim.new(0, 10)

local LaunchStroke = Instance.new("UIStroke")
LaunchStroke.Parent = Launchpad
LaunchStroke.Thickness = 2.5
LaunchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Sustituye esta parte en tu script:
local LogoImage = Instance.new("ImageLabel")
LogoImage.Parent = Launchpad
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://108497694953547" -- ID actualizado
LogoImage.Size = UDim2.new(0, 42, 0, 42)
LogoImage.Position = UDim2.new(0.5, -21, 0.5, -21)
LogoImage.ScaleType = Enum.ScaleType.Fit


local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Parent = ALEXX_GUI
MainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainMenu.BackgroundTransparency = 0.06
MainMenu.AnchorPoint = Vector2.new(0.5, 0.5)
MainMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
MainMenu.Size = UDim2.new(0, 450, 0, 320)
MainMenu.Visible = false
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Parent = MainMenu
MenuStroke.Thickness = 2.5
MenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local RedBar = Instance.new("Frame")
RedBar.Size = UDim2.new(1, 0, 0, 3)
RedBar.BackgroundColor3 = Color3.fromRGB(25, 25, 210)
RedBar.BorderSizePixel = 0
RedBar.ZIndex = 3
RedBar.Parent = MainMenu
Instance.new("UICorner", RedBar).CornerRadius = UDim.new(0, 12)

local SidePanel = Instance.new("Frame")
SidePanel.Parent = MainMenu
SidePanel.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
SidePanel.BackgroundTransparency = 0
SidePanel.Size = UDim2.new(0, 110, 1, 0)
SidePanel.BorderSizePixel = 0
Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 12)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 1, 0.85, 0)
Divider.Position = UDim2.new(0, 110, 0.075, 0)
Divider.BackgroundColor3 = Color3.fromRGB(10, 10, 60)
Divider.BorderSizePixel = 0
Divider.Parent = MainMenu

local ScriptName = Instance.new("TextLabel")
ScriptName.Name = "ScriptName"
ScriptName.Parent = SidePanel
ScriptName.BackgroundTransparency = 1
ScriptName.Position = UDim2.new(0, 0, 0, 10)
ScriptName.Size = UDim2.new(1, 0, 0, 40)
ScriptName.Font = Enum.Font.LuckiestGuy
ScriptName.Text = "- ALEXX HUB"
ScriptName.TextSize = 24
ScriptName.TextColor3 = Color3.fromRGB(30, 30, 220)

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(0.6, 0, 0, 1)
TitleLine.Position = UDim2.new(0.2, 0, 0, 48)
TitleLine.BackgroundColor3 = Color3.fromRGB(20, 20, 180)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = SidePanel

local SystemButtons = Instance.new("Frame")
SystemButtons.Parent = MainMenu
SystemButtons.BackgroundTransparency = 1
SystemButtons.Position = UDim2.new(1, -70, 0, 10)
SystemButtons.Size = UDim2.new(0, 60, 0, 25)

local function CreateSysBtn(text, color, pos)
    local btn = Instance.new("TextButton")
    btn.Parent = SystemButtons
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local CloseBtn    = CreateSysBtn("✕", Color3.fromRGB(15, 15, 160), UDim2.new(0, 35, 0, 0))
local MinimizeBtn = CreateSysBtn("−", Color3.fromRGB(40, 40, 40),  UDim2.new(0, 0, 0, 0))
Instance.new("UIStroke", CloseBtn).Color    = Color3.fromRGB(30, 30, 220)
Instance.new("UIStroke", MinimizeBtn).Color = Color3.fromRGB(60, 60, 60)

local TabBtnHolder = Instance.new("Frame")
TabBtnHolder.Parent = SidePanel
TabBtnHolder.BackgroundTransparency = 1
TabBtnHolder.Position = UDim2.new(0, 0, 0, 60)
TabBtnHolder.Size = UDim2.new(1, 0, 1, -60)

local ContentHolder = Instance.new("Frame")
ContentHolder.Parent = MainMenu
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 120, 0, 45)
ContentHolder.Size = UDim2.new(1, -135, 1, -60)

local function CreateTab(name, isDefault)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabBtnHolder
    TabBtn.Size = UDim2.new(1, -10, 0, 32)
    TabBtn.Position = UDim2.new(0, 5, 0, (#TabBtnHolder:GetChildren() - 1) * 36)
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(10, 10, 130) or Color3.fromRGB(22, 22, 22)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name
    TabBtn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
    TabBtn.TextSize = 11
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = isDefault and Color3.fromRGB(30, 30, 220) or Color3.fromRGB(40, 40, 40)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = TabBtn

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Parent = ContentHolder
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = isDefault
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(10, 10, 150)

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = TabPage
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local Padding = Instance.new("UIPadding")
    Padding.Parent = TabPage
    Padding.PaddingTop = UDim.new(0, 15)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentHolder:GetChildren()) do
            v.Visible = false
        end
        for _, v in pairs(TabBtnHolder:GetChildren()) do
            if v:IsA("TextButton") then
                v.TextColor3 = Color3.fromRGB(160, 160, 160)
                v.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                if v:FindFirstChild("UIStroke") then
                    v:FindFirstChild("UIStroke").Color = Color3.fromRGB(40, 40, 40)
                end
            end
        end
        TabPage.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 130)
        Stroke.Color = Color3.fromRGB(30, 30, 220)
    end)
    return TabPage
end

local EspPage     = CreateTab("Esp",     true)
local AimPage     = CreateTab("Aim",     false)
local HitboxPage = CreateTab("Hitbox", false)

local spooferEnabled = false
local btnSpoofer = Instance.new("TextButton")
btnSpoofer.Parent = EspPage
btnSpoofer.Size = UDim2.new(0.95, 0, 0, 35)
btnSpoofer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnSpoofer.Font = Enum.Font.GothamBlack
btnSpoofer.Text = "Name Spoofer: OFF"
btnSpoofer.TextColor3 = Color3.fromRGB(200, 200, 200)
btnSpoofer.TextSize = 13
Instance.new("UICorner", btnSpoofer).CornerRadius = UDim.new(0, 8)

local SpooferStroke = Instance.new("UIStroke", btnSpoofer)
SpooferStroke.Thickness = 1.2
SpooferStroke.Color = Color3.fromRGB(50, 50, 50)

local TagColor = "rgb(0, 255, 255)"
local NuevoNombre = '<font color="' .. TagColor .. '">[MOD]</font> ALEXX'
local NombrePlano = "[MOD] ALEXX"
local NombreReal = LocalPlayer.Name
local DisplayReal = LocalPlayer.DisplayName

local function AplicarEstilo(instancia)
    if not spooferEnabled then
        return
    end
    if instancia:IsA("TextLabel") or instancia:IsA("TextButton") then
        if string.find(instancia.Text, NombreReal) or string.find(instancia.Text, DisplayReal) then
            instancia.RichText = true
            instancia.Text = string.gsub(instancia.Text, NombreReal, NuevoNombre)
            instancia.Text = string.gsub(instancia.Text, DisplayReal, NuevoNombre)
        end
    end
end

local function MonitorizarInterfaz(parent)
    parent.DescendantAdded:Connect(function(descendant)
        if spooferEnabled then
            task.wait(0.1)
            AplicarEstilo(descendant)
        end
    end)
end

MonitorizarInterfaz(LocalPlayer.PlayerGui)
MonitorizarInterfaz(game:GetService("CoreGui"))

task.spawn(function()
    while true do
        if spooferEnabled then
            pcall(function()
                if LocalPlayer.DisplayName ~= NombrePlano then
                    LocalPlayer.DisplayName = NombrePlano
                end
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.DisplayName ~= NombrePlano then
                        hum.DisplayName = NombrePlano
                    end
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                            for _, texto in ipairs(v:GetDescendants()) do
                                AplicarEstilo(texto)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

btnSpoofer.MouseButton1Click:Connect(function()
    spooferEnabled = not spooferEnabled
    btnSpoofer.Text = spooferEnabled and "Name Spoofer: ON" or "Name Spoofer: OFF"
    btnSpoofer.TextColor3 = spooferEnabled and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(200, 200, 200)
    SpooferStroke.Color = spooferEnabled and Color3.fromRGB(0, 180, 200) or Color3.fromRGB(50, 50, 50)
    if spooferEnabled then
        for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            AplicarEstilo(v)
        end
    else
        LocalPlayer.DisplayName = DisplayReal
    end
end)

LaunchStroke.Color = Color3.fromRGB(25, 25, 210)
MenuStroke.Color = Color3.fromRGB(25, 25, 210)
ScriptName.TextColor3 = Color3.fromRGB(30, 30, 220)

task.spawn(function()
    while true do
        TweenService:Create(ScriptName, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(60, 60, 255),
            TextTransparency = 0,
        }):Play()
        task.wait(0.8)
        TweenService:Create(ScriptName, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(10, 10, 160),
            TextTransparency = 0.1,
        }):Play()
        task.wait(0.8)
    end
end)

task.spawn(function()
    while true do
        TweenService:Create(MenuStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 3.5,
            Color = Color3.fromRGB(40, 40, 255),
        }):Play()
        task.wait(1.2)
        TweenService:Create(MenuStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 1.5,
            Color = Color3.fromRGB(8, 8, 120),
        }):Play()
        task.wait(1.2)
    end
end)

task.spawn(function()
    while true do
        TweenService:Create(LaunchStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 3.5,
            Color = Color3.fromRGB(50, 50, 255),
        }):Play()
        task.wait(1.0)
        TweenService:Create(LaunchStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 1.5,
            Color = Color3.fromRGB(8, 8, 110),
        }):Play()
        task.wait(1.0)
    end
end)

local dragging, dragInput, dragStart, startPos
local dragThreshold = 5

Launchpad.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragStart = input.Position
        startPos = Launchpad.Position
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
                if not dragging then
                    MainMenu.Visible = true
                    Launchpad.Visible = false
                end
                dragging = false
            end
        end)
    end
end)

Launchpad.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
        if dragStart and (input.Position - dragStart).Magnitude > dragThreshold then
            dragging = true
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Launchpad.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
    Launchpad.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    ALEXX_GUI:Destroy()
end)

local espEnabled = true
local highlightObjects = {}
local localTeamCache = nil

local function getLocalTeam()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return nil end
    local main = playerGui:FindFirstChild("Main")
    if not main then return nil end
    local mainGameFrame = main:FindFirstChild("MainGameFrame")
    if not mainGameFrame then return nil end
    local playersFrame = mainGameFrame:FindFirstChild("PlayersFrame")
    if not playersFrame then return nil end
    
    local teamRed = playersFrame:FindFirstChild("TeamRedFrame")
    local teamBlue = playersFrame:FindFirstChild("TeamBlueFrame")
    
    if teamRed and teamRed:FindFirstChild(LocalPlayer.Name) then
        return "Red"
    elseif teamBlue and teamBlue:FindFirstChild(LocalPlayer.Name) then
        return "Blue"
    end
    return nil
end

-- Primero, cambia tu función isEnemy a esta versión universal
local function isEnemy(player)
    -- Si el juego usa atributos (como en Krynex), esto es infalible:
    local myTeam = LocalPlayer:GetAttribute("Team")
    local targetTeam = player:GetAttribute("Team")
    
    -- Si el juego no usa atributos, probamos comparación de equipo estándar de Roblox
    if myTeam and targetTeam then
        return myTeam ~= targetTeam
    end
    
    -- Fallback: Si no hay atributos, comparamos el nombre del equipo del jugador
    if player.Team and LocalPlayer.Team then
        return player.Team ~= LocalPlayer.Team
    end
    
    return false -- Si no se puede determinar, por seguridad no marca
end

local btnEsp = Instance.new("TextButton")
btnEsp.Parent = EspPage
btnEsp.Size = UDim2.new(0.95, 0, 0, 35)
btnEsp.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnEsp.Font = Enum.Font.GothamBlack
btnEsp.Text = "ESP: ON"
btnEsp.TextColor3 = Color3.fromRGB(30, 30, 220)
btnEsp.TextSize = 13
Instance.new("UICorner", btnEsp).CornerRadius = UDim.new(0, 8)

local EspStroke = Instance.new("UIStroke", btnEsp)
EspStroke.Thickness = 1.2
EspStroke.Color = Color3.fromRGB(20, 20, 180)
local function updateESP()
    if not espEnabled then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local char = otherPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Si es enemigo y está vivo
                if isEnemy(otherPlayer) and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local highlight = highlightObjects[otherPlayer]
                    
                    -- Busca esta parte en tu función updateESP y cámbiala por esto:
if not highlight or highlight.Parent ~= char then
    if highlight then pcall(function() highlight:Destroy() end) end
    
    highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = _G.HitboxColor -- <--- AHORA USA TU VARIABLE GLOBAL
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = char
    highlightObjects[otherPlayer] = highlight
end

                else
                    -- Si es aliado o está muerto, quitamos el ESP
                    if highlightObjects[otherPlayer] then
                        pcall(function() highlightObjects[otherPlayer]:Destroy() end)
                        highlightObjects[otherPlayer] = nil
                    end
                end
            end
        end
    end
end
local function clearESP()
    for _, highlight in pairs(highlightObjects) do
        pcall(function() highlight:Destroy() end)
    end
    highlightObjects = {}
end

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    updateESP()
end)

Players.PlayerRemoving:Connect(function(p)
    local highlight = highlightObjects[p]
    if highlight then
        pcall(function() highlight:Destroy() end)
        highlightObjects[p] = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateESP()
end)

local lastESPUpdate = 0
RunService.RenderStepped:Connect(function()
    if espEnabled then
        local now = tick()
        if now - lastESPUpdate >= 0.5 then
            pcall(updateESP)
            lastESPUpdate = now
        end
    end
end)

btnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        btnEsp.Text = "ESP: ON"
        btnEsp.TextColor3 = Color3.fromRGB(30, 30, 220)
        EspStroke.Color = Color3.fromRGB(20, 20, 180)
        updateESP()
    else
        btnEsp.Text = "ESP: OFF"
        btnEsp.TextColor3 = Color3.fromRGB(200, 200, 200)
        EspStroke.Color = Color3.fromRGB(50, 50, 50)
        clearESP()
    end
end)

updateESP()

local aimEnabled = false
local btnSilentAim = Instance.new("TextButton")
btnSilentAim.Parent = AimPage
btnSilentAim.Size = UDim2.new(0.95, 0, 0, 35)
btnSilentAim.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnSilentAim.Font = Enum.Font.GothamBlack
btnSilentAim.Text = "SILENT AIM: OFF"
btnSilentAim.TextColor3 = Color3.fromRGB(200, 200, 200)
btnSilentAim.TextSize = 13
Instance.new("UICorner", btnSilentAim).CornerRadius = UDim.new(0, 8)

local AimStroke = Instance.new("UIStroke", btnSilentAim)
AimStroke.Thickness = 1.2
AimStroke.Color = Color3.fromRGB(50, 50, 50)

-- CORRECCIONES DE ESTRUCTURA Y SINTAXIS
local function getBestTargetSilent()
    local target = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            
            if hrp and hum and hum.Health > 0 and isEnemy(p) then
                local prediction = hrp.Velocity * 0.08
                local predictedPos = p.Character.Head.Position + prediction
                
                local pos, onScreen = camera:WorldToViewportPoint(predictedPos)
                
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        target = CFrame.new(predictedPos)
                    end
                end
            end
        end
    end
    return target
end

local function enableSilentAim()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(self, index)
        if aimEnabled and self == Mouse and (index == "Hit" or index == "Target") then
            local target = getBestTargetSilent()
            if target then
                if index == "Hit" then return target end
                if index == "Target" then return target.Position end
            end
        end
        return oldIndex(self, index)
    end)
    
    setreadonly(mt, true)
end

-- Asegúrate de usar esta única función de desactivación
local function disableSilentAim()
    aimEnabled = false
end

local function disableSilentAim()
    -- Para restaurar, simplemente recargamos el metatable original 
    -- o reiniciamos el juego/script. 
    -- Nota: Algunas ejecuciones no permiten "desactivar" el Hook tan fácil.
    -- Si no se desactiva, una opción es hacer un flag booleano.
    aimEnabled = false 
end

local function disableSilentAim()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = oldIndex
    setreadonly(mt, true)
end

btnSilentAim.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    btnSilentAim.Text = aimEnabled and "SILENT AIM: ON" or "SILENT AIM: OFF"
    btnSilentAim.TextColor3 = aimEnabled and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(200, 200, 200)
    AimStroke.Color = aimEnabled and Color3.fromRGB(200, 30, 70) or Color3.fromRGB(50, 50, 50)
    
    if aimEnabled then
        enableSilentAim()
    else
        disableSilentAim()
    end
end)

local hitboxEnabled = false
_G.HitboxSize = 10
_G.HitboxColor = Color3.fromRGB(30, 30, 220)
_G.HitboxTransparency = 0.7

local btnHitbox = Instance.new("TextButton")
btnHitbox.Parent = HitboxPage
btnHitbox.Size = UDim2.new(0.95, 0, 0, 35)
btnHitbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnHitbox.Font = Enum.Font.GothamBlack
btnHitbox.Text = "HITBOX EXPANDER: OFF"
btnHitbox.TextColor3 = Color3.fromRGB(200, 200, 200)
btnHitbox.TextSize = 13

local hitboxCorner = Instance.new("UICorner", btnHitbox)
hitboxCorner.CornerRadius = UDim.new(0, 8)

local hitboxStroke = Instance.new("UIStroke", btnHitbox)
hitboxStroke.Thickness = 1.2
_G.HitboxColor = Color3.fromRGB(30, 30, 220)
_G.HitboxTransparency = 0.7

btnHitbox.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    
    if hitboxEnabled then
        btnHitbox.Text = "HITBOX EXPANDER: ON"
        btnHitbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnHitbox:FindFirstChild("UIStroke").Color = _G.HitboxColor
    else
        btnHitbox.Text = "HITBOX EXPANDER: OFF"
        btnHitbox.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnHitbox:FindFirstChild("UIStroke").Color = Color3.fromRGB(50, 50, 50)
        
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
end)
local lblColors = Instance.new("TextLabel")
lblColors.Parent = HitboxPage
lblColors.Size = UDim2.new(0.95, 0, 0, 25)
lblColors.BackgroundTransparency = 1
lblColors.Font = Enum.Font.GothamBold
lblColors.Text = "SELECT COLOR:"
lblColors.TextColor3 = Color3.fromRGB(180, 180, 180)
lblColors.TextSize = 12

local ColorGrid = Instance.new("Frame")
ColorGrid.Parent = HitboxPage
ColorGrid.Size = UDim2.new(0.95, 0, 0, 35)
ColorGrid.BackgroundTransparency = 1

local GridLayout = Instance.new("UIGridLayout")
GridLayout.Parent = ColorGrid
GridLayout.CellSize = UDim2.new(0, 30, 0, 30)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 0)
GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateColorBtn(color, transparency, isInv)
    local btn = Instance.new("TextButton")
    btn.Parent = ColorGrid
    btn.Text = isInv and "Ø" or ""
    btn.BackgroundColor3 = isInv and Color3.fromRGB(20, 20, 20) or color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 4)
    
    if isInv then
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(100, 100, 100)
    end

    btn.MouseButton1Click:Connect(function()
        _G.HitboxColor = color
        _G.HitboxTransparency = transparency
        
        -- Cambiar el botón del menú
        if hitboxEnabled then
            btnHitbox:FindFirstChild("UIStroke").Color = isInv and Color3.fromRGB(100, 100, 100) or color
        end
        
        -- ESTO CONECTA EL ESP AL MOMENTO:
        for _, highlight in pairs(highlightObjects) do
            highlight.FillColor = _G.HitboxColor
        end
    end)
end

CreateColorBtn(Color3.fromRGB(30, 30, 220), 0.7, false)
CreateColorBtn(Color3.fromRGB(0, 150, 255), 0.7, false)
CreateColorBtn(Color3.fromRGB(0, 255, 100), 0.7, false)
CreateColorBtn(Color3.fromRGB(255, 255, 0), 0.7, false)
CreateColorBtn(Color3.fromRGB(150, 0, 255), 0.7, false)
CreateColorBtn(Color3.fromRGB(0, 255, 255), 0.7, false)
CreateColorBtn(Color3.fromRGB(255, 255, 255), 0.7, false)
CreateColorBtn(Color3.fromRGB(255, 100, 0), 0.7, false)
CreateColorBtn(Color3.fromRGB(120, 120, 120), 0.7, false)
CreateColorBtn(Color3.fromRGB(0, 0, 0), 1, true)

local lblSize = Instance.new("TextLabel")
lblSize.Parent = HitboxPage
lblSize.Size = UDim2.new(0.95, 0, 0, 25)
lblSize.BackgroundTransparency = 1
lblSize.Font = Enum.Font.GothamBold
lblSize.Text = "HITBOX SIZE: 10"
lblSize.TextColor3 = Color3.fromRGB(180, 180, 180)
lblSize.TextSize = 12

local SliderBack = Instance.new("Frame")
SliderBack.Parent = HitboxPage
SliderBack.Size = UDim2.new(0.9, 0, 0, 6)
SliderBack.Position = UDim2.new(0.05, 0, 0, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SliderBack.BorderSizePixel = 0

local SliderMain = Instance.new("Frame")
SliderMain.Parent = SliderBack
SliderMain.Size = UDim2.new(0.4, 0, 1, 0)
SliderMain.BackgroundColor3 = _G.HitboxColor
SliderMain.BorderSizePixel = 0

local SliderBtn = Instance.new("TextButton")
SliderBtn.Parent = SliderMain
SliderBtn.Size = UDim2.new(0, 18, 0, 18)
SliderBtn.Position = UDim2.new(1, -9, 0.5, -9)
SliderBtn.Text = ""
SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", SliderMain).CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(1, 0)

local UIS = game:GetService("UserInputService")
local dragging = false

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
    SliderMain.Size = UDim2.new(pos, 0, 1, 0)
    _G.HitboxSize = math.floor(pos * 25)
    lblSize.Text = "HITBOX SIZE: " .. tostring(_G.HitboxSize)
    SliderMain.BackgroundColor3 = _G.HitboxColor
end

SliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2) -- Un poco más rápido para que la reacción sea fluida
        if hitboxEnabled then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local HRP = player.Character:FindFirstChild("HumanoidRootPart")
                        local Hum = player.Character:FindFirstChild("Humanoid")
                        
                        if HRP and Hum and Hum.Health > 0 and isEnemy(player) then
                            -- Crear Raycast para verificar visibilidad
                            local origin = camera.CFrame.Position
                            local direction = (HRP.Position - origin)
                            local params = RaycastParams.new()
                            params.FilterType = Enum.RaycastFilterType.Exclude
                            params.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                            
                            local result = workspace:Raycast(origin, direction, params)
                            
                            -- Si no hay nada entre nosotros y el enemigo, está visible
                            if not result then
                                HRP.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                                HRP.Transparency = _G.HitboxTransparency
                            else
                                -- Hay una pared o pared de por medio: Hitbox pequeña (Disimulada)
                                HRP.Size = Vector3.new(2, 2, 1)
                                HRP.Transparency = 1
                            end
                            
                            HRP.Color = _G.HitboxColor
                            HRP.Material = Enum.Material.Neon
                            HRP.CanCollide = false
                        else
                            -- Reset si es aliado o está muerto
                            if HRP then
                                HRP.Size = Vector3.new(2, 2, 1)
                                HRP.Transparency = 1
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- BLOQUE FINAL: Botones de Cielo en la Pestaña Hitbox
local btnSky1 = Instance.new("TextButton")
btnSky1.Parent = HitboxPage
btnSky1.Size = UDim2.new(0.95, 0, 0, 35)
btnSky1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnSky1.Text = "CIELO 1: 97135569821603"
btnSky1.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSky1.Font = Enum.Font.GothamBold
btnSky1.TextSize = 12
Instance.new("UICorner", btnSky1).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", btnSky1).Color = Color3.fromRGB(30, 30, 220)

btnSky1.MouseButton1Click:Connect(function()
    local Lighting = game:GetService("Lighting")
    for _, obj in pairs(Lighting:GetChildren()) do if obj:IsA("Sky") then obj:Destroy() end end
    local mySky = Instance.new("Sky")
    local myID = "rbxassetid://97135569821603"
    mySky.SkyboxBk, mySky.SkyboxDn, mySky.SkyboxFt = myID, myID, myID
    mySky.SkyboxLf, mySky.SkyboxRt, mySky.SkyboxUp = myID, myID, myID
    mySky.Parent = Lighting
end)

local btnSky2 = Instance.new("TextButton")
btnSky2.Parent = HitboxPage
btnSky2.Size = UDim2.new(0.95, 0, 0, 35)
btnSky2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnSky2.Text = "CIELO 2: 74875043101164"
btnSky2.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSky2.Font = Enum.Font.GothamBold
btnSky2.TextSize = 12
Instance.new("UICorner", btnSky2).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", btnSky2).Color = Color3.fromRGB(200, 50, 50)

btnSky2.MouseButton1Click:Connect(function()
    local Lighting = game:GetService("Lighting")
    for _, obj in pairs(Lighting:GetChildren()) do if obj:IsA("Sky") then obj:Destroy() end end
    local mySky = Instance.new("Sky")
    local myID = "rbxassetid://74875043101164"
    mySky.SkyboxBk, mySky.SkyboxDn, mySky.SkyboxFt = myID, myID, myID
    mySky.SkyboxLf, mySky.SkyboxRt, mySky.SkyboxUp = myID, myID, myID
    mySky.Parent = Lighting
end)
