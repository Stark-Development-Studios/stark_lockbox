---@diagnostic disable: lowercase-global

if not lib.checkDependency('ox_lib', '3.32.0', true) then return end

local Config = require 'shared.config'

if Config.Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    local function addRadialLockboxOption()
        local Player = PlayerPedId()
        if Config.Radial == 'qb' then
            MenuItemId = exports['qb-radialmenu']:AddOption({
                id = 'open_lock_box',
                title = locale('info.radial_menu_title'),
                icon = 'lock',
                type = 'client',
                event = 'stark_lockbox:client:OpenLockbox',
                shouldClose = true,
            }, MenuItemId)
        elseif Config.Radial == 'ox' then
            lib.addRadialItem({
                id = 'open_lock_box',
                icon = 'fa-solid fa-lock',
                label = locale('info.radial_menu_title'),
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:OpenLockbox')
                end,
                keepOpen = false
            })
        elseif Config.Radial == 'lation' then
            exports.lation_ui:addRadialItem({
                id = 'open_lock_box',
                label = locale('info.radial_menu_title'),
                icon = 'fa-solid fa-lock',
                iconColor = '#FFFFFF',
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:OpenLockbox')
                end,
            })
        else
            if Config.Notify == 'qb' then
                QBCore.Functions.Notify(locale('error.unsupported_radial_menu_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    description = locale('error.unsupported_radial_menu_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    message = locale('error.unsupported_radial_menu_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            end
        end
    end

    local function updateRadial()
        local Player = PlayerPedId()
        if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local Vehicle = GetVehiclePedIsIn(Player, false)
                local VehicleType = GetVehicleClass(Vehicle)
                if VehicleType == 18 then
                    addRadialLockboxOption()
                elseif MenuItemId ~= nil then
                    exports['qb-radialmenu']:RemoveOption(MenuItemId)
                    MenuItemId = nil
                elseif Config.Radial == 'ox' then
                    lib.removeRadialItem('open_lock_box')
                elseif Config.Radial == 'lation' then
                    exports.lation_ui:removeRadialItem('open_lock_box')
                end
            elseif MenuItemId ~= nil then
                exports['qb-radialmenu']:RemoveOption(MenuItemId)
                MenuItemId = nil
            elseif Config.Radial == 'ox' then
                lib.removeRadialItem('open_lock_box')
            elseif Config.Radial == 'lation' then
                exports.lation_ui:removeRadialItem('open_lock_box')
            end
        elseif MenuItemId ~= nil then
            exports['qb-radialmenu']:RemoveOption(MenuItemId)
            MenuItemId = nil
        elseif Config.Radial == 'ox' then
            lib.removeRadialItem('open_lock_box')
        elseif Config.Radial == 'lation' then
            exports.lation_ui:removeRadialItem('open_lock_box')
        end
    end

    RegisterNetEvent('qb-radialmenu:client:onRadialmenuOpen', function()
        updateRadial()
    end)

    if Config.Radial == 'ox' or Config.Radial == 'lation' then
        lib.onCache('vehicle', function()
            updateRadial()
        end)
    end

    function openLockboxInventory()
        local Player = PlayerPedId()
        local Vehicle = GetVehiclePedIsIn(Player, false)
        local id = GetVehicleNumberPlateText(Vehicle)

        if Config.Inventory == 'qb' then
            local stashLabel = 'Vehicle Lockbox ' .. id
            TriggerServerEvent('stark_lockbox:server:OpenLockbox', stashLabel)
        elseif Config.Inventory == 'ps' then
            TriggerServerEvent('ps-inventory:server:OpenInventory', 'stash', 'Vehicle Lockbox ' .. id, {
                maxweight = Config.LockboxWeight,
                slots = Config.LockboxSlots
            })
            TriggerEvent('ps-inventory:client:SetCurrentStash', 'Vehicle Lockbox ' .. id)
        elseif Config.Inventory == 'ox' then
            local ox_inventory = exports.ox_inventory
            ox_inventory:openInventory('stash', 'vehicle_lockbox')
        else
            if Config.Notify == 'qb' then
                QBCore.Functions.Notify(locale('error.unsupported_inventory_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_inventory_title'),
                    description = locale('error.unsupported_inventory_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.unsupported_inventory_title'),
                    message = locale('error.unsupported_inventory_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            end
        end
    end

    function openLockboxMenu()
        if Config.MenuUI == 'ox' then
            lib.registerContext({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                canClose = false,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            openLockboxInventory()
                        end,
                        icon = 'fa-solid fa-unlock',
                        iconColor = 'white',
                        description = locale('info.open_vehicle_lockbox_option_description')
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        onSelect = function()
                            lib.hideContext()
                        end,
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        description = locale('info.close_vehicle_lockbox_option_description')
                    }
                }
            })

            lib.showContext('vehicle_lockbox_menu')
        elseif Config.MenuUI == 'lation' then
            exports.lation_ui:registerMenu({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                canClose = false,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock-open',
                        iconColor = '#FFFFFF',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        onSelect = function()
                            openLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock',
                        iconColor = '#FFFFFF',
                        description = locale('info.close_vehicle_lockbox_option_description'),
                        onSelect = function()
                            exports.lation_ui:hideMenu()
                        end
                    }
                }
            })

            exports.lation_ui:showMenu('vehicle_lockbox_menu')
        elseif Config.MenuUI == 'qb' then
            local lockboxMenu = {
                {
                    header = locale('info.vehicle_lockbox_menu_title'),
                    icon = 'fa-solid fa-car',
                    isMenuHeader = true
                },
                {
                    header = locale('info.open_vehicle_lockbox_option_title'),
                    txt = locale('info.open_vehicle_lockbox_option_description'),
                    icon = 'fa-solid fa-lock-open',
                    action = function()
                        openLockboxInventory()
                    end
                },
                {
                    header = locale('info.close_vehicle_lockbox_option_title'),
                    txt = locale('info.close_vehicle_lockbox_option_description'),
                    icon = 'fa-solid fa-lock',
                    action = function()
                        exports['qb-menu']:closeMenu()
                    end
                }
            }

            exports['qb-menu']:openMenu(lockboxMenu)
        else
            if Config.Notify == 'qb' then
                QBCore.Functions.Notify(locale('error.unsupported_menu_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_menu_title'),
                    description = locale('error.unsupported_menu_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.unsupported_menu_title'),
                    message = locale('error.unsupported_menu_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            end
        end
    end

    function openLockbox()
        if Config.EnableMenu then
            openLockboxMenu()
        else
            openLockboxInventory()
        end
    end

    RegisterNetEvent('stark_lockbox:client:OpenLockbox', function()
        local Player = PlayerPedId()
        if IsPedInAnyVehicle(Player, false) then
            local Vehicle = GetVehiclePedIsIn(Player, false)
            local VehicleType = GetVehicleClass(Vehicle)
            if VehicleType == 18 then
                if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
                    if Config.Progress.enabled then
                        if Config.Progress.type == 'qb' then
                            QBCore.Functions.Progressbar(locale('info.progress_name'), locale('info.progress_label'),
                                Config.Progress.duration, false,
                                true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                }, {}, {}, {}, function()
                                    openLockbox()
                                end, function()
                                    if Config.Notify == 'qb' then
                                        QBCore.Functions.Notify(locale('error.cancellation_description'), 'error', 5000)
                                    elseif Config.Notify == 'ox' then
                                        lib.notify({
                                            title = locale('error.cancellation_title'),
                                            description = locale('error.cancellation_description'),
                                            duration = 5000,
                                            position = 'center-right',
                                            type = 'error'
                                        })
                                    elseif Config.Notify == 'lation' then
                                        exports.lation_ui:notify({
                                            title = locale('error.cancellation_title'),
                                            message = locale('error.cancellation_description'),
                                            type = 'error',
                                            duration = 5000,
                                            position = 'center-right',
                                        })
                                    end
                                end)
                        elseif Config.Progress.type == 'ox_bar' then
                            if lib.progressBar({
                                    duration = Config.Progress.duration,
                                    label = locale('info.progress_label'),
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        move = true,
                                        car = true,
                                        mouse = false,
                                        combat = true
                                    }
                                }) then
                                openLockbox()
                            else
                                if Config.Notify == 'qb' then
                                    QBCore.Functions.Notify(locale('error.cancellation_description'), 'error', 5000)
                                elseif Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right',
                                    })
                                end
                            end
                        elseif Config.Progress.type == 'ox_circle' then
                            if lib.progressCircle({
                                    duration = Config.Progress.duration,
                                    position = 'bottom',
                                    label = locale('info.progress_label'),
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        move = true,
                                        car = true,
                                        mouse = false,
                                        combat = true
                                    }
                                }) then
                                openLockbox()
                            else
                                if Config.Notify == 'qb' then
                                    QBCore.Functions.Notify(locale('error.cancellation_description'), 'error', 5000)
                                elseif Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right',
                                    })
                                end
                            end
                        elseif Config.Progress.type == 'lation' then
                            if exports.lation_ui:progressBar({
                                    label = locale('info.progress_label'),
                                    duration = Config.Progress.duration,
                                    icon = 'fas fa-box-open',
                                    iconColor = '#FFFFFF',
                                    color = '#0000FF',
                                    -- steps = {}, -- FEATURE COMING SOON
                                    canCancel = true,
                                    useWhileDead = false,
                                    disable = {
                                        move = true,
                                        sprint = true,
                                        car = true,
                                        combat = true,
                                        mouse = false
                                    }
                                }) then
                                openLockbox()
                            else
                                if Config.Notify == 'qb' then
                                    QBCore.Functions.Notify(locale('error.cancellation_description'), 'error', 5000)
                                elseif Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right',
                                    })
                                end
                            end
                        end
                    else
                        -- Progress Not Enabled
                        openLockbox()
                    end
                else
                    -- Fails The Job Check
                    if Config.Notify == 'qb' then
                        QBCore.Functions.Notify(locale('error.incorrect_job_description'), 'error', 5000)
                    elseif Config.Notify == 'ox' then
                        lib.notify({
                            title = locale('error.incorrect_job_title'),
                            description = locale('error.incorrect_job_description'),
                            duration = 5000,
                            position = 'center-right',
                            type = 'error'
                        })
                    elseif Config.Notify == 'lation' then
                        exports.lation_ui:notify({
                            title = locale('error.incorrect_job_title'),
                            message = locale('error.incorrect_job_description'),
                            type = 'error',
                            duration = 5000,
                            position = 'center-right'
                        })
                    end
                end
            else
                -- Fails Emergency Vehicle Class Check
                if Config.Notify == 'qb' then
                    QBCore.Functions.Notify(locale('error.incorrect_vehicle_description'), 'error', 5000)
                elseif Config.Notify == 'ox' then
                    lib.notify({
                        title = locale('error.incorrect_vehicle_title'),
                        description = locale('error.incorrect_vehicle_description'),
                        duration = 5000,
                        position = 'center-right',
                        type = 'error'
                    })
                elseif Config.Notify == 'lation' then
                    exports.lation_ui:notify({
                        title = locale('error.incorrect_vehicle_title'),
                        message = locale('error.incorrect_vehicle_description'),
                        type = 'error',
                        duration = 5000,
                        position = 'center-right'
                    })
                end
            end
        else
            -- Player Is Not In A Vehicle
            if Config.Notify == 'qb' then
                QBCore.Functions.Notify(locale('error.player_not_in_vehicle_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    description = locale('error.player_not_in_vehicle_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    message = locale('error.player_not_in_vehicle_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            end
        end
    end)
end

if Config.Framework == 'qbx' then
    local function oxAddRadialLockboxOption()
        local Player = PlayerPedId()
        if Config.Radial == 'ox' then
            lib.addRadialItem({
                id = 'open_lock_box',
                icon = 'fa-solid fa-lock',
                label = locale('info.radial_menu_title'),
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:OpenLockbox')
                end,
                keepOpen = false
            })
        elseif Config.Radial == 'lation' then
            exports.lation_ui:addRadialItem({
                id = 'open_lock_box',
                label = locale('info.radial_menu_title'),
                icon = 'fa-solid fa-lock',
                iconColor = '#FFFFFF',
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:OpenLockbox')
                end,
            })
        else
            if Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    description = locale('error.unsupported_radial_menu_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    message = locale('error.unsupported_radial_menu_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            end
        end
    end

    local function oxUpdateRadial()
        local Player = PlayerPedId()
        if qbxCheckValidPoliceJob() or qbxCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local Vehicle = GetVehiclePedIsIn(Player, false)
                local VehicleType = GetVehicleClass(Vehicle)
                if VehicleType == 18 then
                    oxAddRadialLockboxOption()
                else
                    if Config.Radial == 'ox' then
                        lib.removeRadialItem('open_lock_box')
                    elseif Config.Radial == 'lation' then
                        exports.lation_ui:removeRadialItem('open_lock_box')
                    end
                end
            else
                if Config.Radial == 'ox' then
                    lib.removeRadialItem('open_lock_box')
                elseif Config.Radial == 'lation' then
                    exports.lation_ui:removeRadialItem('open_lock_box')
                end
            end
        else
            if Config.Radial == 'ox' then
                lib.removeRadialItem('open_lock_box')
            elseif Config.Radial == 'lation' then
                exports.lation_ui:removeRadialItem('open_lock_box')
            end
        end
    end

    lib.onCache('vehicle', function()
        oxUpdateRadial()
    end)

    function oxOpenLockboxInventory()
        if GetResourceState('ox_inventory') ~= 'started' or not GetCurrentResourceName() then
            if Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.inventory_error_title'),
                    description = locale('error.inventory_error_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.inventory_error_title'),
                    message = locale('error.inventory_error_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            end
        else
            local ox_inventory = exports.ox_inventory
            ox_inventory:openInventory('stash', 'vehicle_lockbox')
        end
    end

    function oxOpenLockboxMenu()
        if Config.MenuUI == 'ox' then
            lib.registerContext({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                canClose = false,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            oxOpenLockboxInventory()
                        end,
                        icon = 'fa-solid fa-unlock',
                        iconColor = 'white',
                        description = locale('info.open_vehicle_lockbox_option_description')
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        onSelect = function()
                            lib.hideContext()
                        end,
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        description = locale('info.close_vehicle_lockbox_option_description')
                    }
                }
            })

            lib.showContext('vehicle_lockbox_menu')
        elseif Config.MenuUI == 'lation' then
            exports.lation_ui:registerMenu({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                canClose = false,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock-open',
                        iconColor = '#FFFFFF',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        onSelect = function()
                            oxOpenLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock',
                        iconColor = '#FFFFFF',
                        description = locale('info.close_vehicle_lockbox_option_description'),
                        onSelect = function()
                            exports.lation_ui:hideMenu()
                        end
                    }
                }
            })

            exports.lation_ui:showMenu('vehicle_lockbox_menu')
        end
    end

    function oxOpenLockbox()
        if Config.EnableMenu then
            oxOpenLockboxMenu()
        else
            oxOpenLockboxInventory()
        end
    end

    RegisterNetEvent('stark_lockbox:client:OpenLockbox', function()
        local Player = PlayerPedId()
        if IsPedInAnyVehicle(Player, false) then
            local Vehicle = GetVehiclePedIsIn(Player, false)
            local VehicleType = GetVehicleClass(Vehicle)
            if VehicleType == 18 then
                if qbxCheckValidPoliceJob() or qbxCheckValidAmbulanceJob() then
                    if Config.QbxProgress.enabled then
                        if Config.QbxProgress.type == 'ox_bar' then
                            if lib.progressBar({
                                    duration = Config.QbxProgress.duration,
                                    label = locale('info.progress_label'),
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        move = true,
                                        car = true,
                                        mouse = false,
                                        combat = true
                                    }
                                }) then
                                oxOpenLockbox()
                            else
                                if Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                end
                            end
                        elseif Config.QbxProgress.type == 'ox_circle' then
                            if lib.progressCircle({
                                    duration = Config.QbxProgress.duration,
                                    label = locale('info.progress_label'),
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        move = true,
                                        car = true,
                                        mouse = false,
                                        combat = true
                                    }
                                }) then
                                oxOpenLockbox()
                            else
                                if Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                end
                            end
                        elseif Config.QbxProgress.type == 'lation' then
                            if exports.lation_ui:progressBar({
                                    label = locale('info.progress_label'),
                                    duration = Config.QbxProgress.duration,
                                    icon = 'fas fa-box-open',
                                    iconColor = '#FFFFFF',
                                    color = '#0000FF',
                                    steps = {},
                                    canCancel = true,
                                    useWhileDead = false,
                                    disable = {
                                        move = true,
                                        sprint = true,
                                        car = true,
                                        combat = true,
                                        mouse = false
                                    }
                                }) then
                                oxOpenLockbox()
                            else
                                if Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    exports.lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                end
                            end
                        end
                    else
                        -- Progress Not Enabled.
                        oxOpenLockbox()
                    end
                else
                    -- Fails The Job Check
                    if Config.Notify == 'ox' then
                        lib.notify({
                            title = locale('error.incorrect_job_title'),
                            description = locale('error.incorrect_job_description'),
                            duration = 5000,
                            position = 'center-right',
                            type = 'error'
                        })
                    elseif Config.Notify == 'lation' then
                        exports.lation_ui:notify({
                            title = locale('error.incorrect_job_title'),
                            message = locale('error.incorrect_job_description'),
                            type = 'error',
                            duration = 5000,
                            position = 'center-right'
                        })
                    end
                end
            else
                -- Fails Emergency Vehicle Class Check
                if Config.Notify == 'ox' then
                    lib.notify({
                        title = locale('error.incorrect_vehicle_title'),
                        description = locale('error.incorrect_vehicle_description'),
                        duration = 5000,
                        position = 'center-right',
                        type = 'error'
                    })
                elseif Config.Notify == 'lation' then
                    exports.lation_ui:notify({
                        title = locale('error.incorrect_vehicle_title'),
                        message = locale('error.incorrect_vehicle_description'),
                        type = 'error',
                        duration = 5000,
                        position = 'center-right'
                    })
                end
            end
        else
            -- Player Is Not In A Vehicle
            if Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    description = locale('error.player_not_in_vehicle_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                exports.lation_ui:notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    message = locale('error.player_not_in_vehicle_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            end
        end
    end)
end
