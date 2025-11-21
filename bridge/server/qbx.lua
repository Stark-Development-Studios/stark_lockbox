if GetResourceState('qbx_core') ~= 'started' then return end

if not lib.checkDependency('ox_lib', '3.32.0', true) then return end

local Config = require 'shared.config'

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

lib.addCommand('lockbox', {
    help = locale('info.command_help'),
    restricted = false,
}, function(source)
    TriggerClientEvent('stark_lockbox:client:OpenLockbox', source)
end)
