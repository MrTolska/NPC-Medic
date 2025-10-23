-- Author: Bamm

local QBCore = exports['qb-core']:GetCoreObject()

local Active = false
local test = nil
local test1 = nil
local spam = true

RegisterCommand("help", function(source, args, raw)
	if (QBCore.Functions.GetPlayerData().metadata["isdead"]) or (QBCore.Functions.GetPlayerData().metadata["inlaststand"]) and spam then
		QBCore.Functions.TriggerCallback('BammsMedic:docOnline', function(EMSOnline, hasEnoughMoney)
			if EMSOnline <= Config.Doctor and hasEnoughMoney and spam then
				SpawnVehicle(GetEntityCoords(PlayerPedId()))
				TriggerServerEvent('BammsMedic:charge')
				Notify("Medic is arriving")
			else
				if EMSOnline > Config.Doctor then
					Notify("There is too many medics online", "error")
				elseif not hasEnoughMoney then
					Notify("Not Enough Money", "error")
				else
					Notify("Wait Paramedic is on its Way", "primary")
				end	
			end
		end)
	else
		Notify("This can only be used when dead", "error")
	end
end)

function SpawnVehicle(x, y, z)  
	spam = false
	local vehhash = GetHashKey("romero")                                                     
	local loc = GetEntityCoords(PlayerPedId())
	RequestModel(vehhash)
	while not HasModelLoaded(vehhash) do
		Wait(1)
	end
	RequestModel('mp_m_bogdangoon')
	while not HasModelLoaded('mp_m_bogdangoon') do
		Wait(1)
	end
	local spawnRadius = 150                                                    
    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(
        loc.x + math.random(-spawnRadius, spawnRadius), 
        loc.y + math.random(-spawnRadius, spawnRadius), 
        loc.z, 0, 3, 0
    )

	if not DoesEntityExist(vehhash) then
        mechVeh = CreateVehicle(vehhash, spawnPos, spawnHeading, true, false)                        
        ClearAreaOfVehicles(GetEntityCoords(mechVeh), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(mechVeh)
		SetVehicleNumberPlateText(mechVeh, "BammsMedic")
		SetEntityAsMissionEntity(mechVeh, true, true)
		SetVehicleEngineOn(mechVeh, true, true, false)
        
        mechPed = CreatePedInsideVehicle(mechVeh, 26, GetHashKey('mp_m_bogdangoon'), -1, true, false)              	
        
        mechBlip = AddBlipForEntity(mechVeh)                                                        	
        SetBlipFlashes(mechBlip, true)  
        SetBlipColour(mechBlip, 5)

		PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
		Wait(2000)
		TaskVehicleDriveToCoord(mechPed, mechVeh, loc.x, loc.y, loc.z, 20.0, 0, GetEntityModel(mechVeh), 524863, 2.0)
		test = mechVeh
		test1 = mechPed
		Active = true
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if Active then
            local loc = GetEntityCoords(GetPlayerPed(-1))
			local lc = GetEntityCoords(test)
			local ld = GetEntityCoords(test1)
            local dist = Vdist(loc.x, loc.y, loc.z, lc.x, lc.y, lc.z)
			local dist1 = Vdist(loc.x, loc.y, loc.z, ld.x, ld.y, ld.z)
            if dist <= 10 then
				if Active then
					TaskGoToCoordAnyMeans(test1, loc.x, loc.y, loc.z, 1.0, 0, 0, 786603, 0xbf800000)
				end
				if dist1 <= 1 then 
					Active = false
					ClearPedTasksImmediately(test1)
					DoctorNPC()
				end
            end
        end
    end
end)

function DoctorNPC()
    RequestAnimDict("mini@cpr@char_a@cpr_str")
    while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
        Citizen.Wait(1000)
    end

    -- Animation
    TaskPlayAnim(test1, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 1.0, 1.0, -1, 9, 1.0, 0, 0, 0)

    -- Progress Bar
    QBCore.Functions.Progressbar("revive_doc", "The doctor is giving you medical aid", Config.ReviveTime, false, false, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasks(test1)
        Citizen.Wait(500)

        -- Revive
        local playerServerId = GetPlayerServerId(PlayerId())
        TriggerServerEvent("hospital:server:RevivePlayer", playerServerId)

        -- Death Affect
        StopScreenEffect('DeathFailOut')

        -- Payment Notify
        Notify("Your treatment is done, you were charged: "..Config.Price, "success")

        -- NPC Leaves
        TaskEnterVehicle(test1, test, -1, -1, 2.0, 1, 0)
        Citizen.Wait(2000)

        -- NPS Leaves
        local pedCoords = GetEntityCoords(test1)
        local offsetX = math.random(150, 200)
        local offsetY = math.random(150, 200)
        local driveToX = pedCoords.x + offsetX
        local driveToY = pedCoords.y + offsetY
        local driveToZ = pedCoords.z
        TaskVehicleDriveToCoord(test1, test, driveToX, driveToY, driveToZ, 30.0, 0, GetEntityModel(test), 524863, 2.0)

        -- Cleanup
        Citizen.Wait(15000)
        DeleteEntity(test)
        DeleteEntity(test1)
        spam = true
    end)
end

function Notify(msg, state)
    lib.notify({
        type = state or 'info',
        description = msg
    })
end
