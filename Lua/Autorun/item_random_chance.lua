Hook.Add("character.created", "RandomItemSpawner", function (character)
    -- Define the random chance (e.g., 30%)
    local chance = 30
    local randomValue = math.random(100) -- Generates a number between 1 and 100

    -- Check if the character is a player and matches the random chance
    if character.IsPlayer and randomValue <= chance then
        -- Add the item to the player's inventory
        local itemPrefab = ItemPrefab.GetItemPrefab("divingknife")
        if itemPrefab then
            character.Inventory.TryPutItem(Item(itemPrefab), nil, { InvSlotType.Any })
        end
    end
end)
