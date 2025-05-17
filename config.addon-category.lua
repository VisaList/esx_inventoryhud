--
-- แบ่งประเภทของไอเทม
--
Config.AddonCategory = {}

Config.AddonCategory.Display = {
    Label = true,
    Icon = true
}

-- ประเภท
Config.AddonCategory.Categories = {
    ['type-all'] = {
        Icon = '',
        Label = 'ALL'
    },
    ['type-fasion'] = {
        Icon = '',
        Label = 'FASION'
    },
    -- ['type-cloth'] = {
    --     Icon = '',
    --     Label = 'CLOTHES'
    -- },
    ['type-food'] = {
        Icon = '',
        Label = 'FOOD'
    },
    ['type-weapon'] = {
        Icon = '',
        Label = 'WEAPON'
    },
    ['type-key'] = {
        Icon = '',
        Label = 'KEYS'
    }
}

-- ทุกไอเทมจะมีประเภทไหนเป็นค่าตั้งต้น
Config.AddonCategory.DefaultCategory = 'type-all'

-- เซ็ตประเภทของไอเทมต่าง ๆ
Config.AddonCategory.Items = {
    ['bread'] = 'type-food',
    ['car_keys'] = 'type-key',
    ['keyhouse'] = 'type-key'
}