//enums
enum music
{
	COMBAT_GENERIC,
    AMBIENT,
    COMBAT,
    DAY,
    NIGHT,
    RAINY,
    SUNSET,
    SUNRISE,
    BEACH,
	AMBIENCE_VOID,
    TENSE,
}

enum sfx
{
	ATTACK_GENERIC,
	CRIT,
	EXPLOSION,
	SLICE,
	GUN_SHOT,
	BOW_SHOT,
	SPIDER_BITE,
	DMG_MAJOR,
	DMG_MINOR,
	IMPALE,
	IMPALE_DARK,
	DARK_IMPULSE,
	SHINE,
	LASER_HEAVY,
	WZRD_BLADE_SLICE,
}

//get music

function music_get_sound_generic_combat(){
    var m = "music_combat_0_" + string(irandom(15)); 
    return asset_get_index(m);
}






function init_music_tracklist(){
    global.TrackList = 
    [
        //void track
        new Track(music_ambience_void,[music.AMBIENCE_VOID]),
        
        //old combat, use in times of extreme war
        new Track(music_combat_0_0,[music.COMBAT_GENERIC],"VS Salamander","Makai Symphony"),
        new Track(music_combat_0_1,[music.COMBAT_GENERIC],"VS Nemesis","Makai Symphony"),
        new Track(music_combat_0_2,[music.COMBAT_GENERIC],"Colossal Enemy","Makai Symphony"),
        new Track(music_combat_0_3,[music.COMBAT_GENERIC],"Samurai Fighter","Makai Symphony"),
        new Track(music_combat_0_4,[music.COMBAT_GENERIC],"Evil Warriors","Makai Symphony"),
        new Track(music_combat_0_5,[music.COMBAT_GENERIC],"All Out Attack","Makai Symphony"),
        new Track(music_combat_0_6,[music.COMBAT_GENERIC],"Battle World","Makai Symphony"),
        new Track(music_combat_0_7,[music.COMBAT_GENERIC],"VS Death","Makai Symphony"),
        new Track(music_combat_0_8,[music.COMBAT_GENERIC],"VS Demon","Makai Symphony"),
        new Track(music_combat_0_9,[music.COMBAT_GENERIC],"Last Gladiator","Makai Symphony"),
        new Track(music_combat_0_10,[music.COMBAT_GENERIC],"God Of Blaze","Makai Symphony"),
        new Track(music_combat_0_11,[music.COMBAT_GENERIC],"Grendel","Makai Symphony"),
        new Track(music_combat_0_12,[music.COMBAT_GENERIC],"War Begins","Makai Symphony"),
        new Track(music_combat_0_13,[music.COMBAT_GENERIC],"Executioner","Makai Symphony"),
        new Track(music_combat_0_14,[music.COMBAT_GENERIC],"Endless Storm","Makai Symphony"),
        new Track(music_combat_0_15,[music.COMBAT_GENERIC],"Military Attack","Makai Symphony"),
        
        //ambient day
        new Track(music_ambient_0_0,[music.AMBIENT,music.DAY],"Alliance of Elegance","Tupperwave"),
        new Track(music_ambient_0_1,[music.AMBIENT,music.DAY],"Business Class","Tupperwave"),
        new Track(music_ambient_0_2,[music.AMBIENT,music.DAY],"Vacaction Mode","Tupperwave"),
        new Track(music_ambient_0_3,[music.AMBIENT,music.DAY],"Sunset Highway","FM Skyline"),
        new Track(music_ambient_0_4,[music.AMBIENT,music.DAY],"Daphne","Luxury Elite"),
        new Track(music_ambient_0_5,[music.AMBIENT,music.DAY],"Chasing the Sun","Windows 96"),
        new Track(music_ambient_0_6,[music.AMBIENT,music.DAY],"Business Nights","VCR-Classique"),
        new Track(music_ambient_0_7,[music.AMBIENT,music.DAY],"Hit the Spot","Surfing"),
        new Track(music_ambient_0_8,[music.AMBIENT,music.DAY],"Tell Me How It Feels","bbrainz"),
        new Track(music_ambient_0_9,[music.AMBIENT,music.DAY],"Virtual","bbrainz"),
        new Track(music_ambient_0_10,[music.AMBIENT,music.DAY],"Electrolyte Elixir","SPORTSGIRL"),
        new Track(music_ambient_0_11,[music.AMBIENT,music.DAY],"Consumer (kahvi)","Neko Shi Corp."),
        
        //ambient night
        new Track(music_ambient_1_0,[music.AMBIENT,music.NIGHT],"Remember This Night","Cosmic Cycler"),
        new Track(music_ambient_1_1,[music.AMBIENT,music.NIGHT],"Night Breeze","Cosmic Cycler"),
        new Track(music_ambient_1_2,[music.AMBIENT,music.NIGHT],"Somber Waves","Whitewoods"),
        new Track(music_ambient_1_3,[music.AMBIENT,music.NIGHT],"Night Patrol","FM Skyline"),
        new Track(music_ambient_1_4,[music.AMBIENT,music.NIGHT],"Kordak C-11","Cvltvre"),
        new Track(music_ambient_1_5,[music.AMBIENT,music.NIGHT],"Sonic in the Holobeach","FM Skyline"),
        new Track(music_ambient_1_6,[music.AMBIENT,music.NIGHT],"Desktop","Incorporeal Visions Deluxe"),
        new Track(music_ambient_1_7,[music.AMBIENT,music.NIGHT],"Senses","1ony"),
        new Track(music_ambient_1_8,[music.AMBIENT,music.NIGHT],"You Have a Way","COMPLEX MATHEMATICS"),
        new Track(music_ambient_1_9,[music.AMBIENT,music.NIGHT],"Daysleeper","Dirty Art Club"),
        new Track(music_ambient_1_10,[music.AMBIENT,music.NIGHT],"Soul-Vibration","L a z u l i _ y e l l o w "),
        
        //ambient combat (combat in a chill place)
        new Track(music_ambient_2_0,[music.AMBIENT,music.COMBAT],"Planes, Trains, and Ally McBeals","Oracle FM"),
        new Track(music_ambient_2_1,[music.AMBIENT,music.COMBAT],"Ridgewalk","Moses Yoofee Trio"),
        new Track(music_ambient_2_2,[music.AMBIENT,music.COMBAT],"Orbital","bbrainz"),
        new Track(music_ambient_2_3,[music.AMBIENT,music.COMBAT],"Express","Luxury Elite"),
        new Track(music_ambient_2_4,[music.AMBIENT,music.COMBAT],"Super Gran Turismo","Dreams West"),
        new Track(music_ambient_2_5,[music.AMBIENT,music.COMBAT],"Tennis","SPORTSGIRL"),
        
        //tense area ambient
        new Track(music_ambience_void,[music.TENSE,music.AMBIENT]),
        //tense combat (combat in a dire place)
        new Track(music_combat_1_0,[music.TENSE,music.COMBAT],"Industrial","Makai Symphony"),
        new Track(music_combat_1_1,[music.TENSE,music.COMBAT],"Industrial","Makai Symphony"),
        new Track(music_combat_1_2,[music.TENSE,music.COMBAT],"Industrial","Makai Symphony"),
        new Track(music_combat_1_3,[music.TENSE,music.COMBAT],"Industrial","Makai Symphony"),
        new Track(music_combat_1_4,[music.TENSE,music.COMBAT],"Industrial","Makai Symphony"),
        new Track(music_combat_1_5,[music.TENSE,music.COMBAT],"Synthetic","Makai Symphony"),
        new Track(music_combat_1_6,[music.TENSE,music.COMBAT],"Synthetic","Makai Symphony"),
        new Track(music_combat_1_7,[music.TENSE,music.COMBAT],"Epic Cinematic Drums","Lokh Matov")
        
        
        
        
    ]
}

function Track(sound_ref = music_ambience_void, meta_tags = [], track_name = "...", track_author = "Fracture") constructor {
    meta = {
        name : track_name,
        author : track_author,
        tags : meta_tags,
    }
    ref = sound_ref;
    
}

function music_get_tracklist_by_tags(meta_tags = []) {
    var newTrackList = [];
    for (var i = 0; i < array_length(global.TrackList); i++) {
    	if (array_contains_ext(global.TrackList[i].meta.tags, meta_tags, true)) { 
            array_push(newTrackList,global.TrackList[i]);
        }
    }
    return newTrackList;
}

//get sfx
function sfxGetSound(sfx_enum)
{
	var sArr = [];
	switch(sfx_enum)
	{
		case sfx.ATTACK_GENERIC:
			sArr = [snd_dmg_major_0]; break;
		case sfx.DMG_MAJOR:
			sArr = [snd_dmg_major_0,snd_dmg_major_1]; break;
		case sfx.DMG_MINOR:
			sArr = [snd_dmg_minor_0,snd_dmg_minor_1]; break;
		case sfx.SLICE:
			sArr = [snd_slice_0,snd_slice_1,snd_slice_2,snd_slice_3]; break;
		case sfx.CRIT:
			sArr = [snd_crit_0,snd_crit_1]; break;
		case sfx.EXPLOSION:
			sArr = [snd_explosion]; break;
		case sfx.GUN_SHOT:
			sArr = [snd_gun]; break;
		case sfx.BOW_SHOT:
			sArr = [snd_bow_shot]; break;
		case sfx.SPIDER_BITE:
			sArr = [snd_dmg_minor_0,snd_dmg_minor_1]; break;
		case sfx.IMPALE:
			sArr = [snd_impale]; break;
		case sfx.IMPALE_DARK:
			sArr = [snd_impale_dark]; break;
		case sfx.DARK_IMPULSE:
			sArr = [snd_dark_energy]; break;
		case sfx.LASER_HEAVY:
			sArr = [snd_laser_heavy]; break;
		case sfx.SHINE:
			sArr = [snd_shine]; break;
		case sfx.WZRD_BLADE_SLICE:
			sArr = [snd_energy_slice]; break;
		default:
			sArr = [snd_dialogue_placeholder]; break;
	}
	
	var n = irandom(array_length(sArr)-1);
	return sArr[n];
}