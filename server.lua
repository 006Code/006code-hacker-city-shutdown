local ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('esx_hacker:shutdownLights')
AddEventHandler('esx_hacker:shutdownLights', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'hacker' then
        print('Shutdown lights event triggered')
        TriggerClientEvent('esx_hacker:shutdownLights', -1)
        Citizen.Wait(60000) -- işlem başladığında 60 saniye kadar sürer 1000 = 1s
        TriggerClientEvent('esx_hacker:restoreLights', -1)
    else
        print('Player does not have the hacker job')
    end
end)

ESX.RegisterServerCallback('esx_hacker:hasHackerPermission', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'hacker' then
        cb(true)
    else
        cb(false)
    end
end)
