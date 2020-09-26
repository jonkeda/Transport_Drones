local collision_box = {{-1.25, -1.25},{1.25, 1.25}}
local selection_box = {{-1.5, -1.5}, {1.5, 1.5}}

local garage_depot = util.copy(data.raw["assembling-machine"]["assembling-machine-3"])

local caution_sprite =
{
  type = "sprite",
  name = "caution-sprite",
  filename = util.path("data/entities/delivery_depot/depot-caution.png"),
  width = 101,
  height = 72,
  frame_count = 1,
  scale = 0.33,
  shift = shift,
  direction_count = 1,
  draw_as_shadow = false,
  flags = {"terrain"}
}

local garage_base = function(shift)
  return
  {
    filename = util.path("data/entities/delivery_depot/garage-depot-base.png"),
    width = 474,
    height = 335,
    frame_count = 1,
    scale = 0.45,
    shift = shift
  }
end

garage_depot.name = "garage-depot"
garage_depot.localised_name = {"garage-depot"}
garage_depot.icon = util.path("data/entities/delivery_depot/garage-depot-icon.png")
garage_depot.icon_size = 216
garage_depot.icon_mipmaps = 0
garage_depot.collision_box = collision_box
garage_depot.selection_box = selection_box
garage_depot.max_health = 150
garage_depot.fast_replaceable_group = nil
garage_depot.radius_visualisation_specification =
{
  sprite = caution_sprite,
  distance = 0.5,
  offset = {0, -2}
}
garage_depot.fluid_boxes =
{
  {
    production_type = "input",
    base_area = 50,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -2} }},
  },
  {
    production_type = "output",
    base_area = 100000,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, 2} }},
    pipe_covers = pipecoverspictures(),
    pipe_picture = assembler3pipepictures(),
    secondary_draw_orders = { north = -1, east = -1, west = -1}
  },
  off_when_no_fluid_recipe = false
}
garage_depot.crafting_categories = {"transport-drone-garage"}
garage_depot.crafting_speed = (1)
garage_depot.ingredient_count = nil
--garage_depot.collision_mask = {"item-layer", "object-layer", "water-tile", "player-layer", "resource-layer"}
garage_depot.se_allow_in_space = true
garage_depot.allowed_effects = {}
garage_depot.module_specification = nil
garage_depot.minable = {result = "garage-depot", mining_time = 1}
garage_depot.flags = {"placeable-neutral", "player-creation"}
garage_depot.next_upgrade = nil
garage_depot.scale_entity_info_icon = true
garage_depot.energy_usage = "1W"
garage_depot.gui_title_key = "transport-depot-choose-item"
garage_depot.energy_source =
{
  type = "void",
  usage_priority = "secondary-input",
  emissions_per_second_per_watt = 0.1
}
garage_depot.placeable_by = {item = "garage-depot", count = 1}

garage_depot.animation =
{
  north =
  {
    layers =
    {
      garage_base{0, 0.4},
    }
  },
  south =
  {
    layers =
    {
      garage_base{0, 0.4},
    }
  },
  east =
  {
    layers =
    {
      garage_base{0, 0.4},
    }
  },
  west =
  {
    layers =
    {
      garage_base{0, 0.4},
    }
  },
}

local demand_depot = util.copy(data.raw["logistic-container"]["logistic-chest-requester"])
demand_depot.name = "demand-depot"
demand_depot.localised_name = {"demand-depot"}

demand_depot.icon = "__base__/graphics/icons/logistic-chest-requester.png"
demand_depot.icon_size = 64
demand_depot.icon_mipmaps = 4

demand_depot.minable = {result = "demand-depot", mining_time = 1}
demand_depot.placeable_by = {item = "demand-depot", count = 1}
demand_depot.logistic_mode = "requester"
demand_depot.logistic_slots_count = 5
demand_depot.render_not_in_network_icon = false
table.insert(demand_depot.flags, "not-deconstructable")

local demand_base = function(shift)
  return
  {
    filename = util.path("data/entities/delivery_depot/demand-depot-base.png"),
    width = 474,
    height = 335,
    frame_count = 1,
    scale = 0.45,
    shift = shift
  }
end

local caution_corpse =
{
  type = "corpse",
  name = "transport-caution-corpse",
  flags = {"placeable-off-grid"},
  animation = caution_sprite,
  remove_on_entity_placement = false,
  remove_on_tile_placement = false
}

local category =
{
  type = "recipe-category",
  name = "transport-drone-garage"
}

local items =
{
  {
    type = "item",
    name = "demand-depot",
    localised_name = {"demand-depot"},
    icon = demand_depot.icon,
    icon_size = demand_depot.icon_size,
    flags = {},
    subgroup = "transport-drones",
    order = "e-a-a",
    stack_size = 10,
    place_result = "demand-depot"
  },
  {
    type = "recipe",
    name = "demand-depot",
    localised_name = {"demand-depot"},
    icon = demand_depot.icon,
    icon_size = demand_depot.icon_size,
    --category = "transport",
    enabled = false,
    ingredients =
    {
      {"iron-plate", 50},
      {"iron-gear-wheel", 10},
      {"iron-stick", 20},
    },
    energy_required = 5,
    result = "demand-depot"
  },
  {
    type = "item",
    name = "garage-depot",
    localised_name = {"garage-depot"},
    icon = garage_depot.icon,
    icon_size = garage_depot.icon_size,
    flags = {},
    subgroup = "transport-drones",
    order = "e-a-b",
    stack_size = 10,
    place_result = "garage-depot"
  },
  {
    type = "recipe",
    name = "garage-depot",
    localised_name = {"garage-depot"},
    icon = garage_depot.icon,
    icon_size = garage_depot.icon_size,
    --category = "transport",
    enabled = false,
    ingredients =
    {
      {"iron-plate", 50},
      {"iron-gear-wheel", 10},
      {"iron-stick", 20},
    },
    energy_required = 5,
    result = "garage-depot"
  }
}

data:extend(items)

data:extend
{
  category,
  garage_depot,
  demand_depot,
  caution_corpse,
  invisble_corpse
}