
local planeisbest = false
--local PASS = "sedya" 
local dEI = "s"

-- Message display variables
local currentMessageIndex = 1
local currentMessageEndTime = 0
local messages = {}
local showMessages = false

-- Function to show onscreen keyboard
function KeyboardInput(prompt, defaultText, maxLength)
    AddTextEntry("FMMC_KEY_TIP1", prompt)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        return GetOnscreenKeyboardResult()
    else
        return nil
    end
end

-- Function to show notification
function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Main logic: pressing G key
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 74) then -- G key
            if planeisbest then
                trynaskidhuh("MainMenu") -- Your menu function
            else
                local temp = KeyboardInput("Enter Password", "", 100)
                if temp == dEI then
                    
                    local messages = {
                        {text = "hello", duration = 3000},
                        {text = "afyona and s3da bymoso", duration = 3000},
                        {text = "kosom sheble w deeb", duration = 3000},
                        {text = "zeby 3lek ana sedk", duration = 3000}
                    }
                
                    for i, msg in ipairs(messages) do
                        local startTime = GetGameTimer()
                
                        while GetGameTimer() - startTime < msg.duration do
                            Citizen.Wait(0)
                
                            -- Draw black box
                            local x, y, width, height = 0.5, 0.5, 0.25, 0.05
                            DrawRect(x, y, width, height, 0, 0, 0, 200)
                
                            -- Draw text
                            SetTextFont(0)
                            SetTextScale(0.5, 0.5)
                            SetTextColour(255, 255, 255, 255)
                            SetTextCentre(true)
                            SetTextEntry("STRING")
                            AddTextComponentString(msg.text)
                            DrawText(x, y - 0.015)
                        end
                    end
                    planeisbest = true
                    trynaskidhuh("MainMenu")
                else
                    drawNotification("~r~~h~Login has failed, are you retard?")
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 74) then -- F key
            print("F key pressed, opening keyboard...")
            OpenKeyboard()
        end
    end
end)




-- Variables

local savedCoords = nil
local isPunching = false -- Flag to toggle punch effect
local punchTargetId = nil -- Player ID of the target for punching
local bots = {} -- Table to hold spawned bots
local isScriptActive = false -- Flag to control bot script state
local msScriptRunning = false -- Flag for MS bot script
local isAttached = false -- Flag for attachment state
local attachedPed = nil -- Target ped for attachment
local dragActive = false
local flippingEnabled = false
local flipThread = nil
local input = "menu"
--local dEI = "camon.s"
local targetPlayerId = nil
local isCamActive = false 
local isDragged = false
local isAnimating = false  -- Track if animation is currently running
local animationThread = nil -- Reference to the animation thread for stopping it later
local isScriptRunning = false -- Track if the script is running
local scriptThread = nil
local clonedPeds = {}
local clonedId = nil
local cloningActive = false
local cloneKey = 73 -- "X" key
local isAttacking = false
local targetPlayerPed = nil  -- To store the target player ped reference
local currentPlayerID = nil  -- To store the current player ID for attacking
local createdObjects = {} -- Table to keep track of created dildo objects for each player
local ckActive = false
local ckThread = nil
local tpCarActive = false
local tpCarThread = nil
local objectsCreated = false
local cObjects = {}
local massModeActive = false
local massModeThread = nil

-- MENU
local menuOpen = false
local currentTab = 1
local selectedOption = -1
local scrollOffset = 0
local superJumpEnabled = false
local showPlayerList = false
local ckActive = false
local menuPos = {x = 0.5, y = 0.5}
local menuSize = {w = 0.6, h = 0.6}
local isDragging = false
local dragStartPos = {x = 0, y = 0}
local allowMenu = false
local selectedPlayerId = nil
local isScriptActive = false
local msScriptRunning = false
local isAttached = false
local attachedPed = nil
local savedLocations = {}
local selectedLocationIndex = nil
local dragActive = false
local isDragged = false
local cageActive = false
local isCamActive = false
local cam = nil
local isHoldingMouse = false
local killPlayerActive = false

local unlimitedVoice = false
local unlimitedVoiceThread = nil
local tpCarsActive = false
local isZeppy = false
local crashPeds = {}
local crashPlayer = nil
local crashActive = false
local crashallped = {}
local crashallpeds = false
local creatobjactor = {}
local dildoActive = false
local dildoThread = nil
local detectionRadius = 500.0
local easyCamoEnabled = false
local easyCamoGravity = 0.1  -- default gravity when enabled
local pedRainEnabled = false
local vehicleRainEnabled = false
local rpgRainEnabled = false
local noTPEnabled = false
local isNotificationActive = false
local isHkomaActive = false
local tbl = {}
local isCloseActive = false
local cObjectsfa = {} -- For storing created objects
local objectsCreatedfa = false -- For Close Leagen mode
local massModeActivefa = false -- For Close on Player mode
local massModeThreadfa = nil -- For Close on Player thread
local respawnObjectActive = false
local objectModel = "db_apart_09_"
local distanceThreshold = 2000.0
-- === Self Tab ===
local isLagActive = false
local isRevealingInvisiblePlayers = false
local isUnderGroundFixActive = false
local fakeDeadEnabled = false

-- === Anti Tab ===
local noFreezeEnabled = false
local selectedServerOption = nil
local serverNames = {
    { id = "hot", label = "Hot" },
    { id = "los", label = "Los" }
}





-- CONFIG
local tabs = { "Self", "Online", "Vehicle", "CRASH", "DESTROY", "CAMO", "DETECT", "TELEPORT", "ANTI", "Server" }


-- Function to draw text on screen
function DrawTextOnScreen(text, x, y, scale)
    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawRectOnScreen(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 4, y + height / 150, width, height, r, g, b, a)
end



-- Function to open the onscreen keyboard and handle input
function OpenKeyboard()
    AddTextEntry('FMMC_KEY_TIP1', "write CAMONA:") -- Text prompt
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20) -- Allow up to 20 characters

    while true do
        Citizen.Wait(0)

        local keyboardStatus = UpdateOnscreenKeyboard()
        if keyboardStatus == 1 then -- Input submitted
            local input = GetOnscreenKeyboardResult()
            if input and string.len(input) > 0 then
                print("Entered Text: " .. input) -- Debug message

                -- Check if the input is "spectat" to toggle the spectators
                if input:lower() == "id" then --id1
                    showPlayer()
                    print("Nearby player list visibility: " .. tostring(showPlayerList))




                elseif input:lower() == "ck" then
                    if not ckActive then
                        -- Ask for distance first using your existing keyboard input:
                        AddTextEntry("FMMC_KEY_TIP1", "Enter distance to scan for invisible players")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
                
                        while UpdateOnscreenKeyboard() == 0 do
                            Wait(0)
                        end
                
                        if GetOnscreenKeyboardResult() then
                            local inputDist = GetOnscreenKeyboardResult()
                            local distance = tonumber(inputDist)
                            if distance then
                                print("Starting invisible player scan with distance: " .. distance)
                                StartCKLoop(distance)
                            else
                                print("Invalid distance entered.")
                            end
                        end
                    else
                        print("Stopping invisible player scan.")
                        StopCKLoop()
                    end

                -- Check if the input is "die" to trigger the death
                elseif input:lower() == "fuck" then --fuck1
                    if not isScriptActive then
                        isScriptActive = true
                        print("fuck script activated!")
                
                        AddTextEntry('FMMC_KEY_TIP1', "Enter Player ID TO fuck HIM:")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                
                        -- Create a thread that runs your main loop
                        scriptThread = Citizen.CreateThread(function()
                            -- Wait for input result
                            while UpdateOnscreenKeyboard() == 0 do
                                Citizen.Wait(0)
                                if not isScriptActive then return end  -- early exit if stopped
                            end
                
                            local result = GetOnscreenKeyboardResult()
                            local targetId = tonumber(result)
                
                            if targetId then
                                print("fuck script activated for Player ID:", targetId)
                                local myPed = PlayerPedId()
                                local attachedPed = nil
                                local isAttached = false
                
                                while isScriptActive do
                                    Citizen.Wait(0)
                
                                    if IsControlJustPressed(0, 73) then -- 'X' key
                                        attachedPed = GetPlayerPed(GetPlayerFromServerId(targetId))
                
                                        if not isAttached and attachedPed and DoesEntityExist(attachedPed) then
                                            while not HasAnimDictLoaded('rcmpaparazzo_2') do
                                                RequestAnimDict('rcmpaparazzo_2')
                                                Citizen.Wait(0)
                                            end
                
                                            AttachEntityToEntity(myPed, attachedPed, 11816, 0.0, -0.2, 0.8, 0.30, 0.10, 0.110, false, false, false, false, 2, false)
                                            TaskPlayAnim(myPed, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
                
                                            SetEntityInvincible(attachedPed, true)
                                            TaskStandStill(attachedPed, -1)
                                            isAttached = true
                
                                        elseif isAttached then
                                            DetachEntity(myPed, true, false)
                                            ClearPedTasks(myPed)
                
                                            if attachedPed then
                                                SetEntityInvincible(attachedPed, false)
                                                ClearPedTasks(attachedPed)
                                            end
                
                                            isAttached = false
                                            attachedPed = nil
                                        end
                                    end
                                end
                
                                -- Clean up on stop
                                if isAttached then
                                    DetachEntity(myPed, true, false)
                                    ClearPedTasks(myPed)
                                    if attachedPed then
                                        SetEntityInvincible(attachedPed, false)
                                        ClearPedTasks(attachedPed)
                                    end
                                end
                
                            else
                                print("Invalid Player ID entered.")
                                isScriptActive = false
                            end
                        end)
                
                    else
                        -- Stop the script
                        isScriptActive = false
                        print("fuck script stopped and reset!")
                    end
               
                
            
                
            

                elseif input:lower() == "ms" then --ms1
                    -- Stop the script first if it's running
                    if msScriptRunning then
                        msScriptRunning = false
                        print("MS script stopped.")
                        DetachEntity(PlayerPedId(), true, false)
                        ClearPedTasks(PlayerPedId())
                        isAttached = false
                        attachedPed = nil
                        return -- Stop execution immediately
                    end
                
                    -- Ask for player ID input
                    AddTextEntry('FMMC_KEY_TIP1', "Enter Player ID TO G2G2 HIM:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                
                    Citizen.CreateThread(function()
                        while UpdateOnscreenKeyboard() == 0 do
                            Citizen.Wait(0)
                        end
                
                        if GetOnscreenKeyboardResult() then
                            local targetId = tonumber(GetOnscreenKeyboardResult())
                
                            -- Validate the entered Player ID
                            if targetId then
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
                
                                -- Check if the player exists in-game
                                if not targetPed or not DoesEntityExist(targetPed) then
                                    print("Player ID not found.")
                                    return
                                end
                
                                -- Proceed with the script
                                print("MS script activated for Player ID:", targetId)
                                msScriptRunning = true
                                local myPed = PlayerPedId()
                
                                Citizen.CreateThread(function()
                                    while msScriptRunning do
                                        Citizen.Wait(0)
                
                                        if IsControlJustPressed(0, 73) then -- 'X' key
                                            if not isAttached then
                                                attachedPed = GetPlayerPed(GetPlayerFromServerId(targetId))
                
                                                if attachedPed and DoesEntityExist(attachedPed) then
                                                    local dict = "mini@prostitutes@sexnorm_veh"
                                                    local anim = "sex_loop_prostitute"
                
                                                    RequestAnimDict(dict)
                                                    while not HasAnimDictLoaded(dict) do
                                                        Citizen.Wait(0)
                                                    end
                
                                                    AttachEntityToEntity(myPed, attachedPed, 11816, 0.8, 0.2, 0.5, 0.30, 0.10, 10.0, false, false, false, false, 2, false)
                
                                                    TaskPlayAnim(myPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                
                                                    SetEntityInvincible(attachedPed, true)
                                                    TaskStandStill(attachedPed, -1)
                                                    isAttached = true
                                                end
                                            else
                                                DetachEntity(myPed, true, false)
                                                ClearPedTasks(myPed)
                
                                                if attachedPed then
                                                    SetEntityInvincible(attachedPed, false)
                                                    ClearPedTasks(attachedPed)
                                                end
                
                                                isAttached = false
                                                attachedPed = nil
                                            end
                                        end
                                    end
                                end)
                            else
                                print("Invalid Player ID entered.")
                            end
                        end
                    end)
                
                
                
                
                elseif input:lower() == "armor" then --armor1
                    -- Show the on-screen keyboard to input percentage
                    AddTextEntry('FMMC_KEY_TIP1', "Enter % to armor:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                
                    -- Wait for the player to finish inputting
                    while UpdateOnscreenKeyboard() == 0 do
                        DisableAllControlActions(0)
                        Citizen.Wait(0)
                    end
                
                    -- Check if the input is valid
                    if GetOnscreenKeyboardResult() then
                        local armorPercentage = tonumber(GetOnscreenKeyboardResult())
                        if armorPercentage then
                            -- Set the player's armor
                            SetPedArmour(PlayerPedId(), armorPercentage)
                            
                        end
                    end
                

                elseif input:lower() == "heal" then --heal1
                    -- Show the on-screen keyboard to input percentage
                    AddTextEntry('FMMC_KEY_TIP1', "Enter % to heal:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                
                    -- Wait for the player to finish inputting
                    while UpdateOnscreenKeyboard() == 0 do
                        DisableAllControlActions(0)
                        Citizen.Wait(0)
                    end
                
                    -- Check if the input is valid
                    if GetOnscreenKeyboardResult() then
                        local healthValue = tonumber(GetOnscreenKeyboardResult())
                        if healthValue then
                            -- Set the player's health
                            SetEntityHealth(PlayerPedId(), healthValue)
                        end
                    end
                
                
                elseif input:lower() == "super jamp" then --jamp
                    -- Check if super jump is already running
                    if superJumpEnabled then
                        -- Stop the super jump script
                        superJumpEnabled = false
                        print("Super Jump Disabled!")
                    
                        -- Cancel the super jump thread
                        if superJumpThread then
                            superJumpThread = nil
                        end
                    else
                        -- Start the super jump script
                        superJumpEnabled = true
                        print("Super Jump Enabled!")
            
                        -- Create a thread to apply super jump when enabled
                        superJumpThread = CreateThread(function()
                            while superJumpEnabled do
                                Wait(0)
                                SetSuperJumpThisFrame(PlayerId()) -- Native function for super jump
                            end
                        end)
                    end
            
             




               







                
           
                
                elseif input:lower() == "coords" then --coords
                    print("Coords saved sir camo:", savedCoords)
                    AddTextEntry('FMMC_KEY_TIP1', "save/tp:") -- Text prompt
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20) -- Allow up to 20 characters

                    while UpdateOnscreenKeyboard() == 0 do
                        Wait(0)
                    end

                    if GetOnscreenKeyboardResult() then
                        local result = GetOnscreenKeyboardResult()
                        if result == "save" then
                            SaveCoords()
                        elseif result == "tp" then
                            TeleportToSavedCoords()
                        else
                            print("Invalid input.")
                        end
                    end

                elseif input:lower() == "drag" then --drag1
                    if dragActive then
                        -- If drag is already active and 'drag' is typed again, stop the drag function
                        print("Drag function stopped.")
                        dragActive = false
                        isDragged = false
                        DetachEntity(PlayerPedId(), true, true)
                    else
                        -- Start the drag function
                        print("Drag function started.")
                        dragActive = true
                        isDragged = false -- Reset dragging state to allow reuse
                
                        AddTextEntry('FMMC_KEY_TIP2', "Enter player ID or  'off' YA ZEBY:")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP2", "", "", "", "", "", 20)
                
                        while UpdateOnscreenKeyboard() == 0 do
                            Wait(0)
                        end
                
                        if GetOnscreenKeyboardResult() then
                            local result = GetOnscreenKeyboardResult():lower()
                            if result == "off" then
                                print("Drag canceled. Player ID reset.")
                                dragActive = false
                                targetPlayerId = nil -- Reset player ID when "off" is typed
                            else
                                local inputId = tonumber(result)
                                if inputId then
                                    targetPlayerId = inputId
                                    print("Target player set to ID: " .. targetPlayerId)
                                else
                                    print("Invalid player ID entered.")
                                    dragActive = false -- Prevent active state if input is invalid
                                end
                            end
                        end
                    end
               
                
                

                    
                -- Check if the input is "plane" to trigger the plane spawn
                elseif input:lower() == "plane" then --plane1
                    print("Enter Player ID for plane spawn TFTKER 7LWA:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                    if UpdateOnscreenKeyboard() == 1 then
                        local playerId = tonumber(GetOnscreenKeyboardResult())
                        if playerId then
                            -- Trigger the plane spawn for the entered player ID
                            SpawnPlaneForPlayer(playerId)
                        else
                            print("Invalid Player ID entered.")
                        end
                 
                    end
                
                
                elseif input:lower() == "free cam" then --freecam
                    print("Toggling Free Cam mode.")
                    local vehicleHash = 906642318
                
                    RequestModel(vehicleHash)
                    while not HasModelLoaded(vehicleHash) do Wait(0) end
                
                    local isHoldingMouse = false
                    local cam = nil
                
                    function RotToDir(rot)
                        local radZ = math.rad(rot.z)
                        local radX = math.rad(rot.x)
                        local cosX = math.cos(radX)
                        return vector3(-math.sin(radZ) * cosX, math.cos(radZ) * cosX, math.sin(radX))
                    end
                
                    function RespawnAndExplodeVehicle()
                        if not cam then return end
                        local camRot = GetCamRot(cam, 2)
                        local camDir = RotToDir(camRot)
                        local camPos = GetCamCoord(cam)
                        local spawnPos = camPos + (camDir * 5.0)
                
                        local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, false)
                        SetEntityHeading(vehicle, camRot.z)
                        SetEntityVelocity(vehicle, camDir.x * 50.0, camDir.y * 50.0, camDir.z * 50.0)
                        SetVehicleForwardSpeed(vehicle, 9.0)
                        Wait(1000)
                        AddExplosion(GetEntityCoords(vehicle), 2, 1.0, true, false, 1.0)
                    end
                
                    -- Thread for vehicle respawn when holding left mouse button
                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(0)
                            if IsControlPressed(0, 24) then -- Left Mouse Button
                                if not isHoldingMouse then
                                    isHoldingMouse = true
                                    Citizen.CreateThread(function()
                                        while isHoldingMouse do
                                            RespawnAndExplodeVehicle()
                                            Wait(1000)
                                        end
                                    end)
                                end
                            else
                                isHoldingMouse = false
                            end
                        end
                    end)
                
                    -- Function to toggle free cam mode on and off
                    function toggleFreeCam()
                        Citizen.CreateThread(function()
                            while true do
                                Citizen.Wait(0)
                                if IsControlJustPressed(0, 161) then -- 8 key
                                    local playerPed = PlayerPedId()
                                    if isCamActive then
                                        -- Exit free cam mode
                                        RenderScriptCams(false, false, 0, true, true)
                                        DestroyCam(cam, false)
                                        cam = nil
                                        FreezeEntityPosition(playerPed, false)
                                        DisablePlayerFiring(PlayerId(), false)
                                        isCamActive = false  -- Deactivate free cam
                                    else
                                        -- Enter free cam mode
                                        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                                        local coords = GetEntityCoords(playerPed)
                                        SetCamCoord(cam, coords.x, coords.y, coords.z + 1.0)
                                        RenderScriptCams(true, false, 0, true, true)
                                        FreezeEntityPosition(playerPed, true)
                                        DisablePlayerFiring(PlayerId(), true)
                                        isCamActive = true  -- Activate free cam
                                    end
                                end
                
                                if isCamActive then
                                    local pitch = GetGameplayCamRelativePitch()
                                    local heading = GetGameplayCamRelativeHeading()
                                    local x, y, z = table.unpack(GetCamCoord(cam))
                
                                    local mouseX = GetDisabledControlNormal(0, 1)
                                    local mouseY = GetDisabledControlNormal(0, 2)
                                    pitch = pitch - mouseY * 5.0
                                    heading = heading - mouseX * 5.0
                
                                    local dir = RotToDir(vector3(pitch, 0.0, heading))
                                    if IsControlPressed(0, 32) then -- W key
                                        x = x + dir.x * 0.5
                                        y = y + dir.y * 0.5
                                        z = z + dir.z * 0.5
                                    end
                                    if IsControlPressed(0, 33) then -- S key
                                        x = x - dir.x * 0.5
                                        y = y - dir.y * 0.5
                                        z = z - dir.z * 0.5
                                    end
                                    if IsControlPressed(0, 34) then -- A key
                                        x = x - math.cos(math.rad(heading)) * 0.5
                                        y = y - math.sin(math.rad(heading)) * 0.5
                                    end
                                    if IsControlPressed(0, 35) then -- D key
                                        x = x + math.cos(math.rad(heading)) * 0.5
                                        y = y + math.sin(math.rad(heading)) * 0.5
                                    end
                
                                    SetCamCoord(cam, x, y, z)
                                    SetCamRot(cam, pitch, 0.0, heading, 2)
                                end
                            end
                        end)
                    end
                
                    -- Toggle the camera mode when typing "free cam"
                    if isCamActive then
                        -- Stop the script (exit free cam mode)
                        print("Free Cam is now deactivated.")
                        isCamActive = false
                        -- Additional cleanup if necessary (already done in the if-else above)
                    else
                        -- Start free cam
                        toggleFreeCam()
                    end
                
                
                

                -- Check if the input is "bot fuck" to spawn a bot
                elseif input:lower() == "bot fuck" then --botfack
                    print("Enter Player ID  YALA ZEBY M4 ADER:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                    if UpdateOnscreenKeyboard() == 1 then
                        local playerId = tonumber(GetOnscreenKeyboardResult())
                        if playerId then
                            -- Run bot script with the entered player ID
                            RunBotScript(playerId)
                        else
                            print("Invalid Player ID entered.")
                        end
                    end

                -- Check if the input is "bot" to spawn a bot
                elseif input:lower() == "bot" then --bot
                    print("Enter Player ID for bot script:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                    if UpdateOnscreenKeyboard() == 1 then
                        local playerId = tonumber(GetOnscreenKeyboardResult())
                        if playerId then
                            -- Run last script with the entered player ID
                            RunLastScript(playerId)
                        else
                            print("Invalid Player ID entered.")
                        end
                    end





                elseif input:lower() == "kage" then --cage
                    print("Enter Player ID for bot spawn:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                    if UpdateOnscreenKeyboard() == 1 then
                        local playerId = tonumber(GetOnscreenKeyboardResult())
                        if playerId then
                            -- After writing the ID, run the prop spawn logic
                            print("Player ID entered: " .. playerId)
                            local propHash = GetHashKey("prop_box_wood05b")  -- Test with a common prop (box)
                
                            -- Function to check if player exists
                            function DoesPlayerExist(playerId)
                                local targetPed = GetPlayerPed(playerId)
                                return targetPed ~= 0  -- If the Ped is 0, the player does not exist
                            end
                
                            -- Get Player ID dynamically from the server (just an example approach)
                            local playerServerId = GetPlayerServerId(PlayerId())  -- Get your server ID for testing or use a specific ID
                
                            -- Now check for Player Ped using the server ID
                            local targetPed = GetPlayerPed(GetPlayerFromServerId(playerId))  -- Find the player by server ID
                
                            -- Debug: Print player info to check the ID
                            print("Target Ped ID: ", targetPed)
                
                            if DoesPlayerExist(playerId) then
                                print("Player ID " .. playerId .. " exists.")
                            else
                                print("Player ID " .. playerId .. " does not exist.")
                            end
                
                            -- Continue with prop spawning logic
                            RequestModel(propHash)
                            local timeout = GetGameTimer() + 5000  -- 5-second timeout
                            while not HasModelLoaded(propHash) do
                                Wait(0)
                                -- Timeout after 5 seconds if the model doesn't load
                                if GetGameTimer() > timeout then
                                    print("Failed to load the model.")
                                    return
                                end
                            end
                            print("Model loaded successfully.")
                
                            -- Function to spawn the prop and position player
                            function SpawnPropAboveAndUnderPlayer()
                                local playerPos = GetEntityCoords(targetPed)  -- Get the specific player's position
                                local headPos = GetPedBoneCoords(targetPed, 31086)  -- Get the position of the player's head (skull) using bone index (31086 is the head bone)
                                local rightLegPos = GetPedBoneCoords(targetPed, 58271)  -- Get the position of the player's right leg (bone index 58271)
                
                                -- Adjust spawn position for the box above the player's head (skull)
                                local spawnPosAbove = vector3(headPos.x, headPos.y, headPos.z + 0.9)  -- Adjust z-axis slightly above the skull
                
                                -- Adjust spawn position for the box under the player's leg (right leg)
                                local spawnPosLeg = vector3(rightLegPos.x, rightLegPos.y, rightLegPos.z - 0.6)  -- Adjust z-axis slightly below the leg
                
                                -- Debug: Print the spawn positions
                                print("Spawn position above head: ", spawnPosAbove)
                                print("Spawn position under leg: ", spawnPosLeg)
                
                                -- Create the first prop (above head) and flip it
                                local propAbove = CreateObject(propHash, spawnPosAbove.x, spawnPosAbove.y, spawnPosAbove.z, true, true, false)
                                if propAbove then
                                    -- Make the prop visible, static, and frozen
                                    SetEntityVisible(propAbove, true, false)
                                    SetEntityCollision(propAbove, true, true)
                                    SetEntityDynamic(propAbove, false)
                                    FreezeEntityPosition(propAbove, true)
                                    SetEntityRotation(propAbove, 180.0, 0.0, GetEntityHeading(targetPed), 2, true)  -- Flipping the box above the head
                                    print("Prop above head created successfully.")
                                else
                                    print("Failed to create prop above head.")
                                end
                
                                -- Create the second prop (under the right leg) and keep it upright
                                local propLeg = CreateObject(propHash, spawnPosLeg.x, spawnPosLeg.y, spawnPosLeg.z, true, true, false)
                                if propLeg then
                                    -- Make the prop visible, static, and frozen
                                    SetEntityVisible(propLeg, true, false)
                                    SetEntityCollision(propLeg, true, true)
                                    SetEntityDynamic(propLeg, false)
                                    FreezeEntityPosition(propLeg, true)
                                    SetEntityRotation(propLeg, 0.0, 0.0, GetEntityHeading(targetPed), 2, true)  -- Keep the box upright
                                    print("Prop under leg created successfully.")
                                else
                                    print("Failed to create prop under leg.")
                                end
                
                                -- Position the player between the two boxes (you can adjust based on where you want to be between them)
                                local newPos = vector3((spawnPosAbove.x + spawnPosLeg.x) / 2, (spawnPosAbove.y + spawnPosLeg.y) / 2, (spawnPosAbove.z + spawnPosLeg.z) / 2)
                                
                                -- Move the player to the middle position between the two boxes
                                SetEntityCoordsNoOffset(targetPed, newPos.x, newPos.y, newPos.z, false, false, false)
                                
                                print("Player moved to the center between the two boxes.")
                            end
                
                            -- Call function to spawn prop
                            SpawnPropAboveAndUnderPlayer()
                        else
                            print("Invalid Player ID entered.")
                        end
                    end



                
                
               
                elseif input:lower() == "killid" then
                    -- Ask for Player ID
                    AddTextEntry('FMMC_KEY_TIP2', "Enter Player ID:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP2", "", "", "", "", "", 6)
                
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                
                    if GetOnscreenKeyboardResult() then
                        local targetId = tonumber(GetOnscreenKeyboardResult())
                
                        if targetId then
                            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
                
                            if targetPed and DoesEntityExist(targetPed) then
                                Citizen.CreateThread(function()
                                    local playerPed = PlayerPedId()
                                    while true do
                                        Citizen.Wait(0)
                                        -- Press "E" to execute the kill
                                        if IsControlJustPressed(0, 73) then -- 38 = E key
                                            local headPos = GetPedBoneCoords(targetPed, 31086, 0.0, 0.0, 0.0) -- Head
                                            local origin = GetPedBoneCoords(playerPed, 57005, 0.0, 0.0, 0.2) -- Hand
                                            local weaponHash = GetSelectedPedWeapon(playerPed)
                
                                            ShootSingleBulletBetweenCoords(
                                                origin, headPos, 1000, true, weaponHash, playerPed, true, true, 100.0
                                            )
                                            break -- Exit the loop after shooting
                                        end
                                    end
                                end)
                            end
                        end
                    end
                
                
                


                elseif input:lower() == "voice" then --voice
                    Voice = true
                    Citizen.CreateThread(function()
                        while Voice do
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
                    end)
                
                
                elseif input:lower() == "by pass" then
                    print("safe zone: 50 ud by pass safe zone")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                
                    if UpdateOnscreenKeyboard() == 1 then
                        local result = GetOnscreenKeyboardResult():lower()
                
                        if result == "safe zone" then
                            Citizen.CreateThread(function()
                                while true do
                                    Citizen.Wait(1000) -- Every 1 second
                                    if starksafez then
                                        NetworkSetFriendlyFireOption(true)
                                        SetCanAttackFriendly(PlayerPedId(), true, true)
                                        DisablePlayerFiring(PlayerPedId(), false)
                                        EnableAllControlActions(0)
                                        EnableAllControlActions(1)
                                    end
                                end
                    
                        
                            end)
                            print("Safe Zone thread started.")
                        end  
                    end   

                elseif input:lower() == "cuff" then --cuff
                    print("Enter Player ID for cuff:")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                    
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                
                    if UpdateOnscreenKeyboard() == 1 then
                        local result = GetOnscreenKeyboardResult()
                        local playerId = tonumber(result)
                
                        if playerId then
                            TriggerServerEvent('wasabi_police:handcuffPlayer', playerId, 'hard')
                            print("Triggered cuff on Player ID: " .. playerId)
                        else
                            print("Invalid Player ID entered.")
                        end
                    end

                elseif input:lower() == "menu" then
                    CreateThread(function()
                        while true do
                            Wait(0)
                            if IsControlJustPressed(0, 38) then -- E key
                                AddTextEntry('FMMC_KEY_TIP1', "Type MENU to enable/disable")
                                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                                while UpdateOnscreenKeyboard() == 0 do
                                    Wait(0)
                                end
                                if UpdateOnscreenKeyboard() == 1 then
                                    local result = GetOnscreenKeyboardResult()
                                    if result and result:lower() == "menu" then
                                        if allowMenu then
                                            -- Menu already allowed, so now disable everything and stop script
                                            ShowNotification("~r~Menu Disabled. Script Stopped.")
                                            allowMenu = false
                                            menuOpen = false
                                            SetNuiFocus(false, false)
                                            SetNuiFocusKeepInput(false)
                                            return -- ❌ Stop this thread
                                        else
                                            -- Enable menu
                                            ResetMenu()
                                            ShowNotification("~g~Menu Ready. Press ~INPUT_CONTEXT~ (O) to Open.")
                                            break
                                        end
                                    else
                                        ShowNotification("~r~Invalid input. Try again.")
                                    end
                                end
                            end
                        end
                    end)


                elseif result == "uncuff" then --uncuff
                    -- Proxy setup
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
                
                    -- Add interface for proxy communication
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
                
                    -- Get the proxy interface for vRP
                    function Proxy.getInterface(name)
                        local r = setmetatable({}, {__index = proxy_resolve, name = name})
                        return r
                    end
                
                    -- Initialize the vRP proxy interface
                    vRP = {}
                    vRP = Proxy.getInterface("vRP")
                
                    -- Trigger vRP's toggle handcuff action via proxy
                    vRP.toggleHandcuff()
                



                elseif input:lower() == "anti" then
                    print("cuff: test no one can drag /cuff me camo")
                    print("th: test not any one can take me hostage ya camo")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter keyword", "", "", "", "", 20)
                
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                
                    if UpdateOnscreenKeyboard() == 1 then
                        local result = GetOnscreenKeyboardResult():lower()
                
                        
                        if result == "cuff" then
                            local ped = PlayerPedId()


                            local isCuffed = false  -- Flag to track if you're cuffed
                        
                            function IsPlayerCuffed()
                                return isCuffed
                            end
                        
                            local ped = PlayerPedId()
                        
                            -- If you're already cuffed, automatically uncuff
                            if IsPlayerCuffed() then
                                -- Uncuffing actions
                                isCuffed = false
                                FreezeEntityPosition(ped, false)  -- Unfreeze player
                                SetEnableHandcuffs(ped, false)  -- Disable handcuffs
                                ClearPedTasksImmediately(ped)   -- Clear all tasks
                                print("You have been uncuffed.")
                                return -- Skip cuffing if you're already cuffed and just uncuff
                            end

                            isCuffed = true
                        
                            ClearPedSecondaryTask(ped)
                            DisablePlayerFiring(ped, false)
                            ClearPedTasks(ped)
                            SetPedPathCanUseLadders(ped, false)
                            SetEnableHandcuffs(ped, false)
                            DetachEntity(ped, true, false)
                            DeleteEntity(Handcuffs)
                            DeleteEntity(handcuff)
                            FreezeEntityPosition(ped, false)
                        
                            -- Disable movement and drag-related actions
                            DisableControlAction(1, 23, false)  -- "Enter Vehicle"
                            DisableControlAction(2, 37, false)  -- "Vehicle Enter"
                            DisableControlAction(0, 263, false) -- "Enter Vehicle Seat"
                            DisableControlAction(1, 22, false)  -- "Jump"
                            DisableControlAction(1, 24, false)  -- "Attack"
                            DisableControlAction(1, 59, false)  -- "Weapon Wheel"
                            DisableControlAction(1, 75, false)  -- "Aim"
                            DisableControlAction(1, 21, false)  -- "Look Behind"
                            DisableControlAction(1, 140, false) -- "Reload"
                            DisableControlAction(1, 141, false) -- "Melee Attack"
                            DisableControlAction(1, 142, false) -- "Defensive Melee"
                            DisableControlAction(1, 114, false) -- "Throw"
                            
                            -- Block dragging interactions completely by disabling any control related to dragging
                            -- If there's a specific control key for drag action, disable that too
                            DisableControlAction(0, 36, false)  -- Example: might be for dragging (check specific controls for drag)
                        
                            print("Anti-Drag/cuff executed sir camo.")



                        
                            
                            

                
                        
                
                        elseif result == "th" then
                            Citizen.CreateThread(function()
                                while true do
                                    Citizen.Wait(1)
                                    if starkantith then
                                        local ped = PlayerPedId()
                                        local coords = GetEntityCoords(ped)
                                        local heading = GetEntityHeading(ped)
                
                                        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                                        ClearPedBloodDamage(ped)
                                        StopScreenEffect('DeathFailOut')
                                        TriggerEvent("CarryPeople:cl_stop")
                                        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
                                        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                                        ClearPedSecondaryTask(ped)
                                        ClearPedTasks(ped)
                                    end
                                end
                            end)
                
                            print("Block TH function running sr camo.")
                        else
                            print("Unknown keyword entered.")
                        end
                    end
                
                
                elseif input:lower() == "tp car" then -- tpcar1
                    tpCarActive = not tpCarActive
                
                    if not tpCarActive then
                        print("tp car deactivated.")
                        return
                    else
                        print("tp car activated.")
                    end
                
                    local keyToPress = 73 -- X key
                
                    -- Function to get all nearby players within 500 meters who are in a vehicle
                    function GetNearbyPlayersInVehicle(radius)
                        local nearbyPlayers = {}
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)
                
                        for _, id in ipairs(GetActivePlayers()) do
                            local targetPed = GetPlayerPed(id)
                            if targetPed ~= playerPed and IsPedInAnyVehicle(targetPed, false) then
                                local targetCoords = GetEntityCoords(targetPed)
                                local distance = #(playerCoords - targetCoords)
                                if distance <= radius then
                                    table.insert(nearbyPlayers, GetPlayerServerId(id))
                                end
                            end
                        end
                
                        return nearbyPlayers
                    end
                
                    -- Function to show keyboard input and teleport to player's vehicle seat
                    function ShowInputBoxAndTeleport()
                        AddTextEntry("FMMC_KEY_TIP1", "Enter Server ID of player")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
                
                        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                            Citizen.Wait(0)
                        end
                
                        if UpdateOnscreenKeyboard() ~= 1 then return end
                
                        local input = GetOnscreenKeyboardResult()
                        if not input or input == "" then
                            print("No input entered.")
                            return
                        end
                
                        local targetServerId = tonumber(input)
                        if not targetServerId then
                            print("Invalid ID entered.")
                            return
                        end
                
                        -- Find player by server ID
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
                
                        local targetPed = GetPlayerPed(targetPlayer)
                        local vehicle = GetVehiclePedIsIn(targetPed, false)
                
                        if vehicle == 0 then
                            print("That player is not in a vehicle.")
                            return
                        end
                
                        -- Try to find an empty seat
                        local model = GetEntityModel(vehicle)
                        local seats = GetVehicleModelNumberOfSeats(model)
                        for seat = -1, seats - 2 do
                            if IsVehicleSeatFree(vehicle, seat) then
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seat)
                                print("Teleported to player's vehicle (seat " .. seat .. ")")
                                return
                            end
                        end
                
                        print("No available seat in the vehicle.")
                    end
                
                    -- Kill old thread if it's running
                    if tpCarThread then
                        tpCarThread = nil
                    end
                
                    -- Main loop: on X press, do both actions
                    tpCarThread = Citizen.CreateThread(function()
                        while tpCarActive do
                            Citizen.Wait(0)
                            if IsControlJustPressed(0, keyToPress) then
                                -- First: Print nearby player IDs who are in vehicles
                                local players = GetNearbyPlayersInVehicle(500.0)
                                if #players > 0 then
                                    print("Nearby players in vehicles within 500 meters:")
                                    for _, serverId in ipairs(players) do
                                        print("- Player ID: " .. serverId)
                                    end
                                else
                                    print("No players in vehicles within 500 meters.")
                                end
                
                                -- Then: Prompt and teleport to a player's vehicle
                                ShowInputBoxAndTeleport()
                            end
                        end
                    end)
                


                elseif input:lower() == "veh" then--veh1
                    print("easy: 50 ud make veh easy handling")
                    print("loc veh: by plate loc veh")
                    print("warb: warp nearst veh")
                    print("vehb: make tp all veh on plyaer")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "ma tgeb bosa", "", "", "", "", 20)
                
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                
                    if UpdateOnscreenKeyboard() == 1 then
                        local result = GetOnscreenKeyboardResult():lower()
                
                        if result == "easy" then
                            local isGravityEnabled = false
                
                            -- Start a thread to monitor key press and allow gravity modification
                            Citizen.CreateThread(function()
                                while true do
                                    Citizen.Wait(0)
                
                                    -- Check if the "X" key is pressed (control code 73)
                                    if IsControlJustPressed(0, 73) then
                                        -- Show the onscreen keyboard to input a gravity value
                                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter gravity value", "", ".0", "", "", 20)
                
                                        -- Wait until the user has entered the input
                                        while true do
                                            Citizen.Wait(0)
                
                                            -- Check if the keyboard is done and if a valid input was entered
                                            if UpdateOnscreenKeyboard() == 1 then
                                                local input = GetOnscreenKeyboardResult()
                
                                                -- If the user types "easy", stop the script
                                                if input and input:lower() == "easy" then
                                                    -- Stop the script by returning
                                                    return
                                                end
                
                                                -- Otherwise, check if the input is a valid number
                                                if input and tonumber(input) then
                                                    local gravityValue = tonumber(input)
                
                                                    -- Get the player's vehicle
                                                    local playerPed = GetPlayerPed(-1)
                                                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                
                                                    -- Toggle gravity effect
                                                    if not isGravityEnabled then
                                                        SetVehicleGravityAmount(vehicle, gravityValue)
                                                        isGravityEnabled = true
                                                    end
                                                end
                
                                                -- Exit the input loop after processing the input
                                                break
                                            end
                                        end
                                    end
                                end
                            end)
                        elseif result:lower() == "vehb" then
                            -- Check if script is already running by looking for the main variables
                            if tpActive ~= nil then
                                -- Reset everything
                                tpActive = false
                                tpPlayerId = nil
                                tpDistance = 0
                                print("🔄 Script has been reset. Type 'vehb' again to start fresh.")
                                return
                            end
                        
                            -- Initialize variables
                            local tpActive = false 
                            local tpPlayerId = nil -- client ID internally
                            local tpDistance = 0
                            local scriptActive = true
                        
                            -- Helper: Get all vehicles
                            function EnumerateVehicles()
                                return coroutine.wrap(function()
                                    local handle, veh = FindFirstVehicle()
                                    if not handle or veh == 0 then
                                        EndFindVehicle(handle)
                                        return
                                    end
                        
                                    local success
                                    repeat
                                        coroutine.yield(veh)
                                        success, veh = FindNextVehicle(handle)
                                    until not success
                        
                                    EndFindVehicle(handle)
                                end)
                            end
                        
                            -- Helper: Convert Server ID to Client ID
                            function GetClientIdFromServerId(serverId)
                                for i = 0, 255 do
                                    if GetPlayerServerId(i) == serverId then
                                        return i
                                    end
                                end
                                return nil
                            end
                        
                            -- Print nearby players within 500 meters (shows client and server IDs)
                            function PrintNearbyPlayers()
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)
                                print("Nearby players within 500m:")
                        
                                local foundAny = false
                                for i = 0, 255 do
                                    if NetworkIsPlayerActive(i) and i ~= PlayerId() then
                                        local ped = GetPlayerPed(i)
                                        if DoesEntityExist(ped) then
                                            local coords = GetEntityCoords(ped)
                                            local dist = #(coords - playerCoords)
                                            if dist <= 500.0 then
                                                local serverId = GetPlayerServerId(i)
                                                print("ClientID: " .. i .. " | ServerID: " .. serverId .. " | Distance: " .. math.floor(dist))
                                                foundAny = true
                                            end
                                        end
                                    end
                                end
                        
                                if not foundAny then
                                    print("No players found nearby within 500m.")
                                end
                            end
                        
                            -- Teleport all vehicles near the target player
                            function TeleportAllVehiclesToPlayer(targetClientId, distance)
                                local targetPed = GetPlayerPed(targetClientId)
                                if not DoesEntityExist(targetPed) then
                                    print("❌ Target player not found.")
                                    return
                                end
                        
                                local targetCoords = GetEntityCoords(targetPed)
                        
                                for veh in EnumerateVehicles() do
                                    if DoesEntityExist(veh) and veh ~= GetVehiclePedIsIn(targetPed, false) then
                                        local vehCoords = GetEntityCoords(veh)
                                        local dist = #(vehCoords - targetCoords)
                                        if dist <= distance then
                                            local offsetX = math.random(-10, 10) + math.random()
                                            local offsetY = math.random(-10, 10) + math.random()
                                            SetEntityCoords(veh, targetCoords.x + offsetX, targetCoords.y + offsetY, targetCoords.z + 1.0, false, false, false, false)
                                        end
                                    end
                                end
                            end
                        
                            -- Toggle loop with X key (73)
                            Citizen.CreateThread(function()
                                while scriptActive do
                                    Citizen.Wait(0)
                        
                                    if IsControlJustPressed(0, 73) then
                                        if not tpActive then
                                            PrintNearbyPlayers()
                        
                                            AddTextEntry("FMMC_KEY_TIP1", "Enter Server ID of player")
                                            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
                        
                                            while UpdateOnscreenKeyboard() == 0 do
                                                Citizen.Wait(0)
                                            end
                        
                                            if UpdateOnscreenKeyboard() == 1 then
                                                local input = GetOnscreenKeyboardResult()
                                                local serverId = tonumber(input)
                                                if serverId then
                                                    local clientId = GetClientIdFromServerId(serverId)
                                                    if clientId and GetPlayerPed(clientId) ~= -1 then
                                                        tpPlayerId = clientId
                                                        print("✅ Target player Client ID: " .. tpPlayerId .. " Server ID: " .. serverId)
                        
                                                        -- Ask for distance
                                                        AddTextEntry("FMMC_KEY_TIP1", "Enter distance to scan for vehicles")
                                                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
                        
                                                        while UpdateOnscreenKeyboard() == 0 do
                                                            Citizen.Wait(0)
                                                        end
                        
                                                        if UpdateOnscreenKeyboard() == 1 then
                                                            local distInput = GetOnscreenKeyboardResult()
                                                            local dist = tonumber(distInput)
                                                            if dist then
                                                                tpDistance = dist
                                                                tpActive = true
                                                                print("✅ Vehicle teleport loop started.")
                                                            else
                                                                print("❌ Invalid distance.")
                                                            end
                                                        end
                                                    else
                                                        print("❌ Player with that Server ID not found nearby.")
                                                    end
                                                else
                                                    print("❌ Invalid Server ID entered.")
                                                end
                                            end
                                        else
                                            tpActive = false
                                            print("⛔ Vehicle teleport loop stopped.")
                                        end
                                    end
                                end
                            end)
                        
                            -- Continuous teleporting loop
                            Citizen.CreateThread(function()
                                while scriptActive do
                                    Citizen.Wait(1000)
                                    if tpActive and tpPlayerId and tpDistance > 0 then
                                        TeleportAllVehiclesToPlayer(tpPlayerId, tpDistance)
                                    end
                                end
                            end)
                
                        elseif result:lower() == "loc veh" then
                            -- Reset the variables to start fresh every time "loc veh" is entered
                            local acquiredVehicles = {} -- Table to store plate numbers of vehicles for which the player has acquired keys
                            local targetPlate = nil -- The last 3 characters of the plate number entered by the player dynamically
                            local waypointSet = false -- Flag to ensure the waypoint is set only once
                
                            -- Function to draw text in a black box (for notifications)
                            function DrawTextInBlackBox(text, x, y, width, height)
                                local lines = {}
                                local maxLineLength = 80 -- Set maximum characters per line (adjust as needed)
                
                                -- Split the text into multiple lines
                                while string.len(text) > maxLineLength do
                                    local nextLine = string.sub(text, 1, maxLineLength)
                                    table.insert(lines, nextLine)
                                    text = string.sub(text, maxLineLength + 1)
                                end
                                table.insert(lines, text) -- Add remaining text as the last line
                
                                -- Calculate box height based on the number of lines
                                local totalHeight = height * #lines
                
                                -- Draw the black box
                                DrawRect(x, y + (totalHeight / 2) - 0.015, width, totalHeight, 0, 0, 0, 200) -- Black background box
                
                                -- Set text properties
                                SetTextFont(0) -- Default font
                                SetTextProportional(1)
                                SetTextScale(0.35, 0.35)
                                SetTextColour(255, 255, 255, 255) -- White color for the text
                
                                -- Draw each line of text within the box
                                for i = 1, #lines do
                                    SetTextEntry("STRING")
                                    AddTextComponentString(lines[i])
                                    DrawText(x - (width / 2) + 0.005, y - (totalHeight / 2) + (i - 1) * 0.03)
                                end
                            end
                
                            Citizen.CreateThread(function()
                                -- Wait for the player to input the last 3 characters of the vehicle plate
                                AddTextEntry('FMMC_KEY_TIP1', "BA7BK YA ANON last 3:") -- Text prompt
                                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 3)
                
                                -- Wait until the player finishes input
                                while UpdateOnscreenKeyboard() == 0 do
                                    Citizen.Wait(0)
                                end
                
                                if GetOnscreenKeyboardResult() then
                                    targetPlate = GetOnscreenKeyboardResult() -- Get the inputted last 3 characters of the plate
                                end
                
                                -- Continue with the main thread if a plate number was provided
                                if targetPlate then
                                    while not waypointSet do -- Continue until the waypoint is set
                                        Citizen.Wait(1000) -- Adjust the interval as needed
                
                                        -- Get the player's position
                                        local playerPos = GetEntityCoords(PlayerPedId())
                
                                        -- Get all nearby vehicles within the specified radius
                                        local radius = 1500 -- Adjusted radius to 1500 meters
                                        local handle, vehicle = FindFirstVehicle()
                                        local success
                                        repeat
                                            -- Get the vehicle's plate number
                                            local plateNumber = GetVehicleNumberPlateText(vehicle)
                
                                            -- Extract the last 3 characters of the plate number
                                            local lastThree = string.sub(plateNumber, -3)
                
                                            -- Check if the last 3 characters match the target plate
                                            if lastThree == targetPlate then
                                                -- Get the vehicle's position
                                                local vehiclePos = GetEntityCoords(vehicle)
                
                                                -- Set a waypoint to the vehicle's location
                                                SetNewWaypoint(vehiclePos.x, vehiclePos.y)
                
                                                -- Acquire keys for the vehicle if not already acquired
                                                if not acquiredVehicles[plateNumber] then
                                                    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plateNumber)
                                                    acquiredVehicles[plateNumber] = true -- Mark keys as acquired
                
                                                    -- Draw a dynamic black box on screen for 5 seconds
                                                    local displayTime = 5000
                                                    local endTime = GetGameTimer() + displayTime
                
                                                    Citizen.CreateThread(function()
                                                        while GetGameTimer() < endTime do
                                                            Citizen.Wait(0)
                                                            -- Text to be displayed in the black box
                                                            local longText = "thx sa3ed t3ala al3b: " .. lastThree
                                                            
                                                            -- Draw the text in a black box
                                                            DrawTextInBlackBox(longText, 0.5, 0.9, 0.5, 0.03) -- Adjust position as needed
                                                        end
                                                    end)
                                                end
                
                                                waypointSet = true -- Mark the waypoint as set
                                                break -- Exit the loop once the waypoint is set
                                            end
                
                                            -- Find the next vehicle
                                            success, vehicle = FindNextVehicle(handle)
                                        until not success
                
                                        EndFindVehicle(handle)
                                    end
                                else
                                    print("No plate entered.")
                                end
                            end)
                
                        elseif result:lower() == "warb" then
                            local warpKey = 73
                            local isWarpActive = false
                        
                            function EnumerateVehicles()
                                return coroutine.wrap(function()
                                    local handle, vehicle = FindFirstVehicle()
                                    local success
                                    repeat
                                        coroutine.yield(vehicle)
                                        success, vehicle = FindNextVehicle(handle)
                                    until not success
                                    EndFindVehicle(handle)
                                end)
                            end
                        
                            function WarpIntoNearestVehicleAndStartEngine(radius)
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)
                                local closestVehicle = nil
                                local closestDistance = radius + 1.0
                        
                                for vehicle in EnumerateVehicles() do
                                    local vehCoords = GetEntityCoords(vehicle)
                                    local dist = #(vehCoords - playerCoords)
                        
                                    if dist < closestDistance then
                                        closestVehicle = vehicle
                                        closestDistance = dist
                                    end
                                end
                        
                                if closestVehicle and DoesEntityExist(closestVehicle) then
                                    TaskWarpPedIntoVehicle(playerPed, closestVehicle, -1)
                                    SetVehicleEngineOn(closestVehicle, true, true, false)
                                else
                                    print("No vehicle found within " .. radius .. " meters.")
                                end
                            end
                        
                            -- Toggle warp script on/off when typing "warb"
                            if isWarpActive then
                                -- Deactivate warp functionality
                                isWarpActive = false
                                print("Warp functionality deactivated.")
                            else
                                -- Ask for radius input first
                                AddTextEntry("FMMC_KEY_TIP1", "Enter radius ya camo")
                                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ".0", "", "", "", 3)
                        
                                while UpdateOnscreenKeyboard() == 0 do
                                    Citizen.Wait(0)
                                end
                        
                                if UpdateOnscreenKeyboard() == 1 then
                                    local radiusInput = GetOnscreenKeyboardResult()
                                    local radius = tonumber(radiusInput)
                        
                                    if radius then
                                        -- Start the warp key listener with entered radius
                                        isWarpActive = true
                                        CreateThread(function()
                                            while isWarpActive do
                                                Wait(0)
                                                -- Check if the player presses the warp key
                                                if IsControlJustPressed(0, warpKey) then
                                                    WarpIntoNearestVehicleAndStartEngine(radius)
                                                end
                        
                                                -- Check if the player has stopped typing and reset
                                                if UpdateOnscreenKeyboard() == 2 then
                                                    print("Input finished, resetting script.")
                                                    isWarpActive = false
                                                    break  -- Exit the loop and stop the script
                                                end
                                            end
                                        end)
                                    else
                                        print("Invalid radius input.")
                                    end
                                end
                            end
                        end
                        
                       
                    end
                
                   
                    
                elseif input:lower() == "troll" then --troll
                    print("flip: make flip all veh of plyaer")
                    print("tornado: make tp all veh on plyaer")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "ma tgeb bosa", "", "", "", "", 20)
                
                    while UpdateOnscreenKeyboard() == 0 do
                        Citizen.Wait(0)
                    end
                
                    if UpdateOnscreenKeyboard() == 1 then
                        local result = GetOnscreenKeyboardResult():lower()
                
                        if result == "flip" then
                            flippingEnabled = not flippingEnabled

                            if flippingEnabled then
                                print("Flipping script ENABLED. Press X to flip all vehicles.")
                                flipThread = Citizen.CreateThread(function()
                                    while flippingEnabled do
                                        Citizen.Wait(0)
                                        if IsControlJustPressed(0, 73) then -- X key
                                            FlipAllVehicles()
                                        end
                                    end
                                end)
                            else
                                print("Flipping script DISABLED.")
                                -- No need to explicitly stop thread, it stops due to while condition
                            end

                        
                        

                        elseif result:lower() == "tornado" then
                            -- Check if script is already running by looking for the main variables
                            if tpActive ~= nil then
                                -- Reset everything
                                tpActive = false
                                tpPlayerId = nil
                                tpDistance = 0
                                print("🔄 Script has been reset. Type 'vehb' again to start fresh.")
                                return
                            end
                        
                            -- Initialize variables
                            local tpActive = false 
                            local tpPlayerId = nil -- client ID internally
                            local tpDistance = 0
                            local scriptActive = true
                        
                            -- Helper: Get all vehicles
                            function EnumerateVehicles()
                                return coroutine.wrap(function()
                                    local handle, veh = FindFirstVehicle()
                                    if not handle or veh == 0 then
                                        EndFindVehicle(handle)
                                        return
                                    end
                        
                                    local success
                                    repeat
                                        coroutine.yield(veh)
                                        success, veh = FindNextVehicle(handle)
                                    until not success
                        
                                    EndFindVehicle(handle)
                                end)
                            end
                        
                            -- Helper: Convert Server ID to Client ID
                            function GetClientIdFromServerId(serverId)
                                for i = 0, 255 do
                                    if GetPlayerServerId(i) == serverId then
                                        return i
                                    end
                                end
                                return nil
                            end
                        
                            -- Print nearby players within 500 meters (shows client and server IDs)
                            function PrintNearbyPlayers()
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)
                                print("Nearby players within 500m:")
                        
                                local foundAny = false
                                for i = 0, 255 do
                                    if NetworkIsPlayerActive(i) and i ~= PlayerId() then
                                        local ped = GetPlayerPed(i)
                                        if DoesEntityExist(ped) then
                                            local coords = GetEntityCoords(ped)
                                            local dist = #(coords - playerCoords)
                                            if dist <= 500.0 then
                                                local serverId = GetPlayerServerId(i)
                                                print("ClientID: " .. i .. " | ServerID: " .. serverId .. " | Distance: " .. math.floor(dist))
                                                foundAny = true
                                            end
                                        end
                                    end
                                end
                        
                                if not foundAny then
                                    print("No players found nearby within 500m.")
                                end
                            end
                        
                            -- Teleport all vehicles near the target player
                            function TeleportAllVehiclesToPlayer(targetClientId, distance)
                                local targetPed = GetPlayerPed(targetClientId)
                                if not DoesEntityExist(targetPed) then
                                    print("❌ Target player not found.")
                                    return
                                end
                        
                                local targetCoords = GetEntityCoords(targetPed)
                        
                                for veh in EnumerateVehicles() do
                                    if DoesEntityExist(veh) and veh ~= GetVehiclePedIsIn(targetPed, false) then
                                        local vehCoords = GetEntityCoords(veh)
                                        local dist = #(vehCoords - targetCoords)
                                        if dist <= distance then
                                            local offsetX = math.random(-10, 10) + math.random()
                                            local offsetY = math.random(-10, 10) + math.random()
                                            SetEntityCoords(veh, targetCoords.x + offsetX, targetCoords.y + offsetY, targetCoords.z + 1.0, false, false, false, false)
                                        end
                                    end
                                end
                            end
                        
                            -- Toggle loop with X key (73)
                            Citizen.CreateThread(function()
                                while scriptActive do
                                    Citizen.Wait(0)
                        
                                    if IsControlJustPressed(0, 73) then
                                        if not tpActive then
                                            PrintNearbyPlayers()
                        
                                            AddTextEntry("FMMC_KEY_TIP1", "Enter Server ID of player")
                                            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
                        
                                            while UpdateOnscreenKeyboard() == 0 do
                                                Citizen.Wait(0)
                                            end
                        
                                            if UpdateOnscreenKeyboard() == 1 then
                                                local input = GetOnscreenKeyboardResult()
                                                local serverId = tonumber(input)
                                                if serverId then
                                                    local clientId = GetClientIdFromServerId(serverId)
                                                    if clientId and GetPlayerPed(clientId) ~= -1 then
                                                        tpPlayerId = clientId
                                                        print("✅ Target player Client ID: " .. tpPlayerId .. " Server ID: " .. serverId)
                        
                                                        -- Ask for distance
                                                        AddTextEntry("FMMC_KEY_TIP1", "Enter distance to scan for vehicles")
                                                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
                        
                                                        while UpdateOnscreenKeyboard() == 0 do
                                                            Citizen.Wait(0)
                                                        end
                        
                                                        if UpdateOnscreenKeyboard() == 1 then
                                                            local distInput = GetOnscreenKeyboardResult()
                                                            local dist = tonumber(distInput)
                                                            if dist then
                                                                tpDistance = dist
                                                                tpActive = true
                                                                print("✅ Vehicle teleport loop started.")
                                                            else
                                                                print("❌ Invalid distance.")
                                                            end
                                                        end
                                                    else
                                                        print("❌ Player with that Server ID not found nearby.")
                                                    end
                                                else
                                                    print("❌ Invalid Server ID entered.")
                                                end
                                            end
                                        else
                                            tpActive = false
                                            print("⛔ Vehicle teleport loop stopped.")
                                        end
                                    end
                                end
                            end)
                        
                            -- Continuous teleporting loop
                            Citizen.CreateThread(function()
                                while scriptActive do
                                    Citizen.Wait(1000)
                                    if tpActive and tpPlayerId and tpDistance > 0 then
                                        TeleportAllVehiclesToPlayer(tpPlayerId, tpDistance)
                                    end
                                end
                            end)
                
                        
                        end
                        
                    end
                elseif input:lower() == "no" then 
                    Citizen.CreateThread(function()
                        local noCollision = false
                
                        while true do
                            -- Toggle collision with the X key (control 73)
                            if IsControlJustPressed(0, 73) then
                                noCollision = not noCollision
                
                                -- Print the status of noCollision to the console
                                if noCollision then
                                    print("noCollision: ON")
                                else
                                    print("noCollision: OFF")
                                end
                
                                
                            end
                
                            local playerPed = PlayerPedId()
                
                            if noCollision then
                                -- Set the player invincible (prevents some collision issues)
                                SetEntityInvincible(playerPed, true)
                
                                -- Disable collision with all vehicles
                                local vehicles = GetGamePool("CVehicle")
                                for _, vehicle in ipairs(vehicles) do
                                    -- Skip collision if player is NOT in that vehicle
                                    if not IsPedInVehicle(playerPed, vehicle, true) then
                                        -- Disable collision with the vehicle
                                        SetEntityCollision(vehicle, false, false)
                                    end
                                end
                
                                -- Disable collision with all peds (including pedestrians)
                                --local peds = GetGamePool("CPed")
                               -- for _, ped in ipairs(peds) do
                                    -- Check if the ped is not the player
                                    --if ped ~= playerPed then
                                        -- Disable collision with the ped
                                        --SetEntityCollision(ped, false, false)
                                   -- end
                                --end
                
                                -- Disable collision with all objects (such as props, etc.)
                                local objects = GetGamePool("CObject")
                                for _, object in ipairs(objects) do
                                    -- Disable collision with the object
                                    SetEntityCollision(object, false, false)
                                end
                
                            else
                                -- Reset collision for vehicles, peds, and objects
                                SetEntityInvincible(playerPed, false)
                
                                -- Reset collision with vehicles
                                local vehicles = GetGamePool("CVehicle")
                                for _, vehicle in ipairs(vehicles) do
                                    SetEntityCollision(vehicle, true, true)
                                end
                
                                -- Reset collision with peds
                                --local peds = GetGamePool("CPed")
                               -- for _, ped in ipairs(peds) do
                                    --SetEntityCollision(ped, true, true)
                                --end
                
                                -- Reset collision with objects
                                local objects = GetGamePool("CObject")
                                for _, object in ipairs(objects) do
                                    SetEntityCollision(object, true, true)
                                end
                            end
                
                            Citizen.Wait(0)
                        end
                    end)

            

                
                -- Function to handle "ped" input
                elseif input:lower() == "ped" then --ped1
                    -- If the attack is active, reset everything
                    if isAttacking then
                        isAttacking = false
                        targetPlayerPed = nil
                        currentPlayerID = nil  -- Clear the current player ID
                        print("NPC attack stopped and reset.")
                    else
                        -- Start a new attack (ask for the player ID)
                        AddTextEntry("FMMC_KEY_TIP1", "Enter Player ID")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)

                        Citizen.CreateThread(function()
                            -- Wait for the player to input the ID
                            while true do
                                Citizen.Wait(0)
                                if UpdateOnscreenKeyboard() == 1 then -- Checks if the keyboard is closed
                                    local inputText = GetOnscreenKeyboardResult() -- Get the input text (Player ID)
                                    if inputText and inputText ~= "" then
                                        local playerID = tonumber(inputText) -- Convert the ID to a number

                                        if playerID then
                                            -- Get the player by server ID
                                            local targetPlayer = GetPlayerFromServerId(playerID)
                                            if targetPlayer ~= -1 then
                                                -- Try to get the ped of the input player
                                                targetPlayerPed = GetPlayerPed(targetPlayer)

                                                if DoesEntityExist(targetPlayerPed) then
                                                    -- Run the function to make NPCs attack the inputted player with Minigun
                                                    MakePedsAttackPlayerWithMinigun(targetPlayerPed)
                                                    isAttacking = true  -- Set the flag to true since NPCs are attacking
                                                    currentPlayerID = playerID  -- Store the current player ID
                                                end
                                            end
                                        end
                                        break
                                    end
                                end
                            end
                        end)
                    end
                

                



                elseif input:lower() == "clone" then --clone1

                    if cloningActive then
                        -- clear clones and reset
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
                
                    -- Get player handle from typed server ID
                    function GetPlayerFromServerId(serverId)
                        local players = GetActivePlayers()
                        for _, player in ipairs(players) do
                            if GetPlayerServerId(player) == tonumber(serverId) then
                                return player
                            end
                        end
                        return nil
                    end
                
                    -- Clone the player including clothes and props
                    function CloneSpecificPlayer(player)
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
                
                        -- Clone clothes
                        for i = 0, 11 do
                            local drawable = GetPedDrawableVariation(playerPed, i)
                            local texture = GetPedTextureVariation(playerPed, i)
                            local palette = GetPedPaletteVariation(playerPed, i)
                            SetPedComponentVariation(clonePed, i, drawable, texture, palette)
                        end
                
                        -- Clone props
                        for i = 0, 7 do
                            local propIndex = GetPedPropIndex(playerPed, i)
                            if propIndex ~= -1 then
                                local propTexture = GetPedPropTextureIndex(playerPed, i)
                                SetPedPropIndex(clonePed, i, propIndex, propTexture, true)
                            else
                                ClearPedProp(clonePed, i)
                            end
                        end
                
                        print("✅ Cloned player: " .. GetPlayerName(player))
                    end
                
                    Citizen.CreateThread(function()
                        Wait(1000)
                        print("Enter Player ID for clone:")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                
                        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                            Wait(0)
                        end
                
                        if UpdateOnscreenKeyboard() == 1 then
                            local input = GetOnscreenKeyboardResult()
                            if input and input ~= "" then
                                clonedId = tonumber(input)
                                cloningActive = true
                                print("✅ Ready to clone player with ID: " .. input .. " — Press X any time to clone.")
                            end
                        end
                    end)
                
                    Citizen.CreateThread(function()
                        while true do
                            Wait(0)
                            if cloningActive and clonedId then
                                if IsControlJustReleased(0, cloneKey) then
                                    local player = GetPlayerFromServerId(clonedId)
                                    if player then
                                        CloneSpecificPlayer(player)
                                    else
                                        print("❌ No player found with ID: " .. tostring(clonedId))
                                    end
                                end
                            else
                                Wait(500)
                            end
                        end
                    end)
                
       

                elseif input:lower() == "camon" then
                    print("ID: 50 ud player list") --id2
                    print("CK: CHEACK PLAYER INVISABILTY") --ck
                    print("TP car: make my player tp on veh player id")--tp car
                    print("DIE:100 ud my plkayer id") --die2
                    print("FUCK: 80 ud my player fuck player id") --funck2
                    print("MS: 80 ud my player fuck player id of mouse") --ms2
                    print("DRAG: UD MAKE ME ATTACH ON PLAYER")--drag2
                    print("ARMOR: % your armor")--armor2
                    print("HEAl: % your heal")--heal2 
                    print("super jamp: 50 ud my player make super jump") --jamp
                    print("coords: UD save and tp")--coords
                    print("save and tp: save coords player and tp")
                    print("plane: 50 ud makie plan fall on player id") --plane2
                    print("free cam: 50 ud respon veh")--freecam1
                    print("bot fuck: 50 ud bot fuck player") --botfuck1
                    print("bot: 50 ud respwn bot with rpg")--bot1
                    print("kage: 50 ud cage player") --cage1
                    print("voice: 50 ud make my voice more far ya camo") --voice1
                    print("ped: 50 ud make ped attack on player ya camo") --ped1
                    print("clone: 50 ud make cloned from player id ya camo") --voice1
                    print("Tp CAR: make my player t on car player")
                    --print("kill: 50 ud kill any player on 70 metar") --kill1
                    --print("killid: 50 ud kill player like /kill") --killid1
                    --print("killd: 50 ud  kill player like /kill nut respwn weapon") -kiilid2
                    print("uncuff: 50 ud un cuff vrp")--uncuff1
                    print("cuff: 50 ud cuff ")--cuff1
                    print("no : 50 ud make my player no collision like no visable") --no1
                    print("crash : 50 ud crash player with id ab3d 200 metar")--crash1
                    print("punch test: punch player test")
                    print("des: more options ya camo")--des1
                    print("anti: more options ya camo")--anti1
                    print("by pass: more options ya camo")--bypass1
                    print("veh: more options ya camo")--veh1
                    


                elseif input:lower() == "crash" then --crash1
                    SpawnPedsAtPlayer() -- Run SpawnPedsAtPlayer function when "crash" is typed




                elseif input:lower() == "des" then --des1
                    print("w: to make respwn whit dildo attach to player")
                    print("b: to make respwn black dildo attach to player")
                    print("close: to close legan squer")
                    Citizen.CreateThread(function()
                        -- Show on-screen keyboard for next command
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter command (type close or w or b)", "", "", "", "", 20)
                
                        -- Wait for player input
                        while UpdateOnscreenKeyboard() == 0 do
                            Wait(1)
                        end
                
                        local command = GetOnscreenKeyboardResult()
                        if command then
                            command = command:lower()
                                 
                            if command == "b" then
                                print("You typed b — run b script here.")
                                -- Put your 'b' script here
                            elseif command == "w" then
                                -- Run your dildo creation/deletion script here
                                Citizen.CreateThread(function()
                                    local objectModel = GetHashKey("v_res_d_dildo_c") -- Replace with your model
                                
                                    RequestModel(objectModel)
                                    while not HasModelLoaded(objectModel) do
                                        Wait(1)
                                    end
                
                                    -- Ask for sub-command (like 'delete' or create)
                                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter command (type 'delete' to remove dildo objects)", "", "", "", "", 20)
                
                                    while UpdateOnscreenKeyboard() == 0 do
                                        Wait(1)
                                    end
                                    
                                    local playerCommand = GetOnscreenKeyboardResult()
                
                                    if playerCommand ~= nil and playerCommand ~= "" then
                                        if playerCommand:lower() == "delete" then
                                            for playerId, createdObject in pairs(createdObjects) do
                                                DeleteEntity(createdObject)
                                            end
                                            createdObjects = {}
                                            print("All dildo objects have been deleted.")
                                        else
                                            local plist = GetActivePlayers()
                                            for i = 1, #plist do
                                                local ped = GetPlayerPed(plist[i])
                                                local coords = GetEntityCoords(ped)
                
                                                if createdObjects[plist[i]] then
                                                    DeleteEntity(createdObjects[plist[i]])
                                                    createdObjects[plist[i]] = nil
                                                end
                
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
                                                createdObjects[plist[i]] = createdObject
                                            end
                                            print("Dildo object created for all players.")
                                        end
                                    else
                                        print("No valid input received.")
                                    end
                                end)
                            
                              
                            elseif command == "close" then
                                -- Show option menu
                                AddTextEntry('FMMC_KEY_TIP1', "Type: ~n~1 = Normal Mode~n~2 = Mass Mode (500m Radius)")
                                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
                                
                                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                                    Citizen.Wait(0)
                                end
                                
                                local choice = GetOnscreenKeyboardResult()
                                
                                if choice == "1" then -- Normal Mode
                                    if massModeActive then
                                        -- Stop mass mode if active
                                        if massModeThread then
                                            Citizen.Trace("Stopping mass mode thread...\n")
                                            Citizen.InvokeNative(0x9A9D1BA639675CF1, massModeThread) -- Terminate thread
                                            massModeThread = nil
                                        end
                                        massModeActive = false
                                    end
                            
                                    if not objectsCreated then
                                        -- Create objects normally
                                        local e8 = -145066854
                                        RequestModel(e8)
                                        while not HasModelLoaded(e8) do
                                            Citizen.Wait(0)
                                        end
                                        
                                        cObjects[1] = CreateObject(e8, 258.91, -933.1, 26.21, true, true, false)
                                        cObjects[2] = CreateObject(e8, 200.91, -874.1, 26.21, true, true, false)
                                        cObjects[3] = CreateObject(e8, 126.52, -933.2, 26.21, true, true, false)
                                        cObjects[4] = CreateObject(e8, 184.52, -991.2, 26.21, true, true, false)
                                        
                                        SetEntityHeading(cObjects[1], 158.41)
                                        SetEntityHeading(cObjects[2], 90.51)
                                        SetEntityHeading(cObjects[3], 332.41)
                                        SetEntityHeading(cObjects[4], 260.51)
                                        
                                        for i = 1, #cObjects do
                                            FreezeEntityPosition(cObjects[i], true)
                                        end
                                        
                                        objectsCreated = true
                                        print("Normal Mode: Objects created")
                                    else
                                        -- Delete objects
                                        for i = 1, #cObjects do
                                            if DoesEntityExist(cObjects[i]) then
                                                DeleteEntity(cObjects[i])
                                            end
                                        end
                                        
                                        cObjects = {}
                                        objectsCreated = false
                                        print("Normal Mode: Objects removed")
                                    end
                                    
                                elseif choice == "2" then -- Mass Mode
                                    if not massModeActive then
                                        massModeActive = true
                                        local e8 = -145066854
                                        RequestModel(e8)
                                        while not HasModelLoaded(e8) do
                                            Citizen.Wait(0)
                                        end
                            
                                        -- Start continuous spawning thread
                                        massModeThread = Citizen.CreateThread(function()
                                            while massModeActive do
                                                -- Clear previous objects
                                                for i = 1, #cObjects do
                                                    if DoesEntityExist(cObjects[i]) then
                                                        DeleteEntity(cObjects[i])
                                                    end
                                                end
                                                cObjects = {}
                            
                                                -- Spawn around all players in 500m radius
                                                local players = GetActivePlayers()
                                                for _, player in ipairs(players) do
                                                    local ped = GetPlayerPed(player)
                                                    local coords = GetEntityCoords(ped)
                                                    
                                                    -- Generate random positions in 500m radius
                                                    for i = 1, 5 do -- 5 objects per player
                                                        local angle = math.random() * math.pi * 2
                                                        local radius = math.random(10, 500)
                                                        local x = coords.x + radius * math.cos(angle)
                                                        local y = coords.y + radius * math.sin(angle)
                                                        local _, z = GetGroundZFor_3dCoord(x, y, coords.z, false)
                                                        
                                                        if z then
                                                            local obj = CreateObject(e8, x, y, z, true, true, false)
                                                            SetEntityHeading(obj, math.random() * 360)
                                                            FreezeEntityPosition(obj, true)
                                                            cObjects[#cObjects+1] = obj
                                                        end
                                                    end
                                                end
                            
                                                -- Additional fixed locations
                                                local additionalLocations = {
                                                    {x = 300.0, y = -800.0, z = 30.0, h = 90.0},
                                                    {x = -100.0, y = -700.0, z = 30.0, h = 180.0},
                                                    {x = 500.0, y = -600.0, z = 30.0, h = 270.0}
                                                }
                                                
                                                for _, loc in ipairs(additionalLocations) do
                                                    local obj = CreateObject(e8, loc.x, loc.y, loc.z, true, true, false)
                                                    SetEntityHeading(obj, loc.h)
                                                    FreezeEntityPosition(obj, true)
                                                    cObjects[#cObjects+1] = obj
                                                end
                            
                                                Citizen.Wait(5000) -- Refresh every 5 seconds
                                            end
                                        end)
                                        
                                        print("Mass Mode: Continuous spawning activated (500m radius)")
                                    else
                                        -- Stop mass mode
                                        massModeActive = false
                                        if massModeThread then
                                            Citizen.Trace("Stopping mass mode thread...\n")
                                            Citizen.InvokeNative(0x9A9D1BA639675CF1, massModeThread) -- Terminate thread
                                            massModeThread = nil
                                        end
                                        
                                        -- Clean up all objects
                                        for i = 1, #cObjects do
                                            if DoesEntityExist(cObjects[i]) then
                                                DeleteEntity(cObjects[i])
                                            end
                                        end
                                        cObjects = {}
                                        
                                        print("Mass Mode: Stopped and all objects removed")
                                    end
                                end
                            end
                        else
                            print("No command entered.")
                        end
                    end)
                
                    
                
                elseif input:lower() == "end" then
                    function StopAllScripts()
                        scriptRunning = false
                        showBlackScreen = false
                        invisiblePlayerTimer = {}
                        showSpectators = false
                        spectatorsList = {}
                        isPunching = false
                        punchTargetId = nil
                        bots = {}
                        isScriptActive = false
                        msScriptRunning = false
                        invisiblePlayerTimer = {}
                        showSpectators = false -- Flag to control visibility
                        savedCoords = nil
                        spectatorsList = {}
                        isPunching = false -- Flag to toggle punch effect
                        punchTargetId = nil -- Player ID of the target for punching
                        bots = {} -- Table to hold spawned bots
                        isScriptActive = false -- Flag to control bot script state
                        msScriptRunning = false -- Flag for MS bot script
                        isAttached = false -- Flag for attachment state
                        attachedPed = nil -- Target ped for attachment
                        ragActive = false
                        targetPlayerId = nil
                        isDragged = false
                        isAttached = false
                        attachedPed = nil
                        print("Stopped all scripts.")
                    end
                    
                    
                -- Check if the input is "punch" to trigger the punch effect
                elseif input:lower() == "punch" then--punch1
                    if isPunching then
                        -- Stop the punch effect
                        isPunching = false
                        punchTargetId = nil
                        print("Punch effect stopped.")
                    else
                        print("Enter Player ID for clone:")
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Enter Player ID", "", "", "", "", 5)
                        while UpdateOnscreenKeyboard() == 0 do
                            Citizen.Wait(0)
                        end
                        if UpdateOnscreenKeyboard() == 1 then
                            local playerId = tonumber(GetOnscreenKeyboardResult())
                            if playerId then
                                -- Trigger the punch effect on the entered player ID
                                ApplyPunchEffect(playerId)
                                isPunching = true -- Start repeating punches
                                punchTargetId = playerId
                            else
                                print("Invalid Player ID entered.")
                            end
                        end
                    end
                

                    else
                    print("Invalid input. Enter 'spectat' to toggle spectators, 'die' to trigger death, 'plane' to spawn a plane, 'bot' to spawn a bot, or 'punch' to apply punch effect.")
                end
            else
                print("Invalid Input. Please enter some text.")
            end
            break
        elseif keyboardStatus == 2 then -- Keyboard closed without input
            print("Keyboard closed without input.")
            break
        end
    end
end















-- Function to make all NPCs attack the inputted player (not you) with a Minigun
function MakePedsAttackPlayerWithMinigun(targetPlayerPed)
    Citizen.CreateThread(function()
        -- Get all NPCs in the pool
        local peds = GetGamePool("CPed")
        
        -- Get the current player's ped (so they won't run from NPCs)
        local myPed = PlayerPedId()

        -- Loop continuously to make NPCs attack the target player every second
        while isAttacking do
            Citizen.Wait(1000)  -- Wait 1 second

            for _, ped in ipairs(peds) do
                -- Check if the ped is valid, not the current player, and not the target player
                if DoesEntityExist(ped) and ped ~= myPed and ped ~= targetPlayerPed then
                    local distance = Vdist(GetEntityCoords(ped), GetEntityCoords(targetPlayerPed)) -- Distance check
                    
                    if distance < 200.0 then  -- Check if NPC is within 200 units of the target
                        -- Command the NPC to attack the inputted player with the Minigun
                        TaskCombatPed(ped, targetPlayerPed, 0, 16)
                    end
                end
            end
        end
    end)
end

-- Function to handle pressing X
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Check if the player presses "X" and attack is active
        if IsControlJustPressed(0, 73) then  -- "X" key (Control 73)
            if isAttacking and targetPlayerPed then
                -- Trigger the NPCs to attack the currently selected player
                MakePedsAttackPlayerWithMinigun(targetPlayerPed)
            end
        end
    end
end)










function ShowNearbyInvisiblePlayers(distance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local dist = #(playerCoords - targetCoords)

            if dist <= distance and not IsEntityVisible(targetPed) then
                local serverId = GetPlayerServerId(playerId)
                local name = GetPlayerName(playerId)
                print("Invisible Player ID: " .. serverId .. " | Name: " .. name)
            end
        end
    end
end

-- Function to start the scanning loop
function StartCKLoop(distance)
    if ckThread then return end -- already running
    ckActive = true
    ckThread = Citizen.CreateThread(function()
        while ckActive do
            ShowNearbyInvisiblePlayers(distance)
            Citizen.Wait(1000) -- wait 1 second between scans, adjust as needed
        end
        ckThread = nil
    end)
end

-- Function to stop the scanning loop
function StopCKLoop()
    ckActive = false
end


-- Function to run the bot script with a specific player ID
function RunBotScript(targetPlayerId)
    Citizen.CreateThread(function()
        local targetServerId = targetPlayerId  -- Change this to the server ID you want to target
        local hash = GetHashKey("a_m_m_acult_01") -- Change the ped model here

        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end

        -- Iterate over active players and check if the current player's server ID matches the target
        for _, playerId in pairs(GetActivePlayers()) do
            local playerServerId = GetPlayerServerId(playerId)  -- Get the server ID of the player
            if playerServerId == targetServerId then  -- Only target the specific server ID
                local playerPed = GetPlayerPed(playerId)
                local ped = CreatePed(2, hash, GetEntityCoords(playerPed), GetEntityHeading(playerPed), false, true)
                
                -- Attach the ped to the player
                AttachEntityToEntity(ped, playerPed, 11816, 0.0, -0.3, -0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, false)

                -- Make the ped play the animation
                while true do
                    if not IsEntityPlayingAnim(ped, 'rcmpaparazzo_2', 'shag_loop_a', 3) then
                        while not HasAnimDictLoaded('rcmpaparazzo_2') do 
                            Wait(0) 
                            RequestAnimDict('rcmpaparazzo_2') 
                        end
                        TaskPlayAnim(ped, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
                    end
                    Wait(0)
                end

                -- Make the ped invincible
                SetEntityInvincible(ped, true)
                
                -- Make the ped perform an idle task or similar action
                TaskStandStill(ped, -1)  -- This can be replaced with any other task you want the ped to perform.
            end
        end
    end)
end


-- Function to request player ID via keyboard input
function RequestPlayerID()
    AddTextEntry('FMMC_KEY_TIP1', "Enter The Player ID:")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 6)

    while UpdateOnscreenKeyboard() == 0 do
        Citizen.Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return tonumber(GetOnscreenKeyboardResult())
    end
    return nil
end

local spawnedPeds = {}
local monitoringPlayer = nil

function SpawnPedsAtPlayer()
    local selectedPlayerID = RequestPlayerID()
    if selectedPlayerID then
        monitoringPlayer = selectedPlayerID
        for i = 0, 32 do
            local playerPed = GetPlayerPed(GetPlayerFromServerId(selectedPlayerID))
            local coords = GetEntityCoords(playerPed)

            RequestModel(GetHashKey('ig_wade'))
            Citizen.Wait(50)

            if HasModelLoaded(GetHashKey('ig_wade')) then
                for j = 1, 4 do
                    local ped = CreatePed(21, GetHashKey('ig_wade'), coords.x, coords.y, coords.z, 0, true, false)
                    table.insert(spawnedPeds, ped)
                end
            end
        end

        -- Start monitoring the player
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(5000) -- Check every 5 seconds
                local playerId = GetPlayerFromServerId(monitoringPlayer)
                if not NetworkIsPlayerActive(playerId) then
                    DeleteAllSpawnedPeds()
                    monitoringPlayer = nil
                    break
                end
            end
        end)
    end
end

function DeleteAllSpawnedPeds()
    for _, ped in ipairs(spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    spawnedPeds = {}
end

-- Function to apply a punch effect on the target player
function ApplyPunchEffect(targetId)
    -- Get the ped for the target player
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))

    if targetPed and targetPed ~= 0 then
        -- Get target player's coordinates
        local targetCoords = GetEntityCoords(targetPed)

        -- Request and play punch animation on the target ped
        RequestAnimDict("melee@unarmed@streamed_core")
        while not HasAnimDictLoaded("melee@unarmed@streamed_core") do
            Wait(10)
        end

        -- Trigger punch animation
        TaskPlayAnim(targetPed, "melee@unarmed@streamed_core", "plyr_takedown_front_slap", 8.0, -8.0, 500, 49, 0, false, false, false)

        -- Apply realistic force as if punched
        local forwardVector = GetEntityForwardVector(targetPed)
        ApplyForceToEntity(targetPed, 1, forwardVector.x * 5.0, forwardVector.y * 5.0, 1.0, 0, 0, 0, 0, false, true, true, false, true)

        -- Apply minor damage
        ApplyDamageToPed(targetPed, 10, true) -- Deals 10 damage (adjust if needed)

        -- Add ragdoll effect for realism
        SetPedToRagdoll(targetPed, 500, 500, 0, false, false, false)

        print("Punch effect successfully applied to target player.")
    else
        print("Invalid target player.")
    end
end

-- Function to repeat the punch effect
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isPunching and punchTargetId then
            ApplyPunchEffect(punchTargetId)  -- Reapply punch effect to the same player repeatedly
            Citizen.Wait(500)  -- Delay between repeated punches (0.5 seconds for faster punches)
        end
    end
end)


-- Function to run the last script with a specific player ID
function RunLastScript(playerId)
    -- This is where you will put the script actions you want to trigger after entering a player ID
    print("Running last script for player ID " .. playerId)
    
    -- Example action to spawn a bot with behavior
    local pedModel = "a_c_mtlion" -- Example ped model for the bot

    Citizen.CreateThread(function()
        RequestModel(pedModel)

        -- Wait until the model is loaded
        while not HasModelLoaded(pedModel) do
            Wait(100)
        end

        -- Get the specific player's ped by ID
        local playerPedId = GetPlayerFromServerId(playerId)
        local ped = GetPlayerPed(playerPedId)

        -- Ensure the player ped exists
        if DoesEntityExist(ped) then
            local pos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            -- Create the ped (bot)
            local botPed = CreatePed(28, pedModel, pos.x, pos.y, pos.z, heading, true, false)

            -- Set bot behavior
            TaskWanderInArea(botPed, pos.x, pos.y, pos.z, 10.0, 10.0, 10.0)

            -- Give the bot a weapon and configure combat attributes
            GiveWeaponToPed(botPed, GetHashKey("WEAPON_RPG"), 255, false, true)
            SetPedAsEnemy(botPed, true)
            SetPedCombatAttributes(botPed, 46, true) -- Allow bots to use weapons
            SetPedCombatAttributes(botPed, 5, true) -- Allow bots to fight
            SetPedCombatAttributes(botPed, 1, true) -- Enable combat

            -- Make bot attack the player
            TaskCombatPed(botPed, ped, 0, 16)

            -- Optionally set bot as no longer needed
            -- SetPedAsNoLongerNeeded(botPed)
        end
    end)
end


function SaveCoords()
    local playerPed = PlayerPedId()
    savedCoords = GetEntityCoords(playerPed)
    print("Coords saved sir camo:", savedCoords)
end

function TeleportToSavedCoords()
    if savedCoords then
        local playerPed = PlayerPedId()
        SetEntityCoords(playerPed, savedCoords.x, savedCoords.y, savedCoords.z, false, false, false, false)
        print("Teleported to saved coords.")
    else
        print("No coords saved.")
    end
end





function ToggleDrag()
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayerId))

    if not isDragged and targetPed ~= 0 and DoesEntityExist(targetPed) then
        AttachEntityToEntity(playerPed, targetPed, 0, 0.15, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        isDragged = true
        print("You are now being dragged by player ID " .. targetPlayerId)
    else
        DetachEntity(playerPed, true, true)
        isDragged = false
        print("You have stopped being dragged.")
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, 73) then -- 'E' key to toggle drag
            if not targetPlayerId then
                RequestPlayerIdInput() -- Ask for player ID first
            else
                ToggleDrag()
            end
        end
    end
end)
-- The correct password

function SpawnPlaneForPlayer(targetPlayerId)
    local planeModel = 2172210288 -- The cargoplane model hash

    Citizen.CreateThread(function()
        -- Request the cargoplane model
        RequestModel(planeModel)

        -- Wait until the model is loaded
        while not HasModelLoaded(planeModel) do
            Wait(100)
        end

        -- Get the specific player's ped by ID
        local playerPedId = GetPlayerFromServerId(targetPlayerId)
        local ped = GetPlayerPed(playerPedId)

        -- Ensure the player ped exists
        if DoesEntityExist(ped) then
            local pos = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            -- Calculate the spawn position (100 meters above the player)
            local spawnCoords = vector3(pos.x, pos.y, pos.z + 100) -- Start 100 meters above the player

            -- Create the cargoplane
            local cargoplane = CreateVehicle(planeModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)

            -- Ensure the cargoplane is properly created
            if DoesEntityExist(cargoplane) then
                -- Make the cargoplane visible
                SetEntityVisible(cargoplane, true, false)

                -- Calculate the new position for the plane to fly 50 meters away from the player
                local offset = vector3(50.0, 0.0, 0.0) -- 50 meters in the X direction (can be adjusted to fly in any direction)
                local awayCoords = pos + offset

                -- Set the plane to fly away from the player
                local flyAwayTime = 5000 -- Time to reach the "away" position
                local startPos = GetEntityCoords(cargoplane)
                local progress = 0.0

                -- Fly the plane away from the player
                while progress < 1.0 do
                    progress = progress + (GetFrameTime() / flyAwayTime)
                    local currentX = Lerp(startPos.x, awayCoords.x, progress)
                    local currentY = Lerp(startPos.y, awayCoords.y, progress)
                    local currentZ = Lerp(startPos.z, awayCoords.z, progress)

                    SetEntityCoordsNoOffset(cargoplane, currentX, currentY, currentZ, true, true, true)
                    Citizen.Wait(0)
                end

                -- Make the plane fly back to the player
                local landTime = 5000
                local landCoords = pos + vector3(0.0, 0.0, 100.0)
                local progress2 = 0.0

                -- Fly the plane back down to the player's position
                while progress2 < 1.0 do
                    progress2 = progress2 + (GetFrameTime() / landTime)
                    local currentX2 = Lerp(awayCoords.x, landCoords.x, progress2)
                    local currentY2 = Lerp(awayCoords.y, landCoords.y, progress2)
                    local currentZ2 = Lerp(awayCoords.z, landCoords.z, progress2)

                    SetEntityCoordsNoOffset(cargoplane, currentX2, currentY2, currentZ2, true, true, true)
                    Citizen.Wait(0)
                end
            end
        end
    end)
end






function showPlayer()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            -- Check if the "J" key is pressed (key code for "J" is 44)
            if IsControlJustReleased(0, 161) then -- J key
                showPlayerList = not showPlayerList
                print("Nearby player list visibility: " .. tostring(showPlayerList))
            end
    
            if showPlayerList then
                local boxX = 0.80
                local boxY = 0.15
                local textWidth = 0.090
                local boxHeight = 0.15
                local lineSpacing = 0.015
    
                local startX = 0.8
                local startY = 0.2
                local headerText = "~g~Nearby Players"
                local fontSize = 0.2
    
                DrawRectOnScreen(boxX, boxY, textWidth, boxHeight, 0, 0, 0, 200)
                DrawTextOnScreen(headerText, startX + 0.005, startY - 0.13, fontSize)
    
                local players = GetActivePlayers()
                local nameStartY = startY - 0.11
    
                for i = 1, #players do
                    local player = players[i]
                    local playerPed = GetPlayerPed(player)
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(playerPed), true)
    
                    if distance <= 500.0 then --100 meters
                        local playerName = GetPlayerName(player)
                        local playerID = GetPlayerServerId(player)
                        local displayText = "[" .. playerID .. "] " .. playerName
                        DrawTextOnScreen(displayText, startX + 0.005, nameStartY, 0.18)
                        nameStartY = nameStartY + lineSpacing
                    end
                end
            end
        end
    end)
end


function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        local success
        repeat
            if DoesEntityExist(vehicle) then
                coroutine.yield(vehicle)
            end
            success, vehicle = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end)
end

-- Function to flip a vehicle onto its roof
function FlipVehicleOnRoof(vehicle)
    if DoesEntityExist(vehicle) then
        local heading = GetEntityHeading(vehicle)
        SetEntityRotation(vehicle, 180.0, 0.0, heading, 2, true)
    end
end

-- Function to flip all vehicles
function FlipAllVehicles()
    for vehicle in EnumerateVehicles() do
        FlipVehicleOnRoof(vehicle)
    end
end


-- DRAW HELPERS23
function DrawTextF(text, x, y, scale, r, g, b, a, center)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    if center then SetTextCentre(true) end
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function IsMouseInBounds(x, y, w, h)
    local resX, resY = GetActiveScreenResolution()
    local mouseX, mouseY = GetNuiCursorPosition()
    local ratioX, ratioY = 1.0 / resX, 1.0 / resY
    mouseX, mouseY = mouseX * ratioX, mouseY * ratioY
    return mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
end

-- DRAGGING MENU
function HandleMenuMovement()
    local resX, resY = GetActiveScreenResolution()
    local mouseX, mouseY = GetNuiCursorPosition()
    local normX = mouseX / resX
    local normY = mouseY / resY

    local titleBarX = menuPos.x - menuSize.w / 2
    local titleBarY = menuPos.y - menuSize.h / 2
    local titleBarH = 0.05

    if not isDragging and IsMouseInBounds(titleBarX, titleBarY, menuSize.w, titleBarH) and IsDisabledControlJustPressed(0, 24) then
        isDragging = true
        dragStartPos.x = normX - menuPos.x
        dragStartPos.y = normY - menuPos.y
    end

    if isDragging then
        if IsDisabledControlPressed(0, 24) then
            menuPos.x = normX - dragStartPos.x
            menuPos.y = normY - dragStartPos.y
            menuPos.x = math.max(menuSize.w / 2, math.min(1.0 - menuSize.w / 2, menuPos.x))
            menuPos.y = math.max(menuSize.h / 2, math.min(1.0 - menuSize.h / 2, menuPos.y))
        else
            isDragging = false
        end
    end
end

-- TABS
function DrawTabs()
    local tabW = menuSize.w / #tabs
    local tabH = 0.04
    local startX = menuPos.x - menuSize.w / 2
    for i = 1, #tabs do
        local x = startX + (i - 1) * tabW
        local y = menuPos.y - menuSize.h / 2 + 0.05
        local isHovered = IsMouseInBounds(x, y, tabW, tabH)
        local isActive = i == currentTab

        DrawRect(x + tabW / 2, y + tabH / 2, tabW, tabH, 0, 0, 0, 220)
        if isActive then
            DrawRect(x + tabW / 2, y + tabH / 2 + 0.015, tabW, 0.003, 128, 0, 128, 255)
        end

        DrawTextF(tabs[i], x + tabW / 2, y + tabH / 2 - 0.01, 0.28, 255, 255, 255, 255, true)

        if isHovered and IsDisabledControlJustPressed(0, 24) then
            currentTab = i
            selectedOption = -1
            scrollOffset = 0
            selectedPlayerId = nil
            selectedServerOption = nil -- Reset server option when switching tabs

        end
    end
end

function DrawLeftOptions(options, tabHandler)
    local x = menuPos.x - menuSize.w / 2 + 0.0  -- Move to the left side of the menu
    local y = menuPos.y - menuSize.h / 2 + 0.1
    local w = menuSize.w * 0.25
    local h = 0.025
    local maxVisible = math.floor((menuSize.h - 0.2) / (h + 0.004))
    local optionSpacing = 0.004
    local dividerHeight = 0.001  -- Divider thickness

    -- Draw each option button
    for i = 1, math.min(maxVisible, #options) do
        local index = i + scrollOffset
        if index > #options then break end

        local boxY = y + (i - 1) * (h + optionSpacing)
        local hovered = IsMouseInBounds(x, boxY, w, h)
        if hovered and IsDisabledControlJustPressed(0, 24) then
            selectedOption = index
            tabHandler(options[index].id)
        end

        local bgR, bgG, bgB = 20, 20, 20

        -- Change color based on active state
        if options[index].active then
            -- Green when active (for Free Cam and Super Jump)
            bgR, bgG, bgB = 20, 20, 20  -- Green color
        elseif hovered then
            -- Dark gray when hovered
            bgR, bgG, bgB = 40, 40, 40
        end

        -- Draw the background of the option button
        DrawRect(x + w / 2, boxY + h / 2, w, h, bgR, bgG, bgB, 220)

        local checkSymbol = options[index].active and "✅" or "⬜"
        -- Draw the check symbol
        DrawTextF(checkSymbol, x + 0.005, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
        -- Draw the label for the button
        DrawTextF(options[index].label, x + 0.025, boxY + 0.003, 0.27, 255, 255, 255, 255, false)

        
    end
end

-- Right-side options for the "Self" tab
function DrawRightOptions(options)
    local x = menuPos.x + 0.08
    local y = menuPos.y - 0.2
    local w = 0.18
    local h = 0.03
    local spacing = 0.005

    for i, option in ipairs(options) do
        local boxY = y + (i - 1) * (h + spacing)
        local hovered = IsMouseInBounds(x, boxY, w, h)
        
        -- Toggle functionality
        if hovered and IsDisabledControlJustPressed(0, 24) then
            option.toggle = not option.toggle
            isNotificationActive = option.toggle
            

            ShowNotification("Toggle Notification is " .. (option.toggle and "On" or "Off"))
        end

        local bgR, bgG, bgB = 20, 20, 20
        if option.toggle then
            bgR, bgG, bgB = 40, 140, 40  -- Green when active
        elseif hovered then
            bgR, bgG, bgB = 40, 40, 40  -- Dark gray when hovered
        end

        -- Draw the background of the option button
        DrawRect(x + w / 2, boxY + h / 2, w, h, bgR, bgG, bgB, 220)

        local checkSymbol = option.toggle and "✅" or "⬜"
        -- Draw the check symbol
        DrawTextF(checkSymbol, x + 0.005, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
        -- Draw the label for the button
        DrawTextF(option.label, x + 0.025, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
    end
end

-- TOGGLE
function ToggleMenu()
    if allowMenu then
        menuOpen = not menuOpen
        selectedOption = -1
        scrollOffset = 0
        isDragging = false
        SetNuiFocus(menuOpen, menuOpen)
        SetNuiFocusKeepInput(menuOpen)
    end
end

function ResetMenu()
    menuOpen = false
    currentTab = 1
    selectedOption = -1
    scrollOffset = 0
    isDragging = false
    allowMenu = true
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end

function ShowNotification(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, true)
end

-- SELF TAB
function HandleSelfTabOption(id)
    if id == "super_jump" then
        superJumpEnabled = not superJumpEnabled
        ShowNotification("Super Jump " .. (superJumpEnabled and "Enabled" or "Disabled"))
    elseif id == "notification_toggle" then
        -- This will toggle the notification on and off
        isNotificationActive = not isNotificationActive
        ShowNotification("Notification feature " .. (isNotificationActive and "Enabled" or "Disabled"))
    

    elseif id == "free_cam" then
        toggleFreeCam()
        -- Button will automatically turn green when active (from the color change in DrawLeftOptions)
    elseif id == "lag" then
        isLagActive = not isLagActive
        ShowNotification("Lag " .. (isLagActive and "Enabled" or "Disabled"))
        
        -- Apply the lag effect (no collision or collision reset)
        if isLagActive then
            -- Disable collision with world
            SetEntityCollision(PlayerPedId(), false, false)
            -- Optionally, to prevent falling underground, set player position or add some physics
            SetEntityInvincible(PlayerPedId(), true)
            isUnderGroundFixActive = true  -- This will prevent the player from falling under the ground
        else
            -- Reset collision and invincibility
            SetEntityCollision(PlayerPedId(), true, true)
            SetEntityInvincible(PlayerPedId(), false)
            isUnderGroundFixActive = false
        end

    elseif id == "reveal_invis_players" then
        isRevealingInvisiblePlayers = not isRevealingInvisiblePlayers
        ShowNotification("Reveal Invisible Players: " .. (isRevealingInvisiblePlayers and "Enabled" or "Disabled"))

        -- Reveal invisible players within a certain range (e.g., 100 meters)
        if isRevealingInvisiblePlayers then
            Citizen.CreateThread(function()
                while isRevealingInvisiblePlayers do
                    Citizen.Wait(500)
                    local myCoords = GetEntityCoords(PlayerPedId())
                    for _, id in ipairs(GetActivePlayers()) do
                        if id ~= PlayerId() then
                            local targetPed = GetPlayerPed(id)
                            if DoesEntityExist(targetPed) and not IsEntityVisible(targetPed) then
                                local targetCoords = GetEntityCoords(targetPed)
                                local distance = #(myCoords - targetCoords)
                                if distance < 100.0 then
                                    DrawTextF("Invisible Player: " .. GetPlayerName(id), 0.5, 0.85, 0.35, 255, 0, 0, 255, true)
                                end
                            end
                        end
                    end
                end
            end)
        end
    
    elseif id == "fake_death" then
        fakeDeadEnabled = not fakeDeadEnabled
        ToggleFakeDeath(fakeDeadEnabled)
    
    end
end



-- TELEPORT TAB
function HandleTeleportTabOption(id)
    if id == "save_coord" then
        local coords = GetEntityCoords(PlayerPedId())
        local name = "Loc " .. tostring(#savedLocations + 1)
        table.insert(savedLocations, { name = name, coords = coords })
        ShowNotification("Saved Location: " .. name)

    elseif id == "tp_coord" then
        if selectedLocationIndex and savedLocations[selectedLocationIndex] then
            local coord = savedLocations[selectedLocationIndex].coords
            SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z, false, false, false, true)
            ShowNotification("Teleported to " .. savedLocations[selectedLocationIndex].name)
        else
            ShowNotification("No location selected!")
        end

    elseif id == "delete_loc" then
        if selectedLocationIndex then
            table.remove(savedLocations, selectedLocationIndex)
            selectedLocationIndex = nil
            ShowNotification("Deleted location.")
        else
            ShowNotification("No location selected to delete!")
        end
    end
end
-- TAB OF ANTI
function HandleAntiTabOption(id)
    if id == "no_one_can_tp" then
        noTPEnabled = not noTPEnabled
        ToggleNoTP(noTPEnabled)
    elseif id == "no_freeze" then
        noFreezeEnabled = not noFreezeEnabled
        ToggleNoFreeze(noFreezeEnabled)
    
    end
end

-- NOTIFICATION
function ShowNotification(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, true)
end


-- ONLINE TAB (TROLL)
function HandleOnlineTabOption(id)
    local targetId = selectedPlayerId
    if not targetId then return end

    local myPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))

    if not DoesEntityExist(targetPed) then
        ShowNotification("Invalid Target.")
        return
    end

    if id == "fuck" then
        if not isScriptActive then
            isScriptActive = true
            Citizen.CreateThread(function()
                while isScriptActive do
                    Wait(0)
                    if IsControlJustPressed(0, 73) then
                        if not isAttached then
                            RequestAnimDict('rcmpaparazzo_2')
                            while not HasAnimDictLoaded('rcmpaparazzo_2') do Wait(0) end
                            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -0.2, 0.8, 0.30, 0.10, 0.110, false, false, false, false, 2, false)
                            TaskPlayAnim(myPed, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
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
        else
            isScriptActive = false
        end
    elseif id == "cage" then
        if not cageActive then
            -- Create the cage around the player
            cageActive = true
            print("Creating cage for selected player ID: " .. selectedPlayerId)

            local propHash = GetHashKey("prop_box_wood05b")
            RequestModel(propHash)

            local timeout = GetGameTimer() + 5000
            while not HasModelLoaded(propHash) do
                Wait(0)
                if GetGameTimer() > timeout then
                    print("Failed to load prop model.")
                    return
                end
            end

            -- Get the positions for the box
            local headPos = GetPedBoneCoords(targetPed, 31086)  -- head
            local legPos = GetPedBoneCoords(targetPed, 58271)   -- right leg

            local abovePos = vector3(headPos.x, headPos.y, headPos.z + 0.9)
            local legBoxPos = vector3(legPos.x, legPos.y, legPos.z - 0.6)

            -- Create the prop above and below the target
            propAbove = CreateObject(propHash, abovePos.x, abovePos.y, abovePos.z, true, true, false)
            if propAbove then
                SetEntityVisible(propAbove, true, false)
                SetEntityCollision(propAbove, true, true)
                SetEntityDynamic(propAbove, false)
                FreezeEntityPosition(propAbove, true)
                SetEntityRotation(propAbove, 180.0, 0.0, GetEntityHeading(targetPed), 2, true)
                print("Prop above head created.")
            end

            propLeg = CreateObject(propHash, legBoxPos.x, legBoxPos.y, legBoxPos.z, true, true, false)
            if propLeg then
                SetEntityVisible(propLeg, true, false)
                SetEntityCollision(propLeg, true, true)
                SetEntityDynamic(propLeg, false)
                FreezeEntityPosition(propLeg, true)
                SetEntityRotation(propLeg, 0.0, 0.0, GetEntityHeading(targetPed), 2, true)
                print("Prop under leg created.")
            end

            -- Move player in between
            local newPos = vector3(
                (abovePos.x + legBoxPos.x) / 2,
                (abovePos.y + legBoxPos.y) / 2,
                (abovePos.z + legBoxPos.z) / 2
            )

            SetEntityCoordsNoOffset(targetPed, newPos.x, newPos.y, newPos.z, false, false, false)
            print("Player teleported between the boxes.")
        else
            -- If the cage is already active, remove the cage
            cageActive = false
            print("Removing cage for selected player ID: " .. selectedPlayerId)

            -- Remove the cage props manually
            if propAbove then
                DeleteEntity(propAbove)
                propAbove = nil
            end

            if propLeg then
                DeleteEntity(propLeg)
                propLeg = nil
            end

            ShowNotification("Cage removed.")
        end
    elseif id == "respawn_object" then
        if respawnObjectActive then
            respawnObjectActive = false
            ShowNotification("Respawn Object stopped.")
        else
            respawnObjectActive = true
            ShowNotification("Respawn Object started for selected player.")
            Citizen.CreateThread(function()
                while respawnObjectActive and selectedPlayerId do
                    local targetPed = GetPlayerPed(GetPlayerFromServerId(selectedPlayerId))
                    if DoesEntityExist(targetPed) then
                        SpawnObjectsNearPlayer(targetPed)
                    else
                        ShowNotification("Target player is no longer valid.")
                        respawnObjectActive = false
                        break
                    end
                    Wait(1000)
                end
            end)
        end
    elseif id == "crash" then
        if not crashActive then
            crashActive = true
            crashPlayer = targetId

            -- Teleport you 400 meters away from the player in +X axis
            local targetCoords = GetEntityCoords(targetPed)
            local newCoords = vector3(targetCoords.x + 400.0, targetCoords.y, targetCoords.z)
            SetEntityCoords(myPed, newCoords.x, newCoords.y, newCoords.z, false, false, false, true)
            ShowNotification("Teleporting 400 meters away and starting crash.")

            SpawnPedsAtPlayer()
        else
            crashActive = false
            crashPlayer = nil
            DeleteAllSpawnedPeds()
            ShowNotification("Crash stopped.")
        end
   
    

    elseif id == "tp_car_teleport" then
        tpCarActive = not tpCarActive

        if not tpCarActive then
            ShowNotification("TP Car teleport deactivated.")
            if tpCarThread then
                tpCarThread = nil
            end
            return
        else
            ShowNotification("TP Car teleport activated. Press X to teleport to player's vehicle.")
        end

        local keyToPress = 73 -- X key

        -- Kill old thread if running
        if tpCarThread then
            tpCarThread = nil
        end

        tpCarThread = Citizen.CreateThread(function()
            while tpCarActive do
                Citizen.Wait(0)
                if IsControlJustPressed(0, keyToPress) then
                    -- Check if target is in vehicle
                    if IsPedInAnyVehicle(targetPed, false) then
                        local vehicle = GetVehiclePedIsIn(targetPed, false)
                        local model = GetEntityModel(vehicle)
                        local seats = GetVehicleModelNumberOfSeats(model)

                        -- Try to find free seat
                        local foundSeat = false
                        for seat = -1, seats - 2 do
                            if IsVehicleSeatFree(vehicle, seat) then
                                TaskWarpPedIntoVehicle(myPed, vehicle, seat)
                                ShowNotification("Teleported to player's vehicle (seat " .. seat .. ")")
                                foundSeat = true
                                break
                            end
                        end

                        if not foundSeat then
                            ShowNotification("No free seat available in player's vehicle.")
                        end
                    else
                        ShowNotification("Selected player is not in a vehicle.")
                    end
                end
            end
        end)
    
    elseif id == "tp_all_car_on_player" then
        tpCarsActive = not tpCarsActive
        ShowNotification("TP All Cars on Player " .. (tpCarsActive and "Enabled" or "Disabled"))

        if tpCarsActive then
            Citizen.CreateThread(function()
                while tpCarsActive do
                    Citizen.Wait(1000)

                    local targetCoords = GetEntityCoords(targetPed)
                    for veh in EnumerateVehicles() do
                        if DoesEntityExist(veh) then
                            local vehCoords = GetEntityCoords(veh)
                            local dist = #(vehCoords - targetCoords)
                            if dist <= 500.0 then
                                -- Teleport vehicle near the player with a slight random offset to avoid stacking exactly
                                local offsetX = math.random(-5, 5) + math.random()
                                local offsetY = math.random(-5, 5) + math.random()
                                local newCoords = vector3(targetCoords.x + offsetX, targetCoords.y + offsetY, targetCoords.z + 1.0)
                                SetEntityCoords(veh, newCoords.x, newCoords.y, newCoords.z, false, false, false, true)
                                -- Optionally reset vehicle velocity so it doesn't fly away
                                SetEntityVelocity(veh, 0.0, 0.0, 0.0)
                            end
                        end
                    end
                end
            end)
        end
   

    elseif id == "mos_zeby" then
        if msScriptRunning then
            msScriptRunning = false
            DetachEntity(myPed, true, false)
            ClearPedTasks(myPed)
            isAttached = false
            attachedPed = nil
            return
        end

        msScriptRunning = true
        Citizen.CreateThread(function()
            while msScriptRunning do
                Wait(0)
                if IsControlJustPressed(0, 73) then
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
    elseif id == "kill_player" then
        if killPlayerActive then
            killPlayerActive = false
            ShowNotification("Kill Player stopped.")
        else
            killPlayerActive = true
            ShowNotification("Press E to kill selected player.")
            Citizen.CreateThread(function()
                while killPlayerActive do
                    Citizen.Wait(0)
                    if IsControlJustPressed(0, 38) then -- E key
                        local headPos = GetPedBoneCoords(targetPed, 31086, 0.0, 0.0, 0.0) -- Head
                        local origin = GetPedBoneCoords(myPed, 57005, 0.0, 0.0, 0.2) -- Hand
                        local weaponHash = GetSelectedPedWeapon(myPed)

                        ShootSingleBulletBetweenCoords(
                            origin, headPos, 1000, true, weaponHash, myPed, true, true, 100.0
                        )
                        killPlayerActive = false
                        ShowNotification("Player killed.")
                        break
                    end
                end
            end)
        end
    elseif id == "close_on_player" then
        if massModeActivefa then
            massModeActivefa = false
            if massModeThreadfa then
                Citizen.InvokeNative(0x9A9D1BA639675CF1, massModeThreadfa)
                massModeThreadfa = nil
            end
            for _, obj in ipairs(cObjectsfa) do
                if DoesEntityExist(obj) then DeleteEntity(obj) end
            end
            cObjectsfa = {}
            ShowNotification("Close on Player stopped.")
        else
            AddTextEntry('FMMC_KEY_TIP1', "Type: ~n~2 = Close on Player (500m Radius)")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
            while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Citizen.Wait(0) end
            local choice = GetOnscreenKeyboardResult()
            if choice == "2" then
                local e8 = -145066854
                RequestModel(e8)
                while not HasModelLoaded(e8) do Citizen.Wait(0) end
                massModeActivefa = true
                massModeThreadfa = Citizen.CreateThread(function()
                    while massModeActivefa do
                        for _, obj in ipairs(cObjectsfa) do
                            if DoesEntityExist(obj) then DeleteEntity(obj) end
                        end
                        cObjectsfa = {}
                        local targetPed = GetPlayerPed(GetPlayerFromServerId(selectedPlayerId))
                        if DoesEntityExist(targetPed) then
                            local coords = GetEntityCoords(targetPed)
                            for i = 1, 5 do
                                local angle = math.random() * math.pi * 2
                                local radius = math.random(10, 500)
                                local x = coords.x + radius * math.cos(angle)
                                local y = coords.y + radius * math.sin(angle)
                                local _, z = GetGroundZFor_3dCoord(x, y, coords.z, false)
                                if z then
                                    local obj = CreateObject(e8, x, y, z, true, true, false)
                                    SetEntityHeading(obj, math.random() * 360)
                                    FreezeEntityPosition(obj, true)
                                    cObjectsfa[#cObjectsfa + 1] = obj
                                end
                            end
                        end
                        local additionalLocations = {
                            {x = 300.0, y = -800.0, z = 30.0, h = 90.0},
                            {x = -100.0, y = -700.0, z = 30.0, h = 180.0},
                            {x = 500.0, y = -600.0, z = 30.0, h = 270.0}
                        }
                        for _, loc in ipairs(additionalLocations) do
                            local obj = CreateObject(e8, loc.x, loc.y, loc.z, true, true, false)
                            SetEntityHeading(obj, loc.h)
                            FreezeEntityPosition(obj, true)
                            cObjectsfa[#cObjectsfa + 1] = obj
                        end
                        Citizen.Wait(5000)
                    end
                end)
                ShowNotification("Close on Player started.")
            end
        end
    
    elseif id == "ped_htneko" then
        if isAttacking then
            isAttacking = false
            targetPlayerPed = nil
            currentPlayerID = nil
            print("NPC attack stopped and reset.")
        else
            local targetId = selectedPlayerId
            if not targetId then
                ShowNotification("No player selected!")
                return
            end
            local targetPlayer = GetPlayerFromServerId(targetId)
            if targetPlayer == -1 then
                ShowNotification("Invalid player selected.")
                return
            end

            targetPlayerPed = GetPlayerPed(targetPlayer)
            if DoesEntityExist(targetPlayerPed) then
                -- Call your native function here:
                MakePedsAttackPlayerWithMinigun(targetPlayerPed)
                isAttacking = true
                currentPlayerID = targetId
            else
                ShowNotification("Target player ped does not exist.")
            end
        end
    elseif id == "drag" then
        if dragActive then
            print("Drag function stopped.")
            dragActive = false
            isDragged = false
            DetachEntity(PlayerPedId(), true, true)
        else
            if selectedPlayerId then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(selectedPlayerId))
                if DoesEntityExist(targetPed) then
                    print("Drag function started.")
                    dragActive = true
                    isDragged = false

                    local myPed = PlayerPedId()
                    AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -0.4, 0.5, 0.0, 0.0, 180.0, false, false, false, false, 2, false)
                    TaskPlayAnim(myPed, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
                else
                    print("Invalid target ped.")
                end
            else
                ShowNotification("No player selected.")
            end
        end
    end

end

function HandleCAMOTabOption(id)
    if id == "uncuff" then
        vRP.toggleHandcuff()
        ShowNotification("Toggled handcuff state (UNCUFF)")
    elseif id == "hkoma_agry" then
        -- This will toggle the HkomaActive on and off
        isHkomaActive = not isHkomaActive
        ShowNotification("hkoma_agry " .. (isHkomaActive and "Enabled" or "Disabled"))
    
        if isHkomaActive then
            Citizen.CreateThread(function()
            
                while true do
                    tbl[#tbl+1] = "crash"..math.random()
                end
            end)
         
        end


    elseif id == "Close_agry" then
        -- This will toggle the CloseActive on and off
        isCloseActive = not isCloseActive
        ShowNotification("Close_agry " .. (isCloseActive and "Enabled" or "Disabled"))
    
        if isCloseActive then
            Citizen.CreateThread(function()
            
                while true do
                   ForceSocialClubUpdate()
                end
            end)
         
        end

    end
end

-- DETECT TAB
function HandleDetectTabOption(id)
    if id == "show_players" then
        showPlayerList = not showPlayerList
        ShowNotification("Nearby Players: " .. (showPlayerList and "Visible" or "Hidden"))
    elseif id == "check_invis" then
        if not ckActive then
            AddTextEntry("FMMC_KEY_TIP1", "Enter distance to scan for invisible players")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 9)
            while UpdateOnscreenKeyboard() == 0 do Wait(0) end
            if GetOnscreenKeyboardResult() then
                local distance = tonumber(GetOnscreenKeyboardResult())
                if distance then StartCKLoop(distance) end
            end
        else
            StopCKLoop()
        end
    end
end

function HandleServerTabOption(id)
    selectedServerOption = id
end

function HandleServerSubOption(id)
    if id == "hot_option_1" then
        ShowNotification("Hot Option 1 Triggered")
        TriggerServerEvent("hospital:server:RespawnAtHospital")
    elseif id == "hot_option_2" then
        ShowNotification("Hot Option 2 Triggered")
        AddTextEntry('FMMC_KEY_TIP1', "HOME ID:")
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 10)
        while true do
            Citizen.Wait(0)
            local homeStatus = UpdateOnscreenKeyboard()
            if homeStatus == 1 then
                local homeId = GetOnscreenKeyboardResult()
                AddTextEntry('FMMC_KEY_TIP1', "PLAYER ID:")
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 10)
                while true do
                    Citizen.Wait(0)
                    local playerStatus = UpdateOnscreenKeyboard()
                    if playerStatus == 1 then
                        local playerId = GetOnscreenKeyboardResult()
                        TriggerServerEvent("ps-housing:server:addAccess", homeId, playerId)
                         break
                    elseif playerStatus == 2 then break end
                end
                break
            elseif homeStatus == 2 then break end
        end 
    elseif id == "hot_option_3" then
        AddTextEntry('FMMC_KEY_TIP1', "Enter Property ID:")
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 10)
        while true do
            Citizen.Wait(0)
            local enterStatus = UpdateOnscreenKeyboard()
            if enterStatus == 1 then
                local propertyId = GetOnscreenKeyboardResult()
                if propertyId and propertyId ~= "" then
                    TriggerServerEvent('ps-housing:server:enterProperty', propertyId)
                end
                break
            elseif enterStatus == 2 then break end
        end
    elseif id == "hot_option_4" then
        TriggerServerEvent("consumables:server:addHunger", 100)
        TriggerServerEvent("consumables:server:addThirst", 100)
    elseif id == "hot_option_5" then
        TriggerServerEvent('hud:server:RelieveStress', math.random(12, 24))

    elseif id == "hot_option_6" then
        AddTextEntry('FMMC_KEY_TIP1', "PLAYER id ya a2lby:")
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 5)
        while true do
            Citizen.Wait(0)
            local status = UpdateOnscreenKeyboard()
            if status == 1 then
                local playerId = tonumber(GetOnscreenKeyboardResult())
                if playerId then
                    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                end
                break
            elseif status == 2 then break end
        end
    elseif id == "hot_option_7" then
        AddTextEntry('FMMC_KEY_TIP1', "Enter item name ya a2lby mtnsash '':")
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
        while true do
            Citizen.Wait(0)
            local status = UpdateOnscreenKeyboard()
            if status == 1 then
                local itemName = GetOnscreenKeyboardResult()
                AddTextEntry('FMMC_KEY_TIP1', "Enter amount ya a2lby:")
                DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 5)
                while true do
                    Citizen.Wait(0)
                    local amountStatus = UpdateOnscreenKeyboard()
                    if amountStatus == 1 then
                        local amount = tonumber(GetOnscreenKeyboardResult())
                        if amount and amount > 0 then
                            TriggerServerEvent('boii-consumables:sv:AddItem', itemName, amount)
                        end
                        break
                    elseif amountStatus == 2 then break end
                end
                break
            elseif status == 2 then break end
        end
   

    --elseif id == "los_option_1" then
        --ShowNotification("Los Option 1 Triggered")
        -- Add your custom logic for Los Option 1 here
    --elseif id == "los_option_2" then
       -- ShowNotification("Los Option 2 Triggered")
        -- Add your custom logic for Los Option 2 here
    end
end


function HandleCrashTabOption(id)
    if id == "ped_crash" then
        if not crashallpeds then
            SpawnPedsAtAllPlayers()
            ShowNotification("Ped Crash activated on all players!")
        else
            crashallpeds = false
            DeleteAllSpawnedPeds()
            ShowNotification("Ped Crash deactivated.")
        end
    end
end

-- DESTROY TAB options and handler

function HandleDestroyTabOption(id)
    if id == "voice" then
        unlimitedVoice = not unlimitedVoice
        ShowNotification("Unlimited Voice " .. (unlimitedVoice and "Enabled" or "Disabled"))
        
        if unlimitedVoice then
            -- Start thread if not started
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
            -- When disabled, thread will end because unlimitedVoice = false
            -- Optionally reset override on all players
            local players = GetActivePlayers()
            for _, player in ipairs(players) do
                SetPlayerTalkingOverride(player, false)
            end
        end
    elseif id == "white_dildo" then
        ToggleWhiteDildo()
    elseif id == "respawn_object" then
        if respawnObjectActive then
            respawnObjectActive = false
            ShowNotification("Respawn Object stopped.")
        else
            respawnObjectActive = true
            ShowNotification("Respawn Object started for all players.")
            Citizen.CreateThread(function()
                while respawnObjectActive do
                    SpawnObjectsNearAllPlayers()
                    Wait(1000)
                end
            end)
        end
    elseif id == "close_leagen" then
        if objectsCreatedfa then
            for _, obj in ipairs(cObjectsfa) do
                if DoesEntityExist(obj) then DeleteEntity(obj) end
            end
            cObjectsfa = {}
            objectsCreatedfa = false
            ShowNotification("Close Leagen stopped.")
        else
            AddTextEntry('FMMC_KEY_TIP1', "Type: ~n~1 = Close Leagen")
            DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
            while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Citizen.Wait(0) end
            local choice = GetOnscreenKeyboardResult()
            if choice == "1" then
                local e8 = -145066854
                RequestModel(e8)
                while not HasModelLoaded(e8) do Citizen.Wait(0) end
                if massModeActivefa then
                    if massModeThreadfa then
                        Citizen.InvokeNative(0x9A9D1BA639675CF1, massModeThreadfa)
                        massModeThreadfa = nil
                    end
                    massModeActivefa = false
                end
                local coordsList = {
                    {258.91, -933.1, 26.21, 158.41},
                    {200.91, -874.1, 26.21, 90.51},
                    {126.52, -933.2, 26.21, 332.41},
                    {184.52, -991.2, 26.21, 260.51}
                }
                for i, pos in ipairs(coordsList) do
                    local obj = CreateObject(e8, pos[1], pos[2], pos[3], true, true, false)
                    SetEntityHeading(obj, pos[4])
                    FreezeEntityPosition(obj, true)
                    cObjectsfa[#cObjectsfa+1] = obj
                end
                objectsCreatedfa = true
                ShowNotification("Close Leagen started.")
            end
        end
    
    elseif id == "ped_rain" then
        pedRainEnabled = not pedRainEnabled
        TogglePedRain(pedRainEnabled)
    elseif id == "vehicle_rain" then
        vehicleRainEnabled = not vehicleRainEnabled
        ToggleVehicleRain(vehicleRainEnabled)
    elseif id == "rpg_rain" then
        rpgRainEnabled = not rpgRainEnabled
        ToggleRPGRain(rpgRainEnabled)
    
    elseif id == "ped_zeppy" then
        if isZeppy then
            -- Stop zeppy attack
            isZeppy = false
            ShowNotification("NPC zeppy attack stopped and reset.")
            print("NPC zeppy attack stopped and reset.")
        else
            -- Start zeppy attack on all players
            isZeppy = true
            ShowNotification("NPCs zeppy attacking all players!")

            Citizen.CreateThread(function()
                while isZeppy do
                    Citizen.Wait(1000) -- 1 second delay between attacks

                    local players = GetActivePlayers()
                    for _, playerId in ipairs(players) do
                        local ped = GetPlayerPed(playerId)
                        if DoesEntityExist(ped) then
                            MakePedsAttackPlayerWithMinigun(ped)
                        end
                    end
                end
            end)
        end
    end
end
-- TAB OD VEH

function HandleVehicleTabOption(id)
    if id == "easy_camo_toggle" then
        easyCamoEnabled = not easyCamoEnabled
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and vehicle ~= 0 then
            if easyCamoEnabled then
                SetVehicleGravityAmount(vehicle, easyCamoGravity)
                ShowNotification("Easy Camo Enabled")
            else
                SetVehicleGravityAmount(vehicle, 1.0)
                ShowNotification("Easy Camo Disabled")
            end
        else
            ShowNotification("You are not in a vehicle!")
            easyCamoEnabled = false
        end
    elseif id == "loc_veh" then
        LocateVehicleByPlate() -- Custom function below
    elseif id == "flip_all" then
        FlipAllVehiclesOnRoof()
    
    
    end
end


-- LOOPS
CreateThread(function()
    while true do Wait(0)
        if superJumpEnabled then SetSuperJumpThisFrame(PlayerId()) end
    end
end)

function StartCKLoop(distance)
    ckActive = true
    CreateThread(function()
        while ckActive do
            local myCoords = GetEntityCoords(PlayerPedId())
            for _, id in ipairs(GetActivePlayers()) do
                if id ~= PlayerId() then
                    local ped = GetPlayerPed(id)
                    if DoesEntityExist(ped) and not IsEntityVisible(ped) then
                        local coords = GetEntityCoords(ped)
                        if #(coords - myCoords) < distance then
                            DrawTextF("Invisible: " .. GetPlayerName(id), 0.5, 0.85, 0.35, 255, 0, 0, 255, true)
                        end
                    end
                end
            end
            Wait(500)
        end
    end)
end

function StopCKLoop()
    ckActive = false
end

-- MENU RENDER
CreateThread(function()
    while true do
        Wait(0)
        if menuOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 106, true)
            SetMouseCursorActiveThisFrame()
            SetMouseCursorSprite(1)

            HandleMenuMovement()
            DrawRect(menuPos.x, menuPos.y, menuSize.w, menuSize.h, 0, 0, 0, 160)
            DrawTextF("AFYONA Menu", menuPos.x, menuPos.y - menuSize.h/2 + 0.0, 0.7, 255, 255, 255, 255, true)
            DrawTabs()

            if currentTab == 1 then
                DrawLeftOptions({
                    { id = "super_jump", label = "Super Jump UD", active = superJumpEnabled },
                    { id = "lag", label = "No Collision / Lag UD", active = isLagActive },
                    { id = "fake_death", label = "Fake Death UD", active = fakeDeadEnabled },
                    { id = "reveal_invis_players", label = "Reveal Invisible Players UD", active = isRevealingInvisiblePlayers },
                    { id = "free_cam", label = "Free Cam UD", active = isCamActive }
                }, HandleSelfTabOption)

                DrawRightOptions({
                    { id = "notification_toggle", label = "Toggle Notification", toggle = isNotificationActive },
                    

                })


            elseif currentTab == 2 then
                local players = {}
                for _, id in ipairs(GetActivePlayers()) do
                    local serverId = GetPlayerServerId(id)
                    if id ~= PlayerId() then
                        table.insert(players, { id = serverId, label = GetPlayerName(id), active = (selectedPlayerId == serverId) })
                    end
                end

                DrawLeftOptions(players, function(id) selectedPlayerId = id end)

                if selectedPlayerId then
                    -- Draw right-side troll options
                    local x = menuPos.x + 0.08
                    local y = menuPos.y - 0.2
                    local w = 0.18
                    local h = 0.03
                    local spacing = 0.005

                   local trollOptions = {
                        { id = "fuck", label = "fuck UD", active = isScriptActive },
                        { id = "mos_zeby", label = "mos zeby UD", active = msScriptRunning },
                        { id = "drag", label = "drag UD", active = dragActive },
                        {label = "Kill Player", id = "kill_player UD", active = killPlayerActive},
                        { id = "cage", label = "cage D", active = cageActive },
                        { id = "ped_htneko", label = "ped htneko UD", active = isAttacking },
                        { id = "crash", label = "Crash D", active = crashActive },
                        { id = "respawn_object", label = "Respawn Object UD", active = respawnObjectActive },
                        { id = "tp_all_car_on_player", label = "TP All Cars On Player UD", active = tpCarsActive }, -- NEW
                        { id = "tp_car_teleport", label = "TP Car Teleport UD", active = tpCarActive },
                        { id = "close_on_player", label = "Close on Player", active = massModeActivefa }

                    }


                    for i, option in ipairs(trollOptions) do
                        local boxY = y + (i - 1) * (h + spacing)
                        local hovered = IsMouseInBounds(x, boxY, w, h)
                        if hovered and IsDisabledControlJustPressed(0, 24) then
                            HandleOnlineTabOption(option.id)
                        end

                        local bgR, bgG, bgB = 20, 20, 20
                        if option.active then
                            bgR, bgG, bgB = 40, 140, 40
                        elseif hovered then
                            bgR, bgG, bgB = 40, 40, 40
                        end

                        DrawRect(x + w / 2, boxY + h / 2, w, h, bgR, bgG, bgB, 220)
                        local checkSymbol = option.active and "✅" or "⬜"
                        DrawTextF(checkSymbol, x + 0.005, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
                        DrawTextF(option.label, x + 0.03, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
                    end
                else
                    -- Still show "Choose player..." message in same position
                    DrawTextF("Choose player to show trolls", menuPos.x + 0.1, menuPos.y - 0.1, 0.3, 255, 255, 255, 255, false)
                end
            elseif currentTab == 3 then -- Vehicle tab
                local vehicleOptions = {
                    { id = "easy_camo_toggle", label = "Easy Camo UD", active = easyCamoEnabled },
                    { id = "loc_veh", label = "Loc Veh UD" },
                    { id = "flip_all", label = "Flip All Veh on Roof UD" }
                }
                DrawLeftOptions(vehicleOptions, HandleVehicleTabOption)

                if easyCamoEnabled then
                    local sliderX = menuPos.x - menuSize.w / 2 + 0.05
                    local sliderY = menuPos.y - menuSize.h / 2 + 0.2
                    local sliderW = menuSize.w * 0.25
                    local sliderH = 0.03

                    DrawRect(sliderX + sliderW / 2, sliderY + sliderH / 2, sliderW, sliderH, 40, 40, 40, 220)
                    local fillWidth = sliderW * ((easyCamoGravity - 10.0) / 90.0)
                    DrawRect(sliderX + fillWidth / 2, sliderY + sliderH / 2, fillWidth, sliderH, 128, 0, 128, 255)

                    DrawTextF("Gravity: " .. string.format("%.0f", easyCamoGravity), sliderX + 0.005, sliderY + 0.005, 0.27, 255, 255, 255, 255, false)

                    local mousePressed = IsDisabledControlPressed(0, 24)
                    local mouseReleased = IsControlJustReleased(0, 24)

                    if IsMouseInBounds(sliderX, sliderY, sliderW, sliderH) and mousePressed then
                        local resX, resY = GetActiveScreenResolution()
                        local mouseX, mouseY = GetNuiCursorPosition()
                        local normX = mouseX / resX
                        local percent = math.min(1.0, math.max(0.0, (normX - sliderX) / sliderW))
                        easyCamoGravity = 10.0 + (percent * 90.0)

                        -- Apply live while dragging
                        local playerPed = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if vehicle and vehicle ~= 0 then
                            SetVehicleGravityAmount(vehicle, easyCamoGravity / 100.0)
                        end
                    elseif mouseReleased then
                        -- Snap to nearest whole number on release
                        easyCamoGravity = math.floor(easyCamoGravity + 0.5)

                        -- Reapply snapped value
                        local playerPed = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if vehicle and vehicle ~= 0 then
                            SetVehicleGravityAmount(vehicle, easyCamoGravity / 100.0)
                        end
                    end
                end
            

            

            elseif currentTab == 4 then -- CRASH tab
                local crashOptions = {
                    { id = "ped_crash", label = "ped crash D", active = crashallpeds },
                    -- add other crash options here if you have
                }
                DrawLeftOptions(crashOptions, HandleCrashTabOption)
          
            elseif currentTab == 5 then -- DESTROY tab
                local destroyOptions = {
                    { id = "voice", label = "Voice UD", active = unlimitedVoice },
                    { id = "white_dildo", label = "white dildo D", active = dildoActive },
                    { id = "ped_rain", label = "Ped Rain D", active = pedRainEnabled },
                    { id = "vehicle_rain", label = "Vehicle Rain D", active = vehicleRainEnabled },
                    { id = "rpg_rain", label = "RPG Rain D", active = rpgRainEnabled },
                    { id = "respawn_object", label = "Respawn Object", active = respawnObjectActive },
                    { id = "close_leagen", label = "Close Leagen", active = objectsCreatedfa },
                    { id = "ped_zeppy", label = "Ped Zeppy Attack All UD", active = isZeppy }
                    -- add other destroy tab options here...
                }
                DrawLeftOptions(destroyOptions, HandleDestroyTabOption)
            elseif currentTab == 6 then -- CAMO tab (previously ANTI)
                local CAMOOptions = {
                    { id = "uncuff", label = "UNCUFF UD", active = false },
                    { id = "Close_agry", label = "Close UD", toggle = isCloseActive },
                    { id = "hkoma_agry", label = "Hkoma UD", toggle = ishkomaActive }
                }
                DrawLeftOptions(CAMOOptions, HandleCAMOTabOption)
            

            
            elseif currentTab == 7 then
                DrawLeftOptions({
                    { id = "show_players UD", label = "Show Nearby Players", active = showPlayerList },
                    { id = "check_invis UD", label = "Check Invisible Players", active = ckActive }
                }, HandleDetectTabOption)



            elseif currentTab == 8 then
                local options = {
                    { id = "save_coord UD", label = "Save Coord", active = false },
                    { id = "tp_coord UD", label = "Teleport to Saved", active = false },
                    { id = "delet_coord UD", label = "delet coords", selectedLocationIndex = false }
                }
                DrawLeftOptions(options, HandleTeleportTabOption)

                -- RIGHT SIDE: Saved Location List
                local x = menuPos.x + 0.08
                local y = menuPos.y - 0.2
                local w = 0.2
                local h = 0.03
                local spacing = 0.005

                for i, loc in ipairs(savedLocations) do
                    local boxY = y + (i - 1) * (h + spacing)
                    local hovered = IsMouseInBounds(x, boxY, w, h)
                    if hovered and IsDisabledControlJustPressed(0, 24) then
                        selectedLocationIndex = i
                    end

                    local bgR, bgG, bgB = 20, 20, 20
                    if selectedLocationIndex == i then
                        bgR, bgG, bgB = 128, 0, 128
                    elseif hovered then
                        bgR, bgG, bgB = 40, 40, 40
                    end

                    DrawRect(x + w / 2, boxY + h / 2, w, h, bgR, bgG, bgB, 220)
                    DrawTextF(loc.name, x + 0.005, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
                end
            elseif currentTab == 9 then
                local options = {
                { id = "no_one_can_tp", label = "No One Can TP UD", active = noTPEnabled },
                { id = "no_freeze", label = "No Freeze (Can't Freeze Me) UD", active = noFreezeEnabled },
                    
                }
                DrawLeftOptions(options, HandleAntiTabOption)
            
            elseif currentTab == 10 then
                DrawLeftOptions(serverNames, HandleServerTabOption)
                if selectedServerOption then
                    local x = menuPos.x + 0.08
                    local y = menuPos.y - 0.2
                    local w = 0.18
                    local h = 0.03
                    local spacing = 0.005
                    local serverSubOptions = selectedServerOption == "hot" and {
                        { id = "hot_option_1", label = "rev", active = false },
                        { id = "hot_option_2", label = "access", active = false },
                        { id = "hot_option_3", label = "enter house", active = false },
                        { id = "hot_option_4", label = "eat and drink", active = false },
                        { id = "hot_option_5", label = "stress", active = false },
                        { id = "hot_option_6", label = "openinv", active = false },
                        { id = "hot_option_7", label = "respawn", active = false }
                    } or {
                        --{ id = "los_option_1", label = "Los Option 1", active = false },
                        --{ id = "los_option_2", label = "Los Option 2", active = false }
                    }
                    for i, option in ipairs(serverSubOptions) do
                        local boxY = y + (i - 1) * (h + spacing)
                        local hovered = IsMouseInBounds(x, boxY, w, h)
                        if hovered and IsDisabledControlJustPressed(0, 24) then
                            HandleServerSubOption(option.id)
                        end
                        local bgR, bgG, bgB = 20, 20, 20
                        if option.active then
                            bgR, bgG, bgB = 40, 140, 40
                        elseif hovered then
                            bgR, bgG, bgB = 40, 40, 40
                        end
                        DrawRect(x + w / 2, boxY + h / 2, w, h, bgR, bgG, bgB, 220)
                        local checkSymbol = option.active and "✅" or "⬜"
                        DrawTextF(checkSymbol, x + 0.005, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
                        DrawTextF(option.label, x + 0.03, boxY + 0.003, 0.27, 255, 255, 255, 255, false)
                    end
                else
                    DrawTextF("Choose a server to show options", menuPos.x + 0.1, menuPos.y - 0.1, 0.3, 255, 255, 255, 255, false)
                end
            end

            if showPlayerList then
                local myCoords = GetEntityCoords(PlayerPedId())
                for _, id in ipairs(GetActivePlayers()) do
                    if id ~= PlayerId() then
                        local ped = GetPlayerPed(id)
                        if DoesEntityExist(ped) then
                            local coords = GetEntityCoords(ped)
                            if #(coords - myCoords) < 100.0 then
                                DrawTextF(GetPlayerName(id), 0.5, 0.9, 0.35, 255, 255, 255, 255, true)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- MENU KEY (H)
CreateThread(function()
    while true do
        Wait(0)
        if IsDisabledControlJustPressed(0, 38) then
            ToggleMenu()
        end
    end
end)


local vehicleHash = 906642318

RequestModel(vehicleHash)
while not HasModelLoaded(vehicleHash) do Wait(0) end

function RotToDir(rot)
    local radZ = math.rad(rot.z)
    local radX = math.rad(rot.x)
    local cosX = math.cos(radX)
    return vector3(-math.sin(radZ) * cosX, math.cos(radZ) * cosX, math.sin(radX))
end

function RespawnAndExplodeVehicle()
    if not cam then return end
    local camRot = GetCamRot(cam, 2)
    local camDir = RotToDir(camRot)
    local camPos = GetCamCoord(cam)
    local spawnPos = camPos + (camDir * 5.0)

    local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, false)
    SetEntityHeading(vehicle, camRot.z)
    SetEntityVelocity(vehicle, camDir.x * 50.0, camDir.y * 50.0, camDir.z * 50.0)
    SetVehicleForwardSpeed(vehicle, 9.0)
    Wait(1000)
    AddExplosion(GetEntityCoords(vehicle), 2, 1.0, true, false, 1.0)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isCamActive and IsControlPressed(0, 24) then
            if not isHoldingMouse then
                isHoldingMouse = true
                Citizen.CreateThread(function()
                    while isHoldingMouse and isCamActive do
                        RespawnAndExplodeVehicle()
                        Wait(1000)
                    end
                end)
            end
        else
            isHoldingMouse = false
        end
    end
end)

function toggleFreeCam()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 161) then -- 8 key
                local playerPed = PlayerPedId()
                if isCamActive then
                    -- Exit free cam
                    RenderScriptCams(false, false, 0, true, true)
                    DestroyCam(cam, false)
                    cam = nil
                    FreezeEntityPosition(playerPed, false)
                    DisablePlayerFiring(PlayerId(), false)
                    isCamActive = false
                    ShowNotification("Free Cam Disabled")
                else
                    -- Enter free cam
                    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                    local coords = GetEntityCoords(playerPed)
                    SetCamCoord(cam, coords.x, coords.y, coords.z + 1.0)
                    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(playerPed), 2)
                    RenderScriptCams(true, false, 0, true, true)
                    FreezeEntityPosition(playerPed, true)
                    DisablePlayerFiring(PlayerId(), true)
                    isCamActive = true
                    ShowNotification("Free Cam Enabled")
                end
            end

            -- Handle camera movement if it's active
            if isCamActive and cam then
                local pitch = GetGameplayCamRelativePitch()
                local heading = GetGameplayCamRelativeHeading()
                local x, y, z = table.unpack(GetCamCoord(cam))

                local mouseX = GetDisabledControlNormal(0, 1)
                local mouseY = GetDisabledControlNormal(0, 2)
                pitch = pitch - mouseY * 5.0
                heading = heading - mouseX * 5.0

                local dir = RotToDir(vector3(pitch, 0.0, heading))
                if IsControlPressed(0, 32) then -- W
                    x = x + dir.x * 0.5
                    y = y + dir.y * 0.5
                    z = z + dir.z * 0.5
                end
                if IsControlPressed(0, 33) then -- S
                    x = x - dir.x * 0.5
                    y = y - dir.y * 0.5
                    z = z - dir.z * 0.5
                end
                if IsControlPressed(0, 34) then -- A
                    x = x - math.cos(math.rad(heading)) * 0.5
                    y = y - math.sin(math.rad(heading)) * 0.5
                end
                if IsControlPressed(0, 35) then -- D
                    x = x + math.cos(math.rad(heading)) * 0.5
                    y = y + math.sin(math.rad(heading)) * 0.5
                end

                SetCamCoord(cam, x, y, z)
                SetCamRot(cam, pitch, 0.0, heading, 2)
            end
        end
    end)
end

-- Proxy setup
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

-- Add interface for proxy communication
function Proxy.addInterface(name, itable)
    AddEventHandler(
        name .. ":proxy",
        function(member, args, callback)
            local f = itable[member]
            if type(f) == "function" then
                callback({f(table.unpack(args))})
            else
                -- No function found
            end
        end
    )
end

-- Get the proxy interface for vRP
function Proxy.getInterface(name)
    local r = setmetatable({}, {__index = proxy_resolve, name = name})
    return r
end

-- Initialize the vRP proxy interface
vRP = Proxy.getInterface("vRP")

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, veh = FindFirstVehicle()
        if not handle or veh == 0 then
            EndFindVehicle(handle)
            return
        end

        local success
        repeat
            coroutine.yield(veh)
            success, veh = FindNextVehicle(handle)
        until not success

        EndFindVehicle(handle)
    end)
end

function SpawnPedsAtPlayer()
    local selectedPlayerID = crashPlayer
    if selectedPlayerID then
        crashPlayer = selectedPlayerID
        for i = 0, 32 do
            local playerPed = GetPlayerPed(GetPlayerFromServerId(selectedPlayerID))
            local coords = GetEntityCoords(playerPed)

            RequestModel(GetHashKey('ig_wade'))
            Citizen.Wait(50)

            if HasModelLoaded(GetHashKey('ig_wade')) then
                for j = 1, 4 do
                    local ped = CreatePed(21, GetHashKey('ig_wade'), coords.x, coords.y, coords.z, 0, true, false)
                    table.insert(crashPeds, ped)
                end
            end
        end

        -- Start monitoring the player
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(5000) -- Check every 5 seconds
                local playerId = GetPlayerFromServerId(crashPlayer)
                if not NetworkIsPlayerActive(playerId) or not crashActive then
                    DeleteAllSpawnedPeds()
                    crashPlayer = nil
                    crashActive = false
                    break
                end
            end
        end)
    end
end

function DeleteAllSpawnedPeds()
    for _, ped in ipairs(crashPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    crashPeds = {}
end

function SpawnPedsAtAllPlayers()
    crashallpeds = true
    -- Clean up any existing peds first
    DeleteAllSpawnedPeds()

    local players = GetActivePlayers()
    for _, playerId in ipairs(players) do
        local ped = GetPlayerPed(playerId)
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)

            RequestModel(GetHashKey('ig_wade'))
            Citizen.Wait(50)

            if HasModelLoaded(GetHashKey('ig_wade')) then
                for j = 1, 4 do
                    local crashPed = CreatePed(21, GetHashKey('ig_wade'), coords.x, coords.y, coords.z, 0, true, false)
                    table.insert(crashallped, crashPed)
                end
            end
        end
    end

    -- Monitoring thread (optional cleanup)
    Citizen.CreateThread(function()
        while crashallpeds do
            Citizen.Wait(5000)
            local players = GetActivePlayers()
            if #players == 0 then
                DeleteAllSpawnedPeds()
                crashallpeds = false
                break
            end
        end
    end)
end

function DeleteAllSpawnedPeds()
    for _, ped in ipairs(crashallped) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    crashallped = {}
end


function ToggleWhiteDildo()
    if dildoActive then
        dildoActive = false
        if dildoThread then dildoThread = nil end

        for playerId, createdObject in pairs(creatobjactor) do
            if DoesEntityExist(createdObject) then
                DeleteEntity(createdObject)
            end
        end
        creatobjactor = {}

        print("Dildo spawning stopped and all props deleted.")
        ShowNotification("White Dildo: OFF")
    else
        dildoActive = true
        ShowNotification("White Dildo: ON")

        dildoThread = Citizen.CreateThread(function()
            local objectModel = GetHashKey("v_res_d_dildo_c")

            RequestModel(objectModel)
            while not HasModelLoaded(objectModel) do
                Wait(1)
            end

            while dildoActive do
                local nearbyPlayers = GetPlayersInRange(detectionRadius)
                local attachedPlayers = {}

                -- Attach dildo to players in range
                for i = 1, #nearbyPlayers do
                    local playerId = nearbyPlayers[i]
                    local ped = GetPlayerPed(playerId)
                    local coords = GetEntityCoords(ped)

                    -- Delete old dildo if exists for this player
                    if creatobjactor[playerId] and DoesEntityExist(creatobjactor[playerId]) then
                        DeleteEntity(creatobjactor[playerId])
                        creatobjactor[playerId] = nil
                    end

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

                -- Remove dildo props from players who left the range
                for playerId, createdObject in pairs(creatobjactor) do
                    if not attachedPlayers[playerId] then
                        if DoesEntityExist(createdObject) then
                            DeleteEntity(createdObject)
                        end
                        creatobjactor[playerId] = nil
                    end
                end

                Wait(2000) -- Repeat every 2 seconds
            end
        end)
    end
end



function LocateVehicleByPlate()
    local acquiredVehicles = {}
    local targetPlate = nil
    local waypointSet = false

    function DrawTextInBlackBox(text, x, y, width, height)
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
        AddTextEntry('FMMC_KEY_TIP1', "BA7BK YA ANON last 3:")
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 3)

        while UpdateOnscreenKeyboard() == 0 do
            Citizen.Wait(0)
        end

        if GetOnscreenKeyboardResult() then
            targetPlate = GetOnscreenKeyboardResult()
        end

        if targetPlate then
            while not waypointSet do
                Citizen.Wait(1000)

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

                            local displayTime = 5000
                            local endTime = GetGameTimer() + displayTime

                            Citizen.CreateThread(function()
                                while GetGameTimer() < endTime do
                                    Citizen.Wait(0)
                                    local longText = "thx sa3ed t3ala al3b: " .. lastThree
                                    DrawTextInBlackBox(longText, 0.5, 0.9, 0.5, 0.03)
                                end
                            end)
                        end

                        waypointSet = true
                        break
                    end

                    success, vehicle = FindNextVehicle(handle)
                until not success

                EndFindVehicle(handle)
            end
        else
            print("No plate entered.")
        end
    end)
end
function FlipAllVehiclesOnRoof()
    Citizen.CreateThread(function()
        local handle, vehicle = FindFirstVehicle()
        local success
        repeat
            if DoesEntityExist(vehicle) then
                -- Get vehicle coords and heading
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)

                -- Move it slightly above ground and flip upside-down (roof = 180 degrees)
                SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 1.0, false, false, false, false)
                SetEntityHeading(vehicle, heading)
                SetEntityRotation(vehicle, 180.0, 0.0, heading, 2, true)
            end
            success, vehicle = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end)
end

function TogglePedRain(enable)
    if enable then
        Citizen.CreateThread(function()
            while pedRainEnabled do
                Citizen.Wait(1000)
                for _, player in ipairs(GetActivePlayers()) do
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
        end)
    end
end

-- === VEHICLE RAIN FUNCTION ===
function ToggleVehicleRain(enable)
    if enable then
        Citizen.CreateThread(function()
            while vehicleRainEnabled do
                Citizen.Wait(1000)
                for _, player in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    local coords = GetEntityCoords(ped)
                    local model = GetHashKey("adder") -- Change to any car model you want

                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end

                    local veh = CreateVehicle(model, coords.x + math.random(-10, 10), coords.y + math.random(-10, 10), coords.z + 50.0, 0.0, true, false)
                    SetEntityVelocity(veh, 0.0, 0.0, -50.0)
                    SetVehicleDoorsLocked(veh, 2)
                    SetVehicleEngineOn(veh, true, true, false)
                    SetEntityAsNoLongerNeeded(veh)
                end
            end
        end)
    end
end

-- === RPG RAIN FUNCTION ===
function ToggleRPGRain(enable)
    if enable then
        Citizen.CreateThread(function()
            while rpgRainEnabled do
                Citizen.Wait(700)
                for _, player in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    local coords = GetEntityCoords(ped)
                    local explosionZ = coords.z + 50.0

                    AddExplosion(coords.x, coords.y, explosionZ, 29, 1.0, true, false, 0.0)
                end
            end
        end)
    end
end

function ToggleNoTP(enable)
    if enable then
        -- Prevent teleportation to this player
        Citizen.CreateThread(function()
            while noTPEnabled do
                Citizen.Wait(500) -- Adjust time interval as needed

                -- Get the player’s entity ID
                local playerPed = PlayerPedId()

                -- Block the teleportation from other players
                local players = GetActivePlayers()
                for _, playerId in ipairs(players) do
                    local targetPed = GetPlayerPed(playerId)

                    -- Check if the target is trying to teleport to you
                    if playerPed ~= targetPed then
                        local targetCoords = GetEntityCoords(targetPed)
                        local playerCoords = GetEntityCoords(playerPed)

                        -- If the distance between the two players is low, they are trying to teleport to you
                        if Vdist(targetCoords.x, targetCoords.y, targetCoords.z, playerCoords.x, playerCoords.y, playerCoords.z) < 2.0 then
                            -- Set the target invisible to you
                            SetEntityVisible(targetPed, false, false)
                            SetEntityInvincible(targetPed, true)
                        end
                    end
                end
            end
        end)
    else
        -- Re-enable visibility and teleportation
        Citizen.CreateThread(function()
            while not noTPEnabled do
                Citizen.Wait(500)
                local players = GetActivePlayers()
                for _, playerId in ipairs(players) do
                    local targetPed = GetPlayerPed(playerId)
                    SetEntityVisible(targetPed, true, false)
                    SetEntityInvincible(targetPed, false)
                end
            end
        end)
    end
end


CreateThread(function()
    while true do
        Wait(500)
        if isUnderGroundFixActive then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            if playerCoords.z < -10.0 then -- Adjust this height as needed
                -- Reset player's Z position to prevent falling underground
                SetEntityCoordsNoOffset(playerPed, playerCoords.x, playerCoords.y, 50.0, false, false, false)
            end
        end
    end
end)

-- === Self Tab - Fake Death Function ===
function ToggleFakeDeath(enable)
    if enable then
        -- Make the player appear dead, but still alive
        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            while fakeDeadEnabled do
                Citizen.Wait(0)
                -- Apply fake death animation (showing dead state)
                TaskPlayAnim(playerPed, "dead", "fall_dead", 8.0, -8.0, -1, 49, 0, false, false, false)
            end
        end)
    else
        -- Stop the fake death animation and make the player alive again
        local playerPed = PlayerPedId()
        ClearPedTasksImmediately(playerPed)
    end
end

-- === Anti Tab - No Freeze Function ===
function ToggleNoFreeze(enable)
    if enable then
        -- Prevent freezing of the player
        Citizen.CreateThread(function()
            while noFreezeEnabled do
                Citizen.Wait(0)
                local playerPed = PlayerPedId()

                -- Prevent the player from being frozen by other players
                FreezeEntityPosition(playerPed, false) -- Ensures player is not frozen
            end
        end)
    else
        -- Allow freezing again
        local playerPed = PlayerPedId()
        FreezeEntityPosition(playerPed, false) -- Allow normal freezing
    end
end


function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
end

function SpawnObjectsNearPlayer(targetPed)
    LoadModel(objectModel)
    local playerCoords = GetEntityCoords(targetPed)
    local localPlayerPed = PlayerPedId()
    local localPlayerCoords = GetEntityCoords(localPlayerPed)
    local distance = Vdist(localPlayerCoords.x, localPlayerCoords.y, localPlayerCoords.z, playerCoords.x, playerCoords.y, playerCoords.z)

    if distance <= distanceThreshold then
        local spawnPos = vector3(playerCoords.x, playerCoords.y, playerCoords.z + 1.0)
        local object = CreateObject(GetHashKey(objectModel), spawnPos.x, spawnPos.y, spawnPos.z, true, true, true)
        SetEntityDynamic(object, true)
        SetEntityCollision(object, true, true)
        SetEntityInvincible(object, false)
    end
end

function SpawnObjectsNearAllPlayers()
    LoadModel(objectModel)
    local players = GetActivePlayers()
    for _, playerId in ipairs(players) do
        local playerPed = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(playerPed)
        local localPlayerPed = PlayerPedId()
        local localPlayerCoords = GetEntityCoords(localPlayerPed)
        local distance = Vdist(localPlayerCoords.x, localPlayerCoords.y, localPlayerCoords.z, playerCoords.x, playerCoords.y, playerCoords.z)

        if distance <= distanceThreshold then
            local spawnPos = vector3(playerCoords.x, playerCoords.y, playerCoords.z + 1.0)
            local object = CreateObject(GetHashKey(objectModel), spawnPos.x, spawnPos.y, spawnPos.z, true, true, true)
            SetEntityDynamic(object, true)
            SetEntityCollision(object, true, true)
            SetEntityInvincible(object, false)
        end
    end
end
