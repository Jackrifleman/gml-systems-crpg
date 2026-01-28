function roomCreateBorders(){
	for (var i = -16; i < room_width; i += 32)
	{
		instance_create_layer(i,-16,"Collision",obj_wall);	
		instance_create_layer(i,room_height+16,"Collision",obj_wall);
	}

	for (var i = -16; i < room_height; i += 32)
	{
		instance_create_layer(-16,i,"Collision",obj_wall);	
		instance_create_layer(room_width+16,i,"Collision",obj_wall);
	}
}