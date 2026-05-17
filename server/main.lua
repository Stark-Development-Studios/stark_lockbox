if not lib.checkDependency('ox_lib', '3.33.0', true) then return end

local Config = require 'shared.config'

if Config.VersionCheck then
    lib.versionCheck('AdamaStark-N7/stark_lockbox')
end

Framework = nil

if GetResourceState('es_extended') == 'started' then
    Framework = 'ESX'
elseif GetResourceState('qb-core') == 'started' and GetResourceState('qbx_core') ~= 'started' then
    Framework = 'qb'
elseif GetResourceState('qbx_core') == 'started' then
    Framework = 'qbx'
else
    Framework = nil
    lib.print.error(locale('error.framework_warning'))
end

if Config.Debug then
    lib.print.info('[stark_lockbox] Framework Detected: ' .. tostring(Framework))
end
