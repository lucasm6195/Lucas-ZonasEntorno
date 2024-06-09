
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
                xPlayer.showNotification('Datos guardados correctamente.')
            else
                xPlayer.showNotification('Hubo un error al guardar los datos.')
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

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end