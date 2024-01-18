Minetest Game mod: ckearobjects
=============================
See LICENSE for license information.

Authors of source code
----------------------
Copyright (c) 2024 SFENCE
MIT - check LICENSE file

Introduction
------------
This mod is targeting for server admins.
It depends on minetest feature `clear_obejcts_with_callback`.
It extends command /clearobjects.

Usage
-----

### Examples

#### Removing objects by entity names

* Remove all entities of type "testentities:cube":
  `/clearobjects quick names testentities:cube`

#### Removing objects by rules

* Remove all `__builtin:item` entities with itemstring "default:stone":
  `/clearobjects quick rules {"e":{"name":"__builtin:item","itemstring":"default:stone"}}'

### Rules descriptions

#### Field `e`

Table with rules for values stored in luaentity.

#### Field `p`

Table with rules for values stored in object properties.

#### Field `remove_unloaded`

This field is default in `false`. if is set to `true`, every entity withou loader will be removed.

#### Field `door`

Combine rules results by or instead of and.

API
---

API can be used to extend capabalities of this mod.

In rules mod, rules functions will try to create virtual entity for each entity.
It check `minetest.registered_entities[entityname]` for `load_staticdata` function.
`function load_staticdata(luaentity, staticdata)` is expected to return true, if deserializing of static data sucess.
If there is no `load_staticdata` function in entity definition, custom registered callbacks will be called in order to find custom load_staticdata functuon.

`clearobjects.register_get_staticdata_loader(function(entityname) .. end)`: register custom callback for deserialize static data
  * Function should return `nil` or `function(luaentity, staticdata)`

