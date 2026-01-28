// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function d_destroy(){
	instance_destroy();
}

function d_combatStart(){
	
	var playerParty = obj_player.combatParty;
	array_insert(playerParty, 0, obj_player.stats);
	ent_global.combatants[0] = playerParty;
	
	var party = speaker.combatParty;
	array_push(party,speaker.stats);
	party = array_shuffle(party);
	ent_global.combatants[1] = party;
	global.loadRoom = rm_battle;
	room_goto(rm_loading_tes);
	
}

function d_debugAddToParty(){
	ent_global.combatants[global.party][global.partyMember] = combatStatsCopy(speaker.combatStats);	
}