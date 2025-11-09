-- lava_particles/init.lua


-- Namespace
lava_particles = {}


local players = {}
local scan_box = vector.new(32, 8, 32)

core.register_on_joinplayer(
	function(player, last_login)
		table.insert(players, player:get_player_name())
	end
)

-- Update Particles
function lava_particles.update_particles()
	for _,player in pairs(players) do
		local new_player_obj = core.get_player_by_name(player)
		if (new_player_obj == nil) then break end
		local new_pos = new_player_obj:get_pos()
		local rounded_pos = vector.new(
			math.floor(new_pos["x"]),
			math.floor(new_pos["y"]),
			math.floor(new_pos["z"])
		)
		local blocks = core.find_nodes_in_area(
			rounded_pos - scan_box,
			rounded_pos + scan_box,
			"default:lava_source")
		for _,lpos in pairs(blocks) do
			lnode = core.get_node(lpos)
			lpos_above = vector.offset(lpos, 0, 1, 0)
			lnode_above = core.get_node(lpos_above)
			if (lnode_above.name == "air") and (math.random(1,10) == 1) then
				core.add_particlespawner({
					amount = math.random(1,3),
					time = 2400,
					node = {name = lnode.name},
					object_collision = true,
					collisiondetection = true,
					collision_removal = true,
					exptime = 1,
					playername = player,
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
	core.after(5, lava_particles.update_particles)
end

core.after(0.2, lava_particles.update_particles)
