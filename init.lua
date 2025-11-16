-- lava_particles/init.lua


-- Namespace
lava_particles = {}

local scan_box = vector.new(32, 8, 32)
local velmin = vector.new(-0.8, 1, -0.8)
local velmax = vector.new(0.8, 3, 0.8)
local accmin = vector.new(-1, 4, -1)
local accmax = vector.new(1, 8, 1)


-- Spawn particles
function lava_particles.spawn_particles()
	for _,player_obj in pairs(core.get_connected_players()) do
		if (player_obj == nil) then break end
		local new_pos = player_obj:get_pos()
		local rounded_pos = vector.new(math.floor(new_pos["x"]), math.floor(new_pos["y"]), math.floor(new_pos["z"]))
		local blocks = core.find_nodes_in_area_under_air(rounded_pos - scan_box, rounded_pos + scan_box, "default:lava_source")
		
		for _,lpos in pairs(blocks) do
			lnode = core.get_node(lpos)
			if (math.random(1,40) == 1) then
				posmin = vector.offset(lpos, -0.5, 1, -0.5)
				posmax = vector.offset(lpos,  0.5, 1,  0.5)
				
				core.add_particlespawner({
					amount = math.random(1,3),
					time = 30,
					node = {name = "default:lava_source"},
					collisiondetection = true,
					collision_removal = true,
					exptime = 1,
					playername = player_obj:get_player_name(),
					minpos = posmin,
					maxpos = posmax,
					pos = {min = posmin, max = posmax},
					minvel = velmin,
					maxvel = velmax,
					vel = {min = velmin, max = velmax},
					minacc = accmin,
					maxacc = accmax,
					acc = {min = accmin, max = accmax},
					glow = 7
				})
			end
		end
	end
end

-- Timer
function lava_particles.timer(dtime)
	lava_particles.elapsed = lava_particles.elapsed + dtime
	if lava_particles.elapsed > lava_particles.interval then
		lava_particles.spawn_particles()
		lava_particles.interval = math.random(5,30)
		lava_particles.elapsed = 0.0
	end
end

lava_particles.interval = math.random(5,30)
lava_particles.elapsed = 0.0

minetest.register_globalstep(function(dtime)
	lava_particles.timer(dtime)
end)
