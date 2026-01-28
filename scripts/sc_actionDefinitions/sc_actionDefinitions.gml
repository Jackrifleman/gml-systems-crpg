//enums

//action enums
enum cAction
{
	ATTACK,
	ABILITY,
}
//target enums
enum cTarget
{
	ENEMY,
	ALLY,
	SELF,
	ENEMY_ALL, //to be renamed, will be treated as Self-cast (0range) AoEs
	ALLY_ALL,  //to be renamed, will be treated as Self-cast (0range) AoEs
	ENEMY_AOE,
	ALLY_AOE
}
//buff enums
enum cBuff
{
	DMG,
	HEAL,
	DMG_MOD,
	HEAL_MOD,
	MP_DMG,
	MP_HEAL,
	STUN,
	STUN_GOLD
}

//buff constructor
function buff(_type = cBuff.DMG, _value = 10, _dur = -1, _target = cTarget.ENEMY, size = 0)
{
	var _b =
	{
		type	: _type,
		value	: _value,
		dur		: _dur,
		target	: _target,
		size	: size,
	}
	return _b
}
//action standard
function action(_name="Action", _desc="An action.",_icon=spr_action_placeholder,_buffs=[],_type=cAction.ATTACK,_target=cTarget.ENEMY,_cost=0,_sound = sfx.ATTACK_GENERIC, _ap_cost = 2, _range = 2)
{
	var _a = 
	{
		name	: _name,
		desc	: _desc,
		icon	: _icon,
		buffs	: _buffs,
		type	: _type,
		target  : _target,
		cost	: _cost,
		sound	: _sound,
		apCost  : _ap_cost,
		range	: _range,
	};
	return _a;
}

//get strings from actions
#region Action Strings
//get type of action
function actionStringType(aType)
{
	var str = "";
	switch(aType)
	{
		case cAction.ATTACK: str += "Attack"; break;
		case cAction.ABILITY: str += "Ability"; break;
	}
	
	
	return str;
}

//get target of action
function actionStringTarget(aTarget)
{
	var str = "";
	switch(aTarget)
	{
		case cTarget.ALLY: str += "Ally"; break;
		case cTarget.ALLY_ALL: str += "All Allies"; break;
		case cTarget.ENEMY: str += "Enemy"; break;
		case cTarget.ENEMY_ALL: str += "All Enemies"; break;
		case cTarget.SELF: str += "Self"; break;
	}
	
	return str;
}

//get buff type
function actionStringBuff(aBuff)
{	
	var str = "";
	switch(aBuff)
	{
		case cBuff.DMG: str += "DMG"; break;
		case cBuff.HEAL: str += "HEAL"; break;
		case cBuff.DMG_MOD: str += "DMG MULT"; break;
		case cBuff.HEAL_MOD: str += "HEAL MULT"; break;
		case cBuff.MP_DMG: str += "MP DMG"; break;
		case cBuff.MP_HEAL: str += "MP HEAL"; break;
		case cBuff.STUN: str += "STUNNED"; break;
		case cBuff.STUN_GOLD: str += "TRANSMUTED!"; break;
	}
	return str;
}

//get unit buffs
function actionStringUnitBuffs(uBuffs)
{
	var str = "";
	for(var i = 0; i < array_length(uBuffs); i++)
	{
		var b = uBuffs[i];
		if (b.value > 0) {
			str += string(b.value) + " " + actionStringBuff(b.type);
		} else {
			str += actionStringBuff(b.type);
		}
		if (b.dur > 0)
		{
			str += " (" + string(b.dur) + " Turns)";	
		}
		str += "\n";
	}
	return str;
}

//get actions buffs
function actionStringAllBuffs(aBuffs)
{
	var str = "";
	for(var i = 0; i < array_length(aBuffs); i++)
	{
		var b = aBuffs[i];
		str += actionStringTarget(b.target) + ": ";
		//percent or additive check
		if(b.type == cBuff.DMG_MOD || b.type == cBuff.HEAL_MOD) {
			str += string(b.value) + "x " + actionStringBuff(b.type);
		} 
		else if (b.type == cBuff.STUN) {
			str += "STUNNED";
		} 
		else if (b.type == cBuff.STUN_GOLD) {
			str += "TRANSMUTED!";
		}
		else {
			str += string(b.value) + " " + actionStringBuff(b.type);
		}
		if (b.dur > 0)
		{
			str += " (" + string(b.dur) + " Turns)";	
		}
		str += "\n";
	}
	return str;
}

//produce tooltip for an action
function actionFetchTooltip(_action) {
	var tooltip = tooltipNew(
	[
		tooltipImage(_action.icon,0,1.0),
		tooltipText($"{_action.name}"),
		tooltipText(_action.desc),
        tooltipText($"Range: {_action.range}"),
		tooltipText(""),
		tooltipText($"AP Cost: {_action.apCost}"),
		tooltipText($"MP Cost: {_action.cost}\n"),
		tooltipText(actionStringAllBuffs(_action.buffs))
	
	])	
	return tooltip.content;
}

#endregion

#region Actions
function combatActionAttack(dmg = 10)
{
	var _a = action(
		"Attack",
		"A basic attack.",
		spr_action_attack_melee,
		[buff(cBuff.DMG,dmg)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0
	);
	return _a;
}

function combatActionAttackAOE(dmg = 15,size = 5) {
		var _a = action(
		"AOE Attack",
		"A basic AOE attack.",
		spr_action_ability,
		[buff(cBuff.DMG,dmg,,cTarget.ENEMY,size)],
		cAction.ATTACK,
		cTarget.ENEMY_AOE,
        ,
        ,
        8
		
	);

	return _a;
}


function combatActionSwordSlice(dmg = 15)
{
	var _a = action(
		"Sword Slice",
		"A basic sword attack.",
		spr_action_attack_melee,
		[buff(cBuff.DMG,dmg)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.SLICE
	);
	return _a;
}

function combatActionBowShot(dmg = 20)
{
	var _a = action(
		"Bow Shot",
		"A basic bow attack.",
		spr_action_attack,
		[buff(cBuff.DMG,dmg)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.BOW_SHOT,
        ,
        8
	);

	return _a;
}

function combatActionGunShot(dmg = 25)
{
	var _a = action(
		"Gun Shot",
		"A basic gun attack.",
		spr_action_pierce,
		[buff(cBuff.DMG,dmg)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.GUN_SHOT
	);	
	_a.range = 6;
	return _a;
}

function combatActionSkaterBoom()
{
	var _a = action(
		"Mayo Bomb",
		"A crazy bomb attack.",
		spr_action_upheaval,
		[buff(cBuff.DMG,200,-1,cTarget.ENEMY_ALL), buff(cBuff.DMG,20,-1,cTarget.ALLY_ALL)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.EXPLOSION
	);
	return _a;
}

function combatActionPoisonBite()
{
	var _a = action(
		"Venomous Bite",
		"A low damage attack which applies a strong poison.",
		spr_action_upheaval,
		[buff(cBuff.DMG,5),buff(cBuff.DMG,20,4),buff(cBuff.MP_DMG,5,4)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.SPIDER_BITE
	);
	_a.range = 1;
	return _a;
}

function combatActionGlitterBite()
{
	var _a = action(
		"Siphoning Bite",
		"A low damage attack which applies a strong mana poison, siphoning MP.",
		spr_action_upheaval,
		[buff(cBuff.DMG,5),buff(cBuff.DMG,5,4),buff(cBuff.MP_DMG,20,4), buff(cBuff.MP_HEAL,25,4,cTarget.SELF)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.SPIDER_BITE
	);
	_a.range = 1;
	return _a;
}

function combatActionGlitterBomb()
{
	var _a = action(
		"Glitter Bomb",
		"An AOE attack which applies an extreme mana break to all enemies and a heal to all allies.",
		spr_action_shine,
		[buff(cBuff.DMG,10,-1,cTarget.ENEMY_ALL),buff(cBuff.MP_DMG,1000,-1,cTarget.ENEMY_ALL),buff(cBuff.HEAL,25,-1,cTarget.ALLY_ALL)],
		cAction.ATTACK,
		cTarget.ENEMY_ALL,
		25,
		sfx.SHINE
	);
	return _a;
}

function combatActionNecroticBite()
{
	var _a = action(
		"Necrotic Bite",
		"A low damage attack which applies a fatal poison.",
		spr_action_upheaval,
		[buff(cBuff.DMG,15),buff(cBuff.DMG,60,4),buff(cBuff.MP_DMG,10,4),buff(cBuff.HEAL_MOD,0.2,4)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.IMPALE
	);
	return _a;
}

function combatActionGoldenBite()
{
	var _a = action(
		"Midas Bite",
		"Permanently incapcitate an enemy.",
		spr_action_upheaval,
		[buff(cBuff.DMG,5),buff(cBuff.STUN_GOLD,0,100)],
		cAction.ATTACK,
		cTarget.ENEMY,
		777,
		sfx.IMPALE_DARK
	);
	return _a;
}

function combatActionJackpot() {
	var _a = action(
		"Money Printer",
		"All that glitters...",
		spr_action_shine,
		[buff(cBuff.MP_HEAL,777,,cTarget.SELF),buff(cBuff.DMG_MOD,5.0,2,cTarget.SELF)],
		cAction.ABILITY,
		cTarget.SELF,
		10,
		sfx.DARK_IMPULSE
	);
	return _a;
	
}

function combatActionHealAlliesMulti()
{
	var _a = action(
		"Heal",
		"A strong heal over time.",
		spr_action_heal,
		[buff(cBuff.HEAL,30,10,cTarget.ALLY_ALL)],
		cAction.ATTACK,
		cTarget.ALLY_ALL,
		50
	);
	_a.range = 8;
	return _a;
}

function combatActionDamageEnemiesMulti()
{
	var _a = action(
		"Bleed",
		"A strong damage over time.",
		spr_action_attack_melee,
		[buff(cBuff.DMG,30,10,cTarget.ENEMY_ALL)],
		cAction.ATTACK,
		cTarget.ENEMY_ALL,
		0
	);
	return _a;
}

function combatActionShadowMend()
{
	var _a = action(
		"SHADOW MEND",
		"Heals a targeted ally.",
		spr_action_void,
		[buff(cBuff.HEAL,100,-1,cTarget.ALLY)],
		cAction.ABILITY,
		cTarget.ALLY,
		100,
		sfx.DARK_IMPULSE
	);
	_a.range = 8;
	return _a;
}

function combatActionShadowLeech()
{
	var _a = action(
		"SHADOW LEECH",
		"Full-party heal, absorbed from an enemy.",
		spr_action_lifesteal,
		[buff(cBuff.DMG,120),buff(cBuff.HEAL,60,-1,cTarget.ALLY_ALL),buff(cBuff.HEAL,15,3,cTarget.ALLY_ALL)],
		cAction.ABILITY,
		cTarget.ENEMY,
		400,
		sfx.DARK_IMPULSE
	);
	_a.range = 8;
	return _a;
}

function combatActionShadowShot()
{
	var _a = action(
		"SHADOW SHOT",
		"legalize nuclear bombs",
		spr_action_shadow_shot,
		[buff(cBuff.DMG,90)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.GUN_SHOT
	);
	_a.range = 6;
	return _a;
}

function combatActionShadowSiphon()
{
	var _a = action(
		"VOID SIPHON",
		"Steal mana from a target, granting it to the user.",
		spr_action_lifesteal,
		[buff(cBuff.DMG,60),buff(cBuff.MP_DMG,300),buff(cBuff.MP_HEAL,300,-1,cTarget.SELF)],
		cAction.ABILITY,
		cTarget.ENEMY,
		100,
		sfx.DARK_IMPULSE
	);
	_a.range = 10;
	return _a;
}

function combatActionShadowRestore()
{
	var _a = action(
		"VOID CONDUIT",
		"Heavily replenish the MP of all allies.",
		spr_action_void,
		[buff(cBuff.MP_HEAL,300,-1,cTarget.ALLY_ALL),buff(cBuff.MP_DMG,200,-1,cTarget.SELF),buff(cBuff.MP_HEAL,50,10,cTarget.SELF)],
		cAction.ABILITY,
		cTarget.ALLY_ALL,
		100,
		sfx.DARK_IMPULSE
	);
	return _a;
}

function combatActionShadowPulse()
{
	var _a = action(
		"SHADOW PULSE",
		"Forbidden energies.",
		spr_action_shadow_shot,
		[buff(cBuff.DMG,100)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.IMPALE_DARK
	);
	_a.range = 8;
	return _a;
}

function combatActionShadowPulseSlice()
{
	var _a = action(
		"SLICING SHADOW PULSE",
		"Forbidden energies.",
		spr_action_attack_katana,
		[buff(cBuff.DMG,150)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.WZRD_BLADE_SLICE
	);
	_a.range = 3;
	return _a;
}

function combatActionShadowPunch()
{
	var _a = action(
		"SHADOW SLUG",
		"legalize nuclear fists",
		spr_action_shadow_shot,
		[buff(cBuff.DMG,130)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0
	);
	_a.range = 3;
	return _a;
}

function combatActionShadowEmpower()
{
	var _a = action(
		"ANCIENT POWER",
		"You're in for some hurt.",
		spr_action_lifesteal,
		[buff(cBuff.DMG_MOD,1.5,2,cTarget.ALLY_ALL),buff(cBuff.HEAL,30,-1,cTarget.ALLY_ALL),buff(cBuff.HEAL,10,3,cTarget.ALLY_ALL)],
		cAction.ABILITY,
		cTarget.ALLY_ALL,
		500,
		sfx.DARK_IMPULSE
	);
	return _a;
}

function combatActionShadowTendril()
{
	var _a = action(
		"Abyss",
		"From beyond.",
		spr_action_lifesteal,
		[buff(cBuff.DMG,200),buff(cBuff.HEAL,20,-1,cTarget.SELF)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.IMPALE_DARK
	);
	_a.range = 3;
	return _a;
}

function combatActionAttackKatana()
{
	var _a = action(
		"Fine Slice",
		"A powerful attack with a Katana.",
		spr_action_attack_katana,
		[buff(cBuff.DMG,40)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.SLICE
	);
	return _a;
}

function combatActionPitchforkPoke(dmg = 30)
{
	var _a = action(
		"Pitchfork Poke",
		"A strong attack with a Pitchfork. Causes bleeding.",
		spr_action_cleave_polearm,
		[buff(cBuff.DMG,dmg),buff(cBuff.DMG,5,3)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.SLICE
	);
	_a.range = 3;
	return _a;
}

function combatActionFoxShine()
{
	var _a = action(
		"Shine",
		"Comes out frame 1. Jump cancellable.",
		spr_action_shine,
		[buff(cBuff.DMG,30,,,2), buff(cBuff.MP_DMG,25,,,2)],
		cAction.ABILITY,
		cTarget.ENEMY_AOE,
		5,
		sfx.SHINE
	);
	_a.range = 2;
	return _a;
}

function combatActionFoxLaser()
{
	var _a = action(
		"Laser",
		"The nimble fox prefers to laser-camp instead of melee.",
		spr_action_pierce,
		[buff(cBuff.DMG,15)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.LASER_HEAVY
	);
	_a.range = 8;
	return _a;
}

function combatActionBoneSlice(dmg = 175, dot = 10)
{
	var _a = action(
		"Rend",
		"Very heavy attack, causes bleeding.",
		spr_action_attack_katana,
		[buff(cBuff.DMG,dmg),buff(cBuff.DMG,dot,4)],
		cAction.ATTACK,
		cTarget.ENEMY,
		0,
		sfx.IMPALE
	);
	_a.range = 3;
	return _a;
}

#endregion