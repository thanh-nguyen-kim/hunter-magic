if (global.game_over == true) exit;
y+=global.enemy_speed
if (y > room_height-720) {
    global.game_over = true; // TRIGGER THE LOSS
}
var _cam = view_camera[0];
var _cx = camera_get_view_x(_cam);
var _cy = camera_get_view_y(_cam);
var _cw = camera_get_view_width(_cam);
var _ch = camera_get_view_height(_cam);

// Check if I am inside the box?
// point_in_rectangle checks if (x,y) is inside the view
if (point_in_rectangle(x, y, _cx, _cy, _cx + _cw, _cy + _ch)) {
    
    if (on_screen == false) {
        on_screen = true;
    }
}