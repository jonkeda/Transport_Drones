local demand_depot = {}

demand_depot.metatable = {__index = demand_depot}

demand_depot.corpse_offsets =
{
  [0] = {0, -1},
  [2] = {1, 0},
  [4] = {0, 1},
  [6] = {-1, 0},
}

function demand_depot.new(entity)
  local position = entity.position
  local direction = entity.direction
  local force = entity.force
  local surface = entity.surface
  local offset = demand_depot.corpse_offsets[direction]
  entity.destructible = false
  entity.minable = false
  entity.rotatable = false
  entity.active = false
  local chest = surface.create_entity{name = "demand-depot-chest", position = position, force = force, player = entity.last_user}
  local corpse_position = {position.x + offset[1], position.y + offset[2]}
  local corpse = surface.create_entity{name = "transport-caution-corpse", position = corpse_position}
  corpse.corpse_expires = false

  local depot =
  {
    entity = chest,
    assembler = entity,
    corpse = corpse,
    to_be_delivered = {},
    node_position = {math.floor(corpse_position[1]), math.floor(corpse_position[2])},
    index = tostring(chest.unit_number),
    old_contents = {}
  }
  setmetatable(depot, demand_depot.metatable)

  return depot

end

function demand_depot:update_contents()
  local supply = self.road_network.get_network_item_supply(self.network_id)

  local new_contents
  if (self.circuit_writer and self.circuit_writer.valid) then
    local behavior = self.circuit_writer.get_control_behavior()
    if behavior and behavior.disabled then
      new_contents = {}
    end
  end

  if not new_contents then
    new_contents = self.entity.get_output_inventory().get_contents()
  end

  for name, count in pairs (self.old_contents) do
    if not new_contents[name] then
      local item_supply = supply[name]
      if item_supply then
        item_supply[self.index] = nil
      end
    end
  end

  for name, count in pairs (new_contents) do
    local item_supply = supply[name]
    if not item_supply then
      item_supply = {}
      supply[name] = item_supply
    end
    local new_count = count + self:get_to_be_delivered(name)
    if new_count > 0 then
      item_supply[self.index] = new_count
    else
      item_supply[self.index] = nil
    end
  end

  self.old_contents = new_contents

end

function demand_depot:add_to_be_delivered(name, count)
  self.to_be_delivered[name] = (self.to_be_delivered[name] or 0) + count
end

function demand_depot:get_available_item_count(name)
  return self.entity.get_output_inventory().get_item_count(name) + self:get_to_be_delivered(name)
end

function demand_depot:get_to_be_delivered(name)
  if self.to_be_delivered then
    return self.to_be_delivered[name] or 0
  end
  return 0
end

--[[

had iron 10
now iron 5
]]

function demand_depot:update()
  --self:update_contents()

end

function demand_depot:say(string)
  self.entity.surface.create_entity{name = "tutorial-flying-text", position = self.entity.position, text = string}
end

function demand_depot:deliver_item(requested_name, requested_count)
  local inventory = self.entity.get_output_inventory()
  local inserted_count = inventory.insert({name = requested_name, count = requested_count})
  return inserted_count
end

function demand_depot:add_to_network()
  self.network_id = self.road_network.add_depot(self, "demand")
  self:update_contents()
end

function demand_depot:remove_from_network()
  self.road_network.remove_depot(self, "demand")
  self.network_id = nil
end

function demand_depot:on_removed(event)

  self.corpse.destroy()
  if self.assembler then
    self.assembler.destructible = true
  end
  if event.name == defines.events.on_entity_died then
    self.entity.destroy()
    if self.assembler then
      self.assembler.die()
    end
  else
    if self.assembler then
      self.assembler.destroy()
    end
  end
end

function demand_depot:on_config_changed()
  self.old_contents = self.old_contents or {}
end

return demand_depot