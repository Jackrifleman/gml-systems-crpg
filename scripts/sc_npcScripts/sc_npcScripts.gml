function draw_npcStats()
{
	var xOff = 0;
	var yOff = -128;
	var pad = 10;
	
	
	draw_set_halign(fa_center);
	draw_set_font(fnt_standard_small);
	
	draw_set_color(c_black);
	
	draw_text(x+xOff+1,y+yOff+pad*1+1, "" + stats.name);
	draw_text(x+xOff+1,y+yOff+pad*2+1, string(stats.hp) + " hp");
	draw_text(x+xOff+1,y+yOff+pad*3+1, string(stats.mp) + " mp");
	
	draw_text(x+xOff,y+yOff+pad*1+1, "" + stats.name);
	draw_text(x+xOff,y+yOff+pad*2+1, string(stats.hp) + " hp");
	draw_text(x+xOff,y+yOff+pad*3+1, string(stats.mp) + " mp");
	
	draw_set_color(c_white);
	
	draw_text(x+xOff,y+yOff+pad*1, "" + stats.name);
	draw_text(x+xOff,y+yOff+pad*2, string(stats.hp) + " hp");
	draw_text(x+xOff,y+yOff+pad*3, string(stats.mp) + " mp");
	//draw_text(x+xOff,y+yOff+pad*12, "depth: " + string(depth));
	
	draw_set_color(c_white);
}

function npcDynamicDepth()
{
	depth = (y/room_height*-100) + sprDepth;
}