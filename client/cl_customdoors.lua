Config = Config or {}
Config.Doors = Config.Doors or {}
Config.Shells = Config.Shells or {}

local lastMessageTime = 0
local activeSession = nil -- Tracks the current door/shell the player is in
local spawnedShells = {}

Citizen.CreateThread(function()
    -- Spawn shells on start
    for _, shell in ipairs(Config.Shells) do
        if shell.shellModel and not spawnedShells[shell.coords] then
            RequestModel(GetHashKey(shell.shellModel))
            while not HasModelLoaded(GetHashKey(shell.shellModel)) do
                Citizen.Wait(10)
            end

            local shellObject = CreateObject(GetHashKey(shell.shellModel), shell.shellCoords.x, shell.shellCoords.y, shell.shellCoords.z, false, false, false)
            SetEntityHeading(shellObject, shell.shellHeading)
            FreezeEntityPosition(shellObject, true)
            spawnedShells[shell.coords] = shellObject
        end
    end

    -- Notify about nearby doors and shells
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearDoor = false

        for _, item in ipairs(Config.Doors) do
            if #(playerCoords - item.coords) <= item.radius then
                isNearDoor = true
                if GetGameTimer() - lastMessageTime >= 30000 then
                    TriggerEvent('chatMessage', '', {255, 255, 255}, '^4[INFO]: ^0You are near a door. Use ^3/enter^7 to enter this interior.')
                    lastMessageTime = GetGameTimer()
                end
                break
            end
        end

        for _, shell in ipairs(Config.Shells) do
            if #(playerCoords - shell.coords) <= shell.radius then
                isNearDoor = true
                if GetGameTimer() - lastMessageTime >= 30000 then
                    TriggerEvent('chatMessage', '', {255, 255, 255},'^4[INFO]: ^0You are near a door. Use ^3/enter^7 to enter this interior.')
                    lastMessageTime = GetGameTimer()
                end
                break
            end
        end
    end
end)

RegisterCommand("enter", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, door in ipairs(Config.Doors) do
        if #(playerCoords - door.coords) <= door.radius then
            SetEntityCoords(playerPed, door.enterCoords.x, door.enterCoords.y, door.enterCoords.z, false, false, false, true)
            TriggerServerEvent('customdoors:setRoutingBucket', door.coords)
            activeSession = { type = "door", coords = door.coords }
            return
        end
    end

    for _, shell in ipairs(Config.Shells) do
        if #(playerCoords - shell.coords) <= shell.radius then
            SetEntityCoords(playerPed, shell.enterCoords.x, shell.enterCoords.y, shell.enterCoords.z, false, false, false, true)
            TriggerServerEvent('customdoors:setRoutingBucket', shell.coords)
            activeSession = { type = "shell", coords = shell.coords }
            return
        end
    end

    TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0You are not near any enter point.')
end, false)

RegisterCommand("exit", function()
    if not activeSession then
        TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0You are not in any interior.')
        return
    end

    local playerPed = PlayerPedId()
    local exitCoords = nil

    if activeSession.type == "door" then
        for _, door in ipairs(Config.Doors) do
            if door.coords == activeSession.coords then
                exitCoords = door.coords
                break
            end
        end
    elseif activeSession.type == "shell" then
        for _, shell in ipairs(Config.Shells) do
            if shell.coords == activeSession.coords then
                exitCoords = shell.coords
                break
            end
        end
    end

    if exitCoords then
        SetEntityCoords(playerPed, exitCoords.x, exitCoords.y, exitCoords.z, false, false, false, true)
        TriggerServerEvent('customdoors:resetRoutingBucket')
        activeSession = nil
    else
        TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0No exit point found.')
    end
end, false)
