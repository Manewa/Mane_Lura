local clickOrder = {}
local frame = CreateFrame("Frame", "MonAddonFrame", UIParent, "BackdropTemplate")
local hideTimer = nil

frame:SetSize(300, 200)
frame:SetPoint("CENTER")

frame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

frame:SetBackdropColor(0, 0, 0, 1)

-- Rend la fenêtre déplaçable
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")

frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
local counterText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
counterText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
counterText:SetText("0")
local function UpdateCounter()
    counterText:SetText(#clickOrder .. " / 5")
end

local button1 = CreateFrame("Button", nil, frame, "BackdropTemplate")

button1:SetSize(60, 60)
button1:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)

button1:SetBackdrop({
    bgFile = "Interface/Buttons/UI-Quickslot2",
})

-- 🔥 ICÔNE (c’est ICI que tu mets ton chemin)
local icon1 = button1:CreateTexture(nil, "ARTWORK")
icon1:SetAllPoints()

icon1:SetTexture("Interface/AddOns/Mane_Lura/Icons/TriangleLura.png")
-- 👉 Remplace cette ligne par TON chemin

button1:SetScript("OnClick", function()
    table.insert(clickOrder, "Triangle")
    UpdateCounter()
end)

local button2 = CreateFrame("Button", nil, frame, "BackdropTemplate")
button2:SetSize(60, 60)
button2:SetPoint("TOPLEFT", button1, "TOPRIGHT", 10, 0)

local icon2 = button2:CreateTexture(nil, "ARTWORK")
icon2:SetAllPoints()
icon2:SetTexture("Interface/AddOns/Mane_Lura/Icons/XLura.png")

button2:SetScript("OnClick", function()
    table.insert(clickOrder, "X")
    UpdateCounter()
end)

local button3 = CreateFrame("Button", nil, frame, "BackdropTemplate")
button3:SetSize(60, 60)
button3:SetPoint("TOPLEFT", button2, "TOPRIGHT", 10, 0)

local icon3 = button3:CreateTexture(nil, "ARTWORK")
icon3:SetAllPoints()
icon3:SetTexture("Interface/AddOns/Mane_Lura/Icons/DiamondLura.png")

button3:SetScript("OnClick", function()
    table.insert(clickOrder, "Diamond")
    UpdateCounter()
end)

local button4 = CreateFrame("Button", nil, frame, "BackdropTemplate")
button4:SetSize(60, 60)
button4:SetPoint("TOPLEFT", button3, "TOPRIGHT", 10, 0)

local icon4 = button4:CreateTexture(nil, "ARTWORK")
icon4:SetAllPoints()
icon4:SetTexture("Interface/AddOns/Mane_Lura/Icons/TLura.png")

button4:SetScript("OnClick", function()
    table.insert(clickOrder, "T")
    UpdateCounter()
end)

local button5 = CreateFrame("Button", nil, frame, "BackdropTemplate")
button5:SetSize(60, 60)
button5:SetPoint("TOP", button2, "BOTTOM", 35, -10)

local icon5 = button5:CreateTexture(nil, "ARTWORK")
icon5:SetAllPoints()
icon5:SetTexture("Interface/AddOns/Mane_Lura/Icons/MoonLura.png")

button5:SetScript("OnClick", function()
    table.insert(clickOrder, "Moon")
    UpdateCounter()
end)

local send = CreateFrame("Button", nil, frame, "BackdropTemplate")
send:SetSize(90, 40)
send:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)

local icon_send = send:CreateTexture(nil, "ARTWORK")
icon_send:SetAllPoints()
icon_send:SetTexture("Interface/AddOns/Mane_Lura/Icons/Send.png")

send:SetScript("OnClick", function()
    local message = table.concat(clickOrder, ",")

    channelID = GetChannelName("LuraChannel")

    if channelID ~= 0 then
    SendChatMessage("LURA:" .. message, "CHANNEL", nil, channelID)
    else
        print("Canal non rejoint")
    end

    HandleSequence(message, UnitName("player"))

    clickOrder = {}
    wipe(clickOrder)
    UpdateCounter()
end)

SLASH_LURA1 = "/lura"

SlashCmdList["LURA"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

local displayFrame = CreateFrame("Frame", "LuraDisplayFrame", UIParent, "BackdropTemplate")

displayFrame:SetSize(300, 200)
displayFrame:SetPoint("CENTER")

displayFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

displayFrame:SetBackdropColor(0, 0, 0, 1)
displayFrame:Hide()

displayFrame:SetMovable(true)
displayFrame:EnableMouse(true)
displayFrame:RegisterForDrag("LeftButton")

displayFrame:SetScript("OnDragStart", displayFrame.StartMoving)
displayFrame:SetScript("OnDragStop", displayFrame.StopMovingOrSizing)

icons = {}

local function HandleSequence(message, sender)
    displayFrame:Show()

    -- nettoyage ancien affichage
    for _, icon in ipairs(icons) do
        icon:Hide()
    end
    wipe(icons)
    wipe(clickOrder)

-- annule ancien timer
if hideTimer then
    hideTimer:Cancel()
end

-- nouveau timer
hideTimer = C_Timer.NewTimer(10, function()
    displayFrame:Hide()
end)

    local i = 1
    local positions = {
    {x = 100, y = 50},   -- 1 (haut gauche)
    {x = 50,  y = 0},   -- 2 (haut droite)
    {x = 0,   y = -50},    -- 3 (centre)
    {x = -50, y = 0},  -- 4 (bas gauche)
    {x = -100,  y = 50},  -- 5 (bas droite)
}
    for value in string.gmatch(message, "([^,]+)") do
        if not icons[i] then
            icons[i] = displayFrame:CreateTexture(nil, "ARTWORK")
            icons[i]:SetSize(40, 40)
        end

        local tex = icons[i]
        tex:Show()

        local pos = positions[i]
        if pos then
            tex:SetPoint("CENTER", displayFrame, "CENTER", pos.x, pos.y)
        end

        if value == "Triangle" then
            tex:SetTexture("Interface/AddOns/Mane_Lura/Icons/TriangleLura.png")
        elseif value == "X" then
            tex:SetTexture("Interface/AddOns/Mane_Lura/Icons/XLura.png")
        elseif value == "Diamond" then
            tex:SetTexture("Interface/AddOns/Mane_Lura/Icons/DiamondLura.png")
        elseif value == "T" then
            tex:SetTexture("Interface/AddOns/Mane_Lura/Icons/TLura.png")
        elseif value == "Moon" then
            tex:SetTexture("Interface/AddOns/Mane_Lura/Icons/MoonLura.png")
        end

        i = i + 1
    end
end

local listener = CreateFrame("Frame")

listener:RegisterEvent("CHAT_MSG_CHANNEL")

listener:SetScript("OnEvent", function(self, event, message, sender)
    if string.sub(message, 1, 5) == "LURA:" then
        local data = string.sub(message, 6)
        HandleSequence(data, sender)
    end
end)