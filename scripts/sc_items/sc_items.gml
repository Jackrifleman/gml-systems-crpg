//type of item, used by constructor
enum item_type {
	generic,
	npc,
	gold
}

//tags, could include special properties/keywords
enum item_tag {
	gold,
	npc
}

/*
enum definitions of every unique item
naming conventions:
gold
npc
weaponSword
potion


*/
enum item {
	generic,
	npc,
	gold,	
}

enum item_rarity {
	common,
	uncommon,
	rare,
	very_rare,
	legendary
}

global.item_rarity_colors = [
	make_color_rgb(180, 224, 240),
	make_color_rgb(142, 237, 144),
	make_color_rgb(40, 207, 252),
	make_color_rgb(197, 75, 250),
	make_color_rgb(255, 208, 99)
]

global.item_rarity_strings = [
	"Common",
	"Uncommon",
	"Rare",
	"Very Rare",
	"Legendary"
]
//default item setup, defines the class, ALWAYS NAME variable mItem to access class for npcs/items/containers
// mVar == new name for reserved MODULE variables
// try to make as expandable as possible if new values are required
function item_new(_item_type = 0) {
	
	var _item = {
		type : _item_type,
		def : item.generic,
		ref : item_new,
		name : $"Item #{irandom(9999)}",	
		desc : "Oo, shiny!!",
		icon : spr_shine,
		inventory : [],
		value : 0,
		weight : 0,
		count : 1,
		rarity : item_rarity.common,
		tag : [],
		flag : item_flags(),
		//items methods
		inv_add : function(_item, n = 1) {
			//exit if null,
			if (array_length(inventory) < 1) {
				return;	
			} else {
				var _inv = [];
				
				if (n > 1) {
					if (_item.flag.stackable) {
						_item.count *= n;
						_inv = [_item];
					}
				}
				inventory = array_concat(inventory, _inv);
				show_debug_message(inventory);
			}
		},
		inv_del : function(_item_def, n = 1) {
			//exit if null,
			if (array_length(inventory) < 1) {
				return;	
			} else {
				
				for (var i = 0; i < array_length(inventory); i++) {
					if (inventory[i].def == _item_def) {
						if (inventory[i].flag.stackable) {
							inventory[i].count -= n;
							if (inventory[i].count < 1) {
								array_delete(inventory,i,1);
							}
						} else {
							array_delete(inventory,i,1);
						}
						break;
					}
				}
				
				inventory = array_concat(inventory, _inv);
				show_debug_message(inventory);
			}
		},
		inv_stack : function() {
			//stacks 2 identical items assuming they're both stackable,
			//combining their counts and removing the extra from the inventory
			for (var i = 0; i < array_length(inventory); i++) {
				if (inventory[i].flag.stackable) {
					for (var j = 0; j < array_length(inventory); j++) {
						if (inventory[j].flag.stackable && j != i && inventory[j].def == inventory[i].def) {
							inventory[i].count += inventory[j].count;
							array_delete(inventory,j,1);
							j = 0;
						}
					}
				}
			}
		}
	}
	
	return _item;
}

//

//default flags, for a generic item
function item_flags() {
	var _flags = {
		stackable : true, //can stack with self
		equipable : false, //can be equipped
		lootable : true //can be picked up
	}
	
	return _flags;
}

//real item constructors
function item_gold(quantity = 1) {
	var i = item_new(item_type.gold);
	i.def = item.gold;
	i.ref = item_gold;
	i.name = "Gold";
	i.desc = "All that glitters...";
	i.icon = spr_spider_gold_idle_r;
	i.tag = [item_tag.gold];
	i.value = 1;
	i.weight = 0.01;
	
	i.count = quantity;
	
	return i;
}

function init_items() {
	global.item_definitions = [
		item_new(item_type.generic),
		item_gold()
	]

	//sort the array to be numerically ordered
	array_sort(global.item_definitions, function(elm1, elm2){
		return elm1.def - elm2.def;
	});
	show_debug_message(global.item_definitions);
}
