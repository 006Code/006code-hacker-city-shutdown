local ESX = exports['es_extended']:getSharedObject()

local hackerCoords = vector3(1275.599976, -1710.382446, 54.756836) -- Elektriği kesme işleminin kordinatları
local radius = 2.0 
local hackerBlip = nil
local isHacker = false

-- Işıkları kapat
RegisterNetEvent('esx_hacker:shutdownLights')
AddEventHandler('esx_hacker:shutdownLights', function()
    SetArtificialLightsState(true)
    SetArtificialLightsStateAffectsVehicles(false)
    print('Lights have been shut down')
end)

-- Işıkları aç
RegisterNetEvent('esx_hacker:restoreLights')
AddEventHandler('esx_hacker:restoreLights', function()
    SetArtificialLightsState(false)
    print('Lights have been restored')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    isHacker = job.name == 'hacker' -- Boş bırakma buraya hacker job veya farklı birşey gir. 
    updateHackerBlip()
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
    end
    while true do
        Citizen.Wait(10000)
        ESX.TriggerServerCallback('esx_hacker:hasHackerPermission', function(hasPermission)
            isHacker = hasPermission
            updateHackerBlip()
        end)
    end
end)

function updateHackerBlip()
    if isHacker and not hackerBlip then
        hackerBlip = AddBlipForCoord(hackerCoords)
        SetBlipSprite(hackerBlip, 364) 
        SetBlipDisplay(hackerBlip, 4)
        SetBlipScale(hackerBlip, 1.0)
        SetBlipColour(hackerBlip, 1) 
        SetBlipAsShortRange(hackerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Hacker [Elektrik Kes]")
        EndTextCommandSetBlipName(hackerBlip)
    elseif not isHacker and hackerBlip then
        RemoveBlip(hackerBlip)
        hackerBlip = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isHacker then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - hackerCoords)

            if distance < 100.0 then
                DrawMarker(1, hackerCoords.x, hackerCoords.y, hackerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
            end

            if distance < radius then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ tuşuna basarak şehir ışıklarını kapatabilirsiniz.")
                if IsControlJustReleased(0, 38) then -- tuşu istersen burdan değiştirebilirsin.
                    ESX.TriggerServerCallback('esx_hacker:hasHackerPermission', function(hasPermission)
                        if hasPermission then
                            TriggerServerEvent('esx_hacker:shutdownLights')
                        else
                            ESX.ShowNotification("Bu işlemi gerçekleştirmek için yeterli izne sahip değilsiniz.")
                        end
                    end)
                end
            end
        end
    end
end)
