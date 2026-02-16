Hook.Add("character.created", "AssignRandomTalent", function(character)
  if not character or not character.IsHuman or character.IsBot then return end

  -- Prevent multiple talent assignments by checking a tag
  if character.HasTag("TalentAssigned") then return end

  -- 1% chance to assign the "psychic" talent
  if math.random(100) == 100 then
      character.GiveTalent("psychic")
  end
  
  -- Set a tag to prevent re-assigning on respawn
  character.SetOriginalTeam(character.TeamID) -- Ensures persistence in campaign mode
  character.AddTag("TalentAssigned")
end)