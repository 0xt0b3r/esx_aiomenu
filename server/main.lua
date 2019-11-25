ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_aiomenu:givePhoneNumber')
AddEventHandler('esx_aiomenu:givePhoneNumber', function(ID, targetID)
    local identifier = ESX.GetPlayerFromId(ID).identifier
    local _source 	 = ESX.GetPlayerFromId(targetID).source
    
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
    {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            local data = {
                phoneNumber = result[1]['phone_number'],
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname']
            }

            TriggerClientEvent('esx_aiomenu:givePhoneNumber', _source, data) 
        else
            local data = {
                phoneNumber = 'nil',
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname'],
            }

            TriggerClientEvent('esx_aiomenu:givePhoneNumber', _source, data) 
        end
    end)     
end)

RegisterServerEvent('esx_aiomenu:showID')
AddEventHandler('esx_aiomenu:showID', function(ID, targetID)
    local identifier = ESX.GetPlayerFromId(ID).identifier
    local _source 	 = ESX.GetPlayerFromId(targetID).source
    local sexVariable = 'Male'
    
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
    {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            if result[1]['sex'] == 'f' then
                sexVariable = 'Female'
            end

            local data = {
                name = result[1]['firstname'] .. ' ' .. result[1]['lastname'],
                dob = result[1]['dateofbirth'],
                sex = sexVariable,
                height = result[1]['height'] .. ' Inches'
            }

            TriggerClientEvent('esx_aiomenu:showID', _source, data) 
        else
            local data = {
                name = 'Nil',
                dob = 'Nil',
                sex = 'Nil',
                height = 'Nil'
            }

            TriggerClientEvent('esx_aiomenu:showID', _source, data)
        end
    end)     
end)