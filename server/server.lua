
RegisterServerEvent('viperz_zonasentorno:guardardatos')
AddEventHandler('viperz_zonasentorno:guardardatos', function(message, coords, radius, notification_type)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        MySQL.Async.execute('INSERT INTO zonasentorno (message, coords, radius, notification_type) VALUES (@message, @coords, @radius, @notification_type)', {
            ['@message'] = message,
            ['@coords'] = table.concat(coords, ','),
            ['@radius'] = radius,
            ['@notification_type'] = notification_type
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:showNotification', _source, 'Datos guardados correctamente.')
            else
                TriggerClientEvent('esx:showNotification', _source, 'Hubo un error al guardar los datos.')
            end
        end)
    end
end)

ESX.RegisterServerCallback('viperz_zonasentorno:cargardatos', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM zonasentorno', {}, function(result)
        local data = {}

        for i=1, #result do
            local coords = stringsplit(result[i].coords, ',')
            for j=1, #coords do
                coords[j] = tonumber(coords[j])
            end
            table.insert(data, {
                message = result[i].message,
                coords = coords,
                radius = result[i].radius,
                notification_type = result[i].notification_type
            })
        end

        cb(data)
    end)
end)

RegisterServerEvent('requestZonasEntorno')
AddEventHandler('requestZonasEntorno', function()
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM zonasentorno', {}, function(zonas)
        TriggerClientEvent('receiveZonasEntorno', src, zonas)
    end)
end)

RegisterServerEvent('eliminarZonaEntorno')
AddEventHandler('eliminarZonaEntorno', function(zonaId)
    MySQL.Async.execute('DELETE FROM zonasentorno WHERE id = @zonaId', {
        ['@zonaId'] = zonaId
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('esx:showNotification', source, 'Zona eliminada correctamente.')
        else
            TriggerClientEvent('esx:showNotification', source, 'Error al eliminar la zona.')
        end
    end)
end)


