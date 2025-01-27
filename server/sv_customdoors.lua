RegisterNetEvent('lsc_enter:setRoutingBucket')
AddEventHandler('lsc_enter:setRoutingBucket', function(doorId)
    local playerId = source
    SetPlayerRoutingBucket(playerId, doorId)
end)

RegisterNetEvent('lsc_enter:resetRoutingBucket')
AddEventHandler('lsc_enter:resetRoutingBucket', function()
    local playerId = source
    SetPlayerRoutingBucket(playerId, 0)
end)
