--[[
    NOTE: Framework Default Notifications, Progress UIs, & Context Menus Must All Match The Chosen Framework.
    For Example, qb-menu Is Only Supported By QBCore.
    Please Ensure That Your Framework Variables Match, Otherwise There Will Be Errors In The Script.
]]

return {
    Debug = true,

    VersionCheck = true,

    Framework = 'qbx', -- supported: 'qb', 'qbx', or 'esx'

    Notify = 'ox',     -- supported: 'qb', 'esx', 'ox', or 'lation'

    Inventory = 'ox',  -- supported: 'qb', 'ox', or 'ps'

    Radial = 'ox',     -- supported: 'qb', 'ox', or 'lation'

    Progress = {
        framework = 'qbx',  -- supported: 'qb', 'qbx', or 'esx'
        enabled = true,     -- True Enables Progress Functionality, False Disables It
        type = 'ox_circle', -- supported: 'qb', 'esx', 'ox_bar', 'ox_circle', or 'lation'
        duration = 2000
    },

    Menu = {
        enabled = true, -- True Enables The Lockbox Menu, False Disables It
        type = 'ox'     -- supported: 'qb', 'esx', 'ox', or 'lation'
    },

    LockboxSlots = 5,       -- Number of Inventory Slots

    LockboxWeight = 120000, -- Max Inventory Weight

    PoliceJobs = {
        'police',
        'lssd',
        'sasp',
        'bcso',
        'sast',
        'lscso'
        -- add your server's police job here
    },

    AmbulanceJobs = {
        'ambulance'
        -- add your server's ambulance job here
    }
}
