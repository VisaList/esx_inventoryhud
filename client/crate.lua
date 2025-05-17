local targetPlayer
local targetPlayerName


RegisterNetEvent(Base.PrefixEvent .. ':openCrateInventory')
AddEventHandler(Base.PrefixEvent .. ':openCrateInventory',function(target, playerName)
    print('ok')
        targetPlayer = target
        targetPlayerName = playerName
        setCrateInventoryData()
        openCrateInventory()
        Wait(250)
        refreshCrateInventory()
        Wait(250)
        loadPlayerInventory()
    end
)

function refreshCrateInventory()
    setCrateInventoryData()
end

function setCrateInventoryData()
    ESX.TriggerServerCallback(
        'lootbox:getlootbox',
        function(data)
            SendNUIMessage(
                {
                    action = 'setInfoText',
                    text = 'Lootbox'
                }
            )

            items = {}
            inventory = data.inventory
            money = data.money
            if money > 0 then
                table.insert(items, {
                    label     = 'Money',
                    count     = money,
                    type      = 'item_money',
                    name      = 'cash',
                    usable    = false,
                    rare      = false,
                    canRemove = true
                })
            end
            --if Config.IncludeCash and money ~= nil and money > 0 then
            --    for key, value in pairs(accounts) do
            --        moneyData = {
            --            label = _U('cash'),
            --            name = 'cash',
            --            type = 'item_money',
            --            count = money,
            --            usable = false,
            --            rare = false,
            --            limit = -1,
            --            canRemove = true
            --        }
--
            --        table.insert(items, moneyData)
            --    end
            --end
--
            --if Config.IncludeAccounts and accounts ~= nil then
            --    for key, value in pairs(accounts) do
            --        if not shouldSkipAccount(accounts[key].name) then
            --            local canDrop = accounts[key].name ~= 'bank'
--
            --            if accounts[key].money > 0 then
            --                accountData = {
            --                    label = accounts[key].label,
            --                    count = accounts[key].money,
            --                    type = 'item_account',
            --                    name = accounts[key].name,
            --                    usable = false,
            --                    rare = false,
            --                    limit = -1,
            --                    canRemove = canDrop
            --                }
            --                table.insert(items, accountData)
            --            end
            --        end
            --    end
            --end

            if inventory ~= nil then
                for key, value in pairs(inventory) do
                    if inventory[key].count <= 0 then
                        inventory[key] = nil
                    else
                        inventory[key].type = 'item_standard'
                        table.insert(items, inventory[key])
                    end
                end
            end


            SendNUIMessage(
                {
                    action = 'setSecondInventoryItems',
                    itemList = items
                }
            )
        end,
        targetPlayer
    )

end

function openCrateInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = 'display',
            type = 'crate'
        }
    )

    SetNuiFocus(true, true)
end


RegisterNUICallback('TakeFromCrate',function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == 'number' and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        if data.item.type == 'item_weapon' then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end
        TriggerServerEvent('lootbox:lootbox_trade', GetPlayerServerId(PlayerId()), targetPlayer, data.item.type, data.item.name, count,true)
    end
    Wait(250)
    refreshCrateInventory()
    Wait(250)
    loadPlayerInventory()
    cb('ok')
end)

RegisterNUICallback('PutIntoCrate',function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    
    --if type(data.number) == 'number' and math.floor(data.number) == data.number then
    --    local count = tonumber(data.number)
    --    if data.item.type == 'item_weapon' then
    --        count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
    --    end
    --    TriggerServerEvent('lootbox:lootbox_trade', targetPlayer, GetPlayerServerId(PlayerId()), data.item.type, data.item.name, count,false)
    --end
    --Wait(250)
    --refreshCrateInventory()
    --Wait(250)
    --loadPlayerInventory()
    cb('ok')
end)
