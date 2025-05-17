local Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,['~'] = 243, 
    ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, 
    ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,['HOME'] = 213, 
    ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, 
    ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

isInInventory = false
ESX = nil
InDelay = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Base.ClientEvent, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(10)
    end

    Citizen.Wait(1000)
    if Config.CacheFastSlot then
        SendNUIMessage({
            action = 'request-browser-cache'
        })
    end

    TriggerServerEvent('yield_addon:inventory:setPlayer', true)
end)


RegisterNUICallback('set-fastslot-cache', function(data, cb)
    if data.slot1 then
        TriggerEvent('esx_inventoryhud:setFastWeapons', 1, data.slot1)
    end
    if data.slot2 then
        TriggerEvent('esx_inventoryhud:setFastWeapons', 2, data.slot2)
    end
    cb('ok')
end)



RegisterNUICallback('ChangeAction', function(data, cb)
    TriggerServerEvent('yield_addon:inventory:setPlayer', data.action)
    cb('ok')
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    closeInventory()
end)

AddEventHandler("iSpecial_Core:ClearMemoryCl", function()
    Citizen.CreateThread(function()
        local rdm = math.random(100, 2000)
        Wait(rdm)
        collectgarbage()
    end)
end)

RegisterKeyMapping('openmyinventory', 'Open Inventory', 'keyboard', Config.OpenControl)

RegisterCommand('openmyinventory', function()
    if not IsPlayerDead(PlayerId()) then
        if not isInInventory then
            if Config.Delay.Enable and InDelay then
                return
            end
            openInventory()
            isInInventory = true
        end
    end
end, false)

function closeInventory()
    isInInventory = false
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
    TriggerEvent('meeta_carinventory:setOpenMenu', false)

    if Config.BlurBackdrop then
        TriggerScreenblurFadeOut(1200)
    end

    if Config.Delay.Enable then
        InDelay = true

        SetTimeout(Config.Delay.Length, function()
            InDelay = false
        end)
    end
end

RegisterNUICallback('NUIFocusOff',function()
    closeInventory()
end)

RegisterNUICallback('GetNearPlayers',function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}

    for i = 1, #players, 1 do
        if GetPlayerServerId(players[i]) == tonumber(data.player) then
            foundPlayers = true
        end
    end

    if not foundPlayers then
        exports.pNotify:SendNotification(
            {
                text = 'ผู้เล่นอยู่ไกลเกินไป!!',
                type = 'error',
                timeout = 3000,
                layout = 'bottomRight',
                queue = 'inventoryhud'
            }
        )
    else
        SendNUIMessage({
            action = 'nearPlayers',
            item = data.item,
            player = data.player
        })
    end
    cb('ok')
end)

RegisterNUICallback('GetNearPlayersPolice', function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 1.0)
    local foundPlayers = false
    local elements = {}
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true
			table.insert(elements, {
                label = GetPlayerName(players[i]),
                player = GetPlayerServerId(players[i])
			})
        end
    end

    if not foundPlayers then
        exports.pNotify:SendNotification({
            text = 'ผู้เล่นอยู่ไกลเกินไป!!!',
            type = 'error',
            timeout = 3000,
            layout = 'bottomRight',
            queue = 'inventoryhud'
        })
    else
        SendNUIMessage({
            action = 'nearPlayers',
            foundAny = foundPlayers,
            players = elements,
            item = data.item
        })
    end
    cb('ok')
end)

RegisterNUICallback('SetCurrentMenu', function(type, cb)
    local Value = type.type or 'inventory_all'
    Current_Menu = Value
    cb('ok')
end)

RegisterNUICallback('UseItem',function(data, cb)
        if string.find(data.item.type, 'house_keys_') then
            local house_ident = string.gsub(data.item.type, 'house_keys_', '')
            TriggerEvent('scotty-housekeys:renameKeys', house_ident, data.item.label)
            closeInventory()
            return
        end
                      
        if string.find(data.item.type, 'car_key_') then
			local plate = string.gsub(data.item.type, 'car_key_', '')
			    TriggerEvent('scotty:keyTrigger', plate) 
                closeInventory()
            elseif data.item.type == 'item_key' then
                --TriggerEvent('caruby_invenkeys:useKey', data.item.label)
                TriggerServerEvent('lock:sentplate', data.item.label)
                --TriggerServerEvent('cjjoeza_remote:ServerLock', data.item.label)
                closeInventory()			
		    elseif data.item.name == 'id_card' then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                local player, distance = ESX.Game.GetClosestPlayer()
                
                if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
                end
				closeInventory()	
            elseif data.item.name == 'driver_license' then
                TriggerEvent('jsfour-idcard:dv_license', source)
				closeInventory()	
            elseif data.item.type == 'item_accessories' then
            local player = GetPlayerPed(-1)	
                closeInventory()			 
           
            if data.item.name == 'helmet' then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin['helmet_1'] == -1 then

                        local dict = 'veh@bicycle@roadfront@base'
                        local anim = 'put_on_helmet'
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(1000)

                        local accessorySkin = {}
                        accessorySkin['helmet_1'] = data.item.itemnum
                        accessorySkin['helmet_2'] = data.item.itemskin

                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    else

                         if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = 'veh@bike@common@front@base'
                            local anim = 'take_off_helmet_walk'

                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
                
                            Wait(800)
                        end

                        local accessorySkin = {}
                        accessorySkin['helmet_1'] = -1
                        accessorySkin['helmet_2'] = 0
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    end
                    
                end)
            elseif data.item.name == 'mask' then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin['mask_1'] == -1 then

                        local dict = 'veh@bicycle@roadfront@base'
                        local anim = 'put_on_helmet'
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(1000)

                        local accessorySkin = {}
                        accessorySkin['mask_1'] = data.item.itemnum
                        accessorySkin['mask_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    else

                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = 'veh@bike@common@front@base'
                            local anim = 'take_off_helmet_walk'

                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
                
                            Wait(800)
                        end

                        local accessorySkin = {}
                        accessorySkin['mask_1'] = -1
                        accessorySkin['mask_2'] = 0
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    end
                    
                end)
            elseif data.item.name == 'glasses' then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin['glasses_1'] == -1 then

                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = 'clothingspecs'
                            local anim = 'try_glasses_positive_a'
                
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
                
                            Wait(800)
                        end

                        local accessorySkin = {}
                        accessorySkin['glasses_1'] = data.item.itemnum
                        accessorySkin['glasses_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)

                    else

                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = 'clothingspecs'
                            local anim = 'take_off'
                
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
                
                            Wait(1000)
                        end

                        local accessorySkin = {}
                        accessorySkin['glasses_1'] = -1
                        accessorySkin['glasses_2'] = 0
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    end
                    
                end)
			-------------------------------------------------------------------[1]-------------------------------------------------------------------           
            -- tshirt
        elseif data.item.name == 'tshirt' then
            TriggerEvent('skinchanger:getSkin', function(skin)

            

               --[[  if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end ]]

                local accessorySkin = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
               -- exports['mythic_notify']:DoHudText('success', Config.Text.torsoon)              
           
            
            end)
        elseif data.item.name == 'asdads' then
            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin['tshirt_1'] == -1 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['tshirt_1']  = data.item.itemnum
                accessorySkin['tshirt_2']  = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('success', Config.Text.torsoon)              
            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['tshirt_1'] = -1
                accessorySkin['tshirt_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error', Config.Text.torsooff) 
            end
            
        end)
        -- Torso
        elseif data.item.name == 'torso' then
            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin['torso_1'] == -1 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['torso_1']   = data.item.itemnum
                accessorySkin['torso_2']   = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
                exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['torso_1'] = -1
                accessorySkin['torso_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
            end
            
        end)
        -- arms
    elseif data.item.name == 'arms' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin['arms'] == 15 then

            if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                RequestAnimDict(Config.Options.dicton)
                while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                Wait(2000)
            end

            local accessorySkin = {}
            accessorySkin['arms']   = data.item.itemnum
            accessorySkin['arms_2']   = data.item.itemskin
            TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)  
            exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)              
        else

            if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                RequestAnimDict(Config.Options.dictoff)
                while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                Wait(2000)
            end

            local accessorySkin = {}
            accessorySkin['arms'] = 15
            accessorySkin['arms_2'] = 0
            TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)  
        end       
    end)
     elseif data.item.name == 'pants' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin['pants_1'] == 21 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['pants_1'] = data.item.itemnum
                accessorySkin['pants_2'] = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('success', Config.Text.pantson)  

            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['pants_1'] = 21
                accessorySkin['pants_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error',  Config.Text.pantsoff)  
            end
            
        end)
    elseif data.item.name == 'shoes' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin['shoes_1'] == 34 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['shoes_1'] = data.item.itemnum
                accessorySkin['shoes_2'] = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('success',  Config.Text.shoeson)  

                ClearPedTasks(player)
            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['shoes_1'] = 34
                accessorySkin['shoes_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error',  Config.Text.shoesoff)  
            end
            
        end)			
            elseif data.item.name == 'earring' then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin['ears_1'] == -1 then

                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = 'mini@ears_defenders'
                            local anim = 'takeoff_earsdefenders_idle'
                
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
                
                            Wait(800)
                        end

                        local accessorySkin = {}
                        accessorySkin['ears_1'] = data.item.itemnum
                        accessorySkin['ears_2'] = data.item.itemskin
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    else

                        if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                            local dict = 'mini@ears_defenders'
                            local anim = 'takeoff_earsdefenders_idle'
                
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                            
                            TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
                
                            Wait(800)
                        end

                        local accessorySkin = {}
                        accessorySkin['ears_1'] = -1
                        accessorySkin['ears_2'] = 0
                        TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                    end
                    
                end)
        elseif data.item.name == 'decals' then
            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin['decals_1'] == -1 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['decals_1']   = data.item.itemnum
                accessorySkin['decals_2']   = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
                exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['decals_1'] = -1
                accessorySkin['decals_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
            end
        end)
        elseif data.item.name == 'chain' then
            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin['chain_1'] == -1 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['chain_1']   = data.item.itemnum
                accessorySkin['chain_2']   = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
                exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['chain_1'] = -1
                accessorySkin['chain_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
            end
        end)
        elseif data.item.name == 'bags' then
            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin['bags_1'] == -1 then

                if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dicton)
                    while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['bags_1']   = data.item.itemnum
                accessorySkin['bags_2']   = data.item.itemskin
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin) 
                exports['mythic_notify']:DoHudText('success',  Config.Text.torsoon)             
            else

                if Config.Options.enabledoff and IsPedInAnyVehicle(PlayerPedId(), true) == false then
                    RequestAnimDict(Config.Options.dictoff)
                    while (not HasAnimDictLoaded(Config.Options.dictoff)) do Citizen.Wait(0) end
                    TaskPlayAnim(player, Config.Options.dictoff, Config.Options.animoff, 8.0, 1.0, -1, 0, 0.3, 0, 0)
                    Wait(2000)
                end

                local accessorySkin = {}
                accessorySkin['bags_1'] = -1
                accessorySkin['bags_2'] = 0
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                exports['mythic_notify']:DoHudText('error',  Config.Text.torsooff)      
            end
        end)
        end
        else
            TriggerServerEvent('esx:useItem', data.item.name)
            if ItemCloseInventory(data.item.name) then
                closeInventory()
            else	
                Citizen.Wait(500)
                loadPlayerInventory()
            end
        end
    cb('ok')
end)

RegisterNUICallback('DropItem',function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if data.item.name == 'idcard'
		or data.item.name == 'driverid'
		or data.item.name == 'weaponid' then
			return
		end

    if Config.disableDrop and Config.disableDrop[data.item.name] then
        exports.pNotify:SendNotification(
            {
                text = 'ไม่สามารถทิ้งของชิ้นนี้ได้!!',
                type = 'error',
                timeout = 3000,
                layout = 'bottomRight',
                queue = 'inventoryhud'
            }
        )
        closeInventory()
    elseif type(data.number) == 'number' and math.floor(data.number) == data.number then
        TriggerServerEvent('esx:removeInventoryItem', data.item.type, data.item.name, data.number)
        closeInventory()
    end
    cb('ok')
end)

local carkeys AddEventHandler('scotty:globalFetchCarKeys', function(keys) carkeys = keys end)

RegisterNUICallback('GiveItem',function(data, cb)		
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    
    if Config.disableGive and Config.disableGive[data.item.name] then
        exports.pNotify:SendNotification(
            {
                text = 'ไม่สามารถให้ของชิ้นนี้ได้!!',
                type = 'error',
                timeout = 3000,
                layout = 'bottomRight',
                queue = 'inventoryhud'
            }
        )
        closeInventory()
        return
    end

    for k, v in pairs(players) do
        if GetPlayerServerId(v) == tonumber(data.player) then
            foundPlayer = true
            break
        end
    end
    
    local count = tonumber(data.number)
    local health = GetEntityHealth(playerPed)
    if health >= 101 then
        if not foundPlayer then
            exports.pNotify:SendNotification(
                {
                    text = 'ไม่พบผู้เล่นที่ต้องการให้!!',
                    type = 'error',
                    timeout = 3000,
                    layout = 'bottomRight',
                    queue = 'inventoryhud'
                }
            )
            return
        end

        if data.item.type == 'item_weapon' then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end
        
        local lPed = GetPlayerPed(-1)
        if not IsPedInAnyVehicle(lPed, false) and IsPedOnFoot(lPed) and not IsPedUsingAnyScenario(lPed) and string.find(data.item.type, 'item_key') then
            local plate = string.gsub(data.item.type, 'item_key', '')
            --TriggerServerEvent('scotty:giveCarKey', data.player, plate)
            if Config.ItemTradeCarkey then
                vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 5.0)
                if #vehicles > 0 then
                    local Check = false
                    for _,veh in ipairs(vehicles) do
                        if ESX.Math.Trim(GetVehicleNumberPlateText(veh)) == ESX.Math.Trim(data.item.label) then
                            for k,v in pairs(Config.ItemTradeCarkeyName) do
                                for __,model in pairs(Config.ItemTradeCarkeyName[k]) do
                                    if string.upper(model) == GetDisplayNameFromVehicleModel(GetEntityModel(veh)) then
                                        if checkHasItem(k) then
                                            TriggerEvent('xzero_giveui:client:On_GiveItem', data)
                                            TriggerServerEvent(Base.PrefixEvent .. ':removeitemtradekey', k)
                                            TriggerServerEvent(Base.PrefixEvent .. ':updateKey', data.player, data.item.type, data.item.label)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                --[[if checkHasItem(Config.ItemTradeCarkeyName) then
                    TriggerEvent(':client:On_GiveItem', data)
                    TriggerServerEvent(Base.PrefixEvent .. ':updateKey', data.player, data.item.type, data.item.label)
                else
                    exports.pNotify:SendNotification(
                        {
                            text = '<strong class="red-text">ไม่สามารถเทรดกุญแจถ้าไม่มีใบโอนรถนะ หนู หนู</strong>',
                            type = 'error',
                            timeout = 3000,
                            layout = 'bottomRight',
                            queue = 'inventoryhud'
                        }
                    )
                end]]
            else
                TriggerEvent('xzero_giveui:client:On_GiveItem', data)
                TriggerServerEvent(Base.PrefixEvent .. ':updateKey', data.player, data.item.type, data.item.label)
            end
            
            
            Wait(500)
            closeInventory()
            return
        elseif data.item.type == 'item_keyhouse' then
            TriggerEvent('xzero_giveui:client:On_GiveItem', data)
            TriggerServerEvent(Base.PrefixEvent .. ':updateKey', data.player, data.item.type, data.item.house_id)
        else
            TriggerServerEvent('yield_addon:inventory:giveInventoryItem', data.player, data.item.type, data.item.name, count, data)
        end
        Wait(250)
        loadPlayerInventory()
    else
        exports.pNotify:SendNotification(
            {
                text = 'ไม่สามารถเทรดของตอนตายได้!!',
                type = 'error',
                timeout = 3000,
                layout = 'bottomRight',
                queue = 'inventoryhud'
            }
        )
    end
    cb('ok')
end)



RegisterNetEvent('yield_addon:inventory:itemlimit')
AddEventHandler('yield_addon:inventory:itemlimit', function()
    exports.pNotify:SendNotification({
        text = 'เนื่องจากผู้รับของเต็มจึงไม่สามารถให้ได้!!',
        type = 'error',
        timeout = 3000,
        layout = 'bottomRight',
        queue = 'inventoryhud'
    })
end)

function checkHasItem (item_name)
	local inventory = ESX.GetPlayerData().inventory
	for i=1, #inventory do
	  local item = inventory[i]
	  if item_name == item.name and item.count > 0 then
		return true
	  end
	end
	return false
end

RegisterNUICallback('UseMask',function(data, cb)
    if data.item.type == 'item_accessories' then
        local player = GetPlayerPed(-1)

        closeInventory()
       
        if data.item.name == 'helmet' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin['helmet_1'] == -1 then

                    local dict = 'veh@bicycle@roadfront@base'
                    local anim = 'put_on_helmet'
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(1000)

                    local accessorySkin = {}
                    accessorySkin['helmet_1'] = data.item.itemnum
                    accessorySkin['helmet_2'] = data.item.itemskin

                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                else

                     if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        local dict = 'veh@bike@common@front@base'
                        local anim = 'take_off_helmet_walk'

                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(800)
                    end

                    local accessorySkin = {}
                    accessorySkin['helmet_1'] = -1
                    accessorySkin['helmet_2'] = 0
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                end
                
            end)
        elseif data.item.name == 'mask' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin['mask_1'] == -1 then

                    local dict = 'veh@bicycle@roadfront@base'
                    local anim = 'put_on_helmet'
        
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                    
                    TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        
                    Wait(1000)

                    local accessorySkin = {}
                    accessorySkin['mask_1'] = data.item.itemnum
                    accessorySkin['mask_2'] = data.item.itemskin
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                else

                    if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        local dict = 'veh@bike@common@front@base'
                        local anim = 'take_off_helmet_walk'

                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(800)
                    end

                    local accessorySkin = {}
                    accessorySkin['mask_1'] = -1
                    accessorySkin['mask_2'] = 0
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                end
                
            end)
        elseif data.item.name == 'glasses' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin['glasses_1'] == -1 then

                    if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        local dict = 'clothingspecs'
                        local anim = 'try_glasses_positive_a'
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(800)
                    end

                    local accessorySkin = {}
                    accessorySkin['glasses_1'] = data.item.itemnum
                    accessorySkin['glasses_2'] = data.item.itemskin
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)

                    ClearPedTasks(player)
                else

                    if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        local dict = 'clothingspecs'
                        local anim = 'take_off'
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(1000)
                    end

                    local accessorySkin = {}
                    accessorySkin['glasses_1'] = -1
                    accessorySkin['glasses_2'] = 0
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                end
                
            end)
        elseif data.item.name == 'earring' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin['ears_1'] == -1 then

                    if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        local dict = 'mini@ears_defenders'
                        local anim = 'takeoff_earsdefenders_idle'
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(800)
                    end

                    local accessorySkin = {}
                    accessorySkin['ears_1'] = data.item.itemnum
                    accessorySkin['ears_2'] = data.item.itemskin
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                else

                    if IsPedInAnyVehicle(PlayerPedId(), true) == false then
                        local dict = 'mini@ears_defenders'
                        local anim = 'takeoff_earsdefenders_idle'
            
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                        
                        TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            
                        Wait(800)
                    end

                    local accessorySkin = {}
                    accessorySkin['ears_1'] = -1
                    accessorySkin['ears_2'] = 0
                    TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
                end 
            end)
        end
    end
end)

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end
    return false
end

RegisterNetEvent(Base.PrefixEvent .. ':closeHud')
AddEventHandler(Base.PrefixEvent .. ':closeHud',function()
    closeInventory()
end)

-- print(isInInventory)

Citizen.CreateThread(function()
    while isInInventory do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        DisableControlAction(0, 1, true) -- Disable pan
        DisableControlAction(0, 2, true) -- Disable tilt
        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack 2
        DisableControlAction(0, 25, true) -- Aim
        DisableControlAction(0, 263, true) -- Melee Attack 1
        DisableControlAction(0, Keys['W'], true) -- W
        DisableControlAction(0, Keys['A'], true) -- A
        DisableControlAction(0, 31, true) -- S (fault in Keys table!)
        DisableControlAction(0, 30, true) -- D (fault in Keys table!)
        DisableControlAction(0, Keys['R'], true) -- Reload
        DisableControlAction(0, Keys['SPACE'], true) -- Jump
        DisableControlAction(0, Keys['Q'], true) -- Cover
        -- DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
        DisableControlAction(0, Keys['F'], true) -- Also 'enter'?
        DisableControlAction(0, Keys['F1'], true) -- Disable phone
        DisableControlAction(0, Keys['F2'], true) -- Inventory
        DisableControlAction(0, Keys['F3'], true) -- Animations
        DisableControlAction(0, Keys['F6'], true) -- Job
        DisableControlAction(0, Keys['V'], true) -- Disable changing view
        DisableControlAction(0, Keys['C'], true) -- Disable looking behind
        DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
        DisableControlAction(2, Keys['P'], true) -- Disable pause screen
        DisableControlAction(0, 59, true) -- Disable steering in vehicle
        DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
        DisableControlAction(0, 72, true) -- Disable reversing in vehicle
        DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
        DisableControlAction(0, 47, true) -- Disable weapon
        DisableControlAction(0, 264, true) -- Disable melee
        DisableControlAction(0, 257, true) -- Disable melee
        DisableControlAction(0, 140, true) -- Disable melee
        DisableControlAction(0, 141, true) -- Disable melee
        DisableControlAction(0, 142, true) -- Disable melee
        DisableControlAction(0, 143, true) -- Disable melee
        DisableControlAction(0, 75, true) -- Disable exit vehicle
        DisableControlAction(27, 75, true) -- Disable exit vehicle
        DisableControlAction(0, 288, true) -- Disable exit vehicle
    end
end)

AddEventHandler(Base.PrefixEvent .. ':closeInventory', function()
    closeInventory()
end) 

RegisterCommand(Config.CloseCommand, function()
    TriggerEvent(Base.PrefixEvent .. ':closeInventory')
    exports.pNotify:SendNotification(
        {
            text = 'ปิดกระเป๋าเรียบร้อย',
            type = 'success',
            timeout = 3000,
            layout = 'bottomRight'
        }
    )
end)

function ItemCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end
    return false
end

RegisterNetEvent(Base.PrefixEvent .. ':closeInventory2')
AddEventHandler(Base.PrefixEvent .. ':closeInventory2', function()
    closeInventory()
end)




local currentWeapon = -1569615261 -- Default Weapon hash
local nextWeapon = -1569615261
local bSwitching = false
local SwitchDuration = 2 * 1000
local AnimDictLoaded = false

local AnimDict = "reaction@intimidation@1h"
local DrawAnim = "intro"
local HolsterAnim = "outro" -- ใช้เป็นท่าเก็บอาวุธ


Citizen.CreateThread(
	function()
		function ActionBlocking()
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 140, true)
			DisableControlAction(2, 141, true)
			DisableControlAction(2, 142, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(2, 37, true)
			DisableControlAction(2, 19, true)
		end

		function OnSwitchStarted()
			DisablePlayerFiring(GetPlayerPed(-1), true)
			bSwitching = true
			SetCurrentPedWeapon(GetPlayerPed(-1), currentWeapon, true)
		
			-- เช็กว่าเรากำลังเก็บหรือชัก
			if nextWeapon == -1569615261 or nextWeapon == 966099553 then
				-- เก็บอาวุธ (ไปมือเปล่า)
				TaskPlayAnim(GetPlayerPed(-1), AnimDict, HolsterAnim, 8.0, 2.0, -1, 48, 2, 0, 0, 0)
			else
				-- ชักอาวุธ (จากมือเปล่า)
				TaskPlayAnim(GetPlayerPed(-1), AnimDict, DrawAnim, 8.0, 2.0, -1, 48, 2, 0, 0, 0)
			end
		end

		function OnSwitchDone()
			SetCurrentPedWeapon(GetPlayerPed(-1), nextWeapon, true)
			currentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
			Citizen.Wait(SwitchDuration * 0.25)
			-- ClearPedTasks(GetPlayerPed(-1))
			bSwitching = false
			DisablePlayerFiring(GetPlayerPed(-1), false)
		end

		function WeaponSwitchAnimation()
			nextWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
			if (currentWeapon ~= nextWeapon and nextWeapon ~= 966099553) then
				OnSwitchStarted(GetPlayerPed(-1))
				Citizen.Wait(SwitchDuration * 0.75)
				OnSwitchDone(GetPlayerPed(-1))
			end
		end

		test2 = false
		Citizen.CreateThread(
			function()
				while true do
					Citizen.Wait(0)
					test2 = true
					if (IsPedOnFoot(GetPlayerPed(-1))) then
						if not (bSwitching) then
							test2 = false
							WeaponSwitchAnimation()
						end
					end
					if test2 then
						Wait(500)
					end
				end
			end
		)
		test = false
		Citizen.CreateThread(
			function()
				while true do
					Citizen.Wait(0)
					test = true

					if not (AnimDictLoaded) then
						while not (GetPlayerPed(-1)) do
							Citizen.Wait(100)
						end

						RequestAnimDict(AnimDict)
						while not (HasAnimDictLoaded(AnimDict)) do
							Citizen.Wait(100)
						end
						AnimDictLoaded = true
					end

					if (IsPedOnFoot(GetPlayerPed(-1))) then
						if (bSwitching) then
							test = false
							ActionBlocking()
							DisablePlayerFiring(GetPlayerPed(-1), true)
						end
						if (IsPedPerformingMeleeAction(GetPlayerPed(-1))) then
							test = false
							DisableControlAction(2, 157, true)
							DisableControlAction(2, 158, true)
							DisableControlAction(2, 159, true)
							DisableControlAction(2, 160, true)
							DisableControlAction(2, 161, true)
							DisableControlAction(2, 162, true)
							DisableControlAction(2, 163, true)
							DisableControlAction(2, 164, true)
							DisableControlAction(2, 165, true)
						end
					end
					if test then
						Wait(300)
					end
				end
			end
		)
	end
)

RegisterNUICallback("RefreshInventory", function(data, cb)
    local playerData = ESX.GetPlayerData()
    local items = playerData.inventory
    local fastItems = {} -- ถ้าคุณมีระบบ fastslot

    -- ส่งกลับไปให้ JS
    SendNUIMessage({
        action = "setItems",
        itemList = items,
        fastItems = fastItems
    })
end)


local currentmain = 1
local currentuse = {}

function selectmain()
    local skins = Config["WEAPONSKIN"][currentmain]["SKIN"]
    local filteredSkins = {}

    for k, v in ipairs(skins) do
        if v["ITEMUSE"] == nil or checkitem(v["ITEMUSE"]) then
            v["GOT"] = true
            table.insert(filteredSkins, v)
        end
    end

    SendNUIMessage({
        action = "selectmain",
        select = currentmain,
        data = filteredSkins -- ส่งเฉพาะสกินที่เรามีไอเทม หรือสกิน reset (ITEMUSE = nil)
    })
    
end


function updateskin()
	local weaponName = currentmain -- currentmain = "WEAPON_PISTOL" (string)
	for k, v in ipairs(Config["WEAPONSKIN"][weaponName]["SKIN"]) do
		v["GOT"] = false
		if checkitem(v["ITEMUSE"]) then
			v["GOT"] = true
		end
	end
	SendNUIMessage({
		action = "updateskin",
		select = weaponName, -- เปลี่ยนจาก index → เป็นชื่ออาวุธ
		data = Config["WEAPONSKIN"][weaponName]["SKIN"],
	})
end

RegisterNUICallback('UseSkin', function(data, cb)
	if data.action == "selectmain" then
		local weaponName = data.weaponName
		if Config["WEAPONSKIN"][weaponName] then
			currentmain = weaponName
			selectmain()
		end
	elseif data.action == "selectskin" then
		local weaponName = data.weaponName
		if Config["WEAPONSKIN"][weaponName] then
			currentmain = weaponName
			local selectskinid = math.floor(data.id + 1)
			if selectskinid == 1 then
				selectskin(selectskinid, false) -- ✅ slot แรก = ถอดสกิน
			else
				selectskin(selectskinid, true)  -- ✅ slot อื่น = ใส่สกิน
			end
		end
	end
end)

function selectskin(skin, state)
    local datamain = Config["WEAPONSKIN"][currentmain]
    local dataskin = skin

    if state then
        local isAlreadyInUse = datamain["SKIN"][dataskin]["INUSE"] == true
        local isSameAsCurrent = datamain["INUSE"] and datamain["INUSE"]["INDEX"] == dataskin

        if isAlreadyInUse and isSameAsCurrent then
            TriggerEvent("mythic_notify:client:SendAlert", {text = "สกินนี้ถูกใช้งานอยู่แล้ว", type = "error", timeout = 3000})
            return
        end

        if checkitem(datamain["SKIN"][dataskin]["ITEMUSE"]) then
            -- ถ้ามีการใช้งานสกินอื่นอยู่ ให้ถอดออกก่อน
            if datamain["INUSE"] and datamain["INUSE"]["INDEX"] ~= dataskin then
                if currentuse[datamain["MAIN"]] and currentuse[datamain["MAIN"]]["MODEL"] then
                    DeleteObject(currentuse[datamain["MAIN"]]["MODEL"])
                    currentuse[datamain["MAIN"]]["MODEL"] = nil
                end
                datamain["SKIN"][datamain["INUSE"]["INDEX"]]["INUSE"] = false
            end

            local hasmainweapon = false
            if not datamain["MAIN"]["ITEMWEAPON"] then
                if HasPedGotWeapon(PlayerPedId(), GetHashKey(datamain["MAIN"]), false) then
                    hasmainweapon = true
                end
            else
                if checkitem(datamain["MAIN"]) then
                    hasmainweapon = true
                end
            end

            if hasmainweapon then
                datamain["INUSE"] = {}
                datamain["INUSE"]["NAME"] = datamain["SKIN"][dataskin]["NAME"]
                datamain["INUSE"]["INDEX"] = dataskin
                datamain["SKIN"][dataskin]["INUSE"] = true

                currentuse[datamain["MAIN"]] = {}
                currentuse[datamain["MAIN"]]["SKIN"] = datamain["SKIN"][dataskin]["NAME"]
                currentuse[datamain["MAIN"]]["POSITION"] = datamain["POSITION"]

                SendNUIMessage({
                    action = "updateSkinIcon",
                    weapon = datamain["MAIN"],
                    image = datamain["SKIN"][dataskin]["IMAGE"] -- ส่งชื่อไฟล์รูป เช่น "weapon_skin_a"
                })                

                updateskin()
                TriggerEvent("mythic_notify:client:SendAlert", {text = "คุณได้สวมสกินแล้ว", type = "success", timeout = 3000})
            else
                TriggerEvent("mythic_notify:client:SendAlert", {text = "คุณไม่มีอาวุธสำหรับสกินนี้", type = "error", timeout = 3000})
            end
        else
            TriggerEvent("mythic_notify:client:SendAlert", {text = "คุณไม่มีไอเทมสกินนี้", type = "error", timeout = 3000})
        end
    else
        -- ถอดสกิน
        if datamain["INUSE"] then
            local lastUsedIndex = datamain["INUSE"]["INDEX"]
            datamain["SKIN"][lastUsedIndex]["INUSE"] = false

            if currentuse[datamain["MAIN"]] and currentuse[datamain["MAIN"]]["MODEL"] then
                DeleteObject(currentuse[datamain["MAIN"]]["MODEL"])
                currentuse[datamain["MAIN"]]["MODEL"] = nil
            end

            currentuse[datamain["MAIN"]] = nil
            SetPedCurrentWeaponVisible(PlayerPedId(), 1, 0, 1, 1)

            datamain["INUSE"] = nil

            SendNUIMessage({
                action = "updateSkinIcon",
                weapon = datamain["MAIN"],
                image = datamain["MAIN"] -- ใช้ชื่ออาวุธเป็นรูป default
            })            

            updateskin()
            TriggerEvent("mythic_notify:client:SendAlert", {text = "คุณได้ถอดสกินแล้ว", type = "info", timeout = 3000})
        else
            TriggerEvent("mythic_notify:client:SendAlert", {text = "ไม่ได้ใส่สกินอยู่", type = "error", timeout = 3000})
        end
    end
end



function checkitem(name)
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        if v.name == name then
            if v.count > 0 then
                return true
            end
        end
    end
    return false
end


CreateThread(function()
	while true do
		nothing, weapon = GetCurrentPedWeapon(GetPlayerPed(-1), true)
		for k, v in pairs(currentuse) do
			if weapon == GetHashKey(k) then
				SetPedCurrentWeaponVisible(GetPlayerPed(-1), 0, 0, 1, 1)
				if not currentuse[k]["MODEL"] then
					weaponobject = CreateObject(GetHashKey(currentuse[k]["SKIN"]), x, y, z,  true,  false, true)
					print("Creating object: ", currentuse[k]["SKIN"])
					currentuse[k]["MODEL"] = weaponobject
					SetEntityAsMissionEntity(weaponobject, true, false)
					local weapposition = Config["WEAPONPOSITION"][currentuse[k]["POSITION"]]
					AttachEntityToEntity(weaponobject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), weapposition.Pos.x, weapposition.Pos.y, weapposition.Pos.z, weapposition.Rot.x, weapposition.Rot.y,weapposition.Rot.z, true, true, false, true, 0, true)
				end
			else
				if currentuse[k]["MODEL"] then
					DeleteObject(currentuse[k]["MODEL"])
					currentuse[k]["MODEL"] = nil
				end
			end
		end
		Wait(500)
	end
end)


exports('GetCurrentWeaponSkin', function(weapon)
    return currentuse[weapon] and currentuse[weapon]["SKIN"] or nil
end)
