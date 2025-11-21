return {
    VersionCheck = true,

    Framework = 'qbx', -- supported: 'qbx' or 'qb'

    Notify = 'lation', -- supported: 'qb', 'ox', or 'lation'

    Inventory = 'ox',  -- supported: 'qb', 'ps', or 'ox'

    Radial = 'lation', -- supported: 'qb', 'ox', or 'lation'

    Progress = {
        enabled = false,
        type = 'qb', -- supported: 'qb', 'ox_bar', 'ox_circle', or 'lation'
        duration = 2500
    },

    QbxProgress = {
        enabled = true,
        type = 'lation', -- supported: 'ox_bar', 'ox_circle', or 'lation'
        duration = 2500
    },

    EnableMenu = true,      -- Whether You Wish To Use The Menu UI or Not

    MenuUI = 'lation',      -- supported 'qb', 'ox', or 'lation'

    LockboxSlots = 5,       -- Inventory Slots

    LockboxWeight = 120000, -- Inventory Weight

    PoliceJobs = {
        'police',
        'lssd',
        'sasp',
        'bcso',
        'sast',
        'lscso'
        -- add your server's police job here as found in qb-core/shared/jobs.lua or qbx_core/shared/jobs.lua
    },

    AmbulanceJobs = {
        'ambulance'
        -- add your server's ambulance job here as found in qb-core/shared/jobs.lua or qbx_core/shared/jobs.lua
    }
}
