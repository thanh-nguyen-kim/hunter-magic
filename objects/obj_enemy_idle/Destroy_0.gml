unsubscribe();
tmp_score=10;
if(global.combo>1) tmp_score+=global.combo;
global._score += tmp_score;
//todo: spawn a score object here
// 1. Create the popup at my position
var _inst = instance_create_layer(x, y - 50, "Instances", obj_floating_text);

// 2. Customize it immediately
_inst.text_to_show = "+"+string(tmp_score);
_inst.color = c_red;

// (Optional) Add a slight random offset so they don't stack perfectly
_inst.x += irandom_range(-10, 10);
instance_create_layer(x, y-150, "Instances", obj_enemy_die);
