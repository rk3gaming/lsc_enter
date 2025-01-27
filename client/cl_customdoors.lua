local Zones = {}

for _, location in ipairs(Config.Locations) do
    local exteriorZone = lib.zones.box({
        coords = location.coords,
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = false,
        onEnter = function(self)
            CreateThread(function()
                while self:contains(GetEntityCoords(PlayerPedId())) do
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextScale(0.45, 0.45)
                    SetTextColour(255, 255, 255, 255)
                    SetTextOutline()
                    SetTextCentre(true)
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentSubstringPlayerName("Press ~y~Y~w~ to enter this interior")
                    EndTextCommandDisplayText(0.5, 0.9)

                    if IsControlJustPressed(0, 246) then 
                        SetEntityCoords(PlayerPedId(), location.interiorcords.x, location.interiorcords.y, location.interiorcords.z, false, false, false, true)
                    end

                    Wait(0)
                end
            end)
        end
    })
    table.insert(Zones, exteriorZone)

    local interiorZone = lib.zones.box({
        coords = location.interiorcords,
        size = vec3(10, 10, 10),
        rotation = 0,
        debug = false,
        onEnter = function(self)
            TriggerServerEvent('lsc_enter:setRoutingBucket', location)
        end
    })
    table.insert(Zones, interiorZone)

    local exitZone = lib.zones.box({
        coords = location.exitcoords,
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = false,
        onEnter = function(self)
            CreateThread(function()
                while self:contains(GetEntityCoords(PlayerPedId())) do
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextScale(0.45, 0.45)
                    SetTextColour(255, 255, 255, 255)
                    SetTextOutline()
                    SetTextCentre(true)
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentSubstringPlayerName("Press ~y~Y~w~ to exit this interior")
                    EndTextCommandDisplayText(0.5, 0.9)

                    if IsControlJustPressed(0, 246) then 
                        SetEntityCoords(PlayerPedId(), location.coords.x, location.coords.y, location.coords.z, false, false, false, true)
                        TriggerServerEvent('lsc_enter:resetRoutingBucket')
                    end

                    Wait(0)
                end
            end)
        end
    })
    table.insert(Zones, exitZone)
end
