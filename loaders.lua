
-- use deserialize to load decode staticdata
function clearobjects.serialized_staticdata_without_props(entity, staticdata)
  local data = minetest.deserialize(staticdata)
  if not data then
    return false
  end

  --print("deserialized: "..dump(data))
  for key, value in pairs(data) do
    entity[key] = value
  end
  return true
end 

-- register static data loader for builtin item and falling node.
clearobjects.register_get_staticdata_loader(function(entityname)
    --print("loader for: "..entityname)
    if (entityname == "__builtin:item")
        or (entityname == "__builtin:falling_node") then
      return clearobjects.serialized_staticdata_without_props
    end
    return nil
  end)
