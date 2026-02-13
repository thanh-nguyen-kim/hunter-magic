// Event: Step

// 1. Start Drawing (Click)
if (mouse_check_button_pressed(mb_left)) {
	is_drawing = true;
	mouse_trail = []; // Clear old line
}

// 2. Record Points (While Holding)
if (mouse_check_button(mb_left)) {
	var _len = array_length(mouse_trail);
	var _record = true;
    
	if (_len > 0) {
	    var _last_point = mouse_trail[_len - 1];
	    // Only record if moved
	    if (_last_point.x == mouse_x && _last_point.y == mouse_y) {
	        _record = false;
	    }
	}
    
	if (_record) {
	    array_push(mouse_trail, { x: mouse_x, y: mouse_y });
	}
}

// 3. Stop Drawing & RECOGNIZE (Release)
if (mouse_check_button_released(mb_left)) {
	is_drawing = false;
    
	// Only attempt recognition if we actually drew something
	if (array_length(mouse_trail) > 5) {
        
	    // --- STEP A: Convert mouse_trail to GestureData ---
	    // The recognizer needs a specific data structure, not just an array.
        
	    var _inputData = new GestureData(); // Create the container
	    var _inputLine = new GestureLine(); // Create the stroke
        
	    // Convert your simple {x,y} structs into Vector2 structs
	    for (var i = 0; i < array_length(mouse_trail); i++) {
	        var _pt = mouse_trail[i];
	        array_push(_inputLine.points, new Vector2(_pt.x, _pt.y));
	    }
        
	    // Add the line to the data
	    array_push(_inputData.lines, _inputLine);
        
	    // --- STEP B: Run Recognition ---
	    var result = global.myRecognizer.Recognize(_inputData);

	    // --- STEP C: Check Results ---
	    var _finalScore = result._score.get_final_score();
        
	    //show_debug_message("Score: " + string(_finalScore) + " | Symbol: " + string(result.gesture.id));

	    if (_finalScore > 0.7) {
	        var symbol = result.gesture.id;
            
	        if (symbol == "-") {
				if(_finalScore>0.92)
				broadcast("gesture_detected","-");
	        }
	        else if (symbol == "v") {
	            broadcast("gesture_detected","v");
	        }
			else if(symbol == "|"){
			if(_finalScore>0.92)
			broadcast("gesture_detected","|");
			}
			else if(symbol == "^"){
				broadcast("gesture_detected","^");
			}
	    }
	}
    
	// Optional: Clear trail immediately, or keep it to fade out
	    mouse_trail = []; 
}