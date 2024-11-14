Config = Config or {}
Config.Doors = Config.Doors or {}

local lastMessageTime = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearDoor = false

        for doorId, door in ipairs(Config.Doors) do
            if #(playerCoords - door.coords) <= door.radius then
                isNearDoor = true
                if GetGameTimer() - lastMessageTime >= 30000 then
                    TriggerEvent('chatMessage', '', {255, 255, 255}, '^4[INFO]: ^0You are near a door. Use ^3/enter^7 to enter this interior.')
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
    
    for doorId, door in ipairs(Config.Doors) do
        if #(playerCoords - door.coords) <= door.radius then
            SetEntityCoords(playerPed, door.enterCoords.x, door.enterCoords.y, door.enterCoords.z, false, false, false, true)

            TriggerServerEvent('customdoors:setRoutingBucket', doorId)

            return
        end
    end
    TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0You are not near any door.')
end, false)

RegisterCommand("exit", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for doorId, door in ipairs(Config.Doors) do
        if #(playerCoords - door.exitCoords) <= door.radius then
            SetEntityCoords(playerPed, door.coords.x, door.coords.y, door.coords.z, false, false, false, true)

            TriggerServerEvent('customdoors:resetRoutingBucket')

            return
        end
    end
    TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0You are not near an exit point.')
end, false)
