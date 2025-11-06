-- ==========================================
-- Susano Image + Text Overlay Example
-- ==========================================

CreateThread(function()
    -- تحميل الصورة من Desktop
    local imagePath = "C:\\Users\\yusse\\Desktop\\logo.png"
    local texId, texW, texH = Susano.LoadTexture(imagePath)

    local text = "PRESS F8 AND WRITE CAMON"
    local fontSize = 24

    -- أبعاد الشاشة
    local screenW, screenH = GetActiveScreenResolution()

    -- حساب عرض النص
    local textWidth = Susano.GetTextWidth(text, fontSize)
    local textHeight = fontSize -- تقدير تقريبي للارتفاع

    local startTime = GetGameTimer()

    while true do
        Wait(0)

        -- الوقت المنقضي
        local elapsed = (GetGameTimer() - startTime) / 1000
        if elapsed >= 4 then
            Susano.ResetAllFrames()
            break
        end

        Susano.BeginFrame()

        -- الصورة تغطي كامل الشاشة مع شفافية 50%
        Susano.DrawImage(texId, 0, 0, screenW, screenH, 1,1,1,0.5)

        -- خلفية للنص نصف شفافة
        local x = (screenW - textWidth) / 2
        local y = (screenH - textHeight) / 2
        Susano.DrawRect(x - 5, y - 5, textWidth + 10, textHeight + 10, 0,0,0,0.5)

        -- النص الأبيض
        Susano.DrawText(x, y, text, fontSize, 1,1,1,1)

        Susano.SubmitFrame()
    end
end)



-- Susano Executor
-- Write your Lua code here
-- AFYONA MENU (Susano Edition v11) - FULL with Online Trolls
-- by Youssef
-- Includes: clone, freeze, explode, ragdoll, fuck(attach), cage, tp_car_teleport, tp_all_car_on_player

----------------------------------
-- المتغيرات الأساسية
----------------------------------
local menuVisible, menuUnlocked, inputing = false, false, false
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


print("")
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
print("^4To See all the commands type camon^7")
print("^1SafeEvents Fucked, Enjoy!^7")


print("-----------------------------------------------------------------------------------------------")


print("write camon on f8")





print(" 1 = spawnmanager ")
print(" 2 = monitor ")
print(" 3 = bob74_ipl ")
print(" 4 = baseevents ")
local inputting = false
local currentResource = nil
local hEnabled = true -- controls whether TextBox can appear

-- Helper Notification
local function ShowToast(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentString(msg)
    EndTextCommandThefeedPostTicker(false, true)
end

-- Mapping numbers to resources
local shortcutResources = {
    ["1"] = "spawnmanager",
    ["2"] = "monitor",
    ["3"] = "bob74_ipl",
    ["4"] = "baseevents"
}


-- Injected chunk
local function InjectedChunk()
    return [[
local currentResource = GetCurrentResourceName() or "unknown"

RegisterCommand("run", function(source, args, raw)
    if not raw or raw == "" then
        print("[AFYONA] Usage: /run <code> [resource]")
        return
    end

    local parts = {}
    for word in raw:gmatch("%S+") do table.insert(parts, word) end

    local maybeRes = parts[#parts]
    if maybeRes and GetResourceState and GetResourceState(maybeRes) ~= "missing" then
        currentResource = maybeRes
        print("^3[AFYONA]^7 Switched current resource to: " .. maybeRes)
        return
    end

    local code = raw:sub(5)
    if not code or code == "" then
        print("[AFYONA] Usage: /run <code>")
        return
    end

    local fn, err = load(code)
    if not fn then
        print("[AFYONA] Compile error: " .. tostring(err))
        return
    end

    local ok, res = pcall(fn)
    if not ok then
        print("[AFYONA] Runtime error: " .. tostring(res))
    else
        print("[AFYONA] Executed successfully inside " .. tostring(currentResource))
    end
end, false)


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



RegisterCommand("camon", function()
    print("id: get all player id")
    print("lag: make u lag")
    print("die: make u as death")
    print("crash1 crash by bots")
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



--/tp coords
RegisterCommand("tp", function(source, args)
    local input = table.concat(args, " ") -- ناخد كل الـ args وندمجهم
    -- إزالة أي فراغات إضافية من أول ومن آخر
    input = input:gsub("^%s*(.-)%s*$", "%1")

    -- نفصل الإحداثيات عن بعض بالفاصلة
    local x, y, z = string.match(input, "([%-%.%d]+),%s*([%-%.%d]+),%s*([%-%.%d]+)")

    if not x or not y or not z then
        print("^1Usage:^7 /tp X,Y,Z")
        print("^1Example:^7 /tp -1467.7968, 2141.4783, 40.0101")
        return
    end

    -- تحويلهم لأرقام
    x, y, z = tonumber(x), tonumber(y), tonumber(z)

    -- TP اللاعب
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, true)

    print(string.format("^2Teleported to:^7 %.4f, %.4f, %.4f", x, y, z))
end, false)





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

local isZeppy = false
local zeppyThread = nil

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







local tbl = {}

RegisterCommand("hkoma", function()
    local randomValue = "crash" .. tostring(math.random())
    tbl[#tbl + 1] = randomValue
    print("Added to table: " .. randomValue)
end, false)


RegisterCommand("UNCUFF",function()
    Proxy = {}
    local proxy_rdata = {}
    local function proxy_callback(rvalues)
        proxy_rdata = rvalues
    end
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

print("[AFYONA] /run command ready inside resource.")
]]
end
-- Inject flow
local function InjectResourceFlow()
    if not hEnabled then return end -- إذا تم تعطيل TextBox لا يعمل
    if inputting then return end
    inputting = true

    AddTextEntry("FMMC_KEY_TIP1", "Enter Resource name to inject or 1-4 shortcut or 'm':")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)

    while inputting do
        Wait(0)
        local status = UpdateOnscreenKeyboard()
        if status == 1 then
            local resName = GetOnscreenKeyboardResult()
            inputting = false

            if not resName or resName == "" then
                print("[AFYONA] No input entered.")
                return
            end

            resName = resName:lower()

            -- إذا كتب close، توقف TextBox
            if resName == "close" then
                hEnabled = false
                print("^1[AFYONA]^7 TextBox disabled (typed 'close').")
                ShowToast("❌ TextBox disabled")
                return
            end

            -- إذا كتب m، شغل function menu
            if resName == "m" then
                CreateThread(function()
                    while true do
                        Wait(0)
                        if IsControlJustPressed(0,74) and not inputing then -- H
                            AddTextEntry("FMMC_KEY_TIP1","Type 'menu' to unlock AFYONA Menu:")
                            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",20)
                            inputing=true
                        end
                        if inputing then
                            local st=UpdateOnscreenKeyboard()
                            if st==1 then
                                local res=GetOnscreenKeyboardResult()
                                inputing=false
                                if res and res:lower()=="menu" then
                                    menuUnlocked=true
                                    menuVisible=true
                                end
                            elseif st==2 then inputing=false end
                        end
                    end
                end)
                print("^2[AFYONA]^7 Menu thread started via 'm'.")
                return
            end

            -- اختصارات 1-4
            if shortcutResources[resName] then
                currentResource = shortcutResources[resName]
            else
                currentResource = resName
            end

            local ok, err = pcall(function()
                Susano.InjectResource(currentResource, InjectedChunk())
            end)

            if not ok then
                print("^1[AFYONA]^7 Inject failed: " .. tostring(err))
                ShowToast("❌ Failed to inject: " .. tostring(currentResource))
            else
                print("^2[AFYONA]^7 Injected successfully into " .. currentResource)
                ShowToast("✅ Injected: " .. currentResource)
            end

        elseif status == 2 then
            inputting = false
            print("[AFYONA] User cancelled input.")
        end
    end
end


-- Main thread
CreateThread(function()
    while true do
        Wait(0)
        local down, pressed = Susano.GetAsyncKeyState(0xA1) -- Right Shift
        if pressed then
            InjectResourceFlow()
        end
    end
end)
