ESX = nil
spawncoords = vector3(-797.37, 326.358, 190.713)
createdChars = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function (obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local charAnims = {
    {isAnim = true, dic = "anim@amb@nightclub@peds@", name = "rcmme_amanda1_stand_loop_cop"},
    {isAnim = false, h = 359.1, dic = "WORLD_HUMAN_LEANING"},
    {isAnim = false, dic = "WORLD_HUMAN_SMOKING_POT"},
    {isAnim = false, dic = "WORLD_HUMAN_PARTYING"},
    {isAnim = false, dic = "WORLD_HUMAN_MUSCLE_FLEX"},
    {isAnim = true, dic = "anim@amb@casino@hangout@ped_male@stand@02b@idles", name = "idle_a"}
}

HiddenCoords = {x = -800.94, y = 332.406, z = 190.713, h = 174.64}

Citizen.CreateThread(function()
    Citizen.Wait(7)
    if NetworkIsSessionStarted() then
        Citizen.Wait(100)
        TriggerServerEvent("kashactersS:SetupCharacters")
        TriggerEvent("kashactersC:SetupCharacters")
    end
end)

local IsChoosing = true
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if IsChoosing then
            DisplayHud(false)
            DisplayRadar(false)
        end
    end
end)

local cam = nil
local cam2 = nil

RegisterNetEvent('kashactersC:SetupCharacters')
AddEventHandler('kashactersC:SetupCharacters', function()
    DoScreenFadeOut(10)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1)

    SetCamCoord(cam, -797.80, 328.998, 190.900 )
	SetCamRot(cam, 5.0, 0.0, 540.0)
    SetCamFov(cam, 22.0)
    



    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)

    local interior = GetInteriorAtCoords(-791.28, 336.134, 190.076)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Citizen.Wait(1000)
        print("[Yükleniyor... Lütfen Bekleyin!]")
    end
    SetEntityCoords(PlayerPedId(), HiddenCoords.x, HiddenCoords.y, HiddenCoords.z)
    -- ped 
    CreatePeds(1)
end)

function CreatePeds(i)
        Citizen.CreateThread(function()
            ESX.TriggerServerCallback('kcdd-kashacters:GetPlayerData', function(Player)
                Citizen.Wait(1)
                if Player ~= nil then
                    local PlayerSkin = json.decode(Player['skin'])
                    DeleteEntity(charPed)
                    ClearPedTasks(charPed)
                    ClearPedTasksImmediately(charPed)
                    
                    local model
                    if PlayerSkin['sex'] == 0 then
                        model = "mp_m_freemode_01"
                    else
                        model = "mp_f_freemode_01"
                    end
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    local charPed = CreatePed(3, model, -797.37, 326.400, 190.713 - 1, 359.1, false, true)
                    local random = math.random(1, #charAnims)

                    if charAnims[random].isAnim == true then
                        ESX.Streaming.RequestAnimDict(charAnims[random].dic, function() 
                            TaskPlayAnim(charPed, charAnims[random].dic, charAnims[random].name, 2.0, 2.0, -1, 33, 0, false, false, false)
                        end)
                    else
                        TaskStartScenarioInPlace(charPed, charAnims[random].dic, 0, true)
                    end
                    
                    ApplySkinForPed(charPed, PlayerSkin)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    table.insert(createdChars, {
                        ped = charPed
                    })   
                else
                    DeleteEntity(charPed)
                    local model = "mp_m_freemode_01"
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    local charPed = CreatePed(3, model, -797.37, 326.400, 190.713 - 0.98,  359.1, false, true)
                    SetEntityAlpha(charPed, 100)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, true)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    table.insert(createdChars, {
                        ped = charPed
                    })
                end
            end, i)
        end)
end

RegisterNetEvent('kashactersC:SetupUI')
AddEventHandler('kashactersC:SetupUI', function(Characters)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        characters = Characters
    })
end)

function ApplySkinForPed(char ,Character)
    SetPedHeadBlendData(char, Character['face'], Character['face'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)
    SetPedComponentVariation(char, 8,  Character['tshirt_1'],    Character['tshirt_2'], 2)	
    SetPedComponentVariation(char, 11, Character['torso_1'],	    Character['torso_2'], 2)					
    SetPedComponentVariation(char, 3,  Character['arms'],	    Character['arms_2'], 2)		
    SetPedComponentVariation(char, 10, Character['decals_1'],    Character['decals_2'], 2)	
    SetPedComponentVariation(char, 4,  Character['pants_1'],	    Character['pants_2'], 2)	
    SetPedComponentVariation(char, 6,  Character['shoes_1'],	    Character['shoes_2'], 2)	
    SetPedComponentVariation(char, 1,  Character['mask_1'],	    Character['mask_2'], 2)		
    SetPedComponentVariation(char, 9,  Character['bproof_1'],    Character['bproof_2'], 2)					
    SetPedComponentVariation(char, 7,  Character['chain_1'],	    Character['chain_2'], 2)	
    SetPedComponentVariation(char, 5,  Character['bags_1'],	    Character['bags_2'], 2)
    SetPedComponentVariation(char, 2,  Character['hair_1'],      Character['hair_2'], 2)
	SetPedHairColor			(char,			Character['hair_color_1'],		Character['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay		(char, 3,		Character['age_1'],				(Character['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay		(char, 0,		Character['blemishes_1'],		(Character['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
	SetPedHeadOverlay		(char, 1,		Character['beard_1'],			(Character['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor			(char,			Character['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay		(char, 2,		Character['eyebrows_1'],		(Character['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedHeadOverlay		(char, 4,		Character['makeup_1'],			(Character['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
	SetPedHeadOverlay		(char, 8,		Character['lipstick_1'],		(Character['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
	SetPedComponentVariation(char, 2,		Character['hair_1'],			Character['hair_2'], 2)						-- Hair
	SetPedHeadOverlayColor	(char, 1, 1,	Character['beard_3'],			Character['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor	(char, 2, 1,	Character['eyebrows_3'],		Character['eyebrows_4'])					-- Eyebrows Color
	SetPedHeadOverlayColor	(char, 4, 1,	Character['makeup_3'],			Character['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor	(char, 8, 1,	Character['lipstick_3'],		Character['lipstick_4'])					-- Lipstick Color
	SetPedHeadOverlay		(char, 5,		Character['blush_1'],			(Character['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor	(char, 5, 2,	Character['blush_3'])														-- Blush Color
	SetPedHeadOverlay		(char, 6,		Character['complexion_1'],		(Character['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay		(char, 7,		Character['sun_1'],				(Character['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay		(char, 9,		Character['moles_1'],			(Character['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay		(char, 10,		Character['chest_1'],			(Character['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor	(char, 10, 1,	Character['chest_3'])														-- Torso Color
	SetPedHeadOverlay		(char, 11,		Character['bodyb_1'],			(Character['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity

    if Character['helmet_1'] == -1 then
        ClearPedProp(char, 0)
    else
        SetPedPropIndex(char, 0, Character['helmet_1'],    Character['helmet_2'], 2)
    end
    
    if Character['glasses_1'] == -1 then
        ClearPedProp(char, 1)
    else
        SetPedPropIndex(char, 1, Character['glasses_1'],   Character['glasses_2'], 2)
    end
    
    if Character['watches_1'] == -1 then
        ClearPedProp(char, 6)
    else
        SetPedPropIndex(char, 6, Character['watches_1'],   Character['watches_2'], 2)
    end
    
    if Character['bracelets_1'] == -1 then
        ClearPedProp(char,	7)
    else
        SetPedPropIndex(char, 7, Character['bracelets_1'], Character['bracelets_2'], 2)
    end
end


RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(spawn, isnew)
    SetTimecycleModifier('default')
    local pos = spawn

    TriggerEvent('esx:kashloaded')

    if isnew == true then
        
        SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
        SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
        DoScreenFadeIn(500)
        Citizen.Wait(500)
        cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
        PointCamAtCoord(cam2, pos.x,pos.y,pos.z + 200)
        SetCamActiveWithInterp(cam2, cam, 900, true, true)
        Citizen.Wait(900)

        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
        PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
        SetCamActiveWithInterp(cam, cam2, 3700, true, true)
        Citizen.Wait(3700)
        PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
        RenderScriptCams(false, true, 500, true, true)
        PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        Citizen.Wait(500)
        SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        IsChoosing = false
        DisplayHud(true)
        DisplayRadar(true)
        Citizen.Wait(1000)
        return
    end

    TriggerEvent("spawnselector:openspawner")



end)

RegisterNetEvent('kashactersC:ReloadCharacters')
AddEventHandler('kashactersC:ReloadCharacters', function()
    TriggerServerEvent("kashactersS:SetupCharacters")
    TriggerEvent("kashactersC:SetupCharacters")
end)

RegisterNUICallback("CharacterChosen", function(data, cb)
    SetNuiFocus(false,false)
    DoScreenFadeOut(500)
    TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar, data.loc)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    for k,v in pairs(createdChars) do
        DeleteEntity(v.ped)
        createdChars = {}
    end

    cb("ok")
end)

RegisterNUICallback("DeleteCharacter", function(data, cb)
    SetNuiFocus(false,false)
    DoScreenFadeOut(500)
    TriggerServerEvent('kashactersS:DeleteCharacter', data.charid)

    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    for k,v in pairs(createdChars) do
        DeleteEntity(v.ped)
        createdChars = {}
    end
    cb("ok")
end)

RegisterNUICallback("changeCharacter", function(data, cb)

    for k,v in pairs(createdChars) do
        DeleteEntity(v.ped)
        createdChars = {}
    end

    CreatePeds(data.charId)
    cb("ok")
end)