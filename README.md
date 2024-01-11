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

### Removing objects by entity names

Remove all entities of type "testentities:cube":
`/clearobjects quick names testentities:cube`

API
---

API can be used to extend capabalities of this mod.

`clearobjects.register_get_staticdata_loader(function(entityname) .. end)`
  * TODO

