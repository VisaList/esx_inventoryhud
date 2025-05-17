Config                      = {}
Config.Locale               = 'en'
Config.IncludeCash          = true -- แสดงเงินในกระเป๋า
Config.IncludeAccounts      = true -- แสดง เงินแดง ในกระเป๋า
Config.IncludeWeapons       = true -- แสดง Weapons ในกระเป๋า
Config.ExcludeAccountsList  = {'bank'}   -- List of accounts names to exclude from inventory
Config.OpenControl          = 'T' --289  -- Key ในการเปิดกระเป๋า
Config.EnableVehicleKey     = true -- กุญแจรถในกระเป๋า
Config.EnableHouseKey       = false -- กุญแจบ้านในกระเป๋า
Config.Items                = true
Config.Weight               = false  -- ใช้ระบบน้ำหนัก สำหรับคนที่ใช้ es_extended 1.2 หรือ V1 Final --- False = Limit

Config.ItemTradeCarkey      = true
Config.ItemTradeCarkeyName 	= {
	['license_car'] = { 
		'ELEGY', -- โมเดลรถต้องเป็นตัวพิมพ์ใหญ่เท่านั้น
		'T20'
	},
}

Config.HideFastItemOnInventory = false -- ไม่แสดงไอเทมในกระเป๋าถ้าหากอยู่ในช่อง Fast Slot (Yield Addon)
Config.BlurBackdrop = true -- เบลอพื้นหลัง
Config.Delay = { -- ดีเลย์การเปิดกระเป๋า หลังจากปิดกระเป๋า
	Enable = true,
	Length = 500
}
Config.CacheFastSlot = true -- ออกเข้าเกมใหม่ Fast Slot ยังอยู่เหมือนเดิม

Config.CloseCommand = 'closebag'

Config.Options = { -- อนิเมชั่นใส่ถอดเสือผ้า
    enabled = true, -- true = เปิดใช้งานอนิเมชั่นใส่เสือผ้า
    dicton = "clothingtie",
    animon = "try_tie_positive_a",

    enabledoff = true, -- true = เปิดใช้งานอนิเมชั่นถอดเสือผ้า
    dictoff = "clothingtie",
    animoff = "try_tie_positive_a"
}

Config.CloseUiItems = { -- เวลาใช้ของปิดกระเป๋าเอง
	'platter_lobster',
	'steak',
	'beer',
	'reskin_card',
	'radio',
	-- 'helmet',
	'glasses',
	'mask',
	'ears',
}

Config.disableDrop          = -- ปิดกระดอป Item
{
	WEAPON_BAT = true,
    WEAPON_GOLFCLUB = true,
	WEAPON_KNUCKLE = true,
    WEAPON_FLASHLIGHT = true,
    WEAPON_NIGHTSTICK = true,
	WEAPON_HAMMER = true,
	WEAPON_MACHETE = true,
	WEAPON_BATTLEAXE = true,
	WEAPON_COMBATPISTOL = true,
	WEAPON_STUNGUN = false,
	WEAPON_POOLCUE = true,
	WEAPON_KNIFE = true,
	WEAPON_SWITCHBLADE = true,
	WEAPON_BOTTLE = true,

	id_card = true,
	money = true,
	black_money = true,


}

Config.disableGive          = -- ปิดการ Give Item
{
    -- Weapons
    WEAPON_BAT = true,
    WEAPON_GOLFCLUB = true,
	WEAPON_KNUCKLE = true,
    WEAPON_FLASHLIGHT = true,
    WEAPON_NIGHTSTICK = true,
	WEAPON_HAMMER = true,
	WEAPON_MACHETE = true,
	WEAPON_BATTLEAXE = true,
	WEAPON_COMBATPISTOL = true,
	WEAPON_STUNGUN = false,
	WEAPON_POOLCUE = true,
	WEAPON_KNIFE = true,
	WEAPON_SWITCHBLADE = true,
	WEAPON_BOTTLE = true,

}

Config.disablePutIntoHouse       = -- ห้ามเอาของเข้ารถ House
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,
    
    -- Item
	--cement 				= true,
}

Config.disablePutIntoVault       = -- ห้ามเอาของเข้ารถ Vault
{
    -- Weapons
    WEAPON_BAT 			= true,
    WEAPON_GOLFCLUB 	= true,
	WEAPON_KNUCKLE 		= true,
    WEAPON_FLASHLIGHT 	= true,
    WEAPON_NIGHTSTICK 	= true,
	WEAPON_HAMMER 		= true,
	WEAPON_MACHETE 		= true,
	WEAPON_BOTTLE 		= true,
	WEAPON_STUNGUN 		= true,
	WEAPON_SWITCHBLADE 	= true,
    WEAPON_POOLCUE 		= true,

	id_card = true,
	money = true,
   
}

-- Config.BlacklistVault = { --บล็อกของตู้เซฟ
--     "key_safe",


-- }

Config.Dontuse = --ไม่สามารถลากไอเทมอะเข้า slot ได้บ้าง 
{
	--water = true, --นํ้า
	--bread = true, --ขนมปัง
}