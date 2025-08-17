-- ChudyHub: Pełny skrypt z menu, ESP, TP, Base
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Zmienna do przechowywania pozycji bazy
local basePosition = nil

-- Tworzenie GUI huba
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChudyHubDelta"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ChudyHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 56)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.ZIndex = 2

local MenuFrame = Instance.new("Frame", MainFrame)
MenuFrame.Size = UDim2.new(1, -36, 0, 140)
MenuFrame.Position = UDim2.new(0, 18, 0, 56)
MenuFrame.BackgroundTransparency = 0.4
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
MenuFrame.BorderSizePixel = 0

local infoLabel = Instance.new("TextLabel", MainFrame)
infoLabel.Size = UDim2.new(1, -36, 0, 30)
infoLabel.Position = UDim2.new(0, 18, 0, 200)
infoLabel.Text = ""
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 18
infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
infoLabel.BackgroundTransparency = 1

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
setBaseButton.Size = UDim2.new(0.5, -12, 0, 44)
setBaseButton.Position = UDim2.new(0, 6, 0, 18)
setBaseButton.Font = Enum.Font.GothamBold
setBaseButton.TextSize = 20
setBaseButton.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
setBaseButton.TextColor3 = Color3.fromRGB(25,25,40)
setBaseButton.BorderSizePixel = 0

setBaseButton.MouseButton1Click:Connect(setBase)

-- Przycisk TP do bazy
local tpButton = Instance.new("TextButton", MenuFrame)
tpButton.Text = "TP do Bazy"
tpButton.Size = UDim2.new(0.5, -12, 0, 44)
tpButton.Position = UDim2.new(0.5, 6, 0, 18)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 20
tpButton.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
tpButton.TextColor3 = Color3.fromRGB(25,25,40)
tpButton.BorderSizePixel = 0

tpButton.MouseButton1Click:Connect(teleportToBase)

-- Automatyczny teleport do bazy po zdobyciu brainrota
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child.Name:lower():find("brainrot") then
        teleportToBase()
        infoLabel.Text = "Automatyczny TP do bazy!"
    end
end)

-- ESP KOLORY
local brainrotESPColor = Color3.fromRGB(255, 255, 0) -- żółty
local bestBrainrotColor = Color3.fromRGB(0,255,0)     -- zielony
local playerESPColor = Color3.fromRGB(72, 195, 255)   -- jasnoniebieski

-- Brainrot ESP
local brainrotESPObjects = {}

local function clearBrainrotESP()
    for _,v in pairs(brainrotESPObjects) do
        if v and v.Parent then v:Destroy() end
    end
    brainrotESPObjects = {}
end

local function createBrainrotESP(part, value, isBest)
    if brainrotESPObjects[part] then return end
    local bill = Instance.new("BillboardGui", part)
    bill.Size = UDim2.new(0, 120, 0, 36)
    bill.StudsOffset = Vector3.new(0, part.Size.Y/2 + 1.5, 0)
    bill.Adornee = part
    bill.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.Text = (isBest and "NAJ Brainrot: $" or "Brainrot: $") .. tostring(value)
    label.TextColor3 = isBest and bestBrainrotColor or brainrotESPColor
    brainrotESPObjects[part] = bill
end

-- Player ESP (tylko kolorowy prostokąt nad graczem, bez nicku)
local playerESPObjects = {}

local function clearPlayerESP()
    for _,v in pairs(playerESPObjects) do
        if v and v.Parent then v:Destroy() end
    end
    playerESPObjects = {}
end

local function createPlayerESP(char)
    if playerESPObjects[char] then return end
    if char:FindFirstChild("Head") then
        local bill = Instance.new("BillboardGui", char.Head)
        bill.Size = UDim2.new(0, 32, 0, 32)
        bill.StudsOffset = Vector3.new(0, 2.6, 0)
        bill.Adornee = char.Head
        bill.AlwaysOnTop = true
        local box = Instance.new("Frame", bill)
        box.Size = UDim2.new(1,0,1,0)
        box.BackgroundColor3 = playerESPColor
        box.BackgroundTransparency = 0.3
        box.BorderSizePixel = 0
        playerESPObjects[char] = bill
    end
end

-- Pętla ESP
RunService.RenderStepped:Connect(function()
    -- Brainrot ESP
    clearBrainrotESP()
    local maxValue = 0
    local bestBrainrot = nil
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("brainrot") then
            local value = 0
            if v:FindFirstChild("Value") and v.Value:IsA("NumberValue") then
                value = v.Value.Value
            elseif v:GetAttribute("Value") then
                value = v:GetAttribute("Value")
            end
            if value > maxValue then
                maxValue = value
                bestBrainrot = v
            end
        end
    end
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("brainrot") then
            local value = 0
            if v:FindFirstChild("Value") and v.Value:IsA("NumberValue") then
                value = v.Value.Value
            elseif v:GetAttribute("Value") then
                value = v:GetAttribute("Value")
            end
            createBrainrotESP(v, value, v == bestBrainrot)
        end
    end

    -- Player ESP (podświetlenie, bez nicku)
    clearPlayerESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            createPlayerESP(plr.Character)
        end
    end
end)
