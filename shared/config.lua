--[[
    NOTE: Framework Default Notifications, Progress UIs, & Context Menus Must All Match The Chosen Framework.
    For Example, qb-menu Is Only Supported By QBCore.
    Please Ensure That Your Framework Variables Match, Otherwise There Will Be Errors In The Script.
]]

return {
    Debug = false,

    VersionCheck = true,

    EnforceCurrentVersion = false, -- Highly Recommended That This Is Set To True, False Allows For Older Versions To Be Used

    Notify = 'ox',                 -- supported: 'qb', 'esx', 'ox', or 'lation'

    Inventory = 'ox',              -- supported: 'qb', 'ox', or 'ps'

    Radial = 'ox',                 -- supported: 'qb', 'ox', or 'lation'

    Keybind = {
        enabled = false,
        control = 'RSHIFT' -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    },

    Progress = {
        framework = 'qbx', -- supported: 'qb', 'qbx', or 'esx'
        enabled = true,    -- True Enables Progress Functionality, False Disables It
        type = 'ox_bar',   -- supported: 'qb', 'esx', 'ox_bar', 'ox_circle', or 'lation'
        duration = 2000
    },

    Menu = {
        enabled = false, -- True Enables The Lockbox Menu, False Disables It
        type = 'ox'      -- supported: 'qb', 'esx', 'ox', or 'lation'
    },

    LockboxSlots = 6,       -- Number of Inventory Slots

    LockboxWeight = 120000, -- Max Inventory Weight

    KeepInventory = true,   -- Ox Inventory Only: True Maintains What Is Stored In The Lockbox; False Clears The Inventory When The Script Is Restarted

    PoliceJobs = {
        'police',
        'bcso',
        'lscso',
        'sasp',
        'sast',
        'sahp',
        -- add your server's police job here
    },

    AmbulanceJobs = {
        'ambulance',
        'sams',
        -- add your server's ambulance job here
    }
}
