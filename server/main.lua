---------------------------------------------------------------------------------------
-- Edit this table to all the database tables and columns
-- where identifiers are used (such as users, owned_vehicles, owned_properties etc.)
---------------------------------------------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local IdentifierTables = {
    {table = "addon_account_data",   column = "owner"},
    {table = "billing",              column = "identifier"},
    {table = "datastore_data",       column = "owner"},
    {table = "characters",           column = "identifier"},
    {table = "communityservice",     column = "identifier"},
    {table = "crew_phone_bank",      column = "identifier"},
    {table = "disc_ammo",            column = "owner"},
    {table = "luck_crafting",        column = "identifier"},
    {table = "m3_inv_stashs",        column = "owner"},
    {table = "m3_stashhouse",        column = "owner"},
    {table = "m3_stashhouse",        column = "keys"},
    {table = "m3_user_peds",         column = "identifier"},
    {table = "owned_shops",          column = "identifier"},
    {table = "owned_vehicles",       column = "owner"},
    {table = "phone_users_contacts", column = "identifier"},
    {table = "shipments",            column = "identifier"},
    {table = "twitter_accounts",     column = "identifier"},
    {table = "users",                column = "identifier"},
    {table = "twitter_tweets",       column = "realUser"},
    {table = "user_licenses",        column = "owner"}
}

RegisterServerEvent("kashactersS:SetupCharacters")
AddEventHandler('kashactersS:SetupCharacters', function()
    local src = source
    xPlayer = ESX.GetPlayerFromId(src)
    local LastCharId = GetLastCharacter(src)
    SetIdentifierToChar(GetPlayerIdentifiers(src)[1], LastCharId)
    local Characters = GetPlayerCharacters(src)
    local image = GetPlayerImage(src)

    for i = 1, #Characters, 1 do
        Characters[i].money = json.decode(Characters[i].accounts).money
        Characters[i].bank = json.decode(Characters[i].accounts).bank
        Characters[i].avatar = image[i]
    end

    TriggerClientEvent('kashactersC:SetupUI', src, Characters)
end)

RegisterServerEvent("kashactersS:CharacterChosen")
AddEventHandler('kashactersS:CharacterChosen', function(charid, ischar, loc)
    local src = source
    local spawn = {}
    local isnew = true
    SetLastCharacter(src, tonumber(charid))
    SetCharToIdentifier(GetPlayerIdentifiers(src)[1], tonumber(charid))
    if ischar == "true" then
        spawn = { x = 195.55, y = -933.36, z = 29.90 }
        isnew = false
    else
        TriggerClientEvent('skinchanger:loadDefaultModel', src, true, cb)
        TriggerClientEvent("jsfour-register:open", src)
        spawn = { x = 195.55, y = -933.36, z = 29.90 }
        isnew = true
    end
    TriggerClientEvent("kashactersC:SpawnCharacter", src, spawn, isnew)
end)

RegisterServerEvent("kashactersS:DeleteCharacter")
AddEventHandler('kashactersS:DeleteCharacter', function(charid)
    local src = source
    DeleteCharacter(GetPlayerIdentifiers(src)[1], charid)
    TriggerClientEvent("kashactersC:ReloadCharacters", src)
end)

function GetLastCharacter(source)
    local LastChar = MySQLAsyncExecute("SELECT `charid` FROM `user_lastcharacter` WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
    if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
        return tonumber(LastChar[1].charid)
    else
        MySQLAsyncExecute("INSERT INTO `user_lastcharacter` (`steamid`, `charid`) VALUES('"..GetPlayerIdentifiers(source)[1].."', 1)")
        return 1
    end
end

function SetLastCharacter(source, charid)
    MySQLAsyncExecute("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
end

function SetIdentifierToChar(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."' WHERE `"..itable.column.."` = '"..identifier.."'")
    end
end

function SetCharToIdentifier(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = '"..identifier.."' WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function DeleteCharacter(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("DELETE FROM `"..itable.table.."` WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function GetSpawnPos(source)
    local SpawnPos = MySQLAsyncExecute("SELECT `position` FROM `users` WHERE `identifier` = '"..GetPlayerIdentifiers(source)[1].."'")
    return json.decode(SpawnPos[1].position)
end

function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam", "")
end

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

function GetPlayerCharacters(source)
    local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])
    local Chars = MySQLAsyncExecute("SELECT * FROM `users` WHERE identifier LIKE '%"..identifier.."%'")
    for i=1, #Chars, 1 do
        charJob = MySQLAsyncExecute("SELECT * FROM `jobs` WHERE `name` = '"..Chars[i].job.."'")
        Chars[i].job = charJob[1].label
    end
    return Chars
end

ESX.RegisterServerCallback('kcdd-kashacters:GetPlayerData', function(source, cb, id)
    local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])

	MySQL.Async.fetchAll("SELECT * FROM users WHERE  identifier LIKE '%"..identifier.."%'", {},
     function(users)
		local user = users[id]
		cb(user)
	end)
end)

function GetPlayerImage(source)
    local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])

    local avatar = MySQLAsyncExecute("SELECT avatar_url FROM twitter_accounts WHERE identifier LIKE '%"..identifier.."%'")

    return avatar
end

ESX.RegisterServerCallback('m3:userpeds-kashacters:pedCheck', function(source, cb, id)
    local _source = source
    local xPlayer = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])
    if xPlayer ~= nil then
        MySQL.Async.fetchAll("SELECT pedmodel FROM m3_user_peds WHERE identifier LIKE '%"..xPlayer.."%'", {
        }, function(result)
            if result[id] ~= nil then
                cb(result[id])
            else
                cb(nil)
            end
        end)
    else
        cb(nil)
    end
end)

function GetRockstarID(playerId)
    local identifier

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end

    return identifier
end

function GetIdentifierWithoutLicense(Identifier)
    return string.gsub(Identifier, "steam", "")
end

