if GetResourceState('es_extended') ~= 'started' then return end

if not lib.checkDependency('ox_lib', '3.40.0', true) then return end

local Config = require 'shared.config'

-- Allows For Older Versions/Modified Versions Of Ox Inventory To Be Used
if Config.EnforceCurrentVersion then
    if not lib.checkDependency('ox_inventory', '2.48.0', true) then return end
end

local oxInvState = GetResourceState('ox_inventory')

local ox_inventory = exports.ox_inventory

if oxInvState == 'started' and GetCurrentResourceName() then
    local lockbox = {
        id = 'vehicle_lockbox',
        label = locale('info.inventory_label'),
        slots = Config.LockboxSlots,
        weight = Config.LockboxWeight,
        owner = true
    }

    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
            ox_inventory:RegisterStash(lockbox.id, lockbox.label, lockbox.slots, lockbox.weight, lockbox.owner)
        end
    end)
end

if not Config.KeepInventory then
    AddEventHandler('onResourceStart', function(resourceName)
        if resourceName == GetCurrentResourceName() then
            ox_inventory:ClearInventory('vehicle_lockbox')
        end
    end)
end
