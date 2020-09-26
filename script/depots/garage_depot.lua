local fuel_amount_per_drone = shared.fuel_amount_per_drone
local drone_fluid_capacity = shared.drone_fluid_capacity

local garage_depot = {}
garage_depot.metatable = {__index = garage_depot}

garage_depot.corpse_offsets =
{
  [0] = {0, -2},
  [2] = {2, 0},
  [4] = {0, 2},
  [6] = {-2, 0},
}

local fuel_fluid
local get_fuel_fluid = function()
  if not fuel_fluid then
    fuel_fluid = game.recipe_prototypes["fuel-depots"].products[1].name
  end
  return fuel_fluid
end

local get_corpse_position = function(entity)

  local position = entity.position
  local direction = entity.direction
  local offset = garage_depot.corpse_offsets[direction]
  return {position.x + offset[1], position.y + offset[2]}

end

function garage_depot.new(entity)

  local force = entity.force
  local surface = entity.surface

  entity.active = false
  entity.rotatable = false

  local corpse_position = get_corpse_position(entity)
  local corpse = surface.create_entity{name = "transport-caution-corpse", position = corpse_position}
  corpse.corpse_expires = false

  local depot =
  {
    entity = entity,
    corpse = corpse,
    index = tostring(entity.unit_number),
    node_position = {math.floor(corpse_position[1]), math.floor(corpse_position[2])},
    item = false,
    drones = {},
    fuel_on_the_way = 0
  }
  setmetatable(depot, garage_depot.metatable)

  return depot

end

function garage_depot:remove_fuel(amount)
  self.entity.remove_fluid({name = get_fuel_fluid(), amount = amount})
end

function garage_depot:check_drone_validity()
  for k, drone in pairs (self.drones) do
    if drone.entity.valid then
      return
    else
      drone:clear_drone_data()
      self:remove_drone(drone)
    end
  end
end

local max = math.max
function garage_depot:minimum_fuel_amount()
  return max(fuel_amount_per_drone * 2, fuel_amount_per_drone * self:get_drone_item_count() * 0.2)
end

function garage_depot:max_fuel_amount()
  return (self:get_drone_item_count() * fuel_amount_per_drone)
end


local icon_param = {type = "virtual", name = "fuel-signal"}
function garage_depot:show_fuel_alert(message)
  for k, player in pairs (game.connected_players) do
    player.add_custom_alert(self.entity, icon_param, message, true)
  end
end

function garage_depot:check_fuel_amount()

  local current_amount = self:get_fuel_amount()
  if current_amount >= self:minimum_fuel_amount() then
    return
  end

  local fuel_request_amount = (self:max_fuel_amount() - current_amount)
  if fuel_request_amount <= self.fuel_on_the_way then return end

  local fuel_depots = self.road_network.get_depots_by_distance(self.network_id, "fuel", self.node_position)
  if not (fuel_depots and fuel_depots[1]) then
    self:show_fuel_alert({"no-fuel-depot-on-network"})
    return
  end

  for k = 1, #fuel_depots do
    local depot = fuel_depots[k]
    depot:handle_fuel_request(self)
    if fuel_request_amount <= self.fuel_on_the_way then
      return
    end
  end

  self:show_fuel_alert({"no-fuel-in-network"})

end

local distance = function(a, b)
  local dx = a[1] - b[1]
  local dy = a[2] - b[2]
  return ((dx * dx) + (dy * dy)) ^ 0.5
end

local big = math.huge
local min = math.min
local item_heuristic_bonus = 50

function garage_depot:get_demand_depot()
  
  local demand_depots = self.road_network.get_depots_by_distance(self.network_id, "demand", self.node_position)
  if not (demand_depots and demand_depots[1]) then
    return
  end

  local supply_depots = self.road_network.get_depots_by_distance(self.network_id, "supply", self.node_position)
  if not (supply_depots and supply_depots[1]) then
    return
  end

  for k = 1, #demand_depots do
    local demand_depot = demand_depots[k]
    if demand_depot.entity.valid then
      for i = 1, demand_depot.entity.request_slot_count do
        local slot = demand_depot.entity.get_request_slot(i)
        if slot and slot.name and slot.count >0 then
          local demand_count = demand_depot:get_available_item_count(slot.name)
          if demand_count / slot.count < 0.5 then

            for s = 1, #supply_depots do
              local supply_depot = supply_depots[s]
              if supply_depot.entity.valid then
                local supply_count = supply_depot:get_available_item_count(slot.name)
                -- todo largest amount or heuristic
                if supply_count > 0 then
                  return demand_depot, slot, supply_depot
                end  
              end
            end
          end
        end
      end
    end

  end

end

function garage_depot:make_request()

  while self:can_spawn_drone() do

    local demand_depot, slot, supply_depot = self:get_demand_depot()
    if not demand_depot then return end
    
    self:dispatch_drone(supply_depot, demand_depot, slot.count, slot.name)
  end

end

local min = math.min
function garage_depot:dispatch_drone(supply_depot, demand_depot, count, item)

  local drone = self.delivery_drone.new(self, item)
  drone:make_delivery(supply_depot, demand_depot, item, count)
  self:remove_fuel(fuel_amount_per_drone)

  self.drones[drone.index] = drone

  self:update_sticker()
end

function garage_depot:update()
  self:check_fuel_amount()
  self:check_drone_validity()
  self:make_request()
  self:update_sticker()
  
end

function garage_depot:suicide_all_drones()
  for k, drone in pairs (self.drones) do
    if drone.entity.valid then
      drone:suicide()
    else
      drone:clear_drone_data()
      self:remove_drone(drone)
    end
  end
end

function garage_depot:get_output_inventory()
  --return self.entity.get_output_inventory()
  if not self.output_inventory then
    self.output_inventory = self.entity.get_output_inventory()
  end
  return self.output_inventory
end

function garage_depot:get_drone_inventory()
  if not self.drone_inventory then
    self.drone_inventory = self.entity.get_inventory(defines.inventory.assembling_machine_input)
  end
  return self.drone_inventory
  --return self.entity.get_inventory(defines.inventory.assembling_machine_input)
end

function garage_depot:get_active_drone_count()
  return table_size(self.drones)
end

function garage_depot:get_fuel_amount()
  return self.entity.get_fluid_count(get_fuel_fluid())
end

function garage_depot:can_spawn_drone()
  return self:get_drone_item_count() > self:get_active_drone_count()
end

function garage_depot:get_drone_item_count()
  return self:get_drone_inventory().get_item_count("transport-drone")
end

function garage_depot:get_output_fluidbox()
  return self.entity.fluidbox[2]
end

function garage_depot:set_output_fluidbox(box)
  self.entity.fluidbox[2] = box
end

function garage_depot:get_storage_size()
  return self:get_drone_item_count() * self:get_request_size()
end

function garage_depot:remove_drone(drone, remove_item)
  self.drones[drone.index] = nil
  if remove_item then
    self:get_drone_inventory().remove{name = "transport-drone", count = 1}
  end
  self:update_sticker()
end

function garage_depot:update_sticker()

  if self.rendering and rendering.is_valid(self.rendering) then
    rendering.set_text(self.rendering, self:get_active_drone_count().."/"..self:get_drone_item_count())
    return
  end

  self.rendering = rendering.draw_text
  {
    surface = self.entity.surface.index,
    target = self.entity,
    text = self:get_active_drone_count().."/"..self:get_drone_item_count(),
    only_in_alt_mode = true,
    forces = {self.entity.force},
    color = {r = 1, g = 1, b = 1},
    alignment = "center",
    scale = 1.5
  }

end

function garage_depot:say(string)
  self.entity.surface.create_entity{name = "tutorial-flying-text", position = self.entity.position, text = string}
end

function garage_depot:add_to_network()
  self.network_id = self.road_network.add_depot(self, "request")
end

function garage_depot:remove_from_network()
  self.road_network.remove_depot(self, "request")
  self.network_id = nil
end

function garage_depot:on_removed()
  self:suicide_all_drones()
  self.corpse.destroy()
end

function garage_depot:on_config_changed()
  self.fuel_on_the_way = self.fuel_on_the_way or 0
end

return garage_depot