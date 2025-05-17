local property = nil

RegisterNetEvent(Base.PrefixEvent .. ':openHouseInventory')
AddEventHandler(Base.PrefixEvent .. ':openHouseInventory',function(id, cash, blackMoney, inventory, weapons)
    setHouseInventoryData(id, cash, blackMoney, inventory, weapons)
    openHouseInventory()
end)

RegisterNetEvent(Base.PrefixEvent .. ':refreshHouseInventory')
AddEventHandler(Base.PrefixEvent .. ':refreshHouseInventory', function(id, cash, blackMoney, inventory, weapons)
    setHouseInventoryData(id, cash, blackMoney, inventory, weapons)
    Wait(150)
    openHouseInventory()
end)

function setHouseInventoryData(id, cash, blackMoney, inventory, weapons)
    houseData = id

    SendNUIMessage(
        {
            action = 'setInfoText',
            text = 'Property Inventory'
        }
    )
    items = {}

    if blackMoney > 0 then
        accountData = {
            label = _U('black_money'),
            count = blackMoney,
            type = 'item_account',
            name = 'black_money',
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    if cash > 0 then
        moneyData = {
            label = 'Cash',
            name = 'cash',
            type = 'item_money',
            count = cash,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = true
        }

        table.insert(items, moneyData)
    end

    if Config.IncludeWeapons and weapons ~= nil then
        for key, value in pairs(weapons) do
            local weaponHash = GetHashKey(weapons[key].name)
            if weapons[key].name ~= 'WEAPON_UNARMED' then
                table.insert(
                    items,
                    {
                        label = weapons[key].label,
                        count = weapons[key].count,
                        limit = -1,
                        type = 'item_weapon',
                        name = weapons[key].name,
                        usable = false,
                        rare = false,
                        canRemove = false
                    }
                )
            end
        end
    end

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            if inventory[key].count <= 0 then
                inventory[key] = nil
            else
                if inventory[key].name ~= 'black_money' then
                    inventory[key].type = 'item_standard'
                    inventory[key].usable = false
                    inventory[key].rare = false
                    inventory[key].limit = -1
                    inventory[key].canRemove = false
                    table.insert(items, inventory[key])
                end
            end
        end
    end

    SendNUIMessage(
        {
            action = 'setSecondInventoryItems',
            itemList = items
        }
    )
end

function openHouseInventory()
    loadPlayerInventory()
	LoadInventoryState = false
    isInInventory = true
    SendNUIMessage(
        {
            action = 'display',
            type = 'house'
        }
    )
    SetNuiFocus(true, true)
	TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen',0.1)
end

local PutIntoHouse = false
RegisterNUICallback('PutIntoHouse',function(data, cb)
    if not PutIntoHouse then
        PutIntoHouse = true
        if Config.disablePutIntoHouse and Config.disablePutIntoHouse[data.item.name] then
            exports.PorNotify:SendNotification(
                {
                    text = 'ไม่สามารถใส่ของชิ้นนี้ได้!!',
                    type = 'error',
                    timeout = 3000,
                    layout = 'bottomRight',
                    queue = 'inventoryhud'
                }
            )
            closeInventory()
        elseif type(data.number) == 'number' and math.floor(data.number) == data.number then
            local count = tonumber(data.number)
            if data.item.type == 'item_weapon' then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end
            TriggerServerEvent('meeta_house:putItem', houseData, data.item.type, data.item.name, count, data.item.label)
        end
        Wait(500)
        loadPlayerInventory()
        local player = GetPlayerPed(-1)
        local dict = 'mp_am_hold_up'
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
        TaskPlayAnim(player, dict, 'purchase_beerbox_shopkeeper', 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        cb('ok')
        PutIntoHouse =false
    else
        closeInventory()
    end
end)

local TakeFromHouse = false
RegisterNUICallback('TakeFromHouse', function(data, cb) --ถอนของในบ้าน
	if not TakeFromHouse then
        TakeFromHouse = true
        local rdm = math.random(1,1000) --ดึงของพร้อมกัน
        Wait(rdm)
        if type(data.number) == 'number' and math.floor(data.number) == data.number then
            TriggerServerEvent('meeta_house:getItem', data.item.id, houseData, data.item.type, data.item.name, tonumber(data.number), data.item.label)
        end
        Wait(500)
        loadPlayerInventory()
        local player = GetPlayerPed(-1)
        local dict = 'mp_am_hold_up'
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
        TaskPlayAnim(player, dict, 'purchase_beerbox_shopkeeper', 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
        cb('ok')
		TakeFromHouse = false
    else
       closeInventory()
	end
end)
