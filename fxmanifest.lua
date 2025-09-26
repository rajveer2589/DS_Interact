---@author YOLTIX
---@time 20/09/2025 15:16
---@creation ©️ Interact - DS-Store
---@description Interact System - DS-Store
---@version 1.0.0
---------------------------------------

fx_version 'cerulean'
game 'gta5'
lua54 'on'

author 'YOLTIX'
description 'DS Interact'
version '1.0.0'

shared_script {
    "config/*.lua",
}
client_script {
    "client/*.lua",
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/assets/*.js',
    'web/dist/assets/*.css',
    'web/dist/img/*.png',
}