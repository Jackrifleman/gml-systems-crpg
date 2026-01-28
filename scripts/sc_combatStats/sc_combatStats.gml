//default stats
function combatStatsCreate(_name ="???",_class ="NPC",_hp=100,_mp=100,_lvl=1,_xp=0,_actions=[combatActionAttack()],_sprite=sprite_Ktch_Spider(),_portrait=spr_portrait_unknown,_spawnFunc=function(){},_deathFunc=function(){})
{
	var stats = 
	{
		ref			: combatStatsCreate,
		name		: _name,
		class		: _class,
        desc        : "",
		hpMax		: _hp,
		hp			: _hp,
		mpMax		: _mp,
		mp			: _mp,
		dmg			: 1,
		lvl			: _lvl,
		xp			: _xp,
		actions		: _actions,
		sprite		: _sprite,
		portrait	: _portrait,
		spawnFunc	: _spawnFunc, //originally spawn function, now maybe on combat start function?
		deathFunc	: _deathFunc, //custom death function
		inventory	: [],
		apMax		: 3, //action points maximum
		ap          : 3, //action points spent for actions, restored to apMax at beginning of combat turn
		spd			: 4, //physical world speed of character, and initiative advantage
		movement	: 3, //movement is distance you can travel per 1 AP, ie., with 5 movement, 13 units = 3 AP
		crit		: 0.05, //def chance to crit
		critMult	: 2.0,  //def damage multiplier for crits
		dodge		: 15,
        vision      : 8, //aggro radius, essentially 6 units or 192 pixel radius
	};
	return stats;
}

function combatStatsCopy(stats)
{
	var aArray = [];
	for(var i = 0; i < array_length(stats.actions); i++)
	{
		var a = stats.actions[i];
		var _a = action(a.name,a.desc,a.icon,[],a.type,a.target,a.cost,a.sound);
		
		for(var j = 0; j < array_length(a.buffs); j++)
		{
			var b = a.buffs[j];
			var _b = buff(b.type,b.value,b.dur,b.target);
			_a.buffs[j] = _b;
		}
		aArray[i]  = _a;
	}
	
	var c = combatStatsCreate(stats.name,stats.class,stats.hp,stats.mp,stats.lvl,stats.xp,aArray,stats.sprite,stats.portrait,stats.spawnFunc,stats.deathFunc);
	return c;
}


//scaling formula
function statsLevel(value,level){
	var scalar = 1.1;//var scalar = 1.01;
	//return floor(value * (scalar * (level - 1)));
	//return floor(value * ((level-1)^scalar));
	var levelScalar = power(scalar,level-1);
	return floor(value * levelScalar)
	
}

//sprite struct 
function spriteSheetCreate(idle_r = spr_ktch_spider_idle_r, spr_scale = 1, idle_l = idle_r, move_r = idle_r, move_l = move_r, attack_r = idle_r, attack_l = attack_r, flinch_r = idle_r, flinch_l = flinch_r, cast_r = idle_r, cast_l = cast_r)
{
	var spriteSheet = 
	{
		idleR	: idle_r,
		idleL	: idle_l,
		moveR	: move_r,
		moveL	: move_l,
		attackR : attack_r,
		attackL : attack_l,
		flinchR : flinch_r,
		flinchL : flinch_l,
		castR	: cast_r,
		castL	: cast_l,
		scale	: spr_scale,
		mirror  : true,
		shadowScale	: 1,
		shCyanC		: undefined,
		sinHover	: 0,
		shadowAura	: 0,
	}
	return spriteSheet;
}

function sprite_Ktch_Spider() {
	var sprite = spriteSheetCreate(
		spr_ktch_spider_idle_r,
		1.0,
		spr_ktch_spider_idle_l,
		spr_ktch_spider_move_r,
		spr_ktch_spider_move_l,
		spr_ktch_spider_attack_r,
		spr_ktch_spider_attack_l,
		spr_ktch_spider_flinch_r,
		spr_ktch_spider_flinch_l
	)	
	
	return sprite;
}

function sprite_Bone_Skelly() {
    var sprite = spriteSheetCreate(
        spr_bone_skelly_idle_r,
        1.0,
        ,
        spr_bone_skelly_move_r,
        ,
        spr_bone_skelly_attack_r
    )
    return sprite;
}

///STAT BLOCKS///
#region Stat Blocks

//PLAYER
function stats_Player() {
	var stats = combatStatsCreate(
		"Nameless Drifter",
		"of Fractured Humanity",
		50,
		50,
		1,
		0,
		[combatActionSwordSlice(20),combatActionAttackAOE(10,2),combatActionFoxLaser(),combatActionFoxShine(),combatActionShadowRestore(),combatActionGlitterBomb(),combatActionShadowPulseSlice(),combatActionBowShot(),combatActionGoldenBite()],
		spriteSheetCreate(spr_drifter_idle,1.0,,spr_drifter_idle,,spr_drifter_attack,,spr_drifter_idle,,spr_drifter_cast_ancientpower),
		spr_portrait_drifter,
	)	
	
	stats.sprite.shadowScale = 0.8;
	stats.sprite.shCyanC = make_color_rgb(40,120,20);
	
	return stats;
}

//CREATURES//
#region Creatures
//Spider
function statsSpider()
{
	var spr = asset_get_index("spr_spider_" + string(irandom(6)));
	var stats = combatStatsCreate(
		"Spider",
		"Tricky Arachnid",
		15,
		10,
		1,
		0,
		[combatActionPoisonBite()],
		spriteSheetCreate(spr,2),
		spr,
		onSpawnSpider
	);
	
	stats.sprite.shadowScale = 0.33;
	
	return stats;
}
function onSpawnSpider(){
	sprShadowScale = 0.33;
}

function statsSpiderGlitter()
{
	var stats = combatStatsCreate(
		"Glitter Spider",
		"Sparkly Arachnid",
		25,
		25,
		1,
		0,
		[combatActionGlitterBite(), combatActionGlitterBomb()],
		spriteSheetCreate(spr_spider_glitter,2),
		spr_spider_glitter,
		onSpawnSpiderGlitter
	);
	
	stats.sprite.shadowScale = 0.33;
	stats.mp = 0;
	stats.mpMax = 25;
	
	return stats;
}
function onSpawnSpiderGlitter(){
	stats.mp = 0;
}

function statsSpiderElite()
{
	var spr = spr_spider_elite_idle_r;
	var stats = combatStatsCreate(
		"Spider Elite",
		"Deadly Arachnid",
		80,
		20,
		15,
		100,
		[combatActionNecroticBite()],
		spriteSheetCreate(spr,2),
		spr,
		onSpawnSpiderElite
	);
	
	stats.sprite.shadowScale = 0.67;
	
	return stats;
}
function onSpawnSpiderElite()
{
	sprShadowScale = 0.67;
}

function stats_SpiderElite_Bone() {
	var spr = spr_spider_bone_idle_r;
	var stats = combatStatsCreate(
		"Catacomb Spider",
		"Deadly Arachnid",
		80,
		20,
		15,
		100,
		[combatActionNecroticBite()],
		spriteSheetCreate(spr,2),
		spr
	);
	
	stats.sprite.shadowScale = 0.67;
	
	return stats;
}

function statsSpiderGold()
{
	var spr = spr_spider_gold_idle_r;
	var stats = combatStatsCreate(
		"Golden Spider Elite",
		"Expensive Arachnid",
		160,
		777,
		49,
		1440,
		[combatActionNecroticBite(),combatActionGoldenBite(),combatActionJackpot()],
		spriteSheetCreate(spr,2),
		spr,
		onSpawnSpiderGold
	);
	
	stats.sprite.shadowScale = 0.67;
	stats.mp = 25;
	
	return stats;
}
function onSpawnSpiderGold(){
	stats.mp = 0;
}

function statsFox()
{
	var stats = combatStatsCreate(
		"Fox",
		"Highly Proficient Canine",
		40,
		20,
		5,
		0,
		[combatActionFoxLaser(),combatActionFoxShine()],
		spriteSheetCreate(spr_fox_idle_r,1),
		spr_portrait_fox,
		onSpawnFox
	);
	
	stats.sprite.attackR = spr_fox_attack_r;
	stats.sprite.castR = spr_fox_cast_r;
	
	return stats;
}
function onSpawnFox()
{
	stats.sprite.attackR = spr_fox_attack_r;
	stats.sprite.castR = spr_fox_cast_r;
}

function statsSkeleton()
{
	var stats = combatStatsCreate(
		"Giant Skeleton",
		"Reanimated Husk",
		300,
		5,
		20,
		0,
		[combatActionBoneSlice()],
		spriteSheetCreate(spr_bone_skeleton_idle_r,1.0,,spr_bone_skeleton_move_r,,spr_bone_skeleton_attack_r),
		spr_portrait_bone_skeleton
	);
	
	stats.sprite.shadowScale = 1.66;
	
	return stats;
}

function stats_Skeleton_Small()
{
	var stats = combatStatsCreate(
		"Skeleton",
		"Lingering Soul",
		40,
		5,
		1,
		0,
		[combatActionBoneSlice(20,5)],
		sprite_Bone_Skelly(),
		spr_portrait_bone_skelly
	);
	
	stats.sprite.shadowScale = 0.66;
	
	return stats;
}

function stats_BoneSpider()
{
	var stats = combatStatsCreate(
		"Bone Spider",
		"Raspy Husk",
		600,
		5,
		35,
		0,
		[combatActionBoneSlice()],
		spriteSheetCreate(spr_bone_spider_body,1.0),
		spr_portrait_bone_spider
	);
	
	stats.sprite.shadowScale = 1.9;
	stats.spd = 8;
	
	return stats;
}

#endregion

//MAYO KINGDOM//
#region Mayo Kingdom
//knight stats
function statsMayoKnight()
{
	var stats = combatStatsCreate(
		"Knight",
		"Mayo Kingdom",
		80,
		5,
		1,
		0,
		[combatActionSwordSlice()],
		spriteSheetCreate(spr_mayo_knight_idle_r,1,spr_mayo_knight_idle_l,spr_mayo_knight_move_r,spr_mayo_knight_move_l,spr_mayo_knight_attack_r,spr_mayo_knight_attack_l,spr_mayo_knight_flinch_r,spr_mayo_knight_flinch_l),
		spr_portrait_mayo_knight
	);
	
	stats.sprite.mirror = false;
	
	return stats;
}
//archer stats
function statsMayoArcher()
{
	var stats = combatStatsCreate(
		"Archer",
		"Mayo Kingdom",
		60,
		5,
		1,
		0,
		[combatActionBowShot()],
		spriteSheetCreate(spr_mayo_archer_idle_r,1,spr_mayo_archer_idle_l,spr_mayo_archer_move_r,spr_mayo_archer_move_l,spr_mayo_archer_attack_r,spr_mayo_archer_attack_l),
		spr_portrait_mayo_archer,
	);
	
	stats.sprite.mirror = false;
	return stats;
}
//gunner stats
function statsMayoGunner()
{
	var stats = combatStatsCreate(
		"Gunner",
		"Mayo Kingdom",
		70,
		5,
		1,
		0,
		[combatActionGunShot()],
		spriteSheetCreate(spr_mayo_gunner_idle_r,1,spr_mayo_gunner_idle_l,spr_mayo_gunner_move_r,spr_mayo_gunner_move_l,spr_mayo_gunner_attack_r,spr_mayo_gunner_attack_l,spr_mayo_gunner_flinch_r,spr_mayo_gunner_flinch_l),
		spr_portrait_mayo_gunner,
	);

	stats.sprite.mirror = false;
	stats.apMax += 2;
	stats.movement -= 3; 

	return stats;
}
//skater stats
function statsMayoSkater()
{
	var stats = combatStatsCreate(
		"Skater",
		"Mayo Kingdom",
		10,
		100,
		1,
		0,
		[combatActionSkaterBoom()],
		spriteSheetCreate(spr_mayo_skater_idle_r,1),
		spr_portrait_mayo_skater
	);
	
	stats.sprite.mirror = true;
	stats.spd = 12;
	stats.movement += 5;
	
	return stats;
}

function stats_Mayo_Cheerleader() {
	var stats = combatStatsCreate(
		"Cheerleader",
		"Mayo Kingdom",
		50,
		100,
		1,
		0,
		[combatActionAttack(10),combatActionHealAlliesMulti()],
		spriteSheetCreate(spr_mayo_cheer_idle_r,,spr_mayo_cheer_idle_l,spr_mayo_cheer_move_r,spr_mayo_cheer_move_l),
		spr_portrait_mayo_cheer
	
	)
	
	stats.sprite.mirror = false;
	
	return stats;
}

function stats_Mayo_Peasant() {
	var stats = combatStatsCreate(
		"Peasant",
		"Mayo Kingdom",
		10,
		10,
		1,
		15,
		[combatActionAttack(5)],
		spriteSheetCreate(spr_mayo_peasant_idle_r,,spr_mayo_peasant_idle_l,spr_mayo_peasant_move_r,spr_mayo_peasant_move_l),
		spr_portrait_mayo_peasant
	)
	
	stats.sprite.mirror = false;
	
	stats.dodge += 65;
	
	return stats;
}
#endregion

//KETCHUP SULTANATE//
#region Ketchup Sultanate

function stats_Ktch_Spider() {
	var stats = combatStatsCreate(
		"Spider",
		"Ketchup Sultanate",
		125,
		60,
		1,
		0,
		[combatActionAttack(55)],
		spriteSheetCreate(spr_ktch_spider_idle_r,,spr_ktch_spider_idle_l,spr_ktch_spider_move_r,spr_ktch_spider_move_l,spr_ktch_spider_attack_r,spr_ktch_spider_attack_l,spr_ktch_spider_flinch_r,spr_ktch_spider_flinch_l),
		spr_portrait_ktch_spider
	)	
	
	stats.movement += 4;
	stats.apMax += 1;
	
	stats.sprite.mirror = false;
	
	return stats;
}

function stats_Ktch_Janissary() {
	var stats = combatStatsCreate(
		"Janissary",
		"Ketchup Sultanate",
		175,
		60,
		1,
		0,
		[combatActionSwordSlice(65),combatActionGunShot(55)],
		spriteSheetCreate(spr_ktch_janis_idle_r,1.0,spr_ktch_janis_idle_l,spr_ktch_janis_move_r,spr_ktch_janis_move_l,spr_ktch_janis_attack_r_0,spr_ktch_janis_attack_l_0,spr_ktch_janis_flinch_r,spr_ktch_janis_flinch_l,spr_ktch_janis_attack_r_1,spr_ktch_janis_attack_l_1),
		spr_portrait_ktch_janis
	)	
	
	//enables second attack anim for melee slice
	stats.actions[0].type = cAction.ABILITY;
	
	stats.sprite.mirror = false;
	
	return stats;
}

function stats_Ktch_Gunslinger() {
	var stats = combatStatsCreate(
		"Gunslinger",
		"Ketchup Sultanate",
		125,
		60,
		1,
		0,
		[combatActionGunShot(45)],
		spriteSheetCreate(spr_ktch_cowboy_idle_r,1,spr_ktch_cowboy_idle_l,spr_ktch_cowboy_move_r,spr_ktch_cowboy_move_l,,,spr_ktch_spider_flinch_r,spr_ktch_spider_flinch_l),
		spr_portrait_ktch_cowboy
	);
	
	stats.apMax += 2;
	
	stats.sprite.mirror = false;
	
	return stats;
}

function stats_Ktch_Mindbender() {
	var stats = combatStatsCreate(
		"Mindbender",
		"Ketchup Sultanate",
		125,
		200,
		1,
		0,
		[combatActionFoxLaser(),combatActionGlitterBomb(),combatActionShadowEmpower()],
		spriteSheetCreate(spr_ktch_mndbnd_idle_r,,spr_ktch_mndbnd_idle_l,spr_ktch_mndbnd_idle_r,spr_ktch_mndbnd_idle_l,spr_ktch_mndbnd_attack_r,spr_ktch_mndbnd_attack_l),
		spr_portrait_ktch_mndbnd
		
	)	
	
	stats.sprite.mirror = false;
	stats.sprite.sinHover = true;
	
	return stats;
}

#endregion

//MUSTARD TSARDOM//
#region Mustard Tsardom
function statsMustRecruit()
{
	var stats = combatStatsCreate(
		"Recruit",
		"Mustard Tsardom",
		100,
		20,
		1,
		0,
		[combatActionPitchforkPoke()],
		spriteSheetCreate(spr_must_recruit_idle_r,1,spr_must_recruit_idle_l,spr_must_recruit_move_r,spr_must_recruit_move_l,spr_must_recruit_attack_r,spr_must_recruit_attack_l,spr_must_recruit_flinch_r,spr_must_recruit_flinch_l),
		spr_portrait_must_recruit
	)
	
	stats.sprite.mirror = false;
	
	return stats;
	
}

function stats_Must_Sergeant()
{
	var stats = combatStatsCreate(
		"Sergeant",
		"Mustard Tsardom",
		150,
		60,
		1,
		0,
		[combatActionPitchforkPoke(55)],
		spriteSheetCreate(spr_must_sergeant_idle_r,1,spr_must_sergeant_idle_l,spr_must_sergeant_move_r,spr_must_sergeant_move_l,spr_must_sergeant_attack_r,spr_must_sergeant_attack_l,spr_must_sergeant_flinch_r,spr_must_sergeant_flinch_l),
		spr_portrait_must_sergeant
	)
	
	stats.sprite.mirror = false;
	
	return stats;
	
}

#endregion

//WASABI SHOGUNATE//
#region Wasabi Shogunate
//Samurai Stats
function statsWsbiSamurai()
{
	var stats = combatStatsCreate(
		"Samurai",
		"Wasabi Shogunate",
		150,
		50,
		1,
		0,
		[combatActionAttackKatana()],
		spriteSheetCreate(spr_wsbi_samurai_idle_r,1,spr_wsbi_samurai_idle_l,spr_wsbi_samurai_move_r,spr_wsbi_samurai_move_l,spr_wsbi_samurai_attack_r,spr_wsbi_samurai_attack_l,spr_wsbi_samurai_flinch_r,spr_wsbi_samurai_flinch_l),
		spr_portrait_wsbi_samurai
	);
	
	stats.sprite.mirror = false;
	
	return stats;
}
#endregion

//SHADOW WIZARDS//
#region Shadow Wizards
//tall stats
function statsWzrdTall()
{
	var stats = combatStatsCreate(
		"Adept",
		"Shadow Wizard",
		300,
		1000,
		20,
		100,
		[combatActionShadowShot(),combatActionShadowRestore(),combatActionShadowSiphon()],
		spriteSheetCreate(spr_wzrd_tall_idle_r_c,1.5),
		spr_portrait_wzrd_tall,
		onSpawnWzrdTall
	);
	
	stats.sprite.sinHover = 1;
	stats.sprite.shadowScale = 0.5;
	stats.sprite.attackR = spr_wzrd_tall_attack_r;
	stats.sprite.castR = spr_wzrd_tall_cast_r;
	
	return stats;
}
//tall on spawn
function onSpawnWzrdTall()
{
	sprSinHover = 1;
	sprShadowScale = 0.5;
	stats.sprite.attackR = spr_wzrd_tall_attack_r;
	stats.sprite.castR = spr_wzrd_tall_cast_r;
	//sprShadowAura = 1;
}
//small stats
function statsWzrdSmall()
{
	var stats = combatStatsCreate(
		"Acolyte",
		"Shadow Wizard",
		200,
		1000,
		15,
		70,
		[combatActionShadowShot()],
		spriteSheetCreate(spr_wzrd_small_idle_r),
		spr_portrait_wzrd_small,
		onSpawnWzrdSmall,
	);
	
	stats.sprite.shadowScale = 0.5;
	stats.sprite.attackR = spr_wzrd_small_attack_r;
	stats.sprite.flinchR = spr_wzrd_small_flinch_r;
	
	return stats;
}
//small on spawn
function onSpawnWzrdSmall()
{
	sprShadowScale = 0.5;
	stats.sprite.attackR = spr_wzrd_small_attack_r;
}

//blue stats
function statsWzrdBlue()
{
	var stats = combatStatsCreate(
		"Apostle",
		"Shadow Wizard",
		350,
		1000,
		25,
		100,
		[combatActionShadowPunch(),combatActionShadowEmpower()],
		spriteSheetCreate(spr_wzrd_blue_idle_r,1.25),
		spr_portrait_wzrd_blue,
		onSpawnWzrdBlue
	);
	
	stats.sprite.shadowScale = 1.25;
	stats.sprite.sinHover = 0;
	stats.sprite.attackR = spr_wzrd_blue_attack_r;
	stats.sprite.castR = spr_wzrd_blue_cast_r;
	
	
	return stats;
}
//tall on spawn
function onSpawnWzrdBlue()
{
	sprShadowScale = 1.25;
	sprSinHover = 0;
	stats.sprite.attackR = spr_wzrd_blue_attack_r;
	stats.sprite.castR = spr_wzrd_blue_cast_r;
}

//purp stats
function statsWzrdPurple()
{
	var stats = combatStatsCreate(
		"Mystic",
		"Shadow Wizard",
		300,
		1000,
		20,
		100,
		[combatActionShadowPulse(),combatActionShadowMend(),combatActionShadowLeech()],
		spriteSheetCreate(spr_wzrd_purple_idle_r,1.25),
		spr_portrait_wzrd_purple,
		onSpawnWzrdPurple
	);
	
	stats.sprite.sinHover = 1;
	stats.sprite.shadowScale = 0.5;
	stats.sprite.attackR = spr_wzrd_purple_attack_r;
	stats.sprite.castR = spr_wzrd_purple_cast_r;
	
	return stats;
}
//purp on spawn
function onSpawnWzrdPurple()
{
	sprSinHover = 1;
	sprShadowScale = 0.5;
	stats.sprite.attackR = spr_wzrd_purple_attack_r;
	stats.sprite.castR = spr_wzrd_purple_cast_r;
	//sprShadowAura = 1;
}

//crim stats
function statsWzrdCrimson()
{
	var stats = combatStatsCreate(
		"Priest",
		"High Shadow Wizard",
		500,
		1000,
		30,
		300,
		[combatActionShadowTendril()],
		spriteSheetCreate(spr_wzrd_priest_idle_r_old,1.75),
		spr_portrait_wzrd_crimson,
		onSpawnWzrdCrimson
	);
	
	stats.sprite.shCyanC = make_color_hsv(255*0.95,255,255*0.45);
	stats.sprite.shadowScale = 1;
	//stats.sprite.attackR = spr_wzrd_crimson_attack_r;
	stats.sprite.shadowAura = 1;
	
	return stats;
}
//crim on spawn
function onSpawnWzrdCrimson()
{
	sprShadowScale = 1;
	stats.sprite.attackR = spr_wzrd_crimson_attack_r;
	sprShadowAura = 1;
}

//bld stats
function statsWzrdBlade()
{
	var stats = combatStatsCreate(
		"Inquisitor",
		"High Shadow Wizard",
		400,
		1000,
		25,
		300,
		[combatActionShadowPulseSlice(),combatActionShadowEmpower(),combatActionShadowRestore(),combatActionShadowLeech()],
		spriteSheetCreate(spr_wzrd_blade_idle_r,1.25),
		spr_portrait_wzrd_blade,
		onSpawnWzrdBlade
	);
	
	stats.sprite.shCyanC = make_color_hsv(255*0.95,255,255*0.45);
	stats.sprite.sinHover = 1;
	stats.sprite.shadowScale = 0.66;
	stats.sprite.attackR = spr_wzrd_blade_attack_r;
	stats.sprite.castR = spr_wzrd_blade_cast_r;
	stats.sprite.shadowAura = 0;
	
	return stats;
}
//bld on spawn
function onSpawnWzrdBlade()
{
	sprSinHover = 1;
	sprShadowScale = 0.66;
	stats.sprite.attackR = spr_wzrd_blade_attack_r;
	stats.sprite.castR = spr_wzrd_blade_cast_r;
	sprShadowAura = 1;
	sprCyanReplacer = make_color_hsv(255*0.95,255,255*0.45);
}

//neb stats
function statsWzrdNeb()
{
	var stats = combatStatsCreate(
		"Nebula",
		"High Shadow Wizard",
		800,
		200,
		40,
		1200,
		[combatActionShadowPulseSlice(),combatActionShadowEmpower(),combatActionShadowRestore(),combatActionShadowLeech()],
		spriteSheetCreate(spr_wzrd_neb_idle_r,1.0),
		spr_portrait_wzrd_neb
	);
	
	stats.sprite.shCyanC = make_color_hsv(255*0.0,255*0.0,255*1.0);
	stats.sprite.sinHover = 0;
	stats.sprite.shadowScale = 1.0;
	//stats.sprite.attackR = spr_wzrd_blade_attack_r;
	//stats.sprite.castR = spr_wzrd_blade_cast_r;
	stats.sprite.shadowAura = 1;
	
	return stats;
}

//
function statsWzrdReap()
{
	var stats = combatStatsCreate(
		"Reaper",
		"High Shadow Wizard",
		800,
		200,
		40,
		1200,
		[combatActionShadowPulseSlice(),combatActionShadowEmpower(),combatActionShadowRestore(),combatActionShadowLeech()],
		spriteSheetCreate(spr_wzrd_reap_idle_r),
		spr_portrait_wzrd_reap
	);
	
	stats.sprite.flinchR = spr_wzrd_reap_flinch_r;
	stats.sprite.sinHover = 1;
	stats.sprite.shadowScale = 0;
	stats.sprite.shadowAura = 1;
	
	return stats;
}

#endregion

#endregion