function exists(obj)
{
	return instance_exists(obj);
}

function loop(_min,_max,_val) {
	var n = _val;
	if (n > _max) {
		n = n - _max - 1;
	} else if (n < _min) {
		n = _max + (n + _min + 1);
	}
	
	return n;
}

function struct_merge(struct1, struct2)
{	
	var arr1 = variable_struct_get_names(struct1);
	var arr2 = variable_struct_get_names(struct2);
	
	for (var i = 0; i < array_length(arr2); i++) 
	{
		if (variable_struct_exists(struct1, arr2[i]))
		{
			if (is_struct(variable_struct_get(struct1, arr2[i])))
			{
				var s1 = variable_struct_get(struct1, arr2[i]);
				var s2 = variable_struct_get(struct2, arr2[i]);
				variable_struct_set(struct1,arr2[i],struct_merge(s1,s2));	
			} else {
				variable_struct_set(struct1,arr2[i],variable_struct_get(struct2, arr2[i]));
			}
		}
	}
	return struct1;
}

function image_scale(xy_scale)
{
	image_xscale = xy_scale;
	image_yscale = xy_scale;
}

function structCopySingle(struct){
    var key, value;
    var newCopy = {};
    var keys = variable_struct_get_names(struct);
    for (var i = array_length(keys)-1; i >= 0; --i) {
            key = keys[i];
            value = struct[$ key];
            //variable_struct_get(struct, key);
            variable_struct_set(newCopy, key, value)
    }
    return newCopy;
}

//converts a grid position used by navnodes to world coordinates
function navNode_get_truePos(navNode) {
	var pos = {
		x : navNode.x*32+16,
		y : navNode.y*32+16
	}
			
	return pos;	
}

function posToGrid(x,y) {
	return {
		x : floor(x/32),
		y : floor(y/32)
	}
}