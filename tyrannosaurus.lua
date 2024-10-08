local S = minetest.get_translator("livingfloatlands")

mobs:register_mob("livingfloatlands:tyrannosaurus", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	attack_animals = true,
	attack_monsters = true,
	attack_players = true,
	reach = 12,
	damage = 40,
	hp_min = 300,
	hp_max = 550,
	armor = 100,
	collisionbox = { -2.0, -0.02, -2.0, 2.0, 6.0, 2.0 },
	visual = "mesh",
	mesh = "Tyrannosaurus4.b3d",
	visual_size = { x = 2.0, y = 2.0 },
	textures = {
		{ "texturetyrannosaurus.png" },
		{ "texturetyrannosaurus2.png" },
	},
	sounds = {
		random = "livingfloatlands_tyrannosaurus",
		attack = "livingfloatlands_tyrannosaurus2",
		distance = 20,
	},
	makes_footstep_sound = true,
	walk_velocity = 3,
	run_velocity = 6,
	walk_chance = 20,
	runaway = false,
	jump = false,
	jump_height = 8,
	stepheight = 4,
	drops = {
		{ name = "livingfloatlands:theropodraw", chance = 1, min = 1, max = 1 },
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 6,
	knock_back = false,
	pathfinding = true,
	stay_near = { { "livingfloatlands:paleojungle_litter_leaves", "livingfloatlands:paleojungle_smallpalm", "livingfloatlands:giantforest_grass3", "livingfloatlands:paleojungle_ferngrass" }, 6 },
	animation = {
		speed_normal = 30,
		stand_start = 250,
		stand_end = 350,
		stand1_start = 450,
		stand1_end = 550,
		walk_speed = 75,
		walk_start = 0,
		walk_end = 100,
		punch_speed = 100,
		punch_start = 100,
		punch_end = 200,
		die_start = 100,
		die_end = 200,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},

	follow = {
		"ethereal:fish_raw", "animalworld:rawfish", "mobs_fish:tropical",
		"mobs:meat_raw", "animalworld:rabbit_raw", "animalworld:pork_raw", "water_life:meat_raw",
		"animalworld:chicken_raw", "livingfloatlands:ornithischiaraw", "livingfloatlands:sauropodraw",
		"livingfloatlands:theropodraw", "mobs:meatblock_raw", "animalworld:chicken_raw",
		"livingfloatlands:ornithischiaraw", "livingfloatlands:largemammalraw", "livingfloatlands:theropodraw",
		"livingfloatlands:sauropodraw", "animalworld:raw_athropod", "animalworld:whalemeat_raw", "animalworld:rabbit_raw",
		"nativevillages:chicken_raw", "mobs:meat_raw", "animalworld:pork_raw", "people:mutton:raw"
	},
	view_range = 40,

	on_rightclick = function(self, clicker)
		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 0, 1, false, nil) then return end
	end,
})


if minetest.get_modpath("ethereal") then
	spawn_on = { "ethereal:prairie_dirt", "ethereal:dry_dirt", "mcl_core:dry_dirt_with_dry_grass",
		"mcl_core:dirt_with_rainforest_litter", "mcl_core:sand" }
end


mobs:spawn({
	name = "livingfloatlands:tyrannosaurus",
	nodes = { "livingfloatlands:paleojungle_litter" },
	neighbors = { "livingfloatlands:paleojungle_smallpalm" },
	min_light = 0,
	interval = 60,

	chance = 2000, -- 15000
	min_height = 3,
	max_height = 31000,

})


mobs:register_egg("livingfloatlands:tyrannosaurus", ("Tyrannosaurus"), "atyrannosaurus.png")
