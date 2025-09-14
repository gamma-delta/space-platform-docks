local whocares_icon = "__core__/graphics/questionmark.png"
local dock_aux = require "prototypes/dock-aux"

local nice_fluidbox = {
  -- pipe_picture = assembler2pipepictures(),
  pipe_covers = pipecoverspictures(),
  volume = 0,
  secondary_draw_orders = { north=-1, south=1 },
}

-- This hovers over the dock and is what you actually click on.
-- It's a Lab because it can be name
local function make_cover_lab(direction)
  local hitbox
  local tile_width
  local tile_height
  if direction == "horizontal" then
    hitbox = {{-5, -3}, {5, 3}}
    tile_width = 10
    tile_height = 6
  else
    hitbox = {{-3, -5}, {3, 5}}
    tile_width = 6
    tile_height = 10
  end
  return {
    type = "lab",
    name = "pkspd-platform-dock-cover-" .. direction,
    icon = whocares_icon,
    flags = {
      "placeable-neutral", "placeable-player", "player-creation",
      "get-by-unit-number", "not-on-map", "hide-alt-info",
      "no-automated-item-removal", "no-automated-item-insertion"
    },
    minable = {mining_time = 1.0, result = "pkspd-platform-dock"},
    inputs = {},
    selection_box = hitbox,
    collision_box = hitbox,
    tile_width = tile_width,
    tile_height = tile_height,

    circuit_wire_max_distance = default_circuit_wire_max_distance,
    circuit_connector = dock_aux.circuit_connectors,
    energy_usage = "1kW",
    energy_source = {type="void"}
  }
end

data:extend{
  util.merge({
    data.raw["linked-belt"]["linked-belt"],
    {
      name = "pkspd-linked-belt",
      flags = {
        "placeable-player", "player-creation",
        "not-rotatable", "not-on-map", "hide-alt-info",
      },
      hidden = true,
      selectable_in_game = false,
      icon = whocares_icon,
    }
  }),
  make_cover_lab("horizontal"),
  make_cover_lab("vertical"),
    -- Carries bridged signals across the dock.
  -- https://github.com/robot256/factorio_shortwave_fix/blob/main/control.lua
  -- https://mods.factorio.com/mod/circuit-wire-poles
  util.merge({
    data.raw["constant-combinator"]["constant-combinator"],
    {
      name = "pkspd-dock-circuit-bridge",
      flags = {
        "placeable-player", "player-creation",
        "not-rotatable", "not-on-map", "hide-alt-info",
        "placeable-off-grid"
      },
      hidden = true,
      selectable_in_game = true,
      icon = whocares_icon,
      maximum_wire_distance = default_circuit_wire_max_distance,
      draw_copper_wires = false,
      draw_circuit_wires = true,
    }
  }),
  -- Used to avoid circular dependency errors
  -- Fired when we need to re-draw all the guis
  {
    type = "custom-event",
    name = "pkspd-redraw-dock-guis"
  }
}
