---@diagnostic disable: lowercase-global

if GetResourceState('qb-core') ~= 'started' or GetResourceState('qbx_core') == 'started' then return end

local Config = require 'shared.config'

local QBCore = exports['qb-core']:GetCoreObject()

function qbCheckValidPoliceJob()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData then return false end
    local currentJob = PlayerData.job
    if not currentJob then return false end
    for _, job in ipairs(Config.PoliceJobs) do
        if (currentJob.name == job) then
            return true
        end
    end
    return false
end

function qbCheckValidAmbulanceJob()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData then return false end
    local currentJob = PlayerData.job
    if not currentJob then return false end
    for _, job in ipairs(Config.AmbulanceJobs) do
        if (currentJob.name == job) then
            return true
        end
    end
    return false
end
