// Event: Create

// 1. Movement Variables
hsp = 0;
vsp = 0;
walk_speed = 4;

// 2. State Control
global.state = "intro"; // Start in the 'intro' state
target_y = y - 100; // The spot where we want to stop (200px UP)

receiver = new Receiver();
receiver.add("gesture_detected",function(gesture){
	//do the gesture logic here
	if(gesture=="-"){
		audio_play_sound(sfx_horizontal, 10, false);
		instance_create_layer(x, y-150, "Instances", obj_gesture_horizontal);
	}
	if(gesture=="|"){
		audio_play_sound(sfx_vertical, 10, false);
		instance_create_layer(x, y-150, "Instances", obj_gesture_vertical);
	}
	if(gesture=="^"){
		audio_play_sound(sfx_up, 10, false);
		instance_create_layer(x, y-150, "Instances", obj_gesture_up);
	}
	if(gesture=="v"){
		audio_play_sound(sfx_down, 10, false);
		instance_create_layer(x, y-150, "Instances", obj_gesture_down);
	}
})