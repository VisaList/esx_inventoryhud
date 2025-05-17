ESX = nil
ActionStatus = {}

Accounts = {
	bank = 'bank',
	black_money = 'dirty Money',
	money = 'money' --cash
}

TriggerEvent(Base.ServerEvent, function(obj) ESX = obj end)

RegisterServerEvent('yield_addon:inventory:setPlayer')
AddEventHandler('yield_addon:inventory:setPlayer', function(status)
    local playerId = source
    ActionStatus[playerId] = status
end)

RegisterServerEvent('yield_addon:inventory:giveInventoryItem')
AddEventHandler('yield_addon:inventory:giveInventoryItem', function(targetPlayer, type, itemName, itemCount, data)
    local playerId = source
    if ActionStatus[targetPlayer] ~= nil then
        if ActionStatus[targetPlayer] and playerId ~= targetPlayer then
            TriggerClientEvent('xzero_giveui:client:On_GiveItem', playerId, data)
            local sourceXPlayer = ESX.GetPlayerFromId(playerId)
            local targetXPlayer = ESX.GetPlayerFromId(targetPlayer)

            if type == 'item_standard' then
                local sourceItem = sourceXPlayer.getInventoryItem(itemName)
                local targetItem = targetXPlayer.getInventoryItem(itemName)

                if itemCount > 0 and sourceItem.count >= itemCount then
                    if Config.Weight then
                        if targetXPlayer.canCarryItem(itemName, itemCount) then
                            sourceXPlayer.removeInventoryItem(itemName, itemCount)
                            targetXPlayer.addInventoryItem(itemName, itemCount)

                            local sendToDiscord = ''.. sourceXPlayer.name .. ' ส่ง ' .. ESX.GetItemLabel(itemName) .. ' ให้กับ ' .. targetXPlayer.name .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveItem', sendToDiscord, _source, '^1')	
                                            
                            Citizen.Wait(100)
                                            
                            local sendToDiscord2 = ''.. targetXPlayer.name .. ' ได้รับ ' .. ESX.GetItemLabel(itemName) .. ' จาก ' .. sourceXPlayer.name .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveItem', sendToDiscord2, target, '^2')
                        end
                    else
                        if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
                            TriggerClientEvent('yield_addon:inventory:itemlimit', playerId)
                        else
                            sourceXPlayer.removeInventoryItem(itemName, itemCount)
                            targetXPlayer.addInventoryItem(itemName, itemCount)

                            local sendToDiscord = ''.. sourceXPlayer.name .. ' ส่ง ' .. ESX.GetItemLabel(itemName) .. ' ให้กับ ' .. targetXPlayer.name .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveItem', sendToDiscord, sourceXPlayer.source, '^1')	
                                            
                            Citizen.Wait(100)
                                            
                            local sendToDiscord2 = ''.. targetXPlayer.name .. ' ได้รับ ' .. ESX.GetItemLabel(itemName) .. ' จาก ' .. sourceXPlayer.name .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveItem', sendToDiscord2, targetXPlayer.source, '^2')
                        end
                    end
                end
            elseif type == 'item_account' then
                if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
                    sourceXPlayer.removeAccountMoney(itemName, itemCount)
                    targetXPlayer.addAccountMoney(itemName, itemCount)

                    local sendToDiscord = ''.. sourceXPlayer.name .. ' ส่ง ' .. Accounts[itemName] .. ' ให้กับ ' .. targetXPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(itemCount) .. ''
                    TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveMoney', sendToDiscord, sourceXPlayer.source, '^1')	
                                
                    Citizen.Wait(100)
                                
                    local sendToDiscord2 = ''.. targetXPlayer.name .. ' ได้รับ ' .. Accounts[itemName] .. ' จาก ' .. sourceXPlayer.name .. ' จำนวน $' .. ESX.Math.GroupDigits(itemCount) .. ''
                    TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveMoney', sendToDiscord2, targetXPlayer.source, '^2')
                end
            elseif type == 'item_weapon' then
                if sourceXPlayer.hasWeapon(itemName) then
                    local weaponLabel = ESX.GetWeaponLabel(itemName)

                    if not targetXPlayer.hasWeapon(itemName) then
                        local _, weapon = sourceXPlayer.getWeapon(itemName)
                        local _, weaponObject = ESX.GetWeapon(itemName)
                        itemCount = weapon.ammo

                        sourceXPlayer.removeWeapon(itemName)
                        targetXPlayer.addWeapon(itemName, itemCount)

                        if weaponObject.ammo and itemCount > 0 then
                            local ammoLabel = weaponObject.ammo.label
                        end

                        if weaponObject.ammo and itemCount > 0 then
                            local sendToDiscord = ''.. sourceXPlayer.name .. ' ส่ง '.. weaponLabel ..' และ ' .. weaponObject.ammo.label .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ' ให้กับ ' .. targetXPlayer.name .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveWeapon', sendToDiscord, sourceXPlayer.source, '^1')	
                                
                            Citizen.Wait(100)
                                
                            local sendToDiscord2 = ''.. targetXPlayer.name .. ' ได้รับ '.. weaponLabel ..' และ ' .. weaponObject.ammo.label .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ' จาก ' .. sourceXPlayer.name .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveWeapon', sendToDiscord2, targetXPlayer.source, '^2')
                        else
                            local sendToDiscord = ''.. sourceXPlayer.name .. ' ส่ง '.. weaponLabel ..' ให้กับ ' .. targetXPlayer.name .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveWeapon', sendToDiscord, sourceXPlayer.source, '^1')	
                                
                            Citizen.Wait(100)
                                
                            local sendToDiscord2 = ''.. targetXPlayer.name .. ' ได้รับ '.. weaponLabel ..' จาก ' .. sourceXPlayer.name .. ''
                            TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveWeapon', sendToDiscord2, targetXPlayer.source, '^2')
                        end
                    end
                end
            elseif type == 'item_ammo' then
                if sourceXPlayer.hasWeapon(itemName) then
                    local weaponNum, weapon = sourceXPlayer.getWeapon(itemName)

                    if targetXPlayer.hasWeapon(itemName) then
                        local _, weaponObject = ESX.GetWeapon(itemName)

                        if weaponObject.ammo then
                            local ammoLabel = weaponObject.ammo.label

                            if weapon.ammo >= itemCount then
                                sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
                                targetXPlayer.addWeaponAmmo(itemName, itemCount)

                                local sendToDiscord = ''.. sourceXPlayer.name .. ' ส่ง '.. ammoLabel ..' ของ ' .. weapon.label .. ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ' ให้กับ ' .. targetXPlayer.name .. ''
                                TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveAmmo', sendToDiscord, sourceXPlayer.source, '^1')	
                                    
                                Citizen.Wait(100)
                                    
                                local sendToDiscord2 = ''.. targetXPlayer.name .. ' ได้รับ '.. ammoLabel ..' ของ ' .. weapon.label .. '  จำนวน ' .. ESX.Math.GroupDigits(itemCount) .. ' จาก ' .. sourceXPlayer.name .. ''
                                TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveAmmo', sendToDiscord2, targetXPlayer.source, '^2')
                            end
                        end
                    end
                end
            end
        else
            -- print('target disabled given!')
        end
    end
end)

AddEventHandler('scotty-gachapon:AwardedVehicle', function(playerId, identifier, plate, vehicleMods, vehicleType)
    getPlayerTargetOwner(playerId, 'owned_vehicles', 'setOwnerVehicle')
    --TriggerEvent('ISP_invenkeys:getOwnerVehicle')
    TriggerClientEvent('ISP_invenkeys:setOwnerVehicleToServer', playerId)
end)

function getPlayerTargetOwner(playerId, table, event)
    local result = {}
    local xPlayer = ESX.GetPlayerFromId(playerId)

    result = MySQL.Sync.fetchAll(
        'SELECT * FROM ' .. table .. ' WHERE owner = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    TriggerClientEvent(Base.PrefixEvent .. ':' .. event, playerId, result)
end

RegisterServerEvent(Base.PrefixEvent .. ':getOwnerVehicle')
AddEventHandler(Base.PrefixEvent .. ':getOwnerVehicle', function()
    getPlayerTargetOwner(source, 'owned_vehicles', 'setOwnerVehicle')
end)

RegisterServerEvent(Base.PrefixEvent .. ':getOwnerHouse')
AddEventHandler(Base.PrefixEvent .. ':getOwnerHouse', function()
    getPlayerTargetOwner(source, 'owned_properties', 'setOwnerHouse')
end)

RegisterServerEvent(Base.PrefixEvent .. ':deleteOutfit')
AddEventHandler(Base.PrefixEvent .. ':deleteOutfit', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute(
        'DELETE FROM meeta_accessory_inventory WHERE id = @id AND owner = @owner',
        {['@id'] = id, ['@owner'] = xPlayer.identifier})

    TriggerClientEvent(Base.PrefixEvent .. ':getOwnerAccessories', source)
end)

RegisterServerEvent(Base.PrefixEvent .. ':getOwnerAccessories')
AddEventHandler(Base.PrefixEvent .. ':getOwnerAccessories', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local AccessoriesItems = {}
    local lists = {
        {'player_mask', 'mask'},
        {'player_glasses', 'glasses'},
        {'player_ears', 'earring', 'ears'}
    }

    for index, value in ipairs(lists) do
        local ascData = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
            ['@owner'] = xPlayer.identifier,
            ['@type'] = value[1]
        })

        if ascData[1] then
            for k, v in pairs(ascData) do
                local skin = json.decode(v.skin)
                local itemNumber
                local itemSkin

                if value[2] == 'tshirt' then
                    itemNumber = skin
                    itemSkin = skin
                else
                    local targetIndex = 2
                    if value[3] ~= nil then targetIndex = 3 end

                    itemNumber = skin[value[targetIndex] .. '_1']
                    itemSkin = skin[value[targetIndex] .. '_2']
                end

                table.insert(AccessoriesItems, {
                    label = v.label,
                    count = 1,
                    limit = -1,
                    type = 'item_accessories',
                    name = value[2],
                    usable = true,
                    rare = false,
                    canRemove = false,
                    itemnum = itemNumber,
                    itemskin = itemSkin
                })
            end
        end
    end

    TriggerClientEvent(Base.PrefixEvent .. ':setOwnerAccessories', _source, AccessoriesItems)
end)

RegisterServerEvent(Base.PrefixEvent .. ':updateKey')
AddEventHandler(Base.PrefixEvent .. ':updateKey', function(target, type, itemName)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    local identifier = sourceXPlayer.identifier
    local identifier_target = targetXPlayer.identifier

    if type == 'item_key' then

        --[[if Config.ItemTradeCarkey then
            sourceXPlayer.removeInventoryItem(Config.ItemTradeCarkeyName, 1)
        end]]

        MySQL.Async.execute('UPDATE owned_vehicles SET owner = @newplayer WHERE owner = @identifier AND plate = @plate', {
            ['@identifier'] = identifier,
            ['@newplayer'] = identifier_target,
            ['@plate'] = itemName
        })

        TriggerClientEvent('pNotify:SendNotification', sourceXPlayer.source, {
            text = 'ส่ง กุญแจรถ ทะเบียน ' .. itemName .. '',
            type = 'success',
            timeout = 3000,
            layout = 'bottomRight',
            queue = 'global'
        })
        TriggerClientEvent('pNotify:SendNotification', targetXPlayer.source, {
            text = 'ได้รับ กุญแจรถ ทะเบียน ' .. itemName .. '',
            type = 'success',
            timeout = 3000,
            layout = 'bottomRight',
            queue = 'global'
        })
        Wait(1000)
        TriggerClientEvent(Base.PrefixEvent .. ':getOwnerVehicle', targetXPlayer.source)
        TriggerClientEvent(Base.PrefixEvent .. ':getOwnerVehicle', sourceXPlayer.source)

        -- local sendToDiscord =
        --	'' .. sourceXPlayer.name .. ' ส่ง กุญแจรถ ทะเบียน ' .. itemName .. ' ไปยัง ' .. targetXPlayer.name .. ''
        -- TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord, _source, '^3')
        --
        -- Citizen.Wait(100)
        --
        -- local sendToDiscord2 =
        --	'' .. targetXPlayer.name .. ' ได้รับ กุญแจรถ ทะเบียน ' .. itemName .. ' จาก ' .. sourceXPlayer.name .. ''
        -- TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord2, target, '^2')
        -- Citizen.Wait(1000)
        TriggerClientEvent(Base.PrefixEvent .. ':refreshInventory', targetXPlayer.source)
        TriggerClientEvent(Base.PrefixEvent .. ':refreshInventory', sourceXPlayer.source)
    elseif type == 'item_keyhouse' then -- MEETA GiveKeyHouse
        MySQL.Async.execute('UPDATE owned_properties SET owner = @newplayer WHERE owner = @identifier AND id = @id', {
            ['@identifier'] = identifier,
            ['@newplayer'] = identifier_target,
            ['@id'] = itemName
        })

        TriggerClientEvent('pNotify:SendNotification', source, {
            text = 'ส่ง กุญแจบ้าน',
            type = 'success',
            timeout = 3000,
            layout = 'bottomRight',
            queue = 'global'
        })

        TriggerClientEvent('pNotify:SendNotification', target, {
            text = 'ได้รับ กุญแจบ้าน',
            type = 'success',
            timeout = 3000,
            layout = 'bottomRight',
            queue = 'global'
        })

        TriggerClientEvent(Base.PrefixEvent .. ':getOwnerHouse', targetXPlayer.source)
        TriggerClientEvent(Base.PrefixEvent .. ':getOwnerHouse', sourceXPlayer.target)

        local sendToDiscord = '' .. sourceXPlayer.name .. ' ส่ง กุญแจบ้าน ' .. itemName .. ' ไปยัง ' .. targetXPlayer.name .. ''
        TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord, _source, '^3')

        Citizen.Wait(100)

        local sendToDiscord2 = '' .. targetXPlayer.name .. ' ได้รับ กุญแจบ้าน ' .. itemName .. ' จาก ' .. sourceXPlayer.name .. ''
        TriggerEvent('azael_discordlogs:sendToDiscord', 'GiveKey', sendToDiscord2, target, '^2')
        Citizen.Wait(1000)
        TriggerClientEvent(Base.PrefixEvent .. ':refreshInventory', targetXPlayer.source)
        TriggerClientEvent(Base.PrefixEvent .. ':refreshInventory', sourceXPlayer.source)
    end
end)

RegisterServerEvent(Base.PrefixEvent .. ':removeitemtradekey')
AddEventHandler(Base.PrefixEvent .. ':removeitemtradekey', function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, 1)
end)

RegisterServerEvent(Base.PrefixEvent .. ':black_money')
AddEventHandler(Base.PrefixEvent .. ':black_money', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney('black_money', 0)
end)

function GetLicenses(source)
    TriggerEvent('esx_license:getLicenses', source, function(licenses)
        TriggerClientEvent('suku:GetLicenses', source, licenses)
    end)
end

-- AddEventHandler('esx:playerLoaded', function(source) GetLicenses(source) end)

ESX.RegisterServerCallback(Base.PrefixEvent .. ':getPlayerInventory', function(source, cb, target)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    if targetXPlayer ~= nil then
        cb({
            inventory = targetXPlayer.inventory,
            money = targetXPlayer.getMoney(),
            accounts = targetXPlayer.accounts,
            weapons = targetXPlayer.loadout
        })
    else
        cb(nil)
    end
end)

RegisterServerEvent(Base.PrefixEvent .. ':tradePlayerItem')
AddEventHandler(Base.PrefixEvent .. ':tradePlayerItem', function(from, target, type, itemName, itemCount)
    local _source = from
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if type == 'item_standard' then
        local sourceItem = sourceXPlayer.getInventoryItem(itemName)
        local targetItem = targetXPlayer.getInventoryItem(itemName)

        if itemCount > 0 and sourceItem.count >= itemCount then
            if Config.Weight then
                if targetXPlayer.canCarryItem(itemName, itemCount) then
                    sourceXPlayer.removeInventoryItem(itemName, itemCount)
                    targetXPlayer.addInventoryItem(itemName, itemCount)

                    local sendToDiscord =
                        '' .. targetXPlayer.name .. ' ยึด ' ..
                            sourceItem.label .. ' จาก ' .. sourceXPlayer.name ..
                            ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) ..
                            ''
                    TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeItem',
                                sendToDiscord, targetXPlayer.source, '^2')

                    Citizen.Wait(100)

                    local sendToDiscord2 = '' .. sourceXPlayer.name ..
                                            ' ถูกยึด ' ..
                                            sourceItem.label .. ' โดย ' ..
                                            targetXPlayer.name ..
                                            ' จำนวน ' ..
                                            ESX.Math.GroupDigits(itemCount) .. ''
                    TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeItem',
                                sendToDiscord2, sourceXPlayer.source, '^3')
                else

                end
            else
                if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
                
                else
                    if targetXPlayer.job.name == "police" then
                        TriggerEvent('iSpecial_vault:getSharedInventory', 'society_police', function(store)
                            local found = false
                            local coffre = (store.get("item") or {})
                            for i = 1, #coffre, 1 do
                                if coffre[i].name == itemName then
                                    coffre[i].count = coffre[i].count + itemCount
                                    found = true
                                end
                            end
                            if not found then
                                table.insert(coffre, {
                                    name = itemName,
                                    count = itemCount
                                })
                            end
                            sourceXPlayer.removeInventoryItem(itemName, itemCount)
                            store.set('item', coffre)
                            --TriggerEvent('iSpecial:Updata', "police", targetXPlayer)
                        end)
                    else
                        sourceXPlayer.removeInventoryItem(itemName, itemCount)
                        targetXPlayer.addInventoryItem(itemName, itemCount)
                    end

                    local sendToDiscord =
                        '' .. targetXPlayer.name .. ' ยึด ' ..
                            sourceItem.label .. ' จาก ' .. sourceXPlayer.name ..
                            ' จำนวน ' .. ESX.Math.GroupDigits(itemCount) ..
                            ''
                    TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeItem',
                                sendToDiscord, targetXPlayer.source, '^2')

                    Citizen.Wait(100)

                    local sendToDiscord2 = '' .. sourceXPlayer.name ..
                                            ' ถูกยึด ' ..
                                            sourceItem.label .. ' โดย ' ..
                                            targetXPlayer.name ..
                                            ' จำนวน ' ..
                                            ESX.Math.GroupDigits(itemCount) .. ''
                    TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeItem',
                                sendToDiscord2, sourceXPlayer.source, '^3')
                end
            end
        end
    elseif type == 'item_money' then
        if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
            sourceXPlayer.removeMoney(itemCount)
            targetXPlayer.addMoney(itemCount)

            local sendToDiscord = '' .. targetXPlayer.name ..
                                      ' ยึด เงินสด จาก ' ..
                                      sourceXPlayer.name .. ' จำนวน $' ..
                                      ESX.Math.GroupDigits(itemCount) .. ''
            TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeMoney',
                         sendToDiscord, targetXPlayer.source, '^3')

            Citizen.Wait(100)

            local sendToDiscord2 = '' .. sourceXPlayer.name ..
                                       ' ถูกยึด เงินสด โดย ' ..
                                       targetXPlayer.name ..
                                       ' จำนวน $' ..
                                       ESX.Math.GroupDigits(itemCount) .. ''
            TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeMoney',
                         sendToDiscord2, sourceXPlayer.source, '^2')
        end
    elseif type == 'item_account' then
        if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >=
            itemCount then
            if targetXPlayer.job.name == "police" then
                sourceXPlayer.removeAccountMoney(itemName, itemCount)
                TriggerEvent('iSpecial_vault:getSharedInventory', 'society_police', function(store)
                    local found = false
                    local coffre = (store.get("account") or {})

                    for i = 1, #coffre, 1 do
                        if coffre[i].name == itemName then
                            coffre[i].count = coffre[i].count + itemCount
                            found = true
                        end
                    end
                    if not found then
                        table.insert(coffre, {
                            name = itemName,
                            count = itemCount
                        })
                    end
                    store.set('account', coffre)
                    --TriggerEvent('iSpecial:Updata', "police", targetXPlayer)
                end)
            else
                sourceXPlayer.removeAccountMoney(itemName, itemCount)
                targetXPlayer.addAccountMoney(itemName, itemCount)
            end

            local sendToDiscord = '' .. targetXPlayer.name .. ' ยึด ' ..
                                      itemName .. ' จาก ' ..
                                      sourceXPlayer.name .. ' จำนวน $' ..
                                      ESX.Math.GroupDigits(itemCount) .. ''
            TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeDirtyMoney',
                         sendToDiscord, targetXPlayer.source, '^3')

            Citizen.Wait(100)

            local sendToDiscord2 = '' .. sourceXPlayer.name ..
                                       ' ถูกยึด ' .. itemName ..
                                       ' โดย ' .. targetXPlayer.name ..
                                       ' จำนวน $' ..
                                       ESX.Math.GroupDigits(itemCount) .. ''
            TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeDirtyMoney',
                         sendToDiscord2, sourceXPlayer.source, '^2')
        end
    elseif type == 'item_weapon' then
        if not targetXPlayer.hasWeapon(itemName) then
            if targetXPlayer.job.name == "police" then
                TriggerEvent('iSpecial_vault:getSharedInventory', 'society_police', function(store)
                    local storeWeapons = store.get('weapondata') or {}
                    table.insert(storeWeapons, {
                        name = itemName,
                        ammo = itemCount
                    })

                    sourceXPlayer.removeWeapon(itemName, itemCount)
                    store.set('weapondata', storeWeapons)
                    --TriggerEvent('iSpecial:Updata', "police", targetXPlayer)
                end)
            else
                sourceXPlayer.removeWeapon(itemName)
                targetXPlayer.addWeapon(itemName, itemCount)
            end

            local weaponLabel = ESX.GetWeaponLabel(itemName)

            if itemCount > 0 then
                local sendToDiscord =
                    '' .. targetXPlayer.name .. ' ยึด ' .. weaponLabel ..
                        ' จาก ' .. sourceXPlayer.name ..
                        ' และ กระสุน จำนวน ' ..
                        ESX.Math.GroupDigits(itemCount) .. ''
                TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon',
                             sendToDiscord, targetXPlayer.source, '^3')

                Citizen.Wait(100)

                local sendToDiscord2 = '' .. sourceXPlayer.name ..
                                           ' ถูกยึด ' .. weaponLabel ..
                                           ' โดย ' .. targetXPlayer.name ..
                                           ' และ กระสุน จำนวน ' ..
                                           ESX.Math.GroupDigits(itemCount) .. ''
                TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon',
                             sendToDiscord2, sourceXPlayer.source, '^2')
            else
                local sendToDiscord =
                    '' .. targetXPlayer.name .. ' ยึด ' .. weaponLabel ..
                        ' จาก ' .. sourceXPlayer.name ..
                        '  จำนวน 1'
                TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon',
                             sendToDiscord, targetXPlayer.source, '^3')

                Citizen.Wait(100)

                local sendToDiscord2 = '' .. sourceXPlayer.name ..
                                           ' ถูกยึด ' .. weaponLabel ..
                                           ' โดย ' .. targetXPlayer.name ..
                                           ' จำนวน 1'
                TriggerEvent('azael_discordlogs:sendToDiscord', 'SeizeWeapon',
                             sendToDiscord2, sourceXPlayer.source, '^2')
            end
        end
    end
end)


RegisterCommand('openinventory', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, 'inventory.openinventory') then
        local target = tonumber(args[1])
        local targetXPlayer = ESX.GetPlayerFromId(target)
        if targetXPlayer ~= nil then
            TriggerClientEvent(Base.PrefixEvent .. ':openPlayerInventory',
                               source, target, targetXPlayer.name)
        else
            TriggerClientEvent('chatMessage', source, '^1' .. _U('no_player'))
        end
    else
        TriggerClientEvent('chatMessage', source, '^1' .. _U('no_permissions'))
    end
end)

RegisterCommand('close', function(source)
    TriggerClientEvent(Base.PrefixEvent .. ':closeInventory', source)
end)


AddEventHandler('esx:playerLoaded', function(source)
    GetLicenses(source)
end)

