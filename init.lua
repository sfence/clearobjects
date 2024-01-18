
if not minetest.has_feature("clear_objects_with_callback") then
  error("[clearobjects] This version of Minetest does not support clear_objects call with callback function. Plesa disable this mod or update Minetest version.");
end

local S = minetest.get_translator("clearobjects")
local modpath = minetest.get_modpath(minetest.get_current_modname())

clearobjects = { translator = S}

dofile(modpath.."/shared.lua")
dofile(modpath.."/rules.lua")
dofile(modpath.."/loaders.lua")

function clearobjects.on_clear_object_names(name, _, params)
  if table.indexof(params.names, name) ~= -1 then
    --print("Entity "..name.." is selected to remove")
    return not params.negative
  end
  --print("Entity "..name.." should be keep.")
  return params.negative
end

minetest.override_chatcommand("clearobjects", {
	params = S("[quick | full | hard-quick | hard-full] [(names | not-names <names_list>) | (rules | not-rules <rules_table>)]"),
  func = function (name, param)
		local options = {}
    local check = false;
		if param == "" or param:match("^soft[%s]*") then
      options.mode = "quick"
      options.callback = clearobjects.on_clear_object_rules
      options.params = {
        negative = true,
        e = {prevent_soft_clear = true}
      }
    elseif  param:match("^full%-soft[%s]*") then
      options.mode = "full"
      options.callback = clearobjects.on_clear_object_rules
      options.params = {
        negative = true,
        e = {prevent_soft_clear = true}
      }
    elseif  param:match("^quick[%s]*") then
			options.mode = "quick"
      check = true
		elseif param:match("^full[%s]*") then
			options.mode = "full"
      check = true
		elseif param == "hard-quick" then
			options.mode = "quick"
		elseif param == "hard-full" then
			options.mode = "full"
    else
      return false, S("Bad usage. USe /help clearcomands to get help.")
    end
    if check then
      local begin = param:match("^[%a]+[%s]+names[%s]+")
      local begin_not = param:match("^[%a]+[%s]+not-names[%s]+")
      if begin or begin_not then
			  options.params = {
          negative = (begin_not ~= nil),
          names = string.split(param:sub(begin:len()+1,-1), "[%s]*,[%s]*", nil, nil, true)
        }
        --print(dump(options.params))
        if options.params then
          options.callback = clearobjects.on_clear_object_names
        end
      end
      begin = param:match("^[%a]+[%s]+rules[%s]+")
      begin_not = param:match("^[%a]+[%s]+not-rules[%s]+")
      if begin or begin_not then
			  options.params = minetest.parse_json(param:sub(begin:len()+1,-1))
        if options.params then
          options.params.negative = (begin_not ~= nil)
          options.params.remove_unloaded = options.remove_unloaded or minetest.settings:get_bool("clearobjects_remove_unloaded", false)
          --print(dump(options.params))
          options.callback = clearobjects.on_clear_object_rules
        end
      end
      if not options.callback then
        return false, S("Please, specify names or rules.")
      end
    end

		core.log("action", name .. " clears objects ("
				.. options.mode .. " mode).")
		if options.mode == "full" then
			core.chat_send_all(S("Clearing objects. This may take a long time. "
				.. "You may experience a timeout. (by @1)", name))
		end
		core.clear_objects(options)
		core.log("action", "Object clearing done.")
		core.chat_send_all("*** "..S("Cleared objects with using rule @1.", options.mode))
		return true
	end,
})
