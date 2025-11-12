-- lava_particles/init.lua


-- Namespace
lava_particles = {}
local scan_box = vector.new(32, 8, 32)

-- Create particles
function lava_particles.create_lava_particles()
	for _,player_obj in pairs(core.get_connected_players()) do
		if (player_obj == nil) then break end
		local new_pos = player_obj:get_pos()
		local rounded_pos = vector.new(math.floor(new_pos["x"]), math.floor(new_pos["y"]), math.floor(new_pos["z"]))
		local blocks = core.find_nodes_in_area_under_air(rounded_pos - scan_box, rounded_pos + scan_box, "default:lava_source")
		
		for _,lpos in pairs(blocks) do
			lnode = core.get_node(lpos)
			lpos_above = vector.offset(lpos, 0, 1, 0)
			if (math.random(1,40) == 1) then
				core.add_particlespawner({
					amount = math.random(1,3),
					time = 60,
					node = {name = lnode.name},
					object_collision = true,
					collisiondetection = true,
					collision_removal = true,
					exptime = 1,
					playername = player_obj:get_player_name(),
					minpos = vector.offset(lpos_above, -0.5, 0, -0.5),
					maxpos = vector.offset(lpos_above,  0.5, 0,  0.5),
					minvel = {x = -0.8, y = 1, z = -0.8},
					maxvel = {x = 0.8, y = 3, z = 0.8},
					minacc = {x = -1, y = 4, z = -1},
					maxacc = {x = 1, y = 8, z = 1},
					glow = 7,
				})
			end
		end
	end
end

function lava_particles.timer(dtime)
	lava_particles.elapsed = lava_particles.elapsed + dtime
	if lava_particles.elapsed > lava_particles.interval then
		lava_particles.create_lava_particles()
		lava_particles.interval = math.random(5,30)
		lava_particles.elapsed = 0.0
	end
end

lava_particles.interval = math.random(5,30)
lava_particles.elapsed = 0.0

minetest.register_globalstep(function(dtime)
	lava_particles.timer(dtime)
end)
