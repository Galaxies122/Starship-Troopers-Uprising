local ChatMessenger = require("StarshipTroopers.ChatMessenger")

local function startsWith(text, prefix)
    return string.sub(text, 1, string.len(prefix)) == prefix
end

local function trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function splitInTwo(text)
    local first, rest = text:match("^(%S+)%s+(.+)$")
    if first == nil then
        return text, nil
    end

    return first, rest
end

local function notify(sender, text)
    if sender ~= nil then
        local feedback = ChatMessage.Create("ST-Uprising", text, ChatMessageType.Server, nil, nil)
        Game.SendDirectChatMessage(feedback, sender)
    end
end

Hook.Add("chatMessage", "STUprising.ChatMessenger.Commands", function(message, sender)
    if message == nil then
        return
    end

    if startsWith(message, "!stmsg ") then
        local payload = trim(string.sub(message, 8))
        local ok, err = ChatMessenger.SendGlobal(payload, ChatMessageType.Server, "ST-Uprising")
        if not ok then
            notify(sender, "Unable to send message: " .. err)
        end
        return true
    end

    if startsWith(message, "!stpm ") then
        local payload = trim(string.sub(message, 7))
        local playerName, privateMessage = splitInTwo(payload)

        if privateMessage == nil then
            notify(sender, "Usage: !stpm <player-name> <message>")
            return true
        end

        local ok, err = ChatMessenger.SendPrivate(playerName, privateMessage, "ST-Uprising")
        if not ok then
            notify(sender, "Unable to send private message: " .. err)
        else
            notify(sender, "Private message sent to " .. playerName)
        end

        return true
    end
end)

print("[ST-Uprising] Chat messenger loaded. Use !stmsg <message> or !stpm <player-name> <message>.")