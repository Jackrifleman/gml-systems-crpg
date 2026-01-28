function dialogueCreate() 
{
	var dialogue = 
	{
		img			: spr_portrait_unknown,
		img_index	: 0,
		offsetX		: 0,
		offsetY		: 0,
		scaleX		: 1,
		scaleY		: 1,
		text		: "This is placeholder dialogue.",
		sound		: snd_dialogue_placeholder,
		pitchMin	: 0.9,
		pitchMax	: 1.1,
	};
	return dialogue;
}

function dialogueCreateCustom(txt = "This is placeholder dialogue.", img = sprite_index, img_idx = 0, snd = snd_dialogue_placeholder, pitch_min = 0.9, pitch_max = 1.1, off_x = 0,off_y = 0,sca_x = 1,sca_y = 1,)
{
	var dialogue = 
	{
		img			: img,
		img_index	: img_idx,
		offsetX		: off_x,
		offsetY		: off_y,
		scaleX		: sca_x,
		scaleY		: sca_y,
		text		: txt,
		sound		: snd,
		pitchMin	: pitch_min,
		pitchMax	: pitch_max,
	};
	return dialogue;
}

function dialogueSpawn(dialogue_array, autoscroll = 0, end_script = d_destroy, speaker = undefined)
{
	var d = instance_create_depth(0,0,0,ent_dialogue);
	d.dArray = dialogue_array;
	d.endScript = end_script;
	d.autoscroll = autoscroll;
	d.dSize = array_length(dialogue_array)-1;
	d.speaker = speaker;
	return d;
}