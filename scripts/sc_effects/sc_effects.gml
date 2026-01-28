// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function explosion(){
	var e = instance_create_depth(x,y,depth-1,obj_explosion);
	return e;
}

function screenshake(x_strength,y_strength,duration){
	//var ss = instance_create_depth(x,y,0,ent_screenshake);
	//ss.xStrength = x_strength;
	//ss.yStrength = y_strength;
	//ss.alarm[0] = duration;
	
	with (ent_camera) {
		shakeX = x_strength;
		shakeY = y_strength;
		shakeDur = duration;
		shakeTimer = duration;
	}
}

function draw_depth(_depth, _step = 1, _func = function(){}) {
	var d = instance_create_depth(x,y,_depth,ent_draw_helper);
	d.parent = self;
	d.drawStep = _step;
	d.drawFunc = _func;
	
	return d;
}

function draw_layer(_layer, _step = 1, _func = function(){}) {
	try {
		var d = instance_create_layer(x,y,_layer,ent_draw_helper);
		d.parent = self;
		d.drawStep = _step;
		d.drawFunc = _func;
		return d;
	} catch (_excp) {
		
	}
}