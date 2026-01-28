local VELOCIDADE_DESEJADA = 36
local VELOCIDADE_PADRAO = 16

local SpeedOn = false
local SavedCFrame = nil
local Aberto = true
local TpMarker = nil

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KikiScript"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,170,0,150)
frame.Position = UDim2.new(0,15,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = frame

-- Barra superior
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1,0,0,30)
dragBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
dragBar.BorderSizePixel = 0
dragBar.Parent = frame

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0,10)
dragCorner.Parent = dragBar

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-35,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "KIKI 🌹 SCRIPT"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dragBar

-- Botão ≡
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,30,0,30)
toggleBtn.Position = UDim2.new(1,-30,0,0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = dragBar

-- Botão Speed
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(1,-20,0,28)
speedBtn.Position = UDim2.new(0,10,0,40)
speedBtn.BackgroundColor3 = Color3.fromRGB(255,60,60)
speedBtn.Text = "SPD: OFF"
speedBtn.TextColor3 = Color3.fromRGB(255,255,255)
speedBtn.Font = Enum.Font.SourceSansBold
speedBtn.TextSize = 14
speedBtn.Parent = frame

local spdCorner = Instance.new("UICorner")
spdCorner.CornerRadius = UDim.new(0,6)
spdCorner.Parent = speedBtn

-- Input
local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,22)
input.Position = UDim2.new(0,10,0,74)
input.BackgroundColor3 = Color3.fromRGB(35,35,35)
input.PlaceholderText = "Velocidade"
input.Text = tostring(VELOCIDADE_DESEJADA)
input.TextColor3 = Color3.fromRGB(255,255,255)
input.Font = Enum.Font.SourceSansBold
input.TextSize = 13
input.ClearTextOnFocus = false
input.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0,6)
inputCorner.Parent = input

-- SET TP
local setTpBtn = Instance.new("TextButton")
setTpBtn.Size = UDim2.new(1,-20,0,24)
setTpBtn.Position = UDim2.new(0,10,0,102)
setTpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
setTpBtn.Text = "SET TP"
setTpBtn.TextColor3 = Color3.fromRGB(255,255,255)
setTpBtn.Font = Enum.Font.SourceSansBold
setTpBtn.TextSize = 13
setTpBtn.Parent = frame

local setCorner = Instance.new("UICorner")
setCorner.CornerRadius = UDim.new(0,6)
setCorner.Parent = setTpBtn

-- GO TP
local goTpBtn = Instance.new("TextButton")
goTpBtn.Size = UDim2.new(1,-20,0,24)
goTpBtn.Position = UDim2.new(0,10,0,128)
goTpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
goTpBtn.Text = "GO TP"
goTpBtn.TextColor3 = Color3.fromRGB(255,255,255)
goTpBtn.Font = Enum.Font.SourceSansBold
goTpBtn.TextSize = 13
goTpBtn.Parent = frame

local goCorner = Instance.new("UICorner")
goCorner.CornerRadius = UDim.new(0,6)
goCorner.Parent = goTpBtn

-- Abrir / Fechar
toggleBtn.MouseButton1Click:Connect(function()
	Aberto = not Aberto
	local alvo = Aberto and UDim2.new(0,170,0,150) or UDim2.new(0,170,0,30)
	TweenService:Create(frame,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=alvo}):Play()
end)

-- Drag
local dragging, dragStart, startPos
dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Velocidade
input.FocusLost:Connect(function()
	local num = tonumber(input.Text)
	if num then VELOCIDADE_DESEJADA = math.clamp(num,1,500) end
end)

speedBtn.MouseButton1Click:Connect(function()
	SpeedOn = not SpeedOn
	speedBtn.Text = SpeedOn and "SPD: ON" or "SPD: OFF"
	speedBtn.BackgroundColor3 = SpeedOn and Color3.fromRGB(0,180,0) or Color3.fromRGB(255,60,60)
end)

-- SET TP + MARCADOR AZUL
setTpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		SavedCFrame = char.HumanoidRootPart.CFrame

		if not TpMarker then
			TpMarker = Instance.new("Part")
			TpMarker.Size = Vector3.new(3,0.2,3)
			TpMarker.Anchored = true
			TpMarker.CanCollide = false
			TpMarker.Material = Enum.Material.Neon
			TpMarker.Color = Color3.fromRGB(0,140,255)
			TpMarker.Shape = Enum.PartType.Cylinder
			TpMarker.Orientation = Vector3.new(0,0,90)
			TpMarker.Parent = workspace
		end

		TpMarker.Position = Vector3.new(
			SavedCFrame.Position.X,
			SavedCFrame.Position.Y + 0.1,
			SavedCFrame.Position.Z
		)

		setTpBtn.Text = "TP MARCADO ✓"
		task.delay(1.2,function()
			setTpBtn.Text = "SET TP"
		end)
	end
end)

-- GO TP
goTpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") and SavedCFrame then
		char.HumanoidRootPart.CFrame = SavedCFrame
	end
end)

-- Loop Speed
RunService.Heartbeat:Connect(function()
	if SpeedOn then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = VELOCIDADE_DESEJADA end
	end
end)
