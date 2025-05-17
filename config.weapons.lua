Config.Weapons = {
	--SKIN

	-- {
	-- 	name = 'WEAPON_DESSERT_POOLCUE',
	-- 	label = TranslateCap('weapon_poolcue'),
	-- 	components = {}
	-- },

	-- {
	-- 	name = 'WEAPON_DESSERT_GOLFCLUB',
	-- 	label = TranslateCap('weapon_poolcue'),
	-- 	components = {}
	-- },

	-- Melee
	{
		name = 'WEAPON_KNIFE',
		label = ('KNIFE'),
		components = {}
	},

	{
		name = 'WEAPON_NIGHTSTICK',
		label = TranslateCap('weapon_nightstick'),
		components = {}
	},

	{
		name = 'WEAPON_HAMMER',
		label = TranslateCap('weapon_hammer'),
		components = {}
	},

	{
		name = 'WEAPON_BAT',
		label = ('BAT'),
		components = {}
	},

	{
		name = 'WEAPON_GOLFCLUB',
		label = ('GOLFCLUB'),
		components = {}
	},

	{
		name = 'WEAPON_CROWBAR',
		label = TranslateCap('weapon_crowbar'),
		components = {}
	},

	{
		name = 'WEAPON_PISTOL',
		label = TranslateCap('weapon_pistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_PISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_PISTOL_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_PISTOL_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_COMBATPISTOL',
		label = TranslateCap('weapon_combatpistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_APPISTOL',
		label = TranslateCap('weapon_appistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_APPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_APPISTOL_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_APPISTOL_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_PISTOL50',
		label = TranslateCap('weapon_pistol50'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_PISTOL50_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_PISTOL50_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_PISTOL50_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_REVOLVER',
		label = TranslateCap('weapon_revolver'),
		components = {}
	},

	{
		name = 'WEAPON_SNSPISTOL',
		label = TranslateCap('weapon_snspistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_SNSPISTOL_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_HEAVYPISTOL',
		label = TranslateCap('weapon_heavypistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_HEAVYPISTOL_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_VINTAGEPISTOL',
		label = TranslateCap('weapon_vintagepistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_02') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},

	{
		name = 'WEAPON_MICROSMG',
		label = TranslateCap('weapon_microsmg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_MICROSMG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_MICROSMG_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_MICROSMG_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_SMG',
		label = TranslateCap('weapon_smg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_SMG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_SMG_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_SMG_CLIP_03') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_SMG_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_ASSAULTSMG',
		label = TranslateCap('weapon_assaultsmg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_MINISMG',
		label = TranslateCap('weapon_minismg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_MINISMG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_MINISMG_CLIP_02') }
		}
	},

	{
		name = 'WEAPON_MACHINEPISTOL',
		label = TranslateCap('weapon_machinepistol'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_03') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},

	{
		name = 'WEAPON_COMBATPDW',
		label = TranslateCap('weapon_combatpdw'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_03') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') }
		}
	},
	
	{
		name = 'WEAPON_PUMPSHOTGUN',
		label = TranslateCap('weapon_pumpshotgun'),
		components = {
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_SR_SUPP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_SAWNOFFSHOTGUN',
		label = TranslateCap('weapon_sawnoffshotgun'),
		components = {
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_ASSAULTSHOTGUN',
		label = TranslateCap('weapon_assaultshotgun'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},

	{
		name = 'WEAPON_BULLPUPSHOTGUN',
		label = TranslateCap('weapon_bullpupshotgun'),
		components = {
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},

	{
		name = 'WEAPON_HEAVYSHOTGUN',
		label = TranslateCap('weapon_heavyshotgun'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_03') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},

	{
		name = 'WEAPON_ASSAULTRIFLE',
		label = TranslateCap('weapon_assaultrifle'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_CARBINERIFLE',
		label = TranslateCap('weapon_carbinerifle'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02') },
			{ name = 'clip_box', label = TranslateCap('component_clip_box'), hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_ADVANCEDRIFLE',
		label = TranslateCap('weapon_advancedrifle'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_SPECIALCARBINE',
		label = TranslateCap('weapon_specialcarbine'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_03') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_BULLPUPRIFLE',
		label = TranslateCap('weapon_bullpuprifle'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_BULLPUPRIFLE_VARMOD_LOW') }
		}
	},

	{
		name = 'WEAPON_COMPACTRIFLE',
		label = TranslateCap('weapon_compactrifle'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_02') },
			{ name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_03') }
		}
	},

	{
		name = 'WEAPON_MG',
		label = TranslateCap('weapon_mg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_MG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_MG_CLIP_02') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_MG_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_COMBATMG',
		label = TranslateCap('weapon_combatmg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_COMBATMG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_COMBATMG_CLIP_02') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_COMBATMG_VARMOD_LOWRIDER') }
		}
	},

	{
		name = 'WEAPON_GUSENBERG',
		label = TranslateCap('weapon_gusenberg'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_02') },
		}
	},

	{
		name = 'WEAPON_SNIPERRIFLE',
		label = TranslateCap('weapon_sniperrifle'),
		components = {
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE') },
			{ name = 'scope_advanced', label = TranslateCap('component_scope_advanced'), hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_SNIPERRIFLE_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_HEAVYSNIPER',
		label = TranslateCap('weapon_heavysniper'),
		components = {
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE') },
			{ name = 'scope_advanced', label = TranslateCap('component_scope_advanced'), hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') }
		}
	},

	{
		name = 'WEAPON_MARKSMANRIFLE',
		label = TranslateCap('weapon_marksmanrifle'),
		components = {
			{ name = 'clip_default', label = TranslateCap('component_clip_default'), hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_02') },
			{ name = 'flashlight', label = TranslateCap('component_flashlight'), hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = TranslateCap('component_scope'), hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM') },
			{ name = 'suppressor', label = TranslateCap('component_suppressor'), hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = TranslateCap('component_grip'), hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = GetHashKey('COMPONENT_MARKSMANRIFLE_VARMOD_LUXE') }
		}
	},

	{
		name = 'WEAPON_GRENADELAUNCHER',
		label = TranslateCap('weapon_grenadelauncher'),
		components = {}
	},

	{
		name = 'WEAPON_RPG',
		label = TranslateCap('weapon_rpg'),
		components = {}
	},

	{
		name = 'WEAPON_STINGER',
		label = TranslateCap('weapon_stinger'),
		components = {}
	},

	{
		name = 'WEAPON_MINIGUN',
		label = TranslateCap('weapon_minigun'),
		components = {}
	},

	{
		name = 'WEAPON_GRENADE',
		label = TranslateCap('weapon_grenade'),
		components = {}
	},

	{
		name = 'WEAPON_STICKYBOMB',
		label = TranslateCap('weapon_stickybomb'),
		components = {}
	},

	{
		name = 'WEAPON_SMOKEGRENADE',
		label = TranslateCap('weapon_smokegrenade'),
		components = {}
	},

	{
		name = 'WEAPON_BZGAS',
		label = TranslateCap('weapon_bzgas'),
		components = {}
	},

	{
		name = 'WEAPON_MOLOTOV',
		label = TranslateCap('weapon_molotov'),
		components = {}
	},

	{
		name = 'WEAPON_FIREEXTINGUISHER',
		label = TranslateCap('weapon_fireextinguisher'),
		components = {}
	},

	{
		name = 'WEAPON_PETROLCAN',
		label = TranslateCap('weapon_petrolcan'),
		components = {}
	},

	{
		name = 'WEAPON_DIGISCANNER',
		label = TranslateCap('weapon_digiscanner'),
		components = {}
	},

	{
		name = 'WEAPON_BALL',
		label = TranslateCap('weapon_ball'),
		components = {}
	},

	{
		name = 'WEAPON_BOTTLE',
		label = TranslateCap('weapon_bottle'),
		components = {}
	},

	{
		name = 'WEAPON_DAGGER',
		label = TranslateCap('weapon_dagger'),
		components = {}
	},

	{
		name = 'WEAPON_FIREWORK',
		label = TranslateCap('weapon_firework'),
		components = {}
	},

	{
		name = 'WEAPON_MUSKET',
		label = TranslateCap('weapon_musket'),
		components = {}
	},

	{
		name = 'WEAPON_STUNGUN',
		label = TranslateCap('weapon_stungun'),
		components = {}
	},

	{
		name = 'WEAPON_HOMINGLAUNCHER',
		label = TranslateCap('weapon_hominglauncher'),
		components = {}
	},

	{
		name = 'WEAPON_PROXMINE',
		label = TranslateCap('weapon_proxmine'),
		components = {}
	},

	{
		name = 'WEAPON_SNOWBALL',
		label = TranslateCap('weapon_snowball'),
		components = {}
	},

	{
		name = 'WEAPON_FLAREGUN',
		label = TranslateCap('weapon_flaregun'),
		components = {}
	},

	{
		name = 'WEAPON_GARBAGEBAG',
		label = TranslateCap('weapon_garbagebag'),
		components = {}
	},

	{
		name = 'WEAPON_HANDCUFFS',
		label = TranslateCap('weapon_handcuffs'),
		components = {}
	},

	{
		name = 'WEAPON_MARKSMANPISTOL',
		label = TranslateCap('weapon_marksmanpistol'),
		components = {}
	},

	{
		name = 'WEAPON_KNUCKLE',
		label = ('สนับมือ'),
		components = {}
	},

	{
		name = 'WEAPON_HATCHET',
		label = TranslateCap('weapon_hatchet'),
		components = {}
	},

	{
		name = 'WEAPON_RAILGUN',
		label = TranslateCap('weapon_railgun'),
		components = {}
	},

	{
		name = 'WEAPON_MACHETE',
		label = TranslateCap('weapon_machete'),
		components = {}
	},

	{
		name = 'WEAPON_SWITCHBLADE',
		label = TranslateCap('weapon_switchblade'),
		components = {}
	},

	{
		name = 'WEAPON_DBSHOTGUN',
		label = TranslateCap('weapon_dbshotgun'),
		components = {}
	},

	{
		name = 'WEAPON_AUTOSHOTGUN',
		label = TranslateCap('weapon_autoshotgun'),
		components = {}
	},

	{
		name = 'WEAPON_BATTLEAXE',
		label = TranslateCap('weapon_battleaxe'),
		components = {}
	},

	{
		name = 'WEAPON_COMPACTLAUNCHER',
		label = TranslateCap('weapon_compactlauncher'),
		components = {}
	},

	{
		name = 'WEAPON_PIPEBOMB',
		label = TranslateCap('weapon_pipebomb'),
		components = {}
	},

	{
		name = 'WEAPON_POOLCUE',
		label = TranslateCap('weapon_poolcue'),
		components = {}
	},

	{
		name = 'WEAPON_WRENCH',
		label = TranslateCap('weapon_wrench'),
		components = {}
	},

	{
		name = 'WEAPON_FLASHLIGHT',
		label = TranslateCap('weapon_flashlight'),
		components = {}
	},

	{
		name = 'GADGET_NIGHTVISION',
		label = TranslateCap('gadget_nightvision'),
		components = {}
	},

	{
		name = 'GADGET_PARACHUTE',
		label = TranslateCap('gadget_parachute'),
		components = {}
	},

	{
		name = 'WEAPON_FLARE',
		label = TranslateCap('weapon_flare'),
		components = {}
	},

	{
		name = 'WEAPON_DOUBLEACTION',
		label = TranslateCap('weapon_doubleaction'),
		components = {}
	},
	
	{
		name = 'WEAPON_STONE_HATCHET',
		label = TranslateCap('weapon_stonehatchet'),
		components = {}
	},
	
	{
		name = 'WEAPON_REVOLVER_MK2',
		label = TranslateCap('weapon_revolver_mk2'),
		components = {}
	},
	
	{
		name = 'WEAPON_PISTOl_MK2',
		label = TranslateCap('weapon_pistol_mk2'),
		components = {}
	}
}