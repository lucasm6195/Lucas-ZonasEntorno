fx_version 'cerulean'
game 'gta5'

author 'mano.6195'
description 'https://discord.gg/viperz'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
}