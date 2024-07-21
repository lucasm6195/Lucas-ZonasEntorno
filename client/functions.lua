
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

function startNotificationThread(notification)
    Citizen.CreateThread(function()
        local Command = 'entornozona'

        local message = notification.message
        local ChatTemplate = '<div style="padding: 0.3vw; margin: 0.2vw; background-color: rgba(0, 0, 0, 0.8); border-radius: 0.2vw; color: #fffbfb; font-family: \'Quicksand\', sans-serif; border-left: 0.3vh solid #aca3a3; font-weight: 400; font-size: 0.9em; box-shadow: 0px 0px 5px rgba(0,0,0,0.2);"><span style="color: #56c55f; font-weight: bold;">{0}</span>: <span style="color: #f7eaeafb;">'.. message ..'</span></div>'
        local ChatArgs = { "Entorno de Zona", message }

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
                            template = ChatTemplate,
                            args = ChatArgs
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
