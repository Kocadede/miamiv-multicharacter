fx_version 'adamant'
games {'gta5'}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/main.lua",
}

client_scripts {
    "client/*.lua",
}

ui_page {
    'html/ui.html',
}

files {
    'html/ui.html',
    'html/css/main.css',
    'html/img/*.svg',
    'html/js/app.js',
    'html/slick/*.css',
    'html/slick/*.js',
}