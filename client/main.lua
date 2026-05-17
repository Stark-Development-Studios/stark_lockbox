if not lib.checkDependency('ox_lib', '3.33.0', true) then return end

local Config = require 'shared.config'

if Config.Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    local lation_ui = exports.lation_ui

    local function addRadialLockboxOption()
        local Player = PlayerPedId()
        if Config.Radial == 'qb' then
            MenuItemId = exports['qb-radialmenu']:AddOption({
                id = 'open_lock_box',
                title = locale('info.radial_menu_title'),
                icon = 'lock',
                type = 'client',
                event = 'stark_lockbox:client:openLockbox',
                shouldClose = true
            }, MenuItemId)
        elseif Config.Radial == 'ox' then
            lib.addRadialItem({
                id = 'open_lock_box',
                icon = 'fa-solid fa-lock',
                label = locale('info.radial_menu_title'),
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:openLockbox')
                end,
                keepOpen = false
            })
        elseif Config.Radial == 'lation' then
            lation_ui:addRadialItem({
                id = 'open_lock_box',
                label = locale('info.radial_menu_title'),
                icon = 'fa-solid fa-lock',
                iconColor = '#FFFFFF',
                keepOpen = false,
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:openLockbox')
                end
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
                lation_ui:notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    message = locale('error.unsupported_radial_menu_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function updateRadialMenu()
        local Player = PlayerPedId()
        if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local vehicle = GetVehiclePedIsIn(Player, false)
                local vehicleType = GetVehicleClass(vehicle)
                if vehicleType == 18 then
                    addRadialLockboxOption()
                elseif MenuItemId ~= nil then
                    exports['qb-radialmenu']:RemoveOption(MenuItemId)
                    MenuItemId = nil
                elseif Config.Radial == 'ox' then
                    lib.removeRadialItem('open_lock_box')
                elseif Config.Radial == 'lation' then
                    lation_ui:removeRadialItem('open_lock_box')
                end
            elseif MenuItemId ~= nil then
                exports['qb-radialmenu']:RemoveOption(MenuItemId)
                MenuItemId = nil
            elseif Config.Radial == 'ox' then
                lib.removeRadialItem('open_lock_box')
            elseif Config.Radial == 'lation' then
                lation_ui:removeRadialItem('open_lock_box')
            end
        elseif MenuItemId ~= nil then
            exports['qb-radialmenu']:RemoveOption(MenuItemId)
            MenuItemId = nil
        elseif Config.Radial == 'ox' then
            lib.removeRadialItem('open_lock_box')
        elseif Config.Radial == 'lation' then
            lation_ui:removeRadialItem('open_lock_box')
        end
    end

    RegisterNetEvent('qb-radialmenu:client:onRadialmenuOpen', function()
        updateRadialMenu()
    end)

    if Config.Radial == 'ox' or Config.Radial == 'lation' then
        lib.onCache('vehicle', function()
            updateRadialMenu()
        end)
    end

    local function openLockboxInventory()
        local Player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(Player, false)
        local id = GetVehicleNumberPlateText(vehicle)

        if Config.Inventory == 'qb' then
            local stashLabel = 'Vehicle Lockbox ' .. id
            TriggerServerEvent('stark_lockbox:server:openLockbox', stashLabel)
        elseif Config.Inventory == 'ps' then
            local weight = Config.LockboxWeight
            local slots = Config.LockboxSlots
            TriggerServerEvent('ps-inventory:server:OpenInventory', 'stash', 'Vehicle Lockbox ' .. id, { maxweight = weight, slots = slots })
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
                lation_ui:notify({
                    title = locale('error.unsupported_inventory_title'),
                    message = locale('error.unsupported_inventory_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function openLockboxMenu()
        if Config.Menu.type == 'ox' then
            lib.registerContext({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                position = 'top-right',
                canClose = false,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            openLockboxInventory()
                        end,
                        icon = 'fa-solid fa-unlock',
                        iconColor = 'white',
                        arrow = true,
                        description = locale('info.open_vehicle_lockbox_option_description')
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        onSelect = function()
                            lib.hideContext()
                        end,
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        arrow = true,
                        description = locale('info.close_vehicle_lockbox_option_description')
                    }
                }
            })

            lib.showContext('vehicle_lockbox_menu')
        elseif Config.Menu.type == 'lation' then
            lation_ui:registerMenu({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                subtitle = locale('info.vehicle_lockbox_menu_subtitle'),
                headerIcon = 'fa-solid fa-car',
                headerIconColor = '#0000FF',
                canClose = false,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock-open',
                        iconColor = '#FFFFFF',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        arrow = true,
                        onSelect = function()
                            openLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock',
                        iconColor = '#FFFFFF',
                        description = locale('info.close_vehicle_lockbox_option_description'),
                        arrow = true,
                        onSelect = function()
                            lation_ui:hideMenu()
                        end
                    }
                }
            })

            lation_ui:showMenu('vehicle_lockbox_menu')
        elseif Config.Menu.type == 'qb' then
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
                lation_ui:notify({
                    title = locale('error.unsupported_menu_title'),
                    message = locale('error.unsupported_menu_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function openLockbox()
        if Config.Menu.enabled then
            openLockboxMenu()
        else
            openLockboxInventory()
        end
    end

    RegisterNetEvent('stark_lockbox:client:openLockbox', function()
        if not GetInvokingResource() then return end

        local Player = PlayerPedId()
        if IsPedInAnyVehicle(Player, false) then
            local vehicle = GetVehiclePedIsIn(Player, false)
            local vehicleType = GetVehicleClass(vehicle)
            if vehicleType == 18 then
                if qbCheckValidPoliceJob() or qbCheckValidAmbulanceJob() then
                    if Config.Framework == 'qb' and Config.Progress.framework == 'qb' then
                        if Config.Progress.enabled then
                            if Config.Progress.type == 'qb' then
                                QBCore.Functions.Progressbar(locale('info.progress_name'), locale('info.progress_label'),
                                    Config.Progress.duration, false,
                                    true, {
                                        disableMovement = true,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true
                                    }, {}, {}, {}, function()
                                        openLockbox()
                                    end, function()
                                        QBCore.Functions.Notify(locale('error.cancellation_description'), 'error', 5000)
                                    end)
                            elseif Config.Progress.type == 'ox_bar' then
                                if lib.progressBar({
                                        duration = Config.Progress.duration,
                                        label = locale('info.progress_label'),
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            move = true,
                                            car = false,
                                            combat = true,
                                            mouse = false,
                                            sprint = true
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
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
                                            car = false,
                                            combat = true,
                                            mouse = false,
                                            sprint = true
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                end
                            elseif Config.Progress.type == 'lation' then
                                if lation_ui:progressBar({
                                        label = locale('info.progress_label'),
                                        duration = Config.Progress.duration,
                                        icon = 'fas fa-box-open',
                                        iconColor = '#FFFFFF',
                                        color = '#FF0000',
                                        steps = {
                                            { description = 'Inserting The Key...' },
                                            { description = 'Turning The Key...' },
                                            { description = 'Opening The Lockbox...' }
                                        },
                                        canCancel = true,
                                        useWhileDead = false,
                                        disable = {
                                            move = true,
                                            sprint = true,
                                            car = false,
                                            combat = true,
                                            mouse = false
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        message = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right',
                                    })
                                end
                            else
                                -- Progress Type Not Supported
                                if Config.Notify == 'qb' then
                                    QBCore.Functions.Notify(locale('error.unsupported_progress_type_description', 'error', 5000))
                                elseif Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.unsupported_progress_type_title'),
                                        description = locale('error.unsupported_progress_type_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    lation_ui:notify({
                                        title = locale('error.unsupported_progress_type_title'),
                                        message = locale('error.unsupported_progress_type_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                else
                                    lib.print.error(locale('error.notification_warning'))
                                end
                            end
                        else
                            -- Progress Not Enabled
                            openLockbox()
                        end
                    else
                        -- Framework Doesn't Match
                        if Config.Notify == 'qb' then
                            QBCore.Functions.Notify(locale('error.framework_mismatch_description'), 'error', 5000)
                        elseif Config.Notify == 'ox' then
                            lib.notify({
                                title = locale('error.framework_mismatch_title'),
                                description = locale('error.framework_mismatch_description'),
                                duration = 5000,
                                position = 'center-right',
                                type = 'error'
                            })
                        elseif Config.Notify == 'lation' then
                            lation_ui:notify({
                                title = locale('error.framework_mismatch_title'),
                                message = locale('error.framework_mismatch_description'),
                                type = 'error',
                                duration = 5000,
                                position = 'center-right'
                            })
                        else
                            lib.print.error(locale('error.notification_warning'))
                        end
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
                        lation_ui:notify({
                            title = locale('error.incorrect_job_title'),
                            message = locale('error.incorrect_job_description'),
                            type = 'error',
                            duration = 5000,
                            position = 'center-right'
                        })
                    else
                        lib.print.error(locale('error.notification_warning'))
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
                    lation_ui:notify({
                        title = locale('error.incorrect_vehicle_title'),
                        message = locale('error.incorrect_vehicle_description'),
                        type = 'error',
                        duration = 5000,
                        position = 'center-right'
                    })
                else
                    lib.print.error(locale('error.notification_warning'))
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
                lation_ui:notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    message = locale('error.player_not_in_vehicle_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end)
end

if Config.Framework == 'qbx' then
    local lation_ui = exports.lation_ui

    local function addRadialLockboxOption()
        local Player = PlayerPedId()
        if Config.Radial == 'ox' then
            lib.addRadialItem({
                id = 'open_lock_box',
                icon = 'fa-solid fa-lock',
                label = locale('info.radial_menu_title'),
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:openLockbox')
                end,
                keepOpen = false
            })
        elseif Config.Radial == 'lation' then
            lation_ui:addRadialItem({
                id = 'open_lock_box',
                label = locale('info.radial_menu_title'),
                icon = 'fa-solid fa-lock',
                iconColor = '#FFFFFF',
                keepOpen = false,
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:openLockbox')
                end
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
                lation_ui:notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    message = locale('error.unsupported_radial_menu_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function updateRadial()
        local Player = PlayerPedId()
        if qbxCheckValidPoliceJob() or qbxCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local vehicle = GetVehiclePedIsIn(Player, false)
                local vehicleType = GetVehicleClass(vehicle)
                if vehicleType == 18 then
                    addRadialLockboxOption()
                else
                    if Config.Radial == 'ox' then
                        lib.removeRadialItem('open_lock_box')
                    elseif Config.Radial == 'lation' then
                        lation_ui:removeRadialItem('open_lock_box')
                    end
                end
            else
                if Config.Radial == 'ox' then
                    lib.removeRadialItem('open_lock_box')
                elseif Config.Radial == 'lation' then
                    lation_ui:removeRadialItem('open_lock_box')
                end
            end
        else
            if Config.Radial == 'ox' then
                lib.removeRadialItem('open_lock_box')
            elseif Config.Radial == 'lation' then
                lation_ui:removeRadialItem('open_lock_box')
            end
        end
    end

    lib.onCache('vehicle', function()
        updateRadial()
    end)

    local function openLockboxInventory()
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
                lation_ui:notify({
                    title = locale('error.inventory_error_title'),
                    message = locale('error.inventory_error_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        else
            local ox_inventory = exports.ox_inventory
            ox_inventory:openInventory('stash', 'vehicle_lockbox')
        end
    end

    local function openLockboxMenu()
        if Config.Menu.type == 'ox' then
            lib.registerContext({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                position = 'top-right',
                canClose = false,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            openLockboxInventory()
                        end,
                        icon = 'fa-solid fa-unlock',
                        iconColor = 'white',
                        arrow = true,
                        description = locale('info.open_vehicle_lockbox_option_description')
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        onSelect = function()
                            lib.hideContext()
                        end,
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        arrow = true,
                        description = locale('info.close_vehicle_lockbox_option_description')
                    }
                }
            })

            lib.showContext('vehicle_lockbox_menu')
        elseif Config.Menu.type == 'lation' then
            lation_ui:registerMenu({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                subtitle = locale('info.vehicle_lockbox_menu_subtitle'),
                headerIcon = 'fa-solid fa-car',
                headerIconColor = '#0000FF',
                canClose = false,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock-open',
                        iconColor = '#FFFFFF',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        arrow = true,
                        onSelect = function()
                            openLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock',
                        iconColor = '#FFFFFF',
                        description = locale('info.close_vehicle_lockbox_option_description'),
                        arrow = true,
                        onSelect = function()
                            lation_ui:hideMenu()
                        end
                    }
                }
            })

            lation_ui:showMenu('vehicle_lockbox_menu')
        else
            if Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_menu_title'),
                    description = locale('error.unsupported_menu_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                lation_ui:notify({
                    title = locale('error.unsupported_menu_title'),
                    message = locale('error.unsupported_menu_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function openLockbox()
        if Config.Menu.enabled then
            openLockboxMenu()
        else
            openLockboxInventory()
        end
    end

    RegisterNetEvent('stark_lockbox:client:openLockbox', function()
        if not GetInvokingResource() then return end

        local Player = PlayerPedId()
        if IsPedInAnyVehicle(Player, false) then
            local vehicle = GetVehiclePedIsIn(Player, false)
            local vehicleType = GetVehicleClass(vehicle)
            if vehicleType == 18 then
                if qbxCheckValidPoliceJob() or qbxCheckValidAmbulanceJob() then
                    if Config.Framework == 'qbx' and Config.Progress.framework == 'qbx' then
                        if Config.Progress.enabled then
                            if Config.Progress.type == 'ox_bar' then
                                if lib.progressBar({
                                        duration = Config.Progress.duration,
                                        label = locale('info.progress_label'),
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            move = true,
                                            car = false,
                                            combat = true,
                                            mouse = false,
                                            sprint = true
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                end
                            elseif Config.Progress.type == 'ox_circle' then
                                if lib.progressCircle({
                                        duration = Config.Progress.duration,
                                        label = locale('info.progress_label'),
                                        position = 'bottom',
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            move = true,
                                            car = false,
                                            combat = true,
                                            mouse = false,
                                            sprint = true
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                end
                            elseif Config.Progress.type == 'lation' then
                                if lation_ui:progressBar({
                                        label = locale('info.progress_label'),
                                        duration = Config.Progress.duration,
                                        icon = 'fas fa-box-open',
                                        iconColor = '#FFFFFF',
                                        color = '#FF0000',
                                        steps = {
                                            { description = 'Inserting The Key...' },
                                            { description = 'Turning The Key...' },
                                            { description = 'Opening The Lockbox...' }
                                        },
                                        canCancel = true,
                                        useWhileDead = false,
                                        disable = {
                                            move = true,
                                            sprint = true,
                                            car = false,
                                            combat = true,
                                            mouse = false
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                end
                            else
                                -- Progress Type Not Supported
                                if Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.unsupported_progress_type_title'),
                                        description = locale('error.unsupported_progress_type_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    lation_ui:notify({
                                        title = locale('error.unsupported_progress_type_title'),
                                        message = locale('error.unsupported_progress_type_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                else
                                    lib.print.error(locale('error.notification_warning'))
                                end
                            end
                        else
                            -- Progress Not Enabled.
                            openLockbox()
                        end
                    else
                        -- Framework Doesn't Match
                        if Config.Notify == 'ox' then
                            lib.notify({
                                title = locale('error.framework_mismatch_title'),
                                description = locale('error.framework_mismatch_description'),
                                duration = 5000,
                                position = 'center-right',
                                type = 'error'
                            })
                        elseif Config.Notify == 'lation' then
                            lation_ui:notify({
                                title = locale('error.framework_mismatch_title'),
                                message = locale('error.framework_mismatch_description'),
                                type = 'error',
                                duration = 5000,
                                position = 'center-right'
                            })
                        else
                            lib.print.error(locale('error.notification_warning'))
                        end
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
                        lation_ui:notify({
                            title = locale('error.incorrect_job_title'),
                            message = locale('error.incorrect_job_description'),
                            type = 'error',
                            duration = 5000,
                            position = 'center-right'
                        })
                    else
                        lib.print.error(locale('error.notification_warning'))
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
                    lation_ui:notify({
                        title = locale('error.incorrect_vehicle_title'),
                        message = locale('error.incorrect_vehicle_description'),
                        type = 'error',
                        duration = 5000,
                        position = 'center-right'
                    })
                else
                    lib.print.error(locale('error.notification_warning'))
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
                lation_ui:notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    message = locale('error.player_not_in_vehicle_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end)
end

if Config.Framework == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()

    local lation_ui = exports.lation_ui

    local function addRadialLockboxOption()
        local Player = PlayerPedId()
        if Config.Radial == 'ox' then
            lib.addRadialItem({
                id = 'open_lock_box',
                icon = 'fa-solid fa-lock',
                label = locale('info.radial_menu_title'),
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:openLockbox')
                end,
                keepOpen = false
            })
        elseif Config.Radial == 'lation' then
            lation_ui:addRadialItem({
                id = 'open_lock_box',
                label = locale('info.radial_menu_title'),
                icon = 'fa-solid fa-lock',
                iconColor = '#FFFFFF',
                keepOpen = false,
                onSelect = function()
                    TriggerEvent('stark_lockbox:client:openLockbox')
                end
            })
        else
            if Config.Notify == 'esx' then
                ESX.ShowNotification(locale('error.unsupported_radial_menu_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    description = locale('error.unsupported_radial_menu_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                lation_ui:notify({
                    title = locale('error.unsupported_radial_menu_title'),
                    message = locale('error.unsupported_radial_menu_description'),
                    type = 'error',
                    duration = '5000',
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function updateRadial()
        local Player = PlayerPedId()
        if xCheckValidPoliceJob() or xCheckValidAmbulanceJob() then
            if IsPedInAnyVehicle(Player, false) then
                local vehicle = GetVehiclePedIsIn(Player, false)
                local vehicleType = GetVehicleClass(vehicle)
                if vehicleType == 18 then
                    addRadialLockboxOption()
                else
                    if Config.Radial == 'ox' then
                        lib.removeRadialItem('open_lock_box')
                    elseif Config.Radial == 'lation' then
                        lation_ui:removeRadialItem('open_lock_box')
                    end
                end
            else
                if Config.Radial == 'ox' then
                    lib.removeRadialItem('open_lock_box')
                elseif Config.Radial == 'lation' then
                    lation_ui:removeRadialItem('open_lock_box')
                end
            end
        else
            if Config.Radial == 'ox' then
                lib.removeRadialItem('open_lock_box')
            elseif Config.Radial == 'lation' then
                lation_ui:removeRadialItem('open_lock_box')
            end
        end
    end

    lib.onCache('vehicle', function()
        updateRadial()
    end)

    local function openLockboxInventory()
        if GetResourceState('ox_inventory') ~= 'started' or not GetCurrentResourceName() then
            if Config.Notify == 'esx' then
                ESX.ShowNotification(locale('error.inventory_error_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.inventory_error_title'),
                    description = locale('error.inventory_error_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                lation_ui:notify({
                    title = locale('error.inventory_error_title'),
                    message = locale('error.inventory_error_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        else
            local ox_inventory = exports.ox_inventory
            ox_inventory:openInventory('stash', 'vehicle_lockbox')
        end
    end

    local function openLockboxMenu()
        if Config.Menu.type == 'esx' then
            local menuOptions = {
                {
                    unselectable = false,
                    disabled = false,
                    icon = 'fa-solid fa-unlock',
                    title = locale('info.open_vehicle_lockbox_option_title'),
                    description = locale('info.open_vehicle_lockbox_option_description'),
                    input = false,
                }
            }

            ESX.OpenContext('right', menuOptions, function()
                openLockboxInventory()
                ESX.CloseContext()
            end, function()
                ESX.CloseContext()
            end, true)
        elseif Config.Menu.type == 'ox' then
            lib.registerContext({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                position = 'top-right',
                canClose = false,
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        onSelect = function()
                            openLockboxInventory()
                        end,
                        icon = 'fa-solid fa-unlock',
                        iconColor = 'white',
                        arrow = true,
                        description = locale('info.open_vehicle_lockbox_option_description')
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        onSelect = function()
                            lib.hideContext()
                        end,
                        icon = 'fa-solid fa-lock',
                        iconColor = 'white',
                        arrow = true,
                        description = locale('info.close_vehicle_lockbox_option_description')
                    }
                }
            })

            lib.showContext('vehicle_lockbox_menu')
        elseif Config.Menu.type == 'lation' then
            lation_ui:registerMenu({
                id = 'vehicle_lockbox_menu',
                title = locale('info.vehicle_lockbox_menu_title'),
                subtitle = locale('info.vehicle_lockbox_menu_subtitle'),
                headerIcon = 'fa-solid fa-car',
                headerIconColor = '#0000FF',
                canClose = false,
                position = 'offcenter-right',
                options = {
                    {
                        title = locale('info.open_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock-open',
                        iconColor = '#FFFFFF',
                        description = locale('info.open_vehicle_lockbox_option_description'),
                        arrow = true,
                        onSelect = function()
                            openLockboxInventory()
                        end
                    },
                    {
                        title = locale('info.close_vehicle_lockbox_option_title'),
                        icon = 'fas fa-lock',
                        iconColor = '#FFFFFF',
                        description = locale('info.close_vehicle_lockbox_option_description'),
                        arrow = true,
                        onSelect = function()
                            lation_ui:hideMenu()
                        end
                    }
                }
            })

            lation_ui:showMenu('vehicle_lockbox_menu')
        else
            if Config.Notify == 'esx' then
                ESX.ShowNotification(locale('error.unsupported_menu_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.unsupported_menu_title'),
                    description = locale('error.unsupported_menu_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                lation_ui:notify({
                    title = locale('error.unsupported_menu_title'),
                    message = locale('error.unsupported_menu_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end

    local function openLockbox()
        if Config.Menu.enabled then
            openLockboxMenu()
        else
            openLockboxInventory()
        end
    end

    RegisterNetEvent('stark_lockbox:client:openLockbox', function()
        if not GetInvokingResource() then return end

        local Player = PlayerPedId()
        if IsPedInAnyVehicle(Player, false) then
            local vehicle = GetVehiclePedIsIn(Player, false)
            local vehicleType = GetVehicleClass(vehicle)
            if vehicleType == 18 then
                if xCheckValidPoliceJob() or xCheckValidAmbulanceJob() then
                    if Config.Framework == 'esx' and Config.Progress.framework == 'esx' then
                        if Config.Progress.enabled then
                            if Config.Progress.type == 'esx' then
                                ESX.Progressbar(locale('info.progress_label'), Config.Progress.duration, {
                                    FreezePlayer = false,
                                    onFinish = function()
                                        openLockbox()
                                    end,
                                    onCancel = function()
                                        ESX.ShowNotification(locale('error.cancellation_description'), 'error', 5000)
                                    end
                                })
                            elseif Config.Progress.type == 'ox_bar' then
                                if lib.progressBar({
                                        duration = Config.Progress.duration,
                                        label = locale('info.progress_label'),
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            move = true,
                                            car = false,
                                            combat = true,
                                            mouse = false,
                                            sprint = true
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                end
                            elseif Config.Progress.type == 'ox_circle' then
                                if lib.progressCircle({
                                        duration = Config.Progress.duration,
                                        label = locale('info.progress_label'),
                                        position = 'bottom',
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            move = true,
                                            car = false,
                                            combat = true,
                                            mouse = false,
                                            sprint = true
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lib.notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                end
                            elseif Config.Progress.type == 'lation' then
                                if lation_ui:progressBar({
                                        label = locale('info.progress_label'),
                                        duration = Config.Progress.duration,
                                        icon = 'fas fa-box-open',
                                        iconColor = '#FFFFFF',
                                        color = '#FF0000',
                                        steps = {
                                            { description = 'Inserting The Key...' },
                                            { description = 'Turning The Key...' },
                                            { description = 'Opening The Lockbox...' }
                                        },
                                        canCancel = true,
                                        useWhileDead = false,
                                        disable = {
                                            move = true,
                                            sprint = true,
                                            car = false,
                                            combat = true,
                                            mouse = false
                                        }
                                    }) then
                                    openLockbox()
                                else
                                    lation_ui:notify({
                                        title = locale('error.cancellation_title'),
                                        description = locale('error.cancellation_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                end
                            else
                                -- Progress Type Not Supported
                                if Config.Notify == 'esx' then
                                    ESX.ShowNotification(locale('error.unsupported_progress_type_description'), 'error', 5000)
                                elseif Config.Notify == 'ox' then
                                    lib.notify({
                                        title = locale('error.unsupported_progress_type_title'),
                                        description = locale('error.unsupported_progress_type_description'),
                                        duration = 5000,
                                        position = 'center-right',
                                        type = 'error'
                                    })
                                elseif Config.Notify == 'lation' then
                                    lation_ui:notify({
                                        title = locale('error.unsupported_progress_type_title'),
                                        message = locale('error.unsupported_progress_type_description'),
                                        type = 'error',
                                        duration = 5000,
                                        position = 'center-right'
                                    })
                                else
                                    lib.print.error(locale('error.notification_warning'))
                                end
                            end
                        else
                            -- Progress Not Enabled.
                            openLockbox()
                        end
                    else
                        -- Framework Doesn't Match
                        if Config.Notify == 'esx' then
                            ESX.ShowNotification(locale('error.framework_mismatch_description'), 'error', 5000)
                        elseif Config.Notify == 'ox' then
                            lib.notify({
                                title = locale('error.framework_mismatch_title'),
                                description = locale('error.framework_mismatch_description'),
                                duration = 5000,
                                position = 'center-right',
                                type = 'error'
                            })
                        elseif Config.Notify == 'lation' then
                            lation_ui:notify({
                                title = locale('error.framework_mismatch_title'),
                                message = locale('error.framework_mismatch_description'),
                                type = 'error',
                                duration = 5000,
                                position = 'center-right'
                            })
                        else
                            lib.print.error(locale('error.notification_warning'))
                        end
                    end
                else
                    -- Fails The Job Check
                    if Config.Notify == 'esx' then
                        ESX.ShowNotification(locale('error.incorrect_job_description'), 'error', 5000)
                    elseif Config.Notify == 'ox' then
                        lib.notify({
                            title = locale('error.incorrect_job_title'),
                            description = locale('error.incorrect_job_description'),
                            duration = 5000,
                            position = 'center-right',
                            type = 'error'
                        })
                    elseif Config.Notify == 'lation' then
                        lation_ui:notify({
                            title = locale('error.incorrect_job_title'),
                            message = locale('error.incorrect_job_description'),
                            type = 'error',
                            duration = 5000,
                            position = 'center-right'
                        })
                    else
                        lib.print.error(locale('error.notification_warning'))
                    end
                end
            else
                -- Fails Emergency Vehicle Class Check
                if Config.Notify == 'esx' then
                    ESX.ShowNotification(locale('error.incorrect_vehicle_description'), 'error', 5000)
                elseif Config.Notify == 'ox' then
                    lib.notify({
                        title = locale('error.incorrect_vehicle_title'),
                        description = locale('error.incorrect_vehicle_description'),
                        duration = 5000,
                        position = 'center-right',
                        type = 'error'
                    })
                elseif Config.Notify == 'lation' then
                    lation_ui:notify({
                        title = locale('error.incorrect_vehicle_title'),
                        message = locale('error.incorrect_vehicle_description'),
                        type = 'error',
                        duration = 5000,
                        position = 'center-right'
                    })
                else
                    lib.print.error(locale('error.notification_warning'))
                end
            end
        else
            -- Player Is Not In A Vehicle
            if Config.Notify == 'esx' then
                ESX.ShowNotification(locale('error.player_not_in_vehicle_description'), 'error', 5000)
            elseif Config.Notify == 'ox' then
                lib.notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    description = locale('error.player_not_in_vehicle_description'),
                    duration = 5000,
                    position = 'center-right',
                    type = 'error'
                })
            elseif Config.Notify == 'lation' then
                lation_ui:notify({
                    title = locale('error.player_not_in_vehicle_title'),
                    message = locale('error.player_not_in_vehicle_description'),
                    type = 'error',
                    duration = 5000,
                    position = 'center-right'
                })
            else
                lib.print.error(locale('error.notification_warning'))
            end
        end
    end)
end
