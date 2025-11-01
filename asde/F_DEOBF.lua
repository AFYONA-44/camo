print("=================")
print("Created by unkkifk")
print("=================")


-- Working
local fiveguardFiles = {
    ["sv-resource-obfuscated.lua"] = 1,
    ["sv-resource-obfuscated.js"] = 1,
    ["cl-resource-obfuscated.lua"] = 1,
    ["shared_fg-obfuscated.lua"] = 1,
    ["ai_module_fg-obfuscated.lua"] = 1,
    ["ai_module_fg-obfuscated.js"] = 1,
    ["vrp_shared-obfuscated.lua"] = 1,
    ["script-obfuscated.js"] = 1
}

local phoenixFiles = {
    ["_G%.WhitelistedEvents%s*=%s*json%.decode"] = 10,
    ["_G%.ForceScrambleEvents%s*=%s*json%.decode"] = 10,
}

local possibleFiles = {
    ["anticheat.lua"] = 1, 
    ["server_anticheat.lua"] = 1,
    ["client_anticheat.lua"] = 1,
    ["anticheat.js"] = 1,
    ["anticheat_c.lua"] = 1,
    ["anticheat_s.lua"] = 1,
    ["antimenu.lua"] = 1,
    ["menublocker.lua"] = 1,
    ["menu_blocker.lua"] = 1,
    ["anti_menu.lua"] = 1,
    ["anticheat.html"] = 1,
    ["blacklist.lua"] = 1,
    ["weapon_blacklist.lua"] = 1,
    ["prop_blacklist.lua"] = 1,
    ["anti_aimbot.lua"] = 1,
    ["aimbot.lua"] = 1,
    ["anti_executor.lua"] = 1,
    ["antiexecutor.lua"] = 1,
    ["anti_overlay.lua"] = 1,
    ["antioverlay.lua"] = 1,
    ["executor.lua"] = 1,
    ["anti_silentaim.lua"] = 1,
    ["antisilentaim.lua"] = 1,
    ["anti_wallhack.lua"] = 1,
    ["antiwallhack.lua"] = 1,
    ["anti.lua"] = 1,
    ["heartbeat.lua"] = 1,
    ["cheatai.lua"] = 1,
    ["cheat_ai.lua"] = 1,
    ["cheat.lua"] = 1,
    ["carblacklist.lua"] = 1,
    ["car_blacklist.lua"] = 1,
    ["vehicle_blacklist.lua"] = 1,
    ["vehicleblacklist.lua"] = 1,
    ["anti_noclip.lua"] = 1,
    ["antinoclip.lua"] = 1,
    ["anti_spoofedweapon.lua"] = 1,
    ["anti_spoofedprop.lua"] = 1,
    ["anti_spoofedcar.lua"] = 1,
    ["antispoofedweapon.lua"] = 1,
    ["antispoofedprop.lua"] = 1,
    ["antispoofedcar.lua"] = 1
}

-- Reverce Files
local reverseFiles = {
    ["cheatai-obfuscated.lua"] = 1,
    ["PlayerFreeze.lua"] = 1,
    ["vehicles.lua"] = 1,
    ["ptfx.lua"] = 1,
    ["spawnSpoofedProps.lua"] = 1,
    ["DamageEvent.lua"] = 1,
    ["UnauthorizedResource.lua"] = 1,
    ["ped.lua"] = 1,
    ["Player.lua"] = 1,
    ["weapons.lua"] = 1,
    ["clearpedtasks.lua"] = 1,
    ["emoteall.lua"] = 1,
    ["explosion.lua"] = 1,
    ["heartbeat.lua"] = 1,
    ["props.lua"] = 1,
    ["panel.lua"] = 1,
    ["cheatAI.js"] = 1,
    ["Player.lua"] = 1,
    ["vehicles.lua"] = 1,
    ["menu.lua"] = 1,
    ["damage.lua"] = 1,
    ["aimbot.lua"] = 1,
}

-- Moonguard files
local moonguardFiles = {
    ["moonguard_agent.lua"] = 1,
    ["module_core.lua"] = 1,
    ["whitelistedglobal.json"] = 1,
    ["panel/config.lua"] = 2,
    ["panel/client.lua"] = 1,
    ["configs/Config.lua"] = 1,
    ["panel/server.lua"] = 1,
    ["html/panel/index.html"] = 1,
    ["yes"] = 1,
}

-- Working
local electronFiles = {
    ["src/include/client.lua"] = 1,
    ["src/server/main.js"] = 1,
    ["src/server/main.lua"] = 1,
    ["src/client/main.lua"] = 1,
    ["web/index.html"] = 1,    
    ["true"] = 1,  
}

-- Chocohax Files
local chocohaxFiles = {
    ["/client/index.min.html"] = 1, 
    ["module/*.js"] = 1, 
    ["module/animation/tracks/*.js"] = 1, 
    ["module/animation/*.js"] = 1, 
    ["module/audio/*js"] = 1, 
    ["module/cameras/*.js"] = 1, 
    ["module/core/*.js"] = 1, 
    ["module/extras/core/*.js"] = 1, 
    ["module/extras/curves/*.js"] = 1, 
    ["module/extras/objects/*.js"] = 1, 
    ["module/extras/*.js"] = 1, 
    ["module/geometries/*.js"] = 1, 
    ["module/helpers/*.js"] = 1, 
    ["module/lights/*.js"] = 1, 
    ["module/loaders/*.js"] = 1, 
    ["module/materials/*.js"] = 1, 
    ["module/math/interpolants/*.js"] = 1, 
    ["module/math/*.js"] = 1, 
    ["module/objects/*.js"] = 1, 
    ["module/renderers/shaders/*.js"] = 1, 
    ["module/renderers/shaders/shaderchunk/*.js"] = 1, 
    ["module/renderers/shaders/shaderlib/*.js"] = 1, 
    ["module/renderers/webgl/*.js"] = 1, 
    ["module/renderers/webvr/*.js"] = 1, 
    ["module/renderers/*.js"] = 1, 
    ["module/scenes/*.js"] = 1, 
    ["module/textures/*.js"] = 1, 
    ["script.js"] = 1, 
    ["/client/deps.min.css"] = 1, 
    ["/client/deps.min.js"] = 1, 
    ["/client/main.min.js"] = 1, 
    ["/client/*.lynx"] = 1, 
    ["/modules/client/*.json"] = 1, 
    ["core.js"] = 1, 
    ["core.lua"] = 1, 
    ["modules/*.lua"] = 1, 
    ["/client/client.js"] = 1, 
    ["/client/*.lua"] = 1, 
    ["/modules/client/*.lua"] = 1, 
}

-- Eagle Files Working
local eagleFiles = {
    ["configs/events.lua"] = 1,
    ["configs/shared_config.lua"] = 1,
    ["configs/vrp/shared_config.lua"] = 1,
    ["lib/Proxy.lua"] = 1,
    ["configs/esx/s_config.lua"] = 1,   
    ["render.lua"] = 1,
    ["lib/Tunnel.lua"] = 1,
    ["shared.lua"] = 1,
    ['configs/other/s_config.lua'] = 1,
    ['configs/qbcore/s_config.lua'] = 1,
    ['shared2.js'] = 1,
    ['server/main.lua'] = 1,
    ['server/server.js'] = 1,
    ['html/libs/three.eas.js'] = 1,
    ['html/messages.js'] = 1,
    ['html/main.js'] = 1,
    ['html/index1.html'] = 1,
    ['html/menu.js'] = 1,

}

-- Fire Files
local fireFiles = {
    ["src/fire-client.lua"] = 1,
    ["src/fire-menu.lua"] = 1,
    ["configs/fire-config.lua"] = 1,
    ["src/fire-server.lua"] = 1,
    ["gta5"] = 1,
    ["configs/fire-webhook.lua"] = 1,
    ["ui/index.html"] = 1,
    ["@oxmysql/lib/MySQL.lua"] = 1,
    ["FIREAC_CHANGE_TEMP_WHHITELIST"] = 2,
    ["FIREAC_CHECK_TEMP_WHITELIST"] = 2,
    ["FIREAC_ACTION"] = 2,
}

-- Working
local finiFiles = {
    ["fini_events.js"] = 1,
    ["fini_events.lua"] = 1,
    ["anticheat.html"] = 2,
    ["anticheat_init.lua"] = 1,
    ["client/client.js"] = 1,
    ["server/server.js"] = 1,
    ["yes"] = 1,
}

-- Reaper Files Working
local reaperFiles = {
    ["imports/bypass.lua"] = 1,
    ["imports/bypass_c.lua"] = 1,
    ["imports/bypass_s.lua"] = 1,
    ["classes/class.lua"] = 1,
    ["scripts/index.js"] = 1,
    ["client.lua"] = 1,
    ["imports/imports.lua"] = 2,
    ["imports/bypass.js"] = 1,
    ["web/build/index.html"] = 2,
    ["yes"] = 1,
    ["gta5"] = 1,
}

-- Working
local waveshieldFiles = {
    ["resource/include.lua"] = 1,
    ["resource/waveshield.js"] = 1,
    ["resource/client/main.lua"] = 1,
    ["resource/server/exports.lua"] = 1,
    ["resource/server/auth.lua"] = 1,
    ["web/server.js"] = 1,
    ["web/ui.html"] = 1,
    ["web/ui.js"] = 1,
}

-- Wx files
local wxanticheatFiles = {
    ["config/anticheat.lua"] = 1,
    ["config/punishments.lua"] = 1,
    ["src/init_sh.lua"] = 1,
    ["src/init_cl.lua"] = 1,
    ["src/functions/client/client_callbacks.lua"] = 1,
    ["src/nui/client/client_nui.lua"] = 1,
    ["@oxmysql/lib/MySQL.lua"] = 1,
    ["config/webhooks.lua"] = 1,
    ["src/init_sv.lua"] = 1,
    ["src/functions/server/server_callbacks.lua"] = 1,
    ["src/nui/server/server_nui.lua"] = 1,
    ["ui/dist/index.html"] = 2,
    ["yes"] = 1,
    ["gta5"] = 1,
}

-- Pegasus files working
local pegasusFiles = {
    ["server/install/AC.lua"] = 1,
    ["server/install/WP.lua"] = 1,
    ["server/install/EP.lua"] = 1,
    ["server/data/ignored_events.json"] = 1,
    ["client/html/build/index.html"] = 2,
    ["server/install/_installer.js"] = 1,
    ["server/sv_config.lua"] = 2,
    ["client/html/build/data/scare.gif"] = 1,
    ["yes"] = 2,
    ["gta5"] = 1,
}

local ruxoFiles = {
    ["code/nui/ui.html"] = 2,
    ["code/entityiter.lua"] = 2,
    ["config/shared_config.lua"] = 2,
    ["table_config.lua"] = 1,
    ["client/client.lua"] = 1,
    ["code/randomcode.lua"] = 1,
    ["code/installer.lua"] = 1,
    ["client/shared.lua"] = 1,
    ["config/server_config.lua"] = 1,
    ["server/server.lua"] = 1,
    ["code/nui/ui.js"] = 1,
    ["code/nui/ui.css"] = 1,
}

-- Working
local cyberFiles = {
    ["client-obfuscated.lua"] = 1,
    ["menu-obfuscated.lua"] = 1,
    ["init.lua"] = 4,
    ["server-obfuscated.lua"] = 1,
    ["bans.json"] = 2,
    ["install.js"] = 2,
    ["announcements.json"] = 2,
    ["sv_editme.lua"] = 1,
    ["sh_editme.lua"] = 1,
    ["index-acae63f2.css"] = 1,
    ["en.ui.json"] = 1,
    ["hashes.json"] = 1,
    ["inportant_accepted.json"] = 1,
    ["index.html"] = 2,
    ["config.lua"] = 1,
}

-- Working
local reasonFiles = {
    ["configuration.lua"] = 1,
    ["aimbot.lua"] = 2,
    ["crasher.lua"] = 2,
    ["devtools.lua"] = 2,
    ["dump.lua"] = 2,
    ["event.lua"] = 2,
    ["heartbeat.lua"] = 2,
    ["menu.lua"] = 2,
    ["ocr.lua"] = 2,
    ["player.lua"] = 1,
    ["tokenizer.lua"] = 2,
    ["trigger.lua"] = 2,
    ["vehicles.lua"] = 1,
    ["weapons.lua"] = 2,
    ["bans.json"] = 1,
    ["config.lua"] = 2,
    ["webhooks.lua"] = 2,
    ["commands.lua"] = 1,
    ["entities.lua"] = 1,
    ["explosions.lua"] = 1,
    ["particles.lua"] = 1,
    ["sound.lua"] = 1,
    ["spawn.lua"] = 1,
    ["start-stop.lua"] = 1,
    ["components.json"] = 1,
    ["weapons.json"] = 1,
}

-- Working
local wolfFiles = {
    ["server-event-config.lua"] = 2,
    ["import.lua"] = 2,
    ["protected.lua"] = 1,
    ["check.lua"] = 1,
    ["MySQL.lua"] = 1,
    ["sv-config.lua"] = 2,
    ["main.js"] = 1,
    ["client-event-config.lua"] = 1,
    ["function.lua"] = 1,
    ["shared.lua"] = 2,
    ["main.lua"] = 5,
    ["index.html"] = 2,
    ["script.js"] = 1,
    ["def.js"] = 1,    
}

local icarusFiles = {
    ["wrapper.lua"] = 1,
    ["config.lua"] = 1,
    ["dist/rpc_loader/RPCLoader.js"] = 1,
    ["yes"] = 2,
    ["dist/server/App.js"] = 1,
    ["22"] = 1,
    ["gta5"] = 1,
}

local cheeseFiles = {
    ["ac_config.lua"] = 2,
    ["ac_s.lua"] = 1,
    ["ac_c.lua"] = 1,
    ["gta5"] = 1,
}

local metadataKeys = {
    "client_script", "client_scripts",
    "server_script", "server_scripts",
    "shared_script", "shared_scripts",
    "files", "escrow_ignore", "ac", "file",
    "exports", "server_exports", "ui_page",
    "dependencies", "lua54", "use_experimental_fxv2_oal",
    "node_version", "games", "ui_page_preload"
}

local function countSuspiciousFilesExact(resName, fileMap)
    local foundCounts = {}
    for _, key in ipairs(metadataKeys) do
        local i = 0
        while true do
            local file = GetResourceMetadata(resName, key, i)
            if not file then break end
            local lowerFile = file:lower()
            for pattern, exactRequired in pairs(fileMap) do
                if lowerFile:find(pattern, 1, true) then
                    foundCounts[pattern] = (foundCounts[pattern] or 0) + 1
                end
            end
            i = i + 1
        end
    end

    local totalMatchedPatterns = 0
    for pattern, exactRequired in pairs(fileMap) do
        if (foundCounts[pattern] or 0) == exactRequired then
            totalMatchedPatterns = totalMatchedPatterns + 1
        end
    end

    return totalMatchedPatterns, foundCounts
end

local function countSuspiciousFiles(resName, fileMap)
    local total = 0
    for _, key in ipairs(metadataKeys) do
        local i = 0
        while true do
            local file = GetResourceMetadata(resName, key, i)
            if not file then break end
            local lowerFile = file:lower()
            for pattern in pairs(fileMap) do
                if lowerFile:find(pattern, 1, true) then
                    total = total + 1
                    break
                end
            end
            i = i + 1
        end
    end
    return total
end

local function countPatternOccurrences(resourceName, pattern)
    local content = LoadResourceFile(resourceName, "client.lua") or ""
    local count = 0
    for _ in content:gmatch(pattern) do
        count = count + 1
    end
    return count
end

Citizen.CreateThread(function()
    local num = GetNumResources()
    local detectedReverse = false
    local detectedMoonGuard = false
    local detectedFiveguard = false
    local detectedElectron = false
    local detectedChocohax = false
    local detectedEagle = false
    local detectedFire = false
    local detectedFini = false
    local detectedReaper = false
    local detectedWaveshield = false
    local detectedWxanticheat = false
    local detectedPossible = false
    local detectedPegasus = false
    local detectedRuxo = false
    local detectedCyber = false
    local detectedReason = false
    local detectedWolf = false
    local detectedIcarus = false
    local detectedCheese = false
    local detectedPhoenix = false

    for i = 0, num - 1 do
        local resName = GetResourceByFindIndex(i)
        if resName then
            local fx = (GetResourceMetadata(resName, "fx_version", 0) or ""):lower()
            local desc = (GetResourceMetadata(resName, "description", 0) or ""):lower()
            local author = (GetResourceMetadata(resName, "author", 0) or ""):lower()

            -- Fiveguard detection 20.10.2025
            if not detectedFiveguard then
                local fiveguardCount, foundCounts = countSuspiciousFilesExact(resName, fiveguardFiles)
                if fx == "bodacious" and (fiveguardCount >= 8) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("======================================================")
                    print(("!!! FIVEGUARD ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("======================================================")
                    detectedFiveguard = true
                end
            end
            
            -- Reverce detection
            if not detectedReverse then
                local reverseCount, foundCounts = countSuspiciousFilesExact(resName, reverseFiles)
                if fx == "adamant" and (reverseCount >= 6) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("====================================================")
                    print(("!!! REVERCE ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("====================================================")
                    detectedReverse = true
                end
            end

            -- Moonguard detection
            if not detectedMoonGuard then
                local moonguardCount, foundCounts = countSuspiciousFilesExact(resName, moonguardFiles)
                if fx == "cerulean" and (moonguardCount >= 5) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("======================================================")
                    print(("!!! MOONGUARD ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("======================================================")
                    detectedMoonGuard = true
                end
            end

            -- Electron Detection 20.10.2025
            if not detectedElectron then
                local electornCount, foundCounts = countSuspiciousFilesExact(resName, electronFiles)
                if fx == "cerulean" and (electornCount >= 6) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=====================================================")
                    print(("!!! ELECTRON ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=====================================================")
                    detectedElectron = true
                end
            end

            -- Chocohax detection
            if not detectedChocohax then
                local chocohaxCount, foundCounts = countSuspiciousFilesExact(resName, chocohaxFiles)
                if fx == "adamant" and (chocohaxCount >= 24) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=====================================================")
                    print(("!!! CHOCOHAX ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=====================================================")
                    detectedChocohax = true
                end
            end

            -- EAGLE detection
            if not detectedEagle then
                local eagleCount, foundCounts = countSuspiciousFilesExact(resName, eagleFiles)
                if fx == "adamant" and (eagleCount >= 15) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("==================================================")
                    print(("!!! EAGLE ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("==================================================")
                    detectedEagle = true
                end
            end

            -- Fire detection
            if not detectedFire then
                local fireCount, foundCounts = countSuspiciousFilesExact(resName, fireFiles)
                if fx == "cerulean" and (fireCount >= 6) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=================================================")
                    print(("!!! FIRE ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=================================================")
                    detectedFire = true
                end
            end

            -- Fini detection
            if not detectedFini then
                local finiCount, foundCounts = countSuspiciousFilesExact(resName, finiFiles)
                if fx == "cerulean" and (finiCount >= 6) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=================================================")
                    print(("!!! FINI ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=================================================")
                    detectedFini = true
                end
            end

            -- Reaper detection
            if not detectedReaper then
                local reaperCount, foundCounts = countSuspiciousFilesExact(resName, reaperFiles)
                if fx == "cerulean" and (reaperCount >= 8) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("======================================================")
                    print(("!!! REAPER V4 ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("======================================================")
                    detectedReaper = true
                end
            end

            -- Waveshield detection 20.10.2025
            if not detectedWaveshield then
                local waveshieldCount, foundCounts = countSuspiciousFilesExact(resName, waveshieldFiles)
                if fx == "cerulean" and (waveshieldCount >= 5) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=======================================================")
                    print(("!!! WAVESHIELD ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=======================================================")
                    detectedWaveshield = true
                end
            end

            -- Wx detection
            if not detectedWxanticheat then
                local wxanticheatCount, foundCounts = countSuspiciousFilesExact(resName, wxanticheatFiles)
                if fx == "cerulean" and (wxanticheatCount >= 10) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("===============================================")
                    print(("!!! WX ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("===============================================")
                    detectedWxanticheat = true
                end
            end
            
            -- Pegasus detection
            if not detectedPegasus then
                local pegasusCount, foundCounts = countSuspiciousFilesExact(resName, pegasusFiles)
                if fx == "bodacious" and (pegasusCount >= 6) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("====================================================")
                    print(("!!! PEGASUS ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("====================================================")
                    detectedPegasus = true
                end
            end

            -- Ruxo detection
            if not detectedRuxo then
                local ruxoCount, foundCounts = countSuspiciousFilesExact(resName, ruxoFiles)
                if fx == "adamant" and (ruxoCount >= 8) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=================================================")
                    print(("!!! RUXO ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=================================================")
                    detectedRuxo = true
                end
            end

            -- Cyber Secure detection 20.10.2025
            if not detectedCyber then
                local cyberCount, foundCounts = countSuspiciousFilesExact(resName, cyberFiles)
                if fx == "adamant" and (cyberCount >= 15) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=========================================================")
                    print(("!!! CYBER SECURE ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=========================================================")
                    detectedCyber = true
                end
            end

            -- Reason detection 20.10.2025
            if not detectedReason then
                local reasonCount, foundCounts = countSuspiciousFilesExact(resName, reasonFiles)
                if fx == "adamant" and (reasonCount >= 26) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("===================================================")
                    print(("!!! REASON ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("===================================================")
                    detectedReason = true
                end
            end

            -- Wolfshield detection 20.10.2025
            if not detectedWolf then
                local wolfCount, foundCounts = countSuspiciousFilesExact(resName, wolfFiles)
                if fx == "adamant" and (wolfCount >= 12) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=======================================================")
                    print(("!!! WOLFSHIELD ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=======================================================")
                    detectedWolf = true
                end
            end

            -- Icarus detection 
            if not detectedIcarus then
                local icarusCount, foundCounts = countSuspiciousFilesExact(resName, icarusFiles)
                if fx == "cerulean" and (icarusCount >= 6) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=======================================================")
                    print(("!!! ICARUS ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=======================================================")
                    detectedIcarus = true
                end
            end

            -- Cheese detection 
            if not detectedCheese then
                local cheeseCount, foundCounts = countSuspiciousFilesExact(resName, cheeseFiles)
                if fx == "cerulean" and (cheeseCount >= 4) then
                    print([[
  /$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 /$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    ]])
                    print("=======================================================")
                    print(("!!! ANTICHEESE ANTICHEAT DETECTED IN RESOURCE '%s' !!!"):format(resName))
                    print("=======================================================")
                    detectedCheese = true
                end
            end

            -- Phoenix detection 
            --if not detectedPhoenix then
                --local totalFound = 0
                --local matched = {}

                --for pattern, minCount in pairs(phoenixFiles) do
                    --local count = countPatternOccurrences(resName, pattern)
                    --if count >= minCount then
                        --table.insert(matched, ("%s (found %d, required %d)"):format(pattern, count, minCount))
                        --totalFound = totalFound + 1
                    --end
                --end

                --if fx == "cerulean" or "bodacious" or "adamant" and totalFound >= 2 then
                    --print([[
  --/$$$$$$              /$$     /$$           /$$                             /$$           /$$$$$$$              /$$                           /$$                     /$$
 --/$$__  $$            | $$    |__/          | $$                            | $$          | $$__  $$            | $$                          | $$                    | $$
--| $$  \ $$ /$$$$$$$  /$$$$$$   /$$  /$$$$$$$| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$        | $$  \ $$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$
--| $$$$$$$$| $$__  $$|_  $$_/  | $$ /$$_____/| $$__  $$ /$$__  $$ |____  $$|_  $$_/        | $$  | $$ /$$__  $$|_  $$_/   /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
--| $$__  $$| $$  \ $$  | $$    | $$| $$      | $$  \ $$| $$$$$$$$  /$$$$$$$  | $$          | $$  | $$| $$$$$$$$  | $$    | $$$$$$$$| $$        | $$    | $$$$$$$$| $$  | $$
--| $$  | $$| $$  | $$  | $$ /$$| $$| $$      | $$  | $$| $$_____/ /$$__  $$  | $$ /$$      | $$  | $$| $$_____/  | $$ /$$| $$_____/| $$        | $$ /$$| $$_____/| $$  | $$
--| $$  | $$| $$  | $$  |  $$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$|  $$$$$$$
--|__/  |__/|__/  |__/   \___/  |__/ \_______/|__/  |__/ \_______/ \_______/   \___/        |_______/  \_______/   \___/   \_______/ \_______/   \___/   \_______/ \_______/
                    --]])
                    --print( "==================================")
                    --print(("!!! PHOENIX ANTICHEAT DETECTED !!!"):format(resName))
                    --print( "==================================")
                    --detectedPhoenix = true
                --end
            --end

            -- Possible anticheat detection
            if detectedPossible then
                local possibleCount = countSuspiciousFiles(resName, possibleFiles)
                local looksLikePossible = desc:find("anti-menu", 1, true) 
                    or desc:find("anticheat", 1, true) 
                    or author:find("anticheat")
                if resName ~= "monitor" and ((fx == "cerulean" or fx == "bodacious" or fx == "adamant") and (looksLikePossible or possibleCount >= 1)) then
                    print(("[Detected] Possible anticheat or cheat menu blocker detected in resource '%s'"):format(resName))
                    detectedPossible = true
                end
            end
        end
    end

    -- print if no known anticheat has been detected
    if not detectedReverse and not detectedMoonGuard and not detectedFiveguard and not detectedPhoenix and not detectedCheese and not detectedIcarus and not detectedElectron and not detectedChocohax and not detectedEagle and not detectedFire and not detectedFini and not detectedReaper and not detectedWaveshield and not detectedWxanticheat and not detectedPossible and not detectedPegasus and not detectedRuxo and not detectedCyber and not detectedReason and not detectedWolf then
        print("No known AntiCheat detected")
    end
end)
