local ESX = exports['es_extended']:getSharedObject()
local isBagActive = false
local bagEntity = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end
end)

function GetNearestPlayer()
    local nearestPlayer, distance = ESX.Game.GetClosestPlayer()
    local playerPed = PlayerPedId()

    if nearestPlayer == -1 or distance > 2.0 then 
        ESX.ShowNotification('~r~No nearby players detected.')
    else
        if not isBagActive then
            TriggerServerEvent('kaloudas:setTargetPlayer', GetPlayerServerId(nearestPlayer))
            ESX.ShowNotification('~g~Bag applied to ~w~' .. GetPlayerName(nearestPlayer))
            TriggerServerEvent('kaloudas:applyBagToTarget')
        else
            ESX.ShowNotification('~r~Target already has a bag applied.')
        end
    end
end

RegisterNetEvent('kaloudas:openMenu')
AddEventHandler('kaloudas:openMenu', function()
    OpenHeadBagMenu()
end)

RegisterNetEvent('kaloudas:applyBagClient')
AddEventHandler('kaloudas:applyBagClient', function()
    local playerPed = PlayerPedId()
    bagEntity = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(bagEntity, playerPed, GetPedBoneIndex(playerPed, 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'showOverlay'})
    isBagActive = true
end)

AddEventHandler('playerSpawned', function()
    if bagEntity then
        DeleteEntity(bagEntity)
        SetEntityAsNoLongerNeeded(bagEntity)
    end
    SendNUIMessage({type = 'hideOverlay'})
    isBagActive = false
end)

RegisterNetEvent('kaloudas:removeBagClient')
AddEventHandler('kaloudas:removeBagClient', function()
    ESX.ShowNotification('~g~Bag removed by another player.')
    if bagEntity then
        DeleteEntity(bagEntity)
        SetEntityAsNoLongerNeeded(bagEntity)
    end
    SendNUIMessage({type = 'hideOverlay'})
    isBagActive = false
end)

function OpenHeadBagMenu()
    local menuOptions = {
        {label = 'Apply Bag to Nearby Player', value = 'apply_bag'},
        {label = 'Remove Bag from Nearby Player', value = 'remove_bag'},
    }

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'headbag_menu',
        {
            title    = 'HEAD BAG CONTROL PANEL',
            align    = 'top-left',
            elements = menuOptions
        },
        function(data, menu)
            local player, distance = ESX.Game.GetClosestPlayer()
            if distance ~= -1 and distance <= 2.0 then
                if data.current.value == 'apply_bag' then
                    GetNearestPlayer()
                elseif data.current.value == 'remove_bag' then
                    TriggerServerEvent('kaloudas:removeBagFromTarget')
                end
            else
                ESX.ShowNotification('~r~No players within interaction range.')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end
