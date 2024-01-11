

local initial_properties = {
  hp_max = 1,
  breath_max = 0,
  zoom_fov = 0.0,
  eye_height = 1.625,
  physical = false,
  collide_with_objects = true,
  collisionbox = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },  -- default
  selectionbox = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5, rotate = false },
  pointable = true,
  visual = "sprite",
  visual_size = {x = 1, y = 1, z = 1},
  mesh = "",
  textures = {"no_texture.png"},
  colors = {r=255, g=255, b=255, a=255},
  use_texture_alpha = false,
  spritediv = {x = 1, y = 1},
  initial_sprite_basepos = {x = 0, y = 0},
  is_visible = true,
  makes_footstep_sound = false,
  automatic_rotate = 0,
  stepheight = 0,
  automatic_face_movement_dir = 0.0,
  automatic_face_movement_max_rotation_per_sec = -1,
  backface_culling = true,
  glow = 0,
  nametag = "",
  nametag_color = {r=255, g=255, b=255, a=255},
  nametag_bgcolor = nil,
  infotext = "",
  static_save = true,
  damage_texture_modifier = "^[brighten",
  shaded = true,
  show_on_minimap = false,
}

clearobjects.registered_get_staticdata_loaders = {}
function clearobjects.register_get_staticdata_loader(func)
  if type(func) == "function" then
    table.insert(clearobjects.registered_get_staticdata_loaders, func)
  end
end

local function get_staticdata_loader(entity_name)
  for _,func in pairs (clearobjects.registered_get_staticdata_loaders) do
    local callback = func(entity_name);
    if callback then
      return callback
    end
  end
  local def = minetest.registered_entities[entity_name]
  if not def then
    return nil
  end
  if typ(def.load_staticdata)=="function" then
    return def.load_staticdata
  end
  return nil
end

function clearobjects.create_virtual_entity(entity_name, staticdata)
  local load_staticdata = get_staticdata_loader(entity_name)
  if not load_staticdata then
    return nil
  end
  local object = {
  }
  local data = {
    props = table.copy(initial_properties),
    luae = {
      object = object,
    },
    get_luaentity = function(self)
      return self.luae
    end,
    get_properties = function(self)
      return table.copy(self.props)
    end,
    set_properties = function(self, props)
      for key, val in pairs(props) do
        self.props[key] = val
      end
    end,
  }
  setmetatable(data.luae, {__index=minetest.registered_entities[entity_name] or {name = entity_name}})
  setmetatable(object, {__index=data})

  def.load_staticdata(object, staticdata)

  return object
end

