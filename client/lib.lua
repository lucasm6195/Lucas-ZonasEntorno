function openMenu()
    lib.registerContext({
        id = 'entorno_menu',
        title = 'Entorno Zona',
        options = {
            {
                title = 'Crear una Zona de Entorno',
                description = 'Crea una zona de entorno con notificaciones o mensajes de chat',
                icon = 'fa-plus-circle',
                onSelect = function()
                    lib.registerContext({
                        id = 'crear_zona_entorno',
                        title = 'Crear Zona de Entorno',
                        options = {
                            {
                                title = 'Notification (ESX.ShowNotification)',
                                icon = 'fa-bell',
                                onSelect = function()
                                    openNotificationDialog()
                                end
                            },
                            {
                                title = 'Chat (chat:addMessage)',
                                icon = 'fa-comments',
                                onSelect = function()
                                    openChatDialog()
                                end
                            }
                        }
                    })
                    lib.showContext('crear_zona_entorno')
                end
            },
            {
                title = 'Editar Entornos',
                description = 'Edita los entornos existentes',
                icon = 'fa-edit',
                onSelect = function()
                    TriggerServerEvent('requestZonasEntorno')
                end
            }
        }
    })
    lib.showContext('entorno_menu')
end
function openNotificationDialog()
    openDialog('notification')
end

function openChatDialog()
    openDialog('chat_message')
end

function openDialog(type)
    local input = lib.inputDialog('Detalles de la Zona', {
        {type = 'input', label = 'Mensaje', description = 'Introduce un mensaje para la zona', required = true},
        {type = 'input', label = 'Coordenadas (x,y,z)', description = 'Introduce las coordenadas separadas por comas', required = true},
        {type = 'number', label = 'Radio', description = 'Define el radio de la zona', required = true}
    })

    if input then
        local message = input[1]
        local coordsInput = input[2]
        local radius = tonumber(input[3])

        local coords = stringsplit(coordsInput, ',')
        for i=1, #coords do
            coords[i] = tonumber(coords[i])
        end

        TriggerServerEvent('viperz_zonasentorno:guardardatos', message, coords, radius, type)
        startNotificationThread({message = message, coords = coords, radius = radius, notification_type = type})
    end
end

RegisterNetEvent('receiveZonasEntorno', function(zonas)
    local options = {}
    for _, zona in ipairs(zonas) do
        local title = string.format("Mensaje: %s\nCordenadas: %s", zona.message, zona.coords)
        table.insert(options, {
            title = title,
            onSelect = function()
                lib.registerContext({
                    id = 'editar_eliminar_zona',
                    title = 'Eliminar Zona',
                    options = {
                        {
                            title = 'Eliminar Zona',
                            icon = 'fa-trash', 
                            onSelect = function()
                                TriggerServerEvent('eliminarZonaEntorno', zona.id)
                            end
                        }
                    }
                })
                lib.showContext('editar_eliminar_zona')
            end
        })
    end
    lib.registerContext({
        id = 'editar_zonas_entorno',
        title = 'Editar Zonas de Entorno',
        options = options
    })
    lib.showContext('editar_zonas_entorno')
end)