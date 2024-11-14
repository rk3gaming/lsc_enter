RegisterNetEvent('customdoors:setRoutingBucket')
AddEventHandler('customdoors:setRoutingBucket', function(doorId)
    local playerId = source
    SetPlayerRoutingBucket(playerId, doorId)
end)

RegisterNetEvent('customdoors:resetRoutingBucket')
AddEventHandler('customdoors:resetRoutingBucket', function()
    local playerId = source
    SetPlayerRoutingBucket(playerId, 0)
end)
