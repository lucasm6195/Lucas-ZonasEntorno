AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        local notifications = {}
        Citizen.CreateThread(function()
            Citizen.Wait(5000) 
            ESX.TriggerServerCallback('viperz_zonasentorno:cargardatos', function(data)
                notifications = data
                for i=1, #notifications do
                    local notification = notifications[i]
                    startNotificationThread(notification)
                end
            end)
        end)
    end
end)

RegisterCommand('entornozona', function(source, args, rawCommand)
    openMenu()
end, false)

