draw_self();

// Setup Text Alignment (Do this once)
draw_set_halign(fa_center); // Center horizontally
draw_set_valign(fa_bottom); // Bottom align (so (x,y) is the bottom of the text)

var _line_y = 1220;
var _text_y = _line_y - 20; // 20 pixels above the line
var _screen_center_x = 1080 / 2; // Middle of your 1080 width

if (global.state == "playing") {
    // --- PLAYING STATE (Smooth Pulse) ---
    var _wave = abs(sin(current_time / 1000 * pi)); 
    var _final_alpha = _wave * 0.5;

    draw_set_alpha(_final_alpha);
    draw_set_color(c_white);
    
    // 1. Draw Line
    draw_line_dashed(0, _line_y, 1080, _line_y, 20, 10);
    
    // 2. Draw Text (Pulsing with the line)
    draw_text_transformed(_screen_center_x, _text_y, "Draw patterns to destroy enemy",2,2,0);
    
    draw_set_alpha(1); 
    draw_set_color(c_white);
}
else if (global.state == "end") {
    // --- END STATE (Hard Flash) ---
    var _is_visible = (current_time div 250) % 2 == 0;

    if (_is_visible) {
        draw_set_alpha(0.5); 
        draw_set_color(c_red);
        
        // 1. Draw Line
        draw_line_dashed(0, _line_y, 1080, _line_y, 20, 10);
        
        // 2. Draw Text (Flashing Red)
        draw_text(_screen_center_x, _text_y, "GAME OVER - PATTERN FAILED");
        // Or keep the original text if you prefer:
        // draw_text(_screen_center_x, _text_y, "Draw patterns to destroy enemy");
        
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

// Reset alignment to defaults (good practice)
draw_set_halign(fa_left);
draw_set_valign(fa_top);