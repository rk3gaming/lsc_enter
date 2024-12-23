local lastEnterMessageTime = 0
local lastExitMessageTime = 0
local spawnedShells = {}
local show3DText = false
local isNearExit = false

function Draw3DTextFixed(screenX, screenY, text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.45, 0.45)
    SetTextOutline() 
    SetTextCentre(1) 

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(screenX, screenY)
end

Citizen.CreateThread(function()
    for _, shell in ipairs(Config.Shells) do
        if shell.shellModel and not spawnedShells[shell.shellCoords] then
            RequestModel(GetHashKey(shell.shellModel))
            while not HasModelLoaded(GetHashKey(shell.shellModel)) do
                Citizen.Wait(10)
            end

            local shellObject = CreateObject(GetHashKey(shell.shellModel), shell.shellCoords.x, shell.shellCoords.y, shell.shellCoords.z, false, false, false)
            SetEntityHeading(shellObject, shell.shellHeading)
            FreezeEntityPosition(shellObject, true)
            spawnedShells[shell.shellCoords] = shellObject
        end
    end

    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        show3DText = false
        isNearExit = false

        for _, door in ipairs(Config.Doors) do
            if #(playerCoords - door.coords) <= door.radius then
                show3DText = true
                if GetGameTimer() - lastEnterMessageTime >= 30000 then 
                    TriggerEvent('chatMessage', '', {255, 255, 255}, '^4[INFO]: ^0Use ^3/enter^0 to enter this interior.')
                    lastEnterMessageTime = GetGameTimer() 
                end
                break
            end
        end

        for _, door in ipairs(Config.Doors) do
            if #(playerCoords - door.exitCoords) <= door.radius then
                show3DText = true
                isNearExit = true
                if GetGameTimer() - lastExitMessageTime >= 30000 then 
                    TriggerEvent('chatMessage', '', {255, 255, 255}, '^4[INFO]: ^0Use ^3/exit^0 to exit this interior.')
                    lastExitMessageTime = GetGameTimer() 
                end
                break
            end
        end

        if show3DText then
            if isNearExit then
                Draw3DTextFixed(0.5, 0.9, "~w~Press ~y~Y ~w~to exit this interior")
            else
                Draw3DTextFixed(0.5, 0.9, "~w~Press ~y~Y ~w~to enter this interior")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(0, 246) then  
            if isNearExit then
                ExecuteCommand("exit")
            else
                ExecuteCommand("enter")
            end
        end
    end
end)

RegisterCommand("enter", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, door in ipairs(Config.Doors) do
        if #(playerCoords - door.coords) <= door.radius then
            local destination = vector3(door.enterCoords.x, door.enterCoords.y, door.enterCoords.z)
            if destination then
                SetEntityCoords(playerPed, destination.x, destination.y, destination.z, false, false, false, true)
                SetEntityHeading(playerPed, door.enterHeading) 
                TriggerServerEvent('customdoors:setRoutingBucket', door.coords)

                TriggerEvent('av_weather:freeze', true, 12, 0, "CLEAR", false, "normal", false)
            end
            return
        end
    end

    for _, shell in ipairs(Config.Shells) do
        if #(playerCoords - shell.shellCoords) <= 2.0 then 
            local shellModelHash = GetHashKey(shell.shellModel)
            if not DoesEntityExist(spawnedShells[shell.shellCoords]) then
                RequestModel(shellModelHash)
                while not HasModelLoaded(shellModelHash) do
                    Citizen.Wait(10)
                end

                local shellObject = CreateObject(shellModelHash, shell.shellCoords.x, shell.shellCoords.y, shell.shellCoords.z, false, false, false)
                SetEntityHeading(shellObject, shell.shellHeading)
                FreezeEntityPosition(shellObject, true)
                spawnedShells[shell.shellCoords] = shellObject
            end
            return
        end
    end

    TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0You are not near any enter point.')
end, false)

RegisterCommand("exit", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, door in ipairs(Config.Doors) do
        if #(playerCoords - door.exitCoords) <= door.radius then
            local destination = vector3(door.coords.x, door.coords.y, door.coords.z)
            SetEntityCoords(playerPed, destination.x, destination.y, destination.z, false, false, false, true)

            TriggerEvent('av_weather:freeze', false, 0, 0, "CLEAR", false, "normal", false)
            
            return
        end
    end

    TriggerEvent('chatMessage', '', {255, 255, 255}, '^1[ERROR]: ^0You are not near any exit point.')
end, false)
