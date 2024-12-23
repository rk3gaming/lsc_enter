Config = {}

-- coords = Door Location
-- enterCoords = The interior where they get sent to
-- exitCoords = Where in the interior they can use /exit at to leave
-- radius = How close they have to be at the door to use /enter & /exit

Config.Doors = {
    {
        coords = vector3(464.08, -1852.09, 27.79), 
        enterCoords = vector3(895.12, -1183.06, 84.05), 
        enterHeading = 271.68,
        exitCoords = vector3(892.58, -1183.13, 84.05),
        radius = 2.0,
    },
}

Config.Shells = {
    { 
        shellModel = 'shell_store3',
        shellCoords = vector3(900.36, -1182.97, 82.04),
        shellHeading = 271.4,
    },
}

