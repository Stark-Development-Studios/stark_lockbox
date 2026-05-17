---@diagnostic disable: lowercase-global

if GetResourceState('es_extended') ~= 'started' then return end

local Config = require 'shared.config'

local ESX = exports['es_extended']:getSharedObject()

function xCheckValidPoliceJob()
    local PlayerData = ESX.GetPlayerData()
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

function xCheckValidAmbulanceJob()
    local PlayerData = ESX.GetPlayerData()
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
