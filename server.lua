local ESX = exports['es_extended']:getSharedObject()
local targetPlayerId = nil

RegisterServerEvent('kaloudas:applyBagToTarget')
AddEventHandler('kaloudas:applyBagToTarget', function()
    if targetPlayerId then
        TriggerClientEvent('kaloudas:applyBagClient', targetPlayerId)
    end
end)

RegisterServerEvent('kaloudas:setTargetPlayer')
AddEventHandler('kaloudas:setTargetPlayer', function(playerId)
    targetPlayerId = playerId
end)

RegisterServerEvent('kaloudas:removeBagFromTarget')
AddEventHandler('kaloudas:removeBagFromTarget', function()
    if targetPlayerId then
        TriggerClientEvent('kaloudas:removeBagClient', targetPlayerId)
    end
end)

ESX.RegisterUsableItem('headbag', function(source)
    TriggerClientEvent('kaloudas:openMenu', source)
end)
