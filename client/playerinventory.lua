local Accessory_Items   = {}
local Vehicle_Key       = {}
local House_Key         = {}
local isHotbar          = false;
local fastItemsHotbar   = {};
local dataccount = {}
local fastWeapons       = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = nil,
	[5] = nil,
    [6] = nil,
    [7] = nil
}

function openInventory()
    if Config.BlurBackdrop then
        TriggerScreenblurFadeIn(1200)
    end
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage(
        {
            action = 'display',
            type = 'normal'
        }
    )

    Citizen.Wait(200)
    SetNuiFocus(true, true)
end

function GetCategory(itemName)
    if Config.AddonCategory.Items[itemName] ~= nil then
        return Config.AddonCategory.Items[itemName]
    else
        return Config.AddonCategory.DefaultCategory
    end
end

function loadPlayerInventory()
    updateFastItemsHotbar()
    local toSendInit = {
        action = 'setup-extended',
        useWeight = Config.Weight,
        category = Config.AddonCategory.Categories,
        categoryDisplay = Config.AddonCategory.Display,
        categoryDefault = Config.AddonCategory.DefaultCategory,
        playerId = GetPlayerServerId(PlayerId())
    }

    if Config.Weight then
        local esxConfig = ESX.GetConfig()
        toSendInit.maxWeight = esxConfig.MaxWeight
    end

    SendNUIMessage(toSendInit)

    ESX.PlayerData = ESX.GetPlayerData()
    local PlayerId = GetPlayerServerId(PlayerId())
    local playerData = ESX.GetPlayerData()
    local playerPed = PlayerPedId()
    local inventory = playerData.inventory -- data.inventory
    local accounts = playerData.accounts -- data.accounts
    items = {}
    currentInventoryItems = items

    fastItems = {}
    if Config.Items then
        itemData = {
            label ='บัตรประชาชน',
            name = 'id_card',
            type = 'item_account',
            count = 1,
            limit = 1,
            usable = true,
            skinble = false,
            rare = false,
            canRemove = false,
            category = GetCategory('id_card')
        }
        
        table.insert(items, itemData)
    end

    if Config.IncludeAccounts and accounts ~= nil then
        for key, value in pairs(accounts) do
            if not shouldSkipAccount(accounts[key].name) then
                local canDrop = accounts[key].name ~= 'bank'

                if accounts[key].name == 'money' then
                    cash_ = accounts[key].money
                end

                if accounts[key].money > 0 then
                    accountData = {
                        label = accounts[key].label,
                        count = accounts[key].money,
                        type = 'item_account',
                        name = accounts[key].name,
                        usable = false,
                        skinble = false,
                        rare = false,
                        limit = -1,
                        canRemove = canDrop,
                        category = GetCategory(accounts[key].name)
                    }
                    table.insert(items, accountData)
                end
            end
        end
    end
			
    --
    -- Player Default Inventory
    --
    for i=1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].count > 0 then
            local founditem = false
            for slot, item in pairs(fastWeapons) do
                if item.name == ESX.PlayerData.inventory[i].name then
                    table.insert(fastItems, {
                        label     = ESX.PlayerData.inventory[i].label,
                        count     = ESX.PlayerData.inventory[i].count,
                        limit     = ESX.PlayerData.inventory[i].limit,
                        type      = 'item_standard',
                        name      = ESX.PlayerData.inventory[i].name,
                        usable    = ESX.PlayerData.inventory[i].usable,
                        rare      = ESX.PlayerData.inventory[i].rare,
                        canRemove = ESX.PlayerData.inventory[i].canRemove,
                        slot = slot
                    })

                    if Config.HideFastItemOnInventory then
                        founditem = true
                    end
                    break
                end
            end
            
            if founditem == false then
                local itemData = {
                    label     = ESX.PlayerData.inventory[i].label,
                    count     = ESX.PlayerData.inventory[i].count,
                    type      = 'item_standard',
                    name      = ESX.PlayerData.inventory[i].name,
                    usable    = ESX.PlayerData.inventory[i].usable,
                    rare      = ESX.PlayerData.inventory[i].rare,
                    canRemove = ESX.PlayerData.inventory[i].canRemove,
                    category = GetCategory(ESX.PlayerData.inventory[i].name)
                }

                if Config.Weight then
                    itemData.weight = ESX.PlayerData.inventory[i].weight
                    if itemData.weight == nil then
                        if Config.AddonWeight.Lists[itemData.name] then
                            itemData.weight = Config.AddonWeight.Lists[itemData.name]
                        else
                            itemData.weight = Config.AddonWeight.DefaultStandardItem
                        end
                    end
                else
                    itemData.limit = ESX.PlayerData.inventory[i].limit
                end

                table.insert(items, itemData)
            end
        end
    end

    --
    -- Player Weapons
    --
    if Config.IncludeWeapons then
        for i=1, #Config.Weapons, 1 do
            local weaponHash = GetHashKey(Config.Weapons[i].name)
            local playerPed = PlayerPedId()

            if HasPedGotWeapon(playerPed, weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
                local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                local founditem = false
                for slot, item in pairs(fastWeapons) do
                    if item.name == Config.Weapons[i].name then
                        local weaponData = {
                            label = Config.Weapons[i].label,
                            count = ammo,
                            limit = -1,
                            type = 'item_weapon',
                            name = Config.Weapons[i].name,
                            usable = true,
                            skinble = true,
                            rare  = false,
                            canRemove = false,
                            slot = slot
                        }

                        if Config.Weight then
                            weaponData.weight = Config.AddonWeight.DefaultWeapon
                        end

                        table.insert(fastItems, weaponData)
                        
                        if Config.HideFastItemOnInventory then
                            founditem = true
                        end

                        break
                    end
                end
                
                if founditem == false then
                    table.insert(items, {
                        label = Config.Weapons[i].label,
                        count = ammo,
                        limit = -1,
                        type = 'item_weapon',
                        name = Config.Weapons[i].name,
                        usable = true,
                        skinble = true,
                        rare = false,
                        canRemove = false,
                        category = 'type-weapon' --GetCategory(Config.Weapons[i].name)
                    })
                end
            end
        end
    end

    --
    -- Player Accessories
    --
    for i=1, #Accessory_Items, 1 do
        local founditem = false
        for slot, item in pairs(fastWeapons) do
            if item.label == Accessory_Items[i].label then
                table.insert(fastItems, {
                    label = Accessory_Items[i].label,
                    count = 1,
                    limit = -1,
                    type = 'item_accessories',
                    name = Accessory_Items[i].name,
                    usable = true,
                    skinble = false,
                    rare = false,
                    canRemove = false,
                    itemnum = Accessory_Items[i].itemnum,
                    itemskin = Accessory_Items[i].itemskin,
                    slot = slot
                })

                founditem = true
                break
            end
        end
        
        if founditem == false then
            table.insert(items, {
                label = Accessory_Items[i].label,
                count = 1,
                limit = -1,
                type = 'item_accessories',
                name = Accessory_Items[i].name,
                usable = true,
                skinble = false,
                rare = true,
                canRemove = false,
                itemnum = Accessory_Items[i].itemnum,
                itemskin = Accessory_Items[i].itemskin,
                category = 'type-cloth' --GetCategory(Accessory_Items[i].name)
            })
        end
    end

    --
    -- Player Vehicle Key
    --
    if Config.EnableVehicleKey == true then
        for i=1, #Vehicle_Key, 1 do
            local founditem = false
            for slot, item in pairs(fastWeapons) do
                if item.label == Vehicle_Key[i].plate then
                    table.insert(fastItems, {
                        label = Vehicle_Key[i].plate,
                        count = 1,
                        limit = -1,
                        type = 'item_key',
                        name = 'car_keys',
                        usable = true,
                        skinble = false,
                        rare = false,
                        canRemove = false,
                        slot = slot
                    })

                    if Config.HideFastItemOnInventory then
                        founditem = true
                    end

                    break
                end
            end
            
            if founditem == false then
                table.insert(items, {
                    label = Vehicle_Key[i].plate,
                    count = 1,
                    limit = -1,
                    type = 'item_key',
                    name = 'car_keys',
                    usable = true,
                    skinble = false,
                    rare = false,
                    canRemove = false,
                    category = GetCategory('car_keys')
                })
            end
        end
    end

    if carkeys then
        for plate, _ in pairs(carkeys) do
            local info = {
                label = plate and (plate .. ' Key') or 'UNKNOWN KEY',
                name = 'car_keys',
                type = 'car_key_'..plate,
                count = 1,
                usable = true,
                skinble = false,
                rare = false,
                limit = -1,
                canRemove = false,
                category = GetCategory('car_keys')
            }

            table.insert(items, info)
        end
    end

    --
    -- Player House Key
    --
    if Config.EnableHouseKey == true then
        for i=1, #House_Key, 1 do
            table.insert(items, {
                label = House_Key[i].name,
                count = 1,
                limit = -1,
                type = 'item_keyhouse',
                name = 'keyhouse',
                usable = false,
                skinble = false,
                rare = false,
                canRemove = false,
                house_id = House_Key[i].id,
                category = GetCategory('keyhouse')
            })
        end
    end
    
    fastItemsHotbar = fastItems

    SendNUIMessage({
        action = 'setItems',
        itemList = items,
        text = texts,
        fastItems = fastItems,
    })
end

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	RemoveWeaponFromPed(playerPed, weaponHash)
	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)


RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    for k,v in ipairs(ESX.PlayerData.accounts) do
        if 'black_money' == account.name then
            ESX.PlayerData.accounts[k] = account
            break
        end
    end

    if isInInventory then
		loadPlayerInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)

	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			ESX.PlayerData.inventory[k] = item
			break
		end
    end
	if isInInventory then
		loadPlayerInventory()
	end
end)
RegisterNetEvent(Base.PrefixEvent .. ':refreshInventory')
AddEventHandler(Base.PrefixEvent .. ':refreshInventory', function()
	print('refresh')
	loadPlayerInventory()
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)

	for k,v in ipairs(ESX.PlayerData.inventory) do
        if v.name == item.name then
            ESX.PlayerData.inventory[k] = item
			break
		end
	end

	if isInInventory then
		loadPlayerInventory()
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
    ESX.PlayerData.money = money
    if isInInventory then
		loadPlayerInventory()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent(Base.PrefixEvent .. ':getOwnerVehicle')
    TriggerServerEvent(Base.PrefixEvent .. ':getOwnerHouse')
    TriggerServerEvent(Base.PrefixEvent .. ':getOwnerAccessories')
    TriggerServerEvent(Base.PrefixEvent .. ':black_money')
    TriggerServerEvent(Base.PrefixEvent .. ':getSlotSet')
    ESX.PlayerData = xPlayer
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
        TriggerServerEvent(Base.PrefixEvent .. ':getOwnerVehicle')
        TriggerServerEvent(Base.PrefixEvent .. ':getOwnerHouse')
        TriggerServerEvent(Base.PrefixEvent .. ':getOwnerAccessories')
        TriggerServerEvent(Base.PrefixEvent .. ':black_money')
	end
end)

RegisterNetEvent(Base.PrefixEvent .. ':getOwnerAccessories')
AddEventHandler(Base.PrefixEvent .. ':getOwnerAccessories',function()
    TriggerServerEvent(Base.PrefixEvent .. ':getOwnerAccessories')
end)

RegisterNetEvent(Base.PrefixEvent .. ':getOwnerVehicle')
AddEventHandler(Base.PrefixEvent .. ':getOwnerVehicle',function()
    TriggerServerEvent(Base.PrefixEvent .. ':getOwnerVehicle')
end)

RegisterNetEvent(Base.PrefixEvent .. ':getOwnerHouse')
AddEventHandler(Base.PrefixEvent .. ':getOwnerHouse',function()
    TriggerServerEvent(Base.PrefixEvent .. ':getOwnerHouse')
end)

RegisterNetEvent(Base.PrefixEvent .. ':setOwnerVehicle')
AddEventHandler(Base.PrefixEvent .. ':setOwnerVehicle', function(result)
    Vehicle_Key = result
end)

RegisterNetEvent(Base.PrefixEvent .. ':setOwnerHouse')
AddEventHandler(Base.PrefixEvent .. ':setOwnerHouse', function(result)
    House_Key = result
end)

RegisterNetEvent(Base.PrefixEvent .. ':setOwnerAccessories')
AddEventHandler(Base.PrefixEvent .. ':setOwnerAccessories', function(result)
    Accessory_Items = result
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        --SetPedCanSwitchWeapon(PlayerPedId(), false)
		HideHudComponentThisFrame(19)
		DisableControlAction(1, 37, false)
		DisableControlAction(1, 157, true)
		DisableControlAction(1, 158, true)
		DisableControlAction(1, 160, true)
		DisableControlAction(1, 164, true)
		DisableControlAction(1, 165, true)
		DisableControlAction(2, 157, true)-- disable changing weapon
		DisableControlAction(2, 158, true)-- disable changing weapon
		DisableControlAction(2, 159, true)-- disable changing weapon
		DisableControlAction(2, 160, true)-- disable changing weapon
		DisableControlAction(2, 161, true)-- disable changing weapon
		DisableControlAction(2, 162, true)-- disable changing weapon
		DisableControlAction(2, 163, true)-- disable changing weapon
		DisableControlAction(2, 164, true)-- disable changing weapon
		DisableControlAction(2, 165, true)-- disable changing weapon
	end
end)

function updateFastItemsHotbar()
    fastItemsHotbar = {}
    for i = 1, 7 do
        if fastWeapons[i] then
            local item = fastWeapons[i]
            item.slot = i
            table.insert(fastItemsHotbar, item)
            print('[FastSlot] Slot ' .. i .. ': ' .. item.name)
        end
    end
end



function OnUseFastSlot(number)
    if not IsEntityDead(PlayerPedId()) then
        if fastWeapons[number] ~= nil then
            if fastWeapons[number].name == 'key' then
                TriggerServerEvent('scotty:keyTrigger', fastWeapons[number].label)
            elseif fastWeapons[number].type == 'item_weapon' then
                SetWeapon(fastWeapons[number])
            elseif fastWeapons[number].type == 'item_accessories' then
                useItems(fastWeapons[number])
            else
                TriggerServerEvent('esx:useItem', fastWeapons[number].name)
            end
        else
            ESX.ShowNotification("DEBUG OnUseFastSlot!")
        end
    end
end

RegisterKeyMapping('fast1', 'Use Fast Slot (1)', 'keyboard', '1')
RegisterKeyMapping('fast2', 'Use Fast Slot (2)', 'keyboard', '2')
RegisterKeyMapping('fast3', 'Use Fast Slot (3)', 'keyboard', '3')
RegisterKeyMapping('fast4', 'Use Fast Slot (4)', 'keyboard', '4')
RegisterKeyMapping('fast5', 'Use Fast Slot (5)', 'keyboard', '5')
RegisterKeyMapping('fast6', 'Use Fast Slot (6)', 'keyboard', '6')
RegisterKeyMapping('fast7', 'Use Fast Slot (7)', 'keyboard', '7')

RegisterCommand('fast1', function() OnUseFastSlot(1) end, false)
RegisterCommand('fast2', function() OnUseFastSlot(2) end, false)
RegisterCommand('fast3', function() OnUseFastSlot(3) end, false)
RegisterCommand('fast4', function() OnUseFastSlot(4) end, false)
RegisterCommand('fast5', function() OnUseFastSlot(5) end, false)
RegisterCommand('fast6', function() OnUseFastSlot(6) end, false)
RegisterCommand('fast7', function() OnUseFastSlot(7) end, false)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    -- โหลด slot จาก server
    TriggerServerEvent(Base.PrefixEvent .. ':getSlotSet') -- สร้าง callback ดึงจาก DB
end)

RegisterNetEvent(Base.PrefixEvent .. ':setFastSlotSet')
AddEventHandler(Base.PrefixEvent .. ':setFastSlotSet', function(set)
    -- สมมติ set ที่ได้จาก server เป็น table ที่มี slotSets[1] กับ slotSets[2]
    slotSets[1] = set[1] or {}  -- โหลด slot set 1
    slotSets[2] = set[2] or {}  -- โหลด slot set 2

    -- เซ็ต fastWeapons เป็น slot set 1 (เริ่มต้นตอนเข้าเซิฟ)
    currentSlotSet = 1
    for i = 1, 7 do
        fastWeapons[i] = slotSets[1][i]
    end

    updateFastItemsHotbar()
    loadPlayerInventory()

    -- ส่ง NUI message ให้แสดง fast slot set 1
    SendNUIMessage({
        action = 'setItemsFast',
        fastItems = fastItemsHotbar,
        fastSetId = currentSlotSet
    })
end)


-- FastSlot Switch System
local currentSlotSet = 1 -- ✅ ตรงนี้จะรีค่าเมื่อได้รับ event จาก server
local slotSets = {[1] = {}, [2] = {}}

-- switch
currentSlotSet = currentSlotSet % 2 + 1

local isSwapping = false
local isHotbarVisible = false

RegisterCommand("swapfastslot", function()
    TriggerEvent('swapFastSlotLogic') -- เรียก Logic กลาง
end, false)



RegisterNUICallback('swapfastslot', function(data, cb)
    TriggerEvent('swapFastSlotLogic') -- เรียก Logic กลาง
    cb('ok')
end)


RegisterNetEvent('swapFastSlotLogic')
AddEventHandler('swapFastSlotLogic', function()
    if isSwapping then return end

    -- Save current slot
    slotSets[currentSlotSet] = {}
    for i = 1, 7 do
        slotSets[currentSlotSet][i] = fastWeapons[i]
    end

    -- Toggle slot set
    currentSlotSet = (currentSlotSet == 1) and 2 or 1
    local newSet = slotSets[currentSlotSet]

    for i = 1, 7 do
        fastWeapons[i] = newSet[i]
    end

    updateFastItemsHotbar()

    -- ส่งทั้ง itemList และ fastItems ให้ JS
    SendNUIMessage({
        action = 'setItems',
        itemList = currentInventoryItems or {}, -- ต้องแน่ใจว่าถูกเซ็ตไว้
        fastItems = fastItemsHotbar
    })

    -- ส่งแยกเพื่ออัปเดต Hotbar อย่างเดียวก็ได้ (optional)
    SendNUIMessage({
        action = 'setItemsFast',
        fastItems = fastItemsHotbar,
        fastSetId = currentSlotSet
    })

    ESX.ShowNotification("Fast Slot Set: " .. currentSlotSet)

    isSwapping = true
    SetTimeout(1000, function()
        isSwapping = false
    end)
end)

RegisterKeyMapping("swapfastslot", "Fast Slot", "keyboard", "TAB")

IsSetWeapon = false
SetWeapon = function(data)
    if IsSetWeapon == data.name then
        IsSetWeapon = false
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
    else
        IsSetWeapon = data.name
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(data.name), true)
    end
end

RegisterCommand('CheckIsSetWeapon', function()
    if GetHashKey(IsSetWeapon) == GetSelectedPedWeapon(PlayerPedId()) then
        IsSetWeapon = false
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true) 
    end
end, false)

RegisterKeyMapping('CheckIsSetWeapon', 'Check IsSetWeapon', 'keyboard','B')

RegisterNUICallback('PutIntoFast', function(data, cb)
    if Config.Dontuse[data.item.name] then return end

    if data.item.slot ~= nil then
        fastWeapons[data.item.slot] = nil
    end

    fastWeapons[data.slot] = data.item
    updateFastItemsHotbar()

    -- ✅ ส่ง fastItems ไปอัปเดต Hotbar
    SendNUIMessage({
        action = 'setItemsFast',
        fastItems = fastItemsHotbar,
        fastSetId = currentSlotSet
    })

    loadPlayerInventory()
    cb('ok')
end)

RegisterNUICallback('SwapFast', function(data, cb)
    fastWeapons[data.slot1] = data.item1
    fastWeapons[data.slot2] = data.item2
    updateFastItemsHotbar()

    SendNUIMessage({
        action = 'setItemsFast',
        fastItems = fastItemsHotbar,
        fastSetId = currentSlotSet
    })

    loadPlayerInventory()
    cb('ok')
end)

RegisterNUICallback('TakeFromFast', function(data, cb)
    fastWeapons[data.item.slot] = nil

    updateFastItemsHotbar()

    SendNUIMessage({
        action = 'setItemsFast',
        fastItems = fastItemsHotbar,
        fastSetId = currentSlotSet
    })

    if string.find(data.item.name, 'WEAPON_', 1) ~= nil and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(data.item.name) then
        TriggerEvent(Base.PrefixEvent .. ':closeinventory', source)
    end

    loadPlayerInventory()
    cb('ok')
end)

RegisterNUICallback('GetBrowserCache', function(data, cb)
    if data.cache ~= false then
        print('action : receive-browser-cache')

        if data.cache.slot1 then
            for k, v in pairs(data.cache.slot1) do
                if v.slot then
                    slotSets[1][tonumber(v.slot)] = v
                end
            end
        end

        if data.cache.slot2 then
            for k, v in pairs(data.cache.slot2) do
                if v.slot then
                    slotSets[2][tonumber(v.slot)] = v
                end
            end
        end

        -- ✅ บังคับให้โหลด Set 1 หลังจากได้ข้อมูล cache มา
        currentSlotSet = 1
        for i = 1, 7 do
            fastWeapons[i] = slotSets[1][i]
        end

        updateFastItemsHotbar()

        SendNUIMessage({
            action = 'setItemsFast',
            fastItems = fastItemsHotbar,
            fastSetId = currentSlotSet
        })
    end
    cb('ok')
end)


function saveFastSlotToServer()
    -- เซฟ fastWeapons ของ set ปัจจุบัน
    slotSets[currentSlotSet] = {}
    for i = 1, 7 do
        slotSets[currentSlotSet][i] = fastWeapons[i]
    end

    -- ส่ง slotSets[1] และ slotSets[2] ไปที่ server
    TriggerServerEvent(Base.PrefixEvent .. ':saveFastSlotSet', slotSets)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        saveFastSlotToServer()
    end
end)

-- หรือจะเรียกเวลาปิด UI
RegisterNUICallback('closeInventory', function(_, cb)
    saveFastSlotToServer()
    cb('ok')
end)


-- RegisterNUICallback('GetBrowserCache', function(data, cb)
--     if data.cache ~= false then
--         print('action : receive-browser-cache')
--         for k,v in pairs(data.cache) do
--             fastWeapons[tonumber(v.slot)] = data.cache[k]
--         end
--     end
--     cb('ok')
-- end)

function useItems(data)
    local player = GetPlayerPed(-1)	
    closeInventory()			 
   
    if data.name == 'helmet' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin['helmet_1'] == -1 then

                local dict = 'veh@bicycle@roadfront@base'
                local anim = 'put_on_helmet'
    
                RequestAnimDict(dict)
                while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                
                TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
    
                Wait(1000)

                local accessorySkin = {}
                accessorySkin['helmet_1'] = data.itemnum
                accessorySkin['helmet_2'] = data.itemskin

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
    elseif data.name == 'mask' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin['mask_1'] == -1 then

                local dict = 'veh@bicycle@roadfront@base'
                local anim = 'put_on_helmet'
    
                RequestAnimDict(dict)
                while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
                
                TaskPlayAnim(player, dict, anim, 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
    
                Wait(1000)

                local accessorySkin = {}
                accessorySkin['mask_1'] = data.itemnum
                accessorySkin['mask_2'] = data.itemskin
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
    elseif data.name == 'glasses' then
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
                accessorySkin['glasses_1'] = data.itemnum
                accessorySkin['glasses_2'] = data.itemskin
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
elseif data.name == 'tshirt' then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin['tshirt_1'] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['tshirt_1']  = data.itemnum
        accessorySkin['tshirt_2']  = data.itemskin
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
elseif data.name == 'torso' then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin['torso_1'] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['torso_1']   = data.itemnum
        accessorySkin['torso_2']   = data.itemskin
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
elseif data.name == 'arms' then
TriggerEvent('skinchanger:getSkin', function(skin)

    if skin['arms'] == 15 then

    if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
        RequestAnimDict(Config.Options.dicton)
        while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
        TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
        Wait(2000)
    end

    local accessorySkin = {}
    accessorySkin['arms']   = data.itemnum
    accessorySkin['arms_2']   = data.itemskin
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
elseif data.name == 'pants' then
TriggerEvent('skinchanger:getSkin', function(skin)
    if skin['pants_1'] == 21 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['pants_1'] = data.itemnum
        accessorySkin['pants_2'] = data.itemskin
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
elseif data.name == 'shoes' then
TriggerEvent('skinchanger:getSkin', function(skin)
    if skin['shoes_1'] == 34 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['shoes_1'] = data.itemnum
        accessorySkin['shoes_2'] = data.itemskin
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
    elseif data.name == 'earring' then
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
                accessorySkin['ears_1'] = data.itemnum
                accessorySkin['ears_2'] = data.itemskin
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
elseif data.name == 'decals' then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin['decals_1'] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['decals_1']   = data.itemnum
        accessorySkin['decals_2']   = data.itemskin
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
elseif data.name == 'chain' then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin['chain_1'] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['chain_1']   = data.itemnum
        accessorySkin['chain_2']   = data.itemskin
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
elseif data.name == 'bags' then
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin['bags_1'] == -1 then

        if Config.Options.enabled and IsPedInAnyVehicle(PlayerPedId(), true) == false then
            RequestAnimDict(Config.Options.dicton)
            while (not HasAnimDictLoaded(Config.Options.dicton)) do Citizen.Wait(0) end
            TaskPlayAnim(player, Config.Options.dicton, Config.Options.animon, 8.0, 1.0, -1, 0, 0.5, 0, 0)
            Wait(2000)
        end

        local accessorySkin = {}
        accessorySkin['bags_1']   = data.itemnum
        accessorySkin['bags_2']   = data.itemskin
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
end



