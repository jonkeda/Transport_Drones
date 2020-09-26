local fuel = settings.startup["fuel-fluid"].value
if not data.raw.fluid[fuel] then
  log("Bad name for fuel fluid. reverting to something else...")

  fuel = "petroleum-gas"
  if not data.raw.fluid[fuel] then
    fuel = nil
    for k, fluid in pairs (data.raw.fluid) do
      if fluid.fuel_value then
        fuel = fluid.name
        break
      end
    end
  end

  if not fuel then
    local index, fluid = next(data.raw.fluid)
    if fluid then
      fuel = fluid.name
    end
  end
end

local category = "transport-drone-garage"
local util = require("__Transport_Drones__/data/tf_util/tf_util")
local shared = require("shared")

local make_recipe = function()
  local recipe = 
  {
    type = "recipe",
    name = "garage_item_recipe",
    icon = util.path("data/entities/transport_drone/transport-drone-icon.png"),
    icon_size = 113,
    ingredients =
    {
      {type = "item", name = "transport-drone", amount = 1},
      {type = "fluid", name = fuel, amount = 5000}
    },
    results =
    {
    },
    category = category,
    order = "e_garage_item_recipe",
    subgroup = "other",
    hide_from_player_crafting = true,
    allow_decomposition = false,
    allow_as_intermediate = false,
    allow_intermediates = true
  }
  data:extend{recipe}
end

make_recipe()