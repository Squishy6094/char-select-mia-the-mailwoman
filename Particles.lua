local function aura_init(o)
	o.oFlags = (OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
	obj_scale(o, 0.5)
	o.oFriction = 10.0
    o.hitboxRadius = 120
    o.hitboxHeight = 120
    o.oIntangibleTimer = 0
end

local function aura_loop(o)
	obj_set_billboard(o)
	object_step()

	o.oVelY = math.random(5, 8)
	
	if o.oAnimState ~= 6 then
		o.oAnimState = o.oAnimState + 1
	else
		o.oAnimState = 0
	end

	if o.oTimer < 60 then
		o.oMoveAngleYaw = math.random(-0x10000, 0x10000)
	end
	
	if o.oTimer > 30 then
		obj_mark_for_deletion(o)
	end

	o.oTimer = o.oTimer + 1

end

--local E_MODEL_EFFECT = smlua_model_util_get_id("effect_animation_geo")

local function aura_spawner_loop(obj)
	local m = gMarioStates[0]
	obj.oPosX = m.pos.x
	obj.oPosY = m.pos.y - 40
	obj.oPosZ = m.pos.z
    spawn_non_sync_object(id_bhvCoolParticles, E_MODEL_STAR, obj.oPosX + math.random(-40, 40)*1.3, obj.oPosY + math.random(0, 100)*1.3, obj.oPosZ + math.random(-40, 40)*1.3, function(o) obj_scale(o, 0.5) end)
end

id_bhvCoolParticles = hook_behavior(nil, OBJ_LIST_DEFAULT, true, aura_init, aura_loop)
id_bhvCoolParticlesSpawner = hook_behavior(nil, OBJ_LIST_DEFAULT, true, aura_init, aura_spawner_loop)

function effect_update(m)
   if gNetworkPlayers[0].currLevelNum ~= level  and gNetworkPlayers[0].currAreaIndex ~= area then 
      spawn_non_sync_object(id_bhvCoolParticlesSpawner, E_MODEL_NONE, m.pos.x, m.pos.y, m.pos.z, nil)
   end
    area = gNetworkPlayers[0].currAreaIndex
	level = gNetworkPlayers[0].currLevelNum
end

--hook_event(HOOK_MARIO_UPDATE, effect_update)