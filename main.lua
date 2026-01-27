local VELOCIDADE_DESEJADA = 36 -- ALTERADO AQUI
local VELOCIDADE_PADRAO = 16

local SpeedOn = false
local InvisOn = false
local SavedCFrame = nil

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedInvisTPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 110, 0, 130)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 6)
cornerFrame.Parent = frame

-- Barra de arraste
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 22)
dragBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
dragBar.BorderSizePixel = 0
dragBar.Parent = frame

local dragText = Instance.new("TextLabel")
dragText.Size = UDim2.new(1,0,1,0)
dragText.BackgroundTransparency = 1
dragText.Text = "≡  ARRASTAR"
dragText.TextColor3 = Color3.fromRGB(200,200,200)
dragText.Font = Enum.Font.SourceSansBold
dragText.TextSize = 14
dragText.Parent = dragBar

-- Drag mobile perfeito
local dragging, dragInput, dragStart, startPos

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Criar botão
local function CriarBotao(texto, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 24)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(255,50,50)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,4)
    corner.Parent = btn

    return btn
end

-- Botões
local speedBtn = CriarBotao("SPD: OFF", 26)
local invisBtn = CriarBotao("INV: OFF", 52)
local setBtn   = CriarBotao("SET TP", 78)
local tpBtn    = CriarBotao("GO TP", 104)

-- Invisibilidade
local function SetInvisible(state)
    local char = player.Character or player.CharacterAdded:Wait()
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = state and 1 or 0
            obj.LocalTransparencyModifier = state and 1 or 0
        elseif obj:IsA("Decal") then
            obj.Transparency = state and 1 or 0
        end
    end
end

-- Speed
speedBtn.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    speedBtn.Text = SpeedOn and "SPD: ON" or "SPD: OFF"
    speedBtn.BackgroundColor3 = SpeedOn and Color3.fromRGB(0,180,0) or Color3.fromRGB(255,50,50)

    if not SpeedOn and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = VELOCIDADE_PADRAO
    end
end)

-- Invis
invisBtn.MouseButton1Click:Connect(function()
    InvisOn = not InvisOn
    invisBtn.Text = InvisOn and "INV: ON" or "INV: OFF"
    invisBtn.BackgroundColor3 = InvisOn and Color3.fromRGB(0,180,0) or Color3.fromRGB(255,50,50)
    SetInvisible(InvisOn)
end)

-- SET TP
setBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        SavedCFrame = char.HumanoidRootPart.CFrame
        setBtn.Text = "SET ✔"
        setBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
        task.delay(1,function()
            setBtn.Text = "SET TP"
            setBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
        end)
    end
end)

-- GO TP
tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and SavedCFrame then
        char.HumanoidRootPart.CFrame = SavedCFrame
    end
end)

-- Loop speed
RunService.Heartbeat:Connect(function()
    if SpeedOn then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= VELOCIDADE_DESEJADA then
            hum.WalkSpeed = VELOCIDADE_DESEJADA
        end
    end
end)

-- Reaplicar invis
player.CharacterAdded:Connect(function()
    task.wait(0.6)
    if InvisOn then
        SetInvisible(true)
    end
end)
