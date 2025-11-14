-- lava_particles/init.lua


-- Namespace
lava_particles = {}

local velmin = vector.new(-0.8, 1, -0.8)
local velmax = vector.new(0.8, 3, 0.8)
local accmin = vector.new(-1, 4, -1)
local accmax = vector.new(1, 8, 1)


-- Spawn particles
function lava_particles.spawn_particles(pos, node)
	-- Block above needs to be air.
	local above = vector.offset(pos, 0, 1, 0)
	if not core.get_node(above).name == "air" then
		return
	end
	
	posmin = vector.offset(above, -0.5, 0, -0.5)
	posmax = vector.offset(above,  0.5, 0,  0.5)
	
	core.add_particlespawner({
		amount = math.random(1,3),
		time = 60,
		node = {name = "default:lava_source"},
		collisiondetection = true,
		collision_removal = true,
		exptime = 1,
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

core.register_abm({
	label = "Spawn lava particles",
	nodenames = {"default:lava_source"},
	interval = 60,
	chance = 250,
	action = function(...)
		lava_particles.spawn_particles(...)
	end,
})
