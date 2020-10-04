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
garage_depot.fixed_recipe = "garage_item_recipe"
garage_depot.ingredient_count = nil
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

function drone_depot_picture(tint)
  return {
    layers =
    {
      {
        filename = util.path("data/entities/delivery_depot/logistic-chest/brass-chest.png"),
        width = 38,
        height = 32,
        frame_count = 1,
        repeat_count = 16,
        shift = {0.09375, 0}
      },
      {
        filename = util.path("data/entities/delivery_depot/logistic-chest/logistic-chest-mask.png"),
        width = 32,
        height = 32,
        frame_count = 1,
        repeat_count = 16,
        tint = tint,
        shift = {0, 0}
      }
    }
  }
  end

function drone_depot_icon(tint)
  return {
    {
      icon = util.path("data/entities/delivery_depot/logistic-chest/icons/brass-chest.png"),
    },
    -- {
    --   icon = util.path("data/entities/delivery_depot/logistic-chest/icons/logistic-chest-port.png"),
    -- },
    {
      icon = util.path("data/entities/delivery_depot/logistic-chest/logistic-chest-mask.png"),
      tint = tint
    }
  };
end
  
  
local demand_depot = util.copy(data.raw["assembling-machine"]["assembling-machine-3"])
demand_depot.name = "demand-depot"
demand_depot.localised_name = {"demand-depot"}

demand_depot.icons = drone_depot_icon({r = 0.1, g = 0.4, b = 0.9, a = 1}); 
demand_depot.icon_size = 32;

demand_depot.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
demand_depot.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
demand_depot.drawing_box = {{-0.5, -0.5}, {0.5, 0.5}}
demand_depot.minable = {result = "demand-depot", mining_time = 1}
demand_depot.placeable_by = {item = "demand-depot", count = 1}
table.insert(demand_depot.flags, "not-deconstructable")
demand_depot.fluid_boxes =
{
  {
    production_type = "input",
    base_area = 50,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -1} }},
  },
  off_when_no_fluid_recipe = false
}
demand_depot.animation = drone_depot_picture({r = 0.1, g = 0.4, b = 0.9, a = 1});


local demand_depot_chest = util.copy(data.raw["logistic-container"]["logistic-chest-requester"])
demand_depot_chest.name = "demand-depot-chest"
demand_depot_chest.localised_name = {"demand-depot"}

demand_depot_chest.icons = demand_depot.icons;
demand_depot_chest.icon_size = demand_depot.icon_size;

demand_depot_chest.icon_mipmaps = 4

demand_depot_chest.minable = {result = "demand-depot", mining_time = 1}
demand_depot_chest.placeable_by = {item = "demand-depot", count = 1}
demand_depot_chest.logistic_mode = "requester"
demand_depot_chest.logistic_slots_count = 5
demand_depot_chest.render_not_in_network_icon = false
demand_depot_chest.inventory_size = 10

table.insert(demand_depot_chest.flags, "not-deconstructable")

local supply_small_depot = util.copy(data.raw["assembling-machine"]["assembling-machine-3"])
supply_small_depot.name = "supply-small-depot"
supply_small_depot.localised_name = {"supply-small-depot"}

supply_small_depot.icons = drone_depot_icon({r = 0.9, g = 0.2, b = 0.1, a = 1}); 
supply_small_depot.icon_size = 32;

supply_small_depot.icon_mipmaps = 4
supply_small_depot.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
supply_small_depot.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
supply_small_depot.drawing_box = {{-0.5, -0.5}, {0.5, 0.5}}
supply_small_depot.minable = {result = "supply-small-depot", mining_time = 1}
supply_small_depot.placeable_by = {item = "supply-small-depot", count = 1}
table.insert(supply_small_depot.flags, "not-deconstructable")
supply_small_depot.fluid_boxes =
{
  {
    production_type = "input",
    base_area = 50,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -1} }},
  },
  off_when_no_fluid_recipe = false
}
supply_small_depot.animation = drone_depot_picture({r = 0.9, g = 0.2, b = 0.1, a = 1});


local caution_corpse =
{
  type = "corpse",
  name = "transport-caution-corpse",
  flags = {"placeable-off-grid"},
  animation = caution_sprite,
  remove_on_entity_placement = false,
  remove_on_tile_placement = false
}

local supply_small_depot_chest =
{
  type = "container",
  name = "supply-small-depot-chest",
  localised_name = {"supply-small-depot"},
  icon = util.path("data/entities/transport_depot/supply-depot-icon.png"),
  icon_size = 216,
  dying_explosion = garage_depot.dying_explosion,
  damaged_trigger_effect = garage_depot.damaged_trigger_effect,
  corpse = garage_depot.corpse,
  flags = {"placeable-neutral", "player-creation", "not-blueprintable"},
  max_health = 150,
  collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
  collision_mask = {},
  selection_priority = 100,
  fast_replaceable_group = "container",
  scale_info_icons = false,
  inventory_size = 10,
  open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.5 },
  close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.5 },
  animation = drone_depot_picture({r = 0.9, g = 0.2, b = 0.1, a = 1}),
  picture = util.empty_sprite(),
  order = "nil",
  minable = {result = "supply-small-depot", mining_time = 1},
  placeable_by = {item = "supply-small-depot", count = 1},
  circuit_wire_max_distance = 10,
  circuit_wire_connection_point = circuit_connector_definitions["roboport"].points,
  circuit_connector_sprites = circuit_connector_definitions["roboport"].sprites,

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
    icons = demand_depot_chest.icons,
    icon_size = demand_depot_chest.icon_size,
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
    icons = demand_depot_chest.icons,
    icon_size = demand_depot_chest.icon_size,
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
  },

  {
    type = "item",
    name = "supply-small-depot",
    localised_name = {"supply-small-depot"},
    icons = supply_small_depot.icons,
    icon_size = supply_small_depot.icon_size,
    flags = {},
    subgroup = "transport-drones",
    order = "e-a-a",
    stack_size = 10,
    place_result = "supply-small-depot"
  },
  {
    type = "recipe",
    name = "supply-small-depot",
    localised_name = {"supply-small-depot"},
    icons = supply_small_depot.icons,
    icon_size = supply_small_depot.icon_size,
    --category = "transport",
    enabled = false,
    ingredients =
    {
      {"iron-plate", 50},
      {"iron-gear-wheel", 10},
      {"iron-stick", 20},
    },
    energy_required = 5,
    result = "supply-small-depot"
  },
}

data:extend(items)

data:extend
{
  category,
  garage_depot,
  demand_depot,
  demand_depot_chest,
  supply_small_depot,
  supply_small_depot_chest,
  caution_corpse,
  invisble_corpse
}