/// @description TODO: add AOEs to valpoints

//movement vars
spd = 4;
spdDecay = 1;
hSpd = 0;
vSpd = 0;
path = undefined;
pathing = 0;

//vars
player = obj_player;
cam = ent_camera;

//combat vars
stats = combatStatsCreate();
combatParty = [];
team = 2; //0 player (def blue), 1 player-hostile (def red), 2 neutral
ops = [];
inCombat = 0;
doAggro = false;
aggro_search = true;
aggro_alerted = false;
aggro_search_position = {x : x, y : y};
aggro_combat_range = 0.5;
aggro_players_only = true;
aggro_ally_call_radius = 8; //ally combat call radius, in units 

selectedAction = undefined;
selected = 0;
targeted = 0;
canAct = 1;
ai = 1;
aiAction = -1;
aiTarget = -1;
aiGridTarget = {
	x : x,
	y : y
}
aiGridPath = {
	x : x,
	y : y
}
aiGroundTarget = {
	x : x,
	y : y
}

ai_follow_target = undefined; //undefined or npc ref
ai_follow_distance = 32*1+24; //radius in units to trigger movement

attackCritical = false;
canAct = 0;
pos = -1;
teamColor = c_white;
teamColorAlt = c_grey;
canDie = 1;
buffs = [];

alarm[9] = 1;

//init inventory
mItem = item_new(item_type.npc);

//visual vars
alarm[0] = 1;
sprIdle = spr_cf_small;
sprMoving = spr_cf_small;
sprDir = choose(-1,1);
sprDepth = layer_get_depth("NPC");
sprSinHover = 0;
sprScale = 1;
sprShadowScale = 1;
sprShadowAura = 0;
sprCyanReplacer = undefined;
sprOverride = false;
sprFinalY = y;
sprFinalXScale = stats.sprite.scale;
drawHidden = 0;
drawStats = 0;
drawBars = 1;
drawGold = false;
drawGlow = true;

tooltip = tooltipNew();
npcFetchTooltip = function() {
	tooltip.content =
	[
		tooltipImage(stats.portrait),
		tooltipText(stats.name),
		tooltipText(stats.class),
		tooltipText($"Lvl. {stats.lvl}"),
		tooltipText($"HP | {stats.hp}/{stats.hpMax}"),
		tooltipText($"MP | {stats.mp}/{stats.mpMax}"),
	]
}

npc_fetch_context_tooltip = function() {
    //open inventory for npc
    global.selected_npc = self;
    
    //hold shift for debug menu/commands
    if (global.modShift) 
    {
        var tooltip = tooltipNew([
            tooltipText(stats.name, merge_color(teamColor,c_white,0.5)),
            tooltipImage(spr_action_ability,,0.5),
            tooltipText_Smart("Control",c_critPink),
            tooltipText_Smart("Reset",c_critGreen),
            tooltipText_Smart("Kill",c_critRed),
            tooltipText_Smart("Gild",global.item_rarity_colors[item_rarity.legendary]),
            tooltipText_Smart("alt-f4",c_red),
            tooltipText_Smart("Close")
        
        ]);
        tooltip.border = c_teamRedAlt;
        
        //control
        tooltip.content[2].on_interact = function() {
            with (obj_npc_parent) {
                playerControlled = false;
            }
            global.selected_npc.playerControlled = true;
            ent_global.cam.target = global.selected_npc;
            global.combatSelected = global.selected_npc;
            instance_destroy(ent_ui_context);
        }
        //reset
        tooltip.content[3].on_interact = function() {
            global.selected_npc.alarm[0] = 1;
            global.selected_npc.stats.hp = global.selected_npc.stats.hpMax;
            global.selected_npc.stats.mp = global.selected_npc.stats.mpMax;
            instance_destroy(ent_ui_context);
        } 
        //kill
        tooltip.content[4].on_interact = function() {
            global.selected_npc.hp = 0;
            global.selected_npc.reserved_draw_healthbar_smooth_hp = 0;
            instance_destroy(ent_ui_context);
        }
        //gild
        tooltip.content[5].on_interact = function() {
            global.selected_npc.drawGold = !drawGold;
            instance_destroy(ent_ui_context);
        }
        
        //die
        tooltip.content[6].on_interact = function() {
            game_end();
        }
        
        return tooltip;
    }    
    
    
    var tooltip = tooltipNew([
        tooltipText(stats.name, merge_color(teamColor,c_white,0.5)),
        tooltipText_Smart("View Inventory"),
        tooltipText_Smart("Inspect"),
        tooltipText_Smart("Close")
        
    ]);
    tooltip.border = teamColor;
    
    
    tooltip.content[1].on_interact = function() {
        //ent_ui_inventory.openDisplay(global.selected_npc);
        instance_destroy(ent_ui_context);
        var inv = instance_create_depth(x,y,ent_cursor.depth-1,ent_ui_window);
        inv.tooltip = ui_prefab_inventory(global.selected_npc.mItem);
        inv.x = clamp(x,ent_camera.x-416,ent_camera.x);
    }
    tooltip.content[2].on_interact = function() {
        ent_ui_inspect.targetObj = global.selected_npc;
        ent_ui_inspect.visible = true;
        instance_destroy(ent_ui_context);
    }
    tooltip.content[3].on_interact = function() {
        instance_destroy(ent_ui_context);
    }
    
    return tooltip;
}

glowHelper = draw_layer("glow",1,function() {
	var shader = shd_npc_glow_mask;
	var o = self;
	
	if (o.drawGlow) {
		shader_set(shader);

			draw_sprite_ext(o.sprite_index,o.image_index,o.x,sprFinalY+o.vSpd,o.sprFinalXScale,o.stats.sprite.scale,0,c_white,1.0);

		shader_reset();
	}
});


//create dialogue array
dArray = [];
array_push(dArray,dialogueCreateCustom());
dEndScript = d_destroy;

//flags
hasDialogue = 0;
playerControlled = false;
//dPromptRange = 64;
dPromptInRange = 0;


chatter_duration = -1;
chatterTestString = "";//choose("Urh?","gruh..","Blung!!","You'll never get to the King!!\nHY-YAHH!");

//RESERVED
sh_uCol = shader_get_uniform(shd_replace_cyan,"uCol");
sh_uCoords = shader_get_uniform(shd_npc_gold,"uCoords");
reserved_draw_healthbar_smooth_hp = stats.hpMax;
reserved_draw_healthbar_smooth_mp = stats.mpMax;
reserved_bars_updateDelayFrames = 0;

//sprite functions
spriteSet = function() {
	
}

//npc functions
npcIdleRoamBuildUp = -300;
doIdleRoam = true;

//follows ai_follow_target npc ref, moving within radius if leaving
ai_follow_lead = function() {
    var target = ai_follow_target;
    var dist = point_distance(x,y,target.x,target.y);
    var nx = 0//irandom(1)+1 * -sign(target.hSpd);
    var ny = 0//irandom(1)+1 * -sign(target.vSpd);
    
    if (dist > ai_follow_distance) {
        path = unitPathfind(x,y,target.x+nx,target.y+ny);
        pathing = 1;
    }
}

//combat functions
#region combat code

//enter combat, calling allies
unit_combat_enter = function() {
    if (inCombat) {
        exit;
    }
    inCombat = 1;
    alarm[4] = -1;
    ent_combat_controller.regenTurnOrder();
    unit_combat_alert_allies();
    unitSnapToPos();
}



//grab and add nearby allies to combat based on aggro_ally_call_radius
unit_combat_alert_allies = function() {
    //all npcs
    with (npc) {
        //if same team
    	if (team != other.team) {
            continue;
        }
        if (inCombat) {
            continue;
        }
        //ally in radius
        if (point_distance(x,y,other.x,other.y) <= other.aggro_ally_call_radius*32) {
            unit_combat_enter();
            show_debug_message($"{other.stats.name} alerted ally {stats.name}");
        }
    }
}

unit_attack_on_sight_in_vision = function(enemy_team_array = [0]) {
    //for all npcs
    if (array_length(enemy_team_array) < 1) {
        exit;
    }
    with (npc) {
        if (!playerControlled) {
            continue;
        }
        //if team is in the enemy team array, do the distance calculation
        if (!array_contains(enemy_team_array,team)) {
            continue;
        }
        var dist = point_distance(other.x,other.y,x,y);
        //enters vision, pursue until 75% dist and then join/start combat
        if (dist < other.stats.vision*32) {
            if (!other.aggro_alerted) {
                other.aggro_alerted = true;
                other.aggro_search_position = {x : x, y : y};
                other.chatterTestString = "?";
                other.chatter_duration = 120;
                other.alarm[4] = 60;
            }
            //enter combat upon this distance
            if (dist < (other.stats.vision*32)*aggro_combat_range) {
                unit_combat_enter();
                other.unit_combat_enter();
                other.chatterTestString = "!";
                other.chatter_duration = 60;
                
                show_debug_message($"{other.stats.name} at {other.x}, {other.y} engaged {stats.name} at {x}, {y}");
                if (!global.combatActive) {
                    ent_global.combat.combatStart();
                }
            }
            
        }
    }
}

unit_spawn_party = function() {
    var n = 1;
    var prevMember = self;
    //spawn party
    if (array_length(combatParty) > 0) {
        for (var i = 0; i < array_length(combatParty); i++) {
            var partyMember = instance_create_depth(x+(irandom_range(-n,n)*32),y+(irandom_range(-n,n)*32),depth,npc);
            partyMember.stats = combatParty[i]();
            partyMember.team = team;
            partyMember.ai = ai;
            partyMember.ops = ops;
            partyMember.ai_follow_target = prevMember;
            prevMember = partyMember;
        }
    }
}

unit_setup_default_teams = function() {
    if (team == 2) {
        doAggro = false;
        ops = [1];
    } else if (team == 1) {
        doAggro = true;
        ops = [0]; //team 0 or default player team is their foil
    } else if (team == 0) {
        ops = [1];
        ai = 0;
    }
}


unitPathfind = function(startX,startY,endX,endY) 
{
	var path = path_add();
	var grid = mp_grid_create(0,0,room_width/32,room_height/32,32,32);

	mp_grid_add_instances(grid,obj_wall,0);
	
	if (mp_grid_path(grid,path,floor(startX/32)*32+16,floor(startY/32)*32+16,floor(endX/32)*32+16,floor(endY/32)*32+16,1)) {
		//leaving cell, mark it free
		unitGridFree();
		//return path for pathing:))
		return path;
	} else {
		return -1;	
	}
	
}

unitGridFree = function() {
	var gridPos = unitGridPos();
	var cell = global.matrix[gridPos.y][gridPos.x];
	cell.free = true;
}

unitGridBlock = function() {
	var gridPos = unitGridPos();
	var cell = global.matrix[gridPos.y][gridPos.x];
	cell.free = false;
}

unitActionBanner = function() {
	var b = instance_create_depth(0,0,0,ent_combat_banner);
	b.text = string_upper(aiAction.name);
	b.col = teamColor;
	alarm[1] = 90;
	cam.target = aiTarget;
}

unit_order_Move = function() {
	var vScale = cam.viewScaleActual;
	var camDist = abs(mouse_y - cam.y);
	var hudCull = 180*vScale;
	var gridDist = ceil(point_distance(x,y,mouse_x,mouse_y)/32);
	var maxDist = stats.movement*stats.ap;
	
	if gridDist > maxDist {
		return 0;
	}


	if (camDist < hudCull) {
		if (selected && team == 0 && inCombat) {
            path = unitPathfind(x,y,mouse_x,mouse_y);
			pathing = 1;
			aiGridPath.x = mouse_x;
			aiGridPath.y = mouse_y;
            var cost = ceil(gridDist/stats.movement);
		    stats.ap -= cost;
		}
	}
	return 1;
}

unitCommitAction = function(_action, target)
{
	
	//TODO: WRITE unitGetFinalCrit()
	attackCritical = (random(1) < stats.crit);
	
	
	var crit = 1.0;
	var val = _action.buffs[0].value;
	
	if (attackCritical) {
		//TODO: WRITE unitGetFinalCritMultiplier()
		crit = stats.critMult;
		val = val*crit;
	}
	
	stats.ap -= _action.apCost;
	stats.mp -= _action.cost/crit;
	
	//apply buffs
	for (var i = 0; i < array_length(_action.buffs); i++)
	{
		//parse targeting
		var bRef = _action.buffs[i];
		var b =  buff(bRef.type,bRef.value,bRef.dur,bRef.target);
			
		if (b.type == cBuff.DMG){
			b.value = floor(b.value*unitGetFinalDamageMultiplier()*crit);	
		} else {
			b.value = b.value*crit;
		}
			
		if (_action.target == cTarget.ENEMY_AOE || b.size > 0) {
			
			if (ai) {
				aiGroundTarget.x = aiTarget.x;
				aiGroundTarget.y = aiTarget.y;
			}
			unitTargetEnemiesAOE(b,_action,aiGroundTarget);
		} else {
			switch (b.target)
			{
				case cTarget.SELF: array_push(buffs,b); target.alarm[3] = 90; break;
				case cTarget.ALLY_ALL: unitTargetAllAllies(b); break;
				case cTarget.ENEMY_ALL: unitTargetAllEnemies(b); break;
					
				default: array_push(target.buffs,b); target.alarm[3] = 90; break;
			}
		}	
		
	}
	
	instance_destroy(ent_combat_flair);
	f = instance_create_depth(0,0,0,ent_combat_flair,{flip : 0,});
	f.unit = self;
	f.target = target;
	f.impactShakeStrength = (val/stats.hpMax)*20;
	f.unitSp = stats.sprite.idleR;
	f.targetSp = target.stats.sprite.idleL;
	f.primaryBuff = _action.buffs[0].type;
	f.buffValue = val;
	f.targeting = _action.target;
	f.sound = _action.sound;
	f.attackCritical = attackCritical;
		
	if (_action.type == cAction.ABILITY){
		f.cast = 1;	
	}
		
	if (team == 1)
	{
		f.flip = 1;	
		f.unitX = f.targetX;
		f.targetX = -128;
	}
	
	if (stats.ap) {
		alarm[2] = 120;
	} else {
		canAct = 0;
		selected = 0;
		ent_combat_controller.alarm[0] = 120; //next turn timer
	}

}

//Treat buffs of -1 as instant, such as a melee attack, applies damage right after action
unitParseBuffsInstant = function()
{
	//show_debug_message(stats.name + " (INST): ");
	var newBuffs = [];
	
	var _hp = stats.hp;
	
	for (var i = 0; i < array_length(buffs); i++)
	{
		var b = buffs[i];
		
		if (b.dur == -1)
		{
			show_debug_message(b);
			switch(b.type)
			{
				case cBuff.DMG: stats.hp -= b.value; break;
				case cBuff.HEAL: stats.hp += b.value; break;
				case cBuff.MP_DMG: stats.mp -= b.value; break;
				case cBuff.MP_HEAL: stats.mp += b.value; break;
			
				default: break;
			}
		} else {
			array_push(newBuffs, b);	
		}
		
	}
	
	reserved_bars_updateDelayFrames = 30;
	var dmg = _hp - stats.hp;
	
	if (dmg < 0) //positive change
	{
		unitStatusTextSpawn("+" + string(dmg*-1) + " HP",c_healGreen, 1);
	} else if (dmg > 0) // negative change
	{ 
		unitStatusTextSpawn(string(dmg*-1) + " HP",c_teamRedAlt, 1);
	}
	
	buffs = newBuffs;
}

unitParseBuffsOnTurn = function()
{
	show_debug_message(stats.name + ": ");
	var newBuffs = [];
	
	var _hp = stats.hp;
	
	for (var i = 0; i < array_length(buffs); i++)
	{
		var b = buffs[i];
		
		if (b.dur > 0)
		{
			b.dur -= 1;
			show_debug_message(b);
			switch(b.type)
			{
				case cBuff.DMG: stats.hp -= b.value; break;
				case cBuff.HEAL: stats.hp += b.value; break;
				case cBuff.MP_DMG: stats.mp -= b.value; break;
				case cBuff.MP_HEAL: stats.mp += b.value; break;
				
				case cBuff.STUN_GOLD: unitStatusTextSpawn("\nTRANSMUTED!",make_color_rgb(255,190,0),1); unitPassTurn(); canDie = 0; break;
				case cBuff.STUN: unitStatusTextSpawn("\nSTUNNED!",c_teamRedAlt,1); unitPassTurn(); break;
			
				default: break;
			}
			
		} 
		
		if (b.dur > 0) {
			array_push(newBuffs, b);	
		}
	}
	
	reserved_bars_updateDelayFrames = 30;
	var dmg = _hp - stats.hp;
	
	if (dmg < 0) //positive change
	{
		unitStatusTextSpawn("+" + string(dmg*-1) + " HP",c_healGreen);
	} else if (dmg > 0) // negative change
	{ 
		var dmgScale = dmg/stats.hpMax;
		show_debug_message("dmg scale: " + string(dmgScale));
		if (dmgScale >= 0.25) {
			audio_play_sound(sfxGetSound(sfx.DMG_MAJOR),100,0);
		} else {
			audio_play_sound(sfxGetSound(sfx.DMG_MINOR),100,0);	
		}
		
		screenshake(dmgScale*5,dmgScale*5,5);
		unitStatusTextSpawn(string(dmg*-1) + " HP",c_teamRedAlt);
	}
	
	buffs = newBuffs;
}

unitTargetAllAllies = function(_buff)
{
	var a = unitGetTeamRefs();
	for (var i = 0; i < array_length(a); i++)
	{
		var b =  buff(_buff.type,_buff.value,_buff.dur,_buff.target);
		array_push(a[i].buffs, b);
		a[i].alarm[3] = 90; //buff parsing delay
	}	
}

unitTargetAllEnemies = function(_buff)
{
	var a = unitGetEnemyRefs();
	for (var i = 0; i < array_length(a); i++)
	{
		var b =  buff(_buff.type,_buff.value,_buff.dur,_buff.target);
		array_push(a[i].buffs, b);
		a[i].alarm[3] = 90; //buff parsing delay
	}	
}

unitTargetEnemiesAOE = function(_buff,_action,_pos)
{
	var a = unitGetEnemyRefsAll();
	var gridPos = posToGrid(_pos.x,_pos.y);
	for (var i = 0; i < array_length(a); i++) {
		var uGridPos = a[i].unitGridPos();
		var distToAOE = point_distance(gridPos.x,gridPos.y,uGridPos.x,uGridPos.y);
		if (distToAOE <= _action.buffs[0].size) {
			var b =  buff(_buff.type,_buff.value,_buff.dur,_buff.target);
			array_push(a[i].buffs, b);
			a[i].alarm[3] = 90;	
		}
	}
}

unitHasAction = function(cAction)
{
	for(var i = 0; i < array_length(stats.actions); i++)
	{
		if (stats.actions[i].type == cAction)
		{
			return true;
		}
	}
	return false;
}

unitGetAction = function(cAction)
{
	for(var i = 0; i < array_length(stats.actions); i++)
	{
		if (stats.actions[i].type == cAction)
		{
			return stats.actions[i];
		}
	}
	return stats.actions[0];
}

unitHasBuff = function(cBuffType) {
	for (var i = 0; i < array_length(buffs); i++) {
		if (buffs[i].type == cBuffType) {
			return true;
		}
	}
	return false;
}

unitSnapToPos = function()
{
	var node = unitGridPos();
	x = node.x*32+16;
	y = node.y*32+16;
}

unitLerpToPos = function(amount)
{
	var node = unitGetPosNode();
	x = lerp(x,node.x,amount);
	y = lerp(y,node.y,amount);
	node.unit = self;
}

unitGetPosNode = function()
{
	with(ent_combat_position_node)
	{
		if (team == other.team && pos == other.pos)
		{
			return self;
		}
	}
}

unitDrawHP = function(hp, hp_max, color_front, color_back, color_border, width, yOffset, color_smooth) {

	var inTotal = width-2;
	var inWidth = inTotal/2;
	var outWidth = width/2;

	if !variable_instance_exists(self,"reserved_draw_healthbar_smooth_hp") {
		reserved_draw_healthbar_smooth_hp = hp_max;
	} else if (!reserved_bars_updateDelayFrames){
		//if (hp > reserved_draw_healthbar_smooth_hp) {
		//	reserved_draw_healthbar_smooth_hp = hp; 
		//} else {
			reserved_draw_healthbar_smooth_hp = lerp(reserved_draw_healthbar_smooth_hp,hp,0.1);
		//}
		
		
	}
	var lastHp = reserved_draw_healthbar_smooth_hp;

	draw_set_color(color_border);
	draw_rectangle(x-outWidth, y+yOffset, x+outWidth, (y-8)+yOffset, 0); //Health Border
	draw_set_color(color_back);
	draw_rectangle(x-inWidth, (y-1)+yOffset, x+inWidth, (y-7)+yOffset, 0); //Health Background
	draw_set_color(color_smooth);
	draw_rectangle(x-inWidth, (y-1)+yOffset, (x-inWidth)+(lastHp/hp_max)*(inTotal), (y-7)+yOffset, 0); //Health Foreground
	draw_set_color(color_front);
	draw_rectangle(x-inWidth, (y-1)+yOffset, (x-inWidth)+(hp/hp_max)*(inTotal), (y-7)+yOffset, 0); //Health Foreground
}

unitDrawMP = function(hp, hp_max, color_front, color_back, color_border, width, yOffset, color_smooth) {

	var inTotal = width-2;
	var inWidth = inTotal/2;
	var outWidth = width/2;

	if !variable_instance_exists(self,"reserved_draw_healthbar_smooth_mp") {
		reserved_draw_healthbar_smooth_mp = hp_max;
	} else if (!reserved_bars_updateDelayFrames) {
		//if (hp > reserved_draw_healthbar_smooth_mp) {
		//	reserved_draw_healthbar_smooth_mp = hp; 
		//} else {
			reserved_draw_healthbar_smooth_mp = lerp(reserved_draw_healthbar_smooth_mp,hp,0.1);
		//}
		
		
	}
	var lastHp = reserved_draw_healthbar_smooth_mp;

	draw_set_color(color_border);
	draw_rectangle(x-outWidth, y+yOffset, x+outWidth, (y-8)+yOffset, 0); //Health Border
	draw_set_color(color_back);
	draw_rectangle(x-inWidth, (y-1)+yOffset, x+inWidth, (y-7)+yOffset, 0); //Health Background
	draw_set_color(color_smooth);
	draw_rectangle(x-inWidth, (y-1)+yOffset, (x-inWidth)+(lastHp/hp_max)*(inTotal), (y-7)+yOffset, 0); //Health Foreground
	draw_set_color(color_front);
	draw_rectangle(x-inWidth, (y-1)+yOffset, (x-inWidth)+(hp/hp_max)*(inTotal), (y-7)+yOffset, 0); //Health Foreground
}

unitGetColor = function()
{
	var col = teamColor;
	switch (team)
	{
		case 0: col = c_teamBlue; break;
		case 1: col = c_teamRed; break;
	
	}
	
	return col;
}

unitGetColorAlt = function()
{
	var col = teamColor;
	switch (team)
	{
		case 0: col = c_teamBlueAlt; break;
		case 1: col = c_teamRedAlt; break;
	
	}
	
	return col;
}

unitGetTeamRefs = function()
{
	var _team = [];
	
	with (obj_npc_parent)
	{
		if (team == other.team)
		{
			array_push(_team, self);	
		}
	}

	return _team;
}

//excluding self
unitGetTeamRefsEx = function()
{
	var _team = [];
	
	with (obj_npc_parent)
	{
		if (team == other.team && id != other.id)
		{
			array_push(_team, self);	
		}
	}

	return _team;
}

unitGetEnemyRefs = function()
{
	var _team = [];
	
	with (obj_npc_parent)
	{
		if (array_contains(other.ops,team) && inCombat)
		{
			if (!unitHasBuff(cBuff.STUN_GOLD) && stats.hp > 0) {
				array_push(_team, self);	
			}
		}
	}

	return _team;
}

unitGetEnemyRefsAll = function()
{
	var _team = [];
	
	with (obj_npc_parent)
	{
		if (array_contains(other.ops,team))
		{
			if (!unitHasBuff(cBuff.STUN_GOLD) && stats.hp > 0) {
				array_push(_team, self);	
			}
		}
	}

	return _team;
}

//make them think!!
unitAIForceStartTurn = function() {
	alarm[2] = 1;	
}

unitAIGetTeamHpScale = function()
{
	var arr = unitGetTeamRefs();
	var arrL = array_length(arr);
	var hpScaleTotals = 0;
	
	for(var i = 0; i < array_length(arr); i++)
	{
		var u = arr[i];
		hpScaleTotals += (u.stats.hp/u.stats.hpMax);
	}
	
	return hpScaleTotals/arrL;
}

unitAIGetEnemyHpScale = function()
{
	var arr = unitGetEnemyRefs();
	var arrL = array_length(arr);
	var hpScaleTotals = 0;
	
	for(var i = 0; i < array_length(arr); i++)
	{
		var u = arr[i];
		hpScaleTotals += (u.stats.hp/u.stats.hpMax);
	}
	
	return hpScaleTotals/arrL;
}

unitAIGetTeamMpScale = function()
{
	var arr = unitGetTeamRefs();
	var arrL = array_length(arr);
	var hpScaleTotals = 0;
	
	for(var i = 0; i < array_length(arr); i++)
	{
		var u = arr[i];
		hpScaleTotals += (u.stats.hp/u.stats.hpMax);
	}
	
	return hpScaleTotals/arrL;
}

unitAIGetEnemyMpScale = function()
{
	var arr = unitGetEnemyRefs();
	var arrL = array_length(arr);
	var hpScaleTotals = 0;
	
	for(var i = 0; i < array_length(arr); i++)
	{
		var u = arr[i];
		hpScaleTotals += (u.stats.mp/u.stats.mpMax);
	}
	
	return hpScaleTotals/arrL;
}

unitAIGetAllyLowestHp = function()
{
	var arr = unitGetTeamRefs();
	var leastHp = arr[0];
	
	
	for(var i = 0; i < array_length(arr); i++)
	{
		if ((arr[i].stats.hp/arr[i].stats.hpMax) < (leastHp.stats.hp/leastHp.stats.hpMax))
		{
			leastHp = arr[i];	
		}
	}
	return leastHp;
}

unit_ai_getAlly_lowestHp_inRange = function(range)
{
	var arr = unitGetTeamRefs();
	var leastHp = arr[0];
	
	var uPos = unitGridPos();
	var tPos = uPos;
	
	var maxRange = range
	
	for(var i = 0; i < array_length(arr); i++)
	{
		tPos = arr[i].unitGridPos();
		var gridDist = point_distance(uPos.x,uPos.y,tPos.x,tPos.y);
		if ((arr[i].stats.hp/arr[i].stats.hpMax) < (leastHp.stats.hp/leastHp.stats.hpMax) && gridDist <= maxRange )
		{
			leastHp = arr[i];	
		}
	}
	return leastHp;
}

//the big decider, will break down into sub functions eventually
//return point value, and best target
//also need to calculate value of AoEs when implemented
unitAIGetActionPoints = function(_action)
{
	var val = 0;
	
	//will return points value, and best target
	var pointsTarget = {
		pnts : val,
		targ : undefined
	}
	
	//get a target in range for this action...
	pointsTarget.targ = unit_ai_getTarget_inRange(_action);
	
	var mult_outOfRange = 1.0;
	var mult_outOfMana = 1.0;
	var mult_outOfAp = 1.0;
	
	//can't use if can't reach a target
	if(pointsTarget.targ == undefined) {
		mult_outOfRange = 0.5;	
	}
	//can't use if no mana
	if (_action.cost > stats.mp){
		mult_outOfMana = 0.2;
	}
	//can't use if no ap
	if (stats.ap < _action.apCost) {
		return pointsTarget;
	}
	
	
	
	var tHpScale = 1-unitAIGetTeamHpScale();
	var eHpScale = 0.5+unitAIGetEnemyHpScale();
	var tMpScale = 1.25-unitAIGetTeamMpScale();
	var eMpScale = unitAIGetEnemyMpScale();
	
	
	for(var i = 0; i < array_length(_action.buffs); i++)
	{
		var b = _action.buffs[i];
		
		var targetMult = 1;
		
		switch (b.target)
		{
			case cTarget.ALLY_ALL: targetMult = 2; break;
			case cTarget.ALLY: targetMult = 1.25; break;
			case cTarget.SELF: targetMult = 1.0; break;
			case cTarget.ENEMY_ALL: targetMult = 1.25; break;
			
			default: targetMult = 1; break;
		}
		
		switch (b.type)
		{
			case cBuff.DMG: val += targetMult*eHpScale*(7.5*((b.value*unitGetFinalDamageMultiplier())/stats.hpMax)); break;
			case cBuff.HEAL: val += targetMult*tHpScale*(7.5*(b.value/stats.hpMax)); break;
			case cBuff.DMG_MOD: val += targetMult*eHpScale*(b.value*2); break;
			case cBuff.HEAL_MOD: val += targetMult*tHpScale*(b.value*2); break;
			case cBuff.MP_DMG: val += targetMult*eMpScale*(3*(b.value/stats.mpMax)); break;
			case cBuff.MP_HEAL: val += targetMult*tMpScale*(6*(b.value/stats.mpMax)); break;
			case cBuff.STUN: val += targetMult*10*b.dur; break;
			case cBuff.STUN_GOLD: val += targetMult*15*b.dur; break;
			
			default: val += targetMult*eHpScale*(5*(b.value/stats.hpMax)); break;
		}
			
	}
	val = val * mult_outOfRange * mult_outOfMana;
	val = floor(val*100);	
	//show_debug_message("Calculated value of " + stats.name + "\'s " + _action.name + ": " + string(val));
	//return floor(val);
	pointsTarget.pnts = val;
	
	return pointsTarget;
}

unitAIGetActionPointsAction = function()
{
	var a = stats.actions[0];
	var aVal = unitAIGetActionPoints(stats.actions[0])
	var aValNew = 0;
	
	for(var i = 1; i < array_length(stats.actions); i++)
	{
		//check if the action could even be used
		if (stats.actions[i].cost <= stats.mp) {
			aValNew = unitAIGetActionPoints(stats.actions[i]);
			//show_debug_message($"{stats.actions[i].name}:{aValNew.pnts}");
			if (aVal.pnts < aValNew.pnts)
			{
				a = stats.actions[i];
				aVal = aValNew;
			}
		}
		
	}

	return {
		actn : a,
		targ : aVal.targ
	};
}

unitAIGetTarget = function(a)
{
	//what does this ability primarily target?
	//enemies
	if (a.target == cTarget.ENEMY || a.target == cTarget.ENEMY_ALL)
	{
		var targHp = -1;
		var targ = self;
		var uPos = unitGridPos();
		var ePos = uPos;
		
		//currently finds tankiest guy and attacks them
		with(obj_npc_parent)
		{
			if (array_contains(other.ops,team))
			{
				if (stats.hp >= targHp)
				{
					targ = self;
					targHp = stats.hp;
				}
			}
		}
		return targ;
	//allies, currently just finds lowest hp ally
	} else if (a.target == cTarget.ALLY || a.target == cTarget.ALLY_ALL) {
		var targ = unitAIGetAllyLowestHp();
		return targ;
	}
	return self;
}

//the smarter unitAIGetTarget
unit_ai_getTarget_inRange = function(a)
{
	
	//maximum range for this ability (all remaining movement after action cost + the cast range)
	var maxRange = stats.movement*(stats.ap-a.apCost)+a.range;
	//what does this ability primarily target?
	//enemies
	if (a.target == cTarget.ENEMY || a.target == cTarget.ENEMY_ALL)
	{
		var targHp = -1;
		var targ = undefined;
		var uPos = unitGridPos();
		var tPos = uPos;
		
		//currently finds tankiest guy and attacks them
		with(obj_npc_parent)
		{
			if (array_contains(other.ops,team))
			{
				tPos = unitGridPos();
				var gridDist = point_distance(uPos.x,uPos.y,tPos.x,tPos.y);
				if (stats.hp >= targHp && gridDist <= maxRange)
				{
					targ = self;
					targHp = stats.hp;
				}
			}
		}
		return targ;
	//allies, currently just finds lowest hp ally
	} else if (a.target == cTarget.ALLY || a.target == cTarget.ALLY_ALL) {
		var targ = unit_ai_getAlly_lowestHp_inRange(maxRange);
		return targ;
	}
	return undefined;
}

//grabs and returns the nearest enemy
unit_ai_getNearest_enemy = function() {
	var dist = 999999;
	var newDist = dist;
	var targ = undefined;
	with (obj_npc_parent) {
		if (array_contains(other.ops,team))	{
			newDist = point_distance(x,y,other.x,other.y)
			if (newDist < dist) {
				dist = newDist;
				targ = self;
			}
		}
	}
	return targ;
}

unitGridPos = function() 
{
	var pos = {
		x : floor(x/32),
		y : floor(y/32)
	}
	return pos;
}



//el navegante!!
unitAINavegante = function()
{
	//before anything else, give them something to work towards if they're out of range
	if (aiTarget == undefined) {
		aiTarget = unit_ai_getNearest_enemy();	
	}
	//check of range ability, distance to target
	var aRange = aiAction.range;
	var dist = point_distance(x,y,aiTarget.x,aiTarget.y);
	
	var gridPos = unitGridPos();
	
	var bestCell = {
		x : gridPos.x,
		y : gridPos.y
	}
	
	var targetNode = aiTarget.unitGridPos();
	
	//ADD TILE RATING SYSTEM SO AI POSITION SMARTER
	
	//2. GATHER ENEMY POSITIONS AND ALLY POSITIONS, (CONSIDER AOEs when they're implemented)
	//3. PER AVAILABLE TILE, RATE EACH TILE BASED ON VARIETY OF CONDITIONS AND FACTORS LIKE RISKS AND BONUSES
	//4. SEND BEST TILE, OR RANDOMLY CHOOSE ONE OF THE BEST, to bestCell.xy
	//5. PLUG IN TO PATHFINDER, SHOULD WORK
	
	var matrix = global.matrix; //localized matrix
	var viableTiles = []; //array will be filled with tiles initially where aiAction is in range against aiTarget
	var node = matrix[0][0];
	//for each node, determine if aiAction can reach aiTarget
	
	//movement distance given remaining to consider 
	var maxGridDist = stats.movement*(stats.ap-aiAction.apCost);
	var fullGridRange = stats.movement*(stats.ap);
	var goalDist = 0;
	var nodeDist = 0;
	
	//1. GET A LIST OF TILES IN RANGE TO USE ABILITY FROM
	//show_debug_message($"Finding viable tiles given aRange {aRange}");
	for	(var i = 0; i < array_length(matrix); i++) {
		for (var j = 0; j < array_length(matrix[0]); j++) {
			node = matrix[i][j];
			//goalDist is distance between the node being checked and the aiTarget node
			goalDist = point_distance(node.x,node.y,targetNode.x,targetNode.y);
			nodeDist = point_distance(gridPos.x,gridPos.y,node.x,node.y);
			if (goalDist <= aRange && nodeDist <= maxGridDist && node.free) {
				array_push(viableTiles,node);
			}
		}
	}
	//show_debug_message("Tiles in range:");
	//show_debug_message(viableTiles);
	
	//if no tiles in movement distance, 
	if (array_length(viableTiles) < 1) {
		for	(var i = 0; i < array_length(matrix); i++) {
		for (var j = 0; j < array_length(matrix[0]); j++) {
			node = matrix[i][j];
			//goalDist is distance between the node being checked and the aiTarget node
			goalDist = point_distance(node.x,node.y,targetNode.x,targetNode.y);
			nodeDist = point_distance(gridPos.x,gridPos.y,node.x,node.y);
			//just go for a big move if out of range, assuming we can't act
			if (nodeDist > fullGridRange*0.75 && nodeDist <= fullGridRange && node.free) {
				if (goalDist < floor(dist/32)) {
					array_push(viableTiles,node);
				}
			}
		}
	}
	}
	

	aiGridTarget = {
		x : bestCell.x,
		y : bestCell.y
	};
	
	
	//before ratings are added, choose a random tile from viableTiles
	if (array_length(viableTiles)) {
		var tile = viableTiles[irandom_range(0,array_length(viableTiles)-1)];
		var tilePos = navNode_get_truePos(tile);
	
		aiGridPath = {
			x : tilePos.x,
			y : tilePos.y
		}
	
	
		//send to pathfinder, convert back to real coords
		show_debug_message("Chosen tile:");
		show_debug_message(tile);
	
		//spend AP to move!!
		stats.ap -= ceil(point_distance(gridPos.x,gridPos.y,tile.x,tile.y)/stats.movement);
	
		path = unitPathfind(x,y,tilePos.x,tilePos.y);
		pathing = 1;
	//still nowhere to go? see if you can attack from position
	} else if (stats.ap > 0) {
		if ((floor(dist)/32) <= aRange)	{
			alarm[0] = 15;
			unitActionBanner();
		}
	} else {
		unitPassTurn();	
	}
}

unitAIDetermineAction = function()
{
	if (!canAct) {
		unitPassTurn();
		exit;
	}
	if (array_length(unitGetEnemyRefs()) < 1) {
		unitPassTurn();
		unitStatusTextSpawn("PASS",make_color_rgb(200,200,200),1);
		exit;
	}
	
	//grab action and target in the form of struct 
	var actionTarget = unitAIGetActionPointsAction();
	show_debug_message($"{stats.name} chose: {actionTarget.actn.name}");
	//aiTarget = unitAIGetTarget(a);
	aiTarget = actionTarget.targ;
	aiAction = actionTarget.actn;
	
	unitAINavegante();
	
}
//turn skipping functionality
unitPassTurn = function() {
	canAct = 0;
	selected = 0;
	ent_combat_controller.alarm[0] = 60;
	
}

unitDie = function()
{
	ent_combat_controller.turnOrderRemoveUnit(self);
	if (ent_combat_controller.unit == self) {
		ent_combat_controller.alarm[0] = 90; //next turn timer
	}
	var e = explosion();
	e.y = y-sprite_get_yoffset(sprite_index)*stats.sprite.scale*2;
	e.image_xscale = 2;
	e.image_yscale = 2;
    

	
	audio_play_sound(sfxGetSound(sfx.DMG_MAJOR),100,0);
	screenshake(5,5,5);
	
	npcFetchTooltip();
	
	var grave = instance_create_depth(x,y,depth+1,obj_npc_grave);
	grave.stats = stats;
	grave.mItem = mItem;
	grave.tooltip = tooltip;
    grave.context = npc_fetch_context_tooltip();
    
	instance_destroy();
    
    with (npc) {
        if (!inCombat) {
            continue;
        }
        if (team != 0) {
            continue;
        }
        if (array_length(unitGetEnemyRefs()) < 1) {
            ent_global.combat.combatEnd();
            break;
        } else {
            break;
        }
    }
}

unitStatusTextSpawn = function(text, color = c_white, delay = 1)
{
	var scaleY = stats.sprite.scale;
	var sprOffset = sprite_get_yoffset(sprite_index)*scaleY;
	var txt = instance_create_depth(x,y-sprOffset-(scaleY/2),depth-1,ent_status_text);
	txt.text = text;
	txt.color = color;
	txt.parent = self;
	txt.alarm[1] = delay;
}

unitGetFinalDamageMultiplier = function()
{
	var _mult = 1;
	for (var i = 0; i < array_length(buffs); i++)
	{
		var b = buffs[i];
		if(b.type == cBuff.DMG_MOD){
			_mult *= buffs[i].value;
		}
	}
	return _mult;
}

unitSaveStats = function()
{
	var fPath = "./stats/" + stats.name + ".json";
	var file = file_text_open_write(fPath);
	var jStr = json_stringify(stats,1);
	file_text_write_string(file,jStr);
	file_text_close(file);
	show_debug_message("Unit saved to " + fPath);
}

unitApplyLevel = function()
{
	stats.hpMax = statsLevel(stats.hpMax,stats.lvl);
	stats.hp = stats.hpMax;
	stats.mpMax = statsLevel(stats.mpMax,stats.lvl);
	stats.mp = stats.mpMax;
	
	for (var i = 0; i < array_length(stats.actions); i++)
	{
		var bArr = stats.actions[i].buffs;
		for (var j = 0; j < array_length(bArr);j++ )
		{
			var b = bArr[j];
			if (b.type != cBuff.DMG_MOD && b.type != cBuff.HEAL_MOD)
			{
				b.value = statsLevel(b.value,stats.lvl);
			}
		}
		stats.actions[i].cost = statsLevel(stats.actions[i].cost,stats.lvl);
	}
}
#endregion combat code