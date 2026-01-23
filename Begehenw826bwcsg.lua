-- CashBundle AutoFarm with License System
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

-- Discord Webhook для логов
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1463945548368183431/n44wGNnBsNLZx-sdUwTgFtFpP9lMgvBHKjzZcCFVPrKpnFks8nMCnYPhuKAX2Kai9zoQ"

-- Система лицензирования
local player = Players.LocalPlayer
local GAMEPASS_ID = 1683085244
local GAMEPASS_LINK = "https://www.roblox.com/game-pass/1683085244/Unlock-Farm"

-- Переменные состояния лицензии
local hasGamePass = false
local mainScriptLoaded = false

-- Функция для проверки геймпасса
local function checkGamePass()
    local success, result = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
    end)
    
    if success then
        hasGamePass = result
        return result
    end
    return false
end

-- Создаем интерфейс с кнопкой покупки
local function createBuyGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FarmLoaderGUI"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "LoaderContainer"
    mainFrame.Size = UDim2.new(0.3, 0, 0.12, 0)
    mainFrame.Position = UDim2.new(0.35, 0, 0.44, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 0)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0.35, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "CASH BUNDLE AUTO FARM"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextScaled = false
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = mainFrame
    
    -- Кнопка покупки
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyButton"
    buyButton.Size = UDim2.new(0.8, 0, 0.5, 0)
    buyButton.Position = UDim2.new(0.1, 0, 0.45, 0)
    buyButton.Text = "BUY TO ACTIVATE (1000R$)"
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    buyButton.BackgroundTransparency = 0
    buyButton.Visible = true
    buyButton.ZIndex = 2
    buyButton.Font = Enum.Font.GothamBold
    buyButton.TextSize = 16
    buyButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = buyButton
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = buyButton
    
    -- Индикатор загрузки
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0.8, 0, 0.08, 0)
    loadingFrame.Position = UDim2.new(0.1, 0, 0.88, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    loadingFrame.BackgroundTransparency = 0.5
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Visible = false
    loadingFrame.Parent = mainFrame
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 4)
    loadingCorner.Parent = loadingFrame
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Name = "LoadingBar"
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.Position = UDim2.new(0, 0, 0, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = loadingBar
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, 0, 1, 0)
    loadingText.Position = UDim2.new(0, 0, 0, 0)
    loadingText.Text = "LOADING..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 12
    loadingText.TextScaled = false
    loadingText.BackgroundTransparency = 1
    loadingText.Parent = loadingFrame
    
    -- Обработчик клика по кнопке
    buyButton.MouseButton1Click:Connect(function()
        setclipboard(GAMEPASS_LINK)
        local originalText = buyButton.Text
        local originalColor = buyButton.BackgroundColor3
        
        buyButton.Text = "LINK COPIED!"
        buyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        task.wait(2)
        buyButton.Text = originalText
        buyButton.BackgroundColor3 = originalColor
    end)
    
    buyButton.MouseEnter:Connect(function()
        if buyButton.Text ~= "LINK COPIED!" then
            buyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
    end)
    
    buyButton.MouseLeave:Connect(function()
        if buyButton.Text ~= "LINK COPIED!" then
            buyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        end
    end)
    
    local function showLoading(show, text)
        loadingFrame.Visible = show
        if text then
            loadingText.Text = text
        end
        
        if show then
            coroutine.wrap(function()
                local width = 0
                while loadingFrame.Visible do
                    width = (width + 0.01) % 1
                    loadingBar.Size = UDim2.new(width, 0, 1, 0)
                    task.wait(0.03)
                end
                loadingBar.Size = UDim2.new(0, 0, 1, 0)
            end)()
        end
    end
    
    local function updateTitle(text)
        titleLabel.Text = text
    end
    
    return screenGui, buyButton, showLoading, updateTitle
end

-- ========== НАЧАЛО ОСНОВНОГО СКРИПТА АВТОФАРМА ==========

-- Получаем локального игрока
local character = player.Character

if not character then
    player.CharacterAdded:Wait()
    character = player.Character
end

local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Функция для отправки логов в Discord
local function sendDiscordLog(action, details)
    pcall(function()
        local currentTime = os.date("%H:%M")
        local playerName = player.Name
        local playerId = tostring(player.UserId)
        
        local embed = {
            title = "💰 CashBundle AutoFarm",
            color = 0x00FF00,
            fields = {
                {
                    name = "👤 Игрок",
                    value = string.format("%s (%s)", playerName, playerId),
                    inline = true
                },
                {
                    name = "🕐 Время",
                    value = currentTime,
                    inline = true
                },
                {
                    name = "📝 Действие",
                    value = action,
                    inline = false
                }
            }
        }
        
        if details then
            table.insert(embed.fields, {
                name = "📊 Детали",
                value = details,
                inline = false
            })
        end
        
        local data = {
            embeds = {embed},
            username = "CashBundle Logger"
        }
        
        local jsonData = HttpService:JSONEncode(data)
        
        request({
            Url = DISCORD_WEBHOOK,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
end

-- Хранилище для посещенных серверов
local visitedServers = {}
local currentJobId = game.JobId

-- Функция для сохранения и загрузки посещенных серверов
local function loadVisitedServers()
    pcall(function()
        if readfile and isfile and isfile("CashBundleVisitedServers.txt") then
            visitedServers = HttpService:JSONDecode(readfile("CashBundleVisitedServers.txt"))
        else
            visitedServers = {}
        end
    end)
end

local function saveVisitedServers()
    pcall(function()
        if writefile then
            if #visitedServers > 100 then
                table.remove(visitedServers, 1)
            end
            writefile("CashBundleVisitedServers.txt", HttpService:JSONEncode(visitedServers))
        end
    end)
end

loadVisitedServers()

if not table.find(visitedServers, currentJobId) then
    table.insert(visitedServers, currentJobId)
    saveVisitedServers()
end

-- Находим папку с объектами
local function findCashBundleFolder()
    local function searchFolder(folder)
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name == "CashBundle" then
                return child
            end
            if child:IsA("Folder") then
                local result = searchFolder(child)
                if result then
                    return result
                end
            end
        end
        return nil
    end
    
    return searchFolder(workspace) or searchFolder(game)
end

local cashBundleFolder = findCashBundleFolder()

if not cashBundleFolder then
    return
end

-- Переменные для управления
local isLooping = false
local teleportDelay = 0.5
local connection = nil
local lastObjectCheckTime = 0
local lastValidObjectsCount = 0
local checkTimer = 0
local blacklist = {}
local safeZonePosition = Vector3.new(0, 100, 0)
local isServerHopPending = false
local serverHopDelay = 3
local hopCounter = 0
local maxHopBeforeAntiDetect = 5
local lastServerHopTime = 0
local totalObjectsFarmed = 0
local hasLoggedStart = false

-- Таблицы для отслеживания объектов
local visitedObjects = {}
local validObjects = {}
local maxVisits = 10

-- Функция для добавления объекта в черный список
local function addToBlacklist(object)
    if not blacklist[object] then
        blacklist[object] = true
        
        for i, obj in ipairs(validObjects) do
            if obj == object then
                table.remove(validObjects, i)
                break
            end
        end
    end
end

-- Функция для телепортации в сейфзону
local function teleportToSafeZone()
    local currentCFrame = humanoidRootPart.CFrame
    local currentRotation = currentCFrame - currentCFrame.Position
    
    humanoidRootPart.CFrame = CFrame.new(safeZonePosition) * currentRotation
    return true
end

-- Улучшенная функция для поиска доступных серверов
local function findAvailableServer()
    local placeId = game.PlaceId
    
    local success, result = pcall(function()
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        local response = game:HttpGet(url)
        return HttpService:JSONDecode(response)
    end)
    
    if success and result and result.data then
        local availableServers = {}
        
        for _, server in ipairs(result.data) do
            if server.id ~= currentJobId and 
               not table.find(visitedServers, server.id) and
               server.playing >= 2 and 
               server.playing < server.maxPlayers - 2 then
                table.insert(availableServers, server)
            end
        end
        
        if #availableServers > 0 then
            local selectedServer = availableServers[math.random(1, #availableServers)]
            return selectedServer.id
        else
            for _, server in ipairs(result.data) do
                if server.id ~= currentJobId and 
                   server.playing >= 2 and 
                   server.playing < server.maxPlayers - 2 then
                    return server.id
                end
            end
        end
    end
    
    return nil
end

-- Улучшенная функция для выполнения сервер-хопа
local function performServerHop()
    if isServerHopPending then return end
    
    isServerHopPending = true
    hopCounter = hopCounter + 1
    lastServerHopTime = tick()
    
    if hopCounter % maxHopBeforeAntiDetect == 0 then
        local platform = Instance.new("Part")
        platform.Name = "AntiDetectPlatform"
        platform.Size = Vector3.new(30, 5, 30)
        platform.Position = Vector3.new(0, 300, 0)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Neon
        platform.BrickColor = BrickColor.new("Bright green")
        platform.Parent = workspace
        
        if character and humanoidRootPart then
            humanoidRootPart.CFrame = platform.CFrame + Vector3.new(0, 10, 0)
        end
        
        task.wait(25)
        platform:Destroy()
    end
    
    local newServerId = findAvailableServer()
    
    if newServerId then
        if not table.find(visitedServers, newServerId) then
            table.insert(visitedServers, newServerId)
            saveVisitedServers()
        end
        
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, newServerId, player)
        end)
    else
        task.wait(2)
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end
    
    isServerHopPending = false
end

-- Функция для телепортации в сейфзону с последующим сервер-хопом
local function teleportToSafeZoneWithHop()
    teleportToSafeZone()
    
    local countdown = serverHopDelay
    while countdown > 0 do
        task.wait(1)
        countdown = countdown - 1
    end
    
    performServerHop()
end

-- Функция для обновления списка объектов
local function updateValidObjects()
    validObjects = {}
    visitedObjects = {}
    
    for _, obj in ipairs(cashBundleFolder:GetChildren()) do
        if not blacklist[obj] then
            table.insert(validObjects, obj)
            visitedObjects[obj] = 0
        end
    end
end

updateValidObjects()

-- Функция для прилипания к объекту БЕЗ ВРАЩЕНИЯ
local function stickToObject(object)
    local objectPosition = nil
    
    if object:IsA("BasePart") then
        objectPosition = object.Position
    elseif object:IsA("Model") then
        local primaryPart = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
        if primaryPart then
            objectPosition = primaryPart.Position
        end
    end
    
    if objectPosition then
        local currentCFrame = humanoidRootPart.CFrame
        local currentRotation = currentCFrame - currentCFrame.Position
        
        humanoidRootPart.CFrame = CFrame.new(objectPosition) * currentRotation
        
        visitedObjects[object] = (visitedObjects[object] or 0) + 1
        
        if visitedObjects[object] >= maxVisits then
            addToBlacklist(object)
        end
        
        totalObjectsFarmed = totalObjectsFarmed + 1
        
        return true
    end
    return false
end

-- Функция для проверки активных объектов
local function checkActiveObjects(deltaTime)
    checkTimer = checkTimer + deltaTime
    
    if checkTimer >= 1 then
        checkTimer = 0
        
        if #validObjects == 1 then
            if lastValidObjectsCount == 1 then
                lastObjectCheckTime = lastObjectCheckTime + 1
                
                if lastObjectCheckTime >= 3 then
                    local lastObject = validObjects[1]
                    if lastObject then
                        addToBlacklist(lastObject)
                        teleportToSafeZoneWithHop()
                        
                        lastObjectCheckTime = 0
                        lastValidObjectsCount = 0
                    end
                end
            else
                lastValidObjectsCount = 1
                lastObjectCheckTime = 0
            end
        else
            lastValidObjectsCount = #validObjects
            lastObjectCheckTime = 0
        end
        
        if #validObjects == 0 and isLooping then
            teleportToSafeZoneWithHop()
        end
    end
end

-- Функция для автоматического обновления списка объектов
local function startObjectUpdater()
    local updaterConnection = nil
    
    updaterConnection = RunService.Heartbeat:Connect(function(deltaTime)
        checkActiveObjects(deltaTime)
        
        task.wait(2)
        
        if not cashBundleFolder then return end
        
        local currentObjects = cashBundleFolder:GetChildren()
        local needsUpdate = false
        
        if #currentObjects ~= #validObjects + #blacklist then
            needsUpdate = true
        else
            for _, obj in ipairs(currentObjects) do
                local found = false
                for _, validObj in ipairs(validObjects) do
                    if validObj == obj then
                        found = true
                        break
                    end
                end
                if not found and not blacklist[obj] then
                    needsUpdate = true
                    break
                end
            end
        end
        
        if needsUpdate then
            updateValidObjects()
            
            for obj, count in pairs(visitedObjects) do
                if obj.Parent and obj.Parent == cashBundleFolder then
                    for _, validObj in ipairs(validObjects) do
                        if validObj == obj then
                            visitedObjects[validObj] = count
                            break
                        end
                    end
                else
                    visitedObjects[obj] = nil
                end
            end
        end
    end)
    
    return updaterConnection
end

-- Основная функция бесконечного цикла
local function startStickingLoop()
    if isLooping then return end
    
    isLooping = true
    lastObjectCheckTime = 0
    lastValidObjectsCount = 0
    checkTimer = 0
    
    -- Логируем только вход
    if not hasLoggedStart then
        sendDiscordLog("🚀 Вход в систему", "Активировал в " .. os.date("%H:%M"))
        hasLoggedStart = true
    end
    
    local updater = startObjectUpdater()
    
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not isLooping or not character or not humanoidRootPart then
            connection:Disconnect()
            if updater then updater:Disconnect() end
            return
        end
        
        if isServerHopPending then
            return
        end
        
        if #validObjects == 0 then
            teleportToSafeZoneWithHop()
            return
        end
        
        local randomIndex = math.random(1, #validObjects)
        local object = validObjects[randomIndex]
        
        if object and object.Parent then
            stickToObject(object)
            task.wait(teleportDelay)
        else
            table.remove(validObjects, randomIndex)
            visitedObjects[object] = nil
        end
    end)
end

-- Функция остановки цикла
local function stopStickingLoop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    isLooping = false
    
    -- Логируем только выход с количеством объектов
    sendDiscordLog("🛑 Выход из системы", string.format("Зафармил объектов: %d", totalObjectsFarmed))
end

-- Функция начальной активации
local function initialActivation()
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid:Move(Vector3.new(0, 0, -0.1), true)
        task.wait(0.1)
        humanoid:Move(Vector3.new(0, 0, 0), true)
    end
    
    task.wait(2)
    return true
end

-- Основная функция автофарма
local function startAutoFarm()
    initialActivation()
    startStickingLoop()
    
    coroutine.wrap(function()
        while true do
            task.wait(300)
            
            if isLooping and tick() - lastServerHopTime > 600 then
                teleportToSafeZoneWithHop()
            end
        end
    end)()
end

-- ========== КОНЕЦ ОСНОВНОГО СКРИПТА АВТОФАРМА ==========

-- Функция для запуска основного скрипта
local function startMainScript()
    if mainScriptLoaded then return true end
    
    -- Запускаем автофарм
    coroutine.wrap(function()
        task.wait(1)
        startAutoFarm()
    end)()
    
    mainScriptLoaded = true
    return true
end

-- Основная функция инициализации загрузчика
local function initializeLoader()
    local timerGUI, buyButton, showLoading, updateTitle = createBuyGUI()
    
    -- Проверяем наличие геймпасса
    hasGamePass = checkGamePass()
    
    local function activateScriptAndShowSuccess()
        showLoading(true, "ACTIVATING...")
        updateTitle("ACTIVATING SCRIPT...")
        
        task.wait(2)
        
        local success = startMainScript()
        
        if success then
            showLoading(false)
            updateTitle("SCRIPT ACTIVE")
            
            -- Скрываем GUI после успешной активации
            task.wait(3)
            if timerGUI then
                timerGUI:Destroy()
            end
        else
            showLoading(false)
            updateTitle("ACTIVATION FAILED")
        end
    end
    
    if hasGamePass then
        -- Если геймпас есть, сразу активируем
        updateTitle("GAMEPASS DETECTED")
        task.wait(1)
        activateScriptAndShowSuccess()
    else
        -- Если геймпасса нет, показываем кнопку покупки
        updateTitle("PURCHASE REQUIRED")
        
        -- Периодически проверяем наличие геймпасса
        coroutine.wrap(function()
            while not hasGamePass do
                task.wait(5)
                hasGamePass = checkGamePass()
                
                if hasGamePass then
                    updateTitle("GAMEPASS DETECTED")
                    buyButton.Visible = false
                    task.wait(1)
                    activateScriptAndShowSuccess()
                    break
                end
            end
        end)()
    end
end

-- Автоматически останавливаем при выходе из игры
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        stopStickingLoop()
    end
end)

-- Запускаем скрипт
coroutine.wrap(function()
    task.wait(1)
    initializeLoader()
end)()
