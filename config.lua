Config = {}

-- coords = Door Location
-- enterCoords = The interior where they get sent to
-- exitCoords = Where in the interior they can use /exit at to leave
-- radius = How close they have to be at the door to use /enter & /exit

Config.Doors = {
    {
        coords = vector3(-638.38, -1249.58, 11.81), 
        enterCoords = vector3(305.36, -893.66, 835.86), 
        enterHeading = 284.91,
        exitCoords = vector3(297.62, -889.9, 835.86),
        radius = 2.0,
    },
}

Config.Shells = {
    { 
        shellModel = 'shell_lester',
        shellCoords = vector3(303.6, -891.48, 834.75),
        shellHeading = 272.03,
    },
}

