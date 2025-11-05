-- Susano Executor
-- Write your Lua code here
-- AFYONA MENU (Susano Edition v11) - FULL with Online Trolls
-- by Youssef
-- Includes: clone, freeze, explode, ragdoll, fuck(attach), cage, tp_car_teleport, tp_all_car_on_player

----------------------------------
-- المتغيرات الأساسية
----------------------------------
local menuVisible, menuUnlocked, inputting = false, false, false
local activeTab = 1
local superJump, invisible = false, false
local nearbyPlayers, selectedPlayer = {}, nil
local playerTroll = {}
local selectedServer = nil
local isDragging, dragStartX, dragStartY = false, 0, 0
local dragOffsetX, dragOffsetY = 0, 0
local menuX, menuY = 460, 240
local mw, mh = 900, 700
local crashAllPedsList = {}
local crashAllActive = false
local activeToggles = {}
local superJump = false
local invisible = false
local fakeDeadEnabled = false
local lagSelf = false
local superJumpThread = nil
local lagThread = nil
local fakeDeathThread = nil
local msScriptRunning = false
local isAttached = false
local attachedPed = nil
local isAttacking = false
local targetPlayerPed = nil
local currentPlayerID = nil

local dragActive = false
local isDragged = false


-- Tabs
local tabs = {
    "Self","Online","Crash","Destroy","Camo","Anti","Server"
}

----------------------------------
-- Trolls setup (UI list)
----------------------------------
local trollOptions = {
    { name = "Clone Player", id = "clone" },
    { name = "Freeze Player", id = "freeze" },
    { name = "Explode Player", id = "explode" },
    { name = "Ragdoll Player", id = "ragdoll" },
    { name = "Fuck (attach)", id = "fuck" },
    { name = "Cage", id = "cage" },
    { name = "TP to Player Car", id = "tp_car_teleport" },
    { name = "TP All Cars on Player", id = "tp_all_car_on_player" },
    { name = "Set on Fire", id = "fire" },
    {name="ms", id="MS_Troll"},
}

----------------------------------
-- Servers setup
----------------------------------
local serversList = {
    {
        name = "Hot",
        actions = {
            { label = "Revive All", trigger = "hot:reviveAll" },
            { label = "Clear All",  trigger = "hot:clearAll"  },
            { label = "Godmode",    trigger = "hot:godmode"   },
        }
    },
    {
        name = "Red",
        actions = {
            { label = "Announce", trigger = "red:announce" },
            { label = "Freeze",   trigger = "red:freeze"   },
        }
    }
}

----------------------------------
-- Resource Management
----------------------------------
local resourcesList = {}
local selectedResource = nil
local injectResourceActive = false

function AddResource(name)
    table.insert(resourcesList,{name=name,trolls={},natives={}})
end

-- sample resources
AddResource("MyResource1")
AddResource("MyResource2")

----------------------------------
-- Helpers
----------------------------------
local function ShowNotification(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentString(text)
    EndTextCommandThefeedPostTicker(false, true)
end

local function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, veh = FindFirstVehicle()
        if not handle or handle == -1 then return end
        local finished = false
        repeat
            coroutine.yield(veh)
            finished, veh = FindNextVehicle(handle)
        until not finished
        EndFindVehicle(handle)
    end)
end

function GetNearbyPlayers(radius)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local list = {}
    for _, id in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(id)
        if ped ~= myPed and DoesEntityExist(ped) then
            local dist = #(GetEntityCoords(ped) - myCoords)
            if dist <= radius then
                table.insert(list, {id=id, name=GetPlayerName(id), dist=math.floor(dist)})
            end
        end
    end
    return list
end

-- Toggle troll per resource or per-player
function ToggleTroll(targets, trollId)
    if injectResourceActive and selectedResource then
        local res = resourcesList[selectedResource]
        res.trolls = res.trolls or {}
        res.trolls[trollId] = not (res.trolls[trollId] or false)
        return res.trolls[trollId]
    else
        if type(targets)=="table" then
            for _, id in ipairs(targets) do
                playerTroll[id] = playerTroll[id] or {}
                playerTroll[id][trollId] = not (playerTroll[id][trollId] or false)
            end
            return true
        elseif targets then
            playerTroll[targets] = playerTroll[targets] or {}
            playerTroll[targets][trollId] = not (playerTroll[targets][trollId] or false)
            return playerTroll[targets][trollId]
        end
    end
    return false
end

function IsTrollActive(targets, trollId)
    if injectResourceActive and selectedResource then
        local res = resourcesList[selectedResource]
        return res.trolls and res.trolls[trollId]
    else
        if type(targets)=="table" then
            for _, id in ipairs(targets) do
                if playerTroll[id] and playerTroll[id][trollId] then return true end
            end
            return false
        elseif targets then
            return playerTroll[targets] and playerTroll[targets][trollId]
        end
        return false
    end
end

function HookNativeExample(nativeName)
    if injectResourceActive and selectedResource then
        local res = resourcesList[selectedResource]
        res.natives = res.natives or {}
        res.natives[nativeName] = true
    else
        print("Native executed: "..nativeName)
    end
end

----------------------------------
-- Crash Peds


----------------------------------
-- TrollState and implementations
----------------------------------
local TrollState = {
    fuck = {},       -- pid -> {running=true, attached=false}
    cage = {},       -- pid -> {above=ent, leg=ent}
    tp_car = {},     -- pid -> {active=true}
    tp_allcars = {}, -- pid -> {active=true}
}

-- FUCK (attach/detach with X)
local function HandleFuckModeForPid(pid)
    if not pid then return end
    local key = tostring(pid)
    local cur = TrollState.fuck[key]
    if not cur or not cur.running then
        TrollState.fuck[key] = { running = true, attached = false }
        ShowNotification("Fuck mode enabled for " .. tostring(pid) .. " (press X)")
        CreateThread(function()
            local myPed = PlayerPedId()
            local targetPed = GetPlayerPed(pid)
            while TrollState.fuck[key] and TrollState.fuck[key].running do
                Wait(0)
                if IsControlJustPressed(0,73) then -- X
                    if not TrollState.fuck[key].attached then
                        RequestAnimDict('rcmpaparazzo_2')
                        while not HasAnimDictLoaded('rcmpaparazzo_2') do Wait(0) end
                        AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -0.2, 0.8, 0.30, 0.10, 0.110, false, false, false, false, 2, false)
                        TaskPlayAnim(myPed, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
                        SetEntityInvincible(targetPed, true)
                        TaskStandStill(targetPed, -1)
                        TrollState.fuck[key].attached = true
                        ShowNotification("Attached to target (X to detach)")
                    else
                        DetachEntity(myPed, true, false)
                        ClearPedTasks(myPed)
                        SetEntityInvincible(targetPed, false)
                        ClearPedTasks(targetPed)
                        TrollState.fuck[key].attached = false
                        ShowNotification("Detached")
                    end
                end
            end
            TrollState.fuck[key] = nil
        end)
    else
        TrollState.fuck[key].running = false
        TrollState.fuck[key] = nil
        ShowNotification("Fuck mode disabled for " .. tostring(pid))
    end
end

--pedhtnec
-- Function for NPC attack with minigun
function HandleNPCAttack(targetPlayerId)
    if isAttacking then
        isAttacking = false
        targetPlayerPed = nil
        currentPlayerID = nil
        print("NPC attack stopped and reset.")
    else
        if not targetPlayerId then
            ShowNotification("No player selected!")
            return
        end

        local targetPlayer = GetPlayerFromServerId(targetPlayerId)
        if targetPlayer == -1 then
            ShowNotification("Invalid player selected.")
            return
        end

        targetPlayerPed = GetPlayerPed(targetPlayer)
        if DoesEntityExist(targetPlayerPed) then
            -- Native call
            MakePedsAttackPlayerWithMinigun(targetPlayerPed)
            isAttacking = true
            currentPlayerID = targetPlayerId
        else
            ShowNotification("Target player ped does not exist.")
        end
    end
end
-- Function for Dragging a player
function HandleDrag(targetPlayerId)
    if dragActive then
        print("Drag function stopped.")
        dragActive = false
        isDragged = false
        DetachEntity(PlayerPedId(), true, true)
    else
        if not targetPlayerId then
            ShowNotification("No player selected.")
            return
        end

        local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayerId))
        if DoesEntityExist(targetPed) then
            print("Drag function started.")
            dragActive = true
            isDragged = false

            local myPed = PlayerPedId()
            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -0.4, 0.5, 0.0, 0.0, 180.0, false, false, false, false, 2, false)
            TaskPlayAnim(myPed, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
        else
            ShowNotification("Invalid target ped.")
        end
    end
end

-- CAGE
local function HandleCageForPid(pid)
    if not pid then return end
    local key = tostring(pid)
    local ent = TrollState.cage[key]
    local targetPed = GetPlayerPed(pid)
    if not ent then
        local propHash = GetHashKey("prop_box_wood05b")
        RequestModel(propHash)
        local timeout = GetGameTimer() + 3000
        while not HasModelLoaded(propHash) and GetGameTimer() < timeout do Wait(0) end
        if not HasModelLoaded(propHash) then ShowNotification("Failed to load prop") return end

        local headPos = GetPedBoneCoords(targetPed, 31086)
        local legPos = GetPedBoneCoords(targetPed, 58271)
        local abovePos = vector3(headPos.x, headPos.y, headPos.z + 0.9)
        local legBoxPos = vector3(legPos.x, legPos.y, legPos.z - 0.6)

        local propAbove = CreateObject(propHash, abovePos.x, abovePos.y, abovePos.z, true, true, false)
        if propAbove then
            FreezeEntityPosition(propAbove, true)
            SetEntityCollision(propAbove, true, true)
            SetEntityVisible(propAbove, true, false)
            SetEntityRotation(propAbove, 180.0, 0.0, GetEntityHeading(targetPed), 2, true)
        end

        local propLeg = CreateObject(propHash, legBoxPos.x, legBoxPos.y, legBoxPos.z, true, true, false)
        if propLeg then
            FreezeEntityPosition(propLeg, true)
            SetEntityCollision(propLeg, true, true)
            SetEntityVisible(propLeg, true, false)
            SetEntityRotation(propLeg, 0.0, 0.0, GetEntityHeading(targetPed), 2, true)
        end

        local newPos = vector3((abovePos.x + legBoxPos.x)/2, (abovePos.y + legBoxPos.y)/2, (abovePos.z + legBoxPos.z)/2)
        SetEntityCoordsNoOffset(targetPed, newPos.x, newPos.y, newPos.z, false, false, false)
        TrollState.cage[key] = {above = propAbove, leg = propLeg}
        ShowNotification("Cage created for " .. tostring(pid))
    else
        if ent.above and DoesEntityExist(ent.above) then DeleteEntity(ent.above) end
        if ent.leg and DoesEntityExist(ent.leg) then DeleteEntity(ent.leg) end
        TrollState.cage[key] = nil
        ShowNotification("Cage removed for " .. tostring(pid))
    end
end

-- TP to player's car (press X inside loop)
local function HandleTPToCarForPid(pid)
    if not pid then return end
    local key = tostring(pid) .. "_tpcar"
    if not TrollState.tp_car[key] then
        TrollState.tp_car[key] = { active = true }
        ShowNotification("TP-to-car active for " .. tostring(pid) .. " (press X)")
        CreateThread(function()
            local myPed = PlayerPedId()
            local targetPed = GetPlayerPed(pid)
            while TrollState.tp_car[key] and TrollState.tp_car[key].active do
                Wait(0)
                if IsControlJustPressed(0,73) then -- X
                    if IsPedInAnyVehicle(targetPed, false) then
                        local vehicle = GetVehiclePedIsIn(targetPed, false)
                        local model = GetEntityModel(vehicle)
                        local seats = GetVehicleModelNumberOfSeats(model)
                        local found = false
                        for seat = -1, seats - 2 do
                            if IsVehicleSeatFree(vehicle, seat) then
                                TaskWarpPedIntoVehicle(myPed, vehicle, seat)
                                ShowNotification("Teleported into player's vehicle (seat " .. tostring(seat) .. ")")
                                found = true
                                break
                            end
                        end
                        if not found then ShowNotification("No free seat available") end
                    else
                        ShowNotification("Target not in vehicle")
                    end
                end
            end
            TrollState.tp_car[key] = nil
        end)
    else
        TrollState.tp_car[key].active = false
        TrollState.tp_car[key] = nil
        ShowNotification("TP-to-car disabled for " .. tostring(pid))
    end
end

-- TP All Cars onto player in loop
local function HandleTPAllCarsForPid(pid)
    if not pid then return end
    local key = tostring(pid) .. "_tpallcars"
    if not TrollState.tp_allcars[key] then
        TrollState.tp_allcars[key] = { active = true }
        ShowNotification("TP All Cars enabled for " .. tostring(pid))
        CreateThread(function()
            local targetPed = GetPlayerPed(pid)
            while TrollState.tp_allcars[key] and TrollState.tp_allcars[key].active do
                Wait(1000)
                if not DoesEntityExist(targetPed) then break end
                local targetCoords = GetEntityCoords(targetPed)
                for veh in EnumerateVehicles() do
                    if DoesEntityExist(veh) then
                        local vehCoords = GetEntityCoords(veh)
                        local dist = #(vehCoords - targetCoords)
                        if dist <= 500.0 then
                            local offsetX = (math.random(-50,50))/10
                            local offsetY = (math.random(-50,50))/10
                            local newCoords = vector3(targetCoords.x + offsetX, targetCoords.y + offsetY, targetCoords.z + 1.0)
                            SetEntityCoords(veh, newCoords.x, newCoords.y, newCoords.z, false, false, false, true)
                            SetEntityVelocity(veh, 0.0, 0.0, 0.0)
                        end
                    end
                end
            end
            TrollState.tp_allcars[key] = nil
            ShowNotification("TP All Cars stopped for " .. tostring(pid))
        end)
    else
        TrollState.tp_allcars[key].active = false
        TrollState.tp_allcars[key] = nil
        ShowNotification("TP All Cars disabled for " .. tostring(pid))
    end
end


function HandleTrollMS(targetPlayer)
    local myPed = PlayerPedId()
    local targetPed = GetPlayerPed(targetPlayer)
    
    if GetPlayerName(targetPlayer) ~= "mos_zeby" then return end

    if msScriptRunning then
        msScriptRunning = false
        if isAttached then
            DetachEntity(myPed, true, false)
            ClearPedTasks(myPed)
            ClearPedTasks(targetPed)
            SetEntityInvincible(targetPed, false)
            isAttached = false
            attachedPed = nil
        end
        return
    end

    msScriptRunning = true
    Citizen.CreateThread(function()
        while msScriptRunning do
            Wait(0)
            if IsControlJustPressed(0,74) then -- Key to trigger attach/detach
                if not isAttached then
                    RequestAnimDict("mini@prostitutes@sexnorm_veh")
                    while not HasAnimDictLoaded("mini@prostitutes@sexnorm_veh") do Wait(0) end
                    AttachEntityToEntity(myPed, targetPed, 11816, 0.8, 0.2, 0.5, 0.30, 0.10, 10.0, false, false, false, false, 2, false)
                    TaskPlayAnim(myPed, "mini@prostitutes@sexnorm_veh", "sex_loop_prostitute", 8.0, -8.0, -1, 1, 0, false, false, false)
                    SetEntityInvincible(targetPed, true)
                    TaskStandStill(targetPed, -1)
                    isAttached = true
                else
                    DetachEntity(myPed, true, false)
                    ClearPedTasks(myPed)
                    SetEntityInvincible(targetPed, false)
                    ClearPedTasks(targetPed)
                    isAttached = false
                end
            end
        end
    end)
end
-- Simple trolls
local function HandleSimpleTroll(optId, pid)
    if not pid then return end
    local ped = GetPlayerPed(pid)
    if not DoesEntityExist(ped) then return end
    if optId == "explode" then
        local c = GetEntityCoords(ped)
        AddExplosion(c.x, c.y, c.z, 2, 1.0, true, false, 0.0, false)
    elseif optId == "ragdoll" then
        SetPedToRagdoll(ped, 3000, 3000, 0, false, false, false)
    elseif optId == "freeze" then
        FreezeEntityPosition(ped, true)
        CreateThread(function() Wait(3000) if DoesEntityExist(ped) then FreezeEntityPosition(ped, false) end end)
    elseif optId == "clone" then
        local model = GetEntityModel(ped)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end
        local c = GetEntityCoords(ped)
        local clone = CreatePed(4, model, c.x + 1.0, c.y + 1.0, c.z, 0.0, true, false)
        SetModelAsNoLongerNeeded(model)
    elseif optId == "fire" then
        StartEntityFire(ped)
    end
end

-- Apply troll to single or everyone
function TrollPlayerOrAll(optId, target)
    if not target then return end

    if target == "ALL_PLAYERS" then
        local list = GetNearbyPlayers(500)
        for _, p in ipairs(list) do
            local pid = p.id
            if optId == "ms" then
                HandleTrollMS(pid)
            elseif optId == "fuck" then
                HandleFuckModeForPid(pid)
            elseif optId == "cage" then
                HandleCageForPid(pid)
            elseif optId == "tp_car_teleport" then
                HandleTPToCarForPid(pid)
            elseif optId == "tp_all_car_on_player" then
                HandleTPAllCarsForPid(pid)
            else
                HandleSimpleTroll(optId, pid)
            end
        end
    else
        local pid = target
        if optId == "ms" then
            HandleTrollMS(pid)
        elseif optId == "fuck" then
            HandleFuckModeForPid(pid)
        elseif optId == "cage" then
            HandleCageForPid(pid)
        elseif optId == "tp_car_teleport" then
            HandleTPToCarForPid(pid)
        elseif optId == "tp_all_car_on_player" then
            HandleTPAllCarsForPid(pid)
        else
            HandleSimpleTroll(optId, pid)
        end
    end
end

----------------------------------
-- Drawing helpers
----------------------------------
local function drawTabBar()
    local tabW = mw/#tabs
    for i,name in ipairs(tabs) do
        local tx = menuX+(i-1)*tabW
        local active = (i==activeTab)
        local c = active and {0.55,0,0.85,0.8} or {0.18,0.18,0.18,0.85}
        Susano.DrawRectFilled(tx,menuY+70,tabW,35,table.unpack(c))
        if active then Susano.DrawRectFilled(tx,menuY+105,tabW,5,0.8,0.3,1,1) end
        Susano.DrawText(tx+tabW/2-25,menuY+82,name,16,1,1,1,1)
    end
end

local function DrawResourceTab()
    local listX, listY = menuX + 10, menuY + 160
    local listW, listH = 250, mh - 180
    Susano.DrawRectFilled(listX,listY,listW,listH,0.1,0.1,0.1,0.9)
    Susano.DrawText(listX+10, listY-25, "Resources", 16,1,1,1,1)

    local yOff = 0
    for i, res in ipairs(resourcesList) do
        local isSel = (selectedResource == i)
        local col = isSel and {0,1,0,1} or {1,1,1,1}
        Susano.DrawText(listX+10, listY+10+yOff, res.name, 15, table.unpack(col))
        yOff = yOff + 22
    end

    if selectedResource then
        local rx, ry = listX + listW + 20, listY
        local rw, rh = mw - listW - 50, listH
        Susano.DrawRectFilled(rx, ry, rw, rh, 0.12,0.12,0.12,0.9)
        Susano.DrawText(rx+10, ry-25, resourcesList[selectedResource].name.." Actions", 16,1,1,1,1)
        local btnY = ry + 50
        local actLabel = (injectResourceActive and selectedResource) and "Deactivate Inject" or "Activate Inject"
        Susano.DrawRectFilled(rx+10, btnY, 220, 30, 0.25,0.25,0.25,0.9)
        Susano.DrawText(rx+20, btnY+7, actLabel, 15, 1,1,1,1)
        btnY = btnY + 50
        Susano.DrawText(rx+10, btnY-20, "Assigned Trolls:", 14,1,1,1,1)
        local yy = btnY
        local res = resourcesList[selectedResource]
        for tid, val in pairs(res.trolls or {}) do
            Susano.DrawText(rx+20, yy, "- " .. tid .. (val and " (ON)" or " (OFF)"), 13,1,1,1,1)
            yy = yy + 18
        end
        yy = yy + 6
        Susano.DrawText(rx+10, yy, "Assigned Natives:", 14,1,1,1,1)
        yy = yy + 20
        for nid, val in pairs(res.natives or {}) do
            Susano.DrawText(rx+20, yy, "- " .. nid, 13,1,1,1,1)
            yy = yy + 18
        end
    end
end

----------------------------------
-- Draw Full Menu
----------------------------------
function DrawAfyonMenu()
    Susano.BeginFrame()
    local sw, sh = 1920,1080
    Susano.DrawRectFilled(0,0,sw,sh,0,0,0,0.45)
    Susano.DrawRectFilled(menuX,menuY,mw,mh,0.08,0.08,0.08,0.95)

    -- Title bar
    Susano.DrawRectFilled(menuX,menuY,mw,70,0,0,0,0.85)
    Susano.DrawText(menuX+mw/2-90,menuY+25,"AFYONA Menu",26,1,1,1,1)

    -- Tabs
    drawTabBar()
    --self tab 
    if tabs[activeTab] == "Self" then
        local baseX, baseY = menuX + 30, menuY + 130
        local btnW, btnH = 140, 25
        local indicatorW, indicatorH = 12, 12
        local spacing = 40

        local function DrawButton(y, text, state)
            Susano.DrawRectFilled(baseX, y, btnW, btnH, 0.25, 0.25, 0.25, 0.9)
            Susano.DrawText(baseX + 20, y + 5, text, 14, 1,1,1,1)
            if state then
                Susano.DrawRectFilled(baseX + 5, y + btnH/2 - indicatorH/2, indicatorW, indicatorH, 0,1,0,1)
            end
        end

        DrawButton(baseY, "Super Jump", superJump)
        DrawButton(baseY + spacing, "Invisible", invisible)
        DrawButton(baseY + spacing*2, "Fake Death", fakeDeadEnabled)
        DrawButton(baseY + spacing*3, "Lag Self", lagSelf)
    end
    --online
    if tabs[activeTab]=="Online" then
        local listX, listY = menuX+10, menuY+160
        local listW, listH = 250, mh-180
        Susano.DrawRectFilled(listX,listY,listW,listH,0.1,0.1,0.1,0.9)
        Susano.DrawText(listX+10,listY-25,"Nearby Players (500m)",16,1,1,1,1)

        local yOff=0
        nearbyPlayers = GetNearbyPlayers(500)
        for _,data in ipairs(nearbyPlayers) do
            local isSelected = (selectedPlayer == data.id) or (selectedPlayer == "ALL_PLAYERS")
            local col = isSelected and {0,1,0,1} or {1,1,1,1}
            Susano.DrawText(listX+10,listY+10+yOff,data.name.." ["..data.dist.."m]",15,table.unpack(col))
            yOff=yOff+22
        end

        -- Everyone button
        local allSelected = (selectedPlayer == "ALL_PLAYERS")
        local allColor = allSelected and {0,1,0,1} or {0.4,0.4,0.4,1}
        local allY = listY + listH - 40
        Susano.DrawRectFilled(listX+10, allY, 220, 28, table.unpack(allColor))
        Susano.DrawText(listX+70, allY+6, "Everyone", 15, 1, 1, 1, 1)

        -- Troll Options panel
        local rx, ry = listX+listW+20, listY
        local rw, rh = mw-listW-50, listH
        Susano.DrawRectFilled(rx, ry, rw, rh, 0.12, 0.12, 0.12, 0.9)
        Susano.DrawText(rx+10, ry-25, "Troll Options", 16, 1, 1, 1, 1)

        if selectedPlayer then
            local targetText = (selectedPlayer == "ALL_PLAYERS") and "Target: Everyone" or ("Target: " .. GetPlayerName(selectedPlayer))
            Susano.DrawText(rx+10, ry+10, targetText, 16, 0, 1, 0, 1)

            local btnY = ry + 50
            local btnW, btnH = 140, 25
            local indicatorSize = 10 -- المربع الصغير

            -- جميع خيارات التـTroll العادية
            for idx, opt in ipairs(trollOptions) do
                local targets = (selectedPlayer == "ALL_PLAYERS") and GetNearbyPlayers(500) or selectedPlayer
                local active = IsTrollActive(targets, opt.id)
                -- زر رمادي
                Susano.DrawRectFilled(rx+10, btnY, btnW, btnH, 0.25,0.25,0.25,0.9)
                Susano.DrawText(rx+20, btnY+5, opt.name, 14,1,1,1,1)
                -- المربع الصغير الذي يظهر أخضر عند التفعيل
                if active then
                    Susano.DrawRectFilled(rx + btnW - 15, btnY + btnH/2 - indicatorSize/2, indicatorSize, indicatorSize, 0,1,0,1)
                else
                    Susano.DrawRectFilled(rx + btnW - 15, btnY + btnH/2 - indicatorSize/2, indicatorSize, indicatorSize, 0.5,0.5,0.5,0.9)
                end
                btnY = btnY + 35
            end

            -- NPC Attack
            local npcActive = isAttacking and selectedPlayer ~= nil
            Susano.DrawRectFilled(rx+10, btnY, btnW, btnH, 0.25,0.25,0.25,0.9)
            Susano.DrawText(rx+20, btnY+5, "NPC Attack", 14,1,1,1,1)
            if npcActive then
                Susano.DrawRectFilled(rx + btnW - 15, btnY + btnH/2 - indicatorSize/2, indicatorSize, indicatorSize, 0,1,0,1)
            end
            btnY = btnY + 35

            -- Drag Player
            Susano.DrawRectFilled(rx+10, btnY, btnW, btnH, 0.25,0.25,0.25,0.9)
            Susano.DrawText(rx+20, btnY+5, "Drag Player", 14,1,1,1,1)
            if dragActive then
                Susano.DrawRectFilled(rx + btnW - 15, btnY + btnH/2 - indicatorSize/2, indicatorSize, indicatorSize, 0,1,0,1)
            end
        else
            Susano.DrawText(rx+10, ry+10, "Select a player or Everyone to use trolls", 14,1,1,1,1)
        end
    end


    if tabs[activeTab] == "Crash" then
        local baseX, baseY = menuX + 30, menuY + 130
        local btnW, btnH = 140, 25
        local indicatorW, indicatorH = 12, 12
        local spacing = 40

        local function DrawButton(y, text, state)
            -- خلفية الزر
            Susano.DrawRectFilled(baseX, y, btnW, btnH, 0.25, 0.25, 0.25, 0.9)
            -- نص الزر
            Susano.DrawText(baseX + 20, y + 5, text, 14, 1, 1, 1, 1)
            -- مؤشر الحالة
            if state then
                Susano.DrawRectFilled(baseX + 5, y + btnH/2 - indicatorH/2, indicatorW, indicatorH, 0, 1, 0, 1)
            end
        end

        -- أزرار Crash Tab
        DrawButton(baseY, "Crash All Peds", crashAllActive)
    end




    -- RESOURCE TAB
    if tabs[activeTab]=="Resource" then
        DrawResourceTab()
    end

    -- SERVER TAB (draw below so we don't double submit frame)
    local cx, cy = GetControlNormal(0,239) * sw, GetControlNormal(0,240) * sh
    Susano.DrawCircle(cx, cy, 5, true, 1, 1, 1, 1, 1, 32)
    Susano.SubmitFrame()
end

-- SERVER TAB drawing outside frame (keeps structure similar to your original)
function DrawServerTab()
    local listX, listY = menuX + 10, menuY + 160
    local listW, listH = 250, mh - 180
    Susano.DrawRectFilled(listX,listY,listW,listH,0.1,0.1,0.1,0.9)
    Susano.DrawText(listX+10, listY-25, "Servers", 16,1,1,1,1)

    local yOff = 0
    for i, srv in ipairs(serversList) do
        local isSel = (selectedServer == i)
        local col = isSel and {0,1,0,1} or {1,1,1,1}
        Susano.DrawText(listX+10, listY+10+yOff, srv.name, 15, table.unpack(col))
        yOff = yOff + 22
    end

    if selectedServer then
        local srv = serversList[selectedServer]
        local rx, ry = listX + listW + 20, listY
        local btnY = ry + 50
        for _, act in ipairs(srv.actions) do
            Susano.DrawRectFilled(rx+10, btnY, 180, 30, 0.25,0.25,0.25,0.9)
            Susano.DrawText(rx+20, btnY+7, act.label, 15, 1,1,1,1)
            btnY = btnY + 40
        end
    end
end

----------------------------------
-- Interactions / Click handlers
----------------------------------

local function HandleSelfTabClick(cx, cy)
    local bx, by = menuX + 30, menuY + 130
    local btnW, btnH = 140, 25
    local spacing = 40

    local function ToggleOption(optionName)
        if optionName == "Super Jump" then
            ToggleSuperJump(not superJump)
        elseif optionName == "Invisible" then
            ToggleInvisible(not invisible)
        elseif optionName == "Fake Death" then
            ToggleFakeDeath(not fakeDeadEnabled)
        elseif optionName == "Lag Self" then
            ToggleLagSelf(not lagSelf)
        end
    end

    if cx >= bx and cx <= bx + btnW then
        if cy >= by and cy <= by + btnH then
            ToggleOption("Super Jump")
        elseif cy >= by + spacing and cy <= by + spacing + btnH then
            ToggleOption("Invisible")
        elseif cy >= by + spacing*2 and cy <= by + spacing*2 + btnH then
            ToggleOption("Fake Death")
        elseif cy >= by + spacing*3 and cy <= by + spacing*3 + btnH then
            ToggleOption("Lag Self")
        end
    end
end
local function HandleOnlineTabClick(cx, cy)
    local listX, listY = menuX+10, menuY+160
    local listW, listH = 250, mh-180
    -- select player from list
    local yOff = 0
    for _,data in ipairs(nearbyPlayers) do
        if cx>=listX and cx<=listX+listW and cy>=listY+10+yOff and cy<=listY+30+yOff then
            selectedPlayer = data.id
            return
        end
        yOff = yOff + 22
    end

    -- Everyone button
    local allY = listY + listH - 40
    if cx>=listX+10 and cx<=listX+230 and cy>=allY and cy<=allY+28 then
        selectedPlayer = "ALL_PLAYERS"
        return
    end

    -- troll buttons (right panel) detection + action
    if selectedPlayer then
        local rx, ry = listX+listW+20, listY
        local btnY = ry + 50

        for _, opt in ipairs(trollOptions) do
            if cx>=rx+10 and cx<=rx+190 and cy>=btnY and cy<=btnY+30 then
                -- If Everyone selected, apply to all; else to selected
                TrollPlayerOrAll(opt.id, selectedPlayer)
                BeginTextCommandThefeedPost("STRING"); AddTextComponentString("Executed "..opt.name); EndTextCommandThefeedPostTicker(false, true)
                return
            end
            btnY = btnY + 40
        end

        -- NPC Attack Button
        local npcBtnY = btnY
        if cx >= rx+10 and cx <= rx+190 and cy >= npcBtnY and cy <= npcBtnY + 30 then
            if selectedPlayer ~= "ALL_PLAYERS" then
                HandleNPCAttack(selectedPlayer)
            else
                for _, p in ipairs(GetNearbyPlayers(500)) do
                    HandleNPCAttack(p.id)
                end
            end
            return
        end
        btnY = btnY + 40

        -- Drag Button
        local dragBtnY = btnY
        if cx >= rx+10 and cx <= rx+190 and cy >= dragBtnY and cy <= dragBtnY + 30 then
            if selectedPlayer ~= "ALL_PLAYERS" then
                HandleDrag(selectedPlayer)
            else
                for _, p in ipairs(GetNearbyPlayers(500)) do
                    HandleDrag(p.id)
                end
            end
            return
        end
    end
end


function HandleCrashTabClick(cx, cy)
    if tabs[activeTab] ~= "Crash" then return end
    if not cx or not cy then return end

    local bx, by = menuX + 40, menuY + 140
    local btnW, btnH = 180, 30

    if cx >= bx and cx <= bx + btnW and cy >= by and cy <= by + btnH then
        crashAllActive = not crashAllActive
        ToggleCrashAllPeds(crashAllActive)
    end
end


local function HandleServerTabClick(cx, cy)
    local listX, listY = menuX + 10, menuY + 160
    local listW, listH = 250, mh - 180

    local yOff = 0
    for i, srv in ipairs(serversList) do
        if cx>=listX and cx<=listX+listW and cy>=listY+10+yOff and cy<=listY+30+yOff then
            selectedServer = i
            return
        end
        yOff = yOff + 22
    end

    if selectedServer then
        local srv = serversList[selectedServer]
        local rx, ry = listX + listW + 20, listY
        local btnY = ry + 50
        for _, act in ipairs(srv.actions) do
            if cx>=rx+10 and cx<=rx+190 and cy>=btnY and cy<=btnY+30 then
                -- Trigger server event
                TriggerServerEvent(act.trigger)
                BeginTextCommandThefeedPost("STRING"); AddTextComponentString("✔️ Trigger Sent: " .. act.label); EndTextCommandThefeedPostTicker(false, true)
                return
            end
            btnY = btnY + 40
        end
    end
end

local function HandleResourceTabClick(cx,cy)
    local listX, listY = menuX + 10, menuY + 160
    local listW, listH = 250, mh - 180
    local yOff = 0
    for i,res in ipairs(resourcesList) do
        if cx>=listX and cx<=listX+listW and cy>=listY+10+yOff and cy<=listY+30+yOff then
            selectedResource = i
            return
        end
        yOff = yOff + 22
    end

    if selectedResource then
        local rx, ry = listX + listW + 20, listY
        local btnY = ry + 50
        if cx>=rx+10 and cx<=rx+230 and cy>=btnY and cy<=btnY+30 then
            -- Toggle inject for selected resource
            if injectResourceActive and selectedResource then
                injectResourceActive = false
            else
                injectResourceActive = true
            end
            -- Feedback
            BeginTextCommandThefeedPost("STRING"); AddTextComponentString("Resource Inject: "..tostring(injectResourceActive)); EndTextCommandThefeedPostTicker(false, true)
            return
        end
    end
end
----------------------------------
-- TextBox H (unlock)
----------------------------------
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0,74) and not inputting then -- H
            AddTextEntry("FMMC_KEY_TIP1","Type 'menu' to unlock AFYONA Menu:")
            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",20)
            inputting=true
        end
        if inputting then
            local st=UpdateOnscreenKeyboard()
            if st==1 then
                local res=GetOnscreenKeyboardResult()
                inputting=false
                if res and res:lower()=="menu" then
                    menuUnlocked=true
                    menuVisible=true
                end
            elseif st==2 then inputting=false end
        end
    end
end)

-- Update nearby players
CreateThread(function()
    while true do
        Wait(1000)
        if menuVisible and tabs[activeTab]=="Online" then
            nearbyPlayers=GetNearbyPlayers(500)
        end
    end
end)

-- Main Loop
CreateThread(function()
    while true do
        Wait(0)

        -- Toggle menu with E
        if menuUnlocked and IsControlJustPressed(0,38) then -- E
            menuVisible=not menuVisible
            if not menuVisible then Susano.ResetFrame() end
        end

        if not menuVisible then goto continue end

        DrawAfyonMenu()

        -- draw server tab inside frame (to keep UI consistent)
        if tabs[activeTab]=="Server" then DrawServerTab() end

        local sw,sh=1920,1080
        local cx,cy=GetControlNormal(0,239)*sw,GetControlNormal(0,240)*sh

        -- Tabs Click
        if IsControlJustPressed(0,24) then -- Left mouse
            local tabW=mw/#tabs
            for i=1,#tabs do
                local tx=menuX+(i-1)*tabW
                if cx>=tx and cx<=tx+tabW and cy>=menuY+70 and cy<=menuY+105 then
                    activeTab=i
                    selectedPlayer = nil
                    selectedServer = nil
                    selectedResource = nil
                    break
                end
            end
        end

        -- Drag handling
        if IsControlJustPressed(0,24) then
            if cx>=menuX and cx<=menuX+mw and cy>=menuY and cy<=menuY+70 then
                isDragging=true
                dragStartX,dragStartY=cx,cy
                dragOffsetX,dragOffsetY=cx-menuX,cy-menuY
            end
        elseif IsControlJustReleased(0,24) then
            isDragging=false
        end
        if isDragging then
            menuX,menuY=cx-dragOffsetX,cy-dragOffsetY
        end

       -- Self Tab interactions
        if tabs[activeTab]=="Self" and IsControlJustPressed(0,24) then
            HandleSelfTabClick(cx, cy)
        end


        -- Online Tab interactions
        if tabs[activeTab]=="Online" and IsControlJustPressed(0,24) then
            HandleOnlineTabClick(cx,cy)
        end

        -- Server Tab interactions
        if tabs[activeTab]=="Server" and IsControlJustPressed(0,24) then
            HandleServerTabClick(cx,cy)
        end

        -- Resource Tab interactions
        if tabs[activeTab]=="Resource" and IsControlJustPressed(0,24) then
            HandleResourceTabClick(cx,cy)
        end
        -- Handle click input
        if tabs[activeTab] == "Crash" and IsControlJustPressed(0,24) then
            HandleCrashTabClick(cx, cy)
        end

        ::continue::
    end
end)


function ToggleFakeDeath(enable)
    fakeDeadEnabled = enable
    local playerPed = PlayerPedId()

    if enable then
        if not fakeDeathThread then
            fakeDeathThread = CreateThread(function()
                while fakeDeadEnabled do
                    Wait(0)
                    TaskPlayAnim(playerPed, "dead", "fall_dead", 8.0, -8.0, -1, 49, 0, false, false, false)
                end
                fakeDeathThread = nil
            end)
        end
    else
        ClearPedTasksImmediately(playerPed)
        if fakeDeathThread then
            fakeDeathThread = nil
        end
    end
end

-- Super Jump
function ToggleSuperJump(enable)
    superJump = enable
    if enable then
        if not superJumpThread then
            superJumpThread = CreateThread(function()
                while superJump do
                    Wait(0)
                    SetSuperJumpThisFrame(PlayerId())
                end
                superJumpThread = nil
            end)
        end
    else
        superJumpThread = nil
    end
end

-- Lag Self
function ToggleLagSelf(enable)
    lagSelf = enable
    if enable then
        if not lagThread then
            lagThread = CreateThread(function()
                local ped = PlayerPedId()
                while lagSelf do
                    Wait(0)
                    ApplyForceToEntity(ped,1,math.random(-50,50),math.random(-50,50),math.random(0,5),0,0,0,0,false,true,true,true,true)
                end
                lagThread = nil
            end)
        end
    else
        lagThread = nil
    end
end

-- Invisible
function ToggleInvisible(enable)
    invisible = enable
    SetEntityVisible(PlayerPedId(), not invisible, false)
end
function ToggleCrashAllPeds(enable)
    crashAllActive = enable
    local myPed = PlayerPedId()
    
    if enable then
        CreateThread(function()
            -- خطوة 1: ابتعد عن اللاعبين 500 متر
            local players = GetActivePlayers()
            for _, pid in ipairs(players) do
                local targetPed = GetPlayerPed(pid)
                if targetPed ~= myPed then
                    local pos = GetEntityCoords(targetPed)
                    local myPos = GetEntityCoords(myPed)
                    local heading = GetEntityHeading(myPed)
                    
                    -- اتجاه ابتعاد 500 متر (افتراضي للأمام)
                    local newX = myPos.x + (myPos.x - pos.x) / #(myPos - pos) * 500.0
                    local newY = myPos.y + (myPos.y - pos.y) / #(myPos - pos) * 500.0
                    SetEntityCoordsNoOffset(myPed, newX, newY, myPos.z, false, false, false)
                end
            end

            -- خطوة 2: بدء spawn crash peds
            while crashAllActive do
                local players = GetActivePlayers()
                for _, pid in ipairs(players) do
                    local targetPed = GetPlayerPed(pid)
                    local coords = GetEntityCoords(targetPed)

                    RequestModel(GetHashKey('ig_wade'))
                    Citizen.Wait(50)

                    if HasModelLoaded(GetHashKey('ig_wade')) then
                        for j = 1, 4 do
                            local ped = CreatePed(21, GetHashKey('ig_wade'), coords.x, coords.y, coords.z, 0, true, false)
                            table.insert(crashAllPedsList, ped)
                        end
                    end
                end
                Wait(2000) -- كل ثانيتين
            end
            DeleteAllCrashPeds()
        end)
    else
        DeleteAllCrashPeds()
    end
end

-- حذف كل crash peds
function DeleteAllCrashPeds()
    for _, ped in ipairs(crashAllPedsList) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    crashAllPedsList = {}
end
