-- Define the coordinates of the mechanic shop
local mechanicShopCoords = vector3(100.0, -1000.0, 29.4)

-- Define the repair price
local repairPrice = 500

-- Register a command to repair the player's vehicle
RegisterCommand("repair", function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - mechanicShopCoords)

        if distance < 10.0 then
            -- Check if the player has enough money
            if not HasPlayerGotSMoney(source, repairPrice) then
                TriggerClientEvent('chatMessage', source, '^1[Error]^7 You do not have enough money to repair your vehicle!')
                return
            end

            -- Deduct money from the player
            TriggerEvent('es:getPlayerFromId', source, function(user)
                user:removeMoney(repairPrice)
            end)

            -- Repair the vehicle
            SetVehicleFixed(vehicle)
            SetVehicleDirtLevel(vehicle, 0.0)

            -- Send a confirmation message to the player
            TriggerClientEvent('chatMessage', source, '^2[Success]^7 Your vehicle has been repaired for $' .. repairPrice .. '.')
        else
            TriggerClientEvent('chatMessage', source, '^1[Error]^7 You are not close enough to the mechanic shop!')
        end
    else
        TriggerClientEvent('chatMessage', source, '^1[Error]^7 You are not in a vehicle!')
    end
end, false)

-- Function to check if the player has enough money
function HasPlayerGotSMoney(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        return xPlayer.getMoney() >= amount
    end
    return false
end
