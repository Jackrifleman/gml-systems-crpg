function load_get_preset_amount() {
	return 22;
}

function load_to_room(room = rm_cave, dur_frames = -1, preset = -1) {
    global.loadRoom = room;
    global.loadPreset = preset;
    room_goto(rm_loading_tes);
}

function load_preset_0() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_mayo_skater_idle_r;
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "Skaters are more volatile than they appear.";
	}
}

function load_preset_1() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 2;
			sprite_index = spr_placeholder;
			image_scale(3);
		}
	}
	with (fx_text_load) {
		text = "1";
	}
}

function load_preset_2() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_coyoteshark;
			image_xscale = -4;
		}
	}
	with (fx_text_load) {
		text = "Coyote Sharks are fundamental entities. They are invulnerable and unknowingly destroy everything in their path.";
	}
}

function load_preset_3() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			image_scale(4);
			sprite_index = choose(spr_ktch_janis_idle_r,spr_ktch_cowboy_idle_r,spr_ktch_mndbnd_idle_r,spr_ktch_spider_idle_r);
		}
	}
	with (fx_text_load) {
		text = "Ketchup Soldiers are far more deadly and durable than their Mayo Adversaries.";
	}
}

function load_preset_4() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 1;
			image_scale(4);
			sprite_index = spr_mayo_knight_attack_r;
		}
	}
	with (fx_text_load) {
		text = "Mayo Soldiers deal mayo damage, decreasing your Maximum Health.";
	}
}

//occasional spookler
function load_preset_5() {
	with (fx_object_load) {
		if (!ignorePresets) {
			sprite_index = spr_loading_spooker;
			image_scale(4);
            image_index = irandom(image_number);
		}
	}
	with (fx_text_load) {
		text = "";
	}
}

function load_preset_6() {
	with (fx_object_load) {
		if (!ignorePresets) {
			sprite_index = spr_door;
			y = 300;
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "Wormhole Doors act as a means of fast travel through the many Shards of the Fracture.";
	}
}

function load_preset_7() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_catfish;
			image_scale(1);
		}
	}
	with (fx_text_load) {
		text = "Governing Council Enforcers ensure that the Shards they manage remain balanced and harmonic, through whatever means they see fit.";
	}
}

function load_preset_8() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 2;
			sprite_index = choose(spr_must_recruit_attack_r,spr_must_sergeant_attack_r);
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "The Mustard Tsardom is a mercenary nation and are not allied with any other condiments.";
	}
}

function load_preset_9() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_catfish;
			image_scale(1);
		}
	}
	with (fx_text_load) {
		text = "The Barbeled Benefactors are allied with no condiments. Most nations despise their Overlords.";
	}
}

function load_preset_10() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_mayo_king_r;
			image_scale(5);
			y = 120;
		}
	}
	with (fx_text_load) {
		text = "The Mayo Kingdom is ruled by the Mayo King.";
	}
}

function load_preset_11() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_coyoteshark;
			image_yscale = 4;
			image_xscale = -4;
		}
	}
	with (fx_text_load) {
		text = "There are no records of Overlords being able to manipulate Coyote Sharks.";
	}
}

function load_preset_12() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			image_scale(4);
			sprite_index = choose(spr_mayo_cheer_idle_r, spr_mayo_peasant_idle_r);
		}
	}
	with (fx_text_load) {
		text = "Mayo Men are not bred to fight. They are not bred at all. They simply are.";
	}
}

function load_preset_13() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			image_scale(4);
			sprite_index = spr_mayo_cheer_idle_r;
		}
	}
	with (fx_text_load) {
		text = "Cheerleaders have a medicinal taste in music.";
	}
}

function load_preset_14() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_mayo_skater_idle_r;
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "No one knows where the skaters keep coming from, but they certainly don't enjoy their jazzercize class.";
	}
}

function load_preset_15() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_placeholder;
		}
	}
	with (fx_text_load) {
		text = "15";
	}
}

function load_preset_16() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = choose(spr_wzrd_small_idle_r,spr_wzrd_tall_idle_r);
			image_scale(5);
		}
	}
	with (fx_text_load) {
		text = "Shadow Wizards love casting spellz.";
	}
}

function load_preset_17() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_catfish;
			image_scale(1);
		}
	}
	with (fx_text_load) {
		text = "Overlords love blowing bubbles on sunny afternoons.";
	}
}

function load_preset_18() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_catfish;
			image_scale(1);
		}
	}
	with (fx_text_load) {
		text = "Once an Overlord is defeated, they aren't injured or hurt in any way. They simply get tired of your shenanigans and leave.";
	}
}

function load_preset_19() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_wsbi_samurai_attack_r;
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "The Wasabi Shogunate is a skilled and elegant warrior nation.";
	}
}

function load_preset_20() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_must_recruit_idle_r;
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "Some might say toddlers learn twice as fast...";
	}
}

function load_preset_21() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_mayo_knight_flinch_r;
			image_scale(4);
		}
	}
	with (fx_text_load) {
		text = "There are rumors that Mayo High is overrun by high-powered gigarats that run throughout the halls, eating students and teachers alike.";
	}
}

function load_preset_22() {
	with (fx_object_load) {
		if (!ignorePresets) {
			image_index = 0;
			sprite_index = spr_wsbi_samurai_idle_r;
			image_scale(4);
		}	
	}
	with (fx_text_load) {
		text = "Those who do not accept the edicts of The Wasabi Shogunate are condemned to a spicy grave.";	
	}
}