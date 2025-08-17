local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Tworzenie nowoczesnego GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "LennonLikeHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Gradient background
local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 195, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 50, 255))
}
UIGradient.Rotation = 45

-- Animacja wejścia
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 400, 0, 300)}):Play()

-- Nowoczesny tytuł
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "LennonLike HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)

-- Menu boczne
local SideMenu = Instance.new("Frame", MainFrame)
SideMenu.Size = UDim2.new(0, 110, 1, -50)
SideMenu.Position = UDim2.new(0, 0, 0, 50)
SideMenu.BackgroundTransparency = 0.4
SideMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
SideMenu.BorderSizePixel = 0

-- Przyciski menu
local buttons = {
    {Name = "Set Base", Desc = "Ustaw swoją bazę"},
    {Name = "Brainrot TP", Desc = "Automatyczny teleport do bazy"},
    {Name = "AutoFarm", Desc = "Automatyczne farmienie"},
    {Name = "Exit", Desc = "Zamknij HUB"}
}

local basePosition = nil

for i, btn in ipairs(buttons) do
    local Button = Instance.new("TextButton", SideMenu)
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, (i-1)*45 + 10)
    Button.Text = btn.Name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 18
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(75, 75, 135)
    Button.BorderSizePixel = 0
    Button.BackgroundTransparency = 0.2
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(72, 195, 255)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(75, 75, 135)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if btn.Name == "Set Base" then
            basePosition = LocalPlayer.Character.HumanoidRootPart.Position
            Title.Text = "Baza ustawiona!"
        elseif btn.Name == "Brainrot TP" then
            if basePosition then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
                Title.Text = "Teleport do bazy!"
            else
                Title.Text = "Najpierw ustaw bazę!"
            end
        elseif btn.Name == "AutoFarm" then
            -- Tu dodaj logikę AutoFarm do konkretnej gry!
            Title.Text = "AutoFarm: Włączony!"
        elseif btn.Name == "Exit" then
            ScreenGui:Destroy()
        end
    end)
end

-- Listener na zdobycie brainrota
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child.Name:lower():find("brainrot") then
        if basePosition then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
            Title.Text = "Brainrot: Teleportacja!"
        else
            Title.Text = "Brainrot: Najpierw ustaw bazę!"
        end
    end
end)
