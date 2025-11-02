
    print("CODED BY ")
    print("    :+:         #++:::::::::    +:+          +:+   ::::::::      ::::      +:+        :+:    ")
    print(" :+:   :+:      #++              +:+       +:+    :+:    :+:     +:+:+:    +#+     :+:   :+: ")
    print("+:+     +:+     #++                +:+  +:+       +:+    +:+     +:+ +:+   +:+    :+:     +:+")
    print("+#++:++#++:     #++:::::::::         ###          +#+    +:+     +#+  +:+  #+#    +#++:++#++:")
    print("+#+     +#+     #++                  ###          #+#    #+#     +#+   +:+ +#+    +#+     +#+")
    print("#++     #++     #++                  ###          #+#    #+#     #+#     #+#      +#+     +#+")
    print("###     ###     #++                  ###           ########      #+#              +#+     +#+")
    print("")


    print("^7 Use SUSANO to bypass detected anti-cheats.")
    print("Discord: ^5https://discord.gg/uyHGnbt4Ty^7")
    print("")
    print("^1SafeEvents Fucked, Enjoy!^7")



local HTTPGET = function(url)
    local st, body = Susano.HttpGet(url)
    return body
end


Susano.InjectResource("monitor", [[
 print("write camon on f8")
HandleConfig = function() end
  _Executor_Strings = {["susano"] = "v3"}
  _Executor = "susano"
    -- Helper function لحساب المسافة بين لاعبين (اختياري)
    local function GetDistanceBetweenEntities(entity1, entity2)
        local x1, y1, z1 = table.unpack(GetEntityCoords(entity1))
        local x2, y2, z2 = table.unpack(GetEntityCoords(entity2))
        local dx, dy, dz = x1 - x2, y1 - y2, z1 - z2
        return math.sqrt(dx*dx + dy*dy + dz*dz)
    end

    -- Command: /allplayers [radius]
    RegisterCommand("id", function(source, args)
        local me = PlayerPedId()
        local radius = tonumber(args[1]) or nil -- لو حابب تستخدم راديوس اختياري

        print("=== Players in the server ===")

        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                local ped = GetPlayerPed(i)
                local name = GetPlayerName(i)
                local playerInfo = "PlayerID: " .. i .. " | Name: " .. name

                -- لو الراديوس محدد، احسب المسافة
                if radius and ped and ped ~= 0 then
                    local dist = GetDistanceBetweenEntities(me, ped)
                    if dist <= radius then
                        playerInfo = playerInfo .. " | Distance: " .. math.floor(dist)
                    else
                        goto continue -- تجاوز اللاعب لو خارج الراديوس
                    end
                end

                print(playerInfo)
                ::continue::
            end
        end
    end, false)



    -- Command: /lag

    local collisionEnabled = true


    RegisterCommand("lag", function()
        local ped = PlayerPedId()
        
        if collisionEnabled then
        
            SetEntityCollision(ped, false, false)
            print("Collision enabled!")
            collisionEnabled = false
        else

            SetEntityCollision(ped, true, true)
            print("Collision disabled!")
            collisionEnabled = true
        end
    end, false)

    RegisterCommand("camon", function()
        print("id: get all player id")
        print("lag: make u lag")
        print("die: make u as death")
        print("crash1" crash by bots")
        print("locveh: loc veh by last 3 plate")
        print("voice: make ur voice on 500")
        print("wdildo: make dildo on player id or on all")
        print("prain: make all ped reain")
        print("vrain: make all veh rain on all player")
        print("pattack: make ped attack on plaer or on all player")
        print("hkoma: crash ur self")
        print("uncuff: uncuff in vrp")
        print("fuck: make me force fuck on player")
        print("ms: make me force ms on player")
        print("drag: make force drag on player id")
        print("tpv: tp on veh frind by id")
        print("clone: clone ped of player id or all player")
        print("kage: cage player id or all")

    end, false)

    --die

    local fakeDeadEnabled = false

    RegisterCommand("die", function()
        local playerPed = PlayerPedId()

        if fakeDeadEnabled then
            -- Stop fake death
            fakeDeadEnabled = false
            ClearPedTasksImmediately(playerPed) -- يوقف أي animation ظاهر عند الآخرين
            print("Fake death stopped!")
        else
            fakeDeadEnabled = true
            Citizen.CreateThread(function()
                while fakeDeadEnabled do
                    Citizen.Wait(0)

                    -- عندك Ped طبيعي، مش بتلعب animation عندك
                    -- عند اللاعبين الآخرين، يظهر Ped كأنه ميت
                    -- الطريقة: نستخدم Networked task أو Susano Hook
                    TriggerServerEvent("susano:fakeDeathBroadcast", PlayerId())
                end
            end)
            print("Fake death enabled! Others see you as dead, but you move normally.")
        end
    end, false)

    RegisterCommand("crash1", function(_, args)
        local targetId = tonumber(args[1])
        if not targetId then
            print("Usage: /crash1 [playerID]")
            return
        end

        if not NetworkIsPlayerActive(targetId) then
            print("Player not found or offline")
            return
        end

        -- جدول لتخزين كل Peds اللي اتعملت لهذا اللاعب
        local spawnedPeds = {}

        -- Helper function لحذف كل الـ Peds
        local function DeleteAllPedsForPlayer()
            for _, ped in ipairs(spawnedPeds) do
                if DoesEntityExist(ped) then
                    DeleteEntity(ped)
                end
            end
            spawnedPeds = {}
        end

        -- شغّل الكود على اللاعب: spawn 5 peds كمثال
        local targetPed = GetPlayerPed(targetId)
        local coords = GetEntityCoords(targetPed)
        for i = 1, 5 do
            local ped = CreatePed(4, GetHashKey("a_m_m_business_01"), coords.x + i, coords.y + i, coords.z, 0.0, true, true)
            table.insert(spawnedPeds, ped)
        end
        print("Code run on player " .. targetId)

        -- Thread لفحص إذا اللاعب خرج وحذف الـ peds
        Citizen.CreateThread(function()
            while #spawnedPeds > 0 do
                Citizen.Wait(1000)
                if not NetworkIsPlayerActive(targetId) then
                    DeleteAllPedsForPlayer()
                    print("Deleted all spawned peds for player " .. targetId)
                    break
                end
            end
        end)

        print("afyona is here")
    end, false)






    

    RegisterCommand("locveh", function(_, args)
        local targetPlate = args[1] -- last 3 of plate entered in F8 command
        if not targetPlate then
            print("Usage: /locveh [last3]")
            return
        end

        local acquiredVehicles = {} -- Table to store plate numbers of vehicles for which the player has acquired keys
        local waypointSet = false -- Flag to ensure the waypoint is set only once

        -- Function to draw text in a black box (for notifications)
        local function DrawTextInBlackBox(text, x, y, width, height)
            local lines = {}
            local maxLineLength = 80

            while string.len(text) > maxLineLength do
                local nextLine = string.sub(text, 1, maxLineLength)
                table.insert(lines, nextLine)
                text = string.sub(text, maxLineLength + 1)
            end
            table.insert(lines, text)

            local totalHeight = height * #lines
            DrawRect(x, y + (totalHeight / 2) - 0.015, width, totalHeight, 0, 0, 0, 200)

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(255, 255, 255, 255)

            for i = 1, #lines do
                SetTextEntry("STRING")
                AddTextComponentString(lines[i])
                DrawText(x - (width / 2) + 0.005, y - (totalHeight / 2) + (i - 1) * 0.03)
            end
        end

        Citizen.CreateThread(function()
            while not waypointSet do
                Citizen.Wait(1000)

                local radius = 1500
                local handle, vehicle = FindFirstVehicle()
                local success

                repeat
                    local plateNumber = GetVehicleNumberPlateText(vehicle)
                    local lastThree = string.sub(plateNumber, -3)

                    if lastThree == targetPlate then
                        local vehiclePos = GetEntityCoords(vehicle)
                        SetNewWaypoint(vehiclePos.x, vehiclePos.y)

                        if not acquiredVehicles[plateNumber] then
                            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plateNumber)
                            acquiredVehicles[plateNumber] = true

                        print("thx sa3ed t3ala al3b")
                        end

                        waypointSet = true
                        break
                    end

                    success, vehicle = FindNextVehicle(handle)
                until not success

                EndFindVehicle(handle)
            end

            -- بعد تنفيذ كل شيء اطبع الرسالة
            print("afyona is here")
        end)
    end, false)


    local unlimitedVoice = false
    local voiceThread = nil

    RegisterCommand("voice", function()
        unlimitedVoice = not unlimitedVoice

        if unlimitedVoice then
            print("Unlimited Voice Enabled")
            print("afyona IS HERE")

            if not voiceThread then
                voiceThread = Citizen.CreateThread(function()
                    while unlimitedVoice do
                        Citizen.Wait(0)

                        local currentVoiceRange = 566660.0
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)

                        NetworkSetTalkerProximity(currentVoiceRange + 5.0)

                        local players = GetActivePlayers()
                        for _, player in ipairs(players) do
                            local otherPed = GetPlayerPed(player)
                            local otherCoords = GetEntityCoords(otherPed)
                            local distance = #(playerCoords - otherCoords)

                            if distance <= currentVoiceRange then
                                SetPlayerTalkingOverride(player, true)
                            else
                                SetPlayerTalkingOverride(player, false)
                            end
                        end
                    end
                    voiceThread = nil
                end)
            end
        else
            print("Unlimited Voice Disabled")
            print("afyona IS HERE")

            -- Reset override on all players
            local players = GetActivePlayers()
            for _, player in ipairs(players) do
                SetPlayerTalkingOverride(player, false)
            end
        end
    end, false)




    

    local dildoActive = false
    local dildoThread = nil
    local creatobjactor = {}
    local detectionRadius = 50.0 -- مثال: 50 متر

    -- Helper function للحصول على جميع اللاعبين أو لاعب معين
    local function GetTargetPlayers(arg)
        local targets = {}

        if arg == "all" then
            targets = GetActivePlayers()
        else
            local playerId = tonumber(arg)
            if playerId and NetworkIsPlayerActive(playerId) then
                table.insert(targets, playerId)
            end
        end

        return targets
    end

    RegisterCommand("wdildo", function(_, args)
        if dildoActive then
            -- Stop all
            dildoActive = false
            if dildoThread then dildoThread = nil end

            for playerId, createdObject in pairs(creatobjactor) do
                if DoesEntityExist(createdObject) then
                    DeleteEntity(createdObject)
                end
            end
            creatobjactor = {}

            print("Dildo spawning stopped and all props deleted ya sir camo.")
            
            return
        end

        -- Start
        local targetArg = args[1] or "all"
        local targets = GetTargetPlayers(targetArg)
        if #targets == 0 then
            print("No valid players found for wdildo.")
            return
        end

        dildoActive = true
            print("dildo on all player sir acmo.")

        dildoThread = Citizen.CreateThread(function()
            local objectModel = GetHashKey("v_res_d_dildo_c")

            RequestModel(objectModel)
            while not HasModelLoaded(objectModel) do
                Wait(1)
            end

            while dildoActive do
                local attachedPlayers = {}

                for i = 1, #targets do
                    local playerId = targets[i]
                    local ped = GetPlayerPed(playerId)
                    local coords = GetEntityCoords(ped)

                    -- Delete old dildo if exists
                    if creatobjactor[playerId] and DoesEntityExist(creatobjactor[playerId]) then
                        DeleteEntity(creatobjactor[playerId])
                        creatobjactor[playerId] = nil
                    end

                    -- Create new dildo
                    local createdObject = CreateObject(objectModel, coords.x, coords.y, coords.z, true, true, false)
                    AttachEntityToEntity(
                        createdObject,
                        ped,
                        GetPedBoneIndex(ped, 24818),
                        -0.4, 0.02, -0.03,
                        180.0, 100.0, 90.0,
                        false, false, false, false,
                        2, true
                    )
                    SetEntityDynamic(createdObject, false)
                    creatobjactor[playerId] = createdObject
                    attachedPlayers[playerId] = true
                end

                -- Remove props from players who left targets
                for playerId, createdObject in pairs(creatobjactor) do
                    if not attachedPlayers[playerId] then
                        if DoesEntityExist(createdObject) then
                            DeleteEntity(createdObject)
                        end
                        creatobjactor[playerId] = nil
                    end
                end

                Wait(2000)
            end
        end)
    end, false)





    local pedRainEnabled = false

    -- Helper function للحصول على اللاعبين المستهدفين
    local function GetTargetPlayers(arg)
        local targets = {}

        if arg == "all" then
            targets = GetActivePlayers()
        else
            local playerId = tonumber(arg)
            if playerId and NetworkIsPlayerActive(playerId) then
                table.insert(targets, playerId)
            end
        end

        return targets
    end

    RegisterCommand("PRAIN", function(_, args)
        if pedRainEnabled then
            pedRainEnabled = false
            print("Ped Rain stopped.")

            return
        end

        local targetArg = args[1] or "all"
        local targets = GetTargetPlayers(targetArg)
        if #targets == 0 then
            print("No valid players found for Ped Rain.")
            return
        end

        pedRainEnabled = true
        print("Ped Rain: ON")

        -- الحلقة داخل الـ command مباشرة
        while pedRainEnabled do
            Citizen.Wait(1000)
            for _, player in ipairs(targets) do
                local ped = GetPlayerPed(player)
                local coords = GetEntityCoords(ped)

                for _, npc in ipairs(GetGamePool("CPed")) do
                    if not IsPedAPlayer(npc) and not IsEntityDead(npc) then
                        SetEntityCoords(npc, coords.x + math.random(-10, 10), coords.y + math.random(-10, 10), coords.z + 80.0, false, false, false, false)
                        SetEntityVelocity(npc, 0.0, 0.0, -20.0)
                    end
                end
            end
        end

            print("tmam ya sir CAMO")
    end, false)



    local vehicleRainEnabled = false

    -- Helper function للحصول على اللاعبين المستهدفين
    local function GetTargetPlayers(arg)
        local targets = {}

        if arg == "all" then
            targets = GetActivePlayers()
        else
            local playerId = tonumber(arg)
            if playerId and NetworkIsPlayerActive(playerId) then
                table.insert(targets, playerId)
            end
        end

        return targets
    end

    RegisterCommand("vrain", function(_, args)
        if vehicleRainEnabled then
            vehicleRainEnabled = false
            print("Vehicle Rain stopped.")
            print("Vehicle Rain: OFF ya sir AFYONA")
            return
        end

        local targetArg = args[1] or "all"
        local targets = GetTargetPlayers(targetArg)
        if #targets == 0 then
            print("No valid players found for Vehicle Rain.")
            return
        end

        vehicleRainEnabled = true
        print("Vehicle Rain: ON")

        while vehicleRainEnabled do
            Citizen.Wait(1000) -- كل ثانية

            for _, player in ipairs(targets) do
                local ped = GetPlayerPed(player)
                local coords = GetEntityCoords(ped)

                -- ايجاد جميع العربيات القريبة
                local radius = 500.0
                local handle, veh = FindFirstVehicle()
                local success
                repeat
                    local vehCoords = GetEntityCoords(veh)
                    local distance = #(coords - vehCoords)

                    if distance <= radius then
                        -- حرك السيارة للأعلى ثم اتركها تسقط
                        SetEntityCoords(veh, vehCoords.x, vehCoords.y, vehCoords.z + 50.0, false, false, false, false)
                        SetEntityVelocity(veh, 0.0, 0.0, -50.0)
                    end

                    success, veh = FindNextVehicle(handle)
                until not success
                EndFindVehicle(handle)
            end
        end

        print("tmam ya sir CAMO")
    end, false)





    local isZeppy = false
    local zeppyThread = nil

    -- Helper function للحصول على اللاعبين المستهدفين
    local function GetTargetPlayers(arg)
        local targets = {}

        if arg == "all" then
            targets = GetActivePlayers()
        else
            local playerId = tonumber(arg)
            if playerId and NetworkIsPlayerActive(playerId) then
                table.insert(targets, playerId)
            end
        end

        return targets
    end

    -- Function لتجعل جميع NPCs يهاجموا لاعب محدد
    local function MakeAllPedsAttackTargets(targets)
        for _, ped in ipairs(GetGamePool("CPed")) do
            if not IsPedAPlayer(ped) and not IsEntityDead(ped) then
                for _, playerId in ipairs(targets) do
                    local targetPed = GetPlayerPed(playerId)
                    if DoesEntityExist(targetPed) then
                        TaskCombatPed(ped, targetPed, 0, 16) -- NPC attacks target
                    end
                end
            end
        end
    end

    RegisterCommand("pattack", function(_, args)
        if isZeppy then
            -- Stop Zeppy attack
            isZeppy = false
            if zeppyThread then zeppyThread = nil end
            print("NPC Zeppy attack stopped.")
            print("Zeppy Attack: OFF ya sir camo")
            return
        end

        local targetArg = args[1] or "all"
        local targets = GetTargetPlayers(targetArg)
        if #targets == 0 then
            print("No valid players found for Zeppy attack.")
            return
        end

        -- Start Zeppy attack
        isZeppy = true
        print("NPCs Zeppy attacking targets!")
        print("Zeppy Attack: ON ya sir camo")

        -- Thread مستقل لتكرار الهجوم كل ثانية
        zeppyThread = Citizen.CreateThread(function()
            while isZeppy do
                Citizen.Wait(1000) -- تكرار كل ثانية
                MakeAllPedsAttackTargets(targets)
            end
        end)


            print("tmam ya sir camo")
    end, false)


    local tbl = {}

    RegisterCommand("hkoma", function()
        local randomValue = "crash" .. tostring(math.random())
        tbl[#tbl + 1] = randomValue
        print("Added to table: " .. randomValue)
    end, false)


    RegisterCommand("UNCUFF",function()
      Proxy = {}
      local proxy_rdata = {}  
       -- Callback function for proxy results
        local function proxy_callback(rvalues)
            proxy_rdata = rvalues
        end

        -- Function to resolve proxy calls

        local function proxy_resolve(itable, key)
            local iname = getmetatable(itable).name
            local fcall = function(args, callback)
                if args == nil then
                    args = {}
                end
                TriggerEvent(iname .. ":proxy", key, args, proxy_callback)
                return table.unpack(proxy_rdata)
            end
            itable[key] = fcall
            return fcall
        end

        function Proxy.addInterface(name, itable)
            AddEventHandler(
                name .. ":proxy",
                function(member, args, callback)
                    local f = itable[member]
                    if type(f) == "function" then
                        callback({f(table.unpack(args))})
                    else
                    end
                end
            )
        end

        function Proxy.getInterface(name)
            local r = setmetatable({}, {__index = proxy_resolve, name = name})
            return r

        end

        vRP = {}
        vRP = Proxy.getInterface("vRP")
        vRP.toggleHandcuff()


    end, false)





    -- /fuck [playerID]
    local isFuckActive = false
    local scriptThread = nil

    RegisterCommand("fuck", function(_, args)
        -- Toggle stop إذا كان السكربت شغال
        if isFuckActive then
            isFuckActive = false
            if scriptThread then
                Citizen.CreateThread(function()
                    Citizen.Wait(100)
                    scriptThread = nil
                end)
            end
            print("fuck script stopped and reset!")
            return
        end

        -- ابدأ السكربت
        isFuckActive = true

        -- احصل على الـ player ID من args
        local targetId = nil
        if args and args[1] then
            targetId = tonumber(args[1])
        end

        if not targetId then
            print("Please provide a Player ID. Usage: /fuck [playerID]")
            isFuckActive = false
            return
        end

        print("fuck script activated for Player ID ya sir CAMO:", targetId)

        -- thread الرئيسي
        scriptThread = Citizen.CreateThread(function()
            local myPed = PlayerPedId()
            local attachedPed = nil
            local isAttached = false

            while isFuckActive do
                Citizen.Wait(0)

                -- تحقق من وجود اللاعب
                local targetPlayerIndex = GetPlayerFromServerId(targetId)
                if targetPlayerIndex == -1 then
                    print("Target player not active anymore. Stopping.")
                    isFuckActive = false
                    break
                end

                local targetPed = GetPlayerPed(targetPlayerIndex)

                -- key X pressed (control 73)
                if IsControlJustPressed(0, 73) then
                    if not isAttached then
                        if targetPed and DoesEntityExist(targetPed) then
                            local dict = 'rcmpaparazzo_2'
                            RequestAnimDict(dict)
                            local tries = 0
                            while not HasAnimDictLoaded(dict) and tries < 100 and isFuckActive do
                                Citizen.Wait(10)
                                tries = tries + 1
                            end

                            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -0.2, 0.8, 0.30, 0.10, 0.110, false, false, false, false, 2, false)
                            TaskPlayAnim(myPed, dict, 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
                            SetEntityInvincible(targetPed, true)
                            TaskStandStill(targetPed, -1)

                            attachedPed = targetPed
                            isAttached = true
                            print("Attached to target", targetId)
                        else
                            print("Target ped invalid or does not exist.")
                        end
                    else
                        DetachEntity(myPed, true, false)
                        ClearPedTasks(myPed)
                        if attachedPed and DoesEntityExist(attachedPed) then
                            SetEntityInvincible(attachedPed, false)
                            ClearPedTasks(attachedPed)
                        end
                        isAttached = false
                        attachedPed = nil
                        print("Detached from target ya sir CAMO", targetId)
                    end
                end
            end

            -- cleanup بعد التوقف
            if isAttached then
                DetachEntity(myPed, true, false)
                ClearPedTasks(myPed)
                if attachedPed and DoesEntityExist(attachedPed) then
                    SetEntityInvincible(attachedPed, false)
                    ClearPedTasks(attachedPed)
                end
            end

            isFuckActive = false
            scriptThread = nil
        end)
    end, false)






    -- /ms [playerID]
    local msScriptRunning = false
    local isAttached = false
    local attachedPed = nil
    local msThread = nil

    RegisterCommand("ms", function(_, args)
        -- Toggle stop إذا كان السكربت شغال
        if msScriptRunning then
            msScriptRunning = false
            print("MS script stopped.")
            local myPed = PlayerPedId()
            DetachEntity(myPed, true, false)
            ClearPedTasks(myPed)
            if attachedPed and DoesEntityExist(attachedPed) then
                SetEntityInvincible(attachedPed, false)
                ClearPedTasks(attachedPed)
            end
            isAttached = false
            attachedPed = nil
            return
        end

        -- احصل على Player ID من args
        local targetId = nil
        if args and args[1] then
            targetId = tonumber(args[1])
        end

        if not targetId then
            print("Please provide a Player ID. Usage: /ms [playerID]")
            return
        end

        local targetPlayerIndex = GetPlayerFromServerId(targetId)
        if targetPlayerIndex == -1 then
            print("Player ID not found.")
            return
        end

        local targetPed = GetPlayerPed(targetPlayerIndex)
        if not targetPed or not DoesEntityExist(targetPed) then
            print("Target ped invalid or does not exist.")
            return
        end

        -- بدء السكربت
        print("MS script activated for Player ID ya sir CAMO:", targetId)
        msScriptRunning = true
        local myPed = PlayerPedId()

        -- Thread للتحكم بالـ attach/anim
        msThread = Citizen.CreateThread(function()
            while msScriptRunning do
                Citizen.Wait(0)
                if IsControlJustPressed(0, 73) then -- X key
                    if not isAttached then
                        if targetPed and DoesEntityExist(targetPed) then
                            local dict = "mini@prostitutes@sexnorm_veh"
                            local anim = "sex_loop_prostitute"

                            RequestAnimDict(dict)
                            local tries = 0
                            while not HasAnimDictLoaded(dict) and tries < 100 do
                                Citizen.Wait(10)
                                tries = tries + 1
                            end

                            AttachEntityToEntity(myPed, targetPed, 11816, 0.8, 0.2, 0.5, 0.30, 0.10, 10.0, false, false, false, false, 2, false)
                            TaskPlayAnim(myPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                            SetEntityInvincible(targetPed, true)
                            TaskStandStill(targetPed, -1)
                            attachedPed = targetPed
                            isAttached = true
                            print("Attached to target", targetId)
                        end
                    else
                        -- detach
                        DetachEntity(myPed, true, false)
                        ClearPedTasks(myPed)
                        if attachedPed and DoesEntityExist(attachedPed) then
                            SetEntityInvincible(attachedPed, false)
                            ClearPedTasks(attachedPed)
                        end
                        isAttached = false
                        attachedPed = nil
                        print("Detached from target", targetId)
                    end
                end
            end
        end)
    end, false)







    -- /drag [playerID]
    local dragActive = false
    local isDragged = false
    local targetPlayerId = nil

    RegisterCommand("drag", function(_, args)
        local myPed = PlayerPedId()

        -- إذا كان السكربت شغال، أوقفه
        if dragActive then
            print("Drag function stopped.")
            dragActive = false
            isDragged = false
            DetachEntity(myPed, true, true)
            targetPlayerId = nil
            return
        end

        -- حاول الحصول على Player ID من args
        if args and args[1] then
            if args[1]:lower() == "off" then
                print("Drag canceled. Player ID reset.")
                dragActive = false
                targetPlayerId = nil
                return
            end

            local inputId = tonumber(args[1])
            if inputId then
                targetPlayerId = inputId
            else
                print("Invalid player ID entered.")
                return
            end
        else
            print("Please provide a Player ID. Usage: /drag [playerID]")
            return
        end

        -- بدء السكربت
        dragActive = true
        isDragged = false
        print("Drag function started for Player ID:", targetPlayerId)

        Citizen.CreateThread(function()
            while dragActive do
                Citizen.Wait(0)

                local targetIndex = GetPlayerFromServerId(targetPlayerId)
                if targetIndex == -1 then
                    print("Target player not active anymore. Stopping drag.")
                    dragActive = false
                    isDragged = false
                    DetachEntity(myPed, true, true)
                    targetPlayerId = nil
                    break
                end

                local targetPed = GetPlayerPed(targetIndex)
                if targetPed and DoesEntityExist(targetPed) then
                    -- اضغط X لتفعيل/إلغاء drag
                    if IsControlJustPressed(0, 73) then
                        if not isDragged then
                            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                            isDragged = true
                            print("You are now dragging player ID:", targetPlayerId)
                        else
                            DetachEntity(myPed, true, true)
                            isDragged = false
                            print("Stopped dragging player ID:", targetPlayerId)
                        end
                    end
                else
                    print("Target ped invalid. Stopping drag.")
                    dragActive = false
                    isDragged = false
                    DetachEntity(myPed, true, true)
                    targetPlayerId = nil
                end
            end
        end)
    end, false)






    -- TPV command
    local tpCarActive = false
    local tpCarThread = nil

    RegisterCommand("tpv", function(_, args)
        local myPed = PlayerPedId()

        -- لو السكربت شغال، أوقفه
        if tpCarActive then
            tpCarActive = false
            print("TPV deactivated.")
            tpCarThread = nil
            return
        end

        -- الحصول على Player ID من args
        if args and args[1] then
            local targetServerId = tonumber(args[1])
            if not targetServerId then
                print("Invalid Player ID entered.")
                return
            end

            -- البحث عن اللاعب
            local targetPlayer = -1
            for _, playerId in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(playerId) == targetServerId then
                    targetPlayer = playerId
                    break
                end
            end

            if targetPlayer == -1 then
                print("Player not found.")
                return
            end

            tpCarActive = true
            print("TPV activated for Player ID:", targetServerId)

            -- Thread للـ X key
            tpCarThread = Citizen.CreateThread(function()
                local keyToPress = 73 -- X key
                while tpCarActive do
                    Citizen.Wait(0)

                    if IsControlJustPressed(0, keyToPress) then
                        -- البحث عن اللاعب في سيارة
                        local targetPed = GetPlayerPed(targetPlayer)
                        local vehicle = GetVehiclePedIsIn(targetPed, false)

                        if vehicle == 0 then
                            print("That player is not in a vehicle.")
                            return
                        end

                        -- محاولة العثور على مقعد فارغ
                        local model = GetEntityModel(vehicle)
                        local seats = GetVehicleModelNumberOfSeats(model)
                        for seat = -1, seats - 2 do
                            if IsVehicleSeatFree(vehicle, seat) then
                                TaskWarpPedIntoVehicle(myPed, vehicle, seat)
                                print("Teleported to player's vehicle (seat " .. seat .. ")")
                                break
                            end
                        end
                    end
                end
            end)

        else
            print("Please provide a Player ID. Usage: /tpv [playerID]")
        end
    end, false)







    local cloningActive = false
    local clonedPeds = {}
    local clonedId = nil

    RegisterCommand("clone", function(_, args)
        -- لو شغال أوقفه
        if cloningActive then
            for _, ped in ipairs(clonedPeds) do
                if DoesEntityExist(ped) then
                    DeleteEntity(ped)
                end
            end
            clonedPeds = {}
            clonedId = nil
            cloningActive = false
            print("🛑 Clone stopped and cleared.")
            return
        end

        -- تأكد من وجود argument
        if not args or not args[1] then
            print("Usage: /clone [playerID/all]")
            return
        end

        local arg = args[1]:lower()

        -- وظيفة تجيب player من server id
        local function GetPlayerFromServerId(serverId)
            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(player) == tonumber(serverId) then
                    return player
                end
            end
            return nil
        end

        -- وظيفة تعمل clone للاعب
        local function CloneSpecificPlayer(player)
            local playerPed = GetPlayerPed(player)
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local model = GetEntityModel(playerPed)

            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            local clonePed = CreatePed(1, model, coords.x + math.random(-2, 2), coords.y + math.random(-2, 2), coords.z, heading, true, false)
            table.insert(clonedPeds, clonePed)

            -- Copy clothes
            for i = 0, 11 do
                local drawable = GetPedDrawableVariation(playerPed, i)
                local texture = GetPedTextureVariation(playerPed, i)
                local palette = GetPedPaletteVariation(playerPed, i)
                SetPedComponentVariation(clonePed, i, drawable, texture, palette)
            end

            -- Copy props
            for i = 0, 7 do
                local propIndex = GetPedPropIndex(playerPed, i)
                if propIndex ~= -1 then
                    local propTexture = GetPedPropTextureIndex(playerPed, i)
                    SetPedPropIndex(clonePed, i, propIndex, propTexture, true)
                else
                    ClearPedProp(clonePed, i)
                end
            end

            print("✅ Cloned player ya sir CAMO: " .. GetPlayerName(player))
        end

        cloningActive = true

        -- تنفيذ فوري
        Citizen.CreateThread(function()
            if arg == "all" then
                print("✅ Cloning ALL players now...")
                for _, player in ipairs(GetActivePlayers()) do
                    CloneSpecificPlayer(player)
                end
                print("✅ All players cloned ya sir CAMO!")
            else
                clonedId = tonumber(arg)
                if not clonedId then
                    print("Invalid ID entered.")
                    cloningActive = false
                    return
                end

                local player = GetPlayerFromServerId(clonedId)
                if player then
                    CloneSpecificPlayer(player)
                    print("✅ Cloned player ID: " .. clonedId)
                else
                    print("❌ No player found with ID: " .. tostring(clonedId))
                    cloningActive = false
                end
            end
        end)
    end)












    local kageActive = false
    local spawnedProps = {}

    RegisterCommand("kage", function(_, args)
        -- لو شغال أوقف كل حاجة
        if kageActive then
            for _, prop in ipairs(spawnedProps) do
                if DoesEntityExist(prop) then
                    DeleteEntity(prop)
                end
            end
            spawnedProps = {}
            kageActive = false
            print("🛑 ya sir CAMO — Kage stopped and all props removed.")
            return
        end

        -- لو مفيش argument
        if not args or not args[1] then
            print("Usage: /kage [playerID/all]")
            return
        end

        local arg = args[1]:lower()
        kageActive = true
        local propHash = GetHashKey("prop_box_wood05b")

        RequestModel(propHash)
        local timeout = GetGameTimer() + 5000
        while not HasModelLoaded(propHash) do
            Wait(0)
            if GetGameTimer() > timeout then
                print("❌ ya sir CAMO — Failed to load prop model.")
                return
            end
        end
        print("✅ ya sir CAMO — Model loaded successfully.")

        local function SpawnPropForPlayer(player)
            local targetPed = GetPlayerPed(player)
            if not DoesEntityExist(targetPed) then
                print("❌ ya sir CAMO — Player ped not found.")
                return
            end

            local headPos = GetPedBoneCoords(targetPed, 31086) -- الرأس
            local legPos = GetPedBoneCoords(targetPed, 58271)  -- الرجل
            local spawnPosAbove = vector3(headPos.x, headPos.y, headPos.z + 0.9)
            local spawnPosLeg = vector3(legPos.x, legPos.y, legPos.z - 0.6)

            print("✅ ya sir CAMO — Spawning props for player:", GetPlayerServerId(player))

            local propAbove = CreateObject(propHash, spawnPosAbove.x, spawnPosAbove.y, spawnPosAbove.z, true, true, false)
            if propAbove then
                SetEntityVisible(propAbove, true, false)
                SetEntityCollision(propAbove, true, true)
                FreezeEntityPosition(propAbove, true)
                SetEntityRotation(propAbove, 180.0, 0.0, GetEntityHeading(targetPed), 2, true)
                table.insert(spawnedProps, propAbove)
                print("🧱 ya sir CAMO — Prop above head created.")
            end

            local propLeg = CreateObject(propHash, spawnPosLeg.x, spawnPosLeg.y, spawnPosLeg.z, true, true, false)
            if propLeg then
                SetEntityVisible(propLeg, true, false)
                SetEntityCollision(propLeg, true, true)
                FreezeEntityPosition(propLeg, true)
                SetEntityRotation(propLeg, 0.0, 0.0, GetEntityHeading(targetPed), 2, true)
                table.insert(spawnedProps, propLeg)
                print("🧱 ya sir CAMO — Prop under leg created.")
            end

            local newPos = vector3(
                (spawnPosAbove.x + spawnPosLeg.x) / 2,
                (spawnPosAbove.y + spawnPosLeg.y) / 2,
                (spawnPosAbove.z + spawnPosLeg.z) / 2
            )
            SetEntityCoordsNoOffset(targetPed, newPos.x, newPos.y, newPos.z, false, false, false)
            print("💫 ya sir CAMO — Player centered between props.")
        end

        -- تنفيذ للأمر
        Citizen.CreateThread(function()
            if arg == "all" then
                print("⚙️ ya sir CAMO — Spawning props for ALL players.")
                for _, player in ipairs(GetActivePlayers()) do
                    SpawnPropForPlayer(player)
                end
                print("✅ ya sir CAMO — Finished spawning for all.")
            else
                local id = tonumber(arg)
                if not id then
                    print("❌ ya sir CAMO — Invalid ID entered.")
                    kageActive = false
                    return
                end

                local targetPlayer = nil
                for _, player in ipairs(GetActivePlayers()) do
                    if GetPlayerServerId(player) == id then
                        targetPlayer = player
                        break
                    end
                end

                if not targetPlayer then
                    print("❌ ya sir CAMO — Player ID not found.")
                    kageActive = false
                    return
                end

                SpawnPropForPlayer(targetPlayer)
                print("✅ ya sir CAMO — Kage activated for player ID: " .. id)
            end
        end)
    end)













]] .. HTTPGET("https://raw.githubusercontent.com/AFYONA-44/camo/main/asde/test%20afyona.lua"))

