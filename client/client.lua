
local notifications = {}
Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end
    Citizen.Wait(5000) 
    ESX.TriggerServerCallback('viperz_zonasentorno:cargardatos', function(data)
        notifications = data
        for i=1, #notifications do
            local notification = notifications[i]
            startNotificationThread(notification)
        end
    end)
end)

RegisterCommand(Config.Command, function(source, args, rawCommand)
    openMenu()
end, false)
function openMenu()
    local elements = {
        {label = 'Notification (ESX.ShowNotification)', value = 'notification'},
        {label = 'Chat (chat:addMessage)', value = 'chat_message'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'entorno_menu',
        {
            title    = 'Entorno Zona',
            align    = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'notification_message', {
                title = 'Mensaje',
            }, function(data2, menu2)
                local message = data2.value
                menu2.close()

                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'notification_coords', {
                    title = 'Coordenadas (x,y,z)',
                }, function(data3, menu3)
                    local coords = stringsplit(data3.value, ',')
                    for i=1, #coords do
                        coords[i] = tonumber(coords[i])
                    end
                    menu3.close()

                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'notification_radius', {
                        title = 'Radio',
                    }, function(data4, menu4)
                        local radius = tonumber(data4.value)
                        menu4.close()

                        TriggerServerEvent('viperz_zonasentorno:guardardatos', message, coords, radius, data.current.value)
                        startNotificationThread({message = message, coords = coords, radius = radius, notification_type = data.current.value})
                    end, function(data4, menu4)
                        menu4.close()
                    end)
                end, function(data3, menu3)
                    menu3.close()
                end)
            end, function(data2, menu2)
                menu2.close()
            end)
        end,
        function(data, menu)
            menu.close()
        end
    )
end
function startNotificationThread(notification)
    Citizen.CreateThread(function()
        local message = notification.message
        local coords = notification.coords
        local radius = notification.radius
        local notificationType = notification.notification_type
        local hasShownNotification = false
        while true do
            Citizen.Wait(1000)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(playerCoords, coords[1], coords[2], coords[3], true)
            if distance < radius then
                if not hasShownNotification then
                    if notificationType == 'notificati' then
                        ESX.ShowNotification(message)
                    elseif notificationType == 'chat_messa' then
                        TriggerEvent('chat:addMessage', {
                            template = Config.ChatTemplate,
                            args = Config.ChatArgs
                        })
                    end
                    hasShownNotification = true
                end
            else
                hasShownNotification = false
            end
        end
    end)
end

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