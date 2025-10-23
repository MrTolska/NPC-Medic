fx_version 'cerulean'
lua54 'yes' 
game 'gta5'

author 'Bamm'
description 'BammsMedic'
version '0.1.0'

shared_script '@ox_lib/init.lua' 
shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib'  
}


