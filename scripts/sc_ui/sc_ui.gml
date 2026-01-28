function banner(text,color = c_white)
{
	instance_destroy(ent_combat_banner);
	var b = instance_create_depth(0,0,0,ent_combat_banner);
	b.text = text;
	b.col = color;
}

function draw_ui_box(x,y,width,height,alpha = 1,bg_col = c_black, bg_opacity = 0.5,border = true,bd_thickness = 2,bd_col = c_white, bd_centered = false) {

	var vScale = 1.0;
	draw_set_alpha(alpha);

	image_alpha = bg_opacity;
	draw_set_color(bg_col);
	draw_sprite_ext(spr_ui_bg,1,x,y,width/32,height/32,0,bg_col,bg_opacity);

	if (border) {
	
		//TODO make thickness consistent without create rounded borders...
		var _borderWidth = bd_thickness;
	
		if (bd_centered) {
			//line 1 upper hor
			draw_line_width_color(x-2,y-1,x+width,y-1,_borderWidth,bd_col,bd_col);
			//line 2 lower hor
			draw_line_width_color(x-2,y+height-1,x+width-1,y+height-1,_borderWidth,bd_col,bd_col);
			//line 3 left ver
			draw_line_width_color(x-1,y-1,x-1,y+height-1,_borderWidth,bd_col,bd_col);
			//line 4 right ver
			draw_line_width_color(x+width-1,y,x+width-1,y+height,_borderWidth,bd_col,bd_col);
		} else {
			var horX1 = x - 1; //left
			var horX2 = x + width - 1; //right
			var horY1 = y - (1-vScale); //upper (vScale/vScale)
			var horY2 = y + height - 2 + (1-vScale); //lower -(1*vScale)
		
			var verX1 = x - (1-vScale); //left
			var verX2 = x+width-2 + (1-vScale); //right
			var verY1 = y-1;
			var verY2 = y+height-1;
		
			//line 1 upper hor
			draw_line_width_color(horX1,horY1,horX2,horY1,_borderWidth,bd_col,bd_col);
			//line 2 lower hor
			draw_line_width_color(horX1,horY2,horX2,horY2,_borderWidth,bd_col,bd_col);
			//line 3 left ver
			draw_line_width_color(verX1,verY1,verX1,verY2,_borderWidth,bd_col,bd_col);
			//line 4 right ver
			draw_line_width_color(verX2,verY1,verX2,verY2,_borderWidth,bd_col,bd_col);
		}
	
	
	}

	draw_set_alpha(1);
}

function ui_capsule_element_render(elem, x, y, contentPad, capsuleWidth, scale, ui_layer = false, draw_smart_bounds = false) {
    
    input_x = mouse_x;
    input_y = mouse_y;
    
    if (ui_layer) {
        input_x = device_mouse_x_to_gui(0);
        input_y = device_mouse_y_to_gui(0);
    }
    
    //for image-class element:
		if ((elem.class == tooltipClass.IMAGE) || (elem.class == tooltipClass.IMAGE_SMART)) {
            //if smart type content, check if mouse in region of x and y bounds of element
            if (elem.class == tooltipClass.IMAGE_SMART) {
                //check if mouse coords on in range
                
                if (draw_smart_bounds) {
                	draw_rectangle_color(x+contentPad*scale,y+contentPad+elem.height_prev,x+contentPad+(sprite_get_width(elem.image)*elem.scale)*scale,y+contentPad+(sprite_get_yoffset(elem.image)*elem.scale*scale*2)+elem.height_prev,elem.color,elem.color,elem.color,elem.color,1);
                }
                
                if (input_x > x+contentPad*scale) 
                && (input_x < x+contentPad+(sprite_get_width(elem.image)*elem.scale)*scale) {
                    if (input_y > y+contentPad+elem.height_prev) 
                    && (input_y < y+contentPad+(sprite_get_yoffset(elem.image)*elem.scale*scale*2)+elem.height_prev) {
                        
                        //if clicked, do elem.on_interact() else, elem.on_hover()
                        if (mouse_check_button_pressed(mb_left)) {
                            elem.on_interact();
                        } else {
                            elem.on_hover();
                        }
                        elem.is_hovered = true;
                    } else if (elem.is_hovered) {
                        elem.is_hovered = false;
                        elem.on_unhover();
                    }
                } else if (elem.is_hovered) {
                    elem.is_hovered = false;
                    elem.on_unhover();
                }
            }
            
			//include origin offsets in sprite display, to ensure it draws inside box
			var img_idx = elem.index;
			//if index -1, animate using reserved variable on calling inst
			if (img_idx == -1) {
				img_spd = sprite_get_speed(elem.image);
				img_num = sprite_get_number(elem.image);
				img_idx = ((global.frameTime/60)*(img_spd/60))*img_num*img_spd;
			}
			
            
            
            draw_sprite_ext(elem.bg2_image,elem.bg2_index,x+contentPad+(sprite_get_xoffset(elem.bg2_image)*elem.scale)*scale,y+contentPad+(sprite_get_yoffset(elem.bg2_image)*elem.scale*scale)+elem.height_prev,elem.scale*scale,elem.scale*scale,0,elem.bg2_color,1.0);
            draw_sprite_ext(elem.bg_image,elem.bg_index,x+contentPad+(sprite_get_xoffset(elem.bg_image)*elem.scale)*scale,y+contentPad+(sprite_get_yoffset(elem.bg_image)*elem.scale*scale)+elem.height_prev,elem.scale*scale,elem.scale*scale,0,elem.bg_color,1.0);
			draw_sprite_ext(elem.image,img_idx,x+contentPad+(sprite_get_xoffset(elem.image)*elem.scale)*scale,y+contentPad+(sprite_get_yoffset(elem.image)*elem.scale*scale)+elem.height_prev,elem.scale*scale,elem.scale*scale,0,elem.color,1.0);
            draw_sprite_ext(elem.fg_image,elem.fg_index,x+contentPad+(sprite_get_xoffset(elem.fg_image)*elem.scale)*scale,y+contentPad+(sprite_get_yoffset(elem.fg_image)*elem.scale*scale)+elem.height_prev,elem.scale*scale,elem.scale*scale,0,elem.fg_color,1.0);
            
			if (elem.subtext != "") {
                draw_set_halign(fa_left);
    			//includes text dropshadow
    			draw_set_font(fnt_standard_small);
    			draw_set_color(c_black);
    			draw_text_transformed(x+(sprite_get_xoffset(elem.image)*elem.scale*0.5)*scale+(2*scale)-2,y+contentPad+elem.height_prev+(2*scale)+2,elem.subtext,elem.scale*scale,elem.scale*scale,0);
    			draw_set_color(c_white);
    			draw_text_transformed(x+(sprite_get_xoffset(elem.image)*elem.scale*0.5)*scale-2,y+contentPad+elem.height_prev+2,elem.subtext,elem.scale*scale,elem.scale*scale,0);
    			draw_set_color(c_white);
            }
		}
		//for text-class element:
		else if (elem.class == tooltipClass.TEXT || elem.class == tooltipClass.TEXT_SMART) {
			var alignX = 0;
			if (elem.align == fa_center) {
				alignX = capsuleWidth/2 - contentPad;
			} else if (elem.align == fa_right) {
				alignX = capsuleWidth;
			}
            
            //if smart type content, check if mouse in region of x and y bounds of element
            if (elem.class == tooltipClass.TEXT_SMART) {
                //check if mouse coords on in range
                
                //box drawing the bounds of the clickable space
                if (draw_smart_bounds) {
                    draw_rectangle_color(x+contentPad*scale,y-contentPad+elem.height_prev+(16*scale),x+contentPad+string_width(elem.text)*scale,y+contentPad+elem.height_prev+(16*scale),elem.color,elem.color,elem.color,elem.color,1);
                }
                //this works!!!
                if (input_x > x+contentPad*scale) 
                && (input_x < x+contentPad+string_width(elem.text)*scale) {
                    if (input_y > y-contentPad+elem.height_prev+(16*scale)) 
                    && (input_y < y+contentPad+elem.height_prev+(16*scale)) {
                        //if clicked, do elem.on_interact() else, elem.on_hover()
                        if (mouse_check_button_pressed(mb_left)) {
                            elem.on_interact();
                        } else {
                            elem.on_hover();
                        }
                        elem.is_hovered = true;
                    } else if (elem.is_hovered){
                        elem.is_hovered = false;
                        elem.on_unhover();
                    }
                } else if (elem.is_hovered) {
                    elem.is_hovered = false;
                    elem.on_unhover();
                }
            }
            
            
			draw_set_halign(elem.align);
			//includes text dropshadow
			draw_set_font(elem.font);
			draw_set_color(c_black);
			draw_text_ext_transformed(x+alignX+contentPad+(2*scale),y+contentPad+elem.height_prev+(2*scale),elem.text,24,576,elem.scale*scale,elem.scale*scale,0);
			draw_set_color(elem.color);
			draw_text_ext_transformed(x+alignX+contentPad,y+contentPad+elem.height_prev,elem.text,24,576,elem.scale*scale,elem.scale*scale,0);
			draw_set_color(c_white);

		}
}

function ui_capsule_getSize(tooltip_content, scale = 1.0, elementPad = 8*scale) {
    //init capsulestuff
	var capsuleWidth = 0;
	var capsuleHeight = 0;
	
	for (var i = 0; i < array_length(tooltip_content); i++) {
		var elem = tooltip_content[i];
		//for a row, enter the row and perform the calculation for it,
        if (elem.class == tooltipClass.ROW) {
        	elem.height_prev = capsuleHeight;
            elem.width = elem.get_width()*scale;
            capsuleHeight += elem.get_height()*scale;
            capsuleWidth = max(elem.width,capsuleWidth);
        }
        //for image-class element:
		else if (elem.class == tooltipClass.IMAGE || elem.class == tooltipClass.IMAGE_SMART) {
			//add to the height
			elem.height_prev = capsuleHeight;
            elem.width = sprite_get_width(elem.image)*elem.scale*scale;
			capsuleHeight += sprite_get_height(elem.image)*elem.scale*scale;
			capsuleWidth = max(elem.width,capsuleWidth);
		}
		//for text-class element:
		else if (elem.class == tooltipClass.TEXT || elem.class == tooltipClass.TEXT_SMART) {
			draw_set_font(elem.font);
			elem.height_prev = capsuleHeight;
            elem.width = string_width_ext(elem.text,24,576)*elem.scale*scale;
			capsuleHeight += string_height_ext(elem.text,24,576)*elem.scale*scale;
			capsuleWidth = max(elem.width,capsuleWidth);		
		}
		if (i != array_length(tooltip_content)-1) {
			capsuleHeight += elementPad;
		}
	}
    
	return {
		w : capsuleWidth,
		h : capsuleHeight
	}
}



function draw_ui_capsule(tooltip_content = [tooltipImage(spr_action_heal,0,1.0),tooltipText("Tooltip Text")],x = 0,y = 0, scale = 1.0, bd_color = c_white,bd_alpha = 1.0,bg_color = c_black, bg_alpha = 0.4, ui_layer = false) {
	
	//init capsulestuff
	var capsuleWidth = 0;
	var capsuleHeight = 0;
	
	var frameTime = global.frameTime;
	
	//padding between elements
	var elementPad = 8*scale;
	//padding between edge of capsule and elems
	var contentPad = 8*scale;
	
	draw_set_halign(fa_left);
	
    var size = ui_capsule_getSize(tooltip_content,scale,elementPad);

	capsuleWidth = size.w+contentPad*2;
	capsuleHeight = size.h+contentPad*2;
	
	var divisor = scale > 0.5 ? 18 : 9;
	var img_bd = scale > 0.5 ? spr_ui_capsule_ns_18_border : spr_ui_capsule_ns_9_border;
	var img_bg = scale > 0.5 ? spr_ui_capsule_ns_18_bg : spr_ui_capsule_ns_9_bg;
	
	//capsule drawing
	//draw back
	draw_sprite_ext(img_bg,0,x,y,(capsuleWidth/divisor),(capsuleHeight/divisor),0,bg_color,bg_alpha);
	//draw border
	draw_sprite_ext(img_bd,0,x,y,(capsuleWidth/divisor),(capsuleHeight/divisor),0,bd_color,bd_alpha);


	//step 3.
	//draw each element, approriately spaced and stuff
	//use height_prev to correct space each element
	
	for (var i = 0; i < array_length(tooltip_content); i++) {
		var elem = tooltip_content[i];
        //row render
        if (elem.class == tooltipClass.ROW) {
            var row = tooltip_content[i];
            var rowPad = 0;
            for (var j = 0; j < array_length(row.content); j++) { 
                elem = row.content[j];
                elem.height_prev = row.height_prev;
                ui_capsule_element_render(elem, x + rowPad + j*row.padding*scale, y, contentPad, capsuleWidth, scale,ui_layer);
                rowPad += elem.width*scale;
            }
        } else {
            ui_capsule_element_render(elem, x, y, contentPad,capsuleWidth,scale,ui_layer);
        }
		
	}
}


///TOOLTIPS!!!

enum tooltipClass {
	TEXT,
	IMAGE,
    TEXT_SMART,
    IMAGE_SMART,
    ROW
}

function tooltipNew(_content = [], _width = 256, _height = 64) {
	var _tooltip = {
		content : _content,
		width : _width,
		height : _height,
		border : c_white
		
	};
	
	return _tooltip;
}

function tooltipRow(_content = [], _align = fa_left, _padding = 6, _scale = 1.0) {
    var _tooltipRow = {
		class : tooltipClass.ROW,
		content : _content,
		scale : _scale,
		align : _align,
        padding : _padding,
        get_width : function(){
            var total_width = 0;
            for (var i = 0; i < array_length(content); i++) {
                var elem = content[i];
            	if (elem.class == tooltipClass.TEXT || elem.class == tooltipClass.TEXT_SMART) {
                    elem.width = string_width(elem.text)*elem.scale*scale;
                } else if (elem.class == tooltipClass.IMAGE || elem.class == tooltipClass.IMAGE_SMART){
                    elem.width = sprite_get_width(elem.image)*elem.scale*scale;
                }
                
                total_width += elem.width;
            }
            var _pad = padding*array_length(content)-1*scale-4*scale;
            return total_width + _pad;
        },
        get_height : function(){
            var max_height = 0;
            for (var i = 0; i < array_length(content); i++) {
                var elem = content[i];
            	if (elem.class == tooltipClass.TEXT || elem.class == tooltipClass.TEXT_SMART) {
                    max_height = max(string_height(elem.text)*elem.scale *scale,max_height);
                } else if (elem.class == tooltipClass.IMAGE || elem.class == tooltipClass.IMAGE_SMART){
                    max_height = max(sprite_get_height(elem.image)*elem.scale *scale,max_height);
                }
            }
            return max_height;
        }
	}
	return _tooltipRow;
}

function tooltipText(_text, _color = c_white, _font = fnt_standard, _scale = 1.0, _align = fa_left) {
	var _tooltipText = {
		class : tooltipClass.TEXT,
		text : _text,
		color : _color,
		font : _font,
		scale : _scale,
		align : _align
	}
	return _tooltipText;
}

function tooltipText_Smart(_text, _color = c_white, _font = fnt_standard, _scale = 1.0, _align = fa_left) {
	var _tooltipText = {
		class : tooltipClass.TEXT_SMART,
		text : _text,
		color : _color,
		font : _font,
		scale : _scale,
		align : _align,
        selected : false,
        is_hovered : false,
        on_hover : function() {
            if (!is_hovered) {
                on_hover_stored_color = color;
                color = global.item_rarity_colors[item_rarity.common];
            }
        },
        on_unhover : function() {
            color = on_hover_stored_color;
        },
        on_interact : function(){
            instance_destroy(ent_ui_context);
        },
        
	}
	return _tooltipText;
}

function tooltipImage(_image = spr_placeholder, _index = 0, _scale = 2.0, _align = fa_left) {
	var _tooltipImage = {
		class : tooltipClass.IMAGE,
		image : _image,
        index : _index,
        color : c_white,
        bg_image : spr_none,
        bg_index : 0,
        bg_color : c_white,
        bg2_image : spr_none,
        bg2_index : 0,
        bg2_color : c_white,
        fg_image : spr_none,
        fg_index : 0,
        fg_color : c_white,
        subtext  : "",
		scale : _scale,
		align : _align
	}
	return _tooltipImage;
}

function tooltipImage_Smart(_image = spr_placeholder, _index = 0, _scale = 2.0, _align = fa_left) {
	var _tooltipImage = {
		class : tooltipClass.IMAGE_SMART,
		image : _image,
        index : _index,
        color : c_white,
        bg_image : spr_none,
        bg_index : 0,
        bg_color : c_white,
        bg2_image : spr_none,
        bg2_index : 0,
        bg2_color : c_white,
        fg_image : spr_none,
        fg_index : 0,
        fg_color : c_white,
        subtext  : "",
		scale : _scale,
		align : _align,
        selected : false,
        is_hovered : false,
        on_hover_stored_color : c_white,
        on_hover : function() {
            if (!is_hovered) {
                on_hover_stored_color = color;
                color = global.item_rarity_colors[item_rarity.common];
            }
        },
        on_unhover : function() {
            color = on_hover_stored_color;
            ent_global.tooltip.reset();
        },
        on_interact : function(){
            instance_destroy(ent_ui_context);
            ent_global.tooltip.reset();
        }
	}
	return _tooltipImage;
}

function ui_on_hover() {
    if (!is_hovered) {
        on_hover_stored_color = color;
        color = global.item_rarity_colors[item_rarity.common];
    }
}

function ui_on_unhover() {
    color = on_hover_stored_color;
}

#region UI Prefabs

function ui_prefab_ribbon_portrait(unit) {
    var ui_ribbon_portrait = tooltipNew();
    var ui_portrait = tooltipImage(spr_portrait_fore,,3);
    
    ui_portrait.bg_image = unit.stats.portrait;
    ui_portrait.bg_color = c_white;
    
    ui_portrait.bg2_image = spr_portrait_back;
    ui_portrait.bg2_color = make_colour_rgb(30,30,30);
    
    
    ui_ribbon_portrait.content = [
        ui_portrait,
        tooltipText($"Lvl. {unit.stats.lvl}"),
    ];
    
    ui_ribbon_portrait.height = 256;
    return ui_ribbon_portrait;
}

function ui_prefab_ribbon_self_status(unit) {
    var ui_ribbon_self_status = tooltipNew([
        tooltipText($"{unit.stats.name}"), //padding need to fix row width
        tooltipText($"HP {unit.stats.hp}/{unit.stats.hpMax} | MP {unit.stats.mp}/{unit.stats.mpMax}"),
        tooltipText($"AP {unit.stats.ap}/{unit.stats.apMax}"),
        tooltipText($"DGE {unit.stats.dodge} | MOV {unit.stats.movement}"),
        tooltipText($"CRIT {unit.stats.crit*100} | SPD {unit.stats.spd}")
    ]);
    
    ui_ribbon_self_status.height = 256;
    return ui_ribbon_self_status;
}

function ui_prefab_action(parent,_action){
    var ui_action = tooltipImage_Smart(_action.icon,,1.0);
    ui_action.action = _action;
    ui_action.bg2_image = spr_w_64;
    ui_action.bg2_color = make_colour_rgb(30,30,40);
    ui_action.action_tooltip = actionFetchTooltip(_action);
    ui_action.selected = false;
    ui_action.parent = parent;
    
    
    var action_hover = function() {
        method(self,ui_on_hover)();
        ent_global.tooltip.feed(action_tooltip);
    }
    var action_unhover = function(){
        method(self,ui_on_unhover)();
        ent_global.tooltip.reset();
    }
    
    var action_interact = function() {
        if (!selected) {
            selected = true;
            bg2_color = merge_colour(c_teamBlue,c_black,0.5);
            
    		with(global.combatSelected) {
    			selectedAction = other.action;
    		}
            
    	} else {
    		selected = false;
            bg2_color = make_colour_rgb(30,30,40);
            with(global.combatSelected) {
    			selectedAction = undefined;
    		}
    	}
    }
    
    ui_action.on_hover = method(ui_action,action_hover);
    ui_action.on_unhover = method(ui_action,action_unhover);
    ui_action.on_interact = method(ui_action,action_interact);
    
    return ui_action;
}

function ui_prefab_ribbon_action_bar(unit) {
   
    var icon_scale = 1.0;
    var rows = 2;
    var columns = 8;
    
    var ui_ribbon_action_bar = tooltipNew();
    var n_action = 0;
    
    for (var i = 0; i < rows; i++) {
        ui_ribbon_action_bar.content[i] = tooltipRow();
        var row = ui_ribbon_action_bar.content[i];
        for (var j = 0; j < columns; j++) {
            if (n_action < array_length(unit.stats.actions)) {
               
                row.content[j] = ui_prefab_action(ui_ribbon_action_bar,unit.stats.actions[n_action]);
                n_action++;
            }
            
        }
        
    }
    
    return ui_ribbon_action_bar;
}

function ui_prefab_ribbon_side_bar(verbose = false) {
    
    
    var mini_stats_prefab = function(stats, verbose) {
        var mini_stats = tooltipRow([
            tooltipImage_Smart(stats.portrait),])
        
        if (verbose) {
            mini_stats.content[1] = tooltipText_Smart($"{stats.name}\nHP {stats.hp}/{stats.hpMax}\nMP {stats.mp}/{stats.mpMax}");
        }
    
        mini_stats.content[0].fg_image = spr_portrait_fore;
        mini_stats.content[0].bg_image = spr_portrait_back;
        mini_stats.content[0].bg_color = merge_colour(c_black,c_teamBlue,0.5);
        
        return mini_stats;
    }
    
    if (!exists(obj_player)) {
        return tooltipNew([mini_stats_prefab(combatStatsCreate(),0)]);
    }
    
    var ui_ribbon_side_bar = tooltipNew([mini_stats_prefab(obj_player.stats, verbose)]);
    
    for (var i = 0; i < array_length(obj_player.combatParty); i++) {
        var party_member = obj_player.combatParty[i]();
    	array_push(ui_ribbon_side_bar.content,mini_stats_prefab(party_member, verbose));
    }
    
    return ui_ribbon_side_bar;
}

function ui_prefab_ribbon_world_info(){
    var ui_ribbon_world_info = tooltipNew([
        tooltipText($"Homeshard"), //temp dirty padding while width calc is screwed up
        tooltipText($"Western Wilderness"),
        tooltipText($"12:00 PM"),
        tooltipRow([tooltipImage(((ent_jukebox.current_track.meta.name != "..." && !global.MusicDisabled) ? spr_ui_icon_notes : spr_ui_icon_notes_sleep),-1),tooltipText($"{ent_jukebox.current_track.meta.author} - {ent_jukebox.current_track.meta.name}")]),
        
    ])
    
    ui_ribbon_world_info.height = 256;
    return ui_ribbon_world_info;
}


#region item prefabs
//inventory access test
function ui_prefab_inventory(container, rows = 3, columns = 9) {
    
    var ui_inventory = tooltipNew(
        [tooltipText($"Inventory: {container.name}")
        ],
    )
    

    
    var n_item = 0;
    
    //three rows of inventory space
    for (var i = 0; i < rows; i++) {
        ui_inventory.content[i+1] = tooltipRow();
        var row = ui_inventory.content[i+1];
        for (var j = 0; j < columns; j++) {
            if (n_item < array_length(container.inventory)) {
                row.content[j] = ui_prefab_item(container.inventory[n_item]);
                n_item++;
            }
            
        }
        
    }
    return ui_inventory;
}


function ui_prefab_context_item(_item) {
    var tooltip = tooltipNew(
    [
        tooltipImage(_item.icon),
        tooltipText(_item.name,global.item_rarity_colors[_item.rarity]),
        tooltipText_Smart("Take"),
        tooltipText_Smart("Drop"),
        tooltipText_Smart("Inspect")
    ]);
    tooltip.border = global.item_rarity_colors[_item.rarity];
    return tooltip;
}

function ui_prefab_tooltip_item(_item) {
    var ui_tooltip_item = tooltipNew([
    	tooltipImage(_item.icon,-1),
    	tooltipText(_item.name),
    	tooltipText(global.item_rarity_strings[_item.rarity],global.item_rarity_colors[_item.rarity]),
    	tooltipText($"\"{_item.desc}\""),
    	tooltipText($"Value:  $ {_item.value*_item.count}"),
    	//tooltipText($"Weight:   {_item.weight*_item.count} kg")
    ]);
    ui_tooltip_item.border = global.item_rarity_colors[_item.rarity];
    
    return ui_tooltip_item;
}

function ui_prefab_item(_item){
    var ui_item = tooltipImage_Smart(spr_portrait_fore,,2.0);
    ui_item.item_ref = _item;
    ui_item.item_tooltip = ui_prefab_tooltip_item(_item).content;
    ui_item.color = global.item_rarity_colors[_item.rarity];
    
    ui_item.bg_image = _item.icon;
    ui_item.bg2_image = spr_portrait_back;
    ui_item.bg2_color = merge_colour(c_black,ui_item.color,0.5);
    
    ui_item.subtext = string(_item.count);
    
    var item_hover = function() {
        ent_global.tooltip.feed(item_tooltip,global.item_rarity_colors[item_ref.rarity]);
        ent_cursor.contextTooltip = ui_prefab_context_item(item_ref);
    }
    
    var item_unhover = function() {
        ent_global.tooltip.reset();
        ent_global.cursor.reset_tooltip();
    }
    
    ui_item.on_hover = method(ui_item,item_hover);
    ui_item.on_unhover = method(ui_item,item_unhover);
    
    return ui_item;
} 

#endregion

#endregion
