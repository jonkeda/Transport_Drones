local shared = require("shared")

data.raw.tile["transport-drone-road"].collision_mask = {"object-layer"}
data.raw.tile["transport-drone-proxy-tile"].collision_mask = {"ground-tile"}

data.raw.item.road.place_as_tile =
{
  result = "transport-drone-proxy-tile",
  condition_size = 1,
  condition = {"object-layer"}
}

local util = require "__Transport_Drones__/data/tf_util/tf_util"
require("data/entities/transport_drone/transport_drone")
require("data/make_request_recipes")
require("data/make_garage_recipes")

-- ruin rails

local rail_addition_mask = "floor-layer"
local rail_collision_mask = {"floor-layer", "water-tile", "item-layer"}

for k, rail in pairs (data.raw["straight-rail"]) do
  if rail.collision_mask then
    util.remove_from_list(rail.collision_mask, "object-layer")
    if not util.has_value(rail.collision_mask, rail_addition_mask) then
      table.insert(rail.collision_mask, rail_addition_mask)
    end
  else
    rail.collision_mask = rail_collision_mask
  end
  rail.selection_priority = 45
end

for k, rail in pairs (data.raw["curved-rail"]) do
  if rail.collision_mask then
    util.remove_from_list(rail.collision_mask, "object-layer")
    if not util.has_value(rail.collision_mask, rail_addition_mask) then
      table.insert(rail.collision_mask, rail_addition_mask)
    end
  else
    rail.collision_mask = rail_collision_mask
  end
  rail.selection_priority = 45
end

-- ruin gates

local gate_collision_mask = {"item-layer", "player-layer", "train-layer", "water-tile"}
local opened_gate_collision_mask = {"item-layer", "water-tile", "floor-layer"}

for k, gate in pairs (data.raw.gate) do
  if gate.collision_mask then
    util.remove_from_list(gate.collision_mask, "object-layer")
  else
    gate.collision_mask = gate_collision_mask
  end
  if gate.opened_collision_mask then
    util.remove_from_list(gate.opened_collision_mask, "object-layer")
  else
    gate.opened_collision_mask = opened_gate_collision_mask
  end
end