// Event: Create

// 1.0 is 100% size. 0.5 is 50% size.
image_xscale = 0.4; 
image_yscale = 0.4;
current_pattern=0;
on_screen=false;
receiver = new Receiver();
receiver.add("gesture_detected",function(gesture){
	if(!on_screen)return;
	//do the gesture logic here
	if(gesture==patterns_list[current_pattern].id){
	instance_destroy(pattern_renderers[current_pattern]);
	current_pattern++;
	var _count=array_length(pattern_renderers);
	for(var i=0;i<_count-current_pattern;i++)
	{
		var pattern=pattern_renderers[current_pattern+i];
		var delta_x=20+ i*40-(_count-current_pattern)*20;
	var delta_y=-60;
	with (pattern) {
	owner = other.id; // 'other' refers to the Parent (me)
	offset_x = delta_x;     // Relative distance from parent
	offset_y = delta_y;
}
	}
	//destroy current pattern
	//rearrage alive pattern
	broadcast("pattern_matched",0);
	}
	if(current_pattern>=array_length(patterns_list))
	instance_destroy();
})

// 1. Calculate how many 30-second intervals have passed
// current_time is in milliseconds. 30 seconds = 30,000 ms.
// (0-29s = 0), (30-59s = 1), (60-89s = 2), etc.
var _intervals_passed = current_time div 30000;

// 2. Base patterns is 1, add the intervals
var _calculated_patterns = 1 + _intervals_passed;

// 3. Cap the maximum at 4
// min() returns the smaller of the two numbers.
// If _calculated is 5, min(5, 4) returns 4.
var _max_patterns = min(_calculated_patterns, 4);

// 1. Determine size (Random number between 1 and 4 inclusive)
var _count = irandom_range(1, _max_patterns);

// 2. Create the array
// "patterns_list" is the instance variable on the enemy that stores its assigned patterns
patterns_list = array_create(_count);

//store drawed patterns
pattern_renderers = array_create(_count);

// 3. Loop to assign random patterns
for (var i = 0; i < _count; i++) {
    
	// Get the total number of available patterns from your global list
	// Assuming 'global.AllPatterns' contains your defined gestures ("-", "|", "v", etc.)
	var _total_patterns = array_length(global.myRecognizer.patterns);
    
	// Pick a random index. 
	// C# Random.Range(1, Length) skips index 0. If that was intentional:
	var _rnd_index = irandom_range(0, _total_patterns - 1);
    
	// OR if you want to include index 0 (all patterns):
	// var _rnd_index = irandom(_total_patterns - 1);

	// Assign it
	patterns_list[i] = global.myRecognizer.patterns[_rnd_index];
	
	var patternToDraw=obj_sprite_down;
	if(patterns_list[i].id=="^") patternToDraw=obj_sprite_up;
	if(patterns_list[i].id=="-") patternToDraw=obj_sprite_horizontal;
	if(patterns_list[i].id=="|") patternToDraw=obj_sprite_vertical;
	var delta_x=20+ i*40-_count*20;
	var delta_y=-60;
	var pattern=instance_create_layer(x+delta_x,y+delta_y,"Instances",patternToDraw);
	// 2. Set up the link
with (pattern) {
	owner = other.id; // 'other' refers to the Parent (me)
	offset_x = delta_x;     // Relative distance from parent
	offset_y = delta_y;
}
	pattern_renderers[i]=pattern;
}

