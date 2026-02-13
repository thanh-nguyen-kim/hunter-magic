draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_red);

// 2. Draw the text at position (20, 20)
draw_text_transformed(540, 40,string(global._score),3,3,0);

if (global.combo > 1) {
    var _x = 0;
    var _y = 40;
    var _width = 200;
    var _height = 10;

    // 1. Draw Combo Text
    draw_set_color(c_yellow);
    draw_text_transformed(_x+_width/2, _y, "COMBO +" + string(global.combo),2,2,0);
    
    // 2. Draw Timer Bar (Shrinking)
    var _fill_percent = global.combo_timer / global.combo_max_time;
    
    // Draw Background (Black)
    draw_set_color(c_black);
    draw_rectangle(_x+_width/6, _y + 40, _x+_width/6 + _width, _y + 40 + _height, false);
    
    // Draw Fill (Orange)
    draw_set_color(c_orange);
    draw_rectangle(_x+_width/6, _y + 40, _x+_width/6 + (_width * _fill_percent), _y + 40 + _height, false);
}