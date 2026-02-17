local ChatMessenger = {}

local DEFAULT_SENDER_NAME = "ST-Uprising"

local function iterateClients(callback)
    if Client == nil or Client.ClientList == nil then
        return
    end

    for _, client in pairs(Client.ClientList) do
        callback(client)
    end
end

local function normalizeMessage(message)
    if message == nil then
        return nil
    end

    message = tostring(message)
    if message == "" then
        return nil
    end

    return message
end

local function findClientByName(playerName)
    if playerName == nil or Client == nil or Client.ClientList == nil then
        return nil
    end

    local lookupName = tostring(playerName):lower()
    for _, client in pairs(Client.ClientList) do
        if client ~= nil and client.Name ~= nil and tostring(client.Name):lower() == lookupName then
            return client
        end
    end

    return nil
end

function ChatMessenger.SendGlobal(message, messageType, senderName)
    local normalizedMessage = normalizeMessage(message)
    if normalizedMessage == nil then
        return false, "Message is empty"
    end

    local didSend = false
    local chatMessage = ChatMessage.Create(senderName or DEFAULT_SENDER_NAME, normalizedMessage, messageType or ChatMessageType.Server, nil, nil)
    iterateClients(function(client)
        if client ~= nil then
            Game.SendDirectChatMessage(chatMessage, client)
            didSend = true
        end
    end)

    if not didSend then
        return false, "No connected clients"
    end

    return true
end

function ChatMessenger.SendPrivate(playerName, message, senderName)
    local targetClient = findClientByName(playerName)
    if targetClient == nil then
        return false, string.format("Player '%s' not found", tostring(playerName))
    end

    local normalizedMessage = normalizeMessage(message)
    if normalizedMessage == nil then
        return false, "Message is empty"
    end

    local chatMessage = ChatMessage.Create(senderName or DEFAULT_SENDER_NAME, normalizedMessage, ChatMessageType.Private, nil, nil)
    Game.SendDirectChatMessage(chatMessage, targetClient)
    return true
end

return ChatMessenger