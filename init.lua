--This creates the livingfloatlands object.
naturalbiomes = {}

--This creates the naturalbiomes.settings object, and fills it with either the menu selected choices as defined in settingtypes.txt, or default values, (In this case, false).
naturalbiomes.settings = {
	clear_biomes = minetest.settings:get_bool("livingfloatlands.clear_biomes") or false,
	clear_decos  = minetest.settings:get_bool("livingfloatlands.clear_decos") or false,
	clear_ores   = minetest.settings:get_bool("livingfloatlands.clear_ores") or false,
}

if naturalbiomes.settings.clear_biomes then
	minetest.clear_registered_biomes()
end
if naturalbiomes.settings.clear_decos then
	minetest.clear_registered_decorations()
end
if naturalbiomes.settings.clear_ores then
	minetest.clear_registered_ores()
end

-- MineClone2
-- MineClone2 support


local modname = "livingfloatlands"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

dofile(path .. '/mod_support_mcl_aliases.lua')

local S = minetest.get_translator and minetest.get_translator("livingfloatlands") or
	dofile(path .. "intllib.lua")

mobs.intllib = S


-- Check for custom mob spawn file
local input = io.open(path .. "spawn.lua", "r")

if input then
	mobs.custom_spawn_livingfloatlands = true
	input:close()
	input = nil
end
mobs.custom_spawn_livingfloatlands = false

minetest.register_node(modname .. ":permafrost", {
	description = S("Permafrost"),
	tiles = { "default_permafrost.png" },
	groups = { cracky = 3 },
	sounds = mcl_sounds.node_sound_dirt_defaults(),
})

minetest.register_node(modname .. ":permafrost_with_stones", {
	description = S("Permafrost with Stones"),
	tiles = { "default_permafrost.png^default_stones.png",
		"default_permafrost.png",
		"default_permafrost.png^default_stones_side.png" },
	groups = { cracky = 3 },
	sounds = mcl_sounds.node_sound_gravel_defaults(),
})

minetest.register_node(modname .. ":permafrost_with_moss", {
	description = S("Permafrost with Moss"),
	tiles = { "default_moss.png", "default_permafrost.png",
		{
			name = "default_permafrost.png^default_moss_side.png",
			tileable_vertical = false
		} },
	groups = { cracky = 3 },
	sounds = mcl_sounds.node_sound_dirt_defaults({
		footstep = { name = "default_grass_footstep", gain = 0.25 },
	}),
})

local fence_collision_extra = minetest.settings:get_bool("enable_fence_tall") and 3 / 8 or 0
function register_fence_rail(name, def)
	minetest.register_craft({
		output = name .. " 16",
		recipe = {
			{ def.material, def.material },
			{ "",           "" },
			{ def.material, def.material },
		}
	})

	local fence_rail_texture = "default_fence_rail_overlay.png^" .. def.texture ..
		"^default_fence_rail_overlay.png^[makealpha:255,126,126"
	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = { { -1 / 16, 3 / 16, -1 / 16, 1 / 16, 5 / 16, 1 / 16 },
				{ -1 / 16, -3 / 16, -1 / 16, 1 / 16, -5 / 16, 1 / 16 } },
			-- connect_top =
			-- connect_bottom =
			connect_front = { { -1 / 16, 3 / 16, -1 / 2, 1 / 16, 5 / 16, -1 / 16 },
				{ -1 / 16, -5 / 16, -1 / 2, 1 / 16, -3 / 16, -1 / 16 } },
			connect_left = { { -1 / 2, 3 / 16, -1 / 16, -1 / 16, 5 / 16, 1 / 16 },
				{ -1 / 2, -5 / 16, -1 / 16, -1 / 16, -3 / 16, 1 / 16 } },
			connect_back = { { -1 / 16, 3 / 16, 1 / 16, 1 / 16, 5 / 16, 1 / 2 },
				{ -1 / 16, -5 / 16, 1 / 16, 1 / 16, -3 / 16, 1 / 2 } },
			connect_right = { { 1 / 16, 3 / 16, -1 / 16, 1 / 2, 5 / 16, 1 / 16 },
				{ 1 / 16, -5 / 16, -1 / 16, 1 / 2, -3 / 16, 1 / 16 } }
		},
		collision_box = {
			type = "connected",
			fixed = { -1 / 8, -1 / 2, -1 / 8, 1 / 8, 1 / 2 + fence_collision_extra, 1 / 8 },
			-- connect_top =
			-- connect_bottom =
			connect_front = { -1 / 8, -1 / 2, -1 / 2, 1 / 8, 1 / 2 + fence_collision_extra, -1 / 8 },
			connect_left = { -1 / 2, -1 / 2, -1 / 8, -1 / 8, 1 / 2 + fence_collision_extra, 1 / 8 },
			connect_back = { -1 / 8, -1 / 2, 1 / 8, 1 / 8, 1 / 2 + fence_collision_extra, 1 / 2 },
			connect_right = { 1 / 8, -1 / 2, -1 / 8, 1 / 2, 1 / 2 + fence_collision_extra, 1 / 8 }
		},
		connects_to = { "group:fence", "group:wall" },
		inventory_image = fence_rail_texture,
		wield_image = fence_rail_texture,
		tiles = { def.texture },
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {},
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	-- Always add to the fence group, even if no group provided
	def.groups.fence = 1

	def.texture = nil
	def.material = nil

	minetest.register_node(name, def)
end

function register_fencegate(name, def)
	local fence = {
		description = def.description,
		drawtype = "mesh",
		tiles = {},
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		is_ground_content = false,
		drop = name .. "_closed",
		connect_sides = { "left", "right" },
		groups = def.groups,
		sounds = def.sounds,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			doors.fencegate_toggle(pos, node, clicker)

			return itemstack
		end,

		selection_box = {
			type = "fixed",
			fixed = { -1 / 2, -1 / 2, -1 / 4, 1 / 2, 1 / 2, 1 / 4 }
		}
	}

	if type(def.texture) == "string" then
		fence.tiles[1] = { name = def.texture, backface_culling = true }
	elseif def.texture.backface_culling == nil then
		fence.tiles[1] = table.copy(def.texture)
		fence.tiles[1].backface_culling = true
	else
		fence.tiles[1] = def.texture
	end

	if not fence.sounds then
		fence.sounds = default.node_sound_wood_defaults()
	end

	fence.groups.fence = 1

	-- mesecons support
	if minetest.get_modpath("mesecons") then
		local function fencegate_switch(pos, node)
			doors.fencegate_toggle(pos, node, { is_fake_player = true })
		end

		fence.mesecons = {
			effector = {
				action_on = fencegate_switch,
				action_off = fencegate_switch
			}
		}
	end

	local fence_closed = table.copy(fence)

	fence_closed.mesh = "doors_fencegate_closed.obj"
	fence_closed._gate = name .. "_open"
	fence_closed._gate_sound = "doors_fencegate_open"
	fence_closed.collision_box = {
		type = "fixed",
		fixed = { -1 / 2, -1 / 2, -1 / 8, 1 / 2, 1 / 2 + fence_collision_extra, 1 / 8 }
	}

	local fence_open = table.copy(fence)

	fence_open.mesh = "doors_fencegate_open.obj"
	fence_open._gate = name .. "_closed"
	fence_open._gate_sound = "doors_fencegate_close"
	fence_open.groups.not_in_creative_inventory = 1
	fence_open.collision_box = {
		type = "fixed",
		fixed = { { -1 / 2, -1 / 2, -1 / 8, -3 / 8, 1 / 2 + fence_collision_extra, 1 / 8 },
			{ -1 / 2, -3 / 8, -1 / 2, -3 / 8, 3 / 8,                         0 } },
	}

	minetest.register_node(":" .. name .. "_closed", fence_closed)
	minetest.register_node(":" .. name .. "_open", fence_open)

	minetest.register_craft({
		output = name .. "_closed",
		recipe = {
			{ "group:stick", def.material, "group:stick" },
			{ "group:stick", def.material, "group:stick" }
		}
	})
end

-- Animals
dofile(path .. "carnotaurus.lua")     --
dofile(path .. "nigersaurus.lua")     --
dofile(path .. "deinotherium.lua")    --
dofile(path .. "mammooth.lua")        --
dofile(path .. "gastornis.lua")       --
dofile(path .. "woollyrhino.lua")     --
dofile(path .. "velociraptor.lua")    --
dofile(path .. "triceratops.lua")     --
dofile(path .. "smilodon.lua")        --
dofile(path .. "parasaurolophus.lua") --
dofile(path .. "gigantopithecus.lua") --
dofile(path .. "wildhorse.lua")       --
dofile(path .. "entelodon.lua")       --
dofile(path .. "oviraptor.lua")       --
dofile(path .. "stegosaurus.lua")     --
dofile(path .. "ankylosaurus.lua")    --
dofile(path .. "lycaenops.lua")       --
dofile(path .. "tyrannosaurus.lua")   --
dofile(path .. "cavebear.lua")        --
dofile(path .. "rhamphorhynchus.lua") --
dofile(path .. "coldsteppe.lua")      --
dofile(path .. "paleodesert.lua")     --
dofile(path .. "giantforest.lua")     --
dofile(path .. "coldgiantforest.lua") --
dofile(path .. "paleojungle.lua")     --
dofile(path .. "dye.lua")             --
dofile(path .. "leafdecay.lua")       --
dofile(path .. "hunger.lua")          --



-- Load custom spawning
if mobs.custom_spawn_livingfloatlands then
	dofile(path .. "spawn.lua")
end



print(S("[MOD] Mobs Redo Animals loaded"))
