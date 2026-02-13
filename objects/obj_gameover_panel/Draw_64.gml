// Event: Draw GUI

// 1. Get Screen Center
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2-200;

// 2. Draw Dark Overlay (Keep this, it looks good!)
draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);
draw_set_color(c_white); // Reset color for sprites

// 3. Draw the Panel Background Sprite
// We draw it exactly in the center
draw_sprite(FailPanel, 0, _cx, _cy);

// 4. Calculate Button Position
// Let's place the button 50 pixels below the center of the panel
var _btn_x = _cx;
var _btn_y = _cy + 200;

// 5. Button Logic (Hover & Click)
// We use the sprite's own width to calculate the hitbox automatically!
var _half_w = sprite_get_width(ReviveBtn) / 2;
var _half_h = sprite_get_height(ReviveBtn) / 2;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Check if mouse is inside the button sprite area
var _hover = point_in_rectangle(_mx, _my, _btn_x - _half_w, _btn_y - _half_h, _btn_x + _half_w, _btn_y + _half_h);

var _frame = 0; // Default frame (Normal)

if (_hover) {
    
	if (mouse_check_button_pressed(mb_left)) {

// 1. Reset Game State manually
global._score = 0;
global.combo = 0;
	    room_restart();
}
}
// 6. Draw the Button
// If you only have 1 frame, change _frame to 0
draw_sprite(ReviveBtn, _frame, _btn_x, _btn_y);
// 7. Draw the Text ON TOP
draw_set_halign(fa_center); // Horizontal Center
draw_set_valign(fa_middle); // Vertical Center
draw_set_color(c_black);    // Change color to contrast with your button sprite

draw_text_transformed(_btn_x, _btn_y, "RETRY", 2, 2, 0);

// 7. Draw Text (Title and Scores)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- A. Draw "GAME OVER" Title (Moved UP) ---
// Let's move this to _cy - 100 (Top of the panel)
draw_set_color(c_red); // Make it stand out
draw_text_transformed(_cx, _cy+50, "GAME OVER", 3, 3, 0);

// --- B. Draw Current Score (Center) ---
draw_set_color(c_white); // Use white or yellow for the score
// Draw the label
draw_text_transformed(_cx, _cy + 80, "SCORE", 1.5, 1.5, 0);
// Draw the actual number (slightly below the label)
draw_text_transformed(_cx, _cy + 110, string(global._score), 2.5, 2.5, 0);

// --- C. (Optional) Draw High Score ---
// If you want to show the best score ever
if (global._score > global._highscore) {
	global._highscore = global._score;
	// 1. Open the "prefs" file (GameMaker creates it if it doesn't exist)
ini_open("save_data.ini");

// 2. Write the value
// Arguments: "Section", "Key", Value
// Unity: PlayerPrefs.SetInt("highscore", global.score);
ini_write_real("Player", "highscore", global._highscore);

// 3. Close and Save to disk (Crucial! Unity does this on Quit, GM needs it explicit)
ini_close();
}
draw_set_color(c_yellow);
draw_text_transformed(_cx, _cy + 140, "BEST: " + string(global._highscore), 1.2, 1.2, 0);

// --- D. Reset Draw Settings ---
// Always reset color/alpha to default to avoid affecting other objects
draw_set_color(c_white);
draw_set_alpha(1);