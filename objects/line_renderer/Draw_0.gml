// Event: Draw

draw_self(); // Optional

// Set visual settings
draw_set_color(c_white);
draw_set_alpha(1);

var _len = array_length(mouse_trail);

// We need at least 2 points to draw a line
if (_len > 1) {
    // Loop through the array
    for (var i = 0; i < _len - 1; i++) {
        var _point_a = mouse_trail[i];
        var _point_b = mouse_trail[i + 1];
        
        // Draw segment connecting this point to the next one
        draw_line_width(_point_a.x, _point_a.y, _point_b.x, _point_b.y, 12);
    }
}

draw_set_color(c_white); // Reset