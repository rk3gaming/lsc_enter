Config = {}

-- coords = Door Location
-- enterCoords = The interior where they get sent to
-- exitCoords = Where in the interior they can use /exit at to leave
-- radius = How close they have to be at the door to use /enter & /exit

Config.Doors = {
    {
        coords = vector3(279.6626, 145.0047, 104.2842), 
        enterCoords = vector3(277.2809, 139.3253, 104.4179), 
        exitCoords = vector3(279.1964, 143.8522, 104.4179),
        radius = 2.0, 
    },
}

-- Coords = Door Location
-- EnterCoords = Where in the shell/interior they spawn in at
-- ExitCoords = where in the interior they can use /exit at
-- ShellModel = The Name of the shell its spawning.
-- ShellCooods = Where the shell will spawn at, I personally put these high up in the sky.
-- ShellHeading = Shell Heading..
-- Radius = How close they have to be at the door to use /enter & /exit

Config.Shells = {
    {
        coords = vector3(464.29, -1852.11, 27.79), 
        enterCoords = vector3(2462.19, -3745.72, 87.58), 
        exitCoords = vector3(2458.87, -3743.85, 87.58),
        shellModel = 'shell_store3',
        shellCoords = vector3(2464.85, -3748.81, 85.57),
        shellHeading = 229.47,
        radius = 2.0,
    },
