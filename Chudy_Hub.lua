-- ChudyHub: Minimalne menu z Set Base i TP do Bazy
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Zmienna do przechowywania pozycji bazy
local basePosition = nil

-- Tworzenie GUI huba
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChudyHubMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 190)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ChudyHub Menu"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 30
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 54)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.ZIndex = 2

local MenuFrame = Instance.new("Frame", MainFrame)
MenuFrame.Size = UDim2.new(1, -40, 0, 110)
MenuFrame.Position = UDim2.new(0, 20, 0, 60)
MenuFrame.BackgroundTransparency = 0.22
MenuFrame.BackgroundColor3 = Color3.fromRGB(45, 55, 85)
MenuFrame.BorderSizePixel = 0

local infoLabel = Instance.new("TextLabel", MainFrame)
infoLabel.Size = UDim2.new(1, -40, 0, 24)
infoLabel.Position = UDim2.new(0, 20, 0, 170)
infoLabel.Text = ""
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 17
infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
infoLabel.BackgroundTransparency = 1
infoLabel.TextWrapped = true

-- Funkcja ustawiająca bazę
function setBase()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        basePosition = LocalPlayer.Character.HumanoidRootPart.Position
        infoLabel.Text = "Baza ustawiona!"
    else
        infoLabel.Text = "Brak postaci!"
    end
end

-- Funkcja teleportująca do bazy
function teleportToBase()
    if basePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
        infoLabel.Text = "Teleportowano do bazy!"
    else
        infoLabel.Text = "Najpierw ustaw bazę!"
    end
end

-- Przycisk Set Base
local setBaseButton = Instance.new("TextButton", MenuFrame)
setBaseButton.Text = "Set Base"
setBaseButton.Size = UDim2.new(0.5, -12, 0, 48)
setBaseButton.Position = UDim2.new(0, 6, 0, 14)
setBaseButton.Font = Enum.Font.GothamBold
setBaseButton.TextSize = 22
setBaseButton.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
setBaseButton.TextColor3 = Color3.fromRGB(25,25,40)
setBaseButton.BorderSizePixel = 0
setBaseButton.AutoButtonColor = true

setBaseButton.MouseButton1Click:Connect(setBase)

-- Przycisk TP do bazy
local tpButton = Instance.new("TextButton", MenuFrame)
tpButton.Text = "TP do Bazy"
tpButton.Size = UDim2.new(0.5, -12, 0, 48)
tpButton.Position = UDim2.new(0.5, 6, 0, 14)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 22
tpButton.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
tpButton.TextColor3 = Color3.fromRGB(25,25,40)
tpButton.BorderSizePixel = 0
tpButton.AutoButtonColor = true

tpButton.MouseButton1Click:Connect(teleportToBase)
