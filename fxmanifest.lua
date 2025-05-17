fx_version 'cerulean'
game 'gta5'

description 'ESX INVENTORYHUD'

version '1.1'

ui_page 'html/ui.html'

shared_script 'config.base.lua'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'config.weapons.lua',
	'config.addon-weight.lua',
	'config.addon-category.lua',
	'config.skinweapon.lua',
	'client/client.lua',
	'client/property.lua',
	'client/player.lua',
	'client/crate.lua',
	'client/playerinventory.lua',
	'client/core_client_thief.lua',
	'@xzero_trunk/export/trunk.lua',
	'@xzero_giveui/export/giveui.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/server.lua',
	'locales/en.lua',
}

files {
    'html/ui.html',
    'html/css/jquery.menu.css',
    'html/css/ui.css',
    'html/js/inventory.js',
    'html/js/config.js',
    'html/js/jquery.vendor.js',
	'html/js/setup-config.js',
	'html/js/yield.popup.js',
	'html/js/skin-weapon.js',
	'html/sounds/**',
	-- IMAGES
    'html/img/logo.png',
    'html/img/bullet.png',
	-- ICONS
	'html/img/*.png',
	'html/img/items/*.png',	
}

exports {
    'GetCurrentWeaponSkin'
}

