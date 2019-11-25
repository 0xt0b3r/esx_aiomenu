ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_aiomenu:givePhoneNumber')
AddEventHandler('esx_aiomenu:givePhoneNumber', function(ID, targetID)
    local identifier = ESX.GetPlayerFromId(ID).identifier
    local identifier2 = ESX.GetPlayerFromId(targetID).identifier
    local _source 	 = ESX.GetPlayerFromId(targetID).source
    
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
	{
		['@identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            local data = {
                phoneNumber = result[1]['phone_number'],
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname'],
                id1 = tostring(identifier),
                id2 = tostring(identifier2)
            }

            TriggerClientEvent('esx_aiomenu:givePhoneNumber', _source, data) 
        else
            local data = {
                phoneNumber = 'nil',
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname'], 
                id1 = tostring(identifier),
                id2 = tostring(identifier2)
            }

            TriggerClientEvent('esx_aiomenu:givePhoneNumber', _source, data) 
        end
    end)     
end)