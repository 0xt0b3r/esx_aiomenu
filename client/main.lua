local Vehicle = GetVehiclePedIsIn(ped, false)
local inVehicle = IsPedSittingInAnyVehicle(ped)
local lastCar = nil
local myIdentity = {}
local myIdentifiers = {}

ESX                           = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while true do
		Wait(0)

		if IsControlJustPressed(1, 10) then
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped, true) then 
				SendNUIMessage({type = 'showVehicleButton'})
			else 
				SendNUIMessage({type = 'hideVehicleButton'})
			end		
		end
		
		if IsControlJustPressed(1, 322) then
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)

RegisterNUICallback('NUIShowGeneral', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openGeneral'})
end)

RegisterNUICallback('NUIShowInteractions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openInteractions'})
end)

RegisterNUICallback('toggleid', function(data)
	TriggerServerEvent('menu:id', myIdentifiers, data)
end)

RegisterNUICallback('togglephone', function(data)
	TriggerServerEvent('menu:phone', myIdentifiers, data)
end)

RegisterNUICallback('toggleEngineOnOff', function()
	doToggleEngine()
end)

function doToggleEngine()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        if IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
			ESX.ShowNotification('Your engine is now off.')
		else
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
			ESX.ShowNotification('Your engine is now on.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end

RegisterNUICallback('toggleVehicleLocks', function()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)	
	lockStatus = GetVehicleDoorLockStatus(vehicle)
	if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		if lockStatus == 0 or lockStatus == 1 then
			SetVehicleDoorsLocked(lastCar, 2)
			SetVehicleDoorsLockedForPlayer(lastCar, PlayerId(), false)
			ESX.ShowNotification('Your doors are now locked.')
		elseif lockStatus == 2 then
			SetVehicleDoorsLocked(lastCar, 1)
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
			ESX.ShowNotification('Your doors are now unlocked.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

--================================================================================================
--==                                  ESX Actions GUI                                           ==
--================================================================================================
RegisterNUICallback('NUIESXActions', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openESX'})
	SendNUIMessage({type = 'showInventoryButton'})
	SendNUIMessage({type = 'showPhoneButton'})
	SendNUIMessage({type = 'showBillingButton'})
	SendNUIMessage({type = 'showAnimationsButton'})
end)

RegisterNUICallback('NUIopenInventory', function()
	exports['es_extended']:openInventory()
end)

RegisterNUICallback('NUIopenPhone', function()
	exports['esx_phone']:openPhone()
end)

RegisterNUICallback('NUIopenInvoices', function()
	exports['esx_billing']:openInvoices()
end)

RegisterNUICallback('NUIsetVoice', function()
	exports['esx_voice']:setVoice()
end)

RegisterNUICallback('NUIopenAnimations', function()
	exports['esx_animations']:openAnimations()
end)

RegisterNUICallback('NUIJobActions', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openJobs'})
	local job = tostring(exports['esx_policejob']:getJob())
	if job == 'police' then
		SendNUIMessage({type = 'showPoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'ambulance' then
		SendNUIMessage({type = 'showAmbulanceButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'taxi' then
		SendNUIMessage({type = 'showTaxiButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'mecano' then
		SendNUIMessage({type = 'showMechanicButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'fire' then
		SendNUIMessage({type = 'showFireButton'})  
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
	else
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	end
end)

RegisterNUICallback('NUIopenAmbulance', function()
	exports['esx_ambulancejob']:openAmbulance()
end)

RegisterNUICallback('NUIopenPolice', function()
	exports['esx_policejob']:openPolice()
end)

RegisterNUICallback('NUIopenMechanic', function()
	exports['esx_mecanojob']:openMechanic()
end)

RegisterNUICallback('NUIopenTaxi', function()
	exports['esx_taxijob']:openTaxi()
end)

RegisterNUICallback('NUIopenFire', function()
	exports['esx_firejob']:openFire()
end)

RegisterNUICallback('NUIShowVehicleControls', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openVehicleControls'})
end)

RegisterNUICallback('NUIShowDoorControls', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openDoorControls'})
end)

RegisterNUICallback('NUIShowIndividualDoorControls', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openIndividualDoorControls'})
end)

RegisterNUICallback('toggleFrontLeftDoor', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_f')
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
				SetVehicleDoorShut(playerVeh, 0, false)            
			else
				SetVehicleDoorOpen(playerVeh, 0, false)             
			end
		else
			ESX.ShowNotification('This vehicle does not have a front driver-side door.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end)

RegisterNUICallback('toggleFrontRightDoor', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_pside_f')
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
				SetVehicleDoorShut(playerVeh, 1, false)            
			else
				SetVehicleDoorOpen(playerVeh, 1, false)             
			end
		else
			ESX.ShowNotification('This vehicle does not have a front passenger-side door.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end)

RegisterNUICallback('toggleBackLeftDoor', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_r')
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
				SetVehicleDoorShut(playerVeh, 2, false)            
			else
				SetVehicleDoorOpen(playerVeh, 2, false)             
			end
		else
			ESX.ShowNotification('This vehicle does not have a rear driver-side door.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end)

RegisterNUICallback('toggleBackRightDoor', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_pside_r')
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
				SetVehicleDoorShut(playerVeh, 3, false)            
			else
				SetVehicleDoorOpen(playerVeh, 3, false)             
			end
		else
			ESX.ShowNotification('This vehicle does not have a rear passenger-side door.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end)

RegisterNUICallback('toggleHood', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'bonnet')
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
				SetVehicleDoorShut(playerVeh, 4, false)            
			else
				SetVehicleDoorOpen(playerVeh, 4, false)             
			end
		else
			ESX.ShowNotification('This vehicle does not have a hood.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end)

RegisterNUICallback('toggleTrunk', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'boot')
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
				SetVehicleDoorShut(playerVeh, 5, false)            
			else
				SetVehicleDoorOpen(playerVeh, 5, false)             
			end
		else
			ESX.ShowNotification('This vehicle does not have a trunk.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
    end
end)

RegisterNUICallback('toggleWindowsUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
		local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
		local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
		local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
		local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
		local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
		if frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or frontMiddleWindow ~= -1 or rearMiddleWindow ~= -1 then
			RollUpWindow(playerVeh, 0)
			RollUpWindow(playerVeh, 1)
			RollUpWindow(playerVeh, 2)
			RollUpWindow(playerVeh, 3)
			RollUpWindow(playerVeh, 4)
			RollUpWindow(playerVeh, 5)
		else
			ESX.ShowNotification('This vehicle has no windows.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleWindowsDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
		local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
		local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
		local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
		local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
		local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
		if frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or frontMiddleWindow ~= -1 or rearMiddleWindow ~= -1 then
			RollDownWindow(playerVeh, 0)
			RollDownWindow(playerVeh, 1)
			RollDownWindow(playerVeh, 2)
			RollDownWindow(playerVeh, 3)
			RollDownWindow(playerVeh, 4)
			RollDownWindow(playerVeh, 5)
		else
			ESX.ShowNotification('This vehicle has no windows.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleFrontLeftWindowUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
		if frontLeftWindow ~= -1 then
			RollUpWindow(playerVeh, 0)
		else
			ESX.ShowNotification('This vehicle has no front left window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleFrontLeftWindowDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lf')
		if frontLeftWindow ~= -1 then
			RollDownWindow(playerVeh, 0)
		else
			ESX.ShowNotification('This vehicle has no front left window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleFrontRightWindowUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
		if frontRightWindow ~= -1 then
			RollUpWindow(playerVeh, 1)
		else
			ESX.ShowNotification('This vehicle has no front right window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleFrontRightWindowDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rf')
		if frontRightWindow ~= -1 then
			RollDownWindow(playerVeh, 1)
		else
			ESX.ShowNotification('This vehicle has no front right window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleRearLeftWindowUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
		if rearLeftWindow ~= -1 then
			RollUpWindow(playerVeh, 2)
		else
			ESX.ShowNotification('This vehicle has no rear left window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleRearLeftWindowDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local rearLeftWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lr')
		if rearLeftWindow ~= -1 then
			RollDownWindow(playerVeh, 2)
		else
			ESX.ShowNotification('This vehicle has no rear left window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleRearRightWindowUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
		if rearRightWindow ~= -1 then
			RollUpWindow(playerVeh, 3)
		else
			ESX.ShowNotification('This vehicle has no rear right window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleRearRightWindowDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local rearRightWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rr')
		if rearRightWindow ~= -1 then
			RollDownWindow(playerVeh, 3)
		else
			ESX.ShowNotification('This vehicle has no rear right window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleFrontMiddleWindowUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
		if frontMiddleWindow ~= -1 then
			RollUpWindow(playerVeh, 4)
		else
			ESX.ShowNotification('This vehicle has no front middle window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleFrontMiddleWindowDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local frontMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_lm')
		if frontMiddleWindow ~= -1 then
			RollDownWindow(playerVeh, 4)
		else
			ESX.ShowNotification('This vehicle has no front middle window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleRearMiddleWindowUp', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
		if rearMiddleWindow ~= -1 then
			RollUpWindow(playerVeh, 5)
		else
			ESX.ShowNotification('This vehicle has no rear middle window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('toggleRearMiddleWindowDown', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		local rearMiddleWindow = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'window_rm')
		if rearMiddleWindow ~= -1 then
			RollDownWindow(playerVeh, 5)
		else
			ESX.ShowNotification('This vehicle has no rear middle window.')
		end
	else
		ESX.ShowNotification('You must be the driver of a vehicle to use this.')
	end
end)

RegisterNUICallback('NUIShowWindowControls', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openWindowControls'})
end)

RegisterNUICallback('NUIShowIndividiualWindowControls', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openIndividualWindowControls'})
end)

RegisterNUICallback('NUIShowCharacterControls', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openCharacter'})
end)

RegisterNetEvent("menu:setCharacters")
AddEventHandler("menu:setCharacters", function(identity)
	myIdentity = identity
end)

RegisterNetEvent("menu:setIdentifier")
AddEventHandler("menu:setIdentifier", function(data)
	myIdentifiers = data
end)

RegisterNUICallback('NUIdeleteCharacter', function(data)
	TriggerServerEvent('menu:setChars', myIdentifiers)
	Wait(1000)
	SetNuiFocus(true, true)
	local bt  = myIdentity.character1 --- Character 1 ---
  
	SendNUIMessage({
		type = "deleteCharacter",
		char1    = bt,
		backBtn  = "Back",
		exitBtn  = "Exit"
	}) 
end)

RegisterNUICallback('NUInewCharacter', function(data)
	if myIdentity.character1 == "No Character" then
		exports['esx_identity']:openRegistry()
	else
		ESX.ShowNotification('You can only have one character.')
	end
end)

RegisterNUICallback('NUIDelChar', function(data)
	TriggerServerEvent('menu:deleteCharacter', myIdentifiers, data)
	cb(data)
end)

RegisterNetEvent('sendProximityMessageID')
AddEventHandler('sendProximityMessageID', function(id, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
	end
end)

RegisterNetEvent('successfulDeleteIdentity')
AddEventHandler('successfulDeleteIdentity', function(data)
	ESX.ShowNotification('Successfully deleted ' .. data.firstname .. ' ' .. data.lastname .. '.')
end)

RegisterNetEvent('failedDeleteIdentity')
AddEventHandler('failedDeleteIdentity', function(data)
	ESX.ShowNotification('Failed to delete ' .. data.firstname .. ' ' .. data.lastname .. '. Please contact a server admin.')
end)

RegisterNetEvent('noIdentity')
AddEventHandler('noIdentity', function()
	ESX.ShowNotification('You do not have an identity.')
end)