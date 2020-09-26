for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

  if technologies["transport-system"].researched then
    recipes["garage-depot"].enabled = true
    recipes["demand-depot"].enabled = true
    recipes["supply-small-depot"].enabled = true
  end
end